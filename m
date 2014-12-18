From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/14] RDMA/ocrdma: Add support for interrupt moderation.
Date: Thu, 18 Dec 2014 14:13:05 +0530
Message-ID: <5686e2bc-2d9f-490b-9b37-434b572bff35@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Add support for interrupt moderation for ocrdma device.
Thresholds for high interrupt rates are static values derived based on
experimental results.

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h      |   14 +++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c   |   77 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    4 ++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h  |   24 +++++++++
 4 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 933b38a..b9fee0e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -55,6 +55,12 @@
 #define OCRDMA_UVERBS(CMD_NAME) (1ull << IB_USER_VERBS_CMD_##CMD_NAME)
 
 #define convert_to_64bit(lo, hi) ((u64)hi << 32 | (u64)lo)
+#define EQ_INTR_PER_SEC_THRSH_HI 150000
+#define EQ_INTR_PER_SEC_THRSH_LOW 100000
+#define EQ_AIC_MAX_EQD 20
+#define EQ_AIC_MIN_EQD 0
+
+void ocrdma_eqd_set_task(struct work_struct *work);
 
 struct ocrdma_dev_attr {
 	u8 fw_ver[32];
@@ -117,12 +123,19 @@ struct ocrdma_queue_info {
 	bool created;
 };
 
+struct ocrdma_aic_obj {         /* Adaptive interrupt coalescing (AIC) info */
+	u32 prev_eqd;
+	u64 eq_intr_cnt;
+	u64 prev_eq_intr_cnt;
+};
+
 struct ocrdma_eq {
 	struct ocrdma_queue_info q;
 	u32 vector;
 	int cq_cnt;
 	struct ocrdma_dev *dev;
 	char irq_name[32];
+	struct ocrdma_aic_obj aic_obj;
 };
 
 struct ocrdma_mq {
@@ -214,6 +227,7 @@ struct ocrdma_dev {
 
 	struct ocrdma_eq *eq_tbl;
 	int eq_cnt;
+	struct delayed_work eqd_work;
 	u16 base_eqid;
 	u16 max_eq;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 8176bd6..dc1e3d7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -960,6 +960,7 @@ static irqreturn_t ocrdma_irq_handler(int irq, void *handle)
 
 	} while (budget);
 
+	eq->aic_obj.eq_intr_cnt++;
 	ocrdma_ring_eq_db(dev, eq->q.id, true, true, 0);
 	return IRQ_HANDLED;
 }
@@ -3017,6 +3018,82 @@ done:
 	return status;
 }
 
