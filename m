Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658899;
	b=G/axuY1LC2BoP1jsVrwComzENB9mCkSO0y9L00cWCOikx9C3pV0PQkRgZ89w63H0h+3U
	 H8scOcGeHjd5oVijGxHgDa8zoCXn9NSUfv0eiN6RteF0DUR3OlpQO53ATeJYLtf49napP
	 xysVCdfRMZ9pmtABVjnOhM/k5zCHL27vprCCUpldVGHTDZNSHFnEcWtFAn4/7E6p75b8E
	 Jx7JRfkCCviB9gPl7CdoqCr4jwtuULwpAIEKxVb23YRrSPNQHCXc0tfRIzQVoyFsSX+tn
	 BRdaZRzZJb577019spYihMatK96twy9A16011I7G1Wsk249UQLbdpvotV/eCplCjApA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658899;
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
	bh=E1nIGNMHaDoOQkVq1KREmI6zGA7q6En6YqCKqMbPZMo=;
	b=GDa4sCQg2NWR36XyOHS/PieyONYrGmHu32q2yJ6hqPNGftkSmfL5oUhQjy/jbdSTvvmJ
	 /C/52L1ktMAFWyIUyFh0N1XunlFP2nKtVTRpeZP95+ckrsZaCB+Tc13F2llDhdIJHopub
	 xilq1WpquuIm1wgXHbkPirpbJU9qBNrMsCTgjRtQhq/84XDzmWvPpBqu9qxXvSwAwCdDV
	 /1uwc+lleDylRim4s74H+PDHzWUXs2kKOvdBIPbs6a8oEG6yra0Ntl2U8nxCGr2zQjtjU
	 efFom6RKj8IyeG+HFGnDKz3Arhrw7EvgvgVTpwvFm6x+HHBPTKtkG/UIQdhw4xXBMVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BEatZuqG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.53
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDF4606A333;
	Mon,  2 Nov 2026 22:34:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDDF4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BEatZuqG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=diyBY+NMVFKRGBRexaLT40a5QunGp6uXv19V96y76n1noPKuWuXN8gBagTYitTzuqSE5H19LIigr5hNYyXC1jM8czaCpdmkhq5z8/b+8K1P2cvozHXf3FnGm0YAx13+i36jgOMUUyGxl6HJEvjp8sbsXDAtKjJ7hMrx4djuR6o2wSsM5ts+UJYSw8wlWfPCP9myvgxI06Yn7isFPZKy1byZddeYLN+on+V8Cu66gMQTfK5QLu3eikMW2JrQtfN3gMnB2Er7EuJlGIMomQ5iB+VH8KRq0kSenAygmzJ7fhLpjEm9qN6f0GVocnL1D5VMEluyLdxsVplBOp2TiwZFhAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1nIGNMHaDoOQkVq1KREmI6zGA7q6En6YqCKqMbPZMo=;
 b=YNWi/dY+E6JCIxNKdn9RoX+VpD++/St9UNVFpQUrF0bNRhO/IgOkXOZsDe7RXJCdXxAf0vVR1P/Xd6OijJUgA5dbzg5rNXNhjdZnsKrKjPXVxz2idk/yc9uKE8tyLmhpZWnEFIdnB2hRk1S1mBH9OMHp7+gEkOwv296zSIkIat2DJV/abX6h+F5WKRgWJk6Bo0nCNhQXsjEUf8JwhSSmUsEsnadNLAPggCtEef1V7AvSrk/Rv7ZLm7n/W2JkUAmg+2PpqzHKJ9x+H7jUf34m39Q+MmfWTkcu3SMZ0+Bo6uf6ezwAe4D+vTVlDVfsW+1JXSFzIT/zEZrNblPZBtcovg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1nIGNMHaDoOQkVq1KREmI6zGA7q6En6YqCKqMbPZMo=;
 b=BEatZuqGQd7m4HMxYRgSZmW7wPrroaeF3TBnyvfsRkeE3woK5jrcm5UX599hXugbw83iiR9gpuvJjh7e/N1jVBFVVXy3lz8B+BxkL4aaulKDbfsSHxnDKEDtzfS7c6uLr/dP75BU4QKADRSClQe4oPt6nePbmkLmA+I3YDPK1PeUoOdhBrP/K7RczjQarYSVIdJJkH/dGLo4mAE1LQHi6pI53PTx42A36kxWMMuxkrcLvnUH2T8asaSIJDhN8Dca23Ui1zLZP/CZmCMCAEUNX8b6BHFgYP2F2nE1RKJKkpIUtQgVXNGDmt63T/acsk/8YahegSpbCoMjBniKIM4/hg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by CY1PR12MB9557.namprd12.prod.outlook.com (2603:10b6:930:fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:56 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:56 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 12/15] RDMA/mlx5: Converge UMR access-flag cap checks
