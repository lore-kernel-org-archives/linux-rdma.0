From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/core: Add optional AV attribute for Raw Packet QP in INIT to RTR
Date: Sun,  3 Jul 2016 15:42:05 +0300
Message-ID: <1467549727-23479-2-git-send-email-leon@kernel.org>
References: <1467549727-23479-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467549727-23479-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to configure QoS for Raw Packet QP, the user passes the SL
in the AV attribute when modifying the QP from INIT to RTR state.

This SL is used later on to set the Ethernet Priority of the QP.

Until today, we couldn't pass the AV attribute for Raw Packet QP
because it was blocked in the QP state transition matrix. This
patch adds the AV as optional in INIT to RTR.

Fixes: 8a51866f0810 ('IB: Add ib_modify_qp_is_ok() library function')
Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 2e813ed..ba75780 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -932,6 +932,7 @@ static const struct {
 						 IB_QP_QKEY),
 				 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
 						 IB_QP_QKEY),
+				 [IB_QPT_RAW_PACKET] = IB_QP_AV,
 			 },
 		},
 	},
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
