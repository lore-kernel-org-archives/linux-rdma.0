From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC] Here is a <not tested> patch that I think removes support
	for binding
Date: Mon, 08 Feb 2010 14:30:38 -0600
Message-ID: <20100208203038.12539.199.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

to 127.0.0.1.  Sean will this work?

If we agree to do this for 2.6.33, then I'll build/test this and resubmit.

----

rdma/cma: Disallow binding rdma endpoints to 127.0.0.1.

Currently this functionality breaks openmpi.  Once openmpi is fixed to
correctly ignore 127.0.0.1 as a valid external rdma address, we can
re-enable this functionality.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index cc9b594..cd3d351 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -628,19 +628,9 @@ static inline int cma_zero_addr(struct sockaddr *addr)
 	}
 }
 
-static inline int cma_loopback_addr(struct sockaddr *addr)
-{
-	if (addr->sa_family == AF_INET)
-		return ipv4_is_loopback(
-			((struct sockaddr_in *) addr)->sin_addr.s_addr);
-	else
-		return ipv6_addr_loopback(
-			&((struct sockaddr_in6 *) addr)->sin6_addr);
-}
-
 static inline int cma_any_addr(struct sockaddr *addr)
 {
-	return cma_zero_addr(addr) || cma_loopback_addr(addr);
+	return cma_zero_addr(addr);
 }
 
 static inline __be16 cma_port(struct sockaddr *addr)
@@ -2115,9 +2105,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (ret)
 		goto err1;
 
-	if (cma_loopback_addr(addr)) {
-		ret = cma_bind_loopback(id_priv);
-	} else if (!cma_zero_addr(addr)) {
+	if (!cma_zero_addr(addr)) {
 		ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
 		if (ret)
 			goto err1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
