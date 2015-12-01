From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/6] IB/srp: Initialize dma_length in srp_map_idb
Date: Tue, 1 Dec 2015 10:18:30 -0800
Message-ID: <565DE476.3080308@sandisk.com>
References: <565DE3EC.2070002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565DE3EC.2070002-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Without this sg_dma_len will return 0 on architectures tha have
the dma_length field.

Fixes: commit f7f7aab1a5c0 ("IB/srp: Convert to new registration API")
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c7a95d2..72fac20 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1524,6 +1524,9 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
 		state.sg_nents = 1;
 		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
 		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
+#ifdef CONFIG_NEED_SG_DMA_LENGTH
+		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
+#endif
 		ret = srp_map_finish_fr(&state, ch);
 		if (ret < 0)
 			return ret;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