+static int ocrdma_mbx_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
+				 int num)
+{
+	int i, status = -ENOMEM;
+	struct ocrdma_modify_eqd_req *cmd;
+
+	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_MODIFY_EQ_DELAY, sizeof(*cmd));
+	if (!cmd)
+		return status;
+
+	ocrdma_init_mch(&cmd->cmd.req, OCRDMA_CMD_MODIFY_EQ_DELAY,
+			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
+
+	cmd->cmd.num_eq = num;
+	for (i = 0; i < num; i++) {
+		cmd->cmd.set_eqd[i].eq_id = eq[i].q.id;
+		cmd->cmd.set_eqd[i].phase = 0;
+		cmd->cmd.set_eqd[i].delay_multiplier =
+				(eq[i].aic_obj.prev_eqd * 65)/100;
+	}
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+	if (status)
+		goto mbx_err;
+mbx_err:
+	kfree(cmd);
+	return status;
+}
+
+static int ocrdma_modify_eqd(struct ocrdma_dev *dev, struct ocrdma_eq *eq,
+			     int num)
+{
+	int num_eqs, i = 0;
+	if (num > 8) {
+		while (num) {
+			num_eqs = min(num, 8);
+			ocrdma_mbx_modify_eqd(dev, &eq[i], num_eqs);
+			i += num_eqs;
+			num -= num_eqs;
+		}
+	} else {
+		ocrdma_mbx_modify_eqd(dev, eq, num);
+	}
+	return 0;
+}
+
+void ocrdma_eqd_set_task(struct work_struct *work)
+{
+	struct ocrdma_dev *dev =
+		container_of(work, struct ocrdma_dev, eqd_work.work);
+	struct ocrdma_eq *eq = 0;
+	int i, num = 0, status = -EINVAL;
+	u64 eq_intr;
+
+	for (i = 0; i < dev->eq_cnt; i++) {
+		eq = &dev->eq_tbl[i];
+		if (eq->aic_obj.eq_intr_cnt > eq->aic_obj.prev_eq_intr_cnt) {
+			eq_intr = eq->aic_obj.eq_intr_cnt -
+				  eq->aic_obj.prev_eq_intr_cnt;
+			if ((eq_intr > EQ_INTR_PER_SEC_THRSH_HI) &&
+			    (eq->aic_obj.prev_eqd == EQ_AIC_MIN_EQD)) {
+				eq->aic_obj.prev_eqd = EQ_AIC_MAX_EQD;
+				num++;
+			} else if ((eq_intr < EQ_INTR_PER_SEC_THRSH_LOW) &&
+				   (eq->aic_obj.prev_eqd == EQ_AIC_MAX_EQD)) {
+				eq->aic_obj.prev_eqd = EQ_AIC_MIN_EQD;
+				num++;
+			}
+		}
+		eq->aic_obj.prev_eq_intr_cnt = eq->aic_obj.eq_intr_cnt;
+	}
+
+	if (num)
+		status = ocrdma_modify_eqd(dev, &dev->eq_tbl[0], num);
+	schedule_delayed_work(&dev->eqd_work, msecs_to_jiffies(1000));
+}
+
 int ocrdma_init_hw(struct ocrdma_dev *dev)
 {
 	int status;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 0083360..7a2b59a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -493,6 +493,9 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	spin_unlock(&ocrdma_devlist_lock);
 	/* Init stats */
 	ocrdma_add_port_stats(dev);
+	/* Interrupt Moderation */
+	INIT_DELAYED_WORK(&dev->eqd_work, ocrdma_eqd_set_task);
+	schedule_delayed_work(&dev->eqd_work, msecs_to_jiffies(1000));
 
 	pr_info("%s %s: %s \"%s\" port %d\n",
 		dev_name(&dev->nic_info.pdev->dev), hca_name(dev),
@@ -530,6 +533,7 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	/* first unregister with stack to stop all the active traffic
 	 * of the registered clients.
 	 */
+	cancel_delayed_work_sync(&dev->eqd_work);
 	ocrdma_remove_sysfiles(dev);
 	ib_unregister_device(&dev->ibdev);
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 6ba9939..801883a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -89,6 +89,7 @@ enum {
 	OCRDMA_CMD_CREATE_MQ		= 21,
 	OCRDMA_CMD_GET_CTRL_ATTRIBUTES  = 32,
 	OCRDMA_CMD_GET_FW_VER		= 35,
+	OCRDMA_CMD_MODIFY_EQ_DELAY      = 41,
 	OCRDMA_CMD_DELETE_MQ		= 53,
 	OCRDMA_CMD_DELETE_CQ		= 54,
 	OCRDMA_CMD_DELETE_EQ		= 55,
@@ -316,6 +317,29 @@ struct ocrdma_create_eq_rsp {
 
 #define OCRDMA_EQ_MINOR_OTHER	0x1
 
+struct ocrmda_set_eqd {
+	u32 eq_id;
+	u32 phase;
+	u32 delay_multiplier;
+};
+
+struct ocrdma_modify_eqd_cmd {
+	struct ocrdma_mbx_hdr req;
+	u32 num_eq;
+	struct ocrmda_set_eqd set_eqd[8];
+} __packed;
+
+struct ocrdma_modify_eqd_req {
+	struct ocrdma_mqe_hdr hdr;
+	struct ocrdma_modify_eqd_cmd cmd;
+};
+
+
+struct ocrdma_modify_eq_delay_rsp {
+	struct ocrdma_mbx_rsp hdr;
+	u32 rsvd0;
+} __packed;
+
 enum {
 	OCRDMA_MCQE_STATUS_SHIFT	= 0,
 	OCRDMA_MCQE_STATUS_MASK		= 0xFFFF,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
