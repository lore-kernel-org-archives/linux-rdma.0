Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794224927;
	b=nkU+FkgvMRfy3aGtNi4VKVECfh5HHWAKFrHLhcqviNSjPROBryYym5Dl6FVbL1sBGO3R
	 OnrDpeuMBFdBXo2XSwmvem/3G69f/TdluwVe+sJ+UEYpNnIet54YexzOJ7HnsZqjF7joP
	 +7sVoHzOpns9Wa46hQ1Co6lRsCK5qJm1Z2CkvrPHXs78Q1YIPuwgtH/ndn4wf9r9OQpZ2
	 xi8Xcty2hQ5Qtdi6ZbooUm8Km4I78Bz1UqO34ZEjQD2y0tnO9P2bcakfnYY1+3SyAg8Wo
	 Vr6pg8ItiN7a2H20gIKZjpcWO9syra9IwkyBGQ73uosr48scIR6wLzzEqI4WAF2toiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224927;
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
	bh=+mafEj/GrWhGLS2pQIXbCar7L/xgmjKGxeZNnZycuS4=;
	b=G07De2bUWmNbQLO20dnoTqBnUYnl8tXbp4G5XIlbcN5I7f+tP9z/2H11YlMjbxI54G+A
	 0Vjzuu3Yj1aQs3BwhFF5+oen1BBQXG3LoNUzBl2KwX/JS6lBHM3ZRoDhrbaqIPRoPp8o8
	 GIqihdY+lGcho5o3MScP8tH07pTupenB56VItEfpc7Et9pMsh4tjLf4ssItllfK8+wRyk
	 UsVrX8Q1TxzPwvboMW90Bjx6SZdwkl4qUDNr+3majR2RWDXsTWgLnjxWEN2QKN6Vu+APp
	 2yXgw4ud5/TuxHzae1aN+yihrP3X2k5+uN9u6BTSJsOWNxMQ1S4RaJ/5bQOKJp8dw+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=St6gzCjS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.41
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012041.outbound.protection.outlook.com [40.93.195.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C086606A322;
	Mon,  9 Nov 2026 11:48:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C086606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=St6gzCjS
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqzO7jyWETmtoQ0YRaB4wfcWMPfMNu/fU0FqIpBBvVJvqE/BDRYlWVtzTIF5h14/h/DCvzZh34Ig0lNusSKW0g/OKbiMOUsl8v19Qfb+SHNL+qc/CNd14qh96WbOhZ0NpTr7YnaXb04pEmXhz0HtcJwYDD1jp2AyfLAZoKYnEHmD58CHMr+q3FW3p8QcCUdilYsAUHNOK8pcY2bAK08zojF8xZe82O0gEaicf4wMmBugdhPMWarKKmg2nHtYZr/D9wMS+bdG1WhynjG9t+hNhZXaU2ZwUG0SUD3z8XbVa8LsyN7+d/3t2Vk3P2s69YFg86AkDF7HwrQV8c3kM/0ZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mafEj/GrWhGLS2pQIXbCar7L/xgmjKGxeZNnZycuS4=;
 b=Bt3RhhiDALZiQb2gkdMsclzguVcgFfm2DxGzgFAcAjqyDRj6uiIDdwwWsc1JZDjn6L417T803kAf2yM4jxFQ5ghVCOmboUfmbjUcXX8q86rx0Xx8y6dntPWIVAXWH4VlcM8lfc59gEysRXypcXql9BXaG9GZRilSYHC2wK67p8qtLkD55Jen0MVGg159rH5EBLkYQpM4scD1xnVknwLa/jbZ+yw7Dy6Bd/0Vyzz8coaiMr56UrVvtAkVNntatjoLCZfslxvrL7d0g5O9wZppodLZivEyoWAoAntkGc0KkhkPC9jMmx2K+U+ZqDVBnz+Yv91OitxSaagBlFuFTaPLdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=everpuredata.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mafEj/GrWhGLS2pQIXbCar7L/xgmjKGxeZNnZycuS4=;
 b=St6gzCjSMlPVjVy8eIYcPfoYdJ417QfDVHWc7iLGm3dETWnZ5vxg/efk/XBMtTjQ/4iAUaMi3e7yobJJoY3h5k5OivhmSfW2/PgVtv4yw9vzm/Oyfu5CBz/8z2afhGX15Yu6/CXE5AIDiDHpQ+WzOm6/bbPpENBL5/yIquBuE1j26WLTXBzt4arOlqlElRateDa6TMj3bC6WtLRNJGVgF+dHcXCC7YjA+EHsVqMRziUA8e6lIGhS2jbDDzAqnuGQPlqhzxSONs54Ja5H9ZS6VHoAOj1HABN/PzLtc1T1xwCK5wG4r/xuUUP+RT+5ezaivttYjhikjn+Owgjlvc8whg==
Received: from BN9PR03CA0762.namprd03.prod.outlook.com (2603:10b6:408:13a::17)
 by PH8PR12MB8606.namprd12.prod.outlook.com (2603:10b6:510:1ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Mon, 9 Nov
 2026 11:48:41 +0000
Received: from BN3PEPF00022BCE.namprd03.prod.outlook.com
 (2603:10b6:408:13a:cafe::6f) by BN9PR03CA0762.outlook.office365.com
 (2603:10b6:408:13a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 11:48:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF00022BCE.mail.protection.outlook.com (10.167.248.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 11:48:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:25 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 03:48:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Mon, 9 Nov
 2026 03:48:14 -0800
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
Subject: [RFC net-next 0/7] [Cover Letter] net/mlx5e: kTLS TX fixes for WQEs in flight
Date: Mon, 9 Nov 2026 13:47:27 +0200
Message-ID: <20261109114734.2087878-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCE:EE_|PH8PR12MB8606:EE_
X-MS-Office365-Filtering-Correlation-Id: b4aa06b9-f086-4317-76cc-08df3e576689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|921020|11063799006|261021121427099003|56012099006|261021123027099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|6133799003|13003099007|3023799007;
X-Microsoft-Antispam-Message-Info:
	fHlzXWy5n3q5EHQcKNG2r4D5GsFJaNp5oz6udrzQV48+pQOMHXZrvlUkdUgKSwfq3+ODXxBwCKgxqVD2NbhcATVvq0KRKz6+cQ2lBVJLFh0+5nh0qas62SUJkhOc8WVmyN4xwUFJFMk0ePcw5wDMAMxP4xPG43AreHDVZFU8smpNjc51ZL/HSSezzQgVTJjDEb9TpAnpK7DhsdOZule1YUiG2kEmHvgRZSIej7QSD7HDrsxH7pXh+t86IVvn9A2VmtRxW2T6GywJG1GSajs2PM00hPMVBLcnB2s7UtWm+icDWUiIvKxz16bKDnaITXs2T9uT4UXz405eB/p2wl6I3oxRve5f7tpLh+03FvRtVARApnzZPrijHjMMD6IrLWxoscXIdR5WOy7F2ZRUjmkT6SVHY0IC+IUD3BQc8W71LccUOzXiiX5Wi8lPaargVRh7O/Gc/J8A/aL3gc9ZW5bDXdiAfNCSoN9Kn2fF8qK7YiFHBlBBEZHP4lhF5Sw0/FLVu2AkBHlLclgXFy5AFYi1gIaXaW2t7dx+ern6tqXCODSmB2yqGfw/uEbGgWk5yznsIi9FknkDfBTrfHQ+jby13rzEkJ/aE9+E4D/x52uOkhyG0T6QHLCAOW8jJQIABJuLw8cMuWIGDvFWtIskIwqnWbW5E4dMnXzb/RtespGdj5orXOm/3wogNRsJkhBn6uQywd/W9wP8gEUgYbFsSJ0svWiONCukiU2x9YLj5+oBPOPNpC1ehD/LP2uDPmFx4YHd
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(921020)(11063799006)(261021121427099003)(56012099006)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(6133799003)(13003099007)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	I8serH/1N2cbWYphre52A/E8dqv2EGq1vR6HbvGl6xaNpHEpBdLnYTmfEku6BtiiIXXLLuIy8m8Gy1GSCdQ2bQcjllkT/rBGUlldB0Rkznf3OI6o0IWOuxnM/WWUuKEQjzv9Hf3K/SvK66uq6vOT4KhAZwyZoardehj1KkUwJ9HAvStWDk++6BV3WPAI8YwaeI1R9i+MD9JG4BhzKylzns++zhiMf8SmWWLWOZrOPKsNAvVtWw8PopewnR/HqBBNY+sJ9hzcubPV0Rs4WvAwau4VIJIQNbrOCH/kcOoLmVhQA1B4Uxy4YWOwuR5ViL26uRyy97AukR8oqedYL2Zym9inQX8gC/GGwrT823pNUfgCL0AixD8jeK2hkMYcJ4mZVe/REMnBdvTlv7Ddr1rjD4VDDBVWH7rK+UO10GSZ8K/StPK19YzrCBeeZ2KIl2+n
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 11:48:41.1879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4aa06b9-f086-4317-76cc-08df3e576689
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8606

Hi,

This series fixes kTLS TX offload cases where WQEs that a connection
posted are still in flight while its device state is released, changed
from another SQ, or assumed to be in sync. Records then go out wrongly
encrypted, or the TIS and DEK are released while still in use.

kTLS TX WQEs update the TIS crypto and record tracking state of a
connection as they execute, and the device orders WQEs only within an
SQ. The series makes sure that:

- An skb dropped after WQEs were posted for it is held until they
  complete, and a connection whose WQEs were lost is resynced fully
  (patches 1-2).
- The context params are posted only for an skb that uses them, on the
  SQ of the connection's data (patch 3).
- The old and new SQs never execute together across a channels switch
  (patch 4).
- The TX queue of an offloaded socket does not change while it has
  packets in flight, in the stack and in the mlx5e queue selection
  (patches 5-6). An skb that still reaches another SQ meanwhile, e.g.
  after tc skbedit queue_mapping, is dropped before anything is posted
  (patch 7).

Patches 1-6 are fixes, for net. Patch 7 is for net-next, on top of
them. TLS 1.3 rekey support for device offload builds on this series.

Tested on ConnectX-6 Dx, with a software kTLS receiver that checks
every byte. The commit messages describe the reproduction and the
results of each fix.

Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@purestorage.com/

Regards,
Tariq

Tariq Toukan (7):
  net/mlx5e: kTLS, Hold a dropped skb until its posted WQEs complete
  net/mlx5e: kTLS, Resync TX fully after its WQEs were lost
  net/mlx5e: kTLS, Post TX context params only for skbs that use them
  net/mlx5e: Drain old TX SQs before activating new channels
  net: tls: keep the TX queue of a device-offloaded socket stable
  net/mlx5e: kTLS, Keep the TX queue of an offloaded socket stable
  net/mlx5e: kTLS, Keep a TX connection on one SQ at a time

 Documentation/admin-guide/sysctl/net.rst      |   3 +
 .../ethernet/mellanox/mlx5/counters.rst       |   7 +
 Documentation/networking/tls-offload.rst      |  20 +++
 .../net/ethernet/mellanox/mlx5/core/en/selq.c |  96 ++++++++--
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   2 +
 .../mellanox/mlx5/core/en_accel/ktls.c        |   1 +
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 165 +++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  21 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  88 +++++++++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   4 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  98 +++++++++--
 include/net/sock.h                            |  33 +++-
 include/net/tls.h                             |  13 ++
 net/core/dev.c                                |   3 +-
 net/core/sock.c                               |   2 +-
 net/ipv4/tcp_output.c                         |   7 +-
 net/tls/tls_device.c                          |   3 +
 18 files changed, 503 insertions(+), 65 deletions(-)


base-commit: fa5196392691051963726787944db872420dfa75
-- 
2.44.0

