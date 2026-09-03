Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012050.outbound.protection.outlook.com [40.93.195.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82745C701;
	Thu,  3 Sep 2026 08:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425637; cv=fail; b=loxkizcIU6qUQO6QF8qwIh0orM4ZgEglwsV75V2IqKZ2eCWs5RVmmcTn+xrjLAAgu7/3RnfGcVcJJ6Rbr5zKxXN8ZSuf6XSLtxysyEnApCpnj3ERWpQWTDRbHZz1+oco3/zfmwIhvD659jVFCHDPsVNSUuo0cM1HGE6Q0Ib0hVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425637; c=relaxed/simple;
	bh=/yVgWGQ5i6NhfGrZNZkTvdeFQCeJzczJgmXlUGs1q4k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cu+WXOcVgf8Cx+yamdpQ2tWxJ86LReXmJrfDS/8R8BN/rGdCyry/+apKTcVlFpz7dOm1aY/l4I+iJg07KmSMG/zmxM8snQkc0n5z29bIkLZsfmhVCFggUMHhrv3Yr5lVcoZHB/qUX6VBiyPwO6WoM2J0Km3uqyDqWlwi1xj8mRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AuJDz1uZ; arc=fail smtp.client-ip=40.93.195.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AuJDz1uZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FUBbVPxa714tQCanzxh5EEdhEGxLBc+oMExlSXgCC6BzwVwnxHSW1Uhc5Za5CZ+QxPeCgTnl0tlM6+Jy/h+8VTcCgVvq6PrQPGrnJg9PwKz9GCyXEoUQZzc2JdA6lxRkvvW9dCmqD6Nfw9HzStbhlwIecmKcCKXBRuX+6QvHKuV4iiKFdzMOTiPHQFs+3RpnLEXEMZSpBzs4/M1/CrGGGLrP4dT5g/HALBwuJFm+A4t8sL1ueTiAE4fU+Dlqz+gWdMbWQcESYEVHUCcvGuaatW506Km1lICsUqBB4N4aMTG4bdjfKCNAaCTG9KAp8iHSp9uENXzBJ6LlZcI21X5yaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NwjGJcrgwcc2qsyZSD1f+yo29MHX3+7gcnDlCIyfrWc=;
 b=emdn/p68UgLYkpmknwhXZxTicBIDmNE08bmFeeLe5T/fpur/IIdw25xJc9T/KxDSS7j0+TJl6WjwGDQn6WYjL1GM9QNW7YqMwEIeuU/o8eHXIhlg5W4d65+SHt6XPr80DUWjy8Fnq29znEq69EQahE88dTb8N+hTZGDp3MYHs4ZrPPACsgB/9BCrRbmzj1GygflO6CpKElS0MAjLezt4TVbVgiitU9sBTwg5Eh3M9HEisZNJt8IV3CzmMzdooH9QQseJDx5Iocrceqsmsb7Gbc5Tn8+HdvK3rcwfS6UK9bR/80jVwh6oYkLzsFSdr18npxCmEg+oySwSUD/j+JQraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NwjGJcrgwcc2qsyZSD1f+yo29MHX3+7gcnDlCIyfrWc=;
 b=AuJDz1uZtRcI0SVAYx+spPAgPg351Ij+9YGEYFo1Mmg2546DCnDzHsTA81o1DY7SSr0CSBFt7TvrfYahvsM0vr4PC2GBTWlMZnBzSmmlNadLXrAO8V6sb7LSkQ1dfFQPAH7/o8h8FzpSMqwy+olV9LS3iEGBKb5ZX0enJ4+CEEXPXxqMEVmfy0dO/VZdni/2787yfcEUrVwiIijYGWUAWA8IZVwFtse01RPcKwd1fIPYQ0qD0b2R24n/sZjY46t/HC81aOAefLjPkOvjKiM38iUXgJnMfpgXDIsOq17jGSnzMM1QcenUJydoT+rr8VH56gn3Dmu2VItd/mGFAEEWcA==
Received: from BY3PR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:39b::11)
 by PH8PR12MB8432.namprd12.prod.outlook.com (2603:10b6:510:25b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:53:45 +0000
Received: from CO1PEPF000075EE.namprd03.prod.outlook.com
 (2603:10b6:a03:39b:cafe::96) by BY3PR05CA0036.outlook.office365.com
 (2603:10b6:a03:39b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:53:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075EE.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:53:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:22 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:21 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:53:10 -0700
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
Subject: [PATCH net-next V3 02/15] net/mlx5e: ipsec: Block TC offload when IPsec is enabled
Date: Thu, 3 Sep 2026 11:52:02 +0300
Message-ID: <20260903085215.3691657-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EE:EE_|PH8PR12MB8432:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ecf91c6-3a84-4743-7a0b-08df0998dc2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|7416014|23010399003|82310400026|10067099003|56012099006|18002099003|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	S6OlBtxaiNQOJOaVVNTCDEmEwJlDk308YfahUqcWw6ytK9smdr+YSP7qiNm/E7bK+Z1ZSsdCLmpR7R6HiIdT7w/gsVyxvok3mCOMnqVsbQoiwTWuOsoSg5Fcr7liwHzgtQC1n3TFvjw07IP1pC3jon/4vROAo+q54biVxiZUg55MEtEyfReqQL8gY5SaZnt8mddImLdxW16ZgD18jcqutNxSpnVKBRzqxIPapgvGRU2chfEP73dAT0YLPCKh24l0uB+qXUlB7t1wQG7aM7kBtLO5ithF4rZWgn0XW/mQxbPQWjz499JZytIgGbNxsUGWIqllgMqadI1oPkxHYSn//romVtdO+7xncZRASoMiPjv3eYLqI7jf9LX8ea0k93ugj/KDWwwdbs/PvbrxbCxmJPoCTeZy2le0ya0iWCzLrD6VBZk2+NaKEGMM+f8PPbn3G7pmqij0ksDQYpunJDv3OhlgyyFKTz39lT9jQojvE2nPD011ke35mA8dwmX+E3Bim9bc+Mc4H7h71diipRUlXpxCu7MDx/yOqnfajUSwVT+uNM1Pm1ZvxQWiluOpDLnKznIc1DBInIlNGGb7T8vLlJUIV8Jf09lD1UE1UKNDEu7rxUl6s/cbsfe4GrnJBmQaICV1yZtXKsY5GrdWCZYl6q3PAAqM8+RVqLV/bpjlAaAn6nLLhz/bntsgghP7xyHG8prSJ+BhPvpaJUIxtbEjhw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(7416014)(23010399003)(82310400026)(10067099003)(56012099006)(18002099003)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iEzSh2Et4d69ODyYNDpHVrteW5EnY/EJyKN+8XcLHDcLbJhT8alD5djVxXrH3yBLZQMZk9AqbKJX0u2z1m7wMQaxFLzWVrlroycdIR+yrgaxKlfVW86czXpj6XLG65kwCK1JSNn+F4hmVl4cq/g6TmoTGWBR3tIrRvrPNeFTGQ4OKvOQsQt1pJY70HvlMVj6NjCtbC5/4J171DrHeA+ItDQRtsVOZag7eCjtpftO3oXOzR/dZ3r3AvfDT7wxn7uSbhF5j9ZEgitUfGhQcNSQoaIpkTlImsU0YOBw1LOcAhKFsK5u7GJjHUWEUfUW69TyaRdWJZE/dRM3THnVXGFfUpH6CPVNrJv+9IhduKeYtrL8aPAQ498DR1LP7jtNKSDVfnxhkn1xhhH082zNkka3NvRlTwv6dzU+piAWviQlub6gx5Lf+En2dS0FZxCBflea
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:53:44.2411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecf91c6-3a84-4743-7a0b-08df0998dc2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8432

From: Cosmin Ratiu <cratiu@nvidia.com>

Currently the mutual exclusion mechanism is only used in packet offload
mode. But with the upcoming changes to flow_tag, all RX IPsec flows need
to block TC offload, so do that with the help of a small helper.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 74e0aa5b6133..f236672d3a2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2575,11 +2575,18 @@ void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
 	}
 }
 
+static bool accel_ipsec_should_block_tc(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	return sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET ||
+		sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_IN;
+}
+
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	bool block_tc = accel_ipsec_should_block_tc(sa_entry);
 	int err;
 
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET) {
+	if (block_tc) {
 		err = mlx5e_accel_block_tc_offload(sa_entry->ipsec->mdev);
 		if (err)
 			return err;
@@ -2596,7 +2603,7 @@ int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	return 0;
 
 err_out:
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
+	if (block_tc)
 		mlx5e_accel_unblock_tc_offload(sa_entry->ipsec->mdev);
 	return err;
 }
@@ -2611,7 +2618,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (ipsec_rule->pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
 
-	if (sa_entry->attrs.type == XFRM_DEV_OFFLOAD_PACKET)
+	if (accel_ipsec_should_block_tc(sa_entry))
 		mlx5e_accel_unblock_tc_offload(mdev);
 
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
-- 
2.44.0

