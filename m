From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH rdma-core 2/2] srp_daemon: fix CQ handling
Date: Tue, 12 Dec 2017 15:08:24 +0100
Message-ID: <19c1241b-6a22-f8c2-32a2-6233f62cc39c@suse.com>
References: <05bbb67fea5e3cae535c0d9d21866cf8ad76f74f.1513087686.git.NMoreyChaisemartin@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <05bbb67fea5e3cae535c0d9d21866cf8ad76f74f.1513087686.git.NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

SM traps are polled through poll_cq which waited for a CQ event
before polling the CQ itself.
However it may happens that multiple completions are attached
to a single event. As stated by the ibv_get_cq_event man page,
it is required to poll the the CQ to get those completions
after the call to ibv_req_notify_cq.

As completions need to be handled one by one in an outer function,
start by polling the CQ and return the completion (if any) before
waiting for the next completion event.
This will allow emptying all pending completions, through multiple calls
to poll_cq,  before waiting for a new event.

The buggy use case seems to appear when the master SM is switched multiple
times between two nodes. As the number of ping-pong between the SMs increases,
the number of traps sent to notify that the SM just became master increases
too. This causes burst of completions linked to a single event.
Note that the race condition is also possible in other scenario.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v14, v15, v16
---
 srp_daemon/srp_handle_traps.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index 25f2b9ab..647e6a5e 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -496,6 +496,27 @@ static int stop_threads(struct sync_resources *sync_res)
 	return result;
 }
 
+static int poll_cq_once(struct sync_resources *sync_res, struct ibv_cq *cq,
+			struct ibv_wc *wc)
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
@@ -504,6 +525,14 @@ static int poll_cq(struct sync_resources *sync_res, struct ibv_cq *cq,
 	void          *ev_ctx;
 
 	if (channel) {
+		/* There may be extra completions that
+		 * were associated to the previous event.
+		 * Only poll for the first one. If there are more than one,
+		 * they will be handled by later call to poll_cq */
+		ret = poll_cq_once(sync_res, cq, wc);
+		if (ret)
+			return ret;
+
 		if (ibv_get_cq_event(channel, &ev_cq, &ev_ctx)) {
 			pr_err("Failed to get cq_event\n");
 			return -1;
@@ -524,18 +553,7 @@ static int poll_cq(struct sync_resources *sync_res, struct ibv_cq *cq,
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
