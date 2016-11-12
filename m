From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH, RESEND] IB/srpt: Report login failures only once
Date: Fri, 11 Nov 2016 16:36:06 -0800
Message-ID: <7737d8fc-d41d-0755-d7d2-a3a2b9b6a76e@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Report the following message only once if no ACL has been configured
yet for an initiator port:

"Rejected login because no ACL has been configured yet for initiator %s.\n"

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b268aaa..0951e4f 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1842,7 +1842,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srpt_rdma_ch *ch, *tmp_ch;
 	u32 it_iu_len;
 	int i, ret = 0;
-	unsigned char *p;
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -1996,21 +1995,18 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
 
 	pr_debug("registering session %s\n", ch->sess_name);
-	p = &ch->sess_name[0];
 
-try_again:
 	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
-					TARGET_PROT_NORMAL, p, ch, NULL);
+					TARGET_PROT_NORMAL, ch->sess_name, ch,
+					NULL);
+	/* Retry without leading "0x" */
+	if (IS_ERR(ch->sess))
+		ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+						TARGET_PROT_NORMAL,
+						ch->sess_name + 2, ch, NULL);
 	if (IS_ERR(ch->sess)) {
-		pr_info("Rejected login because no ACL has been"
-			" configured yet for initiator %s.\n", p);
-		/*
-		 * XXX: Hack to retry of ch->i_port_id without leading '0x'
-		 */
-		if (p == &ch->sess_name[0]) {
-			p += 2;
-			goto try_again;
-		}
+		pr_info("Rejected login because no ACL has been configured yet for initiator %s.\n",
+			ch->sess_name);
 		rej->reason = cpu_to_be32((PTR_ERR(ch->sess) == -ENOMEM) ?
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES :
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
-- 
2.10.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
