Colores Bonitos
git config --global color.ui true

Iniciar repositorio
git init repositorio

Concatenar un commit
git commit --amend

Log
git log --oneline --graph

Resetear el proyecto
git reset --mixed head-Log

Resetear hard el proyecto
git reset --hard head-Log

Rama crear
git branch nombre

Borrar Rama
git branch -d nombre

Borrar Rama Forzada
git branch -D nombre

Lista Ramas
git branch -l

Renombrar Ramas
git branch -m nombre nuevoNombre

Moverse entre ramas
git checkout Nombre

Moverse entre commits
git checkout HEAD

Crea rama y se mueve en ella
git checkout -b nuevaRama

Mezclar Ramas
git merge rama

Guarda archivos temporales y te mueves entre rama
git stash

Lista cambios temporales
git stash list

Borrar cambios temporales
git stash drop stash{x}

Guarda cambios temporales
git stash apply


Mostrar cambios
git diff HEAD

Reescribir la historia
git rebase nombreRama

