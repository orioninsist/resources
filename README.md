# Resources

Bu repo kişisel notlar, kaynaklar ve teknik başvuru dosyaları için ana arşivdir.
Kaynak format Markdown'dur; PDF, ebook veya benzeri dosyalar gerekirse sonradan
çıktı olarak üretilebilir.

## Indeks

<!-- index:start -->
- **Tools/**
  - [Gnome](tools/gnome.md)
  - [Imagemagick](tools/imagemagick.md)
- **Topics/**
<!-- index:end -->

## Not Formati

Her ana konu tek bir Markdown dosyasinda tutulur. Dosya buyudukce bolmek yerine
once icindekiler tablosu ve baslik duzeni iyilestirilir.

Onerilen dosya yapisi:

````md
# Konu Adi

## Icindekiler

- [Kisa Ozet](#kisa-ozet)
- [Komutlar](#komutlar)
- [Ornekler](#ornekler)
- [Kaynaklar](#kaynaklar)

## Kisa Ozet

Bu konu ne icin kullanilir?

## Komutlar

```bash
ornek-komut
```

## Ornekler

Kisa, uygulanabilir notlar.

## Kaynaklar

- <https://example.com>
````

## Klasor Mantigi

Tek rehber dosya kok dizindeki `README.md` dosyasidir. Alt klasorlerde ayri
`README.md` tutulmaz. Kok dizindeki her klasor indeks icinde kendi basligi ile
gorunur; klasor eklenirse indekse eklenir, silinirse indeksten cikar.

Kaynaklar ayri klasorde tutulmaz. Bir notun kaynagi varsa ayni dosyanin
`Kaynaklar` bolumune eklenir.

Kural: Gereksiz klasor acma. Konuyu dosya adiyla ayir:

```text
topics/linux-permissions.md
topics/github-workflow.md
topics/markdown-notes.md
tools/git.md
tools/ffmpeg.md
abc/example.md
```

## Indeks Guncelleme

README icindeki indeks bolumu `update-index.sh` ile uretilir.

```bash
./update-index.sh
```

Script repo icindeki klasor agacini ve Markdown dosya adlarini tarayarak indeksi
bastan uretir. Kok README disindaki `README.md` dosyalari indekse alinmaz. Dosya
icerigindeki degisiklikler indeksi etkilemez. Uretilen indeks mevcut README ile
ayniysa dosyaya dokunmaz ve net sonuc yazar.
