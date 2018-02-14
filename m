From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 04/14] RDMA/uverbs: Fail as early as possible if not enough header data was provided
Date: Wed, 14 Feb 2018 14:38:34 +0200
Message-ID: <20180214123844.30321-5-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fail as early as possible if not enough header data
was provided.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index c12608b2d1cc..f50ad3688790 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -662,6 +662,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
 	struct ib_uverbs_file *file = filp->private_data;
+	struct ib_uverbs_ex_cmd_hdr ex_hdr;
 	struct ib_device *ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
 	bool extended_command;
@@ -706,6 +707,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
+	if (extended_command &&
+	    count < (sizeof(hdr) + sizeof(ex_hdr))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (!verify_command_idx(command, extended_command)) {
 		ret = -EINVAL;
 		goto out;
@@ -738,7 +745,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						 hdr.in_words * 4,
 						 hdr.out_words * 4);
 	} else {
-		struct ib_uverbs_ex_cmd_hdr ex_hdr;
 		struct ib_udata ucore;
 		struct ib_udata uhw;
 		size_t written_count = count;
@@ -753,11 +759,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			goto out;
 		}
 
-		if (count < (sizeof(hdr) + sizeof(ex_hdr))) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr))) {
 			ret = -EFAULT;
 			goto out;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
