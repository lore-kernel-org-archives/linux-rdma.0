From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for v3.13 5/8] IB/uverbs: check comp_mask in destroy_flow
Date: Mon,  2 Dec 2013 12:12:47 +0100
Message-ID: <221a1e815abf34a6597b8c39cd4c8c03e53e939e.1385981934.git.ydroneaud@opteya.com>
References: <cover.1385981934.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just like the check added to create_flow in 22878dbc9173,
comp_mask must be checked in destroy_flow too.

Since only empty comp_mask is currently supported,
any other value must be rejected.

This check was silently added in a previous patch[1] to move
comp_mask in extended command header, part of previous patchset[2]
against create/destroy_flow uverbs. The idea of moving comp_mask
to the header was discarded for the final patchset[3].

Unfortunately the check added in destroy_flow uverb was not
integrated in the final patchset.

[1] http://marc.info/?i=40175eda10d670d098204da6aa4c327a0171ae5f.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[2] http://marc.info/?i=cover.1381510045.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[3] http://marc.info/?i=cover.1383773832.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Link: http://marc.info/?i=cover.1385981934.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
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
