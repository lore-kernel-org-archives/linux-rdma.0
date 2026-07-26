Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE1C37FF76;
	Sun, 26 Jul 2026 09:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058265; cv=fail; b=MqYyniA3oR5viPMVQCvHfSJ5XTfk7h92wV44b1csIVgnF9xvoju9rNG0iEPLnKzvVWzu2qQOxYC5XTdohXInU9By65/LiahglerXPjRUw2bbOce0kEJWO2GYXQPsRxrwb71n66jOivhpaSd9n4Gv07d1Jywr5Svz+mE8Xwid1LQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058265; c=relaxed/simple;
	bh=czuDvSOk7WZBkhqCHhNtCKbeYyiVrf8DnYFfpRw6x7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cSmA1mDZcEjNLvaIOxOOaHPc7CNo7oHJGbI7t/8gsgar5pwRxIvnxL4rp5CWyvAxcWEpoRcSlcBA6RyQGwCSx/putZ/+pQoNlDEC/RwloSA52X9VfeR2+jm+LBJbABa59ZFp8zb+Ur3CF50ZGRw7h2CswodqHp1fQW/v+yDhXHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=imuVqmCG; arc=fail smtp.client-ip=52.101.201.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="imuVqmCG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/tZ9i/GYXG4wQbhHOMhIGlcekEkpWvCzxTxlSBinL4b5DRPy/zNIoQpz0ppFWaixk+v5OQIWtbDT9SLZuUtd9QBdqXn1X5uGakcULXwaQ0f9xDR99sVMrw15TQxHyWU0Hz1Z92vkKzCOwd4MeeP2YY//Wr/bzdKQxVovM/zqtIyk5UKeL9ytFtW6a8mfHlwUWXpwEM8oJS0/WQH1i976xMobMGZUcuhCNK4DiHtltyZ95aykfOtuW+i7LiZGQM0FOR0kodxX8Q8os8+3hqaXkKdRuT1XqH/230Op/Krr3VjP14fpsYfuNjXE+amiK06t8Wb/ZfZ/jCxnVp578cyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cbPu7RCbiYE2BcHcs/SRPPMVyBgURcF6Ss/aNHol1/U=;
 b=LSAo3YxBRL7HLN5L4308QDhJcwu8Rh/EDeY1Su5ssbKJmhHG01H5nUQBCdyKU9o6+l2S1aEnvyxS3JdSbVRlEzJl3ItqSvHFNMLbvyNixPV6WssND3XjTT3vd0iRQWn4BhjkEHuMKqE11XIKuiqx8r4CRqAZHWY7oJ6S4M0D9cUZiNtVMJQ0QSRzGoFj+AbnG5tqRvD/o89ubMELwl0OGiHvajF72SwQ89sYS2VmE43lKN875DifgJ1tE9+qXqCDX+2g5YgREI7yE8ygzYH4JkLGpwKtzvybh7mgqojt/nIce2SAuywEz3uZO2LeNi56/oi6WjE6LuYFCwMrOG3TvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbPu7RCbiYE2BcHcs/SRPPMVyBgURcF6Ss/aNHol1/U=;
 b=imuVqmCGhH7jP46TfJfrkAOkNIDrrCCULcInK8+jQb2RfygKRU3GJeHyX7EVUTHB3HSW8XYu/wv3nXjQWfRcxpBkF1ZlFbo/0zGEESTUgEJ0yYgU6GhfpfrSNJ0bv5uMbYgtpMmGnq6S55o7f9uXnCFR6rysPYOdmEQ+lmOMvahqDAF9a/kJT8C9MyD3bD3einnd2bKGbnM3ctR2HHlXMKn8u5NQDwTm7eAiXjSWsaGSxeKsjmIj3uB6inMoGlJoaB45kIod6XsGsGcs7wN4TMuQ9Hwigq/lVA/799GVRJIYjy8v1FKAI+lBtl3Rixmv8T6k8GrgGQ6bqU5T2DEOlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:31:00 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:31:00 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 11/15] RDMA/mlx5: Enable relaxed ordering on Memory Window mkey on strict-RO HW
