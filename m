From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/5] ib/mad: add new ioctl to user space to support new registration options
Date: Mon,  5 May 2014 21:44:49 -0400
Message-ID: <1399340690-27677-5-git-send-email-ira.weiny@intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399340690-27677-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Registrations options are specified through flags.  Definitions of flags will
be in subsequent patches.

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/infiniband/user_mad.txt   |  13 ++--
 drivers/infiniband/core/agent.c         |   4 +-
 drivers/infiniband/core/cm.c            |   5 +-
 drivers/infiniband/core/mad.c           |   4 +-
 drivers/infiniband/core/sa_query.c      |   2 +-
 drivers/infiniband/core/user_mad.c      | 107 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mad.c        |   2 +-
 drivers/infiniband/hw/mthca/mthca_mad.c |   2 +-
 drivers/infiniband/hw/qib/qib_mad.c     |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   |   2 +-
 include/rdma/ib_mad.h                   |   7 ++-
 include/uapi/rdma/ib_user_mad.h         |  38 ++++++++++++
 12 files changed, 172 insertions(+), 16 deletions(-)

diff --git a/Documentation/infiniband/user_mad.txt b/Documentation/infiniband/user_mad.txt
index 8a36695..bf24958 100644
--- a/Documentation/infiniband/user_mad.txt
+++ b/Documentation/infiniband/user_mad.txt
@@ -26,6 +26,11 @@ Creating MAD agents
   ioctl.  Also, all agents registered through a file descriptor will
   be unregistered when the descriptor is closed.
 
+  2013 -- a new registration ioctl is now provided which allows additional
+       fields to be provided during registration.
+       Users of this registration call are implicitly setting the use of
+       pkey_index (see below).
+
 Receiving MADs
 
   MADs are received using read().  The receive side now supports
@@ -104,10 +109,10 @@ P_Key Index Handling
   The old ib_umad interface did not allow setting the P_Key index for
   MADs that are sent and did not provide a way for obtaining the P_Key
   index of received MADs.  A new layout for struct ib_user_mad_hdr
-  with a pkey_index member has been defined; however, to preserve
-  binary compatibility with older applications, this new layout will
-  not be used unless the IB_USER_MAD_ENABLE_PKEY ioctl is called
-  before a file descriptor is used for anything else.
+  with a pkey_index member has been defined; however, to preserve binary
+  compatibility with older applications, this new layout will not be used
+  unless one of IB_USER_MAD_ENABLE_PKEY or IB_USER_MAD_REGISTER_AGENT2 ioctl's
+  are called before a file descriptor is used for anything else.
 
   In September 2008, the IB_USER_MAD_ABI_VERSION will be incremented
   to 6, the new layout of struct ib_user_mad_hdr will be used by
diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index e1f08b4..bed8ee4 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -163,7 +163,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 		port_priv->agent[0] = ib_register_mad_agent(device, port_num,
 							    IB_QPT_SMI, NULL, 0,
 							    &agent_send_handler,
-							    NULL, NULL);
+							    NULL, NULL, 0);
 		if (IS_ERR(port_priv->agent[0])) {
 			ret = PTR_ERR(port_priv->agent[0]);
 			goto error2;
@@ -174,7 +174,7 @@ int ib_agent_port_open(struct ib_device *device, int port_num)
 	port_priv->agent[1] = ib_register_mad_agent(device, port_num,
 						    IB_QPT_GSI, NULL, 0,
 						    &agent_send_handler,
-						    NULL, NULL);
+						    NULL, NULL, 0);
 	if (IS_ERR(port_priv->agent[1])) {
 		ret = PTR_ERR(port_priv->agent[1]);
 		goto error3;
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c323917..e28a494 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3753,7 +3753,7 @@ static void cm_add_one(struct ib_device *ib_device)
 	struct cm_port *port;
 	struct ib_mad_reg_req reg_req = {
 		.mgmt_class = IB_MGMT_CLASS_CM,
-		.mgmt_class_version = IB_CM_CLASS_VERSION
+		.mgmt_class_version = IB_CM_CLASS_VERSION,
 	};
 	struct ib_port_modify port_modify = {
 		.set_port_cap_mask = IB_PORT_CM_SUP
@@ -3801,7 +3801,8 @@ static void cm_add_one(struct ib_device *ib_device)
 							0,
 							cm_send_handler,
 							cm_recv_handler,
-							port);
+							port,
+							0);
 		if (IS_ERR(port->mad_agent))
 			goto error2;
 
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index c48e9a8..a26baa9 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -198,7 +198,8 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					   u8 rmpp_version,
 					   ib_mad_send_handler send_handler,
 					   ib_mad_recv_handler recv_handler,
