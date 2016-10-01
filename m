From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] IB/hfi1: Fix trace of atomic ack
Date: Fri, 30 Sep 2016 20:11:15 -0700
Message-ID: <20161001031114.15264.36761.stgit@scvm10.sc.intel.com>
References: <20161001030935.15264.34730.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161001030935.15264.34730.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The length is incorrect, causing the trace data to
be truncated.

Add the additional 8 bytes that should have been there.
Also trace out the atomic ack in hex to aid debugging.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace.c |    4 ++--
 drivers/infiniband/hw/hfi1/verbs.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace.c b/drivers/infiniband/hw/hfi1/trace.c
index 4a0221f..01f525c 100644
--- a/drivers/infiniband/hw/hfi1/trace.c
+++ b/drivers/infiniband/hw/hfi1/trace.c
@@ -67,8 +67,8 @@ u8 ibhdr_exhdr_len(struct ib_header *hdr)
 #define AETH_PRN "aeth syn 0x%.2x %s msn 0x%.8x"
 #define DETH_PRN "deth qkey 0x%.8x sqpn 0x%.6x"
 #define IETH_PRN "ieth rkey 0x%.8x"
-#define ATOMICACKETH_PRN "origdata %lld"
-#define ATOMICETH_PRN "vaddr 0x%llx rkey 0x%.8x sdata %lld cdata %lld"
+#define ATOMICACKETH_PRN "origdata %llx"
+#define ATOMICETH_PRN "vaddr 0x%llx rkey 0x%.8x sdata %llx cdata %llx"
 
 #define OP(transport, op) IB_OPCODE_## transport ## _ ## op
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 1f19334..f2f6b5a 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -335,7 +335,7 @@ const u8 hdr_len_by_opcode[256] = {
 	[IB_OPCODE_RC_RDMA_READ_RESPONSE_LAST]        = 12 + 8 + 4,
 	[IB_OPCODE_RC_RDMA_READ_RESPONSE_ONLY]        = 12 + 8 + 4,
 	[IB_OPCODE_RC_ACKNOWLEDGE]                    = 12 + 8 + 4,
-	[IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE]             = 12 + 8 + 4,
+	[IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE]             = 12 + 8 + 4 + 8,
 	[IB_OPCODE_RC_COMPARE_SWAP]                   = 12 + 8 + 28,
 	[IB_OPCODE_RC_FETCH_ADD]                      = 12 + 8 + 28,
 	[IB_OPCODE_RC_SEND_LAST_WITH_INVALIDATE]      = 12 + 8 + 4,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
