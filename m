From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCHv1 1/1] IB/iser: Fix sg_tablesize calculation
Date: Mon, 16 Jan 2017 19:44:41 +0200
Message-ID: <1484588681-12987-2-git-send-email-maxg@mellanox.com>
References: <1484588681-12987-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484588681-12987-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For devices that can register page list that is bigger than
USHRT_MAX, we actually take the wrong value for sg_tablesize.
E.g: for CX4 max_fast_reg_page_list_len is 65536 (bigger than USHRT_MAX)
so we set sg_tablesize to 0 by mistake. Therefore, each IO that is
bigger than 4k splitted to "< 4k" chunks that cause performance degredation.

Fixes: 7854550ae6d8 ("RDMA/iser: Limit sgs to the device fastreg depth")
Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9104e6b..ff37f19 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -656,7 +656,8 @@ static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 		 * max fastreg page list length.
 		 */
 		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
-			ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len);
+				      min_t(unsigned int, USHRT_MAX,
+			ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len));
 
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
