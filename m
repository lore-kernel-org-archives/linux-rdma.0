From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/21] staging/rdma/hfi1: Add blank link after declarations
Date: Sun, 14 Feb 2016 20:20:25 -0800
Message-ID: <20160215042020.351.41442.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add blank line after declarations to fix checkpatch check:
CHECK: Please use a blank line after function/struct/union/enum
declarations

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c     |    2 ++
 drivers/staging/rdma/hfi1/debugfs.c  |    1 +
 drivers/staging/rdma/hfi1/firmware.c |    2 ++
 drivers/staging/rdma/hfi1/hfi.h      |    1 +
 drivers/staging/rdma/hfi1/pcie.c     |    1 +
 drivers/staging/rdma/hfi1/pio.h      |    1 +
 6 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b4c017a..bdc5610 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6995,6 +6995,7 @@ static u16 link_width_to_bits(struct hfi1_devdata *dd, u16 width)
 static const u8 bit_counts[16] = {
 	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4
 };
+
 static inline u8 nibble_to_count(u8 nibble)
 {
 	return bit_counts[nibble & 0xf];
@@ -10410,6 +10411,7 @@ static int vl_arb_match_cache(struct vl_arb_cache *cache,
 {
 	return !memcmp(cache->table, vl, VL_ARB_TABLE_SIZE * sizeof(*vl));
 }
+
 /* end functions related to vl arbitration table caching */
 
 static int set_vl_weights(struct hfi1_pportdata *ppd, u32 target,
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index fa3df1f..e02c527 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -71,6 +71,7 @@ static const struct seq_operations _##name##_seq_ops = { \
 	.stop  = _##name##_seq_stop, \
 	.show  = _##name##_seq_show \
 }
+
 #define DEBUGFS_SEQ_FILE_OPEN(name) \
 static int _##name##_open(struct inode *inode, struct file *s) \
 { \
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 1af5e34..16c9dc7 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -113,6 +113,7 @@ struct css_header {
 	u32 exponent_size;	/* in DWORDs */
 	u32 reserved[22];
 };
+
 /* expected field values */
 #define CSS_MODULE_TYPE	   0x00000006
 #define CSS_HEADER_LEN	   0x000000a1
@@ -172,6 +173,7 @@ enum fw_state {
 	FW_FINAL,
 	FW_ERR
 };
+
 static enum fw_state fw_state = FW_EMPTY;
 static int fw_err;
 static struct firmware_details fw_8051;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index de82f8e..805535e 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1495,6 +1495,7 @@ static inline int valid_ib_mtu(unsigned int mtu)
 		mtu == 1024 || mtu == 2048 ||
 		mtu == 4096;
 }
+
 static inline int valid_opa_max_mtu(unsigned int mtu)
 {
 	return mtu >= 2048 &&
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 725e282..b169166 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -529,6 +529,7 @@ static void tune_pcie_caps(struct hfi1_devdata *dd)
 		pcie_set_readrq(dd->pcidev, ep_mrrs);
 	}
 }
+
 /* End of PCIe capability tuning */
 
 /*
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index 8d0cf1b..09a5eeb 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -105,6 +105,7 @@ struct send_context {
 	struct hfi1_devdata *dd;		/* device */
 	void __iomem *base_addr;	/* start of PIO memory */
 	union pio_shadow_ring *sr;	/* shadow ring */
+
 	volatile __le64 *hw_free;	/* HW free counter */
 	struct work_struct halt_work;	/* halted context work queue entry */
 	unsigned long flags;		/* flags */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
