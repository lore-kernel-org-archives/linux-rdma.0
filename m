Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224962;
	b=3cvvbwwrLF1ynwncPYGWIT/p9WkKpeMm4LNBi4zlHp0IE1r6AnCyH+zNjZFoJ6YvVy+H
	 jSy5j63UPxRNv48pAISMpSWyFVP6pQwH7x5gmARzBUFkTMpknV3ydXOBEg/SE5Dwg6OMf
	 So5OWnjiE0IJxNnymYi7JKKCtQyCLAvpeNMACxmSJKxOOfpELa5sLZRuCH72iV4IoWwQy
	 7kGIdTKtNbYJ7fJ8/Vor1r5OWYyvPtAfPRDCUrV4ILq+UHNdLJzL6p0nNbpBbulw2M6+x
	 knoqOcqOVluGE5mT2c7dNPiq0djan5d2xJYi+uJxJlP+dNZuX9jtjfSr5Esh79sLIDw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224962;
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
	bh=JAhr/oX+MoSmLu9aYtpBIb7VRDBE71KMvVFN1dgjjR8=;
	b=nh5zanfRMUmDiXxBpWZD4kHNNDTZ/Z21+m15rttGwq2QPPgdIiCwo4qr3RN7F3sW4V78
	 IofNdZ3+Fb+8nOfuhjJ4sBQCP+FQ6ODtVQyoz4duamSxiCK8xFkR+X2/j+MDHCSYIoeNx
	 1q2qeY8hktJ1ArtFRy13sqpOPtD1mysOqX8eNploclNPbvZaZarqoGrzSJ3FB0kRJ4BTG
	 Vf3J3/lX1Uoj5wBqPfJTZJRPbr8KsMmm5msOcVKYIkQm+UUgPwmiZf5E9+SoCQd/T+DBO
	 B63xxs9ycaba2kHc9DpehVvEh1ruXAmXk02StmVvBekXjpML8P+jDcP8XkMmtZtj8eA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fGRjsXs1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.27
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15866606A323;
	Mon,  9 Nov 2026 11:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15866606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=fGRjsXs1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rxdXB8gzyufXFlrjB+3NTH2SSkAW1yXD2fyHD6DxJ5ubEhiKM2Af5EDQqux9yEu5WUll8eAuovdLAgpFDLwk13Z6oLqyvdYhiCz6pJv5i5nS6R0vRqZq+HhEZZ6D0IBISDAAsCcq8iKACmCfZCBzbQCT8PJLXQt86JItyUUa6kxwVZ/R5gUeO61oSFKZ4FNur7cVQPVsfwIA/Phvirv6eGmmIOyITO/v7MPS3tTlUpX2DCYDZCq+cYWuK+K+qzRvbKEGIreYAugPL0kJk8pFkl1WUj9O0aRJ6qAFQ2zKiZJzMTBhqQz1XeDXNMJwYGNsOIpshxzUTC8J+cHfehQAsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAhr/oX+MoSmLu9aYtpBIb7VRDBE71KMvVFN1dgjjR8=;
 b=WxQQ9MFoUcSHIj+ZHldHkNVcYqt9bJGXoIYrmqXBqbpYunDdYUsWsGzHuyve4hHoPq17h6TEwEiLpTSA0yRSBIZlw/tOe7j8Yi36W5y18DyPWVdcVp8LZMvBPd8o72Nz7tIxjdyn3o9Xya0ipTPlyZLZYueXdwxTF3G4qylPrvWKnJK8vxdPuo9jB4w5FicdFMrN59vn2l0ElSce62z/84ydHaJamRq41VyxttKJYXDXWpigK3mE+FCT3oyk0YOlI3Co/tfXni8xgcQ772TjpVjuFcD0ofoKOSI5U+akqpsT6CM+Tw6XgNJ18fAepHCEA6ohMUk3ajvXEO9Ij5wwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAhr/oX+MoSmLu9aYtpBIb7VRDBE71KMvVFN1dgjjR8=;
 b=fGRjsXs1E9ZtUJLw32truQVurGqGXlIdzPFJPpBGflrygi2CQJ+e5g/twxYJxdptpTqmB3b4weTUD4MM2y44vRrRvORAoIGjK9fZC9+NtBzvCoH4zpp3hzKqpXVvmg6OFC+TLEMJ/wmuNUXTpNFQ5/SKDs22yV5N80OmTT58jWUuiWwu4i10qqPTGPy/lHXU1Ml1w8ldatCZkENx93yyW/u7cFMARrR3aQwdeoJMgloVmVC4jTieDXzGGYLoqfZPlxpqnchBaIqTI38aFCigBAN4MfO5xL5HEwlYm0XPQ+CLvt0N/GtfVKToC1hP5bZ9qyCpyUEEBirQpa/S8g5V4A==
