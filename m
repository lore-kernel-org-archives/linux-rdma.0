From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 1/5] IB/usnic: Add struct usnic_transport_spec
Date: Fri, 20 Dec 2013 12:30:21 -0800
Message-ID: <1387571425-8566-2-git-send-email-umalhi@cisco.com>
References: <1387571425-8566-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571425-8566-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add *struct usnic_transport_spec* for passing around transport
specifications.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_abi.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniband/hw/usnic/usnic_abi.h
index 2beabf7..7eb49f4 100644
--- a/drivers/infiniband/hw/usnic/usnic_abi.h
+++ b/drivers/infiniband/hw/usnic/usnic_abi.h
@@ -33,6 +33,15 @@ enum usnic_transport_type {
 	USNIC_TRANSPORT_MAX		= 2,
 };

+struct usnic_transport_spec {
+	enum usnic_transport_type	trans_type;
+	union {
+		struct {
+			uint16_t	port_num;
+		} usnic_roce;
+	};
+};
+
 /*TODO: Future - usnic_modify_qp needs to pass in generic filters */
 struct usnic_ib_create_qp_resp {
 	u32				vfid;
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
