import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryScreen extends StatefulWidget {
  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late File _imageFile;
  bool _showDeleteIcon = false;

  @override
  void initState() {
    super.initState();
    _imageFile = File(''); // Initialize with empty file
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _showDeleteIcon = true;
      } else {
        print('No image selected.');
      }
    });
  }

  void _deleteImage() {
    setState(() {
      _imageFile = File(''); // Empty file to clear image
      _showDeleteIcon = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF294B29)),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Image',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF294B29)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed: _getImage,
                ),
              ),
            ),
            SizedBox(height: 20),
            _imageFile.path.isNotEmpty
                ? Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom:10.0),
                        child: Image.file(
                          _imageFile,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Visibility(
                        visible: _showDeleteIcon,
                        child: IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: _deleteImage,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'No image selected.',
                    style: TextStyle(fontSize: 16),
                  ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save income
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF294B29),
                  minimumSize: Size(200, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
