From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/4] IB/srpt: Report login failures only once
Date: Wed, 6 Apr 2016 11:57:03 -0700
Message-ID: <57055BFF.9060607@sandisk.com>
References: <57055BC6.7070402@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <57055BC6.7070402@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Report the following message only once if no ACL has been configured
yet for an initiator port:

"Rejected login because no ACL has been configured yet for initiator %s.\n"

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3b425af..07dfc50 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2028,7 +2028,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srpt_rdma_ch *ch, *tmp_ch;
 	u32 it_iu_len;
 	int i, ret = 0;
-	unsigned char *p;
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -2182,21 +2181,18 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
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
2.7.4
