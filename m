From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 03/14] RDMA/uverbs: Refactor flags checks and update return value
Date: Wed, 14 Feb 2018 14:38:33 +0200
Message-ID: <20180214123844.30321-4-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since commit f21519b23c1b ("IB/core: extended command: an
improved infrastructure for uverbs commands"), the uverbs
supports extra flags as an input to the command interface.

However actually, there is only one flag available and used,
so it is better to refactor the code, so the resolution and
report to the users is done as early as possible.

As part of this change, we changed the return value of failure case
from ENOSYS to be EINVAL to be consistent with the rest flags checks.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 06ddb93f9c75..c12608b2d1cc 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -701,6 +701,11 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
 	extended_command = flags & IB_USER_VERBS_CMD_FLAG_EXTENDED;
+	if (flags & ~IB_USER_VERBS_CMD_FLAG_EXTENDED) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!verify_command_idx(command, extended_command)) {
 		ret = -EINVAL;
 		goto out;
@@ -732,8 +737,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						 buf + sizeof(hdr),
 						 hdr.in_words * 4,
 						 hdr.out_words * 4);
-
-	} else if (flags == IB_USER_VERBS_CMD_FLAG_EXTENDED) {
+	} else {
 		struct ib_uverbs_ex_cmd_hdr ex_hdr;
 		struct ib_udata ucore;
 		struct ib_udata uhw;
@@ -804,8 +808,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		ret = uverbs_ex_cmd_table[command](file, ib_dev, &ucore, &uhw);
 		if (!ret)
 			ret = written_count;
-	} else {
-		ret = -ENOSYS;
 	}
 
 out:
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
