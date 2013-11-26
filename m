From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for v3.13 7/7] IB/uverbs: set error code when fail to consume all flow_spec items
Date: Tue, 26 Nov 2013 23:02:45 +0100
Message-ID: <7e2fc009c0c2fcd2c616d02b735cf02f83bad5c6.1385501822.git.ydroneaud@opteya.com>
References: <cover.1385501822.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the flow_spec items parsed count does not match the number
of items declared in the flow_attr command, or if not all
bytes are used for flow_spec items (eg. trailing garbage),
a log message is reported and the function leave through
the error path. Unfortunately the error code is currently
not set.

This patch set error code to -EINVAL in such cases, so
that the error is reported to userspace instead of silently
fail.

Link: http://marc.info/?i=cover.1385501822.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index dd1c5b6ab019..5976d885f408 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2738,6 +2738,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	if (cmd.flow_attr.size || (i != flow_attr->num_of_specs)) {
 		pr_warn("create flow failed, flow %d: %d bytes left from uverb cmd\n",
 			i, cmd.flow_attr.size);
+		err = -EINVAL;
 		goto err_free;
 	}
 	flow_id = ib_create_flow(qp, flow_attr, IB_FLOW_DOMAIN_USER);
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
