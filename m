Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.22
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792565005;
	b=uipKa1nfu8AXbKcivj4oeM5Xj6K4Ln6dbqHZAvG/ihqaaryZlv81+oNGGOnGz/TqKB9O
	 5lWNNDv/jN/79D2jrP7Rg2256Vz9ewlbc+5qPD2un12D8kyyFBhxQwmFdoXBC4TG4/mH6
	 rOke/tfFmV2TIgXVOGVzkeuWF0ExV807tQWXP5yJN5zpGmBwVpCr6BHM8/YI8ZdkweEc/
	 qpIpB5aedGnuhRRe2K+3zg7qWde2d1pnpB0ju3ADe4NXabj6Sx/h2UWbU3qzgsjsQn/4L
	 MX2KE1T/6l8+M8DIm7bWZDC5TfcKfiJV6V30BZfwGiJmcMHM9fKbFhmyv2IWP9bdkng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792565005;
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
	bh=6A8HHcWUN95GGtzSMIwm3I4ccf0FqW0Xv8zpaH3uJRU=;
	b=gmql15eiiOIbh+lPbTzvXV0F2ZieMJJYcxjIR9wfd8b/2kkVUmkB1OvaKkAC5JkmR9YT
	 8Mr9/dcQonp9leddNL+SOiuKvXwXvJunQJQ+rS0hRWQp17VI6+ahpq6ezlB3H4yhNid5A
	 fMPREnTCI2GkjYz9l7YBaEQ3WSIQ92oE9hNvNeeuZzYXtCng3OusCTr8pcTGd6gcXIIuX
	 vRwHr46fQvaRYzeG/WFW68HEUvOC6zNJqbl+Kx3ogD0Ku9jt7t3fkK3LYY8sIYMcStQET
	 hj0AojcwuH95wbkQI4RY1B9Ad89YRSGv2I972vc1vD0wtZO/9E//yhOhAa1KR+6hN7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O+k47taa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.22
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011022.outbound.protection.outlook.com [40.93.194.22])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62664606A31C;
	Wed, 21 Oct 2026 06:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62664606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=O+k47taa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IOBWjt2JnOaI/wWyuFlWaHKbLsLybZrbIobFGh+RUnf6beAmAucrApz5WpEYR3WB15tXY8n275exe/csepj/tTGkr4bTuHPsdNv4E8zWvZXH2ZA9DGDVMtelftSCk+CC57mOsInVn1hsYZk6HMLeOLduqa2fQXCCogBVqyKuskMR+7WlCnCRF5Mg9gRdgtcTaKGANUt8C2VCX4TguV+sDbh22Sx0JEJVyswk0FIRnF9L2Ua4BagHHT4uDAXXFnTwlvDFQ+AwZS9V1y3X0PosaMVC9G7NWFIV0rELZE8tX/xsdYDbyMQ6zAF9YjFhgvvB7Csl4PA1Md0gS9iGsO9y8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6A8HHcWUN95GGtzSMIwm3I4ccf0FqW0Xv8zpaH3uJRU=;
 b=lFVANFYIiHY9E8VojUrGAyafTebMvw0Dp0wsjyl7Ojvz06lJMmDuSdNC8n2iT49a5Gk+U+p0xeEAQ4XeWNH6dhbi+b1ScITRZvQ3eA8+Y5G0WbUujUnT+tbBpgUYYRBLNNmaosUtpFni8YC3TLTDcgH94CoC/hk224sU//OiX0L530RcqKzsW1MRo2sVxKmOsfF1cAAVtqoCOxjzsRSUshPmrdQk/0w7uh1j+Lo1E66uwlqbOyud/A0gbN52vytwQxk93L1kY9ib5Ad3rnRCZy/c/O71tdH27hM+QiAh30i8nRuQEYbH+4asSG3JhsvRKnC5aJ7fzT8ZqQ9G9NYNmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6A8HHcWUN95GGtzSMIwm3I4ccf0FqW0Xv8zpaH3uJRU=;
 b=O+k47taaMyqNg4i78gs03Jy8Tk/rSnoCrZSG8xXfYgRSJwZKE0u2a8hMIkzWzHX3caeDMbG6TNFcg/kpwfjrHRI4WSe/ngCOJahQdG6BVAodrNgwrCdquEksxnfJQM/UFvy8HONmNNMkBs7hJiNxLtYkRJGyRCotm4bFnlku1s+kLppDwVbaSibzPAJ0bTBS2AdcD9CDFsqu7w+UM6Z9IUgAGasWqpDnA4aAuvmeBv8NXMKF3reJSvFWu36JU+3wQN7A1miUILlGvuMWLtK01f/UmnfdIGIuDtVL3kqpoAmtUjstawVBFGPqgtuWdmWIqJDeIKY0mm60Z9gvrx2U9Q==
