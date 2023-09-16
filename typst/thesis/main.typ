#import "@local/thesis:1.0.0": *

#import "./includes.typ": *

#show: thesis.with(
  title: "Use of coinduction in the analysis and optimization\n of imperative languages",
  author: "Edoardo Marangoni",
  figure: align(bottom, image("./figures/Minerva.png", width: 28%)),
  university: "University of Milan",
  degree: "Master of Science",
  msg: [ 

    #v(0.4fr)
  #align(right, text(style: "italic", 
   ["...I can hardly understand, for instance, how a young man can decide to ride over 

   to the next village without being afraid that, quite apart from accidents, 

   even the span of a normal life that passes happily may be totally 

   insufficient for such a ride."]))
  #align(right, "Franz Kafka")

    #v(1fr)
  #smallcaps("no generative artificial intelligence was used in
  this work.")

  ]
)


#include "./chapters/index.typ"

#bibliography("./db.yaml", title: [Bibliography], style: "mla")
#show bibliography: set text(8pt)
