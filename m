From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/8] rdmacm: constify rdma_getaddrinfo public function
Date: Fri, 14 Oct 2016 16:14:10 -0600
Message-ID: <1476483257-16308-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1476483257-16308-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476483257-16308-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Like getaddrinfo most of the arguments should be const.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 librdmacm/acm.c                  |  3 ++-
 librdmacm/addrinfo.c             | 14 ++++++++------
 librdmacm/cma.h                  |  3 ++-
 librdmacm/man/rdma_getaddrinfo.3 |  6 +++---
 librdmacm/rdma_cma.h             |  4 ++--
 5 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/librdmacm/acm.c b/librdmacm/acm.c
index ad6706b2592e..ccd5494c631d 100644
--- a/librdmacm/acm.c
+++ b/librdmacm/acm.c
@@ -363,7 +363,8 @@ static int ucma_ib_addr(struct sockaddr *addr, socklen_t len)
 	return len && addr && (addr->sa_family == AF_IB);
 }
 
-void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints)
+void ucma_ib_resolve(struct rdma_addrinfo **rai,
+		     const struct rdma_addrinfo *hints)
 {
 	struct acm_msg msg;
 	struct acm_ep_addr_data *data;
diff --git a/librdmacm/addrinfo.c b/librdmacm/addrinfo.c
index 2c515a257a27..ac346438a6d0 100644
--- a/librdmacm/addrinfo.c
+++ b/librdmacm/addrinfo.c
@@ -45,7 +45,8 @@
 
 static struct rdma_addrinfo nohints;
 
-static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
+static void ucma_convert_to_ai(struct addrinfo *ai,
+			       const struct rdma_addrinfo *rai)
 {
 	memset(ai, 0, sizeof(*ai));
 	if (rai->ai_flags & RAI_PASSIVE)
@@ -141,7 +142,8 @@ static int ucma_convert_in6(int ps, struct sockaddr_ib **dst, socklen_t *dst_len
 }
 
 static int ucma_convert_to_rai(struct rdma_addrinfo *rai,
-			       struct rdma_addrinfo *hints, struct addrinfo *ai)
+			       const struct rdma_addrinfo *hints,
+			       const struct addrinfo *ai)
 {
 	int ret;
 
@@ -210,8 +212,8 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai,
 	return ret;
 }
 
-static int ucma_getaddrinfo(char *node, char *service,
-			    struct rdma_addrinfo *hints,
+static int ucma_getaddrinfo(const char *node, const char *service,
+			    const struct rdma_addrinfo *hints,
 			    struct rdma_addrinfo *rai)
 {
 	struct addrinfo ai_hints;
@@ -232,8 +234,8 @@ static int ucma_getaddrinfo(char *node, char *service,
 	return ret;
 }
 
-int rdma_getaddrinfo(char *node, char *service,
-		     struct rdma_addrinfo *hints,
+int rdma_getaddrinfo(const char *node, const char *service,
+		     const struct rdma_addrinfo *hints,
 		     struct rdma_addrinfo **res)
 {
 	struct rdma_addrinfo *rai;
diff --git a/librdmacm/cma.h b/librdmacm/cma.h
index 1610e178dfdb..6fe786052dff 100644
--- a/librdmacm/cma.h
+++ b/librdmacm/cma.h
@@ -140,7 +140,8 @@ extern int af_ib_support;
 
 void ucma_ib_init(void);
 void ucma_ib_cleanup(void);
-void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints);
+void ucma_ib_resolve(struct rdma_addrinfo **rai,
+		     const struct rdma_addrinfo *hints);
 
 struct ib_connect_hdr {
 	uint8_t  cma_version;
diff --git a/librdmacm/man/rdma_getaddrinfo.3 b/librdmacm/man/rdma_getaddrinfo.3
index cd819c6cdf42..9e133ffea0a5 100644
--- a/librdmacm/man/rdma_getaddrinfo.3
+++ b/librdmacm/man/rdma_getaddrinfo.3
@@ -5,9 +5,9 @@ rdma_getaddrinfo \- Provides transport independent address translation.
 .B "#include <rdma/rdma_cma.h>"
 .P
 .B "int" rdma_getaddrinfo
-.BI "(char *" node ","
-.BI "char *" service ","
-.BI "struct rdma_addrinfo *" hints ","
+.BI "(const char *" node ","
+.BI "const char *" service ","
+.BI "const struct rdma_addrinfo *" hints ","
 .BI "struct rdma_addrinfo **" res ");"
 .SH ARGUMENTS
 .IP "node" 12
diff --git a/librdmacm/rdma_cma.h b/librdmacm/rdma_cma.h
index 2055665a1496..45c492ab6217 100644
--- a/librdmacm/rdma_cma.h
+++ b/librdmacm/rdma_cma.h
@@ -668,8 +668,8 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel);
 /**
  * rdma_getaddrinfo - RDMA address and route resolution service.
  */
-int rdma_getaddrinfo(char *node, char *service,
-		     struct rdma_addrinfo *hints,
+int rdma_getaddrinfo(const char *node, const char *service,
+		     const struct rdma_addrinfo *hints,
 		     struct rdma_addrinfo **res);
 
 void rdma_freeaddrinfo(struct rdma_addrinfo *res);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
