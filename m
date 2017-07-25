From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] iwpmd: Suppress expected kernel message
Date: Tue, 25 Jul 2017 21:12:54 +0300
Message-ID: <20170725181254.GS3259@mtr-leonro.local>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500935204-6505-4-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170725133030.GR3259@mtr-leonro.local>
 <20170725153608.GA6715@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6UEPj0d4ZbbWkD8I"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725153608.GA6715-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6UEPj0d4ZbbWkD8I
Content-Type: multipart/mixed; boundary="KBjcE0k8Zsqds9qm"
Content-Disposition: inline


--KBjcE0k8Zsqds9qm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 25, 2017 at 09:36:08AM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 25, 2017 at 04:30:30PM +0300, Leon Romanovsky wrote:
> > On Mon, Jul 24, 2017 at 04:26:44PM -0600, Jason Gunthorpe wrote:
> > > RMDA_NL_RSVD was obsoleted a long time ago, but user space still
> > > uses it to support old kernels. Avoid logging:
> > >
> > >  ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list
> > >
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >  drivers/infiniband/core/iwcm.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> >
> > This print should be removed, on my system (Debian), it prints without
> > any relation to iwpmd.
>
> Really? What from?

Yes, I constantly delayed the debug of it :)
Debian 9 + latest rdma-core, see attached log.

ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list


>
> I'm okay with dropping the print too.
>
> Jason

--KBjcE0k8Zsqds9qm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dev-l-vrt-151-010.serial"
Content-Transfer-Encoding: quoted-printable

random: get_random_bytes called from start_kernel+0x42/0x418 with crng_init=
=3D0=0D
Linux version 4.13.0-rc1-00089-g6e4da7d65877 (leonro@dev-l-vrt-151) (gcc ve=
rsion 7.1.1 20170622 (Red Hat 7.1.1-3) (GCC)) #28 SMP Tue Jul 25 17:45:19 I=
DT 2017=0D
Command line: root=3D/dev/vda1 ro earlyprintk=3Dserial,ttyS0,11520n8,keep c=
onsole=3Dtty0 console=3DttyS0,11520n8=0D
x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'=0D
x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'=0D
x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'=0D
x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256=0D
x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'sta=
ndard' format.=0D
e820: BIOS-provided physical RAM map:=0D
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable=0D
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved=0D
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved=0D
BIOS-e820: [mem 0x0000000000100000-0x00000000bffd8fff] usable=0D
BIOS-e820: [mem 0x00000000bffd9000-0x00000000bfffffff] reserved=0D
BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved=0D
BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved=0D
BIOS-e820: [mem 0x0000000100000000-0x000000013fffffff] usable=0D
console [earlyser0] enabled=0D
NX (Execute Disable) protection: active=0D
random: fast init done=0D
SMBIOS 2.8 present.=0D
DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1.fc26 04/01/2014=
=0D
tsc: Using PIT calibration value=0D
e820: last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000=0D
x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  =0D
e820: last_pfn =3D 0xbffd9 max_arch_pfn =3D 0x400000000=0D
found SMP MP-table at [mem 0x000f6bb0-0x000f6bbf] mapped at [ffff8800000f6b=
b0]=0D
ACPI: Early table checksum verification disabled=0D
ACPI: RSDP 0x00000000000F6980 000014 (v00 BOCHS )=0D
ACPI: RSDT 0x00000000BFFE14FD 00002C (v01 BOCHS  BXPCRSDT 00000001 BXPC 000=
00001)=0D
ACPI: FACP 0x00000000BFFE1409 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 000=
00001)=0D
ACPI: DSDT 0x00000000BFFE0040 0013C9 (v01 BOCHS  BXPCDSDT 00000001 BXPC 000=
00001)=0D
ACPI: FACS 0x00000000BFFE0000 000040=0D
ACPI: APIC 0x00000000BFFE147D 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 000=
00001)=0D
Zone ranges:=0D
  DMA      [mem 0x0000000000001000-0x0000000000ffffff]=0D
  DMA32    [mem 0x0000000001000000-0x00000000ffffffff]=0D
  Normal   [mem 0x0000000100000000-0x000000013fffffff]=0D
