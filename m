From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH V1 for-next 2/2] IB/core: Support for CMA multicast join flags
Date: Wed,  6 Jul 2016 16:36:35 +0300
Message-ID: <1467812195-22221-3-git-send-email-leon@kernel.org>
References: <1467812195-22221-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467812195-22221-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Added UCMA and CMA support for multicast join flags. Flags are
passed using UCMA CM join command previously reserved fields.
Currently supporting two join flags indicating two different
multicast JoinStates:

1. Full Member:
   The initiator creates the Multicast group(MCG) if it wasn't
   previously created, can send Multicast messages to the group
   and receive messages from the MCG.

2. Send Only Full Member:
   The initiator creates the Multicast group(MCG) if it wasn't
   previously created, can send Multicast messages to the group
   but doesn't receive any messages from the MCG.

   IB: Send Only Full Member requires a query of ClassPortInfo
       to determine if SM/SA supports this option. If SM/SA
       doesn't support Send-Only there will be no join request
       sent and an error will be returned.

   ETH: When Send Only Full Member is requested no IGMP join
	will be sent.

Signed-off-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c       | 98 ++++++++++++++++++++++++++++++++++---
 drivers/infiniband/core/multicast.c | 12 -----
 drivers/infiniband/core/ucma.c      | 18 +++++--
 include/rdma/ib_sa.h                | 13 +++++
 include/rdma/rdma_cm.h              |  4 +-
 include/uapi/rdma/rdma_user_cm.h    |  9 +++-
 6 files changed, 130 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ad1b1ad..e6dfa1b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -68,6 +68,7 @@ MODULE_DESCRIPTION("Generic RDMA CM Agent");
 MODULE_LICENSE("Dual BSD/GPL");
 
 #define CMA_CM_RESPONSE_TIMEOUT 20
+#define CMA_QUERY_CLASSPORT_INFO_TIMEOUT 3000
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
@@ -162,6 +163,14 @@ struct rdma_bind_list {
 	unsigned short		port;
 };
 
