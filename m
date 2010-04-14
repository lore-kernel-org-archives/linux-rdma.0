From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [1/2] fix libibnetdisc cache error path memleak
Date: Wed, 14 Apr 2010 15:47:49 -0700
Message-ID: <1271285269.17987.139.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-1mwWHNySB++98o1x7hi5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-1mwWHNySB++98o1x7hi5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

This patch fixes a mem-leak through error paths in the libibnetdisc
cache loading.  If some data had not yet been "copied over" to the
fabric struct and an error occurred, that memory would be leaked.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-1mwWHNySB++98o1x7hi5
Content-Disposition: attachment; filename=0001-fix-libibnetdisc-cache-error-path-memleak.patch
Content-Type: message/rfc822; name=0001-fix-libibnetdisc-cache-error-path-memleak.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 14 Apr 2010 14:11:27 -0700
Subject: [PATCH] fix libibnetdisc cache error path memleak
Message-Id: <1271284770.17987.131.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |    2 +-
 .../libibnetdisc/src/ibnetdisc_cache.c             |   13 +++++++++++--
 infiniband-diags/libibnetdisc/src/internal.h       |    2 ++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index c895de9..dfd7dce 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -510,7 +510,7 @@ error:
 	return NULL;
 }
 
-static void destroy_node(ibnd_node_t * node)
+void destroy_node(ibnd_node_t * node)
 {
 	int p = 0;
 
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index 480a0a2..2ec353d 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -113,6 +113,7 @@ typedef struct ibnd_node_cache {
 	ibnd_port_cache_key_t *port_cache_keys;
 	struct ibnd_node_cache *next;
 	struct ibnd_node_cache *htnext;
+	int node_stored_to_fabric;
 } ibnd_node_cache_t;
 
 typedef struct ibnd_port_cache {
@@ -122,6 +123,7 @@ typedef struct ibnd_port_cache {
 	ibnd_port_cache_key_t remoteport_cache_key;
 	struct ibnd_port_cache *next;
 	struct ibnd_port_cache *htnext;
+	int port_stored_to_fabric;
 } ibnd_port_cache_t;
 
 typedef struct ibnd_fabric_cache {
@@ -257,6 +259,9 @@ static int _load_header_info(int fd, ibnd_fabric_cache_t * fabric_cache,
 static void _destroy_ibnd_node_cache(ibnd_node_cache_t * node_cache)
 {
 	free(node_cache->port_cache_keys);
+	if (!node_cache->node_stored_to_fabric
+	    && node_cache->node)
+		destroy_node(node_cache->node);
 	free(node_cache);
 }
 
@@ -283,6 +288,9 @@ static void _destroy_ibnd_fabric_cache(ibnd_fabric_cache_t * fabric_cache)
 	while (port_cache) {
 		port_cache_next = port_cache->next;
 
+		if (!port_cache->port_stored_to_fabric
+		    && port_cache->port)
+			free(port_cache->port);
 		free(port_cache);
 
 		port_cache = port_cache_next;
@@ -387,8 +395,6 @@ static int _load_node(int fd, ibnd_fabric_cache_t * fabric_cache)
 	return 0;
 
 cleanup:
-	/* note, no need to destroy node through destroy_node(), nothing else malloced */
-	free(node);
 	_destroy_ibnd_node_cache(node_cache);
 	return -1;
 }
@@ -500,6 +506,7 @@ static int _fill_port(ibnd_fabric_cache_t * fabric_cache, ibnd_node_t * node,
 	}
 
 	node->ports[port_cache->port->portnum] = port_cache->port;
+	port_cache->port_stored_to_fabric++;
 
 	/* achu: needed if user wishes to re-cache a loaded fabric.
 	 * Otherwise, mostly unnecessary to do this.
@@ -532,6 +539,8 @@ static int _rebuild_nodes(ibnd_fabric_cache_t * fabric_cache)
 
 		add_to_type_list(node_cache->node, fabric_cache->fabric);
 
+		node_cache->node_stored_to_fabric++;
+
 		/* Rebuild node ports array */
 
 		if (!(node->ports =
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 57034f9..32d567e 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -98,4 +98,6 @@ void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
 
 void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric);
 
+void destroy_node(ibnd_node_t * node);
+
 #endif				/* _INTERNAL_H_ */
-- 
1.5.4.5


--=-1mwWHNySB++98o1x7hi5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
