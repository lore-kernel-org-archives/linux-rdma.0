From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH] register_to_trap(): Increase number of iterations from 3 to 5
Date: Fri,  8 Dec 2017 09:22:37 -0800
Message-ID: <20171208172237.312-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Master SM changes can take more than three seconds. Hence increase
the time during which to wait for a master SM to appear from 3 to 5
seconds.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
---
 srp_daemon/srp_handle_traps.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/srp_daemon/srp_handle_traps.c b/srp_daemon/srp_handle_traps.c
index 6d94634ef6df..dda746a5c69d 100644
--- a/srp_daemon/srp_handle_traps.c
+++ b/srp_daemon/srp_handle_traps.c
@@ -550,8 +550,8 @@ static int register_to_trap(struct sync_resources *sync_res,
 	struct ibv_sge sg;
 	struct ibv_send_wr *_bad_wr = NULL;
 	struct ibv_send_wr **bad_wr = &_bad_wr;
-	int counter = 0;
-	int rc = 0;
+	int counter;
+	int rc;
 	int ret;
 	long long unsigned comp_mask = 0;
 
@@ -609,7 +609,7 @@ static int register_to_trap(struct sync_resources *sync_res,
 	p_sa_mad->comp_mask = htobe64(comp_mask);
 	pr_debug("comp_mask: %llx\n", comp_mask);
 
-	do {
+	for (counter = 5, rc = 0; counter > 0 && rc == 0; counter--) {
 		pthread_mutex_lock(res->mad_buffer_mutex);
 		res->mad_buffer->mad_hdr.base_version = 0; // flag that the buffer is empty
 		pthread_mutex_unlock(res->mad_buffer_mutex);
@@ -640,10 +640,9 @@ static int register_to_trap(struct sync_resources *sync_res,
 			}
 			pthread_mutex_unlock(res->mad_buffer_mutex);
 		} while (rc == 2); // while old response.
+	}
 
-	} while (rc == 0 && ++counter < 3);
-
-	if (counter==3) {
+	if (counter == 0) {
 		pr_err("No response to inform info registration\n");
 		return -EAGAIN;
 	}
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
