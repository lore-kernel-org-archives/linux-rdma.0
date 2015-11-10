From: Christoph Hellwig <hch@infradead.org>
Subject: srp state in current mainline
Date: Tue, 10 Nov 2015 09:15:09 -0800
Message-ID: <20151110171509.GA27781@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

I've just tried forward porting some work affecting SRP from a 4.1-ish
base, and started to run into error ASAP on current Linus' HEAD and also
4.3.  In current HEAD memory registrations on the client seem to fail,
probably due to the MR rework, but even on 4.3 I run into crazy
corruption reports from xfstests, which mostly seem to be slab
poisoning.  I'm not sure at this point if they are caused by the
target or initiator, but I'd like to share them.  This is a simply
xfstests run using XFS on a remote LIO ramdisk.

4.3 (actually -rc, but I didn't see any change since):

[   86.316719] run fstests generic/018 at 2015-11-10 08:52:56
[   86.558749] XFS (sdb): Mounting V4 Filesystem
[   86.798915] XFS (sdb): Ending clean mount
[   86.887999] XFS (sdc): Mounting V4 Filesystem
[   86.894340] XFS (sdc): Ending clean mount
[   86.980603] XFS (sdc): Unmounting Filesystem
[   86.992347] XFS (sdc): Mounting V4 Filesystem
[   86.999572] XFS (sdc): Ending clean mount
[   87.052941] XFS (sdc): Unmounting Filesystem
[   87.065080] XFS (sdc): Mounting V4 Filesystem
[   87.070402] XFS (sdc): Ending clean mount
[   87.124831] XFS (sdc): Unmounting Filesystem
[   87.136828] XFS (sdc): Mounting V4 Filesystem
[   87.144746] XFS (sdc): Ending clean mount
[   87.157052] XFS (sdc): Metadata corruption detected at xfs_agi_read_verify+0x4a/0xe0 [xfs], block 0x2
[   87.166374] XFS (sdc): Unmount and run xfs_repair
[   87.171161] XFS (sdc): First 64 bytes of corrupted metadata buffer:
[   87.177515] ffff880314c2ce00: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   87.186312] ffff880314c2ce10: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   87.195107] ffff880314c2ce20: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   87.203902] ffff880314c2ce30: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   87.212716] XFS (sdc): metadata I/O error: block 0x2
("xfs_trans_read_buf_map") error 117 numblks 1
[   87.221816] XFS (sdc): xfs_do_force_shutdown(0x1) called from line
315 of file fs/xfs/xfs_trans_buf.c.  Return address = 0xffffffffa067138c
   87.221828] XFS (sdc): I/O Error Detected. Shutting down filesystem
   [   87.228132] XFS (sdc): Please umount the filesystem and rectify
   the problem(s)
   [   87.328890] XFS (sdc): xfs_log_force: error -5 returned.
   [   87.328897] XFS (sdc): Unmounting Filesystem
   [   87.328906] XFS (sdc): xfs_log_force: error -5 returned.
   [   87.328921] XFS (sdc): xfs_log_force: error -5 returned.
   [   87.432013] run fstests generic/020 at 2015-11-10 08:52:57

and then a couple times more until xfstests eventually gives up.

On current Linus' HEAD tree:

