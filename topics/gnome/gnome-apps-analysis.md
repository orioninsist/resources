# GNOME Apps Analizi

Analiz tarihi: 2026-05-28 10:12 +03

Kaynak liste: <https://apps.gnome.org/en/>

Bakis acim: Sen terminal/CLI agirlikli calisiyorsun. Bu sistemde zaten `fzf`, `fd`, `bat`, `eza`, `tmux`, `git`, `podman`, `docker`, `ffmpeg`, `yt-dlp`, `rsync`, `rclone`, `poppler-utils`, `tesseract`, `vim-minimal` gibi guclu CLI araclari var. Bu nedenle GNOME uygulamalarini "guzel gorunuyor" diye degil, gercek is akisini hizlandiriyorsa degerli saydim.

Kisa karar: GNOME apps listesinin tamami sana gerekli degil. GNOME masaustunun temel parcalari kalsin; dosya, disk, PDF, tarama, ayar, sistem izleme gibi GUI'nin pratik oldugu araclar kalsin. Muzik, hava durumu, harita, kisiler, takvim, tur, yardim, web, oyun, sosyal, dikkat dagitici veya terminalde daha iyi yapilan isler icin GNOME app yuklemek genelde gereksiz.

## Sistemde Su An Kurulu Gorunenler

Kurulu ana GNOME uygulamalari:

- `nautilus`: Files
- `gnome-control-center`: Settings
- `gnome-software`: Software
- `gnome-system-monitor`: System Monitor
- `gnome-disk-utility`: Disks
- `baobab`: Disk Usage Analyzer
- `papers`: Document Viewer
- `loupe`: Image Viewer
- `simple-scan`: Document Scanner
- `snapshot`: Camera
- `gnome-calculator`: Calculator
- `gnome-calendar`: Calendar
- `gnome-clocks`: Clocks
- `gnome-connections`: Connections
- `gnome-contacts`: Contacts
- `gnome-font-viewer`: Fonts
- `gnome-logs`: Logs
- `gnome-maps`: Maps
- `gnome-text-editor`: Text Editor
- `gnome-tour`: Tour
- `gnome-weather`: Weather
- `yelp`: Help

Kurulu ama altyapi/masaustu parcasi sayilmasi gerekenler:

- `gnome-shell`, `gnome-session`, `gnome-settings-daemon`, `gnome-keyring`, `gnome-online-accounts`, `xdg-desktop-portal-gnome`, `gnome-bluetooth`, `gnome-remote-desktop`
- Bunlari "uygulama temizligi" diye silmek masaustu davranisini bozabilir. Sadece gercek ihtiyac varsa dokunulmali.

## Net Oneri

### Kalsin

Bu uygulamalar GUI olduklari icin bile faydali; terminal alternatifi olsa da bazi islerde hizli ve risksizler:

- `nautilus` / Files: Dosya secme, surukle-birak, harici diskler, masaustu entegrasyonu icin kalsin.
- `gnome-control-center` / Settings: GNOME ayarlari icin gerekli.
- `gnome-disk-utility` / Disks: Disk, partition, SMART, USB imaj, mount islemlerinde GUI faydali.
- `baobab` / Disk Usage Analyzer: Diskte ne yer kapliyor sorusuna hizli cevap verir. CLI alternatifi `du`, `ncdu`.
- `papers` veya Evince / Document Viewer: PDF okumak icin kalsin. CLI `pdftotext`, `pdfinfo`, `qpdf` analiz icin iyi ama okuma icin GUI daha rahat.
- `loupe` / Image Viewer: Hizli gorsel kontrol icin kalsin.
- `simple-scan` / Document Scanner: Tarayici kullaniyorsan kalsin; kullanmiyorsan silinebilir.
- `gnome-system-monitor`: Bazen GUI ile surec oldurmek veya grafik gormek kolay. CLI tarafinda `top`, `ps`, `podman stats` var; yine de kalsin denebilir.
- `gnome-calculator`: Hafif ve kullanisli; terminalde `bc`/Python daha guclu ama bu zararli bir yuk degil.
- `gnome-text-editor`: Basit metin dosyalarini GUI ile acmak icin kalsin. Ana editorun terminal olabilir.
- `gnome-software`: Flatpak/firmware/appstream goruntuleme icin bazen lazim. Sadece DNF/Flatpak CLI kullanacaksan opsiyonel.

