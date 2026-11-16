Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794864472;
	b=agpWhGjlWSi7y0HDjarXTYCv5FLdC/5GXHcC8YNUNwknlZFcKEwukcHUWNfN4zE7706H
	 /BIbUAvnPgI0n+gk/MS+wrYsA8jgWAXyXKxsjFqZ1lQoRULgadONcE2gs40IPJeShtME9
	 jhoDvg7E77tha5a4qZ6wVHX5zpw9TfDMp2zWGz9LDjM6da0B3wvuybcgXOS1weaeIT7c0
	 tMYX3WV6QbXEhb3v2OAHvYo0dnngC8cQmAjRTiozBplF6s3Wku97bVHvUaxzsxL7lm3s3
	 gMYpv4EIcBp2TNq7Fo6rgtyBY/dJOLJxmR6AQmypcXJf22/NH4wCoc7DJ2QySm8R+DQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864472;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=OFX5LcTMvChLZsAT4zOQzAlVYckRDM2Z5EHbvxhK4VE=;
	b=jSTG1ns0nvQQgo5aQpVAOP+h7q66FjsL5qcNSOW9cni5XvwLVeET0AkWTBKEpjbT0i0I
	 ss+4p6if7uhOa7i5YlB0L0tVIgUWv4ExXeS/9jFaKA+9V1cl0BO9d9Iv7Nd4qZniltCMO
	 FbWWUMgEg6W2QhzoQcE2JIg6FwdqCFf7x8pJGIWwISf2rJhT3jn30rpMD/Hy2mdSbMB3v
	 Uw0+fofEPmEQWjRCNaWl4WuKFNTDx54pabgdPJxopXdF6colXW8xfzcxyBSqTrPfNEZR0
	 Llj9b572qZH57e19xys5Tl1WnZ831OrNBFbqCnIX/kyD/pAfkvImkTdpwmXuSPPeLTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YFftysGl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.57
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010057.outbound.protection.outlook.com [52.101.201.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974EC606A33B;
	Mon, 16 Nov 2026 21:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 974EC606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YFftysGl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=txyzEDhVh3A4EwG/uE5eam3Mu+tPV6kHiyRn9/h7qAr8Y8aDvl2Eusr0tXugHOtBEBrv9wjdXuFWPIf0iQrMbJWmxP3P2+vHa+JzH9WL57yJoUSzpN7Lnn6AVKaktBFBOFl4JIGJY21KZXVt1gp4oC0N9xMaBVnaqSwVW/eTNaboBMD1uEvgcfvHw3ft1sSTOCrUU+yMuPWO9CoFC2OiIKYcqrjY46RVFQeqIkt51KvFaxS4Wx9ZjInIm7hh7JKVZj8Wmzuqh7WfMe+zHiExNDTbGpSpDEYv53j0L9IL78L6Lf28Pg2ZMgfKzc4VyB5yKBboASYCN/KaEtcAty6oRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFX5LcTMvChLZsAT4zOQzAlVYckRDM2Z5EHbvxhK4VE=;
 b=bswnQJQ6mnp/cU6i9oFT/1vwJxkzoDiFLDilgQ6Ehcpi8c2HHwIeZoP/t/7MYU5/WQQqYkplSp1J4q2sqV50k4+TX9i7GmB2mVv13k68RomTBSycPTtX0lbs89G4sOA7YWP2VSyXHjIP0fOU67h783WeGUWnMZPRYTerN/3tofhkgJH61ayXEGHKQ1sT5lpgt6WYzQdsF5tL8yVwGYXgEZFpcQumUBGtzRi1oVOHObgWIoY0YfFppODmT2xtatZvV2UCT9cOHYR0fEM09MBweAXfjKXU7BvgOGSnxj4wePGBon3CA4AGZWfv2CUmZ+5tzFwYJzTUpdL19xN7p8lYtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFX5LcTMvChLZsAT4zOQzAlVYckRDM2Z5EHbvxhK4VE=;
 b=YFftysGlwYo1FACw9YcSqMhy7FKP/O27CL7eJN63BPyPLAGWdY1GQSCY/phwbZ6XQCLRE12McMG8EaD2dzuImS/SfaBEzDrctMXe/nOuKdyhLXLw206XmzU/O7WaQoZdVgxrrPc56tHxJNA83M3CciraM+yMyEcCDqJL0Ac1t0MJrBDUWfFMYftA8UfP4Jy6O8r9PDA1ykVmTmV4zd/dbc8UEMGNl76pnCgObRQwZXnNKM2YMb4e+cQVzX+Oi47qMtLgtr0KjVDi49MehBV9HtyZpbG5JBPCcRdL95aKqsYtnfk7bE6IJnhK5deeSAu12+OmnbdVMspWfLOtIBt2fg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SA1PR12MB8698.namprd12.prod.outlook.com
 (2603:10b6:806:38b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 21:27:47 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 21:27:46 +0000
Message-ID: <b0f73ee2-fdff-4b5f-b8d0-43cd293d3058@nvidia.com>
Date: Mon, 16 Nov 2026 23:27:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5e: kTLS, Simplify error unwind in
 mlx5e_ktls_set_feature_rx()
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>, netdev@vger.kernel.org
Cc: horms@kernel.org, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, borisp@nvidia.com, witu@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261116110830.2850785-1-xuanqiang.luo@linux.dev>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261116110830.2850785-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0015.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::11) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SA1PR12MB8698:EE_
X-MS-Office365-Filtering-Correlation-Id: 69905a38-a9ca-4747-f3da-08df44287544
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|18002099003|22082099003|11063799006|56012099006|10067099003|261026121527099003|261028144727099003|261021123027099003|261021121427099003|261026140227099003|261009223027099003|261102123227099003|261021135927099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	zSubF1PT8PEFt4EPCcQKtUZLwYpVqRl+sPNLktYHnevhjfSblWHcDUnXFFeLYB01HwKmav3HWBlSai9trKksFscJfGVnhaZcEZrdxdlTD9iwORAXjFtAQwx/AmNuah4Wv+O+G4BZZxFum5Ftqpmbo6UPT0c6nR5J6HawZOAm82sog5TJzF24kQdxP/fxLyKqYfVDcA3pWbeMrpRRnZS2Sn+XhCDrzCzBLDyqdSJokrMnMemX/r3LiBUkyNkQQjXhYwhAh/01MTbNAQ20RIWAEVcuMDbvECNGnL+tldUx+YxTmYCP6qNIKxAoIZABt+9+AoDP8cH8yBWIY0dKdxw97rSlY85X496tLSr/9R8vNxyphqIgbCs4Go25ozTA1LNf29540f423tj9cMDcK6zA/YxXuB58dIfyNA4YqqJdTCMnqwAwWDSCI+fN2WXCZRr+n/Pte4J96i0Wz2AT4iuCdvHp14LwsL3v/R/Rq+kY46a/DX1JmGhV1YwW807zVRBTfbZwZn+Tn2mAp/D9Fs6vyn9a2jTRiUtXFWPIkbOtrxpw0VCXkCD3nJLcAfFXv6c/yFtWyETLdETyas7LMzDef7arS2i4G7Fs+g/K9zxG+MHO1EY6myrg8TS8dAjhGRjzY30l41BXSl/hpvzQQOBw3BkyYnLoazTPjjQ2LrDk4yw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006)(10067099003)(261026121527099003)(261028144727099003)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003)(261102123227099003)(261021135927099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NE5tZXU5ZXRYZHRTUE9BQUVMVStac1FwK1QvanJQWWNrQXQ3bUV4dVpQVmhX?=
 =?utf-8?B?MHBWNWplZ0RtQzJ2YnB1bHNHUnoxZHo2NTJHMzZ1VnV1blJkR1N0cHBuT01C?=
 =?utf-8?B?Yk16cjhsRzhWWHg4VTBFeDNKaG1tazFybm8wRm5MSDlEN3pXZlZib0hCTkVi?=
 =?utf-8?B?L1JPMllqa0V5VGpsNytBeDFUZ0Uxa1BCa2RYSVlBemF5bGI5YXZpbTc5ZVlG?=
 =?utf-8?B?VzMweUlLcEVMRmNsSWhVa2RQYU9NR0o3ZnpxNGtxaDAyTlB1UUI3bFZNUFBI?=
 =?utf-8?B?QXpIK0VvMTBJWndwc3lSTnhGM1pDazd3dGI3aCs2R1ZMN1FsNS9RaDVaMUpO?=
 =?utf-8?B?RHE4YUlCMXc5TmZGUjVuTE1PeWtMVGZxM2hKMEc4ZmhPbzd3WCtwR0p3aGFZ?=
 =?utf-8?B?aURCY1BiSVpUTTR4TWhPNEEyRHJLQ2dhaUN3UWdvSlNPWjBSSkZwWUJyNlRP?=
 =?utf-8?B?VmZrTG5kODJXb3FiUWlaaW9NbklwVUF6MkVFazF4TzBHeXVZbSsyVHprQ1di?=
 =?utf-8?B?NmhnNVZVMFZMYzB4elVVSXE0MmRBSjFQQVgvZEZ3UDhmTHBHWlQ4RW9jdnFt?=
 =?utf-8?B?bzBzeURFVlh1aGUva25GR3lJUHZWNE1GVDBJUVJER0pmREE3UTJOTVhFVU1i?=
 =?utf-8?B?OXdldk5qVlFMMnk2aE1pM05WY3B4bWkyZDQ4dkVzNzJpRkNoRFFjMEY0S3RH?=
 =?utf-8?B?TTExNXZiaHBYc3puZlcvK2h0VFNWZk9xYkNIemlCbEwwODJTL2ZkeEswVGxy?=
 =?utf-8?B?dElJMnFIMlQ2V29YRVlmTXJJd1RzbFl6WmZFa3V6b1VQdHpaWVZ0a0FsMy9N?=
 =?utf-8?B?YWtKcjkyQzd1YlFHZytPWDJDYXdOSHplVnhjMHRrSHNyNzlIbEp5SEtTUHRX?=
 =?utf-8?B?T1ROV282alVROVNsLys3TXI1YnlyNllrakdCSG8ySjMxQ3Iybm0remlGWFYx?=
 =?utf-8?B?djkvWVBFN01kVEs3YXFJUlNMZlcyMFBEZUZPQXFWYUZraWJUYVR6WWp5WjVU?=
 =?utf-8?B?QWgrQ2dsaW1ScUE5TENmSHZxcnNXemp4RjRhVmJhVXQ5bjUwTlYyWmVwbUxS?=
 =?utf-8?B?VXp4dEdOY1dDdFArM3RQamJ4U1BKYVF4MTlFT01iamtwQ21YWmUxc3M3R0Er?=
 =?utf-8?B?TGJ0c29hZldwZmZ2dTNzdXVGM3VJdEVaRkwvQnpUV1ErbnhPdEh5YWRTQWJz?=
 =?utf-8?B?ZHlRQ0xRLzdXM3VLRGVaTlFrVnVtb0hyejQ4eUo2dGpQZkg2RU9UQjZ1bEJL?=
 =?utf-8?B?VXpVY1NxTk1PNG52K3ZGc00vRmd5cmZnTWYza01DUlZpZ0VGMlptVG4yN01V?=
 =?utf-8?B?UkJnUnZHaXNaWDhjS2w0UHdHeTQ1MTBDbGJTSmQzV1Q5bStDVmxERHR5WlFH?=
 =?utf-8?B?WkRXanJVV2wraGZTTVpkUXF4Snp0bE1kMGlveExSazBldTV4Q0VSWm5wSXZL?=
 =?utf-8?B?VXhvQVdoWGUrdDQxWFFGdU9Yd1U3MGZXUHhTNFBLMi83SStFeUh2UHYrWVQ5?=
 =?utf-8?B?Y1FNaDkvVU9yMlNCeXJiR2dCRCt1c2VzS29xTVlpQ1o3M2N5UmJhK3NQeUF2?=
 =?utf-8?B?M1Rod21MeEUxQWFLSTYvK1ByOW9nRm9HTWxYVm9hMVo1eWxvVGt1bkd0Zkti?=
 =?utf-8?B?QjBHUWdFMW1mK2dOY05WUFdIM3VoTWl6NHMraWFvY3EwaTJ6SXlwODRROWRp?=
 =?utf-8?B?NStWQ1VhdDA3M216Z05KZ2VjcFM0UjVRUzBvdW80bmk0K0JBbTUyVkJxRmQ3?=
 =?utf-8?B?M0tIdEYvUU1yR0d1cWk5Ny95eDlnQ096a2wrVi93dWlYTExxSmhQSE5wQ3NH?=
 =?utf-8?B?b1BGNkdSK1VGNk9VbUFWUXd2SFByYWlieGtjVlBIRWU4Vmg4SkFDbTZURHpZ?=
 =?utf-8?B?QUorSld1cGp6L2l3YXdPRWo4RHBEbStESkpOU1BHbDZtM3loUVNveHJVd2Fs?=
 =?utf-8?B?NGdvRDdlYzVwTEhPYzF0QXcwa25MZ2NZWU9qVU01eFB1UlRDMFBEbTVWOXdP?=
 =?utf-8?B?aWVBWitTUmU2SSsydUFkWHJTMDk4NS93bWszNjYwV0VuNUpkUlJwemYxMUY2?=
 =?utf-8?B?QlpSUXhoMWlMei9SRG9MTytRUEZQMmV2NXJEaGFpU1o2Snk5MkJwN3dpcDY0?=
 =?utf-8?B?TExzdzN2R1VWOVRKemZrWHBkWHRLdVhwcWZvNjZMTmNQNERscUo4RjBicGs4?=
 =?utf-8?B?VzlGZHVDVWZFQ3ZWZ0JvRnhJaTZCT25hL2M4cjFiWEswRlpjMHhtK3VseEMw?=
 =?utf-8?B?OVM5ZTh3eFZxT0Z5ME5SSk9NanVIaGJqWGYrZm5SQUppKzNtdGo5M3E4d0o5?=
 =?utf-8?B?am5rQnBFVkFUd1VXNzdjdU02UGJ2blV5eWdWSlY2NE1nSkhMdE1mQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69905a38-a9ca-4747-f3da-08df44287544
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 21:27:46.8492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1QFSqWgKsIQZu+cG5CRX8LBCApeCHcp1G+7qvgdy25F1KJLElHBIktk2EXvnR5ykRYT4dZ5Gqx8VJLTLh5PJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8698



On 16/11/2026 13:08, Xuanqiang Luo wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> mlx5e_ktls_set_feature_rx() has become harder to follow: the error
> handling is nested in the conditions and the main flow is conditional.
> 
> Handle the error cases in conditionals, keep the main flow
> unconditional, and destroy the accel TCP flow tables in a single
> place. Use goto to unlock on the early return.
> 
> No functional change intended.
> 

Thanks for following up on this.
The change is correct, I see no functional change.

However, we can simplify the code further.
See below suggestion where code is flat, the same size, and leaves the 
enable argument alone.

> Suggested-by: Simon Horman <horms@kernel.org>
> Link: https://lore.kernel.org/all/20261029134019.GG257209@horms.kernel.org/
> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> ---
> Only compile-tested on top of net-next 7ccc5e05043b (arm64, W=1). I do
> not have a crypto-enabled ConnectX NIC to run it on.
> 
>   .../mellanox/mlx5/core/en_accel/ktls.c        | 23 +++++++++++--------
>   1 file changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> index 3cc1213c2f68..0f5dcd1b822e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
> @@ -137,19 +137,22 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
>   	mutex_lock(&priv->state_lock);
>   	if (enable) {
>   		err = mlx5e_accel_fs_tcp_create(priv->fs);
> -		if (!err && !priv->ktls_rx_was_enabled) {
> -			priv->ktls_rx_was_enabled = true;
> -			err = mlx5e_safe_reopen_channels(priv);
> -			if (err) {
> -				priv->ktls_rx_was_enabled = false;
> -				mlx5e_accel_fs_tcp_destroy(priv->fs);
> -			}
> +		if (err || priv->ktls_rx_was_enabled)
> +			goto out_unlock;
> +
> +		priv->ktls_rx_was_enabled = true;
> +		err = mlx5e_safe_reopen_channels(priv);
> +		if (err) {
> +			priv->ktls_rx_was_enabled = false;
> +			enable = false;
>   		}
> -	} else {
> -		mlx5e_accel_fs_tcp_destroy(priv->fs);
>   	}
> -	mutex_unlock(&priv->state_lock);
>   
> +	if (!enable)
> +		mlx5e_accel_fs_tcp_destroy(priv->fs);
> +
> +out_unlock:
> +	mutex_unlock(&priv->state_lock);
>   	return err;
>   }
>   

Suggestion:

	mutex_lock(&priv->state_lock);
	if (!enable) {
		mlx5e_accel_fs_tcp_destroy(priv->fs);
		goto out_unlock;
	}

	err = mlx5e_accel_fs_tcp_create(priv->fs);
	if (err || priv->ktls_rx_was_enabled)
		goto out_unlock;

	priv->ktls_rx_was_enabled = true;
	err = mlx5e_safe_reopen_channels(priv);
	if (err) {
		priv->ktls_rx_was_enabled = false;
		mlx5e_accel_fs_tcp_destroy(priv->fs);
	}

out_unlock:
	mutex_unlock(&priv->state_lock);
	return err;
