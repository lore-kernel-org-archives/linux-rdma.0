From: "Arlin Davis" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2: ucm: modify IB address format to align better with sockaddr_in6
Date: Fri, 2 Oct 2009 14:50:03 -0700
Message-ID: <D047C39902BE4F298B02964BE3362EAF@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Restructure the dcm_addr union to map the IB side
closer to sockaddr6 and initialize family to
AF_INET6 to insure callee allocates enough memory
for ucm dat_ia_address type. Put qpn in flowinfo,
lid in port, and gid in addr. Change the test suites
to print address information based on AF_INET
or AF_INET6 instead of using specific IB address
union from the provider.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |   22 ++++++++-----
 dapl/openib_scm/cm.c                |   34 +++++++++-----------
 dapl/openib_ucm/cm.c                |   51 +++++++++++-------------------
 dapl/openib_ucm/device.c            |   15 +++++----
 test/dtest/dtest.c                  |   59 +++++++++++++++++------------------
 test/dtest/dtestcm.c                |   59 ++++++++++++++++++-----------------
 test/dtest/dtestx.c                 |   57 +++++++++++++++++----------------
 7 files changed, 143 insertions(+), 154 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 671073b..0436da7 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -61,24 +61,28 @@ typedef ib_hca_handle_t		dapl_ibal_ca_t;
 #define DCM_VER 5
 
 /* CM private data areas, same for all operations */
-#define        DCM_MAX_PDATA_SIZE      128
+#define        DCM_MAX_PDATA_SIZE      118
 
 /*
- * DAPL IB/QP address (type, port, lid, qp_num, gid) mapping to
- * DAT_IA_ADDRESS_PTR, DAT_SOCK_ADDR2 (24 bytes)
+ * UCM DAPL IB/QP address (lid, qp_num, gid) mapping to
+ * DAT_IA_ADDRESS_PTR, DAT_SOCK_ADDR2 (28 bytes)
  * For applications, like MPI, that exchange IA_ADDRESS
  * across the fabric before connecting, it eliminates the
  * overhead of name and address resolution to the destination's
- * CM services. UCM provider uses this for DAT_IA_ADDRESS.
+ * CM services. UCM provider uses the following for 
+ * DAT_IA_ADDRESS. Note: family == AF_INET6 to insure proper
+ * callee storage for address.
  */
 union dcm_addr {
        DAT_SOCK_ADDR6          so;
        struct {
-               uint8_t         qp_type;
-               uint8_t         port_num;
-               uint16_t        lid;
-               uint32_t        qpn;
-               union ibv_gid   gid;
+		uint16_t	family;  /* sin6_family */
+		uint16_t	lid;     /* sin6_port */
+		uint32_t	qpn;     /* sin6_flowinfo */
+		uint8_t	gid[16]; /* sin6_addr */
+		uint16_t	port;    /* sin6_scope_id */
+		uint8_t	sl;
+		uint8_t	qp_type;
        } ib;
 };
 
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index dae1781..9a7bbd6 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -488,18 +488,17 @@ static void dapli_socket_connected(dp_ib_cm_handle_t cm_ptr, int err)
 	}
 
  	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " CONN_PENDING: sending SRC port=%d lid=0x%x,"
+		     " CONN_PENDING: sending SRC lid=0x%x,"
 		     " qpn=0x%x, psize=%d\n",
-		     cm_ptr->msg.saddr.ib.port_num, 
 		     ntohs(cm_ptr->msg.saddr.ib.lid),
 		     ntohl(cm_ptr->msg.saddr.ib.qpn), 
 		     ntohs(cm_ptr->msg.p_size));
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " CONN_PENDING: SRC GID subnet %016llx id %016llx\n",
 		     (unsigned long long)
-		     htonll(cm_ptr->msg.saddr.ib.gid.global.subnet_prefix),
+		     htonll(*(uint64_t*)&cm_ptr->msg.saddr.ib.gid[0]),
 		     (unsigned long long)
-		     htonll(cm_ptr->msg.saddr.ib.gid.global.interface_id));
+		     htonll(*(uint64_t*)&cm_ptr->msg.saddr.ib.gid[8]));
 	return;
 
 bail:
