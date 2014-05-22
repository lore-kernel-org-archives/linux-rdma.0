From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/4] IB/iser: Add missing newlines to logging messages
Date: Thu, 22 May 2014 11:00:20 +0300
Message-ID: <1400745621-9978-4-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
References: <1400745621-9978-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400745621-9978-1-git-send-email-ogerlitz-lZu6o6FoHf8DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Logging messages need terminating newlines to avoid
possible message interleaving.  Add them.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f217488..eb79739 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -508,28 +508,28 @@ iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_HDRDGST_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("DataDigest wasn't negotiated to None");
+			iser_err("DataDigest wasn't negotiated to None\n");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("DataDigest wasn't negotiated to None");
+			iser_err("DataDigest wasn't negotiated to None\n");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_IFMARKER_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("IFMarker wasn't negotiated to No");
+			iser_err("IFMarker wasn't negotiated to No\n");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_OFMARKER_EN:
 		sscanf(buf, "%d", &value);
 		if (value) {
-			iser_err("OFMarker wasn't negotiated to No");
+			iser_err("OFMarker wasn't negotiated to No\n");
 			return -EPROTO;
 		}
 		break;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
