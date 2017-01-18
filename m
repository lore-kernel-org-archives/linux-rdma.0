From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 01/11] IB/core: Expose vlan offloads capabilities
Date: Wed, 18 Jan 2017 15:39:54 +0200
Message-ID: <20170118134004.5380-2-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose raw packet capabilities in the core layer to enable a device
to report it.
Two existing capabilities, scatter FCS and IP CSUM were added to this
field for a better user experience by exposing the raw packet caps
from one location.
This field will serve also for future capabilities for raw packet QP.

A new capability was introduced - cvlan stripping, which is the
device's ability to remove cvlan tag from an incoming packet and
report it in the matching work completion.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 958a24d..edb9ff0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -207,6 +207,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MEM_WINDOW_TYPE_2A		= (1 << 23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B		= (1 << 24),
 	IB_DEVICE_RC_IP_CSUM			= (1 << 25),
+	/* Deprecated. Please use IB_RAW_PACKET_CAP_IP_CSUM. */
 	IB_DEVICE_RAW_IP_CSUM			= (1 << 26),
 	/*
 	 * Devices should set IB_DEVICE_CROSS_CHANNEL if they
@@ -220,6 +221,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
 	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
 	IB_DEVICE_VIRTUAL_FUNCTION		= (1ULL << 33),
+	/* Deprecated. Please use IB_RAW_PACKET_CAP_SCATTER_FCS. */
 	IB_DEVICE_RAW_SCATTER_FCS		= (1ULL << 34),
 };
 
@@ -330,6 +332,7 @@ struct ib_device_attr {
 	uint64_t		hca_core_clock; /* in KHZ */
 	struct ib_rss_caps	rss_caps;
 	u32			max_wq_type_rq;
+	u32			raw_packet_caps; /* Use ib_raw_packet_caps enum */
 };
 
 enum ib_mtu {
@@ -1456,6 +1459,18 @@ struct ib_srq {
 	} ext;
 };
 
+enum ib_raw_packet_caps {
+	/* Strip cvlan from incoming packet and report it in the matching work
+	 * completion is supported.
+	 */
+	IB_RAW_PACKET_CAP_CVLAN_STRIPPING	= (1 << 0),
+	/* Scatter FCS field of an incoming packet to host memory is supported.
+	 */
+	IB_RAW_PACKET_CAP_SCATTER_FCS		= (1 << 1),
+	/* Checksum offloads are supported (for both send and receive). */
+	IB_RAW_PACKET_CAP_IP_CSUM		= (1 << 2),
+};
+
 enum ib_wq_type {
 	IB_WQT_RQ
 };
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
