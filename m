From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Don't advertise SA in RoCE port capabilities
Date: Wed, 10 Jun 2015 11:43:35 +0300
Message-ID: <1433925815-19725-1-git-send-email-monis@mellanox.com>
References: <5577F72A.2070008@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5577F72A.2070008-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The Subnet Administrator (SA) is not a component of the RoCE spec.
Therefore, it should not be a capability of a RoCE port.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 7d78794..7725cee 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -381,7 +381,6 @@ union rdma_protocol_stats {
 #define RDMA_CORE_PORT_IBA_ROCE        (RDMA_CORE_CAP_PROT_ROCE \
 					| RDMA_CORE_CAP_IB_MAD  \
 					| RDMA_CORE_CAP_IB_CM   \
-					| RDMA_CORE_CAP_IB_SA   \
 					| RDMA_CORE_CAP_AF_IB   \
 					| RDMA_CORE_CAP_ETH_AH)
 #define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
