Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3213D370D63;
	Sun, 26 Jul 2026 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058233; cv=fail; b=ZlXAUQf1Oe9iXHiHQFxSX/Y1OqCSZ9qOE3GDfx2LYzaDpeXVtneNMMjLTTbVch8XC1gvssJyQnr5LPKkSb5DziTWjtTcDBtZXMBhQHmCatCpYGeBs0TUSrUj36WeyqQfqe+wvrKTjoTeFG82an6yYE5IG6dXkIbasL9YsV5THkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058233; c=relaxed/simple;
	bh=DhXC6X4UzgBMEDjDvd3j70ZDAtXsvXu8W0CQUh/Qy4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tJkH5ubrtwqathURMR1syTHtDhRFUkLTMJnbQ1dGRuT7bCD+25YjUBQtJ4GY0EaMmCqiDyxjL5gBRYjKnQZZvhDnVYsTNFJlCkGhKKGcVTmpzY9ov8ZP61mQbqIHKoJfM3qocvR5bf+9RtpJ6XcJvJoinBjHSRGVnHhfsZt6cVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WH/hd43s; arc=fail smtp.client-ip=52.101.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WH/hd43s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUczAt12g9rngE43TEyi2y0qjnB4gGSt4nsBA35U3e3YQ1oTS1y2SNCpbrT5AUY6Syvp4WAexq7/PyOqsIoK5QM4Ly7EGLY//ty99T89qRrqM0imYi2sy39mnXIhMn7fxyQVsBHztTZmHYHo1S+HiY3vkfYvOZ1p5q0zrmYvQG6+Ys6T3IUJEOU1oR9XFwjCF//8osZQFiLLehXb/dkA5MjO5tOEc76SIePH1pocPD3pe5MDv/pKWe0RRLFy+6pNfKMhClytuU4tvPMrlGLuCLWl2fzd9COn1Z3WumofrjqtXokTnw+0pmuWc/n+wDLZ+NtxZyf5CCOchMQfmntQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SG1oshhFblKwKwn5qrcDnRdezOrliRGxzbAPXssuU8=;
 b=bwY8EvOSR7yaiwIjuayDdkJgVgrqvRwIo0bdo8WvDhaJGZzFvgRclEtNwjTKSazeZBJk1so5imT2x+BSyrmG3asjOk9/tzMwBR56u0VBD1bXPBcOthVPzVxH6wLg6ggCsBbmz6xD7tmki/eVdWZ49rskLyG07iJONJBJYDF8gc1IL5t1x+DGubZLbGU0j3FHDjlxD1CsSBzj6YZe06bUCY4bVDoHc/fmeSM7waCNwqbL7dSFMKusav99KBxSw2edISETc8B5s4Ju++qV76wbjKyFNscgINCzXygMmaenS3h+Gi+qdnVzmeHzwpM7z+0QlHlVwb+lOoPex4k//CAPzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SG1oshhFblKwKwn5qrcDnRdezOrliRGxzbAPXssuU8=;
 b=WH/hd43sZ+Gzu7QcDij4I9O0qTMQQo4HlfX94ZcZPn2ZsExpH1cg8b0ugPnT1RWZXCUQMV+yf0KsyjBnXq36AJPMYAUQ8LE49bEkWsWKoE1kGEjDY63Z8/bdxLuJIA+pECE8glpXuvcuRD1exN926f9gMb4N7k6dIhSr7GilQQVFeJ7TuWHftOM4oT7Hs+PRC/uLPCbe0tAgMfy7bG0/xpk6gS+hkAH0QWqA7fZ1o0H5lkuQCoBDJ+eutfcS1hXhGarIRnkqUF7WPWDktje9HHmJY1uXfXDetgiB4SAixTgmVmnZuDf1KQrmCkF+U6sd4c/SraFE1fd1VlnSDouQBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:29 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:29 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 04/15] RDMA/core: Allow optional access flags in reg mr ioctl
