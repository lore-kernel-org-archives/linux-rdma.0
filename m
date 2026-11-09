Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224947;
	b=c5lRSNUzxHSRBpcf3TRPQB4Xz+wFlmuF0AN7+86x4l5EdrB+aGPAeupiYkZ9yjExar2Y
	 2IhyJ+Ks/nLFkCBx7CF3k8xoUeKygDcB8i17kiFChfHlc0B1KQLSF8xl2HjgVSWWgMxZW
	 LHiuD/QcPXy5pcBRNNMil1mN5cNGT0AkJg29GLfNOpx7hlmIpD4CSNZ0SIk4DgszAu3+k
	 +y8opIumAp+J3T9cdzbpxo4CPtPY5887OHEjZP3090IFiQ1cdbyLx7tCEgi4Np6wyPXwq
	 5heFMUXsA/kvAjzwrSem5VH33kSvl1iIKp941NhiSyldHvY2T1Om2IkauruzVhZmSMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224947;
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
	bh=prKzPEmg7TNwL7izr5fVotKy+qjy0eXdDoWy49pfBCw=;
	b=bHkZs1ZMOp11TJ9KX+Rji2gF2iabbCmftprhNpdtTdCl+t+XGAQq/+Ui1BbJb1FOtTnr
	 c5n/1S/GJOOxzb3ZfdF4aN1RFn8IXf6KGHg7O1c9jC36T9XNIFT8GRXJdagLQiFdOrHOq
	 T4mjFYNxVKH1lXTe8CBo0ha5Bu0YA+fvfBO+JhSlwLsUL59kEqbUSNT8qNBlx3HNJPKL5
	 azTZYqeWCQ6nzpfdxQZBBd3z5vFT0vt9Ts3tKbC88V50z+QtLkz42znA+MhDcE8wk5u65
	 aB91rSUgDPhxZvRBttXBsMzZvahQQXo4dAUdnJxIS+Q34hTvzah09e507CQbCB9XceQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CDn8giow;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.66
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EC5606A321;
	Mon,  9 Nov 2026 11:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50EC5606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CDn8giow
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhFG8NSkF3TsV+lyoNJoxi9s7n/JTmpFUI82wVqcCuaXeJxO1EPSPhGa8An99AiJC/Ni7ub0do8GPyiPcS+DGo013o3Dvv50Ve/3int5VOsTJy5ryTjo4PaD9mnAQ7cShDIlyGxY4GbSkSGd/BQ57DZ64G+GoV6j1HNuGUylKbPtM4HClV15ycuv81CO4mEaF6ecJtJLM8QaODCsacvJ9qW+KBvtoDnidixJ8DNjUY5GIFdIiV0VKigxgtR2IGRd3dxvQAdu/euwH2kxDO5uzBp4PQNc2B347muawBO0lSvk4/n4gmoC6se/jL6blnoOloqWebEu1EKBJjhthJr82w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=prKzPEmg7TNwL7izr5fVotKy+qjy0eXdDoWy49pfBCw=;
 b=NtNPrM4G0OiCtEuZr9WLC4IJkGWGhsBhVatbP6Oj9K6oZnQAP7406i3tc5dZEyojuEQNgWtarizBxN3SqHKSksTC08G7WUoDwRfYJYRHGzHeU8QD3XqCGLOlb4eRcAcFrFEfnDgy9Yk9m2C3Xc7JOiGL5G1F2+HsMqz9jAS1/HIV982MxYB0eEogIfbTFYX/ZpJLdkKt1EHVL83Lm/3KsBYenI1HqNxf9ew65ExJ3aU6UAr4FC/2gMO0DZ9ExuFKwW2uaQHlDgQ91BD6oS//kBTFhPSsJQZ2HRRWz7mJwFbitRVSIEj0rhMk3ObE+e07ACmtfdfmSrzfiDmpxcBVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prKzPEmg7TNwL7izr5fVotKy+qjy0eXdDoWy49pfBCw=;
 b=CDn8giowiifDvASa++Fc8t3H+nIbqnLrlq4/UsK2OumQh5fdPsjouC8Y1XieaQ3YLwiMDBN+0J6gA2Tp6f6pHTvvK+I298JXKb/vgGF9F+Gpz4njL5uUUogLBShIvVPfoLQwadUyCsQuSY3K4GbGXEjoMtSqlSFJ61btjdyegJsT5ZYe7JZlxKINdyjVNI3GTQf7owhyfUA0ovDZ050mFCwK8UF2trH3UdTTBDdEppOmzaISQITVBBci89wyUWzUQ0IQe17mpEA2LxKO0cb0NoLYHTbHQPPFDvwbpaFBk1Kn7ouFgnfjVTi95kWs5NeJxD4O90n+V+SHeIQUtGX5CQ==