Date: Tue,  3 Nov 2026 00:33:05 +0200
Message-ID: <20261102223325.2115128-13-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0003.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::8) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|CY1PR12MB9557:EE_
X-MS-Office365-Filtering-Correlation-Id: b33a856a-0185-4029-09d0-08df3931851e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261009223027099003|261022105027099003|261028144727099003|261021121427099003|261021123027099003|261022075727099003|11063799006|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	7vvWP0DfGJG+nRXDC147vA2kCmjWHCoPTiDk0q812NhwmL5YbWAahR/BwHqTeOzQRPxNuyxjm/tEcThCH7NllgOV7UJYVGKq0FtMpLy8+MaDb96L/Rv7vSejMERHuTdjnRfvc4zGWgnfO4xZKN8f386zqwsE2hbB6q5/vgpy3lLa6CCHXFJ1+x2EBNjjhXwfde5RswoxArFVRH5llNqSSwMoecTc1CHSUzLrUkgP+umO122zDgWg/CRwIioiTtlAp00jwZBLKr7OAbPc3nzt+iJ3oRht8otttKGEgnkJGwbYNQAx5Tq7jSxIxdrW5TbNI7MPBX4jNsHLziFSGxg1K66LQKl1iIqf2euWGE4UwqRJTiPWxNfqon3JG7Bh9MMWe2T1C2AxV8RSS30TSjPW4aV3/xuShPQIBqDXOvpT8FJwSvAo98BnjxI4GZbVYaZ5s7dUK5euY4d3LQul9jgkzrQQeIEZaxSzF9kE8BwC+bd5pnDTgU11G9HNVutYDJ0L20E+QNXmGbnArW+rKWYojWG1gdsYQLGk6JskjV+aknaWhHKX2GSSRd+Z8TC/ykyBD84Ize1JSohNyVkBQp20itj5cVA+95TB7Nko0flO+5YsndacuO0y9yKnfS0V9QSKyyqwMbSvwndCT1YHNQK9YnE+KjduR6II1z7+tvuAK8c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261009223027099003)(261022105027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261022075727099003)(11063799006)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8FjRzZXCnmhNlRDAJhh0PBFVVLzkcFOSqwM7tUm4vQnRCg86Fdx9DZoTtQXv?=
 =?us-ascii?Q?AjwM9ktHmTNxfdupS7/Ooexw4WghUGJoErzk/ZqN2PdtUCv7WcYiLkucOBof?=
 =?us-ascii?Q?axTgH6BdGPkgZBhPOzBoYurKN/q0fzsZjTgzN+JDKMyZQqG+Ip50C6t1LTwX?=
 =?us-ascii?Q?bqDrLqw/AfxdicY/fxmFV19svj5Ku0M6lBbxRHJrgCZ0SYw7clV4MA7BYXhn?=
 =?us-ascii?Q?7XI95ehfE471Sqr2rJ0OTx7fhb8lASA7UFW+0P03Zaws2UK9y8dQj57YNnFP?=
 =?us-ascii?Q?WKqVNMQqaaL7N9AcwpBc2ZYU0sCdSmYf+UlSruw2kVw9YcfN6Lgdv/akK8GQ?=
 =?us-ascii?Q?Xxrk5vsZkFT4Rqx0Yw7e5/3HaC1udOpknNF80xnIj3bW7RNI2+StQZ/v+Elh?=
 =?us-ascii?Q?vhIe/9KpHkBkc5T2rdQeacUFTtU/HzMlyKiVwiPmVKwdPRUZIYTKmpv0t8Vw?=
 =?us-ascii?Q?AnS58lbAWJQ0wI7/Z9EWeZOmcC124ZbfXnqfRoRp+9uISHfEstzqTa4dq4aC?=
 =?us-ascii?Q?nzbyVa3twYDR5RAMHSytXwnIciixw7cqER4VCMO4x8IDUKzi5qJMGZbcGIo3?=
 =?us-ascii?Q?3xorbOVX7TbqtKsst8FxGpW7EssmOy2I9VYphAjvY787a25k3NRFysQKPdFI?=
 =?us-ascii?Q?CccWcVekhDmcMt5dvnedqNsERh6AfrMvYZDjEPMZViPAbxLdJLYC4l7GycsO?=
 =?us-ascii?Q?tjbYGIRH8qx4imjrSAGYS9Q5arXmilfY3IODaJjUIcmRwhZging79Jjf3vOk?=
 =?us-ascii?Q?T0KQsCDlZrhAW9Xl53JY0Td/hAduyn7QsRLU8I3N2mddbIy/UIJkdJ9Auqm8?=
 =?us-ascii?Q?bOg9iUPt2sK6Pwk7hXCebeoAzWOuH6LxKPUMgsyancyT6ayBXxINkQLi5jON?=
 =?us-ascii?Q?XpGXLq/Vs1vzUPAUITK2uUuzOdsbRjvN0clB99TAS0CGrPgma359TiWaZkms?=
 =?us-ascii?Q?ViVoWwtqLYWZJLyR+p6gHNTyYq33PAp7xmqTxxgDtZgRlZ9D/phRymACUeqI?=
 =?us-ascii?Q?8IX3/wRcVVJfq2OPkf7ogplZhFZavkM1quudDPYbD+KM9xktPFb/xLcS6J9p?=
 =?us-ascii?Q?I78v7Zt7ansLK6/e4KFSGqRWvoVvefsJUw87+7VxtEL6k+vMQCjC83Tu2v8y?=
 =?us-ascii?Q?G9OxJHlZYyi0mzIvXvNsnf26AzniaFVeIMlGJvIfo4AW5ZejZ7D1uwUqfLNb?=
 =?us-ascii?Q?/uzBIgwsa2+Xk1yKRkbt/YElZ53VXkxulppMQ2ll5kMJN7C7GKWECOZskWh5?=
 =?us-ascii?Q?sxzMQ69MY6SUhIQY0p7n/FNYTXxC23GnUYlLrk/W71RE7S6yxqeie6Wj5Jnh?=
 =?us-ascii?Q?0FflDuwe/PGnUaoxKLJ9IzsfuvRNZgXQ3DZT7I4kCZSd5/oLCuX9Np24ECME?=
 =?us-ascii?Q?49Z31FHHICqkW0bK4irrw7oUWpQonDJB399vMqMPqR6zpIioNYHluYSZXCdF?=
 =?us-ascii?Q?Ex7VDtxJ4KyKQ0UwL7WoqN2bBEuRY7MUT654J+Y/tBp0awgGVFQeZicOiOCM?=
 =?us-ascii?Q?31sXae/mZZlEfxTZWZIQgkKk24+6TVFD0Tad1jPNh28c2ia1coDMWs5HwccQ?=
 =?us-ascii?Q?HiDQRdUo0q3UEZMsOBXTKTucA/vSPTXcypptE7UGCcr35GJBgv6nzTCFJ+gF?=
 =?us-ascii?Q?LnHKRXZTkpd9Kt/s2Ev1BokCaeK9+dfG5T59bGBnuCqQdTYKiVSxpdVz79zY?=
 =?us-ascii?Q?f5d6iJKOloZJaoj6MIR7O1lRlPf/OwMucJ8VHVnym1F/OaBvkWMQ8uoqV0QH?=
 =?us-ascii?Q?32uPRSpWbQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b33a856a-0185-4029-09d0-08df3931851e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:56.0526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjvZGe8+S5N7OXlD0/tP6MEiGWIA/qkN9WgomvLIdomD1spn6AqinRj4pSoK4Pbn7tdfDmuJGKfbXiF4b6WCLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9557

