/*
Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: '@example.com',
                            labelText: 'Email *',
                          ),
                          controller: null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen email giriniz";
                            } else if (!EmailValidator.validate(value)) {
                              return "Lütfen geçerli bir email giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: '*******',
                            labelText: 'Şifre *',
                          ),
                          obscureText: true,
                          controller: null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen şifre giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      */
