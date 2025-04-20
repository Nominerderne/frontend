from django.urls import path
from appbackend import auth, edituser, book, search, favorite, review, comment

urlpatterns = [
    path('user/', auth.checkService),
    path('useredit/', edituser.editcheckService),
    path('book/', book.editcheckService),
    path("search/", search.searchBookService),
    path("search/options/", search.get_options),
    path('favorite/', favorite.favoriteService),
    path('review/', review.reviewService),
    path('comment/',comment.commentService),
]
from django.conf import settings
from django.conf.urls.static import static

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
