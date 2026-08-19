Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8215C437461;
	Wed, 19 Aug 2026 09:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787131624; cv=fail; b=cRLWRaQjc1iQ66lNE9bKTsM6EiuMgv168SO1SccQUhxIY0U+pGcyxDfpSB3sq91Rm4pMjyEsxgtH9SRRGHFydN3/GZJv2i0WCE4JkmfhWcZjN+JBFE9craPs3ZqOEkX5I70Q4MEC+H03xN2lyY5yeTa4l/rFSZz49PBFqPPBagM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787131624; c=relaxed/simple;
	bh=XaDYCaMk7E/SwVvh+jZnTk97Ea14myIewA6rmtZEyyc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aN7WB69AlmOa6k7gdwC+Zgrp9W0XIndZ6J6qYaW63Rx8rlcyM38wQJNDENV086lrTaVeaH4nat7FjZM9g6jjT6sHzu6M5Vyic+dnh8Cln6op7Oh2YJUbz6Six7AIgjXGcvKXIstrG+nTTiSjAN/fS68Ga0NUMP+36u4TXJWj7oA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RJZWONl4; arc=fail smtp.client-ip=52.101.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RJZWONl4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OO60X9LGFLhuCuP53dPDpITrkCJOFtNaRqk81C/F2fyuoyLvE1V/r+40JcEXmGtwthKdE7jr0mOEeai0Fhb69cOGFxpUNjPc+sVrdhm1LF0DiWnTE+nmyICfAkZMtOZnNEkFddJNwZsy8uckAAEEImBGHRA/DyNIZHoGYPdCh7IkdIKqjAEUlHV4d2Xil0S5UkOCvMVPtJKeUmuDSTpqR0lFgFw2c/Hiaw0cxNJqOyzlfHb8k30OXA1Z9Oip3IZWV0WyBuj2vd/R0Nrv1IYm8mGfllpp2+ip+d2wLujXiOcGTEc/1TWxQysPmNrzjoU5Wz1Wx3JyGFp/4TW8jPxY+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaDYCaMk7E/SwVvh+jZnTk97Ea14myIewA6rmtZEyyc=;
 b=ZMSlWdU856ngDGW88M5UrZlGHXzH9OKWr5S29e/LouQqAxFGF8c8BAwsHm0JmC7Xtk0Nvz7MUAT6nlpHFtu2gIS9SdNTP6IS4Rjcuclo0eb5xL03yooPQqMeSk5Sypsb/Ups1GAV3rRR2ujqUF8zCS09dht+zSyPYGNBv1XRSt6QHvrVXAMQoZrH7/Hkh6hUjqd8HciRJBUdT/jMxj0p1VObOFe0jPCv0p7BoN3L0ivWNx/wOiZ8w7H46kDgn6W/85XHcB2gb7G369GyzCc1JzicBs3dcyJMlgHDfQ+JWeceXPlkgrdlO+wlBsX1GFQS3h2PqDyi3iGvdCJUf+0Udw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaDYCaMk7E/SwVvh+jZnTk97Ea14myIewA6rmtZEyyc=;
 b=RJZWONl45gFZ9HtB6mDYqn16TY1984cqFtBpcf855vS1p1gFzQoJKjwOTpdNRHyI1+M8FHQjlyt4CkoefgnW1L4YP8ylsoeynpqB7T1CSvD13MSdsTSgXJ5ACCV8tClfmGU+DrwLLM5WkmL0s0ya1rVBbkG7ZknZ8k3M/hMKJIb/PvepdtIywIQvaNNi9hDiXkItVFgnV+0tKYmDh7/nySz9dXWXHjt3mhMEvKbb5JVG9CLjmx1b2a4H2bxHSV0Jt0uKWn5r4JRS2pZJbB/G+P5nq+R8xTmwJcJdNQYk0aPw87gAR4IR+vWVSYG5dAxV9OwalIsmc87TXQzxyEsHuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS0PR12MB7558.namprd12.prod.outlook.com (2603:10b6:8:133::21)
 by MW4PR12MB7468.namprd12.prod.outlook.com (2603:10b6:303:212::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 09:26:52 +0000
Received: from DS0PR12MB7558.namprd12.prod.outlook.com
 ([fe80::96ea:b67a:4a5b:85e0]) by DS0PR12MB7558.namprd12.prod.outlook.com
 ([fe80::96ea:b67a:4a5b:85e0%4]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 09:26:52 +0000
Message-ID: <2e4cca68-dfe2-4a2c-82d2-8d4790b36ab3@nvidia.com>
Date: Wed, 19 Aug 2026 12:26:47 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] IB/iser: reject a remote invalidation of an
 unregistered direction
To: Yehyeong Lee <yhlee@isslab.korea.ac.kr>, sagi@grimberg.me
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, dledford@redhat.com, stable@vger.kernel.org
References: <20260819010804.641772-1-yhlee@isslab.korea.ac.kr>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20260819010804.641772-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::19) To DS0PR12MB7558.namprd12.prod.outlook.com
 (2603:10b6:8:133::21)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7558:EE_|MW4PR12MB7468:EE_
