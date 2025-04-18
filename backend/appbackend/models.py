# from django.db import models

# class BookReview(models.Model):
#     book_id = models.CharField(max_length=100)
#     user_id = models.CharField(max_length=100)
#     username = models.CharField(max_length=100)
#     rating = models.IntegerField(default=0)
#     comment = models.TextField(blank=True)
#     created_at = models.DateTimeField(auto_now_add=True)

#     def as_dict(self):
#         return {
#             'user_id': self.user_id,
#             'username': self.username,
#             'rating': self.rating,
#             'comment': self.comment,
#             'created_at': self.created_at.strftime("%Y-%m-%d %H:%M"),
#         }