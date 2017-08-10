From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 06/33] RDMA/iwcm: Remove extra EXPORT_SYMBOLS
Date: Thu, 10 Aug 2017 14:08:00 +0300
Message-ID: <20170810110827.9952-7-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The iwcm exports functions which are not used outside of ib_core.
This patch simply removes these EXPORT_SYMBOLS.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/iwpm_msg.c  | 12 ------------
 drivers/infiniband/core/iwpm_util.c |  5 -----
 2 files changed, 17 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index add99b92afdf..45de263305f5 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -42,7 +42,6 @@ int iwpm_valid_pid(void)
 {
 	return iwpm_user_pid > 0;
 }
-EXPORT_SYMBOL(iwpm_valid_pid);
 
 /*
  * iwpm_register_pid - Send a netlink query to user space
@@ -122,7 +121,6 @@ int iwpm_register_pid(struct iwpm_dev_data *pm_msg, u8 nl_client)
 		iwpm_free_nlmsg_request(&nlmsg_request->kref);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_register_pid);
 
 /*
  * iwpm_add_mapping - Send a netlink add mapping message
@@ -191,7 +189,6 @@ int iwpm_add_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 		iwpm_free_nlmsg_request(&nlmsg_request->kref);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_add_mapping);
 
 /*
  * iwpm_add_and_query_mapping - Send a netlink add and query
@@ -267,7 +264,6 @@ int iwpm_add_and_query_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 		iwpm_free_nlmsg_request(&nlmsg_request->kref);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_add_and_query_mapping);
 
 /*
  * iwpm_remove_mapping - Send a netlink remove mapping message
@@ -328,7 +324,6 @@ int iwpm_remove_mapping(struct sockaddr_storage *local_addr, u8 nl_client)
 		dev_kfree_skb_any(skb);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_remove_mapping);
 
 /* netlink attribute policy for the received response to register pid request */
 static const struct nla_policy resp_reg_policy[IWPM_NLA_RREG_PID_MAX] = {
@@ -397,7 +392,6 @@ int iwpm_register_pid_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	up(&nlmsg_request->sem);
 	return 0;
 }
-EXPORT_SYMBOL(iwpm_register_pid_cb);
 
 /* netlink attribute policy for the received response to add mapping request */
 static const struct nla_policy resp_add_policy[IWPM_NLA_RMANAGE_MAPPING_MAX] = {
@@ -466,7 +460,6 @@ int iwpm_add_mapping_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	up(&nlmsg_request->sem);
 	return 0;
 }
-EXPORT_SYMBOL(iwpm_add_mapping_cb);
 
 /* netlink attribute policy for the response to add and query mapping request
  * and response with remote address info */
@@ -558,7 +551,6 @@ int iwpm_add_and_query_mapping_cb(struct sk_buff *skb,
 	up(&nlmsg_request->sem);
 	return 0;
 }
-EXPORT_SYMBOL(iwpm_add_and_query_mapping_cb);
 
 /*
  * iwpm_remote_info_cb - Process a port mapper message, containing
@@ -627,7 +619,6 @@ int iwpm_remote_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 			"remote_info: Mapped remote sockaddr:");
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_remote_info_cb);
 
 /* netlink attribute policy for the received request for mapping info */
 static const struct nla_policy resp_mapinfo_policy[IWPM_NLA_MAPINFO_REQ_MAX] = {
@@ -677,7 +668,6 @@ int iwpm_mapping_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	ret = iwpm_send_mapinfo(nl_client, iwpm_user_pid);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_mapping_info_cb);
 
 /* netlink attribute policy for the received mapping info ack */
 static const struct nla_policy ack_mapinfo_policy[IWPM_NLA_MAPINFO_NUM_MAX] = {
@@ -707,7 +697,6 @@ int iwpm_ack_mapping_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
 	return 0;
 }
-EXPORT_SYMBOL(iwpm_ack_mapping_info_cb);
 
 /* netlink attribute policy for the received port mapper error message */
 static const struct nla_policy map_error_policy[IWPM_NLA_ERR_MAX] = {
@@ -751,4 +740,3 @@ int iwpm_mapping_error_cb(struct sk_buff *skb, struct netlink_callback *cb)
 	up(&nlmsg_request->sem);
 	return 0;
 }
-EXPORT_SYMBOL(iwpm_mapping_error_cb);
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 32ca2aaa4e3b..c46442ac71a2 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -81,7 +81,6 @@ int iwpm_init(u8 nl_client)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_init);
 
 static void free_hash_bucket(void);
 static void free_reminfo_bucket(void);
@@ -107,7 +106,6 @@ int iwpm_exit(u8 nl_client)
 	iwpm_set_registration(nl_client, IWPM_REG_UNDEF);
 	return 0;
 }
-EXPORT_SYMBOL(iwpm_exit);
 
 static struct hlist_head *get_mapinfo_hash_bucket(struct sockaddr_storage *,
 					       struct sockaddr_storage *);
@@ -146,7 +144,6 @@ int iwpm_create_mapinfo(struct sockaddr_storage *local_sockaddr,
 	spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_create_mapinfo);
 
 int iwpm_remove_mapinfo(struct sockaddr_storage *local_sockaddr,
 			struct sockaddr_storage *mapped_local_addr)
@@ -182,7 +179,6 @@ int iwpm_remove_mapinfo(struct sockaddr_storage *local_sockaddr,
 	spin_unlock_irqrestore(&iwpm_mapinfo_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_remove_mapinfo);
 
 static void free_hash_bucket(void)
 {
@@ -295,7 +291,6 @@ int iwpm_get_remote_info(struct sockaddr_storage *mapped_loc_addr,
 	spin_unlock_irqrestore(&iwpm_reminfo_lock, flags);
 	return ret;
 }
-EXPORT_SYMBOL(iwpm_get_remote_info);
 
 struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 					u8 nl_client, gfp_t gfp)
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
