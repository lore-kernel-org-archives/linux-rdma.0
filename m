From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 07/14] RDMA/uverbs: Prevent leak of reserved field
Date: Mon, 31 Jul 2017 10:09:17 +0300
Message-ID: <20170731070924.7193-8-leon@kernel.org>
References: <20170731070924.7193-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

initialize to zero the response structure to prevent
the leakage of "resp.reserved" field.

drivers/infiniband/core/uverbs_cmd.c:1178 ib_uverbs_resize_cq() warn:
	check that 'resp.reserved' doesn't leak information

Fixes: 33b9b3ee9709 ("IB: Add userspace support for resizing CQs")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2c98533a0203..c551d2b275fd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1153,7 +1153,7 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
 			    int out_len)
 {
 	struct ib_uverbs_resize_cq	cmd;
-	struct ib_uverbs_resize_cq_resp	resp;
+	struct ib_uverbs_resize_cq_resp	resp = {};
 	struct ib_udata                 udata;
 	struct ib_cq			*cq;
 	int				ret = -EINVAL;
--
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
