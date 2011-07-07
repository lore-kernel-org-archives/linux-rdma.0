From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 09/12] Clear status reporting from mthca_mad
Date: Thu, 7 Jul 2011 12:22:41 -0500
Message-ID: <20110707172241.GJ10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_mad.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 03a59534..b6f7f45 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -201,7 +201,6 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      struct ib_mad *out_mad)
 {
 	int err;
-	u8 status;
 	u16 slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 	u16 prev_lid = 0;
 	struct ib_port_attr pattr;
@@ -252,17 +251,11 @@ int mthca_process_mad(struct ib_device *ibdev,
 	err = mthca_MAD_IFC(to_mdev(ibdev),
 			    mad_flags & IB_MAD_IGNORE_MKEY,
 			    mad_flags & IB_MAD_IGNORE_BKEY,
-			    port_num, in_wc, in_grh, in_mad, out_mad,
-			    &status);
-	if (err) {
-		mthca_err(to_mdev(ibdev), "MAD_IFC failed\n");
-		return IB_MAD_RESULT_FAILURE;
-	}
-	if (status == MTHCA_CMD_STAT_BAD_PKT)
+			    port_num, in_wc, in_grh, in_mad, out_mad);
+	if (err == -EBADMSG)
 		return IB_MAD_RESULT_SUCCESS;
-	if (status) {
-		mthca_err(to_mdev(ibdev), "MAD_IFC returned status %02x\n",
-			  status);
+	else if (err) {
+		mthca_err(to_mdev(ibdev), "MAD_IFC returned %d\n", err);
 		return IB_MAD_RESULT_FAILURE;
 	}
 
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
