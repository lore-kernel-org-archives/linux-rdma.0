From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] [PATCH 17/22] [for 2.6.36] rdma/cm: export cma_get_service_id
Date: Tue, 23 Mar 2010 11:20:18 -0700
Message-ID: <46F13FF178CB42828B63852AEAB3CC25@amr.corp.intel.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2F3826558E79459EAD2A457A604221C1-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow the rdma_ucm to query the IB service ID formed or
allocated by the rdma_cm by exporting the cma_get_service_id
functionality.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   19 ++++++++++---------
 include/rdma/rdma_cm.h        |    7 +++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index c5bb70c..1d64342 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1256,13 +1256,14 @@ out:
 	return ret;
 }
 
-static __be64 cma_get_service_id(enum rdma_port_space ps, struct sockaddr *addr)
+__be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr)
 {
 	if (addr->sa_family == AF_IB)
 		return ((struct sockaddr_ib *) addr)->sib_sid;
 
-	return cpu_to_be64(((u64)ps << 16) + be16_to_cpu(cma_port(addr)));
+	return cpu_to_be64(((u64)id->ps << 16) + be16_to_cpu(cma_port(addr)));
 }
+EXPORT_SYMBOL(rdma_get_service_id);
 
 static void cma_set_compare_data(enum rdma_port_space ps, struct sockaddr *addr,
 				 struct ib_cm_compare_data *compare)
@@ -1478,7 +1479,7 @@ static int cma_ib_listen(struct rdma_id_private *id_priv)
 		return PTR_ERR(id_priv->cm_id.ib);
 
 	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
-	svc_id = cma_get_service_id(id_priv->id.ps, addr);
+	svc_id = rdma_get_service_id(&id_priv->id, addr);
 	if (cma_any_addr(addr))
 		ret = ib_cm_listen(id_priv->cm_id.ib, svc_id, 0, NULL);
 	else {
@@ -1659,8 +1660,8 @@ static int cma_query_ib_route(struct rdma_id_private *id_priv, int timeout_ms,
 	path_rec.pkey = cpu_to_be16(ib_addr_get_pkey(&addr->dev_addr));
 	path_rec.numb_path = 1;
 	path_rec.reversible = 1;
-	path_rec.service_id = cma_get_service_id(id_priv->id.ps,
-						 (struct sockaddr *) &addr->dst_addr);
+	path_rec.service_id = rdma_get_service_id(&id_priv->id,
+						  (struct sockaddr *) &addr->dst_addr);
 
 	comp_mask = IB_SA_PATH_REC_DGID | IB_SA_PATH_REC_SGID |
 		    IB_SA_PATH_REC_PKEY | IB_SA_PATH_REC_NUMB_PATH |
@@ -2478,8 +2479,8 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 	}
 
 	req.path = route->path_rec;
-	req.service_id = cma_get_service_id(id_priv->id.ps,
-					    (struct sockaddr *) &route->addr.dst_addr);
+	req.service_id = rdma_get_service_id(&id_priv->id,
+					     (struct sockaddr *) &route->addr.dst_addr);
 	req.timeout_ms = 1 << (CMA_CM_RESPONSE_TIMEOUT - 8);
 	req.max_cm_retries = CMA_MAX_CM_RETRIES;
 
@@ -2529,8 +2530,8 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	if (route->num_paths == 2)
 		req.alternate_path = &route->path_rec[1];
 
-	req.service_id = cma_get_service_id(id_priv->id.ps,
-					    (struct sockaddr *) &route->addr.dst_addr);
+	req.service_id = rdma_get_service_id(&id_priv->id,
+					     (struct sockaddr *) &route->addr.dst_addr);
 	req.qp_num = id_priv->qp_num;
 	req.qp_type = IB_QPT_RC;
 	req.starting_psn = id_priv->seq_num;
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c6b2962..ffc544f 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -330,4 +330,11 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr);
  */
 void rdma_set_service_type(struct rdma_cm_id *id, int tos);
 
+/**
+ * rdma_get_service_id - Return the IB service ID for a specified address.
+ * @id: Communication identifier associated with the address.
+ * @addr: Address for the service ID.
+ */
+__be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr);
+
 #endif /* RDMA_CM_H */



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
