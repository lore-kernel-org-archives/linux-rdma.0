Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93448343D75;
	Sun, 11 Oct 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791744873; cv=fail; b=ExlRp6QANPzEQDebFtZeu9B7XcFCtqvx63EC2kYq6yVGL0iC/Y/MK390EWiSHcDRzQFwPGWpBqsQgjhkTryqulgJ9KaH1o6MBCVXvO6ujLrHDFh10IxsZBbNWJMx+wNR6CuVN2bdZDcFlasc4cjvWR4NbAMxH9N7WJrq1Su7Kzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791744873; c=relaxed/simple;
	bh=A2rpVyF+cgFitZPsKoI4xmrcVypaPSSiwnn0az0N31o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D77hhBdHaGfw4nTfS3jGo+JlQbRQpV3srGgUUXuaLqvTe1Xp1/VLGSV6iJmuI3KJN+GDjCtQRDpxbUsuzw2P2ZAHTm0WIdc48Alyncq1qSbV3p41DMHSjaxXNxcZuehMAOu1dlS1vk8sPsqaktmBJFZCRoWdNNasWEa3zMU9R1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HMB2Z+qn; arc=fail smtp.client-ip=52.101.56.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HMB2Z+qn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiMGVqCeC4EdC+YZu8SdNkcn8hDUBAXnZST8afmn07M9vMZ44LWqS/4pHfSQ1J7zCaieT0flD9p7Oh9o2RdRV3ZjA3wwZMNnh/2d8dCLggqDoJ0H0tmhYj+Ys62PTL7XsXEqIx2QGZM6Bnoltaip8jIQHw3tPo8IepGm9SYjvC3A8MKHKKMo70x3F5p9Bh7DVlSCam9dZ/jwSx/sQhDqDCfecJrH2UHIxJAWqRvERMMQzwvd5U0r58UMWS83s3nxdFyOi7DZc+qgbHI9xApLtJ0pNNcunR/GV5tbmFjnWEurTuKzZSvN3AlnU9+5nVK3Z4GTB8dAiN3KFkTY9C4ovg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebIpzzBixlv2iQHmSUZX9IUXwHl9fGWWFjnRGfTI7Os=;
 b=RQYhwG9ShWXos4gNVSsRQUBUQ2OMD+wxolzPlynWAAA5TA9j2zYiwSDUKe2ZoePxr0vZjpdfwqk5dKYgqJP4Ss8PfgMFjGhBxH6mpgSVSAeTKJaMsH8Np1Z5iAgdnDEwXOW7+4Dd51K0Rhu1bAWD7VoGvLdlqpvy1XS4cafvKQhxZRqUAw06pV/YYwPDpIcSuho641qQoOct9XXG0Bw7GmXQlABLCL0dSEe0lIebsz8N8GNiMTgtUQG4i0cLHBRCMQBQyWC1BaD0zqKIzYyBjMJZho82mSGZxls9+R/Q/523612WBRv++XY+sbyDwka+MeEYgV2t/B05vjTD/ieCiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebIpzzBixlv2iQHmSUZX9IUXwHl9fGWWFjnRGfTI7Os=;
 b=HMB2Z+qnaGI9pB64L4YdTBPdf7WXQtHunF624j5Fy+fSMzfgcf0tvgD0FENbwLCUU0VHTRMwJaqOh2ete4VQXAqr7mQBiyWJT6WB7WbBivCxdK91pLS+ncg7KEXm+9xZJNgkFU7NxHZVskTqKl4ZMuO9YOpd4hsEWT4yHK7udCH7OkzohB8wUhgKnIjMi8ok0l58cqGU0MnB9XYiN3tZQra4c7nbrKvgp4fn+thYlngiXQFhQmNTRJ7rN2K8jI8Og8CVgeJTQqvSQqJxv9752R4xciqoAYxU4P/dEEjsX0Sd/ojJF47Erlw4w5ooh3tL4VO13te6zIbAu2Vp6cbaFQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by SJ2PR12MB8157.namprd12.prod.outlook.com (2603:10b6:a03:4fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.20; Sun, 11 Oct
 2026 18:54:26 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0496.020; Sun, 11 Oct 2026
 18:54:26 +0000
Message-ID: <0b9f409a-4281-4e94-87b2-66e57ae751a0@nvidia.com>
Date: Sun, 11 Oct 2026 20:54:19 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net-next 00/10] net/mlx5e: Add netdev support for data
 direct
