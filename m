From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/10] IB/core: Check against uverbs structure size while parsing flow_spec
Date: Wed,  9 Oct 2013 23:12:48 +0200
Message-ID: <2dae8bae7060cf48cc5570afa44405b3439ffeb3.1381351017.git.ydroneaud@opteya.com>
References: <cover.1381351016.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of checking input size against the kernel verbs
data structure, it's safer to check input size against
uverbs data structure.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Link: http://marc.info/?i=cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Link: http://mid.gmane.org/cover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
---
 drivers/infiniband/core/uverbs_cmd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0ea5529..106e997 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2606,18 +2606,18 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec *uverbs_spec,
 
 	switch (ib_spec->type) {
 	case IB_FLOW_SPEC_ETH:
-		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
-		if (ib_spec->eth.size != uverbs_spec->eth.size)
+		if (uverbs_spec->eth.size != sizeof(struct ib_uverbs_flow_spec_eth))
 			return -EINVAL;
+		ib_spec->eth.size = sizeof(struct ib_flow_spec_eth);
 		memcpy(&ib_spec->eth.val, &uverbs_spec->eth.val,
 		       sizeof(struct ib_flow_eth_filter));
 		memcpy(&ib_spec->eth.mask, &uverbs_spec->eth.mask,
 		       sizeof(struct ib_flow_eth_filter));
 		break;
 	case IB_FLOW_SPEC_IPV4:
-		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
-		if (ib_spec->ipv4.size != uverbs_spec->ipv4.size)
+		if (uverbs_spec->ipv4.size != sizeof(struct ib_uverbs_flow_spec_ipv4))
 			return -EINVAL;
+		ib_spec->ipv4.size = sizeof(struct ib_flow_spec_ipv4);
 		memcpy(&ib_spec->ipv4.val, &uverbs_spec->ipv4.val,
 		       sizeof(struct ib_flow_ipv4_filter));
 		memcpy(&ib_spec->ipv4.mask, &uverbs_spec->ipv4.mask,
@@ -2625,9 +2625,9 @@ static int uverbs_spec_to_ib_spec(struct ib_uverbs_flow_spec *uverbs_spec,
 		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
-		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
-		if (ib_spec->tcp_udp.size != uverbs_spec->tcp_udp.size)
+		if (uverbs_spec->tcp_udp.size != sizeof(struct ib_uverbs_flow_spec_tcp_udp))
 			return -EINVAL;
+		ib_spec->tcp_udp.size = sizeof(struct ib_flow_spec_tcp_udp);
 		memcpy(&ib_spec->tcp_udp.val, &uverbs_spec->tcp_udp.val,
 		       sizeof(struct ib_flow_tcp_udp_filter));
 		memcpy(&ib_spec->tcp_udp.mask, &uverbs_spec->tcp_udp.mask,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
