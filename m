Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012009.outbound.protection.outlook.com [52.101.48.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AF140099A;
	Thu,  3 Sep 2026 08:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425721; cv=fail; b=Dx3TonChKy0YFdMwpduJiiB2SldGj2sElz7Z8g3TqePpnLoyicP5Xe0U9JSX3dlsECSnRul/Yi52kdSzYVvwe3aaCD0dKDldTCZAwmT+tE9jXF8fSAchMWymm3QumqLt++EXuF6LmXdnbK5744D6ch81WoTR8xpQCP+HesrZDIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425721; c=relaxed/simple;
	bh=tUrlq+M/IVVTKN3Pi2xZdUHQPr/sRdSUKD0f/gYUkME=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOxChpK3U8i9d0i55gfMJpG0QxcFnFp+b6wsn5WWs0rS6Dekn95xzHyiTmanQKwElYobNRurO8dmYmqUHQHxMh6CEVF+CDHfgm7kE/DXDQe3WlZK88QlbxTynCODM03okxOHi647Y3cpOmpMkVcbO+ya+rls4B/XTA+FHh3NuJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bgI2OmPB; arc=fail smtp.client-ip=52.101.48.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bgI2OmPB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X8HJCkey3jXJ12at3R5sKPiZjrZi7zOXwO5xad33LXVLF+vwi9X9qt/3V/gryM0gyfmRbypunfy2nv7PRVLBv+w+SPaF0So2g0YNFQzLynOxSXMa/jlUSA+/JPs6Pj0ZF1ltBjuTYvM6AYlzLa7eYgsiLOu0B00Sb73S9w8xvsbpVhnfB0hx5WVbhz0E7TN46UwMHkd5p7AAnkTD17CsxpMZb0Re+IrEDxXKEA/L6PpAF1ithCVA/nZ3z/27fbollnN4s54wpnewmME+Bl8YqXFvSOxO6mAHt7opBrGPUjI5zADXzy1KH1zzATieAm3meeLOvuX4msGN905CvlsElw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5RqwQlvkzja2c186lE6lx5Eb5SMKewXulB72chfcLs=;
 b=M1o3Gg5fs4eGHpuUC7iN17Oyl10UA4Rff2kLgxxASJWcbjDo2IfZbED7+erOfVMHZvgnSiAnGWxSv4ETo4L5i3qPCaimbZQVdeIXva8ZS13NV/eEmFkF6ymipDW8PgSaESaPQlKd/+BfGQZMHFg+HnAR5WzfdLqkeFOlJXlJrttY8B9MjPw+VXNj6/YU+F/EouuduUopQwZK9oxDoHYxuPp84au26v/IUTt+CpESaO856T0tk8k9Uk1K7D2VyoEdZZ2k9SGu+omU4smg3W0k2AY9At+/fdth+2UoIHKORraqX/AoyEki+XXr/+VyUNeajSYlipmgrGkuDdnCkPAPnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5RqwQlvkzja2c186lE6lx5Eb5SMKewXulB72chfcLs=;
 b=bgI2OmPBEiuU2pajQrD3O8k0cCnqrY7+xORffxCFUkMiaC5led7SpJIo0NLG/AZvHY9o9N9GYshCmOSJR/WJDoyQ8nBflRBlzKepX0IAM1ehoWKNSim+LVGDLt3nQJfmNnhEvvKsrOhdJWoLZUMd/nVi145f2M29kVtAy3seidZ5+zLG2NNKztMvL04LpOxdzxeVcVq4FDuTIcd0mJkZOnOcwFaRFNxrTd4abyqno0ju2SP2+DTnpPKZXvTfONEoQtjKZI283QVhB/gCrBJkJlbW7edX1tOIq6Ud4y9AGZxbhGxBBANmhvVQ7R6EDJ0BxoqOMuE9sB9+G8ulxzd+hA==
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by DS7PR12MB8291.namprd12.prod.outlook.com (2603:10b6:8:e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:55:09 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:303:6a:cafe::1f) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 08:55:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:55:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:48 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:54:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:54:36 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 09/15] net/mlx5e: psp: Add an rx_decap steering table
Date: Thu, 3 Sep 2026 11:52:09 +0300
Message-ID: <20260903085215.3691657-10-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260903085215.3691657-1-tariqt@nvidia.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|DS7PR12MB8291:EE_
X-MS-Office365-Filtering-Correlation-Id: eaece5c4-c7ac-480d-4c58-08df09990e80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|7416014|376014|1800799024|6133799003|56012099006|10067099003|5023799004|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	sbWCjk0nddOZh9xzcsGSrfPdLtXLQQv5cgBZTCjT+zJNYvU/qfRh3AEnPv8MLc6qCLtRLbx02PVInQ8g7O76aNsdWf7AHCZXbAbw9i+ZY41FUk/1Lez2156c2oZolyV3SlaXZxz6WotpfmD2bSBvw61o58UglPfMewTBoBIYu/js5sdEuPJMYYEN93PlVsdWm+eq9ktqmz3I2XL0e7qmkZdIRrguEmnGc1aeOuZgogVymm9oHHKOG5Ce0sw2knl09yoCa9JFb89ayEREstTuaqgDcvcSF3zFsvpawby931ALEem12X/mC2qzW+AB2fyyeDTlJCYk+6LRi9BrlIZbIYvf0SHcL4QtMgnjW16Lhs7/cH11Fs3ez78sZilW4ZaKl8Ql6zkQol3UaBTwQ0rXpD24bXjGuaUB8gOZ8/PnTTEihgnaehB1KSoSKTFw7TX619lqIQB7e1SLlKPBPgPDaIw8rUX0NAHwwN0VTnRxmbHN2G43uRQfqx9NksCerhZwsOOAOmmVDy7xRog/ki19G2RhhAc5Hs+gP45TPdLou8D5i1Bk48VpUPpn/p9PD2k2IemM8co2tf3LJBpm6uej6XcizCI+rqbAPJA6Xhj97hwXkFXzEbODCcdTtT+A8A3PzjrKYPn2KJHxnVJAhzty0eFmzRIx3YmZtTiOEv3YLHhQH7wToU+wRgJDvH+/WBNo7LIrEUARPNj3ng6Pdask1g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(7416014)(376014)(1800799024)(6133799003)(56012099006)(10067099003)(5023799004)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E+BKANkE0ObRlx2epdH40fY21paAThrB7FT7aAjlVcgq/tBC27qZm6jtYm4U/sdSHBii+ItZ3L3r45BpB9YH1K29idOuI40/39iEm8MDDR8ysIg/ugCG+7NwM3bZU1ZedxH68xslQ5p+YizH2w//T0R2enZUxsnKFbLt2W/pHK+tSoduaUE6UWT1IvB/1HlZnQdSPb3lR/wZ6XkyZ0993YNtO1845m/+DQwPhe65L6GrGjBQtFABFIZwybWw3vyyAKHpYx1T4HE8/0ZiZ745CyCDGQgYHr7KWBzFHwJL+klqgbVsmamK0X2RDPt9WZMsu7kqlNNqYi4SVhtVYwwtHTYrTpOkWTGDHP+y2B7rG8d+lKDtO64v78Pp+TLDeLL1dg8j2EsOYmPEV9CMJMlL76aakYW40UsKvFVH22Udk8+shgW5yBTF9ej86XGeJSE+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:55:08.6769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eaece5c4-c7ac-480d-4c58-08df09990e80
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8291

