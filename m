From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 3/3] iw_cxgb4: remove the stid on listen create failure
Date: Tue, 5 Sep 2017 11:52:34 -0700
Message-ID: <20170915140822.B0E2DE0C1D@smtp.ogc.us>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index d76bfe3..ca846fb 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3463,7 +3463,7 @@ int c4iw_create_listen(struct iw_cm_id *cm_id, int backlog)
 		cm_id->provider_data = ep;
 		goto out;
 	}
-
+	remove_handle(ep->com.dev, &ep->com.dev->stid_idr, ep->stid);
 	cxgb4_free_stid(ep->com.dev->rdev.lldi.tids, ep->stid,
 			ep->com.local_addr.ss_family);
 fail2:
-- 
1.8.3.1
