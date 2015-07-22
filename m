From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH] IB/ipoib: Fix CONFIG_INFINIBAND_IPOIB_CM
Date: Wed, 22 Jul 2015 14:30:03 -0600
Message-ID: <20150722203003.GA9613@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the above is turned off then ipoib_cm_dev_init unconditionally
returns ENOSYS, and the newly added error handling in
0b3957 prevents ipoib from coming up at all:

kernel: mlx4_0: ipoib_transport_dev_init failed
kernel: mlx4_0: failed to initialize port 1 (ret = -12)

Fixes: 0b39578bcde4 (IB/ipoib: Use dedicated workqueues per interface)
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 9e6ee82a8fd7..851c8219d501 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -177,7 +177,8 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		else
 			size += ipoib_recvq_size * ipoib_max_conn_qp;
 	} else
-		goto out_free_wq;
+		if (ret != -ENOSYS)
+			goto out_free_wq;
 
 	cq_attr.cqe = size;
 	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
