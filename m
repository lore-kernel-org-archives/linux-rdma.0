From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/opa_vnic: Support adding OPA VNIC vports
 through debug interface
Date: Tue, 26 Sep 2017 07:08:51 -0700
Message-ID: <20170926140849.18110.73628.stgit@scvm10.sc.intel.com>
References: <20170926140714.18110.74689.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926140714.18110.74689.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Adds the ability to create vnic vports manually from command line using
the debugfs interface.

Reviewed-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Niranjana Vishwanathapura <Niranjana.Vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Scott Franco <safranco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c |   47 ++++++++++++++++++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h |    4 ++
 .../infiniband/ulp/opa_vnic/opa_vnic_internal.h    |   30 +++++++++++++
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c    |   38 ++++------------
 4 files changed, 90 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c
index f5565bd..39cd410 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.c
@@ -604,6 +604,53 @@ void opa_vnic_dbg_vport_exit(struct opa_vnic_adapter *adapter)
 	debugfs_remove_recursive(adapter->dentry);
 }
 
+static int ctrl_add_vport_set(void *data, u64 val)
+{
+	struct opa_vnic_vema_port *port = data;
+	struct opa_vnic_adapter *adapter;
+	u8 vport = (u8)val;
+
+	adapter = vema_add_vport(port, vport);
+	return IS_ERR(adapter);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(ctrl_add_vport, NULL, ctrl_add_vport_set, "%llu\n");
+
+void opa_vnic_dbg_ctrl_init(struct opa_vnic_ctrl_port *cport)
+{
+	struct opa_vnic_vema_port *port;
+	int i;
+
+	if (!opa_vnic_dbg_root)
+		return;
+
+	for (i = 1; i <= cport->num_ports; i++) {
+		char name[255];
+
+		port = vema_get_port(cport, i);
+		if (port->dentry)
+			continue;
+		snprintf(name, sizeof(name), "%s.%02x",
+			 dev_name(&cport->ibdev->dev), i);
+		port->dentry = debugfs_create_dir(name, opa_vnic_dbg_root);
+		if (port->dentry)
+			DEBUGFS_FILE_CREATE("add_vport", port->dentry, port,
+					    &ctrl_add_vport, 0200);
+	}
+}
+
+void opa_vnic_dbg_ctrl_exit(struct opa_vnic_ctrl_port *cport)
+{
+	struct opa_vnic_vema_port *port;
+	int i;
+
+	for (i = 1; i <= cport->num_ports; i++) {
+		port = vema_get_port(cport, i);
+		debugfs_remove_recursive(port->dentry);
+		port->dentry = NULL;
+	}
+}
+
 void opa_vnic_dbg_init(void)
 {
 	opa_vnic_dbg_root = debugfs_create_dir(opa_vnic_driver_name, NULL);
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h
index 9583a34..90fafcb 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_debugfs.h
@@ -52,11 +52,15 @@
  */
 
 #ifdef CONFIG_DEBUG_FS
+void opa_vnic_dbg_ctrl_init(struct opa_vnic_ctrl_port *cport);
+void opa_vnic_dbg_ctrl_exit(struct opa_vnic_ctrl_port *cport);
 void opa_vnic_dbg_vport_init(struct opa_vnic_adapter *adapter);
 void opa_vnic_dbg_vport_exit(struct opa_vnic_adapter *adapter);
 void opa_vnic_dbg_init(void);
 void opa_vnic_dbg_exit(void);
 #else
+static void opa_vnic_dbg_ctrl_init(struct opa_vnic_ctrl_port *cport) {}
+static void opa_vnic_dbg_ctrl_exit(struct opa_vnic_ctrl_port *cport) {}
 static inline void opa_vnic_dbg_vport_init(struct opa_vnic_adapter *adapter) {}
 static inline void opa_vnic_dbg_vport_exit(struct opa_vnic_adapter *adapter) {}
 static inline void opa_vnic_dbg_init(void) {}
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
index 4c82c55..884d6ec 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_internal.h
@@ -243,6 +243,32 @@ struct opa_vnic_mac_tbl_node {
 	struct __opa_vnic_mactable_entry     entry;
 };
 
+/**
+ * struct opa_vnic_vema_port -- VNIC VEMA port details
+ * @cport: pointer to port
+ * @mad_agent: pointer to mad agent for port
+ * @class_port_info: Class port info information.
+ * @tid: Transaction id
+ * @port_num: OPA port number
+ * @vport_idr: vnic ports idr
+ * @event_handler: ib event handler
+ * @dentry: Pointer to port debugfs node
+ * @lock: adapter interface lock
+ */
+struct opa_vnic_vema_port {
+	struct opa_vnic_ctrl_port      *cport;
+	struct ib_mad_agent            *mad_agent;
+	struct opa_class_port_info      class_port_info;
+	u64                             tid;
+	u8                              port_num;
+	struct idr                      vport_idr;
+	struct ib_event_handler         event_handler;
+	struct dentry                  *dentry;
+
+	/* Lock to query/update network adapter */
+	struct mutex                    lock;
+};
+
 #define v_dbg(format, arg...) \
 	netdev_dbg(adapter->netdev, format, ## arg)
 #define v_err(format, arg...) \
@@ -328,5 +354,9 @@ void opa_vnic_set_per_veswport_info(struct opa_vnic_adapter *adapter,
 void opa_vnic_vema_send_trap(struct opa_vnic_adapter *adapter,
 			     struct __opa_veswport_trap *data, u32 lid);
 void vema_get_pod_values(struct opa_veswport_info *port_info);
+struct opa_vnic_vema_port *vema_get_port(struct opa_vnic_ctrl_port *cport,
+					 u8 port_num);
+struct opa_vnic_adapter *vema_add_vport(struct opa_vnic_vema_port *port,
+					u8 vport_num);
 
 #endif /* _OPA_VNIC_INTERNAL_H */
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index c6cccbb..137dc36 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -91,30 +91,6 @@
 /* Maximum number of VNIC ports supported */
 #define OPA_VNIC_MAX_NUM_VPORT    255
 
-/**
- * struct opa_vnic_vema_port -- VNIC VEMA port details
- * @cport: pointer to port
- * @mad_agent: pointer to mad agent for port
- * @class_port_info: Class port info information.
- * @tid: Transaction id
- * @port_num: OPA port number
- * @vport_idr: vnic ports idr
- * @event_handler: ib event handler
- * @lock: adapter interface lock
- */
-struct opa_vnic_vema_port {
-	struct opa_vnic_ctrl_port      *cport;
-	struct ib_mad_agent            *mad_agent;
-	struct opa_class_port_info      class_port_info;
-	u64                             tid;
-	u8                              port_num;
-	struct idr                      vport_idr;
-	struct ib_event_handler         event_handler;
-
-	/* Lock to query/update network adapter */
-	struct mutex                    lock;
-};
-
 static void opa_vnic_vema_add_one(struct ib_device *device);
 static void opa_vnic_vema_rem_one(struct ib_device *device,
 				  void *client_data);
@@ -197,8 +173,8 @@ void vema_get_pod_values(struct opa_veswport_info *port_info)
  *
  * Return a pointer to the vnic adapter structure
  */
-static struct opa_vnic_adapter *vema_add_vport(struct opa_vnic_vema_port *port,
-					       u8 vport_num)
+struct opa_vnic_adapter *vema_add_vport(struct opa_vnic_vema_port *port,
+					u8 vport_num)
 {
 	struct opa_vnic_ctrl_port *cport = port->cport;
 	struct opa_vnic_adapter *adapter;
@@ -213,8 +189,9 @@ void vema_get_pod_values(struct opa_veswport_info *port_info)
 		if (rc < 0) {
 			opa_vnic_rem_netdev(adapter);
 			adapter = ERR_PTR(rc);
+		} else {
+			opa_vnic_dbg_vport_init(adapter);
 		}
-		opa_vnic_dbg_vport_init(adapter);
 	}
 
 	return adapter;
@@ -699,7 +676,7 @@ static void vema_recv(struct ib_mad_agent *mad_agent,
  * Return: ptr to requested opa_vnic_vema_port strucure
  *         if success, NULL if not
  */
-static struct opa_vnic_vema_port *
+struct opa_vnic_vema_port *
 vema_get_port(struct opa_vnic_ctrl_port *cport, u8 port_num)
 {
 	struct opa_vnic_vema_port *port = (void *)cport + sizeof(*cport);
@@ -1025,8 +1002,10 @@ static void opa_vnic_vema_add_one(struct ib_device *device)
 
 	/* Initialize opa vnic management agent (vema) */
 	rc = vema_register(cport);
-	if (!rc)
+	if (!rc) {
+		opa_vnic_dbg_ctrl_init(cport);
 		c_info("VNIC client initialized\n");
+	}
 
 	ib_set_client_data(device, &opa_vnic_client, cport);
 	opa_vnic_ctrl_config_dev(cport, true);
@@ -1049,6 +1028,7 @@ static void opa_vnic_vema_rem_one(struct ib_device *device,
 
 	c_info("removing VNIC client\n");
 	opa_vnic_ctrl_config_dev(cport, false);
+	opa_vnic_dbg_ctrl_exit(cport);
 	vema_unregister(cport);
 	kfree(cport);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
