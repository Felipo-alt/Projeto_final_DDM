# 🌤️ Meteorologia de Bolso

## 🎯 Descrição do Aplicativo

O **Meteorologia de Bolso** é um aplicativo Flutter que permite consultar informações climáticas de qualquer cidade do mundo de forma simples e intuitiva. O app exemplifica, na prática, conceitos fundamentais da disciplina DDM, como interfaces responsivas e persistência de dados em nuvem utilizando o Firebase.

## ✨ Funcionalidades Implementadas

- 🔍 **Busca por cidade**: Digite o nome de qualquer cidade e obtenha informações climáticas em tempo real
- 🌡️ **Temperatura atual**: Visualize a temperatura em graus Celsius
- 🎬 **Representação visual**: GIFs e imagens que representam as condições climáticas atuais
- 📜 **Histórico de consultas**: Visualize as últimas consultas realizadas
- 💾 **Armazenamento em nuvem**: Dados sincronizados via Firebase Firestore
- 📱 **Interface responsiva**: Design adaptado para diferentes tamanhos de tela

## 🛠️ Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento mobile
- **Dart** - Linguagem de programação
- **Firebase** - Backend como serviço
  - Firestore Database - Banco de dados NoSQL
- **OpenWeatherMap API** - API para dados meteorológicos
- **Material Design** - Sistema de design do Google

## 📱 Telas do Aplicativo

### 1. Tela Splash
- Apresenta a logo e nome do aplicativo
- Tempo de carregamento para inicialização das funcionalidades
- Transição automática para a tela principal

### 2. Tela Principal
- Campo de busca para inserir nome da cidade
- Botão de consulta do clima
- Lista com histórico das consultas realizadas
- Menu de navegação

### 3. Tela de Resultado
- Nome da cidade consultada
- Temperatura atual em Celsius
- GIF representando as condições climáticas
- Botão para voltar à tela anterior

## 🏗️ Requisitos Técnicos Atendidos

### ✅ **Estrutura de Telas (Mínimo 3-4 telas)**
- Tela Splash com nome e logo do app
- Tela principal com funcionalidades do app
- Tela de resultado da consulta climática

### ✅ **Conceitos Aplicados**
- **Criação e uso de classes**: Modelos para dados meteorológicos e usuários
- **Gerenciamento de estado**: StatefulWidget para controle de interface
- **Componentes visuais nativos**: Scaffold, Row, Column, Text, Image, Button, etc.
- **Interatividade e feedback**: Validação de campos, loading indicators, mensagens de erro
- **Conexão com Firebase**: Firestore para armazenamento de dados diversos
- **Organização em arquivos**: Separação em diferentes arquivos para melhor organização

### ✅ **Funcionalidades Obrigatórias**
- Interface responsiva e intuitiva
- Persistência de dados em nuvem
- Tratamento de erros e validações
- Navegação fluida entre telas

## 📸 Prints das Telas

### Tela Splash
![Tela Splash](https://github.com/user-attachments/assets/ed341478-5148-4642-9921-278a15f57d36)

### Tela de Consulta/Principal
![Tela Principal](https://github.com/user-attachments/assets/945bbb1f-39a2-40c4-8ea0-672b3a8944ed)

### Tela de Resultado da Consulta
![Resultado da Consulta](https://github.com/user-attachments/assets/f202bdf4-904c-4525-83bf-b34dc3219ae1)

## 🚀 Instruções de Instalação e Execução

### Pré-requisitos
- Flutter SDK 3.0 ou superior
- Dart SDK
- Android Studio ou VS Code
- Conta no Firebase
- Chave da API OpenWeatherMap (gratuita)

### Passos para execução

1. **Clone o repositório**
   ```bash
   git clone https://github.com/Felipo-alt/Projeto_final_DDM.git
   cd Projeto_final_DDM
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Configure o Firestore Database
   - Baixe e adicione os arquivos de configuração caso vá utilizar a aplicação nas plataformas Android e/ou iOS:
     - `google-services.json` (Android) → `android/app/`
     - `GoogleService-Info.plist` (iOS) → `ios/Runner/`

4. **Configure a API OpenWeatherMap**
   - Registre-se em [OpenWeatherMap](https://openweathermap.org/api)
   - Obtenha sua chave API gratuita
   - Substitua no código onde indicado

5. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📂 Estrutura do Projeto

```
lib/
├── main.dart                 # Arquivo principal da aplicação
├── pagina_splash.dart        # Tela de carregamento
├── pagina_clima.dart         # Tela principal
└── servico_historico.dart    # Arquivo responsável pelo histórico
```

## 🧪 Funcionalidades Adicionais

### Recursos Extras Implementados
- **Tratamento de erros**: Mensagens amigáveis para diferentes tipos de erro
- **Loading states**: Indicadores visuais durante carregamento
- **Responsividade**: Interface adaptada para diferentes tamanhos de tela
- **Animações**: Transições suaves entre telas

## 👥 Equipe de Desenvolvimento

**Dupla:**
- Felipe Oliveira Batista Silva
- Mateus Gomes Perez Campos

**Curso:** Técnico em Informática Integrado ao Ensino Médio - 4º ano <br />
**Instituição:** IFSP - Campus Jacareí <br />
**Disciplina:** Desenvolvimento de Aplicações para Dispositivos Móveis <br />
**Professora:** Ana Paula Abrantes de Castro Shiguemori <br />
**Período:** 1º Semestre de 2025