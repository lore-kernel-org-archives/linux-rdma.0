From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/3] iwpmd: use ccan list.h for mapped_ports
Date: Mon, 10 Oct 2016 11:41:54 +0200
Message-ID: <1476092514-18188-4-git-send-email-hch@lst.de>
References: <1476092514-18188-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476092514-18188-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Also ѕtop passing mappped_ports ports as an argument to some function
and always use the global, which allows making mapped_ports static
in iwarp_pm_helper.c.

Now that no user of the iwpm_list infrastructure are left remove it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 iwpmd/iwarp_pm.h        | 26 ++++----------
 iwpmd/iwarp_pm_helper.c | 92 +++++++++----------------------------------------
 iwpmd/iwarp_pm_server.c | 27 +++++++--------
 3 files changed, 35 insertions(+), 110 deletions(-)

diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index 48c9f80..d282029 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -132,18 +132,8 @@ typedef union sockaddr_union {
 	struct sockaddr_nl nl_sockaddr;
 } sockaddr_union;
 
-enum {
-	IWPM_LIST_MAPPED_PORTS,
-};
-
-typedef struct iwpm_list {
-	struct iwpm_list * next;
-	struct iwpm_list * prev;
-} iwpm_list;
-
 typedef struct iwpm_mapped_port {
-	struct iwpm_mapped_port *   next;
-	struct iwpm_mapped_port *   prev;
+	struct list_node	    entry;
 	int			    owner_client;
 	int			    sd;
 	struct sockaddr_storage	    local_addr;
@@ -252,15 +242,15 @@ iwpm_mapped_port *create_iwpm_mapped_port(struct sockaddr_storage *, int);
 
 iwpm_mapped_port *reopen_iwpm_mapped_port(struct sockaddr_storage *, struct sockaddr_storage *, int);
 
-void add_iwpm_mapped_port(iwpm_mapped_port **, iwpm_mapped_port *);
+void add_iwpm_mapped_port(iwpm_mapped_port *);
 
-iwpm_mapped_port *find_iwpm_mapping(iwpm_mapped_port *, struct sockaddr_storage *, int);
+iwpm_mapped_port *find_iwpm_mapping(struct sockaddr_storage *, int);
 
-iwpm_mapped_port *find_iwpm_same_mapping(iwpm_mapped_port *, struct sockaddr_storage *, int);
+iwpm_mapped_port *find_iwpm_same_mapping(struct sockaddr_storage *, int);
 
-void remove_iwpm_mapped_port(iwpm_mapped_port **, iwpm_mapped_port *);
+void remove_iwpm_mapped_port(iwpm_mapped_port *);
 
-void print_iwpm_mapped_ports(iwpm_mapped_port *);
+void print_iwpm_mapped_ports(void);
 
 void free_iwpm_port(iwpm_mapped_port *);
  
@@ -284,10 +274,6 @@ int add_iwpm_pending_msg(iwpm_send_msg *);
 
 int check_same_sockaddr(struct sockaddr_storage *, struct sockaddr_storage *);
 
-void add_list_element(iwpm_list **, iwpm_list **, int);
-
-void remove_list_element(iwpm_list **, iwpm_list *, int);
-
 void free_iwpm_mapped_ports(void);
 
 extern struct list_head pending_messages;
diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index 8aa8e40..dcd1ca9 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -33,8 +33,7 @@
 
 #include "iwarp_pm.h"
 
-extern iwpm_mapped_port *mapped_ports;
-extern iwpm_mapped_port *pending_ports;
+static LIST_HEAD(mapped_ports);		/* list of mapped ports */
 
 extern pthread_cond_t cond_req_complete; 
 extern pthread_mutex_t map_req_mutex;
@@ -417,10 +416,9 @@ reopen_mapped_port_error:
 
 /**
  * add_iwpm_mapped_port - Add mapping to a global list
- * @iwpm_ports: list where to save the mapping
  * @iwpm_port: mapping to be saved
  */ 
-void add_iwpm_mapped_port(iwpm_mapped_port **iwpm_ports, iwpm_mapped_port *iwpm_port)
+void add_iwpm_mapped_port(iwpm_mapped_port *iwpm_port)
 {
 	static int dbg_idx = 1;
 	iwpm_debug(IWARP_PM_ALL_DBG, "add_iwpm_mapped_port: Adding a new mapping #%d\n", dbg_idx++);
@@ -429,8 +427,7 @@ void add_iwpm_mapped_port(iwpm_mapped_port **iwpm_ports, iwpm_mapped_port *iwpm_
 		if (iwpm_port->ref_cnt > 1)
 			return;
 	}
-	add_list_element((iwpm_list **)iwpm_ports, (iwpm_list **)&iwpm_port, 
-				IWPM_LIST_MAPPED_PORTS);
+	list_add(&mapped_ports, &iwpm_port->entry);
 }
 
 /**
@@ -474,7 +471,6 @@ int check_same_sockaddr(struct sockaddr_storage *sockaddr_a, struct sockaddr_sto
 
 /**
  * find_iwpm_mapping - Find saved mapped port object 
- * @iwpm_ports: list of mapped port object
  * @search_addr: IP address and port to search for in the list
  * @not_mapped: if set, compare local addresses, otherwise compare mapped addresses
  *
@@ -482,13 +478,13 @@ int check_same_sockaddr(struct sockaddr_storage *sockaddr_a, struct sockaddr_sto
  * to find a saved port object with the sockaddr or
  * a wild card address with the same tcp port
  */ 
-iwpm_mapped_port *find_iwpm_mapping(iwpm_mapped_port *iwpm_ports,
-				struct sockaddr_storage *search_addr, int not_mapped)
+iwpm_mapped_port *find_iwpm_mapping(struct sockaddr_storage *search_addr,
+		int not_mapped)
 {
 	iwpm_mapped_port *iwpm_port, *saved_iwpm_port = NULL;
 	struct sockaddr_storage *current_addr;
 
-	for (iwpm_port = iwpm_ports; iwpm_port != NULL; iwpm_port = iwpm_port->next) {
+	list_for_each(&mapped_ports, iwpm_port, entry) {
 		current_addr = (not_mapped)? &iwpm_port->local_addr : &iwpm_port->mapped_addr;
 
 		if (get_sockaddr_port(search_addr) == get_sockaddr_port(current_addr)) {
@@ -505,20 +501,19 @@ find_mapping_exit:
 
 /**
  * find_iwpm_same_mapping - Find saved mapped port object 
- * @iwpm_ports: list of mapped port object
  * @search_addr: IP address and port to search for in the list
  * @not_mapped: if set, compare local addresses, otherwise compare mapped addresses
  *
  * Compares the search_sockaddr to the addresses in the list,
  * to find a saved port object with the same sockaddr
  */ 
-iwpm_mapped_port *find_iwpm_same_mapping(iwpm_mapped_port *iwpm_ports,
-				struct sockaddr_storage *search_addr, int not_mapped)
+iwpm_mapped_port *find_iwpm_same_mapping(struct sockaddr_storage *search_addr,
+		int not_mapped)
 {
 	iwpm_mapped_port *iwpm_port, *saved_iwpm_port = NULL;
 	struct sockaddr_storage *current_addr;
 
-	for (iwpm_port = iwpm_ports; iwpm_port != NULL; iwpm_port = iwpm_port->next) {
+	list_for_each(&mapped_ports, iwpm_port, entry) {
 		current_addr = (not_mapped)? &iwpm_port->local_addr : &iwpm_port->mapped_addr;
 		if (check_same_sockaddr(search_addr, current_addr)) {
 			saved_iwpm_port = iwpm_port;
@@ -556,29 +551,27 @@ void free_iwpm_port(iwpm_mapped_port *iwpm_port)
 
 /** 
  * remove_iwpm_mapped_port - Remove a mapping from a global list
- * @iwpm_ports: list from which the mapping needs to be removed
  * @iwpm_port: mapping to be removed
  *
  * Called only by the main iwarp port mapper thread
  */
-void remove_iwpm_mapped_port(iwpm_mapped_port **iwpm_ports, iwpm_mapped_port *iwpm_port)
+void remove_iwpm_mapped_port(iwpm_mapped_port *iwpm_port)
 {
 	static int dbg_idx = 1;
 	iwpm_debug(IWARP_PM_ALL_DBG, "remove_iwpm_mapped_port: index = %d\n", dbg_idx++);
 
-	remove_list_element((iwpm_list **)iwpm_ports, (iwpm_list *)iwpm_port,
-				IWPM_LIST_MAPPED_PORTS);
+	list_del(&iwpm_port->entry);
 }
 
-void print_iwpm_mapped_ports(iwpm_mapped_port *iwpm_ports)
+void print_iwpm_mapped_ports(void)
 {
 	iwpm_mapped_port *iwpm_port;
-	int i;
+	int i = 0;
 
 	syslog(LOG_WARNING, "print_iwpm_mapped_ports:\n");
 
-	for (iwpm_port = iwpm_ports, i = 0; iwpm_port != NULL; iwpm_port = iwpm_port->next, i++) {
-		syslog(LOG_WARNING, "Mapping #%d\n", i);
+	list_for_each(&mapped_ports, iwpm_port, entry) {
+		syslog(LOG_WARNING, "Mapping #%d\n", i++);
 		print_iwpm_sockaddr(&iwpm_port->local_addr, "Local address", IWARP_PM_DEBUG);
 		print_iwpm_sockaddr(&iwpm_port->mapped_addr, "Mapped address", IWARP_PM_DEBUG);
 	}
@@ -616,55 +609,6 @@ int add_iwpm_pending_msg(iwpm_send_msg *send_msg)
 	return 0;
 }
 
-/*
- * assign_list_head - Make list_element the first element in the list
- *                    (i.e. *list = *list_element)
- */
-static void assign_list_head(iwpm_list **list, iwpm_list *list_element, int list_type) 
-{
-	iwpm_mapped_port **ports;
-
-	switch (list_type) {
-		case IWPM_LIST_MAPPED_PORTS:
-			ports = (iwpm_mapped_port **)list;
-			*ports = (iwpm_mapped_port *)list_element;
-			break;
-		default:
-			break;
-	}
-}
-
-/** 
- * add_list_element - Add element to a doubly linked list
- */
-void add_list_element(iwpm_list **list, iwpm_list **list_element, int list_type)
-{
-	/* add element to the beginning of the list*/
-	(*list_element)->next = *list;
-	if (*list)
-		(*list)->prev = *list_element;
-	(*list_element)->prev = NULL;
-	assign_list_head(list, *list_element, list_type);
-}
-
-/** 
- * remove_list_element - Remove element from a doubly linked list
- */
-void remove_list_element(iwpm_list **list, iwpm_list *list_element, int list_type)
-{
-	/* remove element from the list */
-	if (list_element->prev) {
-		list_element->prev->next = list_element->next;
-		if (list_element->next)
-			list_element->next->prev = list_element->prev;
-	} else {
-		/* remove first element */
-		assign_list_head(list, list_element->next, list_type);
-		if (*list)
-			(*list)->prev = NULL;
-	}
-}
-
 /** 
  * free_iwpm_mapped_ports - Free all iwpm mapped port objects 
  */
@@ -672,10 +616,6 @@ void free_iwpm_mapped_ports(void)
 {
 	iwpm_mapped_port *iwpm_port;
 
-	while (mapped_ports) {
-		iwpm_port = mapped_ports;
-		mapped_ports = mapped_ports->next;
+	while ((iwpm_port = list_pop(&mapped_ports, iwpm_mapped_port, entry)))
 		free_iwpm_port(iwpm_port);
-	}
-	mapped_ports = NULL;
 }
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index db73c6f..a9ca685 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -37,7 +37,6 @@
 const char iwpm_ulib_name [] = "iWarpPortMapperUser";
 int iwpm_version = 3;
 
-iwpm_mapped_port *mapped_ports = NULL;        /* list of mapped ports */
 LIST_HEAD(mapping_reqs);		      /* list of map tracking objects */
 LIST_HEAD(pending_messages);		      /* list of pending wire messages */
 iwpm_client client_list[IWARP_PM_MAX_CLIENTS];/* list of iwarp port mapper clients */
@@ -325,7 +324,7 @@ static int process_iwpm_add_mapping(struct nlmsghdr *req_nlh, int client_idx, in
 	}
 	local_addr = (struct sockaddr_storage *)nla_data(nltb[IWPM_NLA_MANAGE_ADDR]);
 
-	iwpm_port = find_iwpm_mapping(mapped_ports, local_addr, not_mapped);
+	iwpm_port = find_iwpm_mapping(local_addr, not_mapped);
 	if (iwpm_port) {
 		if (check_same_sockaddr(local_addr, &iwpm_port->local_addr) && iwpm_port->wcard) {
 				iwpm_port->ref_cnt++;
@@ -366,7 +365,7 @@ static int process_iwpm_add_mapping(struct nlmsghdr *req_nlh, int client_idx, in
 		goto add_mapping_free_error;	
 	}
 	/* add the new mapping to the list */
-	add_iwpm_mapped_port(&mapped_ports, iwpm_port);
+	add_iwpm_mapped_port(iwpm_port);
 	nlmsg_free(resp_nlmsg);
 	return 0;
 
@@ -432,7 +431,7 @@ static int process_iwpm_query_mapping(struct nlmsghdr *req_nlh, int client_idx,
 	local_addr = (struct sockaddr_storage *)nla_data(nltb[IWPM_NLA_QUERY_LOCAL_ADDR]);
 	remote_addr = (struct sockaddr_storage *)nla_data(nltb[IWPM_NLA_QUERY_REMOTE_ADDR]);
 
-	iwpm_port = find_iwpm_mapping(mapped_ports, local_addr, not_mapped);
+	iwpm_port = find_iwpm_mapping(local_addr, not_mapped);
 	if (iwpm_port) {
 		err_code = IWPM_DUPLICATE_MAPPING_ERR;
 		str_err = "Duplicate mapped port";
@@ -497,7 +496,7 @@ static int process_iwpm_query_mapping(struct nlmsghdr *req_nlh, int client_idx,
 	form_iwpm_send_msg(pm_client_sock, &dest_addr.s_sockaddr, msg_parms.msize, send_msg);
 
 	add_iwpm_map_request(iwpm_map_req);
-	add_iwpm_mapped_port(&mapped_ports, iwpm_port);
+	add_iwpm_mapped_port(iwpm_port);
 	return send_iwpm_msg(form_iwpm_request, &msg_parms, &dest_addr.s_sockaddr, pm_client_sock);
 query_mapping_free_error:
 	if (iwpm_port)
@@ -542,7 +541,7 @@ static int process_iwpm_remove_mapping(struct nlmsghdr *req_nlh, int client_idx,
 	iwpm_debug(IWARP_PM_NETLINK_DBG, "process_remove_mapping: Going to remove mapping"
 			" (client idx = %d)\n", client_idx);
 
-	iwpm_port = find_iwpm_same_mapping(mapped_ports, local_addr, not_mapped);
+	iwpm_port = find_iwpm_same_mapping(local_addr, not_mapped);
 	if (!iwpm_port) {
 		iwpm_debug(IWARP_PM_NETLINK_DBG, "process_remove_mapping: Unable to find mapped port object\n");
 		print_iwpm_sockaddr(local_addr, "process_remove_mapping: Local address", IWARP_PM_ALL_DBG);
@@ -560,7 +559,7 @@ static int process_iwpm_remove_mapping(struct nlmsghdr *req_nlh, int client_idx,
 		if (ref_cnt)
 			goto remove_mapping_exit;
 	}
-	remove_iwpm_mapped_port(&mapped_ports, iwpm_port);
+	remove_iwpm_mapped_port(iwpm_port);
 	free_iwpm_port(iwpm_port);
 remove_mapping_exit:
 	return ret;
@@ -641,7 +640,7 @@ static int process_iwpm_wire_request(iwpm_msg_parms *msg_parms, int nl_sock,
 
 	copy_iwpm_sockaddr(msg_parms->address_family, NULL, &local_addr,
 				 &msg_parms->apipaddr[0], NULL, &msg_parms->apport);
-	iwpm_port = find_iwpm_mapping(mapped_ports, &local_addr, not_mapped);
+	iwpm_port = find_iwpm_mapping(&local_addr, not_mapped);
 	if (!iwpm_port) {
 		/* could not find mapping for the requested address */
 		iwpm_debug(IWARP_PM_WIRE_DBG, "process_wire_request: "
@@ -737,7 +736,7 @@ static int process_iwpm_wire_accept(iwpm_msg_parms *msg_parms, int nl_sock,
 	copy_iwpm_sockaddr(msg_parms->address_family, NULL, &remote_mapped_addr,
 				&msg_parms->apipaddr[0], NULL, &msg_parms->apport);
 	ret = -EINVAL;
-	iwpm_port = find_iwpm_same_mapping(mapped_ports, &local_addr, not_mapped); 
+	iwpm_port = find_iwpm_same_mapping(&local_addr, not_mapped);
 	if (!iwpm_port) {
 		iwpm_debug(IWARP_PM_WIRE_DBG, "process_wire_accept: "
 			"Received accept for unknown mapping.\n");
@@ -812,7 +811,7 @@ static int process_iwpm_wire_reject(iwpm_msg_parms *msg_parms, int nl_sock)
 	print_iwpm_sockaddr(&remote_addr, "process_wire_reject: Remote address",
 					IWARP_PM_ALL_DBG);
 	ret = -EINVAL;
-	iwpm_port = find_iwpm_same_mapping(mapped_ports, &local_addr, not_mapped); 
+	iwpm_port = find_iwpm_same_mapping(&local_addr, not_mapped);
 	if (!iwpm_port) {
 		syslog(LOG_WARNING, "process_wire_reject: Received reject for unknown mapping.\n");
 		return 0;
@@ -857,7 +856,7 @@ static int process_iwpm_wire_ack(iwpm_msg_parms *msg_parms)
 
 	copy_iwpm_sockaddr(msg_parms->address_family, NULL, &local_mapped_addr,
 				&msg_parms->apipaddr[0], NULL, &msg_parms->apport);
-	iwpm_port = find_iwpm_mapping(mapped_ports, &local_mapped_addr, not_mapped);
+	iwpm_port = find_iwpm_mapping(&local_mapped_addr, not_mapped);
 	if (!iwpm_port) {
 		iwpm_debug(IWARP_PM_WIRE_DBG, "process_wire_ack: Received ack for unknown mapping.\n");
 		return 0;
@@ -905,7 +904,7 @@ static int process_iwpm_mapinfo(struct nlmsghdr *req_nlh, int client_idx, int nl
 	local_addr = (struct sockaddr_storage *)nla_data(nltb[IWPM_NLA_MAPINFO_LOCAL_ADDR]);
 	local_mapped_addr = (struct sockaddr_storage *)nla_data(nltb[IWPM_NLA_MAPINFO_MAPPED_ADDR]);
 
-	iwpm_port = find_iwpm_mapping(mapped_ports, local_addr, not_mapped); 
+	iwpm_port = find_iwpm_mapping(local_addr, not_mapped);
 	if (iwpm_port) {
 		/* Can be safely ignored, if the mapinfo is exactly the same,
  		 * because the client will provide all the port information it has and 
@@ -926,7 +925,7 @@ static int process_iwpm_mapinfo(struct nlmsghdr *req_nlh, int client_idx, int nl
 		goto process_mapinfo_error;
 	}
 	/* add the new mapping to the list */
-	add_iwpm_mapped_port(&mapped_ports, iwpm_port);
+	add_iwpm_mapped_port(iwpm_port);
 process_mapinfo_exit:
 	mapinfo_num_list[client_idx]++;
 	return 0;
@@ -1301,7 +1300,7 @@ static int iwarp_port_mapper()
 	do {
 		do {
 			if (print_mappings) {
-				print_iwpm_mapped_ports(mapped_ports);
+				print_iwpm_mapped_ports();
 				print_mappings = 0;
 			}
 			/* initialize the file sets for select */
-- 
2.10.1.382.ga23ca1b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
