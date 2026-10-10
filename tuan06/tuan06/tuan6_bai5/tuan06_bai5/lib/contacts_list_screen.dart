import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'add_contact_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndLoad(); // Yêu cầu quyền trước khi load
  }

  Future<void> _requestPermissionsAndLoad() async {
    Map<Permission, PermissionStatus> statuses = await [Permission.contacts]
        .request();
    if (statuses[Permission.contacts]!.isGranted) {
      _loadContacts();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa cấp quyền truy cập danh bạ!')),
      );
    }
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    List<ContactInfo> contacts = await FlutterContactsService.getContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh bạ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Chờ màn hình Thêm danh bạ đóng lại, sau đó load lại danh sách mới
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddContactScreen(),
                ),
              );
              _loadContacts();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text('Không có danh bạ nào.'))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                ContactInfo contact = _contacts[index];
                return ListTile(
                  leading: contact.avatar != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar!),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(contact.displayName ?? 'Không có tên'),
                  subtitle: Text(
                    '${(contact.phones != null && contact.phones!.isNotEmpty) ? contact.phones!.first.value ?? 'Không có số' : 'Không có số'}\n'
                    '${(contact.emails != null && contact.emails!.isNotEmpty) ? contact.emails!.first.value ?? 'Không có email' : 'Không có email'}',
                  ),
                );
              },
            ),
    );
  }
}
