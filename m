From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 06/17] verbs: Add missing endian annotations to kern-abi.h
Date: Thu, 11 Jan 2018 15:13:29 -0700
Message-ID: <20180111221340.965-7-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Copied from the kernel headers.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/kern-abi.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 52b6c8f5b3d621..e4bca3aea4f906 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -768,8 +768,8 @@ struct ibv_kern_send_wr {
 struct ibv_kern_eth_filter {
 	__u8  dst_mac[6];
 	__u8  src_mac[6];
-	__u16  ether_type;
-	__u16  vlan_tag;
+	__be16  ether_type;
+	__be16  vlan_tag;
 };
 
 struct ibv_kern_spec_eth {
@@ -794,8 +794,8 @@ struct ibv_kern_spec_ipv4 {
 };
 
 struct ibv_kern_ipv4_ext_filter {
-	__u32 src_ip;
-	__u32 dst_ip;
+	__be32 src_ip;
+	__be32 dst_ip;
 	__u8  proto;
 	__u8  tos;
 	__u8  ttl;
@@ -813,7 +813,7 @@ struct ibv_kern_spec_ipv4_ext {
 struct ibv_kern_ipv6_filter {
 	__u8  src_ip[16];
 	__u8  dst_ip[16];
-	__u32 flow_label;
+	__be32 flow_label;
 	__u8  next_hdr;
 	__u8  traffic_class;
 	__u8  hop_limit;
@@ -829,8 +829,8 @@ struct ibv_kern_spec_ipv6 {
 };
 
 struct ibv_kern_tcp_udp_filter {
-	__u16 dst_port;
-	__u16 src_port;
+	__be16 dst_port;
+	__be16 src_port;
 };
 
 struct ibv_kern_spec_tcp_udp {
@@ -850,7 +850,7 @@ struct ibv_kern_spec_action_tag {
 };
 
 struct ibv_kern_tunnel_filter {
-	__u32 tunnel_id;
+	__be32 tunnel_id;
 };
 
 struct ibv_kern_spec_tunnel {
@@ -897,6 +897,7 @@ struct ibv_kern_flow_attr {
 	 * struct ibv_kern_flow_spec_xxx
 	 * struct ibv_kern_flow_spec_yyy
 	 */
+	struct ib_uverbs_flow_spec_hdr flow_specs[0];
 };
 
 struct ibv_post_send {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
