From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC rdma-core] Verbs: Introduce resource domain
Date: Sun, 17 Sep 2017 14:48:42 +0300
Message-ID: <1505648922-21346-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Resource domain represents a collection of IB resources (as of QP, CQ,
etc.) which are accessed by an application from the same context (e.g.
same thread) and as such can share hardware and software resources to
allow smarter management of resources by the provider library and better
performance.

Today, without the resource domain, provider libraries ensure thread
safety for all resources and implement some arbitrary logic regarding
hardware resource management (e.g. pre-allocated limit pools, dynamic
allocation, round-robin vs lru, etc.).

We would like to allow the application to explicitly specify which
resources are going to be used by which resource domains, and by that
allow the libraries to improve the HW and SW resource utilization.

When application creates several resources on the same resource domain
index, the provider library can share the related hardware resources
between them and as such better utilize its available resources.
On the other hand if each resource is created by the application on a
dedicated resource domain index it will use a dedicated hardware
resource.

For example if few QPs are used by the application from the same thread
the hardware doorbell can be shared between them. This drops the need to
allocate a dedicate doorbell per QP or share doorbells which are handled
by different threads.

On the other hand if few QPs are not logically related an application
can enjoy the option to get a dedicated resource per QP and prevent the
need to take a lock in its data path flow to protect that doorbell
update operations.

This RFC patch introduces the following verbs extensions to support that:
1) Extend ibv_query_device_ex to return max_resource_domains.
This attribute represents range of valid [0..max_resource_domains] device
domains that resources can be part of. Each driver which supports
this feature will return a positive value, declaring its max unique
resource domains that can be used.

2) Extend ibv_create_qp_ex to get resource_domain to enable associating
a QP into a specific resource domain. Each library will use the input
value to manage the related hardware resources, and reduce the amount of
locks required.

Application is required to use a single context when accessing any of
the IB objects per each resource domain.

Specifically, we plan to use this API in mlx5 driver to better manage
the doorbell (UAR) hardware resource which is a limited hardware resource
by exposing an option from kernel to allocate it on demand and share
among QPs or attach it to a specific a QP based on application needs
which are represented by the resource domain property.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 8cdf8ab..b2b51c1 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -272,6 +272,7 @@ struct ibv_device_attr_ex {
 	uint32_t		max_wq_type_rq;
 	struct ibv_packet_pacing_caps packet_pacing_caps;
 	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
+	uint32_t		max_resource_domains;
 };
 
 enum ibv_mtu {
@@ -785,7 +786,8 @@ enum ibv_qp_init_attr_mask {
 	IBV_QP_INIT_ATTR_MAX_TSO_HEADER = 1 << 3,
 	IBV_QP_INIT_ATTR_IND_TABLE	= 1 << 4,
 	IBV_QP_INIT_ATTR_RX_HASH	= 1 << 5,
-	IBV_QP_INIT_ATTR_RESERVED	= 1 << 6
+	IBV_QP_INIT_ATTR_RES_DOMAIN	= 1 << 6,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 7
 };
 
 enum ibv_qp_create_flags {
@@ -821,6 +823,7 @@ struct ibv_qp_init_attr_ex {
 	struct ibv_rwq_ind_table       *rwq_ind_tbl;
 	struct ibv_rx_hash_conf	rx_hash_conf;
 	uint32_t		source_qpn;
+	uint32_t		resource_domain;
 };
 
 enum ibv_qp_open_attr_mask {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
