From: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/8] bnxt_re: Stop issuing further cmds to FW once a cmd times out
Date: Thu, 31 Aug 2017 09:27:29 +0530
Message-ID: <20170831035735.19595-3-somnath.kotur@broadcom.com>
References: <20170831035735.19595-1-somnath.kotur@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170831035735.19595-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Once a cmd to FW times out(after 20s) it is reasonable to
assume the FW or atleast the control path is dead.
No point issuing further cmds to the FW as each subsequent cmd
with another 20s timeout will cascade resulting in unnecessary
traces and/or NMI Lockups.

Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 4 ++++
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 391bb70..2bdb156 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -107,6 +107,9 @@ static int __send_message(struct bnxt_qplib_rcfw *rcfw, struct cmdq_base *req,
 		return -EINVAL;
 	}
 
+	if (test_bit(FIRMWARE_TIMED_OUT, &rcfw->flags))
+		return -ETIMEDOUT;
+
 	/* Cmdq are in 16-byte units, each request can consume 1 or more
 	 * cmdqe
 	 */
@@ -226,6 +229,7 @@ int bnxt_qplib_rcfw_send_message(struct bnxt_qplib_rcfw *rcfw,
 		/* timed out */
 		dev_err(&rcfw->pdev->dev, "QPLIB: cmdq[%#x]=%#x timedout (%d)msec",
 			cookie, opcode, RCFW_CMD_WAIT_TIME_MS);
+		set_bit(FIRMWARE_TIMED_OUT, &rcfw->flags);
 		return rc;
 	}
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 0ed312f..85b16da 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -162,8 +162,9 @@ struct bnxt_qplib_rcfw {
 	unsigned long		*cmdq_bitmap;
 	u32			bmap_size;
 	unsigned long		flags;
-#define FIRMWARE_INITIALIZED_FLAG	1
+#define FIRMWARE_INITIALIZED_FLAG	BIT(0)
 #define FIRMWARE_FIRST_FLAG		BIT(31)
+#define FIRMWARE_TIMED_OUT		BIT(3)
 	wait_queue_head_t	waitq;
 	int			(*aeq_handler)(struct bnxt_qplib_rcfw *,
 					       struct creq_func_event *);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
