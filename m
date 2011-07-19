From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/7] libibverbs: change kernel API to accept link layer
Date: Tue, 19 Jul 2011 12:28:42 +0300
Message-ID: <alpine.LRH.2.00.1107191228080.5580@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1107191223460.5580@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1107191223460.5580-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Modify the code to allow passing the link layer of a port from the
kernel to the library.

The new field does not change the size of struct ibv_query_port_resp
as it replaces a reserved field. As such binary compatibility between
the kernel to the library is kept, since old kernel running below new
library will not touch that field so it will be resolved as unspecified,
and old library running over new kernel will ignore the setting done by
the kernel.

The solution was suggested by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
and Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/infiniband/kern-abi.h |    3 ++-
 src/cmd.c                     |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 0db083a..619ea7e 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -223,7 +223,8 @@ struct ibv_query_port_resp {
 	__u8  active_width;
 	__u8  active_speed;
 	__u8  phys_state;
-	__u8  reserved[3];
+	__u8  link_layer;
+	__u8  reserved[2];
 };

 struct ibv_alloc_pd {
diff --git a/src/cmd.c b/src/cmd.c
index cbd5288..39af833 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -196,6 +196,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 	port_attr->active_width    = resp.active_width;
 	port_attr->active_speed    = resp.active_speed;
 	port_attr->phys_state      = resp.phys_state;
+	port_attr->link_layer      = resp.link_layer;

 	return 0;
 }
-- 
1.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
