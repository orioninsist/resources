# Podman ve Konteyner Araçları Analiz Raporu

Bu rapor Fedora sisteminde Podman, Podman Desktop ve ilgili konteyner/Kubernetes araçlarının ne işe yaradığını, sistemde kurulu olup olmadığını, gerekiyorsa nasıl kurulacağını ve CLI tarafında nasıl yönetileceğini özetler.

> Bu analiz sırasında kurulum, kaldırma veya servis aktifleştirme işlemi yapılmadı. Sadece sistem durumu okundu.

## 1. Sistem Özeti

| Başlık | Değer |
|---|---|
| Dağıtım | Fedora Linux 44 Workstation Edition |
| Kernel | 6.19.10-300.fc44.x86_64 |
| Podman sürümü | 5.8.2 |
| Çalışma modu | Rootless |
| Cgroup | v2, systemd |
| OCI runtime | crun 1.27.1 |
| Ağ backend'i | netavark 1.17.2 |
| DNS backend'i | aardvark-dns 1.17.1 |
| Depolama driver'ı | overlay |
| Podman remote socket | `/run/user/1000/podman/podman.sock`, dosya mevcut |
| Podman socket systemd durumu | user ve system seviyesinde disabled/inactive |

Sistemde şu anda Podman çalışabilir durumda. Rootless kurulum aktif görünüyor; bu, konteynerlerin normal kullanıcı yetkisiyle çalıştırıldığı anlamına gelir. Günlük geliştirme için önerilen ve güvenli varsayılan kullanım budur.

## 2. Kurulu / Kurulu Değil Durumu

| Araç | Durum | Ne işe yarar? | Gerekli mi? |
|---|---:|---|---|
| Podman | Kurulu | Konteyner ve pod çalıştırır, image yönetir, Docker CLI'ına benzer komutlar sunar. | Evet, ana araç |
| Podman Desktop | Kurulu değil | Podman, image, container, volume, Kubernetes ve extension yönetimi için GUI sağlar. | Şart değil, GUI isteyenler için faydalı |
| Skopeo | Kurulu | Registry ve image kopyalama/inceleme/senkronizasyon işleri yapar. Container çalıştırmaz. | Faydalı, özellikle image işleri için |
| crun | Kurulu | Podman'ın konteynerleri çalıştırmak için kullandığı hızlı OCI runtime. | Evet, Podman zaten kullanıyor |
| netavark | Kurulu | Podman ağ yönetimini sağlar. | Evet |
| aardvark-dns | Kurulu | Podman ağlarında DNS çözümleme sağlar. | Evet |
| Buildah | Kurulu değil | Image build etmek için uzmanlaşmış araçtır. Podman build zaten Buildah altyapısını kullanır. | Gelişmiş image build işleri için faydalı |
| kubectl | Kurulu değil | Kubernetes cluster yönetimi için ana CLI. | Kubernetes kullanacaksan gerekli |
| kind | Kurulu değil | Lokal Kubernetes cluster'ını container içinde çalıştırır. | Lokal Kubernetes testi için faydalı |
| minikube | Kurulu değil | Lokal Kubernetes cluster oluşturur. VM/container driver kullanabilir. | Alternatif lokal Kubernetes aracı |
| podman-compose | Kurulu değil | Docker Compose dosyalarını Podman ile çalıştırmaya yarar. | Compose dosyan varsa faydalı |
| docker-compose | Kurulu değil | Compose v2 uyumlu çoklu servis yönetimi. Podman socket ile kullanılabilir. | Compose workflow için faydalı |
| nerdctl | Kurulu değil | containerd için Docker-benzeri CLI. | Podman kullanıyorsan genelde gerekmez |
| runc | Kurulu değil | Alternatif OCI runtime. | crun varken genelde gerekmez |

## 3. Mevcut Podman Durumu

Şu anda sistemde bir container çalışıyor:

```text
NAMES              IMAGE                                   STATUS
excalidraw-local   localhost/local/excalidraw:fedora-safe  Up About an hour
```

Mevcut image'lar arasında lokal Excalidraw image'ı, Node 24 ve nginx 1.27-alpine görünüyor. Varsayılan Podman ağı `podman` adlı bridge ağ olarak mevcut. Volume listesi boş görünüyor.

Kontrol komutları:

