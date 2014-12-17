From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_torus.c: Increase PORTGRP_MAX_PORTS define
Date: Wed, 17 Dec 2014 11:28:10 +0200
Message-ID: <1418808490-27687-1-git-send-email-alexne@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Torus-2QoS fails to configure fabric with more than 16 HCAs.
This patch extends PORTGRP_MAX_PORTS to be 34. Maximal practical ports
per switch - 2 reserved ports (minimal of needed ports for switch to
switch connections in 2D Torus).

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index 330f55d..b01f69f 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -59,7 +59,7 @@
 #include <opensm/osm_opensm.h>
 
 #define TORUS_MAX_DIM        3
-#define PORTGRP_MAX_PORTS    16
+#define PORTGRP_MAX_PORTS    34
 #define SWITCH_MAX_PORTGRPS  (1 + 2 * TORUS_MAX_DIM)
 #define DEFAULT_MAX_CHANGES  32
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
