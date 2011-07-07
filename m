From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 02/12] Clear status reporting from mthca_cmd
Date: Thu, 7 Jul 2011 12:20:57 -0500
Message-ID: <20110707172056.GC10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_cmd.c |  211 +++++++++++++++----------------
 drivers/infiniband/hw/mthca/mthca_cmd.h |   93 +++++++-------
 2 files changed, 146 insertions(+), 158 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 45461ad..523730a 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -504,17 +504,16 @@ static int mthca_cmd_imm(struct mthca_dev *dev,
 			 u32 in_modifier,
 			 u8 op_modifier,
 			 u16 op,
-			 unsigned long timeout,
-			 u8 *status)
+			 unsigned long timeout)
 {
 	if (dev->cmd.flags & MTHCA_CMD_USE_EVENTS)
 		return mthca_cmd_wait(dev, in_param, out_param, 1,
 				      in_modifier, op_modifier, op,
-				      timeout, status);
+				      timeout);
 	else
 		return mthca_cmd_poll(dev, in_param, out_param, 1,
 				      in_modifier, op_modifier, op,
-				      timeout, status);
+				      timeout);
 }
 
 int mthca_cmd_init(struct mthca_dev *dev)
@@ -631,14 +630,14 @@ void mthca_free_mailbox(struct mthca_dev *dev, struct mthca_mailbox *mailbox)
 	kfree(mailbox);
 }
 
-int mthca_SYS_EN(struct mthca_dev *dev, u8 *status)
+int mthca_SYS_EN(struct mthca_dev *dev)
 {
 	u64 out;
 	int ret;
 
-	ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D, status);
+	ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D);
 
-	if (*status == MTHCA_CMD_STAT_DDR_MEM_ERR)
+	if (ret == -ENOMEM)
 		mthca_warn(dev, "SYS_EN DDR error: syn=%x, sock=%d, "
 			   "sladdr=%d, SPD source=%s\n",
 			   (int) (out >> 6) & 0xf, (int) (out >> 4) & 3,
@@ -647,13 +646,13 @@ int mthca_SYS_EN(struct mthca_dev *dev, u8 *status)
 	return ret;
 }
 
-int mthca_SYS_DIS(struct mthca_dev *dev, u8 *status)
+int mthca_SYS_DIS(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0, 0, CMD_SYS_DIS, CMD_TIME_CLASS_C, status);
+	return mthca_cmd(dev, 0, 0, 0, CMD_SYS_DIS, CMD_TIME_CLASS_C);
 }
 
 static int mthca_map_cmd(struct mthca_dev *dev, u16 op, struct mthca_icm *icm,
-			 u64 virt, u8 *status)
+			 u64 virt)
 {
 	struct mthca_mailbox *mailbox;
 	struct mthca_icm_iter iter;
@@ -701,8 +700,8 @@ static int mthca_map_cmd(struct mthca_dev *dev, u16 op, struct mthca_icm *icm,
 
 			if (++nent == MTHCA_MAILBOX_SIZE / 16) {
 				err = mthca_cmd(dev, mailbox->dma, nent, 0, op,
-						CMD_TIME_CLASS_B, status);
-				if (err || *status)
+						CMD_TIME_CLASS_B);
+				if (err)
 					goto out;
 				nent = 0;
 			}
@@ -711,7 +710,7 @@ static int mthca_map_cmd(struct mthca_dev *dev, u16 op, struct mthca_icm *icm,
 
 	if (nent)
 		err = mthca_cmd(dev, mailbox->dma, nent, 0, op,
-				CMD_TIME_CLASS_B, status);
+				CMD_TIME_CLASS_B);
 
 	switch (op) {
 	case CMD_MAP_FA:
@@ -731,19 +730,19 @@ out:
 	return err;
 }
 
-int mthca_MAP_FA(struct mthca_dev *dev, struct mthca_icm *icm, u8 *status)
+int mthca_MAP_FA(struct mthca_dev *dev, struct mthca_icm *icm)
 {
-	return mthca_map_cmd(dev, CMD_MAP_FA, icm, -1, status);
+	return mthca_map_cmd(dev, CMD_MAP_FA, icm, -1);
 }
 
-int mthca_UNMAP_FA(struct mthca_dev *dev, u8 *status)
+int mthca_UNMAP_FA(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0, 0, CMD_UNMAP_FA, CMD_TIME_CLASS_B, status);
+	return mthca_cmd(dev, 0, 0, 0, CMD_UNMAP_FA, CMD_TIME_CLASS_B);
 }
 
