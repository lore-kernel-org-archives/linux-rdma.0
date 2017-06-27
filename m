From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/2] IB/rxe: Set dma_mask and coherent_dma_mask
Date: Tue, 27 Jun 2017 13:04:35 +0300
Message-ID: <20170627100433.GB6554@yuvallap>
References: <20170622141000.9899-1-leon@kernel.org>
 <20170622141000.9899-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170622141000.9899-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Yonatan and Leon,
In one of my servers i got kernel oops also in ib_register_device when
using dummy device (macvtap) with rxe so was blindly hoping this patch
would solve it but is is not.

Crash is in alloc_name somewhere in the "list_for_each_entry" loop, i think
first line of it.

Anyway, steps that i'm doing are:
$ ip link add link eth0 name macvtap3 type macvtap mode bridge
$ modprobe ib_core ib_umad rdma_ucm ib_uverbs rdma_rxe
$ echo eth0 > /sys/module/rdma_rxe/parameters/add
$ echo macvtap3 > /sys/module/rdma_rxe/parameters/add
At this point the system crash.

I'm using 4.12.0-rc6.
This is 100% reproduced.
Interesting thing is that i'm unable to reproduce it on my workstation.

See the below kernel oops:

BUG: unable to handle kernel paging request at ffffffffa073b6db
[159135.410160] IP: report_bug+0x87/0x110
[159135.454889] PGD 1c0c067
[159135.454890] P4D 1c0c067
[159135.486112] PUD 1c0d063
[159135.517334] PMD c381c5067
[159135.548554] PTE 8000000c42ec7161
[159135.581852]
[159135.640138] Oops: 0003 [#1] SMP
[159135.678635] Modules linked in: crc32_generic(E) crc32_pclmul(E) rdma_rxe(E) udp_tunnel(E) ip6_udp_tunnel(E) ib_ipoib(E) rdma_ucm(E) ib_ucm(E) ib_uverbs(E) ib_umad(E) rdma_cm(E) ib_cm(E) iw_cm(E) mlx4_ib(E) ib_core(E) mlx4_en(E) mlx4_core(E) rds_tcp(E) rds(E) xt_REDIRECT(E) nf_nat_redirect(E) xt_nat(E) iptable_nat(E) nf_conntrack_ipv4(E) nf_defrag_ipv4(E) nf_nat_ipv4(E) nf_nat(E) nf_conntrack(E) iptable_filter(E) ip_tables(E) kvm_intel(E) kvm(E) irqbypass(E) macvtap(E) tap(E) macvlan(E) rpcsec_gss_krb5(E) auth_rpcgss(E) nfsv4(E) nfs(E) fscache(E) lockd(E) grace(E) sunrpc(E) bnx2fc(E) cnic(E) uio(E) fcoe(E) libfcoe(E) libfc(E) 8021q(E) scsi_transport_fc(E) mrp(E) garp(E) stp(E) llc(E) configfs(E) iTCO_wdt(E) iTCO_vendor_support(E) pcspkr(E) ipmi_ssif(E) ipmi_si(E) ipmi_msghandler(E) i2c_
 i801(E) lpc_ich(E)
[159136.531229]  mfd_core(E) ioatdma(E) i7core_edac(E) sg(E) acpi_cpufreq(E) igb(E) dca(E) i2c_algo_bit(E) i2c_core(E) ext4(E) mbcache(E) fscrypto(E) jbd2(E) sd_mod(E) ahci(E) libahci(E) ipv6(E) crc_ccitt(E) ptp(E) pps_core(E) megaraid_sas(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E) [last unloaded: mlx4_core]
[159136.866231] CPU: 3 PID: 3533 Comm: bash Tainted: G            E   4.12.0-rc6.master.20170625.ol6.x86_64 #1
[159136.982848] Hardware name: Oracle Corporation SUN FIRE X4170 M2 SERVER        /ASSY,MOTHERBOARD,X4170, BIOS 08140109 12/10/2014
[159137.121282] task: ffff881843225200 task.stack: ffffc9000e160000
[159137.193126] RIP: 0010:report_bug+0x87/0x110
[159137.244188] RSP: 0018:ffffc9000e163938 EFLAGS: 00010202
[159137.307715] RAX: 0000000000000001 RBX: ffffffffa071d4e1 RCX: 0000000000000907
[159137.394202] RDX: ffffffffa073b6d1 RSI: 0000000000000000 RDI: ffffffffa071d4e1
[159137.480687] RBP: ffffc9000e163958 R08: ffffffffa073cf80 R09: ffffc9000e163908
[159137.567175] R10: ffffc9000e1638d8 R11: 00000000000008c4 R12: 000000000000015a
[159137.653660] R13: ffffffffa07376f8 R14: ffffc9000e163ac8 R15: ffff881843225200
[159137.740147] FS:  00007fe99f793700(0000) GS:ffff880c4fac0000(0000) knlGS:0000000000000000
[159137.838065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[159137.907828] CR2: ffffffffa073b6db CR3: 000000184199c000 CR4: 00000000000006e0
[159137.994315] Call Trace:
[159138.024611]  fixup_bug+0x2e/0x50
[159138.064251]  do_trap+0x13f/0x190
[159138.103893]  do_error_trap+0xbd/0x100
[159138.148745]  ? ib_register_device+0x391/0x3a0 [ib_core]
[159138.212282]  ? kmalloc_order_trace+0x34/0xc0
[159138.264392]  ? __kmalloc+0x1cd/0x1e0
[159138.308185]  ? ttwu_do_activate+0x87/0xa0
[159138.357174]  do_invalid_op+0x20/0x30
[159138.400968]  invalid_op+0x1e/0x30
[159138.441654] RIP: 0010:ib_register_device+0x391/0x3a0 [ib_core]
[159138.512454] RSP: 0018:ffffc9000e163b78 EFLAGS: 00010246
[159138.575987] RAX: 0000000000000000 RBX: ffff880c3f8ed000 RCX: 0000000000000000
[159138.662473] RDX: ffffffffa03d3050 RSI: 0000000000000000 RDI: ffff880c3f8ed000
[159138.748959] RBP: ffffc9000e163be8 R08: ffff880c4fadf0e0 R09: ffff880c42cfa360
[159138.835446] R10: ffffc9000e163718 R11: 0000000000000000 R12: 00000000000005dc
[159138.921933] R13: 0000000000000009 R14: ffff8818431f38e0 R15: ffff881843af1a60
[159139.008430]  rxe_register_device+0x315/0x3a0 [rdma_rxe]
[159139.071963]  rxe_add+0x64/0x70 [rdma_rxe]
[159139.120950]  ? dev_get_by_name_rcu+0x76/0xa0
[159139.173054]  rxe_net_add+0x45/0xd0 [rdma_rxe]
[159139.226193]  ? _raw_spin_unlock_bh+0x1e/0x20
[159139.278299]  rxe_param_set_add+0xb5/0x1b0 [rdma_rxe]
[159139.338718]  ? path_to_nameidata+0x40/0x60
[159139.388752]  param_attr_store+0x64/0x90
[159139.435659]  module_attr_store+0x25/0x30
[159139.483610]  sysfs_kf_write+0x3e/0x40
[159139.528441]  kernfs_fop_write+0x113/0x1b0
[159139.577430]  __vfs_write+0x38/0xe0
[159139.619147]  ? filp_close+0x65/0x90
[159139.661906]  ? __getnstimeofday64+0x45/0xe0
[159139.712974]  ? do_dup2+0x99/0xe0
[159139.752614]  ? __sb_start_write+0x5e/0xc0
[159139.801602]  vfs_write+0xc1/0x130
[159139.842280]  ? __fdget+0x13/0x20
[159139.881916]  SyS_write+0x56/0xc0
[159139.921557]  do_syscall_64+0x7a/0x230
[159139.966390]  ? do_page_fault+0x37/0x90
[159140.012261]  entry_SYSCALL64_slow_path+0x25/0x25

Yuval

On Thu, Jun 22, 2017 at 05:10:00PM +0300, Leon Romanovsky wrote:
> From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The RXE coupled with dummy device causes to the kernel panic attached
> below.  The panic happens when ib_register_device tries to set dma_mask
> by accessing a NULLed parent device.
> 
> The RXE does not actually use DMA, so we can set the dma_mask
> to architecture value.
> 
> [16240.199689] RIP: 0010:ib_register_device+0x468/0x5a0 [ib_core]
> [16240.205289] RSP: 0018:ffffc9000220fc10 EFLAGS: 00010246
> [16240.209909] RAX: 0000000000000024 RBX: ffff880220d1a2a8 RCX: 0000000000000000
> [16240.212244] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000009
> [16240.214385] RBP: ffffc9000220fcb0 R08: 0000000000000000 R09: 000000000000023f
> [16240.254465] R10: 0000000000000007 R11: 0000000000000000 R12: 0000000000000000
> [16240.259467] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880220d1a2a8
> [16240.263314] FS:  00007fd8ecca0740(0000) GS:ffff8802364c0000(0000) knlGS:0000000000000000
> [16240.267292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [16240.273503] CR2: 0000000000000218 CR3: 00000002253ba000 CR4: 00000000000006e0
> [16240.277066] Call Trace:
> [16240.281836]  ? __kmalloc+0x26f/0x280
> [16240.286596]  rxe_register_device+0x297/0x300 [rdma_rxe]
> [16240.291377]  rxe_add+0x535/0x5b0 [rdma_rxe]
> [16240.297586]  rxe_net_add+0x3e/0xc0 [rdma_rxe]
> [16240.302375]  rxe_param_set_add+0x65/0x144 [rdma_rxe]
> [16240.307769]  param_attr_store+0x68/0xd0
> [16240.311640]  module_attr_store+0x1d/0x30
> [16240.316421]  sysfs_kf_write+0x3a/0x50
> [16240.317802]  kernfs_fop_write+0xff/0x180
> [16240.322989]  __vfs_write+0x37/0x140
> [16240.328164]  ? handle_mm_fault+0xce/0x240
> [16240.333340]  vfs_write+0xb2/0x1b0
> [16240.335013]  SyS_write+0x55/0xc0
> [16240.340632]  entry_SYSCALL_64_fastpath+0x1a/0xa9
> 
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index 83d709e74dfb..70fd060e30a7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -1245,6 +1245,8 @@ int rxe_register_device(struct rxe_dev *rxe)
>  	addrconf_addr_eui48((unsigned char *)&dev->node_guid,
>  			    rxe->ndev->dev_addr);
>  	dev->dev.dma_ops = &dma_virt_ops;
> +	dma_coerce_mask_and_coherent(&dev->dev,
> +				     dma_get_required_mask(dev->dev.parent));
> 
>  	dev->uverbs_abi_ver = RXE_UVERBS_ABI_VERSION;
>  	dev->uverbs_cmd_mask = BIT_ULL(IB_USER_VERBS_CMD_GET_CONTEXT)
> --
> 2.13.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