Movable zone start for each node=0D
Early memory node ranges=0D
  node   0: [mem 0x0000000000001000-0x000000000009efff]=0D
  node   0: [mem 0x0000000000100000-0x00000000bffd8fff]=0D
  node   0: [mem 0x0000000100000000-0x000000013fffffff]=0D
Initmem setup node 0 [mem 0x0000000000001000-0x000000013fffffff]=0D
ACPI: PM-Timer IO Port: 0x608=0D
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])=0D
IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)=0D
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)=0D
Using ACPI (MADT) for SMP configuration information=0D
[Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcod=
e to version: 0x22 (or later)=0D
smpboot: Allowing 2 CPUs, 0 hotplug CPUs=0D
e820: [mem 0xc0000000-0xfeffbfff] available for PCI devices=0D
clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_=
idle_ns: 7645519600211568 ns=0D
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1=0D
percpu: Embedded 483 pages/cpu @ffff88013b200000 s1938392 r8192 d31784 u209=
7152=0D
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 103203=
4=0D
Kernel command line: root=3D/dev/vda1 ro earlyprintk=3Dserial,ttyS0,11520n8=
,keep console=3Dtty0 console=3DttyS0,11520n8=0D
PID hash table entries: 4096 (order: 3, 32768 bytes)=0D
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)=0D
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)=0D
Memory: 4013572K/4193756K available (7543K kernel code, 1206K rwdata, 2632K=
 rodata, 2952K init, 21952K bss, 180184K reserved, 0K cma-reserved)=0D
SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1=0D
ftrace: allocating 26693 entries in 105 pages=0D
Running RCU self tests=0D
Hierarchical RCU implementation.=0D
	RCU lockdep checking is enabled.=0D
	RCU restricting CPUs from NR_CPUS=3D8 to nr_cpu_ids=3D2.=0D
RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=3D2=0D
NR_IRQS: 4352, nr_irqs: 440, preallocated irqs: 16=0D
Console: colour VGA+ 80x25=0D
console [tty0] enabled=0D
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar=0D
=2E.. MAX_LOCKDEP_SUBCLASSES:  8=0D
=2E.. MAX_LOCK_DEPTH:          48=0D
=2E.. MAX_LOCKDEP_KEYS:        8191=0D
=2E.. CLASSHASH_SIZE:          4096=0D
=2E.. MAX_LOCKDEP_ENTRIES:     32768=0D
=2E.. MAX_LOCKDEP_CHAINS:      65536=0D
=2E.. CHAINHASH_SIZE:          32768=0D
 memory used by lock dependency info: 8671 kB=0D
 per task-struct memory footprint: 2688 bytes=0D
------------------------=0D
| Locking API testsuite:=0D
---------------------------------------------------------------------------=
-=0D
                                 | spin |wlock |rlock |mutex | wsem | rsem =
|=0D
  -------------------------------------------------------------------------=
-=0D
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |=0D
  -------------------------------------------------------------------------=
-=0D
              recursive read-lock:             |  ok  |             |  ok  =
|=0D
           recursive read-lock #2:             |  ok  |             |  ok  =
|=0D
            mixed read-write-lock:             |  ok  |             |  ok  =
|=0D
            mixed write-read-lock:             |  ok  |             |  ok  =
|=0D
  -------------------------------------------------------------------------=
