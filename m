From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next 5/7] IB/core: Add lock to multicast handlers
Date: Sun, 19 Mar 2017 17:59:03 +0200
Message-ID: <1489939145-125246-6-git-send-email-matanb@mellanox.com>
References: <1489939145-125246-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489939145-125246-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When two handlers used the same object in the old schema, we blocked
the process in the kernel. The new schema just returns -EBUSY. This
could lead to different behaviour in applications between the old
schema and the new schema. In most cases, using such handlers
concurrently could lead to crashing the process. For example, if
thread A destroys a QP and thread B modifies it, we could have the
destruction happens before the modification. In this case, we are
accessing freed memory which could lead to crashing the process.
This is true for most cases. However, attaching and detaching
a multicast address from QP concurrently is safe. Therefore, we
preserve the original behaviour by adding a lock there.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h     | 2 ++
 drivers/infiniband/core/uverbs_cmd.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 8971761..7b10142 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -163,6 +163,8 @@ struct ib_usrq_object {
 
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
+	/* lock for mcast list */
+	struct mutex		mcast_lock;
 	struct list_head 	mcast_list;
 	struct ib_uxrcd_object *uxrcd;
 };
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b806266..304a3ec 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1343,6 +1343,7 @@ static int create_qp(struct ib_uverbs_file *file,
 		return PTR_ERR(obj);
 	obj->uxrcd = NULL;
 	obj->uevent.uobject.user_handle = cmd->user_handle;
+	mutex_init(&obj->mcast_lock);
 
 	if (cmd_sz >= offsetof(typeof(*cmd), rwq_ind_tbl_handle) +
 		      sizeof(cmd->rwq_ind_tbl_handle) &&
@@ -2579,6 +2580,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
 
+	mutex_lock(&obj->mcast_lock);
 	list_for_each_entry(mcast, &obj->mcast_list, list)
 		if (cmd.mlid == mcast->lid &&
 		    !memcmp(cmd.gid, mcast->gid.raw, sizeof mcast->gid.raw)) {
@@ -2602,6 +2604,7 @@ ssize_t ib_uverbs_attach_mcast(struct ib_uverbs_file *file,
 		kfree(mcast);
 
 out_put:
+	mutex_unlock(&obj->mcast_lock);
 	uobj_put_obj_read(qp);
 
 	return ret ? ret : in_len;
@@ -2626,6 +2629,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		return -EINVAL;
 
 	obj = container_of(qp->uobject, struct ib_uqp_object, uevent.uobject);
+	mutex_lock(&obj->mcast_lock);
 
 	ret = ib_detach_mcast(qp, (union ib_gid *) cmd.gid, cmd.mlid);
 	if (ret)
@@ -2640,6 +2644,7 @@ ssize_t ib_uverbs_detach_mcast(struct ib_uverbs_file *file,
 		}
 
 out_put:
+	mutex_unlock(&obj->mcast_lock);
 	uobj_put_obj_read(qp);
 	return ret ? ret : in_len;
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
