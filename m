From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 08/14] RDMA/uverbs: Properly check command supported mask
Date: Wed, 14 Feb 2018 14:38:38 +0200
Message-ID: <20180214123844.30321-9-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The check based on index is not sufficient because

  IB_USER_VERBS_EX_CMD_CREATE_CQ = IB_USER_VERBS_CMD_CREATE_CQ

and IB_USER_VERBS_CMD_CREATE_CQ <= IB_USER_VERBS_CMD_OPEN_QP,
so if we execute IB_USER_VERBS_EX_CMD_CREATE_CQ this code checks
ib_dev->uverbs_cmd_mask not ib_dev->uverbs_ex_cmd_mask.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 50d43c300112..0cf3664cf7d4 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -635,19 +635,13 @@ struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file
 	return filp;
 }
 
-static bool verify_command_mask(struct ib_device *ib_dev, __u32 command)
+static bool verify_command_mask(struct ib_device *ib_dev,
+				__u32 command, bool extended)
 {
-	u64 mask;
+	if (!extended)
+		return ib_dev->uverbs_cmd_mask & BIT_ULL(command);
 
-	if (command <= IB_USER_VERBS_CMD_OPEN_QP)
-		mask = ib_dev->uverbs_cmd_mask;
-	else
-		mask = ib_dev->uverbs_ex_cmd_mask;
-
-	if (mask & ((u64)1 << command))
-		return true;
-
-	return false;
+	return ib_dev->uverbs_ex_cmd_mask & BIT_ULL(command);
 }
 
 static bool verify_command_idx(__u32 command, bool extended)
@@ -722,7 +716,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	if (!verify_command_mask(ib_dev, command)) {
+	if (!verify_command_mask(ib_dev, command, extended)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
