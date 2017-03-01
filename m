From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Poll CQ syncing problem
Date: Wed, 1 Mar 2017 16:30:26 +0200
Message-ID: <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b4355d22-fc79-c860-de8a-5a4d468c884d-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Christoph, Sagi

I’ve been debugging an issue here and seems like it was exposed by
the work you did in the following commit:
14d3a3b2498ed (‘IB: add a proper completion queue abstraction’).

The scenario we run is randomizing pkeys for an IPoIB interface and then
running traffic on all of them.

We get the following panic trace (this one is PPC):

Unable to handle kernel paging request for data at address 0x00200200
Faulting instruction address: 0xc000000000325620
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: rdma_ucm(U) ib_ucm(U) rdma_cm(U) iw_cm(U) ib_ipoib(U)
ib_cm(U) ib_uverbs(U) ib_umad(U) mlx5_ib(U) mlx5_core(U) mlx4_en(U) mlx4_ib(U)
ib_core(U) mlx4_core(U) mlx_compat(U) memtrack(U) mst_pciconf(U) netconsole 
nfs fscache nfsd lockd exportfs auth_rpcgss nfs_acl sunrpc autofs4 configfs
ses enclosure sg ipv6 tg3 e1000e ptp pps_core shpchp ext4 jbd2 mbcache sd_mod
crc_t10dif sr_mod cdrom ipr dm_mirror dm_region_hash dm_log dm_mod
[last unloaded: memtrack]
NIP: c000000000325620 LR: d000000003d46840 CTR: c000000000325600
REGS: c0000001ce7077e0 TRAP: 0300   Not tainted  (2.6.32-642.el6.ppc64)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24004082  XER: 00000000
DAR: 0000000000200200, DSISR: 0000000040000000
TASK = c0000001cca8e5c0[10314] 'ib-comp-wq/8' THREAD: c0000001ce704000 CPU: 8
GPR00: d000000003d46840 c0000001ce707a60 c000000000f9f3b0 c0000001b7989780 
GPR04: c0000001b706e200 c0000001d40b0b40 00000001001900b2 0000000000000000 
GPR08: d00007ffffe10401 0000000000200200 c000000001082500 c000000000325600 
GPR12: d000000003d4eba8 c000000001083900 00000000019ffa50 0000000000223718 
GPR16: 00000000002237c0 00000000002237b4 c0000001cca8e5c0 c0000001b6d626c0 
GPR20: c0000001b7989780 c000000000ee0380 d00007fffff0fb98 c0000001ce707e20 
GPR24: 0000000000000003 c0000001b0033408 c0000001b0032b00 0000000000000001 
GPR28: c0000001b706e200 c0000001b0033440 c000000000f39c38 c0000001b7989780 
NIP [c000000000325620] .list_del+0x20/0xb0
LR [d000000003d46840] .ib_mad_recv_done+0xc0/0x10e0 [ib_core]
Call Trace:
[c0000001ce707a60] [c0000001ce707b30] 0xc0000001ce707b30 (unreliable)
[c0000001ce707ae0] [d000000003d46840] .ib_mad_recv_done+0xc0/0x10e0 [ib_core]
[c0000001ce707c70] [d000000003d244bc] .__ib_process_cq+0xbc/0x190 [ib_core]
[c0000001ce707d20] [d000000003d24b70] .ib_cq_poll_work+0x30/0xb0 [ib_core]
[c0000001ce707db0] [c0000000000ba74c] .worker_thread+0x1dc/0x3d0
[c0000001ce707ed0] [c0000000000c1c6c] .kthread+0xdc/0x110
[c0000001ce707f90] [c000000000033c34] .kernel_thread+0x54/0x70

Analysis:
Since ib_comp_wq isn't single threaded, two works can run in parallel for the same CQ,
executing __ib_process_cq.
Since this function isn't thread safe and the wc array is shared, it causes a data corruption
which eventually crashes in the MAD layer due to a double list_del of the same element.

We have the following options to solve this:
1. Instead of cq->wc, allocate an ib_wc array in __ib_process_cq per each call.
2. Make ib_comp_wq a single thread workqueue.
3. Change the locking scheme during poll: Currently only the device's poll_cq implementation
   is done under lock. Change it to also contan the callbacks.

I'd appreciate your insight.

Thanks,
Noa

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
