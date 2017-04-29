From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 14/18] IB/PVRDMA: Rename ib_ah_attr related functions
Date: Sat, 29 Apr 2017 14:41:26 -0400
Message-ID: <1493491290-31621-15-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Functions pvrdma_ah_attr_to_ib and ib_ah_attr_to_pvrdma have
been renamed so they are in sync wit the rename of the
ib_ah_attr structure

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      | 8 ++++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c | 8 ++++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 4e56b43..8e2f0a1 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -440,10 +440,10 @@ void pvrdma_global_route_to_ib(struct ib_global_route *dst,
 			       const struct pvrdma_global_route *src);
 void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
 			       const struct ib_global_route *src);
-void pvrdma_ah_attr_to_ib(struct rdma_ah_attr *dst,
-			  const struct pvrdma_ah_attr *src);
-void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
-			  const struct rdma_ah_attr *src);
+void pvrdma_ah_attr_to_rdma(struct rdma_ah_attr *dst,
+			    const struct pvrdma_ah_attr *src);
+void rdma_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
+			    const struct rdma_ah_attr *src);
 
 int pvrdma_uar_table_init(struct pvrdma_dev *dev);
 void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
index 4ce831d..8200b03 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
@@ -277,8 +277,8 @@ void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
 	dst->traffic_class = src->traffic_class;
 }
 
-void pvrdma_ah_attr_to_ib(struct rdma_ah_attr *dst,
-			  const struct pvrdma_ah_attr *src)
+void pvrdma_ah_attr_to_rdma(struct rdma_ah_attr *dst,
+			    const struct pvrdma_ah_attr *src)
 {
 	pvrdma_global_route_to_ib(&dst->grh, &src->grh);
 	dst->dlid = src->dlid;
@@ -290,8 +290,8 @@ void pvrdma_ah_attr_to_ib(struct rdma_ah_attr *dst,
 	memcpy(&dst->dmac, &src->dmac, sizeof(dst->dmac));
 }
 
-void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
-			  const struct rdma_ah_attr *src)
+void rdma_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
+			    const struct rdma_ah_attr *src)
 {
 	ib_global_route_to_pvrdma(&dst->grh, &src->grh);
 	dst->dlid = src->dlid;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 30062aa..ed34d5a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -533,8 +533,8 @@ int pvrdma_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	cmd->attrs.alt_port_num = attr->alt_port_num;
 	cmd->attrs.alt_timeout = attr->alt_timeout;
 	ib_qp_cap_to_pvrdma(&cmd->attrs.cap, &attr->cap);
-	ib_ah_attr_to_pvrdma(&cmd->attrs.ah_attr, &attr->ah_attr);
-	ib_ah_attr_to_pvrdma(&cmd->attrs.alt_ah_attr, &attr->alt_ah_attr);
+	rdma_ah_attr_to_pvrdma(&cmd->attrs.ah_attr, &attr->ah_attr);
+	rdma_ah_attr_to_pvrdma(&cmd->attrs.alt_ah_attr, &attr->alt_ah_attr);
 
 	ret = pvrdma_cmd_post(dev, &req, &rsp, PVRDMA_CMD_MODIFY_QP_RESP);
 	if (ret < 0) {
@@ -938,8 +938,8 @@ int pvrdma_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	attr->alt_port_num = resp->attrs.alt_port_num;
 	attr->alt_timeout = resp->attrs.alt_timeout;
 	pvrdma_qp_cap_to_ib(&attr->cap, &resp->attrs.cap);
-	pvrdma_ah_attr_to_ib(&attr->ah_attr, &resp->attrs.ah_attr);
-	pvrdma_ah_attr_to_ib(&attr->alt_ah_attr, &resp->attrs.alt_ah_attr);
+	pvrdma_ah_attr_to_rdma(&attr->ah_attr, &resp->attrs.ah_attr);
+	pvrdma_ah_attr_to_rdma(&attr->alt_ah_attr, &resp->attrs.alt_ah_attr);
 
 	qp->state = attr->qp_state;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
