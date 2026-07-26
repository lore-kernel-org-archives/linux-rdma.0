Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEA130D402;
	Sun, 26 Jul 2026 09:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785058232; cv=fail; b=gPnqNC5eu/DrnuZLEGSLW4WYnqi1UP/2SqIqkf7uWHH1bZhHNJgSgP2kewDB7jdl+HeIO+D7rLF9R+GFgFz2FdjpnfH+uGmDRbhrnxp0sdJ5Yh5jUcE8b4HpnFdGovF1V7I3/Z0P2T9RlFfL+FJapWS4zLzuTlTeyAKEgrJBILU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785058232; c=relaxed/simple;
	bh=Zebu/unyv7aVPT7Ir+WHO2IGSo+1huE4XdLGoV0994o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Wp8ik1PGtem0vlWwxsjU0/7NZFmwtiO/iMjbFAagsSkTdA8e2iDP5hY6WSVztzIYjRcFnvgOeSzHVnZqKnni5QlCBbjKxjNchNtWque3GeXDWvcCFmJCmndZkrFTS+bQMVhD5+/Mi44gnPwujgSpwNcLjWeksdE2lU9axow0Tq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hf3fKW9r; arc=fail smtp.client-ip=52.101.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hf3fKW9r"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AlQ67hAD3ExRIYU+X7PSZOUBpoym9+CJEaS3RD/n6v3qBB0hI1K8IBBFsYuHV62nwCE8AgDqDCIEfd6HP9VTFs8lfdzLs9Evg3x5vOuqo9f+kA1J8HokcphSTMOUcRNeN8J+aiSGcfbRf7o3OZ1ux7L7QUbU0XmRIQ3qKuNREF0k1m7afmIulJR0i1VaWhcgIjBurWikHmBnslo1lwOz5BObAKbUjRE+iTZmNWdQppZUbwd2wzC4bl7ITkvyHmSbhbO3xMJzGJsNAqsLcUC05Z66dZIRsTOUGMbe1uC05ZvFHFJwI+bg1yDNldLuTYFtm3BY1h52UAeIRVQk9pprBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJybzeqiOcI60/gzGIokzTQTeb/y7Wo/Ji6kbHON1D4=;
 b=ID92umSh4YfGg/1uTFANPAEYd54K2tv8Zr4wzbuhh68+oZ1LuCeeSdXd/5rPhpLPVpHLvWJm1fGW0ERaaoQsAE2DUU6RLqwPQfQv9laLqkQsk9npIuQrve8qlKbwyufJFi/7Bej0YSezTQdePCnNh1XunzBAEI3r/IHXl83h8mrDxm+NWAlMtKjKt7kcMJJqOIORF0lnK+79T5P7D1hsKH84AV2t5Q9jQCG2/zuWuQIQEr2kZ+jQExBloACSN2UZ5t5fI70nbGC9BSnMQWdWkIsUvfByVaufqh6gMGeoHO0xCA0bLMNbyMW0HdVlSZW9HEMlN57n9VtCOyqfke/q1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJybzeqiOcI60/gzGIokzTQTeb/y7Wo/Ji6kbHON1D4=;
 b=Hf3fKW9rJWGfSf8vpZRQDeTYi6u0+nbQ7JDiagpEvqmFVPu3bE/Aq3mgq7eviJGYiqftyvI7/V9aeYlP41OpIEnrDImMGzWeCfQ4DZG2fxOZgik+o3542L2ag28hYPK1sv4WEGgwCusJrbT2J7Ihf9CaVYNaPOlJwlpjr2Nhitqmx0fhbirhdPwUh3oHkVsAkLxnbnSioCf3YPVVZEvmV69wQChxLnSD8Pc0hJM15ov+SIJBO4S/SyAJLFrJy3m0mKRfuMBoKeOwbFXKkJa/XrHM6C1Fx749Knn7QmaiV810CfmGeodUWzSReoedLm4UFgMVdBSF9M85M7d8YCGovg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9715.namprd12.prod.outlook.com (2603:10b6:408:2a0::7)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Sun, 26 Jul
 2026 09:30:24 +0000
Received: from LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142]) by LV8PR12MB9715.namprd12.prod.outlook.com
 ([fe80::e74f:2cf8:cf2c:142%6]) with mapi id 15.21.0245.012; Sun, 26 Jul 2026
 09:30:24 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	Sean Hefty <sean.hefty@intel.com>,
	Christian Koenig <christian.koenig@amd.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next 03/15] RDMA/core: Allow optional access flags in dmabuf reg ioctl
