From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 28/28] IB/qib, IB/hfi1: Fix grh creation in ud loopback
Date: Mon, 25 Jul 2016 13:40:40 -0700
Message-ID: <20160725204039.4800.65181.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Instead of copying the actual GRH of type struct ib_grh, existing code
copies the struct ib_global_route into the sge. This patch fixes that
and constructs the actual GRH from ib_global_route and copies the GRH
into the sge.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/ud.c    |    8 ++++++--
 drivers/infiniband/hw/qib/qib_ud.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 852c20f..f01e8e1 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -184,8 +184,12 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	}
 
 	if (ah_attr->ah_flags & IB_AH_GRH) {
-		hfi1_copy_sge(&qp->r_sge, &ah_attr->grh,
-			      sizeof(struct ib_grh), 1, 0);
+		struct ib_grh grh;
+		struct ib_global_route grd = ah_attr->grh;
+
+		hfi1_make_grh(ibp, &grh, &grd, 0, 0);
+		hfi1_copy_sge(&qp->r_sge, &grh,
+			      sizeof(grh), 1, 0);
 		wc.wc_flags |= IB_WC_GRH;
 	} else {
 		hfi1_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 846e6c7..10d0625 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -169,8 +169,12 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	}
 
 	if (ah_attr->ah_flags & IB_AH_GRH) {
-		qib_copy_sge(&qp->r_sge, &ah_attr->grh,
-			     sizeof(struct ib_grh), 1);
+		struct ib_grh grh;
+		struct ib_global_route grd = ah_attr->grh;
+
+		qib_make_grh(ibp, &grh, &grd, 0, 0);
+		qib_copy_sge(&qp->r_sge, &grh,
+			     sizeof(grh), 1);
 		wc.wc_flags |= IB_WC_GRH;
 	} else
 		qib_skip_sge(&qp->r_sge, sizeof(struct ib_grh), 1);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
