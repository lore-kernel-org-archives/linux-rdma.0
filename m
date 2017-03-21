From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 03/20] IB/hfi1: Cache registers during state change
Date: Mon, 20 Mar 2017 17:24:51 -0700
Message-ID: <20170321002450.28538.67346.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When the LCB is going offline, inopportune port queries can cause
benign error messages to be logged.  To deal with this, cache the
registers just before setting the LCB to offline, allowing queries to
return without eliciting the error.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   58 +++++++++++++++++++++++++++++++++++--
 1 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 44322c6..8b8840a 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8345,6 +8345,52 @@ static int read_lcb_via_8051(struct hfi1_devdata *dd, u32 addr, u64 *data)
 }
 
 /*
+ * Provide a cache for some of the LCB registers in case the LCB is
+ * unavailable.
+ * (The LCB is unavailable in certain link states, for example.)
+ */
+struct lcb_datum {
+	u32 off;
+	u64 val;
+};
+
+static struct lcb_datum lcb_cache[] = {
+	{ DC_LCB_ERR_INFO_RX_REPLAY_CNT, 0},
+	{ DC_LCB_ERR_INFO_SEQ_CRC_CNT, 0 },
+	{ DC_LCB_ERR_INFO_REINIT_FROM_PEER_CNT, 0 },
+};
+
+static void update_lcb_cache(struct hfi1_devdata *dd)
+{
+	int i;
+	int ret;
+	u64 val;
+
+	for (i = 0; i < ARRAY_SIZE(lcb_cache); i++) {
+		ret = read_lcb_csr(dd, lcb_cache[i].off, &val);
+
+		/* Update if we get good data */
+		if (likely(ret != -EBUSY))
+			lcb_cache[i].val = val;
+	}
+}
+
+static int read_lcb_cache(u32 off, u64 *val)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lcb_cache); i++) {
+		if (lcb_cache[i].off == off) {
+			*val = lcb_cache[i].val;
+			return 0;
+		}
+	}
+
+	pr_warn("%s bad offset 0x%x\n", __func__, off);
+	return -1;
+}
+
+/*
  * Read an LCB CSR.  Access may not be in host control, so check.
  * Return 0 on success, -EBUSY on failure.
  */
@@ -8355,9 +8401,13 @@ int read_lcb_csr(struct hfi1_devdata *dd, u32 addr, u64 *data)
 	/* if up, go through the 8051 for the value */
 	if (ppd->host_link_state & HLS_UP)
 		return read_lcb_via_8051(dd, addr, data);
-	/* if going up or down, no access */
-	if (ppd->host_link_state & (HLS_GOING_UP | HLS_GOING_OFFLINE))
-		return -EBUSY;
+	/* if going up or down, check the cache, otherwise, no access */
+	if (ppd->host_link_state & (HLS_GOING_UP | HLS_GOING_OFFLINE)) {
+		if (read_lcb_cache(addr, data))
+			return -EBUSY;
+		return 0;
+	}
+
 	/* otherwise, host has access */
 	*data = read_csr(dd, addr);
 	return 0;
@@ -10145,6 +10195,8 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 	int do_transition;
 	int do_wait;
 
+	update_lcb_cache(dd);
+
 	previous_state = ppd->host_link_state;
 	ppd->host_link_state = HLS_GOING_OFFLINE;
 	pstate = read_physical_state(dd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
