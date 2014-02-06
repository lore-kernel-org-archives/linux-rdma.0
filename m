From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 1/2] Add general definitions to support uverbs extensions
Date: Thu,  6 Feb 2014 14:20:32 +0200
Message-ID: <1391689233-12968-2-git-send-email-ogerlitz@mellanox.com>
References: <1391689233-12968-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391689233-12968-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

To support verbs extension mechanism between libibverbs and the uverbs
kernel layer, each new added verb which is based on the verbs extensions
approach should include an extended header, containing:

	__u16 provider_in_words;
	__u16 provider_out_words;
	__u32 cmd_hdr_reserved;
	__u32 comp_mask;

The above fields will be initialized by IBV_INIT_CMD_EX and IBV_INIT_CMD_RESP_EX
new macros.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/kern-abi.h |   36 ++++++++++++++++++++++++++++++++++++
 src/ibverbs.h                 |   29 +++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 064f1aa..0b9c79e 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -48,6 +48,8 @@
 #define IB_USER_VERBS_MIN_ABI_VERSION	3
 #define IB_USER_VERBS_MAX_ABI_VERSION	6
 
+#define IB_USER_VERBS_CMD_THRESHOLD    50
+
 enum {
 	IB_USER_VERBS_CMD_GET_CONTEXT,
 	IB_USER_VERBS_CMD_QUERY_DEVICE,
@@ -92,6 +94,14 @@ enum {
 	IB_USER_VERBS_CMD_OPEN_QP
 };
 
+#define IB_USER_VERBS_CMD_COMMAND_MASK		0xff
+#define IB_USER_VERBS_CMD_FLAGS_MASK		0xff000000u
+#define IB_USER_VERBS_CMD_FLAGS_SHIFT		24
+
+
+#define IB_USER_VERBS_CMD_FLAG_EXTENDED		0x80ul
+
+
 /*
  * Make sure that all structs defined in this file remain laid out so
  * that they pack the same way on 32-bit and 64-bit architectures (to
@@ -103,6 +113,32 @@ enum {
  *    different between 32-bit and 64-bit architectures.
  */
 
+struct hdr {
+	__u32 command;
+	__u16 in_words;
+	__u16 out_words;
+};
+
+struct response_hdr {
+	__u64 response;
+};
+
+struct ex_hdr {
+	struct {
+		__u32 command;
+		__u16 in_words;
+		__u16 out_words;
+	};
+	struct {
+		__u64 response;
+	};
+	struct {
+		__u16 provider_in_words;
+		__u16 provider_out_words;
+		__u32 reserved;
+	};
+};
+
 struct ibv_kern_async_event {
 	__u64 element;
 	__u32 event_type;
diff --git a/src/ibverbs.h b/src/ibverbs.h
index fa6cd41..ff206f9 100644
--- a/src/ibverbs.h
+++ b/src/ibverbs.h
@@ -102,4 +102,33 @@ HIDDEN int ibverbs_init(struct ibv_device ***list);
 		(cmd)->response  = (uintptr_t) (out);			\
 	} while (0)
 
+#define IBV_INIT_CMD_RESP_EX_V(cmd, cmd_size, size, opcode, out, resp_size,\
+		outsize)						   \
+	do {                                                               \
+		size_t c_size = cmd_size - sizeof(struct ex_hdr);	   \
+		if (abi_ver > 2)					   \
+			(cmd)->hdr.command = IB_USER_VERBS_CMD_##opcode;   \
+		else							   \
+			(cmd)->hdr.command =				   \
+				IB_USER_VERBS_CMD_##opcode##_V2;	   \
+		(cmd)->hdr.in_words  = ((c_size) / 8);                     \
+		(cmd)->hdr.out_words = ((resp_size) / 8);                  \
+		(cmd)->hdr.provider_in_words   = (((size) - (cmd_size))/8);\
+		(cmd)->hdr.provider_out_words  =			   \
+			     (((outsize) - (resp_size)) / 8);              \
+		(cmd)->hdr.response  = (uintptr_t) (out);                  \
+		(cmd)->hdr.reserved = 0;				   \
+	} while (0)
+
+#define IBV_INIT_CMD_RESP_EX_VCMD(cmd, cmd_size, size, opcode, out, outsize) \
+	IBV_INIT_CMD_RESP_EX_V(cmd, cmd_size, size, opcode, out,	     \
+			sizeof(*(out)), outsize)
+
+#define IBV_INIT_CMD_RESP_EX(cmd, size, opcode, out, outsize)		     \
+	IBV_INIT_CMD_RESP_EX_V(cmd, sizeof(*(cmd)), size, opcode, out,    \
+			sizeof(*(out)), outsize)
+
+#define IBV_INIT_CMD_EX(cmd, size, opcode)				     \
+	IBV_INIT_CMD_RESP_EX_V(cmd, sizeof(*(cmd)), size, opcode, NULL, 0, 0)
+
 #endif /* IB_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
