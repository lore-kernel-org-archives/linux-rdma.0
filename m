From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 5/8] verbs: Remove bogus cq_fd
Date: Tue,  5 Dec 2017 16:17:18 -0700
Message-ID: <20171205231721.19410-6-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

No reason to call close on something we know is -1.

This was left by accident after ABI version < 2 support was removed.

Fixes: 6be16586e081 ("Infrastructure to support verbs extensions")
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/device.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libibverbs/device.c b/libibverbs/device.c
index 16a7d4caeac5a0..4fb759c6474ad7 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -275,7 +275,6 @@ LATEST_SYMVER_FUNC(ibv_close_device, 1_1, "IBVERBS_1.1",
 {
 	int async_fd = context->async_fd;
 	int cmd_fd   = context->cmd_fd;
-	int cq_fd    = -1;
 	struct verbs_context *context_ex;
 	struct verbs_device *verbs_device = verbs_get_device(context->device);
 	struct ibv_device *device = context->device;
@@ -291,8 +290,6 @@ LATEST_SYMVER_FUNC(ibv_close_device, 1_1, "IBVERBS_1.1",
 
 	close(async_fd);
 	close(cmd_fd);
-	if (abi_ver <= 2)
-		close(cq_fd);
 	ibverbs_device_put(device);
 
 	return 0;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
