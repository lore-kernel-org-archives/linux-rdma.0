From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] ib/core: Protect QP mcast list
Date: Mon, 19 Dec 2011 09:09:52 +0200
Message-ID: <20111219070952.GA11530@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Multicast attach/detach operations on a QP are carried under the
readers'/writers' lock of the QP. Such protection is not sufficient since a
reader's lock allows more than one reader to acquire the lock. However, list
manipulation implies write operations on the list variable. Use a spinlock to
provide protection.
We have hit kernel oops when running applications that perform multicast
joins/leaves. This patch solved the issue.

Reported by: Mike Dubman <miked-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   11 ++++++++++-
 include/rdma/ib_verbs.h              |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c426992..0209292 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1132,6 +1132,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (ret)
 		goto err_destroy;
 
+	spin_lock_init(&qp->mcast_lock);
 	memset(&resp, 0, sizeof resp);
 	resp.qpn             = qp->qp_num;
 	resp.qp_handle       = obj->uevent.uobject.id;
@@ -1910,12 +1911,15 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
 
+	spin_lock(&qp->mcast_lock);
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
 			ret = 0;
+			spin_unlock(&qp->mcast_lock);
 			goto out_put;
 		}
+	spin_unlock(&qp->mcast_lock);
 
 	mcast = kmalloc(sizeof *mcast, GFP_KERNEL);
 	if (!mcast) {
@@ -1927,8 +1931,11 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 	memcpy(mcast->gid.raw, cmd.gid, sizeof mcast->gid.raw);
 
 	ret = ib_attach_mcast(qp, &mcast->gid, cmd.mlid);
-	if (!ret)
+	if (!ret) {
+		spin_lock(&qp->mcast_lock);
 		list_add_tail(&mcast->list, &obj->mcast_list);
+		spin_unlock(&qp->mcast_lock);
+	}
 	else
 		kfree(mcast);
 
@@ -1961,6 +1968,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
 
+	spin_lock(&qp->mcast_lock);
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
@@ -1968,6 +1976,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 			kfree(mcast);
 			break;
 		}
+	spin_unlock(&qp->mcast_lock);
 
 out_put:
 	put_qp_read(qp);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 55cd0a0..bf86750 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -895,6 +895,7 @@ struct ib_qp {
 	void		       *qp_context;
 	u32			qp_num;
 	enum ib_qp_type		qp_type;
+	spinlock_t              mcast_lock;
 };
 
 struct ib_mr {
-- 
1.7.8

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
