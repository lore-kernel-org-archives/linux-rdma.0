From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: correct smatch issue in qib_init.c
Date: Mon, 23 Jul 2012 12:38:15 -0400
Message-ID: <20120723163815.17679.83323.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 36a8f01c ("IB/qib: Add congestion control agent implementation")
introduced an smatch warning.

This patch corrects the issue.

Additionally, Ram Vepa should have been credited as the author for
36a8f01c.

Reviewed-by: Ramkrishna Vepa <ramkrishna.vepa-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 6e19ec8..7b1b866 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -656,6 +656,11 @@ struct qib_pportdata {
 	/* 16 congestion entries with each entry corresponding to a SL */
 	struct ib_cc_congestion_entry_shadow *congestion_entries;
 
+	/* Maximum number of congestion control entries that the agent expects
+	 * the manager to send.
+	 */
+	u16 cc_supported_table_entries;
+
 	/* Total number of congestion control table entries */
 	u16 total_cct_entry;
 
@@ -667,11 +672,6 @@ struct qib_pportdata {
 
 	/* CA's max number of 64 entry units in the congestion control table */
 	u8 cc_max_table_entries;
-
-	/* Maximum number of congestion control entries that the agent expects
-	 * the manager to send.
-	 */
-	u8 cc_supported_table_entries;
 };
 
 /* Observers. Not to be taken lightly, possibly not to ship. */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
