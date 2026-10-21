Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792569073;
	b=IjTs/ak+LKeX2DWDfLgYacqflieKxGN88jEEadjlEgo+nHUFXZVi9sYsZA0Q1usdxoHF
	 1nShiH3p7dgoVw0zau0QucjRkeYGQxc0Kc2ULMQfMp6kwkTnP1xAkQvydlfreNN2gWHjX
	 B03uiD9nJKoO4pTq9F4YPsCFkR6uK062vvKlBHl7iUGFCrkZMd94OMHx+OKHJabMT1jCn
	 4loVUM53Vlyo0dSG6aPVbQo+Vy7uLkJdc1f50JnLZoXARXtI7jKF5qZxbDRO7WdOUFyBM
	 77GnkJIGt2poN9BYsUJs3de264Nauz0fv43aH7BwQLz7NnDSKndXh0S2VexIS4awRRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569073;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=2Ac375qKoEqNKHjY28/wFKZzLXr4nYIay+eeXoZD77w=;
	b=YCdxq1jCLeQwqDzsR/xCoJ63DXk19yEkv+xAqRFPbx7abbkFNotEvw30pp41R+gkzHNz
	 ExO4e5IHsbf8m+vCr1s0I9E/M4qRR25CUj+qU5n0AUlMUhfndTMb6sRvT/yZW1Vcn5jDL
	 fqIr4iT6N3BmfwWESSarF/t6OBL7J3YoMZTqNxYdGZCrKoHyyOSOr1BcFNQfKVOes1wp8
	 4VSKt643xuKlKL9XXaYWH+9b4Rn3QYtUABSkEshOoPuMi7STz05Ch/sxhsz3U4lszFx5g
	 T2I/IK63F3zutdACOBAkrxKSVjF9UZunSLgYro6kOzf48fFrF4Yl5yZ2BUsoSsl1acA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r2yPgd0u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.51
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D771606A31C;
	Wed, 21 Oct 2026 07:51:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D771606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r2yPgd0u
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hD8DUPXFTRCTnYZfZxwL3Nz1vP+mlycS9QBdR+7XPglUAUK1ZuO0N+0qVfawNA0Q7zK1l4chcrf24N+Zpx7nftLqOY4hKSRE9eAzZ5LIBq8jBNzpcEZfrWIXaLzsFDpZw15bjzL860CvS4HYshIkFzRMGqj+za/vU18xnNVujzEYCEOd1bc7fYQac4oeh7J1CVpL9O+cL5e6AH3164QHKN5Cj3I4j4M5Bd8jvx9r1TdkU/pz52XbP4YXWpD8lMY+9TbkAfTPkMhf7+CUAFD2H4jmIYZtHOde9cI2wHMd+7W0y5tdvTHUQbeT6InM/rUPzUgKjLqdi0DY4cyX5bC76Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ac375qKoEqNKHjY28/wFKZzLXr4nYIay+eeXoZD77w=;
 b=hUZbQcel5FNEkdD1n77Z51PL6Uf8hJlBKubm2mDbTK1WuqjqaOfgehvG4/Ohi4cZyeVINGz5X+lF55V+W320/8f/wm9W8yhzS8fGR/MUzbNzHXgwoU+7DLTyaNE4196Ugl+BauTKG00u38zlHVZ2Vv5n/blj4d0p22+YM7Kyoj39Roaa3MjtjQccQc1pAVr2uOFovgwXGSxYTtNiCCD0PA/eCyS8/KVzqeXO1g1B3Hm60Ej4N/sty5p9Y99B/vNwCG7GT8ijkrS+B54Id/G1oq3mhV4lV4NLqkxqk78G9MQEgy04lMgrXiJ3tJcl5ucyX9YACEbjLVdiqhR788u+7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ac375qKoEqNKHjY28/wFKZzLXr4nYIay+eeXoZD77w=;
 b=r2yPgd0unu2X87e0xJd0CiBafAvP43efxk/ybbt5CZ7ygiNkSqz6rl1nzncPKrmsAGEFBmbqEVraKmUKj4eLyNu2ibXnc7bXl9OrExEwv34c68G7tYVKwDBVBgFqNcW0z60nO9RbyLEPdiStZkphXHjJHQYhyYeh9uET0n7i5iiZhbBUP3/zGDja/jHnqHcAxim/j/J/wy8bZ+eoFpmBpUbO6DLABkQj4WsGqOxTtA9Q+ADqhE3xqZ73w8QPA0UeeVVTs+ph9bYowR7HCpWtxN8f86GDNN+6CARYRb7Z1csWDkq5LziTgYNru3yYFDfprAXEQYCfWOG5ABFc3PaBLw==
