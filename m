From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 2/2] IB/mad: Use IDR for agent IDs
Date: Fri,  8 Jun 2018 10:42:18 -0700
Message-ID: <20180608174218.32455-3-willy@infradead.org>
References: <20180608174218.32455-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608174218.32455-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Allocate agent IDs from a global IDR instead of an atomic variable.
This eliminates the possibility of reusing an ID which is already in
use after 4 billion registrations, and we can also limit the assigned
ID to be less than 2^24, which fixes a bug in the mlx4 device.

We look up the agent under protection of the RCU lock, which means we
have to free the agent using kfree_rcu, and only increment the reference
counter if it is not 0.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/infiniband/core/mad.c      | 78 ++++++++++++++++++------------
 drivers/infiniband/core/mad_priv.h |  7 +--
 include/linux/idr.h                |  9 ++++
 3 files changed, 59 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 68f4dda916c8..62384a3dd3ec 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -38,6 +38,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/dma-mapping.h>
+#include <linux/idr.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/security.h>
@@ -58,8 +59,8 @@ MODULE_PARM_DESC(send_queue_size, "Size of send queue in number of work requests
 module_param_named(recv_queue_size, mad_recvq_size, int, 0444);
 MODULE_PARM_DESC(recv_queue_size, "Size of receive queue in number of work requests");
 
+static DEFINE_IDR(ib_mad_clients);
 static struct list_head ib_mad_port_list;
-static atomic_t ib_mad_client_id = ATOMIC_INIT(0);
 
 /* Port list lock */
 static DEFINE_SPINLOCK(ib_mad_port_list_lock);
@@ -377,13 +378,24 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error4;
 	}
 
-	spin_lock_irq(&port_priv->reg_lock);
-	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
+	idr_preload(GFP_KERNEL);
+	idr_lock(&ib_mad_clients);
+	ret2 = idr_alloc_cyclic(&ib_mad_clients, mad_agent_priv, 0,
+			(1 << 24), GFP_ATOMIC);
+	idr_unlock(&ib_mad_clients);
+	idr_preload_end();
+
+	if (ret2 < 0) {
+		ret = ERR_PTR(ret2);
+		goto error5;
+	}
+	mad_agent_priv->agent.hi_tid = ret2;
 
 	/*
 	 * Make sure MAD registration (if supplied)
 	 * is non overlapping with any existing ones
 	 */
+	spin_lock_irq(&port_priv->reg_lock);
 	if (mad_reg_req) {
 		mgmt_class = convert_mgmt_class(mad_reg_req->mgmt_class);
 		if (!is_vendor_class(mgmt_class)) {
@@ -394,7 +406,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 				if (method) {
 					if (method_in_use(&method,
 							   mad_reg_req))
-						goto error5;
+						goto error6;
 				}
 			}
 			ret2 = add_nonoui_reg_req(mad_reg_req, mad_agent_priv,
@@ -410,24 +422,25 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					if (is_vendor_method_in_use(
 							vendor_class,
 							mad_reg_req))
-						goto error5;
+						goto error6;
 				}
 			}
 			ret2 = add_oui_reg_req(mad_reg_req, mad_agent_priv);
 		}
 		if (ret2) {
 			ret = ERR_PTR(ret2);
-			goto error5;
+			goto error6;
 		}
 	}
-
-	/* Add mad agent into port's agent list */
-	list_add_tail(&mad_agent_priv->agent_list, &port_priv->agent_list);
 	spin_unlock_irq(&port_priv->reg_lock);
 
 	return &mad_agent_priv->agent;
-error5:
+error6:
 	spin_unlock_irq(&port_priv->reg_lock);
+	idr_lock(&ib_mad_clients);
+	idr_remove(&ib_mad_clients, mad_agent_priv->agent.hi_tid);
+	idr_unlock(&ib_mad_clients);
+error5:
 	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
 error4:
 	kfree(reg_req);
@@ -589,8 +602,10 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 
 	spin_lock_irq(&port_priv->reg_lock);
 	remove_mad_reg_req(mad_agent_priv);
-	list_del(&mad_agent_priv->agent_list);
 	spin_unlock_irq(&port_priv->reg_lock);
+	idr_lock(&ib_mad_clients);
+	idr_remove(&ib_mad_clients, mad_agent_priv->agent.hi_tid);
+	idr_unlock(&ib_mad_clients);
 
 	flush_workqueue(port_priv->wq);
 	ib_cancel_rmpp_recvs(mad_agent_priv);
@@ -601,7 +616,7 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
 
 	kfree(mad_agent_priv->reg_req);
-	kfree(mad_agent_priv);
+	kfree_rcu(mad_agent_priv, rcu);
 }
 
 static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
