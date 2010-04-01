From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/26] rdma/cm: expose private data when using AF_IB
Date: Thu, 1 Apr 2010 10:08:41 -0700
Message-ID: <04C434500E4B462A899BC3666334D4E7@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the source or destination address is AF_IB, then do not
reserve a portion of the private data in the IB CM REQ or SIDR
REQ messages for the cma header.  Instead, all private data
should be exported to the user.  When AF_IB is used, the
rdma cm does not have sufficient information to fill in the
cma header.  Additionally, this will be necessary to support
any IB connection through the rdma cm interface, 

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 drivers/infiniband/core/cma.c |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0432eca..b3188fc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -820,6 +820,7 @@ static inline int cma_user_data_offset(enum rdma_port_space ps)
 {
 	switch (ps) {
 	case RDMA_PS_SDP:
+	case RDMA_PS_IB:
 		return 0;
 	default:
 		return sizeof(struct cma_hdr);
@@ -2349,19 +2350,19 @@ err1:
 }
 EXPORT_SYMBOL(rdma_bind_addr);
 
-static int cma_format_hdr(void *hdr, enum rdma_port_space ps,
-			  struct rdma_route *route)
+static int cma_format_hdr(void *hdr, struct rdma_cm_id *id)
 {
 	struct cma_hdr *cma_hdr;
 	struct sdp_hh *sdp_hdr;
 
-	if (route->addr.src_addr.ss_family == AF_INET) {
+	if (id->route.addr.src_addr.ss_family == AF_INET &&
+	    id->route.addr.dst_addr.ss_family == AF_INET) {
 		struct sockaddr_in *src4, *dst4;
 
-		src4 = (struct sockaddr_in *) &route->addr.src_addr;
-		dst4 = (struct sockaddr_in *) &route->addr.dst_addr;
+		src4 = (struct sockaddr_in *) &id->route.addr.src_addr;
+		dst4 = (struct sockaddr_in *) &id->route.addr.dst_addr;
 
-		switch (ps) {
+		switch (id->ps) {
 		case RDMA_PS_SDP:
 			sdp_hdr = hdr;
 			if (sdp_get_majv(sdp_hdr->sdp_version) != SDP_MAJ_VERSION)
@@ -2380,13 +2381,14 @@ static int cma_format_hdr(void *hdr, enum rdma_port_space ps,
 			cma_hdr->port = src4->sin_port;
 			break;
 		}
-	} else {
+	} else if (id->route.addr.src_addr.ss_family == AF_INET6 &&
+		   id->route.addr.dst_addr.ss_family == AF_INET6) {
 		struct sockaddr_in6 *src6, *dst6;
 
-		src6 = (struct sockaddr_in6 *) &route->addr.src_addr;
-		dst6 = (struct sockaddr_in6 *) &route->addr.dst_addr;
+		src6 = (struct sockaddr_in6 *) &id->route.addr.src_addr;
+		dst6 = (struct sockaddr_in6 *) &id->route.addr.dst_addr;
 
-		switch (ps) {
+		switch (id->ps) {
 		case RDMA_PS_SDP:
 			sdp_hdr = hdr;
 			if (sdp_get_majv(sdp_hdr->sdp_version) != SDP_MAJ_VERSION)
@@ -2478,20 +2480,20 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 {
 	struct ib_cm_sidr_req_param req;
 	struct rdma_route *route;
-	int ret;
+	int offset, ret;
 
-	req.private_data_len = sizeof(struct cma_hdr) +
-			       conn_param->private_data_len;
+	offset = cma_user_data_offset(id_priv->id.ps);
+	req.private_data_len = offset + conn_param->private_data_len;
 	req.private_data = kzalloc(req.private_data_len, GFP_ATOMIC);
 	if (!req.private_data)
 		return -ENOMEM;
 
 	if (conn_param->private_data && conn_param->private_data_len)
-		memcpy((void *) req.private_data + sizeof(struct cma_hdr),
+		memcpy((void *) req.private_data + offset,
 		       conn_param->private_data, conn_param->private_data_len);
 
 	route = &id_priv->id.route;
-	ret = cma_format_hdr((void *) req.private_data, id_priv->id.ps, route);
+	ret = cma_format_hdr((void *) req.private_data, &id_priv->id);
 	if (ret)
 		goto out;
 
@@ -2545,7 +2547,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	}
 
 	route = &id_priv->id.route;
-	ret = cma_format_hdr(private_data, id_priv->id.ps, route);
+	ret = cma_format_hdr(private_data, &id_priv->id);
 	if (ret)
 		goto out;
 	req.private_data = private_data;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
