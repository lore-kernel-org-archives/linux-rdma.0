Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010031.outbound.protection.outlook.com [52.101.61.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2100463B91;
	Thu,  3 Sep 2026 08:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425655; cv=fail; b=ZecCf6DxdcdiUbaAI+/1PTuCHIbVaETJBcqPnMWeCOzGBNv994h4z+vZbwfPkAxVwqERRtgvI125y9+7HziRd9rbJMlDhWtCqXe8osJKdLMb6EqWn94QPvbsF1SJi8G9WdatUCld/4/ARL5zSyUEVypJ+W2/b429dSeJFcDBWq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425655; c=relaxed/simple;
	bh=wHTUVtPo4Jc9ZFTJCwRVRrAkEYPn7TM6phZvvpMts3E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T88R3sCNUajs9C/tunTAwAH67dhubIermepGBpFYWLCJBV3hFuoKWvDMi1Y1/N4xBt/zYfcGIo7/O+RWX6w+olHZBnba0kz13HhYiCTjf0PSk5Zux1mL+kxwvZ+dYiQLRCpbjNpdLl4a5FkUSE5z1i6Cc6ecnzUcXU/9kFMNtUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mdufluud; arc=fail smtp.client-ip=52.101.61.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mdufluud"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CsMn+X0oU/08mztTIonRzjrVAZCxZYTwvMLRDvws7CcZ5pluOQAgxFfarpoTZ6lFSOA+t103+npaubEVyBBd+i0WCmPQMbQFZ5kZimJ7/jq2rWqSs+4S93FgiiNuWnYIx7Ww/EK9H3kNvm15HWb1k9oQChmSfveu4roa6QA5Y5bv5Yk53oXo6qXCLSKhPVjzjDlVKAM2OXNIXNfV7ezqYmKqTWGSG6/xaYTLREtHgFEoRwLk5WmKOKcKkR36eVV9dFrKoKBqAalYBMXUxnB6/GsL8IT+ErZbmGhBbgmdZZ4M/yo7KMdsT2YeXBHI9TsMjE5oI1YA1RM7TlEHxGFdDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCuJWh8FE2mADeozQy7CgEIWrLF7bl42mZ2Ft+F3Lt0=;
 b=FvBO3K6hMqQ/SfRZen28M2/hHbrnSn0/5Tq8fzbd2J4FmLUFvm6yxLQjqIz0q4IijBkQyduFBPZY/i1uV7SS9NE8v5LrPdNDRSboeGIgpRnJYyhJiXcuNRli6Zw3Gojov21F1xdlKERbrWgJM3/sUXS2jc7Pd4jPxDbGoxguCar3RHB7MzPVobBCGkdVjcYPEgcw4rB8kW+pasO9AyxvqxGn2nT9XM0czDopCPvHOQJTfuw4G1XF/LN/6FbO6fUOsI2x4KreDzvk6BVaGK7PyTOQo7Bf1+Ym5RBsFo3UeobjBhLbp5LH0QUDu2rcRj8YPpMDb1bhpirF6o45MMhckw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCuJWh8FE2mADeozQy7CgEIWrLF7bl42mZ2Ft+F3Lt0=;
 b=mdufluudGknJOUTLnzzYiuWPICD/Ue2VQmrOXynhAaeUE/u1RtjzKiOxQ8rE6Mg0hDtaIxKHlSKggWpUnJvrwArWo0q1UEQsNoNTaKC0gzS5VRTFW5h8K8TJKHiV/+oMzfDP4OejF2VWFDXmYi6w6BymrLQ7d5b+iUDOa/guFMEhsZPMCT6uGNIQrHskMCzqScf/eHcVWyKn6rX/PARLbm1AY6KiFokNiUpTkbwmQalkxCcUwH5NeX+iQ5Cl+y6C/x/VCimstWrS3DeJfojTRmq+3ZqTFLQOFCZTDhcs5o+nvpIqOsNoMsK4Fc3L2BTePFIbqN6Fa2m48NpVLj5MGA==
Received: from CH2PR04CA0027.namprd04.prod.outlook.com (2603:10b6:610:52::37)
 by DS2PR12MB9662.namprd12.prod.outlook.com (2603:10b6:8:27d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:53:54 +0000
Received: from BN2PEPF0000A7FE.namprd02.prod.outlook.com
 (2603:10b6:610:52:cafe::7f) by CH2PR04CA0027.outlook.office365.com
 (2603:10b6:610:52::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:53:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000A7FE.mail.protection.outlook.com (10.167.245.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:53:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:34 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:53:34 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:53:22 -0700
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
Subject: [PATCH net-next V3 03/15] net/mlx5e: psp: Block TC offload when PSP is enabled
Date: Thu, 3 Sep 2026 11:52:03 +0300
Message-ID: <20260903085215.3691657-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A7FE:EE_|DS2PR12MB9662:EE_
X-MS-Office365-Filtering-Correlation-Id: 49143777-0085-4c82-2d5d-08df0998e255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|82310400026|36860700016|10067099003|11063799006|22082099003|18002099003|3023799007|56012099006;
X-Microsoft-Antispam-Message-Info:
	xKijD3c7GJF4cJo2G+xeQIs2gRgniscWhheWHP1p7ZkjnCw84QBK0H4BLS56LWh3wBTzhhP6c3y3c2f+8FY6dJg0UByR6ds4po5MyRSwFm5rs5fI7gfWUQwYkRHIx9Uv1SJGS7tgTX062X98m5PrwDwuyr5uTYdRyvqOsq08i89qO98snH8BkbNFpJrbzw/5ZbRRNew4STRaC+ZfA1V4hYxlzlJ9RYwGi/F5Fs4n1necDYVasrCjsL5P2Heuj2z78F2Vi4k36mSewsgQFLz1ldXGvOHHXDzeT3dNFpdNwlOp715Ow3uul4bcNcN2e/Bk9WeyuvCOjBxyd42ryRbconqbZ3ourbwIDqNERkdCqDBWrDmCPWKBy0+y5zMTf4MAQWc13ZNK4KAx0w/YR8rMKoN7gEN9dK+1m9ur6QZOqtple7l9DpakEcmYKdywRWbstjFqGeGrPM2rAldMiy/qM15LzEAb+So5BcJVYEMolEC0hsmF1PR8OYxMiDuTklqPdYSpfYZb+NRBBzhpu6KPPoukN5e6heRPI/vR2tK5DARL1CgdWu8VPS473tGVjjAnmLUbhv6JpIndEI5aSVugFA5D37KJJEWDIXVHh//Z84g/LfY7+ycKMSmeWS4DiQQbHHn6PrkUdp1FdtSIQ+Y/O5juehzY+Lt3ThKlW9szyiMvDbuS0LaWFbYx+SBx385VsVbsYr31BSkAILqEfvDL7g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(82310400026)(36860700016)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EGQEP8orCxB6QRz0450NosE46KUjbG3Ppo3PgXUWu4BhIc2j1C50uD4KUsVSp0ONkwc40x7D8jLK+8yEJHm4LBMaESN/tw5hYuX7EODvRzvJRLprrlWeVWRJxUu73SH+/Jh1IgNf8+QAwLoPwGnRGK2ovGusg9FYoypzoSowoAQ+a26jvm7HW6tdPb+vZwhqnU9qbfiOmMqKO4kiWqPNJ30WHTsOaZDqrbA/ZGbqCm5NuBO7RLQAiiWXzBsVC3YNn9TdP7I4wydrKCaLRK4YfaSVnsLpoyoC1gPahCxdmEuRG6ZQQ6aHlmOedhC51JzE32pS7a2TZsjLhjuYvoSrqQS6WrAp8OnbmoS22WcT6endhAF3Y3RiVc4h2H8T/M3UdPyq0Ns2gOdy7YJ5hoCjlILzt6viumgmOcmY2FnIVA6C9j83Kd9OD1tPdudxaF6l
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:53:54.5327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49143777-0085-4c82-2d5d-08df0998e255
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A7FE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9662

From: Cosmin Ratiu <cratiu@nvidia.com>

Make use of the mutual exclusion mechanism from the previous patch to
make sure only PSP or TC offload is active on a device. Later in the
series, the PSP protocol marker will move to the flow_tag, which is also
used by TC offload.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/psp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
index 73b232379263..6cc4b9d54f6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp.c
@@ -6,6 +6,7 @@
 #include "mlx5_core.h"
 #include "psp.h"
 #include "lib/crypto.h"
+#include "en_accel/en_accel.h"
 #include "en_accel/psp.h"
 #include "fs_core.h"
 
@@ -526,6 +527,7 @@ accel_psp_fs_rx_decrypt_ft_create(struct mlx5e_psp_fs *fs,
 static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 {
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
+	bool tc_blocked = fs->rx.ft;
 	int i;
 
 	/* disconnect */
@@ -535,6 +537,8 @@ static void accel_psp_fs_rx_destroy(struct mlx5e_psp_fs *fs)
 	}
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
+	if (tc_blocked)
+		mlx5e_accel_unblock_tc_offload(fs->mdev);
 }
 
 static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
@@ -543,10 +547,16 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(fs->fs, false);
 	int i, err;
 
+	err = mlx5e_accel_block_tc_offload(fs->mdev);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "TC offload active, cannot enable PSP");
+		return err;
+	}
+
 	err = accel_psp_fs_rx_ft_create(fs, &fs->rx);
 	if (err) {
 		NL_SET_ERR_MSG(extack, "Failed creating RX steering table");
-		return err;
+		goto err_unblock_tc;
 	}
 
 	err = accel_psp_fs_rx_check_ft_create(fs, &fs->check);
@@ -583,6 +593,8 @@ static int accel_psp_fs_rx_create(struct mlx5e_psp_fs *fs,
 	accel_psp_fs_rx_check_ft_destroy(&fs->check);
 err_ft:
 	accel_psp_fs_rx_ft_destroy(&fs->rx);
+err_unblock_tc:
+	mlx5e_accel_unblock_tc_offload(fs->mdev);
 	return err;
 }
 
-- 
2.44.0

