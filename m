From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/14] ibacm: Add Netlink socket to monitor IP address changes
Date: Thu,  3 Apr 2014 20:51:50 -0400
Message-ID: <1396572714-16498-11-git-send-email-ira.weiny@intel.com>
References: <1396572714-16498-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396572714-16498-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently only reports events to the log.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index af1c66e..45f3ed9 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -49,6 +49,9 @@
 #include <net/if.h>
 #include <sys/ioctl.h>
 #include <net/if_arp.h>
+#include <netinet/in.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
 #include "acm_mad.h"
 #include "acm_util.h"
 
@@ -214,6 +217,7 @@ static event_t timeout_event;
 static atomic_t wait_cnt;
 
 static SOCKET listen_socket;
+static SOCKET ip_mon_socket;
 static struct acm_client client[FD_SETSIZE - 1];
 
 static FILE *flog;
@@ -2389,6 +2393,92 @@ out:
 		acm_disconnect_client(client);
 }
 
+static int acm_ipnl_create(void)
+{
+	struct sockaddr_nl addr;
+
+	if ((ip_mon_socket = socket(PF_NETLINK, SOCK_RAW | SOCK_NONBLOCK, NETLINK_ROUTE)) == -1) {
+		acm_log(0, "Failed to open NETLINK_ROUTE socket");
+		return EIO;
+	}
+
+	memset(&addr, 0, sizeof(addr));
+	addr.nl_family = AF_NETLINK;
+	addr.nl_groups = RTMGRP_LINK | RTMGRP_IPV4_IFADDR;
+
+	if (bind(ip_mon_socket, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
+		acm_log(0, "Failed to bind NETLINK_ROUTE socket");
+		return EIO;
+	}
+
+	return 0;
+}
+
+#define NL_MSG_BUF_SIZE 4096
+static void acm_ipnl_handler(void)
+{
+	int len;
+	char buffer[NL_MSG_BUF_SIZE];
+	struct nlmsghdr *nlh;
+	char name[IFNAMSIZ];
+	char ip_str[INET6_ADDRSTRLEN];
+
+	while ((len = recv(ip_mon_socket, buffer, NL_MSG_BUF_SIZE, 0)) > 0) {
+		nlh = (struct nlmsghdr *)buffer;
+		while ((NLMSG_OK(nlh, len)) && (nlh->nlmsg_type != NLMSG_DONE)) {
+			struct ifaddrmsg *ifa = (struct ifaddrmsg *) NLMSG_DATA(nlh);
+			struct ifinfomsg *ifi = (struct ifinfomsg *) NLMSG_DATA(nlh);
+			struct rtattr *rth = IFA_RTA(ifa);
+			int rtl = IFA_PAYLOAD(nlh);
+
+			switch (nlh->nlmsg_type) {
+			case RTM_NEWADDR:
+			{
+				if_indextoname(ifa->ifa_index, name);
+				while (rtl && RTA_OK(rth, rtl)) {
+					if (rth->rta_type == IFA_LOCAL) {
+						acm_log(0, "Address added %s : %s\n",
+						        name, inet_ntop(ifa->ifa_family, RTA_DATA(rth),
+							ip_str, sizeof(ip_str)));
+					}
+					rth = RTA_NEXT(rth, rtl);
+				}
+				break;
+			}
+			case RTM_DELADDR:
+			{
+				if_indextoname(ifa->ifa_index, name);
+				while (rtl && RTA_OK(rth, rtl)) {
+					if (rth->rta_type == IFA_LOCAL) {
+						acm_log(0, "Address deleted %s : %s\n",
+						        name, inet_ntop(ifa->ifa_family, RTA_DATA(rth),
+							ip_str, sizeof(ip_str)));
+					}
+					rth = RTA_NEXT(rth, rtl);
+				}
+				break;
+			}
+			case RTM_NEWLINK:
+			{
+				acm_log(2, "Link added : %s\n", if_indextoname(ifi->ifi_index, name));
+				break;
+			}
+			case RTM_DELLINK:
+			{
+				acm_log(2, "Link removed : %s\n", if_indextoname(ifi->ifi_index, name));
+				break;
+			}
+			default:
+				acm_log(2, "unknown netlink message\n");
+				break;
+			}
+			nlh = NLMSG_NEXT(nlh, len);
+		}
+	}
+	if (len < 0 && errno == ENOBUFS)
+		acm_log(0, "ENOBUFS returned from netlink... Resyncing all IP's\n");
+}
+
 static void acm_server(void)
 {
 	fd_set readfds;
@@ -2407,6 +2497,9 @@ static void acm_server(void)
 		FD_ZERO(&readfds);
 		FD_SET(listen_socket, &readfds);
 
+		n = max(n, (int) ip_mon_socket);
+		FD_SET(ip_mon_socket, &readfds);
+
 		for (i = 0; i < FD_SETSIZE - 1; i++) {
 			if (client[i].sock != INVALID_SOCKET) {
 				FD_SET(client[i].sock, &readfds);
@@ -2423,6 +2516,9 @@ static void acm_server(void)
 		if (FD_ISSET(listen_socket, &readfds))
 			acm_svr_accept();
 
+		if (FD_ISSET(ip_mon_socket, &readfds))
+			acm_ipnl_handler();
+
 		for (i = 0; i < FD_SETSIZE - 1; i++) {
 			if (client[i].sock != INVALID_SOCKET &&
 				FD_ISSET(client[i].sock, &readfds)) {
@@ -3746,6 +3842,9 @@ int CDECL_FUNC main(int argc, char **argv)
 		return -1;
 	}
 
+	acm_log(1, "creating IP Netlink socket\n");
+	acm_ipnl_create();
+
 	acm_activate_devices();
 	acm_log(1, "starting timeout/retry thread\n");
 	beginthread(acm_retry_handler, NULL);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
