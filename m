From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] infiniband: shut up a maybe-uninitialized warning
Date: Mon,  4 Jul 2016 17:06:26 +0200
Message-ID: <20160704150659.2883024-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The powerpc64 default configuration leads to warnings for the infiniband
core code:

infiniband/core/cma.c: In function 'cma_get_net_dev':
infiniband/core/cma.c:1242:12: warning: 'src_addr_storage.sin_addr.s_addr' may be used uninitialized in this function [-Wmaybe-uninitialized]

The code looks correct to me, and I don't see the warnings on the
other architectures, so this is a dumb change to add an unneeded
initialization to the variables in order to shut up the warning.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Link: http://arm-soc.lixom.net/buildlogs/mainline/v4.7-rc6/buildall.powerpc.ppc64_defconfig.log.passed
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a3c9930f1f93..924ac237310b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1309,7 +1309,7 @@ static bool validate_net_dev(struct net_device *net_dev,
 static struct net_device *cma_get_net_dev(struct ib_cm_event *ib_event,
 					  const struct cma_req_info *req)
 {
-	struct sockaddr_storage listen_addr_storage, src_addr_storage;
+	struct sockaddr_storage listen_addr_storage = {}, src_addr_storage = {};
 	struct sockaddr *listen_addr = (struct sockaddr *)&listen_addr_storage,
 			*src_addr = (struct sockaddr *)&src_addr_storage;
 	struct net_device *net_dev;
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
