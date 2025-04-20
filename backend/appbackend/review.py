# from django.views.decorators.csrf import csrf_exempt
# from django.http import JsonResponse
# import json
# from datetime import datetime

# # Түр хадгалах бүтэц: { user_id: { book_id: rating } }
# book_ratings_by_user = {}
# book_reviews_data = []  # [{ user_id, book_id, rating, comment, created_at, username }]

# @csrf_exempt
# def reviewService(request):
#     if request.method == 'POST':
#         data = json.loads(request.body)
#         action = data.get('action')
#         user_id = str(data.get('user_id'))
#         book_id = str(data.get('book_id'))

#         if not user_id or not book_id:
#             return JsonResponse({'message': 'ID дутуу байна'}, status=400)

#         if action == 'rate':
#             rating = data.get('rating')
#             if rating is None or not (1 <= int(rating) <= 5):
#                 return JsonResponse({'message': 'Үнэлгээ 1-5 хооронд байх ёстой'}, status=400)

#             # Үнэлгээг хадгалах
#             user_ratings = book_ratings_by_user.setdefault(user_id, {})
#             user_ratings[book_id] = int(rating)

#             # Комментгүй үнэлгээ хадгалах
#             book_reviews_data.append({
#                 'user_id': user_id,
#                 'book_id': book_id,
#                 'rating': rating,
#                 'comment': '',  # сэтгэгдэл оруулах бол энэ хэсгийг өөрчилнө
#                 'created_at': datetime.now().strftime("%Y-%m-%d %H:%M"),
#                 'username': f"user_{user_id}"
#             })

#             return JsonResponse({'message': 'Үнэлгээ хадгалагдлаа', 'rating': rating}, status=200)

#         elif action == 'get':
#             user_rating = book_ratings_by_user.get(user_id, {}).get(book_id, 0)
#             reviews = [r for r in book_reviews_data if r['book_id'] == book_id]
#             return JsonResponse({
#                 'user_rating': user_rating,
#                 'reviews': reviews,
#             }, status=200)

#         return JsonResponse({'message': 'Action буруу байна'}, status=400)

#     return JsonResponse({'message': 'POST л зөвшөөрнө'}, status=405)



# #review.py
# from django.views.decorators.csrf import csrf_exempt
# from django.http import JsonResponse
# import json
# from datetime import datetime

# # Түр хадгалах бүтэц: { user_id: { book_id: rating } }
# book_ratings_by_user = {}
# book_reviews_data = []  # [{ user_id, book_id, rating, comment, created_at, username }]

# @csrf_exempt
# def reviewService(request):
#     if request.method == 'POST':
#         data = json.loads(request.body)
#         action = data.get('action')
#         user_id = str(data.get('user_id'))
#         book_id = str(data.get('book_id'))

#         if not user_id or not book_id:
#             return JsonResponse({'message': 'ID дутуу байна'}, status=400)

#         if action == 'rate':
#             rating = data.get('rating')
#             comment = data.get('comment', '')  # ← ✨ comment
#             if rating is None or not (1 <= int(rating) <= 5):
#                 return JsonResponse({'message': 'Үнэлгээ 1-5 хооронд байх ёстой'}, status=400)

#             # Үнэлгээг хадгалах
#             user_ratings = book_ratings_by_user.setdefault(user_id, {})
#             user_ratings[book_id] = int(rating)

#             # Хэрэв өмнө нь rate хийсэн бол update
#             existing = next((r for r in book_reviews_data if r['user_id'] == user_id and r['book_id'] == book_id), None)
#             if existing:
#                 existing['rating'] = rating
#                 existing['comment'] = comment
#                 existing['created_at'] = datetime.now().strftime("%Y-%m-%d %H:%M")
#             else:
#                 book_reviews_data.append({
#                     'user_id': user_id,
#                     'book_id': book_id,
#                     'rating': rating,
#                     'comment': comment,
#                     'created_at': datetime.now().strftime("%Y-%m-%d %H:%M"),
#                     'username': f"user_{user_id}"
#                 })

#             return JsonResponse({'message': 'Үнэлгээ хадгалагдлаа', 'rating': rating}, status=200)

#         elif action == 'get':
#             user_rating = book_ratings_by_user.get(user_id, {}).get(book_id, 0)
#             reviews = [r for r in book_reviews_data if r['book_id'] == book_id]
#             return JsonResponse({
#                 'user_rating': user_rating,
#                 'reviews': reviews,
#             }, status=200)

#         return JsonResponse({'message': 'Action буруу байна'}, status=400)

#     return JsonResponse({'message': 'POST л зөвшөөрнө'}, status=405)


from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from datetime import datetime

# Түр хадгалах жагсаалт
book_reviews_data = []

@csrf_exempt
def reviewService(request):
    if request.method != 'POST':
        return JsonResponse({'message': 'POST хүсэлт илгээнэ үү'}, status=405)

    data = json.loads(request.body.decode('utf-8'))
    action = data.get('action')

    if action == 'rate':
        user_id = data.get('user_id')
        book_id = data.get('book_id')
        rating = data.get('rating')
        comment = data.get('comment', '')

        if not user_id or not book_id or not rating:
            return JsonResponse({'message': 'Мэдээлэл дутуу байна'}, status=400)

        book_reviews_data.append({
            'user_id': user_id,
            'book_id': book_id,
            'rating': rating,
            'comment': comment,
            'created_at': datetime.now().strftime("%Y-%m-%d %H:%M"),
            'username': f"user_{user_id}"
        })

        return JsonResponse({'message': 'Үнэлгээ хадгалагдлаа'}, status=200)

    elif action == 'comment':
        user_id = data.get('user_id')
        book_id = data.get('book_id')
        comment = data.get('comment', '')

        if not user_id or not book_id or not comment.strip():
            return JsonResponse({'message': 'Сэтгэгдэл хоосон байна'}, status=400)

        book_reviews_data.append({
            'user_id': user_id,
            'book_id': book_id,
            'rating': 0,
            'comment': comment,
            'created_at': datetime.now().strftime("%Y-%m-%d %H:%M"),
            'username': f"user_{user_id}"
        })

        return JsonResponse({'message': 'Сэтгэгдэл хадгалагдлаа'}, status=200)

    elif action == 'get':
        user_id = data.get('user_id')
        book_id = data.get('book_id')

        user_rating = 0
        reviews = []

        for review in book_reviews_data:
            if review['book_id'] == book_id:
                reviews.append(review)
                if review['user_id'] == user_id and review['rating'] > 0:
                    user_rating = review['rating']

        return JsonResponse({
            'user_rating': user_rating,
            'reviews': reviews
        }, status=200)

    return JsonResponse({'message': 'Танигдаагүй үйлдэл'}, status=400)
