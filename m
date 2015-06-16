From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH acm] acme.c: Fix IPv6 address handling in inet_any_pton
Date: Tue, 16 Jun 2015 09:37:40 -0400
Message-ID: <558026A4.3090907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In inet_any_pton() routine, src_addr was used by mistake
instead of addr argument.

Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 acm/src/acme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/acm/src/acme.c b/acm/src/acme.c
index 9bf7557..d54c8b9 100644
--- a/acm/src/acme.c
+++ b/acm/src/acme.c
@@ -787,7 +787,7 @@ static int inet_any_pton(char *addr, struct sockaddr *sa)
 	if (ret <= 0) {
 		sin6 = (struct sockaddr_in6 *) sa;
 		sa->sa_family = AF_INET6;
-		ret = inet_pton(AF_INET6, src_addr, &sin6->sin6_addr);
+		ret = inet_pton(AF_INET6, addr, &sin6->sin6_addr);
 	}
 
 	return ret;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
