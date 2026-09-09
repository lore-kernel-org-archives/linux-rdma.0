Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC24C46C85B;
	Wed,  9 Sep 2026 23:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998268; cv=fail; b=oysep6DtTEhxHIZP1L7oMqh3ESJk0G8yO5D/wsy8fgJr3Abvn2Spt1Prt0L0yhIUi3MsDbuV5R4zHB9yX7Hxz69xFoYs00LGBRHR8YcQMJzUw2/L3GSgReS0NWmLT8pP2Istl5svwfhEKgtkAJJQvD5NjVVBO5QVGZwuoPGS/ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998268; c=relaxed/simple;
	bh=/w+ngRnd1kH+SxFgZw2c2bZ/bFKePf8Urop53h8Au7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=P6lS2wVk99lbt2xr7+lxgCGN4rNdqW7KpFKWLT4290+RGvJRMOD9ClBdpaOwJe9jjPyJm/GdkmB9ufgwJOOuZ3Jwv3yj+AqDt2Xe5ts90iE+CiUmfRVuT4lZkCDGfCNMAscTQidhPgDEhKi3CE/HIOIYPri1iuMkYkdriqFqokM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J+A3Psux; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J+A3Psux"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GjM1LJAgC2GYLQ4/c/ReboXvnBZmBhdCjYC0uitYSEvyNOErcq6+bKe4neSikmSOsLslKcG/lWlGPkWyImDCvDP1slP760PTEwvG4PgSdCI+rYJtwWMt9fiuXEmF1Pgb28J4d6bnkRGloj53GIpWbRKNM/M51pB9IxfnQjXGiOVdCZfJ2SDCpuyE6lHgZAEpG5wIGsPyLSQFzdSEqlsQkvuI96rQA2gxFdnzpnfnxPqkkd1Sh/o55wTx7go5wKFdnVuoeatyFPkXTKhXNFSiCWar9270i0c/n3oBBVVblqj2NoHmIn31Wm4J3q4muk4Lj07iQYYw1Z0t9D2ezqdtVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jfe01UndmrkEcZk8OgwaUlUkfvz8EN6XhxiCIShyxKs=;
 b=eUniQAbpbna2p6RhkMgC8EMQznT5JP2wJQn1tmGQMWBdWA6cIonQJV0X9IXuP9zUFbZ05F8R31oBNB92skm08Z7hwwE0xScdkLc4xuUPBabBnV8INDc8N0PsdHqD2rSMyqfBFEVy06TyTpRZVPtuNrocu8TK4GpBAnGiLJ3PQc1+56PelIqsO2FplQPUfGTg6mB8W6W/tJpf/9PhSh6w45/A69V2xlb6vAmr9TpwhDvQEgoNq92UqTUP2J9yClHN6/2+dOj5xHkqE18cdZqUeA8xMyyi+skK3zUOSYECCeOyx8c9/VudmajH0XhzUhGOTwv4hbHnvumg+ViciCMqYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jfe01UndmrkEcZk8OgwaUlUkfvz8EN6XhxiCIShyxKs=;
 b=J+A3PsuxjxCpjYEvvTWFL8l04zFS7c4cVX6zVSP550Qm7sTtSEWFLNg7x8Ohrc2erl3tq+1sr1609OvDP/6VilqUCi3xzpm9pHoY7B8XCMuqkeZXZ6nwqfB+jNRWtFqg4cHME5NIJagO16o/5xX6Qs5+1/7T7qjnJhB6qz4W0FeQo7aEwNZ9SruWMcW+RMTP5QnRUxgHjsoRgzWCwHjI7r/C45+m87lIhP4J3GkKFKERQqCyKXbhNd/4fJudpJ1dXFC68j8YQ5xKHjTanguPy/Tl8zpltflJjPwt6TNInDKxOlrQmzyZ2CmPEpUbt2DxC8xHdtploAkbMo2mZ45qiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 23:57:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:40 +0000
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
Subject: [PATCH v5 01/10] net/mlx5: Add IFC structures for CQE and WQE
Date: Wed,  9 Sep 2026 20:57:27 -0300
Message-ID: <1-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0434.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: a655e93d-29f5-4707-1234-08df0ece2047
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oqVH6Brv2fTt5KvA58QV68SqEpikPygk/jaNZQM29lLlHZ3Fgw+uC+6Ay22DvRaJ3nSrawkacqHdbQuEODlCbxkQqQJiTC0u8X6BvnZ5XaAagAsgdNVSt+0aaaMIcWUys0UVuS5M9cy5s0wCw84WNGPfZH1DZP6ahmA/DvxzujQ6wCGQGGmEUm4yfd3o1TXKhOkgrvQFX8WnahHyvdSjmmT4IMuOsRn/j5xx1TK7ZzWqiJ7R0VyJcu1bwkCC6/cSOpb8/TNPFxLTIrHtmTpWPLv6hqJzxhI/IIUv+vc+Q6qjxNsM5nr2swj9WjCkW6lYUmL6ODD3vDd4Xz1cgxJCERicPp1r/IztGDm+eDcIS5rY+csBDDV4ZSVc9mD1zxGHL0uGJQe0Em8OIY/UYu02Yqe+M6jLLChVFzIzbFElqbtya3TjseWGv9ArT+w4y69TBJekz9Zb2ElL5zqa+jtNkTmyx2oofxKG93HkUG/ZWNEJS9U75JQVMW+Iegpabrxk/nzvJKSyzhoIFEsZYmgtqe4ansixgU2k2d/XVN/LjN/0cYQcffGwcDueBriaXQSw7nTmQUKMwdQry2x/fN014SuHu9rG/4ezfjuFDCdsLlXGiywW4IwP2Ic8EyA8Cj0PIxhF8moNkJc7asROlsxnAxn9Pi8eyUdHiqW9Mqht72NUSoYcYaeRMtyXEsrKyRTbMlPMLzssXHQqBbkx5V9l2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KECbV06mPWgfk3qWEe8AJA/0s09uNqLQA429k/MXxIARU9dv7apZ1lfUhO5B?=
 =?us-ascii?Q?dYO5MaLoOsiDD0p76XqXSUyAQzc5CTL/yNU2fyUlFrCSmHDPVFCvlB9d1EHR?=
 =?us-ascii?Q?xqqhO7G4c+CPDB0l2uLhQ91LGuns6IDriTs6tjb5Jt3S2GWQMe8xJotZnVTl?=
 =?us-ascii?Q?vEkR83f7wYmHMyViHZOgmNGPF45EBUOQYovrmv1lxe9Ad7+D0+NC+7+5taEz?=
 =?us-ascii?Q?b/ai0jYQOU3a9o/hFBzqnovFKJHbrBmDwnxR4T/taVwFxbIxttu9zk2k0pn1?=
 =?us-ascii?Q?wcmKyoquIAbGSdQ/QyEjutYP0btSMLiIXTQ2TauJy6l3c7h9Wzx5PcaMONWW?=
 =?us-ascii?Q?corlPWRLqC1yfUjZTL7is+/YKQVNO023a8YVc/X7lA713PXe/uAijrxzABb3?=
 =?us-ascii?Q?TjOsmf41IrCzWhDBRr47gVVH4DMW6CyHhQ6ADHjCwYaIvGZK6pyzcf/cwSzm?=
 =?us-ascii?Q?fZjaFGmYQvCG20M9HvJLPq4tnp+nIzSlThFRifL50QZLFialVlPFkdDjT1qp?=
 =?us-ascii?Q?W810MJ0XhXsYFBRQj4vjZRcelL0atJhIgd7iyV1N1BwZtMBaVV6x+WD2Lksb?=
 =?us-ascii?Q?Av7jrPSeMKsJwkoRs12aQl0GnQHhyApFlw3G/Nmu+kvpTxQra/xo0xJ381ew?=
 =?us-ascii?Q?vCqSEPuecRhJCF8Bc2yxOzDDhIysCXT3kof9v1Dq8gQLDFSbtEe6K7v8J0IS?=
 =?us-ascii?Q?XP0Nrvlaf1Av2aitaEtY28bcAv0xf6AuN9+54WjUHskoJSy1KoJHUWGQA7Ga?=
 =?us-ascii?Q?IJsN0i6h/f3lDmIKfhJbnWphEyEFhGaW7ddI/mncvpCDESckt3+JXQ/Y8Y2w?=
 =?us-ascii?Q?u+pgPc0DocVhi0JboUYgli5Q0zMeEy+TrtOY0h10p2ULT1U+UCnEC3/esDov?=
 =?us-ascii?Q?/RKeomr7Jbd9LLVbIz0W7RFvo6/pPUFIFP+/QDf3ffo2dU/i3DhmNf/F8Z1R?=
 =?us-ascii?Q?GutP0887CSDFTAnKoE/TRkOrFUzFr+DFEKgSSTJjhZ6ipgGuCMuhJO16C46R?=
 =?us-ascii?Q?zTSkXUleAoBusKb09j+o++wWxhkoucUwsWQ7wzZpO3+EEwFbR4TpOM3yaIuv?=
 =?us-ascii?Q?YIgEvJJtK3kBxBbmHbulL8TneyxjXodatIromzhJqbMs6amlw3IHza7OBiZd?=
 =?us-ascii?Q?WhfXYxRPUb+ejdxy5X4fhg5QIKNjhZckJp3TbDWlc01BQyxs0Yuh3X02T6B1?=
 =?us-ascii?Q?JYXSKEBkSD8gdHvI7PssOXr04LM5Jo/xLwGYFAiWUbAyvf1Q++nzRM+n6/Bm?=
 =?us-ascii?Q?Jr9s17NtO0454Q7JBPbOU7yyghpFugUDmZVdyQbo02Cylkla2/rmaGlZaxFz?=
 =?us-ascii?Q?wftSjZ45MQAE9+wg79uBVkEujBbfDNnFcXuKbNi+lenU57WxgZlF9xhHUAhw?=
 =?us-ascii?Q?Fa7RYap9NiyZi1Y+obem0k1Wy+1L48N26djF3osv15b4ob2ltR6U23Jkwjyk?=
 =?us-ascii?Q?hsQ9j0USXLfiYHZ4s941spL/XSUclYxNBlFjN0GJDSqCblx49WEPFmQQ9ecX?=
 =?us-ascii?Q?wefYvH++LG6lqNjugwsz4M8DoDPuBkWBrLP8TPTdJMsrTfOz9Hot/NP8aE5F?=
 =?us-ascii?Q?R2ai1x82OglXiaCcEszBwAaiPY9WGH3qIf78ON5SLUtIhsyy/se30ZdpPWYb?=
 =?us-ascii?Q?XlKtATb5Da/NWQwD02SZJysUDc8qY3WoCaHpHxzx1v5lpegEPj19003vO5O8?=
 =?us-ascii?Q?jFF8h5gYvYmBRl5yhOYtv2ctfNaLUDQKgJ687dIHvN2t495n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a655e93d-29f5-4707-1234-08df0ece2047
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:38.2673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5x0cIZIDvO+uoS1HrccteOhN0B/c151pnk2pYzwQeWFKu/ru5k06v9vrCHQyfu2F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

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
index 12b9a81e562146..a3edc5ba1cd4f1 100644
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

