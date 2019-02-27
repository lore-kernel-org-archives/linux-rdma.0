From: Robert Eshleman <bobbyeshleman@gmail.com>
Subject: [PATCH 6/8] netxen: remove unnecessary memset(,0) calls
Date: Tue, 26 Feb 2019 22:09:53 -0800
Message-ID: <8448a151b01dc228987c820ac84845a832fd50c9.1551246708.git.bobbyeshleman@gmail.com>
References: <cover.1551246708.git.bobbyeshleman@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1551246708.git.bobbyeshleman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: bobbyeshleman@gmail.com
Cc: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Manish Chopra <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch reduces calls to memset(,0) by replacing memset(,0)
calls that only zero-out newly declared structs with simply
assigning those structs to zero structs.

It also removes a pci_alloc_consistent call followed by a memset(,0)
call by simply using pci_zalloc_consistent.

Signed-off-by: Robert Eshleman <bobbyeshleman@gmail.com>
---
 .../ethernet/qlogic/netxen/netxen_nic_ctx.c   | 36 +++++++------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
index 7503aa222392..f2010c032361 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c
@@ -99,8 +99,7 @@ netxen_issue_cmd(struct netxen_adapter *adapter, struct netxen_cmd_args *cmd)
 static int
 netxen_get_minidump_template_size(struct netxen_adapter *adapter)
 {
-	struct netxen_cmd_args cmd;
-	memset(&cmd, 0, sizeof(cmd));
+	struct netxen_cmd_args cmd = {0};
 	cmd.req.cmd = NX_CDRP_CMD_TEMP_SIZE;
 	memset(&cmd.rsp, 1, sizeof(struct _cdrp_cmd));
 	netxen_issue_cmd(adapter, &cmd);
@@ -120,7 +119,7 @@ netxen_get_minidump_template(struct netxen_adapter *adapter)
 	dma_addr_t md_template_addr;
 	void *addr;
 	u32 size;
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 	size = adapter->mdump.md_template_size;
 
 	if (size == 0) {
@@ -135,7 +134,6 @@ netxen_get_minidump_template(struct netxen_adapter *adapter)
 		return -ENOMEM;
 	}
 
-	memset(&cmd, 0, sizeof(cmd));
 	memset(&cmd.rsp, 1, sizeof(struct _cdrp_cmd));
 	cmd.req.cmd = NX_CDRP_CMD_GET_TEMP_HDR;
 	cmd.req.arg1 = LSD(md_template_addr);
@@ -233,9 +231,8 @@ nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, int mtu)
 {
 	u32 rcode = NX_RCODE_SUCCESS;
 	struct netxen_recv_context *recv_ctx = &adapter->recv_ctx;
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.cmd = NX_CDRP_CMD_SET_MTU;
 	cmd.req.arg1 = recv_ctx->context_id;
 	cmd.req.arg2 = mtu;
@@ -254,9 +251,8 @@ int
 nx_fw_cmd_set_gbe_port(struct netxen_adapter *adapter,
 			u32 speed, u32 duplex, u32 autoneg)
 {
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.cmd = NX_CDRP_CMD_CONFIG_GBE_PORT;
 	cmd.req.arg1 = speed;
 	cmd.req.arg2 = duplex;
@@ -276,7 +272,7 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	nx_cardrsp_sds_ring_t *prsp_sds;
 	struct nx_host_rds_ring *rds_ring;
 	struct nx_host_sds_ring *sds_ring;
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
 	dma_addr_t hostrq_phys_addr, cardrsp_phys_addr;
 	u64 phys_addr;
@@ -359,7 +355,6 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 	}
 
 	phys_addr = hostrq_phys_addr;
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.arg1 = (u32)(phys_addr >> 32);
 	cmd.req.arg2 = (u32)(phys_addr & 0xffffffff);
 	cmd.req.arg3 = rq_size;
@@ -413,9 +408,8 @@ static void
 nx_fw_cmd_destroy_rx_ctx(struct netxen_adapter *adapter)
 {
 	struct netxen_recv_context *recv_ctx = &adapter->recv_ctx;
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.arg1 = recv_ctx->context_id;
 	cmd.req.arg2 = NX_DESTROY_CTX_RESET;
 	cmd.req.arg3 = 0;
@@ -520,9 +514,8 @@ nx_fw_cmd_create_tx_ctx(struct netxen_adapter *adapter)
 static void
 nx_fw_cmd_destroy_tx_ctx(struct netxen_adapter *adapter)
 {
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.arg1 = adapter->tx_context_id;
 	cmd.req.arg2 = NX_DESTROY_CTX_RESET;
 	cmd.req.arg3 = 0;
@@ -538,9 +531,8 @@ int
 nx_fw_cmd_query_phy(struct netxen_adapter *adapter, u32 reg, u32 *val)
 {
 	u32 rcode;
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.arg1 = reg;
 	cmd.req.arg2 = 0;
 	cmd.req.arg3 = 0;
@@ -561,9 +553,8 @@ int
 nx_fw_cmd_set_phy(struct netxen_adapter *adapter, u32 reg, u32 val)
 {
 	u32 rcode;
-	struct netxen_cmd_args cmd;
+	struct netxen_cmd_args cmd = {0};
 
-	memset(&cmd, 0, sizeof(cmd));
 	cmd.req.arg1 = reg;
 	cmd.req.arg2 = val;
 	cmd.req.arg3 = 0;
@@ -763,15 +754,14 @@ int netxen_alloc_hw_resources(struct netxen_adapter *adapter)
 	recv_ctx = &adapter->recv_ctx;
 	tx_ring = adapter->tx_ring;
 
-	addr = pci_alloc_consistent(pdev,
-			sizeof(struct netxen_ring_ctx) + sizeof(uint32_t),
-			&recv_ctx->phys_addr);
-	if (addr == NULL) {
+	addr = pci_zalloc_consistent(pdev,
+				     sizeof(struct netxen_ring_ctx) + sizeof(uint32_t),
+				     &recv_ctx->phys_addr);
+	if (!addr) {
 		dev_err(&pdev->dev, "failed to allocate hw context\n");
 		return -ENOMEM;
 	}
 
-	memset(addr, 0, sizeof(struct netxen_ring_ctx));
 	recv_ctx->hwctx = addr;
 	recv_ctx->hwctx->ctx_id = cpu_to_le32(port);
 	recv_ctx->hwctx->cmd_consumer_offset =
-- 
2.20.1
