//SCRIPT ACCOUNTS
var movementType;

function functionViewCash(){
document.getElementById("cashView").style.display="block";
document.getElementById("cashNone").style.display="none";
}
function functionCashOut(){
movementType = "cashout";
}
function functionDeposit(){
movementType = "deposit";
}
function functionTransfer(){
movementType = "transfer";
}

