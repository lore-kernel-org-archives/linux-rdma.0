Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A194751FCAF;
	Mon, 21 Sep 2026 22:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030168; cv=fail; b=l9Oab4+tg1bTq4a7y04v+PUhtliHBBLbNVRsn3j/19Rfp9cO2JB9HxdRtk5WnQ3TGRKR9Ec4DbJAT5W+mwJQIdL5Bxrn7RjjU5f8pN5dm/69TSnfzaYnS//gx/DB4nSjGQJlL+H7sWZEkexkRsnPLLVy0uu8G+vmDqDkgUPLl0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030168; c=relaxed/simple;
	bh=M97+bpfeIRbTE/PrV/lt8BoPW0DYd6XEih6qZMFhnBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eh3B3UNCJECU4NzNYp6Bgx54rSlVA6rJ2+KzFX6xVoTiyXQNaa+JY5i8V+FPfE8xrDhcg+e53/tN2XrVHiia8oI6LYbMClikglWmZXv6EkW7059aDX9r0/9s5P2FeAOQaowB5r7Om5QysD10JwjSGBxKh5Hgzcv641WRN0l4iDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QnW5x0kt; arc=fail smtp.client-ip=52.101.53.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QnW5x0kt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OchOgir/HSZyPrmji/Sir7h8Zn6gQyp7Ibqz5ed5cANo2Khn5gRxTpiMnTP7WA/jEkBcXDZbhWH17i/1n9Lk7fTXC22GYBqAwBNar1geVDL56F6i/l7LmEnvgUKWE7+w5kJtnUlwBjbRUAYRilbcXHvh8nlU2NmpJ6TL3Ak2sntY1FzJRWKhrua9LiWBdJtLvKDk9wpBd9EWIP/2pCKz3MGiTjkY6ASzpr30KSwwV7esq1uEJvhjnZMcVKf/GMGlsyHRLxhfAtbz8DhRcsZOEBgp5O6esOOJFOAVctPheamGDktoTaxAU3BVCPdENFXN/v09VQNgggIelEXk3iFlTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WbKXozaP4x0kLB0tJQGgYerpSnEO+CkSIpZ12TrWDQ=;
 b=T8zqj5Cb8KP+bLB8ohh+C0oKSGUekX0CgvEynYbsDUUr6NtNSwz4TqpjopGmjKrsKtYMzwuS9Y95kW8U1uTxCPF91JpvVtk2cMbQHHeNb7pgwMDVkBCJJ5WZ/Ex7Lo8T01h9WLXZ12LXZ/BjwM4cU8HMtYf5NB3743sm8VHRLLXS0blhIaORdCPGqQ3pnCEv1Yzh1Y5RKpcTzhewsn5bYjLBzeLn7LW8H02ZyLwwPKnMdpF8Nu15Gq8lgc8RJAIo/nuUERcfqiFITXD0Cxj8IdCGMeqLpLgehtrMFqat+QHDIb1FKKmUNnKo0LtMCSpcaLDxWmuaHvLOd3UfGl/5wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WbKXozaP4x0kLB0tJQGgYerpSnEO+CkSIpZ12TrWDQ=;
 b=QnW5x0ktuMwOwRdKlpri3qFBgh7JcZpXD4u0JD8Apd8YYiM+YNdc6SyfSVKK9LzYFTgjyaq2W7lY3FX2CjgVpnaGODpQqnt+Ba/HFrBJ63Cvw90Dpo/+fcbRzibHMBdQ3WS2YzY3i8AFSbfBu5SH3a8K7rJUgWI43WyzS8A00EJJJDqOHzEjMp4xhboYORMMsv2a1NhCq6fYkjNiENLQYYJyPJWwKWdBHpXUuiusICi+e7isTc1xJA06N3Z1VUc8YkJPokKJ6yXazN2i2rxO2rquw1NAH9pIUvCul69JNyGZaGQlyRxh8wcQqcTNkb/XbMCf1TM83TeS9tTELpIMfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9144.namprd12.prod.outlook.com
 (2603:10b6:408:19d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 22:35:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 22:35:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sean Christopherson <seanjc@google.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v7 02/10] net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
