Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224974;
	b=hmqR9vDXIaWujFYNmDAvYaQzh7te/WQsgi1IkepDwbC20GncQagSvOLL0jg+z3M8YxPy
	 OfYoVIwJpmsDvqjMaZGGqMTl0aagB3SKAppXsSCWxQlnnUXw1DwWrZ55FteiaJp4Y1nVB
	 Fbp8iG9PPuWBO2nRzNZjIZOT8ZeZLQH3gYO0kJi8n917ZsuxD6ZR6nLugOMXxhHO4Yr/0
	 FbzCN62MUVqM46exr90e+EGxSrn9LIp/knPF5arBKMA0LYzzo1ci7H5YY2L9vBKTXlFOC
	 5SoyNRbMfCoQfSgda19jFMj/gKOUtpl4BVbFsF639ZP5ah+0qCr7zWAMAsQukxxjNuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224974;
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
	bh=iSK2R4UjEOHw9UZoxyqMlUPZ+PvS96juCWwniBlO5lo=;
	b=VvcrD/B/v4FxiiN9zP/eJ6B4fptuMCAnGagknvlj1k88ycS3OiYHs/b50ho1X36MxLF6
	 P3WOCdNptIooMgwOEulEWU7jAJbNeOoh9Nj//03b1XB7PkeMQgwXsVoXMdRy30ofY1TTv
	 SanRpPuSTKRvpks4h3fzczHfD5QeJhlpdxr2kTTVGRRJrEN4MjKyI5waMhT60lzjrtM96
	 jYBRVgukUiIU1gt6X9e+/KtCsWTFHCad8T7gEUypKchZ3UG/k7n+C+U6JXFAozieALtwk
	 i4LLlvzHmqTG0j/7ska+Re9LbhngbiJZ1v2RwlBoM+gjDEPgJjkBk/R5Nfsc50Brqzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XUGpnW6F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.40
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011040.outbound.protection.outlook.com [40.107.208.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13588606A323;
	Mon,  9 Nov 2026 11:49:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13588606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=XUGpnW6F
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NlC+1qyldGSjtiZVMBIPhyZWzggHktogencgUeU6xZFFyeHbAwefvqeRPcjtPl1Tiqo2RNYP6onoPDf6xp+W2kqff/vA9Nr4ZQ65oBNQwHqfqEktMCd64LvMcpYfVzOKFH8Rw6BnFk2RdFoP3F6ii1WknVXXrAI3h80rwq5CTg7y9piK0idXIigRFcgqqh/UTFzKF9ra1410woU92cggqQ8HvZSpVl+bXWDv3m6ExxQDN70p5+dCoHthG3sK0OxTORnDzh9L+EOSAl6pf6MTpCZAF5QcRsvUDNRvJqXEhNgsHqini+C82xWXxTyjNrx0hPVC8rv8KOrmKFMn7SOTYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSK2R4UjEOHw9UZoxyqMlUPZ+PvS96juCWwniBlO5lo=;
 b=BiqqC+oHu8tf+82ixLtnaJOjaALj75nhm6kbL/1VAXGwqufk8G2sFFxBlGNR7bAw4IFsyZxjqTM/pUOjzD6D59gQ2zcYSJVrnvtwaH+VpmPoU1b/UyoGbUIodp9APp6ZZ7XaNR4aL1/8/h3SJYrkcyl0KzNDuCFRZ8/MU/Te9hXj6FTDljawzO3eudIguFAqPVWIBriJJnOU76CyiZ80cE4xhWC56GJipmhIflYZzrHphRgMISxLul211hzi1TggTbHsfub3pFS5O/L5NHOKqFRfX6M7463o6gjj8yPde9TDYBqfRn5Gd06Sl+GVl8rAlGI9iQgQNERlX3emwQgyOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSK2R4UjEOHw9UZoxyqMlUPZ+PvS96juCWwniBlO5lo=;
 b=XUGpnW6F7ix2WPhslELQ++yYT05ExKaYNj9f1/EeMd+2VajJgt1Bq4EocOLH7bFBgKqkfwzp4mnwwbIjqcmWrEneMB6VoPC/S+U+7gODIuv9WKindBbdm63f5orIcDX8dzgRYEl5G6iowPlHVbPmtNbkmxLGwL8dzAmDYqK21g5ZT60Ho7UbNosmU6XaDjYYuMMT7nH0WO+A6bEgDtEs1zio91dxUmQHLPVrL+XhHGlXkFQQsOlmO2uT+O9l7rSPtQggBG2uhrBleJFS/dcP/MXpAmmE7hrxpjnWQrEEJ3NYY7U4Rn3mp8S0U+JefNugrg/qFp2HrqSG+14e32HkFA==
Received: from BN0PR04CA0137.namprd04.prod.outlook.com (2603:10b6:408:ed::22)
 by DM4PR12MB8450.namprd12.prod.outlook.com (2603:10b6:8:188::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 11:49:25 +0000
Received: from BN3PEPF00022BCC.namprd03.prod.outlook.com
 (2603:10b6:408:ed:cafe::92) by BN0PR04CA0137.outlook.office365.com
 (2603:10b6:408:ed::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 11:49:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BCC.mail.protection.outlook.com (10.167.248.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:49:25 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:09 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:07 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:48:57 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Rishikesh Jethwani <rjethwani@everpuredata.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, "John
 Fastabend" <john.fastabend@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, Willem de Bruijn
	<willemb@google.com>
CC: Alexander Graf <graf@amazon.com>, Aviad Yehezkel <aviadye@mellanox.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>, Boris Pismenny
	<borisp@mellanox.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Costa Shulyupin <costa.shul@redhat.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, Eran Ben Elisha <eranbe@mellanox.com>, Gal Pressman
	<gal@nvidia.com>, Ilya Lesokhin <ilyal@mellanox.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Jonathan Corbet <corbet@lwn.net>, Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Martin Karsten <mkarsten@uwaterloo.ca>, Randy Dunlap
	<rdunlap@infradead.org>, Richard Cochran <richardcochran@gmail.com>, "Saeed
 Mahameed" <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
	"Stanislav Fomichev" <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Stefano Garzarella <sgarzare@redhat.com>, Tariq
 Toukan <tariqt@mellanox.com>, Tariq Toukan <tariqt@nvidia.com>, Wang Zhan
	<wang.zhan@smartx.com>, "William Tu" <witu@nvidia.com>
Subject: [RFC net-next 4/7] net/mlx5e: Drain old TX SQs before activating new channels
Date: Mon, 9 Nov 2026 13:47:31 +0200
Message-ID: <20261109114734.2087878-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261109114734.2087878-1-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCC:EE_|DM4PR12MB8450:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cfafa18-44a5-4552-e34e-08df3e5780ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|7416014|18002099003|22082099003|6133799003|10067099003|13003099007|921020|5023799004|11063799006|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261022113327099003|261021123027099003|261021121427099003|56012099006|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	lRb8fqHdtZvEGix5JpzaI//pHGECnu2Dlqt8nujM62Uh2680lOP7jvuPXk8r4sBXyqMEsI1pmbuQ14kWr8u+Ph35aAl+3SjXDyYFdaFoUBMvyayRd3iXMl71yvL94oRFHgjvWZ9aVCn5+If8No+NOnjMP1O3t/6+MUtMkbKqkfCCfvm9bqooo4eq/MBaVY27wHPTCnsgz6qApLjqzJJx0ssE6I/MRFS3j8Atrh5EvGWH/PdBSs6+c1U/U+O5T2ESHnVyPWEtp1BotRbFMme0Q/CnuLcJTHR6oNVf1qNft5iPvwxPiXjbkUhKjQRNir0E/yAQpCCXyaxNmlgMNBd/3ZYCFW1VgBe1Af8awNfXs7Jjm2Wp0C5KG6N8wZQsecsSsqCqt38WCS+aLjolSazPlBJwq6FWa1PpZSO8GVB5sSU4hm/Od/FKwL8t1bl6GdqswqGeRO9v9Es5i22FLAktjlpYwb4IZdvAPju09B3mcMI5UDFm7ON9lUtDf5k6zsKFnuEF8DXsPgMZnwtUoJeGewkw7gOIKyDkbxycW7MiJTneINNMSalaXKYmfw9bocq4BT1F0UKO5/Reu6cZECzEEOivlRV9lkyZW0qt9zU2bIF+wHD9+U0e1VspaRqcc1XhfQQbHZtFyz6WirwiXMls2hksvJOX2SmA18rvu9ISq7Ykjb9hQGCtLeZR0LY59QHgcmevlYgV0GadM6hv8cSNwqLJu2cMYXJhMrqhmw7uSqikQjeP1iXJsYRILhvzz4B4
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(6133799003)(10067099003)(13003099007)(921020)(5023799004)(11063799006)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261022113327099003)(261021123027099003)(261021121427099003)(56012099006)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ucYTi2p1DyWUQw/+jlyNqPtLniUyJUxINVEKyblp2CcfVixCNdkeZxB/LbC7FeCF9VGaJVIptogZVF6lTRCKEozo4Sj1PD/Z4/aRxPFDTdatvPiBfaYQtUniJo6M5HzQDSnrd/hD6HhnsYxbADcpNcVIl3NRrl8zH/wTN/bY8Z8tXLa45YAghjnbtj2fz4MdPZ8s9yUM9Wqsolhfs4Yar/1z2VvhlEhNHCNKEt3106PYLrFAAmqwK8hdmU1Z4eQRU7fVM4iI3/BmgCsafNlbSYw3kKlsxxDJrgboWWspyvXhP5U94aJew9Qkq+GvnR+BHJKHGD0b2zt+DSP4U8MGSS98pdu0stN0g7xClzyNuVGrD1gQmzqXAm4FX9wenMh8eRjqYCSqrMb0WQPSldHUNvkJ11zsK9HlONRHAIt6obAm0xWyBeqCFOZSltkvRPLh
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:49:25.0351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cfafa18-44a5-4552-e34e-08df3e5780ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8450

On devices with tis_tir_td_order, commit 3b88a535a8e1 ("net/mlx5e:
Defer channels closure to reduce interface down time") closes the old
channels only after the new ones are activated. Their SQs are
deactivated before that, which rings a final doorbell, but nothing
waits for the HW to execute their pending WQEs: the completions of a
deactivated SQ are not polled, and the SQ is destroyed only when its
channel is closed. Meanwhile, the new SQ of the same TX queue starts
transmitting. A flow's WQEs still pending on the old SQ can then
execute after its newer WQEs on the new SQ, as WQE fences order only
within an SQ.

Besides reordering packets, this breaks kTLS TX offload. The WQEs of a
connection update its TIS crypto and record tracking state as they
execute. When old WQEs execute after new ones, e.g. because a PFC
pause held the old SQ back, the TIS state gets out of sync with the
TCP stream, and the connection's records go out corrupted.

Before activating the new channels, drain the TX SQs of the old ones:
reap their completions until all their WQEs have completed. If they
do not drain in time, e.g. under a long pause, warn, and close the old
channels before activating the new ones, as before that commit. Move
the deferred closure into mlx5e_switch_priv_channels(), next to that
decision.

Pointed out by Rishikesh Jethwani while discussing kTLS TX TIS reuse
for TLS 1.3 rekey on netdev.

Reproduced on ConnectX-6 Dx, with 248 channels, by changing the
channel count between 247 and 248 every 2 seconds while 32 kTLS TX
offloaded connections stream pattern data to a software kTLS receiver
that checks every byte. On this setup, the new channels are activated
about 230 ms after the old ones are deactivated, so the old SQs must
still hold WQEs by then: with every TX queue rate limited to 10 Mb/s,
9 of 41 connections failed decryption in 60 seconds, and 11 of 43 in
120 seconds. With this patch, no record failed in five such runs, 7
minutes in total; the drain timed out and fell back to closing the old
channels first 7 times. At 1 Gb/s per queue, the old SQs always
drained in time.

Fixes: 3b88a535a8e1 ("net/mlx5e: Defer channels closure to reduce interface down time")
Reported-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
Closes: https://lore.kernel.org/netdev/CAKaoeS1hj9XuM7ojLBCjGA=EXc2M-b+eRjC2Sk=8L_8XYeJ18w@mail.gmail.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 88 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 41 +++++++--
 3 files changed, 118 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 24e91279243e..b5bd1b6e8601 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -112,6 +112,7 @@ struct mlx5e_xmit_data_frags {
 
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
+bool mlx5e_txqsq_drain(struct mlx5e_txqsq *sq);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 
 static inline bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c3c2c5720c6f..a721e30bcaa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3421,6 +3421,82 @@ static int mlx5e_switch_priv_params(struct mlx5e_priv *priv,
 	return 0;
 }
 
+/* Time for the TX SQs of deactivated channels to complete their WQEs. */
+#define MLX5E_SQ_DRAIN_TIMEOUT 100 /* msecs */
+
+/* Returns 1 if the SQ still has pending WQEs, and records the first such SQ. */
+static int mlx5e_drain_txqsq(struct mlx5e_txqsq *sq,
+			     struct mlx5e_txqsq **pending)
+{
+	if (mlx5e_txqsq_drain(sq))
+		return 0;
+
+	if (!*pending)
+		*pending = sq;
+
+	return 1;
+}
+
+/* Returns the number of the channel's TX SQs that still have pending WQEs. */
+static int mlx5e_drain_channel_txqsqs(struct mlx5e_channel *c,
+				      struct mlx5e_txqsq **pending)
+{
+	struct mlx5e_txqsq __rcu **qos_sqs;
+	int num_pending = 0;
+	int i;
+
+	for (i = 0; i < c->num_tc; i++)
+		num_pending += mlx5e_drain_txqsq(&c->sq[i], pending);
+
+	qos_sqs = mlx5e_state_dereference(c->priv, c->qos_sqs);
+	if (!qos_sqs)
+		return num_pending;
+
+	for (i = 0; i < c->qos_sqs_size; i++) {
+		struct mlx5e_txqsq *sq;
+
+		sq = mlx5e_state_dereference(c->priv, qos_sqs[i]);
+		if (sq)
+			num_pending += mlx5e_drain_txqsq(sq, pending);
+	}
+
+	return num_pending;
+}
+
+/* Wait for the TX SQs of deactivated channels to complete all their WQEs,
+ * so that none of them executes concurrently with the new SQs.
+ * The PTP SQs are not waited for, they carry PTP event packets only.
+ */
+static bool mlx5e_drain_channels_txqsqs(struct mlx5e_channels *chs)
+{
+	unsigned long exp_time;
+
+	exp_time = jiffies + msecs_to_jiffies(MLX5E_SQ_DRAIN_TIMEOUT);
+	for (;;) {
+		struct mlx5e_txqsq *pending = NULL;
+		int num_pending = 0;
+		int i;
+
+		for (i = 0; i < chs->num; i++)
+			num_pending += mlx5e_drain_channel_txqsqs(chs->c[i],
+								  &pending);
+
+		if (!num_pending)
+			return true;
+
+		if (time_after(jiffies, exp_time)) {
+			netdev_warn(pending->netdev,
+				    "Old TX SQs not drained in %d msecs (%d pending, e.g. SQ 0x%x txq %d cc 0x%x pc 0x%x), closing the old channels first\n",
+				    MLX5E_SQ_DRAIN_TIMEOUT, num_pending,
+				    pending->sqn, pending->txq_ix,
+				    pending->cc, pending->pc);
+			return false;
+		}
+
+		usleep_range(10, 20);
+	}
+}
+
 static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				      struct mlx5e_channels *old_chs,
 				      struct mlx5e_channels *new_chs,
@@ -3428,6 +3504,7 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				      void *context)
 {
 	struct net_device *netdev = priv->netdev;
+	bool defer_close = false;
 	int carrier_ok;
 	int err = 0;
 
@@ -3450,7 +3527,10 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	}
 
 	mlx5e_set_xdp_feature(priv);
-	if (!MLX5_CAP_GEN(priv->mdev, tis_tir_td_order))
+
+	defer_close = MLX5_CAP_GEN(priv->mdev, tis_tir_td_order) &&
+		      mlx5e_drain_channels_txqsqs(old_chs);
+	if (!defer_close)
 		mlx5e_close_channels(old_chs);
 	priv->profile->update_rx(priv);
 
@@ -3462,6 +3542,9 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	if (carrier_ok)
 		netif_carrier_on(netdev);
 
+	if (defer_close)
+		mlx5e_close_channels(old_chs);
+
 	return err;
 }
 
@@ -3499,9 +3582,6 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
 	if (err)
 		goto err_close;
 
-	if (MLX5_CAP_GEN(priv->mdev, tis_tir_td_order))
-		mlx5e_close_channels(old_chs);
-
 	kfree(new_chs);
 	kfree(old_chs);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index bee6f0bf1eff..eb20e3d14d46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -780,10 +780,11 @@ void mlx5e_txqsq_wake(struct mlx5e_txqsq *sq)
 	}
 }
 
-bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
+/* Returns the number of polled CQEs. */
+static int mlx5e_poll_tx_cqes(struct mlx5e_txqsq *sq, int napi_budget)
 {
+	struct mlx5e_cq *cq = &sq->cq;
 	struct mlx5e_sq_stats *stats;
-	struct mlx5e_txqsq *sq;
 	struct mlx5_cqe64 *cqe;
 	u32 dma_fifo_cc;
 	u32 nbytes;
@@ -791,14 +792,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 	u16 sqcc;
 	int i;
 
-	sq = container_of(cq, struct mlx5e_txqsq, cq);
-
-	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
-		return false;
-
 	cqe = mlx5_cqwq_get_cqe(&cq->wq);
 	if (!cqe)
-		return false;
+		return 0;
 
 	stats = sq->stats;
 
@@ -891,11 +887,40 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 
+	return i;
+}
+
+bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
+{
+	struct mlx5e_txqsq *sq = container_of(cq, struct mlx5e_txqsq, cq);
+	int i;
+
+	if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &sq->state)))
+		return false;
+
+	i = mlx5e_poll_tx_cqes(sq, napi_budget);
+	if (!i)
+		return false;
+
 	mlx5e_txqsq_wake(sq);
 
 	return (i == MLX5E_TX_CQ_POLL_BUDGET);
 }
 
+/* Reap the completions of a deactivated SQ, whose NAPI is disabled, without
+ * waking its TX queue. Returns true once all its WQEs have completed.
+ */
+bool mlx5e_txqsq_drain(struct mlx5e_txqsq *sq)
+{
+	int polled;
+
+	do {
+		polled = mlx5e_poll_tx_cqes(sq, 0);
+	} while (polled == MLX5E_TX_CQ_POLL_BUDGET);
+
+	return sq->cc == sq->pc;
+}
+
 static void mlx5e_tx_wi_kfree_fifo_skbs(struct mlx5e_txqsq *sq, struct mlx5e_tx_wqe_info *wi)
 {
 	int i;
-- 
2.44.0

