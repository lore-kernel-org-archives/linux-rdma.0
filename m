From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/3] IB/core: Fixes to XRC reference counting in uverbs
Date: Thu,  1 Aug 2013 18:49:54 +0300
Message-ID: <1375372194-23339-4-git-send-email-ogerlitz@mellanox.com>
References: <1375372194-23339-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375372194-23339-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added reference counting mechanism for XRC target QPs between
ib_uqp_object and its ib_uxrcd_object. This comes to prevent closing
an xrc domain which is still attached to a qp. In addition, added
missing code in ib_uverbs_destroy_srq to handle correctly
ib_uxrcd_object reference counting on xsrq destroying.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     |    1 +
 drivers/infiniband/core/uverbs_cmd.c |   22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 0fcd7aa..b8431d6 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -135,6 +135,7 @@ struct ib_usrq_object {
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
 	struct list_head 	mcast_list;
+	struct ib_uxrcd_object *uxrcd;
 };
 
 struct ib_ucq_object {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b3c07b0..bc72a7c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1526,7 +1526,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
-	obj = kmalloc(sizeof *obj, GFP_KERNEL);
+	obj = kzalloc(sizeof *obj, GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
 
@@ -1642,8 +1642,13 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	if (xrcd)
+	if (xrcd) {
+		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
+					  uobject);
+		atomic_inc(&obj->uxrcd->refcnt);
 		put_xrcd_read(xrcd_uobj);
+	}
+
 	if (pd)
 		put_pd_read(pd);
 	if (scq)
@@ -1753,6 +1758,8 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 		goto err_remove;
 	}
 
+	obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
+	atomic_inc(&obj->uxrcd->refcnt);
 	put_xrcd_read(xrcd_uobj);
 
 	mutex_lock(&file->mutex);
@@ -2019,6 +2026,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	if (obj->uxrcd)
+		atomic_dec(&obj->uxrcd->refcnt);
+
 	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -2860,6 +2870,8 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	struct ib_srq               	 *srq;
 	struct ib_uevent_object        	 *obj;
 	int                         	  ret = -EINVAL;
+	struct ib_usrq_object   *us;
+	enum ib_srq_type srq_type;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
@@ -2869,6 +2881,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 		return -EINVAL;
 	srq = uobj->object;
 	obj = container_of(uobj, struct ib_uevent_object, uobject);
+	srq_type = srq->srq_type;
 
 	ret = ib_destroy_srq(srq);
 	if (!ret)
@@ -2879,6 +2892,11 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	if (srq_type == IB_SRQT_XRC) {
+		us = container_of(obj, struct ib_usrq_object, uevent);
+		atomic_dec(&us->uxrcd->refcnt);
+	}
+
 	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 
 	mutex_lock(&file->mutex);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
