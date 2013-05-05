From: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: decent performance drop for SCSI LLD / SAN initiator when iommu
 is turned on
Date: Sun, 5 May 2013 14:06:26 +0000
Message-ID: <0EE9A1CDC8D6434DB00095CD7DB873462CFA81F0@MTLDAG01.mtl.com>
References: <CAJZOPZJ8eF-Q+WFzA-_vvzkpSb41PQjKFo27_Wi3McUccOqs9A@mail.gmail.com>
 <20130502015603.GC26105@redhat.com>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF9D73E@MTLDAG01.mtl.com>
 <518412AC.3070507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <518412AC.3070507-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Don Dutile [mailto:ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> Sent: Friday, May 03, 2013 22:41
> To: Yan Burman
> Cc: Michael S. Tsirkin; Or Gerlitz; Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> Subject: Re: decent performance drop for SCSI LLD / SAN initiator when
> iommu is turned on
> 
> On 05/02/2013 10:13 AM, Yan Burman wrote:
> >
> >
> >> -----Original Message-----
> >> From: Michael S. Tsirkin [mailto:mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> >> Sent: Thursday, May 02, 2013 04:56
> >> To: Or Gerlitz
> >> Cc: Roland Dreier; iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org; Yan Burman;
> >> linux- rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Subject: Re: decent performance drop for SCSI LLD / SAN initiator
> >> when iommu is turned on
> >>
> >> On Thu, May 02, 2013 at 02:11:15AM +0300, Or Gerlitz wrote:
> >>> Hi Roland, IOMMU folks,
> >>>
> >>> So we've noted that when configuring the kernel&&  booting with
> >>> intel iommu set to on on a physical node (non VM, and without
> >>> enabling SRIOV by the HW device driver) raw performance of the iSER
> >>> (iSCSI RDMA) SAN initiator is reduced notably, e.g in the testbed we
> >>> looked today we had ~260K 1KB random IOPS and 5.5GBs BW for 128KB
> >>> IOs with iommu turned off for single LUN, and ~150K IOPS and 4GBs BW
> >>> with iommu turned on. No change on the target node between runs.
> >>
> >> That's why we have iommu=pt.
> >> See definition of iommu_pass_through in arch/x86/kernel/pci-dma.c.
> >
> > I tried passing "intel_iommu=on iommu=pt" to 3.8.11 kernel and I still get
> performance degradation.
> > I get the same numbers with iommu=pt as without it.
> >
> > I wanted to send perf output, but currently I seem to have some problem
> with its output.
> > Will try to get perf differences next week.
> >
> > Yan
> >
> >
> > _______________________________________________
> > iommu mailing list
> > iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu
> dmesg dump? -- interested to see if x2apic is on, and if MSI is used (or not)


The entire dmesg is 98K, so I won't send it here (I can send it off list if you need it), but I see that x2apic is not enabled:

[    0.019051] ------------[ cut here ]------------
[    0.019175] WARNING: at drivers/iommu/intel_irq_remapping.c:542 intel_enable_irq_remapping+0x78/0x279()
[    0.019362] Hardware name: ProLiant DL380p Gen8
[    0.019481] Your BIOS is broken and requested that x2apic be disabled
[    0.019481] This will leave your machine vulnerable to irq-injection attacks
[    0.019481] Use 'intremap=no_x2apic_optout' to override BIOS request
[    0.019750] Modules linked in:
[    0.019921] Pid: 1, comm: swapper/0 Not tainted 3.8.11-perf #4
[    0.020040] Call Trace:
[    0.020159]  [<ffffffff8103d22a>] warn_slowpath_common+0x7a/0xb0
[    0.020279]  [<ffffffff8103d301>] warn_slowpath_fmt+0x41/0x50
[    0.020399]  [<ffffffff8168f300>] intel_enable_irq_remapping+0x78/0x279
[    0.020522]  [<ffffffff8168f563>] irq_remapping_enable+0x1b/0x24
[    0.020646]  [<ffffffff8166faf5>] enable_IR+0x3c/0x3e
[    0.020768]  [<ffffffff8166fb7f>] enable_IR_x2apic+0x88/0x1e7
[    0.020892]  [<ffffffff81672089>] default_setup_apic_routing+0x15/0x6e
[    0.021015]  [<ffffffff8166ef7d>] native_smp_prepare_cpus+0x361/0x395
[    0.021139]  [<ffffffff816625d0>] kernel_init_freeable+0x5e/0x191
[    0.021263]  [<ffffffff8138a810>] ? rest_init+0x80/0x80
[    0.021384]  [<ffffffff8138a819>] kernel_init+0x9/0xf0
[    0.021505]  [<ffffffff8139132c>] ret_from_fork+0x7c/0xb0
[    0.021630]  [<ffffffff8138a810>] ? rest_init+0x80/0x80
[    0.021755] ---[ end trace 307c85faec0be3b4 ]---
[    0.022289] Enabled IRQ remapping in xapic mode
[    0.022409] x2apic not enabled, IRQ remapping is in xapic mode
[    0.022543] Switched APIC routing to physical flat.



MSI is being used:
cat /proc/interrupts | grep mlx
  98:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-comp-0@pci:0000:07:00.0
  99:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-comp-1@pci:0000:07:00.0
 100:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-comp-2@pci:0000:07:00.0
 101:       3877          0          0          0       5503          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-async@pci:0000:07:00.0
 102:        108          0          0          0          0    2012115          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-0@PCI Bus 0000:07
 103:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-1@PCI Bus 0000:07
 104:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-2@PCI Bus 0000:07
 105:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-3@PCI Bus 0000:07
 106:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-4@PCI Bus 0000:07
 107:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-5@PCI Bus 0000:07
 108:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-6@PCI Bus 0000:07
 109:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0  IR-PCI-MSI-edge      mlx4-ib-1-7@PCI Bus 0000:07


I tried passing in 'intremap=no_x2apic_optout' along with iommu=pt, but saw no difference in performance.

I did see a difference between boot with iommu=pt and without it (don't know if it matters):
Without iommu=pt, I get a lot of "IOMMU: Setting identity map for device 0000:07:00.0 [0xe8000 - 0xe8fff]"
With iommu=pt, I get a lot of "IOMMU: hardware identity mapping for device 0000:20:04.7" first and the "Setting identity map for device" messages,
But the device in question (0000:07:00.0) does not appear in " IOMMU: hardware identity mapping" messages.

Yan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
