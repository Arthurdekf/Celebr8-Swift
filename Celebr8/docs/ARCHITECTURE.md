
# CELEBR8 — Architecture

## Stack

- Swift
- SwiftUI
- MVVM
- Firebase
- iOS 27 durante a fase inicial de estudos

## Camadas

### Models

Representam os dados da aplicação.

Exemplos:

- User
- Event
- Category
- Attendance

### Views

Responsáveis pela apresentação da interface e interação direta com o usuário.

Views não devem acessar diretamente Firebase ou outros serviços externos.

### ViewModels

Controlam o estado e a lógica de apresentação das telas.

Responsabilidades:

- validação
- carregamento
- tratamento de erros
- comunicação com Services
- transformação de dados para a View

### Services

Concentram integrações externas.

Exemplos:

- AuthenticationService
- EventService
- UserService
- StorageService

## Estrutura inicial

```text
Celebr8
├── Models
├── Services
├── ViewModels
├── Views
│   ├── Root
│   ├── Authentication
│   ├── Home
│   ├── Events
│   ├── Search
│   ├── Profile
│   └── Components
├── Resources
│   ├── Theme
│   └── Fonts
├── Assets.xcassets
└── Celebr8App.swift
