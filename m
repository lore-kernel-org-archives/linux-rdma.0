Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658842;
	b=KeoJWC4dd68ysTfY86D0TolJMn7rxnN35CyjwkFbvFLUmJNQipe0gUOdxc6aDFyEH7bk
	 9CCuzpCaxnu/r+2Or1NciKqKBi2xVlSBWhVyqpCiyq9l+pBqufXGHB/X3FuQLBU8IXOLM
	 V8bS5tgyuNMqfC6UJn4JiPckOxfUZM4Dz+KM9qjcr8oXcve5nNXfNSVm6aLo5GNqFL5Vb
	 khGSvbsuurzaMaRp7T5ENJlAfpbSGDaDNZsMxyr7aPMZRGe16yOLuNly4SMgshnIkGBFY
	 iP/nodvhTGfmztqOFpYzqVKv00I6qip1VJFj3Y4RXScQRxvPQf3Jp9PEhDCMpTHpedQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658842;
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
	bh=slPvKjQ1oqVmV/jYMkvFy9zleMULrA0jd9JLWtLszig=;
	b=fLxBUHDEG17SCsgYqcSTBDDos0oXd4yDQ9dF7mqcPOrP1VyCSsUeDqsUCrWnqsvYslq+
	 cwy/ffg6nUjEpTAZ0BH/hsjtb7bi2i1YXFzqlSVzZSRlAF9mxIJckrNDnawZwjU9kL3M2
	 dHKN/pqcefKtV3LK7I3hQrTp8Advs4dcWU4ZgV4tHDGNMhG+Ed+dz/1NV2haw1wdoq2NJ
	 fcTN47h6bAZPhyjKK1rWOOyMxpopMrnEEIachbndMzdoqHyV6bojJiyrhiqpkJsFtoz4o
	 admJ+4dBzyDE2t120a3/hAj4dmGQCLVmm3OxhPhjFv8VaGn6fZP1mnZODpMk1xO+fzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=htF+6yKt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.2
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42AA606A329;
	Mon,  2 Nov 2026 22:34:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A42AA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=htF+6yKt
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQHT70oXgLnT6dDNBj8LUayGcMBTKNja8c6dLe87wI9M1WxTPHPIaYMRCHbo0KOyzWleeuw7QlPBirchvXQP1/4cYFzyIrMuGzN4lbDwC+0V2g0IuIBs1VBGeigcP8/r62zY/Q2YIezbtfjzthXTYjkvpzOiYt1j+y85QgaNUupbgs35w4YdrAxBIo+ilja8bZ8wO+BVV2z6I2kCjaxrQRjRKAMHtWz0rFHAYtdseX4HmjyxIRIitFV7+CN77lx+DzdRSEzQLV1PHVBAo/zf3Q0Kw9OWMtUbPyvvrfI9PKanFkAMOIAgpHaPmmetJrv8YGrmO96djha/QIcHMSQIaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slPvKjQ1oqVmV/jYMkvFy9zleMULrA0jd9JLWtLszig=;
 b=gxiiz4/BhWX6Y/sGod8jktZjyTIo+1maDGZD4gsOvFML60AlszGJT5hx0UHxcI9ZrbNvy9vB3jkOUTUgKPiV+3Cq861wDUbbvdE7R3GdpqtWlcOyyvhTSPFXfG75l4qrJcqQY+HtJcMSP4TwpzKPLa8l4PynVedFzlFYl6tlUYdiQVPJ2NcRxvyOJkA2S9SkvkIxKeG/x3xNPnShQMLYpDxGGsPQrVosVx/9X+2TrAfo3C06A79bUDHclFTQiF0CvEcFSC5iwDN8crspg+zpr0ov9qtc3RDNrPytRTg4ssvJVnNRa6Q2G3nIcsvHcnqJpCzhcwZsJqicF9sw5N0Wtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slPvKjQ1oqVmV/jYMkvFy9zleMULrA0jd9JLWtLszig=;
 b=htF+6yKttmShs4LKyZXYh2ZDZMl3FwS9LyRdsBuYU4KpoCYzURw+9Fs2ZY9qjcsgWUj/x0f9/i1reK/y150/80MyFP7NLTNfuE85e+0tMglrr1lD51+VyqpkKgW3z/j3sRnjzxDuLVwLdDNWo6glnqVkpKlGP1GGmIVPmhcfGLyX6p0hyirARSVMSQVa4dujbOu7YmgmNoFRPHbW+sJqs3R2WgFFPWBCgauTvyj/vR5WuJmPLQSUVRPl9KcFSoiklWs88X8dTSGtiZ1zmCVpAtWX46zbV8kzXxrx3usmwX66wJeGDdJRxXNJTVF7gjtv7UOLo6agh2CR2uw0MnIGzA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:33:56 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:33:55 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@mellanox.com>,
	Michael Guralnik <michaelgur@mellanox.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 01/15] RDMA/mlx5: Allow optional access flags in DM registration
