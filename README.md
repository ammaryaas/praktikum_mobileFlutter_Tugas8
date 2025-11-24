# Tugas 9

Ammar Yassin <br>
H1D023091 <br>
Shift F => A <br>

## Penjelasan Kode
### Login Page
sistem akan mengarahkan pengguna ke halaman login dan diharuskan memasukkan email dan password yang telah terdapat di database melalui proses registrasi. Tombol submit di halaman akan memvalidasi inputan user melalui function bloc yang ada di LoginBloc. Fungsi ini juga akan memuat token dan mengarahkan pengguna ke halaman produk. 
```
void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then(
      (value) async {
        if (value.code == 200) {
          await UserInfo().setToken(value.token.toString());
          await UserInfo().setUserID(int.parse(value.userID.toString()));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProdukPage()),
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
              description: "Login gagal, silahkan coba lagi",
            ),
          );
        }
      },
      onError: (error) {
        print(error);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Login gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
```
<img width="746" height="1080" alt="image" src="https://github.com/user-attachments/assets/c28e59fe-0688-43ab-b2ba-8e8d3fc78d65" />
jika input gagal, sistem akan mengeluarkan peringatan bahwa proses login gagal.
<img width="747" height="1080" alt="image" src="https://github.com/user-attachments/assets/52157b9a-733f-4d93-9857-17a751c57f60" />

### Regist Page
halaman ini dimuat ketika pengguna memutuskan untuk membuat akun dan ingin mendafarkan diri ke dalam sistem. ketika tombol submit ditekan, sistem akan menyimpan data pengguna ke database yang selanjutkan akan digunakan ketika proses login.
```
void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then(
      (value) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Registrasi berhasil, silahkan login",
            okClick: () {
              Navigator.pop(context);
            },
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
            description: "Registrasi gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
  ```
<img width="746" height="1080" alt="image" src="https://github.com/user-attachments/assets/bdd9b8a9-fabe-4e50-bc59-cdadc4f39daa" />
ketika error, validasi tidak bernilai true pada setiap inputan form, maka akan menampilkan pesan error
<img width="745" height="1080" alt="image" src="https://github.com/user-attachments/assets/aa8d235e-8d84-42db-b51e-493d02c8410c" />

### Produk List Page
halaman ini memuat list seluruh produk yang ada di database. Menggunakan ProdukBloc untuk memuat seluruh data produk ke dalam halaman view.
```
body: FutureBuilder<List>(
        future: ProdukBloc.getProduks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListProduk(list: snapshot.data)
              : const Center(child: CircularProgressIndicator());
        },
```
getProduk pada ProdukBloc
```
static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];
    for (int i = 0; i < listProduk.length; i++) {
      produks.add(Produk.fromJson(listProduk[i]));
    }
    return produks;
  }
```
<img width="747" height="1080" alt="image" src="https://github.com/user-attachments/assets/cbb83a63-2a45-4a3b-97a4-9ca96708ded5" />

### Add Product Page
pada halaman ini pengguna dapat menambahkan data produk, pengguna akan diarahkan ke halaman produk form untuk mengisi data produk yang akan ditambahkan. ProdukBloc digunakan sebagai controller untuk menambahkan dan melakukan push data ke dalam database.
```
simpan() {
    setState(() {
      _isLoading = true;
    });
    Produk createProduk = Produk(id: null);
    createProduk.kodeProduk = _kodeProdukTextboxController.text;
    createProduk.namaProduk = _namaProdukTextboxController.text;
    createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
    ProdukBloc.addProduk(produk: createProduk).then(
      (value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => const ProdukPage(),
          ),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ),
        );
      },
    );
    setState(() {
      _isLoading = false;
    });
  }
  ```
addProduk pada ProdukBloc
```
static Future addProduk({Produk? produk}) async {
    String apiUrl = ApiUrl.createProduk;
    var body = {
      "kode_produk": produk!.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }
  ```
<img width="741" height="1080" alt="image" src="https://github.com/user-attachments/assets/0e30a57c-f26b-4ee6-a08b-68e0f91b9d69" />

### Detail Product Page
halaman ini menampilkan detail dari data yang ada di dalam produk. Memuat juga tombol edit dan delete yang akan mengarahkan ke halaman lain. 
```
body: Center(
        child: Column(
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(produk: widget.produk!),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }
  ```
<img width="749" height="1080" alt="image" src="https://github.com/user-attachments/assets/4ac30dc9-fd40-416d-8bd6-096d525e95e5" />

### Edit Product Page
halaman ini sebenrnya adalah halaman form, tetapi dengan value terisi sesuai dengan produk yang dimaksudkan untuk diedit datanya.
```
static Future updateProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.updateProduk(int.parse(produk.id!));
    print(apiUrl);
    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }
```
<img width="753" height="1080" alt="image" src="https://github.com/user-attachments/assets/62fb562d-578f-40b0-90f5-cff888d32e6e" />

### Delete Product
Fungsi ini menjadi peran dalam menghapus data produk. dengan function yang ada di dalam ProdukBloc, data di dalam database dapat dihapus. setelah melakukan konfirmasi pada model yang muncul, data dapat menghilang
```
void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        //tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
              (value) => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProdukPage()),
                ),
              },
              onError: (error) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                    description: "Hapus gagal, silahkan coba lagi",
                  ),
                );
              },
            );
          },
        ),
        //tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
```
<img width="753" height="1080" alt="image" src="https://github.com/user-attachments/assets/b490b10b-8299-4140-97b9-5615af61797d" />

```
static Future<bool> deleteProduk({int? id}) async {
    String apiUrl = ApiUrl.deleteProduk(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
```

