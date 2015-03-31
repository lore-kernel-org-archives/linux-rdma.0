From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 03/18] IB/iser: Fix wrong calculation of protection buffer length
Date: Tue, 31 Mar 2015 19:45:43 +0300
Message-ID: <1427820358-15087-4-git-send-email-sagig@mellanox.com>
References: <1427820358-15087-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427820358-15087-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This length miss-calculation may cause a silent data corruption
in the DIX case and cause the device to reference unmapped area.

Fixes: d77e65350f2d ('libiscsi, iser: Adjust data_length to include protection information')
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 20e859a..76eb57b 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -409,8 +409,8 @@ int iser_send_command(struct iscsi_conn *conn,
 	if (scsi_prot_sg_count(sc)) {
 		prot_buf->buf  = scsi_prot_sglist(sc);
 		prot_buf->size = scsi_prot_sg_count(sc);
-		prot_buf->data_len = data_buf->data_len >>
-				     ilog2(sc->device->sector_size) * 8;
+		prot_buf->data_len = (data_buf->data_len >>
+				     ilog2(sc->device->sector_size)) * 8;
 	}
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