-int mthca_RUN_FW(struct mthca_dev *dev, u8 *status)
+int mthca_RUN_FW(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0, 0, CMD_RUN_FW, CMD_TIME_CLASS_A, status);
+	return mthca_cmd(dev, 0, 0, 0, CMD_RUN_FW, CMD_TIME_CLASS_A);
 }
 
 static void mthca_setup_cmd_doorbells(struct mthca_dev *dev, u64 base)
@@ -772,7 +771,7 @@ static void mthca_setup_cmd_doorbells(struct mthca_dev *dev, u64 base)
 	mthca_dbg(dev, "Mapped doorbell page for posting FW commands\n");
 }
 
-int mthca_QUERY_FW(struct mthca_dev *dev, u8 *status)
+int mthca_QUERY_FW(struct mthca_dev *dev)
 {
 	struct mthca_mailbox *mailbox;
 	u32 *outbox;
@@ -806,7 +805,7 @@ int mthca_QUERY_FW(struct mthca_dev *dev, u8 *status)
 	outbox = mailbox->buf;
 
 	err = mthca_cmd_box(dev, 0, mailbox->dma, 0, 0, CMD_QUERY_FW,
-			    CMD_TIME_CLASS_A, status);
+			    CMD_TIME_CLASS_A);
 
 	if (err)
 		goto out;
@@ -878,7 +877,7 @@ out:
 	return err;
 }
 
-int mthca_ENABLE_LAM(struct mthca_dev *dev, u8 *status)
+int mthca_ENABLE_LAM(struct mthca_dev *dev)
 {
 	struct mthca_mailbox *mailbox;
 	u8 info;
@@ -899,14 +898,11 @@ int mthca_ENABLE_LAM(struct mthca_dev *dev, u8 *status)
 	outbox = mailbox->buf;
 
 	err = mthca_cmd_box(dev, 0, mailbox->dma, 0, 0, CMD_ENABLE_LAM,
-			    CMD_TIME_CLASS_C, status);
+			    CMD_TIME_CLASS_C);
 
 	if (err)
 		goto out;
 
-	if (*status == MTHCA_CMD_STAT_LAM_NOT_PRE)
-		goto out;
-
 	MTHCA_GET(dev->ddr_start, outbox, ENABLE_LAM_START_OFFSET);
 	MTHCA_GET(dev->ddr_end,   outbox, ENABLE_LAM_END_OFFSET);
 	MTHCA_GET(info,           outbox, ENABLE_LAM_INFO_OFFSET);
@@ -931,12 +927,12 @@ out:
 	return err;
 }
 
-int mthca_DISABLE_LAM(struct mthca_dev *dev, u8 *status)
+int mthca_DISABLE_LAM(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0, 0, CMD_SYS_DIS, CMD_TIME_CLASS_C, status);
+	return mthca_cmd(dev, 0, 0, 0, CMD_SYS_DIS, CMD_TIME_CLASS_C);
 }
 
-int mthca_QUERY_DDR(struct mthca_dev *dev, u8 *status)
+int mthca_QUERY_DDR(struct mthca_dev *dev)
 {
 	struct mthca_mailbox *mailbox;
 	u8 info;
@@ -957,7 +953,7 @@ int mthca_QUERY_DDR(struct mthca_dev *dev, u8 *status)
 	outbox = mailbox->buf;
 
 	err = mthca_cmd_box(dev, 0, mailbox->dma, 0, 0, CMD_QUERY_DDR,
-			    CMD_TIME_CLASS_A, status);
+			    CMD_TIME_CLASS_A);
 
 	if (err)
 		goto out;
