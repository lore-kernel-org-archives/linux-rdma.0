From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [RFC rdma-core 2/2] srp_daemon: fix CQ handling
Date: Mon, 11 Dec 2017 15:46:00 +0100
Message-ID: <f35bfdad-9027-d2be-9706-b5a0edd9a778@suse.com>
References: <82dc0912-3ac3-9548-2c3b-703c6e1c9c95@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <82dc0912-3ac3-9548-2c3b-703c6e1c9c95-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SM traps are polled through poll_cq which waited for a CQ event
before polling the CQ itself.
However it may happens that multiple completions are attached
to a single event. As stated by the ibv_get_cq_event, it is required
to poll the the CQ to get those event after the call to
ibv_req_notify_cq.

As completion need to be handled one by one in an outer function,
start by polling the CQ and return the event (if any) before waiting
for the next completion event.

The buggy use case seem to appear when the master SM is switched multiple
times between two nodes. As the number of ping-pong between the SM increases,
the number of traps sent to notify that the SM just became master increases
too. This causes burst of completions linked to a single event.
Note that the race condition is also possible in other scenario.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 srp_daemon/srp_handle_traps.c | 40 ++++++++++++++++++++++++++++------------

This patch goes on top of the one proposed in the thread.

 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index b1d051c6..eaa57979 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -496,6 +496,27 @@ static int stop_threads(struct sync_resources *sync_res)
 	return result;
 }
 
+tatic int poll_cq_once(struct sync_resources *sync_res, struct ibv_cq *cq,
+           struct ibv_wc *wc)
+{
+	int ret;
+	ret = ibv_poll_cq(cq, 1, wc);
+	if (ret < 0) {
+		pr_err("poll CQ failed\n");
+		return ret;
+	}
+
+	if (ret > 0 && wc->status != IBV_WC_SUCCESS) {
+		if (!stop_threads(sync_res))
+			pr_err("got bad completion with status: 0x%x\n",
+			       wc->status);
+		return -ret;
+	}
+
+	return ret;
+}
+
+
 static int poll_cq(struct sync_resources *sync_res, struct ibv_cq *cq,
 		   struct ibv_wc *wc, struct ibv_comp_channel *channel)
 {
@@ -504,6 +525,12 @@ static int poll_cq(struct sync_resources *sync_res, struct ibv_cq *cq,
 	void          *ev_ctx;
 
 	if (channel) {
+		/* Poll CQ once. There may be extra completion that
+		 * were associated to the previous event */
+		ret = poll_cq_once(sync_res, cq, wc);
+		if (ret)
+			return ret;
+
 		if (ibv_get_cq_event(channel, &ev_cq, &ev_ctx)) {
 			pr_err("Failed to get cq_event\n");
 			return -1;
@@ -524,18 +551,7 @@ static int poll_cq(struct sync_resources *sync_res, struct ibv_cq *cq,
 	}
 
 	do {
-		ret = ibv_poll_cq(cq, 1, wc);
-		if (ret < 0) {
-			pr_err("poll CQ failed\n");
-			return ret;
-		}
-
-		if (ret > 0 && wc->status != IBV_WC_SUCCESS) {
-			if (!stop_threads(sync_res))
-				pr_err("got bad completion with status: 0x%x\n",
-				       wc->status);
-			return -ret;
-		}
+		ret = poll_cq_once(sync_res, cq, wc);
 
 		if (ret == 0 && channel) {
 			pr_err("Weird poll returned no cqe after CQ event\n");
-- 
2.15.1.272.g8e603414b

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
