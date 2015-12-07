From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 36/37] IB/rdmavt: Add pkey support
Date: Mon, 07 Dec 2015 15:45:37 -0500
Message-ID: <20151207204536.8144.51093.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add pkey table in rdi per port data structure. Also bring in related pkey
functions. Drivers will still be responsible for allocating and
maintaining the pkey table. However they need to tell rdmavt where to find
the pkey table. We can not move the pkey table up into rdmavt because
drivers need to manipulate this long before registering with it.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   46 ++++++++++++++++++++++++-------------
 include/rdma/rdma_vt.h            |   38 +++++++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index ae0a1fe..d541b05 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -160,6 +160,17 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	 * lock, if a stale value is read and sent to the user so be it there is
 	 * no way to protect against that anyway.
 	 */
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	int port_index;
+
+	if (index >= rvt_get_npkeys(rdi))
+		return -EINVAL;
+
+	port_index = port - 1; /* IB ports start at 1 our array at 0 */
+	if ((port_index < 0) || (port_index >= rdi->dparms.nports))
+		return -EINVAL;
+
+	*pkey = rvt_get_pkey(rdi, port_index, index);
 	return 0;
 }
 
@@ -233,19 +244,6 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 		return -EINVAL;
 	}
 
-	if (!rdi->dparms.nports) {
-		rvt_pr_err(rdi, "Driver says it has no ports.\n");
-		return -EINVAL;
-	}
-
-	rdi->ports = kcalloc(rdi->dparms.nports,
-			     sizeof(struct rvt_ibport **),
-			     GFP_KERNEL);
-	if (!rdi->ports) {
-		rvt_pr_err(rdi, "Could not allocate port mem.\n");
-		return -ENOMEM;
-	}
-
 	/* Once we get past here we can use the rvt_pr macros */
 	rvt_mmap_init(rdi);
 
@@ -360,9 +358,25 @@ EXPORT_SYMBOL(rvt_unregister_device);
  * Keep track of a list of ports. No need to have a detach port.
  * They persist until the driver goes away.
  */
-void rvt_attach_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
-		     int portnum)
+int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
+		  int portnum, u16 *pkey_table)
 {
+	if (!rdi->dparms.nports) {
+		rvt_pr_err(rdi, "Driver says it has no ports.\n");
+		return -EINVAL;
+	}
+
+	rdi->ports = kcalloc(rdi->dparms.nports,
+			     sizeof(struct rvt_ibport **),
+			     GFP_KERNEL);
+	if (!rdi->ports) {
+		rvt_pr_err(rdi, "Could not allocate port mem.\n");
+		return -ENOMEM;
+	}
+
 	rdi->ports[portnum] = port;
+	rdi->ports[portnum]->pkey_table = pkey_table;
+
+	return 0;
 }
-EXPORT_SYMBOL(rvt_attach_port);
+EXPORT_SYMBOL(rvt_init_port);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 5681a54..afcc819 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -72,6 +72,8 @@
 #define RVT_FLAG_QP_INIT_DRIVER BIT(2)
 #define RVT_FLAG_CQ_INIT_DRIVER BIT(3)
 
+#define RVT_MAX_PKEY_VALUES 16
+
 struct rvt_ibport {
 	struct rvt_qp __rcu *qp[2];
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
@@ -128,6 +130,14 @@ struct rvt_ibport {
 
 	void *priv; /* driver private data */
 
+	/*
+	 * The pkey table is allocated and maintained by the driver. Drivers
+	 * need to have access to this before registering with rdmav. However
+	 * rdmavt will need access to it so drivers need to proviee this during
+	 * the attach port API call.
+	 */
+	u16 *pkey_table;
+
 	/* TODO: Move sm_ah and smi_ah into here as well*/
 };
 
@@ -181,6 +191,7 @@ struct rvt_driver_params {
 	int qpn_res_start;
 	int qpn_res_end;
 	int nports;
+	int npkeys;
 	u8 qos_shift;
 };
 
@@ -244,8 +255,6 @@ struct rvt_dev_info {
 	struct rvt_mregion __rcu *dma_mr;
 	struct rvt_lkey_table lk_table;
 
-	/* PKey Table goes here */
-
 	/* Driver specific helper functions */
 	struct rvt_driver_provided driver_f;
 
@@ -288,11 +297,32 @@ static inline struct rvt_srq *ibsrq_to_rvtsrq(struct ib_srq *ibsrq)
 	return container_of(ibsrq, struct rvt_srq, ibsrq);
 }
 
+static inline unsigned rvt_get_npkeys(struct rvt_dev_info *rdi)
+{
+	/*
+	 * All ports have same number of pkeys.
+	 */
+	return rdi->dparms.npkeys;
+}
+
+/*
+ * Return the indexed PKEY from the port PKEY table.
+ */
+static inline u16 rvt_get_pkey(struct rvt_dev_info *rdi,
+			       int port_index,
+			       unsigned index)
+{
+	if (index >= rvt_get_npkeys(rdi))
+		return 0;
+	else
+		return rdi->ports[port_index]->pkey_table[index];
+}
+
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
-void rvt_attach_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
-		     int portnum);
+int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
+		  int portnum, u16 *pkey_table);
 int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
