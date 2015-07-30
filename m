From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 34/50] IB/hfi1: add qsfp handling
Date: Thu, 30 Jul 2015 15:20:36 -0400
Message-ID: <20150730192036.25256.98765.stgit@phlsvslse11.ph.intel.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730191631.25256.95511.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Friedley <andrew.friedley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Gregor <john.a.gregor-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kevin Pine <kevin.pine-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kyle Liddell <kyle.liddell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ravi Krishnaswamy <ravi.krishnaswamy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sanath Kumar <sanath.s.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vlad Danushevsky <vladimir.danusevsky-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qsfp.c |  546 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/qsfp.h |  222 +++++++++++++++
 2 files changed, 768 insertions(+)
 create mode 100644 drivers/infiniband/hw/hfi1/qsfp.c
 create mode 100644 drivers/infiniband/hw/hfi1/qsfp.h

diff --git a/drivers/infiniband/hw/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
new file mode 100644
index 0000000..3138936
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/qsfp.c
@@ -0,0 +1,546 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+
+#include "hfi.h"
+#include "twsi.h"
+
+/*
+ * QSFP support for hfi driver, using "Two Wire Serial Interface" driver
+ * in twsi.c
+ */
+#define I2C_MAX_RETRY 4
+
+/*
+ * Unlocked i2c write.  Must hold dd->qsfp_i2c_mutex.
+ */
+static int __i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
+		       int offset, void *bp, int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	int ret, cnt;
+	u8 *buff = bp;
+
+	/* Make sure TWSI bus is in sane state. */
+	ret = hfi1_twsi_reset(dd, target);
+	if (ret) {
+		hfi1_dev_porterr(dd, ppd->port,
+				 "I2C interface Reset for write failed\n");
+		return -EIO;
+	}
+
+	cnt = 0;
+	while (cnt < len) {
+		int wlen = len - cnt;
+
+		ret = hfi1_twsi_blk_wr(dd, target, i2c_addr, offset,
+				       buff + cnt, wlen);
+		if (ret) {
+			/* hfi1_twsi_blk_wr() 1 for error, else 0 */
+			return -EIO;
+		}
+		offset += wlen;
+		cnt += wlen;
+	}
+
+	/* Must wait min 20us between qsfp i2c transactions */
+	udelay(20);
+
+	return cnt;
+}
+
+int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
+	      void *bp, int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	int ret;
+
+	ret = mutex_lock_interruptible(&dd->qsfp_i2c_mutex);
+	if (!ret) {
+		ret = __i2c_write(ppd, target, i2c_addr, offset, bp, len);
+		mutex_unlock(&dd->qsfp_i2c_mutex);
+	}
+
+	return ret;
+}
+
+/*
+ * Unlocked i2c read.  Must hold dd->qsfp_i2c_mutex.
+ */
+static int __i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
+		      int offset, void *bp, int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	int ret, cnt, pass = 0;
+	int stuck = 0;
+	u8 *buff = bp;
+
+	/* Make sure TWSI bus is in sane state. */
+	ret = hfi1_twsi_reset(dd, target);
+	if (ret) {
+		hfi1_dev_porterr(dd, ppd->port,
+				 "I2C interface Reset for read failed\n");
+		ret = -EIO;
+		stuck = 1;
+		goto exit;
+	}
+
+	cnt = 0;
+	while (cnt < len) {
+		int rlen = len - cnt;
+
+		ret = hfi1_twsi_blk_rd(dd, target, i2c_addr, offset,
+				       buff + cnt, rlen);
+		/* Some QSFP's fail first try. Retry as experiment */
+		if (ret && cnt == 0 && ++pass < I2C_MAX_RETRY)
+			continue;
+		if (ret) {
+			/* hfi1_twsi_blk_rd() 1 for error, else 0 */
+			ret = -EIO;
+			goto exit;
+		}
+		offset += rlen;
+		cnt += rlen;
+	}
+
+	ret = cnt;
+
+exit:
+	if (stuck)
+		dd_dev_err(dd, "I2C interface bus stuck non-idle\n");
+
+	if (pass >= I2C_MAX_RETRY && ret)
+		hfi1_dev_porterr(dd, ppd->port,
+				 "I2C failed even retrying\n");
+	else if (pass)
+		hfi1_dev_porterr(dd, ppd->port, "I2C retries: %d\n", pass);
+
+	/* Must wait min 20us between qsfp i2c transactions */
+	udelay(20);
+
+	return ret;
+}
+
+int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
+	     void *bp, int len)
+{
+	struct hfi1_devdata *dd = ppd->dd;
+	int ret;
+
+	ret = mutex_lock_interruptible(&dd->qsfp_i2c_mutex);
+	if (!ret) {
+		ret = __i2c_read(ppd, target, i2c_addr, offset, bp, len);
+		mutex_unlock(&dd->qsfp_i2c_mutex);
+	}
+
+	return ret;
+}
+
+int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+	       int len)
+{
+	int count = 0;
+	int offset;
+	int nwrite;
+	int ret;
+	u8 page;
+
+	ret = mutex_lock_interruptible(&ppd->dd->qsfp_i2c_mutex);
+	if (ret)
+		return ret;
+
+	while (count < len) {
+		/*
+		 * Set the qsfp page based on a zero-based addresss
+		 * and a page size of QSFP_PAGESIZE bytes.
+		 */
+		page = (u8)(addr / QSFP_PAGESIZE);
+
+		ret = __i2c_write(ppd, target, QSFP_DEV,
+					QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
+		if (ret != 1) {
+			hfi1_dev_porterr(
+			ppd->dd,
+			ppd->port,
+			"can't write QSFP_PAGE_SELECT_BYTE: %d\n", ret);
+			ret = -EIO;
+			break;
+		}
+
+		/* truncate write to end of page if crossing page boundary */
+		offset = addr % QSFP_PAGESIZE;
+		nwrite = len - count;
+		if ((offset + nwrite) > QSFP_PAGESIZE)
+			nwrite = QSFP_PAGESIZE - offset;
+
+		ret = __i2c_write(ppd, target, QSFP_DEV, offset, bp + count,
+					nwrite);
+		if (ret <= 0)	/* stop on error or nothing read */
+			break;
+
+		count += ret;
+		addr += ret;
+	}
+
+	mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
+
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+	      int len)
+{
+	int count = 0;
+	int offset;
+	int nread;
+	int ret;
+	u8 page;
+
+	ret = mutex_lock_interruptible(&ppd->dd->qsfp_i2c_mutex);
+	if (ret)
+		return ret;
+
+	while (count < len) {
+		/*
+		 * Set the qsfp page based on a zero-based address
+		 * and a page size of QSFP_PAGESIZE bytes.
+		 */
+		page = (u8)(addr / QSFP_PAGESIZE);
+		ret = __i2c_write(ppd, target, QSFP_DEV,
+					QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
+		if (ret != 1) {
+			hfi1_dev_porterr(
+			ppd->dd,
+			ppd->port,
+			"can't write QSFP_PAGE_SELECT_BYTE: %d\n", ret);
+			ret = -EIO;
+			break;
+		}
+
+		/* truncate read to end of page if crossing page boundary */
+		offset = addr % QSFP_PAGESIZE;
+		nread = len - count;
+		if ((offset + nread) > QSFP_PAGESIZE)
+			nread = QSFP_PAGESIZE - offset;
+
+		ret = __i2c_read(ppd, target, QSFP_DEV, offset, bp + count,
+					nread);
+		if (ret <= 0)	/* stop on error or nothing read */
+			break;
+
+		count += ret;
+		addr += ret;
+	}
+
+	mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
+
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+/*
+ * This function caches the QSFP memory range in 128 byte chunks.
+ * As an example, the next byte after address 255 is byte 128 from
+ * upper page 01H (if existing) rather than byte 0 from lower page 00H.
+ */
+int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
+{
+	u32 target = ppd->dd->hfi1_id;
+	int ret;
+	unsigned long flags;
+	u8 *cache = &cp->cache[0];
+
+	/* ensure sane contents on invalid reads, for cable swaps */
+	memset(cache, 0, (QSFP_MAX_NUM_PAGES*128));
+	dd_dev_info(ppd->dd, "%s: called\n", __func__);
+	if (!qsfp_mod_present(ppd)) {
+		ret = -ENODEV;
+		goto bail;
+	}
+
+	ret = qsfp_read(ppd, target, 0, cache, 256);
+	if (ret != 256) {
+		dd_dev_info(ppd->dd,
+			"%s: Read of pages 00H failed, expected 256, got %d\n",
+			__func__, ret);
+		goto bail;
+	}
+
+	if (cache[0] != 0x0C && cache[0] != 0x0D)
+		goto bail;
+
+	/* Is paging enabled? */
+	if (!(cache[2] & 4)) {
+
+		/* Paging enabled, page 03 required */
+		if ((cache[195] & 0xC0) == 0xC0) {
+			/* all */
+			ret = qsfp_read(ppd, target, 384, cache + 256, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+			ret = qsfp_read(ppd, target, 640, cache + 384, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+		} else if ((cache[195] & 0x80) == 0x80) {
+			/* only page 2 and 3 */
+			ret = qsfp_read(ppd, target, 640, cache + 384, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+		} else if ((cache[195] & 0x40) == 0x40) {
+			/* only page 1 and 3 */
+			ret = qsfp_read(ppd, target, 384, cache + 256, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+		} else {
+			/* only page 3 */
+			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
+			if (ret <= 0 || ret != 128) {
+				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				goto bail;
+			}
+		}
+	}
+
+	spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
+	ppd->qsfp_info.cache_valid = 1;
+	ppd->qsfp_info.cache_refresh_required = 0;
+	spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
+
+	return 0;
+
+bail:
+	memset(cache, 0, (QSFP_MAX_NUM_PAGES*128));
+	return ret;
+}
+
+const char * const hfi1_qsfp_devtech[16] = {
+	"850nm VCSEL", "1310nm VCSEL", "1550nm VCSEL", "1310nm FP",
+	"1310nm DFB", "1550nm DFB", "1310nm EML", "1550nm EML",
+	"Cu Misc", "1490nm DFB", "Cu NoEq", "Cu Eq",
+	"Undef", "Cu Active BothEq", "Cu FarEq", "Cu NearEq"
+};
+
+#define QSFP_DUMP_CHUNK 16 /* Holds longest string */
+#define QSFP_DEFAULT_HDR_CNT 224
+
+static const char *pwr_codes = "1.5W2.0W2.5W3.5W";
+
+int qsfp_mod_present(struct hfi1_pportdata *ppd)
+{
+	if (HFI1_CAP_IS_KSET(QSFP_ENABLED)) {
+		struct hfi1_devdata *dd = ppd->dd;
+		u64 reg;
+
+		reg = read_csr(dd,
+			dd->hfi1_id ? ASIC_QSFP2_IN : ASIC_QSFP1_IN);
+		return !(reg & QSFP_HFI0_MODPRST_N);
+	}
+	/* always return cable present */
+	return 1;
+}
+
+/*
+ * This function maps QSFP memory addresses in 128 byte chunks in the following
+ * fashion per the CableInfo SMA query definition in the IBA 1.3 spec/OPA Gen 1
+ * spec
+ * For addr 000-127, lower page 00h
+ * For addr 128-255, upper page 00h
+ * For addr 256-383, upper page 01h
+ * For addr 384-511, upper page 02h
+ * For addr 512-639, upper page 03h
+ *
+ * For addresses beyond this range, it returns the invalid range of data buffer
+ * set to 0.
+ * For upper pages that are optional, if they are not valid, returns the
+ * particular range of bytes in the data buffer set to 0.
+ */
+int get_cable_info(struct hfi1_devdata *dd, u32 port_num, u32 addr, u32 len,
+		   u8 *data)
+{
+	struct hfi1_pportdata *ppd;
+	u32 excess_len = 0;
+	int ret = 0;
+
+	if (port_num > dd->num_pports || port_num < 1) {
+		dd_dev_info(dd, "%s: Invalid port number %d\n",
+				__func__, port_num);
+		ret = -EINVAL;
+		goto set_zeroes;
+	}
+
+	ppd = dd->pport + (port_num - 1);
+	if (!qsfp_mod_present(ppd)) {
+		ret = -ENODEV;
+		goto set_zeroes;
+	}
+
+	if (!ppd->qsfp_info.cache_valid) {
+		ret = -EINVAL;
+		goto set_zeroes;
+	}
+
+	if (addr >= (QSFP_MAX_NUM_PAGES * 128)) {
+		ret = -ERANGE;
+		goto set_zeroes;
+	}
+
+	if ((addr + len) > (QSFP_MAX_NUM_PAGES * 128)) {
+		excess_len = (addr + len) - (QSFP_MAX_NUM_PAGES * 128);
+		memcpy(data, &ppd->qsfp_info.cache[addr], (len - excess_len));
+		data += (len - excess_len);
+		goto set_zeroes;
+	}
+
+	memcpy(data, &ppd->qsfp_info.cache[addr], len);
+	return 0;
+
+set_zeroes:
+	memset(data, 0, excess_len);
+	return ret;
+}
+
+int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
+{
+	u8 *cache = &ppd->qsfp_info.cache[0];
+	u8 bin_buff[QSFP_DUMP_CHUNK];
+	char lenstr[6];
+	int sofar, ret;
+	int bidx = 0;
+	u8 *atten = &cache[QSFP_ATTEN_OFFS];
+	u8 *vendor_oui = &cache[QSFP_VOUI_OFFS];
+
+	sofar = 0;
+	lenstr[0] = ' ';
+	lenstr[1] = '\0';
+
+	if (ppd->qsfp_info.cache_valid) {
+
+		if (QSFP_IS_CU(cache[QSFP_MOD_TECH_OFFS]))
+			sprintf(lenstr, "%dM ", cache[QSFP_MOD_LEN_OFFS]);
+
+		sofar += scnprintf(buf + sofar, len - sofar, "PWR:%.3sW\n",
+				pwr_codes +
+				(QSFP_PWR(cache[QSFP_MOD_PWR_OFFS]) * 4));
+
+		sofar += scnprintf(buf + sofar, len - sofar, "TECH:%s%s\n",
+				lenstr,
+			hfi1_qsfp_devtech[(cache[QSFP_MOD_TECH_OFFS]) >> 4]);
+
+		sofar += scnprintf(buf + sofar, len - sofar, "Vendor:%.*s\n",
+				   QSFP_VEND_LEN, &cache[QSFP_VEND_OFFS]);
+
+		sofar += scnprintf(buf + sofar, len - sofar, "OUI:%06X\n",
+				   QSFP_OUI(vendor_oui));
+
+		sofar += scnprintf(buf + sofar, len - sofar, "Part#:%.*s\n",
+				   QSFP_PN_LEN, &cache[QSFP_PN_OFFS]);
+
+		sofar += scnprintf(buf + sofar, len - sofar, "Rev:%.*s\n",
+				   QSFP_REV_LEN, &cache[QSFP_REV_OFFS]);
+
+		if (QSFP_IS_CU(cache[QSFP_MOD_TECH_OFFS]))
+			sofar += scnprintf(buf + sofar, len - sofar,
+				"Atten:%d, %d\n",
+				QSFP_ATTEN_SDR(atten),
+				QSFP_ATTEN_DDR(atten));
+
+		sofar += scnprintf(buf + sofar, len - sofar, "Serial:%.*s\n",
+				   QSFP_SN_LEN, &cache[QSFP_SN_OFFS]);
+
+		sofar += scnprintf(buf + sofar, len - sofar, "Date:%.*s\n",
+				   QSFP_DATE_LEN, &cache[QSFP_DATE_OFFS]);
+
+		sofar += scnprintf(buf + sofar, len - sofar, "Lot:%.*s\n",
+				   QSFP_LOT_LEN, &cache[QSFP_LOT_OFFS]);
+
+		while (bidx < QSFP_DEFAULT_HDR_CNT) {
+			int iidx;
+
+			memcpy(bin_buff, &cache[bidx], QSFP_DUMP_CHUNK);
+			for (iidx = 0; iidx < QSFP_DUMP_CHUNK; ++iidx) {
+				sofar += scnprintf(buf + sofar, len-sofar,
+					" %02X", bin_buff[iidx]);
+			}
+			sofar += scnprintf(buf + sofar, len - sofar, "\n");
+			bidx += QSFP_DUMP_CHUNK;
+		}
+	}
+	ret = sofar;
+	return ret;
+}
diff --git a/drivers/infiniband/hw/hfi1/qsfp.h b/drivers/infiniband/hw/hfi1/qsfp.h
new file mode 100644
index 0000000..d30c2a6
--- /dev/null
+++ b/drivers/infiniband/hw/hfi1/qsfp.h
@@ -0,0 +1,222 @@
+/*
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  - Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  - Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  - Neither the name of Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+/* QSFP support common definitions, for hfi driver */
+
+#define QSFP_DEV 0xA0
+#define QSFP_PWR_LAG_MSEC 2000
+#define QSFP_MODPRS_LAG_MSEC 20
+/* 128 byte pages, per SFF 8636 rev 2.4 */
+#define QSFP_MAX_NUM_PAGES	5
+
+/*
+ * Below are masks for QSFP pins.  Pins are the same for HFI0 and HFI1.
+ * _N means asserted low
+ */
+#define QSFP_HFI0_I2CCLK    (1 << 0)
+#define QSFP_HFI0_I2CDAT    (1 << 1)
+#define QSFP_HFI0_RESET_N   (1 << 2)
+#define QSFP_HFI0_INT_N	    (1 << 3)
+#define QSFP_HFI0_MODPRST_N (1 << 4)
+
+/* QSFP is paged at 256 bytes */
+#define QSFP_PAGESIZE 256
+
+/* Defined fields that Intel requires of qualified cables */
+/* Byte 0 is Identifier, not checked */
+/* Byte 1 is reserved "status MSB" */
+/* Byte 2 is "status LSB" We only care that D2 "Flat Mem" is set. */
+/*
+ * Rest of first 128 not used, although 127 is reserved for page select
+ * if module is not "Flat memory".
+ */
+#define QSFP_PAGE_SELECT_BYTE_OFFS 127
+/* Byte 128 is Identifier: must be 0x0c for QSFP, or 0x0d for QSFP+ */
+#define QSFP_MOD_ID_OFFS 128
+/*
+ * Byte 129 is "Extended Identifier". We only care about D7,D6: Power class
+ *  0:1.5W, 1:2.0W, 2:2.5W, 3:3.5W
+ */
+#define QSFP_MOD_PWR_OFFS 129
+/* Byte 130 is Connector type. Not Intel req'd */
+/* Bytes 131..138 are Transceiver types, bit maps for various tech, none IB */
+/* Byte 139 is encoding. code 0x01 is 8b10b. Not Intel req'd */
+/* byte 140 is nominal bit-rate, in units of 100Mbits/sec Not Intel req'd */
+/* Byte 141 is Extended Rate Select. Not Intel req'd */
+/* Bytes 142..145 are lengths for various fiber types. Not Intel req'd */
+/* Byte 146 is length for Copper. Units of 1 meter */
+#define QSFP_MOD_LEN_OFFS 146
+/*
+ * Byte 147 is Device technology. D0..3 not Intel req'd
+ * D4..7 select from 15 choices, translated by table:
+ */
+#define QSFP_MOD_TECH_OFFS 147
+extern const char *const hfi1_qsfp_devtech[16];
+/* Active Equalization includes fiber, copper full EQ, and copper near Eq */
+#define QSFP_IS_ACTIVE(tech) ((0xA2FF >> ((tech) >> 4)) & 1)
+/* Active Equalization includes fiber, copper full EQ, and copper far Eq */
+#define QSFP_IS_ACTIVE_FAR(tech) ((0x32FF >> ((tech) >> 4)) & 1)
+/* Attenuation should be valid for copper other than full/near Eq */
+#define QSFP_HAS_ATTEN(tech) ((0x4D00 >> ((tech) >> 4)) & 1)
+/* Length is only valid if technology is "copper" */
+#define QSFP_IS_CU(tech) ((0xED00 >> ((tech) >> 4)) & 1)
+#define QSFP_TECH_1490 9
+
+#define QSFP_OUI(oui) (((unsigned)oui[0] << 16) | ((unsigned)oui[1] << 8) | \
+			oui[2])
+#define QSFP_OUI_AMPHENOL 0x415048
+#define QSFP_OUI_FINISAR  0x009065
+#define QSFP_OUI_GORE     0x002177
+
+/* Bytes 148..163 are Vendor Name, Left-justified Blank-filled */
+#define QSFP_VEND_OFFS 148
+#define QSFP_VEND_LEN 16
+/* Byte 164 is IB Extended transceiver codes Bits D0..3 are SDR,DDR,QDR,EDR */
+#define QSFP_IBXCV_OFFS 164
+/* Bytes 165..167 are Vendor OUI number */
+#define QSFP_VOUI_OFFS 165
+#define QSFP_VOUI_LEN 3
+/* Bytes 168..183 are Vendor Part Number, string */
+#define QSFP_PN_OFFS 168
+#define QSFP_PN_LEN 16
+/* Bytes 184,185 are Vendor Rev. Left Justified, Blank-filled */
+#define QSFP_REV_OFFS 184
+#define QSFP_REV_LEN 2
+/*
+ * Bytes 186,187 are Wavelength, if Optical. Not Intel req'd
+ *  If copper, they are attenuation in dB:
+ * Byte 186 is at 2.5Gb/sec (SDR), Byte 187 at 5.0Gb/sec (DDR)
+ */
+#define QSFP_ATTEN_OFFS 186
+#define QSFP_ATTEN_LEN 2
+/* Bytes 188,189 are Wavelength tolerance, not Intel req'd */
+/* Byte 190 is Max Case Temp. Not Intel req'd */
+/* Byte 191 is LSB of sum of bytes 128..190. Not Intel req'd */
+#define QSFP_CC_OFFS 191
+/* Bytes 192..195 are Options implemented in qsfp. Not Intel req'd */
+/* Bytes 196..211 are Serial Number, String */
+#define QSFP_SN_OFFS 196
+#define QSFP_SN_LEN 16
+/* Bytes 212..219 are date-code YYMMDD (MM==1 for Jan) */
+#define QSFP_DATE_OFFS 212
+#define QSFP_DATE_LEN 6
+/* Bytes 218,219 are optional lot-code, string */
+#define QSFP_LOT_OFFS 218
+#define QSFP_LOT_LEN 2
+/* Bytes 220, 221 indicate monitoring options, Not Intel req'd */
+/* Byte 223 is LSB of sum of bytes 192..222 */
+#define QSFP_CC_EXT_OFFS 223
+
+/*
+ * Interrupt flag masks
+ */
+#define QSFP_DATA_NOT_READY		0x01
+
+#define QSFP_HIGH_TEMP_ALARM		0x80
+#define QSFP_LOW_TEMP_ALARM		0x40
+#define QSFP_HIGH_TEMP_WARNING		0x20
+#define QSFP_LOW_TEMP_WARNING		0x10
+
+#define QSFP_HIGH_VCC_ALARM		0x80
+#define QSFP_LOW_VCC_ALARM		0x40
+#define QSFP_HIGH_VCC_WARNING		0x20
+#define QSFP_LOW_VCC_WARNING		0x10
+
+#define QSFP_HIGH_POWER_ALARM		0x88
+#define QSFP_LOW_POWER_ALARM		0x44
+#define QSFP_HIGH_POWER_WARNING		0x22
+#define QSFP_LOW_POWER_WARNING		0x11
+
+#define QSFP_HIGH_BIAS_ALARM		0x88
+#define QSFP_LOW_BIAS_ALARM		0x44
+#define QSFP_HIGH_BIAS_WARNING		0x22
+#define QSFP_LOW_BIAS_WARNING		0x11
+
+/*
+ * struct qsfp_data encapsulates state of QSFP device for one port.
+ * it will be part of port-specific data if a board supports QSFP.
+ *
+ * Since multiple board-types use QSFP, and their pport_data structs
+ * differ (in the chip-specific section), we need a pointer to its head.
+ *
+ * Avoiding premature optimization, we will have one work_struct per port,
+ * and let the qsfp_lock arbitrate access to common resources.
+ *
+ */
+
+#define QSFP_PWR(pbyte) (((pbyte) >> 6) & 3)
+#define QSFP_ATTEN_SDR(attenarray) (attenarray[0])
+#define QSFP_ATTEN_DDR(attenarray) (attenarray[1])
+
+struct qsfp_data {
+	/* Helps to find our way */
+	struct hfi1_pportdata *ppd;
+	struct work_struct qsfp_work;
+	u8 cache[QSFP_MAX_NUM_PAGES*128];
+	spinlock_t qsfp_lock;
+	u8 check_interrupt_flags;
+	u8 qsfp_interrupt_functional;
+	u8 cache_valid;
+	u8 cache_refresh_required;
+};
+
+int refresh_qsfp_cache(struct hfi1_pportdata *ppd,
+		       struct qsfp_data *cp);
+int qsfp_mod_present(struct hfi1_pportdata *ppd);
+int get_cable_info(struct hfi1_devdata *dd, u32 port_num, u32 addr,
+		   u32 len, u8 *data);
+
+int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
+	      int offset, void *bp, int len);
+int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
+	     int offset, void *bp, int len);
+int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+	       int len);
+int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
+	      int len);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
