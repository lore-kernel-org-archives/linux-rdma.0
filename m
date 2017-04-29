From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 13/18] IB/mthca: Rename to_ib_ah_attr to to_rdma_ah_attr
Date: Sat, 29 Apr 2017 14:41:25 -0400
Message-ID: <1493491290-31621-14-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

local function  to_ib_ah_attr is renamed so it in
sync with the rename of the ib_ah_attr structure

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_qp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index e0b8e43..baf65fe 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -393,9 +393,9 @@ static int to_ib_qp_access_flags(int mthca_flags)
 	return ib_flags;
 }
 
-static void to_ib_ah_attr(struct mthca_dev *dev,
-			  struct rdma_ah_attr *ib_ah_attr,
-			  struct mthca_qp_path *path)
+static void to_rdma_ah_attr(struct mthca_dev *dev,
+			    struct rdma_ah_attr *ib_ah_attr,
+			    struct mthca_qp_path *path)
 {
 	memset(ib_ah_attr, 0, sizeof *ib_ah_attr);
 	ib_ah_attr->port_num 	  = (be32_to_cpu(path->port_pkey) >> 24) & 0x3;
@@ -469,8 +469,8 @@ int mthca_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_m
 		to_ib_qp_access_flags(be32_to_cpu(context->params2));
 
 	if (qp->transport == RC || qp->transport == UC) {
-		to_ib_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
-		to_ib_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
+		to_rdma_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
+		to_rdma_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
 		qp_attr->alt_pkey_index =
 			be32_to_cpu(context->alt_path.port_pkey) & 0x7f;
 		qp_attr->alt_port_num 	= qp_attr->alt_ah_attr.port_num;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
