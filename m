From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/3] iwpmd: use ccan list.h for mapping_reqs
Date: Mon, 10 Oct 2016 11:41:53 +0200
Message-ID: <1476092514-18188-3-git-send-email-hch@lst.de>
References: <1476092514-18188-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476092514-18188-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Trivial conversion, nothing to see here.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm.h        |  5 ++---
 iwpmd/iwarp_pm_helper.c | 14 +++-----------
 iwpmd/iwarp_pm_server.c | 11 ++++-------
 3 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index 57153cc..48c9f80 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -134,7 +134,6 @@ typedef union sockaddr_union {
 
 enum {
 	IWPM_LIST_MAPPED_PORTS,
-	IWPM_LIST_MAP_REQUESTS,
 };
 
 typedef struct iwpm_list {
@@ -174,8 +173,7 @@ typedef struct iwpm_send_msg {
 } iwpm_send_msg;
 
 typedef struct iwpm_mapping_request {
-	struct iwpm_mapping_request *   next;
-	struct iwpm_mapping_request *   prev;
+	struct list_node		entry;
 	struct sockaddr_storage		src_addr;
 	struct sockaddr_storage		remote_addr;
 	__u16 				nlmsg_type;     /* Message content */
@@ -293,5 +291,6 @@ void remove_list_element(iwpm_list **, iwpm_list *, int);
 void free_iwpm_mapped_ports(void);
 
 extern struct list_head pending_messages;
+extern struct list_head mapping_reqs;
 
 #endif
diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index ebcff58..8aa8e40 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -35,7 +35,6 @@
 
 extern iwpm_mapped_port *mapped_ports;
 extern iwpm_mapped_port *pending_ports;
-extern iwpm_mapping_request *mapping_reqs; 
 
 extern pthread_cond_t cond_req_complete; 
 extern pthread_mutex_t map_req_mutex;
@@ -96,8 +95,7 @@ iwpm_mapping_request *create_iwpm_map_request(struct nlmsghdr *req_nlh,
 void add_iwpm_map_request(iwpm_mapping_request *iwpm_map_req)
 {
 	pthread_mutex_lock(&map_req_mutex);
-	add_list_element((iwpm_list **)&mapping_reqs, (iwpm_list **)&iwpm_map_req, 
-				IWPM_LIST_MAP_REQUESTS);
+	list_add(&mapping_reqs, &iwpm_map_req->entry);
 	/* if not wake, signal the thread that a new request has been posted */
 	if (!wake)
 		pthread_cond_signal(&cond_req_complete);
@@ -117,8 +115,7 @@ void remove_iwpm_map_request(iwpm_mapping_request *iwpm_map_req)
 			"Timeout for request (type = %u pid = %d)\n",
 			iwpm_map_req->msg_type, iwpm_map_req->nlmsg_pid);
 	}
-	remove_list_element((iwpm_list **)&mapping_reqs, (iwpm_list *)iwpm_map_req,
-				IWPM_LIST_MAP_REQUESTS);
+	list_del(&iwpm_map_req->entry);
 	if (iwpm_map_req->send_msg)
 		free(iwpm_map_req->send_msg);
 	free(iwpm_map_req);
@@ -140,7 +137,7 @@ int update_iwpm_map_request(__u64 assochandle, struct sockaddr_storage *src_addr
 
 	pthread_mutex_lock(&map_req_mutex);
 	/* look for a matching entry in the list */
-	for (iwpm_map_req = mapping_reqs; iwpm_map_req != NULL; iwpm_map_req = iwpm_map_req->next) {
+	list_for_each(&mapping_reqs, iwpm_map_req, entry) {
 		if (assochandle == iwpm_map_req->assochandle && 
 				(msg_type & iwpm_map_req->msg_type) &&
 				check_same_sockaddr(src_addr, &iwpm_map_req->src_addr)) {
@@ -626,17 +623,12 @@ int add_iwpm_pending_msg(iwpm_send_msg *send_msg)
 static void assign_list_head(iwpm_list **list, iwpm_list *list_element, int list_type) 
 {
 	iwpm_mapped_port **ports;
-	iwpm_mapping_request **requests;
 
 	switch (list_type) {
 		case IWPM_LIST_MAPPED_PORTS:
 			ports = (iwpm_mapped_port **)list;
 			*ports = (iwpm_mapped_port *)list_element;
 			break;
-		case IWPM_LIST_MAP_REQUESTS:
-			requests = (iwpm_mapping_request **)list;
-			*requests = (iwpm_mapping_request *)list_element;
-			break;
 		default:
 			break;
 	}
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index a45ccbd..db73c6f 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -38,7 +38,7 @@ const char iwpm_ulib_name [] = "iWarpPortMapperUser";
 int iwpm_version = 3;
 
 iwpm_mapped_port *mapped_ports = NULL;        /* list of mapped ports */
-volatile iwpm_mapping_request *mapping_reqs = NULL;    /* list of map tracking objects */
+LIST_HEAD(mapping_reqs);		      /* list of map tracking objects */
 LIST_HEAD(pending_messages);		      /* list of pending wire messages */
 iwpm_client client_list[IWARP_PM_MAX_CLIENTS];/* list of iwarp port mapper clients */
 int mapinfo_num_list[IWARP_PM_MAX_CLIENTS];   /* list of iwarp port mapper clients */
@@ -96,7 +96,7 @@ void *iwpm_mapping_reqs_handler()
 	while (1) {
 		pthread_mutex_lock(&map_req_mutex);
 		wake = 0;
-		if (!mapping_reqs) {
+		if (list_empty(&mapping_reqs)) {
 			/* wait until a new mapping request is posted */
 			ret = pthread_cond_wait(&cond_req_complete, &map_req_mutex);
 			if (ret) {
@@ -111,9 +111,7 @@ void *iwpm_mapping_reqs_handler()
 		do { 
 			pthread_mutex_lock(&map_req_mutex);
 			wake = 1;
-			iwpm_map_req = (iwpm_mapping_request *)mapping_reqs;
-			while (iwpm_map_req) {
-				next_map_req = iwpm_map_req->next;
+			list_for_each_safe(&mapping_reqs, iwpm_map_req, next_map_req, entry) {
 				if (iwpm_map_req->timeout > 0) {
 					if (iwpm_map_req->timeout < IWPM_MAP_REQ_TIMEOUT &&
 							iwpm_map_req->msg_type != IWARP_PM_REQ_ACK) { 
@@ -130,11 +128,10 @@ void *iwpm_mapping_reqs_handler()
 				} else {
 					remove_iwpm_map_request(iwpm_map_req);
 				}
-				iwpm_map_req = next_map_req;
 			}
 			pthread_mutex_unlock(&map_req_mutex);
 			sleep(1); 
-		} while (mapping_reqs);
+		} while (!list_empty(&mapping_reqs));
 	}
 mapping_reqs_handler_exit:
 	return NULL;
-- 
2.10.1.382.ga23ca1b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
