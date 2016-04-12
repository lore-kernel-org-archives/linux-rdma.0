From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/3] iw_cxgb3: initialize ibdev.iwcm->ifname for port mapping
Date: Tue, 12 Apr 2016 06:55:01 -0700
Message-ID: <20160412143039.41AB3E08CA@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The IWCM uses ibdev.iwcm->ifname for registration with the iwarp
port map daemon.  But iw_cxgb3 did not initialize this field which
causes intermittent registration failures based on the contents of the
uninitialized memory.

Fixes: c1340e8aa628 ("iw_cxgb3: support for iWARP port mapping")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 1423538..608aa0c 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1389,6 +1389,8 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.iwcm->add_ref = iwch_qp_add_ref;
 	dev->ibdev.iwcm->rem_ref = iwch_qp_rem_ref;
 	dev->ibdev.iwcm->get_qp = iwch_get_qp;
+	memcpy(dev->ibdev.iwcm->ifname, dev->rdev.t3cdev_p->lldev->name,
+	       sizeof(dev->ibdev.iwcm->ifname));
 
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
