From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: AV_VALID bit position fix
Date: Thu, 5 Dec 2013 15:48:01 +0530
Message-ID: <560636d5-99d4-4d65-830f-30a2c0e99973@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

fixed ah->av->valid bit position and big endian portability.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c  |    1 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index ee499d9..69da5dd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -84,6 +84,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	memcpy((u8 *)ah->av + eth_sz, &grh, sizeof(struct ocrdma_grh));
 	if (vlan_enabled)
 		ah->av->valid |= OCRDMA_AV_VLAN_VALID;
+	ah->av->valid = cpu_to_le32(ah->av->valid);
 	return status;
 }
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 9f9570e..2708903 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1694,7 +1694,7 @@ struct ocrdma_grh {
 	u16	rsvd;
 } __packed;
 
-#define OCRDMA_AV_VALID		Bit(0)
+#define OCRDMA_AV_VALID		Bit(7)
 #define OCRDMA_AV_VLAN_VALID	Bit(1)
 
 struct ocrdma_av {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
