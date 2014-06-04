From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 15/15] RDMA/ocrdma: Fixing a sparse warning
Date: Wed, 4 Jun 2014 14:22:46 +0530
Message-ID: <16798461-18bb-4b6a-a1a0-183ecac2ad92@CMEXHTCAS1.ad.emulex.com>
References: <1401871966-20408-1-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-2-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-3-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-4-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-5-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-6-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-7-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-8-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-9-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-10-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-11-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-12-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-13-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-14-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-15-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401871966-20408-15-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing the warning about the usage of plain integer as NULL pointer

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 105659d..a4d27c7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -661,7 +661,7 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 {
 	struct ocrdma_qp *qp = NULL;
 	struct ocrdma_cq *cq = NULL;
-	struct ib_event ib_evt = { 0 };
+	struct ib_event ib_evt;
 	int cq_event = 0;
 	int qp_event = 1;
 	int srq_event = 0;
@@ -674,6 +674,8 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 	if (cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQVALID)
 		cq = dev->cq_tbl[cqe->cqvalid_cqid & OCRDMA_AE_MCQE_CQID_MASK];
 
+	memset(&ib_evt, 0, sizeof(ib_evt));
+
 	ib_evt.device = &dev->ibdev;
 
 	switch (type) {
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
