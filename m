Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013035.outbound.protection.outlook.com [40.107.201.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72933431E7D;
	Thu,  2 Jul 2026 11:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782991139; cv=fail; b=Z58FXSUpisbzzR5PZxW+TP2XoeRYA+aTISo1+4DF9jufANit9tDHBeh0ryjnwLZDF9Cy99NDyhF5IvD3JKavY/7kIveEJK7PpJ0WNMCgxSrFDFE2y8gMSCMUH7LIOWo78Byi1UMqWlLMaopoYq1Iz3MuOLARq3g1wWlf1g5CcP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782991139; c=relaxed/simple;
	bh=L8YSkxS8oI32Yz1GR38dPndNDJv5uBrqqCohDzpt3c0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ard2Q5EFwlTnuISlea/HxxmaXXZfz0rVl+2ta+idqXOJPN4ljNuVxZ1NFZL9dki/4fFt85ypOwR7HFCTLx/quIBm9MTUm4GtRYjNX5PJBM6K1KqlWVstMdRIitynZbiDFEcCznGBogvPplUCylyoxcO2MqTxDQbyREI3UaxvEeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lfdsvNx5; arc=fail smtp.client-ip=40.107.201.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lfdsvNx5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uj8Hm6/6pRYnQ04qrxcr2v62Vlqjw1b7i8ttDQOKioGuRcV+qFgyJKA+mg1W8xMPK2oNkyqXvSA7CJMtCFKHT4/VJn2apYEGfxhOWqAG5nf1oQjRQyuc5GxkvdIRa6hKSF7VnIaS8OI1QAYC4vn+Pr5xa9/BJCkMT0zadogyIYtyB0FGp/fUH7gIMMXKkKvAUbxI6Od9ckKdo1lGQIoDj+UZJCHtdGMjFL2yP8ReuYGNJYP92J/4DxvcDajGlc6+TlBsf3Bg7GHx/FyS9B4AvOf1DzoGVrnAStxF5+6elShPYLu4uBZyivTgEWLTEekarGByyKyz4Hfp+sSoclKTBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oeuWF2y0LuirPGi2IWUXw8dm24aHoHveZDJf/RIuss=;
 b=IW2eq7J9qR0QtbLms/3uY2lF0kpCsIlOS8ChDwyJ+OUniTjZp9W47yj6aAEOJY9eBqoLpjpibZJ8yivE9PTwKqvUqncgXIeLca3E6/AB9MM2+xIRs3jPmXBFjopXnuBIR7vKTd2FZFIOxuEIbNzuy+ix6fNKub/hoKMCnEeZs84bBDk26gi3PtLVtgh/E4H4IAOJ40PFRg3uFVBNp3n0fzjZBao+B9mgJuQxH/I8nKpXO/912GFyb6iqTFLOWRqOFS/n3UetOkkgoHXdzb7rEcAmV6scZp1S7AkMjR0FR7bSufnd0c79T+J5kBas+DGm3R2DThVH/gQ+x7zZrFh3mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oeuWF2y0LuirPGi2IWUXw8dm24aHoHveZDJf/RIuss=;
 b=lfdsvNx55MNuSNeYrE9SHNPGshkzP9fX1IVcO+h4hqCceXii77Sc2+DpKVEI8gn3J6swYIStSLTiyLBPWZfzjywBJHKeU/W8nZuEZSsYuM2wloE9+dmQItSizIjUlRlBv+JMkxS6hKfhmr4RsOxLeJJU5V7Mn6v50UFBOjEn+n56Ir+f1Py2i1+m46iHvdvTHiXaxbnpSuF0XFkVHMr/I1mbtl+UYWRs6ar0WmCFO6AJzNquKyiiA6acoU0oSpS4pWB9swxvr34BoLMuKIvuvfhuIi3eDjkir4oZarCGcLSnsgtsFWVLanIl3c4Nl4PQzlEmj1f1UVvgyxlZnF/x7Q==
Received: from PH7PR17CA0069.namprd17.prod.outlook.com (2603:10b6:510:325::29)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 11:18:52 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:510:325:cafe::44) by PH7PR17CA0069.outlook.office365.com
 (2603:10b6:510:325::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.10 via Frontend Transport; Thu, 2
 Jul 2026 11:18:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Thu, 2 Jul 2026 11:18:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 2 Jul
 2026 04:18:35 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 2 Jul
 2026 04:18:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 2 Jul
 2026 04:18:29 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Adithya Jayachandran <ajayachandra@nvidia.com>, Chris Mi <cmi@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, "Jonathan
 Corbet" <corbet@lwn.net>, Kees Cook <kees@kernel.org>, Leon Romanovsky
	<leon@kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov
	<ohartoov@nvidia.com>, Parav Pandit <parav@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next 0/2] devlink: extend phys_port_name controller prefix to non-external ports
