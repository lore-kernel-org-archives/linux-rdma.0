From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>
Subject: [PATCH 1/3] iw_cxgb4: initialize ibdev.iwcm->ifname for port mapping
Date: Tue, 12 Apr 2016 06:54:54 -0700
Message-ID: <20160412143037.33CD0E08CA@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The IWCM uses ibdev.iwcm->ifname for registration with the iwarp
port map daemon.  But iw_cxgb4 did not initialize this field which
causes intermittent registration failures based on the contents of the
uninitialized memory.

Fixes: 170003c894d9 ("iw_cxgb4: remove port mapper related code")
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 124682d..7574f394 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -580,6 +580,8 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.iwcm->add_ref = c4iw_qp_add_ref;
 	dev->ibdev.iwcm->rem_ref = c4iw_qp_rem_ref;
 	dev->ibdev.iwcm->get_qp = c4iw_get_qp;
+	memcpy(dev->ibdev.iwcm->ifname, dev->rdev.lldi.ports[0]->name,
+	       sizeof(dev->ibdev.iwcm->ifname));
 
 	ret = ib_register_device(&dev->ibdev, NULL);
 	if (ret)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
