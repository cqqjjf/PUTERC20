pragma solidity ^0.4.24;

/*  ERC 20 token */
contract PUTToken {
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
	string public constant name = "Personal Ultimate Token";
    string public constant symbol = "PUT";
    uint8 public decimals = 18;
    string  version = "1.0";
	// contracts
    address manager;
	uint256 thetotalSupply;
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	
	    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
	
	constructor(uint256 total) public
	{
		manager = msg.sender;
		thetotalSupply= total;
		balances[manager]=total;
	}
	function totalSupply() public view returns (uint256 tSupply)
	{
		return thetotalSupply;
	}
	
	 function increaseSupply (uint256 _value)  public{
		require(_value > 0 &&_value < 10000000000000000000000000);
		require(msg.sender == manager);
        thetotalSupply = add(thetotalSupply, _value);
        balances[msg.sender] = add(balances[msg.sender],_value);
    }
 
	function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
	
	function transfer(address _to, uint256 _value) public returns (bool success) {
	    require(_value > 0 &&_value < 10000000000000000000000000);
		require(balances[msg.sender] >= _value);
		
		uint256 oldtotal= add(balances[msg.sender],balances[_to]);
		balances[msg.sender] = sub(balances[msg.sender],_value);
		balances[_to] = add(balances[_to] ,_value);
		require(balances[_to] + balances[msg.sender] == oldtotal);
		emit Transfer(msg.sender, _to, _value);
		return true;
    }
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(_value > 0 &&_value < 10000000000000000000000000);
		require(balances[_from] >= _value);
		require(allowed[_from][msg.sender] >= _value);
		uint256 oldtotal= add(balances[_from],balances[_to]);
		balances[_from] = sub(balances[_from],_value);
		allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],_value);
		balances[_to] = add(balances[_to],_value);
		require(balances[_from] + balances[_to] == oldtotal);
		emit Transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
	    require(_value > 0 &&_value < 10000000000000000000000000);
		require(balances[msg.sender] >= _value);
        allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender],_value);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
	
	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}