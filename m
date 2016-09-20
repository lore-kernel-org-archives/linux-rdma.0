From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 perftest] Support for Chelsio T6 devices
Date: Tue, 20 Sep 2016 07:16:38 -0700
Message-ID: <20160920141917.AFE07E0BC1@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gil Rockah <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

Changes since v1:

fixed nit suggested by Leon

---
 src/perftest_parameters.c |    1 +
 src/perftest_parameters.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index a21b6eb..0d1ea2f 100755
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -1326,6 +1326,7 @@ enum ctx_device ib_dev_name(struct ibv_context *context)
 			case 4  : dev_fname = CHELSIO_T4; break;
 			case 11 :
 			case 5  : dev_fname = CHELSIO_T5; break;
+			case 6  : dev_fname = CHELSIO_T6; break;
 			default : dev_fname = UNKNOWN; break;
 		}
 
diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
index 448e398..dc57efb 100755
--- a/src/perftest_parameters.h
+++ b/src/perftest_parameters.h
@@ -269,7 +269,8 @@ enum ctx_device {
 	CONNECTX4		= 10,
 	CONNECTX4LX		= 11,
 	QLOGIC_E4		= 12,
-	QLOGIC_AH		= 13
+	QLOGIC_AH		= 13,
+	CHELSIO_T6		= 14,
 };
 
 /* Units for rate limiter */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
