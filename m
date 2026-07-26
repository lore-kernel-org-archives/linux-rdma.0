Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C5B37189B;
	Sun, 26 Jul 2026 09:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058252; cv=fail; b=mFR9/kBytqRMgC8PhrHQaYMl3/Q4MVAKWkh4+h/e2YknolM2eSZSCHgmMNuQtI5IIruM3ph+HuJq6BVlQoGbm4raLTsp9aSYcZEnUIDg+8nHrZEWZo+sGases6cSzUGiW0asRRgvX0Oe4IUyvpp2Krvuh6HVOPBCG0x4QpdKgRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058252; c=relaxed/simple;
	bh=Tis9V2QwY/89undpNGuB+9HcUCl+QBmZ9tXVBXD4III=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UMDRcoXz7FcE2gaggyINzgq1Ube24j8fzrs2sUupgKyZBB+B3JPvCuXp2r2AFbi27Pkqy/qpwhmR8ObGkUbkdlZ7sMbUkGTnShAIbNVvESNdw6thR37ypkLu7hDEN+vFMJEejFT0S7Z6YQA8mWRpzUTdsovePuMunWfRCnMjAjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P+VO/Ivn; arc=fail smtp.client-ip=52.101.46.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P+VO/Ivn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBJKIeHDHbvW1PLq55jAgJbaayuzCFADKaeBwu0dGcnmyeQs5+msLHOHm0NVO72JXaeozVfBOABqAGEuLFkSwj8utiqeVnm8MYLpFP46BhzEDyAsBR3eYs/7yXnfPdWMCtIi0TEEkooQiBlZIGE5MSeLQQJoO8jyInN/ZI9x+hShayS/1Wzs7hqcQRvvNdSDIMBz8E3LnQmOEQ9HKjiysRZQvFEm6R+bc00uZGLldRo2m3kZ0tI4Nij090RaHzi6WfJl01Y5Risb2t28WRIALORH479Cw01Y/sDn4DeJaBvJuv9Ae1oUXyoA7Gust2nxDpXSlvCjAW5wp3F1Nv39ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdezo+4yZMrKQ45/yQSib0+P6yi59zCH4CsDvvsrx3k=;
 b=TNZLwLFUtT19Ksj5CdZBbo1ry3CLSuLTOYPx0YKwnwH6n/pqQD920GEVC0Q0fre1HLc/6V14TOcc6ysg184JB2kWnomx/W7xNvL2z+VdisD89VX0CHySwXMHXjg/x3/OIi1u1m713ByxPcABk1Jyue8L/hwq/xygBjP/SuthhRH6Y0R6Ex99/GqK90BBo5lrN9topl6ZWrDEgJE1NLfVr8wGec727Cc8w2/3lv4A62bz/kTXDBw6xXjD9JCEc9dHne1RYD3lXwPNv+LaXl7NxgsLHdcujcCrQG2RYqJORi6Rm7v0EaFzo4vWzIXVRjGmDoZaJ54YFfCGLiALrqSKwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdezo+4yZMrKQ45/yQSib0+P6yi59zCH4CsDvvsrx3k=;
 b=P+VO/Ivnhu3R6DOGW5cC1fMMncP7wl6AOVePXcv18Y/xxsGLGh4zWdUqbuLciqbIsNSlfsGkT8DbTfKbTEWB5wfTGlXZjffOSJMsw8B2ki0Yet1RmZzx3AdomyG9k5mxB2wOQpflbKpWjlFFQGTmAIoEXqyJH9Vt3oX7dWdA8tt4Ogy5LFF2PHVr3jcqgssjwDtDwX73j10anZK+J1ltp3UZE6L96oN4VjiB6WsB04YxoV8knahTNn1yqrXVUYYgu1SDM+hbby8zuexaVH4JSH+3Uhi7/WW+n6HOnmsA+w2Udt82fBKC45SHRhQlj88KzmAberkpoTcAI95WJZUxMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:48 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:48 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 08/15] net/mlx5: Enable relaxed ordering on resource dump mkey
