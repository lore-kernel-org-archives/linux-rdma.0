Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224948;
	b=jUDY3CrDQp+TWva5Hyla0hS+jbl27dV6M1AwHQRyhDzJw2hF5H++sEJNcItTQSx5UfoU
	 nEX2ND3TxfIrstd/3h+bmG5O9pK+xZQrP76N4OWHUWqTRvgNWuRMv44xP9E27GUjsL0oj
	 IP6z03m9O6XUYECaianjU0BgZvC9FzcZ53gNXiRvuX4fFUa5fIrCsNuzVj9J62/kh6XOd
	 2wPgGsB3LkNJhX01DXfuuyLgxNTu1tAkzkRjahm+0d1AnX5Y/Gzqlcap4CXErVP1R7hHe
	 zudV+llGBr/FXCGdWT6KiSAKfWHXA/c0xtRIaibxttW1Cakr78DfIm92LTJDSgub/SQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224948;
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
	bh=onyTmcpfr6sAw21RjwFPyT8mxMikZoN0ykJj759s8iY=;
	b=dy/TsO2mwX9zgsfKo2PnLG4B7/A88l6kq+iKKsLjV5D+Q5CoCjR9azCkpTcPYql6uuFX
	 aLmwTrcZ+eyf/Ue05Fjxr4cT80lKaZOtKAud0di3cBw9s8wORK53wdHdMQ+3H1CbKHuZd
	 jBsv9P9lDmo/Ht2sRZtYM2dX61/YRZ39BHOdbHx7qISH7+1foJM183Jn5NaNiyRLFRyg7
	 O3HY4PlGPbbgaIhspw9P545hxwPE06Sr9v6m92UUTD9wuuFgs3LdD7aZFZDKpjDQwolgy
	 zIZPwDT9juFi78ZP5XmCYMDbAse9dJppRMTTW8aJjj15pjAJR77IEPvg1hdcNOTB+XQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=S+CgQHNC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.49
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011049.outbound.protection.outlook.com [40.93.194.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AC2606A323;
	Mon,  9 Nov 2026 11:49:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97AC2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=S+CgQHNC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F897vUxdpZG0srPJx32aOuX+AtmujYJG+m/KndxKcvmG+gH4FYHXR/XCBO2lTTKOkJsbMZBOKZtPDA5IUVb1xb74lp5wMwSmWnx/DalWRWXcZCnEHcC7pFJFJx8mpRoumG9w9+sId7N0EInXJySGqH+mbzQO+0D2pF8q7w3YcpzaJGX7PI6c4xsikfSU8Lp+rWbKo+msgga261QtW5QwUG9V+u+NCc6xxhRLIfBNIU6+tEEMSSICSP9ArEVMjOtWwi9nH8wY3At2Q2YMzDzVe5Bh0f5lSRGOCD1GCoIsqfMbHEGarYnnnIOfA/9c2g/Nzw8bo7/umhdqd4P+NtrnkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onyTmcpfr6sAw21RjwFPyT8mxMikZoN0ykJj759s8iY=;
 b=RoEHbyFzj+YAxB6Fq11rERVedLDhnJvru5anfpNyB0MKUD+jL+q7wmM5hcx1ClieJosH799DMUiQVJvdtLiqQnBqvteS983lj0/+TTpLj+zuLcoODi5NCRA5J5+ZR6/biQiKQaW1P136VztGDheXeb0fjgeUVtHHlMsTcMkso0jhrnxe4A2xet/mCLsTDAK0x01aWtp8vMeTGBTc45htpcI5560TCXdedwkXnMhchS0n7jkSwzU2NP5EaQgGEC0Q7gqHPUEdYs1oLmctQ6uh9q+sIAI73uvb5YT8TopcWzQok7OmdyoXqzX2tNoHTx3UKxC3ZpyAmovIKAulZQoBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onyTmcpfr6sAw21RjwFPyT8mxMikZoN0ykJj759s8iY=;
 b=S+CgQHNCr+P8wr4pOzc1Vdcaem8y3IGmkMOgvECvQ+Qn7xmTvC/k9lfLMH+319fd1ftqiOneSekbO7tijs86WuMSQCcuDlJfh7f2VEsubbth7R1wF3k5Sple1H6CeofKmktMghsFcYM+/bCmNsAFzneFrVDPRjq2lekwtDUvH6EwrRu9N0i/nNqnUcM3n5xmVA2nIrS5W45yUXAypJiRIBVlB+SNNquM/qEyCDCHDGTB4nMdLYc+2GL++6BzOAofbknBQMeBUacuFVyeABvSasuDI51tqTtMCE842RMvxHE6cmIWMrrMU2HPdJnecHKXDXIPS5QJXy/4wuVSNOcHGg==
Received: from BN9PR03CA0841.namprd03.prod.outlook.com (2603:10b6:408:13d::6)
 by SA3PR12MB078285.namprd12.prod.outlook.com (2603:10b6:806:58d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 11:49:02 +0000
Received: from BN3PEPF00022BCF.namprd03.prod.outlook.com
 (2603:10b6:408:13d::4) by BN9PR03CA0841.outlook.office365.com
 (2603:10b6:408:13d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 11:49:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BCF.mail.protection.outlook.com (10.167.248.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:49:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:48:35 -0800
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
Subject: [RFC net-next 2/7] net/mlx5e: kTLS, Resync TX fully after its WQEs were lost
Date: Mon, 9 Nov 2026 13:47:29 +0200
Message-ID: <20261109114734.2087878-3-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCF:EE_|SA3PR12MB078285:EE_
X-MS-Office365-Filtering-Correlation-Id: 466c2000-4494-4803-c494-08df3e577321
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|7416014|1800799024|22082099003|18002099003|6133799003|10067099003|921020|56012099006|11063799006|5023799004|261028144727099003|261026121527099003|261102123227099003|261022115727099003|261026130827099003|261022113327099003|261022105027099003|261022075727099003|261021135927099003|261021130227099003|261021123027099003|261021121427099003|261021133027099003|261026140227099003|261026135527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	KKonVmexwiuez1d7XEh6+HB1xXesWJv20tAya82/kJD12rZwi3z8huR4zVzlPMxjfrNmwGT5usFjGCRqk2lHk0xhhAW1YUdaJuLoiSQHLjn7rawlp84Jba0HI8Ao7/8rKD/UHvjkTUDfMgUqKf9o3ZZytK340hafuzuRKI/cOYbEhhU0y/CEhczat8CdZ18UD+5nEJsHgDp9qdbw27USzxVM6Wlb8I+358YjCfrcA8U+QDYRGGEvynBMOE/PQLqZJ8dny6KVB3ePKJM79teSGWtUipSLAkvOQTVrPhhp1SjaXhwUQmLQp1zIKtkFxxSm7tZci2B/dorMTY71AQAApwn+6UAYZC6ZCVoSSq6GJ2n64ANWaFnnQpBKTc46CO6IBJjEvLHSIhMpHm8MQQBMV6F9T88pB8WyqBezAI0QPlDhSFNvF7DjCVzpCJ60d9LvDYoBhseYEPPm0cy6xOKX96P94rC5bN3/ySQ2gNGjJ4T2XMTTWLt3IHAwMqYJIKE0hrZJQg7d/nYX1V/ugAcLkqMtQAB9ylIO5U6QipE4ddWYdiDhbneYUSdQpNgeZI7cQ5ps1Ckm+gRAti975MU7zdzrD3Q6KIf3LWL44uZNJiEE/QjlIvNdO674Ndc+5luSVnd07wLVdQKdzpYO7TrebQkBXN3kqT48uWLWqjNvbPB8n89YWWITU3zhmVbXiWp5KIimU+fG2QESs7cZA3qBBz0uKnWyZUvhPJhACXuXTnxpd1nSBiE8SJCo8kfpL4C9
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(7416014)(1800799024)(22082099003)(18002099003)(6133799003)(10067099003)(921020)(56012099006)(11063799006)(5023799004)(261028144727099003)(261026121527099003)(261102123227099003)(261022115727099003)(261026130827099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021135927099003)(261021130227099003)(261021123027099003)(261021121427099003)(261021133027099003)(261026140227099003)(261026135527099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3INK32UcgKnzXufYhgyNqIuhKZ4dITNPr9mhquDrDfsdITBzJUGk55vllLNEX/TELaznlgUZn61+UmNBDhe3CyyqDqK/sMd0M+vsavHGKDatGJaLsM6JqrCNEilT2/l28WszgCMwVLbN6Z/BpRzLV8yoBc6Th+g6tGv02A2Ja/thm3Koh3fQSRu3/vqsdFGUpfO9BBGtj7P9jjteGJGQyKTCEv5XkDMrsYS9FuPMKbd9K72iNm9+iAT8YmDKrBJ+nf03AgrtxprylRy6/ypwp0ufi6CnZw2Z7fzSv6S4LrKMC4WkXSJwI/ftgonQ9W7OGo+1+adm97ytvv3O+9ftWiELexnUe5Em0ys/s+qKH06o14bNZpbTGs5yh1JdNCp88iZOL2L8ApvuQqfJ0Hq7nNuEdokbr6Ud9x2ODkuoEyyq0wSoOGDV4mlL4QxfzKi+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:49:02.3193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 466c2000-4494-4803-c494-08df3e577321
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB078285

The driver tracks the TIS state of a kTLS TX connection in software:
expected_seq is the TCP sequence that the TIS expects next, and
crypto_info.rec_seq is the record sequence of the last posted static
params. It assumes that the WQEs it posts for an skb execute, which does
not always hold:
- The skb is dropped after its kTLS WQEs were posted, or after
  expected_seq was advanced past its data: a failed resync, or a DMA
  mapping error of its SEND.
- An SQ error flushes the pending WQEs.
- Closing an SQ (channels reopen, TX timeout recovery, HTB leaf delete)
  destroys its pending WQEs.

The TIS state is then off from the software state, and the next skb is
not resynced:
- An in-order skb is encrypted with a stale record state, corrupting the
  records on the wire.
- If static params were lost, the TIS keeps the previous record
  sequence, and as rec_seq already matches, later resyncs skip posting
  them. When the first static params of a TIS taken from the pool are
  lost, the TIS still names the DEK and record sequence of the previous
  connection that used it, and the new connection's data is encrypted
  with them.

Mark the connection where the driver sees the loss: when it drops the
skb, when the skb completes with an error CQE, and when the skb is freed
with its SQ. The next skb of a marked connection resyncs it fully: post
the static params even if rec_seq matches, then the progress params, and
dump the record prefix. It takes the mark with a test-and-clear before
posting the resync, so a loss reported meanwhile marks the connection
again.

The skb holds the socket, so the connection's context is alive when it
is marked. A context that tls_device_down() releases is not marked: it
clears the netdev and waits for RCU readers first.

Pointed out by Rishikesh Jethwani for lost initial static params, while
discussing kTLS TX TIS reuse for TLS 1.3 rekey on netdev.

Reproduced on ConnectX-6 Dx with a test-only patch that fails the SEND
DMA mapping of a kTLS offloaded socket's skbs at a fixed interval, after
their kTLS WQEs were posted, while 32 connections stream pattern data
for 60 seconds to a software kTLS receiver that checks every byte, over
a single channel, so that no connection can move TX queue. On top of the
previous patch only, every drop broke its connection: 2186 of 2217
connections failed decryption. With this patch, 1838 drops broke none.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Reported-by: Rishikesh Jethwani <rjethwani@everpuredata.com>
Closes: https://lore.kernel.org/netdev/CAKaoeS1hj9XuM7ojLBCjGA=EXc2M-b+eRjC2Sk=8L_8XYeJ18w@mail.gmail.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 67 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 15 +++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 13 +++-
 3 files changed, 83 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 31f61f2ba824..a4aa58ef1dda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -87,11 +87,17 @@ static int mlx5e_ktls_destroy_tis_cb(struct mlx5_core_dev *mdev, u32 tisn,
 				out, outlen, callback, context);
 }
 
+/* Bits of mlx5e_ktls_offload_context_tx flags */
+enum {
+	MLX5E_KTLS_TX_RESYNC, /* WQEs lost, see mlx5e_ktls_tx_handle_lost() */
+};
+
 struct mlx5e_ktls_offload_context_tx {
 	/* fast path */
 	u32 expected_seq;
 	u32 tisn;
 	bool ctx_post_pending;
+	unsigned long flags; /* MLX5E_KTLS_TX_* */
 	/* control / resync */
 	struct list_head list_node; /* member of the pool */
 	union mlx5e_crypto_info crypto_info;
@@ -498,6 +504,7 @@ int mlx5e_ktls_add_tx(struct net_device *netdev, struct sock *sk,
 	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, priv_tx);
 
 	priv_tx->ctx_post_pending = true;
+	priv_tx->flags = 0;
 	atomic64_inc(&priv_tx->sw_stats->tx_tls_ctx);
 
 	return 0;
@@ -676,7 +683,7 @@ tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
 static void
 tx_post_resync_params(struct mlx5e_txqsq *sq,
 		      struct mlx5e_ktls_offload_context_tx *priv_tx,
-		      u64 rcd_sn)
+		      u64 rcd_sn, bool full)
 {
 	__be64 rn_be = cpu_to_be64(rcd_sn);
 	bool skip_static_post;
@@ -704,7 +711,8 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 		return;
 	}
 
-	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
+	/* rec_seq is the record sequence of the last posted static params. */
+	skip_static_post = !full && !memcmp(rec_seq, &rn_be, rec_seq_sz);
 	if (!skip_static_post)
 		memcpy(rec_seq, &rn_be, rec_seq_sz);
 
@@ -772,7 +780,7 @@ static enum mlx5e_ktls_sync_retval
 mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 struct mlx5e_txqsq *sq,
 			 int datalen,
-			 u32 seq)
+			 u32 seq, bool full)
 {
 	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info = {};
@@ -786,7 +794,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		 */
 		return ret;
 
-	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
+	tx_post_resync_params(sq, priv_tx, info.rcd_sn, full);
 
 	for (i = 0; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
@@ -826,6 +834,28 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	return MLX5E_KTLS_SYNC_FAIL;
 }
 
+/* The WQEs posted for an skb were not executed: the skb was dropped, or its
+ * WQEs were flushed by an SQ error or destroyed with their SQ. The TIS state
+ * of its connection may be off from ours, resync it fully on the next skb.
+ */
+void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct tls_context *tls_ctx;
+
+	/* The skb holds the socket, and so its TLS context. tls_device_down()
+	 * clears the netdev, and waits for RCU readers before it releases the
+	 * driver context.
+	 */
+	tls_ctx = tls_get_ctx(skb->sk);
+	rcu_read_lock();
+	if (rcu_dereference(tls_ctx->netdev) == sq->netdev) {
+		priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+		set_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags);
+	}
+	rcu_read_unlock();
+}
+
 bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 			      struct sk_buff *skb,
 			      struct mlx5e_accel_tx_tls_state *state)
