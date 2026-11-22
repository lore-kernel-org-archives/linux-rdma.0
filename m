Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795343953;
	b=M5s6ZJSj3ZapzhWtKyZrEgGgu1ZKKyQIQ0JKJZE5krVtWhTrd7Tfk4OCqNbfFc9/Haa+
	 7niq3henPxsAz6KdYV3qQ2QS6jW1Atl9B0DBPLlrsXI6xgQaCJ2hZAjWJkGK5Var9wYvG
	 UgVdOJc8YSSoIdgJdUhOwykWLsfoq2ic5oIdOIzUyyqEB3rjgzYtMjpnnBq2KdUKF1WyG
	 HZ9B3ZVT3b7MSBBLZjIlwGgTGQklHjjhte5d1Vxj1uwQYD3BaRa6NaM5uZjerzZ1mpsAH
	 mtu0B+W00eNvLNaPUhyw2iGTQ1NeaIkbRJPnvG/CHIzHxhIM7FfnM4FG9x649RZgtAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795343953;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=vdKYzMRwrvR/oupH3LcxUsU1aeXoB7bJpUr9AzYlyOU=;
	b=WMXImiOz7i/wV+aauoRqeokOLd32BvSkKAO0tnOIIYOdaj6k89Im9aRIMV0AEn4AoY2W
	 jOLM6qF92azvvGyAJZqt3W1l4HoUEjY+yJ9VoS2ZsDPw8M9UNe8WhQfe/InTRWYu3BGJY
	 /bPytnlOqo5T6W064KdwZd+8K5QIBLIksHgk43eTfJsrDP7l4Q9/RQbALy1cAaMKrWezI
	 ruCvw+JTGpBuRMEBusVGBSRnABEPcL+Z2KZvfhvd5CeLYveZhmVNa7lqBV4xidNvtSEWb
	 V1wN2XTTtTDr8/7ebv0zS8Pl25I1Q8HvXyqdjcJ45+PZmLM3JYDesCYoEtO2oDAb+KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=jaeyeong.cc;
	spf=pass smtp.mailfrom=jaeyeong.cc;
	dkim=pass header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=CueVUzn4;
	arc=none smtp.remote-ip=185.70.43.18
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69607606A320;
	Sun, 22 Nov 2026 10:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69607606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaeyeong.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jaeyeong.cc header.i=@jaeyeong.cc header.a=rsa-sha256 header.s=protonmail2 header.b=CueVUzn4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaeyeong.cc;
	s=protonmail2; t=1795343948; x=1795603148;
	bh=vdKYzMRwrvR/oupH3LcxUsU1aeXoB7bJpUr9AzYlyOU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=CueVUzn4gUwrWCI+ew+uqIGbDGNd3I+qjdHRotg7sXbEcI09PDboBKVGV1EwotjDW
	 ASEiH1XRVG7hZNBbPNmORaVBU/2hcyS5WDvEgSgvo9uiFFFBquql7DtMfeEpMcVIyi
	 LjkLeMKAMHKjLkSQS/C+Ce9Rr5B+vnSO0XBW4ckd/HPxtiFDJb5p8fEKx/SBiarp1K
	 O6goq4tk5aF6HORM6pV1MioAeT3n2myWsxXOHQCLf+HlO6AQGHq3B6bjV0EsI8izh6
	 muM+xL0E30dwID0P23BRuv1GumkV64xxDLq8xMTI1jk+O6E3/chrxOHyrddZok5bAG
	 woVwmiwp67peA==
Date: Sun, 22 Nov 2026 10:39:01 +0000
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
From: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Preserve DEVX objects after failed output copy
Message-ID: <20261122103855.51859-1-lee@jaeyeong.cc>
In-Reply-To: <20261122103715.51731-1-lee@jaeyeong.cc>
References: <20261111105346.3220427-1-lee@jaeyeong.cc> <20261115135123.GD42525@unreal> <20261122103715.51731-1-lee@jaeyeong.cc>
Feedback-ID: 177356447:user:proton
X-Pm-Message-ID: 42f9441f7273942d2a3ae2bf8bb2b63950ae47bc
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

As requested, below is the full dmesg from the reproducer run.

[    0.000000] Linux version 7.4.0-rc1-g05441d697f7f (finder@finder) (Ubunt=
u clang version 22.1.8 (++20260613092238+e80beda6e255-1~exp1~20260613092253=
.78), Ubuntu LLD 22.1.8) #2 SMP PREEMPT_DYNAMIC Wed Nov 11 19:09:09 KST 202=
6
[    0.000000] Command line: console=3DttyS0 nokaslr kasan_multi_shot panic=
_on_warn=3D0 oops=3Dpanic panic=3D1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff]  Syst=
em RAM
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff]  devi=
ce reserved
[    0.000000] BIOS-e820: [gap 0x00000000000a0000-0x00000000000effff]
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff]  devi=
ce reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff]  Syst=
em RAM
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007fffffff]  devi=
ce reserved
[    0.000000] BIOS-e820: [gap 0x0000000080000000-0x00000000fffbffff]
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff]  devi=
ce reserved
[    0.000000] BIOS-e820: [gap 0x0000000100000000-0x000000fcffffffff]
[    0.000000] BIOS-e820: [mem 0x000000fd00000000-0x000000ffffffffff]  devi=
ce reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] APIC: Static calls initialized
[    0.000000] DMI: SMBIOS 3.0.0 present.
[    0.000000] DMI: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, =
1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.000000] DMI: Memory slots populated: 1/1
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 4411.077 MHz processor
[    0.006896] last_pfn =3D 0x7ffe0 max_arch_pfn =3D 0x400000000
[    0.007910] MTRR map: 4 entries (3 fixed + 1 variable; max 19), built fr=
om 8 variable MTRRs
[    0.008465] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT=
 =20
