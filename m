From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_sa.h: Cosmetic commentary change
Date: Tue, 18 Sep 2012 14:53:33 -0400
Message-ID: <5058C32D.3090409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_sa.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_sa.h b/include/opensm/osm_sa.h
index 7c1061d..08c4130 100644
--- a/include/opensm/osm_sa.h
+++ b/include/opensm/osm_sa.h
@@ -73,8 +73,8 @@ BEGIN_C_DECLS
 *
 * DESCRIPTION
 *	The SA object encapsulates the information needed by the
-*	OpenSM to instantiate a subnet administrator.  The OpenSM allocates
-*	one SA object per subnet manager.
+*	OpenSM to instantiate subnet administration.  The OpenSM
+*	allocates one SA object per subnet manager.
 *
 *	The SA object is thread safe.
 *
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
