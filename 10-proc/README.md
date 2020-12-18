# otus-linux-les-8
## Управление процессами


### Файлы  
1. [ps.sh] - своя реализацию ps ax используя анализ /proc  
2. [lsof.sh] - своя реализацию lsof  
3. [myfork.py] - в myfork.py добавлена обработка сигнала SIGINT (номер 2, например при Ctrl+C)
4. [compare.sh ionice] - 2 конкурирующих процесса по IO с разными ionice  
для запуска использовать ./compare.sh  
вывод консоли:  
```
real    0m0,232s
user    0m0,220s
sys     0m0,011s
nice complete

real    0m0,235s
user    0m0,207s
sys     0m0,021s
notnice complete

```  
4. [compare.sh nice] - 2 конкурирующих процесса по CPU с разными nice  
для запуска использовать ./compare.sh  
вывод консоли:  
```
real    0m0,252s
user    0m0,251s
sys     0m0,001s
notnice complete

real    0m0,206s
user    0m0,194s
sys     0m0,011s
nice complete

```


[ps.sh]:https://github.com/octokama/otus-linux/blob/main/10-proc/ps.sh
[lsof.sh]:https://github.com/octokama/otus-linux/blob/main/10-proc/lsof.sh
[myfork.py]:https://github.com/octokama/otus-linux/blob/main/10-proc/myfork.py
[compare.sh ionice]:https://github.com/octokama/otus-linux/blob/main/10-proc/ionice/compare.sh
[compare.sh nice]:https://github.com/octokama/otus-linux/blob/main/10-proc/nice/compare.sh