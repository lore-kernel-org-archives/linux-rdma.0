From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Wed, 22 Feb 2017 11:52:41 -0500 (EST)
Message-ID: <1848296658.37025722.1487782361271.JavaMail.zimbra@redhat.com>
References: <08131a05-1f56-ef61-990a-7fff04eea095@gmail.com> <de1a559a-bf24-0d73-5fc7-148d6cd4d4e0@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <de1a559a-bf24-0d73-5fc7-148d6cd4d4e0-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Sagi Grimberg" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> To: "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Sent: Tuesday, February 21, 2017 5:50:39 PM
> Subject: Re: Unexpected issues with 2 NVME initiators using the same target
> 
> 
> > I am using 2 initiators + 1 target using nvmet with 1 subsystem and 4
> > backend
> > devices. Kernel is 4.9.6, NVME/rdma drivers are all from the vanilla
> > kernel, I
> > had a probelm connecting the NVME using the OFED drivers, so I removed
> > all the
> > mlx_compat and everything which depends on it.
> 
> Would it be possible to test with latest upstream kernel?
> 
> >
> > When I perform simultaneous writes (non direct fio) from both of the
> > initiators
> > to the same device (overlapping areas), I get NVMEf disconnect followed
> > by "dump
> > error cqe", successful reconnect, and then on one of the servers I get a
> > WARN_ON. After this the server gets stuck and I have to power cycle it
> > to get it
> > back up...
> 
> The error cqes seem to indicate that a memory registration operation
> failed which escalated to something worse.
> 
> I noticed some issues before with CX4 having problems with memory
> registration in the presence of network retransmissions (due to
> network congestion).
> 
> I notified Mellanox folks on that too, CC'ing Linux-rdma for some
> more attention.
> 
> After that, I see that ib_modify_qp failed which I've never seen
> before (might indicate the the device is in bad shape), and the WARN_ON
> is really weird given that nvme-rdma never uses IB_POLL_DIRECT.
> 
> > Here are the printouts from the server that got stuck:
> >
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204216]
> > mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204219] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204220] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204220] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204221] 00000000
> > 08007806 25000129 015557d0
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204234] nvme nvme0:
> > MEMREG for CQE 0xffff96ddd747a638 failed with status
> > memory management operation error (6)
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.204375] nvme nvme0:
> > reconnecting in 10 seconds
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.205512]
> > mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.205514] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.205515] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.205515] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:13 kblock01-knode02 kernel: [59976.205516] 00000000
> > 08007806 25000126 00692bd0
> > Feb  6 09:20:23 kblock01-knode02 kernel: [59986.452887] nvme nvme0:
> > Successfully reconnected
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.682887]
> > mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.682890] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.682891] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.682892] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.682892] 00000000
> > 08007806 25000158 04cdd7d0
> > ...
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.687737]
> > mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.687739] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.687740] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.687740] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:20:24 kblock01-knode02 kernel: [59986.687741] 00000000
> > 93005204 00000155 00a385e0
> > Feb  6 09:20:34 kblock01-knode02 kernel: [59997.389290] nvme nvme0:
> > Successfully reconnected
> > Feb  6 09:21:19 kblock01-knode02 rsyslogd: -- MARK --
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.927832]
> > mlx5_0:dump_cqe:262:(pid 0): dump error cqe
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.927835] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.927836] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.927837] 00000000
> > 00000000 00000000 00000000
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.927837] 00000000
> > 93005204 00000167 b44e76e0
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.927846] nvme nvme0: RECV
> > for CQE 0xffff96fe64f18750 failed with status local protection error (4)
> > Feb  6 09:21:38 kblock01-knode02 kernel: [60060.928200] nvme nvme0:
> > reconnecting in 10 seconds
> > ...
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736182] mlx5_core
> > 0000:04:00.0: wait_func:879:(pid 22709): 2ERR_QP(0x507) timeout. Will
> > cause a leak of a command resource
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736190] ------------[
> > cut here ]------------
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736211] WARNING: CPU: 18
> > PID: 22709 at drivers/infiniband/core/verbs.c:1963
> > __ib_drain_sq+0x135/0x1d0 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736212] failed to drain
> > send queue: -110
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736213] Modules linked
> > in: nvme_rdma rdma_cm ib_cm iw_cm nvme_fabrics nvme_core
> > ocs_fc_scst(POE) scst(OE) mptctl mptbase qla2xxx_scst(OE)
> > scsi_transport_fc dm_multipath drbd lru_cache netconsole mst_pciconf(OE)
> > nfsd nfs_acl auth_rpcgss ipmi_devintf lockd sunrpc grace ipt_MASQUERADE
> > nf_nat_masquerade_ipv4 xt_nat iptable_nat nf_nat_ipv4 nf_nat
> > nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack fuse binfmt_misc
> > iTCO_wdt iTCO_vendor_support pcspkr serio_raw joydev igb i2c_i801
> > i2c_smbus lpc_ich mei_me mei ioatdma dca ses enclosure ipmi_ssif ipmi_si
> > ipmi_msghandler bnx2x libcrc32c mdio mlx5_ib ib_core mlx5_core devlink
> > ptp pps_core tpm_tis tpm_tis_core tpm ext4(E) mbcache(E) jbd2(E) isci(E)
> > libsas(E) mpt3sas(E) scsi_transport_sas(E) raid_class(E) megaraid_sas(E)
> > wmi(E) mgag200(E) ttm(E) drm_kms_helper(E)
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736293]  drm(E)
> > i2c_algo_bit(E) [last unloaded: nvme_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736301] CPU: 18 PID:
> > 22709 Comm: kworker/18:4 Tainted: P           OE   4.9.6-KM1 #0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736303] Hardware name:
> > Supermicro SYS-1027R-72BRFTP5-EI007/X9DRW-7/iTPF, BIOS 3.0a 01/22/2014
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736312] Workqueue:
> > nvme_rdma_wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736315] ffff96de27e6f9b8
> > ffffffffb537f3ff ffffffffc06a00e5 ffff96de27e6fa18
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736320] ffff96de27e6fa18
> > 0000000000000000 ffff96de27e6fa08 ffffffffb5091a7d
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736324] 0000000300000000
> > 000007ab00000006 0507000000000000 ffff96de27e6fad8
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736328] Call Trace:
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736341]
> > [<ffffffffb537f3ff>] dump_stack+0x67/0x98
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736352]
> > [<ffffffffc06a00e5>] ? __ib_drain_sq+0x135/0x1d0 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736364]
> > [<ffffffffb5091a7d>] __warn+0xfd/0x120
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736368]
> > [<ffffffffb5091b59>] warn_slowpath_fmt+0x49/0x50
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736378]
> > [<ffffffffc069fdb5>] ? ib_modify_qp+0x45/0x50 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736388]
> > [<ffffffffc06a00e5>] __ib_drain_sq+0x135/0x1d0 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736398]
> > [<ffffffffc069f5a0>] ? ib_create_srq+0xa0/0xa0 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736408]
> > [<ffffffffc06a01a5>] ib_drain_sq+0x25/0x30 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736418]
> > [<ffffffffc06a01c6>] ib_drain_qp+0x16/0x40 [ib_core]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736422]
> > [<ffffffffc0c4d25b>] nvme_rdma_stop_and_free_queue+0x2b/0x50 [nvme_rdma]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736426]
> > [<ffffffffc0c4d2ad>] nvme_rdma_free_io_queues+0x2d/0x40 [nvme_rdma]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736429]
> > [<ffffffffc0c4d884>] nvme_rdma_reconnect_ctrl_work+0x34/0x1e0 [nvme_rdma]
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736434]
> > [<ffffffffb50ac7ce>] process_one_work+0x17e/0x4f0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736444]
> > [<ffffffffb50cefc5>] ? dequeue_task_fair+0x85/0x870
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736454]
> > [<ffffffffb5799c6a>] ? schedule+0x3a/0xa0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736456]
> > [<ffffffffb50ad653>] worker_thread+0x153/0x660
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736464]
> > [<ffffffffb5026b4c>] ? __switch_to+0x1dc/0x670
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736468]
> > [<ffffffffb5799706>] ? __schedule+0x226/0x6a0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736471]
> > [<ffffffffb50be7c2>] ? default_wake_function+0x12/0x20
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736474]
> > [<ffffffffb50d7636>] ? __wake_up_common+0x56/0x90
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736477]
> > [<ffffffffb50ad500>] ? workqueue_prepare_cpu+0x80/0x80
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736480]
> > [<ffffffffb5799c6a>] ? schedule+0x3a/0xa0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736483]
> > [<ffffffffb50ad500>] ? workqueue_prepare_cpu+0x80/0x80
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736487]
> > [<ffffffffb50b237d>] kthread+0xcd/0xf0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736492]
> > [<ffffffffb50bc40e>] ? schedule_tail+0x1e/0xc0
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736495]
> > [<ffffffffb50b22b0>] ? __kthread_init_worker+0x40/0x40
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736499]
> > [<ffffffffb579ded5>] ret_from_fork+0x25/0x30
> > Feb  6 09:23:54 kblock01-knode02 kernel: [60196.736502] ---[ end trace
> > eb0e5ba7dc81a687 ]---
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176054] mlx5_core
> > 0000:04:00.0: wait_func:879:(pid 22709): 2ERR_QP(0x507) timeout. Will
> > cause a leak of a command resource
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176059] ------------[
> > cut here ]------------
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176073] WARNING: CPU: 18
> > PID: 22709 at drivers/infiniband/core/verbs.c:1998
> > __ib_drain_rq+0x12a/0x1c0 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176075] failed to drain
> > recv queue: -110
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176076] Modules linked
> > in: nvme_rdma rdma_cm ib_cm iw_cm nvme_fabrics nvme_core
> > ocs_fc_scst(POE) scst(OE) mptctl mptbase qla2xxx_scst(OE)
> > scsi_transport_fc dm_multipath drbd lru_cache netconsole mst_pciconf(OE)
> > nfsd nfs_acl auth_rpcgss ipmi_devintf lockd sunrpc grace ipt_MASQUERADE
> > nf_nat_masquerade_ipv4 xt_nat iptable_nat nf_nat_ipv4 nf_nat
> > nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack fuse binfmt_misc
> > iTCO_wdt iTCO_vendor_support pcspkr serio_raw joydev igb i2c_i801
> > i2c_smbus lpc_ich mei_me mei ioatdma dca ses enclosure ipmi_ssif ipmi_si
> > ipmi_msghandler bnx2x libcrc32c mdio mlx5_ib ib_core mlx5_core devlink
> > ptp pps_core tpm_tis tpm_tis_core tpm ext4(E) mbcache(E) jbd2(E) isci(E)
> > libsas(E) mpt3sas(E) scsi_transport_sas(E) raid_class(E) megaraid_sas(E)
> > wmi(E) mgag200(E) ttm(E) drm_kms_helper(E)
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176134]  drm(E)
> > i2c_algo_bit(E) [last unloaded: nvme_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176140] CPU: 18 PID:
> > 22709 Comm: kworker/18:4 Tainted: P        W  OE   4.9.6-KM1 #0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176141] Hardware name:
> > Supermicro SYS-1027R-72BRFTP5-EI007/X9DRW-7/iTPF, BIOS 3.0a 01/22/2014
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176147] Workqueue:
> > nvme_rdma_wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176150] ffff96de27e6f9b8
> > ffffffffb537f3ff ffffffffc069feea ffff96de27e6fa18
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176155] ffff96de27e6fa18
> > 0000000000000000 ffff96de27e6fa08 ffffffffb5091a7d
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176159] 0000000300000000
> > 000007ce00000006 0507000000000000 ffff96de27e6fad8
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176163] Call Trace:
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176169]
> > [<ffffffffb537f3ff>] dump_stack+0x67/0x98
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176180]
> > [<ffffffffc069feea>] ? __ib_drain_rq+0x12a/0x1c0 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176185]
> > [<ffffffffb5091a7d>] __warn+0xfd/0x120
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176189]
> > [<ffffffffb5091b59>] warn_slowpath_fmt+0x49/0x50
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176199]
> > [<ffffffffc069fdb5>] ? ib_modify_qp+0x45/0x50 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176216]
> > [<ffffffffc06de770>] ? mlx5_ib_modify_qp+0x980/0xec0 [mlx5_ib]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176225]
> > [<ffffffffc069feea>] __ib_drain_rq+0x12a/0x1c0 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176235]
> > [<ffffffffc069f5a0>] ? ib_create_srq+0xa0/0xa0 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176246]
> > [<ffffffffc069ffa5>] ib_drain_rq+0x25/0x30 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176255]
> > [<ffffffffc06a01dc>] ib_drain_qp+0x2c/0x40 [ib_core]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176259]
> > [<ffffffffc0c4d25b>] nvme_rdma_stop_and_free_queue+0x2b/0x50 [nvme_rdma]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176263]
> > [<ffffffffc0c4d2ad>] nvme_rdma_free_io_queues+0x2d/0x40 [nvme_rdma]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176267]
> > [<ffffffffc0c4d884>] nvme_rdma_reconnect_ctrl_work+0x34/0x1e0 [nvme_rdma]
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176270]
> > [<ffffffffb50ac7ce>] process_one_work+0x17e/0x4f0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176275]
> > [<ffffffffb50cefc5>] ? dequeue_task_fair+0x85/0x870
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176278]
> > [<ffffffffb5799c6a>] ? schedule+0x3a/0xa0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176281]
> > [<ffffffffb50ad653>] worker_thread+0x153/0x660
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176285]
> > [<ffffffffb5026b4c>] ? __switch_to+0x1dc/0x670
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176289]
> > [<ffffffffb5799706>] ? __schedule+0x226/0x6a0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176291]
> > [<ffffffffb50be7c2>] ? default_wake_function+0x12/0x20
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176294]
> > [<ffffffffb50d7636>] ? __wake_up_common+0x56/0x90
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176297]
> > [<ffffffffb50ad500>] ? workqueue_prepare_cpu+0x80/0x80
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176300]
> > [<ffffffffb5799c6a>] ? schedule+0x3a/0xa0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176302]
> > [<ffffffffb50ad500>] ? workqueue_prepare_cpu+0x80/0x80
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176306]
> > [<ffffffffb50b237d>] kthread+0xcd/0xf0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176310]
> > [<ffffffffb50bc40e>] ? schedule_tail+0x1e/0xc0
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176313]
> > [<ffffffffb50b22b0>] ? __kthread_init_worker+0x40/0x40
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176316]
> > [<ffffffffb579ded5>] ret_from_fork+0x25/0x30
> > Feb  6 09:24:55 kblock01-knode02 kernel: [60258.176318] ---[ end trace
> > eb0e5ba7dc81a688 ]---
> > Feb  6 09:25:26 kblock01-knode02 udevd[9344]: worker [21322]
> > unexpectedly returned with status 0x0100
> > Feb  6 09:25:26 kblock01-knode02 udevd[9344]: worker [21322] failed
> > while handling '/devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n1'
> > Feb  6 09:25:26 kblock01-knode02 udevd[9344]: worker [21323]
> > unexpectedly returned with status 0x0100
> > Feb  6 09:25:26 kblock01-knode02 udevd[9344]: worker [21323] failed
> > while handling '/devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n2'
> > Feb  6 09:25:26 kblock01-knode02 udevd[9344]: worker [21741]
> > unexpectedly returned with status 0x0100
> > Feb  6 09:25:26 kblock01-knode02 udevd[9344]: worker [21741] failed
> > while handling '/devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n3'
> > Feb  6 09:25:57 kblock01-knode02 kernel: [60319.615916] mlx5_core
> > 0000:04:00.0: wait_func:879:(pid 22709): 2RST_QP(0x50a) timeout. Will
> > cause a leak of a command resource
> > Feb  6 09:25:57 kblock01-knode02 kernel: [60319.615922]
> > mlx5_0:destroy_qp_common:1936:(pid 22709): mlx5_ib: modify QP 0x00015e
> > to RESET failed
> > Feb  6 09:26:19 kblock01-knode02 udevd[9344]: worker [21740]
> > unexpectedly returned with status 0x0100
> > Feb  6 09:26:19 kblock01-knode02 udevd[9344]: worker [21740] failed
> > while handling '/devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n4'
> >
> >
> > _______________________________________________
> > Linux-nvme mailing list
> > Linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > http://lists.infradead.org/mailman/listinfo/linux-nvme
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Sagi,

Have not looked in depth here but is this maybe the GAPS issue again I bumped into where we had to revert the patch for the SRP transport.
Would we have to do a similar revert in the NVME space or modify mlx5 where this issue exists.

Thanks
Laurnce



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
