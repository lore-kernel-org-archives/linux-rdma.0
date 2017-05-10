From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] nes: Don't set 0-length FULPDU RTR indication control flag
Date: Wed, 10 May 2017 16:46:39 -0500
Message-ID: <1494452800-25896-2-git-send-email-tatyana.e.nikolova@intel.com>
References: <1494452800-25896-1-git-send-email-tatyana.e.nikolova@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494452800-25896-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Don't set control flag for 0-length FULPDU (Send) RTR indication
in the enhanced MPA Request/Reply frames, because it isn't supported.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index fb983df..06a55f6 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -610,7 +610,6 @@ static void build_mpa_v2(struct nes_cm_node *cm_node,
 		ctrl_ord = cm_node->ord_size & IETF_NO_IRD_ORD;
 	}
 	ctrl_ird |= IETF_PEER_TO_PEER;
-	ctrl_ird |= IETF_FLPDU_ZERO_LEN;
 
 	switch (mpa_key) {
 	case MPA_KEY_REQUEST:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
