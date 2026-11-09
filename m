Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794225001;
	b=WU4allySwBayePOaug5gtxVEIDf9g4NDPbrfmXJq+CDiAQdC6cRS2fO2/AZ6JglB7G1T
	 ouf2INh8hAjspFCWOZnRna+BJF78MfZz1Q6j6BoW/kxhhM89aaciRykJO4puF6wYkr20B
	 KTzVl6VPoAw0oPH1ElwGncPlVdos4VXOoOiMS9+fm27fIB62VT4peSmP9J/WUkEK80G4z
	 weoc8kkgiX7fOagU+gKeCRwnyW/arPDqs6YrJejdukpvwwftJqN++RKZn0inEl1D/isHj
	 fRJJ6BuU1rXbiHULkrgt5XmSohZtPmNts0DP5GY7TOXZnPOkgpkUmsYSdItkJMDNczg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225001;
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
	bh=JAVQqQlY+v1SV6xLwo1OWJcLzHoe1ltbtM2Pf3ErewE=;
	b=ApfW+IJ3S5btTegZ5QBDhUSkBKBdMSys3FAaUKUylZp7S1kObQR7rnnKlxD9Etr2TAHf
	 txY3HgFsnMTVJRsXZbKFWChB2e7We3pEtGEBNDbzwHTNzM7kYBWrT7abrkoHJWLsA0HWx
	 ScjkTLcpJmdUR+Lg38S5w8vEjhWWH4LsH3JzPEVQen4vAttJ81xnvDXBmRee2woVJx2jB
	 F2dx6L9awENLc1jDyCumpotMnI8ZfZTQYD0eZTW14iOJPNyBwMUA3VUvmvoCmbDpWCTNx
	 yt9LKhN43cbQZj7E73z9b64elotHUs3ALxushmXptoEdyOx+RXMAUc4yacXPJPvKZ3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aELm8ti8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.65
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8591E606A31C;
	Mon,  9 Nov 2026 11:50:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8591E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aELm8ti8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xQYsuOPcnL9V7ZRac7guzQgxjQLYnBa/ZxGr4PcwQzgc3il+busGLpm3Er/aZT7h85v2jyKmiaNHBDx4Vx7nG6iqwh8Rtvk7WCvlrjZGCLsxW9YbyJMBJycRn+nGMDx9vMWL7NdzkrWiyvAtu2d4w4ulKcoDqdoh1ZZ2p8oMm0T4Hug/1petzBK1F57O7YaDWq/zTbxjeXmP4eOTKSLkNaOWr0z6940eh9x8qjD0Bo0dTq3HJDLUtdtoEADO6GRTeSLfU13/Sk89WzC53KOICz754+cmsHw6LB7F3tF0VGePAYgFqC1ygrxDxITZbEtzPVHbBTG5BsrPi22JOiR5ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAVQqQlY+v1SV6xLwo1OWJcLzHoe1ltbtM2Pf3ErewE=;
 b=vaHTf6G2fTQELjr1fcCKejWBm/YrOWfLzmHrIQs568vZZYHKTMpmCNpDhelZuC0Vpn62V3eHuQ9r3ZqhIi4wxQHMNnL2OOJAU9HimHjirAWRVdD0D5MJFgpnA/8D6q4qf7hOXpJF8upFiozfGM1HDJ9qDK7t2+EOI85L2irwRhWKOFn8b9uSuQyeGyx3fzqYkrLmRSohil0HAE2C0fhiSM+uX8wdu0vnn+aEht0ZsMYYRq0Ddt7clo8BVV857GLdwMHQA69wYtc/HLBcgz1sr7Q7v8U3MbzgQT3MpwrbR9XwByflMbjY9jeeo5R8v4j/rm+zqtsFGMe4u7RxWdA6Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAVQqQlY+v1SV6xLwo1OWJcLzHoe1ltbtM2Pf3ErewE=;
 b=aELm8ti8ZycTIaLx0zuk1YTvDMzOczBgt7BxeAeC3AhAkuSuuov8BrTlk/kzSCUWE12w2CQMWac0gUIcC8BVm9VXILIdLz7pa59GZlbeceWPfKk7pACsc7yc7tWbTMCfhssh5thCshMVpNB7XjMBAbAvgaKHtSFdUzFZjQ6E/kYGEbZCL2DMoQngBpqt2U0bHK8LbOADwuzNZe5e+p+uP29kUoLd2IZL3yyQ/MMVK2PMvwWJxs0D25CFuBS+YroF9zliDiKI6DFQvhQgLqz3r7TH5wzYweB4vUnHCkYcLNS078H0LsaPM9DAo9PBVT89+nVp9VzZq0o6ePsnxQwSKw==
