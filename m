Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F210646C826;
	Wed, 12 Aug 2026 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546777; cv=fail; b=b0ir5mAgZd58Gy2uCD88M/GmifsLUZTvyv+rtY/TRDaKADJgSblm/1ZAMAqvvLGfK2pP3Ko248ikAtLnCuwsCZeKelHa1H1nHb0DUoSV+fW6UwRAf7OoRBU0uZ1gkX5iHtlbMcc64fhLAqnJQQFRoj3QnbBQ16j1biVOWDaS+h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546777; c=relaxed/simple;
	bh=RNxftcYAWrzxIPfWdt0hRQcyqXniFFAC9b+HROvlWlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d1cSeBMlydcjXZLBRbBxhDljv51Adc6CSRQkFjCaVRXKRe4ALqNdWTF+yBhG43dSg+2mPXW6J9Eh1afBFtd48rY6mUPtyd1rVg3kJHLauHIZ1AhVfPhNl8iFzdHPtRTKUkfOa+L4MqQsB3ITpH0njVGjFQ4qV8qwnWgDOq2okBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qoXgCz4C; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qoXgCz4C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EkYHLPrF0u65Wrd7G60BegDd7E7LF+dmwUw7fUFAw3nXMZZDEYyD1iYtWZoWDNMtbqUDVK1h0jvN3A9M1UxoIec2fkcZtvPls6NHrNDG0At/n1LH2FZC2s//5iJOLidYqIwO9j4d1bW5wJoMjso4FoeleESqcPgYJJk60zcoVsD4Z32ovsvOF2I/KyIMOQ/K6dlQz1FS7UhWOGmiacvXp/c+YYlHcsUKaRQWFsD8QM8vXeWHOl9WwRzohZBZ2pkoEnr2m/BrXtUY6unHBBENPkX0jFOQd0I7yVD5JBChniCwnZajR7szTgERasIPsvjtMJfUOl9Lsn6wvsOuPZCmYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUN/a6w8yIfp6SLHmD687iLllmRcYxz7sJAAt6wpeDg=;
 b=yAKT8pOQto9vvXUVlR8OiwWLvhy6FabUovV3liCvr9iDufMRz0X4lmNUdSONsTxKwGApdhk5LOThJplzU+3TULNow0A18K4G9bW+fvLTI5Y1w3ee8/q98vSgdij23NJ3ZrOcGAOZGw7YSeHyQXvD6QttYrisf2mh9J9AbOS1NkjYqFdqTwvz5TYLMMDPR+gMRlajXzgNwAmHrzSl7yrBjuN6tmbw64lC/xIA7y1/1yLdFptuUVrSd2JarYVoURGiZUKc1M+kAGgEoW5yHZFNIR1K/JoKMGLe2N6M71VuLC0ansg2OHNQx8NL4moum/TIu+d+SokZkLDis9c2pxq/rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUN/a6w8yIfp6SLHmD687iLllmRcYxz7sJAAt6wpeDg=;
 b=qoXgCz4C/LfN1NS2UEq3+NXa7HWpNXGp24alBGk7fDxTNimk5/HKZdcnCGTOJAFVJKA0sQ685Lask/ew3enkZrWcMTlgYPtOK5ASGNhj3Mxcf5wLkdYetE2ZMl0IvzJX3HEg1mYgC6rGsu4h9yUD/XfRGZo1iIwdcfRtKtRebQnDxos51B9dKVYjDMTB9UqB3ht8VL3qkbTD2+0msYs8E9lO97jA2uWvoKtpyU0AX/ZtAx9bIYoecBUb85cOTb6bn17K1Ts/zcLk6ilTN7Sy+Bt3CgcjavdaPoNEbFVJI+MnJFF3EStUGP1TPADmpe3kfOBQNYEka0RIB7l1as/8IQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:13 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:13 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v4 01/10] net/mlx5: Add IFC structures for CQE and WQE
