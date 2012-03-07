From: <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] be2net: Added function to issue mailbox cmd on MQ.
Date: Wed, 7 Mar 2012 23:15:15 +0530
Message-ID: <c67f2a7a-af96-4551-bef9-d340ebbd58e6@exht1.ad.emulex.com>
References: <1331142316-23681-1-git-send-email-parav.pandit@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331142316-23681-1-git-send-email-parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

- Added generic function to issue mailbox cmd on MQ as export function.
- RoCE driver will use this before it setups its own MQ.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c |   39 +++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 0fcb456..19037b0 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -15,6 +15,7 @@
  * Costa Mesa, CA 92626
  */
 
+#include <linux/module.h>
 #include "be.h"
 #include "be_cmds.h"
 
@@ -2391,3 +2392,41 @@ err:
 	spin_unlock_bh(&adapter->mcc_lock);
 	return status;
 }
+
+int be_roce_mcc_cmd(void *netdev_handle, void *wrb_payload,
+			int wrb_payload_size, u16 *cmd_status, u16 *ext_status)
+{
+	struct be_adapter *adapter = netdev_priv(netdev_handle);
+	struct be_mcc_wrb *wrb;
+	struct be_cmd_req_hdr *hdr = (struct be_cmd_req_hdr *) wrb_payload;
+	struct be_cmd_req_hdr *req;
+	struct be_cmd_resp_hdr *resp;
+	int status;
+
+	spin_lock_bh(&adapter->mcc_lock);
+
+	wrb = wrb_from_mccq(adapter);
+	if (!wrb) {
+		status = -EBUSY;
+		goto err;
+	}
+	req = embedded_payload(wrb);
+	resp = embedded_payload(wrb);
+
+	be_wrb_cmd_hdr_prepare(req, hdr->subsystem,
+			       hdr->opcode, wrb_payload_size, wrb, NULL);
+	memcpy(req, wrb_payload, wrb_payload_size);
+	be_dws_cpu_to_le(req, wrb_payload_size);
+
+	status = be_mcc_notify_wait(adapter);
+	if (cmd_status)
+		*cmd_status = (status & 0xffff);
+	if (ext_status)
+		*ext_status = 0;
+	memcpy(wrb_payload, resp, sizeof(*resp) + resp->response_length);
+	be_dws_le_to_cpu(wrb_payload, sizeof(*resp) + resp->response_length);
+err:
+	spin_unlock_bh(&adapter->mcc_lock);
+	return status;
+}
+EXPORT_SYMBOL(be_roce_mcc_cmd);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
