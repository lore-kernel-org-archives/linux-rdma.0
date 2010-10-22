From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: BUG dump from QIB
Date: Fri, 22 Oct 2010 14:40:41 -0600
Message-ID: <20101022204041.GA30241@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ralph,

It doesn't look like smp_processor_id is callable the way QIB does, I
get kernel BUGS:

This is a stock upstream with CONFIG_PREEMPT/DEBUG_PREEMPT
$ uname -a
Linux ib6 2.6.35.7 #17 SMP PREEMPT Thu Oct 7 15:38:53 MDT 2010 x86_64 GNU/Linux

[   36.769466] BUG: using smp_processor_id() in preemptible [00000000] code: insmod/5858
[   36.769500] caller is qib_create_qp+0x56c/0x745 [ib_qib]
[   36.769505] Pid: 5858, comm: insmod Not tainted 2.6.35.7 #17
[   36.769508] Call Trace:
[   36.769520]  [<ffffffff8116c776>] debug_smp_processor_id+0xc2/0xdc
[   36.769538]  [<ffffffffa0201b18>] qib_create_qp+0x56c/0x745 [ib_qib]
[   36.769545]  [<ffffffff8102fcb9>] ? sub_preempt_count+0x92/0xa5
[   36.769550]  [<ffffffff8102eb47>] ? get_parent_ip+0x11/0x41
[   36.769554]  [<ffffffff8102eb47>] ? get_parent_ip+0x11/0x41
[   36.769573]  [<ffffffffa00758ab>] ib_create_qp+0x18/0x8e [ib_core]
[   36.769582]  [<ffffffffa008c948>] create_mad_qp+0x7d/0xce [ib_mad]
[   36.769589]  [<ffffffffa008c13b>] ? qp_event_handler+0x0/0x1e [ib_mad]
[   36.769596]  [<ffffffffa008cec4>] ib_mad_init_device+0x2cf/0x6ad [ib_mad]
[   36.769603]  [<ffffffff8131c1ef>] ? _raw_spin_unlock_irqrestore+0x2c/0x37
[   36.769613]  [<ffffffffa0077bef>] ib_register_device+0x35d/0x401 [ib_core]
[   36.769632]  [<ffffffffa020983b>] ? qib_create_port_files+0x0/0x265 [ib_qib]
[   36.769654]  [<ffffffffa02236b5>] qib_register_ib_device+0x76a/0x8a8 [ib_qib]
[   36.769673]  [<ffffffffa022af11>] qib_init_one+0xdd/0x4f7 [ib_qib]
[   36.769680]  [<ffffffff81175a97>] local_pci_probe+0x12/0x16
[   36.769685]  [<ffffffff81176755>] pci_device_probe+0x5f/0x89
[   36.769690]  [<ffffffff811cef0a>] ? driver_sysfs_add+0x4c/0x72
[   36.769695]  [<ffffffff811cf04f>] driver_probe_device+0xa3/0x151
[   36.769699]  [<ffffffff811cf155>] __driver_attach+0x58/0x7b
[   36.769704]  [<ffffffff811cf0fd>] ? __driver_attach+0x0/0x7b
[   36.769708]  [<ffffffff811ce8c9>] bus_for_each_dev+0x4e/0x85
[   36.769712]  [<ffffffff811ceebc>] driver_attach+0x1c/0x1e
[   36.769716]  [<ffffffff811ce1e1>] bus_add_driver+0xb8/0x20d
[   36.769721]  [<ffffffff811cf432>] driver_register+0xb3/0x121
[   36.769736]  [<ffffffffa02420a2>] ? qlogic_ib_init+0x0/0x126 [ib_qib]
[   36.769740]  [<ffffffff811769b2>] __pci_register_driver+0x51/0xbc
[   36.769754]  [<ffffffffa02420a2>] ? qlogic_ib_init+0x0/0x126 [ib_qib]
[   36.769769]  [<ffffffffa0242165>] qlogic_ib_init+0xc3/0x126 [ib_qib]
[   36.769775]  [<ffffffff810001f0>] do_one_initcall+0x5a/0x14a
[   36.769781]  [<ffffffff8106815d>] sys_init_module+0x9a/0x1d8

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