[    0.016724] found SMP MP-table at [mem 0x000f5480-0x000f548f]
[    0.021290] RAMDISK: [mem 0x7fed0000-0x7ffdffff]
[    0.021633] ACPI: Early table checksum verification disabled
[    0.021941] ACPI: RSDP 0x00000000000F5290 000014 (v00 BOCHS )
[    0.022312] ACPI: RSDT 0x000000007FFE1CAD 000034 (v01 BOCHS  BXPC     00=
000001 BXPC 00000001)
[    0.023049] ACPI: FACP 0x000000007FFE1B59 000074 (v01 BOCHS  BXPC     00=
000001 BXPC 00000001)
[    0.023897] ACPI: DSDT 0x000000007FFE0040 001B19 (v01 BOCHS  BXPC     00=
000001 BXPC 00000001)
[    0.024073] ACPI: FACS 0x000000007FFE0000 000040
[    0.024178] ACPI: APIC 0x000000007FFE1BCD 000080 (v03 BOCHS  BXPC     00=
000001 BXPC 00000001)
[    0.024217] ACPI: HPET 0x000000007FFE1C4D 000038 (v01 BOCHS  BXPC     00=
000001 BXPC 00000001)
[    0.024246] ACPI: WAET 0x000000007FFE1C85 000028 (v01 BOCHS  BXPC     00=
000001 BXPC 00000001)
[    0.024362] ACPI: Reserving FACP table memory at [mem 0x7ffe1b59-0x7ffe1=
bcc]
[    0.024412] ACPI: Reserving DSDT table memory at [mem 0x7ffe0040-0x7ffe1=
b58]
[    0.024426] ACPI: Reserving FACS table memory at [mem 0x7ffe0000-0x7ffe0=
03f]
[    0.024437] ACPI: Reserving APIC table memory at [mem 0x7ffe1bcd-0x7ffe1=
c4c]
[    0.024448] ACPI: Reserving HPET table memory at [mem 0x7ffe1c4d-0x7ffe1=
c84]
[    0.024458] ACPI: Reserving WAET table memory at [mem 0x7ffe1c85-0x7ffe1=
cac]
[    0.026815] No NUMA configuration found
[    0.026843] Faking a node at [mem 0x0000000000000000-0x000000007ffdffff]
[    0.027516] NODE_DATA(0) allocated [mem 0x7fecc780-0x7fecffff]
[    0.875224] KernelAddressSanitizer initialized (generic)
[    0.875868] ACPI: PM-Timer IO Port: 0x608
[    0.876408] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.876850] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-=
23
[    0.876986] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.877316] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.877372] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.877502] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level=
)
[    0.877523] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level=
)
[    0.877770] ACPI: Using ACPI (MADT) for SMP configuration information
[    0.877835] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.878179] CPU topo: Max. logical packages:   1
[    0.878240] CPU topo: Max. logical nodes:      1
[    0.878253] CPU topo: Num. nodes per package:  1
[    0.878289] CPU topo: Max. logical dies:       1
[    0.878299] CPU topo: Max. dies per package:   1
[    0.878337] CPU topo: Max. threads per core:   1
[    0.878453] CPU topo: Num. cores per package:     2
[    0.878468] CPU topo: Num. threads per package:   2
[    0.878477] CPU topo: Allowing 2 present CPUs plus 0 hotplug CPUs
[    0.879497] PM: hibernation: Registered nosave memory: [mem 0x00000000-0=
x00000fff]
[    0.879545] PM: hibernation: Registered nosave memory: [mem 0x0009f000-0=
x000fffff]
[    0.879700] [gap 0x80000000-0xfffbffff] available for PCI devices
[    0.879751] Booting paravirtualized kernel on bare hardware
[    0.879995] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0=
xffffffff, max_idle_ns: 1910969940391419 ns
[    0.911211] Zone ranges:
[    0.911279]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.911446]   DMA32    [mem 0x0000000001000000-0x000000007ffdffff]
[    0.911461]   Normal   empty
[    0.911477] Movable zone start for each node
[    0.911502] Early memory node ranges
[    0.911522]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.911546]   node   0: [mem 0x0000000000100000-0x000000007ffdffff]
[    0.911652] Initmem setup node 0 [mem 0x0000000000001000-0x000000007ffdf=
fff]
[    0.938331] On node 0, zone DMA: 1 pages in unavailable ranges
[    0.939651] On node 0, zone DMA: 97 pages in unavailable ranges
[    1.255217] On node 0, zone DMA32: 32 pages in unavailable ranges
[    1.256029] setup_percpu: NR_CPUS:64 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    1.279790] percpu: Embedded 65 pages/cpu s226904 r8192 d31144 u1048576
[    1.282983] Kernel command line: console=3DttyS0 nokaslr kasan_multi_sho=
t panic_on_warn=3D0 oops=3Dpanic panic=3D1
[    1.284291] Unknown kernel command line parameters "nokaslr", will be pa=
ssed to user space.
[    1.284499] printk: log buffer data + meta data: 262144 + 917504 =3D 117=
9648 bytes
[    1.306186] Dentry cache hash table entries: 262144 (order: 9, 2097152 b=
ytes, linear)
[    1.334716] Inode-cache hash table entries: 131072 (order: 8, 1048576 by=
tes, linear)
[    1.337693] Fallback order for Node 0: 0=20
[    1.338456] Built 1 zonelists, mobility grouping on.  Total pages: 52415=
8
[    1.338503] Policy zone: DMA32
[    1.338691] mem auto-init: stack:all(zero), heap alloc:off, heap free:of=
f
[    1.338716] stackdepot: allocating hash table via alloc_large_system_has=
h
[    1.338770] stackdepot hash table entries: 1048576 (order: 12, 16777216 =
bytes, linear)
[    1.392150] stackdepot: allocating space for 8192 stack pools via memblo=
ck
[    1.476270] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    1.487379] Dynamic Preempt: lazy
[    1.498320] rcu: Preemptible hierarchical RCU implementation.
[    1.498375] rcu: =09RCU event tracing is enabled.
[    1.498404] rcu: =09RCU restricting CPUs from NR_CPUS=3D64 to nr_cpu_ids=
=3D2.
[    1.498525] =09Trampoline variant of Tasks RCU enabled.
[    1.498534] =09Tracing variant of Tasks RCU enabled.
[    1.498597] rcu: RCU calculated value of scheduler-enlistment delay is 1=
00 jiffies.
[    1.498626] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    1.501758] RCU Tasks: Setting shift to 1 and lim to 1 rcu_task_cb_adjus=
t=3D1 rcu_task_cpu_ids=3D2.
[    1.665440] NR_IRQS: 4352, nr_irqs: 440, preallocated irqs: 16
[    1.678331] rcu: srcu_init: Setting srcu_struct sizes based on contentio=
n.
[    1.680026] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 1911260446275000 ns
[    1.692858] Console: colour VGA+ 80x25
[    1.696300] printk: console [ttyS0] enabled
[    1.722675] ACPI: Core revision 20260408
[    1.734228] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, =
max_idle_ns: 19112604467 ns
[    1.740661] APIC: Switch to symmetric I/O mode setup
[    1.748070] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    1.754412] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles:=
 0x3f954527d28, max_idle_ns: 440795246705 ns
[    1.755306] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 8822.15 BogoMIPS (lpj=3D4411077)
[    1.761139] Last level iTLB entries: 4KB 512, 2MB 255, 4MB 127
[    1.761462] Last level dTLB entries: 4KB 512, 2MB 255, 4MB 127, 1GB 0
[    1.762093] mitigations: Enabled attack vectors: user_kernel, user_user,=
 SMT mitigations: auto
[    1.762856] Spectre V2 : Mitigation: Retpolines
[    1.763311] Spectre V1 : Mitigation: usercopy/swapgs barriers and __user=
 pointer sanitization
[    1.763709] Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context=
 switch and VMEXIT