-					   void *context)
+					   void *context,
+					   u32 registration_flags)
 {
 	struct ib_mad_port_private *port_priv;
 	struct ib_mad_agent *ret = ERR_PTR(-EINVAL);
@@ -348,6 +349,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	mad_agent_priv->agent.context = context;
 	mad_agent_priv->agent.qp = port_priv->qp_info[qpn].qp;
 	mad_agent_priv->agent.port_num = port_num;
+	mad_agent_priv->agent.flags = registration_flags;
 	spin_lock_init(&mad_agent_priv->lock);
 	INIT_LIST_HEAD(&mad_agent_priv->send_list);
 	INIT_LIST_HEAD(&mad_agent_priv->wait_list);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index f820958..d079bc5 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1184,7 +1184,7 @@ static void ib_sa_add_one(struct ib_device *device)
 		sa_dev->port[i].agent =
 			ib_register_mad_agent(device, i + s, IB_QPT_GSI,
 					      NULL, 0, send_handler,
-					      recv_handler, sa_dev);
+					      recv_handler, sa_dev, 0);
 		if (IS_ERR(sa_dev->port[i].agent))
 			goto err;
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 1341282..571e9d8b 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -640,6 +640,7 @@ static int ib_umad_reg_agent(struct ib_umad_file *file, void __user *arg,
 
 found:
 	if (ureq.mgmt_class) {
+		memset(&req, 0, sizeof(req));
 		req.mgmt_class         = ureq.mgmt_class;
 		req.mgmt_class_version = ureq.mgmt_class_version;
 		memcpy(req.oui, ureq.oui, sizeof req.oui);
@@ -660,7 +661,7 @@ found:
 				      ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
 				      ureq.mgmt_class ? &req : NULL,
 				      ureq.rmpp_version,
-				      send_handler, recv_handler, file);
+				      send_handler, recv_handler, file, 0);
 	if (IS_ERR(agent)) {
 		ret = PTR_ERR(agent);
 		agent = NULL;
@@ -696,6 +697,106 @@ out:
 	return ret;
 }
 