From: Cosmin Ratiu <cratiu@nvidia.com>

Introduce an additional steering table for PSP transport mode
decapsulation, containing:
- one rule per supported PSP version which does:
  - transport mode decap (removes UDP+PSP headers and PSP trailer)
    - recomputes iph->tot_len
    - recomputes IP checksum
    - reparses packet headers
  - copy SPI into reg_b (which ends up as cqe.ft_metadata)
  - set a decap marker and the PSP version in the flow_tag, so the RX
    handler can make sense of the packet
- default drop rule for unsupported PSP versions (per PSP spec).

Packets are forwarded to the previously added rx table, where:
- one rule forwards UDP traffic to the UDP default destination.
- default rule forwards traffic to the TTC table.

The reason is to avoid steering loops. If packets were to be injected
into the TTC directly after rx_decap, it may be possible to create a
steering loop with RX packets of the form IP|UDP|PSP|UDP|PSP...
The rx flow table guarantees that packets go through PSP steering at
most once.

The steering mode is saved in a new field 'fs.decap_enabled'.
Updating the mode is done through accel_psp_fs_rx_reconfigure(), which
creates the decap steering table if needed and possible. It then uses an
atomic rule update to redirect traffic to the new table.
This is now invoked with decap_wanted == false.
The intention is for failures creating the new table to not block
feature reconfig/PSP toggling. Decap table creation and traffic
redirection failures therefore result in a warning that PSP HW GRO will
not work.
Nothing happens on older HW/FW without the ability to decapsulate PSP
transport.

