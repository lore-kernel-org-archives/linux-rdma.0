From: Robert Randall <robert.r.randall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NVMeoF Linux GIT repo
Date: Tue, 25 Oct 2016 09:06:20 -0500
Message-ID: <CAEqzOjuFAQbP90as+HKiEkCNm1UdP1rw92SD92f6y5aiGa844Q@mail.gmail.com>
References: <f5eefaea1d4b4d24945fdfb12da5a6ab@bowex36e.micron.com> <2aeadd6a-0f5c-5c59-cafa-10116ccc91c0@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2aeadd6a-0f5c-5c59-cafa-10116ccc91c0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "Robert Randall (rrandall)" <rrandall-AL4WhLSQfzjQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Any update on this from Haggi?  Trying to understand if this is a
problem with our host driver or something on the Linux side.

Thanks,
Robert

On Fri, Oct 21, 2016 at 5:19 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> Hey Robert,
>
>> Sorry Keith, I'm back to the same question again.  I've tried using the
>> released 4.8.2 kernel and I'm seeing errors in the Linux RDMA layer.  Log
>> file is attached.  My guess is this may have been fixed already but since
>> I'm not writing code on Linux it is difficult to keep up with which repo and
>> which branch I should be using.
>>
>> It reports a syndrome 5 which appears to mean "work request flush error".
>>
>> Setup is stable 4.8.2 kernel with Mellanox RoCE v2.
>>
>> So, where do I grab the latest and greatest code these days?
>
>
> So from a quick look at the log the FLUSH errors are
> just side effects. Once a queue-pair transitions to
> ERROR state it flushes all the pending work requests with
> a FLUSH syndrome, so we should look at the first error which
> is:
>
> mlx5_1:poll_soft_wc:647:(pid 3422): polled software generated completion on
> CQ 0x14
>
> This seems to come from the GSI QP completion emulation from
> Haggai (CC'd). CQ 0x14 is not nvmet-rdma completion queue (from
> the log it's 0x5d) so something went wrong but its does not
> seem to be nvmet-rdma's fault.
>
> Haggai, any tips for Robert?
>
> Log output:
> [   12.588248] mlx5_core 0000:06:00.0 enp6s0f0: Link up
> [   12.735116] mlx5_core 0000:06:00.1 enp6s0f1: Link up
> [   16.490224] e1000e: enp8s0 NIC Link is Up 1000 Mbps Full Duplex, Flow
> Control: Rx/Tx
> [   20.005394] input: PS/2 Generic Mouse as
> /devices/platform/i8042/serio1/input/input4
> [   33.138312] random: crng init done
> [   57.710309] (0000:06:00.1): E-Switch: disable SRIOV: active vports(1)
> mode(0)
> [   57.713889] (0000:06:00.1): E-Switch: cleanup
> [   58.399819] (0000:06:00.0): E-Switch: disable SRIOV: active vports(1)
> mode(0)
> [   58.401660] (0000:06:00.0): E-Switch: cleanup
> [   59.134997] mlx5_core 0000:06:00.0: firmware version: 12.16.1020
> [   59.855855] (0000:06:00.0): E-Switch: Total vports 9, l2 table
> size(65536), per vport: max uc(1024) max mc(16384)
> [   59.857209] mlx5_core 0000:06:00.1: firmware version: 12.16.1020
> [   60.563522] (0000:06:00.1): E-Switch: Total vports 9, l2 table
> size(65536), per vport: max uc(1024) max mc(16384)
> [   60.566269] mlx5_core 0000:06:00.0: MLX5E: StrdRq(0) RqSz(1024) StrdSz(1)
> RxCqeCmprss(0)
> [   60.737262] mlx5_core 0000:06:00.0 enp6s0f0: renamed from eth0
> [   60.737617] mlx5_core 0000:06:00.1: MLX5E: StrdRq(0) RqSz(1024) StrdSz(1)
> RxCqeCmprss(0)
> [   61.038325] mlx5_core 0000:06:00.0 enp6s0f0: Link up
> [   61.041446] mlx5_core 0000:06:00.1 enp6s0f1: renamed from eth0
> [   61.047290] mlx5_ib: Mellanox Connect-IB Infiniband driver v2.2-1 (Feb
> 2014)
> [   61.981595] mlx5_core 0000:06:00.1 enp6s0f1: Link up
> [   63.159807] e1000e: enp8s0 NIC Link is Down
> [   67.836775] e1000e: enp8s0 NIC Link is Up 1000 Mbps Full Duplex, Flow
> Control: Rx/Tx
> [   74.745144] mlx5_core 0000:06:00.0 enp6s0f0: Link up
> [   74.944733] nvmet: adding nsid 1 to subsystem ignite1
> [   74.945148] nvmet: adding nsid 2 to subsystem ignite2
> [   74.945510] nvmet: adding nsid 3 to subsystem ignite3
> [   74.945864] nvmet: adding nsid 4 to subsystem ignite4
> [   74.946747] nvmet_rdma: enabling port 2 (192.168.2.10:5150)
> micron@fmslnx0:~$ tail -f /var/log/syslog
> Oct 20 07:28:17 fmslnx0 systemd[1]: Reloaded OpenBSD Secure Shell server.
> Oct 20 07:28:17 fmslnx0 kernel: [   74.745144] mlx5_core 0000:06:00.0
> enp6s0f0: Link up
> Oct 20 07:28:17 fmslnx0 systemd[1]: Reloading OpenBSD Secure Shell server.
> Oct 20 07:28:17 fmslnx0 systemd[1]: Reloaded OpenBSD Secure Shell server.
> Oct 20 07:28:17 fmslnx0 systemd[1]: Started Raise network interfaces.
> Oct 20 07:28:18 fmslnx0 kernel: [   74.944733] nvmet: adding nsid 1 to
> subsystem ignite1
> Oct 20 07:28:18 fmslnx0 kernel: [   74.945148] nvmet: adding nsid 2 to
> subsystem ignite2
> Oct 20 07:28:18 fmslnx0 kernel: [   74.945510] nvmet: adding nsid 3 to
> subsystem ignite3
> Oct 20 07:28:18 fmslnx0 kernel: [   74.945864] nvmet: adding nsid 4 to
> subsystem ignite4
> Oct 20 07:28:18 fmslnx0 kernel: [   74.946747] nvmet_rdma: enabling port 2
> (192.168.2.10:5150)
> Oct 20 07:35:01 fmslnx0 CRON[3376]: (root) CMD (command -v debian-sa1 >
> /dev/null && debian-sa1 1 1)
> Oct 20 07:42:35 fmslnx0 systemd[1]: Starting Cleanup of Temporary
> Directories...
> Oct 20 07:42:35 fmslnx0 systemd-tmpfiles[3381]:
> [/usr/lib/tmpfiles.d/var.conf:14] Duplicate line for path "/var/log",
> ignoring.
> Oct 20 07:42:35 fmslnx0 systemd[1]: Started Cleanup of Temporary
> Directories.
> Oct 20 07:45:01 fmslnx0 CRON[3395]: (root) CMD (command -v debian-sa1 >
> /dev/null && debian-sa1 1 1)
> Oct 20 07:50:48 fmslnx0 dhclient[3245]: DHCPREQUEST of 10.113.22.90 on
> enp8s0 to 10.113.22.46 port 67 (xid=0x19ae475f)
> Oct 20 07:50:48 fmslnx0 dhclient[3245]: DHCPACK of 10.113.22.90 from
> 10.113.22.46
> Oct 20 07:50:48 fmslnx0 dhclient[3245]: bound to 10.113.22.90 -- renewal in
> 1615 seconds.
> Oct 20 07:55:01 fmslnx0 CRON[3412]: (root) CMD (command -v debian-sa1 >
> /dev/null && debian-sa1 1 1)
> Oct 20 08:05:01 fmslnx0 CRON[3418]: (root) CMD (command -v debian-sa1 >
> /dev/null && debian-sa1 1 1)
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.978705] nvmet_rdma: connect request
> (4): status 0 id ffff8e0aa2f2bc00
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.979382] nvmet_rdma: added mlx5_1.
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.980211]
> mlx5_1:mlx5_ib_create_cq:948:(pid 1442): cqn 0x5d
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.980269] mlx5_1:calc_sq_size:355:(pid
> 1442): wqe_size 640
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.981626]
> mlx5_1:mlx5_ib_create_qp:2041:(pid 1442): ib qpnum 0xf1, mlx qpn 0xf1, rcqn
> 0x5d, scqn 0x5d
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.982372] nvmet_rdma:
> nvmet_rdma_create_queue_ib: max_cqe= 63 max_sge= 32 sq_size = 51 cm_id=
> ffff8e0aa2f2bc00
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.984271] mlx5_1:poll_soft_wc:647:(pid
> 3422): polled software generated completion on CQ 0x14
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.985964] nvmet_rdma: established (9):
> status 0 id ffff8e0aa2f2bc00
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.987073] nvmet: ctrl 1 start
> keep-alive timer for 120 secs
> Oct 20 08:13:15 fmslnx0 kernel: [ 2771.987122] nvmet: creating controller 1
> for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:01020304.
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.120199] nvmet_rdma: disconnected
> (10): status 0 id ffff8e0aa2f2bc00
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.120253] nvmet_rdma: cm_id=
> ffff8e0aa2f2bc00 queue->state= 1
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.121781] mlx5_1:poll_soft_wc:647:(pid
> 3422): polled software generated completion on CQ 0x14
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122046] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122105] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf5
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122315] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Requestor error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122374] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf5
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122428] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122480] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122534] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122586] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122639] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122690] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122742] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122794] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122846] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122897] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.122949] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123000] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123052] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123103] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123155] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123207] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123260] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123311] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123363] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123414] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123466] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123518] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123570] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123621] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123673] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123724] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123776] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123828] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123881] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123933] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.123991] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124042] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124433] mlx5_1:mlx5_poll_one:586:(pid
> 3422): Responder error cqe on cqn 0x5d:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124488] mlx5_1:mlx5_poll_one:588:(pid
> 3422): syndrome 0x5, vendor syndrome 0xf9
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124567] nvmet_rdma: freeing queue 0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124607] ------------[ cut here
> ]------------
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124651] WARNING: CPU: 0 PID: 1445 at
> kernel/softirq.c:150 __local_bh_enable_ip+0x6b/0x80
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.124710] Modules linked in: mlx5_ib
> mlx5_core rdma_ucm ib_uverbs ib_mthca nvmet_rdma nvmet nls_iso8859_1
> intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp
> dcdbas dell_smm_hwmon kvm_intel kvm irqbypass serio_raw
> snd_hda_codec_realtek snd_hda_codec_generic joydev input_leds
> snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep
> snd_pcm lpc_ich snd_timer snd soundcore mei_me shpchp mei ib_iser rdma_cm
> iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi
> autofs4 btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq
> async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
> hid_generic usbhid hid amdkfd amd_iommu_v2 radeon crct10dif_pclmul
> crc32_pclmul i2c_algo_bit ghash_clmulni_intel ttm aesni_intel drm_kms_helper
> aes_x86_64 lrw gf128mul syscopyarea glue_helper sysfillrect ablk_helper
> sysimgblt cryptd fb_sys_fops psmouse e1000e isci ahci ptp drm libahci nvme
> libsas pps_core nvme_core scsi_transport_sas fjes jitterentropy_rng drbg
> ansi_cprng [last unloaded: mlx5_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.138833] CPU: 0 PID: 1445 Comm:
> kworker/0:29 Not tainted 4.8.2 #1
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.141298] Hardware name: Dell Inc.
> Precision T7600/0VHRW1, BIOS A12 09/29/2014
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.143795] Workqueue: ib_cm
> cm_work_handler [ib_cm]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.146279]  0000000000000086
> 00000000d356260a ffff8e0ac44478f8 ffffffffb93dfce3
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.148788]  0000000000000000
> 0000000000000000 ffff8e0ac4447938 ffffffffb907899b
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.151285]  00000096d356260a
> 0000000000000200 ffff8e0abb9b0000 ffff8e0cae2a6494
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.153789] Call Trace:
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.156253]  [<ffffffffb93dfce3>]
> dump_stack+0x63/0x90
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.158692]  [<ffffffffb907899b>]
> __warn+0xcb/0xf0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.161080]  [<ffffffffb9078acd>]
> warn_slowpath_null+0x1d/0x20
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.163444]  [<ffffffffb907e08b>]
> __local_bh_enable_ip+0x6b/0x80
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.165818]  [<ffffffffb975de6c>]
> ipv4_neigh_lookup+0xac/0x130
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.168184]  [<ffffffffc086c512>]
> addr_resolve_neigh+0xb2/0x2b0 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.170524]  [<ffffffffc086c91c>]
> addr_resolve+0x20c/0x280 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.172851]  [<ffffffffb93f5a2a>] ?
> find_next_zero_bit+0x1a/0x20
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.175142]  [<ffffffffb93e12f9>] ?
> idr_get_empty_slot+0x199/0x3b0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.177413]  [<ffffffffb91e855c>] ?
> kmem_cache_alloc_trace+0xdc/0x1a0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.179693]  [<ffffffffc086cc3c>]
> rdma_resolve_ip+0x18c/0x2c0 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.181975]  [<ffffffffc086c060>] ?
> rdma_addr_register_client+0x30/0x30 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.184272]  [<ffffffffc086d199>]
> rdma_addr_find_l2_eth_by_grh+0x139/0x240 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.186577]  [<ffffffffb902a77c>] ?
> __switch_to+0x2dc/0x700
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.188885]  [<ffffffffc086164d>]
> ib_init_ah_from_wc+0x19d/0x570 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.191212]  [<ffffffffb9034ec9>] ?
> sched_clock+0x9/0x10
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.193531]  [<ffffffffb90a8f3f>] ?
> sched_clock_cpu+0x8f/0xa0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.195846]  [<ffffffffb90a2cb4>] ?
> check_preempt_curr+0x54/0x90
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.198162]  [<ffffffffb90ac453>] ?
> update_curr+0xf3/0x180
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.200471]  [<ffffffffc0861a59>]
> ib_create_ah_from_wc+0x39/0x70 [ib_core]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.202794]  [<ffffffffc0672fc7>]
> cm_alloc_response_msg.isra.33+0x37/0xb0 [ib_cm]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.205134]  [<ffffffffc0677da5>]
> cm_work_handler+0x11d5/0x16f2 [ib_cm]
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.207476]  [<ffffffffb9092c4b>]
> process_one_work+0x16b/0x480
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.209815]  [<ffffffffb9092fab>]
> worker_thread+0x4b/0x500
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.212157]  [<ffffffffb9092f60>] ?
> process_one_work+0x480/0x480
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.214506]  [<ffffffffb9099158>]
> kthread+0xd8/0xf0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.216852]  [<ffffffffb9832e1f>]
> ret_from_fork+0x1f/0x40
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.219189]  [<ffffffffb9099080>] ?
> kthread_create_on_node+0x1a0/0x1a0
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.221540] ---[ end trace
> 40812fc5b7bae90e ]---
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.223991] mlx5_1:poll_soft_wc:647:(pid
> 3422): polled software generated completion on CQ 0x14
> Oct 20 08:13:15 fmslnx0 kernel: [ 2772.232114] nvmet: ctrl 1 stop keep-alive
>
>
> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme



-- 
Robert Randall | robert.r.randall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
