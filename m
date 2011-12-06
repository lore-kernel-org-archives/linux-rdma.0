From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] rdma/core: Fix sparse errors
Date: Tue, 6 Dec 2011 21:15:18 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325653870@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix errors reported by sparse in the rdma core stack.  Note that these
are real bugs, but don't affect any existing code to the best of my
knowledge.  The mlid issue would only affect kernel users of
rdma_join_multicast which have the rdma_cm attach/detach its QP.
There are no current in tree users that do this. (rdma_join_multicast
may be used called by user space applications, which does not have
this issue.)  And the pkey setting is simply returned as informational.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
please queue for 3.3

 drivers/infiniband/core/cma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 75ff821..c3a0c62 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1110,7 +1110,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	if (cma_any_addr((struct sockaddr *) &rt->addr.src_addr)) {
 		rt->addr.dev_addr.dev_type = ARPHRD_INFINIBAND;
 		rdma_addr_set_sgid(&rt->addr.dev_addr, &rt->path_rec[0].sgid);
-		ib_addr_set_pkey(&rt->addr.dev_addr, rt->path_rec[0].pkey);
+		ib_addr_set_pkey(&rt->addr.dev_addr, be16_to_cpu(rt->path_rec[0].pkey));
 	} else {
 		ret = rdma_translate_ip((struct sockaddr *) &rt->addr.src_addr,
 					&rt->addr.dev_addr);
@@ -2920,7 +2920,7 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	mutex_lock(&id_priv->qp_mutex);
 	if (!status && id_priv->id.qp)
 		status = ib_attach_mcast(id_priv->id.qp, &multicast->rec.mgid,
-					 multicast->rec.mlid);
+					 be16_to_cpu(multicast->rec.mlid));
 	mutex_unlock(&id_priv->qp_mutex);
 
 	memset(&event, 0, sizeof event);
@@ -3181,7 +3181,7 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 			if (id->qp)
 				ib_detach_mcast(id->qp,
 						&mc->multicast.ib->rec.mgid,
-						mc->multicast.ib->rec.mlid);
+						be16_to_cpu(mc->multicast.ib->rec.mlid));
 			if (rdma_node_get_transport(id_priv->cma_dev->device->node_type) == RDMA_TRANSPORT_IB) {
 				switch (rdma_port_get_link_layer(id->device, id->port_num)) {
 				case IB_LINK_LAYER_INFINIBAND:


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
