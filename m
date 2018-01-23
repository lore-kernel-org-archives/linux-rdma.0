From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next] RDMA/srpt: Fix RCU debug build error
Date: Tue, 23 Jan 2018 13:50:13 +0200
Message-ID: <20180123115013.12213-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Combination of CONFIG_DEBUG_OBJECTS_RCU_HEAD=y and
CONFIG_INFINIBAND_SRPT=m produces the following build error.

ERROR: "init_rcu_head" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
make: *** [Makefile:1216: modules] Error 2

The reason to it that init_rcu_head() is not exported and not supposed
to be used in modules. The correct function to use is init_rcu_head_on_stack().

Fixes: 795bc112cd5a ("IB/srpt: Make it safe to use RCU for srpt_device.rch_list")
Fixes: a11253142e6d ("IB/srpt: Rework multi-channel support")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index bf37816a1b12..65bbc3dbf0fd 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1950,7 +1950,7 @@ static struct srpt_nexus *srpt_get_nexus(struct srpt_port *sport,
 			nexus = ERR_PTR(-ENOMEM);
 			break;
 		}
-		init_rcu_head(&tmp_nexus->rcu);
+		init_rcu_head_on_stack(&tmp_nexus->rcu);
 		INIT_LIST_HEAD(&tmp_nexus->ch_list);
 		memcpy(tmp_nexus->i_port_id, i_port_id, 16);
 		memcpy(tmp_nexus->t_port_id, t_port_id, 16);
@@ -2110,7 +2110,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto reject;
 	}

-	init_rcu_head(&ch->rcu);
+	init_rcu_head_on_stack(&ch->rcu);
 	kref_init(&ch->kref);
 	ch->pkey = be16_to_cpu(pkey);
 	ch->nexus = nexus;
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