An upcoming patch will add dynamic reconfiguration of PSP steering based
on HW GRO.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../mellanox/mlx5/core/en_accel/psp.c         | 249 +++++++++++++++++-
 2 files changed, 248 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 4973fb473ff0..a802f80d90be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -98,6 +98,7 @@ enum {
 #if defined(CONFIG_MLX5_EN_PSP)
 	MLX5E_ACCEL_FS_PSP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 	MLX5E_ACCEL_FS_PSP_ERR_FT_LEVEL,
+	MLX5E_ACCEL_FS_PSP_DECAP_FT_LEVEL,
 	MLX5E_ACCEL_FS_PSP_RX_FT_LEVEL,
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 20d7f14fb4ac..84133cbf8689 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -23,6 +23,13 @@ enum accel_psp_syndrome {
 	PSP_BAD_TRAILER,
 };
 
+static const u8 psp_supported_versions[] = {
+	PSP_VERSION_HDR0_AES_GCM_128,
+	PSP_VERSION_HDR0_AES_GCM_256,
+};
+
+#define MLX5E_PSP_NUM_SUPPORTED_VERSIONS ARRAY_SIZE(psp_supported_versions)
+
 struct mlx5e_psp_tx_table {
 	struct mlx5_flow_namespace *ns;
 	struct mlx5_flow_table *ft;
@@ -43,6 +50,7 @@ struct mlx5e_psp_rx_decrypt_table {
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_handle *miss_rule;
+	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_flow_handle *rule;
 };
 
@@ -53,6 +61,15 @@ struct mlx5e_psp_rx_table {
 	struct mlx5_flow_handle *udp_rules[ACCEL_FS_PSP_NUM_TYPES];
 };
 
+struct mlx5e_psp_rx_decap_table {
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *drop_group;
+	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_pkt_reformat *reformat;
+	struct mlx5_flow_handle *rule[MLX5E_PSP_NUM_SUPPORTED_VERSIONS];
+	struct mlx5_flow_handle *unsupported_rule;
+};
+
 struct mlx5e_psp_fs {
 	struct mlx5_core_dev *mdev;
 	struct mlx5_fc *tx_counter;
@@ -64,9 +81,14 @@ struct mlx5e_psp_fs {
 	struct mlx5_fc *rx_auth_fail_counter;
 	struct mlx5_fc *rx_err_counter;
 	struct mlx5_fc *rx_bad_counter;
+	/* When set, steering is configured to decapsulate PSP (remove UDP+PSP
+	 * headers and PSP trailer) and hand off the SPI in cqe.ft_metadata.
+	 */
+	bool decap_enabled;
 
 	struct mlx5e_psp_rx_decrypt_table decrypt[ACCEL_FS_PSP_NUM_TYPES];
 	struct mlx5e_psp_rx_check_table check;
+	struct mlx5e_psp_rx_decap_table decap;
 	struct mlx5e_psp_rx_table rx;
 };
 
@@ -111,6 +133,15 @@ static void accel_psp_fs_del_flow_rule(struct mlx5_flow_handle **rule)
 	}
 }
 
+static void accel_psp_fs_dealloc_modify_hdr(struct mlx5_core_dev *dev,
+					    struct mlx5_modify_hdr **modhdr)
+{
+	if (*modhdr) {
+		mlx5_modify_header_dealloc(dev, *modhdr);
+		*modhdr = NULL;
+	}
+}
+
 static int accel_psp_fs_create_miss_group(struct mlx5_flow_table *ft,
 					  struct mlx5_flow_group **group)
 {
@@ -403,11 +434,164 @@ int accel_psp_fs_rx_check_ft_create(struct mlx5e_psp_fs *fs,
 	return err;
 }
 
+static
+void accel_psp_fs_rx_decap_ft_destroy(struct mlx5e_psp_fs *fs,
+				      struct mlx5e_psp_rx_decap_table *decap)
+{
+	int i;
+
+	accel_psp_fs_del_flow_rule(&decap->unsupported_rule);
+	for (i = 0; i < MLX5E_PSP_NUM_SUPPORTED_VERSIONS; i++)
+		accel_psp_fs_del_flow_rule(&decap->rule[i]);
+	if (decap->reformat) {
+		mlx5_packet_reformat_dealloc(fs->mdev, decap->reformat);
+		decap->reformat = NULL;
+	}
+	accel_psp_fs_dealloc_modify_hdr(fs->mdev, &decap->modify_hdr);
+	accel_psp_fs_destroy_flow_group(&decap->drop_group);
+	accel_psp_fs_destroy_ft(&decap->ft);
+	fs->decap_enabled = false;
+}
+
+static void setup_fte_psp_version(struct mlx5_flow_spec *spec, u8 version)
+{
+	void *misc_params_6;
+
+	memset(spec, 0, sizeof(*spec));
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_6;
+	misc_params_6 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				     misc_parameters_6);
+	MLX5_SET_TO_ONES(fte_match_set_misc6, misc_params_6, psp_version);
+	misc_params_6 = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				     misc_parameters_6);
+	MLX5_SET(fte_match_set_misc6, misc_params_6, psp_version, version);
+}
+
+static
+int accel_psp_fs_rx_decap_ft_create(struct mlx5e_psp_fs *fs,
+				    struct mlx5e_psp_rx_decap_table *decap)
+{
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
+	struct mlx5_pkt_reformat_params reformat_params = {};
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_destination dest = {};
+	struct mlx5_core_dev *mdev = fs->mdev;
+	struct mlx5_pkt_reformat *reformat;
+	struct mlx5_modify_hdr *modify_hdr;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	int i, err = 0;
+
+	spec = kvzalloc_obj(*spec);
+	if (!spec)
+		return -ENOMEM;
+
+	/* Create FT */
+	ft_attr.max_fte = 1 + MLX5E_PSP_NUM_SUPPORTED_VERSIONS;
+	ft_attr.level = MLX5E_ACCEL_FS_PSP_DECAP_FT_LEVEL;
+	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft_attr.autogroup.num_reserved_entries = 1;
+	err = accel_psp_fs_create_ft(fs, &ft_attr, &decap->ft);
+	if (err) {
+		mlx5_core_err(mdev, "fail to create psp decap rx ft err=%d\n",
+			      err);
+		goto out_spec;
+	}
+
+	/* Create drop group */
+	err = accel_psp_fs_create_miss_group(decap->ft, &decap->drop_group);
+	if (err) {
+		mlx5_core_err(mdev,
+			      "fail to create psp decap rx drop_group err=%d\n",
+			      err);
+		goto out_err;
+	}
+
+	/* Add default drop rule */
+	err = accel_psp_add_drop_rule(decap->ft, NULL, fs->rx_bad_counter,
+				      &decap->unsupported_rule);
+	if (err) {
+		mlx5_core_err(mdev,
+			      "fail to create psp decap unsupported versions drop rule err=%d\n",
+			      err);
+		goto out_err;
+	}
+
+	/* modify_hdr: copy SPI from REG_C_0 to REG_B */
+	MLX5_SET(copy_action_in, action, action_type, MLX5_ACTION_TYPE_COPY);
+	MLX5_SET(copy_action_in, action, src_field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
+	MLX5_SET(copy_action_in, action, src_offset, 0);
+	MLX5_SET(copy_action_in, action, length, 0);  /* 0 = 32 bits */
+	MLX5_SET(copy_action_in, action, dst_field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_B);
+	MLX5_SET(copy_action_in, action, dst_offset, 0);
+
+	modify_hdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL,
+					      1, action);
+	if (IS_ERR(modify_hdr)) {
+		err = PTR_ERR(modify_hdr);
+		goto out_err;
+	}
+	decap->modify_hdr = modify_hdr;
+
+	/* pkt_reformat: decap PSP transport */
+	reformat_params.type = MLX5_REFORMAT_TYPE_REMOVE_PSP_TRANSPORT;
+	reformat = mlx5_packet_reformat_alloc(mdev, &reformat_params,
+					      MLX5_FLOW_NAMESPACE_KERNEL);
+	if (IS_ERR(reformat)) {
+		err = PTR_ERR(reformat);
+		goto out_err;
+	}
+	decap->reformat = reformat;
+
+	for (i = 0; i < MLX5E_PSP_NUM_SUPPORTED_VERSIONS; i++) {
+		u8 version = psp_supported_versions[i];
+		struct mlx5_flow_act flow_act = {};
+
+		/* match(version) => decap, copy SPI, fwd to rx FT */
+		setup_fte_psp_version(spec, version);
+
+		/*
+		 * Override the flow tag set in the decrypt table with
+		 * the decap PSP marker and version.
+		 */
+		spec->flow_context.flags = FLOW_CONTEXT_HAS_TAG;
+		spec->flow_context.flow_tag =
+			FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PROTO_MASK,
+				   MLX5E_ACCEL_FLOW_TAG_PROTO_PSP_DECAP) |
+			FIELD_PREP(MLX5E_ACCEL_FLOW_TAG_PSP_VER_MASK, version);
+
+		flow_act.action = MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
+			MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
+			MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		flow_act.pkt_reformat = reformat;
+		flow_act.modify_hdr = modify_hdr;
+		dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dest.ft = fs->rx.ft;
+
+		rule = mlx5_add_flow_rules(decap->ft, spec, &flow_act, &dest, 1);
+		if (IS_ERR(rule)) {
+			err = PTR_ERR(rule);
+			goto out_err;
+		}
+		decap->rule[i] = rule;
+	}
+	goto out_spec;
+
+out_err:
+	accel_psp_fs_rx_decap_ft_destroy(fs, decap);
+out_spec:
+	kvfree(spec);
+	return err;
+}
+
 static void
 accel_psp_fs_rx_decrypt_ft_destroy(struct mlx5e_psp_fs *fs,
 				   struct mlx5e_psp_rx_decrypt_table *decrypt)
 {
 	accel_psp_fs_del_flow_rule(&decrypt->rule);
+	accel_psp_fs_dealloc_modify_hdr(fs->mdev, &decrypt->modify_hdr);
 	accel_psp_fs_del_flow_rule(&decrypt->miss_rule);
 	accel_psp_fs_destroy_flow_group(&decrypt->miss_group);
 	accel_psp_fs_destroy_ft(&decrypt->ft);
@@ -427,10 +611,12 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 				  struct mlx5e_psp_rx_decrypt_table *decrypt,
 				  struct mlx5_flow_destination *default_dest)
 {
+	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_core_dev *mdev = fs->mdev;
 	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_modify_hdr *modhdr;
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	int err = 0;
@@ -474,6 +660,24 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 	}
 	decrypt->miss_rule = rule;
 
