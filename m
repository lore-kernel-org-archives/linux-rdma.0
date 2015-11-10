From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH 2/2] staging/rdma/hfi1: add ACK coalescing logic
Date: Tue, 10 Nov 2015 09:14:01 -0500
Message-ID: <20151110141401.30166.89741.stgit@phlsvslse11.ph.intel.com>
References: <20151110141355.30166.93359.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151110141355.30166.93359.stgit@phlsvslse11.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Implement ACK coalesing logic using a 8 bit counter.

The algorithm is send pio ack when:
- fecn present
- this is the first packet in an interrupt session
- counter is >= HFI1_PSN_CREDIT

Otherwise the ack is defered.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/staging/rdma/hfi1/qp.c    |    1 +
 drivers/staging/rdma/hfi1/rc.c    |   29 +++++++++++++++++++++++++++--
 drivers/staging/rdma/hfi1/verbs.h |    7 ++++---
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index df1fa56..8f867ba 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -378,6 +378,7 @@ static void reset_qp(struct hfi1_qp *qp, enum ib_qp_type type)
 	}
 	qp->s_ack_state = IB_OPCODE_RC_ACKNOWLEDGE;
 	qp->r_nak_state = 0;
+	qp->r_adefered = 0;
 	qp->r_aflags = 0;
 	qp->r_flags = 0;
 	qp->s_head = 0;
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 6fe0104..0193497 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1618,6 +1618,17 @@ static inline void rc_defered_ack(struct hfi1_ctxtdata *rcd,
 	}
 }
 
+static inline void rc_cancel_ack(struct hfi1_qp *qp)
+{
+	qp->r_adefered = 0;
+	if (list_empty(&qp->rspwait))
+		return;
+	list_del_init(&qp->rspwait);
+	qp->r_flags &= ~HFI1_R_RSP_DEFERED_ACK;
+	if (atomic_dec_and_test(&qp->refcount))
+		wake_up(&qp->wait);
+}
+
 /**
  * rc_rcv_error - process an incoming duplicate or error RC packet
  * @ohdr: the other headers for this packet
@@ -2335,8 +2346,22 @@ send_last:
 	qp->r_ack_psn = psn;
 	qp->r_nak_state = 0;
 	/* Send an ACK if requested or required. */
-	if (psn & (1 << 31))
-		goto send_ack;
+	if (psn & IB_BTH_REQ_ACK) {
+		if (packet->numpkt == 0) {
+			rc_cancel_ack(qp);
+			goto send_ack;
+		}
+		if (qp->r_adefered >= HFI1_PSN_CREDIT) {
+			rc_cancel_ack(qp);
+			goto send_ack;
+		}
+		if (unlikely(is_fecn)) {
+			rc_cancel_ack(qp);
+			goto send_ack;
+		}
+		qp->r_adefered++;
+		rc_defered_ack(rcd, qp);
+	}
 	return;
 
 rnr_nak:
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index c5e6f47..6d2012b 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -120,9 +120,9 @@ struct hfi1_packet;
 
 #define HFI1_VENDOR_IPG		cpu_to_be16(0xFFA0)
 
-#define IB_BTH_REQ_ACK		(1 << 31)
-#define IB_BTH_SOLICITED	(1 << 23)
-#define IB_BTH_MIG_REQ		(1 << 22)
+#define IB_BTH_REQ_ACK		BIT(31)
+#define IB_BTH_SOLICITED	BIT(23)
+#define IB_BTH_MIG_REQ		BIT(22)
 
 #define IB_GRH_VERSION		6
 #define IB_GRH_VERSION_MASK	0xF
@@ -484,6 +484,7 @@ struct hfi1_qp {
 	u32 r_psn;              /* expected rcv packet sequence number */
 	u32 r_msn;              /* message sequence number */
 
+	u8 r_adefered;         /* number of acks defered */
 	u8 r_state;             /* opcode of last packet received */
 	u8 r_flags;
 	u8 r_head_ack_queue;    /* index into s_ack_queue[] */