```bash
podman --version
podman info
podman ps
podman ps -a
podman images
podman network ls
podman volume ls
podman system df
```

## 4. Podman Nedir?

Podman, daemonless bir konteyner motorudur. Docker'daki gibi sürekli çalışan merkezi bir daemon'a ihtiyaç duymaz. Container lifecycle yönetimi libpod tarafında yapılır. Bu mimari özellikle rootless kullanım, systemd entegrasyonu ve güvenlik açısından güçlüdür.

Podman ile şunlar yapılır:

- Image çekmek: `podman pull nginx`
- Container çalıştırmak: `podman run ...`
- Container listelemek: `podman ps`
- Log okumak: `podman logs ...`
- Shell açmak: `podman exec -it ... sh`
- Image build etmek: `podman build ...`
- Pod oluşturmak: `podman pod create ...`
- Kubernetes YAML çalıştırmak: `podman kube play ...`
- systemd/Quadlet ile kalıcı servis yapmak

## 5. Podman Nasıl Kurulur?

Bu sistemde Podman zaten kurulu. Kurulu olmasaydı Fedora'da komut:

```bash
sudo dnf install podman
```

Kontrol:

```bash
podman --version
podman info
```

Rootless kullanım için çoğu Fedora sisteminde ek işlem gerekmez. Subuid/subgid eşlemelerini kontrol etmek için:

```bash
grep "$USER" /etc/subuid /etc/subgid
```

## 6. Podman Socket ve Docker Uyumlu Kullanım

Podman daemonless olsa da Docker API uyumlu istemciler için bir socket açabilir. Bu, Podman Desktop, docker-compose veya bazı IDE eklentileri için işe yarar.

Mevcut durumda socket dosyası var ama systemd socket otomatik aktif değil. Aktifleştirmek gerekirse rootless kullanıcı için:

```bash
systemctl --user enable --now podman.socket
```

Durum kontrolü:

```bash
systemctl --user status podman.socket
podman system connection list
```

Docker uyumlu araçlara socket göstermek için:

```bash
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
```

Kalıcı yapmak istersen shell profil dosyana eklenebilir:

```bash
echo 'export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock' >> ~/.bashrc
```

## 7. Podman Desktop Nedir?

Podman Desktop, Podman için grafik arayüzdür. Container, image, volume, pod, Kubernetes context ve extension yönetimini GUI üzerinden yapmayı sağlar.

Şart değildir. Terminal kullanıyorsan Podman tek başına yeterlidir. Ancak şu durumlarda yararlıdır:

- Container'ları görsel olarak izlemek istiyorsan
- Image ve volume temizliğini GUI ile yapmak istiyorsan
- Kubernetes context'leriyle görsel çalışmak istiyorsan
- Extension ekosisteminden yararlanmak istiyorsan

Bu sistemde Podman Desktop kurulu değil. Flathub'da görünüyor. Kurmak gerekirse:

```bash
flatpak install flathub io.podman_desktop.PodmanDesktop
```

Çalıştırmak için:

```bash
flatpak run io.podman_desktop.PodmanDesktop
```

GUI'nin Podman socket'e erişebilmesi için gerekirse:

```bash
systemctl --user enable --now podman.socket
```

## 8. Podman ile Günlük CLI Yönetimi

Image çekme:

```bash
podman pull docker.io/library/nginx:alpine
```

Container çalıştırma:

```bash
podman run -d --name web -p 8080:80 docker.io/library/nginx:alpine
```

Durum kontrolü:

```bash
podman ps
curl http://localhost:8080
```

Log okuma:

```bash
podman logs web
```

Container içine girme:

```bash
podman exec -it web sh
```

Durdurma ve silme:

```bash
podman stop web
podman rm web
```

Image silme:

```bash
podman rmi docker.io/library/nginx:alpine
```

Temizlik:

```bash
podman container prune
podman image prune
podman system prune
```

## 9. Podman ile Bir Uygulamayı A'dan Z'ye Çalıştırma Örneği

Örnek: nginx web sunucusu.

1. Image çek:

```bash
podman pull docker.io/library/nginx:alpine
```

2. Container çalıştır:

```bash
podman run -d \
  --name demo-nginx \
  -p 8080:80 \
  docker.io/library/nginx:alpine
```