Received: from CH0PR03CA0064.namprd03.prod.outlook.com (2603:10b6:610:cc::9)
 by DS0PR12MB6632.namprd12.prod.outlook.com (2603:10b6:8:d0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.12; Mon, 9 Nov 2026 11:49:11 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::30) by CH0PR03CA0064.outlook.office365.com
 (2603:10b6:610:cc::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 11:49:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:49:11 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:57 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:56 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:48:46 -0800
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
Subject: [RFC net-next 3/7] net/mlx5e: kTLS, Post TX context params only for skbs that use them
Date: Mon, 9 Nov 2026 13:47:30 +0200
Message-ID: <20261109114734.2087878-4-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|DS0PR12MB6632:EE_
X-MS-Office365-Filtering-Correlation-Id: 5372335d-dd0f-4c89-1ede-08df3e5778aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|7416014|376014|1800799024|22082099003|18002099003|10067099003|13003099007|921020|5023799004|11063799006|261028144727099003|261102123227099003|261022105027099003|261022075727099003|56012099006|261021121427099003|261021123027099003|261026121527099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	30MdMcUfrXu3+1UR1UhXCjZQiIzH4/7kxy9HxvTsQzZmUxk1OoZE9PLLcLxU6abJeDsD6pgv/BFaUIgUmodbZwP+thVkYkBheJMLkH6PgCyOSaxKCO+bcRtDPi2DUc7EIiqbMzNW3R+luvPEUuhsfIRExys8048McGtIm8KOAoQGg/5S02x7aL7bTBMaHxhVl3Puo71Zjnfx6DixqlYnm+MF/8XcJzZLWZy61QTY5wS0o/JjRXJrdfTFluXQdAa0Gl5uuWzj/dlb6A76yilEqmAqG0d4mIv5fAfTU5qzz0GpWfjb0YD1euQtLT+O0Qq65L8o3Jee+dHOXhyP6mbmurMXXeFWqu2/Y6uUBEoX7I35yCNJQep+chvSvSZlPDoJBzkQ9hMKNp5KI1dBfPgg4saZmAF8BDmJc22djDoTafVo4NYCgif2Xg14PUMa5GXwUyctktMFDL+dukVVtgIp0CjKtL2YKhTGIKhFp0BORBc99GCi8xz7JODQdQYIlQlYyQ1dJxQoq6ecoihdAoBSCVadLMftk9512KWQDQ6btHEJDO2VMJ3LoqxQRg4Ct32f4l1vNm1eEsTkKICs8+vPeRRKUUXK21sybcSoGztRwtWI2QdDGci/GYWiPjfwxGBNOmCIRQhPmYv/wa1qbvBP5L9W1FS72h9IX1pHL5b97ia3PUVfejBN1uC+Af1ZkA1g7YLYiVLyEjfL1h21odSKzsluwRa6w2S5ZJzM/S9Z0FFCxEBuaBlTWy8wi7vJKgdT
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(7416014)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(13003099007)(921020)(5023799004)(11063799006)(261028144727099003)(261102123227099003)(261022105027099003)(261022075727099003)(56012099006)(261021121427099003)(261021123027099003)(261026121527099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QFNaQTEn3zaz+7hJRmjmaNP23X5NlVzxxMvldJwQlY7T0x0Z1H87bP5xQviQp4WEu99na3xNT/5cMgz4SeaXc78CeI9g2Z5DbR9x5Mk8ERpdzh9JWjOrjQPpyIOmf+C0W9kPjYr2lA6tW0msHdShcrsfFCq6KdiB1IZolXlTgdWrY6NTgfcKL8c48j0QEkwspEASWBWgOgc8jCmUgfqjIl6HJYRTzrw1WS5KO2u3WIkerLNnTPietOgE/mmUgxQkigIZfwlZMOTY4piwemcvKDOeUOHYc/Bx4bVBRnCQ5cT0JxOQtrOAC+xe3BWUB6eAj0jPGU4ORZIYMMqEmj++VhS5CPY035hLfAZbRMWOOqAIndF0DZkNM23ChWl2fRLJtN4+Jzd2VZZMP1mhr5v9QwdSgHfWI2BUu6p+koggtiqf5QWY9vXWAmzYzs55gRta
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:49:11.6352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5372335d-dd0f-4c89-1ede-08df3e5778aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6632

A new kTLS TX context is installed by static and progress params that
the driver posts for the connection's first skb:
mlx5e_ktls_handle_tx_skb() posts them before it checks the skb's
sequence. That skb may not use the context though: a pass-through skb,
which ends before the offload start marker (SKIP_NO_DATA), e.g. TCP data
that was queued before the socket was offloaded.

A pass-through skb carries no data for the device to encrypt, and is not
tied to the TX queue of the connection's data. For example, when netem
on its TX queue delays it, skb_orphan_partial() releases its
sk_wmem_alloc charge, which lets the socket move to another TX queue
meanwhile. The params are then posted on one SQ and the connection's
data on another, with no ordering between them, and the data can be
encrypted before the TIS is installed, e.g. with the key of the previous
connection that used a TIS from the pool.

Post the params only for an skb that uses the context: an in-order skb
posts them as before, and a resynced one gets a full resync, which posts
the static params regardless of rec_seq, as it may match while the TIS
still holds the params of its previous user. A dropped skb leaves them
pending for the next skb.

A pass-through skb does not use the context at all. Only data that the
device encrypts is sent with skb->decrypted set, so skip kTLS handling
for an skb without it, before its sequence is looked at: a pass-through
skb held long enough can alias the sequence of a live record.

Pointed out by Rishikesh Jethwani for skbs that netem delays, while
discussing kTLS TX TIS reuse for TLS 1.3 rekey on netdev. He also
suggested the skb_is_decrypted() check.

Reproduced on ConnectX-6 Dx with netem, and a 10 Mb/s rate limit, on
half of the TX queues, and connections that send 1 MB of plaintext
before installing kTLS TX, then stream pattern data to a software kTLS
receiver that checks every byte, hopping between CPUs every 1 ms: 2 of
323 connections failed at the first record after the plaintext, and the
device failed another such record, which ran before its params, with a
local protection error. With this patch, none of 400 connections failed.
netem on all TX queues does not reproduce it: it fully orphans the
offloaded data, which validate_xmit_skb() then drops.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Reported-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
Closes: https://lore.kernel.org/netdev/CAKaoeS1hj9XuM7ojLBCjGA=EXc2M-b+eRjC2Sk=8L_8XYeJ18w@mail.gmail.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 40 +++++++++----------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index a4aa58ef1dda..0bd4d961e704 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -542,16 +542,6 @@ static void tx_fill_wi(struct mlx5e_txqsq *sq,
 	};
 }
 
