Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658867;
	b=HdR+Pqmto9OhcukQ5Gsggf7YpC1+Q/dZdh5C8A+WCjrDlYURkuPRm7lB6BE6JU4mHf6C
	 98Q/0Jq2pc4UWqII+yHhRM8Al1ZNfAsqwV2dAYZvTvK+3ycrMTSadsEYDF8oaU68PPH3h
	 qN6X2Vug3PToppppzsL4zMs7Z6oU1cNqaKDEW0dtMnhK9aQcFN+/NRA8ru3CNyZphRMvU
	 dMrIDDUsI8juUWK144/nEdD2dO/RnLiz86mUo6QxowiiRFNh1Gan/PmS9RTgHFhCsu/b6
	 H1jZMjatB015vHwaJtK++aj8GoNeWYXuT+k/a1JfrBcFP8vZzmw5Gp5NpnfIu42JcOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658867;
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
	bh=4OwC9MzeH9hOHOKtnAqRp6ZfExt6VpVwCKFMaql1SGI=;
	b=W/NQtv5FbXFxL2Sen4RsQvMoelChcrUCKV31qWlMBmIAeiAR1Ut0rx+rTpATHmXWp1yW
	 aNeQvGD9ZqR8aEqGEFoIusRc34dOYTAksbTQI04T5FX1m8XRNW8+tZmONfZHL5ZvVxESN
	 e0Vy85WpXbnEidZbm23xPpnQecdCTxtVMZIJUVMZnNwn6ogEBMw0moBYYrwr8F67S8qo6
	 zOJaFHoMQVpYIf9uejOE1vNSCCot8eWn6h9lfi5i2p4OvCLf64+R+SmNWOFX3FKHoHmOz
	 umNC8vFO8O/AS65oOHnO0NGF9zYaKHVv7SW/onxfpcxZIGIyaITLN//cH979J7skwKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="r8L/KDzu";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.31
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B9B606A329;
	Mon,  2 Nov 2026 22:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64B9B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=r8L/KDzu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qldViUtU15KTgElC4mgDawsgrkSqPmWbCybWYWB5jqkWQ9qjOAXHkPhxstSXTvHwcHc1vfcvmZ9z+B3jNH5VPrbop0b2mGCsH7K0kKilqEfHdXy5cNcCIxO/URmDh+wS6cVoFJrm2qzzffHPdZREprm1zqSpY+wxYE6KDdZckElRIa+7yhV/thfjmDk5CJxWUlGCVKx6j5iufXI+/GA1vSuNCvLmML2sbfXW8cYEk7PHz2krNJi2PfsktNiV9Ybp0RI32pH2ewx+TTT1BHgkN4A1Lfx9F/x9QCQ5fc3TQXa/zKxAE/24TQqRdE5FnswqYx9I1+ZUeM2JH6FEht1xcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4OwC9MzeH9hOHOKtnAqRp6ZfExt6VpVwCKFMaql1SGI=;
 b=n8f+9l7Rbr0u527QrcyCJb26yOgVI4ykD1HjU3dcsTPBXeUR+EsaxVSswzfyRtMABuW96YfQl/BKZYOaRkLvf/BnfNgXln0AMc312I5kUarojGPZ6QYDfW1S4MgPBxipfWZTXwyDJkohHzfpO/AlUnNQfO169HITJApHjhj08vDPSk3zg7gIJY8GpczyQbBCJMEEsCfGhVsuxvYSDZ+jL1Q9gGap0EjGIYT6FjaVdSdxM2C3Kh4AF5g2/SoUoxoXCoVv7VJ/o5y0X9/M8Bfa+EG5petOrCFMeRARoPuUyrqcXXJ7kqYl8W0gLQP18AKvOE49z68sBa/coYKsGPrvKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OwC9MzeH9hOHOKtnAqRp6ZfExt6VpVwCKFMaql1SGI=;
 b=r8L/KDzujMQ8yy7q7ZnXBNiHg6M4NCXLrV+Po4o83p1+s1SRE23wGROPV9Et/QZcgVFmu7nMHJNX6EbzCwToshBUU1vSVLEtQQb5QQCvo7isrloppvO+kBgmEEjLRBLX/fIqYS2+3N04dvQolR73s8Gsuh6gDtazAvzKCEAHw9L9EILdtq83bqeoxVS2K9n4qpRq/QbUJD/F57WstF2StDYVaMAeDF7bJZ5E9nQwqoGhBkU3lhzPgQ7Q0WjSMLkrFCGl1HzaoSalG6PXWlfs743z4XNzF3ToRpExmL+y1xDKlyVYdne3hZp3vUj8Sd5TwX7MALb4bsme2AoOKgHu1w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:21 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:21 +0000
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
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	linux-kernel@vger.kernel.org (open list),
	netdev@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver)
