From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] i40iw: pass hw_stats by reference rather than by value
Date: Mon, 28 Mar 2016 12:14:46 +0100
Message-ID: <1459163686-6455-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

passing hw_stats by value requires a 280 byte copy so instead
pass it by reference is much more efficient.

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
index 6b68f78..62bb8265 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
@@ -254,7 +254,7 @@ static void vchnl_pf_send_get_hmc_fcn_resp(struct i40iw_sc_dev *dev,
 static void vchnl_pf_send_get_pe_stats_resp(struct i40iw_sc_dev *dev,
 					    u32 vf_id,
 					    struct i40iw_virtchnl_op_buf *vchnl_msg,
-					    struct i40iw_dev_hw_stats hw_stats)
+					    struct i40iw_dev_hw_stats *hw_stats)
 {
 	enum i40iw_status_code ret_code;
 	u8 resp_buffer[sizeof(struct i40iw_virtchnl_resp_buf) + sizeof(struct i40iw_dev_hw_stats) - 1];
@@ -264,7 +264,7 @@ static void vchnl_pf_send_get_pe_stats_resp(struct i40iw_sc_dev *dev,
 	vchnl_msg_resp->iw_chnl_op_ctx = vchnl_msg->iw_chnl_op_ctx;
 	vchnl_msg_resp->iw_chnl_buf_len = sizeof(resp_buffer);
 	vchnl_msg_resp->iw_op_ret_code = I40IW_SUCCESS;
-	*((struct i40iw_dev_hw_stats *)vchnl_msg_resp->iw_chnl_buf) = hw_stats;
+	*((struct i40iw_dev_hw_stats *)vchnl_msg_resp->iw_chnl_buf) = *hw_stats;
 	ret_code = dev->vchnl_if.vchnl_send(dev, vf_id, resp_buffer, sizeof(resp_buffer));
 	if (ret_code)
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
@@ -541,7 +541,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct i40iw_sc_dev *dev,
 		devstat->ops.iw_hw_stat_read_all(devstat, &devstat->hw_stats);
 		spin_unlock_irqrestore(&dev->dev_pestat.stats_lock, flags);
 		vf_dev->msg_count--;
-		vchnl_pf_send_get_pe_stats_resp(dev, vf_id, vchnl_msg, devstat->hw_stats);
+		vchnl_pf_send_get_pe_stats_resp(dev, vf_id, vchnl_msg, &devstat->hw_stats);
 		break;
 	default:
 		i40iw_debug(dev, I40IW_DEBUG_VIRT,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
