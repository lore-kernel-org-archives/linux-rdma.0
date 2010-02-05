From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0: Cleanup CM object lock before freeing CM object
 memory
Date: Fri, 5 Feb 2010 12:04:02 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983B2EB8D37@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 
Running windows application verifiier for uDAPL validation
for all 3 providers. Cleanup memory lock leaks found
by verifier.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c |    4 ++++
 dapl/openib_scm/cm.c |    2 ++
 dapl/openib_ucm/cm.c |    4 ++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index 9928239..cfa6ede 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -167,6 +167,7 @@ dp_ib_cm_handle_t dapls_ib_cm_create(DAPL_EP *ep)
 
 	/* create CM_ID, bind to local device, create QP */
 	if (rdma_create_id(g_cm_events, &cm_id, (void *)conn, RDMA_PS_TCP)) {
+		dapl_os_lock_destroy(&conn->lock);
 		dapl_os_free(conn, sizeof(*conn));
 		return NULL;
 	}
@@ -221,6 +222,7 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t conn, DAPL_EP *ep)
 		rdma_destroy_id(conn->cm_id);
 	}
 
+	dapl_os_lock_destroy(&conn->lock);
 	dapl_os_free(conn, sizeof(*conn));
 }
 
@@ -686,6 +688,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
 	/* create CM_ID, bind to local device, create QP */
 	if (rdma_create_id
 	    (g_cm_events, &conn->cm_id, (void *)conn, RDMA_PS_TCP)) {
+		dapl_os_lock_destroy(&conn->lock);
 		dapl_os_free(conn, sizeof(*conn));
 		return (dapl_convert_errno(errno, "setup_listener"));
 	}
@@ -734,6 +737,7 @@ dapls_ib_setup_conn_listener(IN DAPL_IA * ia_ptr,
 
       bail:
 	rdma_destroy_id(conn->cm_id);
+	dapl_os_lock_destroy(&conn->lock);
 	dapl_os_free(conn, sizeof(*conn));
 	return dat_status;
 }
diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index db2821a..8e9be4d 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -317,6 +317,7 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t cm_ptr, DAPL_EP *ep)
 			closesocket(cm_ptr->socket);
 		}
 		dapl_os_unlock(&cm_ptr->lock);
+		dapl_os_lock_destroy(&cm_ptr->lock);
 		dapl_os_free(cm_ptr, sizeof(*cm_ptr));
 		return;
 	}
@@ -1761,6 +1762,7 @@ void cr_thread(void *arg)
 					shutdown(cr->socket, SHUT_RDWR);
 					closesocket(cr->socket);
 				}
+				dapl_os_lock_destroy(&cr->lock);
 				dapl_os_free(cr, sizeof(*cr));
 				continue;
 			}
diff --git a/dapl/openib_ucm/cm.c b/dapl/openib_ucm/cm.c
index b5aba64..c0da589 100644
--- a/dapl/openib_ucm/cm.c
+++ b/dapl/openib_ucm/cm.c
@@ -728,6 +728,7 @@ void dapls_ib_cm_free(dp_ib_cm_handle_t cm, DAPL_EP *ep)
 	/* cleanup, never made it to work queue */
 	if (cm->state == DCM_INIT) {
 		dapl_os_unlock(&cm->lock);
+		dapl_os_lock_destroy(&cm->lock);
 		dapl_os_free(cm, sizeof(*cm));
 		return;
 	}
@@ -1701,6 +1702,7 @@ dapls_ib_remove_conn_listener(IN DAPL_IA *ia, IN DAPL_SP *sp)
 		cm->state = DCM_DESTROY;
 		dapl_os_unlock(&cm->lock);
 		ucm_dequeue_listen(cm);
+		dapl_os_lock_destroy(&cm->lock);
 		dapl_os_free(cm, sizeof(*cm));
 	}
 	return DAT_SUCCESS;
@@ -1981,6 +1983,7 @@ void cm_thread(void *arg)
 				dapl_llist_remove_entry(&hca->ib_trans.list,
 							(DAPL_LLIST_ENTRY *)&cm->entry);
 				dapl_os_unlock(&cm->lock);
+				dapl_os_lock_destroy(&cm->lock);
 				dapl_os_free(cm, sizeof(*cm));
 				continue;
 			}
@@ -2052,6 +2055,7 @@ void cm_thread(void *arg)
 					&hca->ib_trans.list,
 					(DAPL_LLIST_ENTRY *)&cm->entry);
 				dapl_os_unlock(&cm->lock);
+				dapl_os_lock_destroy(&cm->lock);
 				dapl_os_free(cm, sizeof(*cm));
 				continue;
 			}
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
