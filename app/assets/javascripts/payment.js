$(function(){
  registration_payment.setupForm();
});

var registration_payment = {
  setupForm: function(){
    $("#new_user").submit(function(e){
      var $form = $(this);
      $form.find('button').prop('disabled', true);

      Stripe.card.createToken($form, registration_payment.stripeResponseHandler);

      return false;
    });
  },

  stripeResponseHandler: function(status, response){
    var $form = $('#new_user');

    if(response.error) {
      $form.find('.payment-errors').text(response.error.message);
      $form.find('button').prop('disabled', false);
    }else{
      var token = response.id;
      $form.append($('<input type="hidden" name="stripeToken" />').val(token));
      $form.get(0).submit();
    }


  }
};

