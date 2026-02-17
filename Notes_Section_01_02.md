# 🛡️ Foundation Report: From SimpleStorage to FactoryPattern
# 🛡️ Relatório de Fundamentos: De SimpleStorage a FactoryPattern

This document details the technical knowledge and security vectors consolidated before the implementation of the **Fund Me** protocol.
Este documento detalha o conhecimento técnico e os vetores de segurança consolidados antes da implementação do protocolo **Fund Me**.

---

## 1. Data Types and Structures (The Audit Basis)
## 1. Tipos de Dados e Estruturas (A Base da Auditoria)

The choice of data type directly impacts gas consumption and security.
A escolha do tipo de dado impacta diretamente o consumo de gás e a segurança.

### Value Types / Tipos Primitivos:
- **uint256:** The standard for integers. *Audit:* Optimized for EVM 32-byte slots. / O padrão para números inteiros. *Auditoria:* Otimizado para slots de 32 bytes da EVM.
- **address:** Identifier for wallets or contracts. *Audit:* Always check if the address is `address(0)` to avoid loss of funds. / Identificador de carteiras ou contratos. *Auditoria:* Sempre verificar se o endereço é `address(0)` para evitar perda de fundos.
- **bool:** True or false. / Verdadeiro ou falso.

### Data Structures / Estruturas de Dados:
- **Structs:** Grouping of variables. *Audit:* Beware of "Packing" (variable order) to save memory slots. / Agrupamento de variáveis. *Auditoria:* Cuidado com o "Packing" (ordem das variáveis) para economizar slots de memória.
- **Arrays:** Lists of data. *Audit:* Unbounded arrays can cause DoS (Denial of Service) attacks if the read loop exceeds the block gas limit. / Listas de dados. *Auditoria:* Arrays infinitos podem causar ataques de DoS (Denial of Service) se o loop de leitura exceder o limite de gás do bloco.
- **Mappings:** Key-value tables. *Audit:* More secure and cheaper than arrays for data lookup, but not iterable (requires an auxiliary list to list all items). / Tabelas de chave-valor. *Auditoria:* São mais seguros e baratos que arrays para buscar dados, mas não são iteráveis (exigem uma lista auxiliar para listar todos os itens).



---

## 2. EVM Memory Management (Where Hacks Happen)
## 2. Gestão de Memória na EVM (Onde os Hacks Acontecem)

Understanding where data is saved is what differentiates a developer from an auditor.
Entender onde os dados são salvos é o que diferencia um desenvolvedor de um auditor.

- **Storage:** Persistent data on the blockchain (very expensive). *Audit:* Manipulating storage is the highest gas cost. / Dados persistentes na blockchain (muito caro). *Auditoria:* Manipular storage é o maior custo de gás.
- **Memory:** Temporary data during execution (cheap). / Dados temporários durante a execução (barato).
- **Calldata:** Similar to memory, but immutable and available only for `external` function arguments. *Audit:* Use calldata whenever possible to save gas on inputs. / Similar à memory, mas imutável e disponível apenas para argumentos de funções `external`. *Auditoria:* Usar calldata sempre que possível para economizar gás em inputs.
- **Stack:** Where the EVM processes calculations. 1024 level limit (risk of *Stack Too Deep* error). / Onde a EVM processa cálculos. Limite de 1024 níveis (risco de *Stack Too Deep*).



---

## 3. Visibility and Contract Flow
## 3. Visibilidade e Fluxo de Contratos

How contract doors are opened or closed.
Como as portas do contrato são abertas ou fechadas.

### Visibility / Visibilidade:
- **public:** Internal and external access. Creates an automatic "getter". / Acesso interno e externo. Cria um "getter" automático.
- **external:** External access only. Cheaper for receiving large volumes of data. / Apenas acesso externo. Mais barato para receber grandes volumes de dados.
- **private:** Only the current contract can access. *Auditor Reminder:* Private data is still visible to anyone analyzing the blockchain state! / Apenas o contrato atual acessa. *Lembrete de Auditor:* Dados privados ainda são visíveis por qualquer pessoa que analise o estado da blockchain!
- **internal:** The contract and its heirs can access. / O contrato e seus herdeiros acessam.

### Flow Keywords / Palavras-Chave de Fluxo:
- **is:** Inheritance. Allows using patterns like OpenZeppelin's `Ownable`. / Herança. Permite usar padrões como o `Ownable` da OpenZeppelin.
- **new:** Instantiation of new contracts (Factory Pattern). / Instanciação de novos contratos (Factory Pattern).

---

## 4. Factory Pattern & Composition
## 4. Factory Pattern & Composição

What I learned while creating `StorageFactory.sol`:
O que aprendi ao criar o `StorageFactory.sol`:

- **Interactivity / Interatividade:** A contract can call functions from another contract if it knows its address and its **ABI (Application Binary Interface)**. / Um contrato pode chamar funções de outro contrato se conhecer o seu endereço e sua ABI.
- **Attack Vector / Vetor de Ataque:** If a Factory contract allows any address to be added as a "child contract", an attacker can inject a malicious contract with a fake function that steals funds. / Se um contrato Factory permite que qualquer endereço seja adicionado como um "contrato filho", um atacante pode injetar um contrato malicioso com uma função falsa que rouba fundos.
- **Factory Audit / Auditoria de Fábrica:** Always validate if the created contract address is legitimate before interacting. / Sempre validar se o endereço do contrato criado é legítimo antes de interagir.



---

## 5. Prerequisite Checklist for Fund Me
## 5. Checklist de Pré-Requisitos para o Fund Me
