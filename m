From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: mlx4_fmr_unmap() crasher
Date: Mon, 9 Jan 2017 17:01:08 -0500
Message-ID: <153857A5-46D1-49AA-BE5D-757B09E96E76@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I found a remote trigger for a device reset. I've reported the issue
to Mellanox.

However, following the reset, the mlx4 driver oopses. Since that is
open source code (upstream Linux), I'm bringing it up here.

Dec 25 12:22:27 manet journal: run fstests generic/028 at 2016-12-25 12:22:27
Dec 25 12:22:32 manet kernel: mlx4_core 0000:81:00.0: command 0xf failed: fw status = 0x1
Dec 25 12:22:32 manet kernel: mlx4_core 0000:81:00.0: device is going to be reset
Dec 25 12:22:33 manet kernel: mlx4_core 0000:81:00.0: device was reset successfully
Dec 25 12:22:33 manet kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error was started
Dec 25 12:22:33 manet kernel: mlx4_core 0000:81:00.0: Could not post command 0x2f: ret=-5, in_param=0x0, in_mod=0x0, op_mod=0x0
Dec 25 12:22:33 manet kernel: <mlx4_ib> mlx4_ib_unmap_fmr: SYNC_TPT error -5 when unmapping FMRs
Dec 25 12:22:33 manet kernel: <mlx4_ib> mlx4_ib_handle_catas_error: mlx4_ib_handle_catas_error ended
Dec 25 12:22:33 manet kernel: mlx4_en 0000:81:00.0: Internal error detected, restarting device

