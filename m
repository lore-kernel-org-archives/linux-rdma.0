Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF6831E852;
	Wed, 14 Oct 2026 12:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982116; cv=fail; b=iWlNXaNesvxZCJi6Xqhz9ZBU2W0Q49h/yVrW2ewgcWbAgwNjEzE4yRK1finm3lSgN0W14ILH+zEU0ndBMV3aWyp4UGN1kP19VPqrFSHidfFN/1YiNlH9Jx6hJpsVVwIOIYrH3uPYtQFcpERjzecZU2ZzlITNNIAnq+EyHNsD+Hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982116; c=relaxed/simple;
	bh=G8AqeWzGlXDV8DbyYFXwTK44JTEbL418R9WAVYa20Ys=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bRsnqvSGET+VKdfZ/Dvm6LS84DnNbdWcHyux+jzlaP8IMV0acD0T3gNRQ5S9Is84qwd3sFl3BlXQm0yn/TBVuuh2G/WS5yuw8xK72I9tPZvW7hFNwFf6ru/GxDWc/e+IgXSsSjbT4cjhPDSZ+w+OA3dYJHwPGV+RQzpvFkkhSjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fZwf4Z2n; arc=fail smtp.client-ip=40.107.208.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fZwf4Z2n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQHid5NaFyFIg13CXxUe0bBGo1GR0SLc7fIwSTq2HqV4DWrrvwJyOGmM1YBvk7ELcU7AX1lj/DWcq2wF/cxyaNwNX5aDVh3H7yt2iCDit2IEzOrs69I800Jep6qb7ESY6zIOaQ548fEXn19KOHb+XIqvpN0hjPJz7XyG6Yn0pSwmBXyqYSbRhdHvDyZ4OX38pYo4DsqWBoJmYYqC/gL3GXRhEkTsqOunbUscp2CvDgFxM48GZXmGqmFA6NOIZWIk6m4bl0fNrAdkOY+kidwgL8uAG/kX+pIg0HgLjjtJUMNmxRL6I0iw1wKDgnhYHiqEnUvkmCLqsbmqjcxyuZYOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFt/Kxzx6yK9MkK8Ax/toV47MQljLVIjAmu/iFJ2MHE=;
 b=sfXSJ1YBJ+kR0fIerX+ykBBGb4ISXEsHGc610BjoN6E9CJQYxnIJNgLYsCalDXcHGdNf2dPobJfy1LqMV1lwWzHOYbE4P97OeoIeBhT1eZQlvt4CnaOl8J6WJXQ0t3GwoAnH2dFWOESpV2tn5ykM7+2hCgmmdk4cgpuk4RktbZZwn7p3QNSQ8vPl7bU08s293sFgdnd6wv0PqtSRxOEmtkDXBjS9xJpJpnBp08AaT4s+HymuTBd2l2zN7a3woINMdGcIyf+gwU0oEy1F8rwGbW8IbNDOgAjZyUsmGAtV7OhCtwX3SAtfYxFxqZE1HZlCh0fIxZnR9YlmvVFaPiZsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFt/Kxzx6yK9MkK8Ax/toV47MQljLVIjAmu/iFJ2MHE=;
 b=fZwf4Z2nupzgclFcl4ApR/2M64VPXbbIc0wNnpry+qfrxb/GawWT9PXrYmE5rDH576rXbcT6G79xsC1nLf9oNpCmcM0yexTpqL4IbAvTzDCgWCwPW2weTlHun46PYuDWtYc+1N06YIKbmyBT22KKGpEUY999M5OS8Ka0T7vfx3W3uvd2k08endj5ltQtPQe5w6ANZ53mIy3lrNWJ4u5n/ns1pTEvVTv4Tn8b+OnyDYYll9STkHiPHwAZmMW+USC9KbgZ7wIhVV064+lV3bBhtwtO+f/nQ0BvFXtx/VMonMD40aUY+FwJNPC+0dyqbae5neQRGonsTasZmZI7aTrgOQ==
