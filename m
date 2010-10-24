From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Fix unneeded return error in eth_link_query_port
Date: Sun, 24 Oct 2010 09:58:35 +0200
Message-ID: <20101024075835.GA11359@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

eth_link_query_port() returns error if a netdevice was not yet associated with
the IBoE port. This is not required since we already initialize the link as
down.  On the other hand, we need other information that the query provides.
Specifically, this can cause a failure to initilize an IBoE device after this
commit 5eb620c8, which calls ib_query_port().
Fix this by always returning success.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 30cd111..bf3e20c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -217,7 +217,6 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 {
 	struct mlx4_ib_iboe *iboe = &to_mdev(ibdev)->iboe;
 	struct net_device *ndev;
-	int err = 0;
 	enum ib_mtu tmp;
 
 	props->active_width	= IB_WIDTH_4X;
@@ -237,10 +236,8 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->active_mtu	= IB_MTU_256;
 	spin_lock(&iboe->lock);
 	ndev = iboe->netdevs[port - 1];
-	if (!ndev) {
-		err = -ENOMEM;
+	if (!ndev)
 		goto out;
-	}
 
 	tmp = iboe_get_mtu(ndev->mtu);
 	props->active_mtu = tmp ? min(props->max_mtu, tmp) : IB_MTU_256;
@@ -251,7 +248,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 
 out:
 	spin_unlock(&iboe->lock);
-	return err;
+	return 0;
 }
 
 static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
-- 
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
