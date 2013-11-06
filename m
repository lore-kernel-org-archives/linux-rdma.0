From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for -next v2 1/7] IB/core: clarify overflow/underflow checks on ib_create/destroy_flow
Date: Wed,  6 Nov 2013 23:21:44 +0100
Message-ID: <5ba88c1178b3d9548e4016f28fab36de747b1a90.1383773832.git.ydroneaud@opteya.com>
References: <cover.1383773832.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch fixes the following issues:
1. Unneeded checks were removed
2. Removed the fixed size out of flow_attr.size and by thus
   simplifying the checks.
3. Remove a 32bit hole on 64bit systems with strict alignment
   in struct ib_kern_flow_att by adding a reserved field.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 32 +++++++++++++++-----------------
 include/uapi/rdma/ib_user_verbs.h    |  1 +
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2f0f01b..26ee2d2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2657,7 +2657,6 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	void *kern_spec;
 	void *ib_spec;
 	int i;
-	int kern_attr_size;
 
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
@@ -2672,32 +2671,28 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	if (cmd.flow_attr.num_of_specs < 0 ||
-	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
+	if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
-	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
-			 sizeof(struct ib_uverbs_cmd_hdr_ex);
-
-	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
-	    kern_attr_size < 0 || kern_attr_size >
+	if (cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
+	    cmd.flow_attr.size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
 		return -EINVAL;
 
 	if (cmd.flow_attr.num_of_specs) {
-		kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
+		kern_flow_attr = kmalloc(sizeof(*kern_flow_attr) + cmd.flow_attr.size,
+					 GFP_KERNEL);
 		if (!kern_flow_attr)
 			return -ENOMEM;
 
 		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
 		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
-				   kern_attr_size)) {
+				   cmd.flow_attr.size)) {
 			err = -EFAULT;
 			goto err_free_attr;
 		}
 	} else {
 		kern_flow_attr = &cmd.flow_attr;
-		kern_attr_size = sizeof(cmd.flow_attr);
 	}
 
 	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
@@ -2714,7 +2709,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 		goto err_uobj;
 	}
 
-	flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
+	flow_attr = kmalloc(sizeof(*flow_attr) + cmd.flow_attr.size, GFP_KERNEL);
 	if (!flow_attr) {
 		err = -ENOMEM;
 		goto err_put;
@@ -2729,19 +2724,22 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 
 	kern_spec = kern_flow_attr + 1;
 	ib_spec = flow_attr + 1;
-	for (i = 0; i < flow_attr->num_of_specs && kern_attr_size > 0; i++) {
+	for (i = 0; i < flow_attr->num_of_specs &&
+	     cmd.flow_attr.size > offsetof(struct ib_kern_spec, reserved) &&
+	     cmd.flow_attr.size >=
+	     ((struct ib_kern_spec *)kern_spec)->size; i++) {
 		err = kern_spec_to_ib_spec(kern_spec, ib_spec);
 		if (err)
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
-		kern_attr_size -= ((struct ib_kern_spec *) kern_spec)->size;
+		cmd.flow_attr.size -= ((struct ib_kern_spec *)kern_spec)->size;
 		kern_spec += ((struct ib_kern_spec *) kern_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
-	if (kern_attr_size) {
-		pr_warn("create flow failed, %d bytes left from uverb cmd\n",
-			kern_attr_size);
+	if (cmd.flow_attr.size || (i != flow_attr->num_of_specs)) {
+		pr_warn("create flow failed, flow %d: %d bytes left from uverb cmd\n",
+			i, cmd.flow_attr.size);
 		goto err_free;
 	}
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index e3ddd86..99a58bd 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -771,6 +771,7 @@ struct ib_kern_flow_attr {
 
 struct ib_uverbs_create_flow  {
 	__u32 comp_mask;
+	__u32 reserved;
 	__u64 response;
 	__u32 qp_handle;
 	struct ib_kern_flow_attr flow_attr;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
