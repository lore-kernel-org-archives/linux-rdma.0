From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/37] librdmacm: add support to query GIDs
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <0ABB65A55D7B4CA2A4B267AA9B9888EF@amr.corp.intel.com>
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

Support query GID ABI to obtain GID information separately from
path record data and sa_family addressing.

This patch also adds the definition for sockaddr_ib for userspace.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 Makefile.am                 |    6 ++-
 include/infiniband/ib.h     |   97 +++++++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_cma.h     |    4 +-
 include/rdma/rdma_cma_abi.h |    3 +
 src/cma.c                   |   32 ++++++++++++++
 5 files changed, 137 insertions(+), 5 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 290cbc3..2898ad9 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -27,10 +27,11 @@ examples_udaddy_LDADD = $(top_builddir)/src/librdmacm.la
 examples_mckey_SOURCES = examples/mckey.c
 examples_mckey_LDADD = $(top_builddir)/src/librdmacm.la
 
-librdmacmincludedir = $(includedir)/rdma
+librdmacmincludedir = $(includedir)/rdma $(includedir)/infiniband
 
 librdmacminclude_HEADERS = include/rdma/rdma_cma_abi.h \
-			   include/rdma/rdma_cma.h
+			   include/rdma/rdma_cma.h \
+			   include/infiniband/ib.h
 
 man_MANS = \
 	man/rdma_accept.3 \
@@ -68,6 +69,7 @@ man_MANS = \
 	man/rdma_cm.7
 
 EXTRA_DIST = include/rdma/rdma_cma_abi.h include/rdma/rdma_cma.h \
+	     include/infiniband/ib.h \
 	     src/librdmacm.map librdmacm.spec.in $(man_MANS)
 
 dist-hook: librdmacm.spec
diff --git a/include/infiniband/ib.h b/include/infiniband/ib.h
new file mode 100644
index 0000000..3a97322
--- /dev/null
+++ b/include/infiniband/ib.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (c) 2010 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#if !defined(_RDMA_IB_H)
+#define _RDMA_IB_H
+
+#include <linux/types.h>
+#include <string.h>
+
+#ifndef AF_IB
+#define AF_IB 27
+#endif
+#ifndef PF_IB
+#define PF_IB AF_IB
+#endif
+
+struct ib_addr {
+	union {
+		__u8		uib_addr8[16];
+		__be16		uib_addr16[8];
+		__be32		uib_addr32[4];
+		__be64		uib_addr64[2];
+	} ib_u;
+#define sib_addr8		ib_u.uib_addr8
+#define sib_addr16		ib_u.uib_addr16
+#define sib_addr32		ib_u.uib_addr32
+#define sib_addr64		ib_u.uib_addr64
+#define sib_raw			ib_u.uib_addr8
+#define sib_subnet_prefix	ib_u.uib_addr64[0]
+#define sib_interface_id	ib_u.uib_addr64[1]
+};
+
+static inline int ib_addr_any(const struct ib_addr *a)
+{
+	return ((a->sib_addr64[0] | a->sib_addr64[1]) == 0);
+}
+
+static inline int ib_addr_loopback(const struct ib_addr *a)
+{
+	return ((a->sib_addr32[0] | a->sib_addr32[1] |
+		 a->sib_addr32[2] | (a->sib_addr32[3] ^ htonl(1))) == 0);
+}
+
+static inline void ib_addr_set(struct ib_addr *addr,
+			       __be32 w1, __be32 w2, __be32 w3, __be32 w4)
+{
+	addr->sib_addr32[0] = w1;
+	addr->sib_addr32[1] = w2;
+	addr->sib_addr32[2] = w3;
+	addr->sib_addr32[3] = w4;
+}
+
+static inline int ib_addr_cmp(const struct ib_addr *a1, const struct ib_addr *a2)
+{
+	return memcmp(a1, a2, sizeof(struct ib_addr));
+}
+
+struct sockaddr_ib {
+	unsigned short int	sib_family;	/* AF_IB */
+	__be16			sib_pkey;
+	__be32			sib_flowinfo;
+	struct ib_addr		sib_addr;
+	__be64			sib_sid;
+	__be64			sib_sid_mask;
+	__u64			sib_scope_id;
+};
+
+#endif /* _RDMA_IB_H */
diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 534489d..a071a9b 100644
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -78,7 +78,7 @@ enum rdma_port_space {
  */
 #define RDMA_UDP_QKEY 0x01234567
 
-struct ib_addr {
+struct rdma_ib_addr {
 	union ibv_gid	sgid;
 	union ibv_gid	dgid;
 	uint16_t	pkey;
@@ -92,7 +92,7 @@ struct rdma_addr {
 	uint8_t			dst_pad[sizeof(struct sockaddr_storage) -
 					sizeof(struct sockaddr)];
 	union {
-		struct ib_addr	ibaddr;
+		struct rdma_ib_addr	ibaddr;
 	} addr;
 };
 
diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index 6c83fe8..0ef9564 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -116,7 +116,8 @@ struct ucma_abi_resolve_route {
 
 enum {
 	UCMA_QUERY_ADDR,
-	UCMA_QUERY_PATH
+	UCMA_QUERY_PATH,
+	UCMA_QUERY_GID
 };
 
 struct ucma_abi_query {
diff --git a/src/cma.c b/src/cma.c
index c3c6b73..2a70d20 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -54,6 +54,7 @@
 #include <infiniband/marshall.h>
 #include <rdma/rdma_cma.h>
 #include <rdma/rdma_cma_abi.h>
+#include <infiniband/ib.h>
 
 #ifdef INCLUDE_VALGRIND
 #   include <valgrind/memcheck.h>
@@ -506,6 +507,37 @@ static int ucma_query_addr(struct rdma_cm_id *id)
 	return 0;
 }
 
+static int ucma_query_gid(struct rdma_cm_id *id)
+{
+	struct ucma_abi_query_addr_resp *resp;
+	struct ucma_abi_query *cmd;
+	struct cma_id_private *id_priv;
+	struct sockaddr_ib *sib;
+	void *msg;
+	int ret, size;
+	
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size);
+	id_priv = container_of(id, struct cma_id_private, id);
+	cmd->id = id_priv->handle;
+	cmd->option = UCMA_QUERY_GID;
+
+	ret = write(id->channel->fd, msg, size);
+	if (ret != size)
+		return (ret >= 0) ? ERR(ENODATA) : -1;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+
+	sib = (struct sockaddr_ib *) &resp->src_addr;
+	memcpy(id->route.addr.addr.ibaddr.sgid.raw, sib->sib_addr.sib_raw,
+	       sizeof id->route.addr.addr.ibaddr.sgid);
+
+	sib = (struct sockaddr_ib *) &resp->dst_addr;
+	memcpy(id->route.addr.addr.ibaddr.dgid.raw, sib->sib_addr.sib_raw,
+	       sizeof id->route.addr.addr.ibaddr.dgid);
+
+	return 0;
+}
+
 static void ucma_convert_path(struct ib_path_data *path_data,
 			      struct ibv_sa_path_rec *sa_path)
 {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
