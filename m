From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 1/5] verbs: Expose tag matching capabilities
Date: Mon, 12 Jun 2017 09:42:43 +0300
Message-ID: <1497249767-15353-2-git-send-email-artemyko@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497249767-15353-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Expose tag matching capabilities and show them in ibv_devinfo.

* max_rndv_hdr_size - Max size of RNDV message
* max_num_tags - Max number of entries in tag matching list
* max_ops - Max number of outstanding list operations
* max_sge - Max number of SGE in a tag matching entry
* capability_flags - TM capabilities mask:
    - IBV_TM_CAP_RC - Support tag matching on RC transport

Change-Id: I6f15a6db209155be6406bb54c714796047979f68
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index b27dfd1..43fa386 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -259,6 +259,23 @@ enum ibv_raw_packet_caps {
 	IBV_RAW_PACKET_CAP_IP_CSUM		= 1 << 2,
 };
 
+enum ibv_tm_cap_flags {
+	IBV_TM_CAP_RC		    = 1 << 0
+};
+
+struct ibv_tm_caps {
+	/* Max size for RNDV message */
+	uint32_t max_rndv_hdr_size;
+	/* Max number of entries in tag matching list */
+	uint32_t max_num_tags;
+	/* TM capabilities mask - enumerated in ibv_tm_cap_flags */
+	uint32_t capability_flags;
+	/* Max number of outstanding list operations */
+	uint32_t max_ops;
+	/* Max number of SGE in a tag matching entry */
+	uint32_t max_sge;
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -271,6 +288,7 @@ struct ibv_device_attr_ex {
 	uint32_t		max_wq_type_rq;
 	struct ibv_packet_pacing_caps packet_pacing_caps;
 	uint32_t		raw_packet_caps; /* Use ibv_raw_packet_caps */
+	struct ibv_tm_caps	tm_caps;
 };
 
 enum ibv_mtu {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
