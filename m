From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH RFC] iw_cxgb4: drop check - dead code
Date: Wed, 23 Jan 2019 14:44:15 -0700
Message-ID: <20190123214415.GA20648@ziepe.ca>
References: <1547947633-10515-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547947633-10515-1-git-send-email-hofrat@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Raju Rangoju <rajur@chelsio.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 20, 2019 at 02:27:13AM +0100, Nicholas Mc Guire wrote:
> The kmalloc is called with  | __GFP_NOFAIL  so there is no point in
> checking the return value - it either returns valid storage or it would
> hang/terminate there. But it is not possible to say if the use of
> __GFP_NOFAIL is really needed and the check should be removed or
> vice-versa (use of __GFP_NOFAIL should be only in exceptional
> cases as I understand it and alloc_srq_queue() is called in quite
> a few places)
> In either way it would need fixing.
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> Fixes: 6a0b6174d35a ("rdma/cxgb4: Add support for kernel mode SRQ's")
> ---

As per steve's remarkes I revised this to the below and applied it to
for-next

>From 4b2d4262ee2ea58df867de1928bf208795344432 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@mellanox.com>
Date: Sun, 20 Jan 2019 02:27:13 +0100
Subject: [PATCH] RDMA/iw_cxgb4: Drop __GFP_NOFAIL

There is no reason for this __GFP_NOFAIL, none of the other routines in
this file use it, and there is an error unwind here. NOFAIL should be
reserved for special cases, not used by network drivers.

Fixes: 6a0b6174d35a ("rdma/cxgb4: Add support for kernel mode SRQ's")
Reported-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/cxgb4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 03f4c66c265946..c00a4114412694 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -2597,7 +2597,7 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
 	/* build fw_ri_res_wr */
 	wr_len = sizeof(*res_wr) + sizeof(*res);
 
-	skb = alloc_skb(wr_len, GFP_KERNEL | __GFP_NOFAIL);
+	skb = alloc_skb(wr_len, GFP_KERNEL);
 	if (!skb)
 		goto err_free_queue;
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, 0);
-- 
2.20.1
