From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 6/7] IB/core: Fix incorrect array allocation
Date: Sat,  4 Jun 2016 15:15:23 +0300
Message-ID: <1465042524-25852-7-git-send-email-leon@kernel.org>
References: <1465042524-25852-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042524-25852-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In a attribute group struct, attrs should point to a NULL
terminated list. Which means we need to allocate one more
slot in the array.

Fixes: b40f4757daa1 ("IB/core: Make device counter infrastructure dynamic")
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5e573bb..c68f132 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -902,8 +902,11 @@ static void setup_hw_stats(struct ib_device *device, struct ib_port *port,
 		goto err;
 
 	hsag = kzalloc(sizeof(*hsag) +
-		       // 1 extra for the lifespan config entry
-		       sizeof(void *) * (stats->num_counters + 1),
+		       /* 1 extra for the lifespan config entry,
+			* and 1 more because attrs should be
+			* NULL terminated.
+			*/
+		       sizeof(void *) * (stats->num_counters + 2),
 		       GFP_KERNEL);
 	if (!hsag)
 		return;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
