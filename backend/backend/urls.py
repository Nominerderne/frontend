from django.urls import path
from appbackend import auth, edituser, book, search, favorite, review

urlpatterns = [
    path('user/', auth.checkService),
    path('useredit/', edituser.editcheckService),
    path('book/', book.editcheckService),
    path("search/", search.searchBookService),
    path("search/options/", search.get_options),
    path('favorite/', favorite.favoriteService),
    path('review/', review.reviewService),
]
