// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

/** 1. Копилка (PiggyBank)
Создай контракт, который принимает эфир и даёт владельцу забрать всё накопленное.
🔹 receive() + withdraw() только для владельца.
🔹 Используй payable, require, owner, address(this).balance.*/ 


import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract PiggyBank is Ownable {

    constructor() Ownable(_msgSender()){}

    receive() external payable {}

    function withdraw() public {
        payable(owner()).transfer(address(this).balance);
    }
}


/**✅ 2. Умный счетчик (SmartCounter)
Контракт с функциями increment(), decrement(), get().
🔹 Сохраняй значение в storage.
🔹 decrement не должен уходить в минус */

contract SmartCounter {

    uint256 private age;

    error OverflowValue();
    error TheMinimumValueHasBeenReached();

    function setAge(uint256 _age) public {
        require(_age > 0, OverflowValue());
        age = _age;
    }

    function increment() public {
        require(age != type(uint256).max, OverflowValue());
        age++;
    }

    function decrement() public {
        require(age != 0, TheMinimumValueHasBeenReached());
        age--;
    }

    function getAge() public view returns(uint256){
        return age;
    }
}

/**3. Массив чисел (SimpleArray)
Храни массив uint[] и реализуй функции:
🔹 addNumber(uint) — добавить в массив
🔹 getNumber(uint) — вернуть число по индексу
🔹 getAll() — вернуть весь массив
🔹 getSum() — сумма всех чисел */

contract SimpleArray {
    uint256[] public array;

    function addNumber(uint256 value) public {
        array.push(value);
    }

    function getNumber(uint256 index) public view returns(uint256) {
        return array[index];
    }

    function getAll() public view returns(uint256[] memory){
        return array;
    }
}