+static int ib_umad_reg_agent2(struct ib_umad_file *file, void __user *arg)
+{
+	struct ib_user_mad_reg_req2 ureq;
+	struct ib_mad_reg_req req;
+	struct ib_mad_agent *agent = NULL;
+	int agent_id;
+	int ret;
+
+	mutex_lock(&file->port->file_mutex);
+	mutex_lock(&file->mutex);
+
+	if (!file->port->ib_dev) {
+		pr_notice("ib_umad_reg_agent2: invalid device\n");
+		ret = -EPIPE;
+		goto out;
+	}
+
+	if (copy_from_user(&ureq, arg, sizeof(ureq))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (ureq.qpn != 0 && ureq.qpn != 1) {
+		pr_notice("ib_umad_reg_agent2: invalid QPN %d specified\n",
+			ureq.qpn);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (ureq.flags & ~IB_USER_MAD_REG_FLAGS_CAP) {
+		pr_notice("ib_umad_reg_agent2 failed: invalid registration flags specified 0x%x; supported 0x%x\n",
+			ureq.flags, IB_USER_MAD_REG_FLAGS_CAP);
+		ret = -EINVAL;
+
+		if (put_user((u32)IB_USER_MAD_REG_FLAGS_CAP,
+				(u32 __user *) (arg + offsetof(struct
+				ib_user_mad_reg_req2, flags))))
+			ret = -EFAULT;
+
+		goto out;
+	}
+
+	for (agent_id = 0; agent_id < IB_UMAD_MAX_AGENTS; ++agent_id)
+		if (!__get_agent(file, agent_id))
+			goto found;
+
+	pr_notice("ib_umad_reg_agent2: Max Agents (%u) reached\n",
+		IB_UMAD_MAX_AGENTS);
+	ret = -ENOMEM;
+	goto out;
+
+found:
+	if (ureq.mgmt_class) {
+		memset(&req, 0, sizeof(req));
+		req.mgmt_class         = ureq.mgmt_class;
+		req.mgmt_class_version = ureq.mgmt_class_version;
+		memcpy(req.oui, ureq.oui, sizeof(req.oui));
+		memcpy(req.method_mask, ureq.method_mask,
+			sizeof(req.method_mask));
+	}
+
+	agent = ib_register_mad_agent(file->port->ib_dev, file->port->port_num,
+				      ureq.qpn ? IB_QPT_GSI : IB_QPT_SMI,
+				      ureq.mgmt_class ? &req : NULL,
+				      ureq.rmpp_version,
+				      send_handler, recv_handler, file,
+				      ureq.flags);
+	if (IS_ERR(agent)) {
+		ret = PTR_ERR(agent);
+		agent = NULL;
+		goto out;
+	}
+
+	if (put_user(agent_id,
+		     (u32 __user *)(arg +
+				offsetof(struct ib_user_mad_reg_req2, id)))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (!file->already_used) {
+		file->already_used = 1;
+		file->use_pkey_index = 1;
+	}
+
+	file->agent[agent_id] = agent;
+	ret = 0;
+
+out:
+	mutex_unlock(&file->mutex);
+
+	if (ret && agent)
+		ib_unregister_mad_agent(agent);
+
+	mutex_unlock(&file->port->file_mutex);
+
+	return ret;
+}
+
+
 static int ib_umad_unreg_agent(struct ib_umad_file *file, u32 __user *arg)
 {
 	struct ib_mad_agent *agent = NULL;
@@ -751,6 +852,8 @@ static long ib_umad_ioctl(struct file *filp, unsigned int cmd,
 		return ib_umad_unreg_agent(filp->private_data, (__u32 __user *) arg);
 	case IB_USER_MAD_ENABLE_PKEY:
 		return ib_umad_enable_pkey(filp->private_data);
+	case IB_USER_MAD_REGISTER_AGENT2:
+		return ib_umad_reg_agent2(filp->private_data, (void __user *) arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
@@ -767,6 +870,8 @@ static long ib_umad_compat_ioctl(struct file *filp, unsigned int cmd,
 		return ib_umad_unreg_agent(filp->private_data, compat_ptr(arg));
 	case IB_USER_MAD_ENABLE_PKEY:
 		return ib_umad_enable_pkey(filp->private_data);
+	case IB_USER_MAD_REGISTER_AGENT2:
+		return ib_umad_reg_agent2(filp->private_data, compat_ptr(arg));
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index fd36ec6..f0ef7c84 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -880,7 +880,7 @@ int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
 				agent = ib_register_mad_agent(&dev->ib_dev, p + 1,
 							      q ? IB_QPT_GSI : IB_QPT_SMI,
 							      NULL, 0, send_handler,
-							      NULL, NULL);
+							      NULL, NULL, 0);
 				if (IS_ERR(agent)) {
 					ret = PTR_ERR(agent);
 					goto err;
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index b6f7f45..8881fa3 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -294,7 +294,7 @@ int mthca_create_agents(struct mthca_dev *dev)
 			agent = ib_register_mad_agent(&dev->ib_dev, p + 1,
 						      q ? IB_QPT_GSI : IB_QPT_SMI,
 						      NULL, 0, send_handler,
-						      NULL, NULL);
+						      NULL, NULL, 0);
 			if (IS_ERR(agent)) {
 				ret = PTR_ERR(agent);
 				goto err;
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index edad991..e87a0f6 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2476,7 +2476,7 @@ int qib_create_agents(struct qib_ibdev *dev)
 		ibp = &dd->pport[p].ibport_data;
 		agent = ib_register_mad_agent(&dev->ibdev, p + 1, IB_QPT_SMI,
 					      NULL, 0, send_handler,
-					      NULL, NULL);
+					      NULL, NULL, 0);
 		if (IS_ERR(agent)) {
 			ret = PTR_ERR(agent);
 			goto err;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fe09f27..8a8311e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -563,7 +563,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 							 &reg_req, 0,
 							 srpt_mad_send_handler,
 							 srpt_mad_recv_handler,
-							 sport);
+							 sport, 0);
 		if (IS_ERR(sport->mad_agent)) {
 			ret = PTR_ERR(sport->mad_agent);
 			sport->mad_agent = NULL;
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 3d81b90..876f497 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -355,6 +355,7 @@ typedef void (*ib_mad_recv_handler)(struct ib_mad_agent *mad_agent,
  * @hi_tid: Access layer assigned transaction ID for this client.
  *   Unsolicited MADs sent by this client will have the upper 32-bits
  *   of their TID set to this value.
+ * @flags: registration flags
  * @port_num: Port number on which QP is registered
  * @rmpp_version: If set, indicates the RMPP version used by this agent.
  */
@@ -367,6 +368,7 @@ struct ib_mad_agent {
 	ib_mad_snoop_handler	snoop_handler;
 	void			*context;
 	u32			hi_tid;
+	u32			flags;
 	u8			port_num;
 	u8			rmpp_version;
 };
@@ -426,6 +428,7 @@ struct ib_mad_recv_wc {
  *   in the range from 0x30 to 0x4f. Otherwise not used.
  * @method_mask: The caller will receive unsolicited MADs for any method
  *   where @method_mask = 1.
+ *
  */
 struct ib_mad_reg_req {
 	u8	mgmt_class;
@@ -451,6 +454,7 @@ struct ib_mad_reg_req {
  * @recv_handler: The completion callback routine invoked for a received
  *   MAD.
  * @context: User specified context associated with the registration.
+ * @registration_flags: Registration flags to set for this agent
  */
 struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					   u8 port_num,
@@ -459,7 +463,8 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 					   u8 rmpp_version,
 					   ib_mad_send_handler send_handler,
 					   ib_mad_recv_handler recv_handler,
-					   void *context);
+					   void *context,
+					   u32 registration_flags);
 
 enum ib_mad_snoop_flags {
 	/*IB_MAD_SNOOP_POSTED_SENDS	   = 1,*/
diff --git a/include/uapi/rdma/ib_user_mad.h b/include/uapi/rdma/ib_user_mad.h
index d6fce1c..51c67ec 100644
--- a/include/uapi/rdma/ib_user_mad.h
+++ b/include/uapi/rdma/ib_user_mad.h
@@ -191,6 +191,41 @@ struct ib_user_mad_reg_req {
 	__u8	rmpp_version;
 };
 
+/**
+ * ib_user_mad_reg_req2 - MAD registration request
+ *
+ * @id                 - Set by the _kernel_; used by userspace to identify the
+ *                       registered agent in future requests.
+ * @qpn                - Queue pair number; must be 0 or 1.
+ * @mgmt_class         - Indicates which management class of MADs should be
+ *                       receive by the caller.  This field is only required if
+ *                       the user wishes to receive unsolicited MADs, otherwise
+ *                       it should be 0.
+ * @mgmt_class_version - Indicates which version of MADs for the given
+ *                       management class to receive.
+ * @res                - Ignored.
+ * @flags              - additional registration flags; Must be in the set of
+ *                       flags defined in IB_USER_MAD_REG_FLAGS_CAP
+ * @method_mask        - The caller wishes to receive unsolicited MADs for the
+ *                       methods whose bit(s) is(are) set.
+ * @oui                - Indicates IEEE OUI to use when mgmt_class is a vendor
+ *                       class in the range from 0x30 to 0x4f. Otherwise not
+ *                       used.
+ * @rmpp_version       - If set, indicates the RMPP version to use.
+ */
+#define IB_USER_MAD_REG_FLAGS_CAP (0)
+struct ib_user_mad_reg_req2 {
+	__u32	id;
+	__u32	qpn;
+	__u8	mgmt_class;
+	__u8	mgmt_class_version;
+	__u16   res;
+	__u32   flags;
+	__u64   method_mask[2];
+	__u8    oui[3]; /* network order */
+	__u8	rmpp_version;
+};
+
 #define IB_IOCTL_MAGIC		0x1b
 
 #define IB_USER_MAD_REGISTER_AGENT	_IOWR(IB_IOCTL_MAGIC, 1, \
@@ -200,4 +235,7 @@ struct ib_user_mad_reg_req {
 
 #define IB_USER_MAD_ENABLE_PKEY		_IO(IB_IOCTL_MAGIC, 3)
 
+#define IB_USER_MAD_REGISTER_AGENT2     _IOWR(IB_IOCTL_MAGIC, 4, \
+					      struct ib_user_mad_reg_req2)
+
 #endif /* IB_USER_MAD_H */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