@@ -561,10 +560,10 @@ dapli_socket_connect(DAPL_EP * ep_ptr,
 	cm_ptr->msg.op = ntohs(DCM_REQ);
 	cm_ptr->msg.saddr.ib.qpn = htonl(ep_ptr->qp_handle->qp_num);
 	cm_ptr->msg.saddr.ib.qp_type = ep_ptr->qp_handle->qp_type;
-	cm_ptr->msg.saddr.ib.port_num = ia_ptr->hca_ptr->port_num;
 	cm_ptr->msg.saddr.ib.lid = ia_ptr->hca_ptr->ib_trans.lid;
-	cm_ptr->msg.saddr.ib.gid = ia_ptr->hca_ptr->ib_trans.gid;
-
+	dapl_os_memcpy(&cm_ptr->msg.saddr.ib.gid[0], 
+		       &ia_ptr->hca_ptr->ib_trans.gid, 16);
+	
 	/* save references */
 	cm_ptr->hca = ia_ptr->hca_ptr;
 	cm_ptr->ep = ep_ptr;
@@ -638,13 +637,12 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 		       sizeof(union dcm_addr));
 
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " CONN_RTU: DST %s %d port=0x%x lid=0x%x,"
+		     " CONN_RTU: DST %s %d lid=0x%x,"
 		     " qpn=0x%x, qp_type=%d, psize=%d\n",
 		     inet_ntoa(((struct sockaddr_in *)
 				&cm_ptr->msg.daddr.so)->sin_addr),
 		     ntohs(((struct sockaddr_in *)
 				&cm_ptr->msg.daddr.so)->sin_port),
-		     cm_ptr->msg.saddr.ib.port_num, 
 		     ntohs(cm_ptr->msg.saddr.ib.lid),
 		     ntohl(cm_ptr->msg.saddr.ib.qpn), 
 		     cm_ptr->msg.saddr.ib.qp_type, 
@@ -967,12 +965,11 @@ static void dapli_socket_accept_data(ib_cm_srvc_handle_t acm_ptr)
 	acm_ptr->state = DCM_ACCEPTING_DATA;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " ACCEPT: DST %s %d port=%d lid=0x%x, qpn=0x%x, psz=%d\n",
+		     " ACCEPT: DST %s %d lid=0x%x, qpn=0x%x, psz=%d\n",
 		     inet_ntoa(((struct sockaddr_in *)
 				&acm_ptr->msg.daddr.so)->sin_addr), 
 		     ntohs(((struct sockaddr_in *)
 			     &acm_ptr->msg.daddr.so)->sin_port),
-		     acm_ptr->msg.saddr.ib.port_num, 
 		     ntohs(acm_ptr->msg.saddr.ib.lid), 
 		     ntohl(acm_ptr->msg.saddr.ib.qpn), exp);
 
@@ -1026,9 +1023,8 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 		return DAT_INTERNAL_ERROR;
 
 	dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     " ACCEPT_USR: remote port=%d lid=0x%x"
+		     " ACCEPT_USR: remote lid=0x%x"
 		     " qpn=0x%x qp_type %d, psize=%d\n",
-		     cm_ptr->msg.saddr.ib.port_num, 
 		     ntohs(cm_ptr->msg.saddr.ib.lid),
 		     ntohl(cm_ptr->msg.saddr.ib.qpn), 
 		     cm_ptr->msg.saddr.ib.qp_type, 
@@ -1084,9 +1080,9 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 	local.op = htons(DCM_REP);
 	local.saddr.ib.qpn = htonl(ep_ptr->qp_handle->qp_num);
 	local.saddr.ib.qp_type = ep_ptr->qp_handle->qp_type;
-	local.saddr.ib.port_num = ia_ptr->hca_ptr->port_num;
 	local.saddr.ib.lid = ia_ptr->hca_ptr->ib_trans.lid;
