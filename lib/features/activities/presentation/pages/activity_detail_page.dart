import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../progress/presentation/viewmodel/progress_viewmodel.dart';

const _titleToId = {
  'Rainbow Paper Craft': 1,
  'Shape Sorting Game': 2,
  'Finger Painting': 3,
  'Story Building': 4,
  'Number Puzzles': 5,
  'Nature Walk': 6,
};

class ActivityDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String emoji;
  final String duration;
  final String category;

  const ActivityDetailPage({
    super.key,
    required this.title,
    required this.emoji,
    required this.duration,
    required this.category,
  });

  @override
  ConsumerState<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends ConsumerState<ActivityDetailPage> {
  int _currentStep = 0;
  bool _gyroDebounce = false;
  StreamSubscription<GyroscopeEvent>? _gyroSub;

  bool _isPaused = false;
  StreamSubscription<dynamic>? _proxSub;
  Timer? _proxDebounceTimer;

  int get _activityId => _titleToId[widget.title] ?? widget.title.hashCode.abs() % 1000000;

  Map<String, dynamic> get _activityData {
    final Map<String, Map<String, dynamic>> data = {
      'Rainbow Paper Craft': {
        'description': 'A colourful craft activity where children create beautiful rainbow artwork using paper strips. This boosts fine motor skills, colour recognition, and creativity.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Recognise and name all rainbow colours',
          'Develop fine motor skills through cutting and gluing',
          'Understand colour sequencing and patterns',
          'Express creativity through art-making',
        ],
        'materials': ['📄 Coloured paper strips', '✂️ Child-safe scissors', '🧴 Glue stick', '✏️ Pencil'],
        'steps': [
          'Cut coloured paper into strips of equal size',
          'Arrange strips in rainbow colour order (red, orange, yellow, green, blue, purple)',
          'Glue each strip onto white paper in a curved shape',
          'Add cotton wool clouds at the ends',
          'Let dry and display your rainbow!',
        ],
      },
      'Shape Sorting Game': {
        'description': 'An interactive game where children match and sort shapes by colour and size. Develops logical thinking, spatial awareness, and problem-solving skills.',
        'ageGroup': '2-5 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Identify basic shapes: circle, square, triangle',
          'Sort objects by colour and size',
          'Develop spatial reasoning and problem-solving',
          'Build hand-eye coordination through matching',
        ],
        'materials': ['🔷 Shape cutouts (circle, square, triangle)', '🎨 Coloured markers', '📦 Sorting box with holes'],
        'steps': [
          'Lay out all shape cutouts on the table',
          'Ask your child to identify each shape by name',
          'Sort shapes by colour first, then by size',
          'Try matching shapes to the correct holes in the box',
          'Celebrate each correct match with encouragement!',
        ],
      },
      'Finger Painting': {
        'description': 'A sensory art activity using fingers as paintbrushes. Encourages self-expression, sensory exploration, and develops hand-eye coordination.',
        'ageGroup': '2-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Explore colour mixing through sensory play',
          'Develop hand-eye coordination and grip strength',
          'Express emotions and ideas through art',
          'Build sensory processing and tactile awareness',
        ],
        'materials': ['🎨 Non-toxic finger paint', '📄 Large white paper', '🧴 Baby wipes for cleanup', '👕 Old shirt/apron'],
        'steps': [
          'Cover the table with newspaper and put on an apron',
          'Squeeze small amounts of different paint colours onto a palette',
          'Dip fingers into paint and press onto paper',
          'Try making handprints, swirls, and dots',
          'Let the painting dry completely before displaying',
        ],
      },
      'Story Building': {
        'description': 'A creative storytelling activity where children build their own stories using picture cards. Develops language skills, imagination, and narrative thinking.',
        'ageGroup': '4-7 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Build vocabulary and oral language skills',
          'Understand story structure: beginning, middle, end',
          'Develop imagination and creative thinking',
          'Practise sequencing and narrative skills',
        ],
        'materials': ['🃏 Picture story cards', '📖 Blank story book', '🖍️ Crayons', '⭐ Sticker rewards'],
        'steps': [
          'Spread picture cards face down on the table',
          'Child picks 3 random cards',
          'Ask them: "Can you make a story with these pictures?"',
          'Help them draw their story in the blank book',
          'Read the story back together and celebrate!',
        ],
      },
      'Number Puzzles': {
        'description': 'Fun number matching and counting puzzles that make maths enjoyable. Builds number recognition, counting skills, and basic arithmetic.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Recognise and write numbers 1–10',
          'Count objects accurately and match quantities',
          'Understand one-to-one correspondence',
          'Build early numeracy and mathematical thinking',
        ],
        'materials': ['🔢 Number puzzle cards (1-10)', '🟡 Counting tokens/beads', '📝 Worksheet', '✏️ Pencil'],
        'steps': [
          'Lay out number cards 1-10 in order',
          'Count out the matching number of tokens for each card',
          'Mix up the cards and ask child to reorder them',
          'Try the worksheet — trace numbers and draw matching dots',
          'Award a sticker for every completed puzzle!',
        ],
      },
      'Nature Walk': {
        'description': 'An outdoor exploration activity where children discover the natural world. Encourages curiosity, observation skills, and appreciation for nature.',
        'ageGroup': '3-8 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Identify common plants, insects, and natural objects',
          'Develop observation and investigation skills',
          'Build scientific vocabulary and curiosity',
          'Foster appreciation for the natural environment',
        ],
        'materials': ['🎒 Small backpack', '🔍 Magnifying glass', '📋 Nature checklist', '🫙 Collection jar'],
        'steps': [
          'Print or draw a nature checklist (leaf, flower, rock, bug, bird)',
          'Head to a park or garden with your child',
          'Use the magnifying glass to examine small things closely',
          'Collect safe items like leaves, pebbles, and seed pods',
          'Come home and identify everything you collected!',
        ],
      },

      // ── Craft Corner ──────────────────────────────────────────
      'Paper Plate Animals': {
        'description': 'Children transform plain paper plates into their favourite animals using craft materials. A hands-on activity that builds creativity, fine motor skills, and introduces animal knowledge.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Learn about different animals and their features',
          'Develop cutting and sticking fine motor skills',
          'Express creativity through character design',
          'Follow multi-step craft instructions independently',
        ],
        'materials': ['🍽️ Paper plates', '🎨 Poster paint', '✂️ Child-safe scissors', '🧴 Glue stick', '🖍️ Markers'],
        'steps': [
          'Choose an animal to make (lion, owl, frog, or butterfly!)',
          'Paint the paper plate in the animal\'s base colour and let dry',
          'Cut out ears, wings, or other features from spare card',
          'Glue features onto the plate to build the face or body',
          'Use markers to add final details — then hang it on the wall!',
        ],
      },
      'Collage Making': {
        'description': 'Children cut and stick different materials to create a themed collage. Develops fine motor skills, creativity, and an understanding of texture and visual composition.',
        'ageGroup': '3-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Explore texture, colour, and composition through art',
          'Develop cutting and sticking fine motor skills',
          'Build creative decision-making and self-expression',
          'Learn how different materials look and feel together',
        ],
        'materials': ['📰 Old magazines or newspapers', '✂️ Child-safe scissors', '🧴 Glue', '📄 Card or thick paper', '🧵 Yarn or fabric scraps'],
        'steps': [
          'Choose a theme: animals, nature, space, or your favourite things',
          'Cut out images, shapes, and colours from magazines',
          'Arrange all pieces on your card before gluing — no glue yet!',
          'When happy with the layout, glue everything in place',
          'Add yarn, fabric, or drawn details to make it unique',
        ],
      },
      'Clay Modelling': {
        'description': 'Children use air-dry clay to sculpt 3D shapes and figures. Develops spatial thinking, fine motor strength, patience, and early sculpting techniques.',
        'ageGroup': '4-8 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Build fine motor strength through kneading and shaping',
          'Develop spatial reasoning and 3D thinking',
          'Follow a multi-step creation process with patience',
          'Explore sculpting techniques: rolling, pinching, smoothing',
        ],
        'materials': ['🏺 Air-dry clay', '🪣 Small bowl of water', '🔪 Plastic sculpting tool', '🪵 Wooden board', '🖌️ Paint for after drying'],
        'steps': [
          'Warm the clay by kneading it in your hands for 2 minutes',
          'Decide what to make: a fruit, animal, bowl, or small figurine',
          'Use rolling, pinching, and smoothing to shape your creation',
          'Dip your finger in water to smooth any cracks that appear',
          'Leave to air-dry for 24 hours, then paint and display!',
        ],
      },
      'Origami Shapes': {
        'description': 'Children fold paper to create animals and objects using the traditional Japanese art of origami. Builds spatial reasoning, concentration, and the skill of following sequential instructions.',
        'ageGroup': '5-8 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Follow multi-step sequential instructions carefully',
          'Develop spatial reasoning and geometry awareness',
          'Build patience and concentration through precise folding',
          'Learn about Japanese art and cultural traditions',
        ],
        'materials': ['📄 Square origami paper (or cut a regular sheet into a square)', '📏 Ruler for crisp folds', '📋 Step-by-step instruction sheet'],
        'steps': [
          'Start with the simplest fold — a fortune teller or paper boat',
          'Place paper on a flat surface and make the first fold precisely',
          'Follow each step slowly, pressing each fold flat with your finger',
          'If you make a mistake, carefully unfold and try again — that\'s okay!',
          'Display finished pieces and try a slightly harder design next time',
        ],
      },
      'Puppet Making': {
        'description': 'Children create hand or finger puppets from socks, paper bags, or felt. Encourages creativity, expressive communication, and imaginative storytelling through play.',
        'ageGroup': '3-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Develop creativity and character design thinking',
          'Build fine motor skills through gluing and cutting',
          'Encourage expressive communication and storytelling',
          'Use imagination to bring characters to life through play',
        ],
        'materials': ['🧦 Old sock or paper bag', '🖍️ Markers', '🧵 Yarn for hair', '🎭 Googly eyes', '🧴 Glue'],
        'steps': [
          'Choose your puppet base: an old sock, paper bag, or cut card',
          'Decide on a character — a person, animal, monster, or superhero!',
          'Draw or glue on the face: eyes, nose, and a mouth',
          'Add yarn for hair, card ears, or a little fabric bow',
          'Slide your hand in and give your puppet a voice — put on a show!',
        ],
      },

      // ── Letters & Phonics ─────────────────────────────────────
      'Letter Tracing': {
        'description': 'Children trace upper and lower case letters to build handwriting muscle memory. Combines tactile learning with visual recognition to reinforce every letter of the alphabet.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Recognise and name all 26 letters of the alphabet',
          'Build correct pencil grip and letter formation habits',
          'Connect letter shapes to their sounds (phonics)',
          'Develop hand-eye coordination and pre-writing skills',
        ],
        'materials': ['📝 Letter tracing worksheet', '✏️ HB pencil', '🖍️ Crayons for colouring pictures', '🔡 Alphabet chart for reference'],
        'steps': [
          'Place the worksheet on a flat surface and sit up straight',
          'Trace each letter slowly, following the directional arrows',
          'Say the letter name and its sound out loud as you trace it',
          'Colour the picture next to the letter (A is for Apple! 🍎)',
          'Cover the example and try writing the letter from memory',
        ],
      },
      'Rhyme Time': {
        'description': 'A playful phonics activity where children identify and generate rhyming word pairs. Builds phonological awareness — the essential foundation for learning to read.',
        'ageGroup': '3-5 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Recognise and generate rhyming word pairs (cat/hat, dog/log)',
          'Develop phonological awareness and an ear for language',
          'Build vocabulary through sound-based word play',
          'Gain confidence in speaking and listening activities',
        ],
        'materials': ['🎵 Rhyme picture cards or a printed word-pair list', '📖 A favourite rhyming picture book', '🎲 Optional: rhyme matching dice game'],
        'steps': [
          'Read a rhyming picture book together (e.g. Dr. Seuss, Roald Dahl poems)',
          'Pause at rhyming words and let your child finish the rhyme',
          'Play "Does this rhyme?" — say two words, they answer yes or no',
          'Challenge: "Can you think of a word that rhymes with cat?"',
          'Clap out syllables and notice how rhyming pairs end the same way',
        ],
      },
      'Alphabet Puzzle': {
        'description': 'Children match letter tiles to corresponding pictures in a fun puzzle format. Reinforces letter-sound associations, vocabulary, and fine motor skills through hands-on play.',
        'ageGroup': '3-5 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Match letters to corresponding picture sounds (A → Apple)',
          'Strengthen recognition of all 26 letters',
          'Develop fine motor skills through puzzle manipulation',
          'Build vocabulary by naming each picture aloud',
        ],
        'materials': ['🔤 Alphabet puzzle (letter-to-picture matching set)', '📋 Answer reference sheet', '✏️ Optional letter writing worksheet'],
        'steps': [
          'Spread all puzzle pieces face up across the table',
          'Pick up a letter tile and say its name and sound aloud clearly',
          'Find the picture card that begins with that same sound',
          'Click or place the piece in the correct matching position',
          'Complete the full alphabet and check answers with the reference sheet',
        ],
      },
      'Word Building': {
        'description': 'Children use letter tiles to build 3-letter CVC words (consonant-vowel-consonant). Develops phonics decoding skills, spelling awareness, and early reading confidence.',
        'ageGroup': '4-6 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Blend consonant-vowel-consonant sounds to build simple words',
          'Develop phonics decoding and encoding skills',
          'Recognise short vowel sounds and common sight words',
          'Build early reading and spelling confidence',
        ],
        'materials': ['📝 Magnetic or cardboard letter tiles', '🖼️ Picture prompt cards', '📋 Word list (cat, dog, sit, hop, mug)', '✏️ Whiteboard or paper'],
        'steps': [
          'Choose a picture card (e.g. a cat 🐱)',
          'Say the word slowly, stretching out each sound: c-a-t',
          'Find the letter tile for each sound you hear',
          'Place the tiles in order left to right to build the word',
          'Write the word on the whiteboard and read it back to check',
        ],
      },
      'Sound Sorting': {
        'description': 'Children sort picture cards into groups based on their starting sound. A key phonics activity that strengthens the connection between letters and the sounds they represent.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Identify and isolate the initial sound in spoken words',
          'Sort words by their beginning, middle, or end sounds',
          'Strengthen phonological awareness and listening skills',
          'Build confidence with letter-sound correspondences',
        ],
        'materials': ['👂 Sound sorting picture cards', '🗂️ 3 labelled sorting boxes or trays', '📋 Sound reference cards (e.g. S, M, T)'],
        'steps': [
          'Set out 3 sorting boxes, each labelled with a different letter',
          'Shuffle the picture cards and place them face down in a pile',
          'Pick a card, say the picture name out loud clearly and slowly',
          'Decide the starting sound — which letter box does it belong in?',
          'Place the card in the correct box and continue until all are sorted',
        ],
      },
      'Silly Sentences': {
        'description': 'Children build imaginative, grammatically silly sentences using word cards. Develops language structure awareness, vocabulary, and a joyful relationship with language.',
        'ageGroup': '4-7 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Understand basic sentence structure: subject, verb, object',
          'Build vocabulary and experiment with descriptive words',
          'Recognise that sentences need to follow grammatical rules',
          'Develop a playful and joyful relationship with language',
        ],
        'materials': ['😄 Word cards (nouns, verbs, adjectives in separate piles)', '📋 Sentence frame strip ("The ___ ___ the ___")', '✏️ Pencil for writing favourite sentences'],
        'steps': [
          'Set up three piles of cards: Who? (nouns), Did what? (verbs), With what? (objects)',
          'Draw one card randomly from each pile',
          'Arrange them into a sentence: "The elephant danced on a banana!"',
          'Read the sentence out loud — the sillier and funnier the better!',
          'Write your favourite silly sentence down and draw a picture of it',
        ],
      },

      // ── Story Time ────────────────────────────────────────────
      'Character Drawing': {
        'description': 'Children draw their favourite story character from a book they have enjoyed. Develops visual interpretation, fine motor skills, and deepens engagement with literature.',
        'ageGroup': '4-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Recall and describe key characters from a story',
          'Develop drawing skills and pencil control',
          'Connect visual representation to narrative comprehension',
          'Build confidence in artistic self-expression',
        ],
        'materials': ['✏️ Pencil and eraser', '📄 Blank white paper', '🖍️ Coloured pencils or markers', '📖 Favourite storybook for reference'],
        'steps': [
          'Read or revisit a favourite book together',
          'Choose one character you want to draw',
          'Look at the book illustrations for clues about what they look like',
          'Sketch the character lightly in pencil first — no detail yet',
          'Add colour and write the character\'s name underneath your drawing',
        ],
      },
      'Story Sequencing': {
        'description': 'Children arrange picture cards to retell a story in the correct order. Builds narrative comprehension, logical sequencing, and oral storytelling confidence.',
        'ageGroup': '4-7 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Understand and retell a story in sequential order',
          'Use time-related language: first, next, then, finally',
          'Develop comprehension and active listening skills',
          'Build confidence in oral storytelling and narration',
        ],
        'materials': ['🃏 Story sequence picture cards (4-6 images)', '📋 Numbered mat or sequencing strip', '✏️ Paper for writing captions'],
        'steps': [
          'Shuffle the picture cards and lay them out in a mixed-up order',
          'Look at each card carefully — what is happening in each one?',
          'Arrange the cards in the correct order from beginning to end',
          'Point to each card and tell the full story out loud',
          'Write or dictate one sentence for each card to caption it',
        ],
      },
      'Puppet Theatre': {
        'description': 'Children use hand or finger puppets to perform a short play. Develops public speaking confidence, creativity, narrative structure, and social communication skills.',
        'ageGroup': '4-8 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Develop oral language and expressive communication',
          'Understand simple narrative structure in performance',
          'Build confidence in speaking aloud to an audience',
          'Encourage creative role-play and imaginative thinking',
        ],
        'materials': ['🎭 Hand or finger puppets', '📦 Cardboard box to use as a theatre stage', '🖍️ Markers to decorate the stage with curtains', '📖 A simple story to adapt'],
        'steps': [
          'Cut a rectangular opening in a cardboard box for the stage window',
          'Decorate the box as a theatre — draw velvet curtains on the sides!',
          'Choose a simple fairy tale or make up a brand new story',
          'Practise the performance — give every puppet a different voice',
          'Invite family members to watch the show — take a bow at the end! 🎉',
        ],
      },
      'Book Review': {
        'description': 'After reading a book, children create a simple star rating and written review. Develops critical thinking, opinion expression, and reading comprehension skills.',
        'ageGroup': '5-8 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Summarise a story including key events and characters',
          'Form and express a personal opinion about a book',
          'Use evaluative language: enjoyed, preferred, would recommend',
          'Develop early literary analysis and comprehension skills',
        ],
        'materials': ['⭐ Book review template', '✏️ Pencil', '📖 A recently read book', '🖍️ Crayons for drawing a favourite scene'],
        'steps': [
          'Read the book or recap the story if recently finished',
          'Fill in the template: title, author, and main characters',
          'Write 2-3 sentences — what happened? what did you enjoy?',
          'Colour in a star rating from 1 to 5 stars',
          'Draw your absolute favourite scene from the book at the bottom',
        ],
      },
      'Make a Comic': {
        'description': 'Children create their own short comic strip with panels, speech bubbles, and characters. Develops narrative sequencing, dialogue writing, and visual storytelling skills.',
        'ageGroup': '5-9 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Plan and organise a narrative into sequential comic panels',
          'Write dialogue using speech bubbles accurately',
          'Develop character design and setting illustration skills',
          'Build early writing stamina and creative composition',
        ],
        'materials': ['💬 Pre-drawn comic template (4-6 empty panels)', '✏️ Pencil and eraser', '🖍️ Coloured markers for inking', '📋 Story idea prompt card'],
        'steps': [
          'Plan your story: Who is the hero? What is the problem? How is it solved?',
          'Sketch each scene lightly in pencil in the correct panel',
          'Add speech bubbles with exactly what each character says',
          'Ink over pencil lines with marker and carefully erase the pencil',
          'Colour all panels and write your comic\'s title at the top — done! 🎉',
        ],
      },

      // ── Numbers & Logic ───────────────────────────────────────
      'Counting Bears': {
        'description': 'Children use coloured counting bears to practise number recognition, sorting, and one-to-one counting. A tactile, hands-on maths activity perfect for early learners.',
        'ageGroup': '2-5 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Count objects accurately up to 10 using one-to-one correspondence',
          'Sort objects by colour and size',
          'Understand the concepts of more, less, and equal',
          'Build early number sense and mathematical language',
        ],
        'materials': ['🐻 Coloured counting bears (or any small objects)', '🗂️ Sorting cups or a muffin tin', '📋 Number cards 1–10', '🟡 Counting mat'],
        'steps': [
          'Set out 10 cups labelled with numbers 1–10',
          'Pick up a number card and say the number out loud',
          'Count out the exact matching number of bears into that cup',
          'Sort remaining bears by colour into separate cups',
          'Ask: Which colour has the most bears? Which has the fewest?',
        ],
      },
      'Shape Patterns': {
        'description': 'Children use shape cutouts to identify, extend, and create repeating patterns. Builds foundational algebraic thinking, logical reasoning, and visual discrimination skills.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Identify and describe repeating patterns (AB, AAB, ABC)',
          'Extend and predict what comes next in a pattern sequence',
          'Create original patterns using shapes and colours',
          'Develop logical reasoning and early algebraic thinking',
        ],
        'materials': ['🔷 Shape cutouts in 2–3 colours (circles, squares, triangles)', '📋 Pattern strip template', '🖍️ Coloured markers'],
        'steps': [
          'Lay out the first pattern: red circle, blue square, red circle, blue square...',
          'Ask your child: "What comes next?" — let them choose and place it',
          'Continue extending the pattern for 3 more repetitions',
          'Now ask them to create their very own repeating pattern',
          'Challenge: can you make a 3-shape pattern? (ABC, ABC, ABC)',
        ],
      },
      'Simple Addition': {
        'description': 'Children use physical counters to understand and solve simple addition equations. Develops number sense, counting-on strategies, and early arithmetic confidence.',
        'ageGroup': '4-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Understand addition as the combining of two groups',
          'Solve simple addition problems up to 10 using objects',
          'Develop counting-on strategies without physical objects',
          'Build confidence with number bonds and early maths',
        ],
        'materials': ['➕ Addition worksheet (equations up to 10)', '🟡 Counters or small toys for physical grouping', '📋 Number line (0–10)', '✏️ Pencil'],
        'steps': [
          'Start with a physical equation: put 3 counters on the left, 2 on the right',
          'Push all counters together and count: "How many altogether?"',
          'Write the equation on paper: 3 + 2 = 5',
          'Try several more combinations using counters as a check',
          'Use the number line on the worksheet to solve problems without counters',
        ],
      },
      'Memory Match': {
        'description': 'A classic pairs card game adapted for number facts or shapes. Develops working memory, concentration, number recognition, and turn-taking social skills.',
        'ageGroup': '3-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Develop working memory and visual recall skills',
          'Practise number or shape recognition in context',
          'Build concentration and patience during game play',
          'Learn fair turn-taking and friendly competition',
        ],
        'materials': ['🧠 Memory match card pairs (numbers, shapes, or pictures)', '🗂️ Clear flat playing surface'],
        'steps': [
          'Shuffle all cards thoroughly and lay them face down in a grid',
          'Player 1 turns over two cards — say out loud what each shows!',
          'If they match, keep the pair and take another turn straight away',
          'If they do not match, flip them face down and Player 2 goes',
          'The player with the most pairs when all cards are gone wins! 🏆',
        ],
      },
      'Time Telling': {
        'description': 'Children learn to read analogue and digital clocks, starting with o\'clock and half-past times. Builds real-world mathematical knowledge and daily routine awareness.',
        'ageGroup': '5-8 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Read o\'clock and half-past times on an analogue clock',
          'Understand that the short hand shows hours, long hand shows minutes',
          'Connect clock times to everyday daily routine events',
          'Build foundational understanding of time as a measurement',
        ],
        'materials': ['🕐 Toy analogue clock or printed clock face', '📋 "What time is it?" activity worksheet', '✏️ Pencil', '📱 Digital clock for comparison'],
        'steps': [
          'Show the clock face and explain: short hand = hours, long hand = minutes',
          'Set the clock to 3 o\'clock — ask: "What time does the clock show?"',
          'Ask your child to set the clock to 7 o\'clock themselves',
          'Introduce half-past: the long hand points straight down to the 6',
          'Connect to real life: "We eat breakfast at 8 o\'clock — can you show me?"',
        ],
      },

      // ── Thinking Skills ───────────────────────────────────────
      'Maze Runner': {
        'description': 'Children navigate pencil mazes of increasing difficulty. Develops visual tracking, spatial planning, fine motor control, and problem-solving persistence.',
        'ageGroup': '4-8 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Develop visual-spatial reasoning and route planning skills',
          'Build fine motor control through pencil-maze navigation',
          'Practise strategic thinking: planning a route ahead before acting',
          'Develop persistence and resilience when encountering dead ends',
        ],
        'materials': ['🌀 Printed maze worksheets (easy to hard difficulty levels)', '✏️ Pencil', '👀 Optional: finger tracing before attempting with pencil'],
        'steps': [
          'Start with the easiest maze — look at the whole maze carefully first!',
          'Trace the route with your finger before touching the paper with pencil',
          'Begin your pencil line at the entrance and move slowly and deliberately',
          'If you reach a dead end, back up to the last junction and try a different path',
          'Complete the maze and challenge yourself with the next harder level! 🌟',
        ],
      },
      'Pattern Copying': {
        'description': 'Children observe a pattern made with coloured blocks or drawn on a grid and recreate it exactly. Builds spatial memory, attention to detail, and visual-motor coordination.',
        'ageGroup': '3-6 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Replicate visual patterns using shapes and colours accurately',
          'Develop attention to detail and visual discrimination',
          'Build spatial memory and working memory capacity',
          'Strengthen visual-motor coordination through recreation tasks',
        ],
        'materials': ['🎨 Pattern reference cards or printed grid patterns', '🟦 Coloured blocks, cubes, or stickers', '📋 Blank grid for recreating the pattern'],
        'steps': [
          'Show the child a pattern card — study it carefully for 10 seconds',
          'Name the shapes and colours you can see from left to right',
          'Using your blocks or stickers, recreate the exact same pattern',
          'Check your copy by placing it directly next to the original',
          'Try again with a more complex pattern — more colours, more rows! 🎯',
        ],
      },
      'Block Building': {
        'description': 'Children follow visual blueprints to construct structures from building blocks. Develops spatial reasoning, engineering thinking, visual-motor coordination, and creative problem-solving.',
        'ageGroup': '3-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Follow visual instructions to build a 3D structure accurately',
          'Develop spatial reasoning and early engineering thinking',
          'Build fine motor control and hand-eye coordination',
          'Understand the concepts of balance, symmetry, and stability',
        ],
        'materials': ['🧱 Building blocks (Lego, Duplo, or wooden cubes)', '📋 Blueprint or photograph of a structure to copy', '📸 Camera to photograph the finished build'],
        'steps': [
          'Study the blueprint carefully: how many blocks? What colours? How many layers?',
          'Sort your blocks by colour and size before starting',
          'Begin building from the very bottom layer upward — base first!',
          'Compare your build to the blueprint after every layer',
          'Take a photo of your finished structure, then try designing your own! 🏗️',
        ],
      },
      'What Comes Next?': {
        'description': 'Children identify the missing element in a sequence of pictures, shapes, or numbers. Develops logical reasoning, pattern recognition, and predictive thinking skills.',
        'ageGroup': '4-7 yrs',
        'level': 'Intermediate',
        'learningOutcomes': [
          'Identify the rule that governs a given sequence',
          'Predict and apply the next element in a pattern',
          'Develop logical and analytical thinking skills',
          'Build confidence in mathematical and visual reasoning',
        ],
        'materials': ['❓ Sequence cards (shapes, numbers, or themed pictures)', '📋 Blank card for writing or drawing the missing element', '✏️ Pencil or crayons'],
        'steps': [
          'Lay out a sequence of 4 cards with one item deliberately missing',
          'Study the cards: what is changing from one card to the next?',
          'Identify the rule: getting bigger? alternating? rotating?',
          'Choose what the missing card should look like and create it',
          'Explain your reasoning out loud: "Because the rule is..."',
        ],
      },
      'Spot the Difference': {
        'description': 'Children compare two nearly identical pictures and circle the differences. Develops visual discrimination, concentration, perceptual thinking, and attention to detail.',
        'ageGroup': '4-8 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Develop visual discrimination and perceptual accuracy',
          'Build sustained concentration and attention to detail',
          'Practise systematic visual scanning strategies',
          'Strengthen fine motor skills through circling differences',
        ],
        'materials': ['🔍 Spot the difference worksheet (two near-identical pictures)', '✏️ Pencil or red pen to circle differences', '📋 Answer sheet to check at the end'],
        'steps': [
          'Place the two pictures side by side on a flat surface',
          'Start scanning from top-left to bottom-right in a systematic way',
          'When you spot a difference, circle it in BOTH pictures',
          'Try to find every difference before checking the answer sheet',
          'Count how many you found and try to beat your own record next time! 🔍',
        ],
      },

      // ── Science & Nature ──────────────────────────────────────
      'Leaf Printing': {
        'description': 'Children press painted leaves onto paper to create beautiful nature prints. Explores plant structure, symmetry, and colour mixing through hands-on science and art.',
        'ageGroup': '3-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Observe and describe the structure of leaves: veins, stem, and shape',
          'Understand that plants display natural patterns and symmetry',
          'Explore colour mixing by layering different leaf prints',
          'Develop fine motor control through leaf pressing and careful peeling',
        ],
        'materials': ['🍂 A variety of leaves (different shapes and sizes)', '🎨 Washable poster paints', '📄 White paper', '🖌️ Small paintbrush', '🗞️ Newspaper to protect the table'],
        'steps': [
          'Collect a variety of fresh leaves from the garden or park',
          'Lay a leaf vein-side up on a sheet of newspaper',
          'Paint one side of the leaf evenly with a brush — be generous!',
          'Press the painted side firmly face down onto white paper',
          'Peel the leaf back carefully and slowly to reveal your nature print! 🍂',
        ],
      },
      'Sink or Float': {
        'description': 'Children test whether everyday objects sink or float in water, making and checking predictions. Develops scientific thinking, hypothesis testing, and early understanding of buoyancy.',
        'ageGroup': '3-7 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Make and test predictions using scientific reasoning',
          'Understand the basic concepts of sinking and floating',
          'Record observations and results in a simple chart',
          'Develop curiosity and a systematic approach to investigation',
        ],
        'materials': ['🌊 Large plastic container or tub filled with water', '🔬 Assorted small objects (coin, cork, sponge, stone, leaf, pencil)', '📋 Prediction and results chart', '✏️ Pencil'],
        'steps': [
          'Fill the tub with water and gather 6–8 small household objects',
          'Create a prediction chart — draw each object and guess: sink or float?',
          'Hold each object over the water and ask: "What do you think will happen?"',
          'Gently drop the object into the water and observe the result',
          'Record whether your prediction was correct and discuss: why do some things float?',
        ],
      },
      'Bug Hunting': {
        'description': 'Children explore the garden or outdoor space looking for minibeasts and recording what they find. Builds scientific observation, biodiversity awareness, and a love of nature.',
        'ageGroup': '3-8 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Identify and name common garden minibeasts (worm, ladybird, ant, beetle)',
          'Develop scientific observation and recording skills',
          'Build respect for living creatures and their natural habitats',
          'Understand that insects are important parts of a wider ecosystem',
        ],
        'materials': ['🐛 Minibeast hunting checklist', '🔍 Magnifying glass', '🫙 Clear collection jar (with air holes poked in the lid)', '📋 Minibeast identification chart', '🖊️ Pencil'],
        'steps': [
          'Head outside with your bug hunting kit — garden or park both work great!',
          'Look carefully under rocks, logs, fallen leaves, and around flower beds',
          'Use the magnifying glass to get a really close look at what you find',
          'Tick it off the checklist and identify it using the picture chart',
          'Observe the creature for a few minutes then release it gently — never harm! 🌿',
        ],
      },
      'Mini Garden': {
        'description': 'Children plant seeds in a small pot and care for them over time. Develops responsibility, patience, scientific observation, and understanding of the plant life cycle.',
        'ageGroup': '3-8 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Understand the basic needs of plants: water, sunlight, and soil',
          'Develop patience and long-term responsibility through daily plant care',
          'Observe and record how plants grow and change over time',
          'Build scientific vocabulary: seed, germinate, roots, stem, leaf, flower',
        ],
        'materials': ['🌱 Easy-to-grow seeds (cress, sunflower, or broad bean)', '🪴 Small plant pot or recycled yoghurt pot', '🪣 Compost or potting soil', '💧 Small watering can', '📋 Plant growth diary'],
        'steps': [
          'Fill your pot three-quarters full with compost and gently firm it down',
          'Push 2–3 seeds about 1 centimetre deep into the soil',
          'Water gently until the soil feels damp but not waterlogged',
          'Place the pot on a sunny windowsill and check it every single day',
          'Record growth in your plant diary — measure the stem height each week! 📏',
        ],
      },
      'Cloud Watching': {
        'description': 'Children lie outside and observe clouds, identifying types and shapes while discovering the water cycle. Builds scientific curiosity, imaginative thinking, and descriptive vocabulary.',
        'ageGroup': '3-8 yrs',
        'level': 'Beginner',
        'learningOutcomes': [
          'Identify and describe different cloud types: cumulus, stratus, cirrus',
          'Develop observational vocabulary and detailed descriptive language',
          'Understand the basic water cycle: evaporation, cloud formation, rainfall',
          'Build a sense of wonder and connection with the natural world',
        ],
        'materials': ['☁️ Printable cloud identification chart', '📋 Cloud journal or notebook for sketching', '✏️ Pencil', '🔭 Optional binoculars for a closer look'],
        'steps': [
          'Find a safe outdoor spot and lie down on a blanket looking straight up',
          'Watch the clouds move for 2 minutes in complete silence first',
          'Use the identification chart: are these fluffy white cumulus clouds?',
          'Spot shapes and creatures hiding in the clouds: "That one looks like a dragon!" 🐉',
          'Sketch your favourite cloud in the journal and write what it reminds you of',
        ],
      },
    };

    return data[widget.title] ?? {
      'description': 'A fun and engaging activity designed to support your child\'s development.',
      'ageGroup': '3-6 yrs',
      'level': 'Beginner',
      'learningOutcomes': ['Have fun and learn something new!'],
      'materials': ['📄 Paper', '✏️ Pencil', '🎨 Colours'],
      'steps': ['Prepare your materials', 'Follow the instructions', 'Have fun!'],
    };
  }

  @override
  void initState() {
    super.initState();
    _startGyroscope();
    _startProximity();
  }

  void _startGyroscope() {
    _gyroSub = gyroscopeEventStream().listen((event) {
      if (_gyroDebounce) return;
      final steps = List<String>.from(_activityData['steps']);
      if (event.y > 2.5 && _currentStep < steps.length - 1) {
        _gyroDebounce = true;
        setState(() => _currentStep++);
        Future.delayed(const Duration(milliseconds: 700), () => _gyroDebounce = false);
      } else if (event.y < -2.5 && _currentStep > 0) {
        _gyroDebounce = true;
        setState(() => _currentStep--);
        Future.delayed(const Duration(milliseconds: 700), () => _gyroDebounce = false);
      }
    });
  }

  void _startProximity() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _proxSub = ProximitySensor.events.listen((event) {
        final isNear = (event != 0);
        _proxDebounceTimer?.cancel();
        _proxDebounceTimer = Timer(const Duration(milliseconds: 400), () {
          if (isNear != _isPaused && mounted) setState(() => _isPaused = isNear);
        });
      });
    });
  }

  Future<void> _markComplete() async {
    final isAlreadyDone = ref.read(progressViewModelProvider).completed
        .any((c) => c['activityId'] == _activityId);
    if (isAlreadyDone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already marked as complete!')),
      );
      return;
    }
    await ref.read(progressViewModelProvider.notifier).markComplete(
      activityId: _activityId,
      activityTitle: widget.title,
      category: widget.category,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity marked as complete! ✅')),
    );
  }

  Future<void> _toggleFavourite() async {
    final isFav = ref.read(progressViewModelProvider).favourites
        .any((f) => f['activityId'] == _activityId);
    if (isFav) {
      await ref.read(progressViewModelProvider.notifier).removeFavourite(_activityId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favourites')),
      );
    } else {
      await ref.read(progressViewModelProvider.notifier).addFavourite(
        activityId: _activityId,
        activityTitle: widget.title,
        category: widget.category,
        age: _activityData['ageGroup'] as String,
        image: widget.emoji,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favourites! ⭐')),
      );
    }
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _proxSub?.cancel();
    _proxDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progressState = ref.watch(progressViewModelProvider);
    final isCompleted = progressState.completed.any((c) => c['activityId'] == _activityId);
    final isFavourite = progressState.favourites.any((f) => f['activityId'] == _activityId);

    final data = _activityData;
    final outcomes = List<String>.from(data['learningOutcomes']);
    final materials = List<String>.from(data['materials']);
    final steps = List<String>.from(data['steps']);
    final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Stack(
      children: [
        Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text(widget.category, style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Text(widget.emoji, style: const TextStyle(fontSize: 36)),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem(context, Icons.timer, widget.duration, 'Duration'),
                            _statItem(context, Icons.star, data['level'], 'Level'),
                            _statItem(context, Icons.people, data['ageGroup'], 'Age Group'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _sectionTitle('About this Activity'),
                      const SizedBox(height: 8),
                      Text(data['description'], style: TextStyle(color: subText, height: 1.6)),

                      const SizedBox(height: 20),
                      _sectionTitle('Learning Outcomes'),
                      const SizedBox(height: 8),
                      ...outcomes.map((o) => _outcomeItem(o, subText)),

                      const SizedBox(height: 20),
                      _sectionTitle('Materials Needed'),
                      const SizedBox(height: 8),
                      ...materials.map((m) => _materialItem(m)),

                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _sectionTitle('Steps')),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8EC5FC).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.screen_rotation, size: 14, color: Color(0xFF8EC5FC)),
                                const SizedBox(width: 4),
                                Text(
                                  '${_currentStep + 1}/${steps.length}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF8EC5FC), fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          '← Tilt phone left/right to navigate steps →',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black38, fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...steps.asMap().entries.map(
                        (e) => _stepItem(context, e.key + 1, e.value, isActive: e.key == _currentStep, isDark: isDark),
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: _actionButton(
                              icon: isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                              label: isCompleted ? 'Completed!' : 'Mark Complete',
                              gradient: isCompleted
                                  ? const [Color(0xFF43E97B), Color(0xFF38F9D7)]
                                  : const [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
                              onTap: _markComplete,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _actionButton(
                              icon: isFavourite ? Icons.star : Icons.star_border,
                              label: isFavourite ? 'Favourited!' : 'Add Favourite',
                              gradient: isFavourite
                                  ? const [Color(0xFFFFD700), Color(0xFFFFB347)]
                                  : const [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
                              onTap: _toggleFavourite,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_isPaused)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.75),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pause_circle_filled, size: 72, color: Colors.white),
                  SizedBox(height: 16),
                  Text('Activity Paused', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Lift phone face-up to resume', style: TextStyle(color: Colors.white70, fontSize: 15)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _sectionTitle(String title) =>
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800));

  Widget _outcomeItem(String text, Color subText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 16, color: Color(0xFF43E97B)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: subText, height: 1.5))),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, IconData icon, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF8EC5FC), size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        Text(label, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.black45, fontSize: 11)),
      ],
    );
  }

  Widget _materialItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5))),
        ],
      ),
    );
  }

  Widget _stepItem(BuildContext context, int step, String text, {bool isActive = false, bool isDark = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 10),
      padding: isActive ? const EdgeInsets.all(12) : const EdgeInsets.only(bottom: 2),
      decoration: isActive
          ? BoxDecoration(
              color: const Color(0xFF8EC5FC).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF8EC5FC).withValues(alpha: 0.4)),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: isActive ? const LinearGradient(colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)]) : null,
              color: isActive ? null : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: TextStyle(
                  color: isActive ? Colors.white : (isDark ? Colors.white70 : Colors.black45),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  height: 1.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                  color: isActive
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? Colors.white60 : Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
