From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Thu, 23 Feb 2012 14:23:50 -0600
Message-ID: <4F46A056.5090005@opengridcomputing.com>
References: <20120222214307.23921.83903.stgit@build.ogc.int> <CAL1RGDV7ZoKWgbh+ERF+af3_B7K2USAkXSPKWeQEg5atpHY0og@mail.gmail.com> <4F465A46.3060301@opengridcomputing.com> <4F4699A1.7030402@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4699A1.7030402-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>
> Hrm.  I just hit this after more testing.  Debugging now.  Just hold of on this patch until I root cause this.
>
>
> Unable to handle kernel paging request at 0000000000200200 RIP:
>  [<0000000000200200>]
> PGD 183c984067 PUD 0
> Oops: 0010 [1] SMP
> last sysfs file: /class/infiniband/cxgb4_0/node_guid
> CPU 10
> Modules linked in: nfs fscache nfs_acl cxgb3(U) iw_cxgb4(U) kretprobes(U) autofs4 hidp rfcomm l2cap bluetooth lockd 
> sunrpc be2iscsi iscsi_tcp bnx2i cnic uio libiscsi_tcp libiscsi2 scsi_transport_iscsi2 scsi_transport_iscsi rdma_ucm(U) 
> ib_sdp(U) rdma_cm(U) iw_cm(U) ib_addr(U) ib_ipoib(U) ipoib_helper(U) ib_cm(U) ib_sa(U) ipv6 xfrm_nalgo crypto_api 
> ib_uverbs(U) ib_umad(U) iw_nes(U) ib_qib(U) dca mlx4_ib(U) mlx4_en(U) mlx4_core(U) ib_mthca(U) ib_mad(U) ib_core(U) 
> dm_mirror dm_multipath scsi_dh video backlight sbs power_meter hwmon i2c_ec dell_wmi wmi button battery asus_acpi 
> acpi_memhotplug ac parport_pc lp parport joydev cxgb4(U) tpm_tis tpm e1000e tpm_bios sr_mod shpchp i7core_edac edac_mc 
> cdrom i2c_i801 i2c_core serio_raw 8021q sg pcspkr dm_raid45 dm_message dm_region_hash dm_log dm_mod dm_mem_cache ahci 
> libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
> Pid: 5708, comm: iw_cm_wq Tainted: G      2.6.18-238.el5 #1
> RIP: 0010:[<0000000000200200>]  [<0000000000200200>]
> RSP: 0018:ffff81183e0cfcf8  EFLAGS: 00010097
> RAX: ffff810c3cf3ca58 RBX: 0c30100000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff81012aad6a58
> RBP: ffff81183e0cfd30 R08: ffff81012aad6a70 R09: 0000000000000282
> R10: 0000000000000000 R11: 0000000000000280 R12: 0000000000000000
> R13: 0000000000003c15 R14: ffff810c3cf3ca50 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff810c6a3c42c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000200200 CR3: 0000000c3d5a4000 CR4: 00000000000006e0
> Process iw_cm_wq (pid: 5708, threadinfo ffff81183e0ce000, task ffff810c3ea79080)
> Stack:  ffffffff8008c846 0000000300000000 ffff810c3cf3ca50 0000000000000000
>  0000000000000000 0000000000000282 0000000000000003 ffff81183e0cfd70
>  ffffffff8002e261 0000000000000000 ffff810c3cf3c9c0 ffff810c3cf3c900
> Call Trace:
>  [<ffffffff8008c846>] __wake_up_common+0x3e/0x68
>  [<ffffffff8002e261>] __wake_up+0x38/0x4f
>  [<ffffffff8867410b>] :iw_cm:iw_cm_reject+0x5a/0xa7
>  [<ffffffff88674baa>] :iw_cm:cm_work_handler+0x15e/0x424
>  [<ffffffff88674a4c>] :iw_cm:cm_work_handler+0x0/0x424
>  [<ffffffff8004d7ae>] run_workqueue+0x99/0xf6
>  [<ffffffff80049ff6>] worker_thread+0x0/0x122
>  [<ffffffff800a269c>] keventd_create_kthread+0x0/0xc4
>  [<ffffffff8004a0e6>] worker_thread+0xf0/0x122
>  [<ffffffff8008e40a>] default_wake_function+0x0/0xe
>  [<ffffffff800a269c>] keventd_create_kthread+0x0/0xc4
>  [<ffffffff80032974>] kthread+0xfe/0x132
>  [<ffffffff8005dfb1>] child_rip+0xa/0x11
>  [<ffffffff800a269c>] keventd_create_kthread+0x0/0xc4
>  [<ffffffff80032876>] kthread+0x0/0x132
>  [<ffffffff8005dfa7>] child_rip+0x0/0x11
>
>


Strange.  From my analysis, cm_work_handler + 0x15e points to cm_conn_req_handler() in the block where 
alloc_work_entries() returns non zero:

         cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
         cm_id_priv->state = IW_CM_STATE_CONN_RECV;

         ret = alloc_work_entries(cm_id_priv, 3);
         if (ret) {
                 iw_cm_reject(cm_id, NULL, 0);
                 iw_destroy_cm_id(cm_id);
                 goto out;
         }


So its calling iw_cm_reject() in the block above having just set the state to CONN_RECV.

Now, iw_cm_reject + 0x5a points to this code in iw_cm_reject():

         if (cm_id_priv->state != IW_CM_STATE_CONN_RECV) {
                 spin_unlock_irqrestore(&cm_id_priv->lock, flags);
                 clear_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags);
                 wake_up_all(&cm_id_priv->connect_wait);
                 return -EINVAL;
         }


Since the state isn't CONN_RECV, yet the previous stack frame set the state to this, then I can only assume some other 
thread is whacking the cm_id concurrently.




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