Subject: [PATCH rdma-next v2 05/15] mlx5: Rename IFC bits of relaxed ordering fields
Date: Tue,  3 Nov 2026 00:32:58 +0200
Message-ID: <20261102223325.2115128-6-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0019.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::14) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: da860e62-05d4-4a86-4ede-08df3931706a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|23010399003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261009223027099003|261022105027099003|261028144727099003|261021121427099003|261021123027099003|11063799006|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	tCmh4fO8dRXOxbSlUCyjrubQf6UqQlXovQJVLlchWt25IMnjaor9h1rmFTrwOHn9LUiiV4IAoUYfjUYo9LSNgYKYqlkHIA5gYKTh69a8M7ikEgoE0YbfUo+k/X+eT2WOEUo6dqTC6Jroa20QA7RfZME2JuQQlprTCAkObFezDB2U0AP3rocwU/56M+Js07RBcGZyBpxYdy5MmJvqkz+Yd0HmhXGn2ny7iwOx9W+eGQAm/Q3VVuuSxAn5mqrsEoUD90CSoawqRlHzXesYIIZXfZnfMcNQn+7uOe9FCUX8dwiDtyLyza2levT3bzORVkmTMdkul2E1pQ92aSXcQnki0pBAO1gf/k59uihMJVPQGJEjyqJalOYozbZvxMvjtaksjyX8rZzul5j5QXNAWp6IyvbSej1zrGXtltPI6Z3p208bgA73H9brRHuZ2E5ciD30Qqn0hkUwLtQdyDN25i801ZLGudGLnf0u1MXsF2YtzinOcvVdu4elVNv0dZrYuNPx1OiuYgXVdV35feAbmatFXGOSaJ5/HrdKgn/HoRNj9Cin1B8YzOAqcwrQeunyz/yh9G2Y3vTbOybQmGyBTik54cqEmQejlJ8xwR1PMjxZFskI24i38W7X6dYlNUjFvOSntEaSEkXCnQN+hVaYTbwBtmvZJf11rxdoo8eqNvsANLc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261009223027099003)(261022105027099003)(261028144727099003)(261021121427099003)(261021123027099003)(11063799006)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KV+XaVGwsagXA8x9DDfNFmRNDA+DLvs/j7KC5S+jZ6CRKGhc6QXiYDbe8Vsx?=
 =?us-ascii?Q?jonYogDU4Du2dncTxOZZjojxHsh4ruA3deDyzN2fLqLT+c+gtBONO8fH9qBI?=
 =?us-ascii?Q?U5zP3IRjBOvofe7Hf2qtbwoaSDH0RNDaaJ1DsG3g2QKz2XB2jg1ye5RJQcLi?=
 =?us-ascii?Q?ivI9/QBtEv7IbT+m73Ubo8FNpW053DYRmQxFRqxI5tbWyMK9Rrzr4J0n9wCd?=
 =?us-ascii?Q?oHTBh0ioq2nJOw9qxV1//vMHr7s5TlP+GHIKAkCzNR+LNdttzZ2xr/6Y1bQ4?=
 =?us-ascii?Q?V2V6z0p3LRjmn/9mVEKjDMDaTAuko3GxVfrbq4j7Fbr4HmQEA/gwqjwXTBbs?=
 =?us-ascii?Q?gy1bZjdtUCRDNQDZhZT+EqyFJJ0wJQt1tG1P1vF7A8Hww2t3z/3lnKTyRGvE?=
 =?us-ascii?Q?OkNvGt4CvEs0eLNQgP7JoFh0IGWXI/4L1/Gr8m4nN4TYrFCPl/sGrezE3duh?=
 =?us-ascii?Q?3cMnEWfyh0lzkxBmUwrpGlM5FRxYY5X5oTMflqTkvel8IMgHREVTkgyePltE?=
 =?us-ascii?Q?MtsIffGqDZnfAjPM8OxxPkCUxCJYYJej5fqTiE07e9AguE5l79k6Hb3mxXiY?=
 =?us-ascii?Q?PqAOWbPRoV47z2QxK6f3z9KX0C7AlmKWRMZ81ip39xpgGsGiUQLvthYmMFzn?=
 =?us-ascii?Q?AIbj45mJ0s7zicRUjipOEUa7OFD5xYyAhkJLjqzeERQpebEdEYVKc19mtPzJ?=
 =?us-ascii?Q?HR+xBr6uE+XcL32tUcJgmNkq40Csrk1X/qYzq/YWYGz8hSaI7Lp5/SgZl7SW?=
 =?us-ascii?Q?BZRAlrEYXUhC8Kx+qzPfclC8ThX9JiSXjP1yHpCgbgV1jh0KvbI7WM7XoNhB?=
 =?us-ascii?Q?Lunz3VygCo3T7s6iRu9P/Ca5KQEEjOn5siSyZox+59rBkiLaZ9GO758CIgYb?=
 =?us-ascii?Q?mXcaL2tsDL/eHPHtEcDA9fyW2qo0bTjXMLIq33X5pn0ahtp3X+XbJow0K0cg?=
 =?us-ascii?Q?iXGEkc5cP3TaKGjDJd94A8AAoWUiLuxRQE45gI7QZloKbxuMooqQzcEtzNXd?=
 =?us-ascii?Q?rkVJnXr2Od1/Qk6LxcvNewITwlKhDFBSiAPGq+r7NFGNmV/18OrX1J4wY0V7?=
 =?us-ascii?Q?OXv9sZ8+0Q55riMqkL2ZUSnnnp0cFHpHu9kUi3pCHCzndXf3DIpyn/boTqbI?=
 =?us-ascii?Q?pL2XIs/4TDAZm00EKo194NnV8iDw7t17/u7GNcVE5Z8yA/7N9lpcxoPJtnvs?=
 =?us-ascii?Q?8jQ5FXc/YOdAuimnMYULiN69JsWwONHq0Z00D8bf37iJBMw6pz/OkwiwvC0g?=
 =?us-ascii?Q?oCk5Qvx9vr+7H1BclepeZQB1cyIrFQAf6hpr+uxhruTW5Q5BJ//S4HHXavx9?=
 =?us-ascii?Q?+P/NEBkUTwxg4pKxBPilRj3YHElm9Ir8FLhYKobnNtoWNwIe4KVstRkaaEV5?=
 =?us-ascii?Q?LRg80URTENM+zRSGS0FwgvpJBt4RZvyvT2AshkRcOXSRYiTCQXuqatk6hMUD?=
 =?us-ascii?Q?xxznaG1vBOruI2znTSMbnbWXr1u3Mh05U9DEqj4OqfFsNMY+SvkaH2TDve4i?=
 =?us-ascii?Q?D6n4Y1heBY/hMfCC3Dlfr7UrJUbSXm1R5RiYbwXac3yNx25yAOUJjw3XxZrV?=
 =?us-ascii?Q?bubKiO/+zYyQg3nHgOAPzJrB6+iCmJ9+IPtyCF3g+1/BekR0nSOqw5EPJdF9?=
 =?us-ascii?Q?xK2OllYc5XxlQGsmRvlzSwWBVONcWy3p8xSHdHgFB4/o00zmuWDDD/uML6T8?=
 =?us-ascii?Q?ElqJxEH0HMex77JElW1KnRAywWQZnuDaTIfPgUs5Rn5vY6UkG+UFTI69H6mS?=
 =?us-ascii?Q?wSXIsHS8fw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da860e62-05d4-4a86-4ede-08df3931706a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:21.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NvVUN/eTnzKnIkyOjWXHR4VLY4e+kmSqs1YRgV41aUryUgvA10JDCYjrp+3fMRlfrcNi4igxnnGCJzrsRWgug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792