Date: Wed, 12 Aug 2026 11:58:59 -0300
Message-ID: <1-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0715.namprd03.prod.outlook.com
 (2603:10b6:408:ef::30) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: 051fe340-8bbc-4326-1c53-08def88243b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	d+qx3y864G+igISE70MMverKBxvu4srT3KeSJC3pz3Tx44ILRL9s3+6EUPX2VlvILlHHal6Y2EhNjElNg2KzavvXIr+WqF4yyQUV7g4VpV+yL4TwtwGgF4+awIXqtGZe7VKmu1nGLhHpfVW6fn8zKheNrOMDuYDr6I8cwDTFOSHfmQi5rmd9dyc4oZmT39ZQHRS15hNyDQPj0TZc3SvFa2488MDikAnfVrbTUxw4xFDhiLxL8T4fCXA80UjwhbcURkBnXqGjVI6HywqcnS58+bfZ/hCqZpHH+hdZlNIf+ovveOlAE0zXc2ZQIObb4ewrbxoCwtF5dqAQMvEpfNi7maGFq/p/afPNlKwUArpO+1lFaN/Ktin1ZnRMfJNe/Kv2vel4ldjM83UD1rXgwLS24n8DJoOGzTTY1OKsztQdyndZjnVxg8exmJGXs8K1DXsY+gJIq8TWSZzrQku8EvHmvXeaJGZBfaUUKFpDWzriTM81+LWIUhovWerOmnGgbPYhf14Kfjd6Iq9W+cqQEfKhWj6YfZqlPC1Ia3zlLF7SWjtLlmtw4Rz3YaLRjbpeR9G7nkm0PHn+UUeOxdnmF9cAWbADuZD5tCGpcBwGBZbsf66iEPmwysnNuZKxSrnK6Sqq1C4l1mu+aeW4ljLD3eFMaYJu1aKAZX/XVgt5j4ENJZiSG+CUZpSTuuKDMmuP/kHj2VyIfP+2xTDcNk90Zj/+Sg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X43RPx3vwZ9lzvO+tTVOC8vS1d31iWjd9BUpKKLqrdin1HGAQFwwv/9guSzH?=
 =?us-ascii?Q?PDXqZb/7rNU+HOIk2eJ+9/Quko9fPqYwYfveAlLJImycdUfYpu/z5adsS6PM?=
 =?us-ascii?Q?XlL/bcPWuBq0Optm6Rzvcjd4xnz78ByEhF3BOZrEp0ijtl0wtFFMAmiy2nCL?=
 =?us-ascii?Q?ddg6oG4HFvqkCQdjAsktd8UbxjIBUzAnBwYJAQoOD4nnn7s+ijnmqiXpjpm8?=
 =?us-ascii?Q?sTMFPVNvq27adqi2Ri0MXGvT41QB9BQPQlnzabkeJ/u2B0xqVYmHRg/1GYKE?=
 =?us-ascii?Q?fV1c44I0ihe31ERup0DQNJMwfVgiGJNxmCLRioxmMX8FlQvNewb2LQ1GebJP?=
 =?us-ascii?Q?4l0kNhuJ8tiDosCWvu2ZUh8QBYAX0/MNX7oN7Rb4Eox0p5uGg3fatSMZorJB?=
 =?us-ascii?Q?x/NaGXYLU7qvShW7MaCQ1zIQzAaMg1pFdSr6PyC5EaVzbJflRKbgBznrbue0?=
 =?us-ascii?Q?SRgmAQ2AKGU4AElFfWC7GF14lKiOeTS/kWAFDeokOsk19dPIyjD9mU+tstiw?=
 =?us-ascii?Q?vIIrNpn7Izrs+u8afXPflQP6+BD5V+Zt7juKk1LK8YlQOf1Vmmgh/B0Sh6Dw?=
 =?us-ascii?Q?Ff7DLJ4nRebYn1A/SxT+ApGrwRlcnUpS/aJHSPuq2FEX9bokhKPaYbR6le0Q?=
 =?us-ascii?Q?0ykIZP8DZvw++xwXtpuYfmzC7eMn+bbEya9C9MESmMC4lBjiJVGDBCq0eSW9?=
 =?us-ascii?Q?h4miM1VWi/obONztmxylCLgZulQ2vl0F9C/eaYnBKLXaQCufKleZiweqGk3B?=
 =?us-ascii?Q?eKpO4L/HcdwILA2TySiWuMmHmjZOVft8V+yM7yE2jIfb/jcZviIUN+TbrBW0?=
 =?us-ascii?Q?Ucleywnu3jG9bMKVrkSl9kLhLGPyOOtiKIkHGFc3ENR6eKtl+IpDu4VqfFHd?=
 =?us-ascii?Q?G78o3FH730mv/4sKvzXXilJxd5/A3UATcUEl/h1NNiw0MSZkfem2UP/jW065?=
 =?us-ascii?Q?l5nONFUi4t+XGCt51xXGv2gHGpOtrUqwBO90urw68v/9mOR9QwvrBLZO54TN?=
 =?us-ascii?Q?7niZmdFzzwaezz69WMN2UGPomxihK17uEtqbwxhiGDvtkhoOeVaJzEw0+R/i?=
 =?us-ascii?Q?CudGuPuFVL53I9uyoDIS5RnjsbKjEF9ntQ2gpoB8wF5d8SS4lAqLzksgX1pa?=
 =?us-ascii?Q?9YP90PnzyHiYjt9Jo+uL66bTPUDCr1wmzFmNX4JOvVe+0674s+1If0UjqclM?=
 =?us-ascii?Q?M+BwEe/diPRAK+Pu7TrnTfw5e7Z1jry5xuzSHvFRBMTRt6tfxL7RovWSffNN?=
 =?us-ascii?Q?cuJUKVgKm/v6Kod+OrAyzRodSJfmpaAux+ZTl4brAuNeJWU9reDJ1APrhTk0?=
 =?us-ascii?Q?dN+Xa2a7rVL59kpSG0A0CE99ukD05eJ49eolqOS8/F6lgOrNPN8mHqDrbPnz?=
 =?us-ascii?Q?307vvat8Ldi4ZP7f/EfiLtzrkVcAWnAXuJ7bLQVXBGAD4tTOF4so2vn8QmS1?=
 =?us-ascii?Q?idb2AymBFQm6pN6Ny6fbtiw1qTF92iyqTTwfSmJtz2PQfGyp08fVoE1BMImX?=
 =?us-ascii?Q?ktX2G8SNvAKvsi1xZTQ3fgGx/6Ay86tR93jnzSVMzM6H7oojitwIoVBkyi+O?=
 =?us-ascii?Q?1+/WFw6q3nSzR4JAK/K5xfjg2FjhkHg07G+Pfe3f71nxL46jbQpmhedKzG2k?=
 =?us-ascii?Q?+MrGY5k4ul/eOCeu0tUaW9qKZ6aOFii40Fd/Qk4lbN+PQrgGW17X/A/K2V+E?=
 =?us-ascii?Q?ARDRLECeR2+xYkenJiEDUZUBGOVgRYYmb670Rq9yu628fqXvr7QSGoMyoqD1?=
 =?us-ascii?Q?+czFqsCELA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 051fe340-8bbc-4326-1c53-08def88243b6
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:10.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zyq+Um9OJJ/+TZJRHYIONx5DgD3pzRHYuPAAHXYfpWzr+leNNy5SpjxFjGhc643s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

