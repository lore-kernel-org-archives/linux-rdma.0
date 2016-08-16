From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] IB/rdmvat: Fix double vfree() in rvt_create_qp() error
 path
Date: Tue, 16 Aug 2016 13:26:29 -0700
Message-ID: <20160816202617.24004.35474.stgit@scvm10.sc.intel.com>
References: <20160816202133.24004.31487.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160816202133.24004.31487.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The unwind logic for creating a user QP has a double vfree
of the non-shared receive queue when handling a "too many qps"
failure.

The code unwinds the mmmap info by decrementing a reference
count which will call rvt_release_mmap_info() which in turn
does the vfree() of the r_rq.wq.  The unwind code then does
the same free.

Fix by guarding the vfree() with the same test that is done
in close and only do the vfree() if qp->ip is NULL.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index bdb540f..870b4f2 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -873,7 +873,8 @@ bail_qpn:
 	free_qpn(&rdi->qp_dev->qpn_table, qp->ibqp.qp_num);
 
 bail_rq_wq:
-	vfree(qp->r_rq.wq);
+	if (!qp->ip)
+		vfree(qp->r_rq.wq);
 
 bail_driver_priv:
 	rdi->driver_f.qp_priv_free(rdi, qp);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
