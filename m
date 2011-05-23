From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH/RFC] IB/srp: Fix integer -> pointer cast warnings
Date: Mon, 23 May 2011 11:31:45 -0700
Message-ID: <1306175505-1988-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

Hi Dave,

Recently did a 32-bit build and saw this.  I assume this patch would
be OK with you...

-- 8< ---- snip ----

Fix

    drivers/infiniband/ulp/srp/ib_srp.c: In function 'srp_handle_recv':
    drivers/infiniband/ulp/srp/ib_srp.c:1150: warning: cast to pointer from integer of different size
    drivers/infiniband/ulp/srp/ib_srp.c: In function 'srp_send_completion':
    drivers/infiniband/ulp/srp/ib_srp.c:1234: warning: cast to pointer from integer of different size

by adding an intermediate cast to uintptr_t.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 376d640..ee165fd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1147,7 +1147,7 @@ static void srp_process_aer_req(struct srp_target_port *target,
 static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 {
 	struct ib_device *dev = target->srp_host->srp_dev->dev;
-	struct srp_iu *iu = (struct srp_iu *) wc->wr_id;
+	struct srp_iu *iu = (struct srp_iu *) (uintptr_t) wc->wr_id;
 	int res;
 	u8 opcode;
 
@@ -1231,7 +1231,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			break;
 		}
 
-		iu = (struct srp_iu *) wc.wr_id;
+		iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 		list_add(&iu->list, &target->free_tx);
 	}
 }
-- 
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
