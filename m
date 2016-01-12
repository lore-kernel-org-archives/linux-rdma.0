From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/1] Ibacm: Check the presence of header files for netlink support
Date: Tue, 12 Jan 2016 13:50:37 -0500
Message-ID: <1452624637-13552-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It was found that the latest ibacm will not build in old distros that
don't have the two header files rdma/rdma_netlink.h and rdma/ib_user_sa.h.
To be backward compatible, the netlink support should be disabled if
the header files were absent. This patch will address the issue.

Reported-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 configure.ac |    7 +++++++
 src/acm.c    |   24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4d493bd..75cc915 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,6 +61,13 @@ AC_CHECK_HEADER(infiniband/umad.h, [],
     AC_MSG_ERROR([<infiniband/umad.h> not found.  Is libibumad installed?]))
 fi
 
+dnl Check netlink header files
+AC_CHECK_HEADER(rdma/rdma_netlink.h,
+    AC_CHECK_HEADER(rdma/ib_user_sa.h,
+        AC_DEFINE(HAVE_NETLINK, 1, [Have netlink header files]),
+        AC_MSG_WARN([Missing rdma/ib_user_sa.h])),
+    AC_MSG_WARN([Missing rdma/rdma_netlink.h]))
+
 dnl Check for gcc atomic intrinsics
 AC_MSG_CHECKING(compiler support for atomics)
 AC_TRY_LINK([int i = 0;],
diff --git a/src/acm.c b/src/acm.c
index 8b6d762..f6191bd 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -46,8 +46,10 @@
 #include <infiniband/acm_prov.h>
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
+#ifdef HAVE_NETLINK
 #include <infiniband/umad_types.h>
 #include <infiniband/umad_sa.h>
+#endif
 #include <dlist.h>
 #include <dlfcn.h> 
 #include <search.h>
@@ -57,14 +59,18 @@
 #include <netinet/in.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#ifdef HAVE_NETLINK
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_user_sa.h>
+#endif
 #include <poll.h>
 #include "acm_mad.h"
 #include "acm_util.h"
+#ifdef HAVE_NETLINK
 #if !defined(RDMA_NL_LS_F_ERR)
 	#include "acm_netlink.h"
 #endif
+#endif
 
 #define src_out     data[0]
 #define src_index   data[1]
@@ -73,7 +79,9 @@
 #define MAX_EP_ADDR 4
 #define NL_MSG_BUF_SIZE 4096
 #define ACM_PROV_NAME_SIZE 64
+#ifdef HAVE_NETLINK
 #define NL_CLIENT_INDEX 0
+#endif
 
 struct acmc_subnet {
 	DLIST_ENTRY            entry;
@@ -160,6 +168,7 @@ struct acmc_sa_req {
 	struct acm_sa_mad	mad;
 };
 
+#ifdef HAVE_NETLINK
 struct acm_nl_path {
 	struct nlattr			attr_hdr;
 	struct ib_path_rec_data		rec;
@@ -174,6 +183,7 @@ struct acm_nl_msg {
 		struct acm_nl_path		path[0];
 	};
 };
+#endif
 
 static char def_prov_name[ACM_PROV_NAME_SIZE] = "ibacmp";
 static DLIST_ENTRY provider_list;
@@ -196,7 +206,9 @@ static struct acmc_ep *acm_find_ep(struct acmc_port *port, uint16_t pkey);
 static int acm_ep_insert_addr(struct acmc_ep *ep, const char *name, uint8_t *addr,
 			      size_t addr_len, uint8_t addr_type);
 static void acm_event_handler(struct acmc_device *dev);
+#ifdef HAVE_NETLINK
 static int acm_nl_send(SOCKET sock, struct acm_msg *msg);
+#endif
 
 static struct sa_data {
 	int		timeout;
@@ -491,9 +503,11 @@ int acm_resolve_response(uint64_t id, struct acm_msg *msg)
 		goto release;
 	}
 
+#ifdef HAVE_NETLINK
 	if (id == NL_CLIENT_INDEX)
 		ret = acm_nl_send(client->sock, msg);
 	else
+#endif
 		ret = send(client->sock, (char *) msg, msg->hdr.length, 0);
 
 	if (ret != msg->hdr.length)
@@ -626,8 +640,10 @@ static void acm_svr_accept(void)
 	}
 
 	for (i = 0; i < FD_SETSIZE - 1; i++) {
+	#ifdef HAVE_NETLINK
 		if (i == NL_CLIENT_INDEX)
 			continue;
+	#endif
 		if (!atomic_get(&client_array[i].refcnt))
 			break;
 	}
@@ -1377,6 +1393,7 @@ static void acm_ipnl_handler(void)
 	}
 }
 
+#ifdef HAVE_NETLINK
 static int acm_nl_send(SOCKET sock, struct acm_msg *msg)
 {
 	struct sockaddr_nl dst_addr;
@@ -1698,6 +1715,7 @@ static int acm_init_nl(void)
 	client_array[NL_CLIENT_INDEX].sock = nl_rcv_socket;
 	return 0;
 }
+#endif
 
 static void acm_server(void)
 {
@@ -1713,9 +1731,11 @@ static void acm_server(void)
 		acm_log(0, "ERROR - server listen failed\n");
 		return;
 	}
+#ifdef HAVE_NETLINK
 	ret = acm_init_nl();
 	if (ret)
 		acm_log(1, "Warn - Netlink init failed\n");
+#endif
 
 	while (1) {
 		n = (int) listen_socket;
@@ -1754,9 +1774,11 @@ static void acm_server(void)
 			if (client_array[i].sock != INVALID_SOCKET &&
 				FD_ISSET(client_array[i].sock, &readfds)) {
 				acm_log(2, "receiving from client %d\n", i);
+			#ifdef HAVE_NETLINK
 				if (i == NL_CLIENT_INDEX)
 					acm_nl_receive(&client_array[i]);
 				else
+			#endif
 					acm_svr_receive(&client_array[i]);
 			}
 		}
@@ -3119,8 +3141,10 @@ int CDECL_FUNC main(int argc, char **argv)
 	acm_server();
 
 	acm_log(0, "shutting down\n");
+#ifdef HAVE_NETLINK
 	if (client_array[NL_CLIENT_INDEX].sock != INVALID_SOCKET)
 		close(client_array[NL_CLIENT_INDEX].sock);
+#endif
 	acm_close_providers();
 	acm_stop_sa_handler();
 	umad_done();
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
