From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/7] ibverbs: Allow creation and modification of WQ with cvlan offload
Date: Tue, 14 Mar 2017 13:15:38 +0200
Message-ID: <1489490143-29018-3-git-send-email-yishaih@mellanox.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489490143-29018-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable WQ creation and modification with cvlan stripping offload.
This includes:
- Adding flags and flags mask fields to ibv_wq_init_attr and
  ibv_wq_attr.
- Similarly extend ibv_wq_attr to allow setting and unsetting this
  offload during ibv_modify_wq.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c      | 18 ++++++++++++++++++
 libibverbs/kern-abi.h |  4 ++++
 libibverbs/verbs.h    | 14 ++++++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 4aebbb5..b8fe76d 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1894,6 +1894,15 @@ int ibv_cmd_create_wq(struct ibv_context *context,
 	cmd->max_wr = wq_init_attr->max_wr;
 	cmd->comp_mask = 0;
 
+	if (cmd_core_size >= offsetof(struct ibv_create_wq, create_flags) +
+	    sizeof(cmd->create_flags)) {
+		if (wq_init_attr->comp_mask & IBV_WQ_INIT_ATTR_FLAGS) {
+			if (wq_init_attr->create_flags & ~(IBV_WQ_FLAGS_RESERVED - 1))
+				return EOPNOTSUPP;
+			cmd->create_flags = wq_init_attr->create_flags;
+		}
+	}
+
 	err = write(context->cmd_fd, cmd, cmd_size);
 	if (err != cmd_size)
 		return errno;
@@ -1927,6 +1936,15 @@ int ibv_cmd_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr,
 
 	cmd->curr_wq_state = attr->curr_wq_state;
 	cmd->wq_state = attr->wq_state;
+	if (cmd_core_size >= offsetof(struct ibv_modify_wq, flags_mask) +
+	    sizeof(cmd->flags_mask)) {
+		if (attr->attr_mask & IBV_WQ_ATTR_FLAGS) {
+			if (attr->flags_mask & ~(IBV_WQ_FLAGS_RESERVED - 1))
+				return EOPNOTSUPP;
+			cmd->flags = attr->flags;
+			cmd->flags_mask = attr->flags_mask;
+		}
+	}
 	cmd->wq_handle = wq->handle;
 	cmd->attr_mask = attr->attr_mask;
 
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 3958f0c..72a16b6 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -1249,6 +1249,8 @@ struct ibv_create_wq {
 	__u32 cq_handle;
 	__u32 max_wr;
 	__u32 max_sge;
+	__u32 create_flags;
+	__u32 reserved;
 };
 
 struct ibv_create_wq_resp {
@@ -1279,6 +1281,8 @@ struct ibv_modify_wq  {
 	__u32 wq_handle;
 	__u32 wq_state;
 	__u32 curr_wq_state;
+	__u32 flags;
+	__u32 flags_mask;
 };
 
 struct ibv_create_rwq_ind_table {
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 604b09e..3398566 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -667,7 +667,13 @@ enum ibv_wq_type {
 };
 
 enum ibv_wq_init_attr_mask {
-	IBV_WQ_INIT_ATTR_RESERVED	= 1 << 0,
+	IBV_WQ_INIT_ATTR_FLAGS		= 1 << 0,
+	IBV_WQ_INIT_ATTR_RESERVED	= 1 << 1,
+};
+
+enum ibv_wq_flags {
+	IBV_WQ_FLAGS_CVLAN_STRIPPING		= 1 << 0,
+	IBV_WQ_FLAGS_RESERVED			= 1 << 1,
 };
 
 struct ibv_wq_init_attr {
@@ -678,6 +684,7 @@ struct ibv_wq_init_attr {
 	struct	ibv_pd	       *pd;
 	struct	ibv_cq	       *cq;
 	uint32_t		comp_mask;
+	uint32_t		create_flags; /* use ibv_wq_flags */
 };
 
 enum ibv_wq_state {
@@ -690,7 +697,8 @@ enum ibv_wq_state {
 enum ibv_wq_attr_mask {
 	IBV_WQ_ATTR_STATE	= 1 << 0,
 	IBV_WQ_ATTR_CURR_STATE	= 1 << 1,
-	IBV_WQ_ATTR_RESERVED	= 1 << 2
+	IBV_WQ_ATTR_FLAGS	= 1 << 2,
+	IBV_WQ_ATTR_RESERVED	= 1 << 3,
 };
 
 struct ibv_wq_attr {
@@ -700,6 +708,8 @@ struct ibv_wq_attr {
 	enum	ibv_wq_state	wq_state;
 	/* Assume this is the current WQ state */
 	enum	ibv_wq_state	curr_wq_state;
+	uint32_t		flags; /* Use ibv_wq_flags */
+	uint32_t		flags_mask; /* Use ibv_wq_flags */
 };
 
 /*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
