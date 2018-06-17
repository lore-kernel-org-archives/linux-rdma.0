From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 05/20] IB/uverbs: Refactor uverbs_finalize_objects
Date: Sun, 17 Jun 2018 12:59:51 +0300
Message-ID: <20180617100006.30663-6-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb@mellanox.com>

uverbs_finalize_objects is currently used only to commit or abort
objects. Since we want to add automatic allocation/free of PTR_IN
attributes, moving it to uverbs_ioctl.c and renamit it to
uverbs_finalize_attrs.

Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/rdma_core.c    | 40 ---------------------
 drivers/infiniband/core/rdma_core.h    | 10 ++----
 drivers/infiniband/core/uverbs_ioctl.c | 64 +++++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 8035a0a7564c..df3c40533252 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -779,43 +779,3 @@ int uverbs_finalize_object(struct ib_uobject *uobj,
 
 	return ret;
 }
-
-int uverbs_finalize_objects(struct uverbs_attr_bundle *attrs_bundle,
-			    struct uverbs_attr_spec_hash * const *spec_hash,
-			    size_t num,
-			    bool commit)
-{
-	unsigned int i;
-	int ret = 0;
-
-	for (i = 0; i < num; i++) {
-		struct uverbs_attr_bundle_hash *curr_bundle =
-			&attrs_bundle->hash[i];
-		const struct uverbs_attr_spec_hash *curr_spec_bucket =
-			spec_hash[i];
-		unsigned int j;
-
-		for (j = 0; j < curr_bundle->num_attrs; j++) {
-			struct uverbs_attr *attr;
-			const struct uverbs_attr_spec *spec;
-
-			if (!uverbs_attr_is_valid_in_hash(curr_bundle, j))
-				continue;
-
-			attr = &curr_bundle->attrs[j];
-			spec = &curr_spec_bucket->attrs[j];
-
-			if (spec->type == UVERBS_ATTR_TYPE_IDR ||
-			    spec->type == UVERBS_ATTR_TYPE_FD) {
-				int current_ret;
-
-				current_ret = uverbs_finalize_object(attr->obj_attr.uobject,
-								     spec->obj.access,
-								     commit);
-				if (!ret)
-					ret = current_ret;
-			}
-		}
-	}
-	return ret;
-}
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 1efcf93238dd..a243cc2a59f7 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -94,9 +94,6 @@ struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type
 						   struct ib_ucontext *ucontext,
 						   enum uverbs_obj_access access,
 						   int id);
-int uverbs_finalize_object(struct ib_uobject *uobj,
-			   enum uverbs_obj_access access,
-			   bool commit);
 /*
  * Note that certain finalize stages could return a status:
  *   (a) alloc_commit could return a failure if the object is committed at the
@@ -112,9 +109,8 @@ int uverbs_finalize_object(struct ib_uobject *uobj,
  * function. For example, this could happen when we couldn't destroy an
  * object.
  */
-int uverbs_finalize_objects(struct uverbs_attr_bundle *attrs_bundle,
-			    struct uverbs_attr_spec_hash * const *spec_hash,
-			    size_t num,
-			    bool commit);
+int uverbs_finalize_object(struct ib_uobject *uobj,
+			   enum uverbs_obj_access access,
+			   bool commit);
 
 #endif /* RDMA_CORE_H */
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 8d32c4ae368c..8cc3e8dad9b5 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -167,6 +167,46 @@ static int uverbs_process_attr(struct ib_device *ibdev,
 	return 0;
 }
 
+static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
+			  struct uverbs_attr_spec_hash * const *spec_hash,
+			  size_t num,
+			  bool commit)
+{
+	unsigned int i;
+	int ret = 0;
+
+	for (i = 0; i < num; i++) {
+		struct uverbs_attr_bundle_hash *curr_bundle =
+			&attrs_bundle->hash[i];
+		const struct uverbs_attr_spec_hash *curr_spec_bucket =
+			spec_hash[i];
+		unsigned int j;
+
+		for (j = 0; j < curr_bundle->num_attrs; j++) {
+			struct uverbs_attr *attr;
+			const struct uverbs_attr_spec *spec;
+
+			if (!uverbs_attr_is_valid_in_hash(curr_bundle, j))
+				continue;
+
+			attr = &curr_bundle->attrs[j];
+			spec = &curr_spec_bucket->attrs[j];
+
+			if (spec->type == UVERBS_ATTR_TYPE_IDR ||
+			    spec->type == UVERBS_ATTR_TYPE_FD) {
+				int current_ret;
+
+				current_ret = uverbs_finalize_object(attr->obj_attr.uobject,
+								     spec->obj.access,
+								     commit);
+				if (!ret)
+					ret = current_ret;
+			}
+		}
+	}
+	return ret;
+}
+
 static int uverbs_uattrs_process(struct ib_device *ibdev,
 				 struct ib_ucontext *ucontext,
 				 const struct ib_uverbs_attr *uattrs,
@@ -187,10 +227,10 @@ static int uverbs_uattrs_process(struct ib_device *ibdev,
 		ret = uverbs_ns_idx(&attr_id, method->num_buckets);
 		if (ret < 0) {
 			if (uattr->flags & UVERBS_ATTR_F_MANDATORY) {
-				uverbs_finalize_objects(attr_bundle,
-							method->attr_buckets,
-							num_given_buckets,
-							false);
+				uverbs_finalize_attrs(attr_bundle,
+						      method->attr_buckets,
+						      num_given_buckets,
+						      false);
 				return ret;
 			}
 			continue;
@@ -208,10 +248,10 @@ static int uverbs_uattrs_process(struct ib_device *ibdev,
 					  attr_spec_bucket, &attr_bundle->hash[ret],
 					  uattr_ptr++);
 		if (ret) {
-			uverbs_finalize_objects(attr_bundle,
-						method->attr_buckets,
-						num_given_buckets,
-						false);
+			uverbs_finalize_attrs(attr_bundle,
+					      method->attr_buckets,
+					      num_given_buckets,
+					      false);
 			return ret;
 		}
 	}
@@ -271,10 +311,10 @@ static int uverbs_handle_method(struct ib_uverbs_attr __user *uattr_ptr,
 
 	ret = method_spec->handler(ibdev, ufile, attr_bundle);
 cleanup:
-	finalize_ret = uverbs_finalize_objects(attr_bundle,
-					       method_spec->attr_buckets,
-					       attr_bundle->num_buckets,
-					       !ret);
+	finalize_ret = uverbs_finalize_attrs(attr_bundle,
+					     method_spec->attr_buckets,
+					     attr_bundle->num_buckets,
+					     !ret);
 
 	return ret ? ret : finalize_ret;
 }
-- 
2.14.4
