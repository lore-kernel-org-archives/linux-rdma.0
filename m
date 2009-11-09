From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/6]  SRP disconnects connection without wait
Date: Mon, 09 Nov 2009 13:31:58 -0800
Message-ID: <4AF88A4E.4040307@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020002020809050008030107"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020002020809050008030107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Disconnect the connection without waiting (1 << max(timeout -8),0) ms

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--------------020002020809050008030107
Content-Type: text/plain;
 name="srp_2_disconnect_without_wait.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_2_disconnect_without_wait.patch"

 drivers/infiniband/ulp/srp/ib_srp.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..dfa14de 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -415,13 +415,11 @@ static void srp_disconnect_target(struct srp_target_port *target)
 {
 	/* XXX should send SRP_I_LOGOUT request */
 
-	init_completion(&target->done);
 	if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
 		shost_printk(KERN_DEBUG, target->scsi_host,
 			     PFX "Sending CM DREQ failed\n");
 		return;
 	}
-	wait_for_completion(&target->done);
 }
 
 static void srp_remove_work(struct work_struct *work)
@@ -1301,7 +1299,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
-		comp = 1;
 		target->status = 0;
 		break;
 

--------------020002020809050008030107--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
