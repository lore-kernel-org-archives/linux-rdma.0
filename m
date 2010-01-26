From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_port_info_rcv.c: fix compilation warning
Date: Tue, 26 Jan 2010 18:10:54 +0200
Message-ID: <4B5F140E.7090400@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixing compilation warning:
osm_port_info_rcv.c:163: warning: implicit declaration of function 'free'

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_port_info_rcv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_port_info_rcv.c b/opensm/opensm/osm_port_info_rcv.c
index 8a99064..9260047 100644
--- a/opensm/opensm/osm_port_info_rcv.c
+++ b/opensm/opensm/osm_port_info_rcv.c
@@ -46,6 +46,7 @@
 #endif				/* HAVE_CONFIG_H */

 #include <string.h>
+#include <stdlib.h>
 #include <iba/ib_types.h>
 #include <complib/cl_qmap.h>
 #include <complib/cl_passivelock.h>
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
