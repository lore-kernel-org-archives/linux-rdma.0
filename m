From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 03/15 ibacm] acm.c: Cosmetic formatting change to acm log
 message
Date: Fri, 21 Jun 2013 07:01:24 -0400
Message-ID: <51C43284.6010808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 src/acm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index e956b09..a124e93 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -1277,7 +1277,7 @@ static void acm_process_acm_recv(struct acm_ep *ep, struct ibv_wc *wc, struct ac
 	rec = (struct acm_resolve_rec *) mad->data;
 	acm_format_name(2, log_data, sizeof log_data,
 			rec->src_type, rec->src, sizeof rec->src);
-	acm_log(2, "src  %s\n", log_data);
+	acm_log(2, "src %s\n", log_data);
 	acm_format_name(2, log_data, sizeof log_data,
 			rec->dest_type, rec->dest, sizeof rec->dest);
 	acm_log(2, "dest %s\n", log_data);
@@ -2134,7 +2134,7 @@ acm_svr_resolve_dest(struct acm_client *client, struct acm_msg *msg)
 
 	acm_format_name(2, log_data, sizeof log_data,
 			saddr->type, saddr->info.addr, sizeof saddr->info.addr);
-	acm_log(2, "src  %s\n", log_data);
+	acm_log(2, "src %s\n", log_data);
 	ep = acm_get_ep(saddr);
 	if (!ep) {
 		acm_log(0, "notice - unknown local end point\n");
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