@@ -987,7 +983,7 @@ out:
 }
 
 int mthca_QUERY_DEV_LIM(struct mthca_dev *dev,
-			struct mthca_dev_lim *dev_lim, u8 *status)
+			struct mthca_dev_lim *dev_lim)
 {
 	struct mthca_mailbox *mailbox;
 	u32 *outbox;
@@ -1063,7 +1059,7 @@ int mthca_QUERY_DEV_LIM(struct mthca_dev *dev,
 	outbox = mailbox->buf;
 
 	err = mthca_cmd_box(dev, 0, mailbox->dma, 0, 0, CMD_QUERY_DEV_LIM,
-			    CMD_TIME_CLASS_A, status);
+			    CMD_TIME_CLASS_A);
 
 	if (err)
 		goto out;
@@ -1267,7 +1263,7 @@ static void get_board_id(void *vsd, char *board_id)
 }
 
 int mthca_QUERY_ADAPTER(struct mthca_dev *dev,
-			struct mthca_adapter *adapter, u8 *status)
+			struct mthca_adapter *adapter)
 {
 	struct mthca_mailbox *mailbox;
 	u32 *outbox;
@@ -1286,7 +1282,7 @@ int mthca_QUERY_ADAPTER(struct mthca_dev *dev,
 	outbox = mailbox->buf;
 
 	err = mthca_cmd_box(dev, 0, mailbox->dma, 0, 0, CMD_QUERY_ADAPTER,
-			    CMD_TIME_CLASS_A, status);
+			    CMD_TIME_CLASS_A);
 
 	if (err)
 		goto out;
@@ -1310,8 +1306,7 @@ out:
 }
 
 int mthca_INIT_HCA(struct mthca_dev *dev,
-		   struct mthca_init_hca_param *param,
-		   u8 *status)
+		   struct mthca_init_hca_param *param)
 {
 	struct mthca_mailbox *mailbox;
 	__be32 *inbox;
@@ -1428,7 +1423,8 @@ int mthca_INIT_HCA(struct mthca_dev *dev,
 		MTHCA_PUT(inbox, param->uarc_base,   INIT_HCA_UAR_CTX_BASE_OFFSET);
 	}
 
-	err = mthca_cmd(dev, mailbox->dma, 0, 0, CMD_INIT_HCA, CMD_TIME_CLASS_D, status);
+	err = mthca_cmd(dev, mailbox->dma, 0, 0,
+			CMD_INIT_HCA, CMD_TIME_CLASS_D);
 
 	mthca_free_mailbox(dev, mailbox);
 	return err;
@@ -1436,7 +1432,7 @@ int mthca_INIT_HCA(struct mthca_dev *dev,
 
 int mthca_INIT_IB(struct mthca_dev *dev,
 		  struct mthca_init_ib_param *param,
-		  int port, u8 *status)
+		  int port)
 {
 	struct mthca_mailbox *mailbox;
 	u32 *inbox;
@@ -1480,24 +1476,24 @@ int mthca_INIT_IB(struct mthca_dev *dev,
 	MTHCA_PUT(inbox, param->si_guid,   INIT_IB_SI_GUID_OFFSET);
 
 	err = mthca_cmd(dev, mailbox->dma, port, 0, CMD_INIT_IB,
-			CMD_TIME_CLASS_A, status);
+			CMD_TIME_CLASS_A);
 
 	mthca_free_mailbox(dev, mailbox);
 	return err;
 }
 
-int mthca_CLOSE_IB(struct mthca_dev *dev, int port, u8 *status)
+int mthca_CLOSE_IB(struct mthca_dev *dev, int port)
 {
-	return mthca_cmd(dev, 0, port, 0, CMD_CLOSE_IB, CMD_TIME_CLASS_A, status);
+	return mthca_cmd(dev, 0, port, 0, CMD_CLOSE_IB, CMD_TIME_CLASS_A);
 }
 
-int mthca_CLOSE_HCA(struct mthca_dev *dev, int panic, u8 *status)
+int mthca_CLOSE_HCA(struct mthca_dev *dev, int panic)
 {
-	return mthca_cmd(dev, 0, 0, panic, CMD_CLOSE_HCA, CMD_TIME_CLASS_C, status);
+	return mthca_cmd(dev, 0, 0, panic, CMD_CLOSE_HCA, CMD_TIME_CLASS_C);
 }
 
 int mthca_SET_IB(struct mthca_dev *dev, struct mthca_set_ib_param *param,
-		 int port, u8 *status)
+		 int port)
 {
 	struct mthca_mailbox *mailbox;
 	u32 *inbox;
@@ -1526,18 +1522,18 @@ int mthca_SET_IB(struct mthca_dev *dev, struct mthca_set_ib_param *param,
 	MTHCA_PUT(inbox, param->si_guid,  SET_IB_SI_GUID_OFFSET);
 
 	err = mthca_cmd(dev, mailbox->dma, port, 0, CMD_SET_IB,
-			CMD_TIME_CLASS_B, status);
+			CMD_TIME_CLASS_B);
 
 	mthca_free_mailbox(dev, mailbox);
 	return err;
 }
 
