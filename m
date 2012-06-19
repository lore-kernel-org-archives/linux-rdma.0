From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next V1 02/29] IB/core: Reserve bits in enum ib_qp_create_flags for low-level driver use
Date: Tue, 19 Jun 2012 11:21:34 +0300
Message-ID: <1340094121-14858-3-git-send-email-jackm@dev.mellanox.co.il>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Reserve bits 26-31 for internal use by low-level drivers. Two
such bits are used in the mlx4 driver SRIOV IB implementation.

These enum additions guarantee that the core layer will never use
these bits, so that low level drivers may safely make use of them.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 include/rdma/ib_verbs.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 07996af..46bc045 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -614,6 +614,9 @@ enum ib_qp_type {
 enum ib_qp_create_flags {
 	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
+	/* reserve bits 26-31 for low level drivers' internal use */
+	IB_QP_CREATE_RESERVED_START		= 1 << 26,
+	IB_QP_CREATE_RESERVED_END		= 1 << 31,
 };
 
 struct ib_qp_init_attr {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
