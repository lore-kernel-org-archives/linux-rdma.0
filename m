From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 01/12] Introduce mthca_status_to_errno
Date: Thu, 7 Jul 2011 12:20:40 -0500
Message-ID: <20110707172039.GB10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function converts the status to an errno code which is returned to
the calling function. This avoids bouncing the status variable for
returning the status of the command to the calling function.

This is in lines with mlx4_status_to_errno in drivers/net/mlx4/cmd.c
---
 drivers/infiniband/hw/mthca/mthca_cmd.c |   65 +++++++++++++++++++++++-------
 1 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 7bfa2a1..45461ad 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -301,6 +301,38 @@ static int mthca_cmd_post(struct mthca_dev *dev,
 	return err;
 }
 
+
+static int mthca_status_to_errno(u8 status)
+{
+	static const int trans_table[] = {
+		[MTHCA_CMD_STAT_INTERNAL_ERR]   = -EIO,
+		[MTHCA_CMD_STAT_BAD_OP]         = -EPERM,
+		[MTHCA_CMD_STAT_BAD_PARAM]      = -EINVAL,
+		[MTHCA_CMD_STAT_BAD_SYS_STATE]  = -ENXIO,
+		[MTHCA_CMD_STAT_BAD_RESOURCE]   = -EBADF,
+		[MTHCA_CMD_STAT_RESOURCE_BUSY]  = -EBUSY,
+		[MTHCA_CMD_STAT_DDR_MEM_ERR]    = -ENOMEM,
+		[MTHCA_CMD_STAT_EXCEED_LIM]     = -ENOMEM,
+		[MTHCA_CMD_STAT_BAD_RES_STATE]  = -EBADF,
+		[MTHCA_CMD_STAT_BAD_INDEX]      = -EBADF,
+		[MTHCA_CMD_STAT_BAD_NVMEM]      = -EFAULT,
+		[MTHCA_CMD_STAT_BAD_QPEE_STATE] = -EINVAL,
+		[MTHCA_CMD_STAT_BAD_SEG_PARAM]  = -EFAULT,
+		[MTHCA_CMD_STAT_REG_BOUND]      = -EBUSY,
+		[MTHCA_CMD_STAT_LAM_NOT_PRE]    = -EAGAIN,
+		[MTHCA_CMD_STAT_BAD_PKT]        = -EBADMSG,
+		[MTHCA_CMD_STAT_BAD_SIZE]       = -ENOMEM,
+	};
+
+	if (status >= ARRAY_SIZE(trans_table) ||
+			(status != MTHCA_CMD_STAT_OK 
+			 && trans_table[status] == 0))
+		return -EINVAL;
+
+	return trans_table[status];
+}
+
+
 static int mthca_cmd_poll(struct mthca_dev *dev,
 			  u64 in_param,
 			  u64 *out_param,
@@ -308,11 +340,11 @@ static int mthca_cmd_poll(struct mthca_dev *dev,
 			  u32 in_modifier,
 			  u8 op_modifier,
 			  u16 op,
-			  unsigned long timeout,
-			  u8 *status)
+			  unsigned long timeout)
 {
 	int err = 0;
 	unsigned long end;
+	u8 status;
 
 	down(&dev->cmd.poll_sem);
 
@@ -341,7 +373,12 @@ static int mthca_cmd_poll(struct mthca_dev *dev,
 			(u64) be32_to_cpu((__force __be32)
 					  __raw_readl(dev->hcr + HCR_OUT_PARAM_OFFSET + 4));
 
-	*status = be32_to_cpu((__force __be32) __raw_readl(dev->hcr + HCR_STATUS_OFFSET)) >> 24;
+	status = be32_to_cpu((__force __be32) __raw_readl(dev->hcr + HCR_STATUS_OFFSET)) >> 24;
+	if (status) {
+		mthca_dbg(dev, "Command %02x completed with status %02x\n",
+			  op, status);
+		err = mthca_status_to_errno(status);
+	}
 
 out:
 	up(&dev->cmd.poll_sem);
@@ -374,8 +411,7 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 			  u32 in_modifier,
 			  u8 op_modifier,
 			  u16 op,
-			  unsigned long timeout,
-			  u8 *status)
+			  unsigned long timeout)
 {
 	int err = 0;
 	struct mthca_cmd_context *context;
@@ -407,10 +443,11 @@ static int mthca_cmd_wait(struct mthca_dev *dev,
 	if (err)
 		goto out;
 
-	*status = context->status;
-	if (*status)
+	if (context->status) {
 		mthca_dbg(dev, "Command %02x completed with status %02x\n",
-			  op, *status);
+			  op, context->status);
+		err = mthca_status_to_errno(context->status);
+	}
 
 	if (out_is_imm)
 		*out_param = context->out_param;
@@ -432,17 +469,16 @@ static int mthca_cmd_box(struct mthca_dev *dev,
 			 u32 in_modifier,
 			 u8 op_modifier,
 			 u16 op,
-			 unsigned long timeout,
-			 u8 *status)
+			 unsigned long timeout)
 {
 	if (dev->cmd.flags & MTHCA_CMD_USE_EVENTS)
 		return mthca_cmd_wait(dev, in_param, &out_param, 0,
 				      in_modifier, op_modifier, op,
-				      timeout, status);
+				      timeout);
 	else
 		return mthca_cmd_poll(dev, in_param, &out_param, 0,
 				      in_modifier, op_modifier, op,
-				      timeout, status);
+				      timeout);
 }
 
 /* Invoke a command with no output parameter */
@@ -451,11 +487,10 @@ static int mthca_cmd(struct mthca_dev *dev,
 		     u32 in_modifier,
 		     u8 op_modifier,
 		     u16 op,
-		     unsigned long timeout,
-		     u8 *status)
+		     unsigned long timeout)
 {
 	return mthca_cmd_box(dev, in_param, 0, in_modifier,
-			     op_modifier, op, timeout, status);
+			     op_modifier, op, timeout);
 }
 
 /*
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