To: Mina Almasry <almasrymina@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Byungchul Park <byungchul@sk.com>, Carolina Jubran <cjubran@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Saeed Mahameed
 <saeedm@nvidia.com>, Shivaji Kant <shivajikant@google.com>,
 Simon Horman <horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>,
 Yue Haibing <yuehaibing@huawei.com>
References: <20261008132815.654147-1-tariqt@nvidia.com>
 <CAHS8izNSo4YzXxD3C6c2HohdOfH2GK1M=51biuevLUk3vz5k4g@mail.gmail.com>
 <CAHS8izMKNeEmJM0wOgtoz9_3WRLUOqP0PEDMn5SZ+hXTKTwSyw@mail.gmail.com>
 <7a0bff03-2a7d-4819-b96e-a5ad8a5f6bf6@nvidia.com>
 <CAHS8izOPRjO54w0ehXCXahn3LPD7uqyJYX=zBeDDYG91Sm+DXw@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAHS8izOPRjO54w0ehXCXahn3LPD7uqyJYX=zBeDDYG91Sm+DXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0370.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::16) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|SJ2PR12MB8157:EE_
X-MS-Office365-Filtering-Correlation-Id: fb3fafd7-14ed-4b69-7265-08df27c9123e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|6133799003|18002099003|22082099003|10067099003|3023799007|11063799006|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Jqq9+4TZi97ApYgm67DkniUajwgLw2BRgK4S66A1t2hrnkpoSuXw6JXXep+OYPRPcpOlL/ejzha4/+K05vhn082MoL8wILpFxNM1Orfhoz/5SBh9aBbhyM9YqfsZQKkjXkehNfvc7W17rE91nQxY7Y+54KliRlrB0WTqKc2vLlji9PiTpH1n34J2GUd7HBlmOWpsufJMf7RLJvtjhzIFfPrPJY8ab1kICJ72WGHtSX1ontGLHrJ9js2fhtRvhFq0Z9djb/Wx4pu3WFVnWPebPNV3kJCFCz1sEYxXO2G28xGyc2xi0ktzWQi/rUxKExIucQALYY6J09sWkfpkV3o4d0227kqy93pu7UfWT7qFDaO+zM2m3OX/pOHeYTGA7JIoxbXwTFwYfnXnzuSad8PGliDGSvAXx9GVq3Y3wjTKwiOTINBVVCM1kwgszlZPsrv1XIwjAXV+6fBQu7NOn4PP92dzozNRCNUIRfOlWOBeUsDQvR3rt/fb3D6L1uCUyB0ntZDahts4bxmcDWea5NEKN/9Vx45HXPqRGQ27axIXRGz+FuvVbAMdQu7uYHimWCcmvkZlOVLsURnjCO/fUaboXHRjZT/cbI0OqN68vi9IkO0NJgD9KDIj98EpNP6DJRI6XWOgdzSFOMbaE/LF7iO9kx/+VbZNSLvwxlLbjlRJ92U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(6133799003)(18002099003)(22082099003)(10067099003)(3023799007)(11063799006)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGlONDlyK242b0xqMUowa3p3WUI2YUYvY3ZIZTRVTGhTRTQ0QXBDYTZ2VWZO?=
 =?utf-8?B?ZWMxYVhBdHAwczFnb0xadkFEd2ZjTWRHelMxZXdiU1BTa2grelQyYi9BMXJv?=
 =?utf-8?B?aUJTMlRHRHlmZEJUVjlzZW9Md1FJQzhqVERhVTBwTkR6V1EyVWN5VEttTUYy?=
 =?utf-8?B?Q0oyK0lDMmlpQnJ3VDk4YzR3ejhFUEtkVHJMeHU1bWhNZDRTeDFCZHQrTUtw?=
 =?utf-8?B?ZVdBc2FUUng4U2g2Wmo2NEpNSyswUzJDbnFxRjk1R2IyVy9JYU9hNUNLWXQ0?=
 =?utf-8?B?VnNIejZEcjRDd0Z2M0lGL2E5OFhYRUlRUHlKV3BwOGo1bVpQU2RQbDgzYnI0?=
 =?utf-8?B?Q3U1R0NBK0R3cFh1aHkwVlBhTW5vcGttcnlkVkJmSDRKVFFUZHBwcjNNUnM3?=
 =?utf-8?B?UnB5M2JqR2poUUJETTROSFBpU1QxRURtRHVyNjZOQ0VEWkFoOTlTZ21UcDhN?=
 =?utf-8?B?a05YTTZWbFN5ZWc2VVZ4L05oeXIrQ0JSQWh6YWN3MVlEYytxLy9LdDNsSklH?=
 =?utf-8?B?RE01ZGJ5dFVmWTJSaTcyRVZRREtJU0V5d3I2T3pMdUpLbGg2d1d1dFhJditD?=
 =?utf-8?B?aEhyc0ZNQmVZZjllRnFuak43WkV2eHMzU3JOeWxFR2J4bUtHK2oxR2hoSjhp?=
 =?utf-8?B?OExQSStVNHl5ejhVOXRnOTJ0M0wwTDJHQ1B2cjVUQ3NjdDlDN0I2MHQrdm1U?=
 =?utf-8?B?NVJlU0Z2dU5VNHhxa1NLY0JFbnBUTkx0WUcwcHl1cGpOcjlKOElwU3hLMmg0?=
 =?utf-8?B?WFZoUGthNFc0NGFaZ000Zi90enhhazVxY3F0L3gwMnc1VXlFaS93QnB4Ujl0?=
 =?utf-8?B?Qm1ZaFUrbTlPNEdEZ1JjUndmNGY4SzJHakNMbnAzS0FCeE83SGh1Y2c1VTVw?=
 =?utf-8?B?MnNaTUtoT2RaWnIzR3lrUktpdmZFenFzbzUvWkRVSytPdVdtM09HWlhsL2pO?=
 =?utf-8?B?TklTc2dHMkpFb2pCeVZsQTdJSzdWWm1sbjlWd01qNDVVaXVUTjdkLzIvRzBL?=
 =?utf-8?B?NFVKZ0tNS0xqS2NmUWpCZjFoY2YwclArVVd3MjM1c2xEQ1ZQaUxsN1pMSDN4?=
 =?utf-8?B?dTJTcFUyU3U5YTFFZDh6emZCampLdnlvT3J3bzVCMnU2SnlHUDJEQS9rcjlP?=
 =?utf-8?B?bXRQQjljYWMzQ1ZPMEM1T1Z5OWZXc3crZFB0WWk2M3NMV1BlQVpjZGExVWFE?=
 =?utf-8?B?MzZzR1hMODl0ZTIyQ3U5V0FlbXJNY2hlZ3RLVy9LNktpd3RDYXJ1MGRLcEp2?=
 =?utf-8?B?NW5jUUkxMVZ4cDRXdlYrVDJSK1p4c1grV1BDekxnYTRWeXp2ZDlYQmx4TFY0?=
 =?utf-8?B?UXRoOVdoL2NSZkNxWTVRdGtDQ3U0NExFTkVqNmJ2NldRMjFEbUI5a1hyeXNy?=
 =?utf-8?B?ZHZVRFQxakNBRi9iTmRXWExuVGpQMVRWZk1QVFJsdGd1SENuSU9iRTlLWWZi?=
 =?utf-8?B?bkpoZzRkTGxhYTEvbnJqaGR0eUVwUDBoUHpmNU5pOW4zN3lDMGs2WmVJMEkx?=
 =?utf-8?B?YmpUSlBXQi9EU2p6NWNxbHdZeVpockRsL1psUk9oMnZDc0pHS0VhZE1GRmF5?=
 =?utf-8?B?V29pY0pUNWFlU0U4VkhRTEEyaWRkSHkvZ1BxVnpvZnBEVFhvcndTdmEzTmFq?=
 =?utf-8?B?andjblhjQkpwbmlBcVpZd3FSRkdhZkx4NnUySmFYVmsrNHdQRllZK1VxWkVm?=
 =?utf-8?B?L0FZWkhCMzR5ZU9jSDhkejZsanI2d3Z6SzhGdnpiT3Jxd3hlelFpQ2d4L1Yw?=
 =?utf-8?B?bUR6NXNabGtKdXN4YXZsY2NGckR3MFVJRktLRFEwLzNEdTlNcnhNTEFIb00v?=
 =?utf-8?B?VytnQTVUZnVnMllMampoOHBJTzZ2cWhkK1ZTbzk2TW1CT1F2Y2tGbytxRkow?=
 =?utf-8?B?Wjcyd1B2UkN3cWUzS29lY21Pcm93dFExY3Z0OHJJOStuSnZaY3lYQ0FwRlRN?=
 =?utf-8?B?dHU3SDVMejJnYmhwa0k3RE9ReUg1a2dGa2lJdGl5bHNjQWFjUGVSVHRFVG9E?=
 =?utf-8?B?ZVp1bW1OeEtRb1VYaFM0eDhIdk5WK0NkLzI0b1NVUUJTakNpbEcrOGZUWE9h?=
 =?utf-8?B?Yjk2ZE4rRGdzaGlFbUN6c0puZmpJZi9QTFBzb3NheGVpMGhXdk1tbkFVM002?=
 =?utf-8?B?Y3YyZmpUaVlDOFZsLzFKVlRUV2JnZ1ZaVzVDSnZrYlJCdnB6aDJNRXhlRVA2?=
 =?utf-8?B?YWNEODF5cFVBbWZoZ2U2RHRLZmdyelV6NGpianJDSHA4QWdhbjAxRFF6cHQ0?=
 =?utf-8?B?QWMveCt1ZlVid2JWRkhES3Rkb2FXYVZrMUpucFA4WE43bWp3NC9tUEVMS1lP?=
 =?utf-8?B?Wnpvck1SR3h1TTk0RDVrRnhoaVV6RENKZVNhSGVSeFNFNGdHeFJxQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3fafd7-14ed-4b69-7265-08df27c9123e
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 18:54:26.0697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COoRIo1lJLJ+IupuV7p2b/yoMri1OaW2yRUFGD2j395K+BavySc155kVphiXLHqRWwY8Mutdwh2bm9ZfVSbM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8157



