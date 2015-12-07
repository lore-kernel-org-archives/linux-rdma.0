From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 31/37] IB/rdmavt: Add an ibport data structure to rdmavt
Date: Mon, 07 Dec 2015 15:45:15 -0500
Message-ID: <20151207204514.8144.79239.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Converge the ibport data structures of qib and hfi1 into a common ib
port structure. Also provides a place to keep track of these ports
in case rdmavt needs it. Along with this goes an attach and detach
function for drivers to use to notify rdmavt of the ports.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   24 +++++++++++++
 include/rdma/rdma_vt.h            |   66 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 51e0887..297e1d5 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -306,6 +306,19 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	spin_lock_init(&rdi->n_pds_lock);
 	rdi->n_pds_allocated = 0;
 
+	if (rdi->dparms.nports) {
+		rdi->ports = kcalloc(rdi->dparms.nports,
+				     sizeof(struct rvt_ibport **),
+				     GFP_KERNEL);
+		if (!rdi->ports) {
+			rvt_pr_err(rdi, "Could not allocate port mem.\n");
+			ret = -ENOMEM;
+			goto bail_mr;
+		}
+	} else {
+		rvt_pr_warn(rdi, "Driver says it has no ports.\n");
+	}
+
 	/* We are now good to announce we exist */
 	ret =  ib_register_device(&rdi->ibdev, rdi->driver_f.port_callback);
 	if (ret) {
@@ -333,3 +346,14 @@ void rvt_unregister_device(struct rvt_dev_info *rdi)
 	rvt_mr_exit(rdi);
 }
 EXPORT_SYMBOL(rvt_unregister_device);
+
+/*
+ * Keep track of a list of ports. No need to have a detach port.
+ * They persist until the driver goes away.
+ */
+void rvt_attach_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
+		     int portnum)
+{
+	rdi->ports[portnum] = port;
+}
+EXPORT_SYMBOL(rvt_attach_port);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 727439b..4ccae84 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -56,6 +56,8 @@
  * rdmavt layer.
  */
 
+#include <linux/spinlock.h>
+#include <linux/list.h>
 #include "ib_verbs.h"
 
 #define RVT_MULTICAST_LID_BASE 0xC000
@@ -362,6 +364,65 @@ struct rvt_srq {
 
 /* End QP section */
 
+struct rvt_ibport {
+	struct rvt_qp __rcu *qp[2];
+	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
+	struct rb_root mcast_tree;
+	spinlock_t lock;		/* protect changes in this struct */
+
+	/* non-zero when timer is set */
+	unsigned long mkey_lease_timeout;
+	unsigned long trap_timeout;
+	__be64 gid_prefix;      /* in network order */
+	__be64 mkey;
+	u64 tid;
+	u32 port_cap_flags;
+	u32 pma_sample_start;
+	u32 pma_sample_interval;
+	__be16 pma_counter_select[5];
+	u16 pma_tag;
+	u16 mkey_lease_period;
+	u16 sm_lid;
+	u8 sm_sl;
+	u8 mkeyprot;
+	u8 subnet_timeout;
+	u8 vl_high_limit;
+
+	/*
+	 * Driver is expected to keep these up to date. These
+	 * counters are informational only and not required to be
+	 * completely accurate.
+	 */
+	u64 n_rc_resends;
+	u64 n_seq_naks;
+	u64 n_rdma_seq;
+	u64 n_rnr_naks;
+	u64 n_other_naks;
+	u64 n_loop_pkts;
+	u64 n_pkt_drops;
+	u64 n_vl15_dropped;
+	u64 n_rc_timeouts;
+	u64 n_dmawait;
+	u64 n_unaligned;
+	u64 n_rc_dupreq;
+	u64 n_rc_seqnak;
+	u16 pkey_violations;
+	u16 qkey_violations;
+	u16 mkey_violations;
+
+	/* Hot-path per CPU counters to avoid cacheline trading to update */
+	u64 z_rc_acks;
+	u64 z_rc_qacks;
+	u64 z_rc_delayed_comp;
+	u64 __percpu *rc_acks;
+	u64 __percpu *rc_qacks;
+	u64 __percpu *rc_delayed_comp;
+
+	void *priv; /* driver private data */
+
+	/* TODO: Move sm_ah and smi_ah into here as well*/
+};
+
 /*
  * Things that are driver specific, module parameters in hfi1 and qib
  */
@@ -406,6 +467,7 @@ struct rvt_driver_params {
 	 * For instance special module parameters. Goes here.
 	 */
 	unsigned int lkey_table_size;
+	int nports;
 };
 
 /*
@@ -471,6 +533,7 @@ struct rvt_dev_info {
 	spinlock_t n_ahs_lock; /* Protect ah allocated count */
 
 	int flags;
+	struct rvt_ibport **ports;
 };
 
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
@@ -507,9 +570,10 @@ static inline struct rvt_srq *ibsrq_to_rvtsrq(struct ib_srq *ibsrq)
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
+void rvt_attach_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
+		     int portnum);
 int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		struct rvt_sge *isge, struct ib_sge *sge, int acc);
-
 #endif          /* DEF_RDMA_VT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
