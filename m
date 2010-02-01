From: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 1/2] IB/core: Add support for enhanced atomic operations
Date: Mon, 1 Feb 2010 17:59:59 +0200
Message-ID: <20100201155959.GA17341@vlad-laptop>
Reply-To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patchset adds support for the following enhanced atomic
operations:
- Masked atomic compare and swap
- Masked atomic fetch and add

These operations enable using a smaller amount of memory when using
multiple locks by using portions of a 64 bit value in an atomic operation.

- Add new IB_WR_ATOMIC_MASKED_CMP_AND_SWP and
  IB_WR_ATOMIC_MASKED_FETCH_AND_ADD send opcodes that can be used to mark a
  "masked atomic compare and swap" and "masked atomic fetch and add" work
  request correspondingly.
- Add IB_DEVICE_MASKED_ATOMIC capability bit.
- Add mask fields to atomic struct of ib_send_wr
- Add new opcodes to ib_wc_opcode

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/rdma/ib_verbs.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..e2adeef 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -105,6 +105,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_UD_TSO		= (1<<19),
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
+	IB_DEVICE_MASKED_ATOMIC		= (1<<23),
 };
 
 enum ib_atomic_cap {
@@ -472,7 +473,9 @@ enum ib_wc_opcode {
  * receive by testing (opcode & IB_WC_RECV).
  */
 	IB_WC_RECV			= 1 << 7,
-	IB_WC_RECV_RDMA_WITH_IMM
+	IB_WC_RECV_RDMA_WITH_IMM,
+	IB_WC_MASKED_COMP_SWAP,
+	IB_WC_MASKED_FETCH_ADD
 };
 
 enum ib_wc_flags {
@@ -689,6 +692,8 @@ enum ib_wr_opcode {
 	IB_WR_RDMA_READ_WITH_INV,
 	IB_WR_LOCAL_INV,
 	IB_WR_FAST_REG_MR,
+	IB_WR_ATOMIC_MASKED_CMP_AND_SWP,
+	IB_WR_ATOMIC_MASKED_FETCH_AND_ADD,
 };
 
 enum ib_send_flags {
@@ -732,6 +737,8 @@ struct ib_send_wr {
 			u64	compare_add;
 			u64	swap;
 			u32	rkey;
+			u64	compare_add_mask;
+			u64	swap_mask;
 		} atomic;
 		struct {
 			struct ib_ah *ah;
-- 
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
