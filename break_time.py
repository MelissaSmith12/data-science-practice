import time
import webbrowser

counter = 0
while counter < 3:
    time.sleep(10)
    webbrowser.open("https://www.youtube.com/watch?v=PSKQ3ZNQ_O8")
    counter += 1
