Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224990;
	b=eANSTasV7o9/CJeuBOm6S8D1wsl4HP1XyYr3z8oSGehIbJffuSE5joKelD99IDcb7pA4
	 4Al54DZFGqJNmOyy4Em5b7jVQX0l/9+RPQyIgaonaTIpSH/I+X9fFUjzzWSMLWResUT2o
	 RvYRjgvXRFoEOr76LUUEeFWvOtldpByQre/ZqxE2oDcudm4IuO4YFFP4mMXTuXM1z6sD/
	 FtubY6BPVVyOTHmcUotJe4Ld1sxn6DR6CK0LgV6iU/6QNHxyVpgzpjundsPKv1Qo0kSc6
	 CUzkia3CJpVMO9iH7p78dvEvTjxYuVOwBK/jxajqx+O6NlVDDF/mCrLr8xKlr9RkEig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224990;
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
	bh=eSXdRrj4T8Bbd35IWlczgWav048fAB9DyqWIUgQuS/g=;
	b=abp/njz/vKLBMnKNY4dmE8oZJFS13GFNRKnUk/k5y/zaPCxgqRGBT4CUetl7CRvdfKtO
	 zUWCF2QcYkBnHEAoRymPHkr5tuFp0LyM1bRuaZQPxNYHKOk72AGHRJ2al3Fx9hIxlueC0
	 uUfUQuJOVMdvmcD/fYW58D9rK02vLfOFRBIW7T3FH7czA7ub/W6qpOF01a+17atb1apLC
	 2YXvWVBW/eE+9Mk+bJ+8t3RmykLz7usufa1y8zbqAdZOqbbJsg10EqQkd11Tqwxu8keQh
	 fAY+1oQl+5nXg5TULBd9a81WjsCRMqJOtc717C0bOwksh5GdrxBGLgAvbfZiYCnDtGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N7j2dTUS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.63
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011063.outbound.protection.outlook.com [52.101.57.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57F6606A325;
	Mon,  9 Nov 2026 11:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C57F6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N7j2dTUS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0L0gAgWK3pRVJiLqlmeTpipaxViqrzDmi9o/ZS1EYl5ZSF6uuKJxZmCJJMBM2x6IPUQ4HuRyGgtTIj1LKXWKqN0/mEdHMLVbXZVGJ1Y1PaCBf1odz//GHg4jlkLl9Ut4+FHNjpD0+yZOOUGoIwmyanu4eTpGUB5nHU+uK6qW6t4uwJZURNzo180ckdu26NFVOPqm0lpBLhH1T1P21eZCfQqfkLlbF2o4KfKTZgsSG1+YgGivM/NuFLXZ+LgviSlBAtjD3Vr01jKGeUMsb3R7TSiMh2996UXeNNzW2lByVcLeA/T0OD0anYFuKFZdlPKdJ0722gj/efLi68DvBRaiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eSXdRrj4T8Bbd35IWlczgWav048fAB9DyqWIUgQuS/g=;
 b=ibnMI11jaYatW50OZXrsM2Xuhp07fAx5P0KxfLvf5y8odm7EwZj4TVs61n9Wl34BKBWh/1mHAYUyZCto1NZhRtIeo4o7ieA+4aWEtqaaGPbnAYZezRzts4oDJEH0AoXLXAw5US2m/Nq/wULmfPtB8MrxCjZLDN/t78Qd/6QzUZj4nM8LAVfYEhtkeB2sXzaI9BpH2zkjnE53jxKEamGWdyT1uSmlyjvd+8Ko4vTDN/0xhB4H7bUYYARmGHg4yODVAfPDy450NuBVRUU7Ozr8GETSWF1moMJ2WY8l7KprSvkxpdqZuFKWz/a05IA9S8VhYXJVqJrDWXjC3RZfieNvtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eSXdRrj4T8Bbd35IWlczgWav048fAB9DyqWIUgQuS/g=;
 b=N7j2dTUSDeqHUEQmdkJ7SwGGvvzdwiHHI/lpW4DSzfBcCQMI3cMrJCLUdLsSdUkkHNOS61r9KBiSPNXWqazBFSh7vDwnGK5NkiMp1lTG2/9XdxXYQfDHh4ygecQyE4HwwYXqxtEWMKVkiWsdvoBjlxh0Yz2dXke5wt5YQRAe/9HIrgJYCtIxws1YYX45k62kHNF7fsCOVBJFlcmARrO8IYZ4ttGSDmaA6JIvz6yPRGl+02d7bEVmTRWXB7AECcCqWBUlIKX7UtRtKjbJHvxwQOHRWIjHz9/WB1pojItC0PeL0bx2aIZ30+XiBRbuvZL8CRvVy66wdOOFj1vp8uskrA==
Received: from BN1PR13CA0007.namprd13.prod.outlook.com (2603:10b6:408:e2::12)
 by CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 11:49:44 +0000
Received: from BN3PEPF00022BD1.namprd03.prod.outlook.com
 (2603:10b6:408:e2:cafe::38) by BN1PR13CA0007.outlook.office365.com
 (2603:10b6:408:e2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.7 via Frontend Transport; Mon, 9
 Nov 2026 11:49:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BD1.mail.protection.outlook.com (10.167.248.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:49:44 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:29 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:49:19 -0800
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
Subject: [RFC net-next 6/7] net/mlx5e: kTLS, Keep the TX queue of an offloaded socket stable
Date: Mon, 9 Nov 2026 13:47:33 +0200
Message-ID: <20261109114734.2087878-7-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BD1:EE_|CY5PR12MB6599:EE_
X-MS-Office365-Filtering-Correlation-Id: 76bb7ba2-0761-4ae3-7a57-08df3e578c32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|7416014|1800799024|18002099003|22082099003|10067099003|13003099007|921020|5023799004|11063799006|261028144727099003|261102123227099003|261022075727099003|261022105027099003|56012099006|261021123027099003|261021121427099003|261026121527099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	6h2TNkYtvASPEOIUw1bsXQ9wJqxRUTQLhdShqcNuZvQMGkttlrLw96pHRrRZirIcbj2//R39V7IUYbQlPL1kBi4EPzAeY2PCA43HIsEGqT52Yg2dc65pjnTdDYFaIshssMX4UwUo7WfBOi5STQ8v0mN0cXmZwpoHL9uimYarOmC3Z7ixm3WIAIRd2VFRyd7KlzUBEqwKX7r+H4wtPsKaHbwKjgqROMfeQaIzK+AMLOqTuuZFWud3vEMHwHC+yRBaexTyMHcQJ0TACcqRPXBcFMwMHwgnNq8/KEkCGfbJ5iBWNxU22cXaniR3sVEc0nqQSpgIOIZvV7Pi7oZs9UOweV6By8PHkfBmJ4KXMVSv9/LL7F15XVg4AHu7JmYHhgIKGcwY3jfvInYmDq6JAt0ftS4JUn78SQt+0Er7Qb+Z78dq3Oul+MB5AH3OpENr6D1YUNOS41eAE4h8z6r6vhUXmDK8MVCwel97eTa1vTYIdaCBKPEqo79HIUmzcJYsjG9rhoTKsKRAP/nWblvYLaNG0+fG9fOpbPQc5Cz/Dcsolg6tQJX+sHLMGU+W721BWDGCROqrMW7RZ8X3sfvg6IccQl5mzI7HmqZZhI+jCVxNiioqAfWsYHsh8tpwoZFeYCwxNeP8Yu+pec4G5NhcHcfmRyplIY/T3G2RWFPxxoM3WNVPgFNUd45H2FQLGz3Up50hagIadvvZz5ks/ivt57Co+gWFcZQ7ELzqGOeXLE/jXmvifrX/xyhLklkuYwwD08wR
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(10067099003)(13003099007)(921020)(5023799004)(11063799006)(261028144727099003)(261102123227099003)(261022075727099003)(261022105027099003)(56012099006)(261021123027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Qow5QuD+9Jju3Kh5RcbxxHcYQT/E8WYt3OFhXdlr3++GHufCh7Nm6Cc/m9EXbtMjjFA3Ae2/izZaYUxS/uZT+fiDHjj2WXu22jbqh3QcP35ibqUpFY6x9sLgtdiqrz0L5N0xM6wDVxBzRyIQET44Tygg7nuVNo8Wlc1zIoFs5U8FDZwPuu9cL+jRnwiOWuQynykzk/GCabF+mJnk1Avjau18S8lJTZGjCO8ezNRxB53vdT6Jj/x1Ep2Vj3FMvH2w6ExGlgUuyYCNGLOkzBTHWpU8U7b40kM25sz68mN9O65mCgGSGqhQK16mC6hYfwZUKdW3OJ2ir5fwA4SdFR3AdmmDiGd1qEruE+A08hf1lmyOQ2tw1krXSW0mtFC2g39FXpI8jKX8TCqaxA7QqX5m04yT8Vax4zJcxh6zWc4CznSY1SIFGmig7BYrPn2wxc5y
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:49:44.3717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76bb7ba2-0761-4ae3-7a57-08df3e578c32
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6599

kTLS TX WQEs update the TIS crypto and record tracking state at
execution time, and WQEs of different SQs are not ordered. A connection
must not move to another SQ while WQEs that it posted to its SQ may be
pending.

With TLSDEV_F_STICKY_TXQ, the stack keeps the socket's TX queue while
the socket has packets in flight. mlx5e_select_queue() uses that queue
to pick the channel only: with multiple TCs, it adds the offset of the
skb's UP, derived from its DSCP or VLAN priority, and with HTB, it picks
the QoS queue of the skb's priority. A connection whose packets change
priority moves to another SQ at any time.

For a SOCK_STICKY_TXQ socket, cache the final queue in the socket, and
reuse it while TCP does not allow a move (ooo_okay is clear). A priority
change then takes effect once no packet of the connection is in flight.
TCP sets ooo_okay when it transmits the skb, and it may be stale by the
time the skb is selected, e.g. after an upper device's qdisc reordered
the socket's skbs, so a move also requires that no other skb of the
socket is in flight. A cached PTP queue is not reused, these are
selected for PTP event packets only.

The remaining moves are covered by the net fixes "net/mlx5e: Drain old
TX SQs before activating new channels", for channel replacement and the
TX queue count changes that come with it, and "net/mlx5e: kTLS, Hold a
dropped skb until its posted WQEs complete", which keeps sk_wmem_alloc
held while WQEs of a dropped skb may be pending. When an HTB leaf is
deleted or becomes an inner class, its queue is removed or given to
another class only after its queued packets were dropped and its SQ
closed, so its connections have nothing in flight and pick a queue anew.
An skb that netem partially orphaned holds no sk_wmem_alloc charge, but
it carries no data for the device, and does not post WQEs that name the
TIS since "net/mlx5e: kTLS, Post TX context params only for skbs that
use them".

Opt in to TLSDEV_F_STICKY_TXQ.

Found by LLM-assisted code inspection, while answering a question on
kTLS TX TIS reuse for TLS 1.3 rekey on netdev, and reproduced on
ConnectX-6 Dx with forced queue moves.

Reproduced on ConnectX-6 Dx, with 128 channels, mqprio with 8 TCs and
DSCP trust mapping DSCP 46 to priority 5, by flipping the IP_TOS of 32
kTLS TX offloaded connections between 0 and DSCP 46 every 5 ms while
they stream pattern data for 60 seconds to a software kTLS receiver that
checks every byte. Without this patch, 115 of 147 connections failed
decryption. With it, none did, and the connections still reached the TC5
queues.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@purestorage.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/selq.c | 92 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ktls.c        |  1 +
 2 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
index 8318a26bc263..dfaee2c3624e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
@@ -5,6 +5,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/rcupdate.h>
+#include <net/sock.h>
 #include "en.h"
 #include "en/ptp.h"
 #include "en/htb.h"
@@ -190,22 +191,12 @@ static int mlx5e_select_htb_queue(struct mlx5e_priv *priv, struct sk_buff *skb,
 	return mlx5e_htb_get_txq_by_classid(priv->htb, classid);
 }
 
-u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
-		       struct net_device *sb_dev)
+static u16 __mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
+				struct mlx5e_selq_params *selq)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_selq_params *selq;
 	int txq_ix, up;
 
-	selq = rcu_dereference_bh(priv->selq.active);
-
-	/* This is a workaround needed only for the mlx5e_netdev_change_profile
-	 * flow that zeroes out the whole priv without unregistering the netdev
-	 * and without preventing ndo_select_queue from being called.
-	 */
-	if (unlikely(!selq))
-		return 0;
-
 	if (likely(!selq->is_special_queues)) {
 		/* No special queues, netdev_pick_tx returns one of the regular ones. */
 
@@ -266,3 +257,80 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 
 	return txq_ix + up * selq->num_channels;
 }
+
+static bool mlx5e_sk_sticky_txq(const struct sock *sk)
+{
+	return IS_ENABLED(CONFIG_MLX5_EN_TLS) && sk && sk_fullsock(sk) &&
+	       sock_flag(sk, SOCK_STICKY_TXQ);
+}
+
+/* TCP sets skb->ooo_okay when it transmits the skb, and it may be stale by
+ * now, e.g. after an upper device's qdisc reordered the socket's skbs.
+ * Allow a move only if no other skb of the socket is in flight: a
+ * decrypted skb holds its own sk_wmem_alloc charge, any other skb may not.
+ */
+static bool mlx5e_sk_txq_may_move(const struct sk_buff *skb)
+{
+	int own = skb_is_decrypted(skb) ? skb->truesize : 0;
+
+	return skb->ooo_okay && sk_wmem_alloc_get(skb->sk) <= own;
+}
+
+/* A SOCK_STICKY_TXQ socket must not move to another TX queue while it has
+ * packets in flight, see TLSDEV_F_STICKY_TXQ. netdev_pick_tx() keeps the
+ * socket's queue, but the UP offset and the HTB queue are derived from each
+ * skb. Reuse the final queue of the socket's previous skb, unless TCP allows
+ * a move.
+ */
+static int mlx5e_select_sticky_queue(struct net_device *dev,
+				     struct sk_buff *skb,
+				     struct mlx5e_selq_params *selq)
+{
+	int txq_ix;
+
+	if (mlx5e_sk_txq_may_move(skb))
+		return -1;
+
+	txq_ix = sk_tx_queue_get(skb->sk);
+	if (txq_ix < 0 || txq_ix >= dev->real_num_tx_queues)
+		return -1;
+
+	/* The PTP queues are selected for PTP event packets only. */
+	if (selq->is_ptp && txq_ix >= selq->num_regular_queues &&
+	    txq_ix < selq->num_regular_queues + selq->num_tcs)
+		return -1;
+
+	return txq_ix;
+}
+
+u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
+		       struct net_device *sb_dev)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_selq_params *selq;
+	struct sock *sk = skb->sk;
+	int txq_ix;
+
+	selq = rcu_dereference_bh(priv->selq.active);
+
+	/* This is a workaround needed only for the mlx5e_netdev_change_profile
+	 * flow that zeroes out the whole priv without unregistering the netdev
+	 * and without preventing ndo_select_queue from being called.
+	 */
+	if (unlikely(!selq))
+		return 0;
+
+	if (likely(!mlx5e_sk_sticky_txq(sk)))
+		return __mlx5e_select_queue(dev, skb, selq);
+
+	txq_ix = mlx5e_select_sticky_queue(dev, skb, selq);
+	if (txq_ix >= 0)
+		return txq_ix;
+
+	txq_ix = __mlx5e_select_queue(dev, skb, selq);
+	/* Cache the final queue, as netdev_pick_tx() does with its own pick. */
+	if (rcu_access_pointer(sk->sk_dst_cache))
+		sk_tx_queue_set(sk, txq_ix);
+
+	return txq_ix;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 337201f12895..248ccae9f8e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -87,6 +87,7 @@ static int mlx5e_ktls_resync(struct net_device *netdev,
 }
 
 static const struct tlsdev_ops mlx5e_ktls_ops = {
+	.flags = TLSDEV_F_STICKY_TXQ,
 	.tls_dev_add = mlx5e_ktls_add,
 	.tls_dev_del = mlx5e_ktls_del,
 	.tls_dev_resync = mlx5e_ktls_resync,
-- 
2.44.0