+struct class_port_info_context {
+	struct ib_class_port_info	*class_port_info;
+	struct ib_device		*device;
+	struct completion		done;
+	struct ib_sa_query		*sa_query;
+	u8				port_num;
+};
+
 static int cma_ps_alloc(struct net *net, enum rdma_port_space ps,
 			struct rdma_bind_list *bind_list, int snum)
 {
@@ -306,6 +315,7 @@ struct cma_multicast {
 	struct sockaddr_storage	addr;
 	struct kref		mcref;
 	bool			igmp_joined;
+	u8			join_state;
 };
 
 struct cma_work {
@@ -3752,10 +3762,63 @@ static void cma_set_mgid(struct rdma_id_private *id_priv,
 	}
 }
 
+static void cma_query_sa_classport_info_cb(int status,
+					   struct ib_class_port_info *rec,
+					   void *context)
+{
+	struct class_port_info_context *cb_ctx = context;
+
+	WARN_ON(!context);
+
+	if (status || !rec) {
+		pr_debug("RDMA CM: %s port %u failed query ClassPortInfo status: %d\n",
+			 cb_ctx->device->name, cb_ctx->port_num, status);
+		goto out;
+	}
+
+	memcpy(cb_ctx->class_port_info, rec, sizeof(struct ib_class_port_info));
+
+out:
+	complete(&cb_ctx->done);
+}
+
+static int cma_query_sa_classport_info(struct ib_device *device, u8 port_num,
+				       struct ib_class_port_info *class_port_info)
+{
+	struct class_port_info_context *cb_ctx;
+	int ret;
+
+	cb_ctx = kmalloc(sizeof(*cb_ctx), GFP_KERNEL);
+	if (!cb_ctx)
+		return -ENOMEM;
+
+	cb_ctx->device = device;
+	cb_ctx->class_port_info = class_port_info;
+	cb_ctx->port_num = port_num;
+	init_completion(&cb_ctx->done);
+
+	ret = ib_sa_classport_info_rec_query(&sa_client, device, port_num,
+					     CMA_QUERY_CLASSPORT_INFO_TIMEOUT,
+					     GFP_KERNEL, cma_query_sa_classport_info_cb,
+					     cb_ctx, &cb_ctx->sa_query);
+	if (ret < 0) {
+		pr_err("RDMA CM: %s port %u failed to send ClassPortInfo query, ret: %d\n",
+		       device->name, port_num, ret);
+		goto out;
+	}
+
+	wait_for_completion(&cb_ctx->done);
+
+out:
+	kfree(cb_ctx);
+	return ret;
+}
+
 static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 				 struct cma_multicast *mc)
 {
 	struct ib_sa_mcmember_rec rec;
+	struct ib_class_port_info class_port_info;
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
 	ib_sa_comp_mask comp_mask;
 	int ret;
@@ -3774,7 +3837,24 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 	rec.qkey = cpu_to_be32(id_priv->qkey);
 	rdma_addr_get_sgid(dev_addr, &rec.port_gid);
 	rec.pkey = cpu_to_be16(ib_addr_get_pkey(dev_addr));
-	rec.join_state = 1;
+	rec.join_state = mc->join_state;
+
+	if (rec.join_state == BIT(SENDONLY_FULLMEMBER_JOIN)) {
+		ret = cma_query_sa_classport_info(id_priv->id.device,
+						  id_priv->id.port_num,
+						  &class_port_info);
+
+		if (ret)
+			return ret;
+
+		if (!(ib_get_cpi_capmask2(&class_port_info) &
+		      IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT)) {
+			pr_warn("RDMA CM: %s port %u Unable to multicast join\n"
+				"RDMA CM: SM doesn't support Send Only Full Member option\n",
+				id_priv->id.device->name, id_priv->id.port_num);
+			return -EOPNOTSUPP;
+		}
+	}
 
 	comp_mask = IB_SA_MCMEMBER_REC_MGID | IB_SA_MCMEMBER_REC_PORT_GID |
 		    IB_SA_MCMEMBER_REC_PKEY | IB_SA_MCMEMBER_REC_JOIN_STATE |
@@ -3843,6 +3923,9 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
 	struct net_device *ndev = NULL;
 	enum ib_gid_type gid_type;
+	bool send_only;
+
+	send_only = mc->join_state == BIT(SENDONLY_FULLMEMBER_JOIN);
 
 	if (cma_zero_addr((struct sockaddr *)&mc->addr))
 		return -EINVAL;
@@ -3878,10 +3961,12 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 	if (addr->sa_family == AF_INET) {
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
 			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
-			err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid,
-					    true);
-			if (!err)
-				mc->igmp_joined = true;
+			if (!send_only) {
+				err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid,
+						    true);
+				if (!err)
+					mc->igmp_joined = true;
+			}
 		}
 	} else {
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
@@ -3911,7 +3996,7 @@ out1:
 }
 
 int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
