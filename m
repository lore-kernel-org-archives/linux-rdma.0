From: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V1 2/2] RDMA/ocrdma: read ASIC_ID register to select
 asic_gen
Date: Wed, 29 Jan 2014 11:47:31 +0000
Message-ID: <5cb7e9a0-812d-4334-9b5a-361e56f66398@CMEXHTCAS2.ad.emulex.com>
References: <1387011914-15046-1-git-send-email-devesh.sharma@emulex.com>
 <f2280bab-542e-4b38-9cde-17c18c9b122b@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f2280bab-542e-4b38-9cde-17c18c9b122b-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Please discard this patch. 
Due to IP based GID changes, this won't apply clean, We are planning to send you a new series of patches on for-next tree please use that instead.

-Regards
 Devesh

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Sent: Saturday, December 14, 2013 2:35 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Devesh Sharma
Subject: [PATCH V1 2/2] RDMA/ocrdma: read ASIC_ID register to select asic_gen

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

compilation error fix

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   17 +++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 24157f0..0c9ec79 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -385,13 +385,6 @@ static inline struct ocrdma_srq *get_ocrdma_srq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct ocrdma_srq, ibsrq);  }
 
-
-static inline int ocrdma_get_num_posted_shift(struct ocrdma_qp *qp) -{
-	return ((qp->dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY &&
-		 qp->id < 128) ? 24 : 16);
-}
-
 static inline int is_cqe_valid(struct ocrdma_cq *cq, struct ocrdma_cqe *cqe)  {
 	int cqe_valid;
@@ -423,15 +416,13 @@ static inline int is_cqe_wr_imm(struct ocrdma_cqe *cqe)
 		OCRDMA_CQE_WRITE_IMM) ? 1 : 0;
 }
 
-
 static inline u8 ocrdma_get_asic_type(struct ocrdma_dev *dev)  {
 	u32 asic_id;
 	u8 asic_gen = 0xF;
 	if (dev->nic_info.dev_family == 0xF) {
 		pci_read_config_dword(dev->nic_info.pdev,
-						OCRDMA_SLI_ASIC_ID_OFFSET,
-						&asic_id);
+					OCRDMA_SLI_ASIC_ID_OFFSET, &asic_id);
 		asic_gen = (asic_id & OCRDMA_SLI_ASIC_GEN_NUM_MASK) >>
 				OCRDMA_SLI_ASIC_GEN_NUM_SHIFT;
 	}
@@ -439,4 +430,10 @@ static inline u8 ocrdma_get_asic_type(struct ocrdma_dev *dev)
 	return asic_gen;
 }
 
+static inline int ocrdma_get_num_posted_shift(struct ocrdma_qp *qp) {
+	return ((ocrdma_get_asic_type(qp->dev) == OCRDMA_ASIC_GEN_SKH_R &&
+		 qp->id < 128) ? 24 : 16);
+}
+
 #endif
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2edbda6..a8f7ccd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1092,7 +1092,7 @@ static int ocrdma_copy_qp_uresp(struct ocrdma_qp *qp,
 	}
 	uresp.db_page_addr = usr_db;
 	uresp.db_page_size = dev->nic_info.db_page_size;
-	if (dev->nic_info.dev_family == OCRDMA_GEN2_FAMILY) {
+	if (ocrdma_get_asic_type(qp->dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		uresp.db_sq_offset = OCRDMA_DB_GEN2_SQ_OFFSET;
 		uresp.db_rq_offset = OCRDMA_DB_GEN2_RQ_OFFSET;
 		uresp.db_shift = 24;
--
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
