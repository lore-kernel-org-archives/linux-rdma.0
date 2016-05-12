From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] IB/hfi1: Remove anti-pattern in cdev init
Date: Thu, 12 May 2016 10:28:21 -0700
Message-ID: <20160512172819.11667.78922.stgit@scvm10.sc.intel.com>
References: <20160512172500.11667.11333.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512172500.11667.11333.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Remove the usage of an anti-pattern goto in hfi1_cdev_init to improve
code readability.

Suggested-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/device.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/device.c b/drivers/staging/rdma/hfi1/device.c
index c05c39d..6ee800f 100644
--- a/drivers/staging/rdma/hfi1/device.c
+++ b/drivers/staging/rdma/hfi1/device.c
@@ -82,13 +82,13 @@ int hfi1_cdev_init(int minor, const char *name,
 	else
 		device = device_create(class, NULL, dev, NULL, "%s", name);
 
-	if (!IS_ERR(device))
-		goto done;
-	ret = PTR_ERR(device);
-	device = NULL;
-	pr_err("Could not create device for minor %d, %s (err %d)\n",
-	       minor, name, -ret);
-	cdev_del(cdev);
+	if (IS_ERR(device)) {
+		ret = PTR_ERR(device);
+		device = NULL;
+		pr_err("Could not create device for minor %d, %s (err %d)\n",
+			minor, name, -ret);
+		cdev_del(cdev);
+	}
 done:
 	*devp = device;
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
