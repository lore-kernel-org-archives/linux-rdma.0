From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 4/7] IB/uverbs: Add more fields to IPv4 flow specification
Date: Tue, 30 Aug 2016 16:58:33 +0300
Message-ID: <1472565516-11591-5-git-send-email-leon@kernel.org>
References: <1472565516-11591-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472565516-11591-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add the following fields to IPv4 flow filter specification:
1. Type of Service
2. Time to Live
3. Flags
4. Protocol

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h           | 11 +++++++++++
 include/uapi/rdma/ib_user_verbs.h |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d4144b2..5f4000d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1629,9 +1629,20 @@ struct ib_flow_spec_ib {
 	struct ib_flow_ib_filter mask;
 };

+/* IPv4 header flags */
+enum ib_ipv4_flags {
+	IB_IPV4_DONT_FRAG = 0x2, /* Don't enable packet fragmentation */
+	IB_IPV4_MORE_FRAG = 0X4  /* For All fragmented packets except the
+				    last have this flag set */
+};
+
 struct ib_flow_ipv4_filter {
 	__be32	src_ip;
 	__be32	dst_ip;
+	u8	proto;
+	u8	tos;
+	u8	ttl;
+	u8	flags;
 	/* Must be last */
 	u8	real_sz[0];
 };
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 7f035f4b..6deca2d 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -834,6 +834,10 @@ struct ib_uverbs_flow_spec_eth {
 struct ib_uverbs_flow_ipv4_filter {
 	__be32 src_ip;
 	__be32 dst_ip;
+	__u8	proto;
+	__u8	tos;
+	__u8	ttl;
+	__u8	flags;
 };

 struct ib_uverbs_flow_spec_ipv4 {
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
