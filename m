From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Introduce VHCA tunnel device capability
Date: Mon,  1 Jul 2019 21:14:01 +0300
Message-ID: <20190701181402.25286-2-leon@kernel.org>
References: <20190701181402.25286-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190701181402.25286-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Max Gurtovoy <maxg@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

When using the device emulation feature (introduced in Bluefield-1 SOC),
a privileged function (the device emulation manager) will be able to
create a channel to execute commands on behalf of the emulated function.

This channel will be a general object of type VHCA_TUNNEL that will have
a unique ID for each emulated function. This ID will be passed in each
cmd that will be issued by the emulation SW in a well known offset in
the command header.

This channel is needed since the emulated function doesn't have a normal
command interface to the HCA HW, but some basic configuration for that
function is needed (e.g. initialize and enable the HCA). For that matter,
a specific command-set was defined and only those commands will be issued
by the HCA.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5d2bf91e130b..a35e545a8de0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1329,7 +1329,13 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_6c0[0x4];
 	u8         flex_parser_id_geneve_tlv_option_0[0x4];
-	u8         reserved_at_6c8[0x138];
+	u8         reserved_at_6c8[0x18];
+
+	u8         reserved_at_6e0[0xa0];
+
+	u8         vhca_tunnel_commands[0x40];
+
+	u8         reserved_at_7c0[0x40];
 };
 
 enum mlx5_flow_destination_type {
@@ -9560,7 +9566,7 @@ struct mlx5_ifc_general_obj_in_cmd_hdr_bits {
 	u8         opcode[0x10];
 	u8         uid[0x10];
 
-	u8         reserved_at_20[0x10];
+	u8         vhca_tunnel_id[0x10];
 	u8         obj_type[0x10];
 
 	u8         obj_id[0x20];
-- 
2.20.1