Received: from MW4PR03CA0007.namprd03.prod.outlook.com (2603:10b6:303:8f::12)
 by SN7PR12MB8101.namprd12.prod.outlook.com (2603:10b6:806:321::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 12:48:11 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::6d) by MW4PR03CA0007.outlook.office365.com
 (2603:10b6:303:8f::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 12:48:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 12:48:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 05:47:51 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 05:47:51 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 14 Oct 2026 05:47:46 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Joe
 Damato" <joe@dama.to>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Nabil S. Alramli" <dev@nalramli.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>, Yael Chemla <ychemla@nvidia.com>
Subject: [PATCH net 2/3] net/mlx5e: Sync CQE moderation params with pflags in set_pflag_cqe_based_moder
Date: Wed, 14 Oct 2026 15:47:03 +0300
Message-ID: <20261014124704.1017782-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261014124704.1017782-1-tariqt@nvidia.com>
References: <20261014124704.1017782-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SN7PR12MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d5dcc6-f976-424d-64bb-08df29f166f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|23010399003|6133799003|10067099003|22082099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	y4ihxyhsoIrhpBVqRC2QEiNFtHfCXkSC4UzITIEw+UyMxgZIo037g/CzFjul59eeyafa3Filn32/xezL15kEJqZXjvlMQLMCxV7IPiwZzcXo7yviuPfdaS2yFSymKIioBhiVuVf4IkQJMqC7Ofd4XQ6jy5IxiDyPrjA1ClGDm9h//e8vuBulprZHi1muO/SnZz5XjH3MRBpRn5rJGTOcyHvnv0CtfzfQrGGPaHXmjQODSUGAKAvL3GlM4m/fE8+SU6/IyVFB79fBmqf1MlsVDvt9Gpj58q/vNkeFVvIT9MWfOBDbUBTwUzXTQMyq7Vr1amJoDXCcAfvPlphQzzza5qeQKFhelRAondM0cJUZw7XNWBbINCTQ0KmElkL9M3xvb+OKuNyRMdarlKlHcvIgfPDjsiS6E2G00KBrneyXozlDl10A7Z/p9wDxrquhhXgYkavgW+hHYAtWV6JTHqC6MzcxObhUSGwLP5Uh/z3/lNrKYDZivbsxDHfmbExSK+d4qqfry+BDDYGq6iPcoAy3zmFVX+cXaoSkosbw8e9GjSeTOu8AEUBRrzEPs6y2IHh7tKrN/U7igDDzKOZsGBSPJKKInxE09sKDPRKuvcU9FCub1h2bxUymc/ftRembHy36JFGGEG3fAzhCWjOVCK5jQLNT8xTecDcMdBDD5r4HwtHMQycASn+ToDCMQ2me5JBSSy0kGEQJxkqyGmBnw8+gJA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(23010399003)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mAxsDUdps9KFzXMI7/iq4MwqFMTM2W91kyXZ3N9jvcR5+Nn4FavruWrOBHIEA5aQPt2at9CMv4R1/cz+9AA7BMoZRYwQghKvaJvKvy/SJ4suIr1Pg+9dk+EJLFd7yQRkeWEnvS3QzivsEr0G2gnqdX6959M9y1Dtf96vhcrGxeYYr9ss2HojiRV3w4D3Ebu4OMNESVcxybmDeaMJSadOa8cYKrno/8DFEtpMTZeE657akjNptjGLpIS+HsnlvNBtr5EsaJzkham33o0EBhIoBXg2cyQhWhBvYvi84dtbDduA34kV6sCO5aP/aVgaKPYP+PiOMJe7up7uFGCNiC7bikTASpaw5FBCwizeQAkBriMhaYxkoqJecGCM5mjaFXVsl0dh6hn9nrdUtUuSLCIxtmATW+yjIG+slwYpn1ZseFnnXTk/VyIW3IZkWe27WxBM
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 12:48:10.1138
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d5dcc6-f976-424d-64bb-08df29f166f9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8101

From: Yael Chemla <ychemla@nvidia.com>

When CQE-based moderation is toggled via the priv-flag path
(ethtool --set-priv-flags ... rx_cqe_moder / tx_cqe_moder),
set_pflag_cqe_based_moder() updates only params->pflags and does not
update rx_moder_use_cqe_mode / tx_moder_use_cqe_mode. After the toggle,
--show-priv-flags reflects the new state but get_coalesce (and thus
ethtool -c) still reports the old state because it reads from the
params fields.

Fix by setting new_params.rx_moder_use_cqe_mode or
new_params.tx_moder_use_cqe_mode in set_pflag_cqe_based_moder() when
toggling the corresponding priv flag, so both representations stay
in sync.

Additionally, new_params.rx_cq_moderation / new_params.tx_cq_moderation
are left as a copy of the old params, so ethtool -c reports stale
rx_coalesce_usecs after the toggle. Fix by calling
mlx5e_reset_rx/tx_moderation() on new_params to overwrite usec with
the default for the new period mode before storing it into
priv->channels.params.

Reproducer:

  ethtool -C eth2 adaptive-rx off
  ethtool --show-priv-flags eth2 | grep -E 'rx_cqe_moder|tx_cqe_moder'
    rx_cqe_moder       : on
    tx_cqe_moder       : off
  ethtool -c eth2 | grep -E 'rx-usecs:|CQE mode'
    rx-usecs: 3
    CQE mode RX: on  TX: off
  ethtool --set-priv-flags eth2 rx_cqe_moder off
  ethtool --set-priv-flags eth2 tx_cqe_moder on
  ethtool --show-priv-flags eth2 | grep -E 'rx_cqe_moder|tx_cqe_moder'
    rx_cqe_moder       : off
    tx_cqe_moder       : on
  ethtool -c eth2 | grep -E 'rx-usecs:|CQE mode'
    rx-usecs: 3              # stale: EQE default is 16
    CQE mode RX: on  TX: off # stale: priv-flags changed, CQE mode did not

Fixes: 445a25f6e1a2 ("net/mlx5e: Support updating coalescing configuration without resetting channels")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 3ed59ced0407..c2bee69c26af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2193,12 +2193,20 @@ static int set_pflag_cqe_based_moder(struct net_device *netdev, bool enable,
 		mlx5e_channels_rx_toggle_dim(&priv->channels);
 		MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_BASED_MODER,
 				cq_period_mode);
+		new_params.rx_moder_use_cqe_mode = enable;
+		mlx5e_reset_rx_moderation(&new_params.rx_cq_moderation,
+					  cq_period_mode,
+					  new_params.rx_dim_enabled);
 	} else {
 		mlx5e_reset_tx_channels_moderation(&priv->channels, cq_period_mode,
 						   false, true);
 		mlx5e_channels_tx_toggle_dim(&priv->channels);
 		MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_TX_CQE_BASED_MODER,
 				cq_period_mode);
+		new_params.tx_moder_use_cqe_mode = enable;
+		mlx5e_reset_tx_moderation(&new_params.tx_cq_moderation,
+					  cq_period_mode,
+					  new_params.tx_dim_enabled);
 	}
 
 	/* Update pflags of existing channels without resetting them */
-- 
2.44.0

