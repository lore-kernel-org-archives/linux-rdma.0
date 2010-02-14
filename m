From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2 1/2] IB/core: Add support for enhanced atomic operations
Date: Sun, 14 Feb 2010 15:51:28 +0200
Message-ID: <20100214135128.GA7607@vlad-laptop>
Reply-To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

- Add a new IB_WR_ATOMIC_MASKED_CMP_AND_SWP and IB_WR_ATOMIC_MASKED_FETCH_AND_ADD send
opcodes that can be used to mark a "masked atomic compare and swap" and
"masked atomic fetch and add" work request correspondingly.
- Add IB_DEVICE_MASKED_ATOMIC capability bit.
- Add mask fields to atomic struct of ib_send_wr
- Add new opcodes to ib_wc_opcode

Signed-off-by: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/rdma/ib_verbs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 09509ed..338cff1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -105,6 +105,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_UD_TSO		= (1<<19),
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
+	IB_DEVICE_MASKED_ATOMIC		= (1<<23),
 };
 
 enum ib_atomic_cap {
@@ -467,6 +468,8 @@ enum ib_wc_opcode {
 	IB_WC_LSO,
 	IB_WC_LOCAL_INV,
 	IB_WC_FAST_REG_MR,
+	IB_WC_MASKED_COMP_SWAP,
+	IB_WC_MASKED_FETCH_ADD,
 /*
  * Set value of IB_WC_RECV so consumers can test if a completion is a
  * receive by testing (opcode & IB_WC_RECV).
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
1.6.6.GIT

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
