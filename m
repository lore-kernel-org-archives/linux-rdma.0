Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658871;
	b=SDYFHIR/fC46x+YBE8nHdDX3q7MEW/Tu9B3XzBjLvjaAW5CbbSi9oDLx6MDwWS2A+5rH
	 oUrgxB7w9lX4DkRWYjPNags4DLRWW5/SkTCu0wGkjrHX15qDXfqTUU2BGgczVZp61rurd
	 Jsro7/gXWkB8rTmRaBha+przwq23UnZ3sy3D5cKXFI4WbjSHZyhSNDIlPNpIJEap6fwRE
	 Y9Jn9OmzsOaeMpRZ9lDxrxAx4fyO9nn0X6ZRmqmNMPtg1+KkjY0KqHxQn2Ol5XshcHjgv
	 IcuHrP8+UjasguaDn7vGUmgaLfOTUvRxrAs5x9WMno3Wde9AgwqFRVdJqePr3H3Fbwg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658871;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=49z8DyEfiV6o7hAKgqFL+WrttrfynDPgiLjXoSaCLUE=;
	b=dWuEMhMqiKhRjvrjoqlHD6wlqvvXHU7CZ17TPXApcG/pbIohzOQCBhoNvhpsR8cpCpSA
	 0zTLsfH4+zMOkVO9Jbapyv4I6iVlWQejSdpWX418cxrKdgiSvZPWtFxnv5Bfx1CKPe90u
	 ZDh3CFNm7hX7kgrIHe1sNR+eRseyfE9PValAb0rI/RR2A+ifmOQGMCzewi+tgEf0ip6PS
	 nGjQjw0Dg/PF8kpXOLHEsSnZkmsmRtsrQSnbvGj9EDg7RVtrjV8CrIy+kH85/2Zs2LJwy
	 TmOFHbMgXAxmG7wlbqjPFcotXLTj0hKQoheHS5W8V8yLstGnWderqGLZnuP8TU1JlOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WPD67hBe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.71
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010071.outbound.protection.outlook.com [52.101.46.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25584606A32F;
	Mon,  2 Nov 2026 22:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25584606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WPD67hBe
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZUNbPTHsXTc+FRK7+ttfuzzwVhPJ6t8D3AT+5bgXZappswH25Vt/+2GtJLpg2XNaWrAQMv1Ey1tTCH/2SLcHtL/CAjxqDKtcB7B9ZizWTNFQZOwLxACT6xeaQMtw7H64zceZ1p7tUgM8YkFHcMYLxM/VTqOkR0cNoqZVHPc9uAMyyGcynahhFgaunMBalQ1VQ4EamiCFBUMSgSLJQ85ZeuSydqg+w9JMg4mXMX1Z4r7zKLQFxflQeoKAQbo+nwVvMAa3v2u7COPFYi/XUa0oyu9jeN/N19uFHgTiRlZqG1TJYOpSfJN82BfHGXsBvSRqN/FK5JDZsBXK+wgapDtW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49z8DyEfiV6o7hAKgqFL+WrttrfynDPgiLjXoSaCLUE=;
 b=oHjKpAwRYExnWqlhiih7cGLEKBkVE4AZN+UjSyck6yxHM7pXwL22unUEarEXRj/5MdsIblym4OPNTOg+mOa6MIkpB4RJEqmCq7MtTLsQbD52srP+VgFu/fPIT/GCWdV5oTe4DofrZPj/ccGFz+RY0CC/0iSXwj6YSUcgW41x2OwdGv03x2gj3h9VWxedsFZZBZLXIjdwqa5P487wR6VJgMnQlSG8UX4EvjodLSUPACcYfK6OSJpFzcUZFihGV8AIILqpz0M+B6rpcDKhD/+u0CDFnlkVX3YpGkbqkrqr7omk2A21J2mfmMVgdwSAGST/2dac1VKuZm4p2IO7FDsM5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49z8DyEfiV6o7hAKgqFL+WrttrfynDPgiLjXoSaCLUE=;
 b=WPD67hBezbV5p6ElpscLk6PhvtJsc8umSwZSvllZZ80lx/ybmhK95RFCNZxIS2SStfKT14DJdfz8oyjRWFh/DFZlsPP0MHiNnEFWQhgjNbsoSgnMuHk4DQphLo84iYIEJIV6JM7wC5++dCc7rT3nFo+z64p5GzqTtSc+VfSJQ2PKjeLs+QSA29QO+ntv5q22c0++BIoNsmihU02+rSnC7uWlY0GRHP7XwCilXij1mS2U+2C8gX6pihAl6wbUN/GnprmwzrjErMbfR2PraU9znVEtpecok3+lfrG13HolyOS7Ye9WRdC939+kdh9qp3+pw4cSXtn7p+2E/+FCwdHxBQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by SA3PR12MB603307.namprd12.prod.outlook.com (2603:10b6:806:58b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:27 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:26 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 06/15] net/mlx5: Add IFC bits for new ordering caps
Date: Tue,  3 Nov 2026 00:32:59 +0200
Message-ID: <20261102223325.2115128-7-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL0P290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::17) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|SA3PR12MB603307:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c2bd2aa-3764-464a-13a7-08df3931737b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|6133799003|10067099003|22082099003|261102123227099003|18002099003|56012099006|11063799006|261021123027099003|261026121527099003|261021121427099003|261022105027099003|261026140227099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	RBQZ2n5Od6wpAGG/kyaYGdEOgbdlJghtKXSk3TiYsrY7cAoC1Odb4WG6XF2eR6q4C9mMT2aLQbbh7/1I6qsObBYYygXM8uwEQBxoDcIKQ8hp10BY8wl/L/45rjbSRubQ5LnRZHbeNydxKpF0gugx0qOl8nViaP6trQiH/DNNNSnOo/rLl2NWr7ts/zHXhsGlMBLON4UWPmKXz1b111iFCqH5r7flce4qsYUh/qWJ97yS4f5hONeQ6MHF5XgL/lzbzsCtTC8gEzFiN1pG7pGzj10/eTN1+cs2+bl6hDVzsfEk4qkciZ/d8tGLTC1IcQJ+nQI7zm7ONCGMXU1obuGNIt7N+1pJ/fbkkl1hSbuoOgFDQGjiiXl7RrlU9fDx5TO+unm+yPf1nmJ8LtYMYa2dpKPpSRPIL+LzJDCX0e/auIbCmCSqX6ovUUbxZcf9/qzZ0s/X+r9ZOpO08fTKC1szz8OnGAIWlShd3x5zVKsb2y0UvSEqj7w9b+eMF2+WE2gH6hEJOPJZ/HnAxh3qUQpNcrxW+XK0gWQZY3lPzdBqQAdbJBmXm7OmJ2jXKh5UslvH6PB7zrdQohovbs7pcXbCFGpEGr7M7Ll3zuhNyt2L2oRJvDQpqyr31skxXZS9RuSRIUxaJtvy0ZuVM/wBsr1IKHQvuxINjIrG24jHT8ZSAo4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(6133799003)(10067099003)(22082099003)(261102123227099003)(18002099003)(56012099006)(11063799006)(261021123027099003)(261026121527099003)(261021121427099003)(261022105027099003)(261026140227099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?90VHYbaS7RTry21sqzNX3921J4m8inTs/PTrwphBLDjgF/ZAO66YraD24j1D?=
 =?us-ascii?Q?x4CTm9BImm10kZ4nUK9KZCb5HRGK2iz5UqJwpesvp/icCP14pwG6P4fHCfRg?=
 =?us-ascii?Q?RBKK7XTLl3nhDmK0NpXbgEZ559EXixdfVIAuXnd7yXDOJSlXZE8PHiaGhGII?=
 =?us-ascii?Q?oxCQtMlG6Jg387txQgGrNGZSdwUkYj7JO1bqOfCCQgAf7Js40kyoLtIWDjiJ?=
 =?us-ascii?Q?jFQ2r6b5i/R8y3FzkBDITsMoeIZ7MbUo+4hI7Nw6VRnlg4/foYGG9KFuO/2i?=
 =?us-ascii?Q?95ZTQCVO2sEkXLvJTIaPsamdHFfvfqN63q5E1+LvCJKAIrvvac9bL+9N6hwU?=
 =?us-ascii?Q?oUkA4P89+Yll1F0WijA4+vUCzuE+kzR83v1ZMKTWt1V3hjmW6nBg16urUoTF?=
 =?us-ascii?Q?Z30mf4FBmkfJy7laVfRGhuXum2U0OoQbyPna8JExn5oazm3u5M9Jwv2qxWZ9?=
 =?us-ascii?Q?GkowqEacYys+jc8HNPMjr9hVqIie4k8Pn4mj5ml8i0YSM2d0HVklwXbzj5iT?=
 =?us-ascii?Q?Uibt+THo7tQzBAJpqPDyIvbZmEiEyMTdt1NJIpITWktrwnSPgS3u/ppa94KN?=
 =?us-ascii?Q?000H5x15F23A4L7vefvNzpPCoz80HByXItn5dsVarkWEWdYUEYdYDZWEr0f2?=
 =?us-ascii?Q?OUmxOotwDRhvk3p9Y57NacKsYsAXnuwML+aBECUGqeSCMLYrGCCq49pTZIOh?=
 =?us-ascii?Q?Zl6UJjCgu7dId5nVFp0DucH3QwYjzFTaG4TfgAmMwd/KygCs6TcGXLLKTC8l?=
 =?us-ascii?Q?hnheaxIkEOj8P1Hi7iX1u1/cIvehgSfk+OcXn9S1WWe1CDCNrKxE4C55JMpP?=
 =?us-ascii?Q?GaEuZ2Mqv88FdJWpFEBMu3p8pxYosmsQtamYxAkF8uiqAorE1f+N3PipjHho?=
 =?us-ascii?Q?s5Xk7cx7VrbVqmClTI/DmFOO5ywW66NGmQSVJocDgd463xmLK7qEeQOLNXVA?=
 =?us-ascii?Q?NiYIMbZxJhrOcFQoX9ZU8rtshQ6N55Hze4kgScPm9ckYwDzoVKyV7Sc37Rla?=
 =?us-ascii?Q?xGu14KxvIaEaYLR2mgi8KojODyZ/xjwwvejcmyXB09SKKpDSuFZpbII5OReO?=
 =?us-ascii?Q?ZqXK7B5FYgyMr+3TT1Am9mPqY36xJWp0yVHpnxnpwmq/0nioc/hb9WVxNR87?=
 =?us-ascii?Q?4gxqrc1min8UENjtgS6jWDQYH4ijfCOQyd+cnfR7LXzpoXGZiph+xhjXTiDf?=
 =?us-ascii?Q?SKFFu0eFwrUQdaxVg8NLMSc7G/aAj3ZQO5lfvXWGVAqcNNxCISsSabz8o+ak?=
 =?us-ascii?Q?FqYoS1JeDiZl2aKYpVU5/0RBAiO8FJ24HkmEwvhD+9bU4f9dMCaVcDyiVofv?=
 =?us-ascii?Q?eZ8QzLk/jNLR1mmRdtKIE56Z0TJeYFKyqwKRNM5jVKjvtHN8JXCnnFc18dc0?=
 =?us-ascii?Q?+LXP5Km/8sGlRNdLGcWf/rlrqMwUxgQtZzeoL2AG5i0oRX4nffGtAbM8QfDe?=
 =?us-ascii?Q?IorHgq6KpcS6DQRADherVBAtpmAl4nOdMZWuxYmA0Pk7QjMximGb8Hhn/Lxs?=
 =?us-ascii?Q?6bvAzNGmi85Gin/r9R+k9+oQaNeQRuyIOGgYaZ/eiVje3TYx2ZEG5qi8bvLd?=
 =?us-ascii?Q?BYwwSLl7Xdd+RL2vNYzijGjpLkoC+5WB3TtJQCcwtM86PP7NAsvX0vJkoA/E?=
 =?us-ascii?Q?MFJm29VNgErM4OrQ7hPlqtj80AQ/F26Ov1gxcSAOTZz7viQ9OibFo+IuVEwb?=
 =?us-ascii?Q?oyDAjPXWzeDb/9J1U+fJTtuNmkSC7jPCfxFdlz+/0aTz2M/BRsddj0TQsu14?=
 =?us-ascii?Q?+VXwQinFbg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2bd2aa-3764-464a-13a7-08df3931737b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:26.5109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmLJbj/0UXsGlFssYDKMPzvO3jMidgR/KH4hUcHmxxYZCMO0vDYc6YNTmXg8D9+N0WsHBzh4s8x+/zQ50yLr0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB603307

Add new HCA capability bits:
- mkc_order_read_after_write
- mkc_order_write_after_write_ro_only

Add new mkey context field:
- order_read_after_write (2-bit)

These fields enable a new level of memory access order relaxation,
allowing read-after-write reordering and allow to expose an indication
that devices don't support strict ordering of memory access.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8531d611fa9b..26801ad51f2c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -2005,7 +2005,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         roce_rw_supported[0x1];
 	u8         log_max_current_uc_list_wr_supported[0x1];
 	u8         log_max_stride_sz_rq[0x5];
-	u8         reserved_at_3a8[0x3];
+	u8         mkc_order_read_after_write[0x1];
+	u8         mkc_order_write_after_write_ro_only[0x1];
+	u8         reserved_at_3aa[0x1];
 	u8         log_min_stride_sz_rq[0x5];
 	u8         reserved_at_3b0[0x2];
 	u8         qp_latency_sensitive_disable[0x1];
@@ -4522,6 +4524,10 @@ enum {
 	MLX5_MKC_PCIE_TPH_NO_STEERING_TAG_INDEX = 0,
 };
 
+enum {
+	MLX5_MKC_ORDER_READ_AFTER_WRITE_RO = 1,
+};
+
 struct mlx5_ifc_mkc_bits {
 	u8         reserved_at_0[0x1];
 	u8         free[0x1];
@@ -4569,7 +4575,9 @@ struct mlx5_ifc_mkc_bits {
 
 	u8         translations_octword_size[0x20];
 
-	u8         reserved_at_1c0[0x19];
+	u8         reserved_at_1c0[0x16];
+	u8         order_read_after_write[0x2];
+	u8         reserved_at_1d8[0x1];
 	u8         pci_relaxed_ordered_read[0x1];
 	u8         log_page_size[0x6];
 
-- 
2.52.0

