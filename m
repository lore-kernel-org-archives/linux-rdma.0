From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 1/4] RDMA/ocrdma: Fix vlan-id assignment in qp parameters
Date: Thu, 24 Dec 2015 13:14:05 -0500
Message-ID: <1450980848-18945-2-git-send-email-devesh.sharma@avagotech.com>
References: <1450980848-18945-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450980848-18945-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

vlan-id is wrongly getting as 0 when PFC is enabled.
Set vlan-id configured by user in QP parameters.
In case vlan interface is not used, flash a warning to
user to configure vlan and assign vlan-id as 0 in qp params.

Fixes: dbf727de7440 ('IB/core: Use GID table in AH creation and dmac resolution')
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 30f67be..4fc2bb4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2515,9 +2515,10 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
 	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] << 8);
 
-	if (vlan_id < 0x1000) {
-		if (dev->pfc_state) {
-			vlan_id = 0;
+	if (vlan_id == 0xFFFF)
+		vlan_id = 0;
+	if (vlan_id || dev->pfc_state) {
+		if (!vlan_id) {
 			pr_err("ocrdma%d:Using VLAN with PFC is recommended\n",
 			       dev->id);
 			pr_err("ocrdma%d:Using VLAN 0 for this connection\n",
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
