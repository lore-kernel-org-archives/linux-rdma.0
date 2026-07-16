Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC09436BF8;
	Thu, 16 Jul 2026 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221422; cv=fail; b=jcVPRChxXUoqXmQX6pdTmQM69QjjBmP+kR86E1cdYWqMldzok3M5xZEyK7SgQofmJXBoIcuUvTRlHkjNgS7y8ZJV77SYjlJ3Vou/QoLqj1gyX5lYVSHcEjr8eLUobPrFkRUJaX2w5ggCqByLYSxvrR+KX21q3WYsGhkLdzULndU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221422; c=relaxed/simple;
	bh=p5k3h3nz8992/L1FCZkT/zeh6nLSq74gYavpxhNdtp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aEcSZ9c31tEksMnR9XBs3t85H21t0eSOT2lAa4U2N4nzLnN0jte2hUeywJ/cUkf5D5PPR92vXEkTsJCT8e8nrZW+LAwxJ6GtCjNTbgaxqH3RidfT1vEXdspucTHKxPrbCNOqJai6lLJ1iB0B0uBc+Pdyz14QjkEUndBECkAvJBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MVYouV0D; arc=fail smtp.client-ip=40.93.201.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MVYouV0D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lfz9IU7SyrvzfzV49HwDagcmzyqqk8vZX0703fPPp4yepzLxpBneQeHnDC1WJqcUFUUn+/lq5tAzJWxNa/hOw8OXi72zS90hoCy8HQil4xWvKhMjlWJlbCgtHqQWtuRBkaMLdLmGngYt4/0CRNzjodfjx6qSAoD2OyHL3/2+gC5Bh8UprSrRT0E/hQ+d0+A6xKxQCgt57TqgYeVtfQCZ32k0SSVS2pDyTmDj8/C7VvHYxgHgDoCe0Zs83T0FO1X4FeHCpXPWM49X+5lt9pEN6/NG73VUxDhnQdBn65AJmTCrhcTy9icvh8neIVGhT2tbEKO57Ar9q2ROpobhGiymGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kr+Hvo7ZYjJktPS6MYM10egAkSmilei7LNFE/ZFMtt4=;
 b=TH7RnHs3k8X62Qjd6y0BLvhgfhJjEB2eM9jKeoY/VKoUhZyE98vkxd1p9AbZVyrfbnSHpgmWVC/zeQulKtN1YA4ubTLtVbhOpHAT55yvb+nTZC6tOVN3T5muwR6UnzbpGHtlUUcOjenw77tTjZy6n3zHVPQW/rxUIRg7wLs8prLyC2B/SF4R1KH0Um9hzvAWUpGZIhHEsnsvH0FyZEc5hb9le+01U6IkUzpHiLfoSez77HqgwdI3ntglZZj9arebBBurtwtJsgBzZLDL3axLRFcX5WwQBdUjsKrqqu555xMSelsa40tS83GW7PpKmXf+CYdcuscnNSPVjUN3KvPGDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr+Hvo7ZYjJktPS6MYM10egAkSmilei7LNFE/ZFMtt4=;
 b=MVYouV0DT6CYpnejhaERruaiyusjhPXZWBj0VBdpnF2vqrMvy6lxFwmpZvE4/GFfZ1koKBTuQP8zE6QUKWjMnDoNIHeZPVWjdbOKeHTVXrFoMk0MeS27qi7hcdGe8TUShH+VnmXEJNGPRG2uLSxSWnrm6LMAVg4tS3rKnsMvaPZ9X2loTrPQF2l4+lUXUsnaXDBg8XbGaIpOUvpuZMNlsz84OHo8hzRPjb4BcnpNkJwpTRtMZSSGP2F3QaZ2P1RBo9Xg8fW/fjsTM9hWLy3Mi6yooPmvZQmToIEWxUF9yfFSRdHGdfGm9eTiGRFj1RgvJoPpdvNf/+gPIO51PUrnBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB9731.namprd12.prod.outlook.com (2603:10b6:610:253::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Thu, 16 Jul
 2026 17:03:29 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3 02/11] net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
