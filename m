From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] IB/mad: Remove improper use of BUG_ON
Date: Wed, 24 Jun 2015 21:50:04 -0400
Message-ID: <1435197004-32495-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit 97f229a8515f932e5adc6cdfa18cc1440235b9fd
IB/mad: Add support for additional MAD info to/from drivers

added BUG_ON's which were inappropriate for a condition which should never
happen.  Change these to be WARN_ON_ONCE as a debugging aid.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ehca/ehca_sqp.c    | 5 +++--
 drivers/infiniband/hw/ipath/ipath_mad.c  | 5 +++--
 drivers/infiniband/hw/mlx4/mad.c         | 5 +++--
 drivers/infiniband/hw/mlx5/mad.c         | 5 +++--
 drivers/infiniband/hw/mthca/mthca_mad.c  | 5 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c | 5 +++--
 drivers/infiniband/hw/qib/qib_mad.c      | 5 +++--
 7 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index 12b5bc23832b..376b031c2c7f 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -226,8 +226,9 @@ int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	if (!port_num || port_num > ibdev->phys_port_cnt || !in_wc)
 		return IB_MAD_RESULT_FAILURE;
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index 948188e37f95..ad3a926ab3c5 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -1499,8 +1499,9 @@ int ipath_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 3e2dee46caa2..31c8ee0eadd0 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -876,8 +876,9 @@ int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (rdma_port_get_link_layer(ibdev, port_num)) {
 	case IB_LINK_LAYER_INFINIBAND:
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 8e45714fa369..15201e02272b 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -68,8 +68,9 @@ int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 6b2418b74c99..7c3f2fb44ba5 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -209,8 +209,9 @@ int mthca_process_mad(struct ib_device *ibdev,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	/* Forward locally generated traps to the SM */
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP &&
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 4bafa15708d0..29b27675dd70 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -215,8 +215,9 @@ int ocrdma_process_mad(struct ib_device *ibdev,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_PERF_MGMT:
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 05e3242d8442..9625e7c438e5 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2412,8 +2412,9 @@ int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
 	struct ib_mad *out_mad = (struct ib_mad *)out;
 
-	BUG_ON(in_mad_size != sizeof(*in_mad) ||
-	       *out_mad_size != sizeof(*out_mad));
+	if (WARN_ON_ONCE(in_mad_size != sizeof(*in_mad) ||
+			 *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