Date: Mon, 21 Sep 2026 19:35:42 -0300
Message-ID: <2-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v7-c6d30e8ce1e4+3dfa6-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0358.namprd03.prod.outlook.com (2603:10b6:8:55::7)
 To CHBPR12MB731189.namprd12.prod.outlook.com (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9144:EE_
X-MS-Office365-Filtering-Correlation-Id: 00560fd2-5452-4dbf-7b5d-08df1830b13f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|7416014|921020|56012099006|3023799007|6133799003|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XxiBzDcAG6iIOKXEEAyIbXzYsH5Kx1SrwnEakrD52yp7n9rhLq2saMbf57rrVJGf9Ouj8ETyK7+ANwrs6jMFAtWJuH5Ve1vM7ai6CPzir3Ftbu8OdDVbU10m/YpmHhoqCs8edJT4pkbDau5ntywpNWptwDM3zyCSZA802MVp1Cen9tqGShbfvB9WgX/Ae2VsZ/+8njwDyc07ADVNHNY5bl0+EnUmVP0QokS4rTcdRH4RzI24gLTu2gUpMp68k7uqU0Wp7hrAKIPqv1ov3AWqirH2E8dVsxi8n0avQ4J/hZ+wDaZHXKqSXK3ThW1ZQc2GeZML8osPUn40cFgB2sTuCqXltR/aVVJN+LLXt/2zVVcP3FIFQDW0xt4XKHAMd06/yhnDM8clVBLjtHc37JVjIbRh4DMAI6PrzVAR0mfFzlaevaLjMtG7orYr11ZpvppjIWeqRNB/SSQZOwQX6MUuOGT3XKrrBHPWAOkbuJvGvhJYt2C20xvXcvQuiXnlZudaBYwbmI6iDDAPR4UDMWh0wyFkKkknNS1QfWw4fHN+f7fElxwcp7ngwKUBw9O+dLR8pY73BRFbjbrhEWJ/bcfTr+dzx8a3pNZRXh1Nh9d2KVJY83CIgjL8wehkR8yQh8eJHqERMqfRE3hzd8Mwcf1MfT0GP7u6Ser/pD4llmv6V5Qo79LzpH2blFYa0vruHhk3rY/7Dj2KF7WcGQZ7mJnPbg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(7416014)(921020)(56012099006)(3023799007)(6133799003)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Fo7XMQUkvVCyUycOjOnh/qozR42UpwKtKPd6+o10Ec/DF/WjYra+V/8muCFl?=
 =?us-ascii?Q?QMyyn7/piXB8zCBbdvr6N9nHqbF/kbuzdn0ia8B/LpFJc0dVDnbdeiwuOrXD?=
 =?us-ascii?Q?Z4xGRvKrxFD/ZbE/cid9t/UO2cXb7IiAupbTk/qfZjEMngjT2ahVNd4N3v0A?=
 =?us-ascii?Q?Cquc9359vcoRSZg5lOBmLiLB9SLdv3c4RyMW/dB8FEzzhrBKtdh6t/dbp3XI?=
 =?us-ascii?Q?24XVj6W+bhRPI6Q+8ZoQ6ISik0wSOXr8DX57kNjDlKEf8svNM7q4ZU8LT9+x?=
 =?us-ascii?Q?VysTua7HDoZzgbUn5ujXT1rStMZ3B+51ZfJjSK9NhcRSSsZst8B/QMxWnhEG?=
 =?us-ascii?Q?aWpb5ThGtUyfJEsXgOusQQzf5Z+H9W9PIpLfCKGQk3EoLewaY+7F3HGHH/Pj?=
 =?us-ascii?Q?icafM2YlOgSZKcBG3tOdnv/UR09G3JxOWCYXgRDNjTXjAXcRBkCxvQ4jn4/e?=
 =?us-ascii?Q?Z6uPU1Zt+NsRYhNz0GBA5SPfmBOxTbx9dKwBvq3tVBImbkFwL1nBkASsfJDn?=
 =?us-ascii?Q?7pJjmh0gH3/pxNpHvVG1JMnbjdditOT6YCDZqUGgqAEdFIvoCsUTJzw6bBdE?=
 =?us-ascii?Q?SEZ5WEMn3ySx44UQhdwvrK3YlthzesPgnviPTfafsEZ9xMUtrf+XqN9ZxNJV?=
 =?us-ascii?Q?HD5ErGRvGctosMqEYWRmrU904gwAvgFDOqqY1mCKW0Atu8Stvtq+OzeByD+x?=
 =?us-ascii?Q?fCCcRa7OeXrvayXeyqRyaO4Fc1v+VloF0g7ALehtLC2mqoWbB8Uf3QC9m40P?=
 =?us-ascii?Q?HEba/s43CC+FnA2V2t1Ga/pH4d/7WvaeuHEKJghBFQ0kE+j2gmj1FjFAjj8u?=
 =?us-ascii?Q?qNr0go5Dn2TGZnKPIA+LyZ6eMF4Dm4Mb7PNyKShH9qi+ZSZqY8CLYcmyZwRS?=
 =?us-ascii?Q?6jaGbfPMOyEzu7NSs9UOCFupH3q+ox/fy9ZmWg1+ZSuWNTrqknYK+us53I2e?=
 =?us-ascii?Q?WT4D0BOpKKyvcbmJAC19Ju/zUty+UzTTuiTw/TP7fm7Xy+W7HefTu4QAOF8G?=
 =?us-ascii?Q?RB+UfzrwZf3ePiWNIbMm5LO7D/OJ9Uh9Wp6eTa0EwRxfQsN/W/esxhgnOPAJ?=
 =?us-ascii?Q?IREpEZOFFio+8GhF74iEb+K71KigGiXx8mLIhMxI6HCQWyk5P9FWWX82ZUl9?=
 =?us-ascii?Q?NVYj65Xb7h43wVLvz6C9ec7UjWzWBR0GUhnd3P0AdvNYzkmy85vE9ffQjO4T?=
 =?us-ascii?Q?4C5Y7kgokg3jeXC0biEUVKbemx8jNz94WBUU1YzizohBWasjyin/M4bc0IHN?=
 =?us-ascii?Q?JITzoSVcPbP3M1SIlEXb2/iur06U4zpW9LExDeB8z1Y4nhLSBs37/2dlCATY?=
 =?us-ascii?Q?mud2gUrnzhBBnvZJteR8NL7Zz0IDzl3Z4enFMTpS+09EX79yKpKyHMtOzOCT?=
 =?us-ascii?Q?/QcKL5nRBbRlVkrdq7KNu15Ljo5UYLfayReNXiQPhag7Skd48TebKBgu0RsE?=
 =?us-ascii?Q?CE6OLga9AaCRQPdX1/+qovqaJMb2knSNNZx/PoWMruFE7bQwAGl7zbSzpyRy?=
 =?us-ascii?Q?Q8U9x3bHOHgooyJ01Tbxt7D6dofoRTnnuVcNvh99SIDj376arMcJeD5edb/f?=
 =?us-ascii?Q?DbK9k3KPVHd2plxvVzbd3ZXlV9hmoW9eewnakQ8M7rbfRLM3g4DOvtvZAG94?=
 =?us-ascii?Q?8UkFZEskc7davTX7QraUVcEswYPFCWhXP9uRotNVmZS2r1zDwTlKOjqAGT/n?=
 =?us-ascii?Q?yDgGALmjFpdH5pWdrSVMsz31afieabPH206Yj5AeHSEzGeUD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00560fd2-5452-4dbf-7b5d-08df1830b13f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 22:35:52.2445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LHvbqnDKrK2pfdRWH2mazgGY4ph0E1LC/tDnRpaPz0p3wkkRAoW+oCUcslEGrlwp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9144

Generally the IFC file should contain enums for the fields it
defines. Move the ones in device.h that are relevant to the VFIO
selftests over to the IFC file:

  wqe_ctrl_seg_bits.opcode: all MLX5_OPCODE_* WQE opcodes
  wqe_ctrl_seg_bits.ce: new MLX5_WQE_CE_* completion/event modes
  cqe64_bits.opcode: all MLX5_CQE_* CQE opcode values
  eqe_bits.event_type: enum mlx5_event (all event types)
  cmd_out_bits.status: all MLX5_CMD_STAT_* status codes
  query_hca_cap_in_bits.op_mod: enum mlx5_cap_mode

Tidy MLX5_PCI_CMD_XPORT which is an alias of
MLX5_CMD_QUEUE_ENTRY_TYPE_PCIE_CMD_IF_TRANSPORT.

No functional change. All existing users of device.h and cq.h
continue to see these constants through the include chain.

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mlx5/cq.h       |  10 ---
 include/linux/mlx5/device.h   | 114 +------------------------------
 include/linux/mlx5/mlx5_ifc.h | 123 ++++++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 123 deletions(-)

diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 9d47cdc727ad0d..a1c14479e462c2 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -81,16 +81,6 @@ enum {
 
 enum {
 	MLX5_CQE_OWNER_MASK	= 1,
-	MLX5_CQE_REQ		= 0,
-	MLX5_CQE_RESP_WR_IMM	= 1,
-	MLX5_CQE_RESP_SEND	= 2,
-	MLX5_CQE_RESP_SEND_IMM	= 3,
-	MLX5_CQE_RESP_SEND_INV	= 4,
-	MLX5_CQE_RESIZE_CQ	= 5,
-	MLX5_CQE_SIG_ERR	= 12,
-	MLX5_CQE_REQ_ERR	= 13,
-	MLX5_CQE_RESP_ERR	= 14,
-	MLX5_CQE_INVALID	= 15,
 };
 
 enum {
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 8cb321a9fb3d1d..8646303b029de0 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -172,7 +172,7 @@ enum mlx5_inline_modes {
 enum {
 	MLX5_MAX_COMMANDS		= 32,
 	MLX5_CMD_DATA_BLOCK_SIZE	= 512,
-	MLX5_PCI_CMD_XPORT		= 7,
+	MLX5_PCI_CMD_XPORT		= MLX5_CMD_QUEUE_ENTRY_TYPE_PCIE_CMD_IF_TRANSPORT,
 	MLX5_MKEY_BSF_OCTO_SIZE		= 4,
 	MLX5_MAX_PSVS			= 4,
 };
@@ -308,63 +308,6 @@ enum {
 	MLX5_EVENT_QUEUE_TYPE_DCT = 6,
 };
 
-/* mlx5 components can subscribe to any one of these events via
- * mlx5_eq_notifier_register API.
- */
-enum mlx5_event {
-	/* Special value to subscribe to any event */
-	MLX5_EVENT_TYPE_NOTIFY_ANY	   = 0x0,
-	/* HW events enum start: comp events are not subscribable */
-	MLX5_EVENT_TYPE_COMP		   = 0x0,
-	/* HW Async events enum start: subscribable events */
-	MLX5_EVENT_TYPE_PATH_MIG	   = 0x01,
-	MLX5_EVENT_TYPE_COMM_EST	   = 0x02,
-	MLX5_EVENT_TYPE_SQ_DRAINED	   = 0x03,
-	MLX5_EVENT_TYPE_SRQ_LAST_WQE	   = 0x13,
-	MLX5_EVENT_TYPE_SRQ_RQ_LIMIT	   = 0x14,
-
-	MLX5_EVENT_TYPE_CQ_ERROR	   = 0x04,
-	MLX5_EVENT_TYPE_WQ_CATAS_ERROR	   = 0x05,
-	MLX5_EVENT_TYPE_PATH_MIG_FAILED	   = 0x07,
-	MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR = 0x10,
-	MLX5_EVENT_TYPE_WQ_ACCESS_ERROR	   = 0x11,
-	MLX5_EVENT_TYPE_SRQ_CATAS_ERROR	   = 0x12,
-	MLX5_EVENT_TYPE_OBJECT_CHANGE	   = 0x27,
-
-	MLX5_EVENT_TYPE_INTERNAL_ERROR	   = 0x08,
-	MLX5_EVENT_TYPE_PORT_CHANGE	   = 0x09,
-	MLX5_EVENT_TYPE_GPIO_EVENT	   = 0x15,
-	MLX5_EVENT_TYPE_PORT_MODULE_EVENT  = 0x16,
-	MLX5_EVENT_TYPE_TEMP_WARN_EVENT    = 0x17,
-	MLX5_EVENT_TYPE_XRQ_ERROR	   = 0x18,
-	MLX5_EVENT_TYPE_REMOTE_CONFIG	   = 0x19,
-	MLX5_EVENT_TYPE_GENERAL_EVENT	   = 0x22,
-	MLX5_EVENT_TYPE_MONITOR_COUNTER    = 0x24,
-	MLX5_EVENT_TYPE_PPS_EVENT          = 0x25,
-
-	MLX5_EVENT_TYPE_DB_BF_CONGESTION   = 0x1a,
-	MLX5_EVENT_TYPE_STALL_EVENT	   = 0x1b,
-
-	MLX5_EVENT_TYPE_CMD		   = 0x0a,
-	MLX5_EVENT_TYPE_PAGE_REQUEST	   = 0xb,
-
-	MLX5_EVENT_TYPE_PAGE_FAULT	   = 0xc,
-	MLX5_EVENT_TYPE_NIC_VPORT_CHANGE   = 0xd,
-
-	MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED = 0xe,
-	MLX5_EVENT_TYPE_VHCA_STATE_CHANGE = 0xf,
-
-	MLX5_EVENT_TYPE_DCT_DRAINED        = 0x1c,
-	MLX5_EVENT_TYPE_DCT_KEY_VIOLATION  = 0x1d,
-
-	MLX5_EVENT_TYPE_FPGA_ERROR         = 0x20,
-	MLX5_EVENT_TYPE_FPGA_QP_ERROR      = 0x21,
-
-	MLX5_EVENT_TYPE_DEVICE_TRACER      = 0x26,
-
-	MLX5_EVENT_TYPE_MAX                = 0x100,
-};
-
 enum mlx5_driver_event {
 	MLX5_DRIVER_EVENT_TYPE_TRAP = 0,
 	MLX5_DRIVER_EVENT_UPLINK_NETDEV,
@@ -420,22 +363,6 @@ enum {
 };
 
 enum {
-	MLX5_OPCODE_NOP			= 0x00,
-	MLX5_OPCODE_SEND_INVAL		= 0x01,
-	MLX5_OPCODE_RDMA_WRITE		= 0x08,
-	MLX5_OPCODE_RDMA_WRITE_IMM	= 0x09,
-	MLX5_OPCODE_SEND		= 0x0a,
-	MLX5_OPCODE_SEND_IMM		= 0x0b,
-	MLX5_OPCODE_LSO			= 0x0e,
-	MLX5_OPCODE_RDMA_READ		= 0x10,
-	MLX5_OPCODE_ATOMIC_CS		= 0x11,
-	MLX5_OPCODE_ATOMIC_FA		= 0x12,
-	MLX5_OPCODE_ATOMIC_MASKED_CS	= 0x14,
-	MLX5_OPCODE_ATOMIC_MASKED_FA	= 0x15,
-	MLX5_OPCODE_BIND_MW		= 0x18,
-	MLX5_OPCODE_CONFIG_CMD		= 0x1f,
-	MLX5_OPCODE_ENHANCED_MPSW	= 0x29,
-
 	MLX5_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
 	MLX5_RECV_OPCODE_SEND		= 0x01,
 	MLX5_RECV_OPCODE_SEND_IMM	= 0x02,
@@ -443,19 +370,6 @@ enum {
 
 	MLX5_CQE_OPCODE_ERROR		= 0x1e,
 	MLX5_CQE_OPCODE_RESIZE		= 0x16,
-
-	MLX5_OPCODE_SET_PSV		= 0x20,
-	MLX5_OPCODE_GET_PSV		= 0x21,
-	MLX5_OPCODE_CHECK_PSV		= 0x22,
-	MLX5_OPCODE_DUMP		= 0x23,
-	MLX5_OPCODE_RGET_PSV		= 0x26,
-	MLX5_OPCODE_RCHECK_PSV		= 0x27,
-
-	MLX5_OPCODE_UMR			= 0x25,
-
-	MLX5_OPCODE_FLOW_TBL_ACCESS	= 0x2c,
-
-	MLX5_OPCODE_ACCESS_ASO		= 0x2d,
 };
 
 enum {
@@ -1224,12 +1138,6 @@ enum mlx5_flex_parser_protos {
 
 /* MLX5 DEV CAPs */
 
-/* TODO: EAT.ME */
-enum mlx5_cap_mode {
-	HCA_CAP_OPMOD_GET_MAX	= 0,
-	HCA_CAP_OPMOD_GET_CUR	= 1,
-};
-
 /* Any new cap addition must update mlx5_hca_caps_alloc() to allocate
  * capability memory.
  */
@@ -1507,26 +1415,6 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_PSP(mdev, cap)\
 	MLX5_GET(psp_cap, (mdev)->caps.hca[MLX5_CAP_PSP]->cur, cap)
 
-enum {
-	MLX5_CMD_STAT_OK			= 0x0,
-	MLX5_CMD_STAT_INT_ERR			= 0x1,
-	MLX5_CMD_STAT_BAD_OP_ERR		= 0x2,
-	MLX5_CMD_STAT_BAD_PARAM_ERR		= 0x3,
-	MLX5_CMD_STAT_BAD_SYS_STATE_ERR		= 0x4,
-	MLX5_CMD_STAT_BAD_RES_ERR		= 0x5,
-	MLX5_CMD_STAT_RES_BUSY			= 0x6,
-	MLX5_CMD_STAT_NOT_READY			= 0x7,
-	MLX5_CMD_STAT_LIM_ERR			= 0x8,
-	MLX5_CMD_STAT_BAD_RES_STATE_ERR		= 0x9,
-	MLX5_CMD_STAT_IX_ERR			= 0xa,
-	MLX5_CMD_STAT_NO_RES_ERR		= 0xf,
-	MLX5_CMD_STAT_BAD_INP_LEN_ERR		= 0x50,
-	MLX5_CMD_STAT_BAD_OUTP_LEN_ERR		= 0x51,
-	MLX5_CMD_STAT_BAD_QP_STATE_ERR		= 0x10,
-	MLX5_CMD_STAT_BAD_PKT_ERR		= 0x30,
-	MLX5_CMD_STAT_BAD_SIZE_OUTS_CQES_ERR	= 0x40,
-};
-
 enum {
 	MLX5_IEEE_802_3_COUNTERS_GROUP	      = 0x0,
 	MLX5_RFC_2863_COUNTERS_GROUP	      = 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a3edc5ba1cd4f1..8247cb0f8dfd64 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5999,6 +5999,39 @@ struct mlx5_ifc_wqe_ctrl_seg_bits {
 	u8         imm[0x20];
 };
 
+/* Values for wqe_ctrl_seg_bits.opcode */
+enum {
+	MLX5_OPCODE_NOP			= 0x00,
+	MLX5_OPCODE_SEND_INVAL		= 0x01,
+	MLX5_OPCODE_RDMA_WRITE		= 0x08,
+	MLX5_OPCODE_RDMA_WRITE_IMM	= 0x09,
+	MLX5_OPCODE_SEND		= 0x0a,
+	MLX5_OPCODE_SEND_IMM		= 0x0b,
+	MLX5_OPCODE_LSO			= 0x0e,
+	MLX5_OPCODE_RDMA_READ		= 0x10,
+	MLX5_OPCODE_ATOMIC_CS		= 0x11,
+	MLX5_OPCODE_ATOMIC_FA		= 0x12,
+	MLX5_OPCODE_ATOMIC_MASKED_CS	= 0x14,
+	MLX5_OPCODE_ATOMIC_MASKED_FA	= 0x15,
+	MLX5_OPCODE_BIND_MW		= 0x18,
+	MLX5_OPCODE_CONFIG_CMD		= 0x1f,
+	MLX5_OPCODE_SET_PSV		= 0x20,
+	MLX5_OPCODE_GET_PSV		= 0x21,
+	MLX5_OPCODE_CHECK_PSV		= 0x22,
+	MLX5_OPCODE_DUMP		= 0x23,
+	MLX5_OPCODE_UMR			= 0x25,
+	MLX5_OPCODE_RGET_PSV		= 0x26,
+	MLX5_OPCODE_RCHECK_PSV		= 0x27,
+	MLX5_OPCODE_ENHANCED_MPSW	= 0x29,
+	MLX5_OPCODE_FLOW_TBL_ACCESS	= 0x2c,
+	MLX5_OPCODE_ACCESS_ASO		= 0x2d,
+};
+
+/* Values for wqe_ctrl_seg_bits.ce */
+enum {
+	MLX5_WQE_CE_CQE_ALWAYS		= 2,
+};
+
 struct mlx5_ifc_wqe_raddr_seg_bits {
 	u8         raddr[0x40];
 
@@ -6034,6 +6067,20 @@ struct mlx5_ifc_cqe64_bits {
 	u8         owner[0x1];
 };
 
+/* Values for cqe64_bits.opcode */
+enum {
+	MLX5_CQE_REQ		= 0,
+	MLX5_CQE_RESP_WR_IMM	= 1,
+	MLX5_CQE_RESP_SEND	= 2,
+	MLX5_CQE_RESP_SEND_IMM	= 3,
+	MLX5_CQE_RESP_SEND_INV	= 4,
+	MLX5_CQE_RESIZE_CQ	= 5,
+	MLX5_CQE_SIG_ERR	= 12,
+	MLX5_CQE_REQ_ERR	= 13,
+	MLX5_CQE_RESP_ERR	= 14,
+	MLX5_CQE_INVALID	= 15,
+};
+
 struct mlx5_ifc_qp_context_extension_bits {
 	u8         reserved_at_0[0x60];
 
@@ -6530,6 +6577,12 @@ struct mlx5_ifc_query_hca_cap_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+/* Values for query_hca_cap_in_bits.op_mod */
+enum mlx5_cap_mode {
+	HCA_CAP_OPMOD_GET_MAX	= 0,
+	HCA_CAP_OPMOD_GET_CUR	= 1,
+};
+
 struct mlx5_ifc_other_hca_cap_bits {
 	u8         roce[0x1];
 	u8         reserved_at_1[0x27f];
@@ -11325,6 +11378,55 @@ struct mlx5_ifc_eqe_bits {
 	u8         owner[0x1];
 };
 
+/* Values for eqe_bits.event_type */
+enum mlx5_event {
+	/* Special value to subscribe to any event */
+	MLX5_EVENT_TYPE_NOTIFY_ANY	   = 0x0,
+	/* HW events enum start: comp events are not subscribable */
+	MLX5_EVENT_TYPE_COMP		   = 0x0,
+	/* HW Async events enum start: subscribable events */
+	MLX5_EVENT_TYPE_PATH_MIG	   = 0x01,
+	MLX5_EVENT_TYPE_COMM_EST	   = 0x02,
+	MLX5_EVENT_TYPE_SQ_DRAINED	   = 0x03,
+	MLX5_EVENT_TYPE_SRQ_LAST_WQE	   = 0x13,
+	MLX5_EVENT_TYPE_SRQ_RQ_LIMIT	   = 0x14,
+
+	MLX5_EVENT_TYPE_CQ_ERROR	   = 0x04,
+	MLX5_EVENT_TYPE_WQ_CATAS_ERROR	   = 0x05,
+	MLX5_EVENT_TYPE_PATH_MIG_FAILED	   = 0x07,
+	MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR = 0x10,
+	MLX5_EVENT_TYPE_WQ_ACCESS_ERROR	   = 0x11,
+	MLX5_EVENT_TYPE_SRQ_CATAS_ERROR	   = 0x12,
+	MLX5_EVENT_TYPE_OBJECT_CHANGE	   = 0x27,
+
+	MLX5_EVENT_TYPE_INTERNAL_ERROR	   = 0x08,
+	MLX5_EVENT_TYPE_PORT_CHANGE	   = 0x09,
+	MLX5_EVENT_TYPE_CMD		   = 0x0a,
+	MLX5_EVENT_TYPE_PAGE_REQUEST	   = 0x0b,
+	MLX5_EVENT_TYPE_PAGE_FAULT	   = 0x0c,
+	MLX5_EVENT_TYPE_NIC_VPORT_CHANGE   = 0x0d,
+	MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED = 0x0e,
+	MLX5_EVENT_TYPE_VHCA_STATE_CHANGE  = 0x0f,
+	MLX5_EVENT_TYPE_GPIO_EVENT	   = 0x15,
+	MLX5_EVENT_TYPE_PORT_MODULE_EVENT  = 0x16,
+	MLX5_EVENT_TYPE_TEMP_WARN_EVENT    = 0x17,
+	MLX5_EVENT_TYPE_XRQ_ERROR	   = 0x18,
+	MLX5_EVENT_TYPE_REMOTE_CONFIG	   = 0x19,
+	MLX5_EVENT_TYPE_DB_BF_CONGESTION   = 0x1a,
+	MLX5_EVENT_TYPE_STALL_EVENT	   = 0x1b,
+	MLX5_EVENT_TYPE_DCT_DRAINED        = 0x1c,
+	MLX5_EVENT_TYPE_DCT_KEY_VIOLATION  = 0x1d,
+	MLX5_EVENT_TYPE_FPGA_ERROR         = 0x20,
+	MLX5_EVENT_TYPE_FPGA_QP_ERROR      = 0x21,
+	MLX5_EVENT_TYPE_GENERAL_EVENT	   = 0x22,
+	MLX5_EVENT_TYPE_MONITOR_COUNTER    = 0x24,
+	MLX5_EVENT_TYPE_PPS_EVENT          = 0x25,
+	MLX5_EVENT_TYPE_DEVICE_TRACER      = 0x26,
+
+	MLX5_EVENT_TYPE_MAX                = 0x100,
+};
+
+/* Values for cmd_queue_entry_bits.type */
 enum {
 	MLX5_CMD_QUEUE_ENTRY_TYPE_PCIE_CMD_IF_TRANSPORT  = 0x7,
 };
@@ -11367,6 +11469,27 @@ struct mlx5_ifc_cmd_out_bits {
 	u8         command_output[0x20];
 };
 
+/* Values for cmd_out_bits.status */
+enum {
+	MLX5_CMD_STAT_OK			= 0x0,
+	MLX5_CMD_STAT_INT_ERR			= 0x1,
+	MLX5_CMD_STAT_BAD_OP_ERR		= 0x2,
+	MLX5_CMD_STAT_BAD_PARAM_ERR		= 0x3,
+	MLX5_CMD_STAT_BAD_SYS_STATE_ERR		= 0x4,
+	MLX5_CMD_STAT_BAD_RES_ERR		= 0x5,
+	MLX5_CMD_STAT_RES_BUSY			= 0x6,
+	MLX5_CMD_STAT_NOT_READY			= 0x7,
+	MLX5_CMD_STAT_LIM_ERR			= 0x8,
+	MLX5_CMD_STAT_BAD_RES_STATE_ERR		= 0x9,
+	MLX5_CMD_STAT_IX_ERR			= 0xa,
+	MLX5_CMD_STAT_NO_RES_ERR		= 0xf,
+	MLX5_CMD_STAT_BAD_QP_STATE_ERR		= 0x10,
+	MLX5_CMD_STAT_BAD_PKT_ERR		= 0x30,
+	MLX5_CMD_STAT_BAD_SIZE_OUTS_CQES_ERR	= 0x40,
+	MLX5_CMD_STAT_BAD_INP_LEN_ERR		= 0x50,
+	MLX5_CMD_STAT_BAD_OUTP_LEN_ERR		= 0x51,
+};
+
 struct mlx5_ifc_cmd_in_bits {
 	u8         opcode[0x10];
 	u8         reserved_at_10[0x10];
-- 
2.43.0

