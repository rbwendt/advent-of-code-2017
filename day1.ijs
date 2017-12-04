removesingles=: 13 : 'y #~ 1 < #@> y'
boxconsecutive=: (<;.2~1,~2&(~:/\))
13 : '+/ +/ > }: each removesingles boxconsecutive y'

NB. To get the answer, you have to save the input string with the first number duplicated at the end, then call adder.


NB. Part 2.

extractmod2s=: 13 : 'x #~ (1 - mod2 #@> x)'
reorder1 =: 13 : ',(|: (>(2;((#y)*0.5))) $ y)'
reorder2 =: 13 : '(|: (>(2;((#y)*0.5))) $ y)'
+/ +/ > extractmod2s boxconsecutive reorder1 d
pair2 =: 13 : '_2 <@:]\ y'
filter2 =: #~ =/ &>
+/ +/ > filter2 pair2 , reorder2 d NB. working solution
