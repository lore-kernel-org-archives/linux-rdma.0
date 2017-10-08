From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH rdma-core] iwpmd: Return existing mapping if port reused on active side
Date: Sun,  8 Oct 2017 18:34:28 -0500
Message-ID: <20171008233429.16348-1-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Port-mapper returns a duplicate mapping error and no
mapped port if an attempt is made to add a mapping for
a new connection which re-uses the local port on active side.
Fix this by finding the existing  mapping for the re-used
local port and return the mapped port. Also, change ref_cnt
in struct iwpm_port to be atomic and use it to track the
references to a mapping.

Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 iwpmd/iwarp_pm.h        |  5 ++---
 iwpmd/iwarp_pm_helper.c | 27 ++++-----------------------
 iwpmd/iwarp_pm_server.c | 47 +++++++++++++++++++++--------------------------
 3 files changed, 27 insertions(+), 52 deletions(-)

diff --git a/iwpmd/iwarp_pm.h b/iwpmd/iwarp_pm.h
index fc09e4fd..501f1992 100644
--- a/iwpmd/iwarp_pm.h
+++ b/iwpmd/iwarp_pm.h
@@ -54,6 +54,7 @@
 #include <netlink/msg.h>
 #include <ccan/list.h>
 #include <rdma/rdma_netlink.h>
+#include <stdatomic.h>
 
 #define IWARP_PM_PORT          3935
 #define IWARP_PM_VER_SHIFT     6
@@ -139,7 +140,7 @@ typedef struct iwpm_mapped_port {
 	struct sockaddr_storage	    local_addr;
 	struct sockaddr_storage	    mapped_addr;
 	int			    wcard;
-	int			    ref_cnt; /* the number of owners, if wcard */
+	_Atomic(int)		    ref_cnt; /* the number of owners */
 } iwpm_mapped_port;
 
 typedef struct iwpm_wire_msg {
@@ -252,8 +253,6 @@ void print_iwpm_mapped_ports(void);
 
 void free_iwpm_port(iwpm_mapped_port *);
 
-int free_iwpm_wcard_mapping(iwpm_mapped_port *);
-
 iwpm_mapping_request *create_iwpm_map_request(struct nlmsghdr *, struct sockaddr_storage *,
 					struct sockaddr_storage *, __u64, int, iwpm_send_msg *);
 
diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index 63530f1d..ff7e72a7 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -341,10 +341,9 @@ static iwpm_mapped_port *get_iwpm_port(int client_idx, struct sockaddr_storage *
 	memcpy(&iwpm_port->mapped_addr, mapped_addr, sizeof(struct sockaddr_storage));
 	iwpm_port->owner_client = client_idx;
 	iwpm_port->sd = sd;
-        if (is_wcard_ipaddr(local_addr)) {
+	atomic_init(&iwpm_port->ref_cnt, 1);
+	if (is_wcard_ipaddr(local_addr))
 		iwpm_port->wcard = 1;
-		iwpm_port->ref_cnt = 1;
-	}
 	return iwpm_port;
 }
 
@@ -415,12 +414,9 @@ reopen_mapped_port_error:
 void add_iwpm_mapped_port(iwpm_mapped_port *iwpm_port)
 {
 	static int dbg_idx = 1;
+	if (atomic_load(&iwpm_port->ref_cnt) > 1)
+		return;
 	iwpm_debug(IWARP_PM_ALL_DBG, "add_iwpm_mapped_port: Adding a new mapping #%d\n", dbg_idx++);
-	/* only one mapping per wild card ip address */
-	if (iwpm_port->wcard) {
-		if (iwpm_port->ref_cnt > 1)
-			return;
-	}
 	list_add(&mapped_ports, &iwpm_port->entry);
 }
 
@@ -518,21 +514,6 @@ find_same_mapping_exit:
 	return saved_iwpm_port;
 }
 
