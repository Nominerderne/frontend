from django.http import StreamingHttpResponse, Http404
import os
import re

def stream_audio(request, filename):
    file_path = os.path.join('media/audio', filename)

    if not os.path.exists(file_path):
        raise Http404

    file_size = os.path.getsize(file_path)
    range_header = request.headers.get('Range', '').strip()
    
    content_type = 'audio/mpeg'

    if range_header:
        range_match = re.match(r'bytes=(\d+)-(\d*)', range_header)
        if range_match:
            start = int(range_match.group(1))
            end = range_match.group(2)
            end = int(end) if end else file_size - 1
            length = end - start + 1

            with open(file_path, 'rb') as f:
                f.seek(start)
                data = f.read(length)

            response = StreamingHttpResponse(data, status=206, content_type=content_type)
            response['Content-Range'] = f'bytes {start}-{end}/{file_size}'
            response['Content-Length'] = str(length)
            response['Accept-Ranges'] = 'bytes'
            return response

    # No Range header
    with open(file_path, 'rb') as f:
        data = f.read()

    response = StreamingHttpResponse(data, content_type=content_type)
    response['Content-Length'] = str(file_size)
    response['Accept-Ranges'] = 'bytes'
    return response
