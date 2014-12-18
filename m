From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/14] RDMA/ocrdma: Honor return value of ocrdma_resolve_dmac.
Date: Thu, 18 Dec 2014 14:13:04 +0530
Message-ID: <e4484fbd-1710-4eda-a0d9-3cd183e53772@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Check for return value for ocrdma_resolve_dmac while setting AV params.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 65b5923..8176bd6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2452,7 +2452,9 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 
 	qp->sgid_idx = ah_attr->grh.sgid_index;
 	memcpy(&cmd->params.sgid[0], &sgid.raw[0], sizeof(cmd->params.sgid));
-	ocrdma_resolve_dmac(qp->dev, ah_attr, &mac_addr[0]);
+	status = ocrdma_resolve_dmac(qp->dev, ah_attr, &mac_addr[0]);
+	if (status)
+		return status;
 	cmd->params.dmac_b0_to_b3 = mac_addr[0] | (mac_addr[1] << 8) |
 				(mac_addr[2] << 16) | (mac_addr[3] << 24);
 	/* convert them to LE format. */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
