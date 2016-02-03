From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] IB/rdmavt: Add support for query_port,
 modify_port and get_port_immutable
Date: Wed, 03 Feb 2016 14:15:20 -0800
Message-ID: <20160203221516.1765.74675.stgit@scvm10.sc.intel.com>
References: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221136.1765.8947.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rvt_query_port calls into the driver through a call back function
query_port_state to populate the rest of ib_port_attr elements.
rvt_modify_port calls into the driver if needed through a call back
function shut_down_port()

Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   77 ++++++++++++++++++++++++++-----------
 include/rdma/rdma_vt.h            |    6 +++
 2 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index e017117..2ccf610 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -128,14 +128,27 @@ static int rvt_modify_device(struct ib_device *device,
 static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
 			  struct ib_port_attr *props)
 {
-	if (ibport_num_to_idx(ibdev, port_num) < 0)
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	struct rvt_ibport *rvp;
+	int port_index = ibport_num_to_idx(ibdev, port_num);
+
+	if (port_index < 0)
 		return -EINVAL;
 
-	/*
-	 * VT-DRIVER-API: query_port_state()
-	 * driver returns pretty much everything in ib_port_attr
-	 */
-	return -EOPNOTSUPP;
+	rvp = rdi->ports[port_index];
+	memset(props, 0, sizeof(*props));
+	props->sm_lid = rvp->sm_lid;
+	props->sm_sl = rvp->sm_sl;
+	props->port_cap_flags = rvp->port_cap_flags;
+	props->max_msg_sz = 0x80000000;
+	props->pkey_tbl_len = rvt_get_npkeys(rdi);
+	props->bad_pkey_cntr = rvp->pkey_violations;
+	props->qkey_viol_cntr = rvp->qkey_violations;
+	props->subnet_timeout = rvp->subnet_timeout;
+	props->init_type_reply = 0;
+
+	/* Populate the remaining ib_port_attr elements */
+	return rdi->driver_f.query_port_state(rdi, port_num, props);
 }
 
 /**
@@ -150,23 +163,26 @@ static int rvt_query_port(struct ib_device *ibdev, u8 port_num,
 static int rvt_modify_port(struct ib_device *ibdev, u8 port_num,
 			   int port_modify_mask, struct ib_port_modify *props)
 {
-	/*
-	 * VT-DRIVER-API: set_link_state()
-	 * driver will set the link state using the IB enumeration
-	 *
-	 * VT-DRIVER-API: clear_qkey_violations()
-	 * clears driver private qkey counter
-	 *
-	 * VT-DRIVER-API: get_lid()
-	 * driver needs to return the LID
-	 *
-	 * TBD: send_trap() and post_mad_send() need examined to see where they
-	 * fit in.
-	 */
-	if (ibport_num_to_idx(ibdev, port_num) < 0)
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	struct rvt_ibport *rvp;
+	int ret = 0;
+	int port_index = ibport_num_to_idx(ibdev, port_num);
+
+	if (port_index < 0)
 		return -EINVAL;
 
-	return -EOPNOTSUPP;
+	rvp = rdi->ports[port_index];
+	rvp->port_cap_flags |= props->set_port_cap_mask;
+	rvp->port_cap_flags &= ~props->clr_port_cap_mask;
+
+	if (props->set_port_cap_mask || props->clr_port_cap_mask)
+		rdi->driver_f.cap_mask_chg(rdi, port_num);
+	if (port_modify_mask & IB_PORT_SHUTDOWN)
+		ret = rdi->driver_f.shut_down_port(rdi, port_num);
+	if (port_modify_mask & IB_PORT_RESET_QKEY_CNTR)
+		rvp->qkey_violations = 0;
+
+	return ret;
 }
 
 /**
@@ -273,7 +289,24 @@ static int rvt_dealloc_ucontext(struct ib_ucontext *context)
 static int rvt_get_port_immutable(struct ib_device *ibdev, u8 port_num,
 				  struct ib_port_immutable *immutable)
 {
-	return -EOPNOTSUPP;
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	struct ib_port_attr attr;
+	int err, port_index;
+
+	port_index = ibport_num_to_idx(ibdev, port_num);
+	if (port_index < 0)
+		return -EINVAL;
+
+	err = rvt_query_port(ibdev, port_num, &attr);
+	if (err)
+		return err;
+
+	immutable->pkey_tbl_len = attr.pkey_tbl_len;
+	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = rdi->dparms.core_cap_flags;
+	immutable->max_mad_size = rdi->dparms.max_mad_size;
+
+	return 0;
 }
 
 /*
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index dabf4d5..4242fea 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -200,6 +200,8 @@ struct rvt_driver_params {
 	int psn_mask;
 	int psn_shift;
 	int psn_modify_mask;
+	u32 core_cap_flags;
+	u32 max_mad_size;
 };
 
 /* Protection domain */
@@ -250,6 +252,10 @@ struct rvt_driver_provided {
 	int (*mtu_to_path_mtu)(u32 mtu);
 	int (*get_guid_be)(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
 			   int guid_index, __be64 *guid);
+	int (*query_port_state)(struct rvt_dev_info *rdi, u8 port_num,
+				struct ib_port_attr *props);
+	int (*shut_down_port)(struct rvt_dev_info *rdi, u8 port_num);
+	void (*cap_mask_chg)(struct rvt_dev_info *rdi, u8 port_num);
 
 	/*--------------------*/
 	/* Optional functions */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