Align the IFC field names with the new naming:
- relaxed_ordering_write_umr -> order_write_after_write_umr (cap)
- relaxed_ordering_read_umr -> pci_relaxed_ordered_read_umr (cap)
- relaxed_ordering_write -> mkc_order_write_after_write_ro (cap)
- relaxed_ordering_write -> order_write_after_write (mkc)
- relaxed_ordering_read -> pci_relaxed_ordered_read (cap and mkc)

Update all references across drivers.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c                  | 16 ++++++++--------
 drivers/infiniband/hw/mlx5/umr.c                 | 14 +++++++-------
 drivers/infiniband/hw/mlx5/umr.h                 |  8 ++++----
 .../ethernet/mellanox/mlx5/core/data_direct.c    |  8 ++++----
 .../net/ethernet/mellanox/mlx5/core/en/params.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c  |  8 ++++----
 include/linux/mlx5/mlx5_ifc.h                    | 12 ++++++------
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 176f87ba062c..a15610c6211c 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -71,14 +71,14 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET(mkc, mkc, lr, 1);
 
 	if (acc & IB_ACCESS_RELAXED_ORDERING) {
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
-			MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
+		if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro))
+			MLX5_SET(mkc, mkc, order_write_after_write, 1);
 
-		if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+		if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 		    (MLX5_CAP_GEN(dev->mdev,
 				  relaxed_ordering_read_pci_enabled) &&
 		     pcie_relaxed_ordering_enabled(dev->mdev->pdev)))
