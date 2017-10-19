From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next] RDMA/hns: Add modify CQ support for hip08
Date: Thu, 19 Oct 2017 11:52:40 +0800
Message-ID: <1508385160-130435-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is needed to call modify cq API for modifying cq
context fields for controlling event generation
moderations. This patch mainly adds it.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cmd.h    |  1 +
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |  6 +++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 42 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/hns/hns_roce_main.c   |  1 +
 5 files changed, 51 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cmd.h b/drivers/infiniband/hw/hns/hns_roce_cmd.h
index 77299ae5..f0039a7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cmd.h
+++ b/drivers/infiniband/hw/hns/hns_roce_cmd.h
@@ -52,6 +52,7 @@ enum {
 	HNS_ROCE_CMD_MODIFY_QPC		= 0x41,
 	HNS_ROCE_CMD_QUERY_QPC		= 0x42,
 
+	HNS_ROCE_CMD_MODIFY_CQC		= 0x52,
 	/* CQC BT commands */
 	HNS_ROCE_CMD_WRITE_CQC_BT0	= 0x10,
 	HNS_ROCE_CMD_WRITE_CQC_BT1	= 0x11,
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index b314ac0..862ab75 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -607,6 +607,7 @@ struct hns_roce_hw {
 	int (*poll_cq)(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 	int (*dereg_mr)(struct hns_roce_dev *hr_dev, struct hns_roce_mr *mr);
 	int (*destroy_cq)(struct ib_cq *ibcq);
+	int (*modify_cq)(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 };
 
 struct hns_roce_dev {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index a5693d4..8311a5f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -2113,6 +2113,11 @@ static void hns_roce_v1_write_cqc(struct hns_roce_dev *hr_dev,
 	cq_context->cqc_byte_32 = cpu_to_le32(cq_context->cqc_byte_32);
 }
 
+static int hns_roce_v1_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
+{
+	return -EOPNOTSUPP;
+}
+
 static int hns_roce_v1_req_notify_cq(struct ib_cq *ibcq,
 				     enum ib_cq_notify_flags flags)
 {
@@ -3963,6 +3968,7 @@ static int hns_roce_v1_destroy_cq(struct ib_cq *ibcq)
 	.set_mtu = hns_roce_v1_set_mtu,
 	.write_mtpt = hns_roce_v1_write_mtpt,
 	.write_cqc = hns_roce_v1_write_cqc,
+	.modify_cq = hns_roce_v1_modify_cq,
 	.clear_hem = hns_roce_v1_clear_hem,
 	.modify_qp = hns_roce_v1_modify_qp,
 	.query_qp = hns_roce_v1_query_qp,
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ff61f30..aec6ef5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2993,6 +2993,47 @@ static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp)
 	return 0;
 }
 
+static int hns_roce_v2_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
+{
+	struct hns_roce_dev *hr_dev = to_hr_dev(cq->device);
+	struct hns_roce_v2_cq_context *cq_context;
+	struct hns_roce_cq *hr_cq = to_hr_cq(cq);
+	struct hns_roce_v2_cq_context *cqc_mask;
+	struct hns_roce_cmd_mailbox *mailbox;
+	int ret;
+
+	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	cq_context = mailbox->buf;
+	cqc_mask = (struct hns_roce_v2_cq_context *)mailbox->buf + 1;
+
+	memset(cqc_mask, 0xff, sizeof(*cqc_mask));
+
+	roce_set_field(cq_context->byte_56_cqe_period_maxcnt,
+		       V2_CQC_BYTE_56_CQ_MAX_CNT_M, V2_CQC_BYTE_56_CQ_MAX_CNT_S,
+		       cq_count);
+	roce_set_field(cqc_mask->byte_56_cqe_period_maxcnt,
+		       V2_CQC_BYTE_56_CQ_MAX_CNT_M, V2_CQC_BYTE_56_CQ_MAX_CNT_S,
+		       0);
+	roce_set_field(cq_context->byte_56_cqe_period_maxcnt,
+		       V2_CQC_BYTE_56_CQ_PERIOD_M, V2_CQC_BYTE_56_CQ_PERIOD_S,
+		       cq_period);
+	roce_set_field(cqc_mask->byte_56_cqe_period_maxcnt,
+		       V2_CQC_BYTE_56_CQ_PERIOD_M, V2_CQC_BYTE_56_CQ_PERIOD_S,
+		       0);
+
+	ret = hns_roce_cmd_mbox(hr_dev, mailbox->dma, 0, hr_cq->cqn, 1,
+				HNS_ROCE_CMD_MODIFY_CQC,
+				HNS_ROCE_CMD_TIMEOUT_MSECS);
+	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
+	if (ret)
+		dev_err(hr_dev->dev, "MODIFY CQ Failed to cmd mailbox.\n");
+
+	return ret;
+}
+
 static const struct hns_roce_hw hns_roce_hw_v2 = {
 	.cmq_init = hns_roce_v2_cmq_init,
 	.cmq_exit = hns_roce_v2_cmq_exit,
@@ -3008,6 +3049,7 @@ static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp)
 	.modify_qp = hns_roce_v2_modify_qp,
 	.query_qp = hns_roce_v2_query_qp,
 	.destroy_qp = hns_roce_v2_destroy_qp,
+	.modify_cq = hns_roce_v2_modify_cq,
 	.post_send = hns_roce_v2_post_send,
 	.post_recv = hns_roce_v2_post_recv,
 	.req_notify_cq = hns_roce_v2_req_notify_cq,
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 3dcb2df..31120fd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -499,6 +499,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 
 	/* CQ */
 	ib_dev->create_cq		= hns_roce_ib_create_cq;
+	ib_dev->modify_cq		= hr_dev->hw->modify_cq;
 	ib_dev->destroy_cq		= hns_roce_ib_destroy_cq;
 	ib_dev->req_notify_cq		= hr_dev->hw->req_notify_cq;
 	ib_dev->poll_cq			= hr_dev->hw->poll_cq;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
