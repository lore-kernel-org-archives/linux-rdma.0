From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/3] iwpmd: use ccan list.h for pending_messages
Date: Mon, 10 Oct 2016 11:41:52 +0200
Message-ID: <1476092514-18188-2-git-send-email-hch@lst.de>
References: <1476092514-18188-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476092514-18188-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The only change in semantics is that we remove the entry from the list
earlier in iwpm_pending_msgs_handler due to using the list_pop helper,
but given that we won't exist the loop early ever this should not change
behavior.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm.h        |  9 ++++-----
 iwpmd/iwarp_pm_helper.c | 22 +---------------------
 iwpmd/iwarp_pm_server.c |  9 +++++----
 3 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index 5b7c613..57153cc 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -52,6 +52,7 @@
 #include <pthread.h>
 #include <syslog.h>
 #include <netlink/msg.h>
+#include <ccan/list.h>
 #include "iwpm_netlink.h"
 
 #define IWARP_PM_PORT          3935
@@ -134,7 +135,6 @@ typedef union sockaddr_union {
 enum {
 	IWPM_LIST_MAPPED_PORTS,
 	IWPM_LIST_MAP_REQUESTS,
-	IWPM_LIST_PENDING_MSGS
 };
 
 typedef struct iwpm_list {
@@ -189,8 +189,7 @@ typedef struct iwpm_mapping_request {
 } iwpm_mapping_request;
 
 typedef struct iwpm_pending_msg {
-	struct iwpm_send_msg *  next;
-	struct iwpm_send_msg *  prev;
+	struct list_node	entry;
 	iwpm_send_msg           send_msg;
 } iwpm_pending_msg;
 
@@ -285,8 +284,6 @@ int send_iwpm_msg(void (*form_msg_type)(iwpm_wire_msg *, iwpm_msg_parms *),
 
 int add_iwpm_pending_msg(iwpm_send_msg *);
 
-void remove_iwpm_pending_msg(iwpm_pending_msg *);
-
 int check_same_sockaddr(struct sockaddr_storage *, struct sockaddr_storage *);
 
 void add_list_element(iwpm_list **, iwpm_list **, int);
@@ -295,4 +292,6 @@ void remove_list_element(iwpm_list **, iwpm_list *, int);
 
 void free_iwpm_mapped_ports(void);
 
+extern struct list_head pending_messages;
+
 #endif
diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index 89d2b6c..ebcff58 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -36,7 +36,6 @@
 extern iwpm_mapped_port *mapped_ports;
 extern iwpm_mapped_port *pending_ports;
 extern iwpm_mapping_request *mapping_reqs; 
-extern iwpm_send_msg *pending_messages;
 
 extern pthread_cond_t cond_req_complete; 
 extern pthread_mutex_t map_req_mutex;
@@ -613,27 +612,13 @@ int add_iwpm_pending_msg(iwpm_send_msg *send_msg)
 	memcpy(&pending_msg->send_msg, send_msg, sizeof(iwpm_send_msg));
 
 	pthread_mutex_lock(&pending_msg_mutex);
-	add_list_element((iwpm_list **)&pending_messages, (iwpm_list **)&pending_msg,
-				IWPM_LIST_PENDING_MSGS);
+	list_add(&pending_messages, &pending_msg->entry);
 	pthread_mutex_unlock(&pending_msg_mutex);
 	/* signal the thread that a new message has been posted */
 	pthread_cond_signal(&cond_pending_msg);
 	return 0;
 }
 
-/** 
- * remove_iwpm_pending_msg - Free wire message buffer
- * @pending_msg: message to be removed
- *
- * Routine must be called within lock context 
- */
-void remove_iwpm_pending_msg(iwpm_pending_msg *pending_msg)
-{
-	remove_list_element((iwpm_list **)&pending_messages, (iwpm_list *)pending_msg,
-				IWPM_LIST_PENDING_MSGS);
-	free(pending_msg);
-}
-
 /*
  * assign_list_head - Make list_element the first element in the list
  *                    (i.e. *list = *list_element)
@@ -642,7 +627,6 @@ static void assign_list_head(iwpm_list **list, iwpm_list *list_element, int list
 {
 	iwpm_mapped_port **ports;
 	iwpm_mapping_request **requests;
-	iwpm_send_msg **messages;
 
 	switch (list_type) {
 		case IWPM_LIST_MAPPED_PORTS:
@@ -653,10 +637,6 @@ static void assign_list_head(iwpm_list **list, iwpm_list *list_element, int list
 			requests = (iwpm_mapping_request **)list;
 			*requests = (iwpm_mapping_request *)list_element;
 			break;
-		case IWPM_LIST_PENDING_MSGS:
-			messages = (iwpm_send_msg **)list;
-			*messages = (iwpm_send_msg *)list_element;
-			break;
 		default:
 			break;
 	}
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index 39e0aa2..a45ccbd 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -39,7 +39,7 @@ int iwpm_version = 3;
 
 iwpm_mapped_port *mapped_ports = NULL;        /* list of mapped ports */
 volatile iwpm_mapping_request *mapping_reqs = NULL;    /* list of map tracking objects */
-volatile iwpm_pending_msg *pending_messages = NULL;    /* list of pending wire messages */
+LIST_HEAD(pending_messages);		      /* list of pending wire messages */
 iwpm_client client_list[IWARP_PM_MAX_CLIENTS];/* list of iwarp port mapper clients */
 int mapinfo_num_list[IWARP_PM_MAX_CLIENTS];   /* list of iwarp port mapper clients */
 
@@ -160,9 +160,10 @@ void *iwpm_pending_msgs_handler()
 			pthread_mutex_unlock(&pending_msg_mutex);
 			goto pending_msgs_handler_exit;
 		}
+
 		/* try sending out each pending message and remove it from the list */
-		while (pending_messages) {
-			pending_msg = (iwpm_pending_msg *)pending_messages;
+		while ((pending_msg = list_pop(&pending_messages,
+				iwpm_pending_msg, entry))) {
 			retries = IWPM_SEND_MSG_RETRIES;
 			while (retries) {
 				send_msg = &pending_msg->send_msg;
@@ -179,7 +180,7 @@ void *iwpm_pending_msgs_handler()
 				} else 
 					retries = 0; /* no need to retry */	
 			}
-			remove_iwpm_pending_msg(pending_msg);
+			free(pending_msg);
 		}
 	}
 	pthread_mutex_unlock(&pending_msg_mutex);
-- 
2.10.1.382.ga23ca1b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