Date: Thu, 2 Jul 2026 14:17:24 +0300
Message-ID: <20260702111726.816985-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|CY5PR12MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: c722fd48-03f0-4e04-021c-08ded82bb1cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|82310400026|36860700016|6133799003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	giADkZxGEEzZLkuIz+PQq65DpM6IJLnRuhzV5x3TJ2uMp6iVnAlVFrV2vrux7RSEq1J3Ca7qnt/XZOCKKG7U/nngBFJ5sake3WSHCi7esedgfWK6ZIQc6yMX4XWZLZuxNyHi+SMGOa9f9ximQqEFdJ8JWNrJODOoh/1p9XX35/naMdM5G72zS8YkpG1ehzfrsGova50tPWFhGwAEB/A/3BK4Ca6UEJoiIZ3gvSfI8LSZPvsTmN55Rg3oiVZVzXrSAJDtLJqu87Vly9+M3FVbfp2cHBg9bQnv9SpkxjuuhPbqom2ykm8TtfFWOmphHsTGpZdV4bM/odPnoXJAp5UoQp6xeeudnmBlft9Pc5DqzTDg9PetjD0AbXAjPwAdpe1e990Bw/2oKzRoX+qShqTbWWgmlV7v9Lx3NhtR9RMM4gojW1dj8FH0kiJnBnIeHON+UO3z9m0CC6wIypchG/1gwuZA+xBSScKawx0YpLL0g6rUIbYfUTSaD7GNCvFApaB5m0XE6mFofR+VLRCcg1mD6DoIiXZZnkjwZkdoKuTtPBF831yS8XKy/JD77mBDOCNhz3sLW2bzckZg9HpAz+70gmLDD03VDgrSFjQEKguokhuYU2Oeo1/5QmUP5UHVTSmX4RzBJMA5D68Qyv2tvcBvd4eutQ/i5gsKvDy9EYGazbyx5weahkmdTEIaJsqh1tlw5hmz1+wYqvFZq5JxT/EBgA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(6133799003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ke3AS7P5pX3OEszPYn++akO0Iei/MmfFBsgc4bREVLEJWVI5Sq10rvP7in/n+UozpgT/1hF9jL1YRgRzBVe07XmH7FuYVWhARYPXTGj68LLoPH7t8V+HkRSbvaied7FwOBH6EP/Mboz9QUDktLm5GaFJMtAHgHrE/ij1kUTFCPwTewfvumCO5tJ3u6sBPbEKKNQ5nmktDhqC7cVWNi2PJn6yP4HxPYvQhWXaAMR5tZdFt4L+f8KvlIyeeVeBIc5KBMuoQYBsjC6EaT7X2a1fzMvwPvC0rFx48XQeoDZ2GU5F2zzDvkXSLKZayB8lJ86cU+gcbhascE8aMRNEpWVE4iW5mLGqVNrljbql8N72bT5sT/PiS1EbvzAajlsCC/bhv998flweyYJtLMLOb00gjUpIM5AWtmnaGAnOr9AJMPe/XQsQdX6fTb6UWlRn8/S6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 11:18:50.9689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c722fd48-03f0-4e04-021c-08ded82bb1cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383

Hi,

This series by Moshe includes the controller number in phys_port_name 
for non-external ports with a non-zero controller, and updates the mlx5
driver to mark satellite PFs as non-external.

The controller prefix (c) in phys_port_name was previously only included
for ports marked as external. However, newer devices can have multiple
controllers within the DPU itself, even within a single host
environment. For example, a SmartNIC may have additional local PCI
physical functions that are managed by the eswitch but are not on an
external host. These ports use a non-zero controller number to
distinguish them from the eswitch manager's own functions, while the
external flag remains unset.

Patch 1 updates the devlink core to include the controller prefix in
phys_port_name for any non-zero controller, regardless of the external
flag. Documentation and kdoc are updated accordingly.

Patch 2 updates the mlx5 driver to set satellite PF devlink ports as
non-external, since they are local to the DPU. It also distinguishes
satellite PF SFs from host PF SFs when setting the external attribute.

Regards,
Tariq

Moshe Shemesh (2):
  devlink: print controller prefix for non-zero controller
  net/mlx5: Set satellite PF devlink ports as non-external

 Documentation/networking/devlink/devlink-port.rst        | 9 +++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/devlink_port.c   | 7 +++++--
 include/net/devlink.h                                    | 6 +++---
 net/devlink/port.c                                       | 6 +++---
 4 files changed, 20 insertions(+), 8 deletions(-)


base-commit: 1c664ec4b9ea827b609d296921ed5bad8a40a158
-- 
2.44.0