-=0D
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |=0D
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |=0D
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |=0D
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |=0D
       sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |=0D
       sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |=0D
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |=0D
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |=0D
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |=0D
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |=0D
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |=0D
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |=0D
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |=0D
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |=0D
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |=0D
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |=0D
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |=0D
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |=0D
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |=0D
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |=0D
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |=0D
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |=0D
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |=0D
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |=0D
      hard-irq read-recursion/123:  ok  |=0D
      soft-irq read-recursion/123:  ok  |=0D
      hard-irq read-recursion/132:  ok  |=0D
      soft-irq read-recursion/132:  ok  |=0D
      hard-irq read-recursion/213:  ok  |=0D
      soft-irq read-recursion/213:  ok  |=0D
      hard-irq read-recursion/231:  ok  |=0D
      soft-irq read-recursion/231:  ok  |=0D
      hard-irq read-recursion/312:  ok  |=0D
      soft-irq read-recursion/312:  ok  |=0D
      hard-irq read-recursion/321:  ok  |=0D
      soft-irq read-recursion/321:  ok  |=0D
  -------------------------------------------------------------------------=
-=0D
  | Wound/wait tests |=0D
  ---------------------=0D
                  ww api failures:  ok  |  ok  |  ok  |=0D
               ww contexts mixing:  ok  |  ok  |=0D
             finishing ww context:  ok  |  ok  |  ok  |  ok  |=0D
               locking mismatches:  ok  |  ok  |  ok  |=0D
                 EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |  ok  |  ok  |  ok  |=0D
           spinlock nest unlocked:  ok  |=0D
  -----------------------------------------------------=0D
                                 |block | try  |context|=0D
  -----------------------------------------------------=0D
                          context:  ok  |  ok  |  ok  |=0D
                              try:  ok  |  ok  |  ok  |=0D
                            block:  ok  |  ok  |  ok  |=0D
                         spinlock:  ok  |  ok  |  ok  |=0D
-------------------------------------------------------=0D
Good, all 256 testcases passed! |=0D
---------------------------------=0D
tsc: Fast TSC calibration using PIT=0D
tsc: Detected 2400.066 MHz processor=0D
Calibrating delay loop (skipped), value calculated using timer frequency.. =
4800.13 BogoMIPS (lpj=3D9600264)=0D
pid_max: default: 32768 minimum: 301=0D
ACPI: Core revision 20170531=0D
ACPI: 1 ACPI AML tables successfully acquired and loaded=0D
Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)=0D
Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)=0D
CPU: Physical Processor ID: 0=0D
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0=0D
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0=0D
Freeing SMP alternatives memory: 28K=0D
smpboot: Max logical packages: 2=0D
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1=0D
smpboot: CPU0: Intel Core Processor (Haswell, no TSX) (family: 0x6, model: =
0x3c, stepping: 0x1)=0D
Performance Events: unsupported p6 CPU model 60 no PMU driver, software eve=
nts only.=0D
Hierarchical SRCU implementation.=0D
smp: Bringing up secondary CPUs ...=0D
x86: Booting SMP configuration:=0D
=2E... node  #0, CPUs:      #1=0D
NMI watchdog: disabled (cpu0): hardware events not enabled=0D
NMI watchdog: Shutting down hard lockup detector on all cpus=0D
smp: Brought up 1 node, 2 CPUs=0D
smpboot: Total of 2 processors activated (9601.80 BogoMIPS)=0D
devtmpfs: initialized=0D
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns:=
 7645041785100000 ns=0D