Date: Sun, 26 Jul 2026 12:29:17 +0300
Message-ID: <20260726092943.2880176-4-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726092943.2880176-1-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::10) To LV8PR12MB9715.namprd12.prod.outlook.com
 (2603:10b6:408:2a0::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9715:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: deb0c8ef-dfcc-4277-64fe-08deeaf8858e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	D9BI+dCc/OSqwQ1/ITg7k3JOiLqJIm1qzSR67/IxQ+Rq1uFSqZcnDSm9Gm7DZ3Grd7jWTMoUBdQXW+sdxEMrfGemaNxnLo2iKWIwrJRdtlF/mpUnaYs3UTj8Lwveon12DRobNcsWUIeKfvkGKrg3J3H7/SWcHTK7MRtaZ11jIQFgPKRF124Im9m8Cohk2RafVIuv+GyQok0qqmEdbUZ9M9bWk8f/ITKGeKv4h1B4+uHrCpGMWcA6MEXrsb1zzyzVOvKBwheSeJG6PEZNoND+IKJqmOsDwTlPW5FYT+RcywHV6aDKMy55imBMwIJd4NPR6RqLEqWv3lerLT8MMH+YO/kCGlMw/fZ+BPiF0FY8ESSrJJ7Q3n07S6X3ngjgGdS7hJYGVru1vobinlhJLmnHZO5+mAnbdhCZ+ur60Guwu/GQPdYQVIY8IbR2tb9r2qJMETdSVDRWoXOT49IL8k3xz66aZqUlM2rOWFNlGchV3EmHT6R2GydKCHNBzvADLZcwvXvfZf4FtFy3Qj7evVx/u892cdcJ/c0k+EhA8fYjCa5ErogHzPtL+GehE6+KrbWUTAFEIcDmFT2ycDlRhPRWNhOZ/QIlFuSORSwIOvA4a4JMpVY44fDW36zqtDCG+Yp7KOoXm6UZFEGbZuySMPcSWk74VW9C+7T0oTZ9bxu7UEA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9715.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bAN+WSAm+/6urlHsCgXFHMYKKdkbUGhHWzkQfur6KmU09L1PgKmavjjvwWAO?=
 =?us-ascii?Q?ZgUkboTetqWzzRVlaJIGgCLCR+5d/0+w7tXqXuWOE08PBjCn84bZAWSXNOEU?=
 =?us-ascii?Q?SW9m5fleybo3PV39X387Nk4ItkZKJHrMheROiRLyK8EI+jxHNttZCYLHfA0Y?=
 =?us-ascii?Q?pJbF1D078OtwS+3Fd6jG6+4/tCdBWh4DRnjlwoAXb/EBnenBPHRzJfGZUOi1?=
 =?us-ascii?Q?e4j4I6u/5HZ4oztlLv5i7nS/AY/hRZrajLYPkuslbJ0FgIJ9V/RCMWy3+vaV?=
 =?us-ascii?Q?MBAw3ZArRWToprI9M3O5+jqwufNd15yUZGj/GfnRUwnrHIUhW0ZRoSV48fJt?=
 =?us-ascii?Q?8Akdlt9IPBheAmr+I2AwNKDvZ1KTNIQeLZUv8bj4BUtmLLfBl8AIG0Y1MuGf?=
 =?us-ascii?Q?X0OFmAK5F++4uIYY9kGuy/QVZW7b1l1GezRnwB8zvs53zh/nWuXVak1yPTDA?=
 =?us-ascii?Q?A+LYfZ9e76uRvvfZVB6iIVgTNbiZP13HFjU4AvRKy8H9+IHmqLMZfFVo4n4P?=
 =?us-ascii?Q?UnMqWQ3/7/0IDWBNxx4lo8V2GL44OY4n4lTme1goaJtLbegwX2W0zxqhpXmW?=
 =?us-ascii?Q?ticcUQlFYKIAR0uH56sEs1we3Wn31Ky0kNHVwSXd8BYMNC13xolser4msiTQ?=
 =?us-ascii?Q?9Mqq7Wt1gO4AL0Q1Sksa/LESsQtZcIedlr8bNGOfJxFX3kPTVSdxWmunAkpR?=
 =?us-ascii?Q?mVTMqLhCQrKBKBInXDjNqb1fTLkZDx1OfkJyy/o1ZKA3+tqliqjHL8pKHM9Q?=
 =?us-ascii?Q?kwVt1oNsPfbJu+4x1NMhGiUn5EH7Z7SRG7LYwq5HdFSjGGJNEbe94O5FcJiQ?=
 =?us-ascii?Q?Ys3cy1xsnjpqGiBHZTlFC8Uc1td+Tm7x61+FY8LneUv9lH85h8oXdZ21nKfB?=
 =?us-ascii?Q?AaVFHFv7nZFyYfjj5O2yd+RpWKgop3VYQP/abzKd/Tq0hnC3rJ6CIVjEjhyK?=
 =?us-ascii?Q?6az0N9T72UC7rZTLZUPHHIw7G/fybYWFoxDiK6OTWIFb00fzMZpF6WoQJ3F5?=
 =?us-ascii?Q?/kaXz7HEQb4JrZjzNevpRVVCx7P2YT5hp6WALgDULuSTVEkXfN27f4tq27pP?=
 =?us-ascii?Q?lNStjHr3qRLE9ImLWbgDh2+9zoByPStqPF1ufyt1fcH9fCS00CZSQaas50ZI?=
 =?us-ascii?Q?Giet7UwvXVQ8EYsUgtPrxXZzJAg8sQ8djIguPPiCcykj0CrZ+RjjcoyCxEkx?=
 =?us-ascii?Q?g7fNxs872Brl/WazSZP19YvxMT1VBID+SKtKFVqnEHPKHIdenajyPJ+pqzH0?=
 =?us-ascii?Q?mrTcW5enarj31zOp2OpZBYI4qEFawSfpphPE45kze8XZz8yfKSmXXF0XVMV4?=
 =?us-ascii?Q?JxJgjuNC2jtTe1NRT0woFPi/aXCKj9L+7zlNQ2E8z2tEl4S+Lw3KJQ1meqE1?=
 =?us-ascii?Q?+c56ianu7GUTlxRwg0TF43J40dbM2bT6u3VFrQeDJbkRkaBRTtNVjxYXkXWy?=
 =?us-ascii?Q?PBggbxmLnu03Fttyv9rbiTN3KNUAYAK4OSOfWW9DGgOw3oTwGe/hOrTpax0j?=
 =?us-ascii?Q?lruvj/Dohv9sPxCNQdfWyKwdM/SQ3nQrpxCULC9FyW1sraFYzUTdt1KOmThz?=
 =?us-ascii?Q?sPFyBgJwENYcgmx0oAhrNbKa01rZEiafjX/VATa0phdGm+YflbaLS5k1Jqqh?=
 =?us-ascii?Q?a6Dxff6qsDKWHDpXwRhAaGXSVE2A7JmA4BXvgQhCnpC8GBKlIpCrTChPdn9O?=
 =?us-ascii?Q?RQgii8NSnsczrWoNLtcGcwPov1ba9RbrP54UQlKd0iQ3yKevPq3nw2vb6cff?=
 =?us-ascii?Q?mVY5O4Ug5g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deb0c8ef-dfcc-4277-64fe-08deeaf8858e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9715.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:30:24.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lIhHhe3sMSKLYx08734C+nsbTqtgkb0dyWco5nJslOVhDie7OoivMLjQQ7lqLGuXxJM0Nl7+3ZrrX5XS81vPnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-list of dmabuf registration
ioctl. Uverbs users can now request any optional access flag on dmabuf
registrations and drivers will apply the flag's effect on a best-effort
basis when supported.

Fixes: bfe0cc6eb249 ("RDMA/uverbs: Add uverbs command for dma-buf based MR registration")
Cc: stable@vger.kernel.org
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 0c72f801e0d3..b6d6cbe448a2 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -229,7 +229,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR)(
 				 IB_ACCESS_REMOTE_READ |
 				 IB_ACCESS_REMOTE_WRITE |
 				 IB_ACCESS_REMOTE_ATOMIC |
-				 IB_ACCESS_RELAXED_ORDERING);
+				 IB_ACCESS_OPTIONAL);
 	if (ret)
 		return ret;
 
-- 
2.52.0

