From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/10] IB/core: Remove checks for negative values in create_flow uverbs
Date: Wed,  9 Oct 2013 23:12:47 +0200
Message-ID: <a90cd272cf465d3c5ce6ecc4e588caa103c5d3b9.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fields in flow_attr structure are unsigned, so it's not
necessary to check for negative values.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 29c89a3..0ea5529 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2669,17 +2669,18 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
 		return -EPERM;
 
-	if (cmd.flow_attr.num_of_specs < 0 ||
-	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
+	if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
-	uverbs_spec_size = cmd.flow_attr.size;
+	if (cmd.flow_attr.size > (in_len - sizeof(cmd)))
+		return -EINVAL;
 
-	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
-	    uverbs_spec_size < 0 || uverbs_spec_size >
+	if (cmd.flow_attr.size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_uverbs_flow_spec)))
 		return -EINVAL;
 
+	uverbs_spec_size = cmd.flow_attr.size;
+
 	if (cmd.flow_attr.num_of_specs) {
 		uverbs_flow_spec = kmalloc(uverbs_spec_size, GFP_KERNEL);
 		if (!uverbs_flow_spec)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
