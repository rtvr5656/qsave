# QSave
Godot Save and Load functions

QSave is a godot 4.X script made to save and load a project data in a easier and faster way.

---

**How to setup**

1 - Copy the file qsave.gd to your project

2 - Add it to Project Settings -> Autoload

3 - Change the name to "QSave"

---

**How to save a file**

function:

```
QSave.s_save(data, save_location) # save_location isn't required if you want to save it as the default save location
```

recommended way:

```
print(QSave.s_save(data))
```

That way it'll print any possible error.

---

**How to load a file**

function:

```
QSave.s_load(load_location) # load_location isn't required if you want to load it from the default save location
```

recommended way:

```
var data : Dictionary

func _ready():
  data = QSave.s_load()
```
