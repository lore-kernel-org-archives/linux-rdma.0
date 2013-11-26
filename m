From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for v3.13 5/7] IB/uverbs: check comp_mask in destroy_flow
Date: Tue, 26 Nov 2013 23:02:43 +0100
Message-ID: <fa0190c08a47cdb0e38ecdec79ee9935a6daa0b3.1385501822.git.ydroneaud@opteya.com>
References: <cover.1385501822.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just like the check added to create_flow in 22878dbc9173,
comp_mask must be checked in destroy_flow too.

Since only empty comp_mask is currently supported,
any other value must be rejected.

Link: http://marc.info/?i=cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d9d91c412628..f1ba441cd2ed 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2795,6 +2795,9 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	if (cmd.comp_mask)
+		return -EINVAL;
+
 	uobj = idr_write_uobj(&ib_uverbs_rule_idr, cmd.flow_handle,
 			      file->ucontext);
 	if (!uobj)
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
