From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 3/7] IB/core: Enable getting an object type from a given uobject
Date: Mon, 26 Nov 2018 08:28:34 +0200
Message-ID: <20181126062838.5907-4-leon@kernel.org>
References: <20181126062838.5907-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181126062838.5907-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Enable getting an object type from a given uobject, the type is saved
upon tree merging and is returned as part of some helper function.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/rdma_core.h   |  5 -----
 drivers/infiniband/core/uverbs_uapi.c |  1 +
 include/rdma/uverbs_std_types.h       | 12 ++++++++++++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 8aec28037c48..b3ca7457ac42 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -118,11 +118,6 @@ void release_ufile_idr_uobject(struct ib_uverbs_file *ufile);
  * Depending on ID the slot pointer in the radix tree points at one of these
  * structs.
  */
-struct uverbs_api_object {
-	const struct uverbs_obj_type *type_attrs;
-	const struct uverbs_obj_type_class *type_class;
-	u8 disabled:1;
-};
 
 struct uverbs_api_ioctl_method {
 	int(__rcu *handler)(struct uverbs_attr_bundle *attrs);
diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index faac225184a6..0136c1d78a0f 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -184,6 +184,7 @@ static int uapi_merge_obj_tree(struct uverbs_api *uapi,
 		if (WARN_ON(obj_elm->type_attrs))
 			return -EINVAL;
 
+		obj_elm->id = obj->id;
 		obj_elm->type_attrs = obj->type_attrs;
 		obj_elm->type_class = obj->type_attrs->type_class;
 		/*
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index df878ce02c94..883abcf6d36e 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -182,5 +182,17 @@ static inline void ib_set_flow(struct ib_uobject *uobj, struct ib_flow *ibflow,
 	uflow->resources = uflow_res;
 }
 
+struct uverbs_api_object {
+	const struct uverbs_obj_type *type_attrs;
+	const struct uverbs_obj_type_class *type_class;
+	u8 disabled:1;
+	u32 id;
+};
+
+static inline u32 uobj_get_object_id(struct ib_uobject *uobj)
+{
+	return uobj->uapi_object->id;
+}
+
 #endif
 
-- 
2.19.1
