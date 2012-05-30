From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/16] librdmacm/rsockets: Change the default QP size from
 512 to 384
Date: Wed, 30 May 2012 17:21:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A24C23@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Simple latency/bandwidth tests using rstream showed minimal
difference in performance between using a QP sized to 384
entries versus 512.  Reduce the overhead of a default rsocket
by using 384 entries.  A user can request a larger size by
calling rsetsockopt.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index b89ef42..c111797 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -54,7 +54,7 @@
 #define RS_INLINE 64
 #define RS_OLAP_START_SIZE 2048
 #define RS_MAX_TRANSFER 65536
-#define RS_QP_SIZE 512
+#define RS_QP_SIZE 384
 #define RS_QP_MAX_SIZE 0xFFFE
 #define RS_QP_MIN_SIZE 8
 #define RS_QP_CTRL_SIZE 4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
