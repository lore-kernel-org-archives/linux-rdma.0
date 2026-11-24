Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795517176;
	b=oJIyyCpryobvJNdIQSp3iLkuhp6aKgXcQjY4rpmndXP8iJjnO+z4fvsahEDOQuXADJxZ
	 qWXaBxssicxFrpTSNQRkKkiJrmkWbAovXgNfJ7pN3Xuttq5bm+QI+zgh96u98wLU5Gfqt
	 wXI6v348JpxuQ9VCSZPcbaaLiURBZ8LUECuADOndPcsXDc1OJPCPlK5EOcCNesOi/2hnk
	 gvpw3rhm0yBz+TUW4aDsaspCJJBCw24h+jbtx1qqLSj1ejBhqSIUs8bPpCZN85qbkkWby
	 De8a1uWBn+dC/NdC7bVjwyAuDqeCtbKzLUJyxkzEmW4XRjFct9UQniIoVi6uVnpgrjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795517176;
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
	bh=Md04kW2kjex02jqyXMdAQI0wcGSNAig8eIOzKmzoLWI=;
	b=SYEu7bHmv6Zl2HZ8zoYGzEAYcw78gnKNiS0DifrBII8s0Tw6226JHR+D0P3UxJ+AGkyy
	 9N4Gr3YtNJkWfZ1WNVF4Q7/Iyx8HlmIOxwrS4KEbJLDNy/mWrRuJXVAyaAIGqIavuZywE
	 vpsjePY2VaTqQ+UGNbmW8fec334Cm8EHyxbK8dcH6UmG5nwBMNoZ1Cju9kF/uQJUlTdGt
	 ybqhuZfzI6LJ6Fy2NfA9qhmUt5L4kLYn4mXfLarC20bulUfOQ7ihBH+jrCnjZWj2GBpjm
	 mQp+Vd+N8sdJ33r3k1zhHXDcVUW78w+HuTN+Z68CjGsaIq/soxJ+Pql6fDrtymCmlmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eAUOBqyr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.58
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB30606A31E;
	Tue, 24 Nov 2026 10:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FB30606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=eAUOBqyr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2gkQPAZFZUhtgZinFAB+qtLO0zFgQDS01UGhOYarZx1DIHWXKCJFH/v1JH7fUT512cfG1bNC5Ef3t4IZi6BoQdUb2uM7nmqGUKnjiZWCzEqq/ctKtPqPWg+n8+INqRgY3hfCHAUrCfhVEfNatZQH6wRJ3p20qgo/ryHGIbrWl6OldpBsEYSHSfZih4oR/d+pCE9vZGQSLKOfdcy1kUnmVSbYyfslUJJ55fhb5JgoYQrzEUBj969BBctdLYAqozDpKgTiqECcwiOcAPHv8UlO4BRQCY1pSXBlTEpTQFesca83c9mXR77Mr7hJrwLc9sIjYycpOWHfnHsK2BtR7OxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Md04kW2kjex02jqyXMdAQI0wcGSNAig8eIOzKmzoLWI=;
 b=W7H5Ky9BepUXOGntJatucl36s5WwQNC9es/yumxGTS+B8Mrd+kuePVF7QETmmKhK8aNw9Za/KOcg+EM9WUljLAC5sMdPocWtPDSytFztGb3iW+rZ/JhVS8xjE960ZwwZe+jDzz11cJirOTp7rWiiiIuE1KiMbrSzjtUVz9/KpYpPDDKJZEqoG8iPPxEuRTSDYmQ2gFcSvsuuTxvehP7sRiXQtJaL7laW+9g+nKylq+xekY57gqt8/n2GXZzR2lR7m6CRQS0ShuGCAZ1ogh1YasAaRtfdtuDzlUEizFZCIl5tngFP48zY15ULVMtlpwjEas/iooJQW6yp4QiZBiI84A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Md04kW2kjex02jqyXMdAQI0wcGSNAig8eIOzKmzoLWI=;
 b=eAUOBqyrXbW8h1bA1nNcsGEj+BEt6/MbtQefOFQKc5N8M/YOxWyt6v4RodFzxrIU5nh8sk88nQQOv/cfk+xPdnqXKBreAJ6u77kfMZDgDht6xwfGEgFEkKNguS4mqrStKGjdV00uRQF8maSVQLv5ued6DSF2c1DJgibNFw3mOE76ludF9tsjpc3TR2heSZDNmzUyd09W3li5/B8QscAjm+CjVBehvK4qeXHqOEqUwxH+FKN590JjarXSM/w8t71bBHYx9G61lv/y90Jfrju6s2k0ktIdrdaC4ds1CiRGxc7NT73oMXbj6Tbjoy5IDBq67Km5tY+nDA3vbfmtQWLXYA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by SN7PR12MB7371.namprd12.prod.outlook.com (2603:10b6:806:29a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Tue, 24 Nov
 2026 10:46:10 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 10:46:10 +0000
Message-ID: <add5a54b-eaa7-4507-b089-6a6c330c39b6@nvidia.com>
Date: Tue, 24 Nov 2026 12:46:04 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 4/5] net/mlx4: track whether a TX doorbell is
 pending
