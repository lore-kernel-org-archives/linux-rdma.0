Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011048.outbound.protection.outlook.com [52.101.57.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470EE501F49;
	Wed, 14 Oct 2026 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982924; cv=fail; b=tlfpwV2w3plo40Zb77RSwTjAhm/9anW3FP0xQGwASSPeO9jUASQ12IKLyOR/dD9GPWAPTIM3iancvacKSrLnCMr2uSWzNcRssDVniITwZwz/+K/JI0CeBiqrVGbgrszESyLqH4FtVu8q29n5Wmoby11gDjM2nPdTqWLkhqiLgvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982924; c=relaxed/simple;
	bh=a7fWveJ6cadF83/0mF7fsJkaRy9vEs/7lT08D3DnAk8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YX264lDxyNxIs7OzMk7CMOLs+IqNTl8QkRxzmMEkQrudHkPJY3uaVRVxLiwAmom1eI1m1Q1e16YLbpZCLSYRY5u1onKpucw+jLX4Wb725iTmNEgi9kc4mgdyaDv30xfsakhe4zUCsuh0tvI50Hw81F7OzPGGPylqQIDnpmpIsf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ifYnr8Gl; arc=fail smtp.client-ip=52.101.57.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ifYnr8Gl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U41bSPqfuZSNZCd5o3oCGcx8Kq+FERpGxgW8/P4HDR1oTngH9/KtqIio2FVwyChWAvxxSex3BQqkzl1rLcn2ExHjSEzY29ZowqwoHNbD8Wu5CjG+uuBw7e1bWrxvHX5Gc99Ulz7RdWWMvlI5G4buVG2ROPaPGSmKPef6kYTWRT6kTMQGnR9Z1JjAe4eQ6eVsr/pLh5XizVnbys91a7Gd4DC++iiwp2JpUJg1v190J4FnE52M7QIHRHr2odpT3xM9cAzfHPnMFO+Di2MiTbcacoLJr45q3F6sqy/I3wBI0B2FflHFUDhhP0uEsuEnuziYV+e6olrPeu6io89oJC0ADQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2pPw4jHBAYxIHXt5cH0PTu5FqsZmYCUuElLy7h1u8E=;
 b=R3YX9DXcnPMAh5JJ0TiokYLiQNljcM3bMlNbyXDycorGDtWnv9l6vYtkPV8iebBY57Rvz5t7IeFDqQ5JW97IAzhkohOf9w+BmZN3aWrFcBY2+SrPpTERppIXQ0qLHj3UsOGm3bC/Jj90YKgdWutowqN6aMkSZXe5ql5RsN6ispeNNHo7Sav0I9NCkhlC3n+/lBZkXUZP+zlOOUWFnPaZAXpJ692gG2KQJoFROixrW9l6mgfxFNN5/XH8AtqC0tkSd19QkM0L6eT77KTfPYWzk7T4lQ1TAir4fyJiCtO66oVzlv/VK0+TMCSVS2Q5vB0QdtnijJaQQ4ZnOY0FpR4tNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2pPw4jHBAYxIHXt5cH0PTu5FqsZmYCUuElLy7h1u8E=;
 b=ifYnr8Gln+V9jDa96sKlZLXEteoV2XTfAA8l5TACf1WjH2aD9NGZDj0NULsRXF6nW+hCskLh2fIT2Vm75+zA3UYziZzX9vTLzsTw8S8kJm2uTtA0mCkDO0i5R5M81tzefjFx4gBE1baPDwe53pBl4foVesS1N3FuzG/dthMEZQZOJN0HSIs3uPROuBDb011GX9+rvnrlS5N+9PpD57ovDih+F6wTCgY/JRO6/ThkVoIcrVlCa8LYgtd11Uve/st83bgx6KsIQ5f3FnU/V6qWjPZJ3cuDmm7GVgp/82uKxiuBBgjbjKMtB6Xn/9Vw0F+m4fPLEwmjb+9Q6ka4s9i0wg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SN7PR12MB6789.namprd12.prod.outlook.com
 (2603:10b6:806:26b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:01:42 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 13:01:42 +0000
Message-ID: <ba52a3e6-19d5-4d0b-b4ef-af10ac246cdc@nvidia.com>
Date: Wed, 14 Oct 2026 16:01:37 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 1/2] net/mlx5e: TC, free NIC flow parse
 attributes after offload
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261009052103.3621855-1-acassen@corp.free.fr>
 <20261009052103.3621855-2-acassen@corp.free.fr>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261009052103.3621855-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV0P278CA0066.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::17) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eba5a86-765b-459a-28ba-08df29f34ac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|18002099003|22082099003|11063799006|5023799004|4143699003|261009223027099003|56012099006|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	qcEF6tfKO6UHK2S9lpgeDphnXYM2opu+JZN49sT60hrwzHbbEz/kW9sSJS87Dmn82uXAJ6CFPi2LfiEQ4QUnQfRZst37cr6fZqyUdJBaHexRXeK6st0YSkZyG++UPmw69DXBbzTWrovZN7msdG0v9PjCda5G4Pd20UmyopLZ/9oZ6ktg5fdZXoTxLz++H8PJ4qdnvPsFcR9UZ5m7idLStCQx2LH0l5DKPKh7al18EweycfGbk3u4Ho+IXAsa8Lsk+Xj6T7d+36PxFXa9eagp8OFahdEod3/q/dfR1ZE5WwgqFB11NJpsNiVG4lxc6Q+l6Lr3NTEgjtLKYNdItDV9kDzEoasE+JJVPjfXdTpvg08zRt/XNJeyN0hs93/zS4l+kxazhSuN/h/hyzdOeehPftDnxfrPsM0pgsmJguc3kHP4ez5vGhnLZuqgLgi05Wg6iAdfI9WiVldKXq6/UxupepUCs7qYvdTqIRjc6KiQ/i4gjklNXXGW/Ns5viTb9KIK3GA8e6Fzl8Wul6Rl6VbwPRbsIyLxJxxhV2co3dx3Hre5hQjrO5SzYBm4wKeMwUSJzyuAz1BT2D18E4uu4tjNHUyjfhEvl9F1bORRQT1uiLfrkunsrn03xVgrPPIO4WY02pPm1J48PEVBOX5zFRDDrGYHPqY/Ap0MNcxNB0/bUDC8G+pOB3bZp51p0nfNZBUHb7t/M2EPQNlme3NSdrK4hW/JhMsR9kYj1jXsEBWmKVBxiHZzvDWWDknsiTP5Bmnu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(18002099003)(22082099003)(11063799006)(5023799004)(4143699003)(261009223027099003)(56012099006)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjV4V2ZycTBNbUROR0IzdlpaUWNtcStVOTF4OVhjYmY1SVVHTWdRUkhiNEhO?=
 =?utf-8?B?NG5hZlNGdE9zY0xqaC9EUTRWUEM0QTBqYlk3UFA3QUFGdGowbDNQcmhRcjNo?=
 =?utf-8?B?RWV1UTUvOVlTMXVyREhFbjQ1SWlYU0Q3Tit3Yjk3bWVtbVFxQzQ2STlEc3dV?=
 =?utf-8?B?WjVpV3hackMvVlU3UzUreUFYRzExYmFuMmlvWkRSM1RnVi92RHlzaGRSRWVr?=
 =?utf-8?B?dFlYbGRSd1N2TXg3VHdXR0gwQ3lEcW5sZHBpS2dUbTkwaHNiS25yaW9BM0gx?=
 =?utf-8?B?T2RUS1FEUlErcVJ0Nzd1UnNDdzNsdU1VTnlGbWd3ZWsrL3JhejhBRnl0RVNj?=
 =?utf-8?B?V253alRJM1l4MGZFTVU4cjBnYU4weHVRNm51VkhCTklMVjE2TlVDNGlFc3Ev?=
 =?utf-8?B?Z3JJYXFwMDMwWW9oNlZlcHF2SXZZdlVKRFFQQTFaQ3pDZldSYVdqS3U2cmhn?=
 =?utf-8?B?VitFM1I4QTBJcnEyMWhhdjV4c3BoSW1DSkRWaTRCdlV6ck1nb2V5ZkdrYTNS?=
 =?utf-8?B?US9lWHFMaHNJNVU0RDc4cERVVUdLYnNIWURlRVhVdElvNmpZWVN0SFNPNEdt?=
 =?utf-8?B?SWRCcTQ5cVE0SzV5c2dvMkZaeW5YcHZWeDZUYVZNZG9kenc3ZXc0K2NVRnlG?=
 =?utf-8?B?K1JWNzZvcUpzRXZDUVdPRjA3aUs3Wk1BUXRiRVk0d2hBUjNKeHUxdFRoU1dm?=
 =?utf-8?B?NnJoVFdCVTJEbmFwZWtOTTE0SjVaUWxCcnVNQ3A3QnN6OU12ZmJPbWFoZEg0?=
 =?utf-8?B?UHhsU3pJQjhRVnNBMFBzR1pqeDRXWUIxUEdrZEhIMHBaaitzMzJRTjd1a2xC?=
 =?utf-8?B?MkRFLzVFWXFIdUcyMVF5R1FCcHZIS0orTUQ3aE85Z0ZnWExyQURmNDdZVlUz?=
 =?utf-8?B?eXRpajdnNG1NR2JISDdTTHNENk5UYmVUOVplemdtb3VuQTlvYkt5NTVpZEpI?=
 =?utf-8?B?eHd0Z3QwMUNCZ0Nqa3FqK3E0OXVNK2p6YlVKb3ZNeEpVekFIbTFRNkhiM1hN?=
 =?utf-8?B?KzVQU2huNUhYL290YjRTM1lKM1ZXNGIzTjZqeCtjdWM4MDMyRzFUREsyWmFq?=
 =?utf-8?B?Uk9FUXFqMEg2cDVDQXNSZm1ONVFWV2M2ZS8wbGN4S3l5dXljRkdzQkhrUTlR?=
 =?utf-8?B?WjJNdkFWYllYWEYxM3Z1UWV3L1FuNGRmZFVuMmhraWhuSUJFU3FlZ2NDRUFK?=
 =?utf-8?B?dE9Ib1pOUXI4ZXNHSUszZVhVRWdYclU1UkR4TlBkbW8yZUNzN1hod0piendX?=
 =?utf-8?B?alZ0VGtNMkVRSFRoTDlHUDVGWWxqall2cHdHM05aeUtoeTdDekR6NEpUTEtK?=
 =?utf-8?B?ZFY5cWkvdU9TY2NlNlk2cERoQ2txQnl0a2RSQkRaRFdIcVhocGhrL3pVYmZI?=
 =?utf-8?B?SlF4VjZFSGczanRlZEdXQzhYaEVWSG16Z2RXQjAyc3JZKy9Wdk5lZ2JRa1Bw?=
 =?utf-8?B?Y2FjaUFHemdmWTMwR3lwaWIrYmJ6MXRtR0tBWmZINnliRzVicHBTU3RheGVj?=
 =?utf-8?B?Y1JON3FIdEpPVDRyVExNTFMwUTNrU1Y4MkxwRndaVFVJRmhlaVBSZHNZeGdr?=
 =?utf-8?B?NEtyNzhjRktqeVFtdk9jTDlFVDdKekdUbXhTc2hocFRac2M0ajRoSUJ4Nzdt?=
 =?utf-8?B?bkozdnpRZFNianBacVBOYlJ3QmtZZWY2MnA2aXRsUENiRC9iNFI4OXpjQXo5?=
 =?utf-8?B?L2pNN2tuakJ1OWxCZ2tYTVduY2FIcnp0QWVwNEs1aEQwby90Wll4dDJoS3pv?=
 =?utf-8?B?ZHJtb2w5QXlTRmpNR05HV0pUejhDeXkwVzVqUERXSWpOL2JtdHhyNEw3c0hZ?=
 =?utf-8?B?QTFyV3ZFQVlpQnlHSHZrL1NreHZ5WU41RkNhZjg3V2FBTXNhWDZqUUtaRldW?=
 =?utf-8?B?MFc3cE04MjF6MzBZZWE2MFR4RC82ekJmcHdnZHFyejdWVENFZVY4blM2TUo5?=
 =?utf-8?B?cW1xajdnLzZNT1Q2bjV6YXBpb096bDJGMEpPb1BNQjdsODVtMzBwSmgvVDd2?=
 =?utf-8?B?TTc1WDNHWmlUbmkrd0I5bSs5M0Rxd3BiOHVmYThBMkQ3cUpSZkF1L1RqRVV4?=
 =?utf-8?B?UERXUkFSUmpjaWVFMzV0RzNidk5UQTZIeGtwSGRYZzArQUtKcmpySDNBVVJx?=
 =?utf-8?B?a2ViRVBXdW9sYlJOa2VUb3V5ZEJIc1pld3N6QXVZNEpHcEJjanJScUMveHht?=
 =?utf-8?B?TU92ZDBydkdIY3lHTnZ3WXoyKzZHOG1hTGh2TjByMkNYQVpobWNwWGhKMHRp?=
 =?utf-8?B?TkxTbnczN0ducm84R0FnS2VDZnIwN1g2VThjUFlvc1g3d3RKdzNuTmhVMGMv?=
 =?utf-8?Q?QtGYSxYuRR+/pNUOxo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eba5a86-765b-459a-28ba-08df29f34ac8
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:01:41.9974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oN2kX8oQIpj9lMRGakmxw/gUXL5a3KvbNJLzf4E58WZyZ5pV0VAM9ZTIeWw8+B8Qi/Hyf36+Qu9Fs38baydr8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789



On 09/10/2026 8:21, Alexandre Cassen wrote:
> A NIC flow holds a 4 KB allocation for its parse attributes until
> deletion although nothing reads them after offload. Free them once the
> rule is in.
> 
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_tc.c    | 18 +++++++++++++-----
>   1 file changed, 13 insertions(+), 5 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