Received: from PH0PR07CA0034.namprd07.prod.outlook.com (2603:10b6:510:e::9) by
 MW4PR12MB5668.namprd12.prod.outlook.com (2603:10b6:303:16b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Wed, 21 Oct
 2026 07:50:37 +0000
Received: from PH7PEPF00000008.namprd04.prod.outlook.com
 (2603:10b6:510:e:cafe::8) by PH0PR07CA0034.outlook.office365.com
 (2603:10b6:510:e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.20 via Frontend Transport; Wed,
 21 Oct 2026 07:50:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 PH7PEPF00000008.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 07:50:35 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 00:50:12 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 21 Oct
 2026 00:50:12 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 21
 Oct 2026 00:50:06 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexandre Cassen <acassen@corp.free.fr>, Alex Vesker <valex@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Itamar
 Gozlan" <igozlan@nvidia.com>, Kees Cook <kees@kernel.org>, Kees Cook
	<kees+treewide@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Tariq
 Toukan" <tariqt@nvidia.com>, William Theesfeld <william@theesfeld.net>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net 0/3] net/mlx5: Fix HWS and DR steering memory safety bugs
Date: Wed, 21 Oct 2026 10:49:46 +0300
Message-ID: <20261021074949.3471704-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-MS-TrafficTypeDiagnostic: PH7PEPF00000008:EE_|MW4PR12MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 924337b5-238c-4fb6-dd8a-08df2f47fdef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|18002099003|6133799003|41080700001;
X-Microsoft-Antispam-Message-Info:
	rxZMQtF4EYOxPrWLmjfX3e5M+oENsKow4AjTyz7qKhEO6z0dlJwnK/7sN/xMspUYzzqM//3oO2d2OQZmAP6z9rExrvphO0mtTpQEqH4qGGLiCDK1gR0K0yeiFTg1vV2AdMIaEPdPq3eQIOPi11GnalZXdVEmr1wQWwfZXKLHktMJYD27jyABc5I3sOsRgiD+VXDA6mglc4UMcqk24e5E7A29vaVl69zstp5v0Gmo0rV17EIklBggzO2EHBMKEg4yWA55itoJOePOVgR4AiKRIV4eZsZJ/6/etaveeFYoS+3+QTDlwp6eJ6x2VKaeyJhzRGWzO0TEAXombKDZU/UfZZVfdqAJSuYYgq78mjbfwJV4DRO7sD2fp3H/M8F3kCx3yrHwvJ4IdgedC+DgkB5bxmVNb80x9fJ3HCURs05Tx34hVcYs7xO4wsB/lDV3xHinm97Isz54SJ4F2Q89CP0JvXS3oCJT8BlsW55O9ciWhtEOry26xjOGjLRicPXD9FaZhGVz7gQoqibLquFn+biZmdbsAJSrqSmrK69juVXnCqwruuqSwFcEZdEMGgt3Abi3zMcSQSSIZInRVKIO6ZhsM8ucN2sIeZ6pfIL1SgN1sfS7pm5e1YrzK22vIi4efxjoBpA/q0QraHvThtzxu/nlLTQLZjIT1/a3BdLwIN5ek2vIgGUKc0oLkrthbVrMIXPZmAco0SBVCZBAM3dGkHkLHT4NOq2lsQ2+l82wU3sGXTGPEJYdF7QSE7iPVPWAF6SQW0PXeoPtbE987uymDg4rWQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(6133799003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1qXgj+TF++ggms1/QlC1vwWO4jdLNWsA/MJQwRphvvnCh/JUnbVEuz1Q/M/SYChEwwcp6qIG3ceHxdgMsly9oN/5h2joFWrRMRHuM3UlJOK5qhRfuRwJHdei1WMP5s4mORpwp5JQaV7+x8s9UjQEZjLsFuV0t7RRtNyN/GlIYyQO5jXbzCooDLk77SKwVTgUXcrlNtjQfxuzpxWVYnf8x4MvOqUoPTEfGZ3Nt7ZLV0DedRLco7ZYDQE+Az0zYHiioAbwDc91fu8K5XrZgWwIKi3f1AyBs9mVSV7vA0jor8iEbC4bs9jaOCXZphdvAF9Z8GAD1VZxEK+dseECj4uNUTnmz3JbilCU372EUS4sgYh/35g3BEK4Wk2N4+XoHrGKKiky0P35TmjdrWXMDYu8WZhsMX+ppi5/YtzPF/8TAQ+ytU/aW009bFyIGv/L2dPe
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:50:35.8101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 924337b5-238c-4fb6-dd8a-08df2f47fdef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF00000008.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5668

Hi,

This series by Yevgeny fixes three memory safety bugs in the mlx5
software and hardware steering code paths.

All three are missing-check or wrong-allocation problems that lead to a
NULL pointer being inserted into an xarray, a heap buffer overflow, or
an out-of-bounds write that corrupts the kernel heap.

Regards,
Tariq

Yevgeny Kliteynik (3):
  net/mlx5: HWS, Handle NULL in vport destination action creation
  net/mlx5: HWS, Fix heap buffer overflow in insert header action
  net/mlx5: DR, Fix out-of-bounds write when sync to HW fails

 .../mellanox/mlx5/core/steering/hws/action.c  |  7 +++++-
 .../mellanox/mlx5/core/steering/hws/fs_hws.c  |  3 +++
 .../mlx5/core/steering/sws/dr_icm_pool.c      | 23 +++++++++++++++++--
 3 files changed, 30 insertions(+), 3 deletions(-)


base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
-- 
2.44.0

