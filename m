Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C34D52FE49;
	Wed,  9 Sep 2026 23:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998279; cv=fail; b=ahedBrxoXCwVNhZvo8YQd4/xCMWd2v/wCC9UEm52P9Jlf2qJJhjXSylE6iULlpcmYVQH48b615iYoeeYjbr+oNuinDc9x/D4wBKwIth1k8lkymsVN46fZhN3fytrSIrfpgIDz+0nPzRD8uO+74cesUnK4owRx1IlR7p+v+8tvFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998279; c=relaxed/simple;
	bh=M97+bpfeIRbTE/PrV/lt8BoPW0DYd6XEih6qZMFhnBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EgXWuM2TaYG4M+v6bwcCGKHgwuEf9NjRPqvANdpgg2+LRCpYA9UmYQ5ST6vTB0dr3pKCgO7AS+agJz7y6qI//QbYRW+OwpHYPD/EW7E+wHp+N9DHxVQdy9BFqgjJg56AopB9FNfhsOzxC94GPyHG6YcIKXn6XVHTJNL/UdElE7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YB6Fjg6b; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YB6Fjg6b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wuhaBHNOrQ8pMuOLru4AC6vnSzYfHsntAR9VpA11bn+YMebEGPZrkCu4ncn2GjNLvH5HClh3WGuwuwSAaqph1HC56DKq7nwWSqejZUQfbY8qKp2pYsnS69EI4YVdpiVe1+rG5jq8EARjN0aWiLxXjeBKNNi1J3qOBD9ZG0QpERyZ2x+enPLytPpb8vcwGXhBL02iGkUbBepyFCEy9/kXIgXCrWYRCIvpBc9mPDY0y12tgVzFgp1ieD6x0/IyWkoOf2Wyinvtq8EwSxj7gQ55k0yK9mIBvfBOLzPHWJANC8N470581KC9cnADR1Uci0E77/rYd91s+J3rJ2eYa/EgRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WbKXozaP4x0kLB0tJQGgYerpSnEO+CkSIpZ12TrWDQ=;
 b=VA8Y6+1DAN9XFHxHZaPTvSKK9R8X7QHKWvh0uZq6WomAvoBfWdqpsnEu3hlh4xdWr1lW6VSWt8V+UzbJQc52Q4a74PUYn3hVZlmKyLy7yf/zSR0McQQLaeZonJttmNaKR5ivuARSv0W4uABJpurmhFtHrQXk7hZNL/RH3XqkTMFOClRmPykcD4lOXT6yb4Dbjch/DrA1xM9REfrbKBAysx8LLtMcO/I8mRScrMWYtBJHFLGk2Hes8PqKB9e9tFeFXQQqbAk4GL3e4u2A7nuflTwjgfTNib0eQQVsXK1ZX9e7My+duuywiuy56uWZ3qdkT/CbejMW6zZtQYMlPzfGwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WbKXozaP4x0kLB0tJQGgYerpSnEO+CkSIpZ12TrWDQ=;
 b=YB6Fjg6bnsBHj8RmzBBGZH+EV/dE7YY5efpnZ1eDHPcUPhMNxtxApboN5CpHtewvoj8adG42+Br70jHvgfOwi2UN4CyubYgsZNa/2fLiAKWsQq+76/GmjmqLI3IIgdOdDaqQjpBaD1hkPxUGRYBu2VlGa4J7mfs4Iq8Fkh3iUh3qcW1FTQflVLg+jGWyrtAaHWoPBJUEhAEk7ozvhjjYYybf31zOdoiF03V5g+iwh3C0pX8BW/hfD+QNQOXTRBc8R4XMP+mhdhrDi3pP5k+We+IaWuIABaAbdPtrHkVLw6Iu+//CfOIC8MfN+lPZZzwmd+nnYIM+Y2gU+B60+jQAPA==
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
Subject: [PATCH v5 02/10] net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
Date: Wed,  9 Sep 2026 20:57:28 -0300
Message-ID: <2-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0007.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: cba5d906-4cc6-4c10-350c-08df0ece20eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|921020|6133799003|3023799007|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	iIMR5LtA5MwOmyVko66GcOuwW/EDH86RUYNtdNUtmTWku7POTkprv/kWD1hDuUiZB58EXiPVUy2EjgaoQ+Q8Pyn90Y0Ck4elwUXPVd5pvYV7U54M762rzzqr1L32/8JP53DqgL2TNAFuibbVQ5jPL32HM2FqAkCnkQLRfZSc6tdP8lRZDXsHdatqbD0+9XMLz5ZJNQwXdVQYmXM1qsHIpTs1hw8qTXn/0ZqEu5ngrnI/oxV6Bli7BoaHc/oFg8u7UwI+AOqP0xEe0ozE2W/c5M8FDrbr1/kdp8aGf6yQj6W1FnJU3ntWzfJt29dY5OXot+1XJEQfiNdy73pM58CnZ5nuRD/8pisxfUG5U6UP0tXbLn3j01ZYiU1cBhJ8tLUxoitM7wBWBE6TAj+PlP9Liwua3Qz2s3XGWT/se2/czuYxIGmloWsfUpiwopdyEsaOm7Pdx2cs8x7tSWvQgvn64QEAX3BsA/LXRvWuQlnEcjCTf1enMadrB2sed+KdB5fS24iuAfBRXCXhmq6yetBIc6JSrdLep1Z1P+2VaYlmc+zo99svkgEuX9hHPoVDWXwV3MR6PxFrAvYOnFuBA77i2LP52IghS1ajMQVAaaNYZsCDyuLUwhXUnsyst7bkQwJsDrV/knRYgeRB7ootSNYjNFEr0HulOI3B+WAtl+HuoCHubx9KDYao5DwLyvbSprMrpF55guXW1cnEw7Wf8YQWpw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(921020)(6133799003)(3023799007)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6dcUBFy4CU7K2JSefs0DPxJ6N4v3gZFTje0fVvG4v4ObIQMpITaZqmx/cfp3?=
 =?us-ascii?Q?PaloZsDCGOf4KIeFTSs4NvVDXWk9rDKksqu0+NY0U8puhuM8zPczoGOAn8+7?=
 =?us-ascii?Q?HhxKklcJPLP25xfXBNrMxXIk8oKGpP3upP9g8vFuaj0WZbNkgn8Mj0YAUaUW?=
 =?us-ascii?Q?NkasoSyQ2lv3Q3Ch0XKI15jQA1IWhCc04+826tCEJ7iMEEcCr5E1XzNNhbMn?=
 =?us-ascii?Q?jmzLEK7cB+LZXNZrducTw+ugcYydWIleaJfB6LH94H2zQ4HWiwNPJvWQO7BG?=
 =?us-ascii?Q?kmUE2u/UCzhHznq/s5DGtDzyyK+SXrphSnnHbkoCj4IxzLUGcYmbQTj+J/qT?=
 =?us-ascii?Q?0WzrjZTHg0RI5BBtU1d/6JI0F7MDU5P/6XZ/e3bSeZCYq/2KPPGoRDNNMNyc?=
 =?us-ascii?Q?fjEYVfjsbDGzFyAEk3ocyj31V9wDSvQG3EsggvdETghurj1kCXyQ+8WJxxCU?=
 =?us-ascii?Q?n2nVuDGghUYLIjEzmyAZO0bc9iwKDh6PLvzhEIvtc57N68mQOev7MWfI3WjZ?=
 =?us-ascii?Q?2opUFjTy2+M+sl8DiHnI4m1N3zLRAQxfq/ZKOgAOVaajyv5fXOLvPasMN9qT?=
 =?us-ascii?Q?0iyfSXyDIuDUpJ1oxDgBp5skAonr18o1W1pVrGXSooHs41xAzzuw9CVM1bbE?=
 =?us-ascii?Q?rV+AFAA8/AQsIOVpLCIBIfbzmBFRFpaksL0/2gM/atdyRBgLd4dyG1BMHkV9?=
 =?us-ascii?Q?koIREzVUl9QEDgN+Rky+Uqw/Nl8/by0x0Fjo6zEnDKaGo860EIvIMr5pcZny?=
 =?us-ascii?Q?b8yIMQhH/KAB2OCKygxIQQ+oLPx4IOnY7dRaDFa/BYEaXObQYmn/DUs1Ruyf?=
 =?us-ascii?Q?yheOEfTXDOfcfUMBKWFT/MIxx0EVYlz6yH1EJcVicIK/Zwb6wBpiLE+qyEng?=
 =?us-ascii?Q?WKZSd01HMz4PKsYgJ29DK9+Nbcypr52ER2snR92+M2h6PfgpJCOBRE6RtPvS?=
 =?us-ascii?Q?9NfS4+oryRfe1hw6thxs1N3HM4a3RwGvue+JXtV2TOekScG3GLXEvI3RAE7I?=
 =?us-ascii?Q?JPd9e4W8g60gIWLVbqk33e/o5stQJ5D8qfVNvCWmDoi6s5TApxYm7pORyp9r?=
 =?us-ascii?Q?6Vcmam6YebRgHzQrQlif78llTMbe73rqvu7gbWsH2Z9mIwCj7d8gFfrYcMen?=
 =?us-ascii?Q?KmJQxdTgA5NliAWxpTCjjv8/lreZSWqZOVkhP0tJwI5jiYlDeFmkGATKblJn?=
 =?us-ascii?Q?TDfbpQor/yutqsp1tfCcSQoeo07O8VrtaHiVXxgh9/RtYq10mF1NeHsZU8iD?=
 =?us-ascii?Q?EMqiHj4DucHh76OKwOwMdHbfksiW4XlWusgep1GFOUFBH71akVIC37R+US6e?=
 =?us-ascii?Q?Z9dftWKKBa5oITIOdDRHPIB1Ir2Sf4WSiMvIQhAfizhFXvkZmXu0IDI9Euan?=
 =?us-ascii?Q?eSJ4jYZMLtvB8MCen0djrcKuoDjp7ABxB5N1DLDIIyg9Cper5rSyQntYyEOQ?=
 =?us-ascii?Q?cbHf87YpF1ZKHsrASIz6ZQ+MZHmo7Xy29Mi6DtaHd1pdJeIXhIhaIpZPhu9k?=
 =?us-ascii?Q?GvAVJZaVP2SPn16/fcb2wsh9cy2CU53v2tWSnaIDzFXSx7ZoQcQWBMqfsmpG?=
 =?us-ascii?Q?z4xYiUwhhMqUeo/WFD3CwatmA3T0nyDIjFf0wioC2lRubQPIdCYS5BtrOOM/?=
 =?us-ascii?Q?XYBBWtSVNRUXlOlOVFZOsPH4aHZ3WGg15rDlAL/pKwlBaZ0B8dSKkULlY4Xs?=
 =?us-ascii?Q?NZY5VKk1CK0qQkoOPLhjQbn8P+8ctClyYWiEuoKyZg/Yh5gn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba5d906-4cc6-4c10-350c-08df0ece20eb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:39.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ektrZyoBB8N+Jc5Du6nm41V2BPysjnkjY8xw6NnL8pbCCaaTF+8VgJMXv5qX45M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

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

