From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 17/21] IB/hfi1: Reduce kernel context pio buffer allocation
Date: Tue, 12 Apr 2016 11:30:28 -0700
Message-ID: <20160412183020.27531.92524.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Mark Debbage <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The pio buffers were pooled evenly among all kernel contexts and
user contexts. However, the demand from kernel contexts is much
lower than user contexts. This patch reduces the allocation for
kernel contexts and thus makes more credits available for PSM,
helping performance. This is especially useful on high core-count
systems where large numbers of contexts are used.

A new context type SC_VL15 is added to distinguish the context used
for VL15 from other kernel contexts. The reason is that VL15 needs
to support 2KB sized packet while other kernel contexts need only
support packets up to the size determined by "piothreshold", which
has a default value of 256.

The new allocation method allows triple buffering of largest pio
packets configured for these contexts. This is sufficient to maintain
verbs performance. The largest pio packet size is 2048B for VL15
and "piothreshold" for other kernel contexts. A cap is applied to
"piothreshold" to avoid excessive buffer allocation.

The special case that SDMA is disable is handled differently. In
that case, the original pooling allocation is used to better
support the much higher pio traffic.

Notice that if adaptive pio is disabled (piothreshold==0), the pio
buffer size doesn't matter for non-VL15 kernel send contexts when
SDMA is enabled because pio is not used at all on these contexts
and thus the new allocation is still valid. If SDMA is disabled then
pooling allocation is used as mentioned in previous paragraph.

Adjustment is also made to the calculation of the credit return
threshold for the kernel contexts. Instead of purely based on
the MTU size, a percentage based threshold is also considered and
the smaller one of the two is chosen. This is necessary to ensure
that with the reduced buffer allocation credits are returned in
time to avoid unnecessary stall in the send path.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mark Debbage <mark.debbage-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   27 +++++++++++---------
 drivers/staging/rdma/hfi1/diag.c |    3 +-
 drivers/staging/rdma/hfi1/pio.c  |   52 ++++++++++++++++++++++++++++++--------
 drivers/staging/rdma/hfi1/pio.h  |    4 ++-
 4 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 1984454..96badb4 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -5661,7 +5661,7 @@ static int sc_to_vl(struct hfi1_devdata *dd, int sw_index)
 	sci = &dd->send_contexts[sw_index];
 
 	/* there is no information for user (PSM) and ack contexts */
-	if (sci->type != SC_KERNEL)
+	if ((sci->type != SC_KERNEL) && (sci->type != SC_VL15))
 		return -1;
 
 	sc = sci->sc;
@@ -9627,6 +9627,7 @@ static void set_send_length(struct hfi1_pportdata *ppd)
 			      & SEND_LEN_CHECK1_LEN_VL15_MASK) <<
 		SEND_LEN_CHECK1_LEN_VL15_SHIFT;
 	int i;
+	u32 thres;
 
 	for (i = 0; i < ppd->vls_supported; i++) {
 		if (dd->vld[i].mtu > maxvlmtu)
@@ -9645,16 +9646,17 @@ static void set_send_length(struct hfi1_pportdata *ppd)
 	/* adjust kernel credit return thresholds based on new MTUs */
 	/* all kernel receive contexts have the same hdrqentsize */
 	for (i = 0; i < ppd->vls_supported; i++) {
-		sc_set_cr_threshold(dd->vld[i].sc,
-				    sc_mtu_to_threshold(dd->vld[i].sc,
-							dd->vld[i].mtu,
-							dd->rcd[0]->
-							rcvhdrqentsize));
-	}
-	sc_set_cr_threshold(dd->vld[15].sc,
-			    sc_mtu_to_threshold(dd->vld[15].sc,
-						dd->vld[15].mtu,
+		thres = min(sc_percent_to_threshold(dd->vld[i].sc, 50),
+			    sc_mtu_to_threshold(dd->vld[i].sc,
+						dd->vld[i].mtu,
 						dd->rcd[0]->rcvhdrqentsize));
+		sc_set_cr_threshold(dd->vld[i].sc, thres);
+	}
+	thres = min(sc_percent_to_threshold(dd->vld[15].sc, 50),
+		    sc_mtu_to_threshold(dd->vld[15].sc,
+					dd->vld[15].mtu,
+					dd->rcd[0]->rcvhdrqentsize));
+	sc_set_cr_threshold(dd->vld[15].sc, thres);
 
 	/* Adjust maximum MTU for the port in DC */
 	dcmtu = maxvlmtu == 10240 ? DCC_CFG_PORT_MTU_CAP_10240 :
@@ -12728,12 +12730,13 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 		dd->num_send_contexts = ret;
 		dd_dev_info(
 			dd,
-			"send contexts: chip %d, used %d (kernel %d, ack %d, user %d)\n",
+			"send contexts: chip %d, used %d (kernel %d, ack %d, user %d, vl15 %d)\n",
 			dd->chip_send_contexts,
 			dd->num_send_contexts,
 			dd->sc_sizes[SC_KERNEL].count,
 			dd->sc_sizes[SC_ACK].count,
-			dd->sc_sizes[SC_USER].count);
+			dd->sc_sizes[SC_USER].count,
+			dd->sc_sizes[SC_VL15].count);
 		ret = 0;	/* success */
 	}
 
diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index c5b520b..bb2409a 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -413,7 +413,8 @@ static ssize_t diagpkt_send(struct diag_pkt *dp)
 		goto bail;
 	}
 	/* can only use kernel contexts */
-	if (dd->send_contexts[dp->sw_index].type != SC_KERNEL) {
+	if (dd->send_contexts[dp->sw_index].type != SC_KERNEL &&
+	    dd->send_contexts[dp->sw_index].type != SC_VL15) {
 		ret = -EINVAL;
 		goto bail;
 	}
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index c6849ce..c67b9ad 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -139,23 +139,30 @@ void pio_send_control(struct hfi1_devdata *dd, int op)
 /* Send Context Size (SCS) wildcards */
 #define SCS_POOL_0 -1
 #define SCS_POOL_1 -2
+
 /* Send Context Count (SCC) wildcards */
 #define SCC_PER_VL -1
 #define SCC_PER_CPU  -2
-
 #define SCC_PER_KRCVQ  -3
-#define SCC_ACK_CREDITS  32
+
+/* Send Context Size (SCS) constants */
+#define SCS_ACK_CREDITS  32
+#define SCS_VL15_CREDITS 102	/* 3 pkts of 2048B data + 128B header */
+
+#define PIO_THRESHOLD_CEILING 4096
 
 #define PIO_WAIT_BATCH_SIZE 5
 
 /* default send context sizes */
 static struct sc_config_sizes sc_config_sizes[SC_MAX] = {
 	[SC_KERNEL] = { .size  = SCS_POOL_0,	/* even divide, pool 0 */
-			.count = SCC_PER_VL },/* one per NUMA */
-	[SC_ACK]    = { .size  = SCC_ACK_CREDITS,
+			.count = SCC_PER_VL },	/* one per NUMA */
+	[SC_ACK]    = { .size  = SCS_ACK_CREDITS,
 			.count = SCC_PER_KRCVQ },
 	[SC_USER]   = { .size  = SCS_POOL_0,	/* even divide, pool 0 */
 			.count = SCC_PER_CPU },	/* one per CPU */
+	[SC_VL15]   = { .size  = SCS_VL15_CREDITS,
+			.count = 1 },
 
 };
 
@@ -202,7 +209,8 @@ static int wildcard_to_pool(int wc)
 static const char *sc_type_names[SC_MAX] = {
 	"kernel",
 	"ack",
-	"user"
+	"user",
+	"vl15"
 };
 
 static const char *sc_type_name(int index)
@@ -231,6 +239,22 @@ int init_sc_pools_and_sizes(struct hfi1_devdata *dd)
 	int i;
 
 	/*
+	 * When SDMA is enabled, kernel context pio packet size is capped by
+	 * "piothreshold". Reduce pio buffer allocation for kernel context by
+	 * setting it to a fixed size. The allocation allows 3-deep buffering
+	 * of the largest pio packets plus up to 128 bytes header, sufficient
+	 * to maintain verbs performance.
+	 *
+	 * When SDMA is disabled, keep the default pooling allocation.
+	 */
+	if (HFI1_CAP_IS_KSET(SDMA)) {
+		u16 max_pkt_size = (piothreshold < PIO_THRESHOLD_CEILING) ?
+					 piothreshold : PIO_THRESHOLD_CEILING;
+		sc_config_sizes[SC_KERNEL].size =
+			3 * (max_pkt_size + 128) / PIO_BLOCK_SIZE;
+	}
+
+	/*
 	 * Step 0:
 	 *	- copy the centipercents/absolute sizes from the pool config
 	 *	- sanity check these values
@@ -311,7 +335,7 @@ int init_sc_pools_and_sizes(struct hfi1_devdata *dd)
 		if (i == SC_ACK) {
 			count = dd->n_krcv_queues;
 		} else if (i == SC_KERNEL) {
-			count = (INIT_SC_PER_VL * num_vls) + 1 /* VL15 */;
+			count = INIT_SC_PER_VL * num_vls;
 		} else if (count == SCC_PER_CPU) {
 			count = dd->num_rcv_contexts - dd->n_krcv_queues;
 		} else if (count < 0) {
@@ -596,7 +620,7 @@ u32 sc_mtu_to_threshold(struct send_context *sc, u32 mtu, u32 hdrqentsize)
  * Return value is what to write into the CSR: trigger return when
  * unreturned credits pass this count.
  */
-static u32 sc_percent_to_threshold(struct send_context *sc, u32 percent)
+u32 sc_percent_to_threshold(struct send_context *sc, u32 percent)
 {
 	return (sc->credits * percent) / 100;
 }
@@ -790,7 +814,10 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 	 * For Ack contexts, set a threshold for half the credits.
 	 * For User contexts use the given percentage.  This has been
 	 * sanitized on driver start-up.
-	 * For Kernel contexts, use the default MTU plus a header.
+	 * For Kernel contexts, use the default MTU plus a header
+	 * or half the credits, whichever is smaller. This should
+	 * work for both the 3-deep buffering allocation and the
+	 * pooling allocation.
 	 */
 	if (type == SC_ACK) {
 		thresh = sc_percent_to_threshold(sc, 50);
@@ -798,7 +825,9 @@ struct send_context *sc_alloc(struct hfi1_devdata *dd, int type,
 		thresh = sc_percent_to_threshold(sc,
 						 user_credit_return_threshold);
 	} else { /* kernel */
-		thresh = sc_mtu_to_threshold(sc, hfi1_max_mtu, hdrqentsize);
+		thresh = min(sc_percent_to_threshold(sc, 50),
+			     sc_mtu_to_threshold(sc, hfi1_max_mtu,
+						 hdrqentsize));
 	}
 	reg = thresh << SC(CREDIT_CTRL_THRESHOLD_SHIFT);
 	/* add in early return */
@@ -1531,7 +1560,8 @@ static void sc_piobufavail(struct send_context *sc)
 	unsigned long flags;
 	unsigned i, n = 0;
 
-	if (dd->send_contexts[sc->sw_index].type != SC_KERNEL)
+	if (dd->send_contexts[sc->sw_index].type != SC_KERNEL &&
+	    dd->send_contexts[sc->sw_index].type != SC_VL15)
 		return;
 	list = &sc->piowait;
 	/*
@@ -1900,7 +1930,7 @@ int init_pervl_scs(struct hfi1_devdata *dd)
 	u32 ctxt;
 	struct hfi1_pportdata *ppd = dd->pport;
 
-	dd->vld[15].sc = sc_alloc(dd, SC_KERNEL,
+	dd->vld[15].sc = sc_alloc(dd, SC_VL15,
 				  dd->rcd[0]->rcvhdrqentsize, dd->node);
 	if (!dd->vld[15].sc)
 		goto nomem;
diff --git a/drivers/staging/rdma/hfi1/pio.h b/drivers/staging/rdma/hfi1/pio.h
index 0026976..53a08ed 100644
--- a/drivers/staging/rdma/hfi1/pio.h
+++ b/drivers/staging/rdma/hfi1/pio.h
@@ -51,7 +51,8 @@
 #define SC_KERNEL 0
 #define SC_ACK    1
 #define SC_USER   2
-#define SC_MAX    3
+#define SC_VL15   3
+#define SC_MAX    4
 
 /* invalid send context index */
 #define INVALID_SCI 0xff
@@ -293,6 +294,7 @@ void sc_group_release_update(struct hfi1_devdata *dd, u32 hw_context);
 void sc_add_credit_return_intr(struct send_context *sc);
 void sc_del_credit_return_intr(struct send_context *sc);
 void sc_set_cr_threshold(struct send_context *sc, u32 new_threshold);
+u32 sc_percent_to_threshold(struct send_context *sc, u32 percent);
 u32 sc_mtu_to_threshold(struct send_context *sc, u32 mtu, u32 hdrqentsize);
 void hfi1_sc_wantpiobuf_intr(struct send_context *sc, u32 needint);
 void sc_wait(struct hfi1_devdata *dd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