Date: Sun, 26 Jul 2026 12:29:22 +0300
Message-ID: <20260726092943.2880176-9-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TLZP290CA0010.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::9)
 To LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 32085ce6-3df2-487e-cf89-08deeaf893c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	RFoy5xSrCmP2nlVRX5xWHHLy4W0F5khOk2DnP5AJbtgAvhJsOsisQmeUYBt0Dfef57HyLMY4zrooWOr6ONo+OEwp/C81Mxu9zdQ7KeX+ljJYE6klGXSvU58z9zmx0MLiGmBHGWlxjP8Y5eTft8fmjYh0V8ANwj1wdNb/IR2/MkBAbRWzHebkB+zI8tC7VI687etGLAaqddTDVnLOH3Y1ecuCvViIIbFw70xib3U00VK4ZkSsFFecZrPs3TnbasCcqTc3El3TqnWClriCOUcnxhiNf/S2fABz8SvcvTDztI43RkYnWjkG5xB9+YOykscnuMkorHW0UrXaTOsdYWvlAplbloyTsxoF84ToNMYmEqWMsOAWR/7CQih0k6E4pk125o332sLFiCkUh7rzPJ++Fr6BDi3QqxRvf7n4N8Fw3auq0dPb0QMf8uaVdCs+PvXPskS5ctow1SYWPWNkARs8ei1UI36zvoTXSbX798V6QvRCyUxZV2ss6IxmYJgtVVb6BKiB56Lb2VxMrBnPMCRLEP5FBNFyxXDVhjtQXcfhK+MpH8x779rJ1BacADwukQIAzXGDvppm78pFGxQIciQ3kqetGkhZI5hSQuOmMwwyw9Ng3ttk87fVEfGZUXytPNbg8OkrEB3aretPSVx1g7RTXGYo09KyFYvwctcu6N0TXJk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SFooKxi+h0r2nuw8dNqADsGk8KWz17+RwfJHncgySJBDe5lKAQlN9veweH5l?=
 =?us-ascii?Q?emQHtz2v0LfjxUGZUEShfNvIEQbWfOry1zmCSSFM68D33BmvEtUjq2HWl6jD?=
 =?us-ascii?Q?GVv5U6CvUhAX4AEn60weCiadrGVn4/U/N1azDiDde8HoYUnHACbizZ+o0RpG?=
 =?us-ascii?Q?412acb8Pj3QvMQvvZonIuqGqWkgxZB+PtV3GBjYGqZ5+S05wcZy1KRb0aVwU?=
 =?us-ascii?Q?Uhx+/aUw6KcW4oHdmRAm5pswmFjceUlGANSi7PsLzy/9N6FgUx6cN65jjCkV?=
 =?us-ascii?Q?x1dkdtFfcjXamMLuzamMaRcHuQYjL0IHoVe6KZoROYLTKm3VAiIMYFFpcjs9?=
 =?us-ascii?Q?wkRZdw94qQ/BMX9D44s64XDqxcF7feRU15AbfkMt2a/ldDbgk7ryxIUVc+ej?=
 =?us-ascii?Q?HKpqEpmZv+1e9Z0YBADeT4qiNbmsUkmmvN5cdYUQQihuEokQ5u97aeEn9Rx8?=
 =?us-ascii?Q?w0TIS/K3+oR6NyssX2/XAsAx2kvgyF1fb8zZfHpQQz1uKNUS52z+JP6fKQlC?=
 =?us-ascii?Q?QmKhIV7zuS3o04M0RlqlAp3H3WgEmynS6oqp0WW7b8vDWOeFxequItZtSr+H?=
 =?us-ascii?Q?8oyC/l4dw5YfcnjIDkFb4sGRtYt+GHyzW5glvfQfT8vizGqcW6SvEoQBz0lC?=
 =?us-ascii?Q?85xdmqCC7qSxe4xtRflOExfyinY4MngvUgE3qRUhjC79qQxKr520JoetiaLw?=
 =?us-ascii?Q?V/VhJtQNVNQHEkqD/Tp3del9VdruDAqf9k3hsvE41vbtzafQ6tnWzu8cqo08?=
 =?us-ascii?Q?zORKSpre8CdOdhtpj3QT5TnOgw/hxX7Mz0m9QE71P1CJ6QJsS45wT6PxnLkW?=
 =?us-ascii?Q?jGmErkffas4S7W58yTliCBO+FVjrrZKdvCjwHGjR0qw4ADRViDJ07yAQfcGT?=
 =?us-ascii?Q?HPq8iyBcSOJo8731fB+9i3UfXV+ipRfC2+Pm7DhE/NfbkKHBpdXfSu4YdLeL?=
 =?us-ascii?Q?qXS4sQN5miQ2TwcXdywR6UcV/RX12yx4oUdBvF8KgdaAVpns5+N+2TmQt61V?=
 =?us-ascii?Q?D2UsezMbdh0auDBUkpMUcaClC9f3gbXjR8VcAXwZ26R43EB3agZoQAg2Vsmo?=
 =?us-ascii?Q?ptPFrPnaiD0Y1K23/Z5/U5Q+BdchoBRSvsL9wH7vckxVJIEtgs0WsWRUzWbs?=
 =?us-ascii?Q?TsYSAZWQ/OVX/tD3vwnbtdtnGLHPY05EAPA0q8SANDpgO6UdibKmWLRW8rf4?=
 =?us-ascii?Q?WQNBIv55HsawGMmWbAj3z1ovL3lohMu81KFm6CVZHZQIWLiPUiknM/mXarJl?=
 =?us-ascii?Q?2C4VpXBgjY/jGFnTzz7pabZljpdVXmQlChKpgdwQlpyYhwiaNN6Up2Wjllr9?=
 =?us-ascii?Q?wuibRrIwZtQKCmXZtLWpxHNR3/iNKig/HE6BU5uQJsl9RO9OpjM603+5FKyv?=
 =?us-ascii?Q?i6gx832dxX59bPeFPqhzAeqRLdOiNRpAp1L1Ii/W4SOzKraQD5YtyACeeTV8?=
 =?us-ascii?Q?VlWPaCX3VG/hlEo9FvTAb4d57z8bPYDTs4mAhb4lqqkbdHZ+XPn7iqna1F6P?=
 =?us-ascii?Q?DB0GumXqkiD7CXwBqXvyD2XJsQ39hen8SO+DSwyR65B5m3H/pf8NFhb2MAG6?=
 =?us-ascii?Q?h+snlkeB993wPmVZJ1OcfUV9D+ENLfGO2r2KAJ7mpSYh3bhCKzM8IB6cjBNS?=
 =?us-ascii?Q?w7yYEVy4iGN8ndGTQZ6HU1/cptGMDKLVX7w99cxgWTJjdLEQsK6lucFRo5OL?=
 =?us-ascii?Q?0FoM1sOd2WNg7s9sM/aFcMQSgHMY1f5y023EzFv4q7aB8pRDy6qOeYV0UjhF?=
 =?us-ascii?Q?Sa1WpogjJg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32085ce6-3df2-487e-cf89-08deeaf893c9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:48.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXEH1wn4Fj0GRXc1nwJS0DjgIyQapMoxmJKBB0vOC2gJBYmmDgP8dQNyQnocUwzvPkSY9o/x9BN7q+wnn3rM/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

As resource dump logic reads data only following an event that is
delivered with strong ordering, there is no need for strong ordering of
its memory accesses.
Add relaxed ordering access flag to its registered memory, thus allowing
better performance and allowing resource dump on HW that restricts
strong ordering.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index e770088de129..7b7ff08bd8bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -236,6 +236,7 @@ static int mlx5_rsc_dump_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_PA);
 	MLX5_SET(mkc, mkc, lw, 1);
 	MLX5_SET(mkc, mkc, lr, 1);
+	mlx5_core_mkey_set_relaxed_ordering(mdev, mkc);
 
 	MLX5_SET(mkc, mkc, pd, pdn);
 	MLX5_SET(mkc, mkc, length64, 1);
-- 
2.52.0

