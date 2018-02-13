From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 02/15] RDMA/restrack: Remove unimplemented XRCD object
Date: Tue, 13 Feb 2018 12:18:28 +0200
Message-ID: <20180213101841.20101-3-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Resource tracking of XRCD objects is not implemented in current
version of restrack and hence can be removed.

Fixes: 02d8883f520e ("RDMA/restrack: Add general infrastructure to track RDMA resources")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/restrack.c | 5 -----
 include/rdma/restrack.h            | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 857637bf46da..d8dc709a3715 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -63,7 +63,6 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 {
 	enum rdma_restrack_type type = res->type;
 	struct ib_device *dev;
-	struct ib_xrcd *xrcd;
 	struct ib_pd *pd;
 	struct ib_cq *cq;
 	struct ib_qp *qp;
@@ -81,10 +80,6 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 		qp = container_of(res, struct ib_qp, res);
 		dev = qp->device;
 		break;
-	case RDMA_RESTRACK_XRCD:
-		xrcd = container_of(res, struct ib_xrcd, res);
-		dev = xrcd->device;
-		break;
 	default:
 		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
 		return NULL;
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
index c2d81167c858..2cdf8dcf4bdc 100644
--- a/include/rdma/restrack.h
+++ b/include/rdma/restrack.h
@@ -28,10 +28,6 @@ enum rdma_restrack_type {
 	 * @RDMA_RESTRACK_QP: Queue pair (QP)
 	 */
 	RDMA_RESTRACK_QP,
-	/**
-	 * @RDMA_RESTRACK_XRCD: XRC domain (XRCD)
-	 */
-	RDMA_RESTRACK_XRCD,
 	/**
 	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
 	 */
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
