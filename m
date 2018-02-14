From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 01/14] RDMA/uverbs: Convert command mask validity check function to be bool
Date: Wed, 14 Feb 2018 14:38:31 +0200
Message-ID: <20180214123844.30321-2-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The function validate_command_mask() returns only two results: success
or failure, so convert it to return bool instead of 0 and -1.

Reported-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index b36cb12b3f38..1be9a93f628c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -635,7 +635,7 @@ struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file
 	return filp;
 }
 
-static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
+static bool verify_command_mask(struct ib_device *ib_dev, __u32 command)
 {
 	u64 mask;
 
@@ -645,9 +645,9 @@ static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
 		mask = ib_dev->uverbs_ex_cmd_mask;
 
 	if (mask & ((u64)1 << command))
-		return 0;
+		return true;
 
-	return -1;
+	return false;
 }
 
 static bool verify_command_idx(__u32 command, bool extended)
@@ -706,7 +706,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	if (verify_command_mask(ib_dev, command)) {
+	if (!verify_command_mask(ib_dev, command)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