-	local.saddr.ib.gid = ia_ptr->hca_ptr->ib_trans.gid;
+	dapl_os_memcpy(&local.saddr.ib.gid[0], 
+		       &ia_ptr->hca_ptr->ib_trans.gid, 16);
 	local.daddr.so = ia_ptr->hca_ptr->hca_address;
 	((struct sockaddr_in *)&local.daddr.so)->sin_port = 
 				htons((uint16_t)cm_ptr->sp->conn_qual);
@@ -1115,15 +1111,15 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 	}
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " ACCEPT_USR: local port=%d lid=0x%x qpn=0x%x psz=%d\n",
-		     local.saddr.ib.port_num, ntohs(local.saddr.ib.lid),
+		     " ACCEPT_USR: local lid=0x%x qpn=0x%x psz=%d\n",
+		     ntohs(local.saddr.ib.lid),
 		     ntohl(local.saddr.ib.qpn), ntohs(local.p_size));
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " ACCEPT_USR: SRC GID subnet %016llx id %016llx\n",
 		     (unsigned long long)
-		     htonll(local.saddr.ib.gid.global.subnet_prefix),
+		     htonll(*(uint64_t*)&local.saddr.ib.gid[0]),
 		     (unsigned long long)
-		     htonll(local.saddr.ib.gid.global.interface_id));
+		     htonll(*(uint64_t*)&local.saddr.ib.gid[8]));
 
 	dapl_dbg_log(DAPL_DBG_TYPE_EP, " PASSIVE: accepted!\n");
 	return DAT_SUCCESS;
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index e76e920..4dc67c9 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -573,9 +573,9 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 		cm->msg.sqpn = htonl(hca->ib_trans.qp->qp_num); /* ucm */
 		cm->msg.saddr.ib.qpn = htonl(ep->qp_handle->qp_num); /* ep */
 		cm->msg.saddr.ib.qp_type = ep->qp_handle->qp_type;
-		cm->msg.saddr.ib.port_num = hca->port_num;
                 cm->msg.saddr.ib.lid = hca->ib_trans.addr.ib.lid; 
-		cm->msg.saddr.ib.gid = hca->ib_trans.addr.ib.gid; 
+		dapl_os_memcpy(&cm->msg.saddr.ib.gid[0], 
+			       &hca->ib_trans.addr.ib.gid, 16);
         }
 	return cm;
 bail:
@@ -857,9 +857,9 @@ static void ucm_connect_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 	}
 		
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " CONN_RTU: DST port=%d lid=%x,"
+		     " CONN_RTU: DST lid=%x,"
 		     " iqp=%x, qp_type=%d, port=%d psize=%d\n",
-		     cm->msg.daddr.ib.port_num, ntohs(cm->msg.daddr.ib.lid),
+		     ntohs(cm->msg.daddr.ib.lid),
 		     ntohl(cm->msg.daddr.ib.qpn), cm->msg.daddr.ib.qp_type,
 		     ntohs(msg->sport), ntohs(msg->p_size));
 
@@ -958,22 +958,16 @@ ud_bail:
 			     " ACTIVE: UD xevent ah %p qpn 0x%x lid 0x%x\n",
 			     xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
 		dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     	     " ACTIVE: UD xevent ia_addr qp_type %d, port %d"
