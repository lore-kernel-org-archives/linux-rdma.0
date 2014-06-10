From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 for-next 06/16] RDMA/ocrdma: Remove hardcoding of the max DPP QPs supported
Date: Tue, 10 Jun 2014 19:32:17 +0530
Message-ID: <3485bb4e-54dc-4a5b-b157-bb6d9a35f30e@CMEXHTCAS1.ad.emulex.com>
References: <1402408947-2074-1-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-2-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-3-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-4-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-5-git-send-email-selvin.xavier@emulex.com>
 <1402408947-2074-6-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402408947-2074-6-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Removing hardcoded value of max dpp qps and calculate the same from
doorbell page size and WQE size

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 4defae8..14a84b2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1236,7 +1236,6 @@ struct ocrdma_destroy_srq {
 
 enum {
 	OCRDMA_ALLOC_PD_ENABLE_DPP	= BIT(16),
-	OCRDMA_PD_MAX_DPP_ENABLED_QP	= 8,
 	OCRDMA_DPP_PAGE_SIZE		= 4096
 };
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index edf6211..0d7d808 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -268,7 +268,8 @@ static struct ocrdma_pd *_ocrdma_alloc_pd(struct ocrdma_dev *dev,
 		pd->dpp_enabled =
 			ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R;
 		pd->num_dpp_qp =
-			pd->dpp_enabled ? OCRDMA_PD_MAX_DPP_ENABLED_QP : 0;
+			pd->dpp_enabled ? (dev->nic_info.db_page_size /
+					   dev->attr.wqe_size) : 0;
 	}
 
 retry:
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
