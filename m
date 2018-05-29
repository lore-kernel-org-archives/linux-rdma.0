From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: [PATCH] IB/mad: Use ID allocator routines to allocate agent number
Date: Tue, 29 May 2018 09:38:08 +0200
Message-ID: <20180529073808.27735-1-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Daniel Jurgens <danielj@mellanox.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The agent TID is a 64 bit value split in two dwords.  The least
significant dword is the TID running counter. The most significant
dword is the agent number. In the CX-3 shared port model, the mlx4
driver uses the most significant byte of the agent number to store the
slave number, making agent numbers greater and equal to 2^24 (3 bytes)
unusable.  The current codebase uses a variable which is incremented
atomically for each new agent number giving too large agent numbers
over time.  The IDA set of functions are used instead of the simple
counter approach. This allows re-use of agent numbers. A sysctl
variable is also introduced, to control the max agent number.

The signature of the bug is a MAD layer that stops working and the
console is flooded with messages like:
 mlx4_ib: egress mad has non-null tid msb:1 class:4 slave:0

Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>

---
 drivers/infiniband/core/mad.c | 50 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b28452a55a08..adce6cd5fc41 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -41,6 +41,8 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/security.h>
+#include <linux/idr.h>
+#include <linux/sysctl.h>
 #include <rdma/ib_cache.h>
 
 #include "mad_priv.h"
@@ -57,9 +59,27 @@ module_param_named(send_queue_size, mad_sendq_size, int, 0444);
 MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests");
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
+/* Sysctl variable to set largest mad agent number */
+static u32 ib_mad_sysctl_min_client_id_max;
+static u32 ib_mad_sysctl_max_client_id_max;
+static u32 ib_mad_sysctl_client_id_max;
+static struct ctl_table_header *ib_mad_sysctl_hdr;
+
+static struct ctl_table ib_mad_sysctl_table[] = {
+	{
+		.procname       = "client_id_max",
+		.data           = &ib_mad_sysctl_client_id_max,
+		.maxlen         = sizeof(ib_mad_sysctl_client_id_max),
+		.mode           = 0644,
+		.proc_handler   = &proc_douintvec_minmax,
+		.extra1         = &ib_mad_sysctl_min_client_id_max,
+		.extra2         = &ib_mad_sysctl_max_client_id_max,
+	},
+	{ }
+};
 
 static struct list_head ib_mad_port_list;
-static atomic_t ib_mad_client_id = ATOMIC_INIT(0);
+DEFINE_IDA(ib_mad_client_ids);
 
 /* Port list lock */
 static DEFINE_SPINLOCK(ib_mad_port_list_lock);
@@ -212,6 +232,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	int ret2, qpn;
 	unsigned long flags;
 	u8 mgmt_class, vclass;
+	u32 ib_mad_client_id;
 
 	/* Validate parameters */
 	qpn = get_spl_qp_index(qp_type);
@@ -376,8 +397,18 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error4;
 	}
 
+	ib_mad_client_id = ida_simple_get(&ib_mad_client_ids,
+					  0,
+					  ib_mad_sysctl_client_id_max,
+					  GFP_KERNEL);
+	if (ib_mad_client_id < 0) {
+		pr_err("Couldn't allocate agent tid; errcode: %#x\n",
+		       ib_mad_client_id);
+		ret = ERR_PTR(ib_mad_client_id);
+		goto error4;
+	}
+	mad_agent_priv->agent.hi_tid = ib_mad_client_id;
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
-	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
 
 	/*
 	 * Make sure MAD registration (if supplied)
@@ -428,6 +459,8 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 error5:
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
+	ida_simple_remove(&ib_mad_client_ids, ib_mad_client_id);
+
 error4:
 	kfree(reg_req);
 error3:
@@ -588,6 +621,7 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	cancel_delayed_work(&mad_agent_priv->timed_work);
 
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
+	ida_simple_remove(&ib_mad_client_ids, mad_agent_priv->agent.hi_tid);
 	remove_mad_reg_req(mad_agent_priv);
 	list_del(&mad_agent_priv->agent_list);
 	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
@@ -3341,10 +3375,22 @@ int ib_mad_init(void)
 		return -EINVAL;
 	}
 
+	ib_mad_sysctl_min_client_id_max = 1 << 10;
+	ib_mad_sysctl_max_client_id_max = 1 << 23;
+	ib_mad_sysctl_client_id_max     = 1 << 18;
+	ib_mad_sysctl_hdr = register_net_sysctl(&init_net, "net/ibmad",
+						ib_mad_sysctl_table);
+	if (!ib_mad_sysctl_hdr) {
+		pr_err("%s: register_net_sysctl failed\n",  __func__);
+		ib_mad_cleanup();
+		return -EINVAL;
+	}
 	return 0;
 }
 
 void ib_mad_cleanup(void)
 {
 	ib_unregister_client(&mad_client);
+	ida_destroy(&ib_mad_client_ids);
+	unregister_net_sysctl_table(ib_mad_sysctl_hdr);
 }
-- 
2.13.6