### Silinebilir veya Gerekmez

Terminalci ve verimlilik odakli kullanimda bunlarin faydasi dusuk:

- `gnome-tour`: Ilk acilis tanitimi. Artik gereksiz.
- `gnome-weather`: Terminalden veya webden bakmak daha hizli. Gereksiz.
- `gnome-maps`: Harita icin tarayici daha iyi. Gereksiz.
- `gnome-contacts`: GNOME Online Accounts ile kisiler kullanmiyorsan gereksiz.
- `gnome-calendar`: GNOME takvim entegrasyonu kullanmiyorsan gereksiz. Terminal/web/calendar servisleri yeterli olabilir.
- `gnome-clocks`: Alarm/kronometre kullanmiyorsan gereksiz.
- `gnome-logs`: `journalctl` varken cok gerekli degil. Ama GUI log bakmayi seviyorsan kalsin.
- `gnome-font-viewer`: Font isi yapmiyorsan gereksiz.
- `snapshot`: Kamera kullanmiyorsan gereksiz.
- `gnome-connections`: Uzak masaustu kullanmiyorsan gereksiz. SSH genelde daha guclu.
- `yelp`: GNOME yardim uygulamasi. Internet ve man pages varken cogu zaman gereksiz.

Muhtemel silme komutu, once sadece simule et:

```bash
sudo dnf remove --assumeno gnome-tour gnome-weather gnome-maps gnome-contacts gnome-calendar gnome-clocks gnome-font-viewer snapshot gnome-connections yelp
```

Eger DNF cok fazla bagimli paket kaldirmaya calisirsa dur. Ozellikle `gnome-shell`, `gnome-session`, `gnome-control-center`, `nautilus`, `xdg-desktop-portal-gnome` gibi seyleri kaldirmaya kalkarsa onay verme.

## GNOME Core Apps Degerlendirmesi

| Uygulama | Sende durum | Karar | Neden |
|---|---:|---|---|
| Audio Player | Kurulu gorunmedi | Yukleme | Muzik icin terminal/MPV/harici player daha mantikli. |
| Calculator | Kurulu | Kalsin | Hafif, hizli, zararli degil. |
| Calendar | Kurulu | Silinebilir | Takvim entegrasyonu kullanmiyorsan gereksiz. |
| Camera / Snapshot | Kurulu | Silinebilir | Kamera ile is yapmiyorsan bos yuk. |
| Characters | Kurulu olabilir | Opsiyonel | Ozel karakter lazimsa faydali; terminalci icin nadir. |
| Clocks | Kurulu | Silinebilir | Alarm/kronometre kullanmiyorsan gereksiz. |
| Connections | Kurulu | Silinebilir | SSH/RDP/VNC is akisin yoksa gereksiz. |
| Console | Kurulu gorunmedi | Yukleme | Zaten terminal tercihin varsa mevcut terminal yeterli. |
| Contacts | Kurulu | Silinebilir | GNOME kisiler kullanmiyorsan gereksiz. |
| Disk Usage Analyzer / Baobab | Kurulu | Kalsin | Disk temizliginde hizli gorsel analiz. |
| Disks | Kurulu | Kalsin | Disk islemlerinde guvenli ve pratik. |
| Document Scanner | Kurulu | Kullanimina bagli | Scanner yoksa sil; varsa kalsin. |
| Document Viewer / Papers | Kurulu | Kalsin | PDF okuma icin gerekli. |
| Files / Nautilus | Kurulu | Kalsin | Masaustu entegrasyonunun ana parcasi. |
| Fonts | Kurulu | Silinebilir | Font isi yapmiyorsan gereksiz. |
| Help / Yelp | Kurulu | Silinebilir | `man`, web ve dokumanlar yeterli. |
| Image Viewer / Loupe | Kurulu | Kalsin | Gorsel dosyalari hizli kontrol icin iyi. |
| Logs | Kurulu | Opsiyonel | `journalctl` daha guclu; GUI istersen kalsin. |
| Maps | Kurulu | Silinebilir | Web haritalari daha iyi. |
| Music | Kurulu gorunmedi | Yukleme | Gereksiz. |
| Settings | Kurulu | Kalsin | GNOME icin temel. |
| Software | Kurulu | Opsiyonel | CLI kullaniyorsan sart degil; Flatpak icin bazen rahat. |
| System Monitor | Kurulu | Kalsin | GUI ile surec/grafik bakmak hizli olabilir. |
| Text Editor | Kurulu | Kalsin | Basit GUI duzenleme icin iyi; ana editor terminal olabilir. |
| Tour | Kurulu | Sil | Sadece tanitim. |
| Video Player | Tam kurulu gorunmedi | Yukleme | `mpv` veya VLC daha iyi. |
| Weather | Kurulu | Silinebilir | Gereksiz. |
| Web / Epiphany | Runtime var | Yukleme | Firefox/Chromium/Tor gibi tarayicilar varken gereksiz. |