3. Çalışıyor mu kontrol et:

```bash
podman ps
curl http://localhost:8080
```

4. Logları izle:

```bash
podman logs -f demo-nginx
```

5. Container içine gir:

```bash
podman exec -it demo-nginx sh
```

6. Durdur:

```bash
podman stop demo-nginx
```

7. Tekrar başlat:

```bash
podman start demo-nginx
```

8. Tamamen kaldır:

```bash
podman rm -f demo-nginx
```

## 10. Image Build Etme

Podman ile Dockerfile/Containerfile build edilebilir. Örnek:

```bash
mkdir demo-app
cd demo-app
cat > Containerfile <<'EOF'
FROM docker.io/library/nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF
cat > index.html <<'EOF'
Merhaba Podman
EOF
podman build -t localhost/demo-nginx:latest .
podman run -d --name demo-built -p 8080:80 localhost/demo-nginx:latest
```

Kontrol:

```bash
curl http://localhost:8080
podman logs demo-built
```

Kaldırma:

```bash
podman rm -f demo-built
podman rmi localhost/demo-nginx:latest
```

Not: Daha gelişmiş build senaryolarında Buildah kullanılabilir, ancak temel işler için `podman build` yeterlidir.

## 11. Buildah

Buildah image oluşturma, katman yönetimi ve düşük seviye build işlemleri için kullanılır. Podman'ın build tarafında Buildah altyapısı vardır; bu yüzden günlük kullanıcı için ayrı Buildah CLI şart değildir.

Kurulu değil. Fedora deposunda mevcut. Kurmak gerekirse:

```bash
sudo dnf install buildah
```

Kontrol:

```bash
buildah --version
```

Ne zaman gerekir?

- CI içinde daemonless image build etmek istiyorsan
- Dockerfile dışı script tabanlı image inşası yapıyorsan
- Image katmanlarını daha ayrıntılı yönetmek istiyorsan

Günlük Podman kullanımı için zorunlu değildir.

## 12. Skopeo

Skopeo kurulu. Container çalıştırmaz; image'ları registry'ler arasında kopyalar, inceler ve imza/policy işlerinde kullanılır.

Örnek komutlar:

```bash
skopeo inspect docker://docker.io/library/nginx:alpine
skopeo copy docker://docker.io/library/nginx:alpine dir:/tmp/nginx-image
```

Ne zaman gerekir?

- Image içeriğini çekmeden incelemek
- Registry'den registry'ye image taşımak
- Air-gapped ortama image hazırlamak
- Image digest doğrulamak

Podman kullanımı için zorunlu değildir ama profesyonel image yönetiminde çok faydalıdır.

## 13. Kubernetes Gerekli mi?

Kubernetes, çok makineli veya cluster tabanlı container orchestration için kullanılır. Tek makinede geliştirme yapıyorsan Podman çoğu zaman yeterlidir. Kubernetes şu durumlarda gerekir:

- Uygulama gerçek ortamda Kubernetes'e deploy edilecekse
- Deployment, Service, Ingress, ConfigMap, Secret gibi Kubernetes kaynakları test edilecekse
- Helm chart veya manifest geliştiriyorsan
- Çok servisli, ölçeklenebilir ortamı cluster mantığıyla test etmek istiyorsan

Gerekli değilse kurmana gerek yok. Podman tek başına container ve pod yönetebilir.

## 14. Podman'ın Kubernetes YAML Desteği

Podman, bazı Kubernetes YAML dosyalarını lokal olarak çalıştırabilir:

```bash
podman kube play app.yaml
podman kube down app.yaml
```

Mevcut container/pod'dan YAML üretmek için:

```bash
podman generate kube demo-nginx > demo-nginx.yaml
```

Bu özellik Kubernetes'in tamamı değildir. Lokal geliştirme ve basit manifest denemeleri için kullanışlıdır.

## 15. kubectl

kubectl Kubernetes cluster yönetmek için ana CLI aracıdır. Bu sistemde kurulu değil.

Fedora deposunda paket adı genellikle `kubernetes-client` olarak bulunur. Kurmak gerekirse:

```bash
sudo dnf install kubernetes-client
```

Kontrol:

```bash
kubectl version --client
kubectl config get-contexts
kubectl get nodes
```

Ne zaman gerekir?

