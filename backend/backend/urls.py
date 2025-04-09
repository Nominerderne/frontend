from django.urls import path
from appbackend import auth, edituser, book

urlpatterns = [
    path('user/', auth.checkService),
    path('useredit/', edituser.editcheckService),
    path('book/', book.editcheckService),
]
