From: Siqi Ling <lsq0473-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: PROBLEM: SOFT-ROCE ATOMIC OPERATIONS BLOCK
Date: Tue, 24 Oct 2017 09:29:28 +0200
Message-ID: <CALB8hDx4nLXJnVNgDJgdqLxBNDyGVZXP6GNKj5sHfATE_bO+8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

[1.] Soft-Roce RDMA atomic operations multiple calls cause block
[2.] I have downloaded the newest Soft-Roce version from github
rdma-core and tested it on 3 machines. I followed the instruction on
mellanox https://community.mellanox.com/docs/DOC-2184 and both the
rdma_rxe module and the user space library seem correct. But I have a
problem on atomic operations. If I call atomic operations in a loop
for e.g. 200 times. Then somewhere in rxe.c the program will be
blocked:

#0  rxe_poll_cq (ibcq=0x8f246b0, ne=1, wc=0x7efb5ec41170) at
/home/siqi/Downloads/rdma-core/providers/rxe/rxe.c:250
#1  0x00000000016a996a in pgaspi_ib_dev_wait ()
#2  0x00000000016a42f6 in pgaspi_wait ()
#3  0x0000000001432c31 in SuiApiGPI2::waitOnVMQueue(SUIQueue) ()
#4  0x0000000001430b32 in SuiApiGPI2::writeDMA(unsigned char*,
unsigned long, unsigned char*, unsigned long, unsigned long, int) ()

[3.] Soft-Roce, RDMA, atomic operations
[4.] Linux version 4.9.0-040900-generic (kernel@tangerine) (gcc
version 6.2.0 20161005 (Ubuntu 6.2.0-5ubuntu12) ) #201612111631 SMP
Sun Dec 11 21:33:00 UTC 2016
[5.]
[6.]
[7.]
[7.1.] If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux siqi-ESPRIMO-P920-4 4.9.0-040900-generic #201612111631 SMP Sun
Dec 11 21:33:00 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

GNU C                   5.4.0
GNU Make                4.1
Binutils                2.26.1
Util-linux              2.27.1
Mount                   2.27.1
Module-init-tools       22
E2fsprogs               1.42.13
Pcmciautils             018
PPP                     2.4.7
Linux C Library         2.23
Dynamic linker (ldd)    2.23
Linux C++ Library       6.0.21
Procps                  3.3.10
Net-tools               1.60
Kbd                     1.15.5
Console-tools           1.15.5
Sh-utils                8.25
Udev                    229
Wireless-tools          30
Modules Loaded          ablk_helper aesni_intel aes_x86_64 ahci
autofs4 beegfs configfs coretemp crc32_pclmul crct10dif_pclmul cryptd
drm drm_kms_helper e1000e fb_sys_fops fjes fujitsu_laptop
ghash_clmulni_intel glue_helper hid hid_generic i2c_algo_bit i915
ib_cm ib_core ib_uverbs input_leds intel_cstate intel_pch_thermal
intel_powerclamp intel_rapl intel_rapl_perf ip6_udp_tunnel irqbypass
iw_cm kvm kvm_intel libahci lp lpc_ich lrw mac_hid mei mei_me parport
parport_pc ppdev pps_core psmouse ptp rdma_cm rdma_rxe rdma_ucm
serio_raw snd snd_hda_codec snd_hda_codec_generic snd_hda_codec_hdmi
snd_hda_codec_realtek snd_hda_core snd_hda_intel snd_hwdep snd_pcm
snd_rawmidi snd_seq snd_seq_device snd_seq_midi snd_seq_midi_event
snd_timer soundcore syscopyarea sysfillrect sysimgblt tpm_infineon
udp_tunnel usbhid video x86_pkg_temp_thermal
[7.2.] processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 799.804
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7183.05
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 1169.384
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.02
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 3517.602
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.06
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 1063.476
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.05
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 4
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 800.024
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 0
cpu cores       : 4
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.52
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 5
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 2157.495
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 1
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.14
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 6
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 817.602
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 2
cpu cores       : 4
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.11
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:

processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 60
model name      : Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz
stepping        : 3
microcode       : 0x22
cpu MHz         : 1142.358
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm
pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm epb tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid xsaveopt dtherm
ida arat pln pts
bugs            :
bogomips        : 7184.12
clflush size    : 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:
[7.3.] rdma_rxe 114688 0 - Live 0x0000000000000000
ip6_udp_tunnel 16384 1 rdma_rxe, Live 0x0000000000000000
udp_tunnel 16384 1 rdma_rxe, Live 0x0000000000000000
rdma_ucm 28672 0 - Live 0x0000000000000000
rdma_cm 57344 1 rdma_ucm, Live 0x0000000000000000
iw_cm 49152 1 rdma_cm, Live 0x0000000000000000
ib_cm 45056 1 rdma_cm, Live 0x0000000000000000
configfs 40960 2 rdma_cm, Live 0x0000000000000000
ib_uverbs 65536 1 rdma_ucm, Live 0x0000000000000000
ib_core 212992 6 rdma_rxe,rdma_ucm,rdma_cm,iw_cm,ib_cm,ib_uverbs, Live
0x0000000000000000
beegfs 417792 1 - Live 0x0000000000000000 (OE)
intel_rapl 20480 0 - Live 0x0000000000000000
x86_pkg_temp_thermal 16384 0 - Live 0x0000000000000000
intel_powerclamp 16384 0 - Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
kvm_intel 196608 0 - Live 0x0000000000000000
kvm 598016 1 kvm_intel, Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
aesni_intel 167936 0 - Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
cryptd 24576 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0x0000000000000000
snd_hda_codec_hdmi 45056 1 - Live 0x0000000000000000
snd_hda_codec_realtek 86016 1 - Live 0x0000000000000000
snd_hda_codec_generic 73728 1 snd_hda_codec_realtek, Live 0x0000000000000000
intel_cstate 16384 0 - Live 0x0000000000000000
intel_rapl_perf 16384 0 - Live 0x0000000000000000
snd_hda_intel 36864 5 - Live 0x0000000000000000
snd_hda_codec 135168 4
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,
Live 0x0000000000000000
snd_hda_core 86016 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,
Live 0x0000000000000000
snd_seq_midi 16384 0 - Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
snd_hwdep 16384 1 snd_hda_codec, Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
snd_seq_midi_event 16384 1 snd_seq_midi, Live 0x0000000000000000
snd_rawmidi 32768 1 snd_seq_midi, Live 0x0000000000000000
intel_pch_thermal 16384 0 - Live 0x0000000000000000
snd_seq 65536 2 snd_seq_midi,snd_seq_midi_event, Live 0x0000000000000000
snd_pcm 114688 4
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_hda_core, Live
0x0000000000000000
mei_me 36864 0 - Live 0x0000000000000000
lpc_ich 24576 0 - Live 0x0000000000000000
mei 102400 1 mei_me, Live 0x0000000000000000
snd_seq_device 16384 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x0000000000000000
snd_timer 32768 2 snd_seq,snd_pcm, Live 0x0000000000000000
snd 86016 21 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_rawmidi,snd_seq,snd_pcm,snd_seq_device,snd_timer,
Live 0x0000000000000000
fujitsu_laptop 20480 0 - Live 0x0000000000000000
soundcore 16384 1 snd, Live 0x0000000000000000
tpm_infineon 20480 0 - Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
parport_pc 32768 1 - Live 0x0000000000000000
ppdev 20480 0 - Live 0x0000000000000000
lp 20480 0 - Live 0x0000000000000000
parport 49152 3 parport_pc,ppdev,lp, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
i915 1257472 93 - Live 0x0000000000000000
i2c_algo_bit 16384 1 i915, Live 0x0000000000000000
drm_kms_helper 159744 1 i915, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
e1000e 249856 0 - Live 0x0000000000000000
psmouse 139264 0 - Live 0x0000000000000000
ahci 36864 2 - Live 0x0000000000000000
drm 364544 8 i915,drm_kms_helper, Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
ptp 20480 1 e1000e, Live 0x0000000000000000
pps_core 20480 1 ptp, Live 0x0000000000000000
fjes 28672 0 - Live 0x0000000000000000
video 40960 2 fujitsu_laptop,i915, Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 53248 0 - Live 0x0000000000000000
hid 122880 2 hid_generic,usbhid, Live 0x0000000000000000
[7.4.] 0000-0000 : PCI Bus 0000:00
  0000-0000 : dma1
  0000-0000 : pic1
  0000-0000 : timer0
  0000-0000 : timer1
  0000-0000 : keyboard
  0000-0000 : keyboard
  0000-0000 : rtc0
  0000-0000 : dma page reg
  0000-0000 : pic2
  0000-0000 : dma2
  0000-0000 : fpu
    0000-0000 : PNP0C04:00
  0000-0000 : parport0
  0000-0000 : parport0
  0000-0000 : vesafb
  0000-0000 : serial
  0000-0000 : pnp 00:06
  0000-0000 : pnp 00:03
  0000-0000 : pnp 00:03
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:03
0000-0000 : PCI conf1
0000-0000 : PCI Bus 0000:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
    0000-0000 : ACPI PM1a_EVT_BLK
    0000-0000 : ACPI PM1a_CNT_BLK
    0000-0000 : ACPI PM_TMR
    0000-0000 : ACPI GPE0_BLK
    0000-0000 : iTCO_wdt.0.auto
    0000-0000 : ACPI PM2_CNT_BLK
    0000-0000 : pnp 00:02
    0000-0000 : iTCO_wdt.0.auto
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
  0000-0000 : pnp 00:00
  0000-0000 : 0000:00:02.0
  0000-0000 : 0000:00:1f.3
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:19.0
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : 0000:00:1f.2
    0000-0000 : ahci
  0000-0000 : pnp 00:00
    0000-0000 : pnp 00:00
      0000-0000 : pnp 00:00