To: Joe Damato <joe@dama.to>, netdev@vger.kernel.org,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
 daniel.machon@microchip.com, linux-rdma@vger.kernel.org
References: <20261117155353.2250540-1-joe@dama.to>
 <20261117155353.2250540-5-joe@dama.to>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261117155353.2250540-5-joe@dama.to>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::9)
 To SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|SN7PR12MB7371:EE_
X-MS-Office365-Filtering-Correlation-Id: 15626314-099d-4aeb-8450-08df4a18270b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|1800799024|376014|10067099003|11063799006|56012099006|5023799004|4143699003|261026121527099003|261021121427099003|261022075727099003|261021123027099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	PDJJkksfPwpWAS2mBZa7Te6H7zGMCOCmcon6Jc5KsnTx+KRvq2+L/3LzcI5bPrXfhr0qNbnbxER2FuciSGcs8QJIeT4rFHReWMF5ti9qEvKuJGrfD68GHSiHD/XfJLiBfixlSDyQSHc2JNfrL8v4J++e0ZEBQWQQobVKCqjul6BUh8l7XuRNojpmeAxXXVOq4cjpF3/IFebzb2I5+0trl6J+clt7bUtISVxgYPb5SB61cNmx5fdsaVRBa8wu7cVOOjS4iIB7SxV8f9VLVWP5HDfvR2xZE4p9KEoierbaGgPFdkpEKhEC2+k+exsH1fS12BwYqY7EF+pt1J/YNHPP0RmxYgO/X3CYlemfaEeKdnp715TnDpMryGgkHhzDmcscDYfj1bxWUri5Xoco9Ah86QsOVbwsKJ3PmyUf72iONPvCvtM89II+n9aOLBzo4ORxfCGeKiVmkGau1xvXzFu4o7vUTMLwOpBy6kjvnwG8hPXVCZHAqgJZwIaYlYX+rX3oPvGqqZI2WZoD8IJNNDaKcASl/H/J6TBdZQdLrkUZnQA8MWDj4bzkVUnzcyy1fg3BXAsOurNdQaJ21FTtrhmrrFmzfe4rHNQR8vLIbishWbaT+cu7Z6hnRtagtbgo4KQgGx8UCVDQZ0BNLM27z67Efw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(1800799024)(376014)(10067099003)(11063799006)(56012099006)(5023799004)(4143699003)(261026121527099003)(261021121427099003)(261022075727099003)(261021123027099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1ZKZExhVWFxNWJlOGpzUzBlTEpkTHhhZURrU05sd3lqd1NoeGlJRGc1RkQr?=
 =?utf-8?B?L1dRQ3BBQnZ5L2pyOEpZbXgrL2ovc1dXbGZzQWVEcW1aLzN1QWhzL2ZzS2ZZ?=
 =?utf-8?B?T2FOeFJOOVEzY0diWDgxaXh5OEIxbloxdnlmcVVxekNtWi9MU2Q4YmJaQjVr?=
 =?utf-8?B?eDFhdmlGNHpwcGx6ZGVNT3l1NjFhYmJSTDJOWFZkeGhXQ3NmY2gvRTVUSjRV?=
 =?utf-8?B?eUtkNzE3WkVmTlNwa2lDZ1dNdndnVEgrZlF4M1RZU2l1OU0zeVZzTis4Z0Ra?=
 =?utf-8?B?eXI2YmZ5aGYxZXlaNmlhYnpTSzZ5aUZ5Q09BTnU1a0RPbzhGQkhDcHZWd09u?=
 =?utf-8?B?MkxRelVpSk5uUU1RT0N2RjJrbXp4Y2NuWVNoVWtHSWlVTDU0Q2FpSDZpaEkw?=
 =?utf-8?B?ZWhFZWZYVHFsTUI2eTlsSzViR2huZkYzTSsyL0daMFlxNEdJaGkvOEQ5eWJ2?=
 =?utf-8?B?MjQyNmRoa2Q0cFI3ZHhNTW84b1pNVFVITXY2RStiSUpISlcwS0pEV0c5NjhL?=
 =?utf-8?B?UnpFNXN0ZEhTZTRSK0dRUFZZdm9yaFo2TEd1NUc0NU5CcmRYWjJsT3Y3T21D?=
 =?utf-8?B?ME5YOEQ0VkgxS09McjQrMENKWDNQbEwrbksxTWo2akp3Qmhnbm9UVytzUmJM?=
 =?utf-8?B?aUFzY3VrVjJxYXBBbXBFL3BjWlQ5bjYra0VUenJxeHFqYlVGQVhhRmUyRjJC?=
 =?utf-8?B?UktRaUVUWFhnUVFCQW0xdGJwVlNKT0EzVEtGUUZvbDQzTjZkY2FnMmdVbTJw?=
 =?utf-8?B?dERTSDVIWFVNRHp5ZC9RRDBFQVRFRU9kRHc4azJHK0hTUS9Fem9sR1ZFS21I?=
 =?utf-8?B?SExvOTRrajkxZHI1dWk2WDFuL0JhY1IrVUEyNTZxY2hQaDZFWEdzSDU3NDFj?=
 =?utf-8?B?a21Pd2FUY1c0bFE5K2tiZlhLanZCUUtSUWNNU2tqZWc0cnRNQU9nZUdRc0lp?=
 =?utf-8?B?OFBjNlVTQUxGakNkSkRHS3JodXVvM0dST25BSUJBRFRwWnE0WnNUbUduSGt1?=
 =?utf-8?B?ZVJTcUFPOUFuQWxob1RaYm5DRVc1RFBTL2RJL1JKekpUYVdhR2x5K2ZQRHBQ?=
 =?utf-8?B?QWVlMDlkWjJrMHo5R1lCY2lWSGYwMTlVQkd2dmNBandYMWtYSWkybWNxczEw?=
 =?utf-8?B?Wi9zclQ1U005emRpVTUzTmJPSnJkZktjQnI5cVhuaEwzWWhLN3FFdEdPVnRs?=
 =?utf-8?B?dWFwd2xubE1QKy9kRXBGUmJaYUovMnhwT0JXWXBYOUtvdzBIRERzT2JYK3VP?=
 =?utf-8?B?dTBOS0d5blFqVENaQzdCZ2x1RjhWNGpkQm5MQnFjdDd3NE1ENitWMjdlUDhi?=
 =?utf-8?B?Vk9ZNHJldElCRmxsRUpZbHg1V1R1MFJyVWlhTDRkK2pyTUdKdU9SZUNWTlc3?=
 =?utf-8?B?ZG4rVFJHb0RGUzkwZk5aWkxZY0dTM05BRXkwMnlhRWtRd1gvb1I5WWswdDFy?=
 =?utf-8?B?b3RNTkJ0Z3VhR1pUakZHS0xXVEJDVFpGS3doYjBvdGZQS2lDbldzUVAxT01j?=
 =?utf-8?B?TnFnUEhQNGs0MjE1R01vSkVOVm9iMk5NS1RjRVZOMDNnQVQ1alFSbUtYamRs?=
 =?utf-8?B?V1RwcjFJNG5xU01ncXorMFJvamI3ZmJwTTZWZ1V6dlJOV1h6cjgvaGxvQlJV?=
 =?utf-8?B?RjhxcDJaVFliTzJRN21YS0ErTHR6NzZGUGNOQ2l3Y2U2TDhlOERxTVIwc3R3?=
 =?utf-8?B?ZkhzbXpHOVljWk9saHUyajd1ZFU2SVA4MkYrTGNrdExLVEJTdFpMTjZYcmdU?=
 =?utf-8?B?YVZ3V2pFT21Ca2JqajdqQVZmQmlqWkJuanFPVXJpZ05uYnNrUHN1d2JOYUVT?=
 =?utf-8?B?TkJLK1VRekFqMjMrUklpY2VTY0tIenF1ZTEvNmZhWlJNdVhNWjl6S01zWCt4?=
 =?utf-8?B?cGloZ29IaGJNWjJKUFp2WFpPNjlEZnVhdm9pUGxwend3N0RVM24zcVJ3REdB?=
 =?utf-8?B?bnN5TGkvU3FRUU9OZEZ2aHAzNk9rOWQ0VXlQWHduZGs4K0Z3eCtDVHoxWUI4?=
 =?utf-8?B?RVVUd3JUVHdUV2RKVW9mbTdJaFhFMWk2OURSTTd0RXlQRW95M0V1TEVYbG1S?=
 =?utf-8?B?ek5QYk5LTWliYmJDMTFmaTVpblNoN0QxZDNJbExPQ1ptWWtjMGoxbGQwc1A1?=
 =?utf-8?B?MUtYNHhIU1dwb2J2VFFLdFQ1Z2tmNGRrZ1JOSm9HcU9VdFByZ1BMcGdYelJL?=
 =?utf-8?B?NFJIL3J5dlNLaXRSbzQwN2hDMyt5c1VYS0pJMWs3bUh2MVZFL1RiME9ydTFh?=
 =?utf-8?B?SnEweURoYk5KYitXTHBxRURrUVFJckcxdndlOGtySkdnU25ENi9qSW9lWjJz?=
 =?utf-8?B?RjY2VVFtUGhQUTl5VS82Q3VJamY3STc1cU1iZTdrNWgyZzlrcTdjZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15626314-099d-4aeb-8450-08df4a18270b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 10:46:10.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPFC+3wt/9dlG3hDHAbdyFjXM+yMc4wJ5+1/rSfrt3m2Ik4TJQkX7FMuZBYiw//pfSSDo2iJ8udNI6rHrKXH+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7371



On 17/11/2026 17:53, Joe Damato wrote:
> When the stack sets xmit_more, mlx4_en_xmit() skips the doorbell and
> relies on a later call in the same batch to write it. Nothing records
> that a doorbell is owed, so a path that ends the batch without writing
> the doorbell leaves the WQEs posted before it unannounced to HW.
> 
> Add ring->doorbell_pending, set when the doorbell is deferred and
> cleared whenever a doorbell or a BlueFlame write is issued, so such a
> path can flush the deferred doorbell.
> 
> Place the flag in the cache line dirtied by mlx4_en_xmit(), next to
> prod. That line has no room left, so move tx_dropped, which is only
> written when an skb is dropped, to the end of the struct among the
> fields not used in the fast path.
> 
> Signed-off-by: Joe Damato <joe@dama.to>
> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
> ---
> v2:
>   - doorbell_pending moved to the area of the struct marked as cache line
>     used and dirtied in mlx4_en_xmit. In exchange, tx_dropped is moved
>     among fields not written in the fast path. It is only written for
>     drops and is read for stats.
>   - Update the commit message.
> 
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 9 +++++++--
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 3 ++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> index 97f27e005810..123071a47bed 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> @@ -194,6 +194,7 @@ int mlx4_en_activate_tx_ring(struct mlx4_en_priv *priv,
>  	ring->prod = 0;
>  	ring->cons = 0xffffffff;
>  	ring->last_nr_txbb = 1;
> +	ring->doorbell_pending = false;
>  	memset(ring->tx_info, 0, ring->size * sizeof(struct mlx4_en_tx_info));
>  	memset(ring->buf, 0, ring->buf_size);
>  	ring->free_tx_desc = mlx4_en_free_tx_desc;
> @@ -757,6 +758,7 @@ void mlx4_en_xmit_doorbell(struct mlx4_en_tx_ring *ring)
>  	iowrite32be(
>  #endif
>  		  (__force u32)ring->doorbell_qpn, ring->doorbell_address);
> +	ring->doorbell_pending = false;

Can we keep this in mlx4_en_xmit()? XDP_TX calls this helper too, but
tracks its pending doorbell in a local variable. If the XDP TX ring
stays full for the whole poll, this store can dirty the producer cache
line even though we didn't post a single WQE.

The skb path already knows whether it deferred the doorbell. Could we
replace the three flag updates with this one?

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c5d564e5a581..9d8a4ea473f1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -1074,6 +1074,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
        send_doorbell = __netdev_tx_sent_queue(ring->tx_queue,
                                               tx_info->nr_bytes,
                                               netdev_xmit_more());
+       ring->doorbell_pending = !send_doorbell;

        real_size = (real_size / 16) & 0x3f;


Mark

>  }
>  
>  static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
> @@ -784,16 +786,19 @@ static void mlx4_en_tx_write_desc(struct mlx4_en_tx_ring *ring,
>  		wmb();
>  
>  		ring->bf.offset ^= ring->bf.buf_size;
> +		ring->doorbell_pending = false;
>  	} else {
>  		/* Ensure new descriptor hits memory
>  		 * before setting ownership of this descriptor to HW
>  		 */
>  		dma_wmb();
>  		tx_desc->ctrl.owner_opcode = op_own;
> -		if (send_doorbell)
> +		if (send_doorbell) {
>  			mlx4_en_xmit_doorbell(ring);
> -		else
> +		} else {
>  			ring->xmit_more++;
> +			ring->doorbell_pending = true;
> +		}
>  	}
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> index aab97694f86b..c28d5213cccd 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
> @@ -274,7 +274,7 @@ struct mlx4_en_tx_ring {
>  
>  	/* cache line used and dirtied in mlx4_en_xmit() */
>  	u32			prod ____cacheline_aligned_in_smp;
> -	unsigned int		tx_dropped;
> +	bool			doorbell_pending;
>  	unsigned long		bytes;
>  	unsigned long		packets;
>  	unsigned long		tx_csum;
> @@ -311,6 +311,7 @@ struct mlx4_en_tx_ring {
>  	enum mlx4_qp_state	sp_qp_state;
>  	u16			sp_stride;
>  	u16			sp_cqn;	/* index of port CQ associated with this ring */
> +	unsigned int		tx_dropped;
>  } ____cacheline_aligned_in_smp;
>  
>  struct mlx4_en_rx_desc {