-static bool
-mlx5e_ktls_tx_offload_test_and_clear_pending(struct mlx5e_ktls_offload_context_tx *priv_tx)
-{
-	bool ret = priv_tx->ctx_post_pending;
-
-	priv_tx->ctx_post_pending = false;
-
-	return ret;
-}
-
 static void
 post_static_params(struct mlx5e_txqsq *sq,
 		   struct mlx5e_ktls_offload_context_tx *priv_tx,
@@ -872,6 +862,12 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	if (!datalen)
 		return true;
 
+	/* Only data that the device encrypts uses the TLS context. */
+	if (!skb_is_decrypted(skb)) {
+		stats->tls_skip_no_sync_data++;
+		return true;
+	}
+
 	mlx5e_tx_mpwqe_ensure_complete(sq);
 
 	tls_ctx = tls_get_ctx(skb->sk);
@@ -885,9 +881,9 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
-	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx)))
-		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
-
+	/* WQEs naming the TIS, pending context params included, are
+	 * posted only for an skb that uses it.
+	 */
 	seq = ntohl(tcp_hdr(skb)->seq);
 	ooo = priv_tx->expected_seq != seq;
 	/* Take the loss mark before resyncing, a loss reported meanwhile
@@ -896,31 +892,32 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	resync = test_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags) &&
 		 test_and_clear_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags);
 	if (unlikely(ooo || resync)) {
+		/* A resync installs a pending context fully: rec_seq may match
+		 * while the TIS still holds the params of its previous user.
+		 */
+		bool full = resync || priv_tx->ctx_post_pending;
 		enum mlx5e_ktls_sync_retval ret =
 			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq,
-						 resync);
+						 full);
 
 		if (ooo)
 			stats->tls_ooo++;
 
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
+			priv_tx->ctx_post_pending = false;
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
 			stats->tls_skip_no_sync_data++;
-			if (likely(!skb->decrypted)) {
-				/* Nothing was posted, keep the mark. */
-				if (resync)
-					set_bit(MLX5E_KTLS_TX_RESYNC,
-						&priv_tx->flags);
-				goto out;
-			}
 			WARN_ON_ONCE(1);
 			goto err_lost;
 		case MLX5E_KTLS_SYNC_FAIL:
 			stats->tls_drop_no_sync_data++;
 			goto err_lost;
 		}
+	} else if (unlikely(priv_tx->ctx_post_pending)) {
+		priv_tx->ctx_post_pending = false;
+		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
 	}
 
 	priv_tx->expected_seq = seq + datalen;
@@ -930,7 +927,6 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	stats->tls_encrypted_packets += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
 	stats->tls_encrypted_bytes   += datalen;
 
-out:
 	return true;
 
 err_lost:
-- 
2.44.0

