Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010023.outbound.protection.outlook.com [52.101.46.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC6C35DA65;
	Sun, 26 Jul 2026 09:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058205; cv=fail; b=nP4+NCzKDIs+526jkaPptoSwTX4i/s3o2cl6bGspqbQN+Vi1M9BVsem3xkned7am/Ik60BvGvcV4vTnt6BmAJl/siyVaLSGkClDPPwclv2npR8UfQso5vP40/RSmJ1sxzF67UL3sR+7Ys3IiXSRt/4uGh6chA0E9X0SgOgq3Jas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058205; c=relaxed/simple;
	bh=kqRUNMxNnusiF8KQWZdLC7jZXafJVSAZCu4mssI1da4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KdHEGVhG2sbPcqkF805XOAfTQWK0bmhL8J676FeMhE/581m/1pOjxFFLHBPZO/Dzt3Ch421ZV4fLbw9DWn50M4dNnKpptpYjxeiSl6Ffrq2EVvkcUaH/GX+qOLWeXbOsYbHCGtQYA2KxwN9Tv07YEJbxhfRAVoydJ4JU4rXgaeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TwfZnLTA; arc=fail smtp.client-ip=52.101.46.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TwfZnLTA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OvMb1q4iBAsH2vO716p9h1BZdhnp+H5VkJF/vjzjW7PMf90PlWa0IGdK1ZLNdN5duVhuIGm+cnEyIgAY56mNAMlNZLz9cwJYgf/lBjL1yBz3QaijkzzbEgj2eJ7GweQGGVfbMNAqrze6akYjmuFkCrs9KPKE1xvJVJ/ZkusW++FDo4024CLg55Md2NvP3+W/E8CNEg+dofzIbDooF9442AORAnLEM1qZl8WYxshJnLI7YPM6IT6ch26SiPeRYobY+WlDbKek/B0q8wR7jMHQDShsc1k6rPOTaB8AbJ+bnbYzASCdry51+5drGgZtRl6+pu6x7Dl8LrnRpye4PyMcbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSv+DJjeSNeW5Izb/8SFH4GeS0BVuiZef0YOk0xveYQ=;
 b=QsMVQqn7AYdHVE3AYNMmBwTzf8tS3GifK5EXxuwhRBqtxFmAjFWGsAnv59ZBpi52J3kvIQxqUfbJn5ePmcoXkFr7MHc9uf79lvisIaYF1pu/D4KDamtrM4ZbSzRhpx2QRd/XF93zJox4K02KOScIArHSS6ANvIuWVspYgevOJJi6cwnuJPV442gTtFr6AtDqjODZRKY5r11nPe8X2/dh+1PuwxhmqDdifoeJJg2kF2DCOySHRS2vNhNWrALh9C5WBWQBXTVE7X8T+6p/wcY+bFtp88Y7sebeuZPmlliYQ56KdImQ4X9HD/7PAzMt2sio5yGP71IIostYuA4Ckb+1Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSv+DJjeSNeW5Izb/8SFH4GeS0BVuiZef0YOk0xveYQ=;
 b=TwfZnLTAaFucXXQnphBwkLpVMlpkaIL48vLMDZxYTpz6fpds0UrhIJxcYi82N5dfSLcWigupeTEVS8eMPsiWrl5nmiGybzT99tfRhE50GbnuMvsNsURfEGdaEbI8LMElEGMQ7Msp1hnQewD0hfp/aH63yZPMHZOEtdPEz4mZ5v22GXBO4rVmalAIA6Nw2ttSaBoGdBqhYDAFZW2z403vORarYyi8DLK7Wfopvc0T+MPFgbG9VxOdODAYvveSCuJjEBDi5ArsRu2GnucY3dyRd7x3tRBwo+viURBj6a2WT8VVhp3+l5iQakQRvC5Q29NP3d1c/+59NtfGFtLSkVs4Xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:00 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:00 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	Michael Guralnik <michaelgur@mellanox.com>,
	Yishai Hadas <yishaih@mellanox.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 01/15] RDMA/mlx5: Allow optional access flags in DM registration
