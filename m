From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 5/7] ib_srpt: Fix a bug in an error path
Date: Sun, 9 Jan 2011 17:27:34 +0100
Message-ID: <201101091727.34249.bvanassche@acm.org>
References: <201101091723.41399.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101091723.41399.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Do not invoke scst_unregister_session() if session registration failed
because invoking scst_unregister_session() with a NULL session pointer
triggers a kernel oops.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/scst/srpt/ib_srpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 08f1de0..66f11f6 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -2365,7 +2365,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		TRACE_DBG("%s", "Failed to create SCST session");
-		goto release_channel;
+		goto destroy_ib;
 	}
 
 	TRACE_DBG("Establish connection sess=%p name=%s cm_id=%p",
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
