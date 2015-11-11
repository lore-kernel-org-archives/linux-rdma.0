From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Wed, 11 Nov 2015 08:18:45 -0800
Message-ID: <20151111161845.GA31542@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <56436053.7030201@sandisk.com>
 <20151111154617.GA3754@infradead.org>
 <564366E2.8000209@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564366E2.8000209-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 08:03:46AM -0800, Bart Van Assche wrote:
> Hello Christoph,
> 
> The SRP initiator from kernel 4.3 is working fine on my test setup. I will
> start a test with Linus' tree and with the following SRP kernel module
> parameters:
> 
> # cat /etc/modprobe.d/ib_srp.conf
> options ib_srp cmd_sg_entries=255 register_always=1 prefer_fr=1

I just finished two runs with the current Linus tree.

register_always=N prefer_fr=N finishes fine.

default options isn't happy:

[   69.516617] run fstests generic/001 at 2015-11-11 08:07:39
[   73.649108] XFS (sdb): Unmounting Filesystem
[   73.649265] ------------[ cut here ]------------
[   73.649276] WARNING: CPU: 2 PID: 1785 at drivers/infiniband/ulp/srp/ib_srp.c:1260 srp_map_desc+0x64/0x80 [ib_srp]()
[   73.649278] Modules linked in: xfs libcrc32c ib_srp scsi_transport_srp nfsd auth_rpcgss oid_regi stry nfs_acl nfs lockd grace fscache sunrpc intel_powerclamp coretemp kvm_intel kvm irqbypass crct1 0dif_pclmul crc32_pclmul sha256_ssse3 sha256_generic hmac drbg ansi_cprng snd_pcm mgag200 ttm drm_k ms_helper aesni_intel snd_timer drm aes_x86_64 snd lrw gf128mul psmouse iTCO_wdt iTCO_vendor_support glue_helper soundcore evdev acpi_power_meter ablk_helper i2c_algo_bit lpc_ich serio_raw dcdbas i7core_edac ipmi_devintf pcspkr i2c_core cryptd edac_core shpchp button mfd_core ipmi_si ipmi_msghandler acpi_cpufreq tpm_tis tpm ib_ipoib ib_umad rdma_ucm rdma_cm iw_cm ib_uverbs ib_cm mlx4_ib ib_sa ib_mad ib_core ib_addr autofs4 ext4 crc16 mbcache jbd2 sd_mod sg sr_mod cdrom ata_generic crc32c_intel m
 ptsas ata_piix
[   73.649342]  ehci_pci uhci_hcd scsi_transport_sas ehci_hcd mptscsih libata mptbase mlx4_core usb core scsi_mod usb_common bnx2
[   73.649353] CPU: 2 PID: 1785 Comm: xfsaild/sdb Tainted: G          I 4.3.0+ #32
[   73.649356] Hardware name: Dell Inc. PowerEdge R710/00NH4P, BIOS 3.0.0 01/31/2011
[   73.649358]  ffffffffa04c2460 ffffffff812c9d63 0000000000000000 ffffffff8106ef61
[   73.649361]  ffff8800c94a3a60 ffff8800c94a3a30 00000006102ad1c0 0000000000000001
[   73.649364]  ffff88002dd4c300 ffffffffa04bba14 0801086e00000000 ffff8800c94a3a60 
[   73.649367] Call Trace:
[   73.649376]  [<ffffffff812c9d63>] ? dump_stack+0x40/0x5d
[   73.649383]  [<ffffffff8106ef61>] ? warn_slowpath_common+0x81/0xb0
[   73.649387]  [<ffffffffa04bba14>] ? srp_map_desc+0x64/0x80 [ib_srp]
[   73.649391]  [<ffffffffa04bbb89>] ? srp_map_finish_fr+0x159/0x1f0
[ib_srp]
[   73.649394]  [<ffffffffa04bc1b1>] ? srp_map_idb.isra.39+0xf1/0x150
[ib_srp]
[   73.649398]  [<ffffffffa04be951>] ? srp_queuecommand+0xc21/0xc70
[ib_srp]
[   73.649405]  [<ffffffffa009e58f>] ? scsi_init_sgtable+0x3f/0x70
[scsi_mod]
[   73.649412]  [<ffffffffa009dc08>] ? scsi_dispatch_cmd+0xd8/0x1f0
[scsi_mod]
[   73.649418]  [<ffffffffa00a053a>] ? scsi_request_fn+0x46a/0x600
[scsi_mod]
[   73.649425]  [<ffffffff8129a94f>] ? __blk_run_queue+0x2f/0x40
[   73.649432]  [<ffffffff812c6393>] ? cfq_insert_request+0x2f3/0x530
[   73.649436]  [<ffffffff812a0315>] ? blk_flush_plug_list+0x1f5/0x220
[   73.649440]  [<ffffffff812a06a6>] ? blk_finish_plug+0x26/0x40
[   73.649459]  [<ffffffffa06b1aa2>] ?
__xfs_buf_delwri_submit+0x1b2/0x230 [xfs]
[   73.649474]  [<ffffffffa06b275c>] ?
xfs_buf_delwri_submit_nowait+0x1c/0x30 [xfs]
[   73.649489]  [<ffffffffa06b275c>] ?
xfs_buf_delwri_submit_nowait+0x1c/0x30 [xfs]
[   73.649503]  [<ffffffffa06d99f8>] ? xfsaild+0x258/0x570 [xfs]
[   73.649516]  [<ffffffffa06d97a0>] ?
xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[   73.649520]  [<ffffffff8108b7af>] ? kthread+0xcf/0xf0
[   73.649524]  [<ffffffff8108b6e0>] ? kthread_park+0x50/0x50
[   73.649528]  [<ffffffff8154dc0f>] ? ret_from_fork+0x3f/0x70
[   73.649531]  [<ffffffff8108b6e0>] ? kthread_park+0x50/0x50
[   73.649534] ---[ end trace 2b5af006a2490f6b ]---
[   73.650000] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f84e780
[   83.772430] scsi host3: ib_srp: reconnect succeeded
[   83.780566] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
[   93.900380] scsi host3: ib_srp: reconnect succeeded
[   93.908355] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
[  104.027018] scsi host3: ib_srp: reconnect succeeded
[  104.036106] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
[  114.155391] scsi host3: ib_srp: reconnect succeeded
[  114.163894] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
[  124.285540] scsi host3: ib_srp: reconnect succeeded
[  124.296033] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
[  134.416857] scsi host3: ib_srp: reconnect succeeded
[  134.427546] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
[  144.548077] scsi host3: ib_srp: reconnect succeeded
[  144.555542] scsi host3: ib_srp: failed receive status WR flushed (5)
for iu ffff88060f801cc0
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
