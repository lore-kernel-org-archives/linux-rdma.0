From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/9] IB/core: Don't include command header size in uverbs create_flow
Date: Fri, 11 Oct 2013 19:18:48 +0200
Message-ID: <ca92c22d0aea21d559d57e6152cb313729a11274.1381510045.git.ydroneaud@opteya.com>
References: <cover.1381510045.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Flow spec length don't depend on the size of the command
header: they are part of different layers.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3b732f6..1e5f0dd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2671,8 +2671,8 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	if (cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
 		return -EINVAL;
 
-	if (cmd.flow_attr.size > (in_len - sizeof(cmd) - sizeof(struct
-	    ib_uverbs_cmd_hdr_ex)) || cmd.flow_attr.size >
+	if (cmd.flow_attr.size > (in_len - sizeof(cmd)) ||
+	    cmd.flow_attr.size >
 	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
 		return -EINVAL;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
