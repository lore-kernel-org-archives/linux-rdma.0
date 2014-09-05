From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH REPOST 2/2] RDMA/ocrdma: use right macro in query ah
Date: Fri, 5 Sep 2014 19:22:13 +0530
Message-ID: <e3688539-4164-49fd-82a1-548c64824bbb@CMEXHTCAS2.ad.emulex.com>
References: <1409925133-14794-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409925133-14794-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

query-ah does not uses correct macro and checks the wrong bit
for the validity of address handle in vector table.
This patch is a fix for it.

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 8d21e33..ab29346 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -164,7 +164,7 @@ int ocrdma_query_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
 	struct ocrdma_av *av = ah->av;
 	struct ocrdma_grh *grh;
 	attr->ah_flags |= IB_AH_GRH;
-	if (ah->av->valid & Bit(1)) {
+	if (ah->av->valid & OCRDMA_AV_VALID) {
 		grh = (struct ocrdma_grh *)((u8 *)ah->av +
 				sizeof(struct ocrdma_eth_vlan));
 		attr->sl = be16_to_cpu(av->eth_hdr.vlan_tag) >> 13;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
