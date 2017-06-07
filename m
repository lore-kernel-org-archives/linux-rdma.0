From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 05/13] IB/core: Add DEVICE type and root types structure
Date: Wed,  7 Jun 2017 15:22:44 +0300
Message-ID: <1496838172-39671-6-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This adds the DEVICE type. This type supports creating the context that
all objects are created from. Moreover, it supports executing actions
which are related to the device itself, such as QUERY_DEVICE.
The only related object to this type is a singleton (per file
instance) context.

All standard types are put in the root structure. This root will later
on be used in drivers as their parsing tree root. Later on, when new
features are added, these drivers could define their own root.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_std_types.c | 19 +++++++++++++++++++
 include/rdma/uverbs_ioctl.h                | 11 +++++++++++
 include/rdma/uverbs_std_types.h            | 19 +++++++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index a204975..4c97be8 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -256,3 +256,22 @@ static int uverbs_hot_unplug_completion_event_file(struct ib_uobject_file *uobj_
 		    /* 2 is used in order to free the PD after MRs */
 		    &UVERBS_TYPE_ALLOC_IDR(2, uverbs_free_pd));
 
+DECLARE_UVERBS_TYPE(uverbs_type_device, NULL);
+
+DECLARE_UVERBS_TYPES(uverbs_common_types,
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_DEVICE, uverbs_type_device),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_PD, uverbs_type_pd),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_MR, uverbs_type_mr),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_COMP_CHANNEL, uverbs_type_comp_channel),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_CQ, uverbs_type_cq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_QP, uverbs_type_qp),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_AH, uverbs_type_ah),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_MW, uverbs_type_mw),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_SRQ, uverbs_type_srq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_FLOW, uverbs_type_flow),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_WQ, uverbs_type_wq),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_RWQ_IND_TBL,
+				     uverbs_type_rwq_ind_table),
+		     ADD_UVERBS_TYPE(UVERBS_TYPE_XRCD, uverbs_type_xrcd),
+);
+EXPORT_SYMBOL(uverbs_common_types);
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index ee89cce..ca636a2 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -135,6 +135,17 @@ struct uverbs_spec_root {
 	const struct uverbs_type name = {				\
 		.type_attrs = _type_attrs,				\
 	}
+#define _UVERBS_TYPE_SZ(...)						\
+	(sizeof((const struct uverbs_type *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type *))
+#define ADD_UVERBS_TYPE(type_idx, type_ptr)				\
+	[type_idx] = ((const struct uverbs_type * const)&(type_ptr))
+#define UVERBS_TYPES(...)  ((const struct uverbs_type_group)		\
+	{.num_types = _UVERBS_TYPE_SZ(__VA_ARGS__),			\
+	 .types = (const struct uverbs_type *[]){__VA_ARGS__} })
+#define DECLARE_UVERBS_TYPES(name, ...)				\
+	const struct uverbs_type_group name = UVERBS_TYPES(__VA_ARGS__)
+
 /* =================================================
  *              Parsing infrastructure
  * =================================================
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 0810faf..3f582ad 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -35,6 +35,23 @@
 
 #include <rdma/uverbs_types.h>
 
+enum uverbs_common_types {
+	UVERBS_TYPE_DEVICE, /* No instances of DEVICE are allowed */
+	UVERBS_TYPE_PD,
+	UVERBS_TYPE_COMP_CHANNEL,
+	UVERBS_TYPE_CQ,
+	UVERBS_TYPE_QP,
+	UVERBS_TYPE_SRQ,
+	UVERBS_TYPE_AH,
+	UVERBS_TYPE_MR,
+	UVERBS_TYPE_MW,
+	UVERBS_TYPE_FLOW,
+	UVERBS_TYPE_XRCD,
+	UVERBS_TYPE_RWQ_IND_TBL,
+	UVERBS_TYPE_WQ,
+	UVERBS_TYPE_LAST,
+};
+
 extern const struct uverbs_type uverbs_type_comp_channel;
 extern const struct uverbs_type uverbs_type_cq;
 extern const struct uverbs_type uverbs_type_qp;
@@ -47,6 +64,8 @@
 extern const struct uverbs_type uverbs_type_mw;
 extern const struct uverbs_type uverbs_type_pd;
 extern const struct uverbs_type uverbs_type_xrcd;
+extern const struct uverbs_type uverbs_type_device;
+extern const struct uverbs_type_group uverbs_common_types;
 
 static inline struct ib_uobject *__uobj_get(const struct uverbs_obj_type *type,
 					    bool write,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
