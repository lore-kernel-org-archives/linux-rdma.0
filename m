From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/7] IB/core: Introduce UVERBS_IDR_ANY_OBJECT
Date: Mon, 26 Nov 2018 08:28:33 +0200
Message-ID: <20181126062838.5907-3-leon@kernel.org>
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

Introduce the UVERBS_IDR_ANY_OBJECT type to match any IDR object.

Once used, the infrastructure skips checking for the IDR type, it
becomes the driver handler responsibility.

This enables drivers to get in a given method an object from various of
types.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/rdma_core.c   | 27 +++++++++++++++++----------
 drivers/infiniband/core/rdma_core.h   | 16 +++++++++++++++-
 drivers/infiniband/core/uverbs_uapi.c |  9 +++++++--
 include/rdma/uverbs_ioctl.h           |  6 ++++++
 4 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index efa292489271..d160ed23065e 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -398,16 +398,23 @@ struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_api_object *obj,
 	struct ib_uobject *uobj;
 	int ret;
 
-	if (!obj)
-		return ERR_PTR(-EINVAL);
+	if (IS_ERR(obj) && PTR_ERR(obj) == -ENOMSG) {
+		/* must be UVERBS_IDR_ANY_OBJECT, see uapi_get_object() */
+		uobj = lookup_get_idr_uobject(NULL, ufile, id, mode);
+		if (IS_ERR(uobj))
+			return uobj;
+	} else {
+		if (IS_ERR(obj))
+			return ERR_PTR(-EINVAL);
 
-	uobj = obj->type_class->lookup_get(obj, ufile, id, mode);
-	if (IS_ERR(uobj))
-		return uobj;
+		uobj = obj->type_class->lookup_get(obj, ufile, id, mode);
+		if (IS_ERR(uobj))
+			return uobj;
 
-	if (uobj->uapi_object != obj) {
-		ret = -EINVAL;
-		goto free;
+		if (uobj->uapi_object != obj) {
+			ret = -EINVAL;
+			goto free;
+		}
 	}
 
 	/*
@@ -427,7 +434,7 @@ struct ib_uobject *rdma_lookup_get_uobject(const struct uverbs_api_object *obj,
 
 	return uobj;
 free:
-	obj->type_class->lookup_put(uobj, mode);
+	uobj->uapi_object->type_class->lookup_put(uobj, mode);
 	uverbs_uobject_put(uobj);
 	return ERR_PTR(ret);
 }
@@ -491,7 +498,7 @@ struct ib_uobject *rdma_alloc_begin_uobject(const struct uverbs_api_object *obj,
 {
 	struct ib_uobject *ret;
 
-	if (!obj)
+	if (IS_ERR(obj))
 		return ERR_PTR(-EINVAL);
 
 	/*
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index bac484d6753a..8aec28037c48 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -162,10 +162,24 @@ struct uverbs_api {
 	const struct uverbs_api_write_method **write_ex_methods;
 };
 
+/*
+ * Get an uverbs_api_object that corresponds to the given object_id.
+ * Note:
+ * -ENOMSG means that any object is allowed to match during lookup.
+ */
 static inline const struct uverbs_api_object *
 uapi_get_object(struct uverbs_api *uapi, u16 object_id)
 {
-	return radix_tree_lookup(&uapi->radix, uapi_key_obj(object_id));
+	const struct uverbs_api_object *res;
+
+	if (object_id == UVERBS_IDR_ANY_OBJECT)
+		return ERR_PTR(-ENOMSG);
+
+	res = radix_tree_lookup(&uapi->radix, uapi_key_obj(object_id));
+	if (!res)
+		return ERR_PTR(-ENOENT);
+
+	return res;
 }
 
 char *uapi_key_format(char *S, unsigned int key);
diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index 19ae4b19b2ef..faac225184a6 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -580,8 +580,13 @@ static void uapi_finalize_disable(struct uverbs_api *uapi)
 			if (obj_key == UVERBS_API_KEY_ERR)
 				continue;
 			tmp_obj = uapi_get_object(uapi, obj_key);
-			if (tmp_obj && !tmp_obj->disabled)
-				continue;
+			if (IS_ERR(tmp_obj)) {
+				if (PTR_ERR(tmp_obj) == -ENOMSG)
+					continue;
+			} else {
+				if (!tmp_obj->disabled)
+					continue;
+			}
 
 			starting_key = iter.index;
 			uapi_remove_method(
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 7f4ace93e502..2f56844fb7da 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -524,6 +524,12 @@ struct uapi_definition {
 			  .u2.objs_arr.max_len = _max_len,                     \
 			  __VA_ARGS__ } })
 
+/*
+ * Only for use with UVERBS_ATTR_IDR, allows any uobject type to be accepted,
+ * the user must validate the type of the uobject instead.
+ */
+#define UVERBS_IDR_ANY_OBJECT 0xFFFF
+
 #define UVERBS_ATTR_IDR(_attr_id, _idr_type, _access, ...)                     \
 	(&(const struct uverbs_attr_def){                                      \
 		.id = _attr_id,                                                \
-- 
2.19.1
