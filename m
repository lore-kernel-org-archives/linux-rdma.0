From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iser-target: Remove an unused variable
Date: Thu, 22 Oct 2015 11:14:18 -0700
Message-ID: <5629277A.20908@sandisk.com>
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
 drivers/infiniband/ulp/isert/ib_isert.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 403bd29..d255fe5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1550,7 +1550,6 @@ isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
 	struct iser_hdr *iser_hdr = &rx_desc->iser_header;
 	uint64_t read_va = 0, write_va = 0;
 	uint32_t read_stag = 0, write_stag = 0;
-	int rc;
 
 	switch (iser_hdr->flags & 0xF0) {
 	case ISCSI_CTRL:
@@ -1577,8 +1576,8 @@ isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
 		break;
 	}
 
-	rc = isert_rx_opcode(isert_conn, rx_desc,
-			     read_stag, read_va, write_stag, write_va);
+	isert_rx_opcode(isert_conn, rx_desc,
+			read_stag, read_va, write_stag, write_va);
 }
 
 static void
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
