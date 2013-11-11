From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Added inline data support for Emulex SkyHawk controller.
Date: Mon, 11 Nov 2013 03:22:52 -0500
Message-ID: <6f48df92-8bd8-486e-b173-1aeee9ed3ed6@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Naresh <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Naresh <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 src/perftest_parameters.c |    1 +
 src/perftest_parameters.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index 084f16f..a2a5ca7 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -732,6 +732,7 @@ static enum ctx_device ib_dev_name(struct ibv_context *context) {
 			case 25418 : dev_fname = CONNECTX;  break;
 			case 25428 : dev_fname = CONNECTX;  break;
 			case 25448 : dev_fname = CONNECTX;  break;
+			case 1824  : dev_fname = SKYHAWK;  break;
 			default	   : dev_fname = UNKNOWN;
 		}
 	}
diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
index 42f6966..4c5b57c 100755
--- a/src/perftest_parameters.h
+++ b/src/perftest_parameters.h
@@ -214,7 +214,8 @@ enum ctx_device {
 	LEGACY 			= 5,
 	CHELSIO_T4 		= 6,
 	CHELSIO_T5 		= 7,
-	CONNECTX3_PRO	= 8
+	CONNECTX3_PRO		= 8,
+	SKYHAWK			= 9
 };
 
 struct perftest_parameters {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
