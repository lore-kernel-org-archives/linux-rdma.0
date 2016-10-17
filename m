From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/13] ibacm: remove HAVE_NETLINK
Date: Mon, 17 Oct 2016 21:11:10 +0200
Message-ID: <1476731482-26491-2-git-send-email-hch@lst.de>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We now always require netlink support

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 buildlib/config.h.in |  3 ---
 ibacm/src/acm.c      | 25 +------------------------
 2 files changed, 1 insertion(+), 27 deletions(-)

diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index 2378180..e4e7b9e 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -6,9 +6,6 @@
 #define HAVE_TYPEOF 1
 #define HAVE_ISBLANK 1
 
-// FIXME: Remove this, we provide the netlink kernel headers ibacm needs
-#define HAVE_NETLINK 1
-
 // FIXME: Remove this, The cmake version hard-requires new style CLOEXEC support
 #define STREAM_CLOEXEC "e"
 
diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index befe942..01ba4e1 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -44,10 +44,8 @@
 #include <infiniband/acm_prov.h>
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
-#ifdef HAVE_NETLINK
 #include <infiniband/umad_types.h>
 #include <infiniband/umad_sa.h>
-#endif
 #include <dlist.h>
 #include <dlfcn.h> 
 #include <search.h>
@@ -57,19 +55,15 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
-#ifdef HAVE_NETLINK
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_user_sa.h>
-#endif
 #include <poll.h>
 #include <inttypes.h>
 #include "acm_mad.h"
 #include "acm_util.h"
-#ifdef HAVE_NETLINK
 #if !defined(RDMA_NL_LS_F_ERR)
 	#include "acm_netlink.h"
 #endif
-#endif
 
 #define src_out     data[0]
 #define src_index   data[1]
@@ -78,9 +72,7 @@
 #define MAX_EP_ADDR 4
 #define NL_MSG_BUF_SIZE 4096
 #define ACM_PROV_NAME_SIZE 64
-#ifdef HAVE_NETLINK
 #define NL_CLIENT_INDEX 0
-#endif
 
 struct acmc_subnet {
 	DLIST_ENTRY            entry;
@@ -167,7 +159,6 @@ struct acmc_sa_req {
 	struct acm_sa_mad	mad;
 };
 
-#ifdef HAVE_NETLINK
 struct acm_nl_path {
 	struct nlattr			attr_hdr;
 	struct ib_path_rec_data		rec;
@@ -182,7 +173,6 @@ struct acm_nl_msg {
 		struct acm_nl_path		path[0];
 	};
 };
-#endif
 
 static char def_prov_name[ACM_PROV_NAME_SIZE] = "ibacmp";
 static DLIST_ENTRY provider_list;
@@ -205,9 +195,7 @@ static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey);
 static int acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			      size_t addr_len, uint8_t addr_type);
 static void acm_event_handler(struct acmc_device *dev);
-#ifdef HAVE_NETLINK
 static int acm_nl_send(SOCKET sock, struct acm_msg *msg);
-#endif
 
 static struct sa_data {
 	int		timeout;
@@ -502,11 +490,9 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
 		goto release;
 	}
 
-#ifdef HAVE_NETLINK
 	if (id == NL_CLIENT_INDEX)
 		ret = acm_nl_send(client->sock, msg);
 	else
-#endif
 		ret = send(client->sock, (char *) msg, msg->hdr.length, 0);
 
 	if (ret != msg->hdr.length)
@@ -639,10 +625,8 @@ static void acm_svr_accept(void)
 	}
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
-	#ifdef HAVE_NETLINK
 		if (i == NL_CLIENT_INDEX)
 			continue;
-	#endif
 		if (!atomic_get(&client_array[i].refcnt))
 			break;
 	}
@@ -1392,7 +1376,6 @@ static void acm_ipnl_handler(void)
 	}
 }
 
-#ifdef HAVE_NETLINK
 static int acm_nl_send(SOCKET sock, struct acm_msg *msg)
 {
 	struct sockaddr_nl dst_addr;
@@ -1714,7 +1697,6 @@ static int acm_init_nl(void)
 	client_array[NL_CLIENT_INDEX].sock = nl_rcv_socket;
 	return 0;
 }
-#endif
 
 static void acm_server(void)
 {
@@ -1730,11 +1712,10 @@ static void acm_server(void)
 		acm_log(0, "ERROR - server listen failed\n");
 		return;
 	}
-#ifdef HAVE_NETLINK
+
 	ret = acm_init_nl();
 	if (ret)
 		acm_log(1, "Warn - Netlink init failed\n");
-#endif
 
 	while (1) {
 		n = (int) listen_socket;
@@ -1773,11 +1754,9 @@ static void acm_server(void)
 			if (client_array[i].sock != INVALID_SOCKET &&
 				FD_ISSET(client_array[i].sock, &readfds)) {
 				acm_log(2, "receiving from client %d\n", i);
-			#ifdef HAVE_NETLINK
 				if (i == NL_CLIENT_INDEX)
 					acm_nl_receive(&client_array[i]);
 				else
-			#endif
 					acm_svr_receive(&client_array[i]);
 			}
 		}
@@ -3143,10 +3122,8 @@ int CDECL_FUNC main(int argc, char **argv)
 	acm_server();
 
 	acm_log(0, "shutting down\n");
-#ifdef HAVE_NETLINK
 	if (client_array[NL_CLIENT_INDEX].sock != INVALID_SOCKET)
 		close(client_array[NL_CLIENT_INDEX].sock);
-#endif
 	acm_close_providers();
 	acm_stop_sa_handler();
 	umad_done();
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
