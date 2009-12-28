From: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>
Subject: [PATCH] INFINIBAND:  Correct CONFIG_IPv6 to CONFIG_IPV6.
Date: Mon, 28 Dec 2009 16:48:08 -0500 (EST)
Message-ID: <alpine.LFD.2.00.0912281644290.3429@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Correct misspelled "CONFIG_IPv6" that was introduced in commit
d14714df61681cfecf945a58436edf197327e87f, should be all uppercase.

Signed-off-by: Robert P. J. Day <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>

---

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index fbdd731..cc9b594 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2083,7 +2083,7 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
 			       struct sockaddr *addr)
 {
-#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	struct sockaddr_in6 *sin6;

 	if (addr->sa_family != AF_INET6)

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
