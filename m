From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 1/8] verbs: Fix typo in copying IBV_FLOW_SPEC_UDP/TCP 'val'
Date: Tue,  5 Dec 2017 16:17:14 -0700
Message-ID: <20171205231721.19410-2-jgg@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The 'val' is a struct ibv_flow_tcp_udp_filter, not a ipv4_filter.

ipv4_filter is 8 bytes while tcp_udp_filter is only 4 bytes. So this
does not result in any bug, it is just a mistake.

Fixes: 389de6a6ef4e ("Add receive flow steering support")
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 62fcd0e4e2f400..b957550ed6fbdb 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1844,7 +1844,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 	case IBV_FLOW_SPEC_UDP | IBV_FLOW_SPEC_INNER:
 		kern_spec->tcp_udp.size = sizeof(struct ibv_kern_spec_tcp_udp);
 		memcpy(&kern_spec->tcp_udp.val, &ib_spec->tcp_udp.val,
-		       sizeof(struct ibv_flow_ipv4_filter));
+		       sizeof(struct ibv_flow_tcp_udp_filter));
 		memcpy(&kern_spec->tcp_udp.mask, &ib_spec->tcp_udp.mask,
 		       sizeof(struct ibv_flow_tcp_udp_filter));
 		break;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
