# Fedora Uzerinde Excalidraw ve Podman Kullanimi

Bu dosya, Excalidraw'i Fedora uzerinde sisteme zarar vermeden calistirmak ve daha sonra Podman container'larini CLI veya GUI ile takip edebilmek icin hazirlandi.

Bu kurulumda Excalidraw host sisteme Node/Yarn kurmadan, rootless Podman container'i icinde calisir.

## 1. Mevcut Excalidraw Durumu

Kullanilan image adi:

```bash
local/excalidraw:fedora-safe
```

Kullanilan container adi:

```bash
excalidraw-local
```

Mevcut adres:

```text
http://127.0.0.1:3000
```

Bu adres sadece kendi bilgisayarindan erisilebilir. Agdaki baska cihazlara acik degildir.

## 2. En Kisa Gunluk Kullanim

Excalidraw'i acmak icin:

```bash
podman start excalidraw-local
```

Tarayicida ac:

```text
http://127.0.0.1:3000
```

Excalidraw'i kapatmak icin:

```bash
podman stop excalidraw-local
```

Durumu kontrol etmek icin:

```bash
podman ps --filter name=excalidraw-local
```

## 3. Bilgisayari Yeniden Baslattiktan Sonra

Bilgisayari yeniden baslattiktan sonra container otomatik acilmayabilir.

Tekrar calistirmak icin:

```bash
podman start excalidraw-local
```

Sonra tarayicida:

```text
http://127.0.0.1:3000
```

Eger calisip calismadigindan emin olmak istersen:

```bash
podman ps --filter name=excalidraw-local
```

## 4. Ilk Kurulum Komutlari

Bu adimlar bu makinede bir kez yapildi. Yeniden kurman gerekirse proje klasorunde calistir:

```bash
cd /mnt/local/projects/excalidraw
podman build -t local/excalidraw:fedora-safe .
podman rm -f excalidraw-local
podman run -d --name excalidraw-local -p 127.0.0.1:3000:80 local/excalidraw:fedora-safe
```

Ac:

```text
http://127.0.0.1:3000
```

## 5. Port Numarasini Degistirmek

Podman'da calisan bir container'in port baglantisi sonradan direkt degistirilmez. Portu degistirmek icin container silinip ayni image ile yeniden olusturulur.

Bu islem image'i silmez. Sadece container yeniden olusturulur.

Ornek: `3000` yerine `8080` portunu kullanmak istersen:

```bash
podman stop excalidraw-local
podman rm excalidraw-local
podman run -d --name excalidraw-local -p 127.0.0.1:8080:80 local/excalidraw:fedora-safe
```

Sonra tarayicida:

```text
http://127.0.0.1:8080
```

Tekrar `3000` portuna donmek istersen:

```bash
podman stop excalidraw-local
podman rm excalidraw-local
podman run -d --name excalidraw-local -p 127.0.0.1:3000:80 local/excalidraw:fedora-safe
```

Port mantigi:

```text
127.0.0.1:3000:80
```

Anlami:

- `127.0.0.1`: Sadece bu bilgisayar erisebilir.
- `3000`: Host sistemde acilan port.
- `80`: Container icindeki nginx portu.

Guvenli kullanim icin `127.0.0.1` kullanmaya devam et.

## 6. Podman CLI ile Container Takibi

Calisan container'lari listele:

```bash
podman ps
```

Tum container'lari listele:

```bash
podman ps -a
```

Image'lari listele:

```bash
podman images
```

Excalidraw loglarini gor:

```bash
podman logs excalidraw-local
```

Loglari canli izle:

```bash
podman logs -f excalidraw-local
```

Canli kaynak kullanimini izle:

```bash
podman stats
```

Container icindeki process'leri gor:

```bash
podman top excalidraw-local
```

Port baglantisini gor:

```bash
podman port excalidraw-local
```

Detayli teknik bilgi al:

```bash
podman inspect excalidraw-local
```

Container'a shell ile girmek icin:

```bash
podman exec -it excalidraw-local sh
```

Cikmak icin:

```bash
exit
```

## 7. Podman Container Yasam Dongusu

Yeni container olusturup arka planda calistir:

```bash
podman run -d --name excalidraw-local -p 127.0.0.1:3000:80 local/excalidraw:fedora-safe
```

Durdur:

```bash
podman stop excalidraw-local
```

Baslat:

```bash
podman start excalidraw-local
```

Yeniden baslat:

```bash
podman restart excalidraw-local
```

Sil:

```bash
podman rm excalidraw-local
```

Zorla sil:

```bash
podman rm -f excalidraw-local
```

Image sil:

```bash
podman rmi local/excalidraw:fedora-safe
```

Kullanilmayan Podman nesnelerini temizle:

```bash
podman system prune
```

Bu komut kullanilmayan container, network ve cache verilerini temizler. Calisan container'lara dokunmaz ama yine de dikkatli kullan.

## 8. GUI ve TUI ile Podman Takibi

Podman'i komut satiri disinda takip etmek icin uc pratik secenek vardir:

- Podman Desktop: Masaustu GUI uygulamasi.
- Cockpit + cockpit-podman: Tarayicidan acilan web paneli.
- podman-tui: Terminal icinde calisan gorsel arayuz.

Bu makinede kontrol edilen durum:

- `podman` kurulu.
- `podman-desktop` Fedora deposunda bulunmadi.
- `cockpit` ve `cockpit-podman` kurulu degil.
- `podman-tui` Fedora deposunda var.

### Neden `sudo dnf install podman-desktop` hata verdi?

Fedora 44 depolarinda `podman-desktop` adinda uygun bir RPM paketi bulunmadigi icin su hata gelir:

```text
No match for argument: podman-desktop
```