Date: Sun, 26 Jul 2026 12:29:18 +0300
Message-ID: <20260726092943.2880176-5-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0204.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::9) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 67a5ecb1-cfc0-4f8b-0d43-08deeaf8885d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	FBMXaZSPB9tq6b9DG7yY+cfGoC5UMMTqn48to8jQRRBSkxp2Nq2uWwL44iG8vJ7zqdgbBbMM+hqrJyrX46VWz3BmivtvGYtpdGKuM9581CMW1rm+9U608EEpQx9pStsYL1LTaF8+lJqTQpbWuTB7Ffyc4pUwrI3muIzsPNSuV1P+YPVumdGYnf9Nd1jff9zsNMaHIEqbUNxjYoa3npgU11W7HUEjQdJi12PylUlmRY5+yEg9s1R4xbP9FgzWIztUaaV36O4rHGjNaQVXAH0D6OjLoa9DEk4WKB0v19GuXWSkXYE4BigYrbGh9AfOZJw1fHwOwGYCA9O/OM0i08gWgrrBmz+QdD5hhpmva89tKjV1p+2SKPc11KSLxkXWUzvXLFt4maESl7iOLnJ8LyucMp/pWvEHjM7iufHoJb1t6BuF6mogesfHRI1YSOoOcc+2jDm/LcGDEfx/MhbAr/xwUp3arpMtP25mX6aNglD5rz3UvS1urECk0W26eE1VRXItovHPtMrkesQNfb73H6q49fttgw60Mr60QFyfpBtP34vlsHNv5SAkLmST6Mjq4L+ISK7X/cKSz4hZYJW7LYKgoRZYZ4M4PDAgL8K7wlyhzLK04W8Gv+ygKFOvkddwDXho/gjpK3kABSLYMN2VVj+CIRJ9GgWYg+QbqRlVfPAmFaw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zh78uhPt7FznTDUa8DrB4PazLONi2lyzu2f9NXVeHfaSIXFRLmY65MY/zncQ?=
 =?us-ascii?Q?wnZzEQLgopXfcl53XbgQ29rfocXgS8VVDMJlfd+GlNjw8Bs1lWIryxjl2J7W?=
 =?us-ascii?Q?lV3PJP4A9zYd9U1V06DWyQIIk8KC8Ezl1Aox+08ZFLL4uFVZx1LP/o3g+/EA?=
 =?us-ascii?Q?Ggf0+qd+SqfeOx3n2GRfcar8am3d8mnxmOft4CGArN3eWvP0oStTPNLRMvkd?=
 =?us-ascii?Q?12608+1n1vVtKtmnM0gBvWmnZ2VhGBx/J4ROhJ7a939psAafBZT9Tz81E2g8?=
 =?us-ascii?Q?RpF3Gu0JfEsZu1QOuC1TbbtXqBQvyHIUeq2P4OlXCGRqDP1qw3CQCC11DaoW?=
 =?us-ascii?Q?+0QVzdPTTkKebcHeOQUFlDGyMxO8cUJXokm3XPawjjm1aQ/1h9Rk7CYjtNMf?=
 =?us-ascii?Q?TbsFD2hkfBb/rcBkxEKxs4/3nsHcFEtksB4YR8bg40TIOHPkRAKPk5PJDyPp?=
 =?us-ascii?Q?l0g04hiiYasqk9SNvcBhPKpmW1HcnFMplYp+/7TsbLCizdgVth2vWbolvATA?=
 =?us-ascii?Q?/nySsGixvGxUbG+dHfjPmW79b5h7fOOQ0hQVAb+B2s2SG3gOzXjvcLowJWvT?=
 =?us-ascii?Q?RdVQokQBLOL/t42Z2fFC1qhN14vYEBsZAMveve8AoAnRGlauiclJ7CpwgmGX?=
 =?us-ascii?Q?EB3vw7opJ9WrQThZGQ8gGHUnCFHsfs5JDVXtZgMet9mrFW12H+mThsPQHPOq?=
 =?us-ascii?Q?IA1kF/fIWaTZdUB7Nci48JF6oXc5u/ICNsK/Tg49xe3B7obLLKztSwvgVGSW?=
 =?us-ascii?Q?bmFfNmRmFr6ScTd3FNy79otfeiULHHOHGD3UjUaAjBPOs4HA72kGqvBPuu+U?=
 =?us-ascii?Q?3usbHRzDXC3BJtDf5pu5DehS1kUGxzTNphTurg2cOlUIK5jtpTRGvJl/pe5B?=
 =?us-ascii?Q?jlUl1TId5KcXFNVio4hQeMaaWF8Jw4cgXAvGV+kSW5tX2iMRvDrjScBXBYp0?=
 =?us-ascii?Q?FrD9EziCz4+j5fDKMLXlzQm7ay8/eMG2TSqskUEIZGZZUoxw14P+8qywO1ai?=
 =?us-ascii?Q?fFISgxVAkUjsfkzhl3T9s2+zHBrOUa2IASpivtz0qH6sc9M4bpnlIAyBqBbN?=
 =?us-ascii?Q?Lj7wm2eEuOuXjLw7tYiQuQVoJnSi42nyNGLIEI6P1YY+KTqKnNrGuflnU3Zs?=
 =?us-ascii?Q?45v3XKCYkb8gl4y3XkUB0ci6vHN6d1YkIUI9XIeB/Xz6DjLoxt8GC+w7AMqu?=
 =?us-ascii?Q?FJgOM4F2Vhrtu2WUT0buzBrXyKYMUgkz0PkIOCtEsYyS0azkeGiw0S4CjuLA?=
 =?us-ascii?Q?IXf4Xl6G8ChiC1aEFzB+yzlZdqmVGkIFvxMUrSdrgzqg/jKM4XkPHBeWiDUS?=
 =?us-ascii?Q?mKKQEPeCRHSq4nXx7S+IeIBNWuOTa1kDlaZvc/sPgLmWSkVRwLF6DYCpXzHe?=
 =?us-ascii?Q?k/2bHareooJ72n9t6+uCFdAlYe+wTz/24pdYI2hd/uxk3cU7Q0WLLPxHMaxO?=
 =?us-ascii?Q?wb22dxoUUIfvRHlYMeyRrUu0QJOX3SxKQoKEnCFkjWhXHA0GnmD5pMPSaPeh?=
 =?us-ascii?Q?kywFrRcfVTNpWk36y6X6jp51+qHa0fDARKnmLFYQtqadim6VPIvaUxndaN6l?=
 =?us-ascii?Q?kUJi1nypICjv9ZFXW8TUSI17rjEhnLRB4PvIXZlJrDZeSUtA7Sm/uCHkiz7u?=
 =?us-ascii?Q?Rf75xa5XIC1C049WidbGbloYz9vQUI7Zk34ZKgeVmz8b05tbvjxXCVpWVMKt?=
 =?us-ascii?Q?qe4opRBgn4D0DW74nXXrTLdxCWxkkfae3p+IbKy4ZhWC69AM4gFrKf8EpLJ/?=
 =?us-ascii?Q?96Wmu3swuQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a5ecb1-cfc0-4f8b-0d43-08deeaf8885d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:29.4731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlPyjN2Ys5e+o0b6F5PcBlNRAc8HICeomLf/xuPzcIYhxxS9GJiuR0cF5a4OivD9Q0HxlGYpgpK+K1jDK5NC0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-list of dmabuf registration
through the reg_mr ioctl. Uverbs users can now request any optional access
flag on dmabuf registrations and mlx5 will apply the flag's effect on a
best-effort basis when supported.

Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
Cc: stable@vger.kernel.org
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index b6d6cbe448a2..ce6c9aaea95d 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -332,7 +332,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 				     IB_ACCESS_REMOTE_READ |
 				     IB_ACCESS_REMOTE_WRITE |
 				     IB_ACCESS_REMOTE_ATOMIC |
-				     IB_ACCESS_RELAXED_ORDERING;
+				     IB_ACCESS_OPTIONAL;
 	} else {
 		if (!has_addr || has_fd_offset)
 			return -EINVAL;
-- 
2.52.0

