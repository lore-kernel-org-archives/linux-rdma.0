From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] IB/ipath: Correct ipath_verbs_register_sysfs() error
	handling
Date: Thu, 28 Mar 2013 14:12:28 -0400
Message-ID: <20130328181228.22713.34224.stgit@phlsvslse11.ph.intel.com>
References: <20130328181220.22713.60413.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130328181220.22713.60413.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ipath_verbs_register_sysfs() never returned the correct error
code from device_create_file and never cleanup up from a failure.
Additionally, the caller of ipath_verbs_register_sysfs() doesn't
return the correct "ret" value.

This patch resolves all of these issues.

Reported-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_verbs.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index ea93870..44ea939 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -2187,7 +2187,8 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	if (ret)
 		goto err_reg;
 
-	if (ipath_verbs_register_sysfs(dev))
+	ret = ipath_verbs_register_sysfs(dev);
+	if (ret)
 		goto err_class;
 
 	enable_timer(dd);
@@ -2327,15 +2328,15 @@ static int ipath_verbs_register_sysfs(struct ib_device *dev)
 	int i;
 	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(ipath_class_attributes); ++i)
-		if (device_create_file(&dev->dev,
-				       ipath_class_attributes[i])) {
-			ret = 1;
+	for (i = 0; i < ARRAY_SIZE(ipath_class_attributes); ++i) {
+		ret = device_create_file(&dev->dev,
+				       ipath_class_attributes[i]);
+		if (ret)
 			goto bail;
-		}
-
-	ret = 0;
-
+	}
+	return 0;
 bail:
+	for (i = 0; i < ARRAY_SIZE(ipath_class_attributes); ++i)
+		device_remove_file(&dev->dev, ipath_class_attributes[i]);
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
