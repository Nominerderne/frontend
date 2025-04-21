from django.urls import path
from appbackend import auth, edituser, book, search, favorite, review, comment, readinghistory
from sendfile import sendfile
from django.http import HttpResponseNotFound
from django.conf import settings
from appbackend.views import stream_audio  # << энэ шугам нэмэх хэрэгтэй

def media_file(request, path):
    file_path = settings.MEDIA_ROOT + '/' + path
    try:
        return sendfile(request, file_path)
    except FileNotFoundError:
        return HttpResponseNotFound("File not found")

urlpatterns = [
    path('user/', auth.checkService),
    path('useredit/', edituser.editcheckService),
    path('book/', book.editcheckService),
    path("search/", search.searchBookService),
    path("search/options/", search.get_options),
    path('favorite/', favorite.favoriteService),
    path('review/', review.reviewService),
    path('comment/', comment.commentService),
    path('readinghistory/', readinghistory.editcheckService),
    path('stream/audio/<str:filename>', stream_audio),
    path('media/<path:path>/', media_file),
]

from django.conf.urls.static import static
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
