from django.urls import path
from appbackend import auth, edituser

urlpatterns = [
    path('user/', auth.checkService),
    path('useredit/', edituser.editcheckService),
]
