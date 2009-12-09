From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/11] RDMA/nes: fix query of ORD values
Date: Wed, 9 Dec 2009 16:38:56 -0600
Message-ID: <20091209223856.GA127904@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ORD size needs updating as we are supporting more inbound READ resources
per connection.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 7a77450..0e3eee2 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -534,16 +534,16 @@ static int nes_query_device(struct ib_device *ibdev, struct ib_device_attr *prop
 	props->max_sge_rd = 1;
 	switch (nesdev->nesadapter->max_irrq_wr) {
 		case 0:
-			props->max_qp_rd_atom = 1;
+			props->max_qp_rd_atom = 2;
 			break;
 		case 1:
-			props->max_qp_rd_atom = 4;
+			props->max_qp_rd_atom = 8;
 			break;
 		case 2:
-			props->max_qp_rd_atom = 16;
+			props->max_qp_rd_atom = 32;
 			break;
 		case 3:
-			props->max_qp_rd_atom = 32;
+			props->max_qp_rd_atom = 64;
 			break;
 		default:
 			props->max_qp_rd_atom = 0;
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
