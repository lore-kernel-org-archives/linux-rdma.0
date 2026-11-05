Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793890953;
	b=UL5wBDJURN4Fi7BIOGqTUGRUJbyBv0BiLoMm18vNzGciXP8APnq4u5RQF9GI592Hih/e
	 IXQfNNgKgKcj91CnyRzTlCC4Frzt3YY2tKFY0hF9snumgGDhxm+u/WVJWHxhyGevr9XPO
	 hIprxfVI63hdVm1BT1uATOSX28CTWfru0yruHJ0ks01yhggz1sWQXcORFHYJUKBYZ1zSe
	 Ffchzti0wxgQvzSXlBMWXgKfKGhrIPJKwmtaNDVSmrmSxQLPfQ3f5jn/f4Tt0AAALoh8S
	 KO/oOTeqVVlbGqAPiDMEQeddpbYlS4q1/Uq6SZXxSmbjAL1iTaEFf10ROk6v9x3SIRQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890953;
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
	bh=3B6c1td5ijzhk3KVsdPZA+Fnm9nKiJcH4sUlM6YZWn0=;
	b=kXpC6Qmbww2FikBGHr8869rrQ12uzQjeRoiXjUTcQn5t6aLk4WX6l2Jc5YM8IDVYpdVd
	 fTeYKXFweFBw8SypobxwC0PSgBKmZ3Hivk4qTlHPo/kE25UI6j5lFgeTK1g8lqNCXS9c6
	 mPcF+tPKMCFuYKVgsd+PZfcpWEkqvbvEmSgotamfRdUW1pQkEGCPqbjdkIenHbNRVDoQ4
	 M5k0W529Lu6USGsx26R8ThF8gVS8TmZIaPzMAmT3Fz4zDQHykjT3/UG1d9ly8j0Gt/Hrz
	 +GDeyrcTlD90HHRA3N+MYYdoT9cZfE2cnRXjjK8NqnVNcz6lUm7xgvHAF4+54QkGSsA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="kctyA/FM";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.60
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013060.outbound.protection.outlook.com [40.107.201.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C05606A33A;
	Thu,  5 Nov 2026 15:02:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07C05606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kctyA/FM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N22HyGKx4ei+0azQjEl7XJqOZT0sj6Q2Lqqku+zdnhMbyPhpHXi9C4wsvtmB6BH45lPlnPsmB6pNZ+ip99L8Ur59r+/I7kEUefI1oIG6d+/oL80bkg2FCfmadfXGLjNP5kIjFxLprPv7qFincTcJlzX4QGQgCBiSNxhhHINd2uJgAwsFTXrqPD+Tdb8U5iIokEELpJgE4aWOtAQLpQtKN7/GcQCZp4u8lUQ0Xw9Wk20su6xJWhxPLXck6vFTot7uwVK/8FU8GsERqXV6XtsLRQFBCa7Doaav3FqlO9ywvRXmsDd3QfwZSLVLndndRGlJT7t3nu7AqA61lr3f68BfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3B6c1td5ijzhk3KVsdPZA+Fnm9nKiJcH4sUlM6YZWn0=;
 b=QEfEaiC/Qqv8nowJZvr9bXldepjmB7hFvKR2PcYYHKoWFTMYCXQe7d1cmZZfzi9MqQ8t+/E/cj5medW/hu6lTJlo81yNWhpmVumEwwhfMx21T9vg8jAkYabJFJdW9UU3QunwL1aPY25DDHT206CU0DxoMEhQZS6EPkuE44pE0qWp3olliOwnBIIuR1HaqAORDyzMv8uc0NROC6FrUvQd8I9A4xVG2Nf9JPM/DsAzLE6nsCcC9QSbUGNYB85bLbd7uxuMEHlEbSvi+Tmff2+/fmdhqLFxJF2/wtPfZXFtOI8FX/AZzA+1X0EvwdcmBb5LvgMB/ujjxRfo1BnDEnOnQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B6c1td5ijzhk3KVsdPZA+Fnm9nKiJcH4sUlM6YZWn0=;
 b=kctyA/FMjAecoHL0A7HxEQDXT3ycLVisk2JWkL9fQs9Dij4o5LObcTUmXsyF5kyp0sJqMvBbgGw9J6JEDeqMmrWh6PhoiZ15b7yCdbmE7c1GjOmaqIcuIcA/fORwlKw4ghMU0bka6jGFgF0yawxGeTpkXUj/hRcuWVnXBJQy2gjEUpUjciWdkH/3M+dCFQHXD+6tKCI16HkLLtJF/pxdkV18H+0qvEL3wxIvOg/v4qprkZYH+bmuRfqFZ/+TCscstXq5WgndnFFfJp+CaaILWfg2+zhNcC5CaSNj50wikhiyWFxWqsr7lSGPm35VqQDLJRvt3r8Gh8ZirFSBBRsebQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by SA1PR12MB8842.namprd12.prod.outlook.com (2603:10b6:806:378::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 15:02:26 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0569.011; Thu, 5 Nov 2026
 15:02:25 +0000
Message-ID: <9775ba1b-6bc0-4e2d-abaa-42d732f274ab@nvidia.com>
Date: Thu, 5 Nov 2026 17:02:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 3/3] net/mlx5: DR, Fix out-of-bounds write when sync
 to HW fails
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
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <a3c08b59-7eae-4a1b-aa0f-042abe024525@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::7)
 To BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
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
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|SA1PR12MB8842:EE_
X-MS-Office365-Filtering-Correlation-Id: 6891a873-2467-4b4e-0d08-08df3b4dcd46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|11063799006|4143699003|56012099006|261022105027099003|261026140227099003|261028144727099003|261026121527099003|10067099003|22082099003|18002099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	mDQjB+xjLBD+ofZ30X9r9ejejXLC8ELgzRvqAVghxIulZZSA1W+zOAjxidofuKr1xgAK0Y2xkqkS2+45msVmJbAzPKiHfXhYIDbmYNvM4CPU1YjVqSrmiQI6pNhymCMvG/ClkkhHrwB9qpt/mGwkW4GDesmo/+Agu3dlCHV03JAOPZ7C4hZWmkoeU6eIr+YZUTVxU1Dj8TmLm2sfyC72XResM9syFnTqCqJxEcnufb//noa90Sp5T8qbztcINKQymbtCnEQ2NuiA2/8F8B/9fiVdJcS+FYGTCFf7gckXRzBAZlpz3tTpTiD5nnvunocp5cyProhVY0vetee1ydZ2nqSQCOHyO1VvXzci9MaS/8PGOA04zNXon1TLKSBEDcg56+yf2Mq+uqc3hF0H12iK41bqPL0AjmOpaDhYxgIWhrehBAqildUaWAfco+Yi2CI5eSlOQ9Li4CyqcKkdWvZADAmL5i5hCnrsAq92CHfOKpqR3QFxQ/53+VqQDXqGUtE7zZAWLTi0Xb/bXvx9nP1E9jUJL+Q7Jszf2/zvRjEI0V24iBeNtabh/MXWpOq5egY4jgj4hyhrZjwvokeCXMLp83WVbfVjJlv2d3eAsryZYNs/aaOOOZ94Sw2ngATjZhjsGGs7QlduUGh+Kvge6sI0FKUf/dlk4WympN08Bnfpu8Xp9yXDglyuadO4J7fwbxKa4BeFPaYz9qtZMGmm1AtmwoYFKSit2nXpC2yjIXPlF4g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(11063799006)(4143699003)(56012099006)(261022105027099003)(261026140227099003)(261028144727099003)(261026121527099003)(10067099003)(22082099003)(18002099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cG0yUmlEd1Vxdy9SUDd1NmlMY3F6SmtZekgwQVBhSXBldlVlcFV3c2ZRcG9M?=
 =?utf-8?B?dlhBRGs3SFFqa1Q5NTBlN1JEYWhJV3NkYXJ0azIxQktXOFNUZGJZdjhzWnpR?=
 =?utf-8?B?VTJYQXNPVEJ1RXFWVEZhY2wweUErby9HL21IYTdFK2tzSEE1c1NYVHVJNVFh?=
 =?utf-8?B?NjdTY3ZKMWJoRmx6MGJwc2cyVkJnU2UvT1NzSkU0TnhQUityNit4RHYyS0t6?=
 =?utf-8?B?eEhWcTFtL1FCeGhtWE1DN0ZlcTZhNy9BYXI5TFBuS3BYZVgzRVhhd1JPM3V6?=
 =?utf-8?B?VmFoN3hFSHpOenVGa3l0NklwMTRxM1FXMlpqY0xDS2RDTkFKRVNEVGVvbmRt?=
 =?utf-8?B?TXFEb1BvR2x4cHdCRVNCbUhadWFlRjc4SGlTN29SL1pUR1ltT2YraTdFSmN4?=
 =?utf-8?B?S2M4TDU2SjlncG9ucTROZDc1VnFBczUzVThMcW40ZmMzNzJhVTA5V3RrK3Ax?=
 =?utf-8?B?a0lOc29aZXAyeTBZQ0FOWitVUDFxZ3NlWXZYdmZSdnI2QVJNSXZMNENyUWJi?=
 =?utf-8?B?SkJKajlBUCtwUjNJSGU0Q3dlakhuWCtRcUxZQW5QWUxJVXdKazgxZGhTZlFK?=
 =?utf-8?B?TWVhTXRiSHp2ODhwaW9vdEtEYXQ1L2tqZzVLcUYyMHRWSDZFQXdaTXZwNEha?=
 =?utf-8?B?ZUtDcjJmODRZVmkweGFqVGhVL3FtZG5SemZXMjZzWFI3enV5clBaUTlCR2pu?=
 =?utf-8?B?YTZMeVZFd3Y1YmpEUlJzNnFCTWVlKzl2MlVYRUgzRlU2R1MzWUtSenp5M3BF?=
 =?utf-8?B?cEJrS0dPK0x5a2ZDMXRxNCtpMGdaRDJxdHoxSUYwYkt4WFNtMEJnV1BTY1NG?=
 =?utf-8?B?QzdtNDNTU1B5MkN4UFozdGhvdWhKZkYra29aRkRwcTNLMi9hMHp5T2lsODly?=
 =?utf-8?B?K21EYjdhZ0lhbi9YcVlzUTFHYlhJOU53dzhhVmNUUWZRWlR6SmxWejhLTDc4?=
 =?utf-8?B?MkdRM2ZkRlZ4MjhPOHpTSXJpYVZTYjlOdWl1QmdISVl2QVh0bFZURi9wcW9h?=
 =?utf-8?B?bGRFNnk5aDkyZmNBWnpmSURBbE80bXhyaVdlcncvOUg3ZEY1c1ljeXBydGRF?=
 =?utf-8?B?Q2hKYjlRbXF3U1pDYzJvRVVyVlBOSVZ3WkRMK0t0SjJrb0NQOXZ3bWx1KzFt?=
 =?utf-8?B?eEZvNnFhczJ6WDdaZjNvWG1SZzcxRlpGZ1c1WUZGbnhmRTM1eUZnVXZlamtD?=
 =?utf-8?B?UUpvaENrUGhPQ0lDWFRUMlFHOExnSkVsdVNwcHVCTU1EODI3QUtSaXp2bncv?=
 =?utf-8?B?cFdpeGRLcXg4UzhLYXRGOTJzcm9GaE9ydldqZW13a1FNWTA2MStQSmRUM0Q3?=
 =?utf-8?B?RVVZSWxnWDFhYWtUbUJ0QmhCWTdtenkvaFB6YU1QL3ZRTGZZUlZkZ0tLMFhh?=
 =?utf-8?B?VDNXNWVCeXlVMElxUEZhRWkzdGk0NzlkbUk3MGRxNitEMWZGeVNmYzZ0NlpK?=
 =?utf-8?B?ME1UdzVlMkJlblYxODNnbmgxNlJwM01qYVNrOGxrV0JBUFpQZU1rNXR5MlRT?=
 =?utf-8?B?c01iTWVyeVZoL3BqQmJUaFJwcE1qQm9Sa2Nmb2tPVGRNTDNVbnhPL3Q0NFlh?=
 =?utf-8?B?RWJWUWhKYkpVdEl6WmpIVWVHS3A3WnRSTlpVSXozUElSb0lYSmVCdm5xOCs2?=
 =?utf-8?B?NUdrZ0x5M1g2UTFvT01YRlowVnhRVTFJVHZmNWljSk80TVluNW50WFBuRmow?=
 =?utf-8?B?Y3VMbzRRanVOQTVKUUdzeDhwRUVDMmtwVlFhNWdadnFncU9kWkVsZ2FXOEFn?=
 =?utf-8?B?ZE1tSkVNTWZ2ZDhJOXRMQ3NUMmhmSE5PUlpreXN2bHFBSGU0SWxleWJjTDI0?=
 =?utf-8?B?VGQvWmpJZUpXQk9zamNDOG9oR1JMZ0dmdmY4Z3ZjVUhlM0swY3JDQ1FXU1pl?=
 =?utf-8?B?MmRtd3VyNmYrVFAvSEpwWitnY3BWalhDK1hFdlY0ZjJVZkdqblc5YjJBaEQv?=
 =?utf-8?B?WXBEdnFqSVpVd3BmclVjWFpJd3JkbzhNbWc4K0ZMck53VURxNG94NFRQeGhi?=
 =?utf-8?B?RURXTERGaE94MDh5MEI1cDNBNWhZanNnb25hZGRQcWxIbnVyRldrRlFLbCti?=
 =?utf-8?B?OFh5WUI3YXdBVENJL05RL2xlQUFrNkFvd2FwM1ZxV1ljRC96c3E4MTZHWFpx?=
 =?utf-8?B?TDF6cm9hYStPanNwN2t6TjFLam5zdWZNSmJCSkh1dG1OK2RZZCtKUkdIeUF6?=
 =?utf-8?B?ZWZ5N1Z6bHVPMnJQL2ZDamxyT3ZGMFVtTHE0S3pUMitnRW1zUllQMVV0OWxv?=
 =?utf-8?B?d3JFSkRnc3B4cDFnYmxnNEdrczNGY2J1Q25pK2E3M3crV1BOVEd2SVdwcVRh?=
 =?utf-8?B?K3RMZ3JpUnkyY0JJU3NwbVhjNHpIbFM2S1dmdWRlSU5EUGVKaEoyZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6891a873-2467-4b4e-0d08-08df3b4dcd46
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 15:02:25.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaBK7lGPZbR7qMFwNIAIxF2oHlxX7XeoyXFi47ZJy5ZBto6S2gdNQtykG2ym4+1uCYmWFrHpmFpcJDWQC3/RMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8842

On 27-Oct-26 10:56, Paolo Abeni wrote:
> On 10/23/26 12:52, netdev-bot+sashiko@kernel.org wrote:
>> - [Medium] After a single SYNC_STEERING failure the pool latches into a
>>    permanent error state while allocation stays open, so device SW ICM…
> 
> This one looks legit.
> 
> /P
> 

Agree.

Actually, there should be two aspects to this fix.
First part is as you commented - stop serving new chunks once the pool
is in error state. Second part is allow for some transient sync failures.

I'll issue v2 that handles both: a failed sync no longer disables the pool
right away. hot_chunks_arr has spare room, the hot chunks stay queued, and the
following frees keep retrying the sync. Only if the sync keeps failing until
the spare room is used up does the pool go into an error state.

-- YK
