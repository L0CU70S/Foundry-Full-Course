# 🛡️ Audit Research: Section 03 - FundMe Protocol
# 🛡️ Relatório de Auditoria: Seção 03 - Protocolo FundMe

This document details the advanced Solidity concepts, gas optimizations, and security vectors explored during the development of the **FundMe** contract.
Este documento detalha os conceitos avançados de Solidity, otimizações de gás e vetores de segurança explorados durante o desenvolvimento do contrato **FundMe**.

---

## 1. External Dependencies & Oracle Risks
## 1. Dependências Externas e Riscos de Oráculos

The FundMe contract relies on **Chainlink Oracles** to fetch real-world price data via `PriceConverter.sol`.
O contrato FundMe depende de **Oráculos da Chainlink** para buscar dados de preço do mundo real através do `PriceConverter.sol`.

- **The Problem / O Problema:** Blockchains are isolated. They cannot natively know the price of ETH/USD. Relying on a single centralized source is a "Single Point of Failure".
- **The Solution / A Solução:** We implemented the `AggregatorV3Interface`. Chainlink’s decentralized node network ensures data integrity and prevents price manipulation.
- **Auditor Note / Nota de Auditoria:** The Oracle address is currently **hardcoded** in the library. While functional for this stage, it limits the contract to the Sepolia Testnet. Future versions should use dependency injection via the constructor.



---

## 2. Gas Optimization & Implementation Decisions
## 2. Otimização de Gás e Decisões de Implementação

Refining the contract to be more efficient on-chain.
Refinando o contrato para ser mais eficiente on-chain.

- **Immutables & Constants:**
  - `MINIMUM_USD` is `constant`.
  - `i_owner` is `immutable`.
  - *Audit Insight:* These do not occupy storage slots. They are embedded in the bytecode, saving gas on every call. / Estes não ocupam slots de storage. São incorporados no bytecode, economizando gás em cada chamada.
- **Error Handling (Require Implementation):**
  - *Current Code:* `require(msg.sender == i_owner, "Sender is not owner!");`
  - *Audit Insight:* The contract uses `require` with a string message for access control. This is highly readable but consumes more gas than **Custom Errors**. 
  - *Future Optimization:* Transitioning to `if (msg.sender != i_owner) revert NotOwner();` would reduce gas costs by using a 4-byte selector instead of storing and emitting the full error string.

---

## 3. Fund Management & Withdrawal Security
## 3. Gestão de Fundos e Segurança de Saque

Handling Ether requires the highest level of security to prevent Reentrancy or locked funds.
Manipular Ether exige o nível mais alto de segurança para evitar Reentrância ou fundos bloqueados.

- **The Withdrawal Pattern (Low-Level Call):**
  - *Implementation:* `(bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");`
  - **Audit Insight:** `call` is preferred over `transfer` or `send` because it forwards all gas and is resilient to gas cost changes in the EVM.
- **Fallback & Receive:**
  - These functions were implemented to catch plain Ether transfers. This ensures that any ETH sent to the contract address without data is still funneled through the `fund()` logic.



---

## 4. Vulnerability Assessment (Auditor's Perspective)
## 4. Avaliação de Vulnerabilidades (Perspectiva de Auditor)

| Risk / Risco | Severity / Severidade | Mitigation / Mitigação |
| :--- | :--- | :--- |
| **Unbounded Loop** | Medium | The `withdraw` function loops through the `funders` array. If thousands of people fund, the gas cost to withdraw could exceed the block limit. / O loop de saque percorre o array `funders`. Se milhares de pessoas financiarem, o custo de gás para sacar pode exceder o limite do bloco. |
| **Hardcoded Oracle** | Low | The price feed address is fixed. Changing networks requires redeploying or updating the library. / O endereço do price feed é fixo. Mudar de rede exige redeploy ou atualização da biblioteca. |
| **Access Control** | Informational | The `onlyOwner` modifier correctly restricts the `withdraw` function to the deployer. / O modificador `onlyOwner` restringe corretamente a função de saque ao deployer. |
