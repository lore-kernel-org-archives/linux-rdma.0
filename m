From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 4/5] RDMA/iwcm: Remove useless check of nelink client validity
Date: Sun, 11 Jun 2017 11:39:30 +0300
Message-ID: <20170611083931.13686-5-leon@kernel.org>
References: <20170611083931.13686-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170611083931.13686-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RDMA netlink implementation guarantees that supplied
client number is in allowed range.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/iwpm_util.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index f13870e69ccd..32ca2aaa4e3b 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -54,8 +54,6 @@ static struct iwpm_admin_data iwpm_admin;
 int iwpm_init(u8 nl_client)
 {
 	int ret = 0;
-	if (iwpm_valid_client(nl_client))
-		return -EINVAL;
 	mutex_lock(&iwpm_admin_lock);
 	if (atomic_read(&iwpm_admin.refcount) == 0) {
 		iwpm_hash_bucket = kzalloc(IWPM_MAPINFO_HASH_SIZE *
@@ -383,15 +381,11 @@ int iwpm_get_nlmsg_seq(void)

 int iwpm_valid_client(u8 nl_client)
 {
-	if (nl_client >= RDMA_NL_NUM_CLIENTS)
-		return 0;
 	return iwpm_admin.client_list[nl_client];
 }

 void iwpm_set_valid(u8 nl_client, int valid)
 {
-	if (nl_client >= RDMA_NL_NUM_CLIENTS)
-		return;
 	iwpm_admin.client_list[nl_client] = valid;
 }

--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
