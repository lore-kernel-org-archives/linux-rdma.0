From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/10] IB/hfi1: Add tracing support for send with invalidate
 opcode
Date: Tue, 24 May 2016 12:50:17 -0700
Message-ID: <20160524195015.19706.29475.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Enable trace generation for packets with the "Send Last with
Invalidate" and "Send Only with Invalidate" opcodes.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace.c |    7 +++++++
 drivers/infiniband/hw/hfi1/trace.h |    2 ++
 drivers/infiniband/hw/hfi1/verbs.c |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index caddb2a..79b2952 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -66,6 +66,7 @@ u8 ibhdr_exhdr_len(struct hfi1_ib_header *hdr)
 #define RETH_PRN "reth vaddr 0x%.16llx rkey 0x%.8x dlen 0x%.8x"
 #define AETH_PRN "aeth syn 0x%.2x %s msn 0x%.8x"
 #define DETH_PRN "deth qkey 0x%.8x sqpn 0x%.6x"
+#define IETH_PRN "ieth rkey 0x%.8x"
 #define ATOMICACKETH_PRN "origdata %lld"
 #define ATOMICETH_PRN "vaddr 0x%llx rkey 0x%.8x sdata %lld cdata %lld"
 
@@ -166,6 +167,12 @@ const char *parse_everbs_hdrs(
 				 be32_to_cpu(eh->ud.deth[0]),
 				 be32_to_cpu(eh->ud.deth[1]) & RVT_QPN_MASK);
 		break;
+	/* ieth */
+	case OP(RC, SEND_LAST_WITH_INVALIDATE):
+	case OP(RC, SEND_ONLY_WITH_INVALIDATE):
+		trace_seq_printf(p, IETH_PRN,
+				 be32_to_cpu(eh->ieth));
+		break;
 	}
 	trace_seq_putc(p, 0);
 	return ret;
diff --git a/drivers/infiniband/hw/hfi1/trace.h b/drivers/infiniband/hw/hfi1/trace.h
index a6c1adf..28c1d08 100644
--- a/drivers/infiniband/hw/hfi1/trace.h
+++ b/drivers/infiniband/hw/hfi1/trace.h
@@ -392,6 +392,8 @@ __print_symbolic(opcode,                                   \
 	ib_opcode_name(RC_ATOMIC_ACKNOWLEDGE),             \
 	ib_opcode_name(RC_COMPARE_SWAP),                   \
 	ib_opcode_name(RC_FETCH_ADD),                      \
+	ib_opcode_name(RC_SEND_LAST_WITH_INVALIDATE),      \
+	ib_opcode_name(RC_SEND_ONLY_WITH_INVALIDATE),      \
 	ib_opcode_name(UC_SEND_FIRST),                     \
 	ib_opcode_name(UC_SEND_MIDDLE),                    \
 	ib_opcode_name(UC_SEND_LAST),                      \
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index ae92ac5..849c4b9 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -335,6 +335,8 @@ const u8 hdr_len_by_opcode[256] = {
 	[IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE]             = 12 + 8 + 4,
 	[IB_OPCODE_RC_COMPARE_SWAP]                   = 12 + 8 + 28,
 	[IB_OPCODE_RC_FETCH_ADD]                      = 12 + 8 + 28,
+	[IB_OPCODE_RC_SEND_LAST_WITH_INVALIDATE]      = 12 + 8 + 4,
+	[IB_OPCODE_RC_SEND_ONLY_WITH_INVALIDATE]      = 12 + 8 + 4,
 	/* UC */
 	[IB_OPCODE_UC_SEND_FIRST]                     = 12 + 8,
 	[IB_OPCODE_UC_SEND_MIDDLE]                    = 12 + 8,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
