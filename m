From: Ward Vandewege <ward-N0QnO1crQcE@public.gmane.org>
Subject: problems with mlx4 driver and PCI passthrough on Xen 4.0.x
Date: Fri, 4 Feb 2011 10:35:02 -0500
Message-ID: <20110204153502.GA3568@countzero.vandewege.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi list,

I'm having problems trying to pass a Mellanox ConnectX HCA to a Xen domU
(version 4.0.x - latest head).

The hardware is Supermicro H8DGT-HIBQF, BIOS revision 1.0c (date 10/29/10).  It
has two AMD Opteron 6128 CPUs, for a total of 16 cores. The machine has 32GiB
of ram. The Mellannox adapter looks like this in the dom0 (2.6.32 debian
squeeze xen kernel):

  02:00.0 InfiniBand: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)
    Subsystem: Super Micro Computer Inc Device 0048
    Flags: fast devsel, IRQ 19
    Memory at fea00000 (64-bit, non-prefetchable) [size=1M]
    Memory at fc800000 (64-bit, prefetchable) [size=8M]
    Capabilities: [40] Power Management version 3
    Capabilities: [48] Vital Product Data
    Capabilities: [9c] MSI-X: Enable- Count=256 Masked-
    Capabilities: [60] Express Endpoint, MSI 00
    Capabilities: [100] Alternative Routing-ID Interpretation (ARI)
    Kernel driver in use: pciback

I've attached the output of xm dmesg (xm.dmesg.txt). This is my current Xen command line:

  (XEN) Command line: placeholder dom0_mem=1024M loglvl=all guest_loglvl=all com1=
115200,8n1 console=com1,vga iommu=pv,verbose,amd_iommu_debug

and the kernel command line is

  [    0.000000] Command line: placeholder root=UUID=cd0306dc-0c81-440e-b431-b33e3
fef9362 ro console=tty0 console=hvc0,115200n8 xen-pciback.hide=(02:00.0)

I have the following in the domU config file:

  pci = ['0000:02:00.0']

I'm using the mlx4 driver from OFED 1.5.2.

Here's what happens when I start the domU (either PV or HVM, same result). On the dom0 console:

[   41.778624] pciback 0000:02:00.0: enabling permissive mode configuration space accesses!
[   41.778788] pciback 0000:02:00.0: permissive mode is potentially unsafe!
[   41.863613] pciback: vpci: 0000:02:00.0: assign to virtual slot 0
[   43.001522] pciback 0000:02:00.0: enabling device (0000 -> 0002)
[   43.001705] xen_allocate_pirq: returning irq 19 for gsi 19
[   43.001855] Already setup the GSI :19
[   43.001975] pciback 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c28000
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c28040
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c28080
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c280c0

And in the boot log of the domU (this is a PV boot - same Debian Xen 2.6.32 kernel):

[    0.413720] mlx4_core: Mellanox ConnectX core driver v1.0-ofed1.5.2 (August 4, 2010)
[    0.413733] mlx4_core: Initializing 0000:00:00.0
[    0.414042] mlx4_core 0000:00:00.0: enabling device (0000 -> 0002)
[    0.414719] mlx4_core 0000:00:00.0: Xen PCI enabling IRQ: 19
[    1.421047] mlx4_core 0000:00:00.0: Installed FW has unsupported command interface revision 0.
[    1.421079] mlx4_core 0000:00:00.0: (Installed FW version is 0.0.000)
[    1.421095] mlx4_core 0000:00:00.0: This driver version supports only revisions 2 to 3.
[    1.421114] mlx4_core 0000:00:00.0: QUERY_FW command failed, aborting.

I've attached full output of the domU boot as well.

I added the Mellanox card's PCI id to xend-pci-permissive.sxp, as I was
prompted to do that when booting the domU the first time I added
xen-pciback.hide=(02:00.0) to the kernel command line.

