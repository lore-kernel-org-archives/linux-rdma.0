From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/iser: Limit sgs to the device fastreg depth
Date: Tue, 28 Jul 2015 09:13:52 -0500
Message-ID: <20150728141152.13342.45907.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently the sg tablesize, which dictates fast register page list
depth to use, does not take into account the limits of the rdma device.
So adjust it once we discover the device fastreg max depth limit.  Also
adjust the max_sectors based on the resulting sg tablesize.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
Note: This patch was originally part of
http://www.spinics.net/lists/linux-rdma/msg27436.html. The isert work
will be a separate series, so I'm submitting this one to go ahead and
get it merged.
---


 drivers/infiniband/ulp/iser/iscsi_iser.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 6a594aa..de8730d 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -640,6 +640,15 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 						   SHOST_DIX_GUARD_CRC);
 		}
 
+		/*
+		 * Limit the sg_tablesize and max_sectors based on the device
+		 * max fastreg page list length.
+		 */
+		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
+			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
+		shost->max_sectors = min_t(unsigned int,
+			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
+
 		if (iscsi_host_add(shost,
 				   ib_conn->device->ib_device->dma_device)) {
 			mutex_unlock(&iser_conn->state_mutex);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
