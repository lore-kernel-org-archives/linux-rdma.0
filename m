From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Support RAI_NUMERICHOST and no delay options
Date: Wed, 8 Dec 2010 17:56:45 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8C1F140@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support similar to getaddrinfo AI_NUMERICHOST.  This
indicates that lengthy address resolution protocols should
not be used.  Also allow a caller of rdma_getaddrinfo to
indicate that lengthy route resolution protocols should not
be used.

Since rdma_getaddrinfo is a synchronous call, this allows a
user to obtain locally available data only without long
delays that may block an application thread.  Callers can then
use the asynchronous librdmacm calls to complete any missing
information.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_cma.h |    2 ++
 man/rdma_getaddrinfo.3  |    5 +++++
 src/acm.c               |    2 ++
 src/addrinfo.c          |    3 ++-
 4 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index d17ef88..b48cd2e
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -165,6 +165,8 @@ struct rdma_cm_event {
 };
 
 #define RAI_PASSIVE		0x00000001
+#define RAI_NUMERICHOST		0x00000002
+#define RAI_NOROUTE		0x00000004
 
 struct rdma_addrinfo {
 	int			ai_flags;
diff --git a/man/rdma_getaddrinfo.3 b/man/rdma_getaddrinfo.3
index c418b5a..e69d8ce
--- a/man/rdma_getaddrinfo.3
+++ b/man/rdma_getaddrinfo.3
@@ -38,6 +38,11 @@ Hint flags that control the operation.  Supported flags are:
 .IP "RAI_PASSIVE" 12
 Indicates that the results will be used on the passive/listening
 side of a connection.
+.IP "RAI_NUMERICHOST" 12
+If specified, then the node parameter, if provided, must be a numerical
+network address.  This flag suppresses any lengthy address resolution. 
+.IP "RAI_NOROUTE" 12
+If set, this flag suppresses any lengthy route resolution.
 .IP "ai_family" 12
 Address family for the source and destination address.  Supported families
 are: AF_INET, AF_INET6, and AF_IB.
diff --git a/src/acm.c b/src/acm.c
index e2d02b4..1fa6c62 100755
--- a/src/acm.c
+++ b/src/acm.c
@@ -292,6 +292,8 @@ void ucma_ib_resolve(struct rdma_addrinfo *rai, struct rdma_addrinfo *hints)
 
 	if (rai->ai_dst_len) {
 		data->flags = ACM_EP_FLAG_DEST;
+		if (rai->ai_flags & (RAI_NUMERICHOST | RAI_NOROUTE))
+			data->flags |= ACM_FLAGS_NODELAY;
 		ucma_copy_rai_addr(data, rai->ai_dst_addr);
 		data++;
 		msg.hdr.length += ACM_MSG_EP_LENGTH;
diff --git a/src/addrinfo.c b/src/addrinfo.c
index a1cb8a5..021f7c4 100755
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -48,7 +48,8 @@
 static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 {
 	memset(ai, 0, sizeof *ai);
-	ai->ai_flags = (rai->ai_flags & RAI_PASSIVE) ? AI_PASSIVE : 0;
+	ai->ai_flags  = (rai->ai_flags & RAI_PASSIVE) ? AI_PASSIVE : 0;
+	ai->ai_flags |= (rai->ai_flags & RAI_NUMERICHOST) ? AI_NUMERICHOST : 0;
 	ai->ai_family = rai->ai_family;
 
 	switch (rai->ai_qp_type) {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
