Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010019.outbound.protection.outlook.com [52.101.61.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4B658038A;
	Wed, 16 Sep 2026 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789602768; cv=fail; b=Heeo+mWiiNNYWoQEv7HxrBXGWxxFlYLP6jrfrESzuFfqLIZSEVGsfmm/++qiKjjVT8jDBYlkKjfKv2rMf5W3H0jORvoQSI++WmagYvcwDBehbGiDovhvRnFbG27v2VemJhXgmu9l0GICXj0pgRRK16CLOE1VGygeC8GpOv0+r6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789602768; c=relaxed/simple;
	bh=M97+bpfeIRbTE/PrV/lt8BoPW0DYd6XEih6qZMFhnBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uk5MKaWItGcuqFjWb9tr9lz0FtYh92A+Prhd22FxMl3n69pRtSFsh1Q1RdMGa45iblqTkDhifsuiBxO0Sf+d2bkyDBxBOMbdiMT4/2B3l/jCwfmiF96yKEjsYfBDejW2RX2VV4SIYcyGr3lMtBqLFeCBXABFyoMnt1lFa6PqcYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gBAyA4cj; arc=fail smtp.client-ip=52.101.61.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gBAyA4cj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ujgt4nZjroVhWgkJm8GmQ4/P8Jo5mc1D4znUm+MVQYtImEEZuC/xZdq2W3gWGkvWExs4K01Uzvqwq8KWUIAHfETdf/TpD7G1hEzkJGgO7+iG+7mnPV5Z6L2nXj0y/IvTnakjKj4vpoBv1kTBQvLQC94DOBk13XyOvqgu1IM4WQNa0HYRh9IzfhjpfdBuoi03J98O68cBunmbRlMA01Z8d1u+KjHT0Xr+T/HC4KvvMQLwIE0nW8OJwbTpH7VmfxnogbOWdyjFzoiV11/5exzWkdg1rsaO53zAVAIKWRxgjDR4DTPn40aIxx993rtu8mcdR3bcr+UKoDVoX1DhKb5HQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WbKXozaP4x0kLB0tJQGgYerpSnEO+CkSIpZ12TrWDQ=;
 b=GdSCU6R0494ivLlxTtlhOOujj14yXE7cgv7Hi4m7JEDph+7IPWVSRXtjPBb123R5GuNAZmDDgc5UKNRkQ2ACekTccNHLf/RDhgxBnANfHupS4oMChQE54/SJ3viwndYJ+EptSGvzUDbPTZp0kprHOiW3JFM9PScEiDgtyI3p23CEOVUN/66i/5cyoNyQ8JY3lEJwDFadWqclxW/mC07L/svK/53CiIDmyNdcEMt6j9m9ARvOFzypB3eypoINUAY3yAllHGLXPGEpNBsnKAXc6opeociog1Mbv7U/AhMgLUF0uo9XLDlu68bgA0AQGO/LK2mRa0NcaLp9Wzrj3i2rmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WbKXozaP4x0kLB0tJQGgYerpSnEO+CkSIpZ12TrWDQ=;
 b=gBAyA4cjhvawthrhvOf9NWHdbeegKY44Fml23RMpHxyhqXXrlEAxEKkQx8TTehY1AJtx0S3V9iS2rY3ezjXZUPSLD98QKqDdgw7Sd6aLaos2faRq2vDCrIyHMb8s3RSBb2cOuNfd4hQ5m1ZOogab/rH+ek9kMo+QxXnGFSG9tlhhjGtCAngEvZhzoVLiWkpOHrNievCIuc97KMViAb4zrJ8FRMmjylXs1s34lnHvo0KROZhEqCEO3e1f7nWH3SB+AdzUPwLCwBZskxBq7WQ7bpwYRcZj6Yrx3Al8zeW4qYST7Jx/0LbDNmJ1K+7+QcZEk5VA1SIzLBfMPqOFIXdLxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA4PR12MB9787.namprd12.prod.outlook.com
 (2603:10b6:208:54d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 23:50:00 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Wed, 16 Sep 2026
 23:50:00 +0000
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
Subject: [PATCH v6 02/10] net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
Date: Wed, 16 Sep 2026 20:49:50 -0300
Message-ID: <2-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:208:52d::19) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c9602a-b6a4-4e03-6574-08df144d380c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|921020|6133799003|3023799007|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vYOP759KRBRGNnzv5mETw7dy/b7IPB7MuSPti9zq/+5csg0dBgF+Y+VOWcYFiGVaTNXBqmRKqUv9ZJ24qnIEuD2gIcbeHJWd/DOGlLyRYKgBj14kJ6ybD3qLsYryy7OnZ3X6eO5RqNYC9l02ps+GOWS+XUIFJdILfiAaCvJ/jzmb0OWeS3Lpvekf6a1g55qNHVqSs1UXviL69c3aeVt64okLCMuhhluFYP3faPZmZ2sQC3xjKM5goeCeKi4N7TzuDoswsCG/C2K9yaK7wFCcdiRtSpSIDEpSMSSe1Jp4cM02I3fqhYes9kScwRjP19sQdprN/mkalVcrRQ+FZ1AFk7XMsfEh0bkScYJhPlHcGsEYQsWeoAzrfQ6G1SnBnKIp5QnMDsTzqPEWwmNXEDwEFUEByGkbpUpVsWRzoC4PoWzN3ZM6gtF8lzb/SpB2gYv8BPNP4rWWODT89gPRYR+Nhp1cDxMD8+l58AtgSKfRSSFTUqxJCQR9+nVqdyH/8yQNEVXiZ7U6Ovqjgo8bf7QumyCe9C9IZfaRY4Ja1cYeO4eSTOACvHbodYmuMz9FyLZa4bW1CTPwQL5JUjiTuW39/l5LbExkmoN/0fWTkAh9ucjJwrr0BzeOasqbBaFHKnzRZr+5UWus766PRFfiviMds9CLEyfWVkNkFERSA+B8OVbJFGHjKWXyiU6rw6WQ648FsNorT8WCcEFLP61r8YgHCQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(921020)(6133799003)(3023799007)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dXuc7MjgCQY0mz0VRUW5cYGm9y9BhdYmVESqlqJX1fF5k+n1fJQM6qw6zMqV?=
 =?us-ascii?Q?s4Giy38fc0zU5L+C4dO93mrlKI6JQz5Lk6WWYXjO+hOGoUfsLhU5eJKx4VNb?=
 =?us-ascii?Q?XiVglWRIUS8C74NL5L2/9Gg+ZR2spgDIdIH26pQUJutksgo7yq/93C3YKFHX?=
 =?us-ascii?Q?3TpV/NioTxgoDBv81jFQ/xsMmo2oBA1AsWvGPiR4QDBfeg0swNY+9ZAr1Opw?=
 =?us-ascii?Q?oBoEe3eGitX4pX9nHDC3IW1Ve7QtqlRCiXLgtjfhJ7/pUy3lbTC84+JJcqwA?=
 =?us-ascii?Q?zw1EF53XU3nBJ29IXC83tjHqPRHggiVLO2RMOsuVZJNJCyDioTS+BPvSMoyf?=
 =?us-ascii?Q?7lNNRjFZOoD0doslDkUI7hQO34SQJZgolgqFiEicQC7pH+32pQFD5Jq5iVVr?=
 =?us-ascii?Q?hCGiZMa/F9RoCQdQAKT7sF3f2Adus/wqyl2Vd1eunYm8o4AezFY5VTjnMjvv?=
 =?us-ascii?Q?U6VFOxWy77pZYPB2mLiB5PljXmT3c/6jRcNIud9VVbFizeDB41YEVo2C6XkM?=
 =?us-ascii?Q?dRZ0nZyhRpR5SWwwK8AHQOOkK4bJW5xOgJtcaxrVvKhn6hfc3YMrjMxvRMMN?=
 =?us-ascii?Q?vskRpmsof3cVrfNSzI1aNbKo9J31mjdDYRJncdM1SRIhGaa15sLE95ik3eiu?=
 =?us-ascii?Q?xofWosTW4sXQpCP9R4ojlLPbPxnsC5k77AQzEQ8HWL94euHO2cuwgjRcuSED?=
 =?us-ascii?Q?7Bx8LUyNxvgEprBpRjHPXKXnELLXwJznqjabl+cmc38g0NUWOuho8Jodvgvp?=
 =?us-ascii?Q?t19Cgl+jTTSwQZwJAJssYfQpR8IArFgRMvw9hacW7Zl5AgVB9TjAXUFDPPAJ?=
 =?us-ascii?Q?YepuwkV3ZIQjuxF8gK9lk8JgkLK+aGhFSd7xqSZwzBniHcQdmLjL1afxlYsi?=
 =?us-ascii?Q?iwv1UOFI6P8srL3OtCHsVKPpOr4cwgYAJbJNrx5Q9+nD0LLuYWdT+kjoDM/n?=
 =?us-ascii?Q?LWilPnixqJ9lLsYTA/3gMq1oP5JLygLbPo5++/U3qA1KSMi4o2/SDgThBnFf?=
 =?us-ascii?Q?9OmI+LWt7TeDTfUJ2vlMkdxBAKib/k5sevQ60xyUxHHGpxNMMYG+x9t7Np3q?=
 =?us-ascii?Q?COaiORS/+Cde2A6IdcHXdO18DqAMTUDmVmlJcNjxvQYnuOXIcwtDKAHc0Oku?=
 =?us-ascii?Q?aJa0UOxgSn0sXFJhitJMRLoPjgmg5b9LBOW1fHhHtfycHZj0UzGTJIjt10PF?=
 =?us-ascii?Q?1gBSOVpu1HYWyC+/ruJCbIQI+G+BL/yM72cms9iUPdo75AsAG40qyHK4GzbX?=
 =?us-ascii?Q?M2TS3GxwX40CIJ7SwwmgKfuIAkkliHZoALnryZXHUOdBWTG8+KZ6pzE2CNUA?=
 =?us-ascii?Q?IHcWbPKvxojvgtbupX5SSdgI3Y8p59VPrK/9jXxIWEbMBV2/8ri9EVLx7qvD?=
 =?us-ascii?Q?wLbjiwHQY+Ss0lTW+3nrp8M8QCXiN1moJ6aDkfRq+jAwaCKzECaahJWH0onA?=
 =?us-ascii?Q?vox15laaxttoUj6mAqC+H9yVIXl/ECKpXdNTXbezg1V8uysIe2+GELd5NuIz?=
 =?us-ascii?Q?RELf2kOXTIMpCuT9OFDEjbrsGM/S3prfYi/kHIzQsOI4ixPksTorbn5bz6Lh?=
 =?us-ascii?Q?4hQ2y/kQ3iDY5FPsnKPyvOp9PFPRgJ+MS4gycY0KRlb6ONQSnwCWzz7gVNNo?=
 =?us-ascii?Q?2JYEqZ/+OuZNastNYyxMCqHEbXlo8qS6dCtNz8DFLqki/aETGjV2te4zv6JB?=
 =?us-ascii?Q?aqmDnliZS6xhCCOEAIJZ9ZuuzrgK2jBWtPgK9yM85A4bV8Dy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c9602a-b6a4-4e03-6574-08df144d380c
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 23:49:59.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uG6Am2ae10OGzBLFcK9kUAAPwYumAbT+JOQ2Gvn1krgqJtabYPf8lGLzroK9Klv2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787

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