[    1.767589] x86/fpu: x87 FPU will use FXSAVE
[    2.014122] pid_max: default: 32768 minimum: 301
[    2.030144] SELinux:  Initializing.
[    2.038638] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes,=
 linear)
[    2.039071] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 b=
ytes, linear)
[    2.056171] VFS: Finished mounting rootfs on nullfs
[    2.192058] smpboot: CPU0: AMD QEMU Virtual CPU version 2.5+ (family: 0x=
f, model: 0x6b, stepping: 0x1)
[    2.213525] Performance Events: PMU not available due to virtualization,=
 using software events only.
[    2.217540] signal: max sigframe size: 1440
[    2.222679] rcu: Hierarchical SRCU implementation.
[    2.222960] rcu: =09Max phase no-delay instances is 400.
[    2.225720] Timer migration: 1 hierarchy levels; 8 children per group; 1=
 crossnode level
[    2.239200] smp: Bringing up secondary CPUs ...
[    2.253886] smpboot: x86: Booting SMP configuration:
[    2.254247] .... node  #0, CPUs:      #1
[    2.333380] smp: Brought up 1 node, 2 CPUs
[    2.334293] smpboot: Total of 2 processors activated (17648.12 BogoMIPS)
[    2.349487] Memory: 1641620K/2096632K available (68311K kernel code, 105=
70K rwdata, 15608K rodata, 7884K init, 836K bss, 448520K reserved, 0K cma-r=
eserved)
[    2.363814] devtmpfs: initialized
[    2.420059] posixtimers hash table entries: 1024 (order: 2, 16384 bytes,=
 linear)
[    2.469313] futex hash table entries: 512 (32768 bytes on 1 NUMA nodes, =
total 32 KiB, linear).
[    2.478189] PM: RTC time: 10:14:19, date: 2026-11-11
[    2.490473] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    2.498397] audit: initializing netlink subsys (disabled)
[    2.502477] audit: type=3D2000 audit(1794392059.761:1): state=3Dinitiali=
zed audit_enabled=3D0 res=3D1
[    2.511330] thermal_sys: Registered thermal governor 'step_wise'
[    2.512373] cpuidle: using governor menu
[    2.520289] PCI: Using configuration type 1 for base access
[    2.521378] mtrr: your CPUs had inconsistent fixed MTRR settings
[    2.521754] mtrr: your CPUs had inconsistent variable MTRR settings
[    2.521958] mtrr: your CPUs had inconsistent MTRRdefType settings
[    2.522105] mtrr: probably your BIOS does not setup all CPUs.
[    2.522300] mtrr: corrected configuration.
[    2.526909] kprobes: kprobe jump-optimization is enabled. All kprobes ar=
e optimized if possible.
[    2.535984] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 page=
s
[    2.536682] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
[    2.550235] ACPI: Added _OSI(Module Device)
[    2.550296] ACPI: Added _OSI(Processor Device)
[    2.550304] ACPI: Added _OSI(Processor Aggregator Device)
[    2.720617] ACPI: 1 ACPI AML tables successfully acquired and loaded
[    2.759909] ACPI: \_SB_: platform _OSC: OS support mask [002a7eee]
[    2.782148] ACPI: Interpreter enabled
[    2.794361] ACPI: PM: (supports S0 S3 S4 S5)
[    2.794525] ACPI: Using IOAPIC for interrupt routing
[    2.796961] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    2.797859] PCI: Using E820 reservations for host bridge windows
[    2.808510] ACPI: Enabled 2 GPEs in block 00 to 0F
[    3.126225] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.128757] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended configuration space under this bridge
[    3.136648] PCI host bridge to bus 0000:00
[    3.137811] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window=
]
[    3.138118] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window=
]
[    3.138151] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f window]
[    3.138185] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f window]
[    3.138210] pci_bus 0000:00: root bus resource [mem 0x100000000-0x17ffff=
fff window]
[    3.138406] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.138564] acpi PNP0A03:00: OS native features: SHPCHotplug- PCIeHotplu=
g- PME- AER- DPC- LTR-
[    3.143148] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000 convent=
ional PCI endpoint
[    3.154603] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100 convent=
ional PCI endpoint
[    3.161811] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180 convent=
ional PCI endpoint
[    3.163437] pci 0000:00:01.1: BAR 4 [io  0xc040-0xc04f]
[    3.163544] pci 0000:00:01.1: BAR 0 [io  0x01f0-0x01f7]: legacy IDE quir=
k
[    3.163571] pci 0000:00:01.1: BAR 1 [io  0x03f6]: legacy IDE quirk
[    3.163602] pci 0000:00:01.1: BAR 2 [io  0x0170-0x0177]: legacy IDE quir=
k
[    3.163625] pci 0000:00:01.1: BAR 3 [io  0x0376]: legacy IDE quirk
[    3.171190] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000 convent=
ional PCI endpoint
[    3.172509] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    3.172596] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    3.178318] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000 convent=
ional PCI endpoint
[    3.179410] pci 0000:00:02.0: BAR 0 [mem 0xfd000000-0xfdffffff pref]
[    3.179549] pci 0000:00:02.0: BAR 2 [mem 0xfebb0000-0xfebb0fff]
[    3.179564] pci 0000:00:02.0: ROM [mem 0xfeba0000-0xfebaffff pref]
[    3.181906] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x0=
00c0000-0x000dffff]
[    3.188499] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000 convent=
ional PCI endpoint
[    3.190075] pci 0000:00:03.0: BAR 0 [mem 0xfeb80000-0xfeb9ffff]
[    3.190164] pci 0000:00:03.0: BAR 1 [io  0xc000-0xc03f]
[    3.190181] pci 0000:00:03.0: ROM [mem 0xfeb00000-0xfeb7ffff pref]
[    3.333589] ACPI: PCI: Interrupt link LNKA configured for IRQ 10
[    3.351191] ACPI: PCI: Interrupt link LNKB configured for IRQ 10
[    3.363970] ACPI: PCI: Interrupt link LNKC configured for IRQ 11
[    3.373689] ACPI: PCI: Interrupt link LNKD configured for IRQ 11
[    3.377733] ACPI: PCI: Interrupt link LNKS configured for IRQ 9
[    3.404328] iommu: Default domain type: Translated
[    3.404404] iommu: DMA domain TLB invalidation policy: lazy mode
[    3.411848] SCSI subsystem initialized
[    3.417639] ACPI: bus type USB registered
[    3.419567] usbcore: registered new interface driver usbfs
[    3.420695] usbcore: registered new interface driver hub
[    3.421951] usbcore: registered new device driver usb
[    3.422965] mc: Linux media interface: v0.10
[    3.423763] videodev: Linux video capture interface: v2.00
[    3.424614] pps_core: LinuxPPS API ver. 1 registered
[    3.424674] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    3.425696] PTP clock support registered
[    3.431392] Advanced Linux Sound Architecture Driver Initialized.
[    3.453717] NetLabel: Initializing
[    3.453789] NetLabel:  domain hash size =3D 128
[    3.453807] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    3.455805] NetLabel:  unlabeled traffic allowed by default
[    3.464143] PCI: Using ACPI for IRQ routing
[    3.464854] e820: register RAM buffer resource [mem 0x0009fc00-0x0009fff=
f]
[    3.466397] e820: register RAM buffer resource [mem 0x7ffe0000-0x7ffffff=
f]
[    3.470926] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    3.471012] pci 0000:00:02.0: vgaarb: bridge control possible
[    3.471058] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+mem=
,owns=3Dio+mem,locks=3Dnone
[    3.471133] vgaarb: loaded
[    3.474925] hpet: 3 channels of 0 reserved for per-cpu timers
[    3.475310] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    3.475436] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    3.481958] clocksource: Switched to clocksource tsc-early
[    3.658242] VFS: Disk quotas dquot_6.6.0
[    3.658748] VFS: Dquot-cache hash table entries: 512 (4096 bytes)
[    3.676298] pnp: PnP ACPI init
[    3.711731] pnp: PnP ACPI: found 5 devices
[    3.734086] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, m=
ax_idle_ns: 2085701024 ns
[    3.736149] NET: Registered PF_INET protocol family
[    3.741489] IP idents hash table entries: 32768 (order: 6, 262144 bytes,=
 linear)