Date: Sun, 26 Jul 2026 12:29:25 +0300
Message-ID: <20260726092943.2880176-12-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0189.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::14) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: af23752d-114b-45c8-23be-08deeaf89a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	6lO8A3z/oaXrFzvSczUGLn2BFtA4GztgJrFzPAi2QcPYnX89rf8S1KP+s030dI4aaK9bqHwNM90Dl9S5dLQ36KtkQ+MUzRGiLdnJKY2AtYX/HO+GDlLXyQpm6Za961UwTvjvblpv6EQ6wby+uUeH0cKdW8HBDzQrllrKO4BgJmjmxfN61ZlVqQrSYfjCkpREhwbd//3p41LftwHRyhiF8ezPb5rWljy8GUgSe6//O1E62klC8jLpVSqfcKLIG57y2SmG78rSEPsgaoZkqwtVT1JnndleDB2azsxRVCrjWVBYXu6Bfxl3GZW5Q93nUt5xdVbpOaFNppmyh27NL9BTBn1GkTwLwUGN9KBlzL3K59thoKbgClvv/MtjLi29cQ28o7m5q3U1Pw2Zenjcfq6WcUpkEO4cmL6TKp+WKhIhNzRNdo4IDhGrW/D7SV2RNAb3XpySCbOZZpethkPKa4FM8QXye1ysV+7FuTXZlf8dNtsPjx62DgFA1sjbLM7i//6oTtiPkYMAqXOSYQ4fL1GbiChTokP10oAARs0X2FpvxAbt5C/YcH8IjaxfJYVRhLorMHbd6leb7iyd1yHdu04yZMdcqBPOHuYfwGZNX4MgWSC2JpZ6rv3tx67nWswbmV7+OuWZuBFaChCxJMcAuvYmAjYfP+NwkNMiDULl8dUmhck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vX/Phlr7nj16xOUCOjn64fgLF+tTuaaqmZsGXf94riflkznkGfCYz0T++AkU?=
 =?us-ascii?Q?QpT0+oQ9rObdRys602loLp2ll7iPgooYiA3Euj+v4rLhrW1+qFePu8und+Cj?=
 =?us-ascii?Q?p8VdpwbSjaly+la0jXszbtZ8uKDbCM6zIFOO+8uAHuhtk+q7vjOYS5wcHthZ?=
 =?us-ascii?Q?dSK+jpZTmChBhm7l1lBbf6YXBnyrADzbV7zSvKYYy9Lz8TZKJzCZ7uzMAFR9?=
 =?us-ascii?Q?2Kb5P6uLMNNrBNjij15lUF+M0/COwuw7AOw0YVcSYX3IupSYbYV45Yn5A/hU?=
 =?us-ascii?Q?irM4fKJfs6YLG7OFb0TuNCqSmOvzzORcSez6a0R4VrP0qDB1fhsBdmGdsNNb?=
 =?us-ascii?Q?tbL0AJEFuhcWwus2EU58ZGlRQ/46cgFVE9eWWvuumta5+FSqCeiPtdH2kc8f?=
 =?us-ascii?Q?/oTv2PGJJ2v9nEPe+PvKZYHBe/3KaBpo93Yfx3M/wQYjXax/kozFy1yNh79P?=
 =?us-ascii?Q?olZEKrJJr9V/PaXD03XKTbF25hO9/ofmHatwwdeykREnfgxzH4RbolvCnI6U?=
 =?us-ascii?Q?JZ3HQBdV5Foudv+PaEYYgETRtr2U7PswA13H3q/mhuS4a9YSCIxTgj3qEDVp?=
 =?us-ascii?Q?cu4ut2f88F4PHGOwCMGUsBtx1+UFd77PhXig+qXUTsMjATqlIRJ2P3sdoSpV?=
 =?us-ascii?Q?+5UOniXb03cWY6xiqXxbcPkXDds8qIclAJl7rtoEKz3Rr0YRq5NuTHuE6qsC?=
 =?us-ascii?Q?m6qyRKFhUo17QCBK6fTZudv6B6RN7UfoNk/eC1cxdRgjn9Fvj5FKpWj7pgJS?=
 =?us-ascii?Q?B+yBMAbWNFRmuJXaz10er+TeOrR0cDlSy+4jzw8pVp7uK1GhB3ZYLQvIhja0?=
 =?us-ascii?Q?gdqHqVbv13WhuS0Ss0ZHraQGVulvhi9wbizIiXjwscN6iBReRq+okEwSwjxb?=
 =?us-ascii?Q?eqgWBDNQy6phpVypvjD7VYCS2GbEopO8k1/GU52JNyFr/WWCNxasIMM1TsW8?=
 =?us-ascii?Q?vcLfq9rUH9YSCx+82XTEwz+k4H4lLtExhfXoBuFvu2lx95WQATwDmGgVFXBU?=
 =?us-ascii?Q?LLL78LuP0wC+c6gyjzX4AQv4w6ixNXIoGMIK4Q3C6IXoivZNExBEvVfPgAw9?=
 =?us-ascii?Q?yU37UjTmDeNXjgjer+zRlUY3F+Yp4R3nhrpd70je9D8ldv4s4gmEM5Krvz2k?=
 =?us-ascii?Q?9jWLQhxzkGVJvKuoE5glDyeb3S/x//hR5p6WWZH1el/Ge+Vh3z6IWxR9fIkT?=
 =?us-ascii?Q?l/s/TDT/4HUAflD3YpRdXBg1EjVG2QG+bXCKmjuFc65VBvK7x3k3L1BNL8wL?=
 =?us-ascii?Q?eNmNDeHhBP4CkirJOpnivNjTh2NEcZ9hWarbcfsO6FPJL17pLNckMn2PWKx0?=
 =?us-ascii?Q?sO3qzUA8cmAnuGhS91xdzSS/zEKvCj4ssp6nNY9uBviUOear6ezuhbOPgY/p?=
 =?us-ascii?Q?HyhpWQmFBY9CRGMlTNrHyInVKJXI7f61j7QxrJSRvXuXnYOvI5DvOoPkV93P?=
 =?us-ascii?Q?+FFlVnSAf9+Iai/j90D6fx4Dk2t0Fr1qG6QXKk7sKkwjSK+C2RSexaZ2Hgop?=
 =?us-ascii?Q?Lq8sCeKzjylbTW7TT59fTzLl6A2qj4sxWUIYH8P0p7M8EXud7ojs1HCtfTUD?=
 =?us-ascii?Q?XPfjz6x8FRZmHJe2Ef8rB7y9Pn8Ix6Cy90CISqHHpVdClHnKboYs3/DGIkxo?=
 =?us-ascii?Q?fxJkMZ0B0hrrtJsdghMwfwI+cvir5p6sfYFIINqFT747h00e6JILI9o/aIe0?=
 =?us-ascii?Q?SxMZW/1kWaw2CFttoSaYAQh6aZw0hnPe0S+potoZRfCKh1wxfvYt1240CqYS?=
 =?us-ascii?Q?Iy4LVvNeIw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af23752d-114b-45c8-23be-08deeaf89a89
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:59.9465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LwMxdDCK/G70QvFtdI13XGdFKEdMEjCqhT4kFxTmtJJ2hMeEz5SGnwRDEolZ7YtUIXEbAuazKIxZ9BCHhcI+fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

On hardware that restricts strong-ordering access for memory
registrations, set relaxed ordering on MW mkeys.
Without this change, MW allocation mkey creation fails on such HW.

Enabling RO implicitly for users in this case is acceptable since all
users share the same memory registration restriction, so any MR bound to
this MW is guaranteed to have relaxed ordering as well.

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 683099333563..29a9da5c6dca 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1822,6 +1822,9 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	MLX5_SET(mkc, mkc, en_rinval, !!((ibmw->type == IB_MW_TYPE_2)));
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
+	if (MLX5_CAP_GEN(dev->mdev, mkc_order_write_after_write_ro_only))
+		mlx5_core_mkey_set_relaxed_ordering(dev->mdev, mkc);
+
 	err = mlx5_ib_create_mkey(dev, &mw->mmkey, in, inlen);
 	if (err)
 		goto free;
-- 
2.52.0

