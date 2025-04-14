from django.http.response import JsonResponse
from django.shortcuts import render
from datetime import datetime
from django.http import JsonResponse
import json
from django.views.decorators.csrf import csrf_exempt
from backend.settings import sendMail, sendResponse ,disconnectDB, connectDB, resultMessages,generateStr


def dt_getallbook(request):
    jsons = json.loads(request.body) 
    action = jsons['action']
    myConn = connectDB() 
    try: 
        cursor = myConn.cursor() 
        query = F"""SELECT id, type, name, date, img_url, score, height, duration, title, turul, review
	                FROM public.books;
                """ 
        cursor.execute(query) 
        columns = cursor.description 
        respRow = [{columns[index][0]:column for index, 
            column in enumerate(value)} for value in cursor.fetchall()] 
        cursor.close() 
        resp = sendResponse(request, 200, respRow, action)
    except Exception as e:
        resp = sendResponse(request, 5000, [], action) 
        
    finally:
        disconnectDB(myConn) 
        return resp 
#dt_getuserinfo
    

@csrf_exempt # method POST uyd ajilluulah csrf
def editcheckService(request): # hamgiin ehend duudagdah request shalgah service
    print(request)
    if request.method == "POST": # Method ni POST esehiig shalgaj baina
        try:
            # request body-g dictionary bolgon avch baina
            jsons = json.loads(request.body)
            print(jsons)
        except:
            # request body json bish bol aldaanii medeelel butsaana. 
            action = "no action"
            respdata = [] 
            resp = sendResponse(request, 3003, respdata) 
            return JsonResponse(resp) 
            
        try: 
            #jsons-s action-g salgaj avch baina
            action = jsons["action"]
        except:
            # request body-d action key baihgui bol aldaanii medeelel butsaana. 
            action = "no action"
            respdata = [] 
            resp = sendResponse(request, 3005, respdata,action) 
            return JsonResponse(resp)
        
        if action == "getallbook":
            result = dt_getallbook(request)
            return JsonResponse(result)
        else:
            action = "no action"
            respdata = []
            resp = sendResponse(request, 3001, respdata, action)
            return JsonResponse(resp)
    
    # Method ni POST bish bol ajillana
    else:
        #GET, POST-s busad uyd ajillana
        action = "no action"
        respdata = []
        resp = sendResponse(request, 3002, respdata, action)
        return JsonResponse(resp)