Received: from CH0P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::23)
 by SA3PR12MB7860.namprd12.prod.outlook.com (2603:10b6:806:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Mon, 9 Nov
 2026 11:49:54 +0000
Received: from CH1PEPF0000A348.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::4c) by CH0P220CA0009.outlook.office365.com
 (2603:10b6:610:ef::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 11:49:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000A348.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:49:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:40 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:49:29 -0800
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
Subject: [RFC net-next 7/7] net/mlx5e: kTLS, Keep a TX connection on one SQ at a time
Date: Mon, 9 Nov 2026 13:47:34 +0200
Message-ID: <20261109114734.2087878-8-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A348:EE_|SA3PR12MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: 25daaeb0-3e83-40d6-1884-08df3e57919f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|7416014|376014|1800799024|18002099003|22082099003|6133799003|3023799007|10067099003|921020|5023799004|261026140227099003|11063799006|261022075727099003|261028144727099003|261102123227099003|261026121527099003|261021121427099003|261009223027099003|56012099006|261022105027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	FAufgJvJIkTRhab3ahcg1gArRbMQ4Try5pGNPvVXNxvbMWoEDyjXmKAslyFIDDyHXLNgNWQX7IboE5l9HUc/AuZkLF9wN6VvHd6qidpjBVXiDSI7JuMhBe66KgClgy96SWQde0h45I5en+58vgTC3W1oeCSxapDcpVQ8Gs7r9O7PcwSKxUzcnZQmtkwYCHMSUWdXdIRadnln9GB4We7v0S3r3o0DFh+kAEpgFQWbCfMh1JGQZbECjlYASjeApylJ3C2+NSWUEJTtxUEUeFrcBi+5i5CnFrv8Uh8pK9Wer18EtN302zpLiokVndUN8fF5F5u6bSspkObkzHt5FpprCztoaXA3PnGBtiSmqLDexk7J/rcpAmKAQVwV2UgZRP9eqw96mD6BQyIWlIEV9wurnaWWMmv5HqgDsAZ5azp8pPAwJeea75YAtLfrZJ0vG/SvcwYiSnEluR5NyKjHtluR7hCEvJ/Q3XFEW1lKgW5aRfJCuCryme0oNjsm1yo/CMpvvqUCP4odM11JPJ7COnn4O5EGF4tO+kOMUjZum+Q8CCN8MoOAFUYG/i8LlEpeQVX/M6UFZb4Lb2k39VPKjxNTjSo21odUrzvwo+E1qq9Jwo6d7RfyR38G7sqNTw8lH99q3mM9BiQwlvZlQ+uaf5/p7GjIEXp+uqep/Cywws1m7HD2HefzF/wm0v2skfRaQC7BTZaHA7v44r4BW6EvS8mHld/0M5I6gfBHqmlnpFPcoA6/pcUBo5DvN//Yff+ustBE
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(7416014)(376014)(1800799024)(18002099003)(22082099003)(6133799003)(3023799007)(10067099003)(921020)(5023799004)(261026140227099003)(11063799006)(261022075727099003)(261028144727099003)(261102123227099003)(261026121527099003)(261021121427099003)(261009223027099003)(56012099006)(261022105027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	iBMNQarEzLUCiaRd3S3HIg4gl5bXTpu2bb4WwIWt09gJXF6h/orUZczLlDcSdgRprraGHXxJHTZLPtewtE5u8EeJbO+gLwOgarXfLOuOnm6CZ6lFY3xJoDSWXQkiz1MwNJsTxjmh694FVj/AR7q4luu9va4XwuRZelrKWVFGwVcKJdxU7ui/du5KrOp9nohwFZhDAYi0Y4OW/jIEk1Mxq3An+/cG/PydomTNrnXSf3/aQtsz6aFHStq9ousERDDoKkfZWOhNdrNYWScYjCd4kK7SUZBOt43H2gpV41VhW6TdA7GeEt+qtxj35Bsvf60XEpyKft/PXOa9Pzu6q/gbUOEO1d1kIOw/CYxKmduL71rW6lkD+S2kmEWWY5hBLDhtVHHHJJET9a8y2zRanfIZuK78W+QQWu/bzwO7Sf3IR/5OZ9HuI208bhMS+Oiq57ek
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:49:53.5022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25daaeb0-3e83-40d6-1884-08df3e57919f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A348.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7860

A kTLS TX connection must not post WQEs to another SQ while WQEs that it
posted to its SQ may be pending: both SQs would update its TIS state
with no ordering, corrupting the records on the wire. The stack and the
driver keep the TX queue of such a connection stable
(TLSDEV_F_STICKY_TXQ), but some paths bypass or defeat that: tc skbedit
queue_mapping skips queue selection, sk_tx_queue_mapping is shared with
the other devices on the route, and ooo_okay can be stale after an
upper device's qdisc reordered the socket's skbs.

Enforce it where the WQEs are posted. Each connection records the TX
queue that it posts on. An skb on another TX queue moves the connection
only if no other skb of its socket is in flight. An skb is freed only
once the WQEs posted for it completed, or were destroyed with their SQ,
so the connection then has no WQE pending on any SQ. An SQ that
replaces another on the same TX queue was drained or destroyed first.
Otherwise the skb is dropped before anything is posted, and counted in
a new tx[i]_tls_drop_txq_move counter. TCP retransmits it.

The move is made under the old TX queue's lock, taken with a trylock,
under which the connection's skbs are posted there, so it cannot race
with them. A connection that stays on its TX queue only compares the
queue index.

A move that the TX queue selection allows, when the socket has nothing
else in flight, is made at selection. Otherwise the socket's next skbs,
queued behind the first one on the new TX queue, would hold
sk_wmem_alloc when it reaches the driver, and it would be dropped,
although nothing of the connection is pending on the old SQ.

Tested on ConnectX-6 Dx, with 128 channels and 32 kTLS TX offloaded
connections streaming pattern data for 60 seconds to a software kTLS
receiver that checks every byte, while an egress tc skbedit
queue_mapping filter flips them between two TX queues every 20 ms.
Without this patch, 23 of 55 connections failed decryption. With it,
none did, and 7515 skbs were dropped over 2035 flips. Without the flips,
no skb was dropped.

Suggested-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/counters.rst       |  7 ++
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 16 +++--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 71 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  6 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  4 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 +
 6 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
index cc498895f92e..0a08ffddc834 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
@@ -711,6 +711,13 @@ the software port.
        data.
      - Acceleration
 
+   * - `tx[i]_tls_drop_txq_move`
+     - Number of TLS packets dropped on ring i because their connection still
+       had packets in flight on another ring. Posting them on ring i would
+       break the ordering of the connection's TLS state updates in the
+       device. TCP retransmits the dropped data.
+     - Error
+
    * - `ptp_cq[i]_abort`
      - Number of times a CQE has to be skipped in precision time protocol due to
        a skew between the port timestamp and CQE timestamp being greater than
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index dfaee2c3624e..0bac217bbfec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -9,6 +9,7 @@
 #include "en.h"
 #include "en/ptp.h"
 #include "en/htb.h"
+#include "en_accel/ktls_txrx.h"
 
 struct mlx5e_selq_params {
 	unsigned int num_regular_queues;
@@ -288,9 +289,6 @@ static int mlx5e_select_sticky_queue(struct net_device *dev,
 {
 	int txq_ix;
 
-	if (mlx5e_sk_txq_may_move(skb))
-		return -1;
-
 	txq_ix = sk_tx_queue_get(skb->sk);
 	if (txq_ix < 0 || txq_ix >= dev->real_num_tx_queues)
 		return -1;
@@ -309,6 +307,7 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_selq_params *selq;
 	struct sock *sk = skb->sk;
+	bool may_move;
 	int txq_ix;
 
 	selq = rcu_dereference_bh(priv->selq.active);
@@ -323,14 +322,19 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 	if (likely(!mlx5e_sk_sticky_txq(sk)))
 		return __mlx5e_select_queue(dev, skb, selq);
 
-	txq_ix = mlx5e_select_sticky_queue(dev, skb, selq);
-	if (txq_ix >= 0)
-		return txq_ix;
+	may_move = mlx5e_sk_txq_may_move(skb);
+	if (!may_move) {
+		txq_ix = mlx5e_select_sticky_queue(dev, skb, selq);
+		if (txq_ix >= 0)
+			return txq_ix;
+	}
 
 	txq_ix = __mlx5e_select_queue(dev, skb, selq);
 	/* Cache the final queue, as netdev_pick_tx() does with its own pick. */
 	if (rcu_access_pointer(sk->sk_dst_cache))
 		sk_tx_queue_set(sk, txq_ix);
+	if (may_move)
+		mlx5e_ktls_tx_select_txq(dev, skb, txq_ix);
 
 	return txq_ix;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0bd4d961e704..9603ef4b3eb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -92,12 +92,15 @@ enum {
 	MLX5E_KTLS_TX_RESYNC, /* WQEs lost, see mlx5e_ktls_tx_handle_lost() */
 };
 
+#define MLX5E_KTLS_TX_NO_TXQ (-1)
+
 struct mlx5e_ktls_offload_context_tx {
 	/* fast path */
 	u32 expected_seq;
 	u32 tisn;
 	bool ctx_post_pending;
 	unsigned long flags; /* MLX5E_KTLS_TX_* */
+	int txq_ix; /* that it posts on, see mlx5e_ktls_tx_own_txq() */
 	/* control / resync */
 	struct list_head list_node; /* member of the pool */
 	union mlx5e_crypto_info crypto_info;
@@ -505,6 +508,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 
 	priv_tx->ctx_post_pending = true;
 	priv_tx->flags = 0;
+	priv_tx->txq_ix = MLX5E_KTLS_TX_NO_TXQ;
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_ctx);
 
 	return 0;
@@ -846,6 +850,59 @@ void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 	rcu_read_unlock();
 }
 
+/* A connection must not post WQEs to another SQ while WQEs that it posted to
+ * its SQ may be pending, see TLSDEV_F_STICKY_TXQ. Let it move to the TX queue
+ * of @sq only if no other skb of its socket is in flight: an skb is freed only
+ * once the WQEs posted for it are done. The move is made under the lock of the
+ * old TX queue, under which the connection posts there.
+ */
+static bool mlx5e_ktls_tx_own_txq(struct net_device *netdev,
+				  struct mlx5e_ktls_offload_context_tx *priv_tx,
+				  struct mlx5e_txqsq *sq, struct sk_buff *skb)
+{
+	int old = READ_ONCE(priv_tx->txq_ix);
+	struct netdev_queue *old_txq;
+	bool own;
+
+	if (old == MLX5E_KTLS_TX_NO_TXQ)
+		return cmpxchg(&priv_tx->txq_ix, old, sq->txq_ix) == old;
+
+	old_txq = netdev_get_tx_queue(netdev, old);
+	if (!__netif_tx_trylock(old_txq))
+		return false;
+
+	own = READ_ONCE(priv_tx->txq_ix) == old &&
+	      sk_wmem_alloc_get(skb->sk) <= skb->truesize;
+	if (own)
+		WRITE_ONCE(priv_tx->txq_ix, sq->txq_ix);
+	__netif_tx_unlock(old_txq);
+
+	return own;
+}
+
+/* The TX queue selection lets the socket of @skb move to @txq_ix only while
+ * no other skb of the socket is in flight, see mlx5e_select_queue(), so the
+ * connection has no WQE pending on any SQ: hand it the new TX queue now. Once
+ * @skb is queued there, the socket's next skbs queue up behind it and hold
+ * sk_wmem_alloc, and mlx5e_ktls_tx_own_txq() would refuse the move.
+ */
+void mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff *skb,
+			      u16 txq_ix)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct tls_context *tls_ctx;
+
+	if (!tls_is_skb_tx_device_offloaded(skb))
+		return;
+
+	tls_ctx = tls_get_ctx(skb->sk);
+	if (rcu_dereference_bh(tls_ctx->netdev) != netdev)
+		return;
+
+	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+	WRITE_ONCE(priv_tx->txq_ix, txq_ix);
+}
+
 bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 			      struct sk_buff *skb,
 			      struct mlx5e_accel_tx_tls_state *state)
@@ -881,6 +938,10 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
+	if (unlikely(READ_ONCE(priv_tx->txq_ix) != sq->txq_ix) &&
+	    !mlx5e_ktls_tx_own_txq(netdev, priv_tx, sq, skb))
+		goto err_move;
+
 	/* WQEs naming the TIS, pending context params included, are
 	 * posted only for an skb that uses it.
 	 */
@@ -929,6 +990,16 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 
 	return true;
 
+err_move:
+	/* Nothing was posted for the skb, TCP retransmits it. */
+	stats->tls_drop_txq_move++;
+	netdev_warn_once(netdev,
+			 "kTLS TX connection moved to TX queue %d with packets in flight, dropping\n",
+			 sq->txq_ix);
+	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq, NULL);
+	return false;
+
 err_lost:
 	/* Resync params may have moved the TIS state to the dropped skb. */
 	set_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index a6b15dcd32b8..acfd1b4025aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -30,6 +30,8 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
 void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb);