[    3.764674] tcp_listen_portaddr_hash hash table entries: 1024 (order: 2,=
 16384 bytes, linear)
[    3.764843] Table-perturb hash table entries: 65536 (order: 6, 262144 by=
tes, linear)
[    3.765061] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes, linear)
[    3.765643] TCP bind hash table entries: 16384 (order: 7, 524288 bytes, =
linear)
[    3.766604] TCP: Hash tables configured (established 16384 bind 16384)
[    3.768276] UDP hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    3.772678] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    3.781672] RPC: Registered named UNIX socket transport module.
[    3.781729] RPC: Registered udp transport module.
[    3.781738] RPC: Registered tcp transport module.
[    3.781746] RPC: Registered tcp-with-tls transport module.
[    3.781753] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.790934] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    3.791069] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    3.791094] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff windo=
w]
[    3.791107] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff windo=
w]
[    3.791117] pci_bus 0000:00: resource 8 [mem 0x100000000-0x17fffffff win=
dow]
[    3.794185] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.794875] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.795214] PCI: CLS 0 bytes, default 64
[    3.802675] NET: Registered PF_INET6 protocol family
[    3.852891] Segment Routing with IPv6
[    3.854061] In-situ OAM (IOAM) with IPv6
[    3.864918] Unpacking initramfs...
[    3.883704] Initialise system trusted keyrings
[    3.891206] workingset: timestamp_bits=3D56 (anon: 51) max_order=3D19 bu=
cket_order=3D0 (anon: 0)
[    3.900772] Key type nfs_keyring registered
[    3.906812] NFS: Registering the id_resolver key type
[    3.907187] Key type id_resolver registered
[    3.907222] Key type id_legacy registered
[    3.908153] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    3.908295] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Driver Regist=
ering...
[    3.911091] 9p: Installing v9fs 9p2000 file system support
[    3.924107] Key type asymmetric registered
[    3.924232] Asymmetric key parser 'x509' registered
[    3.926164] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    3.930007] io scheduler mq-deadline registered
[    3.930121] io scheduler kyber registered
[    3.940260] input: Power Button as /devices/platform/LNXPWRBN:00/input/i=
nput0
[    3.943795] ACPI: button: Power Button [PWRF]
[    3.960710] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.965713] Freeing initrd memory: 1088K
[    3.975664] 00:04: ttyS0 I/O:0x3f8 (irq =3D 4, base_baud =3D 115200) is =
a 16550A
[    4.041628] Non-volatile memory driver v1.3
[    4.046279] ACPI: bus type drm_connector registered
[    4.170926] loop: module loaded
[    4.203600] scsi host0: ata_piix
[    4.212106] scsi host1: ata_piix
[    4.214790] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 1=
4 lpm-pol 0
[    4.214876] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 1=
5 lpm-pol 0
[    4.226127] e100: Intel(R) PRO/100 Network Driver
[    4.226196] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.226896] e1000: Intel(R) PRO/1000 Network Driver
[    4.226944] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.381035] ata2: found unknown device (class 0)
[    4.393101] ata2.00: ATAPI: QEMU DVD-ROM, 2.5+, max UDMA/100
[    4.416174] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.=
5+ PQ: 0 ANSI: 5
[    4.486494] sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    4.511253] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.542922] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    4.908511] tsc: Refined TSC clocksource calibration: 4418.811 MHz
[    4.908945] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x3fb=
1cffa72d, max_idle_ns: 440795418362 ns
[    4.911589] clocksource: Switched to clocksource tsc
[    7.299742] clocksource: Marking clocksource tsc unstable due to frequen=
cy skew
[    7.299960] clocksource: Watchdog                    hpet interval:     =
   503697360ns
[    7.300067] clocksource: Clocksource                  tsc interval:     =
   503991244ns
[    7.300129] tsc: Marking TSC unstable due to clocksource watchdog
[    7.314214] clocksource: Switched to clocksource hpet
[    7.319818] kwatchdog (65) used greatest stack depth: 30512 bytes left
[   12.011684] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[   12.338533] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:5=
6
[   12.339845] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connectio=
n
[   12.341741] e1000e: Intel(R) PRO/1000 Network Driver
[   12.341801] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[   12.373134] sky2: driver version 1.30
[   12.384441] usbcore: registered new interface driver usblp
[   12.384917] usbcore: registered new interface driver usb-storage
[   12.387322] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   12.394073] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.395663] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.407307] rtc_cmos PNP0B00:00: RTC can wake from S4
[   12.411884] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   12.420436] rtc_cmos PNP0B00:00: registered as rtc0
[   12.424314] rtc_cmos PNP0B00:00: alarms up to one day, y3k, 242 bytes nv=
ram, hpet irqs
[   12.432508] device-mapper: ioctl: 4.50.0-ioctl (2025-04-28) initialised:=
 dm-devel@lists.linux.dev
[   12.447807] hid: raw HID events driver (C) Jiri Kosina
[   12.452553] usbcore: registered new interface driver usbhid
[   12.452611] usbhid: USB HID core driver
[   12.468855] nf_conntrack_irc: The irc conntrack helper is scheduled for =
removal.
[   12.468855] Please contact the netfilter-devel mailing list if you still=
 need this.
