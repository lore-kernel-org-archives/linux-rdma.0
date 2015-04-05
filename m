From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 12/16] ib_srpt: fix error return code
Date: Sun,  5 Apr 2015 14:06:32 +0200
Message-ID: <1428235596-4757-13-git-send-email-Julia.Lawall@lip6.fr>
References: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: kernel-janitors@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

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

In the first case, the printk is changed to use the ret value, rather
than duplicating PTR_ERR(ch->thread).  This requires changing the format
from %ld to %d, to account for the type of ret.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6e0a477..5ec98f5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2143,8 +2143,8 @@ retry:
 
 	ch->thread = kthread_run(srpt_compl_thread, ch, "ib_srpt_compl");
 	if (IS_ERR(ch->thread)) {
-		printk(KERN_ERR "failed to create kernel thread %ld\n",
-		       PTR_ERR(ch->thread));
+		ret = PTR_ERR(ch->thread);
+		printk(KERN_ERR "failed to create kernel thread %d\n", ret);
 		ch->thread = NULL;
 		goto err_destroy_qp;
 	}
@@ -2590,6 +2590,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		       " configured yet for initiator %s.\n", ch->sess_name);
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
+		ret = -EINVAL;
 		goto destroy_ib;
 	}
 
@@ -2598,6 +2599,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_debug("Failed to create session\n");
+		ret = PTR_ERR(ch->sess);
 		goto deregister_session;
 	}
 	ch->sess->se_node_acl = &nacl->nacl;
