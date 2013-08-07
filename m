From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] RDMA/ocrdma: Don't allow zero/invalid sgid usage.
Date: Wed, 7 Aug 2013 12:52:34 +0530
Message-ID: <b400e330-3605-4ac5-9f41-846f73459264@CMEXHTCAS1.ad.emulex.com>
References: <1375860157-10588-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375860157-10588-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Dont allow zero/invalid sgid usage.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 6bbcc78..af01ba2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2124,9 +2124,10 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 {
 	int status;
 	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
-	union ib_gid sgid;
+	union ib_gid sgid, zgid;
 	u32 vlan_id;
 	u8 mac_addr[6];
+
 	if ((ah_attr->ah_flags & IB_AH_GRH) == 0)
 		return -EINVAL;
 	cmd->params.tclass_sq_psn |=
@@ -2142,6 +2143,11 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 			 ah_attr->grh.sgid_index, &sgid);
 	if (status)
 		return status;
+
+	memset(&zgid, 0, sizeof(zgid));
+	if (!memcmp(&sgid, &zgid, sizeof(zgid)))
+		return -EINVAL;
+
 	qp->sgid_idx = ah_attr->grh.sgid_index;
 	memcpy(&cmd->params.sgid[0], &sgid.raw[0], sizeof(cmd->params.sgid));
 	ocrdma_resolve_dgid(qp->dev, &ah_attr->grh.dgid, &mac_addr[0]);
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