[   12.479279] Initializing XFRM netlink socket
[   12.481079] NET: Registered PF_PACKET protocol family
[   12.483007] RPC: Registered rdma transport module.
[   12.483060] RPC: Registered rdma backchannel transport module.
[   12.483683] 9pnet: Installing 9P2000 support
[   12.484710] Key type dns_resolver registered
[   12.492697] IPI shorthand broadcast: enabled
[   12.852844] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   13.031039] registered taskstats version 1
[   13.031168] Loading compiled-in X.509 certificates
[   13.225911] Demotion targets for Node 0: null
[   13.241159] PM:   Magic number: 2:86:224
[   13.243138] netconsole: network logging started
[   13.248112] cfg80211: Loading compiled-in X.509 certificates for regulat=
ory database
[   13.269109] kworker/u8:2 (70) used greatest stack depth: 29672 bytes lef=
t
[   13.298769] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   13.302190] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db1=
8c600'
[   13.306942] Unstable clock detected, switching default tracing clock to =
"global"
[   13.306942] If you want to keep using the local clock, then add:
[   13.306942]   "trace_clock=3Dlocal"
[   13.306942] on the kernel command line
[   13.307130] faux_driver regulatory: Direct firmware load for regulatory.=
db failed with error -2
[   13.307980] cfg80211: failed to load regulatory.db
[   13.315125] PM: genpd: Disabling unused power domains
[   13.315208] ALSA device list:
[   13.315275]   No soundcards found.
[   13.411939] Freeing unused kernel image (initmem) memory: 7884K
[   13.412333] Write protecting the kernel read-only data: 86016k
[   13.419210] Freeing unused kernel image (text/rodata gap) memory: 1320K
[   13.422138] Freeing unused kernel image (rodata/data gap) memory: 776K
[   13.559433] x86/mm: Checked W+X mappings: passed, no W+X pages found.
[   13.559959] Run /init as init process
[   13.734483] busybox (73) used greatest stack depth: 28536 bytes left
MLX5-DCT-REPRO: loading reproducer
[   13.847526] mlx5_dct_repro: loading out-of-tree module taints kernel.
[   13.915884] MLX5-DCT-REPRO: forcing DRAIN_DCT to fail with command inter=
face down
[   13.916736] MLX5-DCT-REPRO: destroy failed as required: -67
[   13.916817] MLX5-DCT-REPRO: failed destroy retained DCT ffff88800b112c58=
 in dct_xa
[   13.916862] MLX5-DCT-REPRO: mimicking DEVX create unwind kfree(ffff88800=
b112c00)
[   13.916924] MLX5-DCT-REPRO: delivering DCT_DRAINED event through actual =
notifier
[   13.917219] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x=
38/0x90
[   13.917427] Write of size 4 at addr ffff88800b112cb0 by task insmod/77
[   13.917427]=20
[   13.917427] CPU: 0 UID: 0 PID: 77 Comm: insmod Tainted: G           O   =
     7.4.0-rc1-g05441d697f7f #2 PREEMPT(lazy)=20
[   13.917427] Tainted: [O]=3DOOT_MODULE
[   13.917427] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   13.917427] Call Trace:
[   13.917427]  <TASK>
[   13.917427]  dump_stack_lvl+0x43/0x60
[   13.917427]  print_address_description+0x77/0x200
[   13.917427]  ? _raw_spin_lock_irqsave+0x38/0x90
[   13.917427]  print_report+0x58/0x70
[   13.917427]  kasan_report+0x117/0x150
[   13.917427]  ? _raw_spin_lock_irqsave+0x38/0x90
[   13.917427]  kasan_check_range+0x264/0x2c0
[   13.917427]  _raw_spin_lock_irqsave+0x38/0x90
[   13.917427]  complete+0x28/0x1b0
[   13.917427]  rsc_event_notifier+0x1fc/0x410
[   13.917427]  init_module+0x454/0xff0 [mlx5_dct_repro]
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  ? mlx5_core_destroy_dct+0x4/0x410
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  ? __pfx_init_module+0x10/0x10 [mlx5_dct_repro]
[   13.917427]  ? kasan_save_track+0x4f/0x80
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  ? do_init_module+0x5c/0x670
[   13.917427]  ? __se_sys_finit_module+0x34e/0x540
[   13.917427]  ? do_syscall_64+0x109/0x330
[   13.917427]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]  ? read_hpet+0xd6/0x150
[   13.917427]  ? ktime_get+0x103/0x140
[   13.917427]  ? lapic_next_event+0x11/0x20
[   13.917427]  ? clockevents_program_event+0x1e3/0x440
[   13.917427]  ? __hrtimer_rearm_deferred+0x1fb/0x380
[   13.917427]  ? irqentry_exit+0x574/0x600
[   13.917427]  ? resolve_function+0xb0/0xb0 [mlx5_dct_repro]
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? kasan_unpoison+0x48/0x70
[   13.917427]  ? __asan_register_globals+0x59/0x80
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427] RIP: 0033:0x46716d
[   13.917427] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   13.917427] RSP: 002b:00007ffd4b5afcd8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   13.917427] RAX: ffffffffffffffda RBX: 000000002e8dbb90 RCX: 00000000004=
6716d
[   13.917427] RDX: 0000000000000000 RSI: 000000002e8dbb90 RDI: 00000000000=
00003
[   13.917427] RBP: 00007ffd4b5afd10 R08: 0000000000000020 R09: 00000000000=
00004
[   13.917427] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   13.917427] R13: 000000002e8dad08 R14: 000000002e8dad40 R15: 00000000000=
00000
[   13.917427]  </TASK>
[   13.917427]=20
[   13.917427] Allocated by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  __kasan_kmalloc+0x72/0x90
[   13.917427]  __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  init_module+0x167/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] Freed by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  kasan_save_free_info+0x40/0x50
[   13.917427]  __kasan_slab_free+0x3a/0x60
[   13.917427]  kfree+0x11c/0x390
[   13.917427]  init_module+0x424/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] The buggy address belongs to the object at ffff88800b112c00
[   13.917427]  which belongs to the cache kmalloc-512 of size 512
[   13.917427] The buggy address is located 176 bytes inside of
[   13.917427]  freed 512-byte region [ffff88800b112c00, ffff88800b112e00)
[   13.917427]=20
[   13.917427] The buggy address belongs to the physical page:
[   13.917427] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0xb110
[   13.917427] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0=
 pincount:0
