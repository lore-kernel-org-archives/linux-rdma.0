From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 3/3] RDMA/vmw_pvrdma: Add new port_cap flag
Date: Fri, 18 Aug 2017 09:44:49 -0700
Message-ID: <a7af1415fad6c6de00486002cdb6b95efec4e891.1503073950.git.aditr@vmware.com>
References: <cover.1503073950.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1503073950.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Set the IP_BASED_GIDS port cap flag for vmw_pvrdma.

Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index 0b19d1a..1a367b7 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -152,6 +152,7 @@ int pvrdma_query_port(struct ib_device *ibdev, u8 port,
 	props->gid_tbl_len = resp->attrs.gid_tbl_len;
 	props->port_cap_flags =
 		pvrdma_port_cap_flags_to_ib(resp->attrs.port_cap_flags);
+	props->port_cap_flags |= IB_PORT_CM_SUP | IB_PORT_IP_BASED_GIDS;
 	props->max_msg_sz = resp->attrs.max_msg_sz;
 	props->bad_pkey_cntr = resp->attrs.bad_pkey_cntr;
 	props->qkey_viol_cntr = resp->attrs.qkey_viol_cntr;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
