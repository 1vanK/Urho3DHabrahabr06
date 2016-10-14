:: Указываем путь к git.exe.
set "PATH=c:\Program Files (x86)\Git\bin\"
:: Скачиваем репозиторий.
git clone https://github.com/Urho3D/Urho3D.git
:: Переходим в папку со скачанными исходниками.
cd Urho3D
:: Возвращаем состояние репозитория к определённой версии (13 октября 2016).
git reset --hard 31744b797caf60025d192e7be3ee5e791221669d
:: Ждём нажатия ENTER для закрытия консоли.
pause
