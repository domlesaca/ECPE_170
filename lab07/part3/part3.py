from subprocess import call

if __name__ == '__main__':
    i = 256
    while i <= 2048:
        call(["./matrix_math", '1',  str(i)])

        call(["./matrix_math", '2', str(i)])
        i += 256