[  128.786534] run fstests generic/001 at 2015-11-10 09:05:06
[  132.914320] XFS (sdb): Unmounting Filesystem
[  132.914463] ------------[ cut here ]------------
[  132.914474] WARNING: CPU: 3 PID: 1795 at drivers/infiniband/ulp/srp/ib_srp.c:1262 srp_map_desc+0x64/ 0x80 [ib_srp]()
[  132.914476] Modules linked in: xfs libcrc32c ib_srp(O) scsi_transport_srp nfsd auth_rpcgss oid_regis
try nfs_acl nfs lockd grace fscache sunrpc intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_
pclmul crc32_pclmul sha256_ssse3 sha256_generic hmac drbg mgag200 ttm ansi_cprng drm_kms_helper aesni_i
ntel drm aes_x86_64 lrw gf128mul snd_pcm glue_helper ablk_helper snd_timer evdev cryptd ipmi_devintf i7
core_edac shpchp iTCO_wdt iTCO_vendor_support psmouse snd soundcore i2c_algo_bit i2c_core lpc_ich serio
_raw edac_core dcdbas acpi_power_meter pcspkr mfd_core acpi_cpufreq button tpm_tis ipmi_si ipmi_msghand
ler tpm ib_ipoib ib_umad rdma_ucm rdma_cm iw_cm ib_uverbs ib_cm mlx4_ib ib_sa ib_mad ib_core ib_addr au
tofs4 ext4 crc16 mbcache jbd2 sd_mod sg sr_mod cdrom ata_generic crc32c_intel ehci_pci uhci_hcd
[  132.914541]  ehci_hcd mptsas ata_piix scsi_transport_sas mptscsih
libata mptbase mlx4_core usbcore s
csi_mod usb_common bnx2
[  132.914552] CPU: 3 PID: 1795 Comm: xfsaild/sdb Tainted: G          IO 4.3.0+ #28
[  132.914554] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS 3.0.0 01/31/2011
[  132.914556]  ffffffffa05aa460 ffffffff812c9453 0000000000000000 ffffffff8106ef51
[  132.914559]  ffff880313acfa60 ffff880313acfa30 00000006153efe80 0000000000000001
[  132.914562]  ffff880620a310c0 ffffffffa05a3a14 0801220700000000 ffff880313acfa60
[  132.914566] Call Trace:
[  132.914572]  [<ffffffff812c9453>] ? dump_stack+0x40/0x5d
[  132.914578]  [<ffffffff8106ef51>] ? warn_slowpath_common+0x81/0xb0
[  132.914582]  [<ffffffffa05a3a14>] ? srp_map_desc+0x64/0x80 [ib_srp]
[  132.914585]  [<ffffffffa05a3b89>] ? srp_map_finish_fr+0x159/0x1f0 [ib_srp]
[  132.914589]  [<ffffffffa05a41c1>] ? srp_map_idb.isra.39+0xf1/0x150 [ib_srp]
[  132.914593]  [<ffffffffa05a6961>] ? srp_queuecommand+0xc21/0xc70 [ib_srp]
[  132.914600]  [<ffffffffa009058f>] ? scsi_init_sgtable+0x3f/0x70 [scsi_mod]
[  132.914607]  [<ffffffffa008fc08>] ? scsi_dispatch_cmd+0xd8/0x1f0 [scsi_mod]
[  132.914613]  [<ffffffffa009253a>] ? scsi_request_fn+0x46a/0x600 [scsi_mod]
[  132.914619]  [<ffffffff8129a2ff>] ? __blk_run_queue+0x2f/0x40
[  132.914624]  [<ffffffff812c5a83>] ? cfq_insert_request+0x2f3/0x530
[  132.914628]  [<ffffffff8129fcc5>] ? blk_flush_plug_list+0x1f5/0x220
[  132.914631]  [<ffffffff812a0056>] ? blk_finish_plug+0x26/0x40
[  132.914654]  [<ffffffffa05f4aa2>] ? __xfs_buf_delwri_submit+0x1b2/0x230 [xfs]
[  132.914669]  [<ffffffffa05f575c>] ?
xfs_buf_delwri_submit_nowait+0x1c/0x30 [xfs]
[  132.914683]  [<ffffffffa05f575c>] ? xfs_buf_delwri_submit_nowait+0x1c/0x30 [xfs]
[  132.914696]  [<ffffffffa061c9f8>] ? xfsaild+0x258/0x570 [xfs]
[  132.914710]  [<ffffffffa061c7a0>] ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[  132.914714]  [<ffffffff8108b79f>] ? kthread+0xcf/0xf0
[  132.914717]  [<ffffffff8108b6d0>] ? kthread_park+0x50/0x50
[  132.914721]  [<ffffffff8154d58f>] ? ret_from_fork+0x3f/0x70
[  132.914724]  [<ffffffff8108b6d0>] ? kthread_park+0x50/0x50
[  132.914727] ---[ end trace 5ef1c59be4197e01 ]---
[  132.915191] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff880313f4ca40

and then we end up in a reconnect loop
