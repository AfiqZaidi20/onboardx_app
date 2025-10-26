// document_manager_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:onboarding_tnb_app_part_eizul/services/supabase_service.dart';

class DocumentManagerScreen extends StatefulWidget {
  const DocumentManagerScreen({super.key});

  @override
  State<DocumentManagerScreen> createState() => _DocumentManagerScreenState();
}

class _DocumentManagerScreenState extends State<DocumentManagerScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  Future<List<dynamic>>? _filesFuture;
  
  final List<_PathSegment> _pathHistory = [];
  String? _currentParentFolderId;

  @override
  void initState() {
    super.initState();
    _pathHistory.add(_PathSegment(id: null, name: 'Home'));
    _loadFiles();
  }

  void _loadFiles() {
    setState(() {
      _filesFuture = _supabaseService.getFilesAndFolders(_currentParentFolderId);
    });
  }

  void _navigateToFolder(Folder folder) {
    setState(() {
      _pathHistory.add(_PathSegment(id: folder.id, name: folder.name));
      _currentParentFolderId = folder.id;
      _loadFiles();
    });
  }

  void _goBack() {
    if (_pathHistory.length > 1) {
      setState(() {
        _pathHistory.removeLast();
        _currentParentFolderId = _pathHistory.last.id;
        _loadFiles();
      });
    }
  }

  void _createFolder() async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    Navigator.pop(context);
                    await _supabaseService.createFolder(
                      controller.text, 
                      _currentParentFolderId
                    );
                    _loadFiles();
                    _showSnackbar('Folder "${controller.text}" created.', type: _SnackbarType.success);
                  } catch (e) {
                    _showSnackbar('Error creating folder: $e', type: _SnackbarType.error);
                  }
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _addFileToCurrentFolder() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    
    if (result != null && result.files.isNotEmpty) {
      try {
        final platformFile = result.files.first;
        _showSnackbar('Uploading "${platformFile.name}"...', type: _SnackbarType.info);
        
        await _supabaseService.uploadFile(
          platformFile, 
          _currentParentFolderId
        );
        
        _loadFiles();
        _showSnackbar('File uploaded successfully!', type: _SnackbarType.success);
      } catch (e) {
        _showSnackbar('Error uploading file: $e', type: _SnackbarType.error);
      }
    }
  }

  void _openFile(Document doc) async {
    try {
      _showSnackbar('Opening ${doc.name}...', type: _SnackbarType.info);
      
      // Download and open the actual file
      final filePath = await _supabaseService.downloadFile(doc.path, doc.name);
      
      if (filePath != null) {
        await OpenFile.open(filePath);
        _showSnackbar('${doc.name} opened successfully!', type: _SnackbarType.success);
      } else {
        _showSnackbar('Failed to open ${doc.name}', type: _SnackbarType.error);
      }
    } catch (e) {
      _showSnackbar('Failed to open file: $e', type: _SnackbarType.error);
    }
  }

  void _removeFile(Document doc) async {
    try {
      await _supabaseService.deleteFile(doc.id);
      _loadFiles();
      _showSnackbar('File "${doc.name}" removed successfully!', type: _SnackbarType.success);
    } catch (e) {
      _showSnackbar('Error removing file: $e', type: _SnackbarType.error);
    }
  }

  void _deleteFolder(Folder folder) async {
    try {
      await _supabaseService.deleteFolder(folder.id, recursive: false);
      _loadFiles(); // Reload to show the folder is gone
      _showSnackbar('Folder "${folder.name}" has been deleted.', type: _SnackbarType.success);
    } on FolderNotEmptyException {
      // Folder is not empty, show a confirmation dialog
      final confirmDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Folder?'),
          content: Text(
              'The folder "${folder.name}" is not empty. Do you want to delete it and all of its contents? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete All'),
            ),
          ],
        ),
      );

      if (confirmDelete == true) {
        try {
          // User confirmed, so call delete with recursive flag
          await _supabaseService.deleteFolder(folder.id, recursive: true);
          _loadFiles(); // Reload to show the folder is gone
          _showSnackbar('Folder "${folder.name}" and all its contents have been deleted.', type: _SnackbarType.success);
        } catch (e) {
          _showSnackbar('Error deleting folder contents: $e', type: _SnackbarType.error);
        }
      }
    } catch (e) {
      _showSnackbar('Error deleting folder: $e', type: _SnackbarType.error);
    }
  }

  void _showSnackbar(String message, {_SnackbarType type = _SnackbarType.info}) {
    Color backgroundColor;
    switch (type) {
      case _SnackbarType.success:
        backgroundColor = Colors.green;
        break;
      case _SnackbarType.error:
        backgroundColor = Colors.red;
        break;
      case _SnackbarType.info:
        backgroundColor = Colors.blue;
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _downloadFile(Document doc) async {
    try {
      _showSnackbar('Downloading ${doc.name}...', type: _SnackbarType.info);
      final filePath = await _supabaseService.downloadFile(doc.path, doc.name);
      
      if (filePath != null) {
        _showSnackbar('${doc.name} downloaded successfully!', type: _SnackbarType.success);
      } else {
        _showSnackbar('Failed to download ${doc.name}', type: _SnackbarType.error);
      }
    } catch (e) {
      _showSnackbar('Error downloading file: $e', type: _SnackbarType.error);
    }
  }

  void _showFileContextMenu(Document doc) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                _openFile(doc);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download'),
              onTap: () {
                Navigator.pop(context);
                _downloadFile(doc);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove'),
              onTap: () {
                Navigator.pop(context);
                _removeFile(doc);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFolderContextMenu(Folder folder) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _deleteFolder(folder);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPathSegment = _pathHistory.last;
    final bool isRoot = currentPathSegment.id == null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Row(
            children: _pathHistory.map((segment) {
              return Text(
                '${segment.name} ${segment == currentPathSegment ? '' : '> '}',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: segment == currentPathSegment ? FontWeight.bold : FontWeight.normal
                ),
              );
            }).toList(),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading: isRoot
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
              ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                isRoot ? 'No folders yet.' : 'This folder is empty.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          } else {
            final currentDirectory = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: currentDirectory.length,
              itemBuilder: (context, index) {
                final item = currentDirectory[index];
                if (item is Folder) {
                  return FolderCard(
                    folder: item, 
                    onTap: () => _navigateToFolder(item), 
                    onMenuTap: () => _showFolderContextMenu(item)
                  );
                } else if (item is Document) {
                  return DocumentCard(
                    document: item, 
                    onTap: () => _openFile(item), 
                    onMenuTap: () => _showFileContextMenu(item)
                  );
                }
                return Container();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isRoot ? _createFolder : _addFileToCurrentFolder,
        child: Icon(isRoot ? Icons.create_new_folder : Icons.add),
        tooltip: isRoot ? 'Create New Folder' : 'Add New File',
      ),
    );
  }
}

enum _SnackbarType { success, error, info }

class _PathSegment {
  final String? id;
  final String name;

  _PathSegment({required this.id, required this.name});
}

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.folder_open, color: Colors.blue, size: 40),
        title: Text(
          folder.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMenuTap,
        ),
        onTap: onTap,
      ),
    );
  }
}

class DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightGreen,
          ),
          child: const Center(
            child: Icon(Icons.description, color: Colors.white, size: 24),
          ),
        ),
        title: Text(
          document.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 30,
              child: OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text(
                  'View',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMenuTap,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}