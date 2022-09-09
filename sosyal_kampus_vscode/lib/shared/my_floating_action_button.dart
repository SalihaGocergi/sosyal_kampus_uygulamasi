
class MyFloatingActionButton extends StatefulWidget {
  MyFloatingActionButton({
    Key key,
    @required this.post,
    @required this.user,
  }) : super(key: key);
  final Post post;
  final Users user;

  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final _registerFormKey = GlobalKey<FormState>();
    final _aciklamaKontrol = TextEditingController();
    final _db = DatabaseService();
    final user = Provider.of<FirebaseUser>(context); //giriş yapan kullanıcı id

    @override
    void dispose() {
      _aciklamaKontrol.dispose();
      super.dispose();
    }

    return FloatingActionButton(
      key: scaffoldKey,
      onPressed: () {
        scaffoldKey.currentState.showBottomSheet(
          (context) => Form(
            key: _registerFormKey,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 10,
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Açıklama giriniz'),
                          controller: _aciklamaKontrol,
                          cursorWidth: 3.0,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen açıklama giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text("Gönder"),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_registerFormKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              try {
                                dynamic result = await _db.YorumEkle(
                                    user.uid,
                                    widget.user.uid,
                                    widget.post.id,
                                    _aciklamaKontrol.text);
                                if (result != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowPosts(
                                          post: widget.post, user: widget.user),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    error = 'Bilgilerini kontrol ediniz!';
                                    loading = false;
                                  });
                                }
                              } catch (e) {
                                print('Hata Oluştu!!: $e');
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
*/