+void mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff *skb,
+			      u16 txq_ix);
 
 /* The WQEs posted for the skb may have not been executed. */
 static inline void
@@ -84,6 +86,10 @@ mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb) {}
 static inline void
 mlx5e_ktls_tx_try_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb) {}
 
+static inline void
+mlx5e_ktls_tx_select_txq(struct net_device *netdev, struct sk_buff *skb,
+			 u16 txq_ix) {}
+
 static inline bool
 mlx5e_ktls_rx_handle_resync_list(struct mlx5e_icosq *sq, int budget)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index cd94bb44f6ab..d23790403714 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -132,6 +132,7 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_skip_no_sync_data) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_no_sync_data) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_bypass_req) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_txq_move) },
 #endif
 
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
@@ -441,6 +442,7 @@ static void mlx5e_stats_grp_sw_update_stats_sq(struct mlx5e_sw_stats *s,
 	s->tx_tls_skip_no_sync_data += sq_stats->tls_skip_no_sync_data;
 	s->tx_tls_drop_no_sync_data += sq_stats->tls_drop_no_sync_data;
 	s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
+	s->tx_tls_drop_txq_move += sq_stats->tls_drop_txq_move;
 #endif
 	s->tx_cqes                  += sq_stats->cqes;
 }
@@ -2303,6 +2305,7 @@ static const struct counter_desc sq_stats_desc[] = {
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_skip_no_sync_data) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_txq_move) },
 #endif
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
@@ -2456,6 +2459,7 @@ static const struct counter_desc qos_sq_stats_desc[] = {
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_skip_no_sync_data) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
+	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, tls_drop_txq_move) },
 #endif
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, csum_none) },
 	{ MLX5E_DECLARE_QOS_TX_STAT(struct mlx5e_sq_stats, stopped) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 09f155acb461..8f5fb0478f00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -237,6 +237,7 @@ struct mlx5e_sw_stats {
 	u64 tx_tls_skip_no_sync_data;
 	u64 tx_tls_drop_no_sync_data;
 	u64 tx_tls_drop_bypass_req;
+	u64 tx_tls_drop_txq_move;
 
 	u64 rx_tls_decrypted_packets;
 	u64 rx_tls_decrypted_bytes;
@@ -434,6 +435,7 @@ struct mlx5e_sq_stats {
 	u64 tls_skip_no_sync_data;
 	u64 tls_drop_no_sync_data;
 	u64 tls_drop_bypass_req;
+	u64 tls_drop_txq_move;
 #endif
 	/* less likely accessed in data path */
 	u64 csum_none;
-- 
2.44.0

