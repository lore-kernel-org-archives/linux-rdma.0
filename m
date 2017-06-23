From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] i40iw: Free QP resources on CQP destroy QP failure
Date: Fri, 23 Jun 2017 16:03:59 -0500
Message-ID: <20170623210402.19988-6-henry.orosco@intel.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Current flow leaves software QP structures in memory if
Control Queue Pair (CQP) destroy QP OP fails. To fix this,
free QP resources on fail of CQP destroy QP OP.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_utils.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 56d9869..ded8e48 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -546,8 +546,12 @@ void i40iw_rem_ref(struct ib_qp *ibqp)
 	cqp_info->in.u.qp_destroy.scratch = (uintptr_t)cqp_request;
 	cqp_info->in.u.qp_destroy.remove_hash_idx = true;
 	status = i40iw_handle_cqp_op(iwdev, cqp_request);
-	if (status)
-		i40iw_pr_err("CQP-OP Destroy QP fail");
+	if (!status)
+		return;
+
+	i40iw_rem_pdusecount(iwqp->iwpd, iwdev);
+	i40iw_free_qp_resources(iwdev, iwqp, qp_num);
+	i40iw_rem_devusecount(iwdev);
 }
 
 /**
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
