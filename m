From: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] IB/core: Add support of checksum capability reporting in ib verbs
Date: Wed, 16 Sep 2015 18:56:06 +0300
Message-ID: <490a38ab04a96f24500d647392e931c38853ba45.1442413048.git.bodong@mellanox.com>
References: <cover.1442413048.git.bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <cover.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
References: <cover.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A new filed csum_cap is added to both ib_query_device. It contains two members:
eth_csum_cap and ib_csum_cap, indicates checksum capability of Ethernet and
Infiniband link layer respectively for different QP types.

Current checksum caps use the following enum members:
- IB_CSUM_SUPPORT_UD: device supports validation/calculation of csum for UD QP.
- IB_CSUM_SUPPORT_RAW: device supports validation/calculation of csum for raw QP.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b0f898e..94dbaee 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -183,6 +183,11 @@ struct ib_cq_init_attr {
 	u32		flags;
 };
 
+struct ib_csum_cap_per_link {
+	uint32_t  eth_csum_cap;
+	uint32_t  ib_csum_cap;
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
@@ -229,6 +234,7 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	struct ib_csum_cap_per_link csum_cap;
 };
 
 enum ib_mtu {
@@ -868,6 +874,10 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
 };
 
+enum ib_csum_cap_flags {
+	IB_CSUM_SUPPORT_UD	= (1 << IB_QPT_UD),
+	IB_CSUM_SUPPORT_RAW	= (1 << IB_QPT_RAW_PACKET),
+};
 
 /*
  * Note: users may not call ib_close_qp or ib_destroy_qp from the event_handler
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
