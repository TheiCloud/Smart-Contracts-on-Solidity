// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

contract Vote {
    // адресс того, кто запутил контракт
    address public owner;
    // ["boba", "biba", "beba", "buba"] - кандидаты голосования
    string[] public names;
    // длительность голосования 
    uint256 public votingDuration;
    // булевое значение, активно ли голосование
    bool public stopVoting;
    //максимальное количесво голосов.
    uint256 public maxVotes;
    //текущее количество голосов
    uint256 public numberOfVotes = 0;

    // словарь адрес - голосовал ли 
    mapping(address => bool) public voters;
    // номер кандидата - количество голосов за него
    mapping(uint256 => uint256) public votes;

    error VoitingWasOver();
    error CantVoteTwise();
    error ElectorNotExist();
    error OwnerCantVotes();
    error MaxVotesAchive(uint256 _count);
    error OnlyOwner();
    error ErrorValue();
    error VoteIsActive();

    // проверяет, что функцию запустил owner
    modifier onlyOwner(){
        require(msg.sender == owner, OnlyOwner());
        _;
    }

    modifier positive(uint256 _value) {
        require(_value > 0, ErrorValue());
        _;
    }

    modifier voteIsActive() {
        require(!stopVoting, VoitingWasOver());
        _;
    }


    event LogVoid(address indexed who, uint256 whom);


    constructor(string[] memory _names, uint256 _votingDuration, uint256 _maxVotes) {
        names = _names;
        votingDuration = _votingDuration + block.timestamp;
        owner = msg.sender;
        maxVotes = _maxVotes;

    }

    function void(uint256 _number) public {

        require(block.timestamp < votingDuration, VoitingWasOver());
        require(numberOfVotes < maxVotes, MaxVotesAchive(maxVotes));
        require(voters[msg.sender] == false, CantVoteTwise());
        require(_number < names.length, ElectorNotExist());
        require(msg.sender != owner, OwnerCantVotes() );

        voters[msg.sender] = true;
        votes[_number] += 1;
        numberOfVotes += 1 ;

        emit LogVoid(msg.sender, _number);
    }

    function voidWinner() public view returns(uint256) {
        require(stopVoting == true, VoteIsActive());
        uint256 winnerIndex;
        for(uint256 i = 0; i < names.length; i++)
        {
            if(votes[i] > votes[winnerIndex]){
                winnerIndex = i;
            }
        }
        return(winnerIndex);
    }

    function stopVote() public onlyOwner voteIsActive{
        stopVoting = true;

    }

   function addTimeForVote(uint256 _addedTime) public onlyOwner positive(_addedTime) voteIsActive {
        votingDuration += _addedTime;
   }

   function reduceTime(uint256 _value) public onlyOwner positive(_value) voteIsActive {
        require(_value < votingDuration-block.timestamp);
        votingDuration -= _value;
   }

    function resetMaxVotes(uint256 _newMaxVotes) public onlyOwner voteIsActive{
        require(_newMaxVotes > numberOfVotes, ErrorValue());
        maxVotes = _newMaxVotes;

    }

    function getTime() public view returns(uint256){
        return (block.timestamp);
    }
}