futex hash table entries: 512 (order: 4, 65536 bytes)=0D
NET: Registered protocol family 16=0D
cpuidle: using governor ladder=0D
PCCT header not found.=0D
ACPI: bus type PCI registered=0D
PCI: Using configuration type 1 for base access=0D
ACPI: Added _OSI(Module Device)=0D
ACPI: Added _OSI(Processor Device)=0D
ACPI: Added _OSI(3.0 _SCP Extensions)=0D
ACPI: Added _OSI(Processor Aggregator Device)=0D
ACPI: Interpreter enabled=0D
ACPI: (supports S0 S5)=0D
ACPI: Using IOAPIC for interrupt routing=0D
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocrs" a=
nd report a bug=0D
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])=0D
acpi PNP0A03:00: _OSC: OS supports [Segments MSI]=0D
acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM=0D
PCI host bridge to bus 0000:00=0D
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]=0D
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]=0D
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]=0D
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]=0D
pci_bus 0000:00: root bus resource [bus 00-ff]=0D
pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]=0D
pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=0D
pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]=0D
pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=0D
pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI=0D
pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB=0D
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)=0D
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)=0D
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)=0D
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)=0D
ACPI: PCI Interrupt Link [LNKS] (IRQs *9)=0D
ACPI: Enabled 2 GPEs in block 00 to 0F=0D
pci 0000:00:02.0: vgaarb: setting as boot VGA device=0D
pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+mem,owns=3Dio+mem,=
locks=3Dnone=0D
pci 0000:00:02.0: vgaarb: bridge control possible=0D
vgaarb: loaded=0D
pps_core: LinuxPPS API ver. 1 registered=0D
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giome=
tti-k2GhghHVRtY@public.gmane.org>=0D
PTP clock support registered=0D
PCI: Using ACPI for IRQ routing=0D
clocksource: Switched to clocksource refined-jiffies=0D
pnp: PnP ACPI init=0D
pnp: PnP ACPI: found 5 devices=0D
clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 208=
5701024 ns=0D
clocksource: Switched to clocksource acpi_pm=0D
NET: Registered protocol family 2=0D
TCP established hash table entries: 32768 (order: 6, 262144 bytes)=0D
TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)=0D
TCP: Hash tables configured (established 32768 bind 32768)=0D
UDP hash table entries: 2048 (order: 6, 393216 bytes)=0D
UDP-Lite hash table entries: 2048 (order: 6, 393216 bytes)=0D
NET: Registered protocol family 1=0D
RPC: Registered named UNIX socket transport module.=0D
RPC: Registered udp transport module.=0D
RPC: Registered tcp transport module.=0D
RPC: Registered tcp NFSv4.1 backchannel transport module.=0D
pci 0000:00:00.0: Limiting direct PCI/PCI transfers=0D
pci 0000:00:01.0: PIIX3: Enabling Passive Release=0D
pci 0000:00:01.0: Activating ISA DMA hang workarounds=0D
pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000df=
fff]=0D
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)=0D
software IO TLB [mem 0xbbfd9000-0xbffd9000] (64MB) mapped at [ffff8800bbfd9=
000-ffff8800bffd8fff]=0D
workingset: timestamp_bits=3D62 max_order=3D20 bucket_order=3D0=0D
NFS: Registering the id_resolver key type=0D
Key type id_resolver registered=0D
Key type id_legacy registered=0D
nfs4filelayout_init: NFSv4 File Layout Driver Registering...=0D
9p: Installing v9fs 9p2000 file system support=0D
io scheduler noop registered (default)=0D
io scheduler mq-deadline registered=0D
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0=0D
ACPI: Power Button [PWRF]=0D
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11=0D
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10=0D
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10=0D
AMD IOMMUv2 driver by Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>=0D
AMD IOMMUv2 functionality not available on this system=0D
brd: module loaded=0D
 vda: vda1 vda2 < vda5 >=0D
