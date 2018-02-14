From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 06/14] RDMA/uverbs: Unify return values of not supported command
Date: Wed, 14 Feb 2018 14:38:36 +0200
Message-ID: <20180214123844.30321-7-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The non-existing command is supposed to return -EOPNOTSUPP, but the
current code returns different errors for different flows for the
same failure. This patch unifies those flows.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d8d6ac91981b..90e0b16aed1a 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -653,9 +653,11 @@ static bool verify_command_mask(struct ib_device *ib_dev, __u32 command)
 static bool verify_command_idx(__u32 command, bool extended)
 {
 	if (extended)
-		return command < ARRAY_SIZE(uverbs_ex_cmd_table);
+		return command < ARRAY_SIZE(uverbs_ex_cmd_table) &&
+		       uverbs_ex_cmd_table[command];
 
-	return command < ARRAY_SIZE(uverbs_cmd_table);
+	return command < ARRAY_SIZE(uverbs_cmd_table) &&
+	       uverbs_cmd_table[command];
 }
 
 static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
@@ -730,11 +732,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	}
 
 	if (!flags) {
-		if (!uverbs_cmd_table[command]) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		if (hdr.in_words * 4 != count) {
 			ret = -EINVAL;
 			goto out;
@@ -749,11 +746,6 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		struct ib_udata uhw;
 		size_t written_count = count;
 
-		if (!uverbs_ex_cmd_table[command]) {
-			ret = -ENOSYS;
-			goto out;
-		}
-
 		if (!file->ucontext) {
 			ret = -EINVAL;
 			goto out;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