@@ -834,6 +864,7 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	struct mlx5e_sq_stats *stats = sq->stats;
 	struct net_device *tls_netdev;
 	struct tls_context *tls_ctx;
+	bool ooo, resync;
 	int datalen;
 	u32 seq;
 
@@ -858,24 +889,37 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
 
 	seq = ntohl(tcp_hdr(skb)->seq);
-	if (unlikely(priv_tx->expected_seq != seq)) {
+	ooo = priv_tx->expected_seq != seq;
+	/* Take the loss mark before resyncing, a loss reported meanwhile
+	 * marks the connection again.
+	 */
+	resync = test_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags) &&
+		 test_and_clear_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags);
+	if (unlikely(ooo || resync)) {
 		enum mlx5e_ktls_sync_retval ret =
-			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
+			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq,
+						 resync);
 
-		stats->tls_ooo++;
+		if (ooo)
+			stats->tls_ooo++;
 
 		switch (ret) {
 		case MLX5E_KTLS_SYNC_DONE:
 			break;
 		case MLX5E_KTLS_SYNC_SKIP_NO_DATA:
 			stats->tls_skip_no_sync_data++;
-			if (likely(!skb->decrypted))
+			if (likely(!skb->decrypted)) {
+				/* Nothing was posted, keep the mark. */
+				if (resync)
+					set_bit(MLX5E_KTLS_TX_RESYNC,
+						&priv_tx->flags);
 				goto out;
+			}
 			WARN_ON_ONCE(1);
-			goto err_out;
+			goto err_lost;
 		case MLX5E_KTLS_SYNC_FAIL:
 			stats->tls_drop_no_sync_data++;
-			goto err_out;
+			goto err_lost;
 		}
 	}
 
@@ -889,6 +933,9 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 out:
 	return true;
 
+err_lost:
+	/* Resync params may have moved the TIS state to the dropped skb. */
+	set_bit(MLX5E_KTLS_TX_RESYNC, &priv_tx->flags);
 err_out:
 	/* Parameter and DUMP WQEs may have been posted for the skb. */
 	mlx5e_tx_flush(sq, skb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 93bd383a23d8..a6b15dcd32b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -29,6 +29,15 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
+void mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb);
+
+/* The WQEs posted for the skb may have not been executed. */
+static inline void
+mlx5e_ktls_tx_try_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+{
+	if (tls_is_skb_tx_device_offloaded(skb))
+		mlx5e_ktls_tx_handle_lost(sq, skb);
+}
 
 void
 mlx5e_ktls_rx_resync_async_request_cancel(struct mlx5e_icosq_wqe_info *wi);
@@ -69,6 +78,12 @@ mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 	return false;
 }
 
+static inline void
+mlx5e_ktls_tx_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb) {}
+
+static inline void
+mlx5e_ktls_tx_try_handle_lost(struct mlx5e_txqsq *sq, struct sk_buff *skb) {}
+
 static inline bool
 mlx5e_ktls_rx_handle_resync_list(struct mlx5e_icosq *sq, int budget)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index eb8a7a89b120..bee6f0bf1eff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -386,6 +386,7 @@ static void mlx5e_tx_drop(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 	if (IS_ENABLED(CONFIG_MLX5_EN_TLS) &&
 	    tls_is_skb_tx_device_offloaded(skb)) {
 		/* kTLS WQEs may have been posted for the skb. */
+		mlx5e_ktls_tx_handle_lost(sq, skb);
 		mlx5e_tx_flush(sq, skb);
 		return;
 	}
@@ -815,13 +816,15 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 	i = 0;
 	do {
 		struct mlx5e_tx_wqe_info *wi;
+		bool last_wqe, err_cqe;
 		u16 wqe_counter;
-		bool last_wqe;
 		u16 ci;
 
 		mlx5_cqwq_pop(&cq->wq);
 
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
+		/* WQEs covered by an error CQE may not have been executed. */
+		err_cqe = get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR;
 
 		do {
 			last_wqe = (sqcc == wqe_counter);
@@ -832,6 +835,10 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			sqcc += wi->num_wqebbs;
 
 			if (likely(wi->skb)) {
+				if (unlikely(err_cqe))
+					mlx5e_ktls_tx_try_handle_lost(sq,
+								      wi->skb);
+
 				if (unlikely(!wi->num_bytes)) {
 					/* Dropped, held by mlx5e_tx_flush() */
 					dev_kfree_skb_any(wi->skb);
@@ -859,7 +866,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			}
 		} while (!last_wqe);
 
-		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
+		if (unlikely(err_cqe)) {
 			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING,
 					      &sq->state)) {
 				mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
@@ -913,6 +920,8 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		sqcc += wi->num_wqebbs;
 
 		if (likely(wi->skb)) {
+			/* Destroyed with the SQ, not executed. */
+			mlx5e_ktls_tx_try_handle_lost(sq, wi->skb);
 			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
 			dev_kfree_skb_any(wi->skb);
 
-- 
2.44.0