-			void *context)
+			u8 join_state, void *context)
 {
 	struct rdma_id_private *id_priv;
 	struct cma_multicast *mc;
@@ -3930,6 +4015,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	mc->context = context;
 	mc->id_priv = id_priv;
 	mc->igmp_joined = false;
+	mc->join_state = join_state;
 	spin_lock(&id_priv->lock);
 	list_add(&mc->list, &id_priv->mc_list);
 	spin_unlock(&id_priv->lock);
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index a83ec28..3a3c5d7 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -93,18 +93,6 @@ enum {
 
 struct mcast_member;
 
-/*
-* There are 4 types of join states:
-* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
-*/
-enum {
-	FULLMEMBER_JOIN,
-	NONMEMBER_JOIN,
-	SENDONLY_NONMEBER_JOIN,
-	SENDONLY_FULLMEMBER_JOIN,
-	NUM_JOIN_MEMBERSHIP_TYPES,
-};
-
 struct mcast_group {
 	struct ib_sa_mcmember_rec rec;
 	struct rb_node		node;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index c0f3826..2825ece 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -106,6 +106,7 @@ struct ucma_multicast {
 	int			events_reported;
 
 	u64			uid;
+	u8			join_state;
 	struct list_head	list;
 	struct sockaddr_storage	addr;
 };
@@ -1317,12 +1318,20 @@ static ssize_t ucma_process_join(struct ucma_file *file,
 	struct ucma_multicast *mc;
 	struct sockaddr *addr;
 	int ret;
+	u8 join_state;
 
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
 
 	addr = (struct sockaddr *) &cmd->addr;
-	if (cmd->reserved || !cmd->addr_size || (cmd->addr_size != rdma_addr_size(addr)))
+	if (!cmd->addr_size || (cmd->addr_size != rdma_addr_size(addr)))
+		return -EINVAL;
+
+	if (cmd->join_flags == RDMA_MC_JOIN_FLAG_FULLMEMBER)
+		join_state = BIT(FULLMEMBER_JOIN);
+	else if (cmd->join_flags == RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER)
+		join_state = BIT(SENDONLY_FULLMEMBER_JOIN);
+	else
 		return -EINVAL;
 
 	ctx = ucma_get_ctx(file, cmd->id);
@@ -1335,10 +1344,11 @@ static ssize_t ucma_process_join(struct ucma_file *file,
 		ret = -ENOMEM;
 		goto err1;
 	}
-
+	mc->join_state = join_state;
 	mc->uid = cmd->uid;
 	memcpy(&mc->addr, addr, cmd->addr_size);
-	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *) &mc->addr, mc);
+	ret = rdma_join_multicast(ctx->cm_id, (struct sockaddr *)&mc->addr,
+				  join_state, mc);
 	if (ret)
 		goto err2;
 
@@ -1382,7 +1392,7 @@ static ssize_t ucma_join_ip_multicast(struct ucma_file *file,
 	join_cmd.uid = cmd.uid;
 	join_cmd.id = cmd.id;
 	join_cmd.addr_size = rdma_addr_size((struct sockaddr *) &cmd.addr);
-	join_cmd.reserved = 0;
+	join_cmd.join_flags = RDMA_MC_JOIN_FLAG_FULLMEMBER;
 	memcpy(&join_cmd.addr, &cmd.addr, join_cmd.addr_size);
 
 	return ucma_process_join(file, &join_cmd, out_len);
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 3840416..5ee7aab 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -94,6 +94,19 @@ enum ib_sa_selector {
 	IB_SA_BEST = 3
 };
 
+/*
+ * There are 4 types of join states:
+ * FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
+ * The order corresponds to JoinState bits in MCMemberRecord.
+ */
+enum ib_sa_mc_join_states {
+	FULLMEMBER_JOIN,
+	NONMEMBER_JOIN,
+	SENDONLY_NONMEBER_JOIN,
+	SENDONLY_FULLMEMBER_JOIN,
+	NUM_JOIN_MEMBERSHIP_TYPES,
+};
+
 #define IB_SA_CAP_MASK2_SENDONLY_FULL_MEM_SUPPORT	BIT(12)
 
 /*
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index afe44fd..81fb1d1 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -333,11 +333,13 @@ int rdma_disconnect(struct rdma_cm_id *id);
  *   address.
  * @id: Communication identifier associated with the request.
  * @addr: Multicast address identifying the group to join.
+ * @join_state: Multicast JoinState bitmap requested by port.
+ *		Bitmap is based on IB_SA_MCMEMBER_REC_JOIN_STATE bits.
  * @context: User-defined context associated with the join request, returned
  * to the user through the private_data pointer in multicast events.
  */
 int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
-			void *context);
+			u8 join_state, void *context);
 
 /**
  * rdma_leave_multicast - Leave the multicast group specified by the given
diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 3066718..01923d4 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -244,12 +244,19 @@ struct rdma_ucm_join_ip_mcast {
 	__u32 id;
 };
 
+/* Multicast join flags */
+enum {
+	RDMA_MC_JOIN_FLAG_FULLMEMBER,
+	RDMA_MC_JOIN_FLAG_SENDONLY_FULLMEMBER,
+	RDMA_MC_JOIN_FLAG_RESERVED,
+};
+
 struct rdma_ucm_join_mcast {
 	__u64 response;		/* rdma_ucma_create_id_resp */
 	__u64 uid;
 	__u32 id;
 	__u16 addr_size;
-	__u16 reserved;
+	__u16 join_flags;
 	struct sockaddr_storage addr;
 };
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