00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : Video ROM
00000000-00000000 : Adapter ROM
00000000-00000000 : reserved
  00000000-00000000 : System ROM
00000000-00000000 : System RAM
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : reserved
00000000-00000000 : ACPI Tables
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : reserved
00000000-00000000 : System RAM
00000000-00000000 : RAM buffer
00000000-00000000 : reserved
  00000000-00000000 : Graphics Stolen Memory
00000000-00000000 : PCI Bus 0000:00
  00000000-00000000 : 0000:00:02.0
  00000000-00000000 : 0000:00:02.0
  00000000-00000000 : 0000:00:19.0
    00000000-00000000 : e1000e
  00000000-00000000 : 0000:00:14.0
    00000000-00000000 : xhci-hcd
  00000000-00000000 : 0000:00:1b.0
    00000000-00000000 : ICH HD audio
  00000000-00000000 : 0000:00:03.0
    00000000-00000000 : ICH HD audio
  00000000-00000000 : 0000:00:1f.6
  00000000-00000000 : 0000:00:1f.3
  00000000-00000000 : 0000:00:1f.2
    00000000-00000000 : ahci
  00000000-00000000 : 0000:00:1d.0
    00000000-00000000 : ehci_hcd
  00000000-00000000 : 0000:00:1a.0
    00000000-00000000 : ehci_hcd
  00000000-00000000 : 0000:00:19.0
    00000000-00000000 : e1000e
  00000000-00000000 : 0000:00:16.0
    00000000-00000000 : mei_me
  00000000-00000000 : pnp 00:07
  00000000-00000000 : pnp 00:07
  00000000-00000000 : PCI MMCONFIG 0000 [bus 00-3f]
    00000000-00000000 : reserved
      00000000-00000000 : pnp 00:07
00000000-00000000 : reserved
  00000000-00000000 : IOAPIC 0
00000000-00000000 : reserved
  00000000-00000000 : HPET 0
    00000000-00000000 : PNP0103:00
00000000-00000000 : pnp 00:07
00000000-00000000 : pnp 00:07
00000000-00000000 : pnp 00:07
00000000-00000000 : reserved
  00000000-00000000 : pnp 00:07
    00000000-00000000 : iTCO_wdt.0.auto
00000000-00000000 : pnp 00:07
00000000-00000000 : TPM
00000000-00000000 : pnp 00:07
00000000-00000000 : dmar0
00000000-00000000 : dmar1
00000000-00000000 : Local APIC
  00000000-00000000 : reserved
00000000-00000000 : reserved
  00000000-00000000 : INT0800:00
    00000000-00000000 : pnp 00:07
00000000-00000000 : System RAM
  00000000-00000000 : Kernel code
  00000000-00000000 : Kernel data
  00000000-00000000 : Kernel bss
00000000-00000000 : RAM buffer

