From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 2/6] IB Core: Error Handler
Date: Mon, 13 Dec 2010 18:22:46 +0200
Message-ID: <1292257370-24391-3-git-send-email-nirm@voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292257370-24391-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added missing error handling in ib_core init. (Wasn't intentional right?)

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a19effa..6e06e37 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -719,15 +719,22 @@ static int __init ib_core_init(void)
 	int ret;
 
 	ret = ib_sysfs_setup();
-	if (ret)
+	if (ret) {
 		printk(KERN_WARNING "Couldn't create InfiniBand device class\n");
+		goto err;
+	}
 
 	ret = ib_cache_setup();
 	if (ret) {
 		printk(KERN_WARNING "Couldn't set up InfiniBand P_Key/GID cache\n");
-		ib_sysfs_cleanup();
+		goto err_sysfs;
 	}
 
+	return 0;
+
+err_sysfs:
+	ib_sysfs_cleanup();
+err:
 	return ret;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
