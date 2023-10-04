from django.shortcuts import render, redirect
from django.core.mail import send_mail
from django.conf import settings
from portfolio.forms import ContactForm

def home(request):
    return render(request, 'home.html', {})

def about(request):
    return render(request, 'about.html', {})

def contact(request):
    if request.method == "POST":
        form = ContactForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            email = form.cleaned_data['email']
            message = form.cleaned_data['message']

            # Compose and send the email
            subject = f"Contact Form Submission from {name}"
            message = f"From: {email}\n\nMessage:\n{message}"
            from_email = settings.EMAIL_HOST_USER
            recipient_list = ['your-email@example.com']

            send_mail(subject, message, from_email, recipient_list, fail_silently=False)

            # Redirect after successful form submission
            return redirect('success_page')  # Create a success page URL in your URLs configuration

    else:
        form = ContactForm()

    return render(request, 'contact.html', {'form': form})