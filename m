From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv3 rdma-core 3/3] ibacm: In acm_util.c:acm_if_iter_sys, try
 IPv4 if IPv6 doesn't find any appropriate interfaces
Date: Wed, 25 Oct 2017 12:51:08 -0400
Message-ID: <18b32f97-973a-1eb1-ac57-a5e06287d723@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


This can occur when IPv6 is disabled.

In the case where ipv6 is disabled in kernel, the socket is created
but the ioctl fails.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v2:
Updated commit message to clarify that it's ioctl not socket call which fails when IPv6 is disabled

Changes since v1:
Handle AF_INET6 socket and ioctl errors more "locally" rather than looping around entire routine 
Also, remove loop on no interfaces found

 ibacm/src/acm_util.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/ibacm/src/acm_util.c b/ibacm/src/acm_util.c
index b50fd74..ad454f2 100644
--- a/ibacm/src/acm_util.c
+++ b/ibacm/src/acm_util.c
@@ -127,6 +127,7 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	struct ifconf *ifc;
 	struct ifreq *ifr;
 	char ip_str[INET6_ADDRSTRLEN];
+	int family = AF_INET6;
 	int s, ret, i, len;
 	uint16_t pkey;
 	union ibv_gid sgid;
@@ -135,9 +136,13 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	size_t addr_len;
 	char *alias_sep;
 
-	s = socket(AF_INET6, SOCK_DGRAM, 0);
-	if (!s)
-		return -1;
+	s = socket(family, SOCK_DGRAM, 0);
+	if (!s) {
+		family = AF_INET;
+		s = socket(family, SOCK_DGRAM, 0);
+		if (!s)
+			return -1;
+	}
 
 	len = sizeof(*ifc) + sizeof(*ifr) * 64;
 	ifc = malloc(len);
@@ -150,9 +155,21 @@ int acm_if_iter_sys(acm_if_iter_cb cb, void *ctx)
 	ifc->ifc_len = len - sizeof(*ifc);
 	ifc->ifc_req = (struct ifreq *) (ifc + 1);
 
+retry_ioctl:
 	ret = ioctl(s, SIOCGIFCONF, ifc);
 	if (ret < 0) {
-		acm_log(0, "ioctl ifconf error: %s\n", strerror(errno));
+		acm_log(0, "ioctl IPv%s ifconf error: %s\n",
+			(family == AF_INET6) ? "6" : "4", strerror(errno));
+		if (family == AF_INET6) {
+			close(s);
+			family = AF_INET;
+			s = socket(family, SOCK_DGRAM, 0);
+			if (!s) {
+				free(ifc);
+				return ret;
+			}
+			goto retry_ioctl;
+		}
 		goto out2;
 	}
 
@@ -207,5 +224,4 @@ out2:
 out1:
 	close(s);
 	return ret;
-
 }
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