Building the WQE and CQE using the IFC system is easier than with a
C layout struct. Add definitions for their layout. Structs for:

  - wqe_ctrl_seg_bits (16B): WQE control segment
  - wqe_raddr_seg_bits (16B): RDMA remote address segment
  - wqe_data_seg_bits (16B): data segment
  - cqe64_bits (64B): 64-byte CQE with error syndrome union

The VFIO mlx5 selftest will use these.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 55 +++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 695c86ee6d7a3f..a83eb731764a0f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5979,6 +5979,61 @@ struct mlx5_ifc_cqe_error_syndrome_bits {
 	u8         syndrome[0x8];
 };
 
+struct mlx5_ifc_wqe_ctrl_seg_bits {
+	u8         opmod[0x8];
+	u8         wqe_index[0x10];
+	u8         opcode[0x8];
+
+	u8         qp_or_sq[0x18];
+	u8         reserved_at_38[0x2];
+	u8         ds[0x6];
+
+	u8         signature[0x8];
+	u8         reserved_at_48[0x10];
+	u8         fm[0x3];
+	u8         reserved_at_5b[0x1];
+	u8         ce[0x2];
+	u8         se[0x1];
+	u8         reserved_at_5f[0x1];
+
+	u8         imm[0x20];
+};
+
+struct mlx5_ifc_wqe_raddr_seg_bits {
+	u8         raddr[0x40];
+
+	u8         rkey[0x20];
+	u8         reserved_at_60[0x20];
+};
+
+struct mlx5_ifc_wqe_data_seg_bits {
+	u8         reserved_at_0[0x1];
+	u8         byte_count[0x1f];
+
+	u8         lkey[0x20];
+
+	u8         addr[0x40];
+};
+
+struct mlx5_ifc_cqe64_bits {
+	u8         reserved_at_0[0x1a0];
+
+	union {
+		u8         reserved_at_1a0[0x20];
+		struct mlx5_ifc_cqe_error_syndrome_bits error_syndrome;
+	};
+
+	u8         send_wqe_opcode[0x8];
+	u8         qpn_or_dctn_or_flow_tag[0x18];
+
+	u8         wqe_counter[0x10];
+	u8         signature[0x8];
+	u8         opcode[0x4];
+	u8         cqe_format[0x2];
+	u8         se[0x1];
+	u8         owner[0x1];
+};
+
 struct mlx5_ifc_qp_context_extension_bits {
 	u8         reserved_at_0[0x60];
 
-- 
2.43.0

