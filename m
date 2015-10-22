From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] IB/iser: Remove an unused variable
Date: Thu, 22 Oct 2015 10:59:18 -0700
Message-ID: <562923F6.7070300@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Detected this by compiling with W=1.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1ace5d8..92ab48f 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -121,7 +121,6 @@ iscsi_iser_recv(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	int rc = 0;
 	int datalen;
-	int ahslen;
 
 	/* verify PDU length */
 	datalen = ntoh24(hdr->dlength);
@@ -136,9 +135,6 @@ iscsi_iser_recv(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		iser_dbg("aligned datalen (%d) hdr, %d (IB)\n",
 			datalen, rx_data_len);
 
-	/* read AHS */
-	ahslen = hdr->hlength * 4;
-
 	rc = iscsi_complete_pdu(conn, hdr, rx_data, rx_data_len);
 	if (rc && rc != ISCSI_ERR_NO_SCSI_CMD)
 		goto error;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
