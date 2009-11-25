From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] uDAPL v2: winof cma: missing definition for EADDRNOTAVAIL
Date: Tue, 24 Nov 2009 16:16:21 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C98361B96A63@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_cma/windows/openib_osd.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_cma/windows/openib_osd.h b/dapl/openib_cma/windows/openib_osd.h
index d008fc0..581b908 100644
--- a/dapl/openib_cma/windows/openib_osd.h
+++ b/dapl/openib_cma/windows/openib_osd.h
@@ -3,3 +3,7 @@
 
 #define ntohll _byteswap_uint64
 #define htonll _byteswap_uint64
+
+#ifndef EADDRNOTAVAIL
+#define EADDRNOTAVAIL	WSAEADDRNOTAVAIL
+#endif
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
