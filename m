Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658882;
	b=HYyDGXiZ8xssgglng+bJTqihu9821WfWnMBVBzObbmG0GJ45uCkz6Pgia31/q//BdVDB
	 xsYXS819aubcKGC90CC1sCXD3qOYnqxgbAtFscJit2LjIa1SvDKHGVQiMHDJTsxKhT+u/
	 HUzPeoJcreOfcPqkStHnp4LQE1/SfGECeMKxEeJTV+r6oeuk7Eg510g2GarZBTkxojnph
	 5+WhoUaedvOqfDE1t+gxqB66slnm9RQX5pDzfp3hFN2pY/hz3v+m1cQ6mAujlR1BMSM4x
	 6ocddM8kPTYRD32J/wcDIjmKJM03tAnPCmRiJuQ4BWqhcTJpmKPPxAIrCi+XWAkPMuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658882;
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
	bh=bUd0Da63dHf0pEbzH0gyvrW7S8eLYn0moFSWQMqzGGk=;
	b=Eyqfz5zoVWcPbPTnWvxGG8G2YR9Kj/ly60tuj62GtJbnJYtS3G9ur+z/kT8wsntQp3vw
	 36OOFSlxR+glZ24vx4HFCT5QwRmXKf532Wm8FdFRTEU0CVHB/ybFB2IR5S1jsptIzDmU0
	 4xP5gLXQ+QJtsfIiYQ6E3xFf3b66aq7nmjyJO8NTwoCXWPIgQh0/5fKniW8cftoXjm4IR
	 i33ubo8gBrlfbi2NCbbEHiITEOUfTOFyroXHjw9psNIrMT+YJ1x30tY308RGQahvOGiqb
	 vneacNL+HXEJvLNEeHUY0Ill5JVXAvMyMWOCTfBAD5A14c8Q1LvbJTqzNJuC4FNnd1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=H6PFGbEC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.32
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215A1606A330;
	Mon,  2 Nov 2026 22:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 215A1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=H6PFGbEC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQpfFAgaRJQMi68TeCE8/gi0QeyXGgKirdji5kPwzZNckx9mEtNPeu8sPKAEVEPffC/5famVKuTBL7Gj968XARBZFSTfL4ZOmuQcn5+G56+nIJ6z+HZn+Ay4dcs2Dv6UJX0Hi/7m4kQT06/oBvlDg3rKa0QgX3QPm/xfn896QAvGdQomyLsvOm9/bHFhZvYUU54I5f+vWC3pHbSHpvJfsLSTNPmev8vF0sh45RgZb/NLiAtzHcu198g1VQ1iYmwmQKQhUWF/94+RLwJTs9k9VCxOFGcyi9LWc990p3rncUYTgSkwg6PAzNBm9ik7eM+bpgOh2kaGQaOZkRWYWmSSbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUd0Da63dHf0pEbzH0gyvrW7S8eLYn0moFSWQMqzGGk=;
 b=ga4k/nb4POywXM0UGgZHE6vmLcKfNgWTFRVaZpzXQ25QIsxvCSUrrsk3i42MEDK7Yk54aFEb7abU93XMYcNJydUfTQqDgGTvd1IubjpBW58HfJLE+z4o1Dd6H0upEteYYtBemz1VdYghghsMRlIsd2fzlTSjppxEnV3BZNf324I6hKRjVQhvovuqrezPLD+S2ZYDWE51cx8pXw2jZPHB7UF6zUWr1qTwnRVz4+TBk2PVkNOV1WgowbzmGg3OtncUh8naKvLYMTULSCOWycoMPIVN8dhb9A6F5ZIux74uEJ46Zss2O/8NuAddoDf15JJw0o1eJ6kNZk1sKcxe0jiRAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUd0Da63dHf0pEbzH0gyvrW7S8eLYn0moFSWQMqzGGk=;
 b=H6PFGbECSw3vRIBv8WGH33BNcXGp3ZbK8PHp+sVAWus3bId5QTdsOvzxUkqFqKHVxa+lgGNIt7Ejv02O3QTtNFL7jPRQZ+VJVWa1gVPKXtnJY35YoPElM3c5msktbMeAB4z9IJzdcNWgVzqCkyluseGjOH4e+QI99I+ih+vWZxWwGSkWcxp2KuQFKfXphvuRxl8IjRmGNBI3OnxWPwdZ5KiJAJkStfm7mm7Gp4E3g3el37O3qg1bZZBZVoERebYBISj6VtLCFSFLny4lrLYFU+7Rla6Cqzq2HYmY0Mi0XACfWFJJGK0evsQoX55Cfgcgj9CGOQ+nHSTR0N9NQjPm6g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:38 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:38 +0000
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
	Simon Horman <horms@kernel.org>,
	netdev@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 08/15] net/mlx5: Enable relaxed ordering on resource dump mkey
