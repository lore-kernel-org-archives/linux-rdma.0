From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 16/17] verb: Use kernel uapi header in struct ex_hdr
Date: Thu, 11 Jan 2018 15:13:39 -0700
Message-ID: <20180111221340.965-17-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

All the components are defined by the uapi header. Revise
the macro to use the new names.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/ibverbs.h  | 14 +++++++-------
 libibverbs/kern-abi.h | 15 ++-------------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/libibverbs/ibverbs.h b/libibverbs/ibverbs.h
index 7755393fe4f3ce..ceb6c5bfd4e3f9 100644
--- a/libibverbs/ibverbs.h
+++ b/libibverbs/ibverbs.h
@@ -88,15 +88,15 @@ static inline uint32_t _cmd_ex(uint32_t cmd)
 		outsize)						   \
 	do {                                                               \
 		size_t c_size = cmd_size - sizeof(struct ex_hdr);	   \
-		(cmd)->hdr.command =					   \
+		(cmd)->hdr.hdr.command =				   \
 			_cmd_ex(IB_USER_VERBS_EX_CMD_##opcode);		   \
-		(cmd)->hdr.in_words  = ((c_size) / 8);                     \
-		(cmd)->hdr.out_words = ((resp_size) / 8);                  \
-		(cmd)->hdr.provider_in_words   = (((size) - (cmd_size))/8);\
-		(cmd)->hdr.provider_out_words  =			   \
+		(cmd)->hdr.hdr.in_words  = ((c_size) / 8);                 \
+		(cmd)->hdr.hdr.out_words = ((resp_size) / 8);              \
+		(cmd)->hdr.ex_hdr.provider_in_words   = (((size) - (cmd_size))/8);\
+		(cmd)->hdr.ex_hdr.provider_out_words  =			   \
 			     (((outsize) - (resp_size)) / 8);              \
-		(cmd)->hdr.response  = (uintptr_t) (out);                  \
-		(cmd)->hdr.reserved = 0;				   \
+		(cmd)->hdr.ex_hdr.response  = (uintptr_t) (out);           \
+		(cmd)->hdr.ex_hdr.cmd_hdr_reserved = 0;			   \
 	} while (0)
 
 #define IBV_INIT_CMD_RESP_EX_VCMD(cmd, cmd_size, size, opcode, out, outsize) \
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 8400ce1c47e92d..ca7ba14dfdb580 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -65,19 +65,8 @@
  */
 
 struct ex_hdr {
-	struct {
-		__u32 command;
-		__u16 in_words;
-		__u16 out_words;
-	};
-	struct {
-		__u64 response;
-	};
-	struct {
-		__u16 provider_in_words;
-		__u16 provider_out_words;
-		__u32 reserved;
-	};
+	struct ib_uverbs_cmd_hdr hdr;
+	struct ib_uverbs_ex_cmd_hdr ex_hdr;
 };
 
 /*
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
