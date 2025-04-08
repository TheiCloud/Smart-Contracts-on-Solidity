// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;
/*/
import {Ownable} from "D:\Smart Contracts on Solidity\node_modules\@openzeppelin\contracts\access\Ownable.sol";
/*/
import "@openzeppelin/contracts/access/Ownable.sol";

contract Store is Ownable{
    //@notice buyer => id_product => quantuty
    mapping (address => mapping(uint256 => uint256)) public purchase;

    constructor() Ownable(_msgSender()) {}

    struct Product {
        string name;
        uint256 id;
        uint256 stock;
        uint256 price;
    }

    Product[] private products;

    error IdAlreadyExist();
    error IdNotFound();
    error NotEnoughtFunds();
    error FlawOfProduct();
    error NegativeQuantity();

    function getProducts() public view returns(Product[] memory){
        return products;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Not enought money");
        payable(owner()).transfer(balance);
    }

    function buy(uint256 _id, uint256 _quantity) payable external {
        require(_quantity > 0, NegativeQuantity());
        require(getStock(_id) >= _quantity, FlawOfProduct());
        uint256 cost = _quantity * getPrice(_id);
        require(msg.value >= cost, NotEnoughtFunds());
        
        //buy
        _buyProcess(_msgSender(), _quantity, _id);

        if(cost < msg.value){
            payable(_msgSender()).transfer(cost-msg.value);
        }
    }

    function batchBuy(uint256[] calldata ids, uint256[] calldata quantitys) payable external {
        require(ids.length == quantitys.length, "array lens mismath");
        uint256 totalCost;
        for(uint i = 0; i< ids.length; i++){
            uint256 id = ids[i];
            uint256 q = quantitys[i];

            require(getStock(id) > q, FlawOfProduct());
            uint256 cost = q * getPrice(id);
            totalCost+=cost;
            require(msg.value >= cost, NotEnoughtFunds());

            _buyProcess(_msgSender(), q, id);
        }

        if(totalCost < msg.value){
            payable(_msgSender()).transfer(totalCost - msg.value);
        }


    }

    function _buyProcess(address _buyer, uint256 _quantity, uint256 _id) internal {
        Product storage product = findProduct(_id);
        product.stock -= _quantity;
        purchase[_buyer][product.id] += _quantity;
    }
    

    function addProduct(string calldata _name, uint256 _id, uint256 _stock, uint256 _price) public {
        require(!isIdExist(_id), IdAlreadyExist());
        products.push(Product(_name, _id, _stock, _price));
    }

    function deleteProduct(uint256 _id)external onlyOwner{
        require(isIdExist(_id), IdNotFound());
        products[findIndexById(_id)] = products[products.length-1];
        products.pop();
    }

    function findProduct(uint256 _id) internal view onlyOwner returns(Product storage product){
        for(uint256 i = 0; i < products.length; i++)
        {
            if(products[i].id == _id){
                return products[i];
            }
        }
        revert("Product not found");
    }

    function findIndexById(uint256 _id) internal view returns(uint256){
        for(uint256 i = 0; i < products.length; i++)
        {
            if(products[i].id == _id){
                return i;
            }
        }
        revert IdNotFound();

    }

    function updatePrice(uint256 _id, uint256 _price) external  {
        Product storage product = findProduct(_id);
        product.price = _price;

    }
     function updateStock(uint256 _id, uint256 _stock) external {
        Product storage product = findProduct(_id);
        product.stock = _stock;
     }

     function getPrice(uint256 _id) public  view returns(uint256) {
        Product storage product = findProduct(_id);
        return product.price;
     }

    function getStock(uint256 _id) internal view returns(uint256){
        Product storage product = findProduct(_id);
        return product.stock;

    }

    function isIdExist(uint256 _id) internal view returns(bool)
    {
        for(uint i = 0; i < products.length; i++)
        {
            if(products[i].id == _id){
                return true;
            }
        }
        return false;
    }
}