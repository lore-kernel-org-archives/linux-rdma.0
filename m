From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/11] IB/core: Change port_attr.lid size from 16 to 32 bits
Date: Tue, 22 Nov 2016 14:38:45 -0500
Message-ID: <1479843532-47496-5-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lid field in port_attr is increased to 32 bits. This enables core
components to use the larger addresses if needed.
The user ABI is unchanged and return 16 bit values when queried.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c           | 8 +++++---
 drivers/infiniband/hw/mlx4/alias_GUID.c        | 2 +-
 drivers/infiniband/hw/mlx4/mad.c               | 2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c        | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          | 2 +-
 include/rdma/ib_verbs.h                        | 2 +-
 7 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 36f5bc1..e135c08 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -515,11 +515,13 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.bad_pkey_cntr   = attr.bad_pkey_cntr;
 	resp.qkey_viol_cntr  = attr.qkey_viol_cntr;
 	resp.pkey_tbl_len    = attr.pkey_tbl_len;
-	resp.lid 	     = attr.lid;
-	if (rdma_cap_opa_ah(ib_dev, cmd.port_num))
+	if (rdma_cap_opa_ah(ib_dev, cmd.port_num)) {
 		resp.sm_lid  = OPA_TO_IB_UCAST_LID(attr.sm_lid);
-	else
+		resp.lid  = OPA_TO_IB_UCAST_LID(attr.lid);
+	} else {
 		resp.sm_lid  = (u16)attr.sm_lid;
+		resp.lid     = (u16)attr.lid;
+	}
 	resp.lmc 	     = attr.lmc;
 	resp.max_vl_num      = attr.max_vl_num;
 	resp.sm_sl 	     = attr.sm_sl;
diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 5e99390..7fa64e6 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -527,7 +527,7 @@ static int set_guid_rec(struct ib_device *ibdev,
 
 	memset(&guid_info_rec, 0, sizeof (struct ib_sa_guidinfo_rec));
 
-	guid_info_rec.lid = cpu_to_be16(attr.lid);
+	guid_info_rec.lid = cpu_to_be16((u16)attr.lid);
 	guid_info_rec.block_num = index;
 
 	memcpy(guid_info_rec.guid_info_list, rec_det->all_recs,
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1672907..404ec4e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -821,7 +821,7 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	    in_mad->mad_hdr.method == IB_MGMT_METHOD_SET &&
 	    in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
 	    !ib_query_port(ibdev, port_num, &pattr))
-		prev_lid = pattr.lid;
+		prev_lid = (u16)pattr.lid;
 
 	err = mlx4_MAD_IFC(to_mdev(ibdev),
 			   (mad_flags & IB_MAD_IGNORE_MKEY ? MLX4_MAD_IFC_IGNORE_MKEY : 0) |
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 9139405..b503d160 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -255,7 +255,7 @@ int mthca_process_mad(struct ib_device *ibdev,
 	    in_mad->mad_hdr.method == IB_MGMT_METHOD_SET &&
 	    in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
 	    !ib_query_port(ibdev, port_num, &pattr))
-		prev_lid = pattr.lid;
+		prev_lid = (u16)pattr.lid;
 
 	err = mthca_MAD_IFC(to_mdev(ibdev),
 			    mad_flags & IB_MAD_IGNORE_MKEY,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index d3394b6..bff73b5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -581,7 +581,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 			  port_attr.state);
 		return;
 	}
-	priv->local_lid = port_attr.lid;
+	priv->local_lid = (u16)port_attr.lid;
 	netif_addr_lock_bh(dev);
 
 	if (!test_bit(IPOIB_FLAG_DEV_ADDR_SET, &priv->flags)) {
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index c6d0c47..4dc66ba 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -515,7 +515,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 		goto err_query_port;
 
 	sport->sm_lid = (u16)port_attr.sm_lid;
-	sport->lid = port_attr.lid;
+	sport->lid = (u16)port_attr.lid;
 
 	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid,
 			   NULL);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 294d3ed..3d80720 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -520,7 +520,7 @@ struct ib_port_attr {
 	u32			bad_pkey_cntr;
 	u32			qkey_viol_cntr;
 	u16			pkey_tbl_len;
-	u16			lid;
+	u32			lid;
 	u32			sm_lid;
 	u8			lmc;
 	u8			max_vl_num;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
