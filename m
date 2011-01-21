From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl-2.0:  common: reduce default max inline data size
 because of performance anomaly
Date: Thu, 20 Jan 2011 18:50:36 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011F5526C0@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

	
Increasing max inline causes small message rates to decrease from
4M/sec when set to 64 to about 1M/sec when set to 400. This has
been observed on latest mlx4 adapters using ib_write_bw test.
Set default to 64 until resolved.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 78f71d2..1b7670e 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -151,7 +151,7 @@ typedef uint16_t		ib_hca_port_t;
 
 /* inline send rdma threshold */
 #define	INLINE_SEND_IWARP_DEFAULT	64
-#define	INLINE_SEND_IB_DEFAULT		400
+#define	INLINE_SEND_IB_DEFAULT		64
 
 /* qkey for UD QP's */
 #define DAT_UD_QKEY	0x78654321
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
