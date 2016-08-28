From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/core: Add more fields to IPv6 flow specification
Date: Sun, 28 Aug 2016 14:11:38 +0300
Message-ID: <1472382700-30216-4-git-send-email-leon@kernel.org>
References: <1472382700-30216-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382700-30216-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the following fields to IPv6 flow filter specification:
1. Traffic Class
2. Flow Label
3. Next Header
4. Hop Limit

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ++++
 include/rdma/ib_verbs.h              | 4 ++++
 include/uapi/rdma/ib_user_verbs.h    | 9 +++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 84c0794..8318623 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3158,6 +3158,10 @@ static int kern_spec_to_ib_spec(struct ib_uverbs_flow_spec *kern_spec,
 		ib_spec->size = sizeof(struct ib_flow_spec_ipv6);
 		memcpy(&ib_spec->ipv6.val, kern_spec_val, actual_filter_sz);
 		memcpy(&ib_spec->ipv6.mask, kern_spec_mask, actual_filter_sz);
+
+		if ((ntohl(ib_spec->ipv6.mask.flow_label)) >= BIT(20) ||
+		    (ntohl(ib_spec->ipv6.val.flow_label)) >= BIT(20))
+			return -EINVAL;
 		break;
 	case IB_FLOW_SPEC_TCP:
 	case IB_FLOW_SPEC_UDP:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c0f9d88..a02a6e1 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1655,6 +1655,10 @@ struct ib_flow_spec_ipv4 {
 struct ib_flow_ipv6_filter {
 	u8	src_ip[16];
 	u8	dst_ip[16];
+	__be32	flow_label;
+	u8	next_hdr;
+	u8	traffic_class;
+	u8	hop_limit;
 	/* Must be last */
 	u8	real_sz[0];
 };
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 6deca2d..7e35241 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -872,8 +872,13 @@ struct ib_uverbs_flow_spec_tcp_udp {
 };
 
 struct ib_uverbs_flow_ipv6_filter {
-	__u8 src_ip[16];
-	__u8 dst_ip[16];
+	__u8    src_ip[16];
+	__u8    dst_ip[16];
+	__be32	flow_label;
+	__u8	next_hdr;
+	__u8	traffic_class;
+	__u8	hop_limit;
+	__u8	reserved;
 };
 
 struct ib_uverbs_flow_spec_ipv6 {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
