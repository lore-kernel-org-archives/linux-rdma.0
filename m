From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] XRC - Sample application issues
Date: Thu,  8 Aug 2013 18:05:36 +0300
Message-ID: <1375974336-26314-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jay.e.sternberg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix sync issue when clients go down, it comes to prevent a case when
client misses a response from the daemon then wait forever.

Fix typo in error message.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

This patch is on top of V9 of XRC series that was already sent.
It should be squashed into latest patch #7 named 'Add XRC sample application'.

Jay, Sean - please review.


 examples/xsrq_pingpong.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/examples/xsrq_pingpong.c b/examples/xsrq_pingpong.c
index 984740d..aceef2e 100644
--- a/examples/xsrq_pingpong.c
+++ b/examples/xsrq_pingpong.c
@@ -376,7 +376,7 @@ static int connect_qps(int index)
 			  IBV_QP_STATE | IBV_QP_AV | IBV_QP_PATH_MTU |
 			  IBV_QP_DEST_QPN | IBV_QP_RQ_PSN |
 			  IBV_QP_MAX_DEST_RD_ATOMIC | IBV_QP_MIN_RNR_TIMER)) {
-		fprintf(stderr, "Failed to modify send QP[%d] to RTR\n", index);
+		fprintf(stderr, "Failed to modify recv QP[%d] to RTR\n", index);
 		return 1;
 	}
 
@@ -884,6 +884,13 @@ int main(int argc, char *argv[])
 	if (ctx.use_event)
 		ibv_ack_cq_events(ctx.recv_cq, num_cq_events);
 
+	/* Process should wait before closing its resources to make sure
+	  * latest daemon's response sent via its target QP destined to an XSRQ
+	  * created by another client won't be lost.
+	  * Failure to do so will cause the client to wait for that sent message forever.
+	  * See comment on pp_post_send.
+	*/
+	sleep(1);
 	if (pp_close_ctx())
 		return 1;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
