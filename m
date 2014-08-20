From: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] IB/ipoib: remove unnecessary port query
Date: Wed, 20 Aug 2014 11:15:08 -0400
Message-ID: <20140820151508.14287.53954.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There are two queries for port attributes going one
after another. A second call is not needed since port_attr
structure already holds the data.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index d4e0057..ffb83b5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -529,21 +529,13 @@ void ipoib_mcast_join_task(struct work_struct *work)
 			  port_attr.state);
 		return;
 	}
+	priv->local_lid = port_attr.lid;
 
 	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid))
 		ipoib_warn(priv, "ib_query_gid() failed\n");
 	else
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
 
-	{
-		struct ib_port_attr attr;
-
-		if (!ib_query_port(priv->ca, priv->port, &attr))
-			priv->local_lid = attr.lid;
-		else
-			ipoib_warn(priv, "ib_query_port failed\n");
-	}
-
 	if (!priv->broadcast) {
 		struct ipoib_mcast *broadcast;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
