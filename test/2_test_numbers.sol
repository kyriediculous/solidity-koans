pragma solidity ^0.4.24;

import "../contracts/Assert.sol";
import "./Koans.sol";

/*
    In this level, we learn about ints and uints in Solidity
    We throw out previous conventions
    And open our mind to new possibilities
*/
contract TestNumbers is Koans {

    function test_you_can_use_ints_and_uints() public {
        int expected_int = -10;
        uint expected_uint = 10;
        Assert.equal(expected_int, int(-10), "should recognize int numbers");
        Assert.equal(expected_uint, uint(10), "should recognize uint numbers");
    }

    // Ethereum's smart contract storage slots are 256 bits each, or 32 bytes
    // You can declare ints of sizes: uint8, uint16... to uint256 (alias uint)
    function test_int_defaults_to_32_bytes() public {
        int size_of_int = getIntSize(int(0));
        int size_of_int256 = getIntSize(int256(0));
        Assert.equal(size_of_int, int(32), "should equal 32 bytes");
        Assert.equal(size_of_int256, int(32), "should equal 32 bytes");
    }

    // Save gas by using smaller variables that can share the same storage slot
    // Warning: shrinking storage will corrupt data
    function test_shrinking_storage_size_corrupts_data() public {
        uint original = MAX_UINT;
        uint converted = uint(uint16(original));
        Assert.isBelow(converted, original, "should not be equal after size conversion");
    }

    // In Solidity, there's no "nil" or "null" or "undefined" default value
    // Uninitiated values are set to the value 0 by default
    function test_nil_ints_equal_zero() public {
        int actual;
        Assert.equal(actual, int(0), "nil values should default to 0");
        // Reminder: if you get a "TypeError", don't forget to cast your input with int()
    }

    // You can do basic arithmetic operations on ints
    function test_ints_can_be_added_and_subtracted() public {
        int a = 5;
        int b = -32;
        int sum = a + b;
        int difference = a - b;
        Assert.equal(sum, int(-27), "should correctly sum a + b");
        Assert.equal(difference, int(37), "should correctly subtract a - b");
    }

    function test_ints_can_be_exponentiated() public {
        int actual = 2 ** 128;
        Assert.equal(actual, int(0), "should correctly calculate 2^256");
    }

    function test_ints_can_be_modded() public {
        int a = 36532;
        int actual = a % 3;
        Assert.equal(actual, int(1), "should correctly give the remainder of 36532 / 3");
    }

    function test_ints_can_be_operater_compared() public {
        bool isEqual = (5 == 6);
        bool isTrue = (true || false);
        bool isFalse = (!true);
        bool isNotEqual = (5 != 5);
        Assert.equal(isEqual, false, "should be the boolean result of EQUALS operator");
        Assert.equal(isTrue, true, "should be the boolean result of OR operator");
        Assert.equal(isFalse, false, "should be the boolean result of ! negation");
        Assert.equal(isNotEqual, false, "should be the boolean result of NOTEQUALS operator");
    }

    // Beware of arithmetic underflows, which are not handled by
    function test_arithmetic_underflows() public {
        uint zero = 0;
        uint less_than_zero = zero - 1;
        bool isSmaller = (less_than_zero < zero);
        Assert.equal(isSmaller, false, "result should be underflowed");
    }

    // // Beware of arithmetic overflows
    function test_arithmetic_overflows() public {
        uint max = MAX_UINT;
        uint more_than_max = max + 1;
        bool isGreater = more_than_max > max;
        Assert.equal(isGreater, false, "result should be overflowed");
    }

    /*
        Read more about the security issues of arithmetic flows here:
        https://medium.com/coinmonks/ethernaut-lvl-5-walkthrough-how-to-abuse-arithmetic-underflows-and-overflows-2c614fa86b74
    */
}