Move the UMR cap check from both MR registration and UMR paths to a
single helper checking the access flags non-modifiable by UMR.

No behavior change for the current flag set.
Converge to prevent code duplication when adding support to new access
flags that are not modifiable by UMR, like the new Unordered access flag
added in following patches.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c  | 30 +++-----------------------
 drivers/infiniband/hw/mlx5/umr.h | 37 ++++++++++++++++++--------------
 2 files changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6f57dfc7f4cd..6848515e06d7 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -127,30 +127,6 @@ static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
 	return ret;
 }
 
-static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
-					 int access_flags)
-{
-	int ret = 0;
-
-	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
-	    MLX5_CAP_GEN(dev->mdev, atomic) &&
-	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
-		ret |= IB_ACCESS_REMOTE_ATOMIC;
-
-	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
-	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
-		ret |= IB_ACCESS_RELAXED_ORDERING;
-
-	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
-	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
-		ret |= IB_ACCESS_RELAXED_ORDERING;
-
-	return ret;
-}
-
 #define MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK 1ULL
 #define MLX5_FRMR_POOLS_KEY_VENDOR_KEY_SUPPORTED \
 	MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK
@@ -172,7 +148,7 @@ _mlx5_frmr_pool_alloc(struct mlx5_ib_dev *dev, struct ib_umem *umem,
 
 	mr->ibmr.frmr.key.ats = mlx5_umem_needs_ats(dev, umem, access_flags);
 	mr->ibmr.frmr.key.access_flags =
-		get_unchangeable_access_flags(dev, access_flags);
+		mlx5r_umr_get_unchangeable_access_flags(dev, access_flags);
 	mr->ibmr.frmr.key.num_dma_blocks =
 		ib_umem_num_dma_blocks(umem, page_size);
 	mr->ibmr.frmr.key.vendor_key =
@@ -204,7 +180,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 {
 	struct ib_frmr_key key = {
 		.access_flags =
-			get_unchangeable_access_flags(dev, access_flags),
+			mlx5r_umr_get_unchangeable_access_flags(dev, access_flags),
 		.vendor_key = access_mode == MLX5_MKC_ACCESS_MODE_MTT ?
 				      0 :
 				      MLX5_FRMR_POOLS_KEY_ACCESS_MODE_KSM_MASK,
@@ -323,7 +299,7 @@ static int mlx5r_build_frmr_key(struct ib_device *device,
 
 	out->ats = in->ats;
 	out->access_flags =
-		get_unchangeable_access_flags(dev, in->access_flags);
+		mlx5r_umr_get_unchangeable_access_flags(dev, in->access_flags);
 	out->vendor_key = in->vendor_key;
 	out->num_dma_blocks = in->num_dma_blocks;
 
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index 04dec726b267..a6c4f35b75e6 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -44,34 +44,39 @@ static inline bool mlx5r_umr_can_load_pas(struct mlx5_ib_dev *dev,
 	return true;
 }
 
-/*
- * true if an existing MR can be reconfigured to new access_flags using UMR.
- * Older HW cannot use UMR to update certain elements of the MKC. See
- * get_umr_update_access_mask() and umr_check_mkey_mask()
- */
-static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
-					  unsigned int current_access_flags,
-					  unsigned int target_access_flags)
+/* Return subset of access_flags whose mkey fields can't be updated via UMR. */
+static inline unsigned int
+mlx5r_umr_get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
+					unsigned int access_flags)
 {
-	unsigned int diffs = current_access_flags ^ target_access_flags;
+	unsigned int ret = 0;
 
-	if ((diffs & IB_ACCESS_REMOTE_ATOMIC) &&
+	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
 	    MLX5_CAP_GEN(dev->mdev, atomic) &&
 	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
-		return false;
+		ret |= IB_ACCESS_REMOTE_ATOMIC;
 
-	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
+	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
 	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
 	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
-		return false;
+		ret |= IB_ACCESS_RELAXED_ORDERING;
 
-	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
+	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
 	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
 	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
-		return false;
+		ret |= IB_ACCESS_RELAXED_ORDERING;
 
-	return true;
+	return ret;
+}
+
+/* true if an existing MR can be reconfigured to new access_flags using UMR. */
+static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
+					  unsigned int current_access_flags,
+					  unsigned int target_access_flags)
+{
+	return mlx5r_umr_get_unchangeable_access_flags(
+		dev, current_access_flags ^ target_access_flags) == 0;
 }
 
 static inline u64 mlx5r_umr_get_xlt_octo(u64 bytes)
-- 
2.52.0