## GNOME Circle Apps: Sana Gore Secim

### Gercekten Fayda Saglayabilecekler

Bu uygulamalar belirli ihtiyac varsa mantikli olabilir:

- Authenticator: 2FA kodlarini masaustunde tutmak istiyorsan faydali. Ama guvenlik icin telefon veya password manager entegrasyonu daha iyi olabilir.
- Collision: Hash kontrolu icin GUI. Sen terminalde `sha256sum`, `b3sum`, `gpg --verify` ile daha guclusun; yukleme gerekmeyebilir.
- Curtail: Cok gorsel optimize ediyorsan faydali. CLI alternatifi `imagemagick`, `pngquant`, `jpegoptim`.
- Deja Dup Backups: Basit GUI yedek isteyenler icin iyi. Senin icin `borg`, `restic`, `rsync`, `rclone` daha guclu.
- Gradia: Screenshot uzerine hizli not/ok/cizim ekleme isi varsa faydali olabilir.
- Impression: Bootable USB yazmak icin GUI. Ama `gnome-disk-utility` zaten bu isi yapabilir; ekstra yukleme sart degil.
- Metadata Cleaner / Paper Clip: Dosya/PDF metadata temizligi gerekiyorsa faydali olabilir. CLI alternatifi `exiftool`, `qpdf`.
- Pika Backup: GUI yedek icin iyi; ama senin tarzin icin `restic`/`borg` daha iyi olur.
- Resources: Modern system monitor. `gnome-system-monitor` yerine tercih edilebilir ama sart degil.
- Secrets: Sifre yoneticisi olarak dusunulebilir; ciddi kullanim icin `KeePassXC` daha iyi olur.
- Switcheroo: Gorsel donusturme GUI'si. CLI `magick` ve `ffmpeg` daha guclu.
- Video Trimmer: Videodan hizli parca kesmek icin pratik olabilir. CLI `ffmpeg` daha guclu ama komut hatirlamak istemediginde GUI iyi.
- Warp: Yerel/ag uzerinden hizli dosya transferi gerekiyorsa faydali olabilir. Alternatif: `rsync`, `scp`, `rclone`.

### Sende Muhtemelen Gereksiz Olanlar

Bu liste "kotu uygulama" demek degil; senin is akisin icin dusuk getirili:

- Amberol, Music, Podcasts, Shortwave: Medya tuketimi; verimlilik hedefinle zayif iliski.
- Apostrophe, Iotas, Text Pieces: Not/markdown icin editor + terminal yeterli.
- Audio Sharing, Blanket, Mousai: Nadir ihtiyac, dikkat dagitici olabilir.
- Biblioteca, Wike, Wordbook: Web veya terminal aramalari daha hizli.
- Binary, Valuta, Lorem: Terminal/web ile daha hizli cozulur.
- Boatswain: Stream Deck yoksa gereksiz.
- Bustle, D-Spy, Sysprof: Sadece GNOME/DBus/profiling gelistiriyorsan.
- Cartridges, Mahjongg, Sudoku, Chess Clock: Oyun/eglence; hedefin verimlilikse yukleme.
- Citations: Akademik kaynak yonetimi yoksa gereksiz.
- Clairvoyant: Fayda uretmez.
- Commit: Git commit mesaji icin terminal/editor yeterli.
- Constrict, Ear Tag, Fretboard, Drum Machine: Cok spesifik medya/muzik isleri.
- Decoder: QR isi sik degilse web/CLI yeterli.
- Dialect: Ceviri icin web/CLI daha iyi.
- Elastic, Emblem, Share Preview, Webfont Bundler: Tasarim/frontend isi yogunsa anlamli; yoksa gereksiz.
- Errands, Sessions, Solanum, Exercise Timer: Zaman/gorev yonetimi uygulamalari cogu zaman uygulama oyalanmasina doner.
- File Shredder: Guvenli silme modern SSDlerde karmasik; rastgele GUI'ye guvenmek yerine tehdit modeline gore dusunmek lazim.
- Forge Sparks: Git bildirimleri dikkat dagitabilir; `gh` CLI daha iyi.
- Fragments: Torrent kullanmiyorsan gereksiz.
- Gaphor, Graphs, Hieroglyphic: Sadece ilgili teknik/akademik is varsa.
- Identity: Medya karsilastirma isi yoksa gereksiz.
- Junction, Tangram: Uygulama/browser secici; is akisini sade tutmak daha iyi.
- Komikku, Polari, Railway, Tuba: Sosyal/tuketim/seyahat odakli; senin hedefinle zayif.
- Obfuscate: Screenshot sansurlemek icin arada faydali olabilir ama zorunlu degil.
- Pods: Podman GUI. Senin sisteminde Podman var; CLI daha net ve otomasyona uygun.
- Workbench, Builder, Manuals: GNOME uygulamasi gelistirmiyorsan gereksiz.

## Development Tools

- Boxes: Basit sanal makine icin guzel. Ama ciddi sanallastirma icin `virt-manager` daha guclu. Sadece hizli VM istiyorsan yuklenebilir.
- Builder: GNOME app gelistirmiyorsan yukleme.
- D-Spy: DBus debug etmiyorsan yukleme.
- Dconf Editor: Tehlikeli ama bazen lazim. Ayar kurcalamayi seviyorsan dikkatli kullan; surekli gerekli degil.
- Manuals: GNOME dev dokumani okuyorsan.
- Sysprof: Performans profilleme yapmiyorsan gereksiz.

## DNF ile Pratik Kontrol Komutlari

Kurulu GNOME paketlerini gormek:

```bash
rpm -qa --qf '%{NAME}\n' | sort | rg '^(gnome|nautilus|loupe|papers|simple-scan|snapshot|baobab|yelp)'
```

Bir paketi silmeden once ne kaldiracak simule etmek:

```bash
sudo dnf remove --assumeno paket-adi
```

Bir paketin ne ise yaradigini gormek:

```bash
dnf info paket-adi
```

DNF ile kurulu paketleri takip etmek icin:

```bash
dnf list --installed '*gnome*'
```

## Benim Sana Ozel Son Kararim

Senin felsefen mantikli: CLI cogu zaman GUI'den daha hizli, daha otomatik, daha ozellestirilebilir ve daha takip edilebilir. Bu yuzden GNOME Apps listesini "kurulacak uygulama katalogu" gibi degil, "gerektikce alinacak ufak yardimcilar" gibi dusunmek daha dogru.

Kalsin dediklerim:

- `nautilus`
- `gnome-control-center`
- `gnome-disk-utility`
- `baobab`
- `papers`
- `loupe`
- `gnome-system-monitor`
- `gnome-calculator`
- `gnome-text-editor`
- `simple-scan` sadece scanner kullaniyorsan
- `gnome-software` sadece Flatpak/GUI app yonetimi istiyorsan

Silme adayi dediklerim:

- `gnome-tour`
- `gnome-weather`
- `gnome-maps`
- `gnome-contacts`
- `gnome-calendar`
- `gnome-clocks`
- `gnome-font-viewer`
- `snapshot`
- `gnome-connections`
- `yelp`
- `gnome-logs` sadece `journalctl` kullanacaksan

Yeni GNOME Circle uygulamasi yukleme konusunda kararim:

- Simdilik hicbirini topluca yukleme.
- Sadece gercek ihtiyac dogarsa sunlar dusunulebilir: `Gradia`, `Video Trimmer`, `Warp`, `Resources`, `Metadata Cleaner`, `Pika Backup`.
- Bunlar disindaki GNOME Circle uygulamalarinin cogu senin icin "vakit yiyen guzel oyuncak" olma riskinde.

En temiz yol: once yukaridaki silme adaylarini `--assumeno` ile test et, sonra neyin kalkacagini birlikte okuyup gercek silme kararini ver.
