Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658890;
	b=gVKI0jMwcNUDB/TOtrqjI0g2hHzb5nE3Ijvp7WFmz5iyxRxlP7FnFsp7wCZkvlpw9+4X
	 LzMQuko+DiB7R/ZA51u6qGm0hUf86ZChLkBWrxjWRSRqiWa/VvPw8nrllZLWBpSxXWDqR
	 cqYrG3OnoHS6NxwXCJfWyVVKjWnYGFhp9XnYAOJtIIqSO1IC4SR4kmKRixGNCHAJqtEGD
	 Py2ukTRgjKjWqsxsKCHBRn/ZnrO+hIZqm+xyzPXkxy6yBvZ2LDXjEgq9P2l5N9XyzF8Xd
	 4zerqztl3TVRGgrkm4nRX5zg3yacfWoD/o8x5V6GgR+UMi/i81HjbatSQpS/51kJpGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658890;
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
	bh=IBochIegg1QKhnRV6pXcvLse36YTYVtVgfkk4/H+05I=;
	b=w9PRqkyZqYi6yUrQoDm669jFJOLiFwdY4nMwgtATwWXhDFSMQr35duNTzIdANad9Jqgz
	 iIb9J/Yl5QyQmfvJYkXaHN5l8vcDZnCGoVLHHJtvjPwl5WkuQk1leXPs7UAJT4MNM8Tmf
	 OXtTa9QlbcLYh3aNBNbQXjd75Tn4DXCn8m00s2lx4IdMAKnhIrJsSnHFxpJw2UYBa8r69
	 dPWn4ovnJZPlO2yTPc3mCAcLVuoXEJ1OrqbVySaGEvq+93EUEZxgBwCFoP338pFJkhGUr
	 IZjaU665kq/n3RnShb3XKgztjK6ve1844kOA5yxyVyIBbLLLU3ndWmlGhqKNyBvC1xA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KoilbfFl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.66
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A02606A324;
	Mon,  2 Nov 2026 22:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7A02606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KoilbfFl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ka/QhJJlbYjH2655q7PvJ7HQsaM8ns5vzioQasM5NjuCTBHD0w9XrbyfNTSekODDxUSAET5dR+bQNSjmwp4nFba5wT9x2RScdQJktftTy9n2r/1vden5X9DRpi2nbMoKd1gwfKEzub9cPbGaUrQJ/fAz7I9xK6vhAJVZck1g41dpDimgzlCnmyuUAnL0c9ukDCKikTRzxa1SvC5vvdq4hyxyPwjqEtlGcSEpwp7qDzz/7DExH/760IGVyRTJ3d9Io9WxLRv8xfV5xqMCF5VEZeUQMHXcx1FfPD+lL+hoVkMNGO+ClZbej4m1d4Z06HDnfg92JqEJRFLz6dy6eaDlJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBochIegg1QKhnRV6pXcvLse36YTYVtVgfkk4/H+05I=;
 b=HoDp4kJfCeb09B5wwfHuHW2Q5pn4dvMSpjESe+rA2vqn3O0UxmtdPpNGDtCh15eskFSV5DGgg7uApyElYdVMPPM+1k0NTJRYDN5x2/7kO9h2uP+xyul8z4vZRaDVWoywLemkWmG9V2q/IB5vstbPNxDyU7PH2hsgROC6m0llFJIEngkPLks4ZOLAPPIZsYuJmrMJ3Zz1SBY/IJz1HcpOvnmqZGS/dFi5JP4cu+zeaU/hghxvBFoDA6rWXnTt4EZot/6LMx+PxzI7qIqsf6lNbn5cC0Fti43XjIagihXbdUBjZjEqCboLyx3jdzZCg6Z0BY7ZRt+pYKUbUsnNG18IEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBochIegg1QKhnRV6pXcvLse36YTYVtVgfkk4/H+05I=;
 b=KoilbfFlxOVe1i4VOgVYkNgEeLD7k7IVqWxuvnEBaWg9SONKmP2N7ChztWYCaOYlq8fAdSPl5mwBi6xGCBYQlGugjs8sHZH606LQ2XFPtJ7tj2en9CYN7Sc7IsA+9zg1Gp/UI6o26IDj9EM3UBlWF1HVQGGuUw8501WR0NpyuIFxPQPv8jGrBksB2zxS3cJqRcdiAE4cPyyvNbZJXH6vZDv9ApWNFIuHZ/1Zi5O0c+BCXY5NuMXETOb/EtXOC7OB2K8IkYWm4h3/FPw5G6itIV4XcPU+7seAb24eQfUmM0bfflrjKseTwEawZfmgoIys1dVlzGgLQXs4mr0URb2yZQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by DM6PR12MB4481.namprd12.prod.outlook.com (2603:10b6:5:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:45 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:44 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	netdev@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 09/15] net/mlx5: Enable relaxed ordering on FW tracer mkey
