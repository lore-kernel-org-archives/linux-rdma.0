From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/qib: add err_decode() call for ring dump
Date: Fri, 19 Jul 2013 13:57:33 -0400
Message-ID: <20130719175733.8700.13188.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit b3ddf380 ("Log all SDMA errors unconditionally") missed
part of the patch.

This also corrects a format warning when dma_addr_t is 32 bits
on a 64 bit system.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 ++
 drivers/infiniband/hw/qib/qib_sdma.c    |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 21e8b09..016e742 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -1596,6 +1596,8 @@ static void sdma_7322_p_errors(struct qib_pportdata *ppd, u64 errs)
 	struct qib_devdata *dd = ppd->dd;
 
 	errs &= QIB_E_P_SDMAERRS;
+	err_decode(ppd->cpspec->sdmamsgbuf, sizeof(ppd->cpspec->sdmamsgbuf),
+		   errs, qib_7322p_error_msgs);
 
 	if (errs & QIB_E_P_SDMAUNEXPDATA)
 		qib_dev_err(dd, "IB%u:%u SDmaUnexpData\n", dd->unit,
diff --git a/drivers/infiniband/hw/qib/qib_sdma.c b/drivers/infiniband/hw/qib/qib_sdma.c
index f63b2ac..c6d6a54 100644
--- a/drivers/infiniband/hw/qib/qib_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_sdma.c
@@ -723,7 +723,7 @@ void dump_sdma_state(struct qib_pportdata *ppd)
 	struct qib_sdma_txreq *txp, *txpnext;
 	__le64 *descqp;
 	u64 desc[2];
-	dma_addr_t addr;
+	u64 addr;
 	u16 gen, dwlen, dwoffset;
 	u16 head, tail, cnt;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
