From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] uDAPL v2: ucm: increase default reply and rtu timeout
 values.
Date: Wed, 28 Oct 2009 16:19:14 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9835F08B519@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/dapl_ib_common.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/dapl/openib_common/dapl_ib_common.h b/dapl/openib_common/dapl_ib_common.h
index 982621c..6c66b25 100644
--- a/dapl/openib_common/dapl_ib_common.h
+++ b/dapl/openib_common/dapl_ib_common.h
@@ -167,8 +167,8 @@ typedef uint16_t		ib_hca_port_t;
 
 /* DAPL uCM timers, default queue sizes */
 #define DCM_RETRY_CNT   10 
-#define DCM_REP_TIME    400	/* reply timeout in m_secs */
-#define DCM_RTU_TIME    200	/* rtu timeout in m_secs */
+#define DCM_REP_TIME    800	/* reply timeout in m_secs */
+#define DCM_RTU_TIME    400	/* rtu timeout in m_secs */
 #define DCM_QP_SIZE     500     /* uCM tx, rx qp size */
 #define DCM_CQ_SIZE     500     /* uCM cq size */
 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
