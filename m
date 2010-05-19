From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/9] dapl-2.0: ucm: increase default UCM retry count for
 connect reply to 15
Date: Wed, 19 May 2010 11:25:16 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130DA@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


on large clusters UCM is timing out with retries at 10.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 3e32fab..cc416d2 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -166,7 +166,7 @@ typedef uint16_t		ib_hca_port_t;
 #define DCM_TCLASS	0
 
 /* DAPL uCM timers, default queue sizes */
-#define DCM_RETRY_CNT   10 
+#define DCM_RETRY_CNT   15 
 #define DCM_REP_TIME    800	/* reply timeout in m_secs */
 #define DCM_RTU_TIME    400	/* rtu timeout in m_secs */
 #define DCM_QP_SIZE     500     /* uCM tx, rx qp size */
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
