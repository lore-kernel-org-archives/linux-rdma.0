From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: initialize correct pthread condition in rdma_join_multicast
Date: Wed, 21 Oct 2009 11:47:17 -0700
Message-ID: <04702C2CBECB44E5A2D3D3495EA0378B@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

rdma_join_multicast re-initializes id_priv->cond rather than mc->cond.
Fix this.  Bug reported by Nir Naaman.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 87e73ac..e4bc8d6 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1044,7 +1044,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	mc->context = context;
 	mc->id_priv = id_priv;
 	memcpy(&mc->addr, addr, addrlen);
-	if (pthread_cond_init(&id_priv->cond, NULL)) {
+	if (pthread_cond_init(&mc->cond, NULL)) {
 		ret = -1;
 		goto err1;
 	}



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
