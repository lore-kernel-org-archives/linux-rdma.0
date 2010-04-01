From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/26] rdma/cm: only listen on IB devices when using AF_IB
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <1FC8ACF0790D47FDA952402C21D3521A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If an rdma_cm_id is bound to AF_IB, with a wild card address,
only listen on IB devices.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b3188fc..8e22119 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1534,6 +1534,10 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	struct rdma_cm_id *id;
 	int ret;
 
+	if (id_priv->id.route.addr.src_addr.ss_family == AF_IB &&
+	    rdma_node_get_transport(cma_dev->device->node_type) != RDMA_TRANSPORT_IB)
+		return;
+
 	id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
 			    id_priv->id.qp_type);
 	if (IS_ERR(id))



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
