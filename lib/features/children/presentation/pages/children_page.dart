import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/child_viewmodel.dart';
import '../../data/models/child_model.dart';

class ChildrenPage extends ConsumerWidget {
  const ChildrenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(childViewModelProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1520) : Colors.white,
      body: Column(
        children: [
          // Header
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Children 👶',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Manage child profiles',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showChildDialog(context, ref),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('😕', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 10),
                            Text(state.error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(childViewModelProvider.notifier)
                                  .loadChildren(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : state.children.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('👶', style: TextStyle(fontSize: 56)),
                                const SizedBox(height: 12),
                                const Text(
                                  'No children yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap + to add a child profile',
                                  style: TextStyle(color: isDark ? Colors.white38 : Colors.black45),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _showChildDialog(context, ref),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Child'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8EC5FC),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: state.children.length,
                            itemBuilder: (context, i) => _ChildCard(
                              child: state.children[i],
                              onEdit: () => _showChildDialog(
                                context,
                                ref,
                                existing: state.children[i],
                              ),
                              onDelete: () => _confirmDelete(
                                context,
                                ref,
                                state.children[i],
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  void _showChildDialog(
    BuildContext context,
    WidgetRef ref, {
    ChildModel? existing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final ageCtrl  = TextEditingController(
      text: existing != null ? existing.age.toString() : '',
    );
    final formKey  = GlobalKey<FormState>();
    final isEdit   = existing != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isEdit ? 'Edit Child' : 'Add Child',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: _inputDec('Child\'s Name', isDark),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: _inputDec('Age (1–12)', isDark),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 1 || n > 12) {
                    return 'Age must be 1–12';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8EC5FC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);
              final name = nameCtrl.text.trim();
              final age  = int.parse(ageCtrl.text.trim());
              final vm   = ref.read(childViewModelProvider.notifier);
              if (isEdit) {
                await vm.updateChild(id: existing.id, name: name, age: age);
              } else {
                await vm.addChild(name: name, age: age);
              }
            },
            child: Text(isEdit ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    ChildModel child,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Child Profile'),
        content: Text('Remove ${child.name}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ref
                  .read(childViewModelProvider.notifier)
                  .deleteChild(child.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(String label, bool isDark) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: isDark ? const Color(0xFF1E2530) : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );
}

class _ChildCard extends StatelessWidget {
  final ChildModel child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ChildCard({
    required this.child,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final avatars = ['🐱', '🐶', '🐻', '🦊', '🐼', '🐨'];
    final emoji   = avatars[child.name.codeUnitAt(0) % avatars.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2530) : const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8EC5FC), Color(0xFFE0C3FC)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${child.age} year${child.age == 1 ? '' : 's'} old',
                  style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF8EC5FC)),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
