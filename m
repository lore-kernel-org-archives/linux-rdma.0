From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/10] IB/core: Allocate memory only for flow_spec in create_flow uverbs
Date: Wed,  9 Oct 2013 23:12:46 +0200
Message-ID: <4197856f70def89cfd6d637d37eb0bc8ae4e810e.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of allocating memory for the flow attribute structure
and all the flow specs, this patch makes use of the flow attribute
structure already read as part of the command, allocating memory
only for the flow_specs.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 52 +++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 54ee607..29c89a3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2647,14 +2647,14 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_flow_resp resp;
 	struct ib_uobject		  *uobj;
 	struct ib_flow			  *flow_id;
-	struct ib_uverbs_flow_attr	  *uverbs_flow_attr;
+	struct ib_uverbs_flow_spec	  *uverbs_flow_spec = NULL;
 	struct ib_flow_attr		  *flow_attr;
 	struct ib_qp			  *qp;
 	int err = 0;
 	void *uverbs_spec;
 	void *ib_spec;
 	int i;
-	int uverbs_attr_size;
+	int uverbs_spec_size;
 
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
@@ -2673,33 +2673,29 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
-	uverbs_attr_size = cmd.flow_attr.size;
+	uverbs_spec_size = cmd.flow_attr.size;
 
 	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
-	    uverbs_attr_size < 0 || uverbs_attr_size >
+	    uverbs_spec_size < 0 || uverbs_spec_size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
 		return -EINVAL;
 
 	if (cmd.flow_attr.num_of_specs) {
-		uverbs_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
-		if (!uverbs_flow_attr)
+		uverbs_flow_spec = kmalloc(uverbs_spec_size, GFP_KERNEL);
+		if (!uverbs_flow_spec)
 			return -ENOMEM;
 
-		memcpy(uverbs_flow_attr, &cmd.flow_attr, sizeof(*uverbs_flow_attr));
-		if (copy_from_user(uverbs_flow_attr + 1, buf + sizeof(cmd),
-				   uverbs_attr_size)) {
+		if (copy_from_user(uverbs_flow_spec, buf + sizeof(cmd),
+				   uverbs_spec_size)) {
 			err = -EFAULT;
-			goto err_free_attr;
+			goto err_free_spec;
 		}
-	} else {
-		uverbs_flow_attr = &cmd.flow_attr;
-		uverbs_attr_size = sizeof(cmd.flow_attr);
 	}
 
 	uobj = kmalloc(sizeof(*uobj), GFP_KERNEL);
 	if (!uobj) {
 		err = -ENOMEM;
-		goto err_free_attr;
+		goto err_free_spec;
 	}
 	init_uobj(uobj, 0, file->ucontext, &rule_lock_class);
 	down_write(&uobj->mutex);
@@ -2710,34 +2706,34 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 		goto err_uobj;
 	}
 
-	flow_attr = kmalloc(sizeof(*flow_attr) + cmd.flow_attr.size, GFP_KERNEL);
+	flow_attr = kmalloc(sizeof(*flow_attr) + uverbs_spec_size, GFP_KERNEL);
 	if (!flow_attr) {
 		err = -ENOMEM;
 		goto err_put;
 	}
 
-	flow_attr->type = uverbs_flow_attr->type;
-	flow_attr->priority = uverbs_flow_attr->priority;
-	flow_attr->num_of_specs = uverbs_flow_attr->num_of_specs;
-	flow_attr->port = uverbs_flow_attr->port;
-	flow_attr->flags = uverbs_flow_attr->flags;
+	flow_attr->type = cmd.flow_attr.type;
+	flow_attr->priority = cmd.flow_attr.priority;
+	flow_attr->num_of_specs = cmd.flow_attr.num_of_specs;
+	flow_attr->port = cmd.flow_attr.port;
+	flow_attr->flags = cmd.flow_attr.flags;
 	flow_attr->size = sizeof(*flow_attr);
 
-	uverbs_spec = uverbs_flow_attr + 1;
+	uverbs_spec = uverbs_flow_spec;
 	ib_spec = flow_attr + 1;
-	for (i = 0; i < flow_attr->num_of_specs && uverbs_attr_size > 0; i++) {
+	for (i = 0; i < flow_attr->num_of_specs && uverbs_spec_size > 0; i++) {
 		err = uverbs_spec_to_ib_spec(uverbs_spec, ib_spec);
 		if (err)
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
-		uverbs_attr_size -= ((struct ib_uverbs_flow_spec *) uverbs_spec)->size;
+		uverbs_spec_size -= ((struct ib_uverbs_flow_spec *) uverbs_spec)->size;
 		uverbs_spec += ((struct ib_uverbs_flow_spec *) uverbs_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
-	if (uverbs_attr_size) {
+	if (uverbs_spec_size) {
 		pr_warn("create flow failed, %d bytes left from uverb cmd\n",
-			uverbs_attr_size);
+			uverbs_spec_size);
 		goto err_free;
 	}
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
@@ -2772,7 +2768,7 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	up_write(&uobj->mutex);
 	kfree(flow_attr);
 	if (cmd.flow_attr.num_of_specs)
-		kfree(uverbs_flow_attr);
+		kfree(uverbs_flow_spec);
 	return in_len;
 err_copy:
 	idr_remove_uobj(&ib_uverbs_rule_idr, uobj);
@@ -2784,9 +2780,9 @@ err_put:
 	put_qp_read(qp);
 err_uobj:
 	put_uobj_write(uobj);
-err_free_attr:
+err_free_spec:
 	if (cmd.flow_attr.num_of_specs)
-		kfree(uverbs_flow_attr);
+		kfree(uverbs_flow_spec);
 	return err;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
