From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] siw_cm: use to_sockaddr_in() also within dprint() statements
Date: Fri, 27 Jun 2014 17:02:40 +0200
Message-ID: <1403881360-32168-1-git-send-email-metze@samba.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 softiwarp/siw_cm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/softiwarp/siw_cm.c b/softiwarp/siw_cm.c
index ad3d617..e4d97bb 100644
--- a/softiwarp/siw_cm.c
+++ b/softiwarp/siw_cm.c
@@ -1303,10 +1303,10 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		id, QP_ID(qp), sdev->ofa_dev.name, sdev->netdev->name);
 	dprint(DBG_CM, "(id=0x%p, QP%d): laddr=(0x%x,%d), raddr=(0x%x,%d)\n",
 		id, QP_ID(qp),
-		ntohl(id->local_addr.sin_addr.s_addr),
-		ntohs(id->local_addr.sin_port),
-		ntohl(id->remote_addr.sin_addr.s_addr),
-		ntohs(id->remote_addr.sin_port));
+		ntohl(to_sockaddr_in(id->local_addr).sin_addr.s_addr),
+		ntohs(to_sockaddr_in(id->local_addr).sin_port),
+		ntohl(to_sockaddr_in(id->remote_addr).sin_addr.s_addr),
+		ntohs(to_sockaddr_in(id->remote_addr).sin_port));
 
 	laddr = (struct sockaddr *)&id->local_addr;
 	raddr = (struct sockaddr *)&id->remote_addr;
@@ -1832,9 +1832,9 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 			"raddr(id)  : ipv4=%d.%d.%d.%d, port=%d\n",
 			id,
 			l_ip[0], l_ip[1], l_ip[2], l_ip[3],
-			ntohs(id->local_addr.sin_port),
+			ntohs(to_sockaddr_in(id->local_addr).sin_port),
 			r_ip[0], r_ip[1], r_ip[2], r_ip[3],
-			ntohs(id->remote_addr.sin_port));
+			ntohs(to_sockaddr_in(id->remote_addr).sin_port));
 
 		in_dev = in_dev_get(sdev->netdev);
 		if (!in_dev) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
