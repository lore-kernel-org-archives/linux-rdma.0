Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3878843D515;
	Thu,  8 Oct 2026 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466137; cv=fail; b=mdfZcQYhqn4ZtxX8MvrBR3AwySj1LzvfYP63Pxrbe48KIRIttovq09zISnp2YDyHJQFwr8J0opTT4c6WbcA7ZR7X5h7sflSQBN4HxJYEiCXOTh1mIOSKsUI7Gm7lmvWzRAwnAZ4DdqAb2r+WubIrApvDs/1Gwpd6dGw2KPckdfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466137; c=relaxed/simple;
	bh=83A34lLNx8RuXz9hOR9qlnEQfBVNLDhRJiqSKQ4rnI4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oExdnLOOzSZcS7xIPtiQVv5Q6oN4/A44UNu3WIRgbVgPAk+MyY8s0yCwA+BvqW0ty/E1d+/+eRh6a7XasJCJF5tgxz1/NaO1NbkSllHoJfckmzzWcP4RKAICAJ+2KoKayPXW2TkfYID7Igcx0544h0KCl+TfuhRZs31+1gzF6nI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cg1W+6/N; arc=fail smtp.client-ip=40.107.200.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cg1W+6/N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bF4JbYMHmnpvNv5Q63HB8KGlkHs3un7s67DFtAob/kwsZhWkYmff68qRMVdJ5j7G44CkD1xDXkTv30DDZ1bodzpt9/17zRXUV7X9Hc8nM57crHCI/zKlFciLvIqaoScjMcYPZHtPJwv9ibtkOhTcUitgUHKezQ6PYZCEgAJrx9NH6JsjE+6l+YwhyoSvJdDR/TKwJfXbg0Y9SjN+hEsv2wdEQFXjvyWQq5HuURpdHJOGtCw+SjED1TdxZtmChVvXceGBei37hW06QaN5rZFOsoMtK5qrERvnqF0qLDlggCM6CHOKfp5PWnAhvlgPzGEuDoLPyvom+gWU58+OnQcNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UknDRGspkVat2KX+hUjHcPm6VwhvzbIFWW4rIQQZ+qQ=;
 b=vvs3PEdCYAItW8rvMNRNFrXmEofcAveFlHqqY/Zn0qJsuittOLmAFTm4OtNJbVgVaETW0oFho1bg6jHrR3Z+MuzFrBwEwfJ4b0QqOUq7W4S0tgWCQHXmZxDtzseOYu25U1swJep4AHcxKjeFr48wna6oEuwJHRvjtCrRoyIEAmuTeYi9rN2gBCi0qN4xbTzEOhRTZ21qSzN68+9x6dyRo828q2GcnHkRg9wAi59yRZmtskj6V/iTU/DUiZc+c7zn+HJraXz4z+Sf9IRL1PuPV5MVRV9QszFWAmggiT9RFGu7t27Pc2kqGmttg/JHwPCUQcUDrN6FHahem4fg4EjjeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UknDRGspkVat2KX+hUjHcPm6VwhvzbIFWW4rIQQZ+qQ=;
 b=Cg1W+6/NwppZlH6205BX3HUlTOtGGEh62uIqjjBYry4lu6PxFsXAblwODMfUIzMyjCHYu8V9GdYJaUpf+RQ3cAko+fJFzc+Vx1unlHjAXzwF8R3nzqsN1qxRwsQ8TzlPsF16QzkRAVkZIYSU11gyKBugkPXtBh8LB3OiQ62iAL4b4mne1EmzBylPFV8nLnJAxq+dAxIvyoFkF0e5Bb9q58K72IopwhQfXnyGwxGVFZ6OYGlVtbyz0daA263PdPhZx76Q+glHXj1sHiHaZFaEla2inEo6nyVBmkHTT2pZudU5ykG+WYCbGwxyPy1R7FpnEmkaOwMBT+yQLGT8tlFo/g==
