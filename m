From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 14/20 v2] rdma/cm: Support XRC QPs
Date: Fri, 19 Aug 2011 02:14:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A6D@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow users to connect XRC QPs through the rdma_cm.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9f1d44d..1aa8e96 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2567,7 +2567,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.service_id = cma_get_service_id(id_priv->id.ps,
 					    (struct sockaddr *) &route->addr.dst_addr);
 	req.qp_num = id_priv->qp_num;
-	req.qp_type = IB_QPT_RC;
+	req.qp_type = id_priv->id.qp_type;
 	req.starting_psn = id_priv->seq_num;
 	req.responder_resources = conn_param->responder_resources;
 	req.initiator_depth = conn_param->initiator_depth;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
