From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 19/22] IB/srpt: Fix srpt_write_pending()
Date: Fri, 29 Jan 2016 15:17:59 -0800
Message-ID: <56ABF327.3010005@sandisk.com>
References: <56ABF16E.7070006@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56ABF16E.7070006-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only allowed return values for the write_pending() callback
function are 0, -EAGAIN and -ENOMEM. Since attempting to perform
RDMA over a disconnecting channel will result in an IB error
completion anyway, remove the code that checks the channel state
from srpt_write_pending().

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 33 ++++-----------------------------
 1 file changed, 4 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e9c3067..a7c966f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2481,39 +2481,14 @@ static int srpt_write_pending_status(struct se_cmd *se_cmd)
  */
 static int srpt_write_pending(struct se_cmd *se_cmd)
 {
-	struct srpt_rdma_ch *ch;
-	struct srpt_send_ioctx *ioctx;
+	struct srpt_send_ioctx *ioctx =
+		container_of(se_cmd, struct srpt_send_ioctx, cmd);
+	struct srpt_rdma_ch *ch = ioctx->ch;
 	enum srpt_command_state new_state;
-	int ret;
-
-	ioctx = container_of(se_cmd, struct srpt_send_ioctx, cmd);
 
 	new_state = srpt_set_cmd_state(ioctx, SRPT_STATE_NEED_DATA);
 	WARN_ON(new_state == SRPT_STATE_DONE);
-
-	ch = ioctx->ch;
-	BUG_ON(!ch);
-
-	switch (ch->state) {
-	case CH_CONNECTING:
-		WARN(true, "unexpected channel state %d\n", ch->state);
-		ret = -EINVAL;
-		goto out;
-	case CH_LIVE:
-		break;
-	case CH_DISCONNECTING:
-	case CH_DRAINING:
-	case CH_DISCONNECTED:
-		pr_debug("cmd with tag %lld: channel disconnecting\n",
-			 ioctx->cmd.tag);
-		srpt_set_cmd_state(ioctx, SRPT_STATE_DATA_IN);
-		ret = -EINVAL;
-		goto out;
-	}
-	ret = srpt_xfer_data(ch, ioctx);
-
-out:
-	return ret;
+	return srpt_xfer_data(ch, ioctx);
 }
 
 static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
