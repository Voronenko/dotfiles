# portions of https://github.com/Voronenko/znotebook


In Ipython, first,

import iplantuml
then, create a cell like,

%%plantuml

@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response
@enduml
