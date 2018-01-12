From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-next 2/5] i40iw: Zero-out consumer key on allocate stag for FMR
Date: Thu, 11 Jan 2018 18:10:51 -0600
Message-ID: <20180112001054.15572-3-shiraz.saleem@intel.com>
References: <20180112001054.15572-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112001054.15572-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the application invalidates the MR before the FMR WR,
HW parses the consumer key portion of the stag and returns
an invalid stag key Asynchronous Event (AE) that tears down the QP.

Fix this by zeroing-out the consumer key portion of the
allocated stag returned to application for FMR.

Fixes: ee855d3b93f3 ("RDMA/i40iw: Add base memory management extensions")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 3c6f3ce..9f18997 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1637,6 +1637,7 @@ static struct ib_mr *i40iw_alloc_mr(struct ib_pd *pd,
 		err_code = -EOVERFLOW;
 		goto err;
 	}
+	stag &= ~I40IW_CQPSQ_STAG_KEY_MASK;
 	iwmr->stag = stag;
 	iwmr->ibmr.rkey = stag;
 	iwmr->ibmr.lkey = stag;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
