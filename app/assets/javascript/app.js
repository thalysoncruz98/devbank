//SCRIPT ACCOUNTS
var movementType;

//Logic to view and hide the current value
function functionViewCash(){
  number = document.getElementById("cashView");
  character = document.getElementById("cashNone");

  if(number.style.display != "block"){
  number.style.display = "block";
  character.style.display = "none";
  }else{
  number.style.display = "none";
  character.style.display = "block";
  }
}

//Functions for movement type
function functionCashOut(){
  movementType = "cashout";
}
function functionDeposit(){
  movementType = "deposit";
}
function functionTransfer(){
  movementType = "transfer";
}

//Script for movement pages
function myfunction(){
  document.getElementById("movement").style.display="none";
  document.getElementById("movementConfirm").style.display="block";
  document.getElementById("cashButtons").style.display="none";
}