From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 2/3] IB/rxe: Drop future atomic/read packets rather than retrying
Date: Thu, 22 Dec 2016 08:54:37 -0500
Message-ID: <1482414878-6892-3-git-send-email-andrew.boyer@dell.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If the completer is in the middle of a large read operation, one
lost packet can cause havoc. Going to COMPST_ERROR_RETRY will
cause the requester to resend the request. After that, any packet
from the first attempt still in the receive queue will be
interpreted as an error, restarting the error/retry sequence.
The transfer will quickly exhaust its retries.

This behavior is very noticeable when doing 512KB reads on a
QEMU system configured with 1500B MTU.

Also, a resent request here will prompt the responder on the
other side to immediately start resending, but the resent
packets will get stuck in the already-loaded receive queue and
will never be processed.

Rather than erroring out every time an unexpected future packet
arrives, just drop it. Eventually the retry timer will send a
duplicate request; the completer will be able to make progress since
the queue will start relatively empty.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index cd27cbd..d369f24 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -224,7 +224,7 @@ static inline enum comp_state check_psn(struct rxe_qp *qp,
 		else
 			return COMPST_DONE;
 	} else if ((diff > 0) && (wqe->mask & WR_ATOMIC_OR_READ_MASK)) {
-		return COMPST_ERROR_RETRY;
+		return COMPST_DONE;
 	} else {
 		return COMPST_CHECK_ACK;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