Date: Sun, 26 Jul 2026 12:29:15 +0300
Message-ID: <20260726092943.2880176-2-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0109.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::9) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 974e7386-7652-4ccb-1227-08deeaf87732
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	GJplHIkYcro/39SNde4rGe+KSTjRN8gyvXc9ZYG79vtisCEElhhFYyrXblf9hj6dCd5zS4+CpedhI1Zq9wpqARKup6S84tQthunQbiCTZ1OwJhv3UXx/CjdQyHFMTOQQ/rbalDrry2c4eni8RPB1/YfH3Nm9hBHDuwlaqKaCAsHZIgvfyma1hrQOCjNFoPYyriVx3KaC9BDVJpCZs+XVSVBhZiyiUX2jzFtIsyDH2TPH+QAmGsEsBFfjvA7RGmqkahRk2Gy/vmAf01GDrKeYC0gCMYjPPA7rUlkiiK2LNS+wXXeQsBLdQKLTfGugTbEY13FXTPmmdiDvpre1UESBoWjvPv2z711M+4VgQfJVyqNOEQ619Jw0gvmb96urXxbwo94NAGResPOI/CLgXn6aMEvrxBpa6xUpf2vkSJAwvlSfHxFlIY7wZZ5s6pVQqZ30UQaQBh/JdgL+qMpnwVaq9fwz+TOmf9gM+KA8bGlbtHYz+Ut7bi24JYCl99GPKS0ebpw/zzWwmWTyEryIvhdgu2pS6QwawrwumO9c1Jw0GZU/mH9CdzjJxqu6hVmbbbPdh0kZX64H13k5dbvUoQ/EnsBREnAi/lGOsCOlnlGjaqB4/Ka4WYPgoc9wnWvakza7KyMcxROuXowHm1mSZ+haxducnUZuAxDswEMB4zok9Ks=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9t0CTCCJVmSDnL6Op9xl1aSTamq550dhtKXN7qFtfJZlYCYGB1aNHbAvwoKi?=
 =?us-ascii?Q?hX2Zbzyy/MCBJ11mnAhe5OxZJdQf3NLpSQPZl9LBN8vPFJbkRJBuEBRWdDEC?=
 =?us-ascii?Q?/QS/isd8ZbLWphAxqlnoYU8Kwq7WGxZRI9Pv8rQfLURYR07cXS+RLD9PQoeE?=
 =?us-ascii?Q?IRG7kQD16DM6dO5VmzSkctSjmg4eWwiWc2pU6tb81ST1WAWwX/UGxD7CbwqT?=
 =?us-ascii?Q?g1AyVr5LGH50UYJKtcemK/1oM/3YsKL95bi7pw9Y7gKgGb2xD8vlVhGeZ3En?=
 =?us-ascii?Q?P844JtNk5LN/LaDtsIwf01H5flOhFiRMMOT4YCV0N8F59zuBgD8mC3o2aAdB?=
 =?us-ascii?Q?qEFxUeJMBpeyK2D9uVtELAU9tK1BsHu53lcL2Va7n9gkYbwR/tEW0pI6aM2s?=
 =?us-ascii?Q?hUNsYWw8V+l840yCz/9Mbi3PRso8sOaJfyqLaukeDP2XHPfkg+Uif5nuaBEw?=
 =?us-ascii?Q?xlS5jdfM5I9GMVJ3+G2zVJ5Lb4mxsX4EP5U31KaRP2S51URq6UiSyvhW523n?=
 =?us-ascii?Q?lC5CwVJ+o5B0GRd6TKp4fJmendVbYPtqsbYNGcQ1c+/+F4ngJ/JROOvtAlFp?=
 =?us-ascii?Q?QSFQNtcr84xy1xIYodg8kwJoRFJ4dvqdy4DIWvDlM0YuIQPsNkokKBQtOR1u?=
 =?us-ascii?Q?kr4Z7VneAGKhcv2rpeMiDKJ7ELPKT5VLtCKSim6ofsokBdaCwN1PvtcLejQk?=
 =?us-ascii?Q?PhqSovrpv7jwazdnA6EkraztwHXU5b/rbSNRCTwmTyYv0+aFZD8B7NXErvmG?=
 =?us-ascii?Q?9pyzn0pNevHh3kqoBQFMQHVZDDUHPVOO809YSoXwfS0kGgkgXKuyy8NWcXkP?=
 =?us-ascii?Q?kxlxUMrIwrqPn2G8KvPbkHOcRbOp1VQlq0j9FzjRkFNk+yZ0fTfAZWz5+VR+?=
 =?us-ascii?Q?EzZ0n3Bfn6RGYw59SAUw2vYwgRMjuLU5XNxzosWCwGIYbVtJglrlemaAi+FY?=
 =?us-ascii?Q?5dkRwlCny9q87F+KkvFLXU9hqzz1vi3SPGe05hGRYhNYi/btK23yLTDbsNkU?=
 =?us-ascii?Q?ByKeKY3eX/8RgvUMCaWZeTva0E3axTvGbE92fCLZJe++3YdS/uTWfHaspIf6?=
 =?us-ascii?Q?E5Xoyr8Wexpvw8zA599odNJmrITSv2dO+8v/u1ZwrqbdY9/NmBvbZKN6S+Vl?=
 =?us-ascii?Q?XlgRsFuEwOB6SgRk55wEL0/Nigtx18mU70D6IoE78H8lp3FWOdgs3U6GcDL5?=
 =?us-ascii?Q?BL4oulJu9aDMgCfziql+CU0DnfLNgoM0/kfpcKXkJya9k4R/tDIYTOr53XgF?=
 =?us-ascii?Q?ztKm+hQS44c/qSzQ/brQvyCtFz94z47fQf/l5/L/EVI8fJaY0mqyjQqILrfG?=
 =?us-ascii?Q?MPm7XSn2e2D/dIA+U6mgmMVHPCLaPvVuj5fLPWtcfyM+10IGnUlvq7xIGbQh?=
 =?us-ascii?Q?s3kHHMEFB60L9PqRWtKLF1NydlEiT7dpXCmWvDbh4C1SGXHw6oqKldMtRKKE?=
 =?us-ascii?Q?xgm57pDApik1lw14nuEhck0Lvxt1rOQ+J/JLsyKHYvpniD36PyYJFUXaRI6Z?=
 =?us-ascii?Q?g/JzCHmN2mbTA1mHHbXopu78oRfJFcTszlaWhAljgDjQS01CZI8AVatMJH//?=
 =?us-ascii?Q?2z0x0SN9yF8R5havxcuAqzXYBIbSB/eFUeZ5/03v2mNlSGOdMqDj8x+Ykpz3?=
 =?us-ascii?Q?J/4b/zalPmmPEShvUPgP+qthnPNHtiLzALTvRFYTZfQ165Pjl5vQdITlsr8T?=
 =?us-ascii?Q?0pXfHWd2ZPPY6AUh0mEKZ+5h3xNsD/5gcizovbY1ub43AYg2pwNeNtal8ir1?=
 =?us-ascii?Q?WrRgIEClkw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974e7386-7652-4ccb-1227-08deeaf87732
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:00.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfZ2Hdwc/2qzOjTj7vqIPioinzbbaArBanuUdKSyDVS/AmV1VmOOgEOtxb4O+2q4uEdlnTJZuJsN5BYxsyXerg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-lists of DM registrations.
Uverbs users can now request any optional access flag on DM registrations
and mlx5 will apply the flag's effect on a best-effort basis when
supported.

Fixes: 68d384b906cf ("RDMA/core: Add optional access flags range")
Cc: stable@vger.kernel.org
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 522984d958bb..427e7f706c8a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -660,11 +660,13 @@ struct mlx5_ib_mkey {
 					 IB_ACCESS_REMOTE_WRITE  |\
 					 IB_ACCESS_REMOTE_READ   |\
 					 IB_ACCESS_REMOTE_ATOMIC |\
+					 IB_ACCESS_OPTIONAL      |\
 					 IB_ZERO_BASED)
 
 #define MLX5_IB_DM_SW_ICM_ALLOWED_ACCESS (IB_ACCESS_LOCAL_WRITE   |\
 					  IB_ACCESS_REMOTE_WRITE  |\
 					  IB_ACCESS_REMOTE_READ   |\
+					  IB_ACCESS_OPTIONAL      |\
 					  IB_ZERO_BASED)
 
 #define mlx5_update_odp_stats(mr, counter_name, value)		\
-- 
2.52.0