MLX5-DCT-REPRO: test completed; inspect the KASAN report above
[   13.917427] flags: 0x100000000000040(head|node=3D0|zone=3D1)
[   13.917427] page_type: f5(slab)
[   13.917427] raw: 0100000000000040 ffff888008441c80 dead000000000100 dead=
000000000122
[   13.917427] raw: 0000000000000000 0000000000100010 00000000f5000000 0000=
000000000000
[   13.917427] head: 0100000000000040 ffff888008441c80 dead000000000100 dea=
d000000000122
[   13.917427] head: 0000000000000000 0000000000100010 00000000f5000000 000=
0000000000000
[   13.917427] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 000=
00000ffffffff
[   13.917427] head: 0000000000000000 0000000000000000 00000000ffffffff 000=
0000000000000
[   13.917427] page dumped because: kasan: bad access detected
[   13.917427]=20
[   13.917427] Memory state around the buggy address:
[   13.917427]  ffff88800b112b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   13.917427]  ffff88800b112c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] >ffff88800b112c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]                                      ^
[   13.917427]  ffff88800b112d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]  ffff88800b112d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] Disabling lock debugging due to kernel taint
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] BUG: KASAN: slab-use-after-free in complete+0x189/0x1b0
[   13.917427] Read of size 4 at addr ffff88800b112ca8 by task insmod/77
[   13.917427]=20
[   13.917427] CPU: 0 UID: 0 PID: 77 Comm: insmod Tainted: G    B      O   =
     7.4.0-rc1-g05441d697f7f #2 PREEMPT(lazy)=20
[   13.917427] Tainted: [B]=3DBAD_PAGE, [O]=3DOOT_MODULE
[   13.917427] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   13.917427] Call Trace:
[   13.917427]  <TASK>
[   13.917427]  dump_stack_lvl+0x43/0x60
[   13.917427]  print_address_description+0x77/0x200
[   13.917427]  ? complete+0x189/0x1b0
[   13.917427]  print_report+0x58/0x70
[   13.917427]  kasan_report+0x117/0x150
[   13.917427]  ? complete+0x189/0x1b0
[   13.917427]  complete+0x189/0x1b0
[   13.917427]  rsc_event_notifier+0x1fc/0x410
[   13.917427]  init_module+0x454/0xff0 [mlx5_dct_repro]
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  ? mlx5_core_destroy_dct+0x4/0x410
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  ? __pfx_init_module+0x10/0x10 [mlx5_dct_repro]
[   13.917427]  ? kasan_save_track+0x4f/0x80
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  ? do_init_module+0x5c/0x670
[   13.917427]  ? __se_sys_finit_module+0x34e/0x540
[   13.917427]  ? do_syscall_64+0x109/0x330
[   13.917427]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]  ? read_hpet+0xd6/0x150
[   13.917427]  ? ktime_get+0x103/0x140
[   13.917427]  ? lapic_next_event+0x11/0x20
[   13.917427]  ? clockevents_program_event+0x1e3/0x440
[   13.917427]  ? __hrtimer_rearm_deferred+0x1fb/0x380
[   13.917427]  ? irqentry_exit+0x574/0x600
[   13.917427]  ? resolve_function+0xb0/0xb0 [mlx5_dct_repro]
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? kasan_unpoison+0x48/0x70
[   13.917427]  ? __asan_register_globals+0x59/0x80
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427] RIP: 0033:0x46716d
[   13.917427] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   13.917427] RSP: 002b:00007ffd4b5afcd8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   13.917427] RAX: ffffffffffffffda RBX: 000000002e8dbb90 RCX: 00000000004=
6716d
[   13.917427] RDX: 0000000000000000 RSI: 000000002e8dbb90 RDI: 00000000000=
00003
[   13.917427] RBP: 00007ffd4b5afd10 R08: 0000000000000020 R09: 00000000000=
00004
[   13.917427] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   13.917427] R13: 000000002e8dad08 R14: 000000002e8dad40 R15: 00000000000=
00000
[   13.917427]  </TASK>
[   13.917427]=20
[   13.917427] Allocated by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  __kasan_kmalloc+0x72/0x90
[   13.917427]  __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  init_module+0x167/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] Freed by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  kasan_save_free_info+0x40/0x50
[   13.917427]  __kasan_slab_free+0x3a/0x60
[   13.917427]  kfree+0x11c/0x390
[   13.917427]  init_module+0x424/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] The buggy address belongs to the object at ffff88800b112c00
[   13.917427]  which belongs to the cache kmalloc-512 of size 512
[   13.917427] The buggy address is located 168 bytes inside of
[   13.917427]  freed 512-byte region [ffff88800b112c00, ffff88800b112e00)
[   13.917427]=20
[   13.917427] The buggy address belongs to the physical page:
[   13.917427] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0xb110
[   13.917427] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0=
 pincount:0
[   13.917427] flags: 0x100000000000040(head|node=3D0|zone=3D1)
[   13.917427] page_type: f5(slab)
[   13.917427] raw: 0100000000000040 ffff888008441c80 dead000000000100 dead=
000000000122
[   13.917427] raw: 0000000000000000 0000000000100010 00000000f5000000 0000=
000000000000
[   13.917427] head: 0100000000000040 ffff888008441c80 dead000000000100 dea=
d000000000122
[   13.917427] head: 0000000000000000 0000000000100010 00000000f5000000 000=
0000000000000
[   13.917427] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 000=
00000ffffffff
[   13.917427] head: 0000000000000000 0000000000000000 00000000ffffffff 000=
0000000000000
[   13.917427] page dumped because: kasan: bad access detected
[   13.917427]=20
[   13.917427] Memory state around the buggy address:
[   13.917427]  ffff88800b112b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   13.917427]  ffff88800b112c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] >ffff88800b112c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]                                   ^
[   13.917427]  ffff88800b112d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]  ffff88800b112d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] BUG: KASAN: slab-use-after-free in complete+0x1a7/0x1b0
[   13.917427] Write of size 4 at addr ffff88800b112ca8 by task insmod/77
[   13.917427]=20
[   13.917427] CPU: 0 UID: 0 PID: 77 Comm: insmod Tainted: G    B      O   =
     7.4.0-rc1-g05441d697f7f #2 PREEMPT(lazy)=20
