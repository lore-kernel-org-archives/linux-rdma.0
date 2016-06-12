From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Sun, 12 Jun 2016 18:40:27 -0400 (EDT)
Message-ID: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com>
References: <1217453008.41876448.1465770498545.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1217453008.41876448.1465770498545.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello

Phase 2 of the testing for EDR100 and IB/srp means testing multipath fail-over and recovery during controller reboots.
Running 40 parallel tasks to 40 mpath devices will consistently land up in a stack dump when calling swiotlb_alloc_coherent, during reconnect attempts waiting for the controller to return.

Most of the time the system will recover paths when the controller returns but will flood the logs during the reconnects.

I am wondering we should disable this as its supposed to be a warning so looking for opinions here.

Notes
-----
This is initiated from mlx5_core

The dump stack seems to have been pulled in with this commit - e2172d8fd500a51a3845bc2294cdf4feaa388dab

Specifically 
  swiotlb: Warn on allocation failure in swiotlb_alloc_coherent()

From: Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>

Print a warning when all allocation tries have been failed
and the function is about to return NULL. This prepares for
calling the function with __GFP_NOWARN to suppress
allocation failure warnings before all fall-backs have
failed.

Looking at the code here:

We call __get_free_pages(flags, order) and we cannot DMA to the ConnectX-4 and we land up in 

err_warn:
        pr_warn("swiotlb: coherent allocation failed for device %s size=%zu\n",
                dev_name(hwdev), size);
        dump_stack();

        return NULL;
}




Jun  8 10:12:52 jumpclient kernel: device-mapper: multipath: Failing path 68:240.
Jun  8 10:12:52 jumpclient kernel: device-mapper: multipath: Failing path 69:16.
Jun  8 10:12:52 jumpclient kernel: device-mapper: multipath: Failing path 68:160.
Jun  8 10:12:52 jumpclient kernel: device-mapper: multipath: Failing path 68:224.
Jun  8 10:12:52 jumpclient kernel: mlx5_core 0000:08:00.1: swiotlb buffer is full (sz: 266240 bytes)
Jun  8 10:12:52 jumpclient kernel: swiotlb: coherent allocation failed for device 0000:08:00.1 size=266240
Jun  8 10:12:52 jumpclient kernel: CPU: 4 PID: 22125 Comm: kworker/4:1 Tainted: G          I     4.7.0-rc1.bart+ #1
Jun  8 10:12:52 jumpclient kernel: Hardware name: HP ProLiant DL380 G7, BIOS P67 08/16/2015
Jun  8 10:12:52 jumpclient kernel: Workqueue: events_long srp_reconnect_work [scsi_transport_srp]
Jun  8 10:12:52 jumpclient kernel: 0000000000000286 000000009fe8136d ffff8801027ffa10 ffffffff8134514f
Jun  8 10:12:52 jumpclient kernel: 0000000000041000 ffff88060ba1f0a0 ffff8801027ffa50 ffffffff8136eab9
Jun  8 10:12:52 jumpclient kernel: ffffffff00000007 00000000024082c0 ffff88060ba1f0a0 0000000000041000
Jun  8 10:12:52 jumpclient kernel: Call Trace:
Jun  8 10:12:52 jumpclient kernel: [<ffffffff8134514f>] dump_stack+0x63/0x84
Jun  8 10:12:52 jumpclient kernel: [<ffffffff8136eab9>] swiotlb_alloc_coherent+0x149/0x160
Jun  8 10:12:52 jumpclient kernel: [<ffffffff810655e3>] x86_swiotlb_alloc_coherent+0x43/0x50
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa01e5874>] mlx5_dma_zalloc_coherent_node+0xa4/0x100 [mlx5_core]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa01e5bdd>] mlx5_buf_alloc_node+0x4d/0xc0 [mlx5_core]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa01e5c64>] mlx5_buf_alloc+0x14/0x20 [mlx5_core]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0187db5>] create_kernel_qp.isra.46+0x285/0x7a0 [mlx5_ib]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa018934b>] ? mlx5_ib_create_qp+0xdb/0x490 [mlx5_ib]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0188ede>] create_qp_common+0xc0e/0xdc0 [mlx5_ib]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa018934b>] ? mlx5_ib_create_qp+0xdb/0x490 [mlx5_ib]
Jun  8 10:12:52 jumpclient kernel: [<ffffffff811f32a8>] ? kmem_cache_alloc_trace+0x1f8/0x210
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0189373>] mlx5_ib_create_qp+0x103/0x490 [mlx5_ib]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0425cf9>] ? ib_alloc_cq+0x89/0x160 [ib_core]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0425cf9>] ? ib_alloc_cq+0x89/0x160 [ib_core]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa042583f>] ib_create_qp+0x3f/0x240 [ib_core]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa06650e3>] srp_create_ch_ib+0x133/0x530 [ib_srp]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0662833>] ? srp_finish_req+0x93/0xb0 [ib_srp]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa06669aa>] srp_rport_reconnect+0xea/0x1d0 [ib_srp]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa06272a3>] srp_reconnect_rport+0xc3/0x230 [scsi_transport_srp]
Jun  8 10:12:52 jumpclient kernel: [<ffffffffa0627454>] srp_reconnect_work+0x44/0xd4 [scsi_transport_srp]
Jun  8 10:12:52 jumpclient kernel: [<ffffffff810a2e82>] process_one_work+0x152/0x400
Jun  8 10:12:52 jumpclient kernel: [<ffffffff810a3775>] worker_thread+0x125/0x4b0
Jun  8 10:12:52 jumpclient kernel: [<ffffffff810a3650>] ? rescuer_thread+0x380/0x380
Jun  8 10:12:52 jumpclient kernel: [<ffffffff810a92b8>] kthread+0xd8/0xf0
Jun  8 10:12:52 jumpclient kernel: [<ffffffff816c43bf>] ret_from_fork+0x1f/0x40
Jun  8 10:12:52 jumpclient kernel: [<ffffffff810a91e0>] ? kthread_park+0x60/0x60
Jun  8 10:12:52 jumpclient kernel: scsi host2: reconnect attempt 2 failed (-12)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
