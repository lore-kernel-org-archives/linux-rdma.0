From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCHv2 12/16 ibacm] Increase buffer space for inet_ntop from 32
 to INET6_ADDRSTRLEN
Date: Thu, 27 Jun 2013 15:14:15 -0400
Message-ID: <51CC8F07.5020703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Rebased

 linux/acme_linux.c |    2 +-
 src/acm.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/linux/acme_linux.c b/linux/acme_linux.c
index 1039645..ef5b107 100644
--- a/linux/acme_linux.c
+++ b/linux/acme_linux.c
@@ -149,7 +149,7 @@ int gen_addr_ip(FILE *f)
 {
 	struct ifconf *ifc;
 	struct ifreq *ifr;
-	char ip[sizeof "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff"];
+	char ip[INET6_ADDRSTRLEN];
 	int s, ret, dev_index, i, len;
 	uint16_t pkey;
 	uint8_t port;
diff --git a/src/acm.c b/src/acm.c
index aac7883..74c99e3 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -2795,7 +2795,7 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 	FILE *faddr;
 	char *dev_name;
 	char s[120];
-	char dev[32], addr[32], pkey_str[8];
+	char dev[32], addr[INET6_ADDRSTRLEN], pkey_str[8];
 	uint16_t pkey;
 	uint8_t type;
 	int port, index = 0;
@@ -2814,7 +2814,7 @@ static int acm_assign_ep_names(struct acm_ep *ep)
 		if (s[0] == '#')
 			continue;
 
-		if (sscanf(s, "%32s%32s%d%8s", addr, dev, &port, pkey_str) != 4)
+		if (sscanf(s, "%46s%32s%d%8s", addr, dev, &port, pkey_str) != 4)
 			continue;
 
 		acm_log(2, "%s", s);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
