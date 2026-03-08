#!/bin/bash
echo "🛡️ Iniciando Varredura de Segurança..."
echo "--- [1/2] Testes de Unidade (Forge) ---"
forge test

echo ""
echo "--- [2/2] Análise Estática (Slither) ---"
slither . --solc-remaps "forge-std/=lib/forge-std/src/" --filter-paths "lib/"