On the Xen devel list (http://www.gossamer-threads.com/lists/xen/devel/197392),
Konrad suggested the mlx4 driver might not be using the VM_IO flag (referring
to this thread:
http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg06980.html).

I'm seeing the exact same problem with Xen 4.0.2-rc2-pre and 2.6.32.27
compiled from the current head at http://xenbits.xen.org/xen-4.0-testing.hg. 

Is anyone using the mlx4 driver in a Xen environment? With PCI passthrough? 

Thanks,
Ward.


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xm.dmesg.txt"

(XEN) Xen version 4.0.1 (Debian 4.0.1-2) (waldi-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org) (gcc version 4.4.5 (Debian 4.4.5-10) ) Wed Jan 12 14:04:06 UTC 2011
(XEN) Bootloader: GRUB 1.98+20100804-14
(XEN) Command line: placeholder dom0_mem=1024M loglvl=all guest_loglvl=all com1=115200,8n1 console=com1,vga iommu=pv,verbose,amd_iommu_debug
(XEN) Video information:
(XEN)  VGA is text mode 80x25, font 8x16
(XEN)  VBE/DDC methods: none; EDID transfer time: 0 seconds
(XEN)  EDID info not retrieved because no DDC retrieval method detected
(XEN) Disc information:
(XEN)  Found 2 MBR signatures
(XEN)  Found 2 EDD information structures
(XEN) Xen-e820 RAM map:
(XEN)  0000000000000000 - 000000000009ac00 (usable)
(XEN)  000000000009ac00 - 00000000000a0000 (reserved)
(XEN)  00000000000e6000 - 0000000000100000 (reserved)
(XEN)  0000000000100000 - 00000000dfe90000 (usable)
(XEN)  00000000dfe9e000 - 00000000dfea0000 type 9
(XEN)  00000000dfea0000 - 00000000dfeb2000 (ACPI data)
(XEN)  00000000dfeb2000 - 00000000dfee0000 (ACPI NVS)
(XEN)  00000000dfee0000 - 00000000f0000000 (reserved)
(XEN)  00000000ffe00000 - 0000000100000000 (reserved)
(XEN)  0000000100000000 - 0000000820000000 (usable)
(XEN) ACPI: RSDP 000F9E90, 0024 (r2 ACPIAM)
(XEN) ACPI: XSDT DFEA0100, 008C (r1 SMCI            20101029 MSFT       97)
(XEN) ACPI: FACP DFEA0290, 00F4 (r4 102910 FACP1824 20101029 MSFT       97)
(XEN) ACPI: DSDT DFEA0670, 56DB (r2  1AA11 1AA11000        0 INTL 20051117)
(XEN) ACPI: FACS DFEB2000, 0040
(XEN) ACPI: APIC DFEA0390, 0118 (r2 102910 APIC1824 20101029 MSFT       97)
(XEN) ACPI: MCFG DFEA04B0, 003C (r1 102910 OEMMCFG  20101029 MSFT       97)
(XEN) ACPI: OEMB DFEB2040, 0075 (r1 102910 OEMB1824 20101029 MSFT       97)
(XEN) ACPI: HPET DFEAA670, 0038 (r1 102910 OEMHPET  20101029 MSFT       97)
(XEN) ACPI: IVRS DFEAA6B0, 00B8 (r1  AMD     RD890S   202031 AMD         0)
(XEN) ACPI: SRAT DFEAA770, 0220 (r2 AMD    F10             1 AMD         1)
(XEN) ACPI: SLIT DFEAA990, 003C (r1 AMD    F10             1 AMD         1)
(XEN) ACPI: SSDT DFEAA9D0, 2854 (r1 A M I  POWERNOW        1 AMD         1)
(XEN) ACPI: EINJ DFEAD230, 0130 (r1  AMIER AMI_EINJ 20101029 MSFT       97)
(XEN) ACPI: BERT DFEAD3C0, 0030 (r1  AMIER AMI_BERT 20101029 MSFT       97)
(XEN) ACPI: ERST DFEAD3F0, 01B0 (r1  AMIER AMI_ERST 20101029 MSFT       97)
(XEN) ACPI: HEST DFEAD5A0, 00A8 (r1  AMIER ABC_HEST 20101029 MSFT       97)
(XEN) System RAM: 32766MB (33552552kB)
(XEN) SRAT: PXM 0 -> APIC 16 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 17 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 18 -> Node 0
(XEN) SRAT: PXM 0 -> APIC 19 -> Node 0
(XEN) SRAT: PXM 1 -> APIC 20 -> Node 1
(XEN) SRAT: PXM 1 -> APIC 21 -> Node 1
(XEN) SRAT: PXM 1 -> APIC 22 -> Node 1
(XEN) SRAT: PXM 1 -> APIC 23 -> Node 1
(XEN) SRAT: PXM 2 -> APIC 36 -> Node 2
(XEN) SRAT: PXM 2 -> APIC 37 -> Node 2
(XEN) SRAT: PXM 2 -> APIC 38 -> Node 2
(XEN) SRAT: PXM 2 -> APIC 39 -> Node 2
(XEN) SRAT: PXM 3 -> APIC 32 -> Node 3
(XEN) SRAT: PXM 3 -> APIC 33 -> Node 3
(XEN) SRAT: PXM 3 -> APIC 34 -> Node 3
(XEN) SRAT: PXM 3 -> APIC 35 -> Node 3
(XEN) SRAT: Node 0 PXM 0 0-a0000
(XEN) SRAT: Node 0 PXM 0 100000-e0000000
(XEN) SRAT: Node 0 PXM 0 100000000-220000000
(XEN) SRAT: Node 1 PXM 1 220000000-420000000
(XEN) SRAT: Node 2 PXM 2 420000000-620000000
(XEN) SRAT: Node 3 PXM 3 620000000-820000000
(XEN) NUMA: Allocated memnodemap from 81fdf5000 - 81fdfe000
(XEN) NUMA: Using 8 for the hash shift.
(XEN) Reserving non-aligned node boundary @ mfn 0x620000
(XEN) Domain heap initialised DMA width 31 bits
(XEN) found SMP MP-table at 000ff780
(XEN) DMI present.
(XEN) Using APIC driver default
(XEN) ACPI: PM-Timer IO Port: 0x808
(XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[804,0], pm1x_evt[800,0]
(XEN) ACPI:                  wakeup_vec[dfeb200c], vec_size[20]
(XEN) ACPI: Local APIC address 0xfee00000
(XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
(XEN) Processor #16 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x11] enabled)
(XEN) Processor #17 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] enabled)
(XEN) Processor #18 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x13] enabled)
(XEN) Processor #19 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] enabled)
(XEN) Processor #20 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x06] lapic_id[0x15] enabled)
(XEN) Processor #21 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] enabled)
(XEN) Processor #22 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x08] lapic_id[0x17] enabled)
(XEN) Processor #23 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x09] lapic_id[0x20] enabled)
(XEN) Processor #32 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x21] enabled)
(XEN) Processor #33 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x22] enabled)
(XEN) Processor #34 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x23] enabled)
(XEN) Processor #35 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x24] enabled)
(XEN) Processor #36 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x25] enabled)
(XEN) Processor #37 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x26] enabled)
(XEN) Processor #38 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x10] lapic_id[0x27] enabled)
(XEN) Processor #39 0:9 APIC version 16
(XEN) ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
(XEN) ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
(XEN) ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
(XEN) ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
(XEN) Overriding APIC driver with bigsmp
(XEN) ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
(XEN) IOAPIC[0]: apic_id 0, version 33, address 0xfec00000, GSI 0-23
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
(XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
(XEN) ACPI: IRQ0 used by override.
(XEN) ACPI: IRQ2 used by override.
(XEN) ACPI: IRQ9 used by override.
(XEN) Enabling APIC mode:  Phys.  Using 1 I/O APICs
(XEN) ACPI: HPET id: 0x8300 base: 0xfed00000
(XEN) PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
(XEN) PCI: MCFG area at e0000000 reserved in E820
(XEN) Using ACPI (MADT) for SMP configuration information
(XEN) Using scheduler: SMP Credit Scheduler (credit)
(XEN) Detected 2000.166 MHz processor.
(XEN) Initing memory sharing.
(XEN) HVM: ASIDs enabled.
(XEN) HVM: SVM enabled
(XEN) HVM: Hardware Assisted Paging detected.
(XEN) AMD Fam10h machine check reporting enabled
(XEN) AMD-Vi: IOMMU 0 Enabled.
(XEN) I/O virtualisation enabled
(XEN)  - Dom0 mode: Relaxed
(XEN) Total of 16 processors activated.
(XEN) ENABLING IO-APIC IRQs
(XEN)  -> Using new ACK method
(XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
(XEN) TSC is reliable, synchronization unnecessary
(XEN) Platform timer appears to have unexpectedly wrapped 10 or more times.
(XEN) Platform timer is 14.318MHz HPET
(XEN) Allocated console ring of 128 KiB.
(XEN) do_IRQ: 1.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 2.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 3.231 No irq handler for vector (irq -1)
(XEN) microcode.c:73:d32767 microcode: CPU2 resumed
(XEN) Brought up 16 CPUs
(XEN) microcode.c:73:d32767 microcode: CPU3 resumed
(XEN) microcode.c:73:d32767 microcode: CPU1 resumed
(XEN) do_IRQ: 7.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 15.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 12.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 14.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 5.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 6.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 10.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 4.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 13.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 9.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 8.231 No irq handler for vector (irq -1)
(XEN) do_IRQ: 11.231 No irq handler for vector (irq -1)
(XEN) microcode.c:73:d32767 microcode: CPU4 resumed
(XEN) HPET's MSI mode hasn't been supported when Interrupt Remapping is enabled.
(XEN) microcode.c:73:d32767 microcode: CPU9 resumed
(XEN) ACPI sleep modes:<G><2>microcode.c:73:d32767 microcode: CPU6 resumed
(XEN)  S3<G><2>microcode.c:73:d32767 microcode: CPU14 resumed
(XEN) 
(XEN) microcode.c:73:d32767 microcode: CPU13 resumed
(XEN) MCA: Use hw thresholding to adjust polling frequency
(XEN) microcode.c:73:d32767 microcode: CPU7 resumed
(XEN) mcheck_poll: Machine check polling timer started.
(XEN) microcode.c:73:d32767 microcode: CPU5 resumed
(XEN) *** LOADING DOMAIN 0 ***
(XEN) microcode.c:73:d32767 microcode: CPU12 resumed
(XEN) microcode.c:73:d32767 microcode: CPU15 resumed
(XEN) microcode.c:73:d32767 microcode: CPU8 resumed
(XEN) microcode.c:73:d32767 microcode: CPU10 resumed
(XEN) microcode.c:73:d32767 microcode: CPU11 resumed
(XEN)  Xen  kernel: 64-bit, lsb, compat32
(XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x16b8000
(XEN) PHYSICAL MEMORY ARRANGEMENT:
(XEN)  Dom0 alloc.:   0000000218000000->000000021c000000 (245760 pages to be allocated)
(XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: ffffffff81000000->ffffffff816b8000
(XEN)  Init. ramdisk: ffffffff816b8000->ffffffff83ae7400
(XEN)  Phys-Mach map: ffffffff83ae8000->ffffffff83ce8000
(XEN)  Start info:    ffffffff83ce8000->ffffffff83ce84b4
(XEN)  Page tables:   ffffffff83ce9000->ffffffff83d0c000
(XEN)  Boot stack:    ffffffff83d0c000->ffffffff83d0d000
(XEN)  TOTAL:         ffffffff80000000->ffffffff84000000
(XEN)  ENTRY ADDRESS: ffffffff81508200
(XEN) Dom0 has maximum 16 VCPUs
(XEN) Scrubbing Free RAM: .......................................................................................................................................................................................................................................................................................................................done.
(XEN) trace.c:89:d32767 calc_tinfo_first_offset: NR_CPUs 128, offset_in_bytes 258, t_info_first_offset 65
(XEN) Xen trace buffers: disabled
(XEN) Std. Loglevel: All
(XEN) Guest Loglevel: All
(XEN) Xen is relinquishing VGA console.
(XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch input to Xen)
(XEN) Freed 176kB init memory.
(XEN) traps.c:2308:d0 Domain attempted WRMSR 00000000c0010004 from 00000003:0d3d402e to 00000000:00000000.
(XEN) traps.c:2308:d0 Domain attempted WRMSR 00000000c0010000 from 00000000:00030076 to 00000000:00430076.
(XEN) PCI add device 00:00.0
(XEN) PCI add device 00:00.2
(XEN) PCI add device 00:04.0
(XEN) PCI add device 00:0b.0
(XEN) PCI add device 00:11.0
(XEN) PCI add device 00:12.0
(XEN) PCI add device 00:12.1
(XEN) PCI add device 00:12.2
(XEN) PCI add device 00:13.0
(XEN) PCI add device 00:13.1
(XEN) PCI add device 00:13.2
(XEN) PCI add device 00:14.0
(XEN) PCI add device 00:14.1
(XEN) PCI add device 00:14.3
(XEN) PCI add device 00:14.4
(XEN) PCI add device 00:14.5
(XEN) PCI add device 00:18.0
(XEN) PCI add device 00:18.1
(XEN) PCI add device 00:18.2
(XEN) PCI add device 00:18.3
(XEN) PCI add device 00:18.4
(XEN) PCI add device 00:19.0
(XEN) PCI add device 00:19.1
(XEN) PCI add device 00:19.2
(XEN) PCI add device 00:19.3
(XEN) PCI add device 00:19.4
(XEN) PCI add device 00:1a.0
(XEN) PCI add device 00:1a.1
(XEN) PCI add device 00:1a.2
(XEN) PCI add device 00:1a.3
(XEN) PCI add device 00:1a.4
(XEN) PCI add device 00:1b.0
(XEN) PCI add device 00:1b.1
(XEN) PCI add device 00:1b.2
(XEN) PCI add device 00:1b.3
(XEN) PCI add device 00:1b.4
(XEN) PCI add device 03:00.0
(XEN) PCI add device 03:00.1
(XEN) PCI add device 02:00.0
(XEN) PCI add device 01:04.0
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c28000
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c28040
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c28080
(XEN) AMD_IOV: IO_PAGE_FALT: domain:1, device id:0x200, fault address:0x2c280c0

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="domU.dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-5-xen-amd64 (Debian 2.6.32-30) (ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Wed Jan 12 05:46:49 UTC 2011
[    0.000000] Command line: root=/dev/xvda2 ro 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] released 0 pages of unused memory
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 0000000080000000 (usable)
[    0.000000] DMI not present or invalid.
[    0.000000] last_pfn = 0x80000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000080000000
[    0.000000]  0000000000 - 0080000000 page 4k
[    0.000000] kernel direct mapping tables up to 80000000 @ 100000-503000
[    0.000000] RAMDISK: 016b8000 - 03ae8000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000080000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000]   NODE_DATA [0000000000008000 - 000000000000ffff]
[    0.000000]   bootmap [0000000000010000 -  000000000001ffff] pages 10
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0080000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0003eeb000 - 0003f0e000]   XEN PAGETABLES ==> [0003eeb000 - 0003f0e000]
[    0.000000]   #2 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #3 [0001000000 - 0001697994]    TEXT DATA BSS ==> [0001000000 - 0001697994]
[    0.000000]   #4 [00016b8000 - 0003ae8000]          RAMDISK ==> [00016b8000 - 0003ae8000]
[    0.000000]   #5 [0003ae8000 - 0003eeb000]   XEN START INFO ==> [0003ae8000 - 0003eeb000]
[    0.000000]   #6 [0000100000 - 00004dd000]          PGTABLE ==> [0000100000 - 00004dd000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x00080000
[    0.000000] On node 0 totalpages: 524192
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 992 pages reserved
[    0.000000]   DMA zone: 2952 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7112 pages used for memmap
[    0.000000]   DMA32 zone: 513080 pages, LIFO batch:31
[    0.000000] SFI: Simple Firmware Interface v0.7 http://simplefirmware.org
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:80000000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 4.0.1 (preserve-AD)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880003f44000 s90328 r8192 d24360 u122880
[    0.000000] pcpu-alloc: s90328 r8192 d24360 u122880 alloc=30*4096
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] trying to map vcpu_info 0 at ffff880003f4f020, mfn 119497, offset 32
[    0.000000] cpu 0 using vcpu_info at ffff880003f4f020
[    0.000000] Xen: using vcpu_info placement
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 516032
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/xvda2 ro 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2015580k/2097152k available (3147k kernel code, 384k absent, 81188k reserved, 1908k data, 600k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:512
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000]   alloc irq_desc for 511 on node -1
[    0.000000]   alloc kstat_irqs on node -1
[    0.000000] Detected 2000.166 MHz processor.
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4000.33 BogoMIPS (lpj=8000664)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys devices
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] Initializing cgroup subsys net_cls
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 0/0x0 -> Node 0
[    0.004000] tseg: 00dff00000
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Performance Events: AMD PMU driver.
[    0.004000] ... version:                0
[    0.004000] ... bit width:              48
[    0.004000] ... generic registers:      4
[    0.004000] ... value mask:             0000ffffffffffff
[    0.004000] ... max period:             00007fffffffffff
[    0.004000] ... fixed-purpose events:   0
[    0.004000] ... event mask:             000000000000000f
[    0.004000] SMP alternatives: switching to UP code
[    0.004000] Freeing SMP alternatives: 28k freed
[    0.004069]   alloc irq_desc for 510 on node -1
[    0.004073]   alloc kstat_irqs on node -1
[    0.004081]   alloc irq_desc for 509 on node -1
[    0.004084]   alloc kstat_irqs on node -1
[    0.004089]   alloc irq_desc for 508 on node -1
[    0.004091]   alloc kstat_irqs on node -1
[    0.004095]   alloc irq_desc for 507 on node -1
[    0.004098]   alloc kstat_irqs on node -1
[    0.004216] Brought up 1 CPUs
[    0.004240] CPU0 attaching NULL sched-domain.
[    0.004348] devtmpfs: initialized
[    0.008253] Grant table initialized
[    0.008261] regulator: core version 0.5
[    0.008316] NET: Registered protocol family 16
[    0.008371]   alloc irq_desc for 506 on node -1
[    0.008373]   alloc kstat_irqs on node -1
[    0.008877] PCI: setting up Xen PCI frontend stub
[    0.009373] bio: create slab <bio-0> at 0
[    0.009443] ACPI: Interpreter disabled.
[    0.009479] xen_balloon: Initialising balloon driver with page order 0.
[    0.009528] vgaarb: loaded
[    0.009590] PCI: System does not support PCI
[    0.009596] PCI: System does not support PCI
[    0.009677] Switching to clocksource xen
[    0.010907] pnp: PnP ACPI: disabled
[    0.011136] NET: Registered protocol family 2
[    0.011320] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.012000] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.012309] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.012636] TCP: Hash tables configured (established 262144 bind 65536)
[    0.012644] TCP reno registered
[    0.012741] NET: Registered protocol family 1
[    0.012807] Unpacking initramfs...
[    0.045969] Freeing initrd memory: 37056k freed
[    0.057128] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.057356] audit: initializing netlink socket (disabled)
[    0.057372] type=2000 audit(1296831903.561:1): initialized
[    0.061145] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.062577] VFS: Disk quotas dquot_6.5.2
[    0.062635] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.062725] msgmni has been set to 4009
[    0.062924] alg: No test for stdrng (krng)
[    0.062979] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.062987] io scheduler noop registered
[    0.062992] io scheduler anticipatory registered
[    0.062997] io scheduler deadline registered
[    0.063036] io scheduler cfq registered (default)
[    0.065791]   alloc irq_desc for 505 on node -1
[    0.065794]   alloc kstat_irqs on node -1
[    0.077398] registering netback
[    0.078773]   alloc irq_desc for 504 on node -1
[    0.078777]   alloc kstat_irqs on node -1
[    0.079002] Linux agpgart interface v0.103
[    0.079037] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.079242] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.079295] PNP: No PS/2 controller found. Probing ports directly.
[    0.080007] i8042.c: No controller found.
[    0.080214] mice: PS/2 mouse device common for all mice
[    0.080312] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
[    0.080387] cpuidle: using governor ladder
[    0.080392] cpuidle: using governor menu
[    0.080400] No iBFT detected.
[    0.080663] pcifront pci-0: Installing PCI frontend
[    0.080748] TCP cubic registered
[    0.080899] NET: Registered protocol family 10
[    0.080963] pcifront pci-0: Creating PCI Frontend Bus 0000:00
[    0.081969] pci 0000:00:00.0: reg 10 64bit mmio: [0xfea00000-0xfeafffff]
[    0.082189] pci 0000:00:00.0: reg 18 64bit mmio pref: [0xfc800000-0xfcffffff]
[    0.084138] pcifront pci-0: claiming resource 0000:00:00.0/0
[    0.084138] pcifront pci-0: claiming resource 0000:00:00.0/2
[    0.088231] lo: Disabled Privacy Extensions
[    0.088600] Mobile IPv6
[    0.092006] NET: Registered protocol family 17
[    0.171893] PM: Resume from disk failed.
[    0.171905] registered taskstats version 1
[    0.268090] XENBUS: Device with no driver: device/vbd/51714
[    0.268116] XENBUS: Device with no driver: device/vbd/51713
[    0.268132] XENBUS: Device with no driver: device/vif/0
[    0.268144] XENBUS: Device with no driver: device/console/0
[    0.268193] /build/buildd-linux-2.6_2.6.32-30-amd64-d4MbNM/linux-2.6-2.6.32/debian/build/source_amd64_xen/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    0.268256] Initalizing network drop monitor service
[    0.268444] Freeing unused kernel memory: 600k freed
[    0.268809] Write protecting the kernel read-only data: 4328k
[    0.324240] udev[46]: starting version 164
[    0.405217] Initialising Xen virtual ethernet driver.
[    0.405786]   alloc irq_desc for 503 on node -1
[    0.405790]   alloc kstat_irqs on node -1
[    0.413720] mlx4_core: Mellanox ConnectX core driver v1.0-ofed1.5.2 (August 4, 2010)
[    0.413733] mlx4_core: Initializing 0000:00:00.0
[    0.414042] mlx4_core 0000:00:00.0: enabling device (0000 -> 0002)
[    0.414719] mlx4_core 0000:00:00.0: Xen PCI enabling IRQ: 19
[    0.414728]   alloc irq_desc for 19 on node -1
[    0.414731]   alloc kstat_irqs on node -1
[    0.414987] mlx4_core 0000:00:00.0: setting latency timer to 64
[    0.421589]   alloc irq_desc for 502 on node -1
[    0.421593]   alloc kstat_irqs on node -1
[    0.449507]   alloc irq_desc for 501 on node -1
[    0.449517]   alloc kstat_irqs on node -1
[    0.464284] blkfront: xvda2: barriers enabled
[    0.468268] blkfront: xvda1: barriers enabled
[    1.421047] mlx4_core 0000:00:00.0: Installed FW has unsupported command interface revision 0.
[    1.421079] mlx4_core 0000:00:00.0: (Installed FW version is 0.0.000)
[    1.421095] mlx4_core 0000:00:00.0: This driver version supports only revisions 2 to 3.
[    1.421114] mlx4_core 0000:00:00.0: QUERY_FW command failed, aborting.
[    1.467834] md: raid1 personality registered for level 1
[    1.541084] device-mapper: uevent: version 1.0.3
[    1.542616] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[    1.584075] kjournald starting.  Commit interval 5 seconds
[    1.584092] EXT3-fs: mounted filesystem with ordered data mode.
[    2.368751] udev[165]: starting version 164
[    2.564626] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    2.785735] Error: Driver 'pcspkr' is already registered, aborting...
[    2.930252] Adding 4194296k swap on /dev/xvda1.  Priority:-1 extents:1 across:4194296k SS
[    3.066143] EXT3 FS on xvda2, internal journal
[   14.076057] eth0: no IPv6 routers present

--W/nzBZO5zC0uMSeA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
