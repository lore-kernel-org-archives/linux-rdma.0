From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 5/6] acm: Fix snprintf truncation
Date: Tue, 31 Jan 2017 14:08:05 -0700
Message-ID: <1485896886-23517-6-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485896886-23517-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

gcc 7.0.1 remarks:

ibacm/prov/acmp/src/acmp.c: In function 'acmp_open_endpoint.part.11':
ibacm/prov/acmp/src/acmp.c:2499:29: warning: '%d' directive writing between 1 and 3 bytes into a region of size between 0 and 63 [-Wformat-overflow=]
  sprintf(ep->id_string, "%s-%d-0x%x", port->dev->verbs->device->name,
                             ^~
ibacm/prov/acmp/src/acmp.c:2499:25: note: directive argument in the range [0, 255]
  sprintf(ep->id_string, "%s-%d-0x%x", port->dev->verbs->device->name,
                         ^~~~~~~~~~~~
ibacm/prov/acmp/src/acmp.c:2499:25: note: directive argument in the range [0, 65535]
ibacm/prov/acmp/src/acmp.c:2499:2: note: 'sprintf' output between 7 and 75 bytes into a destination of size 64
  sprintf(ep->id_string, "%s-%d-0x%x", port->dev->verbs->device->name,
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   port->port_num, endpoint->pkey);

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/prov/acmp/src/acmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ibacm/prov/acmp/src/acmp.c b/ibacm/prov/acmp/src/acmp.c
index 56567ef8bf379c..fb6684f2eac1f5 100644
--- a/ibacm/prov/acmp/src/acmp.c
+++ b/ibacm/prov/acmp/src/acmp.c
@@ -174,7 +174,7 @@ struct acmp_ep {
 	struct ibv_mr         *mr;
 	uint8_t               *recv_bufs;
 	struct list_node      entry;
-	char		      id_string[ACM_MAX_ADDRESS];
+	char		      id_string[IBV_SYSFS_NAME_MAX + 11];
 	void                  *dest_map[ACM_ADDRESS_RESERVED - 1];
 	struct acmp_dest      mc_dest[MAX_EP_MC];
 	int                   mc_cnt;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
