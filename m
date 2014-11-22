From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/6] ib_srpt: fix error return code
Date: Sat, 22 Nov 2014 15:39:18 +0100
Message-ID: <1416667159-9808-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416667159-9808-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7206547..cbfdce7 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2135,8 +2135,8 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 
 	ch->thread = kthread_run(srpt_compl_thread, ch, "ib_srpt_compl");
 	if (IS_ERR(ch->thread)) {
-		printk(KERN_ERR "failed to create kernel thread %ld\n",
-		       PTR_ERR(ch->thread));
+		ret = PTR_ERR(ch->thread);
+		printk(KERN_ERR "failed to create kernel thread %ld\n", ret);
 		ch->thread = NULL;
 		goto err_destroy_qp;
 	}
@@ -2580,6 +2580,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	if (!nacl) {
 		printk(KERN_INFO "Rejected login because no ACL has been"
 		       " configured yet for initiator %s.\n", ch->sess_name);
+		ret = -EINVAL;
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
 		goto destroy_ib;
@@ -2590,6 +2591,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_debug("Failed to create session\n");
+		ret = PTR_ERR(ch->sess);
 		goto deregister_session;
 	}
 	ch->sess->se_node_acl = &nacl->nacl;
