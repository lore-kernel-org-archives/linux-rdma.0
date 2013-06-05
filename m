From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib_srpt: fix error return code in srpt_create_ch_ib() and srpt_cm_req_recv()
Date: Wed, 5 Jun 2013 10:17:54 +0800
Message-ID: <CAPgLHd-ZupR6bT6-gi8erzU3i7bVwdSGKYkZH_CbCbOqhtAcVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Fix to return a negative error code in some error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 3f3f041..1d9b019 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2144,6 +2144,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (IS_ERR(ch->thread)) {
 		printk(KERN_ERR "failed to create kernel thread %ld\n",
 		       PTR_ERR(ch->thread));
+		ret = PTR_ERR(ch->thread);
 		ch->thread = NULL;
 		goto err_destroy_qp;
 	}
@@ -2589,6 +2590,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		       " configured yet for initiator %s.\n", ch->sess_name);
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
+		ret = -ENOENT;
 		goto destroy_ib;
 	}
 
@@ -2597,6 +2599,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_debug("Failed to create session\n");
+		ret = PTR_ERR(ch->sess);
 		goto deregister_session;
 	}
 	ch->sess->se_node_acl = &nacl->nacl;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
