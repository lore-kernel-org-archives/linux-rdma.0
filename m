Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795730212;
	b=qCLcDXtfjuX6ylAA0ghv/cfMhzvu2vT17ZyTDvcxliB6O2Fj7qb/Y294gTAo1TfMU9Gw
	 UARC35ip0ceopTtk+N6cGoQn3Nm2auosGFJo0sn7VQtoAAeQ45jUe/wQeJZMQ1vr3CJPY
	 WiSNtZpj/QUV2cCfAqp9MpZcWkuPa1ybLXpQs1UcWtG1xzgRawH/Hsm7SqJWnPg08fFGG
	 VVZBhq6GbhE573VUDJf1kECNdEsEGKcVfotKYt776Mkt8t0XnPghnWyITLm1MnMIQio5W
	 MgV6gd7Hs38ixc7AzhvAXGuXGrxnwZy8VgAtQ2+pAlHP25bYjIgK1VspNG7Cqo8NI4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795730212;
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
	bh=HG8sw6LR97kshYhK5mT8oaufbSC1YRVka7+mHWEzkIA=;
	b=C7b7preN2LT1bgeDPQK81Q7Wf3Qvep9c8wSa5hrlDgtiyd7kDJ66kRFS3rSCGKPq056L
	 1AEwdIOFsPN0tW9pjsyn/fICwErZkxtugrtWAJq2BPhsedSh9LczoJyNF5XOBX/vH4q5E
	 o8cFPfNDt73zoe835fPnql0wzlqGzvs669w6wzv3cKJt1MKScRQFWoyfRG8evHt5GnbDQ
	 ywR37l/GDbqJNvfKC8u6YwhEUyRYtZPcHk+AVIElVDDPPHiJqVsgFCb6aslwhgt6w26Og
	 leywoBVNUqEn728MPf5YbFEOgy2FPv8HCRrolUerDS54pqYGe9VCyBIO16iHzKznNqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q8KhMmhh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.25
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011025.outbound.protection.outlook.com [52.101.57.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19AC606A31E;
	Thu, 26 Nov 2026 21:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B19AC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q8KhMmhh
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EEVdTCexqriekuig41W7FB6coFsWxkZ3R0C0lUr/1b9ibu82+JPzsQXuzcz6G0n2bpyz5IL/SSAboYdPNBLRi3lsigskjd4Raisote4jhiUS7pj6+jqJqxvYhAS9TWQBS0jv5I1KPzAsCh8hJqQsbpk7zjwXAJzZOYoyKmYbMXFtYXgZEvlkbVYu7kAEvWxy7otpc19WXzMTZvtJtSiVp2jwFmie7t83a73gtkTeLCaSGfEnc4t8HB0xjMysTeuRFcGWKRI7b99otqiQAkXryF3tB1iQFvwAyhDvWPjWLI+PvMJXfCHLaW8yQUB7ofgpn7/7rdHiIoV8FpyMGapfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HG8sw6LR97kshYhK5mT8oaufbSC1YRVka7+mHWEzkIA=;
 b=kx0YKtZ/3HQyfS6E0r3YN4nmTCy/C4izsWWpQHSyhTreHsvCUscTNL9qQxo3IoVurWOWKKNG9R+nJF5NzCYAQPQ6KlxOy1diPJtN9eQ0ejmQYDys+ADgerQ1UeWXD3/dMEEPaKTTDdMvF0UacJ0YTO1tciJHiGpMHkdNI5KkOm+fNtmZXmKmvuJREJfqmiN9enWb6TPdMiBMHcGhy/EsNiIezFznWBy8TKDwEcsPenT8RFPh6VaFe8Lh+9ty4BMvv1a7iC45BnWRCfpzteTZIz6hWsEE/H77On3fevFyIjcM6VSRFXSCW9SVP6BZr2iGyAk/JTIA7dOj9h0K+21+Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HG8sw6LR97kshYhK5mT8oaufbSC1YRVka7+mHWEzkIA=;
 b=Q8KhMmhh9hfRhFsyzz3OxvLKf3+ifn+xPWvnqg8HGkto/PT63erHaAWRHZPA5yJM9KvMsSI8Nzz2y9a5TBN/zmk35c4Tz4AAJlaZqTEwkM7/BE59bJ1jKMusLiBOVl0J/iZBtk9E5Vq1EUIaek+vWFNJCPvCeOeOvOoZFcT8hxQ/Hw3YFzefYi+MQvkeatvwe/wEawV69d+3fR4fDQdf/IoOxpSaeeN1h1IB+oTB/2ObxvgSDpa7ToFBB39A8vkantaM47CLT/jFEBw2NPaoIc9oy2v92JE34yJfj+cy1QD8eodWooVIB7eWAnzYpoBeAoRxR+1LxanYIaSfjFhnqA==
Received: from BY3PR05CA0042.namprd05.prod.outlook.com (2603:10b6:a03:39b::17)
 by SJ2PR12MB9086.namprd12.prod.outlook.com (2603:10b6:a03:55f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 21:56:46 +0000
Received: from SJ1PEPF000037A0.namprd04.prod.outlook.com
 (2603:10b6:a03:39b:cafe::78) by BY3PR05CA0042.outlook.office365.com
 (2603:10b6:a03:39b::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.5 via Frontend Transport; Thu, 26
 Nov 2026 21:56:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000037A0.mail.protection.outlook.com (10.167.244.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Thu, 26 Nov 2026 21:56:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 13:56:44 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 13:56:44 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 13:56:38 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>
CC: Andrea Parri <parri.andrea@gmail.com>, Boris Pismenny <borisp@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>, Elliot Edmunds <eedmunds@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, Jeroen Massar <jmassar@nvidia.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kuniyuki Iwashima <kuniyu@google.com>, Leon Romanovsky
	<leon@kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>, Raed Salem
	<raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Simon Horman
	<horms@kernel.org>, Sridhar Samudrala <sridhar.samudrala@intel.com>, "Steffen
 Klassert" <steffen.klassert@secunet.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net 00/10] net/mlx5e: Fix IPsec SA races and neighbour handling
Date: Thu, 26 Nov 2026 23:56:04 +0200
Message-ID: <20261126215614.792598-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A0:EE_|SJ2PR12MB9086:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e620470-15cd-4854-915e-08df4c0829e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|7416014|23010399003|6133799003|18002099003|56012099006|11063799006|261022075727099003|261102123227099003|261022105027099003|261026140227099003|261028144727099003|261021121427099003|261021123027099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	2Nho1GUSG+TzOrMkgesnNf/ay1mTxQpiK0LaROEHPtOG1DhuECuK4Y8vjFpH5dHntGbytzzb4GadhEHRAZGm6ycpSK0U+J9fJSDv2XSmroEA0xnGVCf6OrowZ5/wT8zwjM/PywOQwm+eS9hCcGrgyAQgEN73NPEtK3xiTgNbSgsq+pmFnqbsjyPmwc2H80dazixFCmeo9/aRNlYIyKiI2LD8keyWA9oGgoqv9lGHN/RGbK1BJyg0l8dojEPMTHQfJdtqxsMBYEMrJaxhi3n8HpMRnp95pYYwFGC0IzMegP++wozLnL6h66dVbHdevCY2kPwfHZSfWhaV0E5JPFw/04hIvL+Q0W1X8og4fymHHz5X36mbSNykrHtG7U3muFCN9dvDU6cj4PEYR9xb4srzSXohwlV3m7d2cK8KlIIuwHsDtpwffSDxk9E22lxfXPkmx+paQFF9bbaNfcXkfAcY26HB72myIRu8RW65yBZcffQ9CLG4R0dBKE3iYxc8ZxFWi7DgDEHLZlNfKqJQUnM/IwUauv+29qnjWdaP0ocC88jBn8Izaq8mbGvMjodNrTEuNDOAUK4OqCVstmg+cjdM5tBGtbJKxlo0fVl0Z4kVtgnzgVWls6Sv/Ed5kRZWSGwwT321CShFvERFRrAlV/vqx6rKumjpAY4YzkJs2oHSPCD0i/mXBQ9PKY+wMM6MZhXe43ghzuEOisCTWSEHAm4cew==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(7416014)(23010399003)(6133799003)(18002099003)(56012099006)(11063799006)(261022075727099003)(261102123227099003)(261022105027099003)(261026140227099003)(261028144727099003)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	s8PR06npDjR/Bt6nLg+ois7oub4YNJCGwGBOT7Wo76rqhJB3UnGNCJ5cJ170EzFobFAlILzoSwP2TRi0aH3J9EsARvv2bUhdMm5npoHSA+1kOsCATF9jDQ8N4PcGeB5nZejv4aNwHOXMuaaF31W6l2ahVTVEXBr2Yi+SwIisNngp2BYORCABnAQ8isN74hI+RE/G/QN4Nktd2TcRkv7ETAF9vbyj8IoLSZOM7+pYMSHvXtvSvYIZ0NUj5megbP75xFIKnbgVhB9+G78YLLz6hty9qX4Wlr4Cmn33b9ro434IITCrWK0kLyb3DxCTaZYwNoynjV02QmTJtaYpXC9UwcAT0jQHzEIztFmlEIa3lEIdxhNhoMmajkrm8O7bzLomQPB671HBdyOEpapgwux1w7rlayo4aEHS7BT98X3RKX5y44PvRWAEQm/bDHytRorN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 21:56:45.5899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e620470-15cd-4854-915e-08df4c0829e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9086

Hi,

This series by Jianbo fixes a number of bugs related to IPsec, neighbour
handling and hardware event work.

These bugs were found by Sashiko, code inspection, code development and
a field report, and tested on ConnectX-7 with a reproducer where the
bug can be triggered.

Please see individual fixes for details.

Regards,
Tariq

Jianbo Liu (10):
  net/mlx5e: Initialize IPsec XArrays with XA_FLAGS_LOCK_BH
  net/mlx5e: Stop counting packets dropped by IPsec RX SA rules
  net/mlx5e: Fix IPsec SA modify/stats update race
  net/mlx5e: Drain pending hardware event work before freeing IPsec SA
  net/mlx5e: Drop IPsec tunnel traffic if the neigh cannot be created
  net/mlx5e: Fix IPv6 neighbour fallback for IPsec tunnels
  net/mlx5e: Copy back only replay_esn after an IPsec ESN update
  net/mlx5e: Validate neighbour events before updating IPsec SAs
  net/mlx5e: Serialize IPsec netevent MAC snapshots
  net/mlx5e: Create IPsec flow counters once per SA

 .../mellanox/mlx5/core/en_accel/ipsec.c       | 130 +++++++++----
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  29 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 171 +++++++++---------
 .../mlx5/core/en_accel/ipsec_offload.c        |  27 +--
 .../mellanox/mlx5/core/esw/ipsec_fs.c         |   8 +-
 5 files changed, 223 insertions(+), 142 deletions(-)


base-commit: e1055cbfd6eb578417f3ce983cf44462e8465267
-- 
2.44.0

