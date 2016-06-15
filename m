From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V1 13/13] IB/hfi1: Add device FW version string
Date: Wed, 15 Jun 2016 02:22:08 -0400
Message-ID: <1465971728-24104-14-git-send-email-ira.weiny@intel.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465971728-24104-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Export the firmware version through the core.

Acked-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h   |  2 ++
 drivers/infiniband/hw/hfi1/verbs.c | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1dd48efb5b61..ac73206a8e18 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1174,6 +1174,8 @@ struct hfi1_devdata {
 
 /* 8051 firmware version helper */
 #define dc8051_ver(a, b) ((a) << 8 | (b))
+#define dc8051_ver_maj(a) ((a & 0xff00) >> 8)
+#define dc8051_ver_min(a)  (a & 0x00ff)
 
 /* f_put_tid types */
 #define PT_EXPECTED 0
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 849c4b9399d4..dd4be3c2b225 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1291,9 +1291,12 @@ int hfi1_verbs_send(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 {
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
+	u16 ver = dd->dc8051_ver;
 
 	memset(&rdi->dparms.props, 0, sizeof(rdi->dparms.props));
 
+	rdi->dparms.props.fw_ver = ((u64)(dc8051_ver_maj(ver)) << 16) |
+				    (u64)dc8051_ver_min(ver);
 	rdi->dparms.props.device_cap_flags = IB_DEVICE_BAD_PKEY_CNTR |
 			IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SHUTDOWN_PORT |
 			IB_DEVICE_SYS_IMAGE_GUID | IB_DEVICE_RC_RNR_NAK_GEN |
@@ -1567,6 +1570,17 @@ static void init_ibport(struct hfi1_pportdata *ppd)
 	RCU_INIT_POINTER(ibp->rvp.qp[1], NULL);
 }
 
+static void hfi1_get_dev_fw_str(struct ib_device *ibdev, char *str,
+				size_t str_len)
+{
+	struct rvt_dev_info *rdi = ib_to_rvt(ibdev);
+	struct hfi1_ibdev *dev = dev_from_rdi(rdi);
+	u16 ver = dd_from_dev(dev)->dc8051_ver;
+
+	snprintf(str, str_len, "%u.%u", dc8051_ver_maj(ver),
+		 dc8051_ver_min(ver));
+}
+
 /**
  * hfi1_register_ib_device - register our device with the infiniband core
  * @dd: the device data structure
@@ -1613,6 +1627,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	/* keep process mad in the driver */
 	ibdev->process_mad = hfi1_process_mad;
+	ibdev->get_dev_fw_str = hfi1_get_dev_fw_str;
 
 	strncpy(ibdev->node_desc, init_utsname()->nodename,
 		sizeof(ibdev->node_desc));
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
