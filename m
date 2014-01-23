From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next] IB/usnic: Fix smatch endianness error
Date: Thu, 23 Jan 2014 22:38:04 +0000
Message-ID: <2FE80B3D-7377-4A6B-80CC-E9A1955E3CDE@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <177E9B7020533444BCA7EAF6505CA404-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Error reported at http://marc.info/?l=linux-rdma&m=138995755801039&w=2

Fix short to int cast for big endian systems.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 7ecc606..f8dfd76 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -629,6 +629,7 @@ static int qp_grp_id_from_flow(struct usnic_ib_qp_grp_flow *qp_flow,
 {
 	enum usnic_transport_type trans_type = qp_flow->trans_type;
 	int err;
+	uint16_t port_num = 0;
 
 	switch (trans_type) {
 	case USNIC_TRANSPORT_ROCE_CUSTOM:
@@ -637,9 +638,15 @@ static int qp_grp_id_from_flow(struct usnic_ib_qp_grp_flow *qp_flow,
 	case USNIC_TRANSPORT_IPV4_UDP:
 		err = usnic_transport_sock_get_addr(qp_flow->udp.sock,
 							NULL, NULL,
-							(uint16_t *) id);
+							&port_num);
 		if (err)
 			return err;
+		/*
+		 * Copy port_num to stack first and then to *id,
+		 * so that the short to int cast works for little
+		 * and big endian systems.
+		 */
+		*id = port_num;
 		break;
 	default:
 		usnic_err("Unsupported transport %u\n", trans_type);
-- 
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