[   13.917427] Tainted: [B]=3DBAD_PAGE, [O]=3DOOT_MODULE
[   13.917427] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   13.917427] Call Trace:
[   13.917427]  <TASK>
[   13.917427]  dump_stack_lvl+0x43/0x60
[   13.917427]  print_address_description+0x77/0x200
[   13.917427]  ? complete+0x1a7/0x1b0
[   13.917427]  print_report+0x58/0x70
[   13.917427]  kasan_report+0x117/0x150
[   13.917427]  ? complete+0x1a7/0x1b0
[   13.917427]  complete+0x1a7/0x1b0
[   13.917427]  rsc_event_notifier+0x1fc/0x410
[   13.917427]  init_module+0x454/0xff0 [mlx5_dct_repro]
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  ? mlx5_core_destroy_dct+0x4/0x410
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  ? __pfx_init_module+0x10/0x10 [mlx5_dct_repro]
[   13.917427]  ? kasan_save_track+0x4f/0x80
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  ? do_init_module+0x5c/0x670
[   13.917427]  ? __se_sys_finit_module+0x34e/0x540
[   13.917427]  ? do_syscall_64+0x109/0x330
[   13.917427]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]  ? read_hpet+0xd6/0x150
[   13.917427]  ? ktime_get+0x103/0x140
[   13.917427]  ? lapic_next_event+0x11/0x20
[   13.917427]  ? clockevents_program_event+0x1e3/0x440
[   13.917427]  ? __hrtimer_rearm_deferred+0x1fb/0x380
[   13.917427]  ? irqentry_exit+0x574/0x600
[   13.917427]  ? resolve_function+0xb0/0xb0 [mlx5_dct_repro]
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? kasan_unpoison+0x48/0x70
[   13.917427]  ? __asan_register_globals+0x59/0x80
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427] RIP: 0033:0x46716d
[   13.917427] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   13.917427] RSP: 002b:00007ffd4b5afcd8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   13.917427] RAX: ffffffffffffffda RBX: 000000002e8dbb90 RCX: 00000000004=
6716d
[   13.917427] RDX: 0000000000000000 RSI: 000000002e8dbb90 RDI: 00000000000=
00003
[   13.917427] RBP: 00007ffd4b5afd10 R08: 0000000000000020 R09: 00000000000=
00004
[   13.917427] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   13.917427] R13: 000000002e8dad08 R14: 000000002e8dad40 R15: 00000000000=
00000
[   13.917427]  </TASK>
[   13.917427]=20
[   13.917427] Allocated by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  __kasan_kmalloc+0x72/0x90
[   13.917427]  __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  init_module+0x167/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] Freed by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  kasan_save_free_info+0x40/0x50
[   13.917427]  __kasan_slab_free+0x3a/0x60
[   13.917427]  kfree+0x11c/0x390
[   13.917427]  init_module+0x424/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] The buggy address belongs to the object at ffff88800b112c00
[   13.917427]  which belongs to the cache kmalloc-512 of size 512
[   13.917427] The buggy address is located 168 bytes inside of
[   13.917427]  freed 512-byte region [ffff88800b112c00, ffff88800b112e00)
[   13.917427]=20
[   13.917427] The buggy address belongs to the physical page:
[   13.917427] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0xb110
[   13.917427] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0=
 pincount:0
[   13.917427] flags: 0x100000000000040(head|node=3D0|zone=3D1)
[   13.917427] page_type: f5(slab)
[   13.917427] raw: 0100000000000040 ffff888008441c80 dead000000000100 dead=
000000000122
[   13.917427] raw: 0000000000000000 0000000000100010 00000000f5000000 0000=
000000000000
[   13.917427] head: 0100000000000040 ffff888008441c80 dead000000000100 dea=
d000000000122
[   13.917427] head: 0000000000000000 0000000000100010 00000000f5000000 000=
0000000000000
[   13.917427] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 000=
00000ffffffff
[   13.917427] head: 0000000000000000 0000000000000000 00000000ffffffff 000=
0000000000000
[   13.917427] page dumped because: kasan: bad access detected
[   13.917427]=20
[   13.917427] Memory state around the buggy address:
[   13.917427]  ffff88800b112b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   13.917427]  ffff88800b112c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] >ffff88800b112c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]                                   ^
[   13.917427]  ffff88800b112d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]  ffff88800b112d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] BUG: KASAN: slab-use-after-free in complete+0x76/0x1b0
[   13.917427] Read of size 8 at addr ffff88800b112cb8 by task insmod/77
[   13.917427]=20
[   13.917427] CPU: 0 UID: 0 PID: 77 Comm: insmod Tainted: G    B      O   =
     7.4.0-rc1-g05441d697f7f #2 PREEMPT(lazy)=20
[   13.917427] Tainted: [B]=3DBAD_PAGE, [O]=3DOOT_MODULE
[   13.917427] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   13.917427] Call Trace:
[   13.917427]  <TASK>
[   13.917427]  dump_stack_lvl+0x43/0x60
[   13.917427]  print_address_description+0x77/0x200
[   13.917427]  ? complete+0x76/0x1b0
[   13.917427]  print_report+0x58/0x70
[   13.917427]  kasan_report+0x117/0x150
[   13.917427]  ? complete+0x76/0x1b0
[   13.917427]  complete+0x76/0x1b0
[   13.917427]  rsc_event_notifier+0x1fc/0x410
[   13.917427]  init_module+0x454/0xff0 [mlx5_dct_repro]
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  ? mlx5_core_destroy_dct+0x4/0x410
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  ? __pfx_init_module+0x10/0x10 [mlx5_dct_repro]
[   13.917427]  ? kasan_save_track+0x4f/0x80
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  ? do_init_module+0x5c/0x670
[   13.917427]  ? __se_sys_finit_module+0x34e/0x540
[   13.917427]  ? do_syscall_64+0x109/0x330
[   13.917427]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]  ? read_hpet+0xd6/0x150
[   13.917427]  ? ktime_get+0x103/0x140
[   13.917427]  ? lapic_next_event+0x11/0x20
[   13.917427]  ? clockevents_program_event+0x1e3/0x440
[   13.917427]  ? __hrtimer_rearm_deferred+0x1fb/0x380
[   13.917427]  ? irqentry_exit+0x574/0x600
[   13.917427]  ? resolve_function+0xb0/0xb0 [mlx5_dct_repro]
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? kasan_unpoison+0x48/0x70
[   13.917427]  ? __asan_register_globals+0x59/0x80
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427] RIP: 0033:0x46716d
[   13.917427] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   13.917427] RSP: 002b:00007ffd4b5afcd8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   13.917427] RAX: ffffffffffffffda RBX: 000000002e8dbb90 RCX: 00000000004=
6716d
[   13.917427] RDX: 0000000000000000 RSI: 000000002e8dbb90 RDI: 00000000000=
00003
[   13.917427] RBP: 00007ffd4b5afd10 R08: 0000000000000020 R09: 00000000000=
00004
[   13.917427] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   13.917427] R13: 000000002e8dad08 R14: 000000002e8dad40 R15: 00000000000=
00000
[   13.917427]  </TASK>
[   13.917427]=20
[   13.917427] Allocated by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  __kasan_kmalloc+0x72/0x90
[   13.917427]  __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  init_module+0x167/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] Freed by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  kasan_save_free_info+0x40/0x50
[   13.917427]  __kasan_slab_free+0x3a/0x60
[   13.917427]  kfree+0x11c/0x390
[   13.917427]  init_module+0x424/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] The buggy address belongs to the object at ffff88800b112c00
[   13.917427]  which belongs to the cache kmalloc-512 of size 512
[   13.917427] The buggy address is located 184 bytes inside of
[   13.917427]  freed 512-byte region [ffff88800b112c00, ffff88800b112e00)
[   13.917427]=20
[   13.917427] The buggy address belongs to the physical page:
[   13.917427] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0xb110
[   13.917427] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0=
 pincount:0
