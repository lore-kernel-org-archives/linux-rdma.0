From: Devesh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sharma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: [PATCH for-next 1/2] RDMA/ocrdma: Report actual value of max_fast_reg_page_list_len
Date: Mon, 9 Jun 2014 10:52:37 +0530
Message-ID: <1188adea-1d05-4374-939b-7e8098b2de77@CMEXHTCAS2.ad.emulex.com>
References: <1402291358-24901-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402291358-24901-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

ocrdma_query_device does not report correct value of max_fast_reg_page_list_len.
This patch applies changes to fix this bug.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 90152de..55aad54 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -101,7 +101,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	attr->max_srq_sge = dev->attr.max_srq_sge;
 	attr->max_srq_wr = dev->attr.max_rqe;
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
-	attr->max_fast_reg_page_list_len = 0;
+	attr->max_fast_reg_page_list_len = dev->attr.max_pages_per_frmr;
 	attr->max_pkeys = 1;
 	return 0;
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
