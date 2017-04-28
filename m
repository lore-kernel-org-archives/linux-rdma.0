From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 rdma-next 7/8] IB/core: Move opa_class_port_info definition to header file
Date: Fri, 28 Apr 2017 17:47:10 -0400
Message-ID: <1493416031-23917-8-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493416031-23917-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493416031-23917-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Both opa_vnic and the hfi driver use the same opa_classport_info
definition. We will also have ib_sa capable of querying opa class
port info and would need this definition. Move it to ib_mad.h
for everyone to use.

Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c                | 25 -------------------------
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c | 25 -------------------------
 include/rdma/ib_mad.h                           | 25 +++++++++++++++++++++++++
 3 files changed, 25 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 4c6f51c..836d00b 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -1994,31 +1994,6 @@ struct opa_pma_mad {
 	u8 data[2024];
 } __packed;
 
-struct opa_class_port_info {
-	u8 base_version;
-	u8 class_version;
-	__be16 cap_mask;
-	__be32 cap_mask2_resp_time;
-
-	u8 redirect_gid[16];
-	__be32 redirect_tc_fl;
-	__be32 redirect_lid;
-	__be32 redirect_sl_qp;
-	__be32 redirect_qkey;
-
-	u8 trap_gid[16];
-	__be32 trap_tc_fl;
-	__be32 trap_lid;
-	__be32 trap_hl_qp;
-	__be32 trap_qkey;
-
-	__be16 trap_pkey;
-	__be16 redirect_pkey;
-
-	u8 trap_sl_rsvd;
-	u8 reserved[3];
-} __packed;
-
 struct opa_port_status_req {
 	__u8 port_num;
 	__u8 reserved[3];
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index 6ff7be6..cee49aa 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -88,31 +88,6 @@
 /* Maximum number of VNIC ports supported */
 #define OPA_VNIC_MAX_NUM_VPORT    255
 
-struct opa_class_port_info {
-	u8 base_version;
-	u8 class_version;
-	__be16 cap_mask;
-	__be32 cap_mask2_resp_time;
-
-	u8 redirect_gid[16];
-	__be32 redirect_tc_fl;
-	__be32 redirect_lid;
-	__be32 redirect_sl_qp;
-	__be32 redirect_qkey;
-
-	u8 trap_gid[16];
-	__be32 trap_tc_fl;
-	__be32 trap_lid;
-	__be32 trap_hl_qp;
-	__be32 trap_qkey;
-
-	__be16 trap_pkey;
-	__be16 redirect_pkey;
-
-	u8 trap_sl_rsvd;
-	u8 reserved[3];
-} __packed;
-
 /**
  * struct opa_vnic_vema_port -- VNIC VEMA port details
  * @cport: pointer to port
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 42814a0..3d5f5d6 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -262,6 +262,31 @@ struct ib_class_port_info {
 	__be32			trap_qkey;
 };
 
+struct opa_class_port_info {
+	u8 base_version;
+	u8 class_version;
+	__be16 cap_mask;
+	__be32 cap_mask2_resp_time;
+
+	u8 redirect_gid[16];
+	__be32 redirect_tc_fl;
+	__be32 redirect_lid;
+	__be32 redirect_sl_qp;
+	__be32 redirect_qkey;
+
+	u8 trap_gid[16];
+	__be32 trap_tc_fl;
+	__be32 trap_lid;
+	__be32 trap_hl_qp;
+	__be32 trap_qkey;
+
+	__be16 trap_pkey;
+	__be16 redirect_pkey;
+
+	u8 trap_sl_rsvd;
+	u8 reserved[3];
+} __packed;
+
 /**
  * ib_get_cpi_resp_time - Returns the resp_time value from
  * cap_mask2_resp_time in ib_class_port_info.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
