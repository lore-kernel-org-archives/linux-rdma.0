From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-4.14-rc] RDMA/core: Correct nlmsg_len after appending attributes
Date: Fri, 29 Sep 2017 08:25:01 -0500
Message-ID: <20170929132501.15440-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 1a1c116f3dcf removes nlmsg_len calculation in
ibnl_put_attr causing netlink messages to be rejected due
to incorrect length.

Add nlmsg_end after all attributes are appended to calculate
the nlmsg_len.

Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v0->v1:
	* Update subject line, previously
	("RDMA/netlink: Restore nlmsg_len calculation in ibnl_put_attr") and commit message.
	* Remove nlmsg_len calculation from ibnl_put_attr
---
 drivers/infiniband/core/iwpm_msg.c  | 8 ++++++++
 drivers/infiniband/core/iwpm_util.c | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 30825bb..8861c05 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -100,6 +100,8 @@ int iwpm_register_pid(struct iwpm_dev_data *pm_msg, u8 nl_client)
 	if (ret)
 		goto pid_query_error;
 
+	nlmsg_end(skb, nlh);
+
 	pr_debug("%s: Multicasting a nlmsg (dev = %s ifname = %s iwpm = %s)\n",
 		__func__, pm_msg->dev_name, pm_msg->if_name, iwpm_ulib_name);
 
@@ -170,6 +172,8 @@ int iwpm_add_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 				&pm_msg->loc_addr, IWPM_NLA_MANAGE_ADDR);
 	if (ret)
 		goto add_mapping_error;
+
+	nlmsg_end(skb, nlh);
 	nlmsg_request->req_buffer = pm_msg;
 
 	ret = rdma_nl_unicast_wait(skb, iwpm_user_pid);
@@ -246,6 +250,8 @@ int iwpm_add_and_query_mapping(struct iwpm_sa_data *pm_msg, u8 nl_client)
 				&pm_msg->rem_addr, IWPM_NLA_QUERY_REMOTE_ADDR);
 	if (ret)
 		goto query_mapping_error;
+
+	nlmsg_end(skb, nlh);
 	nlmsg_request->req_buffer = pm_msg;
 
 	ret = rdma_nl_unicast_wait(skb, iwpm_user_pid);
@@ -308,6 +314,8 @@ int iwpm_remove_mapping(struct sockaddr_storage *local_addr, u8 nl_client)
 	if (ret)
 		goto remove_mapping_error;
 
+	nlmsg_end(skb, nlh);
+
 	ret = rdma_nl_unicast_wait(skb, iwpm_user_pid);
 	if (ret) {
 		skb = NULL; /* skb is freed in the netlink send-op handling */
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index c81c559..3c4faad 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -597,6 +597,9 @@ static int send_mapinfo_num(u32 mapping_num, u8 nl_client, int iwpm_pid)
 				&mapping_num, IWPM_NLA_MAPINFO_SEND_NUM);
 	if (ret)
 		goto mapinfo_num_error;
+
+	nlmsg_end(skb, nlh);
+
 	ret = rdma_nl_unicast(skb, iwpm_pid);
 	if (ret) {
 		skb = NULL;
@@ -678,6 +681,8 @@ int iwpm_send_mapinfo(u8 nl_client, int iwpm_pid)
 			if (ret)
 				goto send_mapping_info_unlock;
 
+			nlmsg_end(skb, nlh);
+
 			iwpm_print_sockaddr(&map_info->local_sockaddr,
 				"send_mapping_info: Local sockaddr:");
 			iwpm_print_sockaddr(&map_info->mapped_sockaddr,
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
