from crispy_forms.layout import Layout, Field
from django import forms
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Submit

class ContactForm(forms.Form):
    name = forms.CharField(label='Your name', max_length=100)
    email = forms.EmailField(label='Your email')
    message = forms.CharField(label='Your message', widget=forms.Textarea)
    def __init__(self, *args, **kwargs):
        super(ContactForm, self).__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_id = 'id-contact-form'
        self.helper.form_method = 'post'
        self.helper.layout = Layout(
            Field('name', css_class='form-control'),
            Field('email', css_class='form-control'),
            Field('message', css_class='form-control'),
        )
        self.helper.add_input(Submit('submit', 'Send message'))