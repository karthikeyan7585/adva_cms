function toggleAddress(radio_name, div_id){
	if(radio_name == 'new')
		document.getElementById(div_id).style.display = '';
	else
		document.getElementById(div_id).style.display = 'none';
}

function toggleShippingAddress(checked, div_id){
	if(checked==true)
		document.getElementById(div_id).style.display = 'none';
	else
		document.getElementById(div_id).style.display = '';
}

function togglePaymentMethods(selectedPayment, otherPayment1, otherPayment2, submit_icon){
	document.getElementById(selectedPayment).style.display = '';
	document.getElementById(otherPayment1).style.display = 'none';
	document.getElementById(otherPayment2).style.display = 'none';
	if (selectedPayment == "paypal_checkout_button")
		document.getElementById(submit_icon).style.display = 'none';
	else
		document.getElementById(submit_icon).style.display = '';
}
