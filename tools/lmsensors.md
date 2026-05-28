# lm-sensors

Linux'ta donanim sicakliklarini, fan hizlarini ve bazi voltaj degerlerini terminalden okumak icin kullanilir.

## Komutlar

Anlik degerleri goster:

```bash
sensors
```

Degerleri canli izlemek icin:

```bash
watch -n 2 sensors
```

Her 10 saniyede bir log dosyasina yazmak icin:

```bash
while true; do date; sensors; sleep 10; done >> ~/sensors.log &
```

Arka plandaki log komutunu durdurmak icin:

```bash
pkill -f "while true; do date; sensors"
```

## Notlar

- Paket adi: `lm_sensors`
- Komut adi: `sensors`
- `N/A` veya `+0.0°C` gorunen degerler genelde bos ya da kullanilmayan sensor kanallaridir.
- CPU icin en onemli satirlar `Package id 0` ve `Core` satirlaridir.
- NVMe disk icin `Composite` satiri takip edilebilir.
