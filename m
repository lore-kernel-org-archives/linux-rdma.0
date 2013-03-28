From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/qib: Correct qib_verbs_register_sysfs() error handling
Date: Thu, 28 Mar 2013 14:17:20 -0400
Message-ID: <20130328181720.22889.87887.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

qib_verbs_register_sysfs() never cleans up from a failure.
Additionally, the caller of qib_verbs_register_sysfs() doesn't
return the correct "ret" value.

This patch resolves both of those issues.

Reported-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_sysfs.c |    6 +++++-
 drivers/infiniband/hw/qib/qib_verbs.c |    3 ++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_sysfs.c b/drivers/infiniband/hw/qib/qib_sysfs.c
index 034cc82..3c8e4e3 100644
--- a/drivers/infiniband/hw/qib/qib_sysfs.c
+++ b/drivers/infiniband/hw/qib/qib_sysfs.c
@@ -808,10 +808,14 @@ int qib_verbs_register_sysfs(struct qib_devdata *dd)
 	for (i = 0; i < ARRAY_SIZE(qib_attributes); ++i) {
 		ret = device_create_file(&dev->dev, qib_attributes[i]);
 		if (ret)
-			return ret;
+			goto bail;
 	}
 
 	return 0;
+bail:
+	for (i = 0; i < ARRAY_SIZE(qib_attributes); ++i)
+		device_remove_file(&dev->dev, qib_attributes[i]);
+	return ret;
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 7c0ab16..904c384 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2234,7 +2234,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	if (ret)
 		goto err_agents;
 
-	if (qib_verbs_register_sysfs(dd))
+	ret = qib_verbs_register_sysfs(dd);
+	if (ret)
 		goto err_class;
 
 	goto bail;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
