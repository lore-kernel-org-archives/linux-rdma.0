From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/54] staging/rdma/hfi1: Fix QSFP memory read/write across
 128 byte boundary
Date: Wed, 03 Feb 2016 14:31:05 -0800
Message-ID: <20160203223102.5923.24152.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The QSFP memory cache reads both lower and upper page 0H in one shot,
which leads to the address counter wrapping around to the beginning of
lower page 00H at byte 128, as defined by SFF-8636.
This patch fixes this by modifying the underlying QSFP read and writes
to avoid this wrap around.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qsfp.c |   44 +++++++++++++++++++++++++-------------
 drivers/staging/rdma/hfi1/qsfp.h |   28 +++++++++++++++++-------
 2 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 6e9c56f..0d2ec97 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -186,6 +186,10 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	return ret;
 }
 
+/*
+ * Write page n, offset m of QSFP memory as defined by SFF 8636
+ * in the cache by writing @addr = ((256 * n) + m)
+ */
 int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	       int len)
 {
@@ -217,15 +221,15 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 			break;
 		}
 
-		/* truncate write to end of page if crossing page boundary */
 		offset = addr % QSFP_PAGESIZE;
 		nwrite = len - count;
-		if ((offset + nwrite) > QSFP_PAGESIZE)
-			nwrite = QSFP_PAGESIZE - offset;
+		/* truncate write to boundary if crossing boundary */
+		if (((addr % QSFP_RW_BOUNDARY) + nwrite) > QSFP_RW_BOUNDARY)
+			nwrite = QSFP_RW_BOUNDARY - (addr % QSFP_RW_BOUNDARY);
 
 		ret = __i2c_write(ppd, target, QSFP_DEV, offset, bp + count,
 					nwrite);
-		if (ret <= 0)	/* stop on error or nothing read */
+		if (ret <= 0)	/* stop on error or nothing written */
 			break;
 
 		count += ret;
@@ -239,6 +243,10 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	return count;
 }
 
+/*
+ * Access page n, offset m of QSFP memory as defined by SFF 8636
+ * in the cache by reading @addr = ((256 * n) + m)
+ */
 int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	      int len)
 {
@@ -269,11 +277,11 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 			break;
 		}
 
-		/* truncate read to end of page if crossing page boundary */
 		offset = addr % QSFP_PAGESIZE;
 		nread = len - count;
-		if ((offset + nread) > QSFP_PAGESIZE)
-			nread = QSFP_PAGESIZE - offset;
+		/* truncate read to boundary if crossing boundary */
+		if (((addr % QSFP_RW_BOUNDARY) + nread) > QSFP_RW_BOUNDARY)
+			nread = QSFP_RW_BOUNDARY - (addr % QSFP_RW_BOUNDARY);
 
 		ret = __i2c_read(ppd, target, QSFP_DEV, offset, bp + count,
 					nread);
@@ -295,6 +303,11 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
  * This function caches the QSFP memory range in 128 byte chunks.
  * As an example, the next byte after address 255 is byte 128 from
  * upper page 01H (if existing) rather than byte 0 from lower page 00H.
