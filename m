From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/7] IB/qib: Eliminate divide/mod in converting idx to egr buf
	pointer
Date: Fri, 23 Sep 2011 13:16:39 -0400
Message-ID: <20110923171639.14542.85925.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The context init now saves a shift from rcvegrbufs_perchunk
rcvegrbufs_perchunk_shift using ilog2.   A BUG_ON protects the
power of 2 assumption.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h         |    8 ++++++--
 drivers/infiniband/hw/qib/qib_driver.c  |    6 +++---
 drivers/infiniband/hw/qib/qib_iba6120.c |    2 ++
 drivers/infiniband/hw/qib/qib_iba7220.c |    2 ++
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 ++
 drivers/infiniband/hw/qib/qib_init.c    |    3 +++
 6 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index ee993e7..97e6233 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -171,7 +171,9 @@ struct qib_ctxtdata {
 	/* how many alloc_pages() chunks in rcvegrbuf_pages */
 	u32 rcvegrbuf_chunks;
 	/* how many egrbufs per chunk */
-	u32 rcvegrbufs_perchunk;
+	u16 rcvegrbufs_perchunk;
+	/* ilog2 of above */
+	u16 rcvegrbufs_perchunk_shift;
 	/* order for rcvegrbuf_pages */
 	size_t rcvegrbuf_size;
 	/* rcvhdrq size (for freeing) */
@@ -940,7 +942,9 @@ struct qib_devdata {
 	/* chip address space used by 4k pio buffers */
 	u32 align4k;
 	/* size of each rcvegrbuffer */
-	u32 rcvegrbufsize;
+	u16 rcvegrbufsize;
+	/* log2 of above */
+	u16 rcvegrbufsize_shift;
 	/* localbus width (1, 2,4,8,16,32) from config space  */
 	u32 lbus_width;
 	/* localbus speed in MHz */
diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 23e584f..89264ff 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -279,10 +279,10 @@ bail:
  */
 static inline void *qib_get_egrbuf(const struct qib_ctxtdata *rcd, u32 etail)
 {
-	const u32 chunk = etail / rcd->rcvegrbufs_perchunk;
-	const u32 idx =  etail % rcd->rcvegrbufs_perchunk;
+	const u32 chunk = etail >> rcd->rcvegrbufs_perchunk_shift;
+	const u32 idx =  etail & ((u32)rcd->rcvegrbufs_perchunk - 1);
 
-	return rcd->rcvegrbuf[chunk] + idx * rcd->dd->rcvegrbufsize;
+	return rcd->rcvegrbuf[chunk] + (idx << rcd->dd->rcvegrbufsize_shift);
 }
 
 /*
diff --git a/drivers/infiniband/hw/qib/qib_iba6120.c b/drivers/infiniband/hw/qib/qib_iba6120.c
index d8ca0a0..781a802 100644
--- a/drivers/infiniband/hw/qib/qib_iba6120.c
+++ b/drivers/infiniband/hw/qib/qib_iba6120.c
@@ -3273,6 +3273,8 @@ static int init_6120_variables(struct qib_devdata *dd)
 	/* we always allocate at least 2048 bytes for eager buffers */
 	ret = ib_mtu_enum_to_int(qib_ibmtu);
 	dd->rcvegrbufsize = ret != -1 ? max(ret, 2048) : QIB_DEFAULT_MTU;
+	BUG_ON(!is_power_of_2(dd->rcvegrbufsize));
+	dd->rcvegrbufsize_shift = ilog2(dd->rcvegrbufsize);
 
 	qib_6120_tidtemplate(dd);
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index e1f9474..3f1d562 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -4085,6 +4085,8 @@ static int qib_init_7220_variables(struct qib_devdata *dd)
 	/* we always allocate at least 2048 bytes for eager buffers */
 	ret = ib_mtu_enum_to_int(qib_ibmtu);
 	dd->rcvegrbufsize = ret != -1 ? max(ret, 2048) : QIB_DEFAULT_MTU;
+	BUG_ON(!is_power_of_2(dd->rcvegrbufsize));
+	dd->rcvegrbufsize_shift = ilog2(dd->rcvegrbufsize);
 
 	qib_7220_tidtemplate(dd);
 
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 5ea9ece..f3f4b55 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -6205,6 +6205,8 @@ static int qib_init_7322_variables(struct qib_devdata *dd)
 
 	/* we always allocate at least 2048 bytes for eager buffers */
 	dd->rcvegrbufsize = max(mtu, 2048);
+	BUG_ON(!is_power_of_2(dd->rcvegrbufsize));
+	dd->rcvegrbufsize_shift = ilog2(dd->rcvegrbufsize);
 
 	qib_7322_tidtemplate(dd);
 
diff --git a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
index 021636d..21ffa7c 100644
--- a/drivers/infiniband/hw/qib/qib_init.c
+++ b/drivers/infiniband/hw/qib/qib_init.c
@@ -183,6 +183,9 @@ struct qib_ctxtdata *qib_create_ctxtdata(struct qib_pportdata *ppd, u32 ctxt)
 		rcd->rcvegrbuf_chunks = (rcd->rcvegrcnt +
 			rcd->rcvegrbufs_perchunk - 1) /
 			rcd->rcvegrbufs_perchunk;
+		BUG_ON(!is_power_of_2(rcd->rcvegrbufs_perchunk));
+		rcd->rcvegrbufs_perchunk_shift =
+			ilog2(rcd->rcvegrbufs_perchunk);
 	}
 	return rcd;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
