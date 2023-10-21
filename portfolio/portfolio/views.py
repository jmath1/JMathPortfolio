import json

import boto3
from django.conf import settings
from django.core.mail import send_mail
from django.http import HttpResponse
from django.shortcuts import redirect, render

from portfolio.forms import ContactForm


def home(request):
    return render(request, 'home.html', {})

def about(request):
    return render(request, 'about.html', {})

def healthcheck(request):
    return HttpResponse("OK")

def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            # Collect form data
            name = form.cleaned_data['name']
            email = form.cleaned_data['email']
            message = form.cleaned_data['message']

            # Publish a message to the SNS topic
            sns = boto3.client('sns', region_name=settings.AWS_S3_REGION_NAME)
            topic_arn = settings.SNS_EMAIL_TOPIC_ARN
            message_data = {
                'Name': name,
                'Email': email,
                'Message': message,
            }
            response = sns.publish(
                TopicArn=topic_arn,
                Message=json.dumps({'default': json.dumps(message_data)}),
                MessageStructure='json'
            )

            # Check the SNS response if needed

            return HttpResponse('Thank you for your message!')
            # Redirect after successful form submission
            return redirect('success_page')  # Create a success page URL in your URLs configuration

    else:
        form = ContactForm()

    return render(request, 'contact.html', {'form': form})