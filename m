From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RESEND V2 for-next 2/5] IB/core: Fixes in ib_sa_add_one error flow
Date: Thu,  5 Feb 2015 13:35:41 +0200
Message-ID: <1423136144-12784-3-git-send-email-ogerlitz@mellanox.com>
References: <1423136144-12784-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423136144-12784-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fixed off-by-one bug, we need to decrement the port number only after we
released the resources to the current port.

Call ib_unregister_mad_agent only for cases where ib_register_mad_agent succeeded.

Separate the ib_register_event_handler() call error flow from the loop error
flow. If the call to ib_register_event_handler fails, the client data must be
reset to NULL, (in case at some point ib_register_event_handler() is modified so
that it may return a non-zero (error) value).

issue: none
Change-Id: Ia79a2d5037f674d67d75494c620b5c197da86314
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c38f030..80461af 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1202,7 +1202,7 @@ static void ib_sa_add_one(struct ib_device *device)
 
 	INIT_IB_EVENT_HANDLER(&sa_dev->event_handler, device, ib_sa_event);
 	if (ib_register_event_handler(&sa_dev->event_handler))
-		goto err;
+		goto reg_err;
 
 	for (i = 0; i <= e - s; ++i)
 		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
@@ -1210,9 +1210,13 @@ static void ib_sa_add_one(struct ib_device *device)
 
 	return;
 
+reg_err:
+	ib_set_client_data(device, &sa_client, NULL);
+	i = e - s;
 err:
-	while (--i >= 0)
-		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND)
+	for (; i >= 0; --i)
+		if (rdma_port_get_link_layer(device, i + 1) == IB_LINK_LAYER_INFINIBAND &&
+		    !IS_ERR(sa_dev->port[i].agent))
 			ib_unregister_mad_agent(sa_dev->port[i].agent);
 
 	kfree(sa_dev);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
