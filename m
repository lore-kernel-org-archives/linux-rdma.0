From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 47/54] staging/rdma/hfi1: Add credits for VL0 to VL7 in
 snoop mode
Date: Wed, 03 Feb 2016 14:37:15 -0800
Message-ID: <20160203223712.5923.25590.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a new option to the snoop ioctl which allows credits to be allocated
across all VLs. Previously only VL0 and VL15 had credits allocated.
The new option used in the ioctl HFI1_SNOOP_IOCSET_OPTS allows credits
to be allocated so that VL15 will have at least 8.5KB credits and the
other VLs will have the rest of the credits divided equally across
themselves.

The total number of credits are stored in the upper 16 bits of the
integer passed and the cumulative value should ensure that VL0 has at
least 8.5KB and each VL a minimum of 2KB + 128 bytes

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    3 +-
 drivers/staging/rdma/hfi1/diag.c |   64 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/hfi.h  |    1 +
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index f31cc23..77b07c3 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -10711,8 +10711,7 @@ static void wait_for_vl_status_clear(struct hfi1_devdata *dd, u64 mask,
  * raise = if the new limit is higher than the current value (may be changed
  *	earlier in the algorithm), set the new limit to the new value
  */
-static int set_buffer_control(struct hfi1_devdata *dd,
-			      struct buffer_control *new_bc)
+int set_buffer_control(struct hfi1_devdata *dd, struct buffer_control *new_bc)
 {
 	u64 changing_mask, ld_mask, stat_mask;
 	int change_count;
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index fafb3d7..bfce812 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -80,6 +80,7 @@
 /* Snoop option mask */
 #define SNOOP_DROP_SEND		BIT(0)
 #define SNOOP_USE_METADATA	BIT(1)
+#define SNOOP_SET_VL0TOVL15     BIT(2)
 
 static u8 snoop_flags;
 
@@ -965,6 +966,65 @@ static ssize_t hfi1_snoop_read(struct file *fp, char __user *data,
 	return ret;
 }
 
+/**
+ * hfi1_assign_snoop_link_credits -- Set up credits for VL15 and others
+ * @ppd : ptr to hfi1 port data
+ * @value : options from user space
+ *
+ * Assumes the rest of the CM credit registers are zero from a
+ * previous global or credit reset.
+ * Leave shared count at zero for both global and all vls.
+ * In snoop mode ideally we don't use shared credits
+ * Reserve 8.5k for VL15
+ * If total credits less than 8.5kbytes return error.
+ * Divide the rest of the credits across VL0 to VL7 and if
+ * each of these levels has less than 34 credits (at least 2048 + 128 bytes)
+ * return with an error.
+ * The credit registers will be reset to zero on link negotiation or link up
+ * so this function should be activated from user space only if the port has
+ * gone past link negotiation and link up.
+ *
+ * Return -- 0 if successful else error condition
+ *
+ */
+static long hfi1_assign_snoop_link_credits(struct hfi1_pportdata *ppd,
+					   int value)
+{
+#define  OPA_MIN_PER_VL_CREDITS  34  /* 2048 + 128 bytes */
+	struct buffer_control t;
+	int i;
+	struct hfi1_devdata *dd = ppd->dd;
+	u16  total_credits = (value >> 16) & 0xffff;
+	u16  vl15_credits = dd->vl15_init / 2;
+	u16  per_vl_credits;
+	__be16 be_per_vl_credits;
+
+	if (!(ppd->host_link_state & HLS_UP))
+		goto err_exit;
+	if (total_credits  <  vl15_credits)
+		goto err_exit;
+
+	per_vl_credits = (total_credits - vl15_credits) / TXE_NUM_DATA_VL;
+
+	if (per_vl_credits < OPA_MIN_PER_VL_CREDITS)
+		goto err_exit;
+
+	memset(&t, 0, sizeof(t));
+	be_per_vl_credits = cpu_to_be16(per_vl_credits);
+
+	for (i = 0; i < TXE_NUM_DATA_VL; i++)
+		t.vl[i].dedicated = be_per_vl_credits;
+
+	t.vl[15].dedicated  = cpu_to_be16(vl15_credits);
+	return set_buffer_control(ppd->dd, &t);
+
+err_exit:
+	snoop_dbg("port_state = 0x%x, total_credits = %d, vl15_credits = %d",
+		  ppd->host_link_state, total_credits, vl15_credits);
+
+	return -EINVAL;
+}
+
 static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	struct hfi1_devdata *dd;
@@ -1191,6 +1251,10 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			snoop_flags |= SNOOP_DROP_SEND;
 		if (value & SNOOP_USE_METADATA)
 			snoop_flags |= SNOOP_USE_METADATA;
+		if (value & (SNOOP_SET_VL0TOVL15)) {
+			ppd = &dd->pport[0];  /* first port will do */
+			ret = hfi1_assign_snoop_link_credits(ppd, value);
+		}
 		break;
 	default:
 		return -ENOTTY;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 363e6ef..023c504 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1515,6 +1515,7 @@ int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			   u64 pbc);
 void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
 			   u64 pbc, const void *from, size_t count);
+int set_buffer_control(struct hfi1_devdata *dd, struct buffer_control *bc);
 
 static inline struct hfi1_devdata *dd_from_ppd(struct hfi1_pportdata *ppd)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
