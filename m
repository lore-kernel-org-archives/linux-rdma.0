From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 08/10] verbs: Tag matching send interface
Date: Mon, 23 Oct 2017 16:17:59 +0300
Message-ID: <1508764681-4531-9-git-send-email-yishaih@mellanox.com>
References: <1508764681-4531-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508764681-4531-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add tag matching header (TMH) and rendezvous header (RVH) definitions
to infiniband/tm_types.h.
Add TM message building explanations to Documentation/tag_matching.md.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Documentation/tag_matching.md | 52 ++++++++++++++++++++++++++++++++
 debian/libibverbs-dev.install |  1 +
 libibverbs/CMakeLists.txt     |  1 +
 libibverbs/tm_types.h         | 70 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+)
 create mode 100644 libibverbs/tm_types.h

diff --git a/Documentation/tag_matching.md b/Documentation/tag_matching.md
index 1e5a929..23d6532 100644
--- a/Documentation/tag_matching.md
+++ b/Documentation/tag_matching.md
@@ -234,6 +234,58 @@ While **wr_id** identifies the tag manipulation operation itself, the
 completions.
 
 
+### Sending TM messages
+
+TM messages are sent using standard RC Send operations. A TM message comprises
+a Tag-Matching Header (TMH), an optional Rendezvous Header (RVH), and
+a payload.
+
+TMH and RVH are defined in infiniband/tm_types.h:
+
+```h
+struct ibv_tmh {
+	  uint8_t	  opcode;
+	  uint8_t	  reserved[3];
+	  __be32	  app_ctx;
+	  __be64	  tag;
+};
+```
+```h
+struct ibv_rvh {
+	  __be64	  va;
+	  __be32	  rkey;
+	  __be32	  len;
+};
+```
+
+The following opcodes are defined:
+
+* **IBV_TM_NO_TAG**   - Send a message without a tag.
+Such a message will always be treated as unexpected by the receiver TM-SRQ.
+Any data following the opcode is ignored by the tag matching logic, and the
+message is delivered in its entirety (including the opcode) to the standard
+SRQ buffer.
+
+* **IBV_TM_OP_EAGER** - Send an eager tagged message.
+The message consists of a TMH followed by payload.
+
+* **IBV_TM_OP_RNDV**  - Send a tagged rendezvous request.
+The message consists of a TMH, an RVH, and optional additional data (which may
+be inspected by receiver SW if the message is deemed unexpected). The RVH must
+refer to a registered buffer containing the rendezvous payload. The total
+rendezvous message size must not exceed the **max_rndv_hdr_size** capability.
+The Sender must consider the operation outstanding until a TM message with the
+**IBV_TM_OP_FIN** opcode is received, after which the buffer may be deregistered
+and freed.
+
+* **IBV_TM_OP_FIN**   - Send a rendezvous completion indication.
+The message consists of a copy of the original TMH and RVH of the rendezvous
+request, apart the opcode. This message is sent after the receiver has
+completed the transfer of the rendezvous payload by an RDMA-read operation. It
+may be sent either by HW or SW, depending on whether the rendezvous request
+was handled as expected or unexpected by the TM-SRQ.
+
+
 ### TM completion processing
 
 There are 2 types of TM completions: tag-manipulation and receive completions.
diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index b854a19..026327e 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -6,6 +6,7 @@ usr/include/infiniband/opcode.h
 usr/include/infiniband/sa-kern-abi.h
 usr/include/infiniband/sa.h
 usr/include/infiniband/verbs.h
+usr/include/infiniband/tm_types.h
 usr/lib/*/libibverbs*.so
 usr/lib/*/libmlx4.so
 usr/lib/*/libmlx5.so
diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
index 863c395..af340a8 100644
--- a/libibverbs/CMakeLists.txt
+++ b/libibverbs/CMakeLists.txt
@@ -5,6 +5,7 @@ publish_headers(infiniband
   sa-kern-abi.h
   sa.h
   verbs.h
+  tm_types.h
   )
 
 publish_internal_headers(infiniband
diff --git a/libibverbs/tm_types.h b/libibverbs/tm_types.h
new file mode 100644
index 0000000..9a50d45
--- /dev/null
+++ b/libibverbs/tm_types.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2017 Mellanox Technologies Ltd.  All rights reserved.
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
+ *
+ */
+#ifndef _TM_TYPES_H
+#define _TM_TYPES_H
+
+#include <linux/types.h>
+#include <stdint.h>
+
+#ifdef __cplusplus
+#  define BEGIN_C_DECLS extern "C" {
+#  define END_C_DECLS   }
+#else				/* !__cplusplus */
+#  define BEGIN_C_DECLS
+#  define END_C_DECLS
+#endif				/* __cplusplus */
+
+BEGIN_C_DECLS
+
+enum ibv_tmh_op {
+	IBV_TMH_NO_TAG	      = 0,
+	IBV_TMH_RNDV	      = 1,
+	IBV_TMH_FIN	      = 2,
+	IBV_TMH_EAGER	      = 3,
+};
+
+struct ibv_tmh {
+	uint8_t		opcode;      /* from enum ibv_tmh_op */
+	uint8_t		reserved[3]; /* must be zero */
+	__be32		app_ctx;     /* opaque user data */
+	__be64		tag;
+};
+
+struct ibv_rvh {
+	__be64		va;
+	__be32		rkey;
+	__be32		len;
+};
+
+END_C_DECLS
+#endif				/* _TM_TYPES_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
