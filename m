From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] rxe: Do not use 'struct sockaddr' in a uapi header
Date: Wed, 7 Feb 2018 16:49:10 -0700
Message-ID: <20180207234910.GA14608@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Linux has two 'linux/socket.h' files - and only the one in the kernel
defines struct sockaddr - the user space one does not.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_av.c | 5 +++--
 include/uapi/rdma/rdma_user_rxe.h  | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 7522d1af3ae2a3..7f1ae364088a07 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -74,8 +74,9 @@ void rxe_av_fill_ip_info(struct rxe_av *av,
 			struct ib_gid_attr *sgid_attr,
 			union ib_gid *sgid)
 {
-	rdma_gid2ip(&av->sgid_addr._sockaddr, sgid);
-	rdma_gid2ip(&av->dgid_addr._sockaddr, &rdma_ah_read_grh(attr)->dgid);
+	rdma_gid2ip((struct sockaddr *)&av->sgid_addr, sgid);
+	rdma_gid2ip((struct sockaddr *)&av->dgid_addr,
+		    &rdma_ah_read_grh(attr)->dgid);
 	av->network_type = ib_gid_to_network_type(sgid_attr->gid_type, sgid);
 }
 
diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index bdeea948b2f3a4..e3e6852b58eb45 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -35,6 +35,9 @@
 #define RDMA_USER_RXE_H
 
 #include <linux/types.h>
+#include <linux/socket.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 
 union rxe_gid {
 	__u8	raw[16];
@@ -57,7 +60,6 @@ struct rxe_av {
 	__u8			network_type;
 	struct rxe_global_route	grh;
 	union {
-		struct sockaddr		_sockaddr;
 		struct sockaddr_in	_sockaddr_in;
 		struct sockaddr_in6	_sockaddr_in6;
 	} sgid_addr, dgid_addr;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
