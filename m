From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/10] IB/core: Add proper bound checking in flow_spec uverbs conversion to verbs
Date: Wed,  9 Oct 2013 23:12:52 +0200
Message-ID: <4642ab6033d76c0f650edd5622023360f96d78b1.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Relying on the size sent by userspace as the size of kernel
internal data structure is not safe.

This patch add some level of protections to
- not read past uverbs command in case of truncated uverbs flow spec
- not write past flow_attr in case of changes in kernel flow spec
  data structure format: at some point the format of internal flow_spec
  may change while the userspace format is kept the same.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 41 +++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 902dfd3..1887b8a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2600,17 +2600,25 @@ out_put:
 }
 
 static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hdr,
-				union ib_flow_spec *ib_spec)
+				  size_t uverbs_spec_size,
+				  union ib_flow_spec *ib_spec,
+				  size_t ib_spec_size)
 {
 	struct ib_uverbs_flow_spec_storage *uverbs_spec;
 
-	ib_spec->type = uverbs_spec_hdr->type;
+	if (uverbs_spec_size < sizeof(struct ib_uverbs_flow_spec_hdr))
+		return -EINVAL;
 
-	switch (ib_spec->type) {
+	switch (uverbs_spec_hdr->type) {
 	case IB_FLOW_SPEC_ETH:
+		if (uverbs_spec_size < sizeof(struct ib_uverbs_flow_spec_eth))
+			return -EINVAL;
 		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_eth))
 			return -EINVAL;
 		uverbs_spec = (struct ib_uverbs_flow_spec_storage *)uverbs_spec_hdr;
+		if (ib_spec_size < sizeof(struct ib_flow_spec_eth))
+			return -EINVAL;
+		ib_spec->type = IB_FLOW_SPEC_ETH;
 		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
 		memcpy(&ib_spec->eth.val, &uverbs_spec->eth.val,
 		       sizeof(struct ib_flow_eth_filter));
@@ -2618,9 +2626,14 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hd
 		       sizeof(struct ib_flow_eth_filter));
 		break;
 	case IB_FLOW_SPEC_IPV4:
+		if (uverbs_spec_size < sizeof(struct ib_uverbs_flow_spec_ipv4))
+			return -EINVAL;
 		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_ipv4))
 			return -EINVAL;
 		uverbs_spec = (struct ib_uverbs_flow_spec_storage *)uverbs_spec_hdr;
+		if (ib_spec_size < sizeof(struct ib_flow_spec_ipv4))
+			return -EINVAL;
+		ib_spec->type = IB_FLOW_SPEC_IPV4;
 		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
 		memcpy(&ib_spec->ipv4.val, &uverbs_spec->ipv4.val,
 		       sizeof(struct ib_flow_ipv4_filter));
@@ -2629,9 +2642,14 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hd
 		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
+		if (uverbs_spec_size < sizeof(struct ib_uverbs_flow_spec_tcp_udp))
+			return -EINVAL;
 		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_tcp_udp))
 			return -EINVAL;
 		uverbs_spec = (struct ib_uverbs_flow_spec_storage *)uverbs_spec_hdr;
+		if (ib_spec_size < sizeof(struct ib_flow_spec_tcp_udp))
+			return -EINVAL;
+		ib_spec->type = uverbs_spec_hdr->type;
 		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
 		memcpy(&ib_spec->tcp_udp.val, &uverbs_spec->tcp_udp.val,
 		       sizeof(struct ib_flow_tcp_udp_filter));
@@ -2659,7 +2677,8 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 	void *uverbs_spec;
 	void *ib_spec;
 	int i;
-	int uverbs_spec_size;
+	size_t uverbs_spec_size;
+	size_t ib_spec_size;
 
 	if (out_len < sizeof(resp))
 		return -ENOSPC;
@@ -2716,7 +2735,9 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 		goto err_uobj;
 	}
 
-	flow_attr = kmalloc(sizeof(*flow_attr) + uverbs_spec_size, GFP_KERNEL);
+	ib_spec_size = min(uverbs_spec_size,
+			   cmd.flow_attr.num_of_specs * sizeof(union ib_flow_spec));
+	flow_attr = kmalloc(sizeof(*flow_attr) + ib_spec_size, GFP_KERNEL);
 	if (!flow_attr) {
 		err = -ENOMEM;
 		goto err_put;
@@ -2731,18 +2752,22 @@ ssize_t ib_uverbs_create_flow(struct ib_uverbs_file *file,
 
 	uverbs_spec = uverbs_flow_spec;
 	ib_spec = flow_attr + 1;
-	for (i = 0; i < flow_attr->num_of_specs && uverbs_spec_size > 0; i++) {
-		err = uverbs_spec_to_ib_spec(uverbs_spec, ib_spec);
+	for (i = 0;
+	     i < flow_attr->num_of_specs && ib_spec_size > 0 &&	uverbs_spec_size > 0;
+	     i++) {
+		err = uverbs_spec_to_ib_spec(uverbs_spec, uverbs_spec_size,
+					     ib_spec, ib_spec_size);
 		if (err)
 			goto err_free;
 		flow_attr->size +=
 			((union ib_flow_spec *) ib_spec)->size;
 		uverbs_spec_size -= ((struct ib_uverbs_flow_spec_hdr *) uverbs_spec)->size;
 		uverbs_spec += ((struct ib_uverbs_flow_spec_hdr *) uverbs_spec)->size;
+		ib_spec_size -= ((union ib_flow_spec *) ib_spec)->size;
 		ib_spec += ((union ib_flow_spec *) ib_spec)->size;
 	}
 	if (uverbs_spec_size) {
-		pr_warn("create flow failed, %d bytes left from uverb cmd\n",
+		pr_warn("create flow failed, %zu bytes left from uverb cmd\n",
 			uverbs_spec_size);
 		goto err_free;
 	}
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
