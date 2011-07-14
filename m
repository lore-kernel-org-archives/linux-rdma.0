From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Questions regarding CMA
Date: Thu, 14 Jul 2011 10:58:29 +0300
Message-ID: <201107141058.29879.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I am currently reviewing/cleaning up our CMA LAP patches for submission.

I have several questions regarding the file cma.c, which I would like you to clarify for me.

1. In procedure cma_ib_listen (and elsewhere), if the call to ib_create_cm_id fails,
   id_priv->cm_id.ib is left with the (non-zero) error value instead of NULL.
   However, if there is a failure later in the procedure, you set id_priv->cm_id.ib to NULL.

   Is there a reason for this difference in behavior? 
   (code snippet from current code is below)
	int cma_ib_listen(struct rdma_id_

       		id_priv->cm_id.ib = ib_create_cm_id(id_priv->id.device, cma_req_handler,
                                            	    id_priv);
	       	if (IS_ERR(id_priv->cm_id.ib))
               		return PTR_ERR(id_priv->cm_id.ib);

		....
	        if (ret) {
                	ib_destroy_cm_id(id_priv->cm_id.ib);
                	id_priv->cm_id.ib = NULL;
        	}

   
2. procedure cma_has_cm_dev looks as follows:

	static int cma_has_cm_dev(struct rdma_id_private *id_priv)
	{
		return (id_priv->id.device && id_priv->cm_id.ib);
	}

   Shouldn't the line be:
		return (id_priv->id.device && id_priv->cm_id.ib &&
			!IS_ERR(id_priv->cm_id.ib));

3. There are several places where the value of id_priv->cm_id.ib
   is checked to be not NULL.

   Wouldn't it be better to call cma_has_cm_dev in these places
   (when cma_has_cm_dev has been fixed, as I suggested in 2 above).
		
Please consider the patch below as a starting point (I did not touch the iwarp code).
Please let me know (ASAP) what you think.
(I still leave a window here where id_priv->cm_id.ib is ERR. Is this a problem?
 Would it be better to use a local variable instead of id_priv->cm_id.ib, and
 only assign to id_priv->cm_id.ib when all the error checks have passed?
 This would leave a window where a successful cm_id creation is not immediately assigned
 to the CMA object -- would this be a problem?).

Thanks!

-Jack
====================================================================
--- cma.c	2011-07-13 09:54:09.000000000 +0300
+++ cma_fixed.c	2011-07-14 10:51:23.000000000 +0300
@@ -424,7 +424,8 @@ static int cma_disable_callback(struct r
 
 static int cma_has_cm_dev(struct rdma_id_private *id_priv)
 {
-	return (id_priv->id.device && id_priv->cm_id.ib);
+	return (id_priv->id.device && id_priv->cm_id.ib &&
+		!IS_ERR(id_priv->cm_id.ib));
 }
 
 struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
@@ -658,7 +659,7 @@ int rdma_init_qp_attr(struct rdma_cm_id 
 	id_priv = container_of(id, struct rdma_id_private, id);
 	switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
 	case RDMA_TRANSPORT_IB:
-		if (!id_priv->cm_id.ib || cma_is_ud_ps(id_priv->id.ps))
+		if (!cma_has_cm_dev(id_priv) || cma_is_ud_ps(id_priv->id.ps))
 			ret = cma_ib_init_qp_attr(id_priv, qp_attr, qp_attr_mask);
 		else
 			ret = ib_cm_init_qp_attr(id_priv->cm_id.ib, qp_attr,
@@ -918,7 +919,7 @@ void rdma_destroy_id(struct rdma_cm_id *
 	if (id_priv->cma_dev) {
 		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
 		case RDMA_TRANSPORT_IB:
-			if (id_priv->cm_id.ib && !IS_ERR(id_priv->cm_id.ib))
+			if (cma_has_cm_dev(id_priv))
 				ib_destroy_cm_id(id_priv->cm_id.ib);
 			break;
 		case RDMA_TRANSPORT_IWARP:
@@ -1471,8 +1472,10 @@ static int cma_ib_listen(struct rdma_id_
 
 	id_priv->cm_id.ib = ib_create_cm_id(id_priv->id.device, cma_req_handler,
 					    id_priv);
-	if (IS_ERR(id_priv->cm_id.ib))
-		return PTR_ERR(id_priv->cm_id.ib);
+	if (IS_ERR(id_priv->cm_id.ib)) {
+		ret = PTR_ERR(id_priv->cm_id.ib);
+		goto out;
+	}
 
 	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
 	svc_id = cma_get_service_id(id_priv->id.ps, addr);
@@ -1482,9 +1485,10 @@ static int cma_ib_listen(struct rdma_id_
 		cma_set_compare_data(id_priv->id.ps, addr, &compare_data);
 		ret = ib_cm_listen(id_priv->cm_id.ib, svc_id, 0, &compare_data);
 	}
-
+out:
 	if (ret) {
-		ib_destroy_cm_id(id_priv->cm_id.ib);
+		if (!IS_ERR(id_priv->cm_id.ib))
+			ib_destroy_cm_id(id_priv->cm_id.ib);
 		id_priv->cm_id.ib = NULL;
 	}
 
@@ -2454,11 +2458,12 @@ static int cma_resolve_ib_udp(struct rdm
 	req.max_cm_retries = CMA_MAX_CM_RETRIES;
 
 	ret = ib_send_cm_sidr_req(id_priv->cm_id.ib, &req);
+out:
 	if (ret) {
-		ib_destroy_cm_id(id_priv->cm_id.ib);
+		if (!IS_ERR(id_priv->cm_id.ib))
+			ib_destroy_cm_id(id_priv->cm_id.ib);
 		id_priv->cm_id.ib = NULL;
 	}
-out:
 	kfree(req.private_data);
 	return ret;
 }
@@ -2516,8 +2521,9 @@ static int cma_connect_ib(struct rdma_id
 
 	ret = ib_send_cm_req(id_priv->cm_id.ib, &req);
 out:
-	if (ret && !IS_ERR(id_priv->cm_id.ib)) {
-		ib_destroy_cm_id(id_priv->cm_id.ib);
+	if (ret) {
+	      	if (!IS_ERR(id_priv->cm_id.ib))
+			ib_destroy_cm_id(id_priv->cm_id.ib);
 		id_priv->cm_id.ib = NULL;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
