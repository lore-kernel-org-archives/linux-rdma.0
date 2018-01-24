From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v1] RDMA/srpt: Fix RCU debug build error
Date: Wed, 24 Jan 2018 08:56:05 +0200
Message-ID: <20180124065605.19310-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Combination of CONFIG_DEBUG_OBJECTS_RCU_HEAD=y and
CONFIG_INFINIBAND_SRPT=m produces the following build error.

ERROR: "init_rcu_head" [drivers/infiniband/ulp/srpt/ib_srpt.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
make: *** [Makefile:1216: modules] Error 2

The reason to it that init_rcu_head() is not exported and not supposed
to be used in modules. It is needed for dynamic initialization of
statically allocated rcu_head structures.

Fixes: 795bc112cd5a ("IB/srpt: Make it safe to use RCU for srpt_device.rch_list")
Fixes: a11253142e6d ("IB/srpt: Rework multi-channel support")
Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changelog:
 v0->v1:
  * Added Bart's SOB.
  * Updated commit message.
  * Removed init_rcu_head() from srpt code.
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index bf37816a1b12..0373b7c40902 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1950,7 +1950,6 @@ static struct srpt_nexus *srpt_get_nexus(struct srpt_port *sport,
 			nexus = ERR_PTR(-ENOMEM);
 			break;
 		}
-		init_rcu_head(&tmp_nexus->rcu);
 		INIT_LIST_HEAD(&tmp_nexus->ch_list);
 		memcpy(tmp_nexus->i_port_id, i_port_id, 16);
 		memcpy(tmp_nexus->t_port_id, t_port_id, 16);
@@ -2110,7 +2109,6 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto reject;
 	}

-	init_rcu_head(&ch->rcu);
 	kref_init(&ch->kref);
 	ch->pkey = be16_to_cpu(pkey);
 	ch->nexus = nexus;
--
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