Date: Tue,  3 Nov 2026 00:32:54 +0200
Message-ID: <20261102223325.2115128-2-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To CY5PR12MB6478.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 413edf3c-9f62-45b2-1f2a-08df39316127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261009223027099003|261022105027099003|261028144727099003|261021121427099003|11063799006|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	5qyG5tRcSMWrApynW30mlf1dj38Sy4BHq2vsFSYtLvhQIY6v1Pr9uzr7dgWfUcltlu6sQpQh/FI4T/rz2NQkgPyfHvz5GuNGy4KprF2i+RJlRikeAf3WQiqEvvKBemAbFFFOLTCwgabE/JdoEmwcy0kvsIei4II5ZLatC+pcGrLiaWdRcFSc+2YU9UHQcDhh4Ounyypj0f32nZeyMmnysB0j7FcytScExGgX44iGZQ2UA81z5kdzbgAMeL0WKOGR7ifxQo3sttjSck1Zfp1gOMx+um8hgbFMG4Q7Awgc8h06g7M8+95AUs76wfF6Ha6iTHQtFXWP9coBdEzquWMORH3LYFlMyaMmqD1rHg01ECMT2gHQVls8J92GWkKELJ+ZG+Qc64dlnXXtcK/ndEZcsmJ1aGYc3IDLaUQ8Ek/4uDSr3fioxNjD8eQG+07vh7mj8yvCFCxHwdjwwaHhwKjg4l67sIMyCYqhJXRg+jiyM2xVTLFrIse0ao7kF78JWgovZ5n3DDrNl26m4FzwbX0S//WWDr9KIamLnXw6JixwpFSh8IRp8mrec6l9aaGczjcU/n56E+PygJAjw1Y4B6hRckE5vFEBhUZqFWu4jfTOrGhfoyxJOPtnHoTK8p2+CjTrqg40b/LPcCQ+IMmYXJl+oQ7oGv1PxGoymJbGN9wGMhs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261009223027099003)(261022105027099003)(261028144727099003)(261021121427099003)(11063799006)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AP/15BXUmnyk7en7aDY6kVkee0gcL6ZnyPkEZr2hMKIVd3l/V6iQGh4Uueuc?=
 =?us-ascii?Q?mrD1hsSZBW2W78XfnxUVB4eqzg0TRSgfPiAMf/PzeyzDS+/2M0gZ0FHUOYKS?=
 =?us-ascii?Q?FexWYH3Ur7Fw1mIIrYQrqtKPdGygq0e1KMH9YI2ZfqBbAdhLltWk3gMf5aan?=
 =?us-ascii?Q?G48kaTZw465EcjH8VRyWgxe7Beraa8kt5UTc3mAfGXQ7iZBBx4IpdAWQiHu3?=
 =?us-ascii?Q?GZOFcZCb6CUqQ7Afz7fcB/kwF76cyF5MSEaKRn6SqpIiOzT6WPAXfN3ZRFtK?=
 =?us-ascii?Q?VxwNFzyXB5YMgy8EU5aYqJtMGEBmYP1MJhKrBfsLW+X7FBOPDZPfwht4QYdQ?=
 =?us-ascii?Q?ruL8pYlMkp0hv/kYT+BZ6XjxFQ8z7Tk9glsAgIKp4k4Dq5bOgjBaQ9Rybhuv?=
 =?us-ascii?Q?zG5hJoKlP9X/fxnZufBqJ7PAr9kIDkwo2rQyNw9YshVB5dnIvbVj/TWrlIsU?=
 =?us-ascii?Q?i9+ImgWaotYScCpjoP/Yxy730HHFzwzRVVPz5FnMdn3NNs1w+oAJO354c2qo?=
 =?us-ascii?Q?Z0fTCo9qqJkF1yXGUjNXM2iF/jp8gPs8VDmM8GNzwqbFiFdxJ+1h1CeoFMsu?=
 =?us-ascii?Q?KLuApfdjWKm4rCXPNCljW3M0rEfQyPMIGYYXHdiRyFLkGQG4qCXkjaBvYD5M?=
 =?us-ascii?Q?2LdtrCpUjGYRRw97QICkLKKPjeg0eBmAtNLhg9Ema7S7CIKE1SEmT6G/g/Gn?=
 =?us-ascii?Q?8o7GS0XCqy9mzDnu04d0f8/XCRyV/jEjmTBWyWC15gMG9ItMn1rnisbI0Fgp?=
 =?us-ascii?Q?GCbryerFMwOvOaoE8Fxc171R8KraHZ065YvEkNmpt8uaIDXF3baphxVVuM7/?=
 =?us-ascii?Q?d/lTNCTMAUxoKSFa4uCdkF02aEWghFuXUItyXwrCgvpgYt1TzGr8qG17JS7r?=
 =?us-ascii?Q?xNyKcY+FkQ63YQgNUHL7EIuefkudRsWszCN+A68cd308s44iW6qSrj5lPM0n?=
 =?us-ascii?Q?aAqfCCGUIBcf6FEVMVb07ILaG9W2m+6dySLVJxqcp2X2ZY0TvDc13zMSuqRd?=
 =?us-ascii?Q?SMXecBgCdBisYoAesuv3Dg2V2QQbvBiNXbcqKjq0pZIvurT17tYIYlPqb0FR?=
 =?us-ascii?Q?WXP8iqtUHPcXJi/utctAgLhlizKWB8ZL2FCUnBhClnBx3w6ohrLDqBoEzh0a?=
 =?us-ascii?Q?nNqunM/3q7cE5HYwSF17BU/qujA1rtgX3XrGXH0a7muqiC/IO2F1/zqxvZaC?=
 =?us-ascii?Q?kioYZVgC1YwLMWUlQjm3sgfmThe0FH2tVTViD+H0K6AhwD86hk2XGIzjMlo+?=
 =?us-ascii?Q?IxUyiZIrDCLzHmgT65xFfcxJHb/Ui7RzV2qR6CUQjxUxo4NqP/js3J1ThTD+?=
 =?us-ascii?Q?CILin8Lv18KbOps/adrfqQi9XyD1/mQYuNjESDlwgcw6IBVAbiDlo0aI9l+z?=
 =?us-ascii?Q?dXrrwV0v94DfwfAWGSpM0Xaz84072yPomSqP2HbX4e4djTX+Qvef+Fq1CqaD?=
 =?us-ascii?Q?dgOOXa7eYdhVBUUCl3BNjCHZKzK7Frn+8dSjjMplEzhq0d0iEeYD9JIHnssg?=
 =?us-ascii?Q?xTTJF0uirFIMF2ktJ8wbvlf6SgQ/ku4SLiFjZtewe6kN5ta34iEul3I72Z0k?=
 =?us-ascii?Q?qF52kSW0E83l/1CZMBKZVY1y+ApgJnLU57wbwth617TUU2JsBXn+tTtTAvpJ?=
 =?us-ascii?Q?VuJc1MWXkL/GeNWRlM5p02OI1vf0KBKMOyk+X1XLrasKPgZO6/8Hhrp0SQMa?=
 =?us-ascii?Q?EuiDXx4c80Q8Jh1/mRSmhiQIYIi02zd186vhzfaapb9J47q9uXlp8aFw+uHh?=
 =?us-ascii?Q?Yn4I8qMklg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 413edf3c-9f62-45b2-1f2a-08df39316127
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:33:55.6866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q40BfZs3Rp+yh8yiamlDUnejTQOSxzWeI25/UglfK8KPE1/wgq66elzWM/PQ7mWiBEcCEyq9i990925ZDL/ITg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792

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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4a6ee14ffd7d..86465d9d2b5a 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -661,11 +661,13 @@ struct mlx5_ib_mkey {
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

