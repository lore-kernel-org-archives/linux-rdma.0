Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068624766A6;
	Tue, 11 Aug 2026 19:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476721; cv=fail; b=CxYiOl2uoChLcBzTftXcH9qd9m4+sfXVnPtMrPbjeax2AGAbWQa6ZEqb4Mo/2uMQIleAyDT2+vYkyEdnRrMOd9SpZU9AmfsDt0cYsjkJ4dnr8U8teZZPndJ28wkvILWZH5W+/1jUZ4jcl6SspHHSlNainaDqdn/ALQSXSFbgX80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476721; c=relaxed/simple;
	bh=sQTHHhnfo61FPysEFFf+1rvg/sOE0hW/x7dsaPVMI8Q=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=bNmCSvxhE9v2CYTZ0dvOltRLRe3DoWeASKfwXKFr1jMov9AZOp7FEzrHWtLoxwKIk7g1VofP9V+TwwQg15ZhthwGawB/VX8zgHerzl8mGLBNS+XeuryctX8zOCC7fwEq8XoGe2blWA9obZaOkpRjfI6RyS0U23p29wWXw9R3kHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ywl7XjJ3; arc=fail smtp.client-ip=52.101.53.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ywl7XjJ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLzDQMFCpPS7+vslo3v5ROFbx/mTlBc0IGhcfzPNuGY5XJkxMoAyKvymEsb7I3NaltAhPzQ1EUxVRX7MBElXERS0yLfMEdsjvIJQGzemGWGwAAD4YCyTwSqF1iplCgxrGtae1MHrf0pxoPve7B9v6hfg0LmW2GdDkuWVckG1WSdsZbgVthnMljVJ8qSwg9IjmLVS5ItIb8ijSZHaHZiCr5hZkXUi7ugCliYXZ0ADVjI24CqwhgwObOrkMTmLo2s34OTCbPkCa11/xN4mGXHLKS4BdYOQ5lfN1GKJ4ErkYZhL1Yzy4HIgmMh8jcsxj+3hi5IE2fmwxCPnEGWRGgosxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79ZGvazQipoS3dA3sq+bwvgVDFWgsSulSQ8Ptj8ZKdg=;
 b=LcsDV6vjLAQBssHXCgO6o1bq0M0sJBk2qnPpq8Ujev/CwOOxogUvNPLjq87jZeEBPfiKm2gr11qbj6YbMxIiXzYWqPNsxiqZFCTQKF+Pu9vQ/V+Pmsd2hyNtlOKcVJ+zzpOJ8X8DQG+MaZNj1l7+Zd6Od+XDAJGaJjQThcqXhidGbAAHX+wiKy9oVoiAsnoUs0gXEdVTR8Z572d3Sc5GyG5pQWSyZEaWqrrDVL9fMDGeAsH2uy1rqTIasVPVtHTrS1OsoCQV6YsysIPeOEAR/p/M03fXEFqQm01jkvaySSvLxf9ZL8cpQT0BCyZkmOd/6kZ3ysTilXMJU3mpcSz7bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79ZGvazQipoS3dA3sq+bwvgVDFWgsSulSQ8Ptj8ZKdg=;
 b=Ywl7XjJ3rJUXNjhrhx0/2u7Xcxj17YKpTNGoLOraeff/Frg4/z1xAWlPVolYMalXtpFBS27xoG26dDcM9AEJHybluUZ5xbaVWORF//WNXBQTdVkvv8wuaZMnuC8lUK03nCtC7Oj42zaRaMXip+VRtH/G82qEBx64Yszhehk7uexwbnt3odF8R8RDrQlG96CSS2edlF+j8hO8pW+de5rfXGvvsmBZ1rlZSGO8XtmYhvLQcL7Y7GwB9lPKZ383c+yd8WD9NYjGmr5Bb1hMvCdSKirn7PgowlHJGyb0VpdgH+H3tEwrP/ep2IrmE4pkqnY9XKW8mRdj0/AdeI2vBGGIFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:53 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 14/15] RDMA/mlx5: Support new Unordered
 access flag
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-15-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-15-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669519.282103.10112232253077921606.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH2PR18CA0056.namprd18.prod.outlook.com
 (2603:10b6:610:55::36) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: 478ebb0b-649d-4e37-b664-08def7df2ffe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FivMA40amnvbBnD1p8ypKZ6T1PHcPWPlgi1/iQG8Skk1Ik01Lx/kQ3xSi2s4Mp3nCCYl3J+KXjJHtn6+Xt60/OUebxHYR3vWTPBz+BpuM1Lv0FOKQU5rZ2UCTO7tkaY/GR0+KKwHlsWr8/7cz96F43Q8NuYaRucCkBWPPGbOREWaqSb3R7tZrVz7H0mP/Mpra5Grlvxi4F7Rt3lj2TMqkpVTtlDPo7rpjL0SJvSGtEPg0ZHOXCCKU3zcIf4/r2bqvfldQ68ntg+g0BEf/OQTzi3FbvMrsifefxCiSKvco14mReX8tW07BBHsa4OIYdNXySx4b2UemyWzXMBITXGVf8Yvl7OrCtqTBQPBcp7+nTILmuzJUu/RuMcC7uQ4zJmtVeu7kOBNlKwYdF8GorNqZdEACil0qDworNPgvc2SKuaYcRP+CVfHC9FwhVSyUeSSkcXxRC6nQz4c/ESiJrLPB65HjCxOLL6AS99xREGq+Ri8AUN+rrX/UgSRbE8DbdHUdWo7jedNh8yMKZSBVnR+zSH+FI61caXM+gIsLerMuu266opl2kewbo1iNuW/xrUPSiBC/2i+Fbknb4cZ0ojqUUr4ZtliAYJ6OmtPs2ihmqFwOVmwiZ/0cBAszwIzyhdo4+3Lw/U1094tLTSZXAz1yg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEVmeUJ6aVgycCt2TXlvcmdPNURlN3RYTG03TC9GQnBLanVJdkhvcUhoK2dW?=
 =?utf-8?B?akQxa1V4RVVFZUN5S29ZYjUwaDQwcTNZeVBFWFIxZy9tWFV4QzFsMEFqTkw3?=
 =?utf-8?B?bjNKQ1VxbzBzdFZEYkFTU1p6NzlkT01kL2VBMnhKM0RZOHFqOTNyblFNbXc5?=
 =?utf-8?B?dFI4ZnlMZkRmWUpqL05zdlJzRmNXcjRIWnhNcDdGbGJIejE0eFdEZE5iMVZC?=
 =?utf-8?B?Tk95VndkMmxncEdtdFdvd0pMcTNXdmlDTEg5MFUxS0lxWkxJZ1M2dUVDRlhj?=
 =?utf-8?B?OU53dlRNdnd5emRnNEEvNEl1dmxMVTBISlBWclp0c2Jzc1RocmVIVDNTeHRM?=
 =?utf-8?B?THFMTVJUWE1sY3NVVzFuUEFqaVdKdE9nSkFtNWQ2U0FMc0JOQWxNZXlzbXhm?=
 =?utf-8?B?THRMcy9rQm5Hb2l1QnVLd2JHdDZxRWdReThoYXFWNVdBcG9lRlEwQ2hqYmJ5?=
 =?utf-8?B?ZTNqWDgwK0FOUTFBMU5hSlo4L1BNbiswOE5VUEdmZTQwZ0F4QnZGSkxUeXJh?=
 =?utf-8?B?VjA1MHd5RTVjMVZDRkUzeXRvbk50RVI1TngzT0ZFZCt2YUUwSVpUSElYSVcw?=
 =?utf-8?B?V1Y3c013UjQwWnUyaDgrajMyYlJDalFlV1lkempjZVppdm1rNW5lNTNiQk1M?=
 =?utf-8?B?QXA4aEY3YUh4QUg4ZHVhK3VOODFKQTBNNDBRNTVNZjNsWTVoSWZqd0lNRG1L?=
 =?utf-8?B?MUo4V2pPU0RDUmx2NWI4WDZnbzdGaXVnelZ6dGdqSTFDQUd5ampVYVBiRGI2?=
 =?utf-8?B?MkR0dFFZTGNXWXZhUEM1RHF1SEJ5ZnVydnlYcFRVS2xVaWdUbXNqSkJXNTlw?=
 =?utf-8?B?NDFxQnZkMC93VVRlWXB4aGRRVCs3WWJsSW4yMmZaWXgzK0dVMTVDNzNxZDA2?=
 =?utf-8?B?ejhoMkV2ZUg0L0dTNDM3U2RxUXU1ZDdqSlhQdklZdWFwWXkzNU52OGdnRWtp?=
 =?utf-8?B?SXlySElraDkwNWJvVFcySklpN0xnZzdHRnpTMUJ6eGxYbG9PU01Idk9vNEZp?=
 =?utf-8?B?amRKUzZkc0xRL200a3U1eUxYdmE2NG9hTkJydUErZTdjV1ZrVnBDRXNremRl?=
 =?utf-8?B?VTJUamY0c3FTdzBPMFI2WXJaUXhua28xbnpwUjJFVXFUdlNaS0pwaUlVSmN0?=
 =?utf-8?B?eVc2ZTBGY0d6OVFZTmxFeTkwd1ZUTmFrQmJYWGFaV3pZR0pNV2RZZWNENFZZ?=
 =?utf-8?B?eGxHOFVoNjBTSTh4THZlZE9LR3RmQXgyczNkSk43VEx5ZGluSHE2d2xvQ0Y2?=
 =?utf-8?B?ekIxc2pCRU9MZXF0QlFLMVg4d2pkUzZiaHBCU3EyYWZEaFZ5SkxJSXRYZXVZ?=
 =?utf-8?B?dGt6NzVVR0VIblJUbFMwdDJqVHltazBaQUVJYXR5dit4cnZLQVQ5c2tLVlpr?=
 =?utf-8?B?WTdQTXgwQXp2UXhjL1krWjk3WmRQVWFSWWdMSm5uU2x0RlhRZGxlN3c1ZktY?=
 =?utf-8?B?aVoxWDhUeFN1N0NqRDJWd0g2VzQ0bk1MVUtBcGxGNUlFdUk0WFQva3EwRGwx?=
 =?utf-8?B?WE5SWkMrdWcyUnljSVBzN0VDajJROUJ0RTZlSDZ1a1gwUW0wTjIxdjV4QzFJ?=
 =?utf-8?B?UzVPYndaRkZsQWlRcnhld1V5cUt2UzNHVW01b09FeXRwZU8xd3pMaXE0anNx?=
 =?utf-8?B?TVF2VUliWnBVMHRQeFRlY1NiS3NZLzI1OU9BZ2poZ3VTVDRxY3prU0JNamtI?=
 =?utf-8?B?b2sxcTZrQzdUUjBBMDhqU1JWeUV6VG9OYXlhb3VEbnREdEwyOGxqdXRVOGpD?=
 =?utf-8?B?cFRXbjludE5JSldrY2JPYVk3NUxXcndJK1B4eHBOVDNLZ0lHK0ZlNklaZnV6?=
 =?utf-8?B?K05lUEJyR3prbVFGQW1JcytkUW1JY3VmOTUxTlVQOG9ZQ0ZzMHN4V2xERlRz?=
 =?utf-8?B?RVlnRmNhYzRvYTRTbk1wdFZhYWN3cm8xZC94ZmVRUDFXZjkweStYd3BLa2cv?=
 =?utf-8?B?NEFOcDYxaVk3d2lLMlVNUTBNazNkT25Uc3dJcUtydTdZUW5hd0hjdy9Camsw?=
 =?utf-8?B?RUVGSkwvVnhoZTNlRTJmYTMyZDBKdWZUdk9rWkJheUJwZmVnTXdEOENkanhK?=
 =?utf-8?B?NitGRFQwRklpZlA5M1NvMkEzMUxROVVsNmZPTFdrdStRSFZLOGNlSFpYT3Y2?=
 =?utf-8?B?WkJBTm9nSmhrT3FCM0MyeG56R3ZQTGw2eElHYVlwTkphL0g4c2lac3VEazZ6?=
 =?utf-8?B?K1F5Y1N3VFBVRnZYMVV5R1FZa2NIRTdVYWVlejVVR2JGa2lsOFJyaWltK1dQ?=
 =?utf-8?B?UC8vdFMzYWpOMDB2Vk9Od216NkNrQ09xakNQaExubXQ0bFdid0NpeHpUVk1y?=
 =?utf-8?B?Z1JMczhVZUo0M2N4ZGRiWDhralhvOGZDenFTZ0FaZXF5QVcxd3Z4QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 478ebb0b-649d-4e37-b664-08def7df2ffe
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:49.0624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqSB11mKbFhhbh5Wmg90hGut9pS9lSRMtCABI7BrWi1uomJKwBjLqllY8rXUe6OT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

> @@ -71,9 +71,14 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
>  	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
>  	MLX5_SET(mkc, mkc, lr, 1);
>  
> -	if (acc & IB_ACCESS_RELAXED_ORDERING)
> +	if (acc & (IB_ACCESS_RELAXED_ORDERING | IB_ACCESS_UNORDERED))
>  		mlx5_core_mkey_set_relaxed_ordering(dev->mdev, mkc);
>  
> +	if ((acc & IB_ACCESS_UNORDERED) &&
> +	    MLX5_CAP_GEN(dev->mdev, mkc_order_read_after_write))
> +		MLX5_SET(mkc, mkc, order_read_after_write,
> +			 MLX5_MKC_ORDER_READ_AFTER_WRITE_RO);

So we have this nice helper that sets all the bits then we open code other bits?
Let's have the helper do everything?

Since the new bit is not umr able I would have expected this patch to also
introduce some logic in the mkey key system so we are checking that the cached
mkeys have the right mkc? (even though on this HW we expect them to all be uniform)

-- 
Jason
