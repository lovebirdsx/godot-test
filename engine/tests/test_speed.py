import time

start_time = time.time()

sum = 0
for i in range(1, 100000001):
    sum += i

end_time = time.time()
print('Python:', end_time - start_time, 'seconds')
print('Sum =', sum)