[7.5.] 00:00.0 Host bridge: Intel Corporation 4th Gen Core Processor
DRAM Controller (rev 06)
        DeviceName:  Intel I217LM
        Subsystem: Fujitsu Technology Solutions 4th Gen Core Processor
DRAM Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: hsw_uncore

00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200
v3/4th Gen Core Processor Integrated Graphics Controller (rev 06)
(prog-if 00 [VGA controller])
        Subsystem: Fujitsu Technology Solutions Xeon E3-1200 v3/4th
Gen Core Processor Integrated Graphics Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 29
        Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=4M]
        Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at f000 [size=64]
        [virtual] Expansion ROM at 000c0000 [disabled] [size=128K]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee00018  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a4] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: i915
        Kernel modules: i915

00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
Processor HD Audio Controller (rev 06)
        Subsystem: Fujitsu Technology Solutions Xeon E3-1200 v3/4th
Gen Core Processor HD Audio Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: Memory at f7c34000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee00338  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB xHCI (rev 04) (prog-if 30 [XHCI])
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset Family USB xHCI
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 26
        Region 0: Memory at f7c20000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
                Address: 00000000fee00238  Data: 0000
        Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 8 Series/C220
Series Chipset Family MEI Controller #1 (rev 04)
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset Family MEI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 30
        Region 0: Memory at f7c40000 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee002d8  Data: 0000
        Kernel driver in use: mei_me
        Kernel modules: mei_me

00:19.0 Ethernet controller: Intel Corporation Ethernet Connection
I217-LM (rev 04)
        Subsystem: Fujitsu Technology Solutions Ethernet Connection I217-LM
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 28
        Region 0: Memory at f7c00000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at f7c3d000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at f080 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee002b8  Data: 0000
        Capabilities: [e0] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: e1000e
        Kernel modules: e1000e

00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #2 (rev 04) (prog-if 20 [EHCI])
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset Family USB EHCI
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f7c3c000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 8 Series/C220 Series Chipset
High Definition Audio Controller (rev 04)
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset High Definition Audio Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 31
        Region 0: Memory at f7c30000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000fee00318  Data: 0000
        Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0
                        ExtTag- RBE-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
                VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable- ID=0 ArbSelect=Fixed TC/VC=00
                        Status: NegoPending- InProgress-
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel

00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
Family USB EHCI #1 (rev 04) (prog-if 20 [EHCI])
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset Family USB EHCI
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at f7c3b000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port: BAR=1 offset=00a0
        Capabilities: [98] PCI Advanced Features
                AFCap: TP+ FLR+
                AFCtrl: FLR-
                AFStatus: TP-
        Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation Q87 Express LPC Controller (rev 04)
        Subsystem: Fujitsu Technology Solutions Q87 Express LPC Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information: Len=0c <?>
        Kernel driver in use: lpc_ich
        Kernel modules: lpc_ich

00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series
Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 04) (prog-if
01 [AHCI 1.0])
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset Family 6-port SATA Controller 1 [AHCI mode]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0
        Interrupt: pin B routed to IRQ 27
        Region 0: I/O ports at f0d0 [size=8]
        Region 1: I/O ports at f0c0 [size=4]
        Region 2: I/O ports at f0b0 [size=8]
        Region 3: I/O ports at f0a0 [size=4]
        Region 4: I/O ports at f060 [size=32]
        Region 5: Memory at f7c3a000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                Address: fee00278  Data: 0000
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
        Kernel driver in use: ahci
        Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family
SMBus Controller (rev 04)
        Subsystem: Fujitsu Technology Solutions 8 Series/C220 Series
Chipset Family SMBus Controller
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 3
        Region 0: Memory at f7c39000 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at f040 [size=32]
        Kernel modules: i2c_i801

00:1f.6 Signal processing controller: Intel Corporation 8 Series
Chipset Family Thermal Management Controller (rev 04)
        Subsystem: Fujitsu Technology Solutions 8 Series Chipset
Family Thermal Management Controller
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f7c38000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
                Address: 00000000  Data: 0000
        Kernel modules: intel_pch_thermal

[7.6.] Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Micron_M600_MTFD Rev: MU02
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVDRAM GHC0N     Rev: VF01
  Type:   CD-ROM                           ANSI  SCSI revision: 05
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
