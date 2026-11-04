Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793796588;
	b=HmWtvlSJ6GoC9osqb9v2MYJXaJOwn6SkfzjVAfwLVbp056bGnBVyyUQmv3xdzLLiX//H
	 qLNsE2JvH7f3PFONZBbz8hAhSJZ0wcR7l7Gywsn4PQEzZ6dPiNBKswuC+aOO+8sa9DGMm
	 alV3sV+ZLVnAMYW6nM3EzAyIJiGQnXELETmDu2vmrzKR7oI8lrKorVbRn0jrEkgsfjFKY
	 ep8y7VkWqHy5Vm+aldxmdJSxoyu+sxshB8fE84FhhAJ1yrABelE1zDehR6WXIo4KtJ2fA
	 /0vgQ+3jm0wP7gQs9ta1P6/9W8UQL+njqWnishJFH9jXsisXZu9Rmh2Yq2CzthS+k6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793796588;
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
	bh=seyoCC8UDh4HywmEg4RY1Y0A5ZL97ROajEiL01nTuZA=;
	b=ZVxU/LApnxzjZZrOR4UFW7+vJ7I+iFPo85vQ0GMoPnW3631mNUjOJ5Sm1N4dD+d/bgkY
	 /IhQbf/ISg7GbaGdaYrqcryQ3WTmmWUs2PW931yn4F90g7Aw98Oa2050+5M3Xzx6wPKa6
	 5Ld5zIDinaUYaiuXbkunCoAORfFB2JMdzSJeE9XYF8bRIgt1VswqzkcwNbmJO0X0IdQ6y
	 wmq9IIMkh2kLh95AC5CfMTakLc6OfPfAzFhAX1QMeswbE0k35kn7tSUMtjiVfV0RX/YVt
	 gBDO2jO6bOqBezKi9bPrh8+fsfJg3RY8YCk4KCZCJQjXafaErBvyUbORCpwawLc147w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IFzuNWxs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.35
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012035.outbound.protection.outlook.com [40.93.195.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CB1606A328;
	Wed,  4 Nov 2026 12:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3CB1606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IFzuNWxs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2k+Fn8I9SAPpsvbNFX0lRgTIBJWjnHlKXvXMEXimWOPcgrRK3du6glKs0Fen+5MTMPgLBZlBR5IwKfFX4swfQeMnCbhtD5dD+WPbUd0SCyK7QGdMEJCPsmGVKYhxCF8wlm5EXtnPHzykAygmwfKp928QBRkmvQpWGvlpqmxiDwqBD0y3udDF4vYgZkNZ2LmcOSBgwpNb9PEg/w2GZnjCHMd0UFli/0Hav0a7mlzJ8idDNSQT/0zvqTbEeb3BGRJrJehvautu/MQ3n2EBnvsPdf6klVjtDEIBop2Lfc0DLVuZnsVnTpVXqcBlww1XJMLt0wkkFLZFWlMHgDiapdlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seyoCC8UDh4HywmEg4RY1Y0A5ZL97ROajEiL01nTuZA=;
 b=qcg72KaFoOiYuB9tvFg4JRh7Uco6ei0Ed29vp/0iEDWqXfg/uhHwTJ5PLiQPBbu2pK/OnBAUnLuMC7NoqS5oWllQxaInH8GyQUkoZ2o1Bx2bYrWRVNRtLaeR9RGd0uLVguSSSwE6S3F/Krt9rPkXhpbt4wNqxmz8zBwxl3UCK5+WbEYKmazEufZnXVx/LwfK49ZRwfM5cz1bul+a7dKIvHSpg9X+Iw3gKmby24MwJiVM95ZZPfEjnjoP7ybnWLt5VpBKsYptdCclvVveqM15h3SMmObHm2WOXo7/4WwOxzs0QqoNRgwUstQbNd8uD249a6b+m92aYK+thfMpWp1+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seyoCC8UDh4HywmEg4RY1Y0A5ZL97ROajEiL01nTuZA=;
 b=IFzuNWxsLf1mH//KdIRsDjxiVuDcBJ0skGOCmgmMYM5zBJNyfZt4Hyp5RRucUoPPrR9ZmdSKHiDekRwz3CXXZGejso+F0AbgvGsU7PIJIUd7GSIhUOK9P1FCuafjkH90+yYtbQVeuVsAPrWgHiINEoeZlLqEcRxgGPnbounaTuX6GxVerBdUcMo4M+MXy3rWLHQqwBPJrmbvsA/eZ7fvGGxURtwvhIy7gCJmp56cEraY7s8UmUWc52TR4aiQSA+CPVvm0GmfTfmhnrfd0X3+Neos2aTBnpLy9m4m4Kk/CucV2OvH7uKf3Z5o3fUGx6xecMyBkn1dFtQK6aBsDlFgFw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by FT1PR12MB863618.namprd12.prod.outlook.com
 (2603:10b6:170:e::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 12:49:44 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 12:49:43 +0000
Message-ID: <94dfe8e7-5eaf-45be-94f5-7d2e2b38fdb2@nvidia.com>
Date: Wed, 4 Nov 2026 14:49:37 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5: macsec: free struct mlx5_fs_id after an
 RCU grace period
To: Cosmin Ratiu <cratiu@nvidia.com>,
 "joasantonio108@gmail.com" <joasantonio108@gmail.com>,
 Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 "leon@kernel.org" <leon@kernel.org>
Cc: "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>,
 "edumazet@kernel.org" <edumazet@kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "sd@queasysnail.net" <sd@queasysnail.net>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pabeni@redhat.com" <pabeni@redhat.com>, "horms@kernel.org"
 <horms@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
 Boris Pismenny <borisp@nvidia.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <179313582625.87630.11382992904624255106@gmail.com>
 <e91e786d3bf20ed981ab2d214ae3358d137d597e.camel@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <e91e786d3bf20ed981ab2d214ae3358d137d597e.camel@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0007.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::11) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|FT1PR12MB863618:EE_
X-MS-Office365-Filtering-Correlation-Id: 41d401d7-4174-4da8-5e46-08df3a72195d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|261022075727099003|261028144727099003|261022105027099003|261021123027099003|261021121427099003|261026140227099003|261026121527099003|261102123227099003|4143699003|56012099006|5023799004|11063799006|10067099003|22082099003|18002099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	W0CTA5vkOfIgohcGsodeh9iX6S/LE93oHeec6LQqSMKItXjr/7BlzIxhajyq4yL+XdPyj1bjLLLx0VclnCPXOTc7PYKcCtKSwjZmsQG50Dt6SZsV957wMKTkcqSuPajAY1qwRzdUDtodVg8ZqSAQJJMQcSqf7at8KIfPLlk+C6ANHLtZ9LCjy3QnYzZFbBMruMJM6PW1yI7vmi7tjmVDHV9tlaObLQxuGC1t6Xh5zZA5b4zCMEND8S2bCqHo4Cd+KWLQFbMMVu6X9lxaQpXv1qZVYrK6x9ffuUjNM92g8U/1ksqO5LJ6+u3/G6kpD+Ob2oMFXUOEN8d9AHjsE3RhMMXHT45lQQpd2gOD2D4+zLNfdg4E0g79QlpSm1ki9RwNIYKoRsMTOusr5LbO8jMMcv1xUAJrm+ECCcnP+AFHDj1yTih6LVhcyS+r4+rjWfoSJomugPABu6TiHcTDP6zUhEA79x6S6vgZ4AOhijtZ0BAVkNsOGECAauUVZI5tF87mMgOBeO1eK7IVxiuQlaVdtG1w/c/fyiGT9MdpCiVIV0UEXxBV9O/wpFqBUpND3c9xXLMnKruhS4EfOIIEIigFNi9vUJ6rVwtHWBMOROa6Myk8CmP/oUButZIW0puy5JW0By2oLHLa9Cf0yDkMSsPZ3Cd0PWtbekUTqSOP1idLx5U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(261022075727099003)(261028144727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026140227099003)(261026121527099003)(261102123227099003)(4143699003)(56012099006)(5023799004)(11063799006)(10067099003)(22082099003)(18002099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wmo4NG1wVWVWdmpnZVJYdEpZL2twSUluOFltRFVUc3Y4L3ZYRUtNQ3FhOGth?=
 =?utf-8?B?cGxwN3V2cm1teFhzbm5XeC9ZRkY1R0RoVFlFbG5JV2x1bGdnVFhkUEdPS3NL?=
 =?utf-8?B?bUtxK1Nmb01FZmo4dUpFSUZUMzY0MGtuOW1TL1NQMlBPb2FCdU53TkZDMnUx?=
 =?utf-8?B?cjJkeHRpSlFxWkNqT1ZCdG54WHB5QnpTUS96bnlFN3VxdHozM3pkUFpHeEZt?=
 =?utf-8?B?aFQyRGsyNHpBa3ptRHk1cjVVdGNteWVrZENmUjlhUXB0Mk12ZisxMkdhSWY2?=
 =?utf-8?B?SHhTdmt3NTVRT2RiS0s4N1A0TEJzV2oyMGZOL2NTc1JTV1p3RUE2S1BNLzdR?=
 =?utf-8?B?WjI4eCtiekxuMVM5aWRxVkc4Y3g2bWJIOHZPbzNGdGNkcHJXb0FOS0d3S1BE?=
 =?utf-8?B?R1NtSi84WS96UW9KNmRUeUlXeG1NUFpkZytzVUcvRWZyOXZ6QWc3US9MZ3VG?=
 =?utf-8?B?Z3k1QURNOXBLOGZQcDlBZktlRmhOVDE5U0FVOVhBMXlGTVRLTW9VbEUrZ0ht?=
 =?utf-8?B?MTlMbHBhWm8yVkphV0tUT0hDRFJLbW1TMTlXdkx2SmEzZHp4dXo5TUlDUnp4?=
 =?utf-8?B?dGZ3cXdHUkI0dFI2a0NlUFFna1o4NzZMVW9TVzFuWFVGMlpzejNhalEwd0NZ?=
 =?utf-8?B?QWpEWHZmU3FHZzVneCtwR2RZVDhTT1NMbERiVjEvcTRGK2hQdm5qRUZwTXV3?=
 =?utf-8?B?QVdRRWdDYlJCS0xSeU1MWDZiamRvN1djaVIxY1c1bzRZMis0OVJkRzlaMzE4?=
 =?utf-8?B?VnZIL2tvVUxHT3ExK3NDMTFRblBkaGhzYzd2OFpWaDdvdVJSVzkvd1lnVkdP?=
 =?utf-8?B?YWg3TmdjcTdoNDJqc1R5UGZKdFByYWQ1Z3gyWEY4WGtrWTg2bDZIaVFrUlN4?=
 =?utf-8?B?RVlkRXBVZUdCVTlYbXY2ODdyK0s1SjBZWTlJTVYrUm5XUGRmaWJybWRmc1Bn?=
 =?utf-8?B?T1Q2ZkQrdXVHM3RCNEpQc2gxT2t6MXE3cG5BQmRJYUVkSWdsWDRRNCtrV2ZX?=
 =?utf-8?B?V240QkFlOFhKQmpzdytHampQZ3dPNU1Dc2lBS3hMc2FUMVRkTUtqMHJndHkz?=
 =?utf-8?B?czFGb0RmTVJuUDRHZGZZNjRjRk9SVFlHMTJrSFdmcTR3ckFhU0FLSjhSR2Iw?=
 =?utf-8?B?dnBGTldyTTJQbWllVHF6NmZERmNpdTBaRGY5d1BoOHJRM0pYNTkxakFiR0Iy?=
 =?utf-8?B?RWJnVWEvWVRBZ3FQa3VBc2lzcTZjTWdMcXZaWWR3R2RrejA3eDlyTW1FRGlW?=
 =?utf-8?B?UlhpbmtNcllKU1kzbllXY2RJdjExc3pKSlUrZVozcGVMRXloSzNSR2RoVDRm?=
 =?utf-8?B?Tmlqc0R4SGc4MEdFRzVzd2MwNXczbzF5MXlkbGJRMi9NNllYWi96UHR0a1JU?=
 =?utf-8?B?aEdnWEJiUjd3TFJoYTU2YklneG94dXByc2VJQzRxc2h3UHRWMWtQejdIdEJz?=
 =?utf-8?B?dWI1K2dmUGlwc05XVjY1N3ZueUR1Zi9CbERsOHNSUmwzRVVadFZoUmF0eXlz?=
 =?utf-8?B?VnJNd0tIbzZ3NG9aQXAycnJSNXQxbXUzMFV5dlZzWjE5cy9nWS9ZL201NnN4?=
 =?utf-8?B?K0h4dEpZbmhxdjl4cnc1NS9Fb2o1QWZUeU5ENmQ1eVYwaU1kbmNEdlBEeFhB?=
 =?utf-8?B?R2JtOFNEK1prY0JTNlFkU05sUGxweGFXS3N3cmlmQnMySEdJYmZkME9maHl4?=
 =?utf-8?B?NzZ6VFFGTDFkU0lKaEY4RkVydkFkRkw5eVVlL3N2bllTVldIalpRaWtQdUVi?=
 =?utf-8?B?TTk0VlFTR2xJcTBqU0tPaFVMZ1FMNVQzc2tIMEQzTmtPOEZtN3padHZrRDdR?=
 =?utf-8?B?T0hnRmVORktJT2ZwMnFlZzA0LzF1MmRXcVZIMEZTd1h1TU5hNXMyM3VEMFZa?=
 =?utf-8?B?MzN4clgrOXB1YjE1dENYTnJOUDlLN3QzUmJNTFNEcmVRK2QrdXlzUk52K0s1?=
 =?utf-8?B?TGlpcFBOK09NTDgvWWtrcHUxWmlqN3RBeEpNSFdlRHo0N042QTg0WWZ3dU1H?=
 =?utf-8?B?RXJnbjJ6WGY0dDhwRk9WRGh5TWRTVFRIeWJyZE5wbVJJbFVCU21kZnJtWEt3?=
 =?utf-8?B?allucklpNGZsOFROSUlHWFB1VFNySWN4ZEtFQ0YwcWhEc3pLOHFWckN5ME9J?=
 =?utf-8?B?UmJWVzhOQ1ZPQXJFajVBWjRXRHV5YVd4cjdUY016M1J5Mmc2Rzd2OWlJNEVu?=
 =?utf-8?B?cWdwUEt3YVVJd0pGZVVnVDgrMTZPdFF3SVl0eG1OOHNPZ01xeHFEbnFsOWhH?=
 =?utf-8?B?aUZjNFdySHlqVmZwLzZCS1lPWFRhYjBBVFpiMVlHUU1SUzdmUXFBK3c4Tzg2?=
 =?utf-8?Q?h3tOnjbqfOkzpiDxFZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d401d7-4174-4da8-5e46-08df3a72195d
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 12:49:43.8364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEfb1RUVQsS8e+Bi3IIL0oY4XecMZz4VzXN5ZKyzdFAo7jOZS00WnkE8fxdKZOG3mUeZWBWp849EX/q1KSzQZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB863618



On 04/11/2026 13:20, Cosmin Ratiu wrote:
> On Tue, 2026-10-27 at 18:17 -0300, Joas Antonio dos Santos wrote:
>> macsec_fs_id_del() removes a struct mlx5_fs_id from its rhashtable
>> with
>> rhashtable_remove_fast() and then frees it with kfree() right away.
>>
>> The TX (SCI) table is read locklessly from the transmit path:
>> mlx5e_macsec_handle_tx_skb() and mlx5e_macsec_tx_build_eseg() call
>> mlx5_macsec_fs_get_fs_id_from_hashtable(), which does
>> rhashtable_lookup() under rcu_read_lock() and then reads
>> mlx5_fs_id->id. A transmit that looked the entry up just before it
>> was
>> removed reads freed memory.
>>
>> Before commit d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per
>> MACsec
>> device inside macsec steering") the SCI table held struct
>> mlx5e_macsec_sa directly, and mlx5e_macsec_del_txsa() freed it with
>> kfree_rcu_mightsleep(). That commit moved the table into macsec_fs.c
>> with the new struct mlx5_fs_id, but frees it with a plain kfree().
>>
>> Add an rcu_head to struct mlx5_fs_id and free it with kfree_rcu().
>>
>> The same issue was flagged by the Sashiko AI review as a pre-existing
>> problem while reviewing the HW-GRO for PSP series.
>>
>> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec
>> device inside macsec steering")
>> Link:
>> https://lore.kernel.org/all/20260909065542.4B80D1F00ACA@smtp.kernel.org/
>> Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
>> Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
>> ---
>> v2:
>> - Drop the macsec.c hunk: the sc_xarray_element free was already
>> fixed
>>    by ad17ad50b8dc ("net: mlx5e: Fix use-after-free of the MACsec
>> xarray
>>    entry on RX SC deletion"). (Simon)
>> - Embed an rcu_head and use kfree_rcu() instead of
>>    kvfree_rcu_mightsleep(). (Simon)
>> - Fixes: now points at the commit that introduced the kfree().
>> - v1:
>> https://lore.kernel.org/all/179285888829.90275.17386097105525068016@gmail.com/
>>
>> Testing: compile-tested only (arm64, W=1, CONFIG_MLX5_MACSEC=y, no
>> new
>> warnings). I do not have
>> MACsec-capable ConnectX hardware, so this was not run on a device.
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/macsec_fs.c
>> @@ -94,6 +94,7 @@ struct mlx5_fs_id {
>>   	refcount_t refcnt;
>>   	sci_t sci;
>>   	struct rhash_head hash;
>> +	struct rcu_head rcu;
>>   };
>>
>>   struct mlx5_macsec_device {
>> @@ -684,7 +685,7 @@ static void macsec_fs_id_del(struct list_head
>> *macsec_devices_list, u32 fs_id,
>>
>>   	xa_erase(fs_id_xa, fs_id);
>>
>> -	kfree(fs_id_found);
>> +	kfree_rcu(fs_id_found, rcu);
>>
>>   	if (macsec_fs_is_macsec_device_empty(macsec_device)) {
>>   		list_del(&macsec_device->macsec_devices_list_entry);
>> --
>> 2.39.5
> 
> Thank you for the fix, it looks good.
> 
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>

Acked-by: Tariq Toukan <tariqt@nvidia.com>

