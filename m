From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/srpt: Remove redundant wc array
Date: Tue, 12 Jan 2016 13:19:50 +0200
Message-ID: <1452597590-17850-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

No usage after the conversion to the new CQ API.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
This can go as is or be folded to Christoph's srpt patch,
whatever works best.

 drivers/infiniband/ulp/srpt/ib_srpt.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index ff8b907..247c807 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -254,7 +254,6 @@ enum rdma_ch_state {
  * @free_list:     Head of list with free send I/O contexts.
  * @state:         channel state. See also enum rdma_ch_state.
  * @ioctx_ring:    Send ring.
- * @wc:            IB work completion array for srpt_process_completion().
  * @list:          Node for insertion in the srpt_device.rch_list list.
  * @cmd_wait_list: List of SCSI commands that arrived before the RTU event. This
  *                 list contains struct srpt_ioctx elements and is protected
@@ -281,7 +280,6 @@ struct srpt_rdma_ch {
 	struct list_head	free_list;
 	enum rdma_ch_state	state;
 	struct srpt_send_ioctx	**ioctx_ring;
-	struct ib_wc		wc[16];
 	struct list_head	list;
 	struct list_head	cmd_wait_list;
 	struct se_session	*sess;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