On 11.10.26 18:25, Mina Almasry wrote:
> On Sat, Oct 10, 2026 at 7:16 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
>>
>>
>>
>> On 10.10.26 01:54, Mina Almasry wrote:
>>> On Fri, Oct 9, 2026 at 9:42 AM Mina Almasry <almasrymina@google.com> wrote:
>>>>
>>>> On Thu, Oct 8, 2026 at 6:28 AM Tariq Toukan <tariqt@nvidia.com> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> This patch series by Dragos adds data direct support for netdev devices,
>>>>> allowing a mlx5 netdev to issue DMA commands through multiple paths.
>>>>> This feature is critical for improving performance and reaching line
>>>>> rate in certain environments where issuing PCI transactions over one
>>>>> path may be significantly faster than over another. These differences
>>>>> can arise from various PCI generations in the system or the specific
>>>>> system topology.
>>>>>
>>>>> Data direct for netdev will work with devmem by returning the data
>>>>> direct DMA device instead of the DMA device of the NIC. Each PF netdev
>>>>> registers its own data direct device and support for RX and TX datapath
>>>>> is added. The feature is selected through a new data direct priv flag.
>>>>>
>>>>> The feature is enabled though a ethtool private flag. When this flag
>>>>> is enabled, the driver will return the data direct device in the
>>>>> ndo_queue_get_dma_dev op.
>>>>>
>>>>> During data_direct device unbind, a re-creation of the channels is
>>>>> triggered.
>>>>>
>>>>> A note about the unbind: it does not does not tear down dmabuf bindings
>>>>> attached to the data direct device; the recreated channels will still
>>>>> pick up the binding via rxq->mp_params and post DMA addresses from the
>>>>> data direct IOMMU domain to the PF, causing IOMMU faults. A devmem
>>>>> revoke hook is needed to close those bindings before the switch. This is
>>>>> out of scope for this series.
>>>>>
>>>>
>>>> Elaborate on this please. Are you referring to the fact that on
>>>> page_pool_scrub we unmap the netmems dma-mapped by the page-pool, but
>>>> we don't unmap the netmems dma-mapped by the memory provider?
>>>>
>>>> What's the impact of leaving this unfixed? Is the machine going to
>>>> crash if the device goes away but we don't unmap the dmabuf?
>>>
>> IOMMU faults because the dma device is invalid. Either because the
>> DD dev is still in use and was unbound. Or because the non-DD
>> one is used and is invalid (due to channel reopen).
>>
>>> Oh, you're referring to an even different bug than the one I had in
>>> mind. (I'll see if I can submit a fix for the bug I had in mind).
>>>
>>> But in general I think not addressing the issue you're referring to is
>>> way too messy. I think we do indeed need to unbind the dma-buf if the
>>> dma-dev is going away. The invariant should be that the
>>> binding->attachment->dev should not change at all during the entire
>>> lifetime of the binding. We already 'revoke' the dma-buf binding if
>>> the netdev is going away, sorta (there is a bug there I need to fix.
>>> The uninstall function in the provider doesn't actually unmap the
>>> dma-buf :sad face:).
>>>
>>> I've worked with my LLM to suggest some changes that (we think) make
>>> this work, but you may disagree. I'll post the suggestions. But please
>>> I think this should be handled one way or another.
>>>
>> My idea was to handle the unbind part in a subsequent series because
>> it probably needs some more back and forth to get this cleanup path
>> right.
>>
>> If not acceptable I'll work on adding it to this series.
>>
> 
> Since these are mostly driver-local changes I don't want to be so
> forceful to block it by saying it's unacceptable, but if at all
> possible lets try not to exacerbate the current mess. It looks like we
> already a bunch of lifetime bugs with regards to the device going
> away. I've posted this series, which - I think - gives you the devmem
> 'revoke' mechanism that you want:
> 
> https://lore.kernel.org/netdev/20261010025532.839559-1-almasrymina@google.com/
> 
> Also working on that, I realized we don't use binding->vdev and
> binding->dev correctly on binding rx. binding->vdev is meant to be the
> device we do the bind to, and binding->dev is meant to be the
> underlying dma_device (if they're different). That fits into your
> model where you have the netdev you want to bind to, but have an
> underlying device that you want to dma-map to.
> 
> I've gotten some feedback on my series and I'm working on v2. If it
> makes sense for you to wait on my devmem core changes so you can
> integrate into them better and avoid these lifetime bugs, lets do
> that.
> 

Thanks for your patches Mina! This made it easier to implement the
unbind. I will add a dependency in the series to your patches. That's
if they don't get merged before.

Thanks,
Dragos
