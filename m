From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 5/8] RDMA/core: Introduce add/remove uobj from types
Date: Thu, 30 Jun 2016 16:39:28 +0300
Message-ID: <1467293971-25688-6-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We introduce here adding new user objects to the type list.
Adding an object is done in two parts. First, an object is allocated
and added to IDR. Then, the command's handlers (in downstream patches)
could work on this object and fill its required details.
After a successful command, ib_uverbs_uobject_enable is called and
this user object becomes ucontext visible.

Removing an uboject is done by calling ib_uverbs_uobject_remove.

We should make sure IDR (per-device) and lists (per-ucontext) could
be accessed concurrently without corrupting them (some parts are
missing here).

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uobject.c | 33 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uobject.h |  5 +++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/infiniband/core/uobject.c b/drivers/infiniband/core/uobject.c
index bc15be1..c480b3b 100644
--- a/drivers/infiniband/core/uobject.c
+++ b/drivers/infiniband/core/uobject.c
@@ -118,6 +118,39 @@ err:
 	return err;
 }
 
+int ib_uverbs_uobject_add(struct ib_uobject *uobject,
+			  struct uverbs_uobject_type *uobject_type)
+{
+	int ret = -EINVAL;
+	struct uverbs_uobject_list *type;
+
+	/* TODO: add locking */
+	list_for_each_entry(type, &uobject->context->uobjects_lists, type_list)
+		if (type->type == uobject_type) {
+			uobject->type = type;
+			ret = idr_add_uobj(uobject);
+			return ret;
+		}
+
+	return ret;
+}
+
+void ib_uverbs_uobject_remove(struct ib_uobject *uobject)
+{
+	spin_lock(&uobject->context->device->idr_lock);
+	list_del(&uobject->idr_list);
+	spin_unlock(&uobject->context->device->idr_lock);
+	idr_remove_uobj(uobject);
+}
+
+void ib_uverbs_uobject_enable(struct ib_uobject *uobject)
+{
+	spin_lock(&uobject->context->device->idr_lock);
+	list_add(&uobject->idr_list, &uobject->type->list);
+	spin_unlock(&uobject->context->device->idr_lock);
+	uobject->live = 1;
+}
+
 /*
  * The ib_uobject locking scheme is as follows:
  *
diff --git a/drivers/infiniband/core/uobject.h b/drivers/infiniband/core/uobject.h
index 40f6ff1..13fdaef 100644
--- a/drivers/infiniband/core/uobject.h
+++ b/drivers/infiniband/core/uobject.h
@@ -58,6 +58,11 @@ struct uverbs_uobject_list {
 	struct list_head		type_list;
 };
 
+int ib_uverbs_uobject_add(struct ib_uobject *uobject,
+			  struct uverbs_uobject_type *uobject_type);
+void ib_uverbs_uobject_remove(struct ib_uobject *uobject);
+void ib_uverbs_uobject_enable(struct ib_uobject *uobject);
+
 void init_uobj(struct ib_uobject *uobj, u64 user_handle,
 	       struct ib_ucontext *context, struct uverbs_lock_class *c);
 
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
