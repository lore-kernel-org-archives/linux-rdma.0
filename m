From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] infiniband: hw: i40iw: fix duplicated code for different
 branches
Date: Thu, 18 May 2017 13:11:17 -0500
Message-ID: <20170518181117.GA14287@embeddedgus>
References: <20170518125413.Horde.xnD_6K5mFzkhQLdyz7R3LXt@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170518125413.Horde.xnD_6K5mFzkhQLdyz7R3LXt@gator4166.hostgator.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Yuval Shaia <yuval.shaia@oracle.com>, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org

Refactor code to avoid identical code for different branches.

Addresses-Coverity-ID: 1357356
Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
index f4d1368..48fd327 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
@@ -443,10 +443,7 @@ enum i40iw_status_code i40iw_vchnl_recv_pf(struct i40iw_sc_dev *dev,
 	if (!dev->vchnl_up)
 		return I40IW_ERR_NOT_READY;
 	if (vchnl_msg->iw_op_code == I40IW_VCHNL_OP_GET_VER) {
-		if (vchnl_msg->iw_op_ver != I40IW_VCHNL_OP_GET_VER_V0)
-			vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
-		else
-			vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
+		vchnl_pf_send_get_ver_resp(dev, vf_id, vchnl_msg);
 		return I40IW_SUCCESS;
 	}
 	for (iw_vf_idx = 0; iw_vf_idx < I40IW_MAX_PE_ENABLED_VF_COUNT; iw_vf_idx++) {
-- 
2.5.0
