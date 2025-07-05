import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo para item do histórico
class ItemHistorico {
  final String nomeCidade;
  final double temperatura;
  final String descricaoClima;
  final DateTime dataConsulta;

  ItemHistorico({
    required this.nomeCidade,
    required this.temperatura,
    required this.descricaoClima,
    required this.dataConsulta,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomeCidade': nomeCidade,
      'temperatura': temperatura,
      'descricaoClima': descricaoClima,
      'dataConsulta': dataConsulta,
    };
  }

  factory ItemHistorico.fromMap(Map<String, dynamic> map) {
    return ItemHistorico(
      nomeCidade: map['nomeCidade'] ?? '',
      temperatura: (map['temperatura'] ?? 0.0).toDouble(),
      descricaoClima: map['descricaoClima'] ?? '',
      dataConsulta: (map['dataConsulta'] as Timestamp).toDate(),
    );
  }
}

// Serviço para gerenciar histórico no Firestore
class ServicoHistorico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _colecao = 'historico_consultas';

  // Salvar nova consulta no histórico
  Future<void> salvarConsulta(ItemHistorico item) async {
    try {
      // Adiciona o novo item
      await _firestore.collection(_colecao).add(item.toMap());
      
      // Mantém apenas os últimos 3 itens
      await _manterUltimosTresItens();
    } catch (e) {
      print('Erro ao salvar consulta: $e');
    }
  }

  // Buscar histórico das últimas 3 consultas
  Future<List<ItemHistorico>> obterHistorico() async {
    try {
      final consulta = await _firestore
          .collection(_colecao)
          .orderBy('dataConsulta', descending: true)
          .limit(3)
          .get();

      return consulta.docs.map((doc) {
        return ItemHistorico.fromMap(doc.data());
      }).toList();
    } catch (e) {
      print('Erro ao obter histórico: $e');
      return [];
    }
  }

  // Manter apenas os últimos 3 itens no histórico
  Future<void> _manterUltimosTresItens() async {
    try {
      final consulta = await _firestore
          .collection(_colecao)
          .orderBy('dataConsulta', descending: true)
          .get();

      // Se há mais de 3 itens, remove os mais antigos
      if (consulta.docs.length > 3) {
        final itensParaRemover = consulta.docs.skip(3);
        for (final doc in itensParaRemover) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      print('Erro ao manter últimos 3 itens: $e');
    }
  }

  // Limpar o histórico
  Future<void> limparHistorico() async {
    try {
      final consulta = await _firestore.collection(_colecao).get();
      for (final doc in consulta.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Erro ao limpar histórico: $e');
    }
  }
}