Date: Tue,  3 Nov 2026 00:33:02 +0200
Message-ID: <20261102223325.2115128-10-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::18) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|DM6PR12MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 9112be75-4aac-4998-a08e-08df39317e1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|3023799007|10067099003|6133799003|18002099003|261102123227099003|22082099003|56012099006|261021121427099003|11063799006|261022105027099003|261026140227099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	qY8pKmvHptd64N52xWfN2ApFqcdSDkZrtuASQDxUqRaP6IBRamhi1rzmtCJYhQvQO0tVnPIYJJyTEVrm+HOcE/ySL0CfY3ZWVY7WoAsSuQrSaVyhS1wdb3jKTIOjBq216OZTqaCZeUl+LpCHcj2epjaqTeImIupbd7jls3+kdkgPiUgzVv7xPrXjqD+QdWqs74vsB5qSsGTX4JOoBfnTJbomMFLdsVx4vaBNrzUukUXWGQbC4pi0B6tNipJU/3glVMi0+OQAlgrye1cHV98pd9kUl/3s/Y7CM/FNAIYRR6RTgHC9w8FRWct9NQEL4+i4zx4maO4AfJ8JQaC9nfXnDRN5eRKBFJsh8pzGEUW5c5rKpZWMQBAU6zuryQ0MIBqfzHeePumFfacTBINeZz10SAFPipglFlif4slKUA5e+sEjTbf6y3xHJB84eVwMTrf53ZNvXb85j+OktU5abX81a9YOAw/QPuM/zHhQfXJ2Om4gbXXrdRV35cythlOmtAWZQvNTke3m9ArxMhWkAdqUmV08sXnjOZsiiS6JZvzmT8Jpa3F1/Ruxp8Kt1im+mNJolK+uuA2NVT+/SwP9VL0DlIilDTBOn9veVJ3E9PidCBmTLXu4CUVhvwB+hrWJmK/1IBVd//9ozGhPuJoZ15jpbEtxwGdHOnJqJGWG8JVCEXY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(3023799007)(10067099003)(6133799003)(18002099003)(261102123227099003)(22082099003)(56012099006)(261021121427099003)(11063799006)(261022105027099003)(261026140227099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LTL85xF6dbKfyQTGHcM5wAY5fUziyIMCP9tj6Jzr1Ak/Krpqcm3NGLcPmHpl?=
 =?us-ascii?Q?8BNpuaRnRAdlMzJHWjFk9cWzfTlWdReactuoajbMST28B3rdTeZGcYCOQ3qo?=
 =?us-ascii?Q?avLsr7irVBpXK36ZNjIF37cyZSSpib7LqwjqmfS4wF2F+B1I2jv0uFTMlrds?=
 =?us-ascii?Q?XH4pLBvrlSZWreUUcxgsAzuMp5r6+2RMNdbxR1vmwUNBmJXyT51eJQTq7wJH?=
 =?us-ascii?Q?4x1s/6cuhN2LK3MDOy6Ql4ylCB5igWuJuMtwnOwkGTImyoU4bSvzxJhOIFUg?=
 =?us-ascii?Q?jKAVz5u6ttqtxxRxpjLIf6eiqznEhvOMfSPl6hP6h4aopBY4RmxWJwx9+rCL?=
 =?us-ascii?Q?y+veQd9WbuYFpsdooPpJ1ypS1ympZlCTdoXba7I2XrZh/IFnr9Oo0UG65QIy?=
 =?us-ascii?Q?MkjABgET2fWo0qKXChYmNIzJFf8gcllVWPwn8NMOs6JwcZi1rniUCVA899zC?=
 =?us-ascii?Q?6fzuD/2u+ILsqhzcYSU+z3whDBu8HyxUDqvs8SXxBR5Fijd94LAtr2vMFP6Y?=
 =?us-ascii?Q?Nlm8VTdn16gGFRjTTSxh3Z7+rRzzc+V6ZTJfY28gQf1yNhXHgJ0iY7ndws6p?=
 =?us-ascii?Q?uChtpt0CwvLaBwq3rwJH0qXrc75ldgYoIABv5Dv6V7vbp2CGC9+HFBZMfbT9?=
 =?us-ascii?Q?x1m46/mZYOaERyF/1C+dM0H7qJAnJruwqf4Lj5fPxbUETFU2n8e63vCs6962?=
 =?us-ascii?Q?uh9KpouRRSJPm60BKt1iXczUWOp7+pqr3BaHgoTYYzo3Ta7dUXTdXrUiGNDm?=
 =?us-ascii?Q?Qf8/bWJ1sAjg6pq3bL+vPAUxn/43cgyxjl0KtHRG0d5G/9mOAk+XiHofrf3K?=
 =?us-ascii?Q?bk7rQ7uBBlD4fwK1ffxhxYuxv8bAtEfgxMeff4fcnpwrba2+a5Nq6z2rQ/GO?=
 =?us-ascii?Q?rO66XM0jtpoDa/0e6OAC5g57AkGXcAgVEwIBgNqO5RJoK6HASNv3eG4PTYi9?=
 =?us-ascii?Q?yVnggSmiF7ZwNcT9KhcHduaNhZwnE5exkhnf/w/1ht4C4z6eGcOYCInxBnyO?=
 =?us-ascii?Q?bYldspTQdHvQxhkOJd1GFvPFO2Tf9uCPtwOyzL2edr9rdt++4985kA4ZJBGV?=
 =?us-ascii?Q?f2O+2RlKf+8ozs0F6cfW1St1oOw3+Hy4ypcxyNxHmSPiavgF7PsH1LnHo3oz?=
 =?us-ascii?Q?y+uFaS9TOTMTikDqpKH7Dl5PTBy8ejGxMSKxvj5g5ubfBS8yNwrBpXp6yWpo?=
 =?us-ascii?Q?Du83i4fA10P26AQ+mCzEe5Yt4X4lUw0nyvHgsERABxUalVdPvuENT8G3p/5a?=
 =?us-ascii?Q?QvJ1lkCIYXsFe/7IvJK4a4+MTWxfoK3zqI2HvQRVKi3PzswmE1UCSa1hjDnQ?=
 =?us-ascii?Q?+bdR35yS2sklFZ+sQD4KV7NAZn6N2ihqNhPEJjSrCyeIyOEoboewLzmDu13o?=
 =?us-ascii?Q?P9XE1V1pz7QtCHp2hfLOODy1t9yuV+bs9wBXL8DXbdmV3TTyTbkkHwToZaM3?=
 =?us-ascii?Q?F73eRjHZFsIJXkUMAdGmIkAEGScLXgYM/W0MjwbxJ6gY0JCH6dEqHi9QeswR?=
 =?us-ascii?Q?bvp0BTLD92R2MhJdton6GgUj6HGs0Q+aj26wXJqCjNQO9GlLU1sMqmag7zIt?=
 =?us-ascii?Q?3DxJEpP3edbQn3yLsmB3gkBBLngMn6fFIBDdH19F9Jckwzc5xh7lmc+bt0fK?=
 =?us-ascii?Q?Yy629UJMcbVH7DcGaDWGV9zpqMAkisXNBXWceEtJvQ3H9DoB5yY0+yhAlwGQ?=
 =?us-ascii?Q?z3zTktyy2dV+k9Y98k8vL0iJA2TN++luxM2O/ktHOGar7W4p9DG+lfPYfWEp?=
 =?us-ascii?Q?TrG3zJ+mUA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9112be75-4aac-4998-a08e-08df39317e1f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:44.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfzb3JwzfFEHqcy8FWlxe95/aILRLGEA/SVRUoxf6nOIrH8UF7EAbDvjjeweyv3ApSs/o3sRXGSL1vCIrlPtzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4481

