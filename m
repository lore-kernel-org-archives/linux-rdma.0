From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 03/11] IB/umad: Enable support only for IB ports
Date: Thu, 18 Feb 2010 19:23:54 +0200
Message-ID: <20100218172354.GD12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initialize umad context only for Infiniband (as opposed to Ethernet) ports.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7de0296..e962c5a 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1138,8 +1138,9 @@ static void ib_umad_add_one(struct ib_device *device)
 	for (i = s; i <= e; ++i) {
 		umad_dev->port[i - s].umad_dev = umad_dev;
 
-		if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
-			goto err;
+		if (rdma_port_link_layer(device, i) == IB_LINK_LAYER_INFINIBAND)
+			if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
+				goto err;
 	}
 
 	ib_set_client_data(device, &umad_client, umad_dev);
@@ -1148,7 +1149,8 @@ static void ib_umad_add_one(struct ib_device *device)
 
 err:
 	while (--i >= s)
-		ib_umad_kill_port(&umad_dev->port[i - s]);
+		if (rdma_port_link_layer(device, i) == IB_LINK_LAYER_INFINIBAND)
+			ib_umad_kill_port(&umad_dev->port[i - s]);
 
 	kref_put(&umad_dev->ref, ib_umad_release_dev);
 }
@@ -1162,7 +1164,8 @@ static void ib_umad_remove_one(struct ib_device *device)
 		return;
 
 	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
-		ib_umad_kill_port(&umad_dev->port[i]);
+		if (rdma_port_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+			ib_umad_kill_port(&umad_dev->port[i]);
 
 	kref_put(&umad_dev->ref, ib_umad_release_dev);
 }
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
