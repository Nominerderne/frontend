from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json

favorite_books = []  # Түр хадгалах санах ой

@csrf_exempt
def favoriteService(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        action = data.get('action')

        if action == 'add':
            book = data.get('book')
            if book:
                if book not in favorite_books:
                    favorite_books.append(book)
                return JsonResponse({'message': 'Ном хадгалагдлаа', 'data': book}, status=200)
            return JsonResponse({'message': 'Номын мэдээлэл дутуу байна'}, status=400)

        elif action == 'get':
            return JsonResponse({'data': favorite_books}, status=200)

        return JsonResponse({'message': 'Action олдсонгүй'}, status=400)

    return JsonResponse({'message': 'POST хүсэлт биш байна'}, status=405)
