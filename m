From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-rc v1 1/2] IB/core: Only enforce security for InfiniBand
Date: Sun, 26 Nov 2017 20:23:53 +0200
Message-ID: <20171126182354.18709-2-leon@kernel.org>
References: <20171126182354.18709-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171126182354.18709-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, Paul Moore <paul@paul-moore.com>, Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj@mellanox.com>

For now the only LSM security enforcement mechanism available is
specific to InfiniBand. Bypass enforcement for non-IB link types.
This fixes a regression where modify_qp fails for iWARP because
querying the PKEY returns -EINVAL.

Cc: Paul Moore <paul@paul-moore.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: stable@vger.kernel.org
Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
Fixes: d291f1a65232("IB/core: Enforce PKey security on QPs")
Fixes: 47a2b338fe63("IB/core: Enforce security on management datagrams")
Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/security.c | 43 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 23278ed5be45..4b7fd68e1174 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -417,8 +417,17 @@ void ib_close_shared_qp_security(struct ib_qp_security *sec)
 
 int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
 {
+	u8 i = rdma_start_port(dev);
+	bool is_ib = false;
 	int ret;
 
+	while (i <= rdma_end_port(dev) && !is_ib)
+		is_ib = rdma_protocol_ib(dev, i++);
+
+	/* If this isn't an IB device don't create the security context */
+	if (!is_ib)
+		return 0;
+
 	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
 	if (!qp->qp_sec)
 		return -ENOMEM;
@@ -441,6 +450,10 @@ EXPORT_SYMBOL(ib_create_qp_security);
 
 void ib_destroy_qp_security_begin(struct ib_qp_security *sec)
 {
+	/* Return if not IB */
+	if (!sec)
+		return;
+
 	mutex_lock(&sec->mutex);
 
 	/* Remove the QP from the lists so it won't get added to
@@ -470,6 +483,10 @@ void ib_destroy_qp_security_abort(struct ib_qp_security *sec)
 	int ret;
 	int i;
 
+	/* Return if not IB */
+	if (!sec)
+		return;
+
 	/* If a concurrent cache update is in progress this
 	 * QP security could be marked for an error state
 	 * transition.  Wait for this to complete.
@@ -505,6 +522,10 @@ void ib_destroy_qp_security_end(struct ib_qp_security *sec)
 {
 	int i;
 
+	/* Return if not IB */
+	if (!sec)
+		return;
+
 	/* If a concurrent cache update is occurring we must
 	 * wait until this QP security structure is processed
 	 * in the QP to error flow before destroying it because
@@ -565,13 +586,19 @@ int ib_security_modify_qp(struct ib_qp *qp,
 	bool pps_change = ((qp_attr_mask & (IB_QP_PKEY_INDEX | IB_QP_PORT)) ||
 			   (qp_attr_mask & IB_QP_ALT_PATH));
 
+	WARN_ONCE((qp_attr_mask & IB_QP_PORT &&
+		   rdma_protocol_ib(real_qp->device, qp_attr->port_num) &&
+		   !real_qp->qp_sec),
+		   "%s: QP security is not initialized for IB QP: %d\n",
+		   __func__, real_qp->qp_num);
+
 	/* The port/pkey settings are maintained only for the real QP. Open
 	 * handles on the real QP will be in the shared_qp_list. When
 	 * enforcing security on the real QP all the shared QPs will be
 	 * checked as well.
 	 */
 
-	if (pps_change && !special_qp) {
+	if (pps_change && !special_qp` && real_qp->qp_sec) {
 		mutex_lock(&real_qp->qp_sec->mutex);
 		new_pps = get_new_pps(real_qp,
 				      qp_attr,
@@ -600,7 +627,7 @@ int ib_security_modify_qp(struct ib_qp *qp,
 						 qp_attr_mask,
 						 udata);
 
-	if (pps_change && !special_qp) {
+	if (pps_change && !special_qpp && real_qp->qp_sec) {
 		/* Clean up the lists and free the appropriate
 		 * ports_pkeys structure.
 		 */
@@ -631,6 +658,9 @@ int ib_security_pkey_access(struct ib_device *dev,
 	u16 pkey;
 	int ret;
 
+	if (!rdma_protocol_ib(dev, port_num))
+		return 0;
+
 	ret = ib_get_cached_pkey(dev, port_num, pkey_index, &pkey);
 	if (ret)
 		return ret;
@@ -665,6 +695,9 @@ int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
 {
 	int ret;
 
+	if (!rdma_protocol_ib(agent->device, agent->port_num))
+		return 0;
+
 	ret = security_ib_alloc_security(&agent->security);
 	if (ret)
 		return ret;
@@ -690,6 +723,9 @@ int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
 
 void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)
 {
+	if (!rdma_protocol_ib(agent->device, agent->port_num))
+		return;
+
 	security_ib_free_security(agent->security);
 	if (agent->lsm_nb_reg)
 		unregister_lsm_notifier(&agent->lsm_nb);
@@ -697,6 +733,9 @@ void ib_mad_agent_security_cleanup(struct ib_mad_agent *agent)
 
 int ib_mad_enforce_security(struct ib_mad_agent_private *map, u16 pkey_index)
 {
+	if (!rdma_protocol_ib(map->agent.device, map->agent.port_num))
+		return 0;
+
 	if (map->agent.qp->qp_type == IB_QPT_SMI && !map->agent.smp_allowed)
 		return -EACCES;
 
-- 
2.15.0