mlx5_core 0000:00:08.0: firmware version: 10.16.1020=0D
tsc: Refined TSC clocksource calibration: 2400.035 MHz=0D
clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x2298587c4a5, max_i=
dle_ns: 440795272338 ns=0D
clocksource: Switched to clocksource tsc=0D
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12=
=0D
serio: i8042 KBD port at 0x60,0x64 irq 1=0D
serio: i8042 AUX port at 0x60,0x64 irq 12=0D
mousedev: PS/2 mouse device common for all mice=0D
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input=
/input1=0D
mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0=0D
oprofile: using NMI timer interrupt.=0D
NET: Registered protocol family 10=0D
Segment Routing with IPv6=0D
sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver=0D
NET: Registered protocol family 17=0D
RPC: Registered rdma transport module.=0D
RPC: Registered rdma backchannel transport module.=0D
tipc: Activated (version 2.0.0)=0D
NET: Registered protocol family 30=0D
tipc: Started in single node mode=0D
9pnet: Installing 9P2000 support=0D
Key type dns_resolver registered=0D
sched_clock: Marking stable (3210654019, 0)->(3355124163, -144470144)=0D
page_owner is disabled=0D
EXT4-fs (vda1): couldn't mount as ext3 due to feature incompatibilities=0D
EXT4-fs (vda1): couldn't mount as ext2 due to feature incompatibilities=0D
EXT4-fs (vda1): INFO: recovery required on readonly filesystem=0D
EXT4-fs (vda1): write access will be enabled during recovery=0D
EXT4-fs (vda1): recovery complete=0D
EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)=0D
VFS: Mounted root (ext4 filesystem) readonly on device 254:1.=0D
devtmpfs: mounted=0D
Freeing unused kernel memory: 2952K=0D
Write protecting the kernel read-only data: 12288k=0D
Freeing unused kernel memory: 632K=0D
Freeing unused kernel memory: 1464K=0D
rodata_test: all tests were successful=0D
systemd[1]: Failed to insert module 'autofs4': No such file or directory=0D
systemd[1]: systemd 232 running in system mode. (+PAM +AUDIT +SELINUX +IMA =
+APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +L=
Z4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)=0D
systemd[1]: Detected virtualization kvm.=0D
systemd[1]: Detected architecture x86-64.=0D
systemd[1]: Set hostname to <dev-l-vrt-151-010>.=0D
systemd[1]: ibacm.service: Found ordering cycle on ibacm.service/start=0D
systemd[1]: ibacm.service: Found dependency on opensm.service/start=0D
systemd[1]: ibacm.service: Found dependency on remote-fs.target/start=0D
systemd[1]: ibacm.service: Found dependency on images-bmain.mount/start=0D
systemd[1]: ibacm.service: Found dependency on network-online.target/start=
=0D
systemd[1]: ibacm.service: Found dependency on network.target/start=0D
EXT4-fs (vda1): re-mounted. Opts: errors=3Dremount-ro=0D
systemd-journald[103]: Received request to flush runtime journal from PID 1=
=0D
virtio_net virtio0 enp0s3: renamed from eth0=0D
Adding 2094076k swap on /dev/vda5.  Priority:-1 extents:1 across:2094076k =
=0D
ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list=0D

--KBjcE0k8Zsqds9qm--

--6UEPj0d4ZbbWkD8I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll3iiYACgkQ5GN7iDZy
WKfmuA/4qoH7hWkhNRuzSuPX6PU9jvk9h2RnUSpB4OiUcTnBAwYgdQ12YGLH0JOq
wsU9dac9qV6l51LQOb2V+4Po4RtoNAzO9pQ3WZ87jH392ci4qX4kfPEYcntRVuSY
ajYY7H61AknYll4U8zEM0N2Y19e8wY6jzhWLsC3Nw5WYRurLUk1lVRjCOQYx6NSN
pqTARfoqLOJivlqPXQGK8o/V7ib8ciZm82y3hAkgHt1qnrtZuF4ozk06hiGEaep2
54J6RuCmCNQvsiqs53kSjZBMu9y33+I4xpRVYKKoBBYYa/Vz9z95qeqTdOb0G3Tx
7V2df/qqjccXMPOnZno4fzxDAev0VCANS3j0ub5HsUifQzlfY304+O3cCpeujTgI
5swMWZnWEpKfyxLffVSxDm3WyIOZ4vbD9QUPnTqDWPHksVtKmfqxwzuVKIRaOsAg
MPl/XKLbNm2n9Grw/myMDqet3C1XoRB1xA2MD/+SF8EdwjYByjMlT3H7uBGTQiLG
yxd5FdHr0P1zf+sEsjCxrHWfeu3Iqrcm95sLXZZl8OLk6kdbTPcG4MkKgnbYJjTd
fHCZxmCJIiYWh61EC0w7dMgaB1Junu4aM9V22rQ/ReaPLDXwsAFs1xw1qeIS8x6+
mlWN8SUYXn51P/SjQpiT0ZkrbjDdlpkf5QtF1FfyNW0x+6aRow==
=2SdG
-----END PGP SIGNATURE-----

--6UEPj0d4ZbbWkD8I--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
