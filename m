From: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: clean ib tx ring periodically
Date: Thu, 16 Feb 2017 18:47:10 +0100
Message-ID: <1487267230.6505.1.camel@redhat.com>
References: <589591340739f0ceeea9ca449b6de3df01caadc4.1487259121.git.pabeni@redhat.com>
         <20170216170946.GZ6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170216170946.GZ6989-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-02-16 at 19:09 +0200, Leon Romanovsky wrote:
> On Thu, Feb 16, 2017 at 04:35:31PM +0100, Paolo Abeni wrote:
> > The skbs transmitted via ipoib_send() are freed only if there are
> > 16 or more outstanding work requests or if the send queue is full.
> > 
> > If there is very little networking activity, the transmitted skbs
> > can be held by the device driver for an unlimited amount of time,
> > starving other subsystems.
> > 
> > E.g. assuming the ipv6 is enabled, with the following sequence:
> > 
> > systemctl start firewalld
> > modprobe ib_ipoib
> > ip addr add dev ib0 fc00::1/64
> > systemctl stop firewalld
> > 
> > a cpu will hang: rmmod conntrack will keep a core busy
> > spinning for nf_conntrack_untracked going to 0, since some ICMP6
> > ND packets are generated and transmitted when the ipv6 address
> > is attached to the device, and such packets get a notrack ct
> > entry.
> > 
> > This change address the issue introducing a periodic timer performing
> > "garbage collection" on the send ring at low frequency (once every
> > second).
> > 
> > This new timer runs independently from the currently used poll_timer,
> > so that no additional delay is introduced to clean the ring after
> > errors or ring full event.
> > 
> > Reported-by: Thomas Cameron <tcameron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Fixes: f56bcd801356 ("IPoIB: Use separate CQ for UD send completions")
> > Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib.h    |  2 ++
> >  drivers/infiniband/ulp/ipoib/ipoib_ib.c | 35 +++++++++++++++++++++++++++------
> >  2 files changed, 31 insertions(+), 6 deletions(-)
> > 
> 
> Hi Paolo,
> 
> This patch crashes in our verification system on Mellanox CX3 HCA.
> 
> [  105.569758] console [netcon0] enabled
> [  105.569801] netconsole: network logging started
> [  105.570316] sysrq: SysRq : Changing Loglevel
> [  105.570393] sysrq: Loglevel set to 8
> [  127.303248] IPv6: ADDRCONF(NETDEV_UP): ib0: link is not ready
> [  135.501051] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [  135.501182] IP:           (null)
> [  135.501231] PGD 34d5e067
> [  135.501231] PUD 34eae067
> [  135.501311] PMD 0
> [  135.501351]
> [  135.501431] Oops: 0010 [#1] SMP
> [  135.501491] Modules linked in: netconsole nfsv3 nfs fscache rdma_ucm ib_ucm
> rdma_cm iw_cm ib_ipoib ib_cm ib_uverbs ib_umad mlx4_en ptp pps_core ib_core
> dm_mirror dm_region_hash dm_log dm_mod ppdev pcspkr nfsd parport_pc parport
> i2c_piix4 acpi_cpufreq auth_rpcgss nfs_acl lockd grace sunrpc ip_tables
> ata_generic cirrus drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
> ttm serio_raw pata_acpi drm virtio_console mlx4_core e1000 devlink i2c_core
> floppy ata_piix [last unloaded: mlx4_ib]
> [  135.501812] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.10.0-rc8-2017-02-16_18-01-48_Paolo_Abeni__pabeni_redhat_com #1
> [  135.501895] Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
> [  135.501985] task: ffff88013a429480 task.stack: ffffc90000694000
> [  135.502057] RIP: 0010:          (null)
> [  135.502106] RSP: 0018:ffff88013fcc3e28 EFLAGS: 00010286
> [  135.502155] RAX: ffff880138dd0c00 RBX: ffff880138bac900 RCX: 00000000fffd7780
> [  135.502221] RDX: ffff880138bace88 RSI: 0000000000000010 RDI: ffff880138dd1400
> [  135.502285] RBP: ffff88013fcc3e78 R08: ffff88013fcd0630 R09: ffff88013fcc3ef8
> [  135.502357] R10: 0000000000000200 R11: 0000000000000020 R12: ffff880138bace88
> [  135.502423] R13: 0000000000000001 R14: 0000000000000003 R15: ffff880138bac000
> [  135.502487] FS:  0000000000000000(0000) GS:ffff88013fcc0000(0000) knlGS:0000000000000000
> [  135.502558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  135.502615] CR2: 0000000000000000 CR3: 000000008d77b000 CR4: 00000000000006e0
> [  135.502675] Call Trace:
> [  135.502711]  <IRQ>
> [  135.502766]  ? poll_tx+0x39/0x250 [ib_ipoib]
> [  135.502821]  ? cpu_load_update+0xdc/0x150
> [  135.502863]  ipoib_tx_gc_timer_func+0x115/0x130 [ib_ipoib]
> [  135.502910]  ? poll_tx+0x250/0x250 [ib_ipoib]
> [  135.502951]  call_timer_fn+0x35/0x140
> [  135.502994]  run_timer_softirq+0x1d7/0x460
> [  135.503034]  ? kvm_sched_clock_read+0x1e/0x30
> [  135.504133]  ? sched_clock+0x9/0x10
> [  135.505240]  ? sched_clock_cpu+0x72/0xa0
> [  135.506293]  __do_softirq+0xd7/0x2a8
> [  135.507328]  irq_exit+0xb5/0xc0
> [  135.508339]  smp_apic_timer_interrupt+0x3d/0x50
> [  135.509342]  apic_timer_interrupt+0x89/0x90
> [  135.510346] RIP: 0010:native_safe_halt+0x6/0x10
> [  135.511360] RSP: 0018:ffffc90000697ea0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
> [  135.512405] RAX: 0000000000000000 RBX: ffff88013a429480 RCX: 0000000000000000
> [  135.513457] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [  135.514496] RBP: ffffc90000697ea0 R08: 00000000d5555b28 R09: 0000000000000000
> [  135.515535] R10: 0000000000000200 R11: ffffc900022b7ef0 R12: 0000000000000003
> [  135.516579] R13: ffff88013a429480 R14: 0000000000000000 R15: 0000000000000000
> [  135.517620]  </IRQ>
> [  135.518650]  default_idle+0x1e/0xd0
> [  135.519672]  arch_cpu_idle+0xf/0x20
> [  135.520673]  default_idle_call+0x35/0x40
> [  135.521678]  do_idle+0x15b/0x200
> [  135.522687]  cpu_startup_entry+0x1d/0x30
> [  135.523706]  start_secondary+0x103/0x130
> [  135.524734]  start_cpu+0x14/0x14
> [  135.525793] Code:  Bad RIP value.
> [  135.526798] RIP:           (null) RSP: ffff88013fcc3e28
> [  135.527767] CR2: 0000000000000000
> [  135.528727] ---[ end trace 8acb66738f095ba7 ]---
> [  135.529639] Kernel panic - not syncing: Fatal exception in interrupt
> [  135.531590] Kernel Offset: disabled
> [  135.532496] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

Can you please add more info on the testing setup ? I can't reproduce
the above in my [pretty much trivial] test-bed

Thank you!

Paolo
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
