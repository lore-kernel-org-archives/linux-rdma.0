From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Need some pointers to debug a KASAN splat in NVMe over Fabrics with
 rdma-rxe
Date: Wed, 8 Mar 2017 16:35:50 +0100
Message-ID: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux NVMe Mailinglist <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Moni et al.,

I'm getting a KASAN stack-out-of-bounds in rxe_post_send+0xdfe/0x1830
[rdma_rxe] at addr ffff8800187072e8 with v4.11-rc1

rxe_post_send+0xdfe is the following (note: the pr_err was inserted by
me to aid debugging).

(gdb) list *(rxe_post_send+0xdfe)
0x1dc3e is in rxe_post_send (drivers/infiniband/sw/rxe/rxe_verbs.c:765).
760             pr_err("%s: *_wr(ibwr): %p\n",
761                    __func__, (void *)(mask & WR_ATOMIC_MASK ?
atomic_wr(ibwr)
762                    : rdma_wr(ibwr)));
763
764             wqe->iova               = (mask & WR_ATOMIC_MASK) ?
765
atomic_wr(ibwr)->remote_addr :
766                                             rdma_wr(ibwr)->remote_addr;
767             wqe->mask               = mask;
768             wqe->dma.length         = length;
769             wqe->dma.resid          = length;

Coincidentially ffff8800187072e8 = ibwr + 0x28. ibwr comes from
nvme_rdma_post_send() and has an opcode of IB_WR_SEND (verified . So the
rdma_wr(ibwr) call cannot return a correct/valid parent object (neither
could the atomic_wr(ibr)).

So much for the easy/mechanic part.

I can special case IB_WR_SEND in rxe's init_send_wqe() but I neither
know if it is correct nor how the wqe elements (especially wqe->iova)
should be set up.

So any help would be appreciated here.

Thanks in advance,
	Johannes
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