-/**
- * free_iwpm_wcard_port - Free wild card mapping object
- * @iwpm_port: mapped port object to be freed
- *
- * Mappings with wild card IP addresses can't be freed
- * while their reference count > 0
- */
-int free_iwpm_wcard_mapping(iwpm_mapped_port *iwpm_port)
-{
-	if (iwpm_port->ref_cnt > 0)
-		iwpm_port->ref_cnt--;
-
-	return iwpm_port->ref_cnt;
-}
-
 /**
  * free_iwpm_port - Free mapping object
  * @iwpm_port: mapped port object to be freed
diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index ef541c81..caa87cb9 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -315,7 +315,7 @@ static int process_iwpm_add_mapping(struct nlmsghdr *req_nlh, int client_idx, in
 	__u16 err_code = 0;
 	const char *msg_type = "Add Mapping Request";
 	const char *str_err = "";
-	int ret = -EINVAL, ref_cnt;
+	int ret = -EINVAL;
 
 	if (parse_iwpm_nlmsg(req_nlh, IWPM_NLA_MANAGE_MAPPING_MAX, manage_map_policy, nltb, msg_type)) {
 		err_code = IWPM_INVALID_NLMSG_ERR;
@@ -327,7 +327,7 @@ static int process_iwpm_add_mapping(struct nlmsghdr *req_nlh, int client_idx, in
 	iwpm_port = find_iwpm_mapping(local_addr, not_mapped);
 	if (iwpm_port) {
 		if (check_same_sockaddr(local_addr, &iwpm_port->local_addr) && iwpm_port->wcard) {
-				iwpm_port->ref_cnt++;
+			atomic_fetch_add(&iwpm_port->ref_cnt, 1);
 		} else {
 			err_code = IWPM_DUPLICATE_MAPPING_ERR;
 			str_err = "Duplicate mapped port";
@@ -373,12 +373,8 @@ add_mapping_free_error:
 	if (resp_nlmsg)
 		nlmsg_free(resp_nlmsg);
 	if (iwpm_port) {
-		if (iwpm_port->wcard) {
-			ref_cnt = free_iwpm_wcard_mapping(iwpm_port);
-			if (ref_cnt)
-				goto add_mapping_error;
-		}
-		free_iwpm_port(iwpm_port);
+		if (atomic_fetch_sub(&iwpm_port->ref_cnt, 1) == 1)
+			free_iwpm_port(iwpm_port);
 	}
 add_mapping_error:
 	syslog(LOG_WARNING, "process_add_mapping: %s (failed request from client = %s).\n",
@@ -433,15 +429,14 @@ static int process_iwpm_query_mapping(struct nlmsghdr *req_nlh, int client_idx,
 
 	iwpm_port = find_iwpm_mapping(local_addr, not_mapped);
 	if (iwpm_port) {
-		err_code = IWPM_DUPLICATE_MAPPING_ERR;
-		str_err = "Duplicate mapped port";
-		goto query_mapping_error;
-	}
-	iwpm_port = create_iwpm_mapped_port(local_addr, client_idx);
-	if (!iwpm_port) {
-		err_code = IWPM_CREATE_MAPPING_ERR;
-		str_err = "Unable to create new mapping";
-		goto query_mapping_error;
+		atomic_fetch_add(&iwpm_port->ref_cnt, 1);
+	} else {
+		iwpm_port = create_iwpm_mapped_port(local_addr, client_idx);
+		if (!iwpm_port) {
+			err_code = IWPM_CREATE_MAPPING_ERR;
+			str_err = "Unable to create new mapping";
+			goto query_mapping_error;
+		}
 	}
 	if (iwpm_port->wcard) {
 		err_code = IWPM_CREATE_MAPPING_ERR;
@@ -497,10 +492,13 @@ static int process_iwpm_query_mapping(struct nlmsghdr *req_nlh, int client_idx,
 
 	add_iwpm_map_request(iwpm_map_req);
 	add_iwpm_mapped_port(iwpm_port);
+
 	return send_iwpm_msg(form_iwpm_request, &msg_parms, &dest_addr.s_sockaddr, pm_client_sock);
 query_mapping_free_error:
-	if (iwpm_port)
-		free_iwpm_port(iwpm_port);
+	if (iwpm_port) {
+		if (atomic_fetch_sub(&iwpm_port->ref_cnt, 1) == 1)
+			free_iwpm_port(iwpm_port);
+	}
 	if (send_msg)
 		free(send_msg);
 	if (iwpm_map_req)
@@ -528,7 +526,7 @@ static int process_iwpm_remove_mapping(struct nlmsghdr *req_nlh, int client_idx,
 	struct nlattr *nltb [IWPM_NLA_MANAGE_MAPPING_MAX];
 	int not_mapped = 1;
 	const char *msg_type = "Remove Mapping Request";
-	int ret = 0, ref_cnt;
+	int ret = 0;
 
 	if (parse_iwpm_nlmsg(req_nlh, IWPM_NLA_MANAGE_MAPPING_MAX, manage_map_policy, nltb, msg_type)) {
 		send_iwpm_error_msg(req_nlh->nlmsg_seq, IWPM_INVALID_NLMSG_ERR, client_idx, nl_sock);
@@ -554,13 +552,10 @@ static int process_iwpm_remove_mapping(struct nlmsghdr *req_nlh, int client_idx,
 				client_idx);
 		goto remove_mapping_exit;
 	}
-	if (iwpm_port->wcard) {
-		ref_cnt = free_iwpm_wcard_mapping(iwpm_port);
-		if (ref_cnt)
-			goto remove_mapping_exit;
+	if (atomic_fetch_sub(&iwpm_port->ref_cnt, 1) == 1) {
+		remove_iwpm_mapped_port(iwpm_port);
+		free_iwpm_port(iwpm_port);
 	}
-	remove_iwpm_mapped_port(iwpm_port);
-	free_iwpm_port(iwpm_port);
 remove_mapping_exit:
 	return ret;
 }
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
