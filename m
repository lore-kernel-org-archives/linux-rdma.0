From: Joe Perches <joe@perches.com>
Subject: [PATCH] iscsi_iser: Add missing newlines to logging messages
Date: Mon, 07 Oct 2013 15:44:50 -0700
Message-ID: <1381185890.2081.223.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Logging messages need terminating newlines to avoid
possible message interleaving.  Add them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index dd03cfe..dfb62e3 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -481,28 +481,28 @@ iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
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
