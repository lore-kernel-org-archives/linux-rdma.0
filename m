From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 15/15] IB/srpt: Fix a rare crash in srpt_close_session()
Date: Tue, 5 Jan 2016 15:27:45 +0100
Message-ID: <568BD2E1.1060701@sandisk.com>
References: <568BD0FC.70207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <568BD0FC.70207-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Keep the ib_srpt session as long as srpt_close_session() may
access it.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 669ae5c..7548bd5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2228,6 +2228,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	pr_debug("Establish connection sess=%p name=%s cm_id=%p\n", ch->sess,
 		 ch->sess_name, ch->cm_id);
 
+	kref_get(&ch->kref);
+
 	/* create srp_login_response */
 	rsp->opcode = SRP_LOGIN_RSP;
 	rsp->tag = req->tag;
@@ -2991,6 +2993,8 @@ static void srpt_close_session(struct se_session *se_sess)
 
 	srpt_disconnect_ch(ch);
 
+	kref_put(&ch->kref, srpt_free_ch);
+
 	if (!wait)
 		return;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