+	/* Create modify_hdr to copy SPI to REG_C_0 */
+	MLX5_SET(copy_action_in, action, action_type, MLX5_ACTION_TYPE_COPY);
+	MLX5_SET(copy_action_in, action, src_field,
+		 MLX5_ACTION_IN_FIELD_PSP_HEADER_1);
+	MLX5_SET(copy_action_in, action, src_offset, 0);
+	MLX5_SET(copy_action_in, action, length, 0);  /* 0 = 32 bits */
+	MLX5_SET(copy_action_in, action, dst_field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
+	MLX5_SET(copy_action_in, action, dst_offset, 0);
+
+	modhdr = mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL, 1,
+					  action);
+	if (IS_ERR(modhdr)) {
+		err = PTR_ERR(modhdr);
+		goto out_err;
+	}
+	decrypt->modify_hdr = modhdr;
+
 	/* Add PSP RX decrypt rule */
 	setup_fte_udp_psp(spec, PSP_DEFAULT_UDP_PORT);
 
@@ -484,8 +688,10 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 			   MLX5E_ACCEL_FLOW_TAG_PROTO_PSP);
 
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_PSP;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
+		MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
+		MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	flow_act.modify_hdr = modhdr;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = fs->check.ft;
 	rule = mlx5_add_flow_rules(decrypt->ft, spec, &flow_act, &dest, 1);