-int mthca_MAP_ICM(struct mthca_dev *dev, struct mthca_icm *icm, u64 virt, u8 *status)
+int mthca_MAP_ICM(struct mthca_dev *dev, struct mthca_icm *icm, u64 virt)
 {
-	return mthca_map_cmd(dev, CMD_MAP_ICM, icm, virt, status);
+	return mthca_map_cmd(dev, CMD_MAP_ICM, icm, virt);
 }
 
-int mthca_MAP_ICM_page(struct mthca_dev *dev, u64 dma_addr, u64 virt, u8 *status)
+int mthca_MAP_ICM_page(struct mthca_dev *dev, u64 dma_addr, u64 virt)
 {
 	struct mthca_mailbox *mailbox;
 	__be64 *inbox;
@@ -1552,7 +1548,7 @@ int mthca_MAP_ICM_page(struct mthca_dev *dev, u64 dma_addr, u64 virt, u8 *status
 	inbox[1] = cpu_to_be64(dma_addr);
 
 	err = mthca_cmd(dev, mailbox->dma, 1, 0, CMD_MAP_ICM,
-			CMD_TIME_CLASS_B, status);
+			CMD_TIME_CLASS_B);
 
 	mthca_free_mailbox(dev, mailbox);
 
@@ -1563,31 +1559,31 @@ int mthca_MAP_ICM_page(struct mthca_dev *dev, u64 dma_addr, u64 virt, u8 *status
 	return err;
 }
 
-int mthca_UNMAP_ICM(struct mthca_dev *dev, u64 virt, u32 page_count, u8 *status)
+int mthca_UNMAP_ICM(struct mthca_dev *dev, u64 virt, u32 page_count)
 {
 	mthca_dbg(dev, "Unmapping %d pages at %llx from ICM.\n",
 		  page_count, (unsigned long long) virt);
 
-	return mthca_cmd(dev, virt, page_count, 0, CMD_UNMAP_ICM, CMD_TIME_CLASS_B, status);
+	return mthca_cmd(dev, virt, page_count, 0,
+			CMD_UNMAP_ICM, CMD_TIME_CLASS_B);
 }
 
-int mthca_MAP_ICM_AUX(struct mthca_dev *dev, struct mthca_icm *icm, u8 *status)
+int mthca_MAP_ICM_AUX(struct mthca_dev *dev, struct mthca_icm *icm)
 {
-	return mthca_map_cmd(dev, CMD_MAP_ICM_AUX, icm, -1, status);
+	return mthca_map_cmd(dev, CMD_MAP_ICM_AUX, icm, -1);
 }
 
-int mthca_UNMAP_ICM_AUX(struct mthca_dev *dev, u8 *status)
+int mthca_UNMAP_ICM_AUX(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0, 0, CMD_UNMAP_ICM_AUX, CMD_TIME_CLASS_B, status);
+	return mthca_cmd(dev, 0, 0, 0, CMD_UNMAP_ICM_AUX, CMD_TIME_CLASS_B);
 }
 
