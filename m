From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 6/7] dapl scm: remove use of msg.resv field for process id logging
Date: Fri, 22 May 2015 12:22:46 -0700
Message-ID: <1432322567-9349-6-git-send-email-arlin.r.davis@intel.com>
References: <1432322567-9349-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432322567-9349-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 680d16b..ecc5418 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -42,7 +42,7 @@
  *
  *    $Id: $
  *
- *	Copyright (c) 2005 Intel Corporation.  All rights reserved.
+ *	Copyright (c) 2005-2015 Intel Corporation.  All rights reserved.
  *
  **************************************************************************/
 
@@ -737,13 +737,11 @@ static void dapli_socket_connect_rtu(dp_ib_cm_handle_t cm_ptr)
 		int err = dapl_socket_errno();
 		dapl_log(DAPL_DBG_TYPE_CM_WARN,
 			 " CONN_REP_PENDING: sk %d ERR 0x%x, rcnt=%d, v=%d ->"
-			 " %s PORT L-%x R-%x PID L-%x%x R-%x%x %d\n",
+			 " %s PORT L-%x R-%x %d\n",
 			 cm_ptr->socket, err, len, ntohs(cm_ptr->msg.ver),
 			 inet_ntoa(((struct sockaddr_in *)&cm_ptr->addr)->sin_addr),
 			 ntohs(((struct sockaddr_in *)&cm_ptr->msg.daddr.so)->sin_port),
 			 ntohs(((struct sockaddr_in *)&cm_ptr->addr)->sin_port),
-			 cm_ptr->msg.resv[1],cm_ptr->msg.resv[0],
-			 cm_ptr->msg.resv[3],cm_ptr->msg.resv[2],
 			 cm_ptr->retry);
 
 		/* Retry; corner case where server tcp stack resets under load */
@@ -1302,11 +1300,6 @@ dapli_socket_accept_usr(DAPL_EP * ep_ptr,
 	sl = sizeof(local.daddr.so);
 	getsockname(cm_ptr->socket, (struct sockaddr *)&local.daddr.so, &sl);
 
-#ifdef DAPL_DBG
-	/* DBG: Active PID [0], PASSIVE PID [2] */
-	*(uint16_t*)&cm_ptr->msg.resv[2] = htons((uint16_t)dapl_os_getpid()); 
-	dapl_os_memcpy(local.resv, cm_ptr->msg.resv, 4); 
-#endif
 	cm_ptr->hca = ia_ptr->hca_ptr;
 	dapl_os_lock(&cm_ptr->lock);
 	cm_ptr->state = DCM_ACCEPTED;
@@ -1973,7 +1966,7 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 				(DAPL_LLIST_ENTRY*)&cr->local_entry);
 
 		printf( "  CONN[%d]: sp %p ep %p sock %d %s %s %s %s %s %s "
-			" PORT L-%x R-%x PID L-%x%x R-%x%x\n",
+			" PORT L-%x R-%x \n",
 			i, cr->sp, cr->ep, cr->socket,
 			cr->msg.saddr.ib.qp_type == IBV_QPT_RC ? "RC" : "UD",
 			dapl_cm_state_str(cr->state), dapl_cm_op_str(ntohs(cr->msg.op)),
@@ -1991,10 +1984,7 @@ void dapls_print_cm_list(IN DAPL_IA *ia_ptr)
 
 			ntohs(cr->msg.op) == DCM_REQ ? /* remote port */
 				ntohs(((struct sockaddr_in *)&cr->addr)->sin_port) :
-				ntohs(((struct sockaddr_in *)&cr->msg.daddr.so)->sin_port),
-
-			cr->sp ? cr->msg.resv[3] : cr->msg.resv[1], cr->sp ? cr->msg.resv[2] : cr->msg.resv[0],
-			cr->sp ? cr->msg.resv[1] : cr->msg.resv[3], cr->sp ? cr->msg.resv[0] : cr->msg.resv[2]);
+				ntohs(((struct sockaddr_in *)&cr->msg.daddr.so)->sin_port) );
 		i++;
 	}
 	printf("\n");
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
