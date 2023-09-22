from django.shortcuts import render

def home(request):
    # Your view logic here
    context = {
        'variable1': 'Hello',
        'variable2': 'World',
    }
    return render(request, 'home.html', context)