From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/10] IB/core: Use flow_spec common header in uverbs flow_spec conversion function
Date: Wed,  9 Oct 2013 23:12:50 +0200
Message-ID: <dc9e9f03d60265f7e859619959396c5676ea29cb.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

While the validity (and type) of the flow_spec is not known before calling
the conversion function, it's make more sense to use a pointer
to the header structure.

Once the header parameters are validated, the flow_spec can be processed.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6b066a3..8079383 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2599,15 +2599,18 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec *uverbs_spec,
+static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec_hdr *uverbs_spec_hdr,
 				union ib_flow_spec *ib_spec)
 {
-	ib_spec->type = uverbs_spec->type;
+	struct ib_uverbs_flow_spec *uverbs_spec;
+
+	ib_spec->type = uverbs_spec_hdr->type;
 
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
-		if (uverbs_spec->eth.size != sizeof(struct ib_uverbs_flow_spec_eth))
+		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_eth))
 			return -EINVAL;
+		uverbs_spec = (struct ib_uverbs_flow_spec *)uverbs_spec_hdr;
 		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
 		memcpy(&ib_spec->eth.val, &uverbs_spec->eth.val,
 		       sizeof(struct ib_flow_eth_filter));
@@ -2615,8 +2618,9 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec *uverbs_spec,
 		       sizeof(struct ib_flow_eth_filter));
 		break;
 	case IB_FLOW_SPEC_IPV4:
-		if (uverbs_spec->ipv4.size != sizeof(struct ib_uverbs_flow_spec_ipv4))
+		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_ipv4))
 			return -EINVAL;
+		uverbs_spec = (struct ib_uverbs_flow_spec *)uverbs_spec_hdr;
 		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
 		memcpy(&ib_spec->ipv4.val, &uverbs_spec->ipv4.val,
 		       sizeof(struct ib_flow_ipv4_filter));
@@ -2625,8 +2629,9 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec *uverbs_spec,
 		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
-		if (uverbs_spec->tcp_udp.size != sizeof(struct ib_uverbs_flow_spec_tcp_udp))
+		if (uverbs_spec_hdr->size != sizeof(struct ib_uverbs_flow_spec_tcp_udp))
 			return -EINVAL;
+		uverbs_spec = (struct ib_uverbs_flow_spec *)uverbs_spec_hdr;
 		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
 		memcpy(&ib_spec->tcp_udp.val, &uverbs_spec->tcp_udp.val,
 		       sizeof(struct ib_flow_tcp_udp_filter));
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
