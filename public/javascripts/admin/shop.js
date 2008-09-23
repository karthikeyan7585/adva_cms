function togglePaymentMethod(checked, paymentMethodDivId){
	if(checked == true)
		document.getElementById(paymentMethodDivId).style.display = '';
	else
		document.getElementById(paymentMethodDivId).style.display = 'none';
}
