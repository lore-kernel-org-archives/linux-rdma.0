From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 for-3.13 08/10] IB/uverbs: set error code when fail to consume all flow_spec items
Date: Tue, 17 Dec 2013 10:58:57 +0100
Message-ID: <235c273cfdbb5449a9408aade049b7aacf0180ae.1387273677.git.ydroneaud@opteya.com>
References: <cover.1387273677.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
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

Link: http://marc.info/?i=cover.1387273677.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f50f1f3dc509..1288a7ce254a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2776,6 +2776,7 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
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
