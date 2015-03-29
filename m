From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/18] IB/iser: Fix unload during ep_poll wrong dereference
Date: Sun, 29 Mar 2015 15:45:15 +0300
Message-ID: <1427633132-23910-2-git-send-email-sagig@mellanox.com>
References: <1427633132-23910-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427633132-23910-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In case the user unloaded ib_iser while ep_connect is in
progress, we need to destroy the endpoint although ep_disconnect
wasn't invoked (we detect this by the iser conn state != DOWN).
However, if we got an REJECTED/UNREACHABLE CM event we move the
connection state to DOWN which will prevent us from destroying
the endpoint in the module unload stage. Fix this by setting the
connection state to TERMINATING in iser_conn_error so we can still
destroy the endpoint at unload stage.

Reported-by: Ariel Nahum <arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 4065abe..070c5af 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -721,7 +721,7 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
 	struct iser_conn *iser_conn;
 
 	iser_conn = (struct iser_conn *)cma_id->context;
-	iser_conn->state = ISER_CONN_DOWN;
+	iser_conn->state = ISER_CONN_TERMINATING;
 }
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
