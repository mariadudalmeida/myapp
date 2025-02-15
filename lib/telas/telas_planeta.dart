import 'package:flutter/material.dart';

import '../controles/controle_planeta.dart';
import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

//CLASSE TelaPlaneta
class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  //VARIÁVEIS CRIADAS PARA O ARMAZENAMENTO DOS DADOS
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  //VARIÁVEL CRIADA PARA O ARMAZENAMENTO DOS DADOS
  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
    super.initState();
  }

  //DISPOSIÇÃO DOS DADOS
  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _inserirPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  //SALVAMENTO DOS DADOS DO PLANETA INSERIDO
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Dados validados com sucesso
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _inserirPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'OS DADOS DO PLANETA FORAM ${widget.isIncluir ? 'INCLUÍDOS' : 'ALTERADOS'} COM SUCESSO!',
          ),
        ),
      );
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  //CRIAÇÃO DA TELA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: 'NOME'),

                  //VALIDA SE A ENTRADA DO NOME ESTÁ NULA OU POSSUI MENOS DE 3 CARACTERES
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, insira o nome do Planeta desejado (Mínimo de 3 caracteres)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),

                TextFormField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(labelText: 'TAMANHO (KM)'),

                  //VALIDA SE A ENTRADA DO NÚMERO ESTÁ NULA OU NÃO ATENDE Á UM VALOR NUMÉRICO
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tamanho do planeta desejado';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Esse valor numérico não é válido!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),

                //VALIDA SE A ENTRADA DO NÚMERO ESTÁ NULA OU NÃO ATENDE Á UM VALOR NUMÉRICO
                TextFormField(
                  controller: _distanciaController,
                  decoration: InputDecoration(labelText: 'DISTÂNCIA (KM)'),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a distância do planeta desejado';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Esse valor numérico nã é válido!';
                    }
                    return null;
                  },
                  //SALVA A DISTÂNCIA DO PLANETA
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                TextFormField(
                  controller: _apelidoController,
                  decoration: InputDecoration(labelText: 'APELIDO'),
                  onSaved: (value) {
                    _planeta.apelido = value;
                  },
                ),

                //BOTÃO SALVAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('CANCELAR'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm, //_submitForm,
                      child: Text('SALVAR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