Bu hata Podman'in bozuk oldugu anlamina gelmez. Sadece `dnf` bu paket adini mevcut Fedora depolarinda bulamiyor demektir.

### Secenek A: Podman Desktop

Podman Desktop masaustu uygulamasidir. Container, image, volume ve loglari grafik arayuzden gormek icin kullanilir.

Bu makinede su anda kurulu degil. Fedora 44 tarafinda `sudo dnf install podman-desktop` komutu calismadi, cunku paket depoda yok.

Kontrol:

```bash
rpm -q podman-desktop
```

Flatpak ve Flathub kontrolu:

```bash
flatpak remotes
```

Bu makinede Flatpak var ve Flathub remote'u gorunuyor. Bu yuzden Podman Desktop icin onerilen yol Flatpak'tir.

Flatpak ile kur:

```bash
flatpak install flathub io.podman_desktop.PodmanDesktop
```

Eger Flathub ekli degilse once ekle:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Sonra tekrar kur:

```bash
flatpak install flathub io.podman_desktop.PodmanDesktop
```

Calistirmak icin uygulama menulerinden `Podman Desktop` acilir.

Terminalden acmak istersen:

```bash
flatpak run io.podman_desktop.PodmanDesktop
```

Ne ise yarar:

- Container'lari gorursun.
- Baslatma, durdurma, silme islemleri yaparsin.
- Image'lari gorursun.
- Loglari izlersin.
- Volume ve network bilgilerini takip edersin.

### Secenek B: Cockpit + cockpit-podman

Cockpit tarayicidan acilan sistem yonetim panelidir. `cockpit-podman` eklentisi ile Podman container'lari web arayuzunden yonetilebilir.

Bu makinede su anda `cockpit` ve `cockpit-podman` kurulu degil.

Kontrol:

```bash
rpm -q cockpit cockpit-podman
```

Kurmak icin:

```bash
sudo dnf install cockpit cockpit-podman
```

Cockpit servisini acmak icin:

```bash
sudo systemctl enable --now cockpit.socket
```

Tarayicida ac:

```text
https://localhost:9090
```

Ne ise yarar:

- Sistem durumunu gorursun.
- Podman container'larini web arayuzunden takip edersin.
- Loglari ve kaynak kullanimini inceleyebilirsin.
- Sunucu gibi calisan makinelerde kullanislidir.

Not: Cockpit sistem yonetim paneli oldugu icin Podman Desktop'a gore daha genis yetkilere sahiptir. Sadece ihtiyacin varsa kur.

### Secenek C: podman-tui

`podman-tui`, terminal icinde calisan gorsel Podman yonetim aracidir. Tam masaustu GUI degildir ama ok tuslariyla gezilen kullanisli bir terminal panelidir.

Fedora 44 deposunda mevcut gorunuyor.

Kurmak icin:

```bash
sudo dnf install podman-tui
```

Calistirmak icin:

```bash
podman-tui
```

Ne ise yarar:

- Container'lari terminal icinde listelemeyi saglar.
- Image'lari gormeyi kolaylastirir.
- Log ve durum takibinde CLI'dan daha rahat olabilir.
- Masaustu uygulamasi kurmak istemiyorsan hafif bir ara cozumdur.

## 9. CLI mi GUI mi?

CLI kullanmak icin:

- Hizli kontrol gerekir.
- Komutlari ogrenmek istersin.
- Daha az sistem bileseni kurmak istersin.

Podman Desktop kullanmak icin:

- Container'lari grafik arayuzden gormek istersin.
- Log, image ve volume takibini tiklayarak yapmak istersin.
- Masaustu kullaniminda rahat bir panel istersin.

Cockpit kullanmak icin:

- Tarayici uzerinden sistem ve container yonetimi istersin.
- Makineyi kucuk bir sunucu gibi takip etmek istersin.
- Podman disinda sistem servislerini de gormek istersin.

podman-tui kullanmak icin:

- Terminalden cikmadan gorsel takip istersin.
- Fedora depolarindan kolay kurulan hafif bir arac istersin.
- Tam masaustu GUI gerekmiyorsa pratik bir panel istersin.

Bu Excalidraw kurulumu icin en sade yontem CLI'dir. Masaustu GUI istersen Podman Desktop'i Flatpak ile kur. Fedora deposundan kolay kurulan terminal paneli istersen `podman-tui` kullan.

## 10. Neden Bu Yontem Guvenli?

- `127.0.0.1:3000` kullanildigi icin uygulama sadece yerel bilgisayardan erisilebilir.
- `0.0.0.0:3000` kullanilmadi; yani agdaki diger cihazlara acilmadi.
- Sistem paketlerine Node/Yarn kurulumu yapilmadi.
- `npm install -g` veya global Yarn kurulumu yapilmadi.
- Excalidraw statik build olarak nginx container'i icinde calisiyor.
- Container image'i Podman tarafinda tutuluyor.

## 11. Tamamen Kaldirmak

Container'i durdur ve sil:

```bash
podman rm -f excalidraw-local
```

Image'i sil:

```bash
podman rmi local/excalidraw:fedora-safe
```

Kullanilmayan Podman cache ve katmanlarini temizlemek istersen:

```bash
podman system prune
```

## 12. Hata Durumunda Bakilacak Ilk Yerler

Container calisiyor mu?

```bash
podman ps -a --filter name=excalidraw-local
```

Port dogru mu?

```bash
podman port excalidraw-local
```

Loglarda hata var mi?

```bash
podman logs excalidraw-local
```

Adres dogru mu?

```text
http://127.0.0.1:3000
```

Portu degistirdiysen adresi de degistirmelisin. Ornek: `8080` kullandiysan adres `http://127.0.0.1:8080` olur.
