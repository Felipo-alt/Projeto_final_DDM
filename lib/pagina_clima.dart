import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'servico_historico.dart';

// Modelo de dados do clima
class DadosClima {
  final String nomeCidade;
  final double temperatura;
  final String condicaoPrincipal;
  final String descricaoClima;

  DadosClima({
    required this.nomeCidade,
    required this.temperatura,
    required this.condicaoPrincipal,
    required this.descricaoClima,
  });

  factory DadosClima.fromJson(Map<String, dynamic> json) {
    return DadosClima(
      nomeCidade: json['name'],
      temperatura: json['main']['temp'].toDouble(),
      condicaoPrincipal: json['weather'][0]['main'],
      descricaoClima: json['weather'][0]['description'],
    );
  }
}

// Serviço para consultar API do clima
class ServicoClima {
  static const String urlBase = 'http://api.openweathermap.org/data/2.5/weather';
  final String chaveApi;

  ServicoClima(this.chaveApi);

  Future<DadosClima> obterClima(String nomeCidade) async {
    final resposta = await http.get(
      Uri.parse('$urlBase?q=$nomeCidade&appid=$chaveApi&units=metric&lang=pt_br'),
    );

    if (resposta.statusCode == 200) {
      return DadosClima.fromJson(jsonDecode(resposta.body));
    } else {
      throw Exception('Falha ao carregar dados do clima');
    }
  }
}

// Página de consulta/pesquisa
class PaginaConsulta extends StatefulWidget {
  const PaginaConsulta({super.key});

  @override
  State<PaginaConsulta> createState() => _PaginaConsultaState();
}

class _PaginaConsultaState extends State<PaginaConsulta> {
  final _servicoClima = ServicoClima('cd5be3a94574bf172b52bff59dce2140');
  final _servicoHistorico = ServicoHistorico();
  final _controladorPesquisa = TextEditingController();
  bool _estaCarregando = false;
  List<ItemHistorico> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final historico = await _servicoHistorico.obterHistorico();
    setState(() {
      _historico = historico;
    });
  }

  Future<void> _pesquisarCidadeDoHistorico(String nomeCidade) async {
    _controladorPesquisa.text = nomeCidade;
    await _pesquisarCidade();
  }

  List<Widget> buildHistoricoList() {
    return _historico.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.history, color: Colors.blue),
          title: Text(
            item.nomeCidade,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _pesquisarCidadeDoHistorico(item.nomeCidade),
          tileColor: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }).toList();
  }

  Future<void> _pesquisarCidade() async {
    if (_controladorPesquisa.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite o nome de uma cidade')),
      );
      return;
    }

    setState(() {
      _estaCarregando = true;
    });

    try {
      final dadosClima = await _servicoClima.obterClima(_controladorPesquisa.text.trim());
      
      // Salvar no histórico
      final itemHistorico = ItemHistorico(
        nomeCidade: dadosClima.nomeCidade,
        temperatura: dadosClima.temperatura,
        descricaoClima: dadosClima.descricaoClima,
        dataConsulta: DateTime.now(),
      );
      await _servicoHistorico.salvarConsulta(itemHistorico);
      
      // Atualizar lista de histórico
      await _carregarHistorico();
      
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaginaClima(
              nomeCidade: _controladorPesquisa.text.trim(),
              dadosClima: dadosClima,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cidade não encontrada. Tente novamente.')),
        );
      }
    } finally {
      setState(() {
        _estaCarregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wb_sunny,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 40),
              const Text(
                'Meteorologia no Bolso',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _controladorPesquisa,
                decoration: InputDecoration(
                  hintText: 'Digite o nome da cidade',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onSubmitted: (_) => _pesquisarCidade(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _estaCarregando ? null : _pesquisarCidade,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _estaCarregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Buscar',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              if (_historico.isNotEmpty) ...[
                const SizedBox(height: 40),
                const Text(
                  'Consultas Recentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...buildHistoricoList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controladorPesquisa.dispose();
    super.dispose();
  }
}

// Página de exibição do clima
class PaginaClima extends StatefulWidget {
  final String? nomeCidade;
  final DadosClima? dadosClima;
  
  const PaginaClima({super.key, this.nomeCidade, this.dadosClima});

  @override
  State<PaginaClima> createState() => _PaginaClimaState();
}

class _PaginaClimaState extends State<PaginaClima> {
  // Definir a chave da API do OpenWeatherMap
  final _servicoClima = ServicoClima('cd5be3a94574bf172b52bff59dce2140');
  DadosClima? _dadosClima;

  Future<void> _buscarClima() async {
    if (widget.dadosClima != null) {
      setState(() {
        _dadosClima = widget.dadosClima;
      });
      return;
    }

    if (widget.nomeCidade == null) {
      return;
    }

    try {
      final dadosClima = await _servicoClima.obterClima(widget.nomeCidade!);
      setState(() {
        _dadosClima = dadosClima;
      });
    } catch (e) {
      print(e);
    }
  }

  String obterAnimacaoClima(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }



  @override
  void initState() {
    super.initState();
    _buscarClima();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _dadosClima?.nomeCidade ?? "Carregando cidade...",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              obterAnimacaoClima(_dadosClima?.condicaoPrincipal),
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              '${_dadosClima?.temperatura.round() ?? 0}°C',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _dadosClima?.descricaoClima ?? "",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