+		     	     " ACTIVE: UD xevent ia_addr qp_type %d"
 			     " lid 0x%x qpn 0x%x gid 0x"F64x" 0x"F64x" \n",
 			     ((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.qp_type,
-			     ((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->ib.port_num,
 			     ntohs(((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.lid),
 			     ntohl(((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.qpn),
-			     ntohll(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->
-					ib.gid.global.subnet_prefix),
-			     ntohll(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->
-					ib.gid.global.interface_id));
+			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[0]),
+			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[8]));
 
 		if (event == IB_CME_CONNECTED)
 			event = DAT_IB_UD_CONNECTION_EVENT_ESTABLISHED;
@@ -1137,22 +1131,16 @@ static void ucm_accept_rtu(dp_ib_cm_handle_t cm, ib_cm_msg_t *msg)
 			     " PASSIVE: UD xevent ah %p qpn 0x%x lid 0x%x\n",
 			     xevent.remote_ah.ah, xevent.remote_ah.qpn, lid);
 		dapl_dbg_log(DAPL_DBG_TYPE_EP,
-		     	     " PASSIVE: UD xevent ia_addr qp_type %d, port %d"
+		     	     " PASSIVE: UD xevent ia_addr qp_type %d"
 			     " lid 0x%x qpn 0x%x gid 0x"F64x" 0x"F64x" \n",
 			     ((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.qp_type,
-			     ((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->ib.port_num,
 			     ntohs(((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.lid),
 			     ntohl(((union dcm_addr*)
 				&xevent.remote_ah.ia_addr)->ib.qpn),
-			     ntohll(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->
-					ib.gid.global.subnet_prefix),
-			     ntohll(((union dcm_addr*)
-				&xevent.remote_ah.ia_addr)->
-					ib.gid.global.interface_id));
+			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[0]),
+			     ntohll(*(uint64_t*)&cm->msg.daddr.ib.gid[8]));
 
 		dapls_evd_post_connection_event_ext(
 				(DAPL_EVD *)cm->ep->param.connect_evd_handle,
@@ -1201,18 +1189,17 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	dapl_os_unlock(&cm->lock);
 
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
-		     " ACCEPT_USR: remote port_num=%d lid=%x"
+		     " ACCEPT_USR: remote lid=%x"
 		     " iqp=%x qp_type %d, psize=%d\n",
-		     cm->msg.daddr.ib.port_num, ntohs(cm->msg.daddr.ib.lid),
+		     ntohs(cm->msg.daddr.ib.lid),
 		     ntohl(cm->msg.daddr.ib.qpn), cm->msg.daddr.ib.qp_type, 
 		     ntohs(cm->msg.p_size));
-
 	dapl_dbg_log(DAPL_DBG_TYPE_CM,
 		     " ACCEPT_USR: remote GID subnet %016llx id %016llx\n",
 		     (unsigned long long)
-		     htonll(cm->msg.daddr.ib.gid.global.subnet_prefix),
+		     htonll(*(uint64_t*)&cm->msg.daddr.ib.gid[0]),
 		     (unsigned long long)
-		     htonll(cm->msg.daddr.ib.gid.global.interface_id));
+		     htonll(*(uint64_t*)&cm->msg.daddr.ib.gid[8]));
 
 #ifdef DAT_EXTENSIONS
 	if (cm->msg.daddr.ib.qp_type == IBV_QPT_UD &&
@@ -1260,9 +1247,9 @@ dapli_accept_usr(DAPL_EP *ep, DAPL_CR *cr, DAT_COUNT p_size, DAT_PVOID p_data)
 	cm->msg.op = htons(DCM_REP);
 	cm->msg.saddr.ib.qpn = htonl(ep->qp_handle->qp_num);
 	cm->msg.saddr.ib.qp_type = ep->qp_handle->qp_type;
-	cm->msg.saddr.ib.port_num = cm->hca->port_num;
 	cm->msg.saddr.ib.lid = cm->hca->ib_trans.addr.ib.lid; 
-	cm->msg.saddr.ib.gid = cm->hca->ib_trans.addr.ib.gid; 
+	dapl_os_memcpy(&cm->msg.saddr.ib.gid[0],
+		       &cm->hca->ib_trans.addr.ib.gid, 16); 
 
 	/* 
 	 * UD: deliver p_data with REQ and EST event, keep REQ p_data in 
@@ -1327,7 +1314,7 @@ dapls_ib_connect(IN DAT_EP_HANDLE ep_handle,
 	if (cm == NULL)
 		return DAT_INSUFFICIENT_RESOURCES;
 
-	/* remote hca and port: lid, gid, port_num, network order */
+	/* remote hca and port: lid, gid, network order */
 	dapl_os_memcpy(&cm->msg.daddr, r_addr, sizeof(union dcm_addr));
 
 	/* remote uCM information, comes from consumer provider r_addr */
@@ -1463,9 +1450,9 @@ dapls_ib_setup_conn_listener(IN DAPL_IA *ia,
 	cm->msg.sport = htons((uint16_t)sid);
 	cm->msg.sqpn = htonl(ia->hca_ptr->ib_trans.qp->qp_num);
 	cm->msg.saddr.ib.qp_type = IBV_QPT_UD;
-	cm->msg.saddr.ib.port_num = ia->hca_ptr->port_num;
         cm->msg.saddr.ib.lid = ia->hca_ptr->ib_trans.addr.ib.lid; 
-	cm->msg.saddr.ib.gid = ia->hca_ptr->ib_trans.addr.ib.gid; 
+	dapl_os_memcpy(&cm->msg.saddr.ib.gid[0],
+		       &cm->hca->ib_trans.addr.ib.gid, 16); 
 	
 	/* save cm_handle reference in service point */
 	sp->cm_srvc_handle = cm;
diff --git a/dapl/openib_ucm/device.c b/dapl/openib_ucm/device.c
index 243044a..b887186 100644
--- a/dapl/openib_ucm/device.c
+++ b/dapl/openib_ucm/device.c
@@ -205,13 +205,12 @@ found:
 		goto err;
 	} else {
 		hca_ptr->ib_trans.addr.ib.lid = htons(port_attr.lid);
-		hca_ptr->ib_trans.addr.ib.port_num = hca_ptr->port_num;
 	}
 
 	/* get gid for this hca-port, network order */
 	if (ibv_query_gid(hca_ptr->ib_hca_handle,
-			  (uint8_t) hca_ptr->port_num,
-			  0, &hca_ptr->ib_trans.addr.ib.gid)) {
+			  (uint8_t) hca_ptr->port_num, 0,
+			  (union ibv_gid *)&hca_ptr->ib_trans.addr.ib.gid)) {
 		dapl_log(DAPL_DBG_TYPE_ERR,
 			 " open_hca: query GID ERR for %s, err=%s\n",
 			 ibv_get_device_name(hca_ptr->ib_trans.ib_dev),
@@ -284,21 +283,23 @@ found:
 		     " open_hca: devname %s, ctx %p port %d, hostname_IP %s\n",
 		     ibv_get_device_name(hca_ptr->ib_trans.ib_dev),
 		     hca_ptr->ib_hca_handle,
-		     hca_ptr->ib_trans.addr.ib.port_num, 
+		     hca_ptr->port_num, 
 		     inet_ntoa(((struct sockaddr_in *)
 			       &hca_ptr->hca_address)->sin_addr));
 	dapl_dbg_log(DAPL_DBG_TYPE_UTIL,
 		     " open_hca: QPN 0x%x LID 0x%x GID Subnet 0x" F64x ""
-		     "ID 0x" F64x "\n", 
+		     " ID 0x" F64x "\n", 
 		     ntohl(hca_ptr->ib_trans.addr.ib.qpn),
 		     ntohs(hca_ptr->ib_trans.addr.ib.lid), 
 		     (unsigned long long)
-		     htonll(hca_ptr->ib_trans.addr.ib.gid.global.subnet_prefix),
+		     ntohll(*(uint64_t*)&hca_ptr->ib_trans.addr.ib.gid[0]),
 		     (unsigned long long)
-		     htonll(hca_ptr->ib_trans.addr.ib.gid.global.interface_id));
+		     ntohll(*(uint64_t*)&hca_ptr->ib_trans.addr.ib.gid[8]));
 
 	/* save LID, GID, QPN, PORT address information, for ia_queries */
+	/* Set AF_INET6 to insure callee address storage of 28 bytes */
 	hca_ptr->ib_trans.hca = hca_ptr;
+	hca_ptr->ib_trans.addr.ib.family = AF_INET6; 
 	hca_ptr->ib_trans.addr.ib.qp_type = IBV_QPT_UD;
 	memcpy(&hca_ptr->hca_address, 
 	       &hca_ptr->ib_trans.addr, 
diff --git a/test/dtest/dtest.c b/test/dtest/dtest.c
index eb9429c..d43a09b 100755
--- a/test/dtest/dtest.c
+++ b/test/dtest/dtest.c
@@ -209,21 +209,7 @@ static int recv_msg_index = 0;
 static int burst_msg_posted = 0;
 static int burst_msg_index = 0;
 static int ucm = 0;
-
-/* IB address structure used by DAPL uCM provider */
-union dcm_addr {
-	DAT_SOCK_ADDR6          so;
-	struct {
-		uint8_t		qp_type;
-		uint8_t		port_num;
-		uint16_t	lid;
-		uint32_t	qpn;
-		uint8_t		gid[16];
-	} ib;
-};
-
-static union dcm_addr remote;
-static union dcm_addr local;
+static DAT_SOCK_ADDR6 remote;
 
 /* forward prototypes */
 const char *DT_RetToStr(DAT_RETURN ret_value);
@@ -325,6 +311,27 @@ retry:
 	return (ret);
 }
 
+static void print_ia_address(struct sockaddr *sa)
+{
+	char str[INET6_ADDRSTRLEN] = {" ??? "};
+
+	switch(sa->sa_family) {
+	case AF_INET:
+		inet_ntop(AF_INET, &((struct sockaddr_in *)sa)->sin_addr, str, INET6_ADDRSTRLEN);
+		printf("%d Local Address AF_INET - %s port %d\n", getpid(), str, SERVER_CONN_QUAL);
+		break;
+	case AF_INET6:
+		inet_ntop(AF_INET6, &((struct sockaddr_in6 *)sa)->sin6_addr, str, INET6_ADDRSTRLEN);
+		printf("%d Local Address AF_INET6 - %s flowinfo(QPN)=0x%x, port(LID)=0x%x\n",
+			getpid(), str, 
+			ntohl(((struct sockaddr_in6 *)sa)->sin6_flowinfo),
+			ntohs(((struct sockaddr_in6 *)sa)->sin6_port));
+		break;
+	default:
+		printf("%d Local Address UNKOWN FAMILY - port %d\n", getpid(), SERVER_CONN_QUAL);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	int i, c;
@@ -359,12 +366,16 @@ int main(int argc, char **argv)
 			fflush(stdout);
 			break;
 		case 'q':
-			remote.ib.qpn = htonl(strtol(optarg,NULL,0));
+			/* map UCM qpn into AF_INET6 sin6_flowinfo */
+			remote.sin6_family = AF_INET6;
+			remote.sin6_flowinfo = htonl(strtol(optarg,NULL,0));
 			ucm = 1;
 			server = 0;
 			break;
 		case 'l':
-			remote.ib.lid = htons(strtol(optarg,NULL,0));
+			/* map UCM lid into AF_INET6 sin6_port */
+			remote.sin6_family = AF_INET6;
+			remote.sin6_port = htons(strtol(optarg,NULL,0));
 			ucm = 1;
 			server = 0;
 			break;
@@ -434,25 +445,13 @@ int main(int argc, char **argv)
 	} else
 		LOGPRINTF("%d Opened Interface Adaptor\n", getpid());
 
-	printf("%d query \n", getpid());
-
 	ret = dat_ia_query(h_ia, 0, DAT_IA_FIELD_ALL, &ia_attr, 0, 0);
 	if (ret != DAT_SUCCESS) {
 		fprintf(stderr, "%d: Error Adaptor query: %s\n",
 			getpid(), DT_RetToStr(ret));
 		exit(1);
 	}
-	memcpy((void*)&local,
-		(void*)ia_attr.ia_address_ptr,
-		sizeof(DAT_SOCK_ADDR6));
-
-	printf("%d Local Address %s port %d\n", getpid(),
-	       inet_ntoa(((struct sockaddr_in *)&local)->sin_addr), 
-	       SERVER_CONN_QUAL);
-
-	printf("%d Local Address QPN=0x%x, LID=0x%x  <<< ucm provider\n",
-		getpid(), ntohl(local.ib.qpn),
-		ntohs(local.ib.lid));
+	print_ia_address(ia_attr.ia_address_ptr);
 
 	/* Create Protection Zone */
 	start = get_time();
diff --git a/test/dtest/dtestcm.c b/test/dtest/dtestcm.c
index 0b4941a..d3762c9 100644
--- a/test/dtest/dtestcm.c
+++ b/test/dtest/dtestcm.c
@@ -79,7 +79,7 @@
 #include <unistd.h>
 #include <stdlib.h>
 
-#define DAPL_PROVIDER "ofa-v2-mlx4_0-1"
+#define DAPL_PROVIDER "ofa-v2-ib0"
 
 #define F64x "%"PRIx64""
 #define F64d "%"PRId64""
@@ -101,21 +101,6 @@
 #include "dat2/udat.h"
 #include "dat2/dat_ib_extensions.h"
 
-/* IB address structure used by DAPL uCM provider */
-union dcm_addr { 
-	DAT_SOCK_ADDR6		so;
-	struct {
-		uint8_t		qp_type;
-		uint8_t		port_num;
-		uint16_t	lid;
-		uint32_t	qpn;
-		uint8_t		gid[16];
-	} ib;
-};
-
-static union dcm_addr remote;
-static union dcm_addr local;
-
 /* definitions */
 #define SERVER_CONN_QUAL  45248
 #define CONN_TIMEOUT      (1000*1000*100)
@@ -178,6 +163,7 @@ static int connections = 1000;
 static int burst = 100;
 static int port_id = SERVER_CONN_QUAL;
 static int ucm = 0;
+static DAT_SOCK_ADDR6 remote;
 
 /* forward prototypes */
 const char *DT_RetToString(DAT_RETURN ret_value);
@@ -205,6 +191,27 @@ void flush_evds(void)
 	}
 }
 
+static void print_ia_address(struct sockaddr *sa)
+{
+	char str[INET6_ADDRSTRLEN] = {" ??? "};
+
+	switch(sa->sa_family) {
+	case AF_INET:
+		inet_ntop(AF_INET, &((struct sockaddr_in *)sa)->sin_addr, str, INET6_ADDRSTRLEN);
+		printf("%d Local Address AF_INET - %s port %d\n", getpid(), str, SERVER_CONN_QUAL);
+		break;
+	case AF_INET6:
+		inet_ntop(AF_INET6, &((struct sockaddr_in6 *)sa)->sin6_addr, str, INET6_ADDRSTRLEN);
+		printf("%d Local Address AF_INET6 - %s flowinfo(QPN)=0x%x, port(LID)=0x%x\n",
+			getpid(), str,
+			ntohl(((struct sockaddr_in6 *)sa)->sin6_flowinfo),
+			ntohs(((struct sockaddr_in6 *)sa)->sin6_port));
+		break;
+	default:
+		printf("%d Local Address UNKOWN FAMILY - port %d\n", getpid(), SERVER_CONN_QUAL);
+	}
+}
+
 int main(int argc, char **argv)
 {
 	int i, c, len;
@@ -250,12 +257,16 @@ int main(int argc, char **argv)
 			strcpy(provider, optarg);
 			break;
 		case 'q':
-			remote.ib.qpn = htonl(strtol(optarg,NULL,0));
+			/* map UCM qpn into AF_INET6 sin6_flowinfo */
+			remote.sin6_family = AF_INET6;
+			remote.sin6_flowinfo = htonl(strtol(optarg,NULL,0));
 			ucm = 1;
 			server = 0;
 			break;
 		case 'l':
-			remote.ib.lid = htons(strtol(optarg,NULL,0));
+			/* map UCM lid into AF_INET6 sin6_port */
+			remote.sin6_family = AF_INET6;
+			remote.sin6_port = htons(strtol(optarg,NULL,0));
 			ucm = 1;
 			server = 0;
 			break;
@@ -334,17 +345,7 @@ int main(int argc, char **argv)
 			getpid(), DT_RetToString(ret));
 		exit(1);
 	}
-	memcpy((void*)&local, 
-	       (void*)ia_attr.ia_address_ptr, 
-	        sizeof(DAT_SOCK_ADDR6));
-
-	printf("%d Local Address %s port %d\n", getpid(),
-	       inet_ntoa(((struct sockaddr_in *)&local)->sin_addr),
-	       SERVER_CONN_QUAL);
-
-	printf("%d Local Address QPN=0x%x, LID=0x%x  <<< ucm provider\n",
-	       getpid(), ntohl(local.ib.qpn),
-	       ntohs(local.ib.lid));
+	print_ia_address(ia_attr.ia_address_ptr);
 
 	/* Create Protection Zone */
 	start = get_time();
diff --git a/test/dtest/dtestx.c b/test/dtest/dtestx.c
index 00460dd..32ffe33 100755
--- a/test/dtest/dtestx.c
+++ b/test/dtest/dtestx.c
@@ -180,21 +180,7 @@ int verbose = 0;
 int counters = 0;
 int counters_ok = 0;
 static int ucm = 0;
-
-/* IB address structure used by DAPL uCM provider */
-union dcm_addr {
-	DAT_SOCK_ADDR6          so;
-	struct {
-		uint8_t		qp_type;
-		uint8_t		port_num;
-		uint16_t	lid;
-		uint32_t	qpn;
-		uint8_t		gid[16];
-	} ib;
-};
-
-static union dcm_addr remote;
-static union dcm_addr local;
+static DAT_SOCK_ADDR6 remote;
 
 #define LOGPRINTF if (verbose) printf
 
@@ -225,6 +211,27 @@ static void sleep(int secs)
 #define	_WSACleanup()
 #endif
 
+static void print_ia_address(struct sockaddr *sa)
+{
+	char str[INET6_ADDRSTRLEN] = {" ??? "};
+
+	switch(sa->sa_family) {
+	case AF_INET:
+		inet_ntop(AF_INET, &((struct sockaddr_in *)sa)->sin_addr, str, INET6_ADDRSTRLEN);
+		printf("%d Local Address AF_INET - %s port %d\n", getpid(), str, SERVER_ID);
+		break;
+	case AF_INET6:
+		inet_ntop(AF_INET6, &((struct sockaddr_in6 *)sa)->sin6_addr, str, INET6_ADDRSTRLEN);
+		printf("%d Local Address AF_INET6 - %s flowinfo(QPN)=0x%x, port(LID)=0x%x\n",
+			getpid(), str,
+			ntohl(((struct sockaddr_in6 *)sa)->sin6_flowinfo),
+			ntohs(((struct sockaddr_in6 *)sa)->sin6_port));
+		break;
+	default:
+		printf("%d Local Address UNKOWN FAMILY - port %d\n", getpid(), SERVER_ID);
+	}
+}
+
 void
 send_msg(void *data,
 	 DAT_COUNT size,
@@ -440,17 +447,7 @@ int connect_ep(char *hostname)
 			      DAT_PROVIDER_FIELD_ALL, &prov_attrs);
 	_OK(status, "dat_ia_query");
 
-	memcpy((void*)&local,
-		(void*)ia_attr.ia_address_ptr,
-		sizeof(DAT_SOCK_ADDR6));
-
-        printf("%d Local Address %s port %d\n", getpid(),
-               inet_ntoa(((struct sockaddr_in *)&local)->sin_addr),
-               SERVER_ID);
-
-        printf("%d Local Address QPN=0x%x, LID=0x%x <<< ucm provider\n",
-                getpid(), ntohl(local.ib.qpn),
-                ntohs(local.ib.lid));
+	print_ia_address(ia_attr.ia_address_ptr);
 
 	if (ucm && ud_test) {
 		printf("%d UD test over UCM provider not supported\n",
@@ -1286,12 +1283,16 @@ int main(int argc, char **argv)
 			verbose = 1;
 			break;
 		case 'q':
-			remote.ib.qpn = htonl(strtol(optarg,NULL,0));
+			/* map UCM qpn into AF_INET6 sin6_flowinfo */
+			remote.sin6_family = AF_INET6;
+			remote.sin6_flowinfo = htonl(strtol(optarg,NULL,0));
 			ucm = 1;
 			server = 0;
 			break;
 		case 'l':
-			remote.ib.lid = htons(strtol(optarg,NULL,0));
+			/* map UCM lid into AF_INET6 sin6_port */
+			remote.sin6_family = AF_INET6;
+			remote.sin6_port = htons(strtol(optarg,NULL,0));
 			ucm = 1;
 			server = 0;
 			break;
-- 
1.5.2.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