@@ -1722,22 +1737,19 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 	struct ib_mad_agent_private *mad_agent = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&port_priv->reg_lock, flags);
 	if (ib_response_mad(mad_hdr)) {
 		u32 hi_tid;
-		struct ib_mad_agent_private *entry;
 
 		/*
 		 * Routing is based on high 32 bits of transaction ID
 		 * of MAD.
 		 */
 		hi_tid = be64_to_cpu(mad_hdr->tid) >> 32;
-		list_for_each_entry(entry, &port_priv->agent_list, agent_list) {
-			if (entry->agent.hi_tid == hi_tid) {
-				mad_agent = entry;
-				break;
-			}
-		}
+		rcu_read_lock();
+		mad_agent = idr_find(&ib_mad_clients, hi_tid);
+		if (mad_agent && !atomic_inc_not_zero(&mad_agent->refcount))
+			mad_agent = NULL;
+		rcu_read_unlock();
 	} else {
 		struct ib_mad_mgmt_class_table *class;
 		struct ib_mad_mgmt_method_table *method;
@@ -1746,6 +1758,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 		const struct ib_vendor_mad *vendor_mad;
 		int index;
 
+		spin_lock_irqsave(&port_priv->reg_lock, flags);
 		/*
 		 * Routing is based on version, class, and method
 		 * For "newer" vendor MADs, also based on OUI
@@ -1785,20 +1798,19 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 							  ~IB_MGMT_METHOD_RESP];
 			}
 		}
+		if (mad_agent)
+			atomic_inc(&mad_agent->refcount);
+out:
+		spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 	}
 
-	if (mad_agent) {
-		if (mad_agent->agent.recv_handler)
-			atomic_inc(&mad_agent->refcount);
-		else {
-			dev_notice(&port_priv->device->dev,
-				   "No receive handler for client %p on port %d\n",
-				   &mad_agent->agent, port_priv->port_num);
-			mad_agent = NULL;
-		}
+	if (mad_agent && !mad_agent->agent.recv_handler) {
+		dev_notice(&port_priv->device->dev,
+			   "No receive handler for client %p on port %d\n",
+			   &mad_agent->agent, port_priv->port_num);
+		deref_mad_agent(mad_agent);
+		mad_agent = NULL;
 	}
-out:
-	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
 
 	return mad_agent;
 }
@@ -3161,7 +3173,6 @@ static int ib_mad_port_open(struct ib_device *device,
 	port_priv->device = device;
 	port_priv->port_num = port_num;
 	spin_lock_init(&port_priv->reg_lock);
-	INIT_LIST_HEAD(&port_priv->agent_list);
 	init_mad_qp(port_priv, &port_priv->qp_info[0]);
 	init_mad_qp(port_priv, &port_priv->qp_info[1]);
 
@@ -3340,6 +3351,9 @@ int ib_mad_init(void)
 
 	INIT_LIST_HEAD(&ib_mad_port_list);
 
+	/* Client ID 0 is used for snoop-only clients */
+	idr_alloc(&ib_mad_clients, NULL, 0, 0, GFP_KERNEL);
+
 	if (ib_register_client(&mad_client)) {
 		pr_err("Couldn't register ib_mad client\n");
 		return -EINVAL;
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 28669f6419e1..d84ae1671898 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -89,7 +89,6 @@ struct ib_rmpp_segment {
 };
 
 struct ib_mad_agent_private {
-	struct list_head agent_list;
 	struct ib_mad_agent agent;
 	struct ib_mad_reg_req *reg_req;
 	struct ib_mad_qp_info *qp_info;
@@ -105,7 +104,10 @@ struct ib_mad_agent_private {
 	struct list_head rmpp_list;
 
 	atomic_t refcount;
-	struct completion comp;
+	union {
+		struct completion comp;
+		struct rcu_head rcu;
+	};
 };
 
 struct ib_mad_snoop_private {
@@ -203,7 +205,6 @@ struct ib_mad_port_private {
 
 	spinlock_t reg_lock;
 	struct ib_mad_mgmt_version_table version[MAX_MGMT_VERSION];
-	struct list_head agent_list;
 	struct workqueue_struct *wq;
 	struct ib_mad_qp_info qp_info[IB_MAD_QPS_CORE];
 };
diff --git a/include/linux/idr.h b/include/linux/idr.h
index e856f4e0ab35..bef0df8600e2 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -81,6 +81,15 @@ static inline void idr_set_cursor(struct idr *idr, unsigned int val)
 	WRITE_ONCE(idr->idr_next, val);
 }
 
+#define idr_lock(idr)		xa_lock(&(idr)->idr_rt)
+#define idr_unlock(idr)		xa_unlock(&(idr)->idr_rt)
+#define idr_lock_irq(idr)	xa_lock_irq(&(idr)->idr_rt)
+#define idr_unlock_irq(idr)	xa_unlock_irq(&(idr)->idr_rt)
+#define idr_lock_irqsave(idr, flags) \
+				xa_lock_irqsave(&(idr)->idr_rt, flags)
+#define idr_unlock_irqrestore(idr, flags) \
+				xa_unlock_irqrestore(&(idr)->idr_rt, flags)
+
 /**
  * DOC: idr sync
  * idr synchronization (stolen from radix-tree.h)
-- 
2.17.1
