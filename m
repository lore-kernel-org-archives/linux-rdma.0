From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 5/8] RDMA/core: Move port state to UAPI and rename it to be link
Date: Tue, 15 Aug 2017 12:14:28 +0300
Message-ID: <20170815091431.12822-6-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide to user space applications ability to reuse kernel
link state enum.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h  | 12 ++++++------
 include/uapi/rdma/rdma.h | 10 ++++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a7cd54061f48..7e9940244e38 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -383,12 +383,12 @@ static inline enum ib_mtu ib_mtu_int_to_enum(int mtu)
 }
 
 enum ib_port_state {
-	IB_PORT_NOP		= 0,
-	IB_PORT_DOWN		= 1,
-	IB_PORT_INIT		= 2,
-	IB_PORT_ARMED		= 3,
-	IB_PORT_ACTIVE		= 4,
-	IB_PORT_ACTIVE_DEFER	= 5
+	IB_PORT_NOP		= RDMA_LINK_STATE_NOP,
+	IB_PORT_DOWN		= RDMA_LINK_STATE_DOWN,
+	IB_PORT_INIT		= RDMA_LINK_STATE_INIT,
+	IB_PORT_ARMED		= RDMA_LINK_STATE_ARMED,
+	IB_PORT_ACTIVE		= RDMA_LINK_STATE_ACTIVE,
+	IB_PORT_ACTIVE_DEFER	= RDMA_LINK_STATE_ACTIVE_DEFER
 };
 
 enum ib_port_cap_flags {
diff --git a/include/uapi/rdma/rdma.h b/include/uapi/rdma/rdma.h
index 397796e63a3a..5f4019e2c5d4 100644
--- a/include/uapi/rdma/rdma.h
+++ b/include/uapi/rdma/rdma.h
@@ -143,4 +143,14 @@ enum rdma_port_cap {
 	RDMA_PORT_CLIENT_REG			= 1 << 25,
 	RDMA_PORT_IP_BASED_GIDS			= 1 << 26,
 };
+
+enum rdma_link_state {
+	RDMA_LINK_STATE_NOP,
+	RDMA_LINK_STATE_DOWN,
+	RDMA_LINK_STATE_INIT,
+	RDMA_LINK_STATE_ARMED,
+	RDMA_LINK_STATE_ACTIVE,
+	RDMA_LINK_STATE_ACTIVE_DEFER,
+};
+};
 #endif /* _RDMA_H */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
