From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] IB/srpt: Accept GUIDs as port names
Date: Fri, 9 Dec 2016 11:00:33 -0800
Message-ID: <1b20f44a-0378-7b53-65bd-e079e9fa87ff@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Port and ACL information must be configured before an initiator
logs in.  Make it possible to configure this information before
a subnet prefix has been assigned to a port by not only accepting
GIDs as target port and initiator port names but by also accepting
port GUIDs.

Add a 'priv' member to struct se_wwn to allow target drivers to
associate their own data with struct se_wwn.

Reported-by: Doug Ledford <dledford@redhat.com>
References: http://www.spinics.net/lists/linux-rdma/msg39505.html
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 139 ++++++++++++++++++++--------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  18 +++--
 drivers/target/target_core_tpg.c      |   1 +
 include/target/target_core_base.h     |   1 +
 4 files changed, 98 insertions(+), 61 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b6b9a6401a2d..0474004ebad2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -500,6 +500,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	struct ib_mad_reg_req reg_req;
 	struct ib_port_modify port_modify;
 	struct ib_port_attr port_attr;
+	__be16 *guid;
 	int ret;
 
 	memset(&port_modify, 0, sizeof(port_modify));
@@ -522,10 +523,17 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	if (ret)
 		goto err_query_port;
 
+	sport->port_guid_wwn.priv = sport;
+	guid = (__be16 *)&sport->gid.global.interface_id;
 	snprintf(sport->port_guid, sizeof(sport->port_guid),
-		"0x%016llx%016llx",
-		be64_to_cpu(sport->gid.global.subnet_prefix),
-		be64_to_cpu(sport->gid.global.interface_id));
+		 "%04x:%04x:%04x:%04x",
+		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
+		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
+	sport->port_gid_wwn.priv = sport;
+	snprintf(sport->port_gid, sizeof(sport->port_gid),
+		 "0x%016llx%016llx",
+		 be64_to_cpu(sport->gid.global.subnet_prefix),
+		 be64_to_cpu(sport->gid.global.interface_id));
 
 	if (!sport->mad_agent) {
 		memset(&reg_req, 0, sizeof(reg_req));
@@ -1840,6 +1848,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	struct srp_login_rej *rej;
 	struct ib_cm_rep_param *rep_param;
 	struct srpt_rdma_ch *ch, *tmp_ch;
+	__be16 *guid;
 	u32 it_iu_len;
 	int i, ret = 0;
 
@@ -1985,26 +1994,30 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 
-	/*
-	 * Use the initator port identifier as the session name, when
-	 * checking against se_node_acl->initiatorname[] this can be
-	 * with or without preceeding '0x'.
-	 */
+	guid = (__be16 *)&param->primary_path->sgid.global.interface_id;
+	snprintf(ch->ini_guid, sizeof(ch->ini_guid), "%04x:%04x:%04x:%04x",
+		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
+		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
 	snprintf(ch->sess_name, sizeof(ch->sess_name), "0x%016llx%016llx",
 			be64_to_cpu(*(__be64 *)ch->i_port_id),
 			be64_to_cpu(*(__be64 *)(ch->i_port_id + 8)));
 
 	pr_debug("registering session %s\n", ch->sess_name);
 
-	ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+	if (sport->port_guid_tpg.se_tpg_wwn)
+		ch->sess = target_alloc_session(&sport->port_guid_tpg, 0, 0,
+						TARGET_PROT_NORMAL,
+						ch->ini_guid, ch, NULL);
+	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
+		ch->sess = target_alloc_session(&sport->port_gid_tpg, 0, 0,
 					TARGET_PROT_NORMAL, ch->sess_name, ch,
 					NULL);
 	/* Retry without leading "0x" */
-	if (IS_ERR(ch->sess))
-		ch->sess = target_alloc_session(&sport->port_tpg_1, 0, 0,
+	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
+		ch->sess = target_alloc_session(&sport->port_gid_tpg, 0, 0,
 						TARGET_PROT_NORMAL,
 						ch->sess_name + 2, ch, NULL);
-	if (IS_ERR(ch->sess)) {
+	if (IS_ERR_OR_NULL(ch->sess)) {
 		pr_info("Rejected login because no ACL has been configured yet for initiator %s.\n",
 			ch->sess_name);
 		rej->reason = cpu_to_be32((PTR_ERR(ch->sess) == -ENOMEM) ?
@@ -2422,7 +2435,7 @@ static int srpt_release_sdev(struct srpt_device *sdev)
 	return 0;
 }
 
-static struct srpt_port *__srpt_lookup_port(const char *name)
+static struct se_wwn *__srpt_lookup_wwn(const char *name)
 {
 	struct ib_device *dev;
 	struct srpt_device *sdev;
@@ -2437,23 +2450,25 @@ static struct srpt_port *__srpt_lookup_port(const char *name)
 		for (i = 0; i < dev->phys_port_cnt; i++) {
 			sport = &sdev->port[i];
 
-			if (!strcmp(sport->port_guid, name))
-				return sport;
+			if (strcmp(sport->port_guid, name) == 0)
+				return &sport->port_guid_wwn;
+			if (strcmp(sport->port_gid, name) == 0)
+				return &sport->port_gid_wwn;
 		}
 	}
 
 	return NULL;
 }
 
-static struct srpt_port *srpt_lookup_port(const char *name)
+static struct se_wwn *srpt_lookup_wwn(const char *name)
 {
-	struct srpt_port *sport;
+	struct se_wwn *wwn;
 
 	spin_lock(&srpt_dev_lock);
-	sport = __srpt_lookup_port(name);
+	wwn = __srpt_lookup_wwn(name);
 	spin_unlock(&srpt_dev_lock);
 
-	return sport;
+	return wwn;
 }
 
 /**
@@ -2645,11 +2660,19 @@ static char *srpt_get_fabric_name(void)
 	return "srpt";
 }
 
+static struct srpt_port *srpt_tpg_to_sport(struct se_portal_group *tpg)
+{
+	return tpg->se_tpg_wwn->priv;
+}
+
 static char *srpt_get_fabric_wwn(struct se_portal_group *tpg)
 {
-	struct srpt_port *sport = container_of(tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(tpg);
 
-	return sport->port_guid;
+	WARN_ON_ONCE(tpg != &sport->port_guid_tpg &&
+		     tpg != &sport->port_gid_tpg);
+	return tpg == &sport->port_guid_tpg ? sport->port_guid :
+		sport->port_gid;
 }
 
 static u16 srpt_get_tag(struct se_portal_group *tpg)
@@ -2739,6 +2762,19 @@ static int srpt_get_tcm_cmd_state(struct se_cmd *se_cmd)
 	return srpt_get_cmd_state(ioctx);
 }
 
+static int srpt_parse_guid(u64 *guid, const char *name)
+{
+	u16 w[4];
+	int ret = -EINVAL;
+
+	if (sscanf(name, "%hx:%hx:%hx:%hx", &w[0], &w[1], &w[2], &w[3]) != 4)
+		goto out;
+	*guid = get_unaligned_be64(w);
+	ret = 0;
+out:
+	return ret;
+}
+
 /**
  * srpt_parse_i_port_id() - Parse an initiator port ID.
  * @name: ASCII representation of a 128-bit initiator port ID.
@@ -2773,20 +2809,23 @@ static int srpt_parse_i_port_id(u8 i_port_id[16], const char *name)
  */
 static int srpt_init_nodeacl(struct se_node_acl *se_nacl, const char *name)
 {
+	u64 guid;
 	u8 i_port_id[16];
+	int ret;
 
-	if (srpt_parse_i_port_id(i_port_id, name) < 0) {
+	ret = srpt_parse_guid(&guid, name);
+	if (ret < 0)
+		ret = srpt_parse_i_port_id(i_port_id, name);
+	if (ret < 0)
 		pr_err("invalid initiator port ID %s\n", name);
-		return -EINVAL;
-	}
-	return 0;
+	return ret;
 }
 
 static ssize_t srpt_tpg_attrib_srp_max_rdma_size_show(struct config_item *item,
 		char *page)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 
 	return sprintf(page, "%u\n", sport->port_attrib.srp_max_rdma_size);
 }
@@ -2795,7 +2834,7 @@ static ssize_t srpt_tpg_attrib_srp_max_rdma_size_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 	unsigned long val;
 	int ret;
 
@@ -2823,7 +2862,7 @@ static ssize_t srpt_tpg_attrib_srp_max_rsp_size_show(struct config_item *item,
 		char *page)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 
 	return sprintf(page, "%u\n", sport->port_attrib.srp_max_rsp_size);
 }
@@ -2832,7 +2871,7 @@ static ssize_t srpt_tpg_attrib_srp_max_rsp_size_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 	unsigned long val;
 	int ret;
 
@@ -2860,7 +2899,7 @@ static ssize_t srpt_tpg_attrib_srp_sq_size_show(struct config_item *item,
 		char *page)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 
 	return sprintf(page, "%u\n", sport->port_attrib.srp_sq_size);
 }
@@ -2869,7 +2908,7 @@ static ssize_t srpt_tpg_attrib_srp_sq_size_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 	unsigned long val;
 	int ret;
 
@@ -2907,7 +2946,7 @@ static struct configfs_attribute *srpt_tpg_attrib_attrs[] = {
 static ssize_t srpt_tpg_enable_show(struct config_item *item, char *page)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 
 	return snprintf(page, PAGE_SIZE, "%d\n", (sport->enabled) ? 1: 0);
 }
@@ -2916,7 +2955,7 @@ static ssize_t srpt_tpg_enable_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = to_tpg(item);
-	struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(se_tpg);
 	struct srpt_device *sdev = sport->sdev;
 	struct srpt_rdma_ch *ch;
 	unsigned long tmp;
@@ -2968,15 +3007,19 @@ static struct se_portal_group *srpt_make_tpg(struct se_wwn *wwn,
 					     struct config_group *group,
 					     const char *name)
 {
-	struct srpt_port *sport = container_of(wwn, struct srpt_port, port_wwn);
+	struct srpt_port *sport = wwn->priv;
+	static struct se_portal_group *tpg;
 	int res;
 
-	/* Initialize sport->port_wwn and sport->port_tpg_1 */
-	res = core_tpg_register(&sport->port_wwn, &sport->port_tpg_1, SCSI_PROTOCOL_SRP);
+	WARN_ON_ONCE(wwn != &sport->port_guid_wwn &&
+		     wwn != &sport->port_gid_wwn);
+	tpg = wwn == &sport->port_guid_wwn ? &sport->port_guid_tpg :
+		&sport->port_gid_tpg;
+	res = core_tpg_register(wwn, tpg, SCSI_PROTOCOL_SRP);
 	if (res)
 		return ERR_PTR(res);
 
-	return &sport->port_tpg_1;
+	return tpg;
 }
 
 /**
@@ -2985,11 +3028,10 @@ static struct se_portal_group *srpt_make_tpg(struct se_wwn *wwn,
  */
 static void srpt_drop_tpg(struct se_portal_group *tpg)
 {
-	struct srpt_port *sport = container_of(tpg,
-				struct srpt_port, port_tpg_1);
+	struct srpt_port *sport = srpt_tpg_to_sport(tpg);
 
 	sport->enabled = false;
-	core_tpg_deregister(&sport->port_tpg_1);
+	core_tpg_deregister(tpg);
 }
 
 /**
@@ -3000,19 +3042,7 @@ static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
 				      struct config_group *group,
 				      const char *name)
 {
-	struct srpt_port *sport;
-	int ret;
-
-	sport = srpt_lookup_port(name);
-	pr_debug("make_tport(%s)\n", name);
-	ret = -EINVAL;
-	if (!sport)
-		goto err;
-
-	return &sport->port_wwn;
-
-err:
-	return ERR_PTR(ret);
+	return srpt_lookup_wwn(name) ? : ERR_PTR(-EINVAL);
 }
 
 /**
@@ -3021,9 +3051,6 @@ static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
  */
 static void srpt_drop_tport(struct se_wwn *wwn)
 {
-	struct srpt_port *sport = container_of(wwn, struct srpt_port, port_wwn);
-
-	pr_debug("drop_tport(%s\n", config_item_name(&sport->port_wwn.wwn_group.cg_item));
 }
 
 static ssize_t srpt_wwn_version_show(struct config_item *item, char *buf)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 581878782854..cc1183851af5 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -258,6 +258,7 @@ enum rdma_ch_state {
  *                 against concurrent modification by the cm_id spinlock.
  * @sess:          Session information associated with this SRP channel.
  * @sess_name:     Session name.
+ * @ini_guid:      Initiator port GUID.
  * @release_work:  Allows scheduling of srpt_release_channel().
  * @release_done:  Enables waiting for srpt_release_channel() completion.
  */
@@ -284,6 +285,7 @@ struct srpt_rdma_ch {
 	struct list_head	cmd_wait_list;
 	struct se_session	*sess;
 	u8			sess_name[36];
+	u8			ini_guid[24];
 	struct work_struct	release_work;
 	struct completion	*release_done;
 };
@@ -306,28 +308,34 @@ struct srpt_port_attrib {
  * @mad_agent: per-port management datagram processing information.
  * @enabled:   Whether or not this target port is enabled.
  * @port_guid: ASCII representation of Port GUID
+ * @port_gid:  ASCII representation of Port GID
  * @port:      one-based port number.
  * @sm_lid:    cached value of the port's sm_lid.
  * @lid:       cached value of the port's lid.
  * @gid:       cached value of the port's gid.
  * @port_acl_lock spinlock for port_acl_list:
  * @work:      work structure for refreshing the aforementioned cached values.
- * @port_tpg_1 Target portal group = 1 data.
- * @port_wwn:  Target core WWN data.
+ * @port_guid_tpg: TPG associated with target port GUID.
+ * @port_guid_wwn: WWN associated with target port GUID.
+ * @port_gid_tpg:  TPG associated with target port GID.
+ * @port_gid_wwn:  WWN associated with target port GID.
  * @port_acl_list: Head of the list with all node ACLs for this port.
  */
 struct srpt_port {
 	struct srpt_device	*sdev;
 	struct ib_mad_agent	*mad_agent;
 	bool			enabled;
-	u8			port_guid[64];
+	u8			port_guid[24];
+	u8			port_gid[64];
 	u8			port;
 	u16			sm_lid;
 	u16			lid;
 	union ib_gid		gid;
 	struct work_struct	work;
-	struct se_portal_group	port_tpg_1;
-	struct se_wwn		port_wwn;
+	struct se_portal_group	port_guid_tpg;
+	struct se_wwn		port_guid_wwn;
+	struct se_portal_group	port_gid_tpg;
+	struct se_wwn		port_gid_wwn;
 	struct srpt_port_attrib port_attrib;
 };
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d99752c6cd60..4a8b180c478b 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -448,6 +448,7 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 	complete(&lun->lun_ref_comp);
 }
 
+/* Does not change se_wwn->priv. */
 int core_tpg_register(
 	struct se_wwn *se_wwn,
 	struct se_portal_group *se_tpg,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ca8ec7218f39..22c37987d937 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -909,6 +909,7 @@ static inline struct se_portal_group *param_to_tpg(struct config_item *item)
 
 struct se_wwn {
 	struct target_fabric_configfs *wwn_tf;
+	void			*priv;
 	struct config_group	wwn_group;
 	struct config_group	fabric_stat_group;
 };
-- 
2.11.0
