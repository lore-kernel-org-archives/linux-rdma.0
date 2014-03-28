From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 11/16] ibacm: Add thread to monitor IP address changes
Date: Thu, 27 Mar 2014 22:50:05 -0700
Message-ID: <1395985810-23822-12-git-send-email-sean.hefty@intel.com>
References: <1395985810-23822-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395985810-23822-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently only reports events to the log

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index ebb48f4..a23e953 100644
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
 
@@ -3368,6 +3371,86 @@ static void acm_port_down(struct acm_port *port)
 	acm_log(1, "%s %d is down\n", port->dev->verbs->device->name, port->port_num);
 }
 
+
+#define NL_MSG_BUF_SIZE 4096
+static void CDECL_FUNC acm_ipnl_handler(void *context)
+{
+	struct sockaddr_nl addr;
+	int sock, len;
+	char buffer[NL_MSG_BUF_SIZE];
+	struct nlmsghdr *nlh;
+	char name[IFNAMSIZ];
+	char ip_str[INET6_ADDRSTRLEN];
+
+	if ((sock = socket(PF_NETLINK, SOCK_RAW, NETLINK_ROUTE)) == -1) {
+		acm_log(0, "Failed to open NETLINK_ROUTE socket");
+		return;
+	}
+
+	memset(&addr, 0, sizeof(addr));
+	addr.nl_family = AF_NETLINK;
+	addr.nl_groups = RTMGRP_LINK | RTMGRP_IPV4_IFADDR;
+
+	if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) == -1) {
+		acm_log(0, "Failed to bind NETLINK_ROUTE socket");
+		return;
+	}
+
+	while ((len = recv(sock, buffer, NL_MSG_BUF_SIZE, 0)) > 0) {
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
+	return;
+}
+
 /*
  * There is one event handler thread per device.  This is the only thread that
  * modifies the port state or a port endpoint list.  Other threads which access
@@ -3750,6 +3833,9 @@ int CDECL_FUNC main(int argc, char **argv)
 		return -1;
 	}
 
+	acm_log(1, "starting IP Netlink thread\n");
+	beginthread(acm_ipnl_handler, NULL);
+
 	acm_activate_devices();
 	acm_log(1, "starting timeout/retry thread\n");
 	beginthread(acm_retry_handler, NULL);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