On HW that restricts strong ordering, mkey creation fails unless relaxed
ordering is set, which prevents the FW tracer from being enabled.

Set relaxed ordering on the FW tracer mkey only on such HW, to work
around this limitation. This has no effect on the ordering of the trace
data, as once the mkey is configured as the tracer output buffer, FW and
HW write to it with strong ordering regardless of the mkey ordering
attributes. Strong ordering is required by design, as the driver polls
the buffer and considers a block valid once its last bytes hold a valid
timestamp. Out of order writes could expose a partially written block
to the driver.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 1493d8106c1a..003ba788dd4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -208,6 +208,8 @@ static int mlx5_fw_tracer_create_mkey(struct mlx5_fw_tracer *tracer)
 		 DIV_ROUND_UP(TRACER_BUFFER_PAGE_NUM, 2));
 	MLX5_SET64(mkc, mkc, start_addr, tracer->buff.dma);
 	MLX5_SET64(mkc, mkc, len, tracer->buff.size);
+	if (MLX5_CAP_GEN(dev, mkc_order_write_after_write_ro_only))
+		mlx5_core_mkey_set_ordering(dev, mkc, MLX5_MKEY_ORDER_RELAXED);
 	err = mlx5_core_create_mkey(dev, &tracer->buff.mkey, in, inlen);
 	if (err)
 		mlx5_core_warn(dev, "FWTracer: Failed to create mkey, %d\n", err);
-- 
2.52.0

