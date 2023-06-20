Usefully for encoding videos that you want to be embeddable, like in Discord.

Modify the the "crf" flag between 0–63 to change the constrained quality.
Modify the "deadline" flag between good and best to change speed of encode.
modify the "cpu-used" flag between 0-5 on good-best and 0-8 on realtime to change the efficiency of the encode.

The changes needs to be applied to both "params-pass1.txt" and "params-pass2.txt" with the exception of  the "pass" flag
