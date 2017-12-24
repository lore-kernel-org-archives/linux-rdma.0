From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/8] RDMA/netlink: Simplify code of autoload modules
Date: Sun, 24 Dec 2017 15:43:22 +0200
Message-ID: <20171224134328.17398-3-leon@kernel.org>
References: <20171224134328.17398-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224134328.17398-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The request_module() call is internally wrapped by CONFIG_MODULE,
so there is no need to check it in our RDMA code too.

Refactor the code to simplify the code.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 1fb72c356e36..fdff071c3784 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -83,15 +83,13 @@ static bool is_nl_valid(unsigned int type, unsigned int op)
 	if (!is_nl_msg_valid(type, op))
 		return false;
 
-	cb_table = rdma_nl_types[type].cb_table;
-#ifdef CONFIG_MODULES
-	if (!cb_table) {
+	if (!rdma_nl_types[type].cb_table) {
 		mutex_unlock(&rdma_nl_mutex);
 		request_module("rdma-netlink-subsys-%d", type);
 		mutex_lock(&rdma_nl_mutex);
-		cb_table = rdma_nl_types[type].cb_table;
 	}
-#endif
+
+	cb_table = rdma_nl_types[type].cb_table;
 
 	if (!cb_table || (!cb_table[op].dump && !cb_table[op].doit))
 		return false;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