Received: from DS7P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:1ca::13) by
 MW6PR12MB8835.namprd12.prod.outlook.com (2603:10b6:303:240::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.16; Thu, 8 Oct 2026 13:28:48 +0000
Received: from DS2PEPF000061C2.namprd02.prod.outlook.com
 (2603:10b6:8:1ca:cafe::56) by DS7P220CA0009.outlook.office365.com
 (2603:10b6:8:1ca::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 8
 Oct 2026 13:28:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF000061C2.mail.protection.outlook.com (10.167.23.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Thu, 8 Oct 2026 13:28:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:27 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 8 Oct
 2026 06:28:27 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Thu, 8 Oct
 2026 06:28:20 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Byungchul Park
	<byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook
	<kees@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>, "Simon
 Horman" <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "Stanislav
 Fomichev" <sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>, William
 Tu <witu@nvidia.com>, Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH net-next 00/10] net/mlx5e: Add netdev support for data direct
Date: Thu, 8 Oct 2026 16:28:05 +0300
Message-ID: <20261008132815.654147-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C2:EE_|MW6PR12MB8835:EE_
X-MS-Office365-Filtering-Correlation-Id: 57846983-052a-498f-b5a2-08df254015ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|10067099003|56012099006|3023799007|6133799003|260925022911599003|11063799006|260925021311599003|260925021911599003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	xeRlmWpwry/8cy+Sdj9rxsGLKg95oM4auDagMWQgs0QXIa77bPQnP0cga3QMI0P4NttYmgIVZVQLigmo0KeiH2pLfpmwN6loh3ResnUvZ8AH4M6fd9PkDum0WVhT0fqprn0CRrRKpWpr8AUbEugQeQ7364GG05xVIXl6aN25p4PpnndxMoil1WOHCtn/rymwb9YG8yCqYmQhpi3y8/LxMzbEap+kPOX+rTZ30a04mII4KR0iMm3zUh/v6P45Kf9vau28LU5Nf3jcPuNkxDItp2mc2Lm1iq5uBcw/k58OaXA5iPuHIXuEvzklj2qUsLwM5FCK++O24hHXWAzna3u2BUn5QDCjfoCsTIsqwLLfvWY9siJcWIwdY6TQQtlZS1doJr8caq+4yG4WKqw6RQIxUru7ZmhVv4cRUxzCC/2Ic0CY2EwX3TkKIhQp9X4OxpbEw32dMle6F7pEd3T95D8ApBGECbWCr1VZ0jyOSq642LMUyXB06NudqMNekX+cLd9+qSNLc4FD/0J2CRq00XZ+PFysKv/8gRyTQBWYF+QKL+9pc3Go90um+yOUWiHikUmTrRGuxFG4GKmJKjMTSDuH+h8qimk68Fi2UJnWd56XzSO1aMV2LSKruz5+SIBts2C9lMiE5Y7OURjIDKSf7olGMN52zcHQFNhY+yyV4pylLnX+RZfXYWkOXRfzK6X/7tzYSp3GyR0YAfUX6JIr8rTwiA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(10067099003)(56012099006)(3023799007)(6133799003)(260925022911599003)(11063799006)(260925021311599003)(260925021911599003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y3GxxHlVRqEi1BKLN5ZbqPzbM0vOoIuPq1kA0lQJz3Vg73eVWNfkb7WKL/7n9labsQiNoex1ws9whTm/854+xWuqilj8Y6zdqkfxI7W+dB/TMyramU4Ku47oPF3p9q6Y3AWuD/6NZq05bjJC5lm4T9YvLlrxdv+puTAsTK0Tm8P+V0+p/x2O+7U2+5v/w4MJiLSR29MD3Ss1wZEOyv2d++AfmZeSsRBxbnnWDze6r2ciNKEuYHa05AL8WQHzaF0Jz9TLFlk3Bs57TLnqBApwnP+q4ML3wFflIeU5XgDiE6iOCsiVCr0l7v18dWtUOF8omo3135ubihQTQbkQwFAuB+tNkkqwRnlNm5HPGDRLOEVEA94cIdMpeuwO84flD2C0ijLAMAvSyMJDhNaFPGpsfadGvOVESwBwkZ7h2UXdST43BHbgak0/yAwLfcM3Wlet
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 13:28:48.0770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57846983-052a-498f-b5a2-08df254015ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8835

Hi,

This patch series by Dragos adds data direct support for netdev devices,
allowing a mlx5 netdev to issue DMA commands through multiple paths.
This feature is critical for improving performance and reaching line
rate in certain environments where issuing PCI transactions over one
path may be significantly faster than over another. These differences
can arise from various PCI generations in the system or the specific
system topology.

Data direct for netdev will work with devmem by returning the data
direct DMA device instead of the DMA device of the NIC. Each PF netdev
registers its own data direct device and support for RX and TX datapath
is added. The feature is selected through a new data direct priv flag.

The feature is enabled though a ethtool private flag. When this flag
is enabled, the driver will return the data direct device in the
ndo_queue_get_dma_dev op.

During data_direct device unbind, a re-creation of the channels is
triggered.

A note about the unbind: it does not does not tear down dmabuf bindings
attached to the data direct device; the recreated channels will still
pick up the binding via rxq->mp_params and post DMA addresses from the
data direct IOMMU domain to the PF, causing IOMMU faults. A devmem
revoke hook is needed to close those bindings before the switch. This is
out of scope for this series.

A note about io_uring support: currently io_uring rejects the
configuration where the dmabuf dev != page_pool dev.

Regards,
Tariq

[1] https://lore.kernel.org/all/cover.1722512548.git.leon@kernel.org/

Dragos Tatulea (10):
  net/mlx5: Log the data direct to PF device mapping
  net/mlx5e: Register supported netdevs as data direct users
  net/mlx5e: Pre-calculate UMR padding and entry size
  net/mlx5e: Add data direct ethtool private flag
  net/mlx5e: Add data direct RX infrastructure
  net/mlx5e: Add data direct TX infrastructure
  net/mlx5e: Use the correct DMA dev when data_direct pdev enabled
  net/mlx5e: Recreate netdev channels on data direct device unbind
  net: devmem: add netdev_has_dmabuf_binding() helper
  net/mlx5e: Enable the data direct netdev feature

 .../ethernet/mellanox/mlx5/core/data_direct.c |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  13 ++
 .../ethernet/mellanox/mlx5/core/en/params.c   |   5 +
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
 .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
 .../ethernet/mellanox/mlx5/core/en_common.c   |  38 +++-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  40 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 173 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  28 +--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   4 +-
 include/linux/mlx5/driver.h                   |   1 +
 include/net/netmem.h                          |  23 +++
 net/core/devmem.c                             |  30 +++
 net/core/devmem.h                             |   2 +
 15 files changed, 342 insertions(+), 24 deletions(-)


base-commit: 8df0638138d3e0344fd1fb36cf2d1ca1cf5028f0
-- 
2.44.0

