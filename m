From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 13/14] IB/core: Support getting IOCTL header/SGEs from kernel space
Date: Sun, 11 Dec 2016 14:58:07 +0200
Message-ID: <1481461088-56355-14-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to allow compatibility header, allow passing
ib_uverbs_ioctl_hdr and ib_uverbs_attr from kernel space.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h       |  6 ++++
 drivers/infiniband/core/uverbs_ioctl.c | 56 ++++++++++++++++++++++------------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 7c038a3..72858e5 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -84,7 +84,13 @@
  * released when the CQ is destroyed.
  */
 
+struct ib_uverbs_ioctl_hdr;
 long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
+			 struct ib_uverbs_file *file,
+			 struct ib_uverbs_ioctl_hdr *hdr,
+			 void __user *buf,
+			 bool w_legacy);
 
 struct ib_uverbs_device {
 	atomic_t				refcount;
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 406b735..6050a64 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -41,7 +41,8 @@ static int uverbs_validate_attr(struct ib_device *ibdev,
 				u16 attr_id,
 				const struct uverbs_attr_spec_group *attr_spec_group,
 				struct uverbs_attr_array *attr_array,
-				struct ib_uverbs_attr __user *uattr_ptr)
+				struct ib_uverbs_attr __user *uattr_ptr,
+				bool w_legacy)
 {
 	const struct uverbs_attr_spec *spec;
 	struct uverbs_attr *e;
@@ -113,10 +114,14 @@ static int uverbs_validate_attr(struct ib_device *ibdev,
 		if (spec->obj.access == UVERBS_IDR_ACCESS_NEW) {
 			u64 idr = o_attr->uobject->id;
 
-			if (put_user(idr, &o_attr->uattr->ptr_idr)) {
-				uverbs_rollback_object(o_attr->uobject,
-						       UVERBS_IDR_ACCESS_NEW);
-				return -EFAULT;
+			if (!w_legacy) {
+				if (put_user(idr, &o_attr->uattr->ptr_idr)) {
+					uverbs_rollback_object(o_attr->uobject,
+							       UVERBS_IDR_ACCESS_NEW);
+					return -EFAULT;
+				}
+			} else {
+				o_attr->uattr->ptr_idr = idr;
 			}
 		}
 
@@ -135,7 +140,8 @@ static int uverbs_validate(struct ib_device *ibdev,
 			   size_t num_attrs,
 			   const struct uverbs_action *action,
 			   struct uverbs_attr_array *attr_array,
-			   struct ib_uverbs_attr __user *uattr_ptr)
+			   struct ib_uverbs_attr __user *uattr_ptr,
+			   bool w_legacy)
 {
 	size_t i;
 	int ret;
@@ -161,7 +167,7 @@ static int uverbs_validate(struct ib_device *ibdev,
 		attr_spec_group = action->attr_groups[ret];
 		ret = uverbs_validate_attr(ibdev, ucontext, uattr, attr_id,
 					   attr_spec_group, &attr_array[ret],
-					   uattr_ptr++);
+					   uattr_ptr++, w_legacy);
 		if (ret) {
 			uverbs_commit_objects(attr_array, n_val,
 					      action, false);
@@ -178,14 +184,16 @@ static int uverbs_handle_action(struct ib_uverbs_attr __user *uattr_ptr,
 				struct ib_device *ibdev,
 				struct ib_uverbs_file *ufile,
 				const struct uverbs_action *handler,
-				struct uverbs_attr_array *attr_array)
+				struct uverbs_attr_array *attr_array,
+				bool w_legacy)
 {
 	int ret;
 	int n_val;
 	unsigned int i;
 
 	n_val = uverbs_validate(ibdev, ufile->ucontext, uattrs, num_attrs,
-				handler, attr_array, uattr_ptr);
+				handler, attr_array, uattr_ptr,
+				w_legacy);
 	if (n_val <= 0)
 		return n_val;
 
@@ -212,10 +220,11 @@ cleanup:
 #ifdef UVERBS_OPTIMIZE_USING_STACK
 #define UVERBS_MAX_STACK_USAGE		512
 #endif
-static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
-				struct ib_uverbs_file *file,
-				struct ib_uverbs_ioctl_hdr *hdr,
-				void __user *buf)
+long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
+			 struct ib_uverbs_file *file,
+			 struct ib_uverbs_ioctl_hdr *hdr,
+			 void __user *buf,
+			 bool w_legacy)
 {
 	const struct uverbs_type *type;
 	const struct uverbs_action *action;
@@ -281,15 +290,21 @@ static long ib_uverbs_cmd_verbs(struct ib_device *ib_dev,
 		curr_bitmap += BITS_TO_LONGS(curr_num_attrs);
 	}
 
-	err = copy_from_user(ctx->uattrs, buf,
-			     sizeof(*ctx->uattrs) * hdr->num_attrs);
-	if (err) {
-		err = -EFAULT;
-		goto out;
+	if (w_legacy) {
+		memcpy(ctx->uattrs, buf,
+		       sizeof(*ctx->uattrs) * hdr->num_attrs);
+	} else {
+		err = copy_from_user(ctx->uattrs, buf,
+				     sizeof(*ctx->uattrs) * hdr->num_attrs);
+		if (err) {
+			err = -EFAULT;
+			goto out;
+		}
 	}
 
 	err = uverbs_handle_action(buf, ctx->uattrs, hdr->num_attrs, ib_dev,
-				   file, action, ctx->uverbs_attr_array);
+				   file, action, ctx->uverbs_attr_array,
+				   w_legacy);
 out:
 #ifdef UVERBS_OPTIMIZE_USING_STACK
 	if (ctx_size > UVERBS_MAX_STACK_USAGE)
@@ -344,7 +359,8 @@ long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		}
 
 		err = ib_uverbs_cmd_verbs(ib_dev, file, &hdr,
-					  (__user void *)arg + sizeof(hdr));
+					  (__user void *)arg + sizeof(hdr),
+					  false);
 	}
 out:
 	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
