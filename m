From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2 - openib_common: remote memory read privilege set
 multi times
Date: Fri, 4 Dec 2009 14:36:56 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361E0FFD9@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


cleanup duplicate setting of read privileges in dapls_convert_privileges

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/mem.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/dapl/openib_common/mem.c b/dapl/openib_common/mem.c
index b286f8c..ddf85a4 100644
--- a/dapl/openib_common/mem.c
+++ b/dapl/openib_common/mem.c
@@ -55,10 +55,6 @@ STATIC _INLINE_ int dapls_convert_privileges(IN DAT_MEM_PRIV_FLAGS privileges)
 		access |= IBV_ACCESS_REMOTE_WRITE;
 	if (DAT_MEM_PRIV_REMOTE_READ_FLAG & privileges)
 		access |= IBV_ACCESS_REMOTE_READ;
-	if (DAT_MEM_PRIV_REMOTE_READ_FLAG & privileges)
-		access |= IBV_ACCESS_REMOTE_READ;
-	if (DAT_MEM_PRIV_REMOTE_READ_FLAG & privileges)
-		access |= IBV_ACCESS_REMOTE_READ;
 #ifdef DAT_EXTENSIONS
 	if (DAT_IB_MEM_PRIV_REMOTE_ATOMIC & privileges)
 		access |= IBV_ACCESS_REMOTE_ATOMIC;
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
