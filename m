From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv9 01/12] IB/umad: Enable support only for IB ports
Date: Fri, 6 Aug 2010 17:34:55 +0300
Message-ID: <20100806143455.GB20588@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initialize umad context only for Infiniband (as opposed to Ethernet) ports.
Since the only ULP using QP1 is the CM and since all protocol traffic is done
in kernel, we do not expose QP1 to userspace.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 6babb72..8b6e8a2 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -1149,8 +1149,9 @@ static void ib_umad_add_one(struct ib_device *device)
 	for (i = s; i <= e; ++i) {
 		umad_dev->port[i - s].umad_dev = umad_dev;
 
-		if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
-			goto err;
+		if (rdma_port_get_link_layer(device, i) == IB_LINK_LAYER_INFINIBAND)
+			if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
+				goto err;
 	}
 
 	ib_set_client_data(device, &umad_client, umad_dev);
@@ -1159,7 +1160,8 @@ static void ib_umad_add_one(struct ib_device *device)
 
 err:
 	while (--i >= s)
-		ib_umad_kill_port(&umad_dev->port[i - s]);
+		if (rdma_port_get_link_layer(device, i) == IB_LINK_LAYER_INFINIBAND)
+			ib_umad_kill_port(&umad_dev->port[i - s]);
 
 	kref_put(&umad_dev->ref, ib_umad_release_dev);
 }
@@ -1173,7 +1175,8 @@ static void ib_umad_remove_one(struct ib_device *device)
 		return;
 
 	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
-		ib_umad_kill_port(&umad_dev->port[i]);
+		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+			ib_umad_kill_port(&umad_dev->port[i]);
 
 	kref_put(&umad_dev->ref, ib_umad_release_dev);
 }
-- 
1.7.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
