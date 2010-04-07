From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/37] librdmacm: add zalloc call
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <53A8AB949BCE4311B58A4881EC549E90@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |    6 ++----
 src/cma.h |   10 ++++++++++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index a85448b..4025aeb 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -342,11 +342,10 @@ static struct cma_id_private *ucma_alloc_id(struct rdma_event_channel *channel,
 {
 	struct cma_id_private *id_priv;
 
-	id_priv = malloc(sizeof *id_priv);
+	id_priv = zalloc(sizeof *id_priv);
 	if (!id_priv)
 		return NULL;
 
-	memset(id_priv, 0, sizeof *id_priv);
 	id_priv->id.context = context;
 	id_priv->id.ps = ps;
 	id_priv->id.channel = channel;
@@ -1228,11 +1227,10 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 	int ret, size;
 	
 	id_priv = container_of(id, struct cma_id_private, id);
-	mc = malloc(sizeof *mc);
+	mc = zalloc(sizeof *mc);
 	if (!mc)
 		return ERR(ENOMEM);
 
-	memset(mc, 0, sizeof *mc);
 	mc->context = context;
 	mc->id_priv = id_priv;
 	memcpy(&mc->addr, addr, addrlen);
diff --git a/src/cma.h b/src/cma.h
index 1c0ab8b..fcfb1f7 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -42,6 +42,7 @@
 #include <errno.h>
 #include <endian.h>
 #include <byteswap.h>
+#include <string.h>
 
 #ifdef INCLUDE_VALGRIND
 #   include <valgrind/memcheck.h>
@@ -70,5 +71,14 @@ static inline int ERR(int err)
 	return -1;
 }
 
+static inline void *zalloc(size_t size)
+{
+	void *buf;
+
+	if ((buf = malloc(size)))
+		memset(buf, 0, size);
+	return buf;
+}
+
 #endif /* CMA_H */
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
