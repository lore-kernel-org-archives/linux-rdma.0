Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794789397;
	b=1Fm8VylacU9BeaVakLZoOc13FncAy+MsxkcRNeCcOA3S2Jc1/GoK75jQLx0dTcceLpwr
	 2rItFLy6V64w5yNkmSQQO6mpLihwU/uPaawT62+aleV2zpu7zA/F4sHMKfu1RmZrxkcmN
	 gM7+Yl3OcyGwjDKxUGmkgy3Li3g/7sWmur2qH7B1h3Wzoj9+WiQInfloYMxDWxMAppFk7
	 hzvSc3bPlMK1yEpJ1tB7dr73UIt0M1Rl0ZA8KyO0jt7uAyXdxp2FSpu3HAZNsCgBHOaqw
	 q9IxWSpjFJzEAWxKUfy+6oPUCAH3udQBLN4DLDZYmNEOgEwiF1s6LESKqvsqxs5llDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789397;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:From:To:Cc:References:Content-Language:In-Reply-To:
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
	bh=C/9tKTIr5TSDB/mcl2b0ZeUJJW5037bMslnwR1ufb0c=;
	b=RgNbi4qMm3Uv10kfI9yL+KCt78Jo0+n8g9JtRni1CO20IeBgbmFnaNjqlF2Tln0nASPk
	 eYxMoHi9e+ECjvp3oVJSyorfDpTNt8N6cHTaXBsUVD+RJ65yzoyE9y+10NEv4L3PoEc0L
	 AqSfg4j2ZdhoY731EmiRxv5VWCC2NYtcwxydFEvcQW9mdT/nLpw7INV7CN+0CVB9Klpif
	 K300M/U3M7ZcIZg0yEjfuSsf7Nr9Ao1E3xN6Bet9D3Ap+YAiKUv+gINTCVJj2AHsIqAdy
	 9uvX4nHW3BAP+vzl/Xg6c8hRKsDfRL6P1XRU/CagO8/xLOJgcIS9nfpiQz2HR3ghrBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LGElOv+A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.51
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010051.outbound.protection.outlook.com [52.101.201.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBC8606A323;
	Mon, 16 Nov 2026 00:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEBC8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LGElOv+A
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtWl+16rX29spPFl285x27cD9KgbV1wtjyZASM63zliJvo/9DvGQjGKdcG9aSs5wma6ZvleJDPYMJosUd0UJ3l/xfRqZl9nI3JA11mgR68LszQww1QhjTJIlr3Vdo5eDQYBC/MoMejHYEtCwBSsEQXSH+q7/lvR9T6pmFuvHLRZIr0TOso0q86vYWTdS2EHudGDFV/scE9Otqdq0SoKRGi2nB52T/Oz8i9bxd/57MCY5Dfye3O2Q0P7y5bth4h3JOLCihZLcTJBG7NGCKUC/Neg7dN4mYP6GJQ0NMQRyeB+yDBrKjz4qxuUg0gRTIe2+s6KATxKKCZD/JPIcqqO4+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/9tKTIr5TSDB/mcl2b0ZeUJJW5037bMslnwR1ufb0c=;
 b=OOvAjC6yj+4fWpGdtDWTZGY2KqbCzsXIFzIdG6izFnuhv6N5BG5kxDO3IGDC+dhY0oTeIuzA+usTa84wsu72w+wI8rv6wP+cFC3Z1/utvGhnS06p+o9T8xonJI48bGCaS8+U2wq7GEJ6e/q1GGyC93Yr/fAOlZw8HOX36rsfJjoqhviXV5GB6eb26VO/+p+WXuU/DSf4iN20qYSnzmc1+SckCd4hC3goq0KwoW/kH0WDKLi1IYmagbs2Apn8eb3J9pa13C0BmToCHmRrP/9gzWnQRfULwT5R1gHGseU7jGQiYejFar/oOjv34P6SyLvlUuILuzZbP2FdZAUkqIZjFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/9tKTIr5TSDB/mcl2b0ZeUJJW5037bMslnwR1ufb0c=;
 b=LGElOv+AfEwFbWLgnHqCPasjAS8JJfOWXr4VnfrOAVk989yHT9Q9eCT0RNxIsCTzEIM0X4B5UYVdxC0hF7MRkmKY9uU51/7A2Kv9V7DsopDX4YleSok9++n+NAcFx7mvq9+VVecjDCBV2/4KEfMj/iap/KMRs4vRcc/nMtl2A9xyqfI0N/KBOIoGWQUPJkjAOUqqpm2F1AJx0wIdsdblW1yde5MArburlTZarcfjxhqy0qdIjLehD5wrYd3F7TqB+7YZeFn6Z4cllUaNrump2UwoHNRxrP9q6pIgYHWoroAURuFrgVj7SqjZxtIUkTYlubSulbMGajH/YW0EUMCFfw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by PH0PR12MB999090.namprd12.prod.outlook.com (2603:10b6:510:38c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 00:36:34 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 00:36:34 +0000
Message-ID: <76da7f8a-7735-436c-9ee1-1198d7e98255@nvidia.com>
Date: Mon, 16 Nov 2026 02:36:26 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 3/3] net/mlx5: DR, Fix out-of-bounds write when sync
 to HW fails
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>, netdev-bot+sashiko@kernel.org,
 tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, acassen@corp.free.fr,
 valex@nvidia.com, erezsh@nvidia.com, gal@nvidia.com, igozlan@nvidia.com,
 kees@kernel.org, kees+treewide@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 moshe@nvidia.com, prathameshdeshpande7@gmail.com, saeedm@nvidia.com,
 william@theesfeld.net
References: <20261021074949.3471704-4-tariqt@nvidia.com>
 <179275275762.3134.7548579754182364985@kernel.org>
 <a3c08b59-7eae-4a1b-aa0f-042abe024525@redhat.com>
 <9775ba1b-6bc0-4e2d-abaa-42d732f274ab@nvidia.com>
Content-Language: en-US
In-Reply-To: <9775ba1b-6bc0-4e2d-abaa-42d732f274ab@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::18) To BL1PR12MB5873.namprd12.prod.outlook.com
 (2603:10b6:208:395::20)
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
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|PH0PR12MB999090:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d71257a-68c0-4e65-8a09-08df4379aa80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|11063799006|4143699003|56012099006|261022105027099003|261021121427099003|261026121527099003|261026140227099003|261028144727099003|261102123227099003|22082099003|18002099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	FucIul8xbBEErPuYh6Z3PaHBoUtEGaa43bpP4DYYGosGFJVC79Awfaai1PPuFJZBU45cXx4IfL3eoz5utE4gZdJzaQY5qV2GvV6CBuKAMyOb4o5WbOGigDS7EDjD8yBGOk4+yP97rAMEtMuM0LTgTaYnfh9JggulEkjcZsbXNSWvX6SWdnt3BeSCURkj2tEw6KwTwJ+/mssBX8zU6eZwTVMlCoKR5O7rhab7t19Zjb3ALHuUixHUGDavmP58hP9WalBy8puPhxsqInXUVEEKnazrz0BoodH8qMtUaHgf9vOEi9aoQupeSE2kPlJBICX9p+JiuJWIt0iacypUVFCVLmxiODS3/8QoN8Ra7HljIfiV3o5twbj4gpPu8nyGGoWAiXhpoV81rkZ1dU5ekrrmRx3u+tQN9KDlW8AH3wEwX+33dC3J3nnLJjiFwxIqWikWoaGYqlKA4zc+PovN8jcU1TlJ9KTYFsJ8hEbzqW2qinIE9TidlKEBfUwd5elE05hjFUKYuB2ElMkf80Y5Y96jhfleZ6cPSjDx6Rr9PNxbpfoBsQeFxEWODgCXJhjY0mcfhPaW04MOoyvYvKqEkzcN9iIrCr/gci3XtGZfmxk9Vx5zndGP6AHFgXiNtUPhA+0YJiKkQ7RMU5ohoM1UcxSQ7fqgNKJl1YLohAYnryOFMZ+wFOpL0Z8EekKd7DP82TCC+UQmjZ5wzgGDbCeUCxdD/6TvT0NQbSHiv/iH9VQJQMA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFA2MnQxRFE1NmFPeUVJNzUrZ1FGdThpVkN1em1aN3d6TDUxU2w0WHFwc04x?=
 =?utf-8?B?cHJ6S3ZNR3lzdVo3endMYmpnVmN4cEM1dytpdDQ3WENpK0xicURJS0VYMWdP?=
 =?utf-8?B?YU1JUUYwNlBVWndMSjQ0aDdCL3VGb3dLU1U1cWNlS3VYMHhEc01CYjkvNE1k?=
 =?utf-8?B?WmxlS2xlbUlYT3Racjd3TGFoOXFYMTZrdGxGSG5hQnJHYnJYYlFaQkhhMVRs?=
 =?utf-8?B?NjluZzdwZ05WZXhvR1Ura0NxQzVuMUVmTWYzUGVkdWRWeExEbTNGQ2JNTUxG?=
 =?utf-8?B?WHluQW9BUHU3Y293TFpad3N6QWk0cG1RaFpFNmdnTGRHZzRnMGFHUkJBMFJh?=
 =?utf-8?B?cnErZnQ4bWtqSkM3bTNKelJ6OVFxK09pN2c2WjVNL1VuR2JTSXhxamdDZjIr?=
 =?utf-8?B?a21pOHAwSHlwNHJWYS9aM0pnV0h1djRUOWlIZkszZnBzSHR1bEpqWUVkWUZS?=
 =?utf-8?B?ZDNBb3V0Y2FKdFA4UHlXMmFXYmRoZm5mcXR3Z0FvNzc3RjI0RlhxSmxJVXcr?=
 =?utf-8?B?cXNFa1RiUWJpbjF3NFR2NGZlTkJEUk9ZdTdsZEo2dS9uS2JGQ0xQS3NEb050?=
 =?utf-8?B?b2tMUURRQlVjU25RTWVEck5jSXBLY0VrREYySWpMVWlSdVlTWlIwNFdaZlJo?=
 =?utf-8?B?T2VveHBRN0RzWUJ0N043U3JRTUF2cjFXQTJOWUlzY3BEWWtjMmNsQjdydE9W?=
 =?utf-8?B?YnhTd2JVYjhjVEhXUTlKNWF0Q3djU0V3eTJxN0gzaHRpekhUTWwwaHhBTm5J?=
 =?utf-8?B?WEJDdUUxNEhoektqQVB0OVZaTnhVVTg3clFrb0RMMVBEcWVqR2xtT0t2TWY4?=
 =?utf-8?B?MXEwUXZhN2J0N2lhME93U2ZEUGhOdVZGUXRBRXFZU000ays2bnFYd0o1aFJP?=
 =?utf-8?B?QlErbHl5d3hpR2JLTUZiOVZ0SEFKWHdlY29NcU9scnkxbU1rbk9hU2JFMGgy?=
 =?utf-8?B?TXpWYTRnMjhOamExOHlJaXcyTklRZHpzS1hFRGlDYjNsdTVYUlFLNllTUWNX?=
 =?utf-8?B?b2JNemkrNHlQTHYzdWREODBDYXhkWmJlVDAwcE1YYjhPemR5U2pyRlVLL1Rw?=
 =?utf-8?B?REh4ZlhxMnJKYWhWSi9Wa24xT2tHTzcvdkFrRVppbWlVSVduV0FMbzVQUEVG?=
 =?utf-8?B?dmpFcVhHVXlBOHg5NDhTK0JtWFYrYVVxc1I3NjhVK2JCeGEzbXRhV3lhV2lE?=
 =?utf-8?B?VlJraXZJWTBWN1ZnaUxhYkF0OG1aUkM1MWdPdGR4Rjk0TlhYZmhvMVRFRUlI?=
 =?utf-8?B?Ui9wdEg1ZTZWaVRiZFk5eldJTi9BRkRBV1lCelpDRWJsQkRJM0FpbUFqbEFh?=
 =?utf-8?B?QUdGelpTbFExMHpFeEdEVWgyQmNudlZwVkxqR0U3ZnY1TTR0Qk51TlkzaW04?=
 =?utf-8?B?cjR3QU51cWFnZnd6RVFQSkdzOFZrMzZTSGlzMVJnaE54Y1BCM0xnOFhXRXRl?=
 =?utf-8?B?Z2ZURmxpWFJRSTM5ZWljYmpNaFdHRzhBalVmNDZJYkZmMTgxUUJLUStoS0Vv?=
 =?utf-8?B?cnpoMHZXRUJ0Sko0UHkwNlUwdFYxUHpVeWlkVjFyN2VPTFIzUHBhZ0NHQm45?=
 =?utf-8?B?ZHhpalEvWDJWbk9Ub3ZJU1NrOEtXY0NHSkVOdDZKeE9zYzdyc1lRTjFHbi9I?=
 =?utf-8?B?RHJ6dFdCZEFacjFZakMrVFl5ZTVBMXJIRy9tWWhIQklYemdnWnhmMnJGRC9V?=
 =?utf-8?B?eHZFTzBFbGR1WUdudldNZUdVd3NuVVF0T3ZtNkZxTEl5YW9FODArdVVaYUNS?=
 =?utf-8?B?U09ObGxQbXUrWXBDQ0xyWUVzYjI0NkhHckVCSjN0WFRvcXczZUh2VWF1Vll1?=
 =?utf-8?B?a3laTy9wN29EKzZ0WHFUWERLdTkvQTB6VTh3cUw0cXRBOGs5RXhPYUlyMHlY?=
 =?utf-8?B?ZEVQTHV2YWMxNU5URW04RzdDSk1GcFB6THNEcm4xMHZvS0NQZGIrSUhYano0?=
 =?utf-8?B?ZkdteGlmeGQ5TENSWmtxWktJWmFIY2JRWThuLzlsaUoyWXYralZGbG13b01N?=
 =?utf-8?B?eTcyQmFIbGdkZjZRb2t5TitLL0R2eGIvYjZLNm9sM1NEd2dwd25nWkVjK0lV?=
 =?utf-8?B?L053cVZnTDVRaElSOHc2NytqeE13N05UdnVmTlpxUlEvdjZKY2xnSno4TGRh?=
 =?utf-8?B?aSt4VXN1dE11UWtBOEpEV3VpNk5VVVhwUXlwaUc4eDlDbjhTSFdGOHVoQ3VE?=
 =?utf-8?B?WDJzaDhhcndKUVJwSlZQYXVkR1V3dDBjam9YSU9VTUJta0JvY0FGUDljblBa?=
 =?utf-8?B?WkJ0WWtaWlkwSU1pcUJNbHlFb243bWVFOVFWVXY2M0JNN3RrSGloRmRteXUv?=
 =?utf-8?B?b3ZLYWYycTRXRGJtb0owbjVQSFRkbmRpM0FEc0tnL0FiWnF3cXhIdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d71257a-68c0-4e65-8a09-08df4379aa80
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 00:36:34.2701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6MMFzZ9HJR1qKeSTadlEWEZ0fhL/XgkjwvLn+4bPyz7/T8wSuSnKh0xs7bJJqgDE3sBjdFGeWdzJQGO4AaIo2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999090

On 05-Nov-26 17:02, Yevgeny Kliteynik wrote:
> On 27-Oct-26 10:56, Paolo Abeni wrote:
>> On 10/23/26 12:52, netdev-bot+sashiko@kernel.org wrote:
>>> - [Medium] After a single SYNC_STEERING failure the pool latches into a
>>>    permanent error state while allocation stays open, so device SW ICM…
>>
>> This one looks legit.
>>
>> /P
>>
> 
> Agree.
> 
> Actually, there should be two aspects to this fix.
> First part is as you commented - stop serving new chunks once the pool
> is in error state. Second part is allow for some transient sync failures.
> 
> I'll issue v2 that handles both: a failed sync no longer disables the pool
> right away. hot_chunks_arr has spare room, the hot chunks stay queued, and the
> following frees keep retrying the sync. Only if the sync keeps failing until
> the spare room is used up does the pool go into an error state.

After some more digging, there is no point in complicating this fix.
I don't expect to see "transient" sync failures, so increasing memory
footprint just to prepare for sync failures is not a good tradeoff.
The v2 will contain just the suggested fix - once the poll is in error
state, the chunks will not be allocated/freed.

> -- YK

