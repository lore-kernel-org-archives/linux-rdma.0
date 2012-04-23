From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/15] uDAPL v2.0 scm: use ioctl SIOCIFCONF to get complete
 list of configured netdev interfaces
Date: Mon, 23 Apr 2012 20:01:03 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F94812027B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

replace usage of getaddrinfo since is doesnt actually return bound addresses
and can return the loopback address in some configurations. Some
systems may not have eth0 configured so you cannot assume eth0 as a non-loopback
default netdev.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/util.c |   55 ++++++++++++++------------------------------
 1 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index 053c376..c118ca9 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -155,12 +155,11 @@ char *dapl_ib_mtu_str(enum ibv_mtu mtu)
 DAT_RETURN getlocalipaddr(char *addr, int addr_len)
 {
 	struct sockaddr_in *sin;
-	struct addrinfo *res, hint, *ai;
-	int ret;
-	char hostname[256];
+	int ret, skfd, i;
 	char *netdev = getenv("DAPL_SCM_NETDEV");
+	struct ifreq ifr[10];
+	struct ifconf ifc;
 
-retry:
 	/* use provided netdev instead of default hostname */
 	if (netdev != NULL) {
 		ret = getipaddr_netdev(netdev, addr, addr_len);
@@ -174,46 +173,28 @@ retry:
 			return DAT_SUCCESS;
 	}
 
-	if (addr_len < sizeof(*sin)) {
+	if (addr_len < sizeof(*sin))
 		return DAT_INTERNAL_ERROR;
-	}
 
-	ret = gethostname(hostname, 256);
+	memset(&ifc,0,sizeof(ifc));
+	ifc.ifc_buf = (char *)ifr;
+	ifc.ifc_len = sizeof(ifr);
+
+	skfd = socket(PF_INET, SOCK_STREAM, 0);
+	ret = ioctl(skfd, SIOCGIFCONF, &ifc);
 	if (ret)
-		return dapl_convert_errno(ret, "gethostname");
-
-	memset(&hint, 0, sizeof hint);
-	hint.ai_flags = AI_PASSIVE;
-	hint.ai_family = AF_INET;
-	hint.ai_socktype = SOCK_STREAM;
-	hint.ai_protocol = IPPROTO_TCP;
-
-	ret = getaddrinfo(hostname, NULL, &hint, &res);
-	if (ret) {
-		dapl_log(DAPL_DBG_TYPE_ERR,
-			 " getaddrinfo ERR: %d %s\n", ret, gai_strerror(ret));
-		return DAT_INVALID_ADDRESS;
-	}
+		goto bail;
 
-	ret = DAT_INVALID_ADDRESS;
-	for (ai = res; ai; ai = ai->ai_next) {
-		sin = (struct sockaddr_in *)ai->ai_addr;
-		if (*((uint32_t *) & sin->sin_addr) != htonl(0x7f000001)) {
-			*((struct sockaddr_in *)addr) = *sin;
-			ret = DAT_SUCCESS;
+	/* first non-loopback interface in list */
+	for (i=0; i < ifc.ifc_len/sizeof(struct ifreq); i++) {
+		if (strcmp(ifr[i].ifr_name, "lo"))
 			break;
-		}
 	}
+	memcpy(addr, &ifr[i].ifr_addr, sizeof(struct sockaddr_in));
 
-	freeaddrinfo(res);
-
-	/* only loopback found, retry netdev eth0 */
-	if (ret == DAT_INVALID_ADDRESS) {
-		netdev = "eth0";
-		goto retry;
-	}
-
-	return ret;
+bail:
+	close(skfd);
+	return dapl_convert_errno(ret, "getlocalipaddr");
 }
 
 /*
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
