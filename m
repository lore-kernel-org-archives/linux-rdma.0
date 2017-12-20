From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core v2] Fix typos 'pontentially' and 'bandwith'
Date: Wed, 20 Dec 2017 19:30:51 +0100
Message-ID: <20171220183051.13906-1-benjamin.drung@profitbricks.com>
References: <1513092243.3704.0.camel@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1513092243.3704.0.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 libibverbs/man/ibv_query_device_ex.3 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_query_device_ex.3 b/libibverbs/man/ibv_query_device_ex.3
index 1172523a..cc8b896e 100644
--- a/libibverbs/man/ibv_query_device_ex.3
+++ b/libibverbs/man/ibv_query_device_ex.3
@@ -125,7 +125,7 @@ utilization and small packets will be harmed.
 
 For instance, with a 128 byte cache line size, the transfer of any
 packets less than 128 bytes will require a full 128 transfer on PCI,
-pontentially doubling the required PCI-E bandwith.
+potentially doubling the required PCI-E bandwidth.
 
 This feature can be enabled on a QP or WQ basis via the
 IBV_QP_CREATE_PCI_WRITE_END_PADDING or IBV_WQ_FLAGS_PCI_WRITE_END_PADDING
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