-int mthca_SET_ICM_SIZE(struct mthca_dev *dev, u64 icm_size, u64 *aux_pages,
-		       u8 *status)
+int mthca_SET_ICM_SIZE(struct mthca_dev *dev, u64 icm_size, u64 *aux_pages)
 {
-	int ret = mthca_cmd_imm(dev, icm_size, aux_pages, 0, 0, CMD_SET_ICM_SIZE,
-				CMD_TIME_CLASS_A, status);
+	int ret = mthca_cmd_imm(dev, icm_size, aux_pages, 0,
+			0, CMD_SET_ICM_SIZE, CMD_TIME_CLASS_A);
 
-	if (ret || status)
+	if (ret)
 		return ret;
 
 	/*
@@ -1601,74 +1597,73 @@ int mthca_SET_ICM_SIZE(struct mthca_dev *dev, u64 icm_size, u64 *aux_pages,
 }
 
 int mthca_SW2HW_MPT(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int mpt_index, u8 *status)
+		    int mpt_index)
 {
 	return mthca_cmd(dev, mailbox->dma, mpt_index, 0, CMD_SW2HW_MPT,
-			 CMD_TIME_CLASS_B, status);
+			 CMD_TIME_CLASS_B);
 }
 
 int mthca_HW2SW_MPT(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int mpt_index, u8 *status)
+		    int mpt_index)
 {
 	return mthca_cmd_box(dev, 0, mailbox ? mailbox->dma : 0, mpt_index,
 			     !mailbox, CMD_HW2SW_MPT,
-			     CMD_TIME_CLASS_B, status);
+			     CMD_TIME_CLASS_B);
 }
 
 int mthca_WRITE_MTT(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int num_mtt, u8 *status)
+		    int num_mtt)
 {
 	return mthca_cmd(dev, mailbox->dma, num_mtt, 0, CMD_WRITE_MTT,
-			 CMD_TIME_CLASS_B, status);
+			 CMD_TIME_CLASS_B);
 }
 
-int mthca_SYNC_TPT(struct mthca_dev *dev, u8 *status)
+int mthca_SYNC_TPT(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0, 0, CMD_SYNC_TPT, CMD_TIME_CLASS_B, status);
+	return mthca_cmd(dev, 0, 0, 0, CMD_SYNC_TPT, CMD_TIME_CLASS_B);
 }
 
 int mthca_MAP_EQ(struct mthca_dev *dev, u64 event_mask, int unmap,
-		 int eq_num, u8 *status)
+		 int eq_num)
 {
 	mthca_dbg(dev, "%s mask %016llx for eqn %d\n",
 		  unmap ? "Clearing" : "Setting",
 		  (unsigned long long) event_mask, eq_num);
 	return mthca_cmd(dev, event_mask, (unmap << 31) | eq_num,
-			 0, CMD_MAP_EQ, CMD_TIME_CLASS_B, status);
+			 0, CMD_MAP_EQ, CMD_TIME_CLASS_B);
 }
 
 int mthca_SW2HW_EQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int eq_num, u8 *status)
+		   int eq_num)
 {
 	return mthca_cmd(dev, mailbox->dma, eq_num, 0, CMD_SW2HW_EQ,
-			 CMD_TIME_CLASS_A, status);
+			 CMD_TIME_CLASS_A);
 }
 
 int mthca_HW2SW_EQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int eq_num, u8 *status)
+		   int eq_num)
 {
 	return mthca_cmd_box(dev, 0, mailbox->dma, eq_num, 0,
 			     CMD_HW2SW_EQ,
-			     CMD_TIME_CLASS_A, status);
+			     CMD_TIME_CLASS_A);
 }
 
 int mthca_SW2HW_CQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int cq_num, u8 *status)
+		   int cq_num)
 {
 	return mthca_cmd(dev, mailbox->dma, cq_num, 0, CMD_SW2HW_CQ,
-			CMD_TIME_CLASS_A, status);
+			CMD_TIME_CLASS_A);
 }
 
 int mthca_HW2SW_CQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int cq_num, u8 *status)
+		   int cq_num)
 {
 	return mthca_cmd_box(dev, 0, mailbox->dma, cq_num, 0,
 			     CMD_HW2SW_CQ,
-			     CMD_TIME_CLASS_A, status);
+			     CMD_TIME_CLASS_A);
 }
 
-int mthca_RESIZE_CQ(struct mthca_dev *dev, int cq_num, u32 lkey, u8 log_size,
-		    u8 *status)
+int mthca_RESIZE_CQ(struct mthca_dev *dev, int cq_num, u32 lkey, u8 log_size)
 {
 	struct mthca_mailbox *mailbox;
 	__be32 *inbox;
@@ -1692,44 +1687,43 @@ int mthca_RESIZE_CQ(struct mthca_dev *dev, int cq_num, u32 lkey, u8 log_size,
 	MTHCA_PUT(inbox, lkey,     RESIZE_CQ_LKEY_OFFSET);
 
 	err = mthca_cmd(dev, mailbox->dma, cq_num, 1, CMD_RESIZE_CQ,
-			CMD_TIME_CLASS_B, status);
+			CMD_TIME_CLASS_B);
 
 	mthca_free_mailbox(dev, mailbox);
 	return err;
 }
 
 int mthca_SW2HW_SRQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int srq_num, u8 *status)
+		    int srq_num)
 {
 	return mthca_cmd(dev, mailbox->dma, srq_num, 0, CMD_SW2HW_SRQ,
-			CMD_TIME_CLASS_A, status);
+			CMD_TIME_CLASS_A);
 }
 
 int mthca_HW2SW_SRQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int srq_num, u8 *status)
+		    int srq_num)
 {
 	return mthca_cmd_box(dev, 0, mailbox->dma, srq_num, 0,
 			     CMD_HW2SW_SRQ,
-			     CMD_TIME_CLASS_A, status);
+			     CMD_TIME_CLASS_A);
 }
 
 int mthca_QUERY_SRQ(struct mthca_dev *dev, u32 num,
-		    struct mthca_mailbox *mailbox, u8 *status)
+		    struct mthca_mailbox *mailbox)
 {
 	return mthca_cmd_box(dev, 0, mailbox->dma, num, 0,
-			     CMD_QUERY_SRQ, CMD_TIME_CLASS_A, status);
+			     CMD_QUERY_SRQ, CMD_TIME_CLASS_A);
 }
 
-int mthca_ARM_SRQ(struct mthca_dev *dev, int srq_num, int limit, u8 *status)
+int mthca_ARM_SRQ(struct mthca_dev *dev, int srq_num, int limit)
 {
 	return mthca_cmd(dev, limit, srq_num, 0, CMD_ARM_SRQ,
-			 CMD_TIME_CLASS_B, status);
+			 CMD_TIME_CLASS_B);
 }
 
 int mthca_MODIFY_QP(struct mthca_dev *dev, enum ib_qp_state cur,
 		    enum ib_qp_state next, u32 num, int is_ee,
-		    struct mthca_mailbox *mailbox, u32 optmask,
-		    u8 *status)
+		    struct mthca_mailbox *mailbox, u32 optmask)
 {
 	static const u16 op[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
 		[IB_QPS_RESET] = {
@@ -1790,7 +1784,7 @@ int mthca_MODIFY_QP(struct mthca_dev *dev, enum ib_qp_state cur,
 
 		err = mthca_cmd_box(dev, 0, mailbox ? mailbox->dma : 0,
 				    (!!is_ee << 24) | num, op_mod,
-				    op[cur][next], CMD_TIME_CLASS_C, status);
+				    op[cur][next], CMD_TIME_CLASS_C);
 
 		if (0 && mailbox) {
 			int i;
@@ -1824,21 +1818,20 @@ int mthca_MODIFY_QP(struct mthca_dev *dev, enum ib_qp_state cur,
 		}
 
 		err = mthca_cmd(dev, mailbox->dma, optmask | (!!is_ee << 24) | num,
-				op_mod, op[cur][next], CMD_TIME_CLASS_C, status);
+				op_mod, op[cur][next], CMD_TIME_CLASS_C);
 	}
 
 	return err;
 }
 
 int mthca_QUERY_QP(struct mthca_dev *dev, u32 num, int is_ee,
-		   struct mthca_mailbox *mailbox, u8 *status)
+		   struct mthca_mailbox *mailbox)
 {
 	return mthca_cmd_box(dev, 0, mailbox->dma, (!!is_ee << 24) | num, 0,
-			     CMD_QUERY_QPEE, CMD_TIME_CLASS_A, status);
+			     CMD_QUERY_QPEE, CMD_TIME_CLASS_A);
 }
 
-int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn,
-			  u8 *status)
+int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn)
 {
 	u8 op_mod;
 
@@ -1860,12 +1853,12 @@ int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn,
 	}
 
 	return mthca_cmd(dev, 0, qpn, op_mod, CMD_CONF_SPECIAL_QP,
-			 CMD_TIME_CLASS_B, status);
+			 CMD_TIME_CLASS_B);
 }
 
 int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
 		  int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		  void *in_mad, void *response_mad, u8 *status)
+		  void *in_mad, void *response_mad)
 {
 	struct mthca_mailbox *inmailbox, *outmailbox;
 	void *inbox;
@@ -1932,9 +1925,9 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
 
 	err = mthca_cmd_box(dev, inmailbox->dma, outmailbox->dma,
 			    in_modifier, op_modifier,
-			    CMD_MAD_IFC, CMD_TIME_CLASS_C, status);
+			    CMD_MAD_IFC, CMD_TIME_CLASS_C);
 
-	if (!err && !*status)
+	if (!err)
 		memcpy(response_mad, outmailbox->buf, 256);
 
 	mthca_free_mailbox(dev, inmailbox);
@@ -1943,33 +1936,33 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
 }
 
 int mthca_READ_MGM(struct mthca_dev *dev, int index,
-		   struct mthca_mailbox *mailbox, u8 *status)
+		   struct mthca_mailbox *mailbox)
 {
 	return mthca_cmd_box(dev, 0, mailbox->dma, index, 0,
-			     CMD_READ_MGM, CMD_TIME_CLASS_A, status);
+			     CMD_READ_MGM, CMD_TIME_CLASS_A);
 }
 
 int mthca_WRITE_MGM(struct mthca_dev *dev, int index,
-		    struct mthca_mailbox *mailbox, u8 *status)
+		    struct mthca_mailbox *mailbox)
 {
 	return mthca_cmd(dev, mailbox->dma, index, 0, CMD_WRITE_MGM,
-			 CMD_TIME_CLASS_A, status);
+			 CMD_TIME_CLASS_A);
 }
 
 int mthca_MGID_HASH(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    u16 *hash, u8 *status)
+		    u16 *hash)
 {
 	u64 imm;
 	int err;
 
 	err = mthca_cmd_imm(dev, mailbox->dma, &imm, 0, 0, CMD_MGID_HASH,
-			    CMD_TIME_CLASS_A, status);
+			    CMD_TIME_CLASS_A);
 
 	*hash = imm;
 	return err;
 }
 
-int mthca_NOP(struct mthca_dev *dev, u8 *status)
+int mthca_NOP(struct mthca_dev *dev)
 {
-	return mthca_cmd(dev, 0, 0x1f, 0, CMD_NOP, msecs_to_jiffies(100), status);
+	return mthca_cmd(dev, 0, 0x1f, 0, CMD_NOP, msecs_to_jiffies(100));
 }
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.h b/drivers/infiniband/hw/mthca/mthca_cmd.h
index 6efd326..f952244 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.h
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.h
@@ -252,79 +252,74 @@ struct mthca_mailbox *mthca_alloc_mailbox(struct mthca_dev *dev,
 					  gfp_t gfp_mask);
 void mthca_free_mailbox(struct mthca_dev *dev, struct mthca_mailbox *mailbox);
 
-int mthca_SYS_EN(struct mthca_dev *dev, u8 *status);
-int mthca_SYS_DIS(struct mthca_dev *dev, u8 *status);
-int mthca_MAP_FA(struct mthca_dev *dev, struct mthca_icm *icm, u8 *status);
-int mthca_UNMAP_FA(struct mthca_dev *dev, u8 *status);
-int mthca_RUN_FW(struct mthca_dev *dev, u8 *status);
-int mthca_QUERY_FW(struct mthca_dev *dev, u8 *status);
-int mthca_ENABLE_LAM(struct mthca_dev *dev, u8 *status);
-int mthca_DISABLE_LAM(struct mthca_dev *dev, u8 *status);
-int mthca_QUERY_DDR(struct mthca_dev *dev, u8 *status);
+int mthca_SYS_EN(struct mthca_dev *dev);
+int mthca_SYS_DIS(struct mthca_dev *dev);
+int mthca_MAP_FA(struct mthca_dev *dev, struct mthca_icm *icm);
+int mthca_UNMAP_FA(struct mthca_dev *dev);
+int mthca_RUN_FW(struct mthca_dev *dev);
+int mthca_QUERY_FW(struct mthca_dev *dev);
+int mthca_ENABLE_LAM(struct mthca_dev *dev);
+int mthca_DISABLE_LAM(struct mthca_dev *dev);
+int mthca_QUERY_DDR(struct mthca_dev *dev);
 int mthca_QUERY_DEV_LIM(struct mthca_dev *dev,
-			struct mthca_dev_lim *dev_lim, u8 *status);
+			struct mthca_dev_lim *dev_lim);
 int mthca_QUERY_ADAPTER(struct mthca_dev *dev,
-			struct mthca_adapter *adapter, u8 *status);
+			struct mthca_adapter *adapter);
 int mthca_INIT_HCA(struct mthca_dev *dev,
-		   struct mthca_init_hca_param *param,
-		   u8 *status);
+		   struct mthca_init_hca_param *param);
 int mthca_INIT_IB(struct mthca_dev *dev,
 		  struct mthca_init_ib_param *param,
-		  int port, u8 *status);
-int mthca_CLOSE_IB(struct mthca_dev *dev, int port, u8 *status);
-int mthca_CLOSE_HCA(struct mthca_dev *dev, int panic, u8 *status);
+		  int port);
+int mthca_CLOSE_IB(struct mthca_dev *dev, int port);
+int mthca_CLOSE_HCA(struct mthca_dev *dev, int panic);
 int mthca_SET_IB(struct mthca_dev *dev, struct mthca_set_ib_param *param,
-		 int port, u8 *status);
-int mthca_MAP_ICM(struct mthca_dev *dev, struct mthca_icm *icm, u64 virt, u8 *status);
-int mthca_MAP_ICM_page(struct mthca_dev *dev, u64 dma_addr, u64 virt, u8 *status);
-int mthca_UNMAP_ICM(struct mthca_dev *dev, u64 virt, u32 page_count, u8 *status);
-int mthca_MAP_ICM_AUX(struct mthca_dev *dev, struct mthca_icm *icm, u8 *status);
-int mthca_UNMAP_ICM_AUX(struct mthca_dev *dev, u8 *status);
-int mthca_SET_ICM_SIZE(struct mthca_dev *dev, u64 icm_size, u64 *aux_pages,
-		       u8 *status);
+		 int port);
+int mthca_MAP_ICM(struct mthca_dev *dev, struct mthca_icm *icm, u64 virt);
+int mthca_MAP_ICM_page(struct mthca_dev *dev, u64 dma_addr, u64 virt);
+int mthca_UNMAP_ICM(struct mthca_dev *dev, u64 virt, u32 page_count);
+int mthca_MAP_ICM_AUX(struct mthca_dev *dev, struct mthca_icm *icm);
+int mthca_UNMAP_ICM_AUX(struct mthca_dev *dev);
+int mthca_SET_ICM_SIZE(struct mthca_dev *dev, u64 icm_size, u64 *aux_pages);
 int mthca_SW2HW_MPT(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int mpt_index, u8 *status);
+		    int mpt_index);
 int mthca_HW2SW_MPT(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int mpt_index, u8 *status);
+		    int mpt_index);
 int mthca_WRITE_MTT(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int num_mtt, u8 *status);
-int mthca_SYNC_TPT(struct mthca_dev *dev, u8 *status);
+		    int num_mtt);
+int mthca_SYNC_TPT(struct mthca_dev *dev);
 int mthca_MAP_EQ(struct mthca_dev *dev, u64 event_mask, int unmap,
-		 int eq_num, u8 *status);
+		 int eq_num);
 int mthca_SW2HW_EQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int eq_num, u8 *status);
+		   int eq_num);
 int mthca_HW2SW_EQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int eq_num, u8 *status);
+		   int eq_num);
 int mthca_SW2HW_CQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int cq_num, u8 *status);
+		   int cq_num);
 int mthca_HW2SW_CQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		   int cq_num, u8 *status);
-int mthca_RESIZE_CQ(struct mthca_dev *dev, int cq_num, u32 lkey, u8 log_size,
-		    u8 *status);
+		   int cq_num);
+int mthca_RESIZE_CQ(struct mthca_dev *dev, int cq_num, u32 lkey, u8 log_size);
 int mthca_SW2HW_SRQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int srq_num, u8 *status);
+		    int srq_num);
 int mthca_HW2SW_SRQ(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    int srq_num, u8 *status);
+		    int srq_num);
 int mthca_QUERY_SRQ(struct mthca_dev *dev, u32 num,
-		    struct mthca_mailbox *mailbox, u8 *status);
-int mthca_ARM_SRQ(struct mthca_dev *dev, int srq_num, int limit, u8 *status);
+		    struct mthca_mailbox *mailbox);
+int mthca_ARM_SRQ(struct mthca_dev *dev, int srq_num, int limit);
 int mthca_MODIFY_QP(struct mthca_dev *dev, enum ib_qp_state cur,
 		    enum ib_qp_state next, u32 num, int is_ee,
-		    struct mthca_mailbox *mailbox, u32 optmask,
-		    u8 *status);
+		    struct mthca_mailbox *mailbox, u32 optmask);
 int mthca_QUERY_QP(struct mthca_dev *dev, u32 num, int is_ee,
-		   struct mthca_mailbox *mailbox, u8 *status);
-int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn,
-			  u8 *status);
+		   struct mthca_mailbox *mailbox);
+int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn);
 int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
 		  int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		  void *in_mad, void *response_mad, u8 *status);
+		  void *in_mad, void *response_mad);
 int mthca_READ_MGM(struct mthca_dev *dev, int index,
-		   struct mthca_mailbox *mailbox, u8 *status);
+		   struct mthca_mailbox *mailbox);
 int mthca_WRITE_MGM(struct mthca_dev *dev, int index,
-		    struct mthca_mailbox *mailbox, u8 *status);
+		    struct mthca_mailbox *mailbox);
 int mthca_MGID_HASH(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
-		    u16 *hash, u8 *status);
-int mthca_NOP(struct mthca_dev *dev, u8 *status);
+		    u16 *hash);
+int mthca_NOP(struct mthca_dev *dev);
 
 #endif /* MTHCA_CMD_H */
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
