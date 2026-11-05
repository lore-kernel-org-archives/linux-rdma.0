Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793873159;
	b=ExYGL7gTZjExZmEoIpPJmz3iu3BCNMp/U/glD/jMKDNOxkQatJZEUqwJERlghvZ0neYH
	 UHnJ0AO89lHjs3LSP0Wn0Uc0fnT06Rti0XirfJqPwKBeg3ML9ZJXvvdtmYUKC5k/BeV8W
	 UkS+rmWdzMwt09tSDCuk+CQEIyy13pl4VsWz6V5CVOwovMlnhNxNrHxWPpeQMQx7KjBDf
	 /roNpVnAL9BsmrO4xIx80R4qj/wxpzZFiu3BJkjgPgRaz/xuyEcwJpIRCtZJOwoxeTdF7
	 UIF6mlbyHqPYnOPwg4ACeW7hWryKB5I+p8bcZrsULovOy+Wi2l15uVxH+fGAXfn9Kcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873159;
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
	bh=YaMA+9QcOz8IOBAL6yfJDI+7D/mu2twW0lAxe70wvPg=;
	b=mJ8rMQ4rwgEGldULp+yfwcwHYAhts9TBqo1oO9VaEtAz42dSewgVHMv+rXp3z3n2ndJB
	 LVmRkIdHmRjFSXWlYbjnp0aQsmxhDCZMF5gBeOr8Eeue5XxojBSZuY1h5hF+xCCjyanzG
	 SvsU+q52+qeXn/v8z1JUhxQhJFB9eoabilxicG5VmmsBtZylQXt968bfRyIR2M3Ta2IwH
	 IV5M3ObDPdzkdUQv/MviioqvYCJJS7Zjem9Zih+0fWu/FXva08e6pZ1HAV4Zg8r77rDjZ
	 loVCgPLPe4E25efhJFj3eDvdmG4VTkPxzro0TY5gU21pn9hBe2mX5Oc7fNV2F165eYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HvLV4KdX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.42
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010042.outbound.protection.outlook.com [52.101.193.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F53A606D807;
	Thu,  5 Nov 2026 10:05:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F53A606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HvLV4KdX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FXCKDJN58NrFUXYry81c3fO1sv4qY69Hi5tc19Xqyg+1odWXI1hYaYDnbI/lY6q2SwZz+b674+f+cQn6k1d03sPPuoFswcBM/yV4EWdJEyKtmVOVjNYp28rAz1+F8yttC8ry/Uvck3nDE40DHJWLhxRpyt+ZpQB5vvJ1gWeQP7L5eK9z2Jdn4zQSbdS5m8EHIbjP1wYoKyZMwuInuNzSQ0ffzjEA8sFICdqbFdXOn68eA0/RoSmoy05IQ3yc+tVor2mrWDC5Qwz/No4IGiDOK/XUm80adBBujtqO6xmtuwJ6X9Qt0SXRmqT053AGTsgcBftCDuEE2v5G7mExBGS+Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaMA+9QcOz8IOBAL6yfJDI+7D/mu2twW0lAxe70wvPg=;
 b=MDYNlucGGxSVelqTSClfhta2jJvG6oNOFXIcTkYS0g2PBKSCIv6v+kjrOGhRBQooy13bDiwSa1L/GJGMNM6rmlZEkLShncOMTRKQAmaJhRv2DJLnZuTpx4XsBPQeHiFDjnK08IRKBCop2vVPBRy6mVYDXziktCa5gVGw5h/A5JYrAEGfdKB/wXTIw/NH5uni2tPwvxv6eSXaqVFwS6IW/341XpX9Dd2dG6PxTZhQKYVfEATYhIG0UCKGfy1HT4Dz3miw0esMzvsSM2odpELpOvRWhgVkoU5QKia1PXp7cwPCr/Uzzc5msLZTbqpxi+7vGJJEmvIO+t3HdK94e8tRqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaMA+9QcOz8IOBAL6yfJDI+7D/mu2twW0lAxe70wvPg=;
 b=HvLV4KdXdqWoil18tVLIiMcY2WDwYuu5HGXu/M87+vVksBExQeRULwtoMX3VBZ6dNEnzfhgyAmPz7PD7tkKwkYw4o1wXQCWQvDHWSkqzYUXwk/gdbRA/83OY9rh0Ws5A8/4l2yHbcAlassdNxU4JoK9Sh1MJlF5QJOhL09HXU7EG5pv6QXZvKmII6bf5lQJZ6JIRR7i9EVyg4jiqYUMZ7+m45uO5Oktj2Qimr9luhIqsR1iGRw33pXKM1ukaYoQFUW6FNshsZfyyAXcsA0AQP7qOEWIxT+h/VyvbYfT2VazSum5M3nt+cj8Y9kyoQGw6z9Q7rLVGiipVw63mhKHp/A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 10:05:52 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 10:05:52 +0000
Message-ID: <4b02dc55-7362-438c-9595-19818a60cbf4@nvidia.com>
Date: Thu, 5 Nov 2026 12:05:47 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Free software WCs left on wc_list at
 CQ destroy
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
 Haggai Eran <haggaie@mellanox.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>
References: <20261103-free-sw-wcs-v1-1-3885ce449012@nvidia.com>
 <20261104140106.GE478286@unreal>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <20261104140106.GE478286@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::15) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: a1d89ab2-7f4a-4c57-bd56-08df3b245fea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|11063799006|4143699003|5023799004|56012099006|261022075727099003|261021123027099003|261102124527099003|261021121427099003|261009223027099003|261022105027099003|261102123227099003|261026140227099003|261028144727099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gqJQcwJWk2YlV0nxII1LL5JcBkpCjSObgl2kdODHmR4FdA8UgOw0+BTvlSQTkd3Hz+RgFj8uEaq0W3nR6ldjw3A396OIfLS9rDMC19HR2jgKzcVNB6MiHr6ALizQJUScPL7n0p6IOsm56qjgADehnPqkp2Ggs1joav8xaxEa9TVAo1vV2aOyVph869JJ3XKgv6o+/AmWBKX8Z/T/Y6tnGLwTFB9DFjy/tk4fVi+g71VKeyV2uiHZf2rfneCOar02NetCB987NdqtLtEmIXbYJlnKHm7Xkrkd0oBTCpOeu/2by2oy4x/Nd2qUXSWOa6spCO5DrdKVcPhL5M/kLblxpjsSiwBB/eqMl2wVDr51/sj9gW507Jt8biyGZI8owUdZchcvclsPLH/14jdAYytKMoTB1bvqxJc4XyvzM2IsZFz1BUyK+IO15w8NkC9Hhx5KqsH0IonN/6e6/dVkQQ71nJ/dg3z1IZPQ2Hn1nwSRHsujHEl1tiDwwuAyq8LEHXFJpdyrTGgWZ/olRhkQuYdwrQA/5uVLlrmI8ZxbCi0YhLiroupdcP933g3CwIehT1QIsF0XCUkDeJFJKE5m7zqrFEtIPkJvVHZYNBKD+7LyLBaoNhrhOvJ82vw+Y1unXciyRm+Zm5q5i3ZsiyXLv75WBkEUwFgTj7Fz7t8DO6O7zo8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(11063799006)(4143699003)(5023799004)(56012099006)(261022075727099003)(261021123027099003)(261102124527099003)(261021121427099003)(261009223027099003)(261022105027099003)(261102123227099003)(261026140227099003)(261028144727099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVhSV3RvODVoV1RPOE43c05ZNzRrNTk0VDRDSGZEc1FHSWtQbE5LZUZ6TzJn?=
 =?utf-8?B?MjNNVk9ISmwxNUFnLzJEZDFVbVNrcENPTGJGU2RVSWJOcVBaSTJMVkw1TnNa?=
 =?utf-8?B?dGhYV0htRTNFQnh3T1pycTM3UDNZOXRUUXZqRXMzbjZ0K0tMcmxCbHk2NVVu?=
 =?utf-8?B?M0s1cm9WR0NRTTVsejBpNVJ5SE9pUjduVFJnN0o2TkJyUzBGSkQ2djVCYzdL?=
 =?utf-8?B?OFRQTjFQTU1iQ1RRTGRDUC8wYUNjVkRVTFlOMUJZV2w4eVVFQUUvcDdrckNX?=
 =?utf-8?B?Q0tXM0Q3WDllOGZSa0RLUnZZOE53MW1KYU1PVkhoWUcxMlN1Y0FpZEF1T2xq?=
 =?utf-8?B?SUVvQ2NkTGw2Tm9KblJVUFlPQUN6eS9QbTZxaHRXdGJLZHpWVnZsZnRmRjhU?=
 =?utf-8?B?dkk3MHlhUm9DWWozcEhud0J4OHBLM0ZORUowcy9kTkdVT1F0d2RXMDA3WXFQ?=
 =?utf-8?B?ZnU4MTF5UGhuSHJZbTR3dXROWFc3U1N3OTlPbSs0dzFMVmlNUVNmbk1zRkdG?=
 =?utf-8?B?WEZQTGZ1WHFlalNrT1R6MGFqaDhMNGVtVU9ydS80SVZHVFJKdndlRDgzOEcw?=
 =?utf-8?B?MnBqdUZSYXM4Q2ZnRjJYaDNEdEZEUmFKWEhTZ0hNb0tZUndBMkdQRUh5TjBC?=
 =?utf-8?B?RmprcFZCZFlRZkt3TEdGMFRYeGFsYmRraHljbUluVGRuL1hzb2hNRGkzTHQ5?=
 =?utf-8?B?UFl0ZFJZR3dNUzhTWnhuNUNJN2xPY1FFWFl4OXVrcWY4S3Z3ZzdlNFBsNmZk?=
 =?utf-8?B?VGJRMDdqMG9FSldaR2dxZWpIc0czR1V2Y1RWczAyVlF4KytvUlV5em5wNW8z?=
 =?utf-8?B?aFMyTUdZN3lETFdSd2VUNmVCeTREZU1VQ0kybEcyS01LQ1dpcjBPY08xM2la?=
 =?utf-8?B?WEpIWTl6OXU2Z001SC9pYUNHWTdrblV3Zy94eXc1d0k0QjI2TVA4Uk9HOXFQ?=
 =?utf-8?B?czRtcHNSK3BRQWpMbHpPeFlIZ1Ixc2g0TmM3c1ZIb3lzek9FSzltNFdubUpE?=
 =?utf-8?B?ZHIxNjJ5aDBvak9BQjdGRFlMaitqN1k1NnRFdndzc01FNHFCU2ZOQzhpR2gw?=
 =?utf-8?B?aXVOd0sxdEhNMkNnS3pjdVZDNXp1U2Q3WUpKcVUxU0RBbU9kcUNhcFBYVTBC?=
 =?utf-8?B?T0U4OEZWekNURTQ5SkJtRFdmRS9LejlaeWR2MWlGSkQwNVlCNlFZYjFpWGFS?=
 =?utf-8?B?Um0yeDVnTW9kMUgvZ3pEVitsRTVZbjhSY3hSM2dQMEFCa3hEcmp0MnJ5M05D?=
 =?utf-8?B?ejJvQkIyVzdvWVEwRXptcDVyZjN2MmZGS2x4WnlNM1FjL1RPSStraER4L3do?=
 =?utf-8?B?UzAxVWRlTkU4NjNSMnlKZUdibzJIY1k3SCs4VHNyV0U1N3daQW85b1V0RUJ6?=
 =?utf-8?B?c2Zick84aUlqTkRpQlRnVUhEMHF4YVdQZ0NvUUZ5ZnFDVWx6a0xyNjFETmZB?=
 =?utf-8?B?dGtlZmF6bmVZSTh4QWdTL3RSdjV0S2g3alRmSDhXMDFsNG1EdWhVdHpKV3cr?=
 =?utf-8?B?am5Xc0RtTERoeW9jR3BoR1Y5dFJlZDY2VUdFUTdaVlNib2VFcXMvR2ZhUURp?=
 =?utf-8?B?MytuQjJVRzlDeHV2SmVJRUREQkY4TmdDRHpTcytEVklhWFlabDgraklpMmsz?=
 =?utf-8?B?OTBsa1JmWDdYVStmbFZIQnRtMEl4eVBlYkt3UzJxc0JvZmhlV1lnUjhqdU4z?=
 =?utf-8?B?MktUakp2UUluS0ltdUoraityWDU1YnAzdm1Nd0ZQbTJHTjNONDJYMTFZYjVv?=
 =?utf-8?B?enhmdHZlNVpXVktQdElaeWhSS09ldW1NWFZYNFNjYkNnUkljeFR6Tzc2azRE?=
 =?utf-8?B?NHd6ZzVBVXZYTmI3OGZlV1hEZWlSMkVWNnFOcCs0bVF5TzlYbVN1YklDM2lo?=
 =?utf-8?B?TmkzVyt3VlFHZVZDNFcvbHJUT2piNllzUmxBN2FCSUNSc3ltZ0M1NnNteitm?=
 =?utf-8?B?ck03MTEwZk54R1JvTWhEQUlmQ3MwODNsU2o0MlpJQlZtTnVKZENCVHQrZmg3?=
 =?utf-8?B?SXRjWXB0ZkQwejBtSS80SG9QRlZTVStMQUdTdUJmNGVRS2hieTd0S013UUt1?=
 =?utf-8?B?VEV0TVhwMkdpZVhXVHFyL3ExMTZWYW80V20zeEpaVGpGNGQ4Z3MrWVdjdXNp?=
 =?utf-8?B?aW5YTFdWZEVpb3I0M3dYUWt0MlJWdnFtdm1qNVVxYVFkYXBFaHZUQ3BQK3V4?=
 =?utf-8?B?UzNZdlZia1FLRjBsQnBWYlFvTEljQlM4dFA3YUxNUDZGZmpkeGRldFhoSFIy?=
 =?utf-8?B?M2Vxak9zUFlxZlo5Tmxmdm5NRFFCNGRvSXNBQlMrV1RxdlJ5RGJXWHI4Q2I4?=
 =?utf-8?B?N0xsL1Y5TDF3YXJVWlhVaFQ3dUdpVEdOTi9iM0twekFHUFZIUFNNdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d89ab2-7f4a-4c57-bd56-08df3b245fea
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 10:05:52.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DARL6XHklTvdVpg8loi9wRQkD9sVvBK/NGnqrC1OeEW+sWPOKf2bu79+DFBWdWiSO6Wdb0sEL6QETFO3NHwEQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177



On 11/4/2026 4:01 PM, Leon Romanovsky wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Tue, Nov 03, 2026 at 06:55:19PM +0200, Edward Srouji wrote:
>> Software WCs generated by mlx5_ib_generate_wc() are allocated one at a
>> time and linked onto cq->wc_list. The only thing that ever frees them is
>> poll_soft_wc(), i.e. a consumer actually reaping them. If the CQ is
>> destroyed while entries are still linked, those allocations are leaked.
> 
> Is this real issue? Just put WARN_ON(!list_empty(...)) instead.
> 
> Thanks

Yes, it's a real issue reachable on a normal device removal.
E.g. ib_mad destroys the GSI QP and frees the CQ without polling it 
(while it may have unpolled completions).
I'd say that this is a complementary fix to 
https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
Before it, a pending notify_work still ran and polled from freed memory, 
which was the UAF it fixed.

> 
>>
>> Drain the list in destroy_cq_kernel(). Nothing can be walking wc_list by
>> then: the poll context is the only walker, notify_work the only thing
>> that can re-arm it, and both are stopped before post_destroy_cq() runs.
>>
>> destroy_cq_kernel() is also the error unwind for mlx5_ib_create_cq(), so
>> move the INIT_LIST_HEAD() of wc_list up next to the other list
>> initialisations, ahead of anything that can jump to err_cqb.  The driver
>> object is zero-allocated, and list_for_each_entry_safe() evaluates the
>> next linkage before testing the loop condition, so draining a wc_list
>> that is still all zeroes would oops.
>>
>> Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
>> Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
>> Signed-off-by: Edward Srouji <edwards@nvidia.com>
>> ---
>>   drivers/infiniband/hw/mlx5/cq.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 55ffd7d4de517e6ce3f04c98b4edcd94b12e43b3..2f7ac350c3d8f179ad1d4d8c1181b93f3151c7ce 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -933,8 +933,19 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
>>        return err;
>>   }
>>
>> +static void drain_soft_wc(struct mlx5_ib_cq *cq)
>> +{
>> +     struct mlx5_ib_wc *soft_wc, *next;
>> +
>> +     list_for_each_entry_safe(soft_wc, next, &cq->wc_list, list) {
>> +             list_del(&soft_wc->list);
>> +             kfree(soft_wc);
>> +     }
>> +}
>> +
>>   static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
>>   {
>> +     drain_soft_wc(cq);
>>        free_cq_buf(dev, &cq->buf);
>>        mlx5_db_free(dev->mdev, &cq->db);
>>   }
>> @@ -1067,6 +1078,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>        spin_lock_init(&cq->lock);
>>        INIT_LIST_HEAD(&cq->list_send_qp);
>>        INIT_LIST_HEAD(&cq->list_recv_qp);
>> +     INIT_LIST_HEAD(&cq->wc_list);
>>
>>        cqe_size = cache_line_size() == 128 ? 128 : 64;
>>        err = create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index,
>> @@ -1102,7 +1114,6 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>        mlx5_ib_dbg(dev, "cqn 0x%x\n", cq->mcq.cqn);
>>        cq->mcq.event = mlx5_ib_cq_event;
>>
>> -     INIT_LIST_HEAD(&cq->wc_list);
>>        kvfree(cqb);
>>        return 0;
>>
>>
>> ---
>> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
>> change-id: 20261103-free-sw-wcs-8cf40aa66fd8
>>
>> Best regards,
>> --
>> Edward Srouji <edwards@nvidia.com>
>>