@@ -506,6 +712,42 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 	return err;
 }
 
+static void accel_psp_fs_rx_reconfigure(struct mlx5e_psp_fs *fs,
+					bool decap_wanted)
+{
+	bool decap_supported =
+		MLX5_CAP_FLOWTABLE(fs->mdev,
+				   flow_table_properties_nic_receive.reformat_del_psp_transport);
+	bool decap_enable = decap_wanted && decap_supported;
+	struct mlx5_flow_destination dest = {};
+	int err;
+
+	if (decap_enable == fs->decap_enabled)
+		return;
+
+	/* Create the decap table if needed. */
+	if (decap_enable && !fs->decap.ft) {
+		err = accel_psp_fs_rx_decap_ft_create(fs, &fs->decap);
+		if (err)
+			goto out_err;
+	}
+
+	/* Redirect traffic to the correct table. */
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest.ft = decap_enable ? fs->decap.ft : fs->rx.ft;
+	err = mlx5_modify_rule_destination(fs->check.rule, &dest, NULL);
+	if (err)
+		goto out_err;
+
+	fs->decap_enabled = decap_enable;
+	return;
+
+out_err:
+	mlx5_core_warn(fs->mdev,
+		       "Failed to create/modify PSP decapsulation rules (err %d), HW GRO for PSP unavailable\n",
+		       err);
+}
+
 static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
@@ -518,6 +760,7 @@ static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 		accel_psp_fs_rx_decrypt_ft_destroy(fs, &fs->decrypt[i]);
 	}
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
+	accel_psp_fs_rx_decap_ft_destroy(fs, &fs->decap);
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
 	if (tc_blocked)
 		mlx5e_accel_unblock_tc_offload(fs->mdev);
@@ -565,6 +808,8 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 		mlx5_ttc_fwd_dest(ttc, fs_psp2tt(i), &dest);
 	}
 
+	accel_psp_fs_rx_reconfigure(fs, false);
+
 	return 0;
 
 err_decrypt_ft:
-- 
2.44.0

