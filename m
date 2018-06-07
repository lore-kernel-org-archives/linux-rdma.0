From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH v3 2/2] IB/mad: Use ID allocator routines to allocate agent number
Date: Thu,  7 Jun 2018 13:14:35 +0200
Message-ID: <20180607111435.17538-3-hans.westgaard.ry@oracle.com>
References: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
 <20180607111435.17538-1-hans.westgaard.ry@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180607111435.17538-1-hans.westgaard.ry@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, Matthew Wilcox <mawilcox@microsoft.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Wei Wang <wei.w.wang@intel.com>, Chris Mi <chrism@mellanox.com>, Eric Biggers <ebiggers@google.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mel Gorman <mgorman@techsingularity.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The agent TID is a 64 bit value split in two dwords.  The least
significant dword is the TID running counter. The most significant
dword is the agent number. In the CX-3 shared port model, the mlx4
driver uses the most significant byte of the agent number to store the
slave number, making agent numbers greater and equal to 2^24 (3 bytes)
unusable.  The current codebase uses a variable which is incremented
atomically for each new agent number giving too large agent numbers
over time.  The IDA set of functions are used instead of the simple
counter approach. This allows re-use of agent numbers.

The signature of the bug is a MAD layer that stops working and the
console is flooded with messages like:
 mlx4_ib: egress mad has non-null tid msb:1 class:4 slave:0

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
---
 drivers/infiniband/core/mad.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b28452a55a08..c01a2d63ffa2 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/security.h>
+#include <linux/idr.h>
 #include <rdma/ib_cache.h>
 
 #include "mad_priv.h"
@@ -59,8 +60,7 @@ module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
 static struct list_head ib_mad_port_list;
-static atomic_t ib_mad_client_id = ATOMIC_INIT(0);
-
+static DEFINE_IDA(ib_mad_client_ids);
 /* Port list lock */
 static DEFINE_SPINLOCK(ib_mad_port_list_lock);
 
@@ -212,7 +212,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	int ret2, qpn;
 	unsigned long flags;
 	u8 mgmt_class, vclass;
-
+	u32 ib_mad_client_id;
 	/* Validate parameters */
 	qpn = get_spl_qp_index(qp_type);
 	if (qpn == -1) {
@@ -375,9 +375,19 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		ret = ERR_PTR(ret2);
 		goto error4;
 	}
+	ib_mad_client_id = ida_simple_get_cyclic(&ib_mad_client_ids,
+						1,
+						BIT(24) - 1,
+						GFP_KERNEL);
+	if (ib_mad_client_id < 0) {
+		pr_err("Couldn't allocate agent tid; errcode: %#x\n",
+			ib_mad_client_id);
+		ret = ERR_PTR(ib_mad_client_id);
+		goto error4;
+	}
+	mad_agent_priv->agent.hi_tid = ib_mad_client_id;
 
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
-	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
 
 	/*
 	 * Make sure MAD registration (if supplied)
@@ -428,6 +438,8 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 error5:
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
+	ida_simple_remove(&ib_mad_client_ids, ib_mad_client_id);
+
 error4:
 	kfree(reg_req);
 error3:
@@ -576,6 +588,7 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 {
 	struct ib_mad_port_private *port_priv;
 	unsigned long flags;
+	u32 ib_mad_client_id;
 
 	/* Note that we could still be handling received MADs */
 
@@ -587,6 +600,8 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	port_priv = mad_agent_priv->qp_info->port_priv;
 	cancel_delayed_work(&mad_agent_priv->timed_work);
 
+	ib_mad_client_id = mad_agent_priv->agent.hi_tid;
+
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
 	remove_mad_reg_req(mad_agent_priv);
 	list_del(&mad_agent_priv->agent_list);
@@ -602,6 +617,7 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 
 	kfree(mad_agent_priv->reg_req);
 	kfree(mad_agent_priv);
+	ida_simple_remove(&ib_mad_client_ids, ib_mad_client_id);
 }
 
 static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
@@ -3347,4 +3363,5 @@ int ib_mad_init(void)
 void ib_mad_cleanup(void)
 {
 	ib_unregister_client(&mad_client);
+	ida_destroy(&ib_mad_client_ids);
 }
-- 
2.14.3
