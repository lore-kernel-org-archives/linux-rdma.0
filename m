From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] dapl 2.0: cma: definition for dapl_sp_remove_ep() is
 missing in cm.c
Date: Fri, 10 Dec 2010 13:58:51 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983011EBD7099@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_cma/cm.c b/dapl/openib_cma/cm.c
index ff48999..f010b8a 100644
--- a/dapl/openib_cma/cm.c
+++ b/dapl/openib_cma/cm.c
@@ -42,6 +42,7 @@
 #include "dapl.h"
 #include "dapl_adapter_util.h"
 #include "dapl_evd_util.h"
+#include "dapl_sp_util.h"
 #include "dapl_cr_util.h"
 #include "dapl_name_service.h"
 #include "dapl_ib_util.h"
-- 
1.7.3



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
