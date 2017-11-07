From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [rdma-core] librdmacm: Make return value from ucma_init consist
Date: Tue,  7 Nov 2017 10:43:21 +0200
Message-ID: <20171107084321.6396-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When check_abi_version fails we must be consist with rest of exit flows
of the function and return -1 and set errno with the actual error code.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 librdmacm/cma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index 7aaf45f2..4898c348 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -202,8 +202,10 @@ int ucma_init(void)
 
 	fastlock_init(&idm_lock);
 	ret = check_abi_version();
-	if (ret)
+	if (ret) {
+		ret = ERR(EPERM);
 		goto err1;
+	}
 
 	dev_list = ibv_get_device_list(&dev_cnt);
 	if (!dev_list) {
-- 
2.13.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
