From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH net-next] i40iw: remove use of VLAN_TAG_PRESENT
Date: Thu, 08 Nov 2018 18:44:49 +0100
Message-ID: <af1c14d14054c8a62ffd56487f507b2110d5ed73.1541698641.git.mirq-linux@rere.qmqm.pl>
References: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Claudiu Manoil <claudiu.manoil@nxp.com>, Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 771eb6bd0785..4b3999d88c9e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -404,7 +404,7 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
 	if (pdata)
 		pd_len = pdata->size;
 
-	if (cm_node->vlan_id < VLAN_TAG_PRESENT)
+	if (cm_node->vlan_id <= VLAN_VID_MASK)
 		eth_hlen += 4;
 
 	if (cm_node->ipv4)
@@ -433,7 +433,7 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
 
 		ether_addr_copy(ethh->h_dest, cm_node->rem_mac);
 		ether_addr_copy(ethh->h_source, cm_node->loc_mac);
-		if (cm_node->vlan_id < VLAN_TAG_PRESENT) {
+		if (cm_node->vlan_id <= VLAN_VID_MASK) {
 			((struct vlan_ethhdr *)ethh)->h_vlan_proto = htons(ETH_P_8021Q);
 			vtag = (cm_node->user_pri << VLAN_PRIO_SHIFT) | cm_node->vlan_id;
 			((struct vlan_ethhdr *)ethh)->h_vlan_TCI = htons(vtag);
@@ -463,7 +463,7 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
 
 		ether_addr_copy(ethh->h_dest, cm_node->rem_mac);
 		ether_addr_copy(ethh->h_source, cm_node->loc_mac);
-		if (cm_node->vlan_id < VLAN_TAG_PRESENT) {
+		if (cm_node->vlan_id <= VLAN_VID_MASK) {
 			((struct vlan_ethhdr *)ethh)->h_vlan_proto = htons(ETH_P_8021Q);
 			vtag = (cm_node->user_pri << VLAN_PRIO_SHIFT) | cm_node->vlan_id;
 			((struct vlan_ethhdr *)ethh)->h_vlan_TCI = htons(vtag);
@@ -3323,7 +3323,7 @@ static void i40iw_init_tcp_ctx(struct i40iw_cm_node *cm_node,
 
 	tcp_info->flow_label = 0;
 	tcp_info->snd_mss = cpu_to_le32(((u32)cm_node->tcp_cntxt.mss));
-	if (cm_node->vlan_id < VLAN_TAG_PRESENT) {
+	if (cm_node->vlan_id <= VLAN_VID_MASK) {
 		tcp_info->insert_vlan_tag = true;
 		tcp_info->vlan_tag = cpu_to_le16(((u16)cm_node->user_pri << I40IW_VLAN_PRIO_SHIFT) |
 						  cm_node->vlan_id);
-- 
2.19.1
