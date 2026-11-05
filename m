Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793913465;
	b=XDT4mlbapmXBNI9tNnD/jHa3sEOb9+tSdgPuIeoGnZo6X0Kp3Fp7cYqG1asTiqBPSpGJ
	 Rlfn4NUGTESr4QIfxkWTb2JtaxDqK9MERuQmaTy5E4VMbwX/ypkcRcKw+EMmwM82tbCVc
	 waFmoea+vu0D62fDi1RaxHW+xdhlybP8OkVF3aIgxr3nsWBMHB9YEf1TyBnj13JkUOJH8
	 Y641GrW6YS3RglehDkgrSiOxgLrYlMAFO7DX+pj5sneZeBnF8OZK1SLCAL+AO0sTYK/mA
	 DuxI0drQ5QysaVJkvj1lF/KOFbJB2pd56DFicrgii6KGUwDpq6lNgGTNDp8WoRPlCmQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793913465;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=qU1peTGBFexNBg8gOkatFIxu+Y5oNHTtAWoeg7gJcv8=;
	b=SQAw5u81GR0E84cN3YclO5UfXScDFjbJPgCjO7iSrq5rXWaSBqT+QeZhi6fSI7rTBgZB
	 Bd/fS21xmlSXonLEArYaF23/g0V5l1Ow3YJoNXMY44agyrVJEXg7RU6tss9p+PYzNu07M
	 d6e0yt1MJohxKJD7UEdGq2fkzber8uH7kZ5Ey4eJd+QrqhL9qaQBiO8ibytyOYcUNsemX
	 eXZIFqnx+r7qExlBCYvDSUF5IQuYTYfUmpf06BbDOXdojvuf+dI+IF92seHFVe2dotfGd
	 lD+loq89nYvluavxaeY43o7/8ShFkd+KWb7dhvIp6occZS7mQ8cbhWvFG4QBCO9ch7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AV8G6HEh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.0
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012000.outbound.protection.outlook.com [52.101.48.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A94606A326;
	Thu,  5 Nov 2026 21:17:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8A94606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AV8G6HEh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gAlbakr9Fsq8ZbzM2RRNCoLuuwfc669kAqVqaQFvb/RQJp002tWyQ/5oitNmgfLpIiSe6WEzBYnSHpmZ5dsZ2PCJyWivvC12d22qyyA4FnrEGJpFnnIUDcxiK5ZcaHymR/TlBJw4Pk2JFDJeLdkrGXwHqNyNIHWvbOff8y2S6PazpcP2nJ3sRbqOpUAN9Id68eAQk9pa4lzC5l6L809EEb6tibmV3drkYRUvhrf+DkbWXmgSz02le1F9kPiN1Z1jdk3Jtkk3RPAsiApab6/wQuStB0vo0Frex7sFeTrt9vwNnueb43grvWgBhMEDBDBHbNdhN1V5rjBU737uO/8Y4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qU1peTGBFexNBg8gOkatFIxu+Y5oNHTtAWoeg7gJcv8=;
 b=GK6gRrl2pIW3FI6IvzPel/bji1BBN5b2De1W9Q7fk1t2EGyq1EbDs/GjSl46/BDY0H+t/chk5DgAtbNt1/9Ra8tbiOB8MPeY+JGJEbp7TWbbbmb86ceBTL1mK/10GUKTf5tF4woqKMplfGYEYZ03Y4nTcjKPGKL1k3IK7S2rgtvMSzHnV0OnXE7KIJR+6j7DetQWyzuD6ireCqto9vLyBowHGbcuvAuea7bcYZJO9LGKiB35zswLfvrKGiNE1jtvtyAtVOVpkxamgy+CM5z1Y6sw5M1PjiR2Orxl9TjQslMToqNO7mltxM9MlIUmLZ0HYVds0975mnaHQbyL5Y2O4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qU1peTGBFexNBg8gOkatFIxu+Y5oNHTtAWoeg7gJcv8=;
 b=AV8G6HEhDGHCQJ6K/1eClP+6UJCUVGLE5GSpbh/41RGtD3QTB8cVcnMVCyTfXaII9WxTODjWbttDhQ7PfNTNOsdCCkEGkJxfd62Sq0kO96q2Y3BPlBYVlAdBBXoIBqDlMrUVzIaYr+bRSaVMzNMlPEBBdI1MBgEE2RD6+IgacXAvKjIgQGa/5wGxj10BacYyxwpEk9OlwjqwW2vN1dL3bdvvyc3gm3hJ1CrtVJo3Bmh6vEilHx0diaH6CzZlZzB6fQpXemZOElqR9hU58cZrZH2b4DTT1d+kn5RIjD74EU1ytPhLZFX/hfQHfQcldnT73EeBbssNYREbJSLCjXRYng==
Received: from BN9PR03CA0703.namprd03.prod.outlook.com (2603:10b6:408:ef::18)
 by DS0PR12MB7876.namprd12.prod.outlook.com (2603:10b6:8:148::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 21:17:36 +0000
Received: from BN3PEPF00022BD5.namprd03.prod.outlook.com
 (2603:10b6:408:ef:cafe::3b) by BN9PR03CA0703.outlook.office365.com
 (2603:10b6:408:ef::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 21:17:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF00022BD5.mail.protection.outlook.com (10.167.248.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 21:17:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 13:17:16 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:17:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:17:09 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Raed Salem <raeds@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drory
	<shayd@nvidia.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net V3 2/8] net/mlx5e: Serialize ipsec encap reservations with eswitch operations
Date: Thu, 5 Nov 2026 23:16:30 +0200
Message-ID: <20261105211637.1083978-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261105211637.1083978-1-tariqt@nvidia.com>
References: <20261105211637.1083978-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD5:EE_|DS0PR12MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: f758fa48-602d-4d9b-c668-08df3b82364f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|7416014|23010399003|9063799003|6133799003|22082099003|18002099003|10067099003|56012099006|261021130227099003|261022113327099003|11063799006|261026121527099003|261021123027099003|261021135927099003|261026140227099003|261022105027099003|261028144727099003|261026130827099003|261022115727099003|261021121427099003|261009223027099003|261102123227099003|261022075727099003|261026135527099003|261021133027099003;
X-Microsoft-Antispam-Message-Info:
	9zW4PlWIZRVmkFjVAkP/CwjpHaFmfUhXh6+be8xhH32zq1UxIpl7aBPTomNoS9uwyqLRefDv+mCmqt5wvGvGjeUYwpvNa4S5NCck8PEicHSN7v3suAbn73Le08FoIqa31mfSuAqBwqQmIith6WNaRjbIswDBOPLxUYWnCqqAjASb6dHzyWFv90rNA3m5pres1eZ+feuF63V/YA/H1G+cdnKhfwJCsO1MIynruPfqAIA5RNPLbGO6siERYN6k5gFGnzZbtto6NREjX84kbQYGpVNRt91pNBdsflZyAlFFgSJ0XfVMVAYnaRrY7F0H07uACNkzt4Qbhy9PVwI6+sYIXtt64wX0BIW491vpv7zku/fV0CGEGRKdFendgzcniG5E1entQtaMyMM3JlgmKjYVeRGcmD+o1fDZ1d0795R/fO6rZGVNZRZB07TrB0/UDXRPq/UQKrC6/UqLB2Uc/7ZQajiiUpUzqb2n2ew6G8Tf5e5d1fDxpGdJSfoNe+gUbVQb+Z8i27xbIokjZUniDPmomnt9ezc34X4246Og0O00dApoHfkPGL+/8Z9XACsxVm8I6iU3wZNQlSfyud+xBOdVkKQoRoJ98l1wFez/0Uz/+cCvGmqG3WJqvfj2PrDnV07nViUT9qp3sqRpQVPAfe10vg5Lxv1NeMIkG/cJteZdPM41Ne1fmex+Jqmf2av2881rzlC8IkGzE4M2SabKswa+Bg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(7416014)(23010399003)(9063799003)(6133799003)(22082099003)(18002099003)(10067099003)(56012099006)(261021130227099003)(261022113327099003)(11063799006)(261026121527099003)(261021123027099003)(261021135927099003)(261026140227099003)(261022105027099003)(261028144727099003)(261026130827099003)(261022115727099003)(261021121427099003)(261009223027099003)(261102123227099003)(261022075727099003)(261026135527099003)(261021133027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ECn+t3htk7TJRlIZqTdEJhowUV6w2kS7rnn+BH+6EyVKsSOu/FywNZSIlSrO90tRo9oWlSAY9jREIUtVXKy2eSFTYpXE32AKzWaKLi9BIXSLddnDCgvIXO62cGt508S0bN3qa7VwNu8wecNwDpYCls/0qO93Ax2dOb1CFMD91dwVZV/zZets5nEi4szLZE3HEyrA0A8gU4JIni1VUXG2julkwGTZmNctFdoIGtExfGq7k6yjIXSUvpr//NIUWbi0dKv6gHOp4Wj4l9MArVn4OwcLLSijZrxZfLjFnlyY2iVJn5Wqz/VPRjtzLSgk/M7Dm95C5sKKiOLAJWZrheQvCElGXD1zIn84/qAA8vG8xBh9CZY+Q3OnUDYXiBXSMW1qEaTFv6KWCCtajSxm+ta6qq+czpP/uIQrXi1PGW8GCsQU44RIcRZu1Cvge8bjF9EH
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 21:17:35.1079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f758fa48-602d-4d9b-c668-08df3b82364f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7876

From: Cosmin Ratiu <cratiu@nvidia.com>

mlx5_eswitch_block_encap() takes mode_lock but ignores
eswitch_operation_in_progress. mlx5_devlink_eswitch_encap_mode_set()
claims the operation and drops mode_lock while rebuilding the FDB and
updating offloads.encap, so a reservation can read a stale or
rolled-back encap value. In diagram form:

T1: first IPsec SA (NIC table)   T2: encap none -> basic
                                 mlx5_devlink_eswitch_encap_mode_set()
                                   down_write(&esw->mode_lock)
                                   sees num_block_encap == 0
                                   eswitch_operation_in_progress = true
                                   up_write(&esw->mode_lock)
                                   esw_destroy_offloads_fdb_tables()
mlx5e_xfrm_add_state()
  mlx5e_ipsec_fs_tunnel_allowed()
    mlx5_eswitch_block_encap()
      down_write(&esw->mode_lock)
      reads encap == NONE
      num_block_encap++
      up_write(&esw->mode_lock)
                                   esw->offloads.encap = BASIC
                                   esw_create_offloads_fdb_tables()

The race happens therefore because offloads.encap is not consistently
accessed under mode_lock. There are other variations of the above race
(e.g. in rollback, or in tx_create()).

Use mlx5_esw_lock() to reject a reservation while an operation is in
progress. This implies changing mlx5e_ipsec_fs_tunnel_allowed() to
propagate the error. Note that these are not new failure modes as it
seems on first glance, because if the eswitch_operation_in_progress flag
is set, rx_get()/tx_get()->mlx5_eswitch_block_mode() already fails with
-EBUSY. The new code simply protects against an operation initiated in
the short window after mlx5_eswitch_block_mode().

This race was found by Sashiko during inspection of another patch of
this series. No attempt has been made to trigger it, as it requires very
precise timing.

Fixes: baac8351f74c ("net/mlx5e: Reduce eswitch mode_lock protection context")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  5 ++++-
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 21 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  6 +++---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 20 +++++++++++-------
 5 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7e991a09b3ff..7bc5d07b4321 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -812,7 +812,10 @@ static int mlx5e_xfrm_add_state(struct net_device *dev,
 
 	if (x->props.mode == XFRM_MODE_TUNNEL &&
 	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET) {
-		allow_tunnel_mode = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
+		err = mlx5e_ipsec_fs_tunnel_allowed(sa_entry);
+		if (err < 0)
+			goto unblock_mode;
+		allow_tunnel_mode = err;
 		if (!allow_tunnel_mode) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Packet offload tunnel mode is disabled due to encap settings");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index abcbd38db9db..f4b2d7b950c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -320,7 +320,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry);
-bool mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry);
+int mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index fd9fbf359333..1529d4730323 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -1072,9 +1072,12 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_fs_ft_sa_sel;
 
 	/* Create FT */
-	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
-		rx->allow_tunnel_mode =
-			mlx5_eswitch_block_encap(mdev, rx == ipsec->rx_esw);
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL) {
+		err = mlx5_eswitch_block_encap(mdev, rx == ipsec->rx_esw);
+		if (err < 0)
+			goto err_fs_ft;
+		rx->allow_tunnel_mode = err;
+	}
 
 	if (rx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
@@ -1315,9 +1318,12 @@ static int tx_create(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_tx *tx,
 	if (err)
 		goto err_status_rule;
 
-	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
-		tx->allow_tunnel_mode =
-			mlx5_eswitch_block_encap(mdev, tx == ipsec->tx_esw);
+	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL) {
+		err = mlx5_eswitch_block_encap(mdev, tx == ipsec->tx_esw);
+		if (err < 0)
+			goto err_encap;
+		tx->allow_tunnel_mode = err;
+	}
 
 	if (tx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
@@ -1387,6 +1393,7 @@ static int tx_create(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_tx *tx,
 err_sa_ft:
 	if (tx->allow_tunnel_mode)
 		mlx5_eswitch_unblock_encap(mdev);
+err_encap:
 	mlx5_del_flow_rules(tx->status.rule);
 err_status_rule:
 	mlx5_destroy_flow_table(tx->ft.status);
@@ -2854,7 +2861,7 @@ void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
 	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));
 }
 
-bool mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry)
+int mlx5e_ipsec_fs_tunnel_allowed(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct xfrm_state *x = sa_entry->x;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e9cbcd73b23f..928b20e73d37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -967,7 +967,7 @@ void mlx5_eswitch_unload_reps(struct mlx5_eswitch *esw);
 bool mlx5_eswitch_is_peer(struct mlx5_eswitch *esw,
 			  struct mlx5_eswitch *peer_esw);
 
-bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
+int mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb);
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev);
 
 int mlx5_eswitch_block_mode(struct mlx5_core_dev *dev);
@@ -1071,10 +1071,10 @@ mlx5_eswitch_reload_ib_reps(struct mlx5_eswitch *esw)
 static inline void
 mlx5_eswitch_unload_reps(struct mlx5_eswitch *esw) {}
 
-static inline bool
+static inline int
 mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb)
 {
-	return true;
+	return 1;
 }
 
 static inline void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c712848b202d..7a0131e26ff0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4712,25 +4712,31 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	return esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 }
 
-bool mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb)
+/* Return 1 if allowed, 0 if disallowed by the configuration, or -EBUSY
+ * if an eswitch operation is in progress.
+ */
+int mlx5_eswitch_block_encap(struct mlx5_core_dev *dev, bool from_fdb)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	enum devlink_eswitch_encap_mode encap;
-	bool allow_tunnel = false;
+	int ret;
 
 	if (!mlx5_esw_allowed(esw))
-		return true;
+		return 1;
+
+	ret = mlx5_esw_lock(esw);
+	if (ret)
+		return ret;
 
-	down_write(&esw->mode_lock);
 	encap = esw->offloads.encap;
 	if (esw->mode == MLX5_ESWITCH_LEGACY ||
 	    (encap == DEVLINK_ESWITCH_ENCAP_MODE_NONE && !from_fdb)) {
-		allow_tunnel = true;
+		ret = 1;
 		esw->offloads.num_block_encap++;
 	}
-	up_write(&esw->mode_lock);
+	mlx5_esw_unlock(esw);
 
-	return allow_tunnel;
+	return ret;
 }
 
 void mlx5_eswitch_unblock_encap(struct mlx5_core_dev *dev)
-- 
2.44.0

