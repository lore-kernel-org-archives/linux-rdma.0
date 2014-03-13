From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] udapl: move dapltest default server port outside ephemeral
 port range
Date: Thu, 13 Mar 2014 18:56:06 +0000
Message-ID: <54347E5A035A054EAE9D05927FB467F972E0C9B4@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 test/dapltest/include/dapl_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/test/dapltest/include/dapl_common.h b/test/dapltest/include/dapl_common.h
index a514973..7dfe471 100644
--- a/test/dapltest/include/dapl_common.h
+++ b/test/dapltest/include/dapl_common.h
@@ -33,7 +33,7 @@
 
 #include "dapl_proto.h"
 
-#define SERVER_PORT_NUMBER ((DAT_CONN_QUAL)0xB0de)
+#define SERVER_PORT_NUMBER ((DAT_CONN_QUAL)62000)
 
 typedef enum
 {
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
