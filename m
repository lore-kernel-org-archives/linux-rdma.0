From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] i40iw: Add missing VLAN priority
Date: Tue, 19 Sep 2017 09:19:12 -0500
Message-ID: <20170919141913.10172-5-shiraz.saleem@intel.com>
References: <20170919141913.10172-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170919141913.10172-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Set the VLAN priority which is in the upper 3 bits of the VLAN
tag field in the QP context.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 3 ++-
 drivers/infiniband/hw/i40iw/i40iw_cm.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 14f36ba..b721544 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3255,7 +3255,8 @@ static void i40iw_init_tcp_ctx(struct i40iw_cm_node *cm_node,
 	tcp_info->snd_mss = cpu_to_le32(((u32)cm_node->tcp_cntxt.mss));
 	if (cm_node->vlan_id < VLAN_TAG_PRESENT) {
 		tcp_info->insert_vlan_tag = true;
-		tcp_info->vlan_tag = cpu_to_le16(cm_node->vlan_id);
+		tcp_info->vlan_tag = cpu_to_le16(((u16)cm_node->user_pri << I40IW_VLAN_PRIO_SHIFT) |
+						  cm_node->vlan_id);
 	}
 	if (cm_node->ipv4) {
 		tcp_info->src_port = cpu_to_le16(cm_node->loc_port);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
index 2e52e38..8626e7f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.h
@@ -71,6 +71,8 @@
 #define	I40IW_HW_IRD_SETTING_32	32
 #define	I40IW_HW_IRD_SETTING_64	64
 
+#define I40IW_VLAN_PRIO_SHIFT   13
+
 enum ietf_mpa_flags {
 	IETF_MPA_FLAGS_MARKERS = 0x80,	/* receive Markers */
 	IETF_MPA_FLAGS_CRC = 0x40,	/* receive Markers */
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