- Gerçek veya lokal Kubernetes cluster'a bağlanacaksan
- `kind`, `minikube`, OpenShift, Rancher Desktop veya bulut Kubernetes kullanacaksan

Podman tek başına kullanılacaksa gerekli değildir.

## 16. kind

kind, Kubernetes cluster'ını container içinde çalıştıran hafif bir geliştirme aracıdır. Bu sistemde kurulu değil. Fedora deposunda mevcut.

Kurmak gerekirse:

```bash
sudo dnf install kind
```

Podman ile kullanırken provider belirtmek gerekebilir:

```bash
export KIND_EXPERIMENTAL_PROVIDER=podman
kind create cluster --name dev
kubectl get nodes
```

Silmek için:

```bash
kind delete cluster --name dev
```

Ne zaman gerekir?

- Lokal Kubernetes testi istiyorsan
- CI benzeri hızlı cluster denemesi yapacaksan
- Kubernetes manifestlerini Podman dışında gerçek cluster davranışına yakın test etmek istiyorsan

## 17. minikube

minikube lokal Kubernetes cluster oluşturmak için başka bir popüler araçtır. Bu sistemde kurulu değil. Fedora deposunda görünmedi; resmi RPM veya upstream kurulum yöntemi gerekebilir.

Kurulum için resmi kaynak tercih edilmeli:

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm
```

Podman driver ile başlatma örneği:

```bash
minikube start --driver=podman
kubectl get nodes
```

Ne zaman gerekir?

- Tek komutla lokal Kubernetes ortamı istiyorsan
- Addon, dashboard veya ingress gibi minikube özelliklerini kullanacaksan

kind daha sade ve CI dostu, minikube daha özellikli bir lokal geliştirme deneyimi sunar. İkisini birden kurmak şart değildir.

## 18. Compose Araçları

Compose, birden fazla servisi `compose.yaml` veya `docker-compose.yml` dosyasıyla birlikte çalıştırmak için kullanılır.

Bu sistemde `podman-compose` ve `docker-compose` kurulu değil. Fedora deposunda ikisi de mevcut görünüyor.

Podman odaklı seçenek:

```bash
sudo dnf install podman-compose
podman-compose up -d
podman-compose down
```

Docker Compose v2 seçeneği:

```bash
sudo dnf install docker-compose
systemctl --user enable --now podman.socket
export DOCKER_HOST=unix:///run/user/$UID/podman/podman.sock
docker-compose up -d
docker-compose down
```

Ne zaman gerekir?

- Elinde `compose.yaml` varsa
- Birden fazla servisi tek dosyadan başlatmak istiyorsan
- Veritabanı + backend + frontend gibi lokal geliştirme ortamı kuruyorsan

Sadece tekil container çalıştırıyorsan şart değildir.

## 19. crun, runc ve Runtime Seçimi

Bu sistemde Podman `crun` kullanıyor. Fedora ve rootless Podman için crun iyi varsayılandır.

Kontrol:

```bash
podman info --format '{{.Host.OCIRuntime.Name}}'
crun --version
```

`runc` kurulu değil. Gerekirse:

```bash
sudo dnf install runc
```

Genellikle gerekmez. Özel uyumluluk testi yapmıyorsan crun ile devam etmek mantıklı.

## 20. nerdctl ve containerd

nerdctl, containerd için Docker-benzeri CLI'dır. Podman ile aynı problem alanında yer alır ama farklı runtime stack kullanır.

Bu sistemde kurulu değil. Podman kullanıyorsan genelde gerekmez. Şu durumlarda anlamlı olabilir:

- Kubernetes node/containerd davranışını birebir test etmek istiyorsan
- containerd tabanlı bir geliştirme ortamın varsa
- Docker yerine containerd CLI istiyorsan

Podman odaklı Fedora geliştirici makinesinde öncelikli araç değildir.

## 21. Quadlet ve systemd ile Kalıcı Servis

Quadlet, Podman container/pod/image/network/volume tanımlarını systemd unit'lerine dönüştürür. Uzun süre çalışacak servisler için önerilir.

Rootless kullanıcı servisi örneği:

```bash
mkdir -p ~/.config/containers/systemd
cat > ~/.config/containers/systemd/demo-nginx.container <<'EOF'
[Container]
Image=docker.io/library/nginx:alpine
ContainerName=demo-nginx
PublishPort=8080:80

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now demo-nginx.service
```

Kontrol:

```bash
systemctl --user status demo-nginx.service
podman ps
curl http://localhost:8080
```

Durdurma ve kaldırma:

```bash
systemctl --user disable --now demo-nginx.service
rm ~/.config/containers/systemd/demo-nginx.container
systemctl --user daemon-reload
podman rm -f demo-nginx
```

Kullanıcı oturum kapattığında servislerin çalışmaya devam etmesi gerekiyorsa:

```bash
loginctl enable-linger "$USER"
```

## 22. Hangi Araçları Kurmak Mantıklı?

Bu sistem için pratik öneri:

| İhtiyaç | Öneri |
|---|---|
| Sadece container çalıştırma | Mevcut Podman yeterli |
| GUI ile yönetim | Podman Desktop kur |
| Image inceleme/kopyalama | Skopeo zaten kurulu |
| Gelişmiş image build | Buildah kur |
| Compose dosyaları | podman-compose veya docker-compose kur |
| Lokal Kubernetes | kubectl + kind kur |
| Daha özellikli lokal Kubernetes | kubectl + minikube kur |
| Runtime alternatifi testi | runc kur |
| containerd odaklı çalışma | nerdctl düşün |

En sade ve mantıklı kurulum seti:

```bash
sudo dnf install podman buildah podman-compose kubernetes-client kind
flatpak install flathub io.podman_desktop.PodmanDesktop
```

Ama bunların hepsi şart değildir. Mevcut sistemde Podman zaten düzgün çalışıyor. Önce ihtiyaç belirlenmeli:

- GUI istiyorsan: Podman Desktop
- Kubernetes çalışacaksan: kubectl + kind
- Compose kullanacaksan: podman-compose
- Image build/pipeline işi çoksa: Buildah

## 23. Podman ile İlgili Soru İşaretlerini Bitiren Kısa Rehber

Podman çalışıyor mu?

```bash
podman info
```

Container var mı?

```bash
podman ps -a
```

Image var mı?

```bash
podman images
```

Bir container nasıl başlatılır?

```bash
podman run -d --name web -p 8080:80 nginx:alpine
```

Log nasıl okunur?

```bash
podman logs web
```

Container içine nasıl girilir?

```bash
podman exec -it web sh
```

Port çalışıyor mu?

```bash
curl http://localhost:8080
```

Container nasıl durdurulur?

```bash
podman stop web
```

Container nasıl silinir?

```bash
podman rm web
```

Image nasıl silinir?

```bash
podman rmi nginx:alpine
```

Rootless mı rootful mı?

```bash
podman info --format '{{.Host.Security.Rootless}}'
```

Hangi runtime kullanılıyor?

```bash
podman info --format '{{.Host.OCIRuntime.Name}}'
```

Hangi network backend'i kullanılıyor?

```bash
podman info --format '{{.Host.NetworkBackend}}'
```

Socket aktif mi?

```bash
systemctl --user status podman.socket
```

Podman Desktop bağlantısı için ne gerekir?

```bash
systemctl --user enable --now podman.socket
```

Kubernetes YAML lokal çalıştırma:

```bash
podman kube play app.yaml
podman kube down app.yaml
```

Compose çalıştırma:

```bash
podman-compose up -d
podman-compose down
```

## 24. Sonuç

Bu Fedora sisteminde Podman ana kullanım için hazır ve çalışır durumda. Rootless yapı, crun runtime, netavark ağ backend'i ve aardvark-dns ile modern Podman mimarisi kullanılmakta. Ek olarak Skopeo da kurulu olduğu için image inceleme ve registry işlemleri yapılabilir.

Eksik görünen araçlar ihtiyaç bazlı kurulmalı:

- GUI gerekiyorsa Podman Desktop
- Compose workflow gerekiyorsa podman-compose veya docker-compose
- Kubernetes gerekiyorsa kubectl + kind
- Gelişmiş build gerekiyorsa Buildah

Kubernetes zorunlu değildir. Tek makinede container geliştirme, servis çalıştırma, image build etme ve lokal test için Podman tek başına yeterlidir. Kubernetes ancak gerçek hedef ortam Kubernetes ise veya manifest/cluster davranışı test edilecekse gerekir.