[   13.917427] flags: 0x100000000000040(head|node=3D0|zone=3D1)
[   13.917427] page_type: f5(slab)
[   13.917427] raw: 0100000000000040 ffff888008441c80 dead000000000100 dead=
000000000122
[   13.917427] raw: 0000000000000000 0000000000100010 00000000f5000000 0000=
000000000000
[   13.917427] head: 0100000000000040 ffff888008441c80 dead000000000100 dea=
d000000000122
[   13.917427] head: 0000000000000000 0000000000100010 00000000f5000000 000=
0000000000000
[   13.917427] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 000=
00000ffffffff
[   13.917427] head: 0000000000000000 0000000000000000 00000000ffffffff 000=
0000000000000
[   13.917427] page dumped because: kasan: bad access detected
[   13.917427]=20
[   13.917427] Memory state around the buggy address:
[   13.917427]  ffff88800b112b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   13.917427]  ffff88800b112c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] >ffff88800b112c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]                                         ^
[   13.917427]  ffff88800b112d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]  ffff88800b112d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.917427] BUG: KASAN: slab-use-after-free in _raw_spin_unlock_irqresto=
re+0x5a/0x70
[   13.917427] Write of size 1 at addr ffff88800b112cb0 by task insmod/77
[   13.917427]=20
[   13.917427] CPU: 0 UID: 0 PID: 77 Comm: insmod Tainted: G    B      O   =
     7.4.0-rc1-g05441d697f7f #2 PREEMPT(lazy)=20
[   13.917427] Tainted: [B]=3DBAD_PAGE, [O]=3DOOT_MODULE
[   13.917427] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_=
caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   13.917427] Call Trace:
[   13.917427]  <TASK>
[   13.917427]  dump_stack_lvl+0x43/0x60
[   13.917427]  print_address_description+0x77/0x200
[   13.917427]  ? _raw_spin_unlock_irqrestore+0x5a/0x70
[   13.917427]  print_report+0x58/0x70
[   13.917427]  kasan_report+0x117/0x150
[   13.917427]  ? _raw_spin_unlock_irqrestore+0x5a/0x70
[   13.917427]  _raw_spin_unlock_irqrestore+0x5a/0x70
[   13.917427]  rsc_event_notifier+0x1fc/0x410
[   13.917427]  init_module+0x454/0xff0 [mlx5_dct_repro]
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  ? mlx5_core_destroy_dct+0x4/0x410
[   13.917427]  ? rsc_event_notifier+0x4/0x410
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  ? __pfx_init_module+0x10/0x10 [mlx5_dct_repro]
[   13.917427]  ? kasan_save_track+0x4f/0x80
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  ? do_init_module+0x5c/0x670
[   13.917427]  ? __se_sys_finit_module+0x34e/0x540
[   13.917427]  ? do_syscall_64+0x109/0x330
[   13.917427]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]  ? read_hpet+0xd6/0x150
[   13.917427]  ? ktime_get+0x103/0x140
[   13.917427]  ? lapic_next_event+0x11/0x20
[   13.917427]  ? clockevents_program_event+0x1e3/0x440
[   13.917427]  ? __hrtimer_rearm_deferred+0x1fb/0x380
[   13.917427]  ? irqentry_exit+0x574/0x600
[   13.917427]  ? resolve_function+0xb0/0xb0 [mlx5_dct_repro]
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? __kasan_kmalloc+0x72/0x90
[   13.917427]  ? kasan_save_track+0x3e/0x80
[   13.917427]  ? kasan_unpoison+0x48/0x70
[   13.917427]  ? __asan_register_globals+0x59/0x80
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427] RIP: 0033:0x46716d
[   13.917427] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48=
> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e0 ff ff ff f7 d8 64 89 01 48
[   13.917427] RSP: 002b:00007ffd4b5afcd8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000139
[   13.917427] RAX: ffffffffffffffda RBX: 000000002e8dbb90 RCX: 00000000004=
6716d
[   13.917427] RDX: 0000000000000000 RSI: 000000002e8dbb90 RDI: 00000000000=
00003
[   13.917427] RBP: 00007ffd4b5afd10 R08: 0000000000000020 R09: 00000000000=
00004
[   13.917427] R10: 00000000006047a0 R11: 0000000000000246 R12: 00000000000=
00003
[   13.917427] R13: 000000002e8dad08 R14: 000000002e8dad40 R15: 00000000000=
00000
[   13.917427]  </TASK>
[   13.917427]=20
[   13.917427] Allocated by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  __kasan_kmalloc+0x72/0x90
[   13.917427]  __kmalloc_cache_noprof+0x162/0x390
[   13.917427]  init_module+0x167/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] Freed by task 77:
[   13.917427]  kasan_save_track+0x3e/0x80
[   13.917427]  kasan_save_free_info+0x40/0x50
[   13.917427]  __kasan_slab_free+0x3a/0x60
[   13.917427]  kfree+0x11c/0x390
[   13.917427]  init_module+0x424/0xff0 [mlx5_dct_repro]
[   13.917427]  do_one_initcall+0x100/0x380
[   13.917427]  do_init_module+0x233/0x670
[   13.917427]  __se_sys_finit_module+0x34e/0x540
[   13.917427]  do_syscall_64+0x109/0x330
[   13.917427]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   13.917427]=20
[   13.917427] The buggy address belongs to the object at ffff88800b112c00
[   13.917427]  which belongs to the cache kmalloc-512 of size 512
[   13.917427] The buggy address is located 176 bytes inside of
[   13.917427]  freed 512-byte region [ffff88800b112c00, ffff88800b112e00)
[   13.917427]=20
[   13.917427] The buggy address belongs to the physical page:
[   13.917427] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0=
x0 pfn:0xb110
[   13.917427] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0=
 pincount:0
[   13.917427] flags: 0x100000000000040(head|node=3D0|zone=3D1)
[   13.917427] page_type: f5(slab)
[   13.917427] raw: 0100000000000040 ffff888008441c80 dead000000000100 dead=
000000000122
[   13.917427] raw: 0000000000000000 0000000000100010 00000000f5000000 0000=
000000000000
[   13.917427] head: 0100000000000040 ffff888008441c80 dead000000000100 dea=
d000000000122
[   13.917427] head: 0000000000000000 0000000000100010 00000000f5000000 000=
0000000000000
[   13.917427] head: 0100000000000002 ffffffffffffff01 00000000ffffffff 000=
00000ffffffff
[   13.917427] head: 0000000000000000 0000000000000000 00000000ffffffff 000=
0000000000000
[   13.917427] page dumped because: kasan: bad access detected
[   13.917427]=20
[   13.917427] Memory state around the buggy address:
[   13.917427]  ffff88800b112b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc=
 fc fc
[   13.917427]  ffff88800b112c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] >ffff88800b112c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]                                      ^
[   13.917427]  ffff88800b112d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427]  ffff88800b112d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb=
 fb fb
[   13.917427] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   13.928450] MLX5-DCT-REPRO: notifier returned after event delivery
[   13.948174] insmod (77) used greatest stack depth: 28008 bytes left
[   19.466696] ACPI: PM: Preparing to enter system sleep state S5
[   19.469308] reboot: Power down