+ * Access page n, offset m of QSFP memory as defined by SFF 8636
+ * in the cache by reading byte ((128 * n) + m)
+ * The calls to qsfp_{read,write} in this function correctly handle the
+ * address map difference between this mapping and the mapping implemented
+ * by those functions
  */
 int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 {
@@ -305,23 +318,24 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 
 	/* ensure sane contents on invalid reads, for cable swaps */
 	memset(cache, 0, (QSFP_MAX_NUM_PAGES*128));
-	dd_dev_info(ppd->dd, "%s: called\n", __func__);
+	spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
+	ppd->qsfp_info.cache_valid = 0;
+	spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
+
+	dd_dev_info(ppd->dd, "%s called\n", __func__);
 	if (!qsfp_mod_present(ppd)) {
 		ret = -ENODEV;
 		goto bail;
 	}
 
-	ret = qsfp_read(ppd, target, 0, cache, 256);
-	if (ret != 256) {
+	ret = qsfp_read(ppd, target, 0, cache, QSFP_PAGESIZE);
+	if (ret != QSFP_PAGESIZE) {
 		dd_dev_info(ppd->dd,
-			"%s: Read of pages 00H failed, expected 256, got %d\n",
-			__func__, ret);
+			    "%s: Page 0 read failed, expected %d, got %d\n",
+			    __func__, QSFP_PAGESIZE, ret);
 		goto bail;
 	}
 
-	if (cache[0] != 0x0C && cache[0] != 0x0D)
-		goto bail;
-
 	/* Is paging enabled? */
 	if (!(cache[2] & 4)) {
 
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index 16aebdc..3422250 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -67,15 +67,16 @@
 
 /* QSFP is paged at 256 bytes */
 #define QSFP_PAGESIZE 256
+/* Reads/writes cannot cross 128 byte boundaries */
+#define QSFP_RW_BOUNDARY 128
 
 /* Defined fields that Intel requires of qualified cables */
 /* Byte 0 is Identifier, not checked */
 /* Byte 1 is reserved "status MSB" */
-/* Byte 2 is "status LSB" We only care that D2 "Flat Mem" is set. */
-/*
- * Rest of first 128 not used, although 127 is reserved for page select
- * if module is not "Flat memory".
- */
+#define QSFP_TX_CTRL_BYTE_OFFS 86
+#define QSFP_PWR_CTRL_BYTE_OFFS 93
+#define QSFP_CDR_CTRL_BYTE_OFFS 98
+
 #define QSFP_PAGE_SELECT_BYTE_OFFS 127
 /* Byte 128 is Identifier: must be 0x0c for QSFP, or 0x0d for QSFP+ */
 #define QSFP_MOD_ID_OFFS 128
@@ -87,7 +88,8 @@
 /* Byte 130 is Connector type. Not Intel req'd */
 /* Bytes 131..138 are Transceiver types, bit maps for various tech, none IB */
 /* Byte 139 is encoding. code 0x01 is 8b10b. Not Intel req'd */
-/* byte 140 is nominal bit-rate, in units of 100Mbits/sec Not Intel req'd */
+/* byte 140 is nominal bit-rate, in units of 100Mbits/sec */
+#define QSFP_NOM_BIT_RATE_100_OFFS 140
 /* Byte 141 is Extended Rate Select. Not Intel req'd */
 /* Bytes 142..145 are lengths for various fiber types. Not Intel req'd */
 /* Byte 146 is length for Copper. Units of 1 meter */
@@ -135,11 +137,18 @@ extern const char *const hfi1_qsfp_devtech[16];
  */
 #define QSFP_ATTEN_OFFS 186
 #define QSFP_ATTEN_LEN 2
-/* Bytes 188,189 are Wavelength tolerance, not Intel req'd */
+/*
+ * Bytes 188,189 are Wavelength tolerance, if optical
+ * If copper, they are attenuation in dB:
+ * Byte 188 is at 12.5 Gb/s, Byte 189 at 25 Gb/s
+ */
+#define QSFP_CU_ATTEN_7G_OFFS 188
+#define QSFP_CU_ATTEN_12G_OFFS 189
 /* Byte 190 is Max Case Temp. Not Intel req'd */
 /* Byte 191 is LSB of sum of bytes 128..190. Not Intel req'd */
 #define QSFP_CC_OFFS 191
-/* Bytes 192..195 are Options implemented in qsfp. Not Intel req'd */
+#define QSFP_EQ_INFO_OFFS 193
+#define QSFP_CDR_INFO_OFFS 194
 /* Bytes 196..211 are Serial Number, String */
 #define QSFP_SN_OFFS 196
 #define QSFP_SN_LEN 16
@@ -150,6 +159,8 @@ extern const char *const hfi1_qsfp_devtech[16];
 #define QSFP_LOT_OFFS 218
 #define QSFP_LOT_LEN 2
 /* Bytes 220, 221 indicate monitoring options, Not Intel req'd */
+/* Byte 222 indicates nominal bitrate in units of 250Mbits/sec */
+#define QSFP_NOM_BIT_RATE_250_OFFS 222
 /* Byte 223 is LSB of sum of bytes 192..222 */
 #define QSFP_CC_EXT_OFFS 223
 
@@ -191,6 +202,7 @@ extern const char *const hfi1_qsfp_devtech[16];
  */
 
 #define QSFP_PWR(pbyte) (((pbyte) >> 6) & 3)
+#define QSFP_HIGH_PWR(pbyte) (((pbyte) & 3) | 4)
 #define QSFP_ATTEN_SDR(attenarray) (attenarray[0])
 #define QSFP_ATTEN_DDR(attenarray) (attenarray[1])
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