Received: from BN9PR03CA0392.namprd03.prod.outlook.com (2603:10b6:408:111::7)
 by DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 11:48:53 +0000
Received: from BN3PEPF00022BCB.namprd03.prod.outlook.com
 (2603:10b6:408:111:cafe::40) by BN9PR03CA0392.outlook.office365.com
 (2603:10b6:408:111::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 11:48:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BCB.mail.protection.outlook.com (10.167.248.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:48:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:36 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:48:25 -0800
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
Subject: [RFC net-next 1/7] net/mlx5e: kTLS, Hold a dropped skb until its posted WQEs complete
Date: Mon, 9 Nov 2026 13:47:28 +0200
Message-ID: <20261109114734.2087878-2-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCB:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: 42990cff-feb0-4704-62a9-08df3e576dba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|7416014|1800799024|18002099003|22082099003|6133799003|10067099003|13003099007|921020|56012099006|11063799006|261028144727099003|261026121527099003|261102123227099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	5XHZrP8UjJXgwHz4c7uilZwVhSdbjbuqf95QI44bdI1ElURV11qw2Ktm394oi49jhEqdGqZ+/PUK4mrgsgi2oohukrXO5rIyw54tA0pM/4jSWGrL96n+iIdBa+9pZpjNfrxpeNHusS5dUm8Jq2a7NDy34kzNtFhAjoZonC8n4C9ukZEst+ELJ4VgpFcWc9jgpqNV7Djbg4mSDEUItDgekjos/poaNbSY5JGIc79weyJ0ac9lESqMTnL2ALhiDVHkKYP+HgHrXvqWhvIjwCa41R0cV4hHG9kmfWX5NKhZoO4tGC2lCsb6RHBvZdwsTdqU/eX4KacWG8id4ytkCmLlYj5rdrbwFgfAAqeVwNwnYX+Hm67nxNRKxiVdHW68VZbWgYTby3jZCjKvVl4BSqkWNTG3j4oXaDq3OdhvuQusM2vCwRGFenFbL6PKiY/sNaQhOPV9HliWQK4TesUrjFhT8acnzm9yj0KwW1HRMafMM1K23LAwVEbKETNpEiQGmQjZegtbOMHsro/ArfGz4uk3QtJ43Q6lBtpv1JfFbohiqlV/EgFiNgOcI3/Ys+0jeFQEFszt7cwSzZakdmEEfnrcGda55yZxRRqzHKisUu+arnGdCumWg7d0qP1wpzu0nyoV4DUe9+NsaxhOTBALzRCFSeRQB3yc+ydqnk9VotlCaoue0Ad/be98YAxD6V10c4YP8To3UVM5Mbei9nn5Irh7ww5Tc+z95NIUnZA6S932SrXFDYZq15v9GjqdnuseqSPh
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(6133799003)(10067099003)(13003099007)(921020)(56012099006)(11063799006)(261028144727099003)(261026121527099003)(261102123227099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CAb7mZJXRXGaceWPQ6kj2ChTxf9y3PdchfH9MptdBM71EgJWNY5/OF9Ehvqdt9FON2MqXUjIG1/PoXD9PS4IVcK4g+ogtB/YmmWZiUBUtrs6TAk/7qmVQIxzsxfEiP5mL7EBzLD4X0nRFbne9bIbaz8py89pt07vPwQrhpKQMNVphvvAxk+E9xa21ILI0NxxFeEI1xcAKvlGBR+laDtmkhgR4a9S3W9QBGOObq06irYaHRqutdejmvQw8NGOTtFajloxGJSfVha+P6ooqG0l60icY/As8CTKrnID8xnwPvxDRAkf2Yu8x+Dov3O7V7LwyojOA4idBAvrQM50vfL5Wmqr9dQsF0n4gpm87YJ5fSuKDpEdz4fXf2IKLfFRo3q4KnosA38cq33stYW6LAGy49g8bx2yrgFgIt5SUwHDOqwvEMjWBD1FKJ9bz2HRHiYb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:48:53.2528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42990cff-feb0-4704-62a9-08df3e576dba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718

mlx5e_ktls_del_tx() releases a TX connection's TIS and DEK with no
completion tracking: the DEK is destroyed, and the TIS is returned to
the recycling pool, right away. This relies on the socket lifetime:
tls_dev_del() is called only once the socket is destructed, i.e. after
sk_wmem_alloc drained, so every skb of the connection was completed,
and with it every WQE posted ahead of it on the same SQ; or from
tls_device_down(), after the channels were closed.

This does not cover the error path: an skb can be dropped after
parameter or DUMP WQEs were posted on its behalf, in the kTLS TX
handling, or when DMA mapping for its SEND fails. These WQEs request
no completion of their own and hold no socket memory, so freeing the
skb can let the socket be destructed while they are pending. The TIS
can then be handed to another connection, and the DEK destroyed,
before they execute.

Defer freeing such an skb to the completion of the NOP that
mlx5e_tx_flush() posts: completions are in order, so all WQEs posted
before the NOP are retired by then. The SEND error paths already post
this NOP; post it in the kTLS error path too. In the SEND error paths,
only skbs of kTLS offloaded sockets are held.

Found by LLM-assisted code inspection, while answering a question on
kTLS TX TIS reuse for TLS 1.3 rekey on netdev.

Reproduced on ConnectX-6 Dx with test-only code that fails the SEND DMA
mapping of every 2nd skb of short kTLS connections, which reset 0-1 s
after sending 32 KB, while bulk kTLS traffic at 10 Mb/s per TX queue
keeps the SQs backlogged, and that counts TX contexts released while
WQEs posted for them are still pending on their SQ: 32 in 60 seconds,
their TIS returned to the pool and their DEK destroyed early, against
none in the same run without the drops. With this patch alone, 11188
drops released none early.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@purestorage.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  1 +
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 44 +++++++++++++++----
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index f2a8453d8dce..24e91279243e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -377,6 +377,7 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 }
 
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq);
+void mlx5e_tx_flush(struct mlx5e_txqsq *sq, struct sk_buff *skb);
 
 static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 29769fc99c4b..31f61f2ba824 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -890,7 +890,8 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	return true;
 
 err_out:
-	dev_kfree_skb_any(skb);
+	/* Parameter and DUMP WQEs may have been posted for the skb. */
+	mlx5e_tx_flush(sq, skb);
 	return false;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 14479da98f42..eb8a7a89b120 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -348,7 +348,11 @@ static void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
 	}
 }
 
