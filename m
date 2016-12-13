From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: [PATCH resend] IB/core: fix unmap_sg argument
Date: Tue, 13 Dec 2016 16:10:55 +0100 (CET)
Message-ID: <alpine.LFD.2.20.1612131609260.4914@schleppi>
References: <alpine.LFD.2.20.1612021439450.3570@schleppi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1612021439450.3570@schleppi>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,

using dapltest on s390 I ran into the following warning:

[   20.781709] mlx4_core 0000:00:00.0: DMA-API: device driver frees DMA sg list with different entry count [map count=2] [unmap count=1]
[   20.781760] ------------[ cut here ]------------
[   20.781767] WARNING: CPU: 4 PID: 1063 at lib/dma-debug.c:1141 check_unmap+0x658/0xa08
[   20.781769] Modules linked in: rdma_ucm ib_ucm ib_uverbs rdma_cm configfs ib_cm iw_cm [...]
[   20.781797] CPU: 4 PID: 1063 Comm: dapltest Tainted: G        W       4.9.0-rc7-00039-g43c4f67 #65
[   20.781799] Hardware name: IBM              2964 N96              704              (LPAR)
[   20.781801] task: 00000000dd8e4008 task.stack: 00000000f1448000
[   20.781803] Krnl PSW : 0404c00180000000 000000000060af08 (check_unmap+0x658/0xa08)
[   20.781806]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[   20.781809] Krnl GPRS: 0000000000000002 00000000dd8e4008 0000000000000079 0000000000a1d4f0
[   20.781811]            000000000060af04 0000000000000000 0000000000000001 0000000000000001
[   20.781813]            00000000f8e8e880 07000000008f2210 0000000001e47700 00000000f7a11298
[   20.781814]            00000000f144ba68 00000000008f21f8 000000000060af04 00000000f144b960
[   20.781822] Krnl Code: 000000000060aef8: c0200022fcc0	larl	%r2,a6a878
                          000000000060aefe: c0e5ffe474dd	brasl	%r14,2998b8
                         #000000000060af04: a7f40001		brc	15,60af06
                         >000000000060af08: c0200022f976	larl	%r2,a6a1f4
                          000000000060af0e: c0e5ffe474d5	brasl	%r14,2998b8
                          000000000060af14: 4120b050		la	%r2,80(%r11)
                          000000000060af18: a7390000		lghi	%r3,0
                          000000000060af1c: c0e5ffde780a	brasl	%r14,1d9f30
[   20.781847] Call Trace:
[   20.781848] ([<000000000060af04>] check_unmap+0x654/0xa08)
[   20.781851]  [<000000000060b6bc>] debug_dma_unmap_sg+0xf4/0x160 
[   20.781873]  [<000003ff82245738>] __ib_umem_release+0x98/0x1a8 [ib_core] 
[   20.781881]  [<000003ff82245f3e>] ib_umem_release+0x5e/0x1d0 [ib_core] 
[   20.781891]  [<000003ff80139976>] mlx4_ib_destroy_qp+0x47e/0x550 [mlx4_ib] 
[   20.781898]  [<000003ff8222ad2e>] ib_destroy_qp+0x116/0x188 [ib_core] 
[   20.781902]  [<000003ff80052fba>] ib_uverbs_destroy_qp+0xb2/0x1a0 [ib_uverbs] 
[   20.781905]  [<000003ff8004cada>] ib_uverbs_write+0x20a/0x488 [ib_uverbs] 
[   20.781910]  [<0000000000352756>] __vfs_write+0x36/0x138 
[   20.781912]  [<000000000035348c>] vfs_write+0xbc/0x1a0 
[   20.781914]  [<0000000000354a96>] SyS_write+0x66/0xc0 
[   20.781918]  [<000000000087d796>] system_call+0xd6/0x270 
[   20.781919] INFO: lockdep is turned off.
[   20.781921] Last Breaking-Event-Address:
[   20.781922]  [<000000000060af04>] check_unmap+0x654/0xa08
[   20.781924] ---[ end trace bd581c43b9bebeea ]---
[   20.781925] Mapped at:
[   20.781929] [<000000000060b4a6>] debug_dma_map_sg+0x5e/0x180
[   20.781938] [<000003ff82245d12>] ib_umem_get+0x4ca/0x610 [ib_core]
[   20.781943] [<000003ff80136df2>] create_qp_common.isra.15+0x572/0x1010 [mlx4_ib]
[   20.781949] [<000003ff8013929e>] mlx4_ib_create_qp+0x1de/0x438 [mlx4_ib]
[   20.781953] [<000003ff8004f52c>] create_qp.isra.11+0x44c/0x7f0 [ib_uverbs]

The following patch fixes this:

---->8
>From ec91646d8c14e2a8dd2b62187084dab32ef8a56b Mon Sep 17 00:00:00 2001
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Date: Fri, 2 Dec 2016 11:15:05 +0100
Subject: [PATCH] IB/core: fix unmap_sg argument

__ib_umem_release calls dma_unmap_sg with a different number of
sg_entries than ib_umem_get uses for dma_map_sg. This might cause
trouble for implementations that merge sglist entries and results
in the following dma debug complaint:

DMA-API: device driver frees DMA sg list with different entry
         count [map count=2] [unmap count=1]

Fix it by using the correct value.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/infiniband/core/umem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 84b4eff..1e62a5f 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -51,7 +51,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 
 	if (umem->nmap > 0)
 		ib_dma_unmap_sg(dev, umem->sg_head.sgl,
-				umem->nmap,
+				umem->npages,
 				DMA_BIDIRECTIONAL);
 
 	for_each_sg(umem->sg_head.sgl, sg, umem->npages, i) {
-- 
2.7.4
