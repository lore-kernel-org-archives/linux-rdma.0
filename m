From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] ib/core: Protect QP mcast list
Date: Wed, 21 Dec 2011 18:56:12 +0200
Message-ID: <20111221165612.GA1037@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Multicast attach/detach operations on a QP are carried under the
readers'/writers' lock of the QP. Such protection is not sufficient since a
reader's lock allows more than one reader to acquire the lock. However, list
manipulation implies write operations on the list variable. Acquire the lock as
a writer to serialize attach/detach operations. Add idr_write_qp() and
put_qp_write().
We have hit kernel oops when running applications that perform multicast
joins/leaves. This patch solved the issue.

Reported by: Mike Dubman <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes from previous version:
Avoid the spinlock and serialize the entire operation by taking the
lock as a writer.


 drivers/infiniband/core/uverbs_cmd.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 254f164..e3db8ef 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -241,11 +241,24 @@ static struct ib_qp *idr_read_qp(int qp_handle, struct ib_ucontext *context)
 	return idr_read_obj(&ib_uverbs_qp_idr, qp_handle, context, 0);
 }
 
+static struct ib_qp *idr_write_qp(int qp_handle, struct ib_ucontext *context)
+{
+	struct ib_uobject *uobj;
+
+	uobj = idr_write_uobj(&ib_uverbs_qp_idr, qp_handle, context);
+	return uobj ? uobj->object : NULL;
+}
+
 static void put_qp_read(struct ib_qp *qp)
 {
 	put_uobj_read(qp->uobject);
 }
 
+static void put_qp_write(struct ib_qp *qp)
+{
+	put_uobj_write(qp->uobject);
+}
+
 static struct ib_srq *idr_read_srq(int srq_handle, struct ib_ucontext *context)
 {
 	return idr_read_obj(&ib_uverbs_srq_idr, srq_handle, context, 0);
@@ -2375,7 +2388,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -2404,7 +2417,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
-	put_qp_read(qp);
+	put_qp_write(qp);
 
 	return ret ? ret : in_len;
 }
@@ -2422,7 +2435,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	qp = idr_write_qp(cmd.qp_handle, file->ucontext);
 	if (!qp)
 		return -EINVAL;
 
@@ -2441,7 +2454,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
-	put_qp_read(qp);
+	put_qp_write(qp);
 
 	return ret ? ret : in_len;
 }
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
