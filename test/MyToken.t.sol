//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MYTOKEN} from "../src/MYTOKEN.sol";
import {DeployMyToken} from "../script/DeployMYTOKEN.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract MyTokenTest is Test  {
  MYTOKEN public myToken;
  DeployMyToken public deployer;
  uint256 public constant INITIAL_SUPPLY = 1000 ether;
  uint256 public SEND_AMOUNT = 10 ether;
  address bob = makeAddr("bob");
  address tiho = makeAddr("tiho");


  function setUp() public {
    deployer = new DeployMyToken();
    myToken = new MYTOKEN(INITIAL_SUPPLY);

    vm.prank(address(this));
    myToken.transfer(bob, SEND_AMOUNT);
  }
  
  function testBobBalance() public {
      assertEq(myToken.balanceOf(bob), SEND_AMOUNT);
  }
  
  function testAllownaceWorks() public {
      vm.prank(bob);
      myToken.approve(tiho, SEND_AMOUNT);

      vm.prank(tiho);
      myToken.transferFrom(bob,tiho,SEND_AMOUNT);

      assertEq(myToken.balanceOf(tiho), SEND_AMOUNT);
  }
    function testInitialSupply() public {
        assertEq(myToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(myToken)).mint(address(this), 1);
    }

    function testTransfer() public {
        // Prepare test data
        uint256 initialSupply = myToken.totalSupply();
        uint256 transferAmount = initialSupply / 2;
        address recipient = address(bob); // Replace this with the desired recipient address

        // Perform the transfer
        vm.prank(address(this));
        myToken.transfer(recipient, transferAmount);

        // Check balances after transfer
        assertEq(myToken.balanceOf(address(this)), initialSupply - transferAmount);
        assertEq(myToken.balanceOf(recipient), transferAmount);
    }

    function testTransferFrom() public {
        // Prepare test data
        address owner = address(this);
        address spender = address(0x2); // Replace this with the desired spender address
        address recipient = address(0x3); // Replace this with the desired recipient address
        uint256 initialSupply = myToken.totalSupply();
        uint256 approvalAmount = initialSupply / 4;
        uint256 transferAmount = initialSupply / 8;

        // Approve the spender to spend on behalf of the owner
        myToken.approve(spender, approvalAmount);

        // Perform the transferFrom
        myToken.transferFrom(owner, recipient, transferAmount);

        // Check balances after transferFrom
        assertEq(myToken.balanceOf(owner), initialSupply - transferAmount);
        assertEq(myToken.balanceOf(recipient), transferAmount);

        // Check allowance after transferFrom
        assertEq(myToken.allowance(owner, spender), approvalAmount - transferAmount);
    }

    function testAllowance() public {
        // Prepare test data
        address owner = address(this);
        address spender = address(0x2); // Replace this with the desired spender address
        uint256 initialSupply = myToken.totalSupply();
        uint256 approvalAmount = initialSupply / 4;

        // Approve the spender to spend on behalf of the owner
        myToken.approve(spender, approvalAmount);

        // Check allowance after approval
        assertEq(myToken.allowance(owner, spender), approvalAmount);
    }

    function testDecreaseAllowance() public {
        // Prepare test data
        address owner = address(this);
        address spender = address(0x2); // Replace this with the desired spender address
        uint256 initialSupply = myToken.totalSupply();
        uint256 approvalAmount = initialSupply / 4;
        uint256 decreaseAmount = initialSupply / 8;

        // Approve the spender to spend on behalf of the owner
        myToken.approve(spender, approvalAmount);

        // Decrease the allowance
        myToken.decreaseAllowance(spender, decreaseAmount);

        // Check allowance after decreaseAllowance
        assertEq(myToken.allowance(owner, spender), approvalAmount - decreaseAmount);
    }

    function testIncreaseAllowance() public {
        // Prepare test data
        address owner = address(this);
        address spender = address(0x2); // Replace this with the desired spender address
        uint256 initialSupply = myToken.totalSupply();
        uint256 approvalAmount = initialSupply / 4;
        uint256 increaseAmount = initialSupply / 8;

        // Approve the spender to spend on behalf of the owner
        myToken.approve(spender, approvalAmount);

        // Increase the allowance
        myToken.increaseAllowance(spender, increaseAmount);

        // Check allowance after increaseAllowance
        assertEq(myToken.allowance(owner, spender), approvalAmount + increaseAmount);
    }

}