Date: Tue,  3 Nov 2026 00:33:01 +0200
Message-ID: <20261102223325.2115128-9-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0146.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::7) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: d536bf86-3ebe-448d-3b14-08df39317a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261102123227099003|261026140227099003|261028144727099003|11063799006|10067099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	cncGlkLrBuDIcOds4efrWfu7rsemnkYnz+ur63rCmhSnZaqDh75Xw9rgsSqB+rOb3RwiPBBdlgB91Ws+og05Fd6du23LLXjXj9QDdtfeh2vv0bgNBHzXzfDGgOk+NoM8uPQ2x8awiU5OucZ4DMY7AUDQAN8rIf3uQTlfICf1uvjXvvChGe3KGSA0CCQ8Azu8fBbtLcfvm+jwDaPdfszkPEK+hBHdH8mRg/hRn7dQymgD8uZMccwyIZCmOjnQy2qdVGzYtiv3GHpQbElnrmTYLF1SzlD9p1/8ICkNiDXsIXkrjKuOIkG/nkNztk8KP4B+w3TvuNtzOSj+DjOuXY7vHiZx2x7MRApzSPz9vB6hHL5incp8xcuxpY0t9Rt33p0sXyn4K7MDUT6nXVHdnTk4Jgb2rJR+7Qecx1qRT3OLVtK9JsjpqqEYXJhz0df9B5G4VXR42QDO3bRHyz71+l11tuRHG/5vnZnL9TWF8fHT+yAe+zjplJWapis8+w6vuO3zkzG9q6dW9AZvZA1nY9DElpy9IpzWDay83CRD4kCx89lYTGXjDIoTKw7pFQs+irQe8NxSUC7iTSbMFrwiQ7xHZAC5iUn46qCJynJFQg/mkPAmAR0zd6wKMcFs4YFluzrbR/Pkmj1NZ8Rc48xF0t6n2ZFvc6fJHf2+go5tK+ZdYI4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261102123227099003)(261026140227099003)(261028144727099003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PUpxF8zM60W0G/7hI8yAd1HN1OtR5hMctk+HD+0d9bUL+aUCqhnwgHtFbQTg?=
 =?us-ascii?Q?daYYVGnx6WlJ0C0KdAuPJAKi9zBVp/Tj3Fs39SLhxIkD431cSxnTv/sVhknc?=
 =?us-ascii?Q?9c8/XEeSRgkPxxGKf8C5cgJp9trJTtjHsmaGo/6xrlKQ/xFHbyScJ0dAClHN?=
 =?us-ascii?Q?rqmx3CrHN1NW8krHpICKQyZDhT0NeD1khlJ0vtL+f2SFHuoLiZvNnJlVrhYW?=
 =?us-ascii?Q?eiXjYYHE6jFvc6PARhyX3SKjPk6z3F8sJrxtqBT30dXTFk3kG+XVxOzI5Mt2?=
 =?us-ascii?Q?+FciL6UOYANG9Lk2M8QWyJYnlYs8lpRtRntapWHb1au7CLK+LF6YO1w1nFfg?=
 =?us-ascii?Q?SZ5PXu7tYM9MVFMxR9LtfaqR9QfQCVD7r0NLxsyXz2FxiKwRD8i2+MP7rigS?=
 =?us-ascii?Q?a1PSAANIPs8VnIKTucmVWnaEfj23sz7HWfJaZR2EiGge3CN9ES8nRil8XA8g?=
 =?us-ascii?Q?VFeOy/kqkx8CtNNhuKWwPeiI3fbR8Cvc2v3LahS6xjLpmA6cQkbOP9ClhhLQ?=
 =?us-ascii?Q?rUmMb3kCtPjhNQDf0SMd2h9b9weio6jFQILeRNYNgkb5gU7ASADjkaKio5my?=
 =?us-ascii?Q?O07hZvrwil1eDhskpoRloHWciZLNy4kNXjHxiAouaVXMY5LArq2NrhAXPub+?=
 =?us-ascii?Q?YBqHpLRyTJfaAPtso+pq4A3NbPcmNFeNx8uFmNPOYHEvESGj6foBHbZ5OPe8?=
 =?us-ascii?Q?bkUVJJ4opzHd6VMycKJlcUq7rlWTybAVcm2TnIOA8ZuCtSPLSRmAoTsHpGZC?=
 =?us-ascii?Q?uqNVrY/nVsck0ed8ZPnbA8/pHENLDdm3cGCB7sJsenXsqQOZW7l56o7BA/3h?=
 =?us-ascii?Q?rKCMlPW5ts3aUSa9YNxr+yDAITCW0aEB+Tpn1gDr0NFJ6bPjhllv4hab3N0D?=
 =?us-ascii?Q?6pB5X8quWk8BZAw4KAiHlRby7bby2NvGjLCcJ84Iv/j7iJHQ7o3shR4yHt1U?=
 =?us-ascii?Q?imeHaY0jRIKkG5YpJsVWTqc5gxK6TegSc/vzV0kxfZ4WSyWC0Ntr0u1vvHZg?=
 =?us-ascii?Q?l5MvNs1YX+JtiGxVTyhSVB1FBWT2wIx63ledk01mwDwgYhiQt1OzONFo/iPn?=
 =?us-ascii?Q?HPZ+yLIp9U2vseIXtfpz9erwUlsE0GTUsI45ShbrMpXOSSbaGByFRuhuKZU8?=
 =?us-ascii?Q?CjewIKSpvzzk1muL/D7Lu5sjwl0MHDiu4AMjmUX7CapWrRn0dWsEZY83r90Q?=
 =?us-ascii?Q?4JJCfmQnbmMG/FW4aqFsqsq2mY+xZeOT6LfxBrN1C5lDE0CxTM/BZsHB76YI?=
 =?us-ascii?Q?32OlgJ0qR06oE5oY1igDvXPAAMAYx/Hh5VB07nI/eJ85d1tIDvyoXYZeWaQm?=
 =?us-ascii?Q?R46ryqMhQR/kD+v3AT2uFXukfNsjLECq3XxKhm3c/GGr2CrINVZOhgnVmDde?=
 =?us-ascii?Q?LKc1C2JQnIK1Ch5FCZDp7ThblNW/frFEVPKCeZeT2ew3vQ6LzraCKlqV9e2c?=
 =?us-ascii?Q?DN/UUJZnsgp9m73QOb9rGm0PI3jIwguXkQRbaILEIeiIUjqMlhxd6nDE8QA6?=
 =?us-ascii?Q?DhkNVsFnwLIBRC/fmEG/QjPkpwLAx/FgEJHnBy4L6muP40M1FodvV9D6U95O?=
 =?us-ascii?Q?7etKMRz5CR9IkzwxSU30wQLVOesMXzoZurXGJEGNpTNTTd1t42+W610gY3oE?=
 =?us-ascii?Q?+xr5EjpIqX/dxhNlDiG2mnBw/w0JF0mFkFgsnoW/MqfgbFbSWrO1z7vMwDbJ?=
 =?us-ascii?Q?fkDO9Qc8lNnpwMhutppOuqDd0O8ovR8bsN1fSXW5i891qYDTy1hSsdHZWv3z?=
 =?us-ascii?Q?76aK21BrVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d536bf86-3ebe-448d-3b14-08df39317a73
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:38.1457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4U2DOBgTdQSgIBxBR7otzyifqU6+qD/QwzYxy1NalKhXzpFo/oLRWdVIeeAF4ujTezL7oVdyPshc6AuGJ5SyuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

As resource dump logic reads data only following an event that is
delivered with strong ordering, there is no need for strong ordering of
its memory accesses.
Add relaxed ordering access flag to its registered memory, thus allowing
better performance and allowing resource dump on HW that restricts
strong ordering.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 8044419fb5eb..5b88cd009472 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -236,6 +236,7 @@ static int mlx5_rsc_dump_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
+	mlx5_core_mkey_set_ordering(mdev, mkc, MLX5_MKEY_ORDER_RELAXED);
 
 	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET(mkc, mkc, length64, 1);
-- 
2.52.0

