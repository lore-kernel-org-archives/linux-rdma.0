From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cxgb4: initialize the device status page
Date: Tue, 08 Jul 2014 10:20:35 -0500
Message-ID: <20140708152034.17969.83997.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The status page is mapped to user processes and allows sharing the device
state between the kernel and user processes.  This state isn't getting
initialized and thus intermittently causes problems.  Namely, the user
process can mistakenly think the user doorbell writes are disabled which
causes SQ work requests to never get fetched by HW.

This bug was introduced by this commit in 3.15:

	commit 05eb23893c2cf9502a9cec0c32e7f1d1ed2895c8
	Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
	Date:   Fri Mar 14 21:52:08 2014 +0530

	    cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v3.15
---

 drivers/infiniband/hw/cxgb4/device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index cbcb72d..7db82b2 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -696,6 +696,7 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 		pr_err(MOD "error allocating status page\n");
 		goto err4;
 	}
+	rdev->status_page->db_off = 0;
 	return 0;
 err4:
 	c4iw_rqtpool_destroy(rdev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
