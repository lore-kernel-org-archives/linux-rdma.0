From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/ipoib: Fix for potential no-carrier state
Date: Thu, 01 Feb 2018 10:55:41 -0800
Message-ID: <20180201185533.9091.17941.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On reboot SM can program port pkey table before ipoib registered its
event handler, which could result in missing pkey event and leave root
interface with initial pkey value from index 0.

Since OPA port starts with invalid pkey in index 0, root interface will
fail to initialize and stay down with no-carrier flag.

For IB ipoib interface may end up with pkey different from value
opensm put in pkey table idx 0, resulting in connectivity issues
(different mcast groups, for example).

Close the window by calling event handler after registration
to make sure ipoib pkey is in sync with port pkey table.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 5930c7d..161ba8c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2306,6 +2306,9 @@ void ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 			      priv->ca, ipoib_event);
 	ib_register_event_handler(&priv->event_handler);
 
+	/* call event handler to ensure pkey in sync */
+	queue_work(ipoib_workqueue, &priv->flush_heavy);
+
 	result = register_netdev(priv->dev);
 	if (result) {
 		pr_warn("%s: couldn't register ipoib port %d; error %d\n",

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
