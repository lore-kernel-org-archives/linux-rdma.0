From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/2] IB/mad: Agent registration is process context only
Date: Fri,  8 Jun 2018 10:42:17 -0700
Message-ID: <20180608174218.32455-2-willy@infradead.org>
References: <20180608174218.32455-1-willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608174218.32455-1-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hans.westgaard.ry@oracle.com, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Pravin Shedge <pravin.shedge4linux@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Document this (it's implicitly true due to sleeping operations already
in use in both registration and deregistration).  Use this fact to use
spin_lock_irq instead of spin_lock_irqsave.  This improves performance
slightly.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/infiniband/core/mad.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index f742ae7a768b..68f4dda916c8 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -190,6 +190,8 @@ EXPORT_SYMBOL(ib_response_mad);
 
 /*
  * ib_register_mad_agent - Register to send/receive MADs
+ *
+ * Context: Process context.
  */
 struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					   u8 port_num,
@@ -210,7 +212,6 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	struct ib_mad_mgmt_vendor_class *vendor_class;
 	struct ib_mad_mgmt_method_table *method;
 	int ret2, qpn;
-	unsigned long flags;
 	u8 mgmt_class, vclass;
 
 	/* Validate parameters */
@@ -376,7 +377,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 		goto error4;
 	}
 
-	spin_lock_irqsave(&port_priv->reg_lock, flags);
+	spin_lock_irq(&port_priv->reg_lock);
 	mad_agent_priv->agent.hi_tid = atomic_inc_return(&ib_mad_client_id);
 
 	/*
@@ -422,11 +423,11 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 
 	/* Add mad agent into port's agent list */
 	list_add_tail(&mad_agent_priv->agent_list, &port_priv->agent_list);
-	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
+	spin_unlock_irq(&port_priv->reg_lock);
 
 	return &mad_agent_priv->agent;
 error5:
-	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
+	spin_unlock_irq(&port_priv->reg_lock);
 	ib_mad_agent_security_cleanup(&mad_agent_priv->agent);
 error4:
 	kfree(reg_req);
@@ -575,7 +576,6 @@ static inline void deref_snoop_agent(struct ib_mad_snoop_private *mad_snoop_priv
 static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 {
 	struct ib_mad_port_private *port_priv;
-	unsigned long flags;
 
 	/* Note that we could still be handling received MADs */
 
@@ -587,10 +587,10 @@ static void unregister_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 	port_priv = mad_agent_priv->qp_info->port_priv;
 	cancel_delayed_work(&mad_agent_priv->timed_work);
 
-	spin_lock_irqsave(&port_priv->reg_lock, flags);
+	spin_lock_irq(&port_priv->reg_lock);
 	remove_mad_reg_req(mad_agent_priv);
 	list_del(&mad_agent_priv->agent_list);
-	spin_unlock_irqrestore(&port_priv->reg_lock, flags);
+	spin_unlock_irq(&port_priv->reg_lock);
 
 	flush_workqueue(port_priv->wq);
 	ib_cancel_rmpp_recvs(mad_agent_priv);
@@ -625,6 +625,8 @@ static void unregister_mad_snoop(struct ib_mad_snoop_private *mad_snoop_priv)
 
 /*
  * ib_unregister_mad_agent - Unregisters a client from using MAD services
+ *
+ * Context: Process context.
  */
 void ib_unregister_mad_agent(struct ib_mad_agent *mad_agent)
 {
-- 
2.17.1
