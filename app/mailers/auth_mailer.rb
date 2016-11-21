class AuthMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, options={})
    # Use different e-mail templates for signup e-mail confirmation and for when a user changes e-mail address.
    if record.pending_reconfirmation?
      options[:template_name] = 'reconfirmation_instructions'
    else
      options[:template_name] = 'confirmation_instructions'
    end

    super
  end
end