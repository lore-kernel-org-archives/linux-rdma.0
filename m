Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224984;
	b=J4beELEv8r6wBocfDTk6vohhfeyLkBh5uumdAoSeQ0EZt9+G8FcVay2P6doptwJUh99b
	 wLycurulB6WAFI7F1PEH9otOe3/ymu6z6ct6Xz4098WE6qxzY5G5YaWf364F60AaiWxtI
	 WBGjJbi82twdrjGn/r/6UOgnXYlDpYW0nysmbQzhcr/3Kj5oCPVZQs0ILjVYVfM0DZtjz
	 xS2FUOom5jb5RsYOVRl2r5/hf7AjmVcc8M6NLP1sgnEzDZWXiHYRoviV+TAsQ8c0DXaMO
	 NZU3W89a69h52jWZ/aZ/1SKRbk7vFj0gB6ae+qHJ28n6ICt+vY8qrZtHvPyX1+GP51A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224984;
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
	bh=M4qcG/IotNi+dKc01MBp//a2aBblMKXrL4Q2YJR/GZo=;
	b=DQXGtYRAJEPmZOyRq2/lq8W96X/nSSRa0zjNtcUegLVRjNi/OdByZ/466O2fkHy2DK7e
	 m94FfO0nM3grnrAuBDkFET5xI/MfeLOqxQi/B8dMLS004RDF9HKiMg9Kdk/GRvxNYTv4F
	 PLusTieIPOoRa1ix2I1wr1M+5eWBBMh3ZTUhLWaKLyzYl/2itdwRUr9SdAuH5alfgRgTY
	 1tQmcpwJtg6GAQldEwdU20DzkhHwZplc/jZuoULPSIjAj/20AN8MBQj3Pztwu/4Lolu1S
	 1gWo/5mMLzOo6VY5bIOtD0q+/tL9R1kmrUdbmfjR0csDezpS030fdgJ1wpidP3rSIbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N6iqXAce;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.40
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C5D606A326;
	Mon,  9 Nov 2026 11:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1C5D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N6iqXAce
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m55dox98mX9Dl6/KT3LHf0Q0kory++yvAXOll/MidN4V1paUVN33HLGQf78UpIm6YoSYq6ioLr7urXCkg9RnKCIk2Oegqw1nrhYEG5vsbV089AUq1jBb+aOIezuohwNi212v/HKpdS4ACnTfNAdqCFP7qvIVthS0bIK+8xBfAnbRYrlsu+O7WlzC9g+AYnvoFWxQr7gSp3N77uEU74LFmfW5nKgPRnEVt6Sw2AswPWyo3mz+wBjECN+KOQEhLfTWYF5lZqGDvuaRE/GVChBECS7p1sPZDagCa7xejG5VPDPwqmxpWWpnkkCJHIp6G8jX5vsa6fNWjwBrBoYuwbKUrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4qcG/IotNi+dKc01MBp//a2aBblMKXrL4Q2YJR/GZo=;
 b=k1gD6Ciyg5qTIEs3h5LzhHmxRsWgj2319oY3RA44ztMpHgWqFKnTvaOOYjVnhCqu1n9aNfKxL+V3Q6zzh4il1rg2GsXSwQaSLaRUyFcKLlMBbV8JBAF1rhh46AXKq28U8OsfFfP/zaAKTKJ5sHqHcknAwb9YXJAbsaPpukxqt5U5BpN/scUNsaIcJYyr0Vd2zoSZnTUnZrBLKuifA60eZhdXjRd6LBmIIBsfvjdw5C+j1vMr/y2dWolUMc9NXr/KhEj2RXiaK/OXNW+WPLVX8/6XmS7Xi+vUbCQ/sn2UzubR+EcyXSebxNTm4qN5CHps2mGaKxVjIMDTuu/nP+3m5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4qcG/IotNi+dKc01MBp//a2aBblMKXrL4Q2YJR/GZo=;
 b=N6iqXAcekik635l7BHtJxKwbOicdSbvB9Jjuq2ErBq6v0QrYodHxRenGe79tp8vhvyHYjiGF2B3HZX0o+jM850SDpdh3z/d4xPxWZNqH2et4LAMnEGS60Av8jHdVMvDLZGNnTvE6Q42oVXTjQNJt1KhQSZvx4mRot1O48vltv3EAG1S+Wn4s756vZ0ig3VN5qMJjFANzPoctUND1nFJnLcV0INLCgs/zEbJrnKYEY0913INCgoYEkWsZ8UBK8iSlIsnt7EMDJzA4PX3PX/VqmKYR2oaTaSW9XwqYaRCdFp6qHQ/pF/XODK/gIf1UB/iEekZjlTxaGFzn/EPA3NKMRQ==
Received: from BN0PR04CA0042.namprd04.prod.outlook.com (2603:10b6:408:e8::17)
 by SJ0PR12MB7082.namprd12.prod.outlook.com (2603:10b6:a03:4ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 11:49:37 +0000
Received: from BN3PEPF00022BCF.namprd03.prod.outlook.com
 (2603:10b6:408:e8:cafe::4e) by BN0PR04CA0042.outlook.office365.com
 (2603:10b6:408:e8::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 11:49:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BCF.mail.protection.outlook.com (10.167.248.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:49:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:19 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:49:18 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:49:08 -0800
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
Subject: [RFC net-next 5/7] net: tls: keep the TX queue of a device-offloaded socket stable
Date: Mon, 9 Nov 2026 13:47:32 +0200
Message-ID: <20261109114734.2087878-6-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCF:EE_|SJ0PR12MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: 482e4dd1-b934-457b-4b42-08df3e5787e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|22082099003|18002099003|10067099003|3023799007|13003099007|921020|11063799006|261028144727099003|261102123227099003|261022105027099003|261022075727099003|56012099006|261021121427099003|261021135927099003|261021123027099003|261026121527099003|261026140227099003|261009221227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	E64mXZ2MPHs0knPHHE7Qhzj/il+Vee6y9xIhV9RiTMXEOIg737ZeyucZao8tPokYlvhlCmccFKX4xXtlwdzM9I7KHacmy1LWIIJQn3o2M1eORMqCi3CeZxx7f9fNM9zvg8X0h38Q//aU42OsDIZD5UNMu6f1AjQ/QABegoKUJv26vzjLEh6Lqgn5su6AsCeV3bYZ1eXth57ISplF7fujfjmTzbH9/qKcbYtCZonrQ1e7Qn7TdTQWiBurqQi3wETpwSiuoKWrmvs6LQI2c8p0+WAv+Utc3e7APTnX8erx3Hkw0L04O6OWRlRtXV6oaApf+GqHbljdnx+IGz98yqRoLMD2XyWVIIRhWHzzgIi6KIu74BHWVpqkv18GAc9EOCuNs2QJjTnfstu1yvTBYeqAJZEQEXjukwQTFhwKPyDwD2/0vMTxWJOd9i+U3xK7581f8p3yeP5DJe7+6nCiJJDyklmFx2JYItVF1yk2rhyvXKuD9g980HjKzvVfJU5maf+4PmzG0OgVU32PCAr5fgMyAL9BydpJGa5bkVrbrrN20brXxJf6roJrwITPRzJinIRmibGAYwGHxNmJJtLpow/H+gYmPGuqLFQ930bL9dQgC8iOQ1hRCRARZEE7lWxRmPS4HUdnR62njGraDQ9y5Hl1/PQt2g52Ud91JmuAyYGIhspDxQJGCJSTBI37C0EVCtNnz+FNyBS6AyYrOGSpbPgKdvo2cmsn2KYu02ZESjALOO1QgxmZLXCVWqFYHqGFQKIY
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(10067099003)(3023799007)(13003099007)(921020)(11063799006)(261028144727099003)(261102123227099003)(261022105027099003)(261022075727099003)(56012099006)(261021121427099003)(261021135927099003)(261021123027099003)(261026121527099003)(261026140227099003)(261009221227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E21wbS6S7ymloaf1jrCX1vdV11bR1adw/ncxE4W5OcKYFk0nE6566ZuY1n5TeHTvlvBberQ5pyXtIIJQuJYKxGx0rMdcgatZpK3I/8hzc6JgO21FJZEt7Lqlov+Ba+e0NgblWMxcZOZYdzVY+AEymLk5guN566Z6FADlcWnZnR3Ewdrrso/8HKEGYUGPmPen1s7UPAYtU2q0Q5J5ugDTAmaan7jPpXESCj/iwCdaKZsrIA0k5CtrUzo/ar+Deklcic6CiVoRsIxBAiRJCY248r42oBtyW9XFXMdhh0/RtnjMPJ9SE0gXqknovmeOF/0+ASFrPgndFco++9uJ+WxUwl170wnexfrCc+pox2Ug0C5LW1YBFK+3DqGbtzJkKBoxM7NmqZiGSxfvMpeG/p8ZZWVHM+xYlPb6V/wgqlWrnj54n3UzXLXqmXy9q0nrmF57
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:49:37.1748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 482e4dd1-b934-457b-4b42-08df3e5787e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7082

A device that keeps per-connection TLS TX state (e.g. mlx5e kTLS, where
WQEs update the TIS crypto and record tracking state at execution time)
cannot order work posted on different TX queues. If the flow moves to
another TX queue while work is still in flight on the previous one, the
device state is accessed from both queues with no ordering, corrupting
the record stream on the wire.

The stack moves a socket's flow while packets are in flight: TCP sets
ooo_okay when the rtx queue is empty, a dst reset (e.g. on RTO or PLB
rehash) clears the cached TX queue, and txq_reselection_ms expires it.

Let a driver declare the constraint via a new tlsdev_ops flag,
TLSDEV_F_STICKY_TXQ, and mark sockets offloaded to such a device with a
new sock flag, SOCK_STICKY_TXQ. While such a socket holds sk_wmem_alloc,
keep its cached TX queue: do not clear it on dst changes, do not expire
it, and set ooo_okay from the wmem condition only.

This covers the stack's own queue selection. The rest is the driver's,
as documented: a ndo_select_queue that derives the queue from more than
the cached one must keep its choice stable too, changing it only for an
skb with ooo_okay set, and when TX queues are removed, the device must
be done with their work before the flows move. tc skbedit queue_mapping
bypasses queue selection, and is not supported for such sockets.

Packets in flight are tracked by sk_wmem_alloc, so the flag also
requires the driver not to free an skb, even a dropped one, before the
device is done with the work posted for it.

Found by LLM-assisted code inspection, while answering a question on
kTLS TX TIS reuse for TLS 1.3 rekey on netdev, and reproduced on
ConnectX-6 Dx with forced queue moves.

Reproduced on ConnectX-6 Dx, with 128 channels and 32 kTLS TX offloaded
connections streaming pattern data for 60 seconds to a software kTLS
receiver that checks every byte. Without this patch and the mlx5e one
that follows it, 1 of 33 connections failed decryption with the default
txq_reselection_ms, and 67 of 99 with txq_reselection_ms=1 and the
senders migrating between CPUs every millisecond. With both applied, no
record failed in either test, with no loss of throughput.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Fixes: 726e9e8b94b9 ("tcp: refine skb->ooo_okay setting")
Fixes: 4a7708443dec ("net: allow busy connected flows to switch tx queues")
Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@purestorage.com/
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 Documentation/admin-guide/sysctl/net.rst |  3 +++
 Documentation/networking/tls-offload.rst | 20 ++++++++++++++
 include/net/sock.h                       | 33 +++++++++++++++++++++---
 include/net/tls.h                        | 13 ++++++++++
 net/core/dev.c                           |  3 ++-
 net/core/sock.c                          |  2 +-
 net/ipv4/tcp_output.c                    |  7 ++++-
 net/tls/tls_device.c                     |  3 +++
 8 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index fe43e8595958..88bfb4421843 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -449,6 +449,9 @@ But switching txq can introduce reorders, especially if the
 old queue is under high pressure. Modern TCP stacks deal
 well with reorders if they happen not too often.
 
+A flow offloaded to a TLS device that keeps per-flow TX state in
+the device switches txq only once it has no packets in flight.
+
 To disable this feature, set the value to 0.
 
 Default : 1000
diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index cf0e599c06a1..f03e48643503 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -190,6 +190,26 @@ TLS handling and confirms the sequence number matches its expectation.
 The device performs encryption and authentication of the record data.
 It replaces the authentication tag and TCP checksum with correct values.
 
+A device may keep the TLS state of a connection in the device, and update it
+as it processes the TX queues, with no ordering between the queues. Its driver
+sets ``TLSDEV_F_STICKY_TXQ`` in ``tlsdev_ops->flags``, and the stack then keeps
+the TX queue selection of an offloaded socket stable while the socket has
+packets in flight (``SOCK_STICKY_TXQ``): the cached queue is neither cleared on
+route changes nor expired by ``txq_reselection_ms``, and TCP sets
+``skb->ooo_okay`` only when no packet of the socket is in flight. Packets in
+flight are tracked by ``sk_wmem_alloc``, so the driver must not free an skb
+before the device is done with all the work it posted for it, even when the skb
+is dropped.
+
+The rest is up to the driver. If its ``ndo_select_queue`` derives the queue from
+more than the socket's cached queue, it must keep its choice stable as well, and
+may change it only for an skb with ``ooo_okay`` set. A queue change driven by
+the skb's priority or traffic class then waits until the socket has no packets
+in flight, which under sustained traffic may never happen. When TX queues are
+removed, the device must be done with their work before the flows that move from
+them start transmitting on other queues. ``tc`` ``skbedit queue_mapping``
+bypasses queue selection and is not supported for such sockets.
+
 RX
 --
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 9bba1e793f1e..ab4b5a5a74f5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1026,6 +1026,11 @@ enum sock_flags {
 	SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
 	SOCK_RCVPRIORITY, /* Receive SO_PRIORITY ancillary data with packet */
 	SOCK_TIMESTAMPING_ANY, /* Copy of sk_tsflags & TSFLAGS_ANY */
+	SOCK_STICKY_TXQ, /* Keep the TX queue selection while packets are in
+			  * flight; set for sockets whose TX offload keeps
+			  * per-flow device state updated by queue execution
+			  * (see TLSDEV_F_STICKY_TXQ).
+			  */
 };
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
@@ -2067,6 +2072,29 @@ static inline void sk_tx_queue_clear(struct sock *sk)
 	WRITE_ONCE(sk->sk_tx_queue_mapping, NO_QUEUE_MAPPING);
 }
 
+#define SK_WMEM_ALLOC_BIAS 1
+
+/* A SOCK_STICKY_TXQ socket keeps its TX queue while it has packets in
+ * flight: a stateful TX offload must not see the flow on a new queue
+ * while its work may still be pending on the previous one.
+ */
+static inline bool sk_tx_queue_pinned(const struct sock *sk)
+{
+	return sock_flag(sk, SOCK_STICKY_TXQ) &&
+	       refcount_read(&sk->sk_wmem_alloc) - SK_WMEM_ALLOC_BIAS >=
+	       SKB_TRUESIZE(1);
+}
+
+/* Like sk_tx_queue_clear(), but keeps a pinned mapping, see
+ * sk_tx_queue_pinned(). Lifecycle resets (allocation, cloning) must use
+ * sk_tx_queue_clear() directly.
+ */
+static inline void sk_tx_queue_maybe_clear(struct sock *sk)
+{
+	if (!sk_tx_queue_pinned(sk))
+		sk_tx_queue_clear(sk);
+}
+
 int sk_tx_queue_get(const struct sock *sk);
 
 static inline void __sk_rx_queue_set(struct sock *sk,
@@ -2237,7 +2265,7 @@ __sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
 	struct dst_entry *old_dst;
 
-	sk_tx_queue_clear(sk);
+	sk_tx_queue_maybe_clear(sk);
 	WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 	old_dst = rcu_dereference_protected(sk->sk_dst_cache,
 					    lockdep_sock_is_held(sk));
@@ -2250,7 +2278,7 @@ sk_dst_set(struct sock *sk, struct dst_entry *dst)
 {
 	struct dst_entry *old_dst;
 
-	sk_tx_queue_clear(sk);
+	sk_tx_queue_maybe_clear(sk);
 	WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 	old_dst = unrcu_pointer(xchg(&sk->sk_dst_cache, RCU_INITIALIZER(dst)));
 	dst_release(old_dst);
@@ -2369,7 +2397,6 @@ static inline int skb_copy_to_page_nocache(struct sock *sk, struct iov_iter *fro
 	return 0;
 }
 
-#define SK_WMEM_ALLOC_BIAS 1
 /**
  * sk_wmem_alloc_get - returns write allocations
  * @sk: socket
diff --git a/include/net/tls.h b/include/net/tls.h
index e57bef58851e..80fd68c9801f 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -276,7 +276,20 @@ enum tls_offload_ctx_dir {
 	TLS_OFFLOAD_CTX_DIR_TX,
 };
 
+/* TX offload state (e.g. crypto and record tracking state of a device
+ * connection context) is updated by TX queue execution, and the device
+ * provides no cross-queue ordering. The stack keeps the socket's TX queue
+ * selection stable while the socket has packets in flight
+ * (SOCK_STICKY_TXQ), and the driver keeps its own part of the selection
+ * stable too, see Documentation/networking/tls-offload.rst. Packets in
+ * flight are tracked by sk_wmem_alloc, so the driver must not free an skb
+ * before the device is done with all work it posted for it, even when the
+ * skb is dropped.
+ */
+#define TLSDEV_F_STICKY_TXQ	BIT(0)
+
 struct tlsdev_ops {
+	u32 flags; /* TLSDEV_F_* */
 	int (*tls_dev_add)(struct net_device *netdev, struct sock *sk,
 			   enum tls_offload_ctx_dir direction,
 			   struct tls_crypto_info *crypto_info,
diff --git a/net/core/dev.c b/net/core/dev.c
index 3b60b15e2175..18f7b9159ec5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4894,7 +4894,8 @@ int sk_tx_queue_get(const struct sock *sk)
 
 	resel = READ_ONCE(sock_net(sk)->core.sysctl_txq_reselection);
 	if (resel && time_is_before_jiffies(
-			READ_ONCE(sk->sk_tx_queue_mapping_jiffies) + resel))
+			READ_ONCE(sk->sk_tx_queue_mapping_jiffies) + resel) &&
+	    !sk_tx_queue_pinned(sk))
 		return -1;
 
 	return val;
diff --git a/net/core/sock.c b/net/core/sock.c
index e2401d735c5a..d90a4f69ddda 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -606,7 +606,7 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
 	if (dst && READ_ONCE(dst->obsolete) &&
 	    INDIRECT_CALL_INET(dst->ops->check, ip6_dst_check, ipv4_dst_check,
 			       dst, cookie) == NULL) {
-		sk_tx_queue_clear(sk);
+		sk_tx_queue_maybe_clear(sk);
 		WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 		RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
 		dst_release(dst);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 08d0d4a639fe..690f73e9de41 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1661,9 +1661,14 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 	 * 2) Or rtx queue is empty.
 	 *    This mitigates above case if ACK packets for
 	 *    all prior packets were already processed.
+	 * A SOCK_STICKY_TXQ socket (stateful TX offload) relies on 1) only:
+	 * a spurious retransmit clone may still hold wmem and reference
+	 * device state from the old queue when the rtx queue is already
+	 * empty.
 	 */
 	skb->ooo_okay = sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1) ||
-			tcp_rtx_queue_empty(sk);
+			(tcp_rtx_queue_empty(sk) &&
+			 !sock_flag(sk, SOCK_STICKY_TXQ));
 
 	/* If we had to use memory reserve to allocate this skb,
 	 * this might cause drops if packet is looped back :
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4cdfbb57ecff..048b6a912d41 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1197,6 +1197,9 @@ int tls_set_device_offload(struct sock *sk)
 	tls_device_attach(ctx, sk, netdev);
 	up_read(&device_offload_lock);
 
+	if (netdev->tlsdev_ops->flags & TLSDEV_F_STICKY_TXQ)
+		sock_set_flag(sk, SOCK_STICKY_TXQ);
+
 	/* following this assignment tls_is_skb_tx_device_offloaded
 	 * will return true and the context might be accessed
 	 * by the netdev's xmit function.
-- 
2.44.0

