From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 14/20] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device cap flag
Date: Mon, 12 Jan 2015 12:11:06 -0500
Message-ID: <1421082672-22588-15-git-send-email-ira.weiny@intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a device capability flag to flag OPA MAD support on devices.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from RFC:
	Changed flag to indicate OPA MAD base version support
	Added device_cap_flags2 as device_cap_flags bits are limited

 include/rdma/ib_verbs.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5024f1f..83b39d5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -128,6 +128,10 @@ enum ib_device_cap_flags {
 	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
 };
 
+enum ib_device_cap_flags2 {
+	IB_DEVICE_OPA_MAD_SUPPORT	= 1
+};
+
 enum ib_signature_prot_cap {
 	IB_PROT_T10DIF_TYPE_1 = 1,
 	IB_PROT_T10DIF_TYPE_2 = 1 << 1,
@@ -210,6 +214,7 @@ struct ib_device_attr {
 	int			sig_prot_cap;
 	int			sig_guard_cap;
 	struct ib_odp_caps	odp_caps;
+	u64			device_cap_flags2;
 	u32			mad_size;
 };
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
