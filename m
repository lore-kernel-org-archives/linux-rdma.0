Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010009.outbound.protection.outlook.com [52.101.61.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAB037C0FB;
	Wed, 12 Aug 2026 15:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786546808; cv=fail; b=KeOiZq4Fe9Nb8NINn1B9shG90cnZcXViQTHLEc24LOVm2Un9odP8jtH4TrnOBVL7eZhF09t4/QP4aZ2tAdCcOLLfCLqivMRzNYbl8tj4/nRubk2AGmm0j3WR52990JJLlLgKoaDRlCIxwRSemzIzpg++sBlPA80JycylWyU+nC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786546808; c=relaxed/simple;
	bh=p5k3h3nz8992/L1FCZkT/zeh6nLSq74gYavpxhNdtp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZYhsIdLkv0mpELAv6YKVdLfrb+A7Arkr2+QmsBfYRCMGGwEKhFj52uuYoLf8u3ICWVf543u3A+yPcLsD9X2Z1o69f4njo4tJOef/eaj6OlcQzo8eIOjgfk8TSJiRUIds1hd1zXjiVsHjQAs6sr14pwj9VHE58/TKRD4fAHadA9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NrZHBKiw; arc=fail smtp.client-ip=52.101.61.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NrZHBKiw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PzGp+BTjBlE2ACEVBLsjyTWkyV7LAojpzZG67C3YVgPaIN2mWV4zJTP9JFXrDxCZTdLQcGBHWoiR7PqTL6F94RFIebGU49zY2BX7QQoHOINlPeO0x1z2TKZG1kgRko1YY9bXrlp8zuivilvUpFZJIsIkGDexKBenc4rVF0SmbvqjfhlrMyRUP7nfrVay9sUyusavyIHz6yHuDNs9cKC8gZfR2vK09T0XUG1b4JyXIAjtLtCz0YmdPQBCQwqWa8etfNEJ4BNHB/1IUD/k07cyUe6gkRjgKnEe9V/meYM3FoxBdBVRP+qK1AtGYDdT1+Icrl0TIo1jP6s1tbaXl08BnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kr+Hvo7ZYjJktPS6MYM10egAkSmilei7LNFE/ZFMtt4=;
 b=p99eXRdaUticg0QFS+U503cjjEMrrKJh//KL58Bjh6nn9bc/on60fnSueybm5AKcyDPxdj0nx/Cx8jMoPvlT+q+d3tkNKJaCZT6lXv5ILsXRsmidvrNxQOYTfcNKVnLLFhNapKB2iX3zOM3gqF596aLjTIp65+O9dgo/+w+Kil0YrcuBHb+eJCKKrpysiURO8l4WSOUJDtYCcC0Ew0Op5BuPsEnjoJbx+5vF7wZHHGq32sQAlTn3Elm33ZOGikoRDLMQgSUr92YW8Lv1LndNJe/T7vNGJ5NSt/nOIbevVoW/00/3YSshkiH7+trUXM9H9aXOIhEheqmT8KoOnJSYXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr+Hvo7ZYjJktPS6MYM10egAkSmilei7LNFE/ZFMtt4=;
 b=NrZHBKiwPyCKxmgLlNyIVKP50qMInLCXIk9Xd9JVy7DfEx2kM9DXTzMVic7pszkm4ewzGF7woQe86xO6AoElCxRHcZXPSK1MzrfNpf2MQl1KJes31/mhNUB7JNK4FQ8dXWw6Vorpkk0NeMk0NCv4jVb40e1d1u9F8yqgtfD9Lvv5fuqrMLf2Z2MY/iRRI8TGPMjePI6iO4/Mq8ao7/IynjSBUgWoTzXvi2Vat3bWOO3GY00AQkJ3RaX9wBh22ZWXqrQtzEW5Xptk/RWM+uOorR9Jldf3/viuqpxB4zraqQLjQdQLeLmVkOIPPw5RJGKLNq/2ebe11x6DNTCWelBHpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9654.namprd12.prod.outlook.com (2603:10b6:930:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Wed, 12 Aug
 2026 14:59:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 14:59:19 +0000
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
Subject: [PATCH v4 02/10] net/mlx5: Move HW constant groups from device.h/cq.h to mlx5_ifc.h
Date: Wed, 12 Aug 2026 11:59:00 -0300
Message-ID: <2-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0691.namprd03.prod.outlook.com
 (2603:10b6:408:ef::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9654:EE_
X-MS-Office365-Filtering-Correlation-Id: e62b1589-2a4e-4df5-4dd0-08def88245ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|56012099006|11063799006|10067099003|3023799007|6133799003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	uWX/zZOEU/fXrcLO+hQI2PFobwkI9EHTO6S9dW8hKcOUVexg2iRjdZxtahJbZCBa818ysQqlCc8sSCYQTnhX3UmjfBvHgpADD3TKtAPAisV2JzxS2L9nWj7UZdxzpqblJtyZgxOgWbdzucr97FD8cxt2FURsDINsj0ounGCYSBMx+xgzh+qHKr8Dn7/yuYjbQ/mtLPGEe8g+rgJC8CsvJkEWvIQpKuV+LD5HjRBJmpM272zU+nx1HoLUHheGSS6oKNJBIq2GzvHbB7F8AiQZErCh9no3VNtgJ5z87/ieoSU8gNmskd5z22gN80fmTsy7g9jzMS9Ld/NNPb5Kc72Y7rYBRScAYnwXreBJxlBNAnZVem/sD4RDsDuAHEkcif+l/TfBEaS8O1qK+Wa1aliBx15w5rajLoWzw9zLEbPsusLfwgAQxUnNeoBlEcqe/Rt4jRggATPH7r9T3dv78buexC1HfExnO40dVqZUESK7O5iq5YFemlYxRsPlVLLvWbi9vnccmc/scx+rC5rc5naTRVXLDf8e+qEZXX/RWB6V1qAmGB25JLhWrHdpgLCAHEXqwj1GzPuUWwhnCdgEBP2dkhfstZJFgKJ193gJeE9S0vNawcQweRZEkuwymT7qcEXpxgV+gAUHNcqX4G+cr7z69un8vPIpLKQmJ7U7YN/UobFZYVri77n6Emaa4LLb3fyI0Qtv4EQ1gSDvaJszZuqNIg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(3023799007)(6133799003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TwnsnBbhzEhFDWfDovTerCobo5UCTJfBK+owucTPAGlzRATZfo7BQxvSc2pV?=
 =?us-ascii?Q?Gis/ON1QBBxB6D33aBU/Ckx3oO161r0autwpU7Ihqnchvg3wGOJHBmIZ9PMo?=
 =?us-ascii?Q?jfMpCCIRg/WFZMCFYgY5W9YuZM6MlRPCpOK4RrUXhxaYnJftZuyhhwQlfFKl?=
 =?us-ascii?Q?FnRhPPW+LLUFcSw2UHxL1tUAvPcJxSBoRklB0hNDn1M24uMwPg7wnRUshH2n?=
 =?us-ascii?Q?2WF1PzaaH+q9sItnqtOQ60XVmDb0zgKk0shsJPjrx3NcOKiOzKO1OIyk4fgx?=
 =?us-ascii?Q?SowUt+Ofgmnlo5mz0GsofjuRkudw0kpTnkOlKsEbZxfhbeksGd88b1zvNuCa?=
 =?us-ascii?Q?xfOyBQcbouFOwOswARJFaJAiBzAw5kw8UjDkCxWzapw6OMbP2en8FiXOmsr8?=
 =?us-ascii?Q?iU8NyFGooWUVRtof/yutEawvDRGdbmpn41xIoUsS+EVe85crCYcv1DoUJUon?=
 =?us-ascii?Q?ZLAtEofPnveJWFWUI1TPp1NwgySeW7otaENc9B9EDuFwYF180pzQfGYdt9nj?=
 =?us-ascii?Q?NEJK5KqEDwfn5q6qv9qOKUoOhCf4IRRO9QcZILBdhiy38TgsI6/5E+zpqEwN?=
 =?us-ascii?Q?u4eDnkrRN7Q5duY/p4ceQhyGLGzmStS835bgxG5/B2LgPBVxnx63bpo+LbWr?=
 =?us-ascii?Q?bO7jQ39G/BcmXsh4t+DcSiyI/L0uLHGeHFBHxv1L1OEXp7DoGKhHwvet/x8P?=
 =?us-ascii?Q?jae46uLMkRnuAWfQbdZGLziIQlMoevTA66C4BuZcgicdlM5LaU+SmB1T6ThJ?=
 =?us-ascii?Q?cptn9ZU0NUftCf2pVXeGjx2/p9C5qk+JAQnXYz5iuCjyvVN91lxLuMS7t0xn?=
 =?us-ascii?Q?d/rdhntdab9b8iW30fKS9Iau+FqupBP7QPdJoJAV2kQKmU7d03Qe6h4EbYZm?=
 =?us-ascii?Q?osAAzN+4GFjBRAlYE5nyvxS8Q72mwYM+tuGF9ON5j+QAdwZNctrjzFeUrMk/?=
 =?us-ascii?Q?0MfUKex20OOE9haL7vb4y9Q533n2g5g/DHnjVsz6Y/4zyAdkDIFXYwA6lXx8?=
 =?us-ascii?Q?mq52q71czlyXHwb5NhzFEKTgdfwVUAHL9Q79NYVG1iehPGKNCe//mDFyJ6B1?=
 =?us-ascii?Q?6KApWf9uV3ADiEB+Fr93DOEBzxjimIUedL3AzSIAOKWO4+kx8j9WNz16+GfQ?=
 =?us-ascii?Q?9XExSXF9Q0gbFHXsf49ayVNs2KyDAaniWveE5T/X5k2Qwm40NBbAjqCCILc7?=
 =?us-ascii?Q?k95MtFyb5N072rAU2PuX+lxjOiqirnzAMQIPMuH+gEc+/S0ZrEVV2n3vN8az?=
 =?us-ascii?Q?Y+MGnE10f43ERHB2EJpxETjnurFu8chajuEOLPbBmheec7WjXFBi4Vd3Aro6?=
 =?us-ascii?Q?YDIfHpdSj9Dlv41NQo7Axm3D87oThdcB9fs7qcEGK10WLHi2gNjk8vogLa5o?=
 =?us-ascii?Q?o26xpm5SznF2rVH1aQg6cTUqUdfk12SsR13g7MM32w61h4OeUWL6G/DQaZRW?=
 =?us-ascii?Q?MMu4fGo3O9jRFBU4ADLtmqDP9p5wHpZx/aAO8aTVHrqdxf0nYkfa2NESfFm7?=
 =?us-ascii?Q?q1dkefCKYlszGpglT2ui+rRYKVs2ECtfLwBZ7wIWP93DYKNcrgBjBu0cDXO9?=
 =?us-ascii?Q?5Anmf4I3zYtdo5/QXFVALXWAuUNlT6ioAcztsGdZsHyjhcJJnAO3nTwLxSiV?=
 =?us-ascii?Q?6jAtzSuX0+v7Ab+pTTj5sX0Mib/Ohsc1rfyULI+T8f5GCaradZ/uaaUdgd63?=
 =?us-ascii?Q?uA9MDp9pf1S5ShIGw89+RbFxsveoP/ervqM4anI8JQZGrDeu2RhRQe4lzfvB?=
 =?us-ascii?Q?JT8ZG4OUsA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e62b1589-2a4e-4df5-4dd0-08def88245ed
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 14:59:13.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZ5X3mHQjQOP+ZveNJAHzJewZLibyTlAySfYdZv7JMCw6Mu1dQrKPfHfMPhy1aCO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9654

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

