From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Need some pointers to debug a KASAN splat in NVMe over Fabrics
 with rdma-rxe
Date: Wed, 8 Mar 2017 17:11:29 +0100
Message-ID: <db58598f-6cd7-0e90-9a41-a7f26e5722e3@suse.de>
References: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux NVMe Mailinglist <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/08/2017 04:35 PM, Johannes Thumshirn wrote:
> Hi Moni et al.,
> 
> I'm getting a KASAN stack-out-of-bounds in rxe_post_send+0xdfe/0x1830
> [rdma_rxe] at addr ffff8800187072e8 with v4.11-rc1
> 
> rxe_post_send+0xdfe is the following (note: the pr_err was inserted by
> me to aid debugging).

Quick follow up to my last mail

Slamming in a:
@@ -753,9 +757,18 @@ static int init_send_wqe(struct rxe_qp *qp, struct
ib_send_wr *ibwr,
                memcpy(wqe->dma.sge, ibwr->sg_list,
                       num_sge * sizeof(struct ib_sge));

-       wqe->iova               = (mask & WR_ATOMIC_MASK) ?
-                                       atomic_wr(ibwr)->remote_addr :
-                                       rdma_wr(ibwr)->remote_addr;
+
+       if (ibwr->opcode == IB_WR_RDMA_WRITE ||
+           ibwr->opcode == IB_WR_RDMA_WRITE_WITH_IMM ||
+           ibwr->opcode == IB_WR_ATOMIC_CMP_AND_SWP ||
+           ibwr->opcode == IB_WR_ATOMIC_FETCH_AND_ADD)
+               wqe->iova = (mask & WR_ATOMIC_MASK) ?
+                       atomic_wr(ibwr)->remote_addr :
+                       rdma_wr(ibwr)->remote_addr;
+
        wqe->mask               = mask;
        wqe->dma.length         = length;
        wqe->dma.resid          = length;


Gives me
[    4.286632] rdma_rxe: qp#17 moved to error state
[ ...hang... ]
[   64.847464] nvme nvme0: Connect command failed, error wo/DNR bit: 7
[   64.859829]
==================================================================
[   64.861048] BUG: KASAN: stack-out-of-bounds in
rxe_post_send+0x12f3/0x1880 [rdma_rxe] at addr ffff88001f787838

Which translates to:
(gdb) list *(rxe_post_send+0x12f3)
0x1e133 is in rxe_post_send (drivers/infiniband/sw/rxe/rxe_verbs.c:685).
680                     switch (wr->opcode) {
681                     case IB_WR_RDMA_WRITE_WITH_IMM:
682                             wr->ex.imm_data = ibwr->ex.imm_data;
683                     case IB_WR_RDMA_READ:
684                     case IB_WR_RDMA_WRITE:
685                             wr->wr.rdma.remote_addr =
rdma_wr(ibwr)->remote_addr;
686                             wr->wr.rdma.rkey        =
rdma_wr(ibwr)->rkey;
687                             break;
688                     case IB_WR_SEND_WITH_IMM:
689                             wr->ex.imm_data = ibwr->ex.imm_data;


-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
