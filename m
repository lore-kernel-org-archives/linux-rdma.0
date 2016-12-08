From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/23] IB/hfi1: Use reference count wrapper for MRs
Date: Wed, 07 Dec 2016 19:33:53 -0800
Message-ID: <20161208033351.21135.25392.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some parts of the code don't use the standard driver
wrapper for memory region reference counters. Use the
standard driver wrapper throughout the code.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 562cf78..52fd152 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -793,7 +793,7 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		mr = rcu_dereference(dev->dma_mr);
 		if (!mr)
 			goto bail;
-		atomic_inc(&mr->refcount);
+		rvt_get_mr(mr);
 		rcu_read_unlock();
 
 		isge->mr = mr;
@@ -814,7 +814,7 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		     off + sge->length > mr->length ||
 		     (mr->access_flags & acc) != acc))
 		goto bail;
-	atomic_inc(&mr->refcount);
+	rvt_get_mr(mr);
 	rcu_read_unlock();
 
 	off += mr->offset;
@@ -892,7 +892,7 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		mr = rcu_dereference(rdi->dma_mr);
 		if (!mr)
 			goto bail;
-		atomic_inc(&mr->refcount);
+		rvt_get_mr(mr);
 		rcu_read_unlock();
 
 		sge->mr = mr;
@@ -913,7 +913,7 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
 		     (mr->access_flags & acc) == 0))
 		goto bail;
-	atomic_inc(&mr->refcount);
+	rvt_get_mr(mr);
 	rcu_read_unlock();
 
 	off += mr->offset;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