X-MS-Office365-Filtering-Correlation-Id: 688ab9e6-e9c1-4509-b5e0-08defdd400c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8ju75FcUPkZ5y6rHI0x6lRIsdkVgBI7w46EpAGUFZ7hDJjiv1KhMj9d20Eerc2c8dzuYnvyJxqAwsqTtJVAUGUVJ5FYWGmzAsgUDMYWSaIG589ntlqy/VNIYLQPgC/nrglCg5HNwjoN4WRU7XAr7/GFJmrqwSCyYAzUcjvagoETxl+6qysCkjSWgO/4cam7pOsUMxvx1DhiaChqj2AciZhXiVby963b9HPPs03cSkBGZiLxhNj4L5lsToR4HKn2loZ1kwhqcq701hyB94mbR6xNvjVybOOlTXjgYqG5VOVkoWSwfF7Io9CLNPlFwu3dDsL2axDk1mJ9BROtYgawdAg76UZ/4DGMnCff6K71kNi/mOQukaHlTjk9yw2vQWwDYAP1qp+7loL7dagxs/Ku/z+QK63wJ+W35Yd8BeNr99sMz2zCGeoMp6vR0bLdXjCietClutKtLy5EXjx8VKdBxeQAvCVNu7/tWECCpXfThBZLdcjC5xifcogxd2vABXmbW+3SMs3FlV0qDjyiRfKZXRJfJxpbyOswU+46QXaid8qnCd3nLFvouPPqUvKFWbHTYN9lYPWcsNw7c/xxq+COhSbGBuWvSGdHq8yDLJHHwonPb3D4g0MZYehySyw/v6ZGS7AP48ltcYC6Do/6aUDyZYt9MTs8/wVzXcUiIx3eAHEs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7558.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WSs0T3ZBTS84aUE0VUNFajdzKzRSTTU3TGNxT0ZPYlVtd3I0ZDVWSE5QS3hO?=
 =?utf-8?B?WUpPaThhUURrQnBpOWZCVUJOU1UyaGptTG1LNktFbFpsbHV1YmlHbCt4SUR2?=
 =?utf-8?B?MmZJUitiWHQwY0RVeDlaaDBhandIem9mY1I1aS9IOGo2NHdYMCtReUpHVlBC?=
 =?utf-8?B?UCtIK0M0K1pxeVBiWjhVSjBpY2lTaGJUUHlaMG1EcFA5d2ZHWXl0YkgrZWpQ?=
 =?utf-8?B?cTVsNUZxRFVYUTdiaENVdDk5eE9YSTNsejhzbnl0SEZxcDBIUUJlYmlKNEhZ?=
 =?utf-8?B?OC9UbkdpOGNZOHlENmV0RHJ2eTJPc01vVE54ZlduaVVhVFh3Q2gyNlpVTExF?=
 =?utf-8?B?VGx2akRFS3hvL0d2WmhzSjBFK0NjelVCY1hOTDhyVUhFaWtDdWtiZ3BLdG5M?=
 =?utf-8?B?aHlMZHFReVYvWG0zV0hRM2YwZHprSW1hYm5jdTRYWEJyQUFuMkN3M3hYMHVG?=
 =?utf-8?B?UUFsU0VMMHdObGIvNEtLUkpsVERhME5MeWh4KzZxcnp4WEZyQ1hCZEFMQlZo?=
 =?utf-8?B?STF3NDVZTTZCSVhDYXVCQkNqWit4dHZWVkFRaHozQ0JRb21sZVVXbHIyQ2N2?=
 =?utf-8?B?UjJBMHhBcW5NeTJnTGt1WDM5RlhWcDNJTUw2K3A0bkd1M2Z6OURZSW9HbzN5?=
 =?utf-8?B?bGhkbThZcnR0ZFJWRytqR0xTQWhGQTM2ckdXU2JxczJqRVMrYk1sazM1ZS90?=
 =?utf-8?B?b0ZkL0YyYWN4OXF3ellEKzQ1Y0RHZjkzSy9GWnkycFBpSGd0VU5qRVZMN2k5?=
 =?utf-8?B?ODhvUE1hemVNSmpkZ1ZmVXQ0SnZEdWRTT2VQb25FazBHeUdBOHVpQXVnL0Zn?=
 =?utf-8?B?MzA4QUFrYUdTRkNudE9tNC8wbzhTb1J4VTRTYlM0NGZUY1pIci9qOG9CTGhO?=
 =?utf-8?B?RlNmMHVITm1xOCszWmJ5S2MrbHByTlBSRTBtSlBPYTZQZGFKSTZtZTdkUzly?=
 =?utf-8?B?d29FTlBKZk93Q1ROQ0krQ1BwU2lLdlBteEJ3VHZYb0xtanpxcU9BTHhXRVNt?=
 =?utf-8?B?U0Z1UE9xN0wvVEpTbmVacW5yTWYzeW50NUgvcHlDNFBxc0ZJT0FXTFpObE9K?=
 =?utf-8?B?SXpDamxlS1cweFY5S0NhZDdBR1pTUTBKS3JVd2Zmb2Yyb1lPTTNoak5mOS9x?=
 =?utf-8?B?YXVUQ2s3Z3hoVXcvSzBzd0UvdlBBcEtacjZCaWczN0FwMTlnWC9ZbEJkTi92?=
 =?utf-8?B?Z3dmeUJYZjc2bEcySkhjNG9WQkNHMGxKeUtSb2RIU3JqT1dvNnZCbHcyWE1i?=
 =?utf-8?B?bll4OUZPOU40QmJKME95MlVWZVNEMzdyakY1QzZnd2VDY25Wd1VhdnNqc2dI?=
 =?utf-8?B?WFdIbXRhVytHTEhGU1FFNjlDRitqcm9TMldHWTRrd20xNVlVZnNrQ3Nac0Vh?=
 =?utf-8?B?ZDk1ZjRzcTRScXQvV2lrTXNRKzNyZFFKc1o2eDZHOUJqNmFDYXVLREVDVzJO?=
 =?utf-8?B?bmxqTXhRdEFaSklYM1orRitMd08ydG9sZ3REQm9YTnl0cjlWcEMvMHA5VEtO?=
 =?utf-8?B?WGNpMmhpQ0lLc3JMWG5xZ1dyMWJFTitFY25nMmhIQzRzd2tNWnRLM2JlaWxn?=
 =?utf-8?B?T3pxZ25wME1WUjNIR3ZjMVJSa0UxY1ZsdXZqMERQb29PaDJBSGZSb2NmSHQ3?=
 =?utf-8?B?V1JUSXIwUEFPYjZaeElYOElJcXI3aUxDQVN2NFdkdUxNZkdsS2JkZkczVEZX?=
 =?utf-8?B?ZkJGUnBodngxaVduYjdUby95amcrNHorbTJKS3ZQV00rdzBFWEkvcURCeHNs?=
 =?utf-8?B?QXlJczR4Z2NSTEVkTy9SWE1kRXBOc2l1WHkxbzNCQmhKY0R1MHl6djhxQ2xa?=
 =?utf-8?B?T05hWU10K1NWeG5JUThvdFl6U1ljdWF1bExJeVR5RmxTM1FNcFE3YS93VDFL?=
 =?utf-8?B?OUtaYy9FODQwMXpBTHMxWG9YU0JVbTd1OFJGYlV4UWFaTDNScVpJUHMwdUlY?=
 =?utf-8?B?ZTZjLzhSMnBtNjJJVzRFWFFud1RvajM0Vm9SeHFKeWVsTERHZTRyRTZMUnhV?=
 =?utf-8?B?TXFmekRrMmpxbzdPR2dZY2VYSUIwNkdMYi9kaVhEdEZkUitjdElBRGsvQ1dM?=
 =?utf-8?B?TzV4ZVROWlVnQk5wcWt3cmNEVFdkbE1rZXlmN3VDNlMvT25RNnJJMkdqQkM3?=
 =?utf-8?B?cWI3S0ZRRmNsaHUrcWdtUy9RTWIyOTJHei9WaXlsRUlnUEdxM3VwZ3Z4SHIv?=
 =?utf-8?B?Ykx0YWJDUGtuT1FjWmIwWUU5TGV1NnNBcmlya0JXNEVHYmVzOStyakMzeWtw?=
 =?utf-8?B?UTdxMy8vRHhMTEdDblZkTHhjRDRqbmZLWlN3Wk1KYWVEbU5tazlBc1RCSDVa?=
 =?utf-8?B?dGx5aHpubGU5WkE3alhkeTdjUkxRNm96UW5jbjFYSml3UWVmeW5tdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688ab9e6-e9c1-4509-b5e0-08defdd400c4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7558.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 09:26:52.4014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yC5OG0j6fK9rlEhG86VOEbJNQidtr96WPTNx3xn3WnJ1BCHyT2zXPOW2rndtV5ZW/aujmpNRLI1syx/Szv8wcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7468

looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>