Received: from CH3P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::7)
 by BY5PR12MB4292.namprd12.prod.outlook.com (2603:10b6:a03:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Wed, 21 Oct
 2026 06:43:06 +0000
Received: from BL2PEPF000352D1.namprd02.prod.outlook.com
 (2603:10b6:610:1e7:cafe::36) by CH3P221CA0011.outlook.office365.com
 (2603:10b6:610:1e7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Wed,
 21 Oct 2026 06:43:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL2PEPF000352D1.mail.protection.outlook.com (10.167.249.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 06:43:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 20 Oct
 2026 23:42:46 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 20 Oct
 2026 23:42:46 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 20
 Oct 2026 23:42:40 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Boris Pismenny <borisp@nvidia.com>, Fernando Fernandez Mancera
	<fmancera@suse.de>, Gal Pressman <gal@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Sridhar
 Samudrala" <sridhar.samudrala@intel.com>, Tariq Toukan <tariqt@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>
Subject: [PATCH net] net/mlx5e: IPsec, Fix out-of-bounds comparison of neighbour keys
Date: Wed, 21 Oct 2026 09:42:31 +0300
Message-ID: <20261021064231.3466989-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D1:EE_|BY5PR12MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: c150c1bb-8316-441c-42a5-08df2f3e8f8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|1800799024|376014|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	qeXLz1vLGWNRi6Zc9aSyGb73uwAPvH+TQaDdAD6RtDYL+2/sXi9V5HaJR+QukHD8yGhXwLhGSir0TQ8reDdgarAgKuF/0dA+0VfvUPx5w0Svru0RIiepVQR8S5eZvBggG844dYCFocJ+xckiHtD8pMKP7iQLfCDfUXSlbdLtsRy9CIW0Mc6SvWqWWwGKHd0NBPRYlw2OW8lLNCBlywAeHQU7LsRFMMcD12TRshhtX9KZi+vUL9oHyHA3J54mH7cVS0h09rI7ImgOwwbPy5gGl6CsHgOzL4eagCTzbIYoCoQzoLqdwpkIPPE23F5nZ+NotB3F8eXKROSSfDchKVkGgBKs3kUkwnVKt7M9zeNzCvrvuqgqyFAsyknmzDAeg8MrX/xh4NSEA/L3iEt2PQKmAxGD4srKGDUmV7QWlPHVR5TSMWchfVwOs7AP1zOshIF4mGzWvbhAT3A0j43rt2YvuwgL9K+AxmH4F4a2iMpmPw8s/f2O0wPyD1WLm9SFFX5XT+3avzOX1iClep50wGSIdItegLB0WRnAduqqOLJl+o0zFymo46038OtQd2zUIfL8S46IWgJ+IRzBAWiiCsgONjBg52iRfb5JXd6HzLju3P7syayqn3Bc362fTLxC/hw0kfKLcA4JX94AhH4Bu9HZV1Ev59jrqpq47BlLJLJeYeYrztra+PfSenPIYH6kbE3HnW4864SdfjYDx5pq8vEqcA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zyi0c9Z8YB5B5PsN/MXIwAwZysCDSrYt5QPpnXuV+kxFnQuz8Hews/eui9YEOJRLeCPn0soya4fLLozIRxM23LjBGJ1zBnDU/LS6yrA55r6CPw4aU9G48NrsSrrXOLQzHI4+YqUV3k2hn5OQHVxdw9c4SwEDVmF6SWYu9Y9I/EGNw9nLuay+6TKxtBpTfsX5YtZz1TRSAspbJF+mpmNYz9VO+L0gVtlpYQ+4UJID5BIKBmkLXuOj5ivgJWXKbUncideVDYKmXgPZFDmFp42iNProBxl1OCGLK4fDLSsdf+ppsiRFUrUk0O20u8kdO27UtbwxY0s9WXp7A2KUURHcp7BJ6qrpW3NFoJUa/OpkCMG2nZdVTEACLro47392z3lLPecQvzehofP4IVisEsK42DcONzof7gwvHDcicxUGS4iioSIn0hFUTOlct4txEDex
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:43:05.0861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c150c1bb-8316-441c-42a5-08df2f3e8f8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4292

From: Gal Pressman <gal@nvidia.com>

mlx5e_ipsec_netevent_event() keeps the L2 headers of offloaded tunnel
mode SAs up to date: on every neighbour change it looks for SAs whose
endpoint matches the neighbour's address. The compare width, 4 bytes for
IPv4 or 16 for IPv6, is chosen from the SA's address family, with no
check that the neighbour is of the same family.

An ARP entry only stores a 4-byte key, so with an IPv6 tunnel mode SA
offloaded, any IPv4 neighbour update in the system is compared as if it
were a 16-byte IPv6 address, reading past the end of the object:

  BUG: KASAN: slab-out-of-bounds in mlx5e_ipsec_netevent_event+0x736/0x8d0 [mlx5_core]
  Read of size 4 at addr ff110001260a4ad8 by task swapper/8/0
  Call Trace:
   <IRQ>
   mlx5e_ipsec_netevent_event+0x736/0x8d0 [mlx5_core]
   notifier_call_chain+0x97/0x2b0
   atomic_notifier_call_chain+0x5d/0x130
   neigh_timer_handler+0x35c/0x1140
   call_timer_fn+0x164/0x490
   __run_timers+0x5b9/0x960
   run_timer_softirq+0xf0/0x1d0
   handle_softirqs+0x189/0x8a0
   __irq_exit_rcu+0x10d/0x250
   ...

  Allocated by task 1015:
   __kmalloc_noprof+0x2e6/0x8b0
   ___neigh_create+0xcc9/0x24c0
   ip_finish_output2+0xfc7/0x1e80
   ip_output+0x172/0x3b0
   ip_send_skb+0xa5/0x1b0
   udp_send_skb+0x852/0x10f0
   udp_sendmsg+0x1333/0x2150
   ...

The opposite mix (IPv4 SA with IPv6 neighbour) stays in bounds, but only
the first 32 bits of the IPv6 address are compared, so an unrelated
neighbour can match.

Skip neighbours whose address family doesn't match the SA.

Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index db260e3d1412..e6dd911475e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -958,6 +958,9 @@ static int mlx5e_ipsec_netevent_event(struct notifier_block *nb,
 	xa_for_each_marked(&ipsec->sadb, idx, sa_entry, MLX5E_IPSEC_TUNNEL_SA) {
 		attrs = &sa_entry->attrs;
 
+		if (attrs->addrs.family != n->tbl->family)
+			continue;
+
 		if (attrs->addrs.family == AF_INET) {
 			if (!neigh_key_eq32(n, &attrs->addrs.saddr.a4) &&
 			    !neigh_key_eq32(n, &attrs->addrs.daddr.a4))

base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
-- 
2.44.0