Date: Thu, 16 Jul 2026 14:03:18 -0300
Message-ID: <2-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::23) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB9731:EE_
X-MS-Office365-Filtering-Correlation-Id: 4508a427-3708-4fe3-e9de-08dee35c284e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|921020|22082099003|18002099003|3023799007|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	idZvFDQrAOGf3NpUpA4gwDiyffYBf4F82G9hvDdGd90SbJmISD6G0+iXdY1HZgY4rIGo1yap0FJIDhKoxJcGaDNQnsHIkVC2Puga3lzyX1nVuCta1YIWa59YTEAGI7gS4+7pn0ye/nUod4j+0thhUqW1DlUk7f2UulEhvdDB/FvuwGmkHOWFZRma3VZMXC72ZLhE8Bp6si2pCVy9+iInSCNJmFtE5b3E2r1K7NCVV3WBJJKx8zApN8TB8JaeeYhc4RTuoYJ1/A6NbTnKEFl1MhXXH/8jdtBnyXjR09Eq+Zm4qS4igQI96E8lMVYyt7Z9wX2ip77jenEEfZsWD4fNNUh1Ye09IjwOjTUsoM1vnO3e25JZTeka4JDqG6zd5SD+5wt5h67dF9MpFZOFRRK4/w26hQWHQDSQd/y16u0Qu1Scaws3vCgUNbXcwVXSVtsB80R6fJzaJ0P3ZHRf913W3CI+WDt5OjgFqQhlCAQ97ZOuGmTtoOvPQ1+K2x7omPoOf61MBAkyosHc7Xi3VSU9uJaq/SNTlNLvPGyobOIAZr4twVwwPR/JHldkr54MTde/9FfciqRHSsknymYO0LNTf+qMWRA2/cgvbkwzmQL1zydcVP/RkbwhTInlSZ36oYVqLxA3AFh6xPyb9QR62b7i9Ipu43GCdyq2QizzSepqm9lqPK7hgwP3vire797aBXyUFJHQf8GBK9bhfEIHlBfcJg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(921020)(22082099003)(18002099003)(3023799007)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XDlBaZMJB7A9IYsurCf5WS9K8ZneZS5IkcFsWori7w2/FPzGfIT30gK2GoVA?=
 =?us-ascii?Q?vBz7PbLRe5zv/jo1LF4fMHNRquXOlFWlC4avA6Ne8p4vREVeODzDgsqfYXZI?=
 =?us-ascii?Q?Ng8c8nQVmeiy9QdVq4PuTsqgZAzpdQZquK3duHBjkk6zfN5QJD+K8a/YQO1s?=
 =?us-ascii?Q?5AS3g5wVoa06nwlJqxoNjRiyQNLQUpMr+XJDrA0rHyfPGCYSO2++5uDlFQVm?=
 =?us-ascii?Q?w2nWZk95f7s0F/GB2LMNKVhNV9x8iiXIFA5WBCqNd0rPY4IDtLU6WGd1sCdl?=
 =?us-ascii?Q?V1Qwb+rNMdopwB+jY0b9k/s81u8W0p3lXRbRHYnTF5r22fDioDwaQj5+i83b?=
 =?us-ascii?Q?cy7E+YvZCoe11vBVgRPaNhm57EEi1oQ0epvPTB7/+Z/xf6eM2LCO/KY3duAH?=
 =?us-ascii?Q?1IZw1CDL4zkNVUz2QziEVIy4eHWLkTfq3qhsSv6ghygFo+V8nVogBye07Jmk?=
 =?us-ascii?Q?4YghuQhPx0nPvBEypdh7xSL7O+bPQYA3ECar+5II8OeO1vbQSmBixjEjrYyQ?=
 =?us-ascii?Q?t/tXrFtVQEFC3edgILTNZXsNiqfAFxW9UXUPIveAzpeuxTLknbZ8qxkRX/KQ?=
 =?us-ascii?Q?JyVtau0hSlG+Oj1IVtizD1wZvccHhi+f+nU+gq1lNeG2TVYwKlKsXqtLrsxk?=
 =?us-ascii?Q?vswJLv15nnPLu2Utx99Kudolgm76S1N1lGNgyJhSyIXS1VstF9MrlYE0x6g1?=
 =?us-ascii?Q?YrFRcIAWooN72O/e1DHXZwvWDzVxYdZGMC+gLJSgo5EkemyyKMFsa/33H4m1?=
 =?us-ascii?Q?3iPD3C8kXgGfklwLC70QQn/A/HNDy1GgPdXQXbNbEOK0oqugb3UtQjfldhTh?=
 =?us-ascii?Q?xnUSA6bTQKlw1PK64S7z0Ts0jDyzSCGGrE2tjw9THjCqK3t5kzppOBYBBzoe?=
 =?us-ascii?Q?9nIgyDldLwUxhM99oHLBYiLVuK0yW4eZkSqjNfO1VBMNZ8WKzxPOuhC/wc2N?=
 =?us-ascii?Q?7QK/DiSE7g4yl25AksHll8L2r67yhRxU56JGRTumaAYFvVS/L7RjRNTqczsj?=
 =?us-ascii?Q?nxyFe65rM8ssBlGJuFiWkcV3kB627gPIPkHGC9tTJ3AccKhIAIJmsVXNknRP?=
 =?us-ascii?Q?NV3TH1XYUof8xzLp4dgwVFX4aNilnSuwpFEYHtY1CU6qP86oa/aBGYJw10qL?=
 =?us-ascii?Q?CuTKxo57ro43J+77r0/6IGNiIhY1e7+rXFogwCzWexB2LNd2SGFQ22jjalOS?=
 =?us-ascii?Q?x+RzOGIBMUXBN+w7yjrxFbeLSU5pUyy5Zb2vFKljC3TtxgZ8EzB9UFrHvkMj?=
 =?us-ascii?Q?bgA5qA1THzRtdcxe3oa5EcDqZzgJG2874+++BMiBtOUmj7d7cnwckyo1Nwv5?=
 =?us-ascii?Q?HJ7ouRjfuJnuZeUYP93COli/7kTyxGjRNc1+YCGuLAGaF2P8l1JpTeW+xFl0?=
 =?us-ascii?Q?ZNkjtHwHMqPPYc7F7A/0Q/vKLaftuIH+aPl7rBaanHeyXq0Kzxa6wkHJ42tV?=
 =?us-ascii?Q?ZcwuVShze4tse/AS5NxDrYP4gJJjKbZ8cEr7J0U9uw6Qd5l8L57evPV20eBn?=
 =?us-ascii?Q?aVSicQvImz9/B3KWNFYz9vvpvw0BXswDUsLTNNEjVLMmb+TSgnJn465iHvPJ?=
 =?us-ascii?Q?BmeOz1Pr3sG5ct4tfFpzBsULrKXzB8+0/BPcUDMfmF1HipZN11LNOQ7r+m+3?=
 =?us-ascii?Q?F1j2js5BNtU6u4DNcsZRn0a4BS63cZMYJOXtQVPZbIbe7Q/f8wlz44nSvqrF?=
 =?us-ascii?Q?OtJD7q6y3qFOXUqgwMzzZL7ZRJ8P71svnxQGjecIPzyG18Vr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4508a427-3708-4fe3-e9de-08dee35c284e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:28.8191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTxdHUdSVmg24tgQMfuwrKMvnoMyoC7onRngIOGIqNPtuKLkRPO5L4Zmg4vEEe2S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9731

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
index 07a25f26429213..c739a1f578dc44 100644
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
@@ -1223,12 +1137,6 @@ enum mlx5_flex_parser_protos {
 
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
@@ -1506,26 +1414,6 @@ enum mlx5_qcam_feature_groups {
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
index a83eb731764a0f..2d4609aaa1068e 100644
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
@@ -11322,6 +11375,55 @@ struct mlx5_ifc_eqe_bits {
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
@@ -11364,6 +11466,27 @@ struct mlx5_ifc_cmd_out_bits {
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