-static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
+/* Post a NOP that requests a completion, and ring the doorbell. A given
+ * skb is held by the NOP until all WQEs posted ahead of it are retired:
+ * WQEs posted for it, e.g. kTLS ones, may need its socket to stay alive.
+ */
+void mlx5e_tx_flush(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 {
 	struct mlx5e_tx_wqe_info *wi;
 	struct mlx5e_tx_wqe *wqe;
@@ -361,13 +365,35 @@ static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
 	wi = &sq->db.wqe_info[pi];
 
 	*wi = (struct mlx5e_tx_wqe_info) {
+		.skb = skb,
 		.num_wqebbs = 1,
 	};
 
 	wqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
+
+	/* The NOP takes the room of the SEND that was not posted. As after a
+	 * SEND, stop the queue if room runs low; the completion wakes it.
+	 */
+	mlx5e_tx_check_stop(sq);
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
 }
 
+/* Drop an skb whose SEND could not be posted. */
+static void mlx5e_tx_drop(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+{
+	sq->stats->dropped++;
+
+	if (IS_ENABLED(CONFIG_MLX5_EN_TLS) &&
+	    tls_is_skb_tx_device_offloaded(skb)) {
+		/* kTLS WQEs may have been posted for the skb. */
+		mlx5e_tx_flush(sq, skb);
+		return;
+	}
+
+	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq, NULL);
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     const struct mlx5e_tx_attr *attr,
@@ -470,9 +496,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return;
 
 err_drop:
-	stats->dropped++;
-	dev_kfree_skb_any(skb);
-	mlx5e_tx_flush(sq);
+	mlx5e_tx_drop(sq, skb);
 }
 
 static bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct mlx5e_tx_attr *attr)
@@ -612,9 +636,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return;
 
 err_unmap:
-	sq->stats->dropped++;
-	dev_kfree_skb_any(skb);
-	mlx5e_tx_flush(sq);
+	mlx5e_tx_drop(sq, skb);
 }
 
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
@@ -810,6 +832,12 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			sqcc += wi->num_wqebbs;
 
 			if (likely(wi->skb)) {
+				if (unlikely(!wi->num_bytes)) {
+					/* Dropped, held by mlx5e_tx_flush() */
+					dev_kfree_skb_any(wi->skb);
+					continue;
+				}
+
 				mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
 				mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
 
@@ -1007,6 +1035,6 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
-	mlx5e_tx_flush(sq);
+	mlx5e_tx_flush(sq, NULL);
 }
 #endif
-- 
2.44.0

