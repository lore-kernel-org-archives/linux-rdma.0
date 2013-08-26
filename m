From: <bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/14] RDMA/ocrdma: Fix for displaying proper link speed.
Date: Mon, 26 Aug 2013 15:27:47 +0530
Message-ID: <beb0bb0f-5344-4024-ad9c-60531e77cbfa@CMEXHTCAS1.ad.emulex.com>
References: <1377511071-16967-1-git-send-email-bgottumukka@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377511071-16967-1-git-send-email-bgottumukka-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Fix for displaying proper link speed.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 28 +++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 27 ++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 43 +++++++++++++++++++++++++++--
 4 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 3f02755..ea3d723 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1101,6 +1101,34 @@ mbx_err:
 	return status;
 }
 
+int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed)
+{
+	int status = -ENOMEM;
+	struct ocrdma_get_link_speed_rsp *rsp;
+	struct ocrdma_mqe *cmd;
+
+	cmd = ocrdma_init_emb_mqe(OCRDMA_CMD_QUERY_NTWK_LINK_CONFIG_V1,
+				  sizeof(*cmd));
+	if (!cmd)
+		return status;
+	ocrdma_init_mch((struct ocrdma_mbx_hdr *)&cmd->u.cmd[0],
+			OCRDMA_CMD_QUERY_NTWK_LINK_CONFIG_V1,
+			OCRDMA_SUBSYS_COMMON, sizeof(*cmd));
+
+	((struct ocrdma_mbx_hdr *)cmd->u.cmd)->rsvd_version = 0x1;
+
+	status = ocrdma_mbx_cmd(dev, (struct ocrdma_mqe *)cmd);
+	if (status)
+		goto mbx_err;
+
+	rsp = (struct ocrdma_get_link_speed_rsp *)cmd;
+	*lnk_speed = rsp->phys_port_speed;
+
+mbx_err:
+	kfree(cmd);
+	return status;
+}
+
 int ocrdma_mbx_alloc_pd(struct ocrdma_dev *dev, struct ocrdma_pd *pd)
 {
 	int status = -ENOMEM;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index 044db74..f2a89d4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -91,6 +91,7 @@ void ocrdma_ring_cq_db(struct ocrdma_dev *, u16 cq_id, bool armed,
 		       bool solicited, u16 cqe_popped);
 
 /* verbs specific mailbox commands */
+int ocrdma_mbx_get_link_speed(struct ocrdma_dev *dev, u8 *lnk_speed);
 int ocrdma_query_config(struct ocrdma_dev *,
 			struct ocrdma_mbx_query_config *config);
 int ocrdma_resolve_dgid(struct ocrdma_dev *, union ib_gid *dgid, u8 *mac_addr);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 35c6108..9e975d8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -70,6 +70,7 @@ enum {
 
 #define OCRDMA_SUBSYS_COMMON 1
 enum {
+	OCRDMA_CMD_QUERY_NTWK_LINK_CONFIG_V1 = 5,
 	OCRDMA_CMD_CREATE_CQ		= 12,
 	OCRDMA_CMD_CREATE_EQ		= 13,
 	OCRDMA_CMD_CREATE_MQ		= 21,
@@ -545,6 +546,32 @@ enum {
 	OCRDMA_FN_MODE_RDMA	= 0x4
 };
 
+struct ocrdma_get_link_speed_rsp {
+	struct ocrdma_mqe_hdr hdr;
+	struct ocrdma_mbx_rsp rsp;
+
+	u8 pt_port_num;
+	u8 link_duplex;
+	u8 phys_port_speed;
+	u8 phys_port_fault;
+	u16 rsvd1;
+	u16 qos_lnk_speed;
+	u8 logical_lnk_status;
+	u8 rsvd2[3];
+};
+
+enum {
+	OCRDMA_PHYS_LINK_SPEED_ZERO = 0x0,
+	OCRDMA_PHYS_LINK_SPEED_10MBPS = 0x1,
+	OCRDMA_PHYS_LINK_SPEED_100MBPS = 0x2,
+	OCRDMA_PHYS_LINK_SPEED_1GBPS = 0x3,
+	OCRDMA_PHYS_LINK_SPEED_10GBPS = 0x4,
+	OCRDMA_PHYS_LINK_SPEED_20GBPS = 0x5,
+	OCRDMA_PHYS_LINK_SPEED_25GBPS = 0x6,
+	OCRDMA_PHYS_LINK_SPEED_40GBPS = 0x7,
+	OCRDMA_PHYS_LINK_SPEED_100GBPS = 0x8
+};
+
 enum {
 	OCRDMA_CREATE_CQ_VER2			= 2,
 	OCRDMA_CREATE_CQ_VER3                   = 3,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e934073..f09a940 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -106,6 +106,45 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	return 0;
 }
 
+static inline void get_link_speed_and_width(struct ocrdma_dev *dev,
+					    u8 *ib_speed, u8 *ib_width)
+{
+	int status;
+	u8 speed;
+
+	status = ocrdma_mbx_get_link_speed(dev, &speed);
+	if (status)
+		speed = OCRDMA_PHYS_LINK_SPEED_ZERO;
+
+	switch (speed) {
+	case OCRDMA_PHYS_LINK_SPEED_1GBPS:
+		*ib_speed = IB_SPEED_SDR;
+		*ib_width = IB_WIDTH_1X;
+		break;
+
+	case OCRDMA_PHYS_LINK_SPEED_10GBPS:
+		*ib_speed = IB_SPEED_QDR;
+		*ib_width = IB_WIDTH_1X;
+		break;
+
+	case OCRDMA_PHYS_LINK_SPEED_20GBPS:
+		*ib_speed = IB_SPEED_DDR;
+		*ib_width = IB_WIDTH_4X;
+		break;
+
+	case OCRDMA_PHYS_LINK_SPEED_40GBPS:
+		*ib_speed = IB_SPEED_QDR;
+		*ib_width = IB_WIDTH_4X;
+		break;
+
+	default:
+		/* Unsupported */
+		*ib_speed = IB_SPEED_SDR;
+		*ib_width = IB_WIDTH_1X;
+	};
+}
+
+
 int ocrdma_query_port(struct ib_device *ibdev,
 		      u8 port, struct ib_port_attr *props)
 {
@@ -142,8 +181,8 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	props->pkey_tbl_len = 1;
 	props->bad_pkey_cntr = 0;
 	props->qkey_viol_cntr = 0;
-	props->active_width = IB_WIDTH_1X;
-	props->active_speed = 4;
+	get_link_speed_and_width(dev, &props->active_speed,
+				 &props->active_width);
 	props->max_msg_sz = 0x80000000;
 	props->max_vl_num = 4;
 	return 0;
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
