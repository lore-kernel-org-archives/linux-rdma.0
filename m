From: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/qib: define max IB ports instead of variable stack
	allocation
Date: Wed, 02 Jun 2010 17:21:07 -0700
Message-ID: <20100603002107.8958.18499.stgit@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Rather than use a variable size array allocation on the stack,
define a constant for the maximum array size possible.

Signed-off-by: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---

 drivers/infiniband/hw/qib/qib.h    |    3 +++
 drivers/infiniband/hw/qib/qib_tx.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 32d9208..211ff6a 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -326,6 +326,9 @@ struct qib_verbs_txreq {
 
 #define QIB_DEFAULT_MTU 4096
 
+/* max number of IB ports supported per HCA */
+#define QIB_MAX_IB_PORTS 2
+
 /*
  * Possible IB config parameters for f_get/set_ib_table()
  */
diff --git a/drivers/infiniband/hw/qib/qib_tx.c b/drivers/infiniband/hw/qib/qib_tx.c
index f7eb1dd..77909b5 100644
--- a/drivers/infiniband/hw/qib/qib_tx.c
+++ b/drivers/infiniband/hw/qib/qib_tx.c
@@ -170,7 +170,7 @@ static int find_ctxt(struct qib_devdata *dd, unsigned bufn)
 void qib_disarm_piobufs_set(struct qib_devdata *dd, unsigned long *mask,
 			    unsigned cnt)
 {
-	struct qib_pportdata *ppd, *pppd[dd->num_pports];
+	struct qib_pportdata *ppd, *pppd[QIB_MAX_IB_PORTS];
 	unsigned i;
 	unsigned long flags;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
