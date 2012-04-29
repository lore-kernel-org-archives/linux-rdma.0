From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/7] IB/core: enhance the qp use counter to track multicast attach/detach
Date: Sun, 29 Apr 2012 17:04:22 +0300
Message-ID: <1335708267-30284-3-git-send-email-ogerlitz@mellanox.com>
References: <1335708267-30284-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335708267-30284-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the same manner that we don't allow to destroy a PD, CQ, etc if
there are open QPs that relate to them, don't let one destory a QP
if there are active attachment/s of it to multicast groups. Use the
existing usecnt field of struct ib_qp which was added by commit
0e0ec7e "RDMA/core: Export ib_open_qp() to share XRC TGT QPs".

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   14 ++++++++++++--
 include/rdma/ib_verbs.h         |    2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 140f9a5..30f199e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1184,23 +1184,33 @@ EXPORT_SYMBOL(ib_dealloc_fmr);
 
 int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
+	int ret;
+
 	if (!qp->device->attach_mcast)
 		return -ENOSYS;
 	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
 		return -EINVAL;
 
-	return qp->device->attach_mcast(qp, gid, lid);
+	ret = qp->device->attach_mcast(qp, gid, lid);
+	if (!ret)
+		atomic_inc(&qp->usecnt);
+	return ret;
 }
 EXPORT_SYMBOL(ib_attach_mcast);
 
 int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 {
+	int ret;
+
 	if (!qp->device->detach_mcast)
 		return -ENOSYS;
 	if (gid->raw[0] != 0xff || qp->qp_type != IB_QPT_UD)
 		return -EINVAL;
 
-	return qp->device->detach_mcast(qp, gid, lid);
+	ret = qp->device->detach_mcast(qp, gid, lid);
+	if (!ret)
+		atomic_dec(&qp->usecnt);
+	return ret;
 }
 EXPORT_SYMBOL(ib_detach_mcast);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a3fa323..07996af 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -964,7 +964,7 @@ struct ib_qp {
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd; /* XRC TGT QPs only */
 	struct list_head	xrcd_list;
-	atomic_t		usecnt; /* count times opened */
+	atomic_t		usecnt; /* count times opened, mcast attaches */
 	struct list_head	open_list;
 	struct ib_qp           *real_qp;
 	struct ib_uobject      *uobject;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
