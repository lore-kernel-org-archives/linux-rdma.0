From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 2/5] IB/core: Remove unnecessary check in ibnl_rcv_msg
Date: Fri,  6 May 2016 22:45:25 +0300
Message-ID: <1462563928-29164-3-git-send-email-leon@kernel.org>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462563928-29164-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RDMA_NL_GET_OP is defined like this: (type & ((1 << 10) - 1))
which means op (defined as an int) can never be a negative number.

Fixes: b2cbae2c2487 ('RDMA: Add netlink infrastructure')
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index d47df93..9b8c20c 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -151,12 +151,11 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct ibnl_client *client;
 	int type = nlh->nlmsg_type;
 	int index = RDMA_NL_GET_CLIENT(type);
-	int op = RDMA_NL_GET_OP(type);
+	unsigned int op = RDMA_NL_GET_OP(type);
 
 	list_for_each_entry(client, &client_list, list) {
 		if (client->index == index) {
-			if (op < 0 || op >= client->nops ||
-			    !client->cb_table[op].dump)
+			if (op >= client->nops || !client->cb_table[op].dump)
 				return -EINVAL;
 
 			/*
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
