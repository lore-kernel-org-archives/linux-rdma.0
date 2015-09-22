From: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [v1 1/2] IB/core: Add support of checksum capability reporting for RC and RAW
Date: Tue, 22 Sep 2015 23:18:10 +0300
Message-ID: <1442953091-102103-2-git-send-email-bodong@mellanox.com>
References: <1442953091-102103-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442953091-102103-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Two enum members IB_DEVICE_RC_IP_CSUM and IB_DEVICE_RAW_IP_CSUM are
added to ib_device_cap_flags. Device should set these two flags if they support
insertion of UDP and TCP checksum on outgoing IPv4 messages and can verify the
validity of checksum for incoming IPv4 messages, for RC IPoIB and RAW over
Ethernet respectively. They are similar to IB_DEVICE_UD_IP_CSUM.

Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b0f898e..091894a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -130,6 +130,8 @@ enum ib_device_cap_flags {
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
 	IB_DEVICE_MEM_WINDOW_TYPE_2B	= (1<<24),
+	IB_DEVICE_RC_IP_CSUM		= (1<<25),
+	IB_DEVICE_RAW_IP_CSUM		= (1<<26),
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
 	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
 	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
@@ -868,7 +870,6 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
 };
 
-
 /*
  * Note: users may not call ib_close_qp or ib_destroy_qp from the event_handler
  * callback to destroy the passed in QP.
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
