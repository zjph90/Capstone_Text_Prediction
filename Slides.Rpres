Johns Hopkins University Data Science Capstone Project - Next Word Prediction using N-grams
========================================================
author: John Howard
date: June 2016

Predictive Text Analytics
========================================================
Use statistical knowledge about a body - *corpus* - of text to predict how likely a particular word is to occur next in a new sequence. 

Many applications:  
- Automated Speech Recognition 
- Error Correction
- Text Input - Next Word Prediction

Here we are concerned with **Next Word Prediction** and how it might be used with a textual input tool such as the keyboard apps on a mobile phone.  

Prediction with N-grams
========================================================
**Markov Assumption** - Probability depends mostly on few preceding words.

Predict N'th word using previous N-1 words

Probability = Count(abc)/Count(ab*)  <- Maximum Likelihood

Smoothing - Need to "borrow" probability mass from seen N-grams and give this to unseen N-grams

**Kneser-Ney Smoothing** - interpolates across all levels of N-gram hierarchy. Uses *Continuation count* - better estimate of how likely a word is to follow another.

Shiny App 
========================================================

HC Corpus data prepared using *tm* and *RWeka* packages.

App uses principals of *Kneser-Ney* to derive list of candidate words given the supplied phrase.

Algorithm uses recursive function. Trivial to extend to higher order N-grams. Currently up to 4.

Need to compromise for size and speed. Cut lesser seen N-grams to ensure small memory footprint.

Treat unseen words by converting to wildcard (*)
 

References
========================================================
[My Shiny App](https://jph65.shinyapps.io/Capstone_Predict/)

[My Github Repo](https://github.com/zjph90/Capstone_Text_Prediction)

[HC Corpora](http://www.corpora.heliohost.org/)

[Stanford NLP Course](https://www.coursera.org/course/nlp)

[Chen-Goodman 1999](http://u.cs.biu.ac.il/~yogo/courses/mt2013/papers/chen-goodman-99.pdf)

[Kneser Ney Smoothing](http://www.foldl.me/2014/kneser-ney-smoothing/)