Dec 25 12:22:33 manet kernel: BUG: unable to handle kernel paging request at ffffc900034e787c
Dec 25 12:22:33 manet kernel: IP: [<ffffffffa021cfcb>] mlx4_fmr_unmap+0x6b/0xb0 [mlx4_core]
Dec 25 12:22:33 manet kernel: PGD 46f88d067
Dec 25 12:22:33 manet kernel: PUD 86f003067
Dec 25 12:22:33 manet kernel: PMD 46db8c067
Dec 25 12:22:33 manet kernel: PTE 0
Dec 25 12:22:33 manet kernel:
Dec 25 12:22:33 manet kernel: Oops: 0002 [#1] SMP
Dec 25 12:22:33 manet kernel: Modules linked in: dm_mod nfsv3 cts rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache iTCO_wdt iTCO_vendor_support sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd pcspkr mei_me i2c_i801 lpc_ich sg mfd_core mei i2c_smbus ioatdma wmi ipmi_si ipmi_msghandler acpi_pad acpi_power_meter nfsd rpcrdma ib_ipoib nfs_acl lockd rdma_ucm ib_ucm grace ib_uverbs ib_umad rdma_cm auth_rpcgss sunrpc ib_cm iw_cm ip_tables xfs libcrc32c mlx4_en mlx4_ib mlx5_ib ib_core sr_mod sd_mod cdrom ast drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx4_core drm mlx5_core igb ahci crc32c_intel libahci ptp libata pps_core dca i2c_al
 go_bit i2c_core
Dec 25 12:22:33 manet kernel: CPU: 9 PID: 11055 Comm: kworker/u29:7 Not tainted 4.9.0-00014-gcac87ed #54
Dec 25 12:22:33 manet kernel: Hardware name: Supermicro SYS-6028R-T/X10DRi, BIOS 1.1a 10/16/2015
Dec 25 12:22:33 manet kernel: Workqueue: xprtrdma_receive rpcrdma_reply_handler [rpcrdma]
Dec 25 12:22:33 manet kernel: task: ffff88086c5595c0 task.stack: ffffc90009230000
Dec 25 12:22:33 manet kernel: RIP: 0010:[<ffffffffa021cfcb>]  [<ffffffffa021cfcb>] mlx4_fmr_unmap+0x6b/0xb0 [mlx4_core]
Dec 25 12:22:33 manet kernel: RSP: 0018:ffffc90009233cc0  EFLAGS: 00010246
Dec 25 12:22:33 manet kernel: RAX: ffff8804637d3c01 RBX: ffffc900034e7850 RCX: 000000000795ef55
Dec 25 12:22:33 manet kernel: RDX: 000000000795ef54 RSI: 0000000000000282 RDI: ffff88046f803b80
Dec 25 12:22:33 manet kernel: RBP: ffffc90009233ce0 R08: 000000000001c540 R09: ffffffffa0202e4d
Dec 25 12:22:33 manet kernel: R10: ffff88087fcdc540 R11: ffffea00118df4c0 R12: ffff880868f10060
Dec 25 12:22:33 manet kernel: R13: ffff8804637d3de0 R14: 0000000000000000 R15: ffff88046b066fa8
Dec 25 12:22:33 manet kernel: FS:  0000000000000000(0000) GS:ffff88087fcc0000(0000) knlGS:0000000000000000
Dec 25 12:22:33 manet kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 25 12:22:33 manet kernel: CR2: ffffc900034e787c CR3: 0000000001c07000 CR4: 00000000001406e0
Dec 25 12:22:33 manet kernel: Stack:
Dec 25 12:22:33 manet kernel: ffff880868f10060 ffffc900034e7828 ffffc90009233d28 ffff8803eb3f0000
Dec 25 12:22:33 manet kernel: ffffc90009233d08 ffffffffa0308fa7 ffffc90009233d28 ffff88086c0b4000
Dec 25 12:22:33 manet kernel: ffff88086c0b41c8 ffffc90009233d18 ffffffffa01b4ea0 ffffc90009233d60
Dec 25 12:22:33 manet kernel: Call Trace:
Dec 25 12:22:33 manet kernel: [<ffffffffa0308fa7>] mlx4_ib_unmap_fmr+0x67/0xc0 [mlx4_ib]
Dec 25 12:22:33 manet kernel: [<ffffffffa01b4ea0>] ib_unmap_fmr+0x20/0x30 [ib_core]
Dec 25 12:22:33 manet journal: run fstests generic/029 at 2016-12-25 12:22:33
Dec 25 12:22:33 manet kernel: [<ffffffffa05085ea>] fmr_op_unmap_sync+0x8a/0x200 [rpcrdma]
Dec 25 12:22:33 manet kernel: [<ffffffffa05054b4>] rpcrdma_reply_handler+0x244/0x8a0 [rpcrdma]
Dec 25 12:22:33 manet kernel: [<ffffffff8102d698>] ? __switch_to+0x208/0x5f0
Dec 25 12:22:33 manet kernel: [<ffffffff8109dbb3>] process_one_work+0x153/0x3f0
Dec 25 12:22:33 manet kernel: [<ffffffff8109e53b>] worker_thread+0x12b/0x4b0
Dec 25 12:22:33 manet kernel: [<ffffffff8109e410>] ? rescuer_thread+0x370/0x370
Dec 25 12:22:33 manet kernel: [<ffffffff810a42a9>] kthread+0xd9/0xf0
Dec 25 12:22:33 manet kernel: [<ffffffff810a41d0>] ? kthread_park+0x60/0x60
Dec 25 12:22:33 manet kernel: [<ffffffff816c0b55>] ret_from_fork+0x25/0x30
Dec 25 12:22:33 manet kernel: Code: 24 54 01 00 00 8b 53 20 4c 89 e7 8d 70 ff c1 ca 08 21 d6 e8 b8 fe ff ff 4c 89 ee 41 89 c6 4c 89 e7 e8 5a 5e fe ff 45 85 f6 75 22 <c7> 43 2c 02 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 89 c6 48 c7 c7
Dec 25 12:22:33 manet kernel: RIP  [<ffffffffa021cfcb>] mlx4_fmr_unmap+0x6b/0xb0 [mlx4_core]
Dec 25 12:22:33 manet kernel: RSP <ffffc90009233cc0>
Dec 25 12:22:33 manet kernel: CR2: ffffc900034e787c
Dec 25 12:22:33 manet kernel: ---[ end trace 5327e37e047cfb91 ]---


1107 void mlx4_fmr_unmap(struct mlx4_dev *dev, struct mlx4_fmr *fmr,
1108                     u32 *lkey, u32 *rkey)
1109 {
1110         struct mlx4_cmd_mailbox *mailbox;
1111         int err;
1112 
1113         if (!fmr->maps)
1114                 return;
1115 
1116         fmr->maps = 0;
1117 
1118         mailbox = mlx4_alloc_cmd_mailbox(dev);
1119         if (IS_ERR(mailbox)) {
1120                 err = PTR_ERR(mailbox);
1121                 pr_warn("mlx4_ib: mlx4_alloc_cmd_mailbox failed (%d)\n", err);
1122                 return;
1123         }
1124 
1125         err = mlx4_HW2SW_MPT(dev, NULL,
1126                              key_to_hw_index(fmr->mr.key) &
1127                              (dev->caps.num_mpts - 1));
1128         mlx4_free_cmd_mailbox(dev, mailbox);
1129         if (err) {
1130                 pr_warn("mlx4_ib: mlx4_HW2SW_MPT failed (%d)\n", err);
1131                 return;
1132         }
1133         fmr->mr.enabled = MLX4_MPT_EN_SW;
1134 }
1135 EXPORT_SYMBOL_GPL(mlx4_fmr_unmap);

The crash is at line 1133, according to objdump.


I recognize that a device reset is probably not going to be 100%
recoverable. However, I have some questions:

1. "command 0xf failed: fw status = 0x1": 0xf is MLX4_CMD_HW2SW_MPT
and 0x1 is CMD_STAT_INTERNAL_ERR. Why doesn't mlx4_HW2SW_MPT return
an error if an internal error is reported while issuing that command?

2. It appears that the reset is somehow freeing the memory pointed
to by "fmr". mlx4_ib_unmap_fmr is walking a list of FMRs using the
list_for_each_entry macro. Even if mlx4_HW2SW_MPT returned an
error, that macro in the caller will examine that freed memory to
determine whether the list is terminated or there is another FMR
to unmap.

3. "mailbox" is allocated in line 1118, released in line 1128, but
is not otherwise used. Should it be passed to mlx4_HW2SW_MPT? I
have not found another mlx4_alloc_cmd_mailbox call site where the
returned mailbox is ignored.

4. Nit: "lkey" and "rkey" are not used in this function. Are they
part of an API contract, or can they be removed?


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
