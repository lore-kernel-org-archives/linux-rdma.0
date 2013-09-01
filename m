From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/core: Receive flow steering support infrastructure cleanups
Date: Sun,  1 Sep 2013 18:39:52 +0300
Message-ID: <1378049992-27629-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Hadar Har-Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This commit addresses the following comments for patchset
"Add receive Flow Steering support":
  - Addressed comments from Roland on patch #1 and #3
  - Don't allow unsupported comp_mask values, user should
    check ibv_query_device to know which features are supported.
  - Added a check in ib_uverbs_create_flow to verify
    the size passed from the user space.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Roland,

This patch is an incremental patch over
"[PATCH V5 for-next 0/4] Add receive Flow Steering support".
Since V6 had a typo and was actually called V4, V5 was merged instead.
This patch contains V6 fixes and addresses your comments.

Thanks,
Matan

 drivers/infiniband/core/uverbs_cmd.c |   16 +++++++++++++++-
 include/rdma/ib_verbs.h              |    2 ++
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d47717d..f2b81b9 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2662,17 +2662,31 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof(cmd)))
 		return -EFAULT;
 
+	if (cmd.comp_mask)
+		return -EINVAL;
+
 	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
 	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
 		return -EPERM;
 
+	if (cmd.flow_attr.num_of_specs < 0 ||
+	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
+		return -EINVAL;
+
+	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
+			 sizeof(struct ib_uverbs_cmd_hdr_ex);
+
+	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
+	    kern_attr_size < 0 || kern_attr_size >
+	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
+		return -EINVAL;
+
 	if (cmd.flow_attr.num_of_specs) {
 		kern_flow_attr = kmalloc(cmd.flow_attr.size, GFP_KERNEL);
 		if (!kern_flow_attr)
 			return -ENOMEM;
 
 		memcpy(kern_flow_attr, &cmd.flow_attr, sizeof(*kern_flow_attr));
-		kern_attr_size = cmd.flow_attr.size - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr_ex);
 		if (copy_from_user(kern_flow_attr + 1, buf + sizeof(cmd),
 				   kern_attr_size)) {
 			err = -EFAULT;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e65c511..e393171 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1104,6 +1104,8 @@ enum ib_flow_spec_type {
 	IB_FLOW_SPEC_UDP	= 0x41
 };
 
+#define IB_FLOW_SPEC_SUPPORT_LAYERS 4
+
 /* Flow steering rule priority is set according to it's domain.
  * Lower domain value means higher priority.
  */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