-			MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
+			MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, 1);
 	}
 
 	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
@@ -146,14 +146,14 @@ static int get_unchangeable_access_flags(struct mlx5_ib_dev *dev,
 		ret |= IB_ACCESS_REMOTE_ATOMIC;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
+	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		ret |= IB_ACCESS_RELAXED_ORDERING;
 
 	return ret;
diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 711075e3d9ea..144cf851c41e 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -59,10 +59,10 @@ static __be64 get_umr_update_access_mask(struct mlx5_ib_dev *dev)
 	if (MLX5_CAP_GEN(dev->mdev, atomic))
 		result |= MLX5_MKEY_MASK_A;
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	if (MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE;
 
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	if (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		result |= MLX5_MKEY_MASK_RELAXED_ORDERING_READ;
 
 	return cpu_to_be64(result);
@@ -88,11 +88,11 @@ static int umr_check_mkey_mask(struct mlx5_ib_dev *dev, u64 mask)
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_WRITE &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		return -EPERM;
 
 	if (mask & MLX5_MKEY_MASK_RELAXED_ORDERING_READ &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		return -EPERM;
 
 	return 0;
@@ -446,7 +446,7 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       unsigned int access_flags)
 {
 	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
-		       (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+		       (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 			pcie_relaxed_ordering_enabled(dev->mdev->pdev));
 
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
@@ -454,9 +454,9 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, seg, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
 	MLX5_SET(mkc, seg, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
 	MLX5_SET(mkc, seg, lr, 1);
-	MLX5_SET(mkc, seg, relaxed_ordering_write,
+	MLX5_SET(mkc, seg, order_write_after_write,
 		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, seg, relaxed_ordering_read, ro_read);
+	MLX5_SET(mkc, seg, pci_relaxed_ordered_read, ro_read);
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/umr.h b/drivers/infiniband/hw/mlx5/umr.h
index bda7123781a9..04dec726b267 100644
--- a/drivers/infiniband/hw/mlx5/umr.h
+++ b/drivers/infiniband/hw/mlx5/umr.h
@@ -61,14 +61,14 @@ static inline bool mlx5r_umr_can_reconfig(struct mlx5_ib_dev *dev,
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+	    MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro) &&
+	    !MLX5_CAP_GEN(dev->mdev, order_write_after_write_umr))
 		return false;
 
 	if ((diffs & IB_ACCESS_RELAXED_ORDERING) &&
-	    (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) ||
+	    (MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read) ||
 	     MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_pci_enabled)) &&
-	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+	    !MLX5_CAP_GEN(dev->mdev, pci_relaxed_ordered_read_umr))
 		return false;
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
index 5afb11a2a9f0..b2eb2cb0d734 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
@@ -145,13 +145,13 @@ static int mlx5_data_direct_create_resources(struct mlx5_core_dev *mdev)
 	mdev->data_direct->pdn = pdn;
 
 	/* create another mkey with RO support */
-	if (MLX5_CAP_GEN(mdev, relaxed_ordering_write)) {
-		MLX5_SET(mkc, mkc, relaxed_ordering_write, 1);
+	if (MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro)) {
+		MLX5_SET(mkc, mkc, order_write_after_write, 1);
 		ro_supp = true;
 	}
 
-	if (MLX5_CAP_GEN(mdev, relaxed_ordering_read)) {
-		MLX5_SET(mkc, mkc, relaxed_ordering_read, 1);
+	if (MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read)) {
+		MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, 1);
 		ro_supp = true;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 5caf7820a136..b0fc1fdd1339 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -912,7 +912,7 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
 {
 	bool lro_en = params->packet_merge.type == MLX5E_PACKET_MERGE_LRO;
-	bool ro = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+	bool ro = MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro);
 
 	return ro && lro_en ?
 		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c2d4bae533de..2dbcf6673916 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -40,13 +40,13 @@
 
 void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 {
-	bool ro_write = MLX5_CAP_GEN(mdev, relaxed_ordering_write);
-	bool ro_read = MLX5_CAP_GEN(mdev, relaxed_ordering_read) ||
+	bool ro_write = MLX5_CAP_GEN(mdev, mkc_order_write_after_write_ro);
+	bool ro_read = MLX5_CAP_GEN(mdev, pci_relaxed_ordered_read) ||
 		       (pcie_relaxed_ordering_enabled(mdev->pdev) &&
 			MLX5_CAP_GEN(mdev, relaxed_ordering_read_pci_enabled));
 
-	MLX5_SET(mkc, mkc, relaxed_ordering_read, ro_read);
-	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_write);
+	MLX5_SET(mkc, mkc, pci_relaxed_ordered_read, ro_read);
+	MLX5_SET(mkc, mkc, order_write_after_write, ro_write);
 }
 
 int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 697fc9387b73..8531d611fa9b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1711,15 +1711,15 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
-	u8         relaxed_ordering_write_umr[0x1];
-	u8         relaxed_ordering_read_umr[0x1];
+	u8         order_write_after_write_umr[0x1];
+	u8         pci_relaxed_ordered_read_umr[0x1];
 	u8         reserved_at_d2[0x7];
 	u8         virtio_net_device_emualtion_manager[0x1];
 	u8         virtio_blk_device_emualtion_manager[0x1];
 	u8         log_max_cq[0x5];
 
 	u8         log_max_eq_sz[0x8];
-	u8         relaxed_ordering_write[0x1];
+	u8         mkc_order_write_after_write_ro[0x1];
 	u8         relaxed_ordering_read_pci_enabled[0x1];
 	u8         log_max_mkey[0x6];
 	u8         reserved_at_f0[0x6];
@@ -1951,7 +1951,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_320[0x3];
 	u8         log_max_transport_domain[0x5];
 	u8         reserved_at_328[0x2];
-	u8	   relaxed_ordering_read[0x1];
+	u8         pci_relaxed_ordered_read[0x1];
 	u8         log_max_pd[0x5];
 	u8         dp_ordering_ooo_all_ud[0x1];
 	u8         dp_ordering_ooo_all_uc[0x1];
@@ -4528,7 +4528,7 @@ struct mlx5_ifc_mkc_bits {
 	u8         reserved_at_2[0x1];
 	u8         access_mode_4_2[0x3];
 	u8         reserved_at_6[0x7];
-	u8         relaxed_ordering_write[0x1];
+	u8         order_write_after_write[0x1];
 	u8         reserved_at_e[0x1];
 	u8         small_fence_on_rdma_read_response[0x1];
 	u8         umr_en[0x1];
@@ -4570,7 +4570,7 @@ struct mlx5_ifc_mkc_bits {
 	u8         translations_octword_size[0x20];
 
 	u8         reserved_at_1c0[0x19];
-	u8         relaxed_ordering_read[0x1];
+	u8         pci_relaxed_ordered_read[0x1];
 	u8         log_page_size[0x6];
 
 	u8         reserved_at_1e0[0x5];
-- 
2.52.0

