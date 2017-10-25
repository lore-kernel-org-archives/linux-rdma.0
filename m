From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] RDMA/cxgb4: Annotate r2 and stag as __be32
Date: Wed, 25 Oct 2017 23:10:19 +0300
Message-ID: <20171025201019.7367-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chelsio cxgb4 HW is big-endian, hence there is need to properly
annotate r2 and stag fields as __be32 and not __u32 to fix the
following sparse warnings.

  drivers/infiniband/hw/cxgb4/qp.c:614:16:
    warning: incorrect type in assignment (different base types)
      expected unsigned int [unsigned] [usertype] r2
      got restricted __be32 [usertype] <noident>
  drivers/infiniband/hw/cxgb4/qp.c:615:18:
    warning: incorrect type in assignment (different base types)
      expected unsigned int [unsigned] [usertype] stag
      got restricted __be32 [usertype] <noident>

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
index 010c709ba3bb..58c531db4f4a 100644
--- a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
+++ b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
@@ -675,8 +675,8 @@ struct fw_ri_fr_nsmr_tpte_wr {
 	__u16  wrid;
 	__u8   r1[3];
 	__u8   len16;
-	__u32  r2;
-	__u32  stag;
+	__be32  r2;
+	__be32  stag;
 	struct fw_ri_tpte tpte;
 	__u64  pbl[2];
 };
--
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
