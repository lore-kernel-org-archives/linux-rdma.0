From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv3 for-3.13 9/9] IB/uverbs: check input length in flow steering uverbs
Date: Wed, 11 Dec 2013 23:01:52 +0100
Message-ID: <171ccedab8531844b9a3186d70be029650ee1d3e.1386798254.git.ydroneaud@opteya.com>
References: <cover.1386798254.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since ib_copy_from_udata() doesn't check yet the available
input data length before accessing userspace memory,
an explicit check of this length is required to prevent:

- reading past the user provided buffer,
- underflow when subtracting the expected command size
  from the input length.

This will ensure the newly added flow steering uverbs
don't try to process truncated commands.

Link: http://marc.info/?i=cover.1386798254.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 5976d885f408..d39062466a7a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2649,6 +2649,9 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 	void *ib_spec;
 	int i;
 
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
 	if (ucore->outlen < sizeof(resp))
 		return -ENOSPC;
 
@@ -2799,6 +2802,9 @@ int ib_uverbs_ex_destroy_flow(struct ib_uverbs_file *file,
 	struct ib_uobject		*uobj;
 	int				ret;
 
+	if (ucore->inlen < sizeof(cmd))
+		return -EINVAL;
+
 	ret = ib_copy_from_udata(&cmd, ucore, sizeof(cmd));
 	if (ret)
 		return ret;
-- 
1.8.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
