From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/3] IB/srp: Report receive errors correctly
Date: Thu, 10 Oct 2013 13:53:25 +0200
Message-ID: <52569535.2060101@acm.org>
References: <5256941A.3040506@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5256941A.3040506-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The IB spec does not guarantee that the opcode is available in error
completions. Hence do not rely on it. See also commit 948d1e88
("IB/srp: Introduce srp_handle_qp_err()").

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.8
---
 drivers/infiniband/ulp/srp/ib_srp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 93a35a1..17b58f4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1303,14 +1303,13 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
-static void srp_handle_qp_err(enum ib_wc_status wc_status,
-			      enum ib_wc_opcode wc_opcode,
+static void srp_handle_qp_err(enum ib_wc_status wc_status, bool send_err,
 			      struct srp_target_port *target)
 {
 	if (target->connected && !target->qp_in_error) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "failed %s status %d\n",
-			     wc_opcode & IB_WC_RECV ? "receive" : "send",
+			     send_err ? "send" : "receive",
 			     wc_status);
 	}
 	target->qp_in_error = true;
@@ -1326,7 +1325,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 		if (likely(wc.status == IB_WC_SUCCESS)) {
 			srp_handle_recv(target, &wc);
 		} else {
-			srp_handle_qp_err(wc.status, wc.opcode, target);
+			srp_handle_qp_err(wc.status, false, target);
 		}
 	}
 }
@@ -1342,7 +1341,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
 			list_add(&iu->list, &target->free_tx);
 		} else {
-			srp_handle_qp_err(wc.status, wc.opcode, target);
+			srp_handle_qp_err(wc.status, true, target);
 		}
 	}
 }
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
