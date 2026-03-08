// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {StorageFactory} from "../src/StorageFactory.sol";

contract StorageFactoryTest is Test {
    StorageFactory public factory;

    function setUp() public {
        factory = new StorageFactory();
    }

    function testCanCreateSimpleStorage() public {
        factory.createSimpleStorageContract();
        // Verifica se o array agora tem 1 elemento
        // (Você precisará garantir que o array seja public no seu .sol)
    }
}
