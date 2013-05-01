From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.10 4/4] IB/iser: Add support for iser CM REQ additional info
Date: Wed,  1 May 2013 16:25:27 +0300
Message-ID: <1367414727-22680-5-git-send-email-ogerlitz@mellanox.com>
References: <1367414727-22680-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367414727-22680-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Annex A12 of the IBTA spec defines additional information that needs
to be provided through the CM exchange and relate to usage of ZBVA
(Zero Based VAs) and Send With Invalidate over this iser connection.

Currently, the initiator set both to not supported, but does provide
the header such that existing iser targets can be patched too, so
they start looking on the private data carried by the CM.

This is preparation step to enable iser with HW drivers for which
FMRs are not supported, such as mlx4 VF instances or new HW devices
which might support only FRWR (Fast Registration Work-Requests) along
the details of the IB_DEVICE_MEM_MGT_EXTENSIONS device capability.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    9 +++++++++
 drivers/infiniband/ulp/iser/iser_verbs.c |    7 +++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index f6b8ff0..cae6084 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -140,6 +140,15 @@ struct iser_hdr {
 	__be64  read_va;
 } __attribute__((packed));
 
+
+#define ISER_ZBVA_NOT_SUPPORTED		0x80
+#define ISER_SEND_W_INV_NOT_SUPPORTED	0x40
+
+struct iser_cm_hdr {
+	u8      flags;
+	u8      rsvd[3];
+} __packed;
+
 /* Constant PDU lengths calculations */
 #define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct iscsi_hdr))
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 13838ad..5278916 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -499,6 +499,7 @@ static int iser_route_handler(struct rdma_cm_id *cma_id)
 {
 	struct rdma_conn_param conn_param;
 	int    ret;
+	struct iser_cm_hdr req_hdr;
 
 	ret = iser_create_ib_conn_res((struct iser_conn *)cma_id->context);
 	if (ret)
@@ -510,6 +511,12 @@ static int iser_route_handler(struct rdma_cm_id *cma_id)
 	conn_param.retry_count	       = 7;
 	conn_param.rnr_retry_count     = 6;
 
+	memset(&req_hdr, 0, sizeof(req_hdr));
+	req_hdr.flags = (ISER_ZBVA_NOT_SUPPORTED |
+			ISER_SEND_W_INV_NOT_SUPPORTED);
+	conn_param.private_data		= (void *)&req_hdr;
+	conn_param.private_data_len	= sizeof(struct iser_cm_hdr);
+
 	ret = rdma_connect(cma_id, &conn_param);
 	if (ret) {
 		iser_err("failure connecting: %d\n", ret);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
