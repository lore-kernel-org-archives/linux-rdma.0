Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010058.outbound.protection.outlook.com [52.101.85.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90484E9C13;
	Wed, 14 Oct 2026 13:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791982938; cv=fail; b=uKo3NKK3fjyVVqNc4S7XTFyhSmhPwNb/IOtJ0TW5CL+U+hpnook0OK+DwmvYIV1IBNb1GdYONNBrGYZhmXdhrJlc8XEgZN/OEdbaLS8MVfr1y7ORd+UO6rXoe9W97BceQijz8IT5Iz8wHCRad3ggXFJK/U7CHhMF+h/tDD7pkF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791982938; c=relaxed/simple;
	bh=HtMXNRSKoSit3b6hQDTKLouRs8JsltImTy9EYjRhuaM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JVdj/6fVNdAKX055HrK0UYtPg7p2xhXupy+GMkPCAmdx55+SWX0ENhvpAsQ5Rs9f8iGPZJUjYTZOK1Vt/wurGx9I5wi2mq9xWK3UfLWp0GG1HkC5f6ZMn8mqXUQ6lUGVEhSoBVfIrNnW+etRH3xn45GXU9WC5UIT55xjdecNxoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eC7c3FNq; arc=fail smtp.client-ip=52.101.85.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eC7c3FNq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IegqdrZvjoVA/u6k7lvb6SGLx/pIZNAvcJtpxH+CLCkFCvxvdPabmGUkqGuOdSciVycQC5cFE/cbSZfQBYuEG0vO7ZDciqkQAs+VKWwlC7Ug/D6wvAmbrRf9E8q3loXvQb6H/mOzutmPjbr+WG7RP+aYRzQSSFypxcZo/MKSB8mwE6GDUYmNAJtzKpMpshGiWHG9I9UAY5NtfJwUX34gaSOS7pZtCrUr116R9yC11Orjqb6JsbYn2O2ZL6FN1OBJzWEGqH4wfWoZaoa4BSG9lPYfPTa56m6YTZZEPrBfmITzjaymmA9SNbbdi3FKU17dFQoRxoVIVsWTkoqoIjYOYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FM2yxZHSk97DTOv9QaL2RVqr35xjYVZ8mAP5PINMlK8=;
 b=oNCPq0Hlm+msXDBaTN6XBU10GqCnpg1JvS2Pigs2JVTjqb+GSOJiE/GUSIHkTtZ4rpWKtVkRbBFO3qT1/9Nu+VD6XrUypYa9eHuc9lQbezqm7AYYBn83b3lZZgHkCH1en5IkZ1ms4dNZRQG6VrmKqILgpjhcc9glt+ZZ/RqI276xSq4nelTGfcJJ+fS4k7rKfZ+8VhlFt1mJCjfg/mTZwy3/x1YYebx33DYTAytDqCmiPOVs3NuNKRPTyIqOHTo8715vcfgJJwVbwyLPgN1OOGUimx5oOhsqc1q03Olc8q6KuPix5UdieXPc+8Ns6t/WCucQ0MerEKdAXle0+G0SQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FM2yxZHSk97DTOv9QaL2RVqr35xjYVZ8mAP5PINMlK8=;
 b=eC7c3FNqLBDpAQkevmE9cFWBPlgZvuMe5w+/wlquV0N1o/U3QphvYYGL747jNr2bI54Z88/JmDk4nUs+akfWQIACHJf9AJK3Ijv/A9b1vSu++XnY8hlthkae9gmNmbcMHRxJ+OEKTY9KLRJ/RpitjA/rm0rycI6JPgQn+GN9zPGq4rsBypEz5cdRrkvCh6uNo/ewYwGNJX1P/bSPe7BKMZoCRYUxdTYFc4TVqFchnsbKfzk9MkX6tR1kR/kAQXWrcFqGpSCnnRcWRXEn4pLTX8YcaxusQKyKF48+gnygwuj9E2qmjqed/oL35LuGjCjepzayPUDmHIzsU1ztlhEZAg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SN7PR12MB6789.namprd12.prod.outlook.com
 (2603:10b6:806:26b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 13:02:08 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 13:02:08 +0000
Message-ID: <a5cec0da-e7e5-40e4-b7a0-e45f0e489313@nvidia.com>
Date: Wed, 14 Oct 2026 16:02:03 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 2/2] net/mlx5: HWS, shrink FTE action array to
 fit
To: Alexandre Cassen <acassen@corp.free.fr>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261009052103.3621855-1-acassen@corp.free.fr>
 <20261009052103.3621855-3-acassen@corp.free.fr>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261009052103.3621855-3-acassen@corp.free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV0P278CA0069.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::20) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SN7PR12MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b999c0a-c56c-48f8-2402-08df29f35aab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|18002099003|22082099003|11063799006|4143699003|261009223027099003|56012099006|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	jhGENyxi3REWsOZdsH8/D5Y7qplJhSQuiPWfI05EQHDZA7UxlczJxd0NKRI+MkxQFJsyxeWULsZs6cg9voRmd3PPuFi2euJG8YrOE0rixtusOjICn4orOO5T8lhRMoZtbeAb/lFqpb3pbB1zKiy1bppHHoQbq4w1+aKm6coMCnEy/6WgOU/YzD5IF6Qb8FtXzeofvkLsMGpdWkzel/knuDYE/Pjsu4PYgRpodXQxIqOvD+hntIJqz3UODmtItKgEboQtIXok6F6lzjHpnkMDFvKsIIFW4hy/wO8kducfXa0vaovt6CzMUX3L7paj3i2qjf4CGVuwX6uIixxoYGST7cVzxHernSImAHLL/SJ9vIuUM7UVD5yB18GDOcJg5AFRmH0QTOkYx5nvayt5ygicGgldNRvxQJCkQZmEECf5C9CqJ7n4jdsNkUgDFr4w71xx/hl8cdk22taX0TGQGjyfVk6Tpt6D1UHfiyVem6DBL0TwN7fTgUl7ubNaH6Xw79jhcYKN6nsraGhhMWCFVzgw1+75cWgX2LXluTWgOt2M7VGjHcbEyegaGUBs2vf5RjM0qiyz7C84TJWdCYm8d5NZpS81rkHfkkBnjxqBaFQHgOpEC2F3UHGCSG1ikGK2TwEZQ5kI6uBKZGGJTwQ45xkbDrpokeuHXVV5YXfcNzxSraTa3zxX6kVcpg0/McRDvuAJfUIvD9E1bGIjGVxHWyfIcUAeGoJJ1Sw/2SSJxhu45T2rNZ3ubvdMCplW5rql9W8L
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(18002099003)(22082099003)(11063799006)(4143699003)(261009223027099003)(56012099006)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QktseUh2WVpuL1hoM2NjTmVSWG5rTVFEVExJM0NaQkJYQXhwQjZ3SDlUaWlD?=
 =?utf-8?B?SVFadDB4T2MvM01FQmJJU0NMTUxqUlFkNVJVQ1NWLzB4aGhaOFM1Vm9FdHFT?=
 =?utf-8?B?WVlrby9TK2JUd1dMcDM5dG1zUGhjRG5UNk9KWDJ1ODVFZkhVVXdlY2hLL0Zn?=
 =?utf-8?B?bFVDeElzUnovY2hRcEFlZ2FjQmNBU1FTMVhkMlVwK3lsWlpMSVhoL3hKcG1R?=
 =?utf-8?B?L0pjNjcwczNlbldON3ZlTk8wajBEWWtiK0oyK0pvaHlJMXhMbVhiUHRUc0JP?=
 =?utf-8?B?Y01WZHFnWS9YVjZHZitSU1NLenJ1dGc2UXdiTnV5a1F3eWtDd05XS1dPajE1?=
 =?utf-8?B?TzRXTG92M0xpRkZ0bTRxUnNPR1NnMkFFSEdiajJIRVl2UHJiWEZaNUxoRUE5?=
 =?utf-8?B?ZDdncWFybGhHSVlUeTRmRjdOU09GeFpXeDZkZFRnenNRaUtYOTlML3J4QVBB?=
 =?utf-8?B?QVdwcjJkLzhQano1cXN0KzlNdU1sNHVWL05UVWZ2TlU1VkZIQmpiTFYzU0tY?=
 =?utf-8?B?NU9WZGV1TTFPUkxDQnBReHNmbDdoTnhhSm8zUi9ESGFhUWlaT2RSdksvbWRn?=
 =?utf-8?B?TDJLakZoODJVY1ZtVEJGblRnYTJBbE1Wa1dNdTZJQVJyVUpQNG85MU9USklG?=
 =?utf-8?B?T0lIek5UUEJTcjMwRUl3bmF2MWVNbFBkdHlRMWdyclZqVjFzKzQySWFxNjF6?=
 =?utf-8?B?MU9LN1FsZTdla3E2R1c4OXZvNG1KdDFhc25NZUhGUEhoZjFSaks5TVBmOU4y?=
 =?utf-8?B?azl4aWIvZE1wM0NCbFYwYUJZd0ZZUkgzUCtKdnVEeHF1d3Nnd0tIeW53eklz?=
 =?utf-8?B?dEErb3Bsc1F2WU9wUnNXMVdYU3F4NHp6dUVFSUdQR3dJY0FWd3pIV0ZvQmx3?=
 =?utf-8?B?aEVYWU5Ic3ZUR2FMQURnWFdiamVqdEF0cWh0MWhrS1lMMi9rNytjQ1N5dlJj?=
 =?utf-8?B?akdiQkFkQU9zWi8rVExKeUxrMG5vQWdJaUg5VHduejJPbXBTcjNSUGQrZjVL?=
 =?utf-8?B?MHJZR1o4emRHTVBXS3dPQnVFbGQyUVBTZ040aFBwRWE5VUJTZlNodTJ1MXFV?=
 =?utf-8?B?YThnekpyOWliV0xraStKSWwzM051RjhFNU1sN1BSVkVzOE9xMEw5UmlndkJ5?=
 =?utf-8?B?VWg2MUdkbVlMWXkxeTZzbFdoRTlEK2ZzdFA5eVZ4aldTWm1NWTZCSUlyM0pH?=
 =?utf-8?B?RWl3aFpLUC9RZWZGa2JDMENUcExBK0hqRERaeVFPM21ERXU1enRTTTd2MDNO?=
 =?utf-8?B?WlNJbEM1ZThIU0gwUjhpOVFSdXArcXNybnYxOWtUdmtOdldSbG1GdjUzRzBq?=
 =?utf-8?B?R2hRT0l2YXIrL3VpQTdiZyt0SFZSbUVrbGE0Y3hrOWNBNEZUdHM3YjJ5VkNq?=
 =?utf-8?B?aFVjV3lmc2p5ZVJnaTBLYTc4Q2pBb2FxZlRWd1IwREhkQzdXSTR1MFhWY0ZW?=
 =?utf-8?B?UGNrL2hLcDBFMGJHRWNYdXZZTWRBbWNGOXJwMHNydlUrTW4xZC9zWjJ6a0RF?=
 =?utf-8?B?Q2FWVDJZTDQvREZRODZJSVMyMzRwRDBsdFlvM1NJbHlDci9wN1FCTGUrMmw1?=
 =?utf-8?B?NFcrVlJ0TGlheGJ3bnpZazh5bFB5QVpWWlFHcTE2MHRRQzlkZzRibk9NMk5G?=
 =?utf-8?B?MmsrcXJNMDArdHcramhWTnIxZGI4cGhtZ1dhVzBpT0RkaGxBd0sraVBiOWpi?=
 =?utf-8?B?U2V4cmpJNjNvMDB3MkJoS0lwY1RDOE00SWRDb3JDd0RzZDBnWHdadWpDcVp4?=
 =?utf-8?B?SkhzN0Jscmhnc0dOajB6WERzYmJ1dUE5WlhOcSs5OUFGQk1NSDJaY2d1V3p1?=
 =?utf-8?B?ZFZBWWtTNytON0IvUEJaZXVQdW83NWZKT0lRZU5Vei84cytLZ0dwcHZlU1pF?=
 =?utf-8?B?MWxwTEVCTzFvOEJuNU12TC9MMkVOV3JueGpFWFJnelJ5ajkvZk1nbFJabWFT?=
 =?utf-8?B?WkNzeDV0OHBCNkR4SzBlRHpETm1xdUoxWDZ5UksvME1IczZieUJpRDdwN1hu?=
 =?utf-8?B?NFpydEE5QkZERzZJMEtEMjZwNkJzRklEMHlIdzhzR0krdjNHbmtuanN5eUhV?=
 =?utf-8?B?czdYOFdJY2VZeTlQV0RUdWQ5SjRObnVmZ3VJUWI3YWxsdkRuUlFCcWJDa3Zw?=
 =?utf-8?B?R29yUkJhTHJVRWRvdzQ3c0Zua2dYTFl1K3JXemZ6QkFkbUFMdmkyWjhsNXJl?=
 =?utf-8?B?VTVhSmdWOGNUSS9Udk5ZVkRPTVJuQ2MxNGtXWWk3VDczb0c0VnVJbEhJSk44?=
 =?utf-8?B?RHM0Nm9iM1BvNmNtRmRPaURIaXcvVXR3K0F0d2ZjRGNBUUl6RDAwNFMzZTNT?=
 =?utf-8?Q?N6tW1UCqQaRgH7bB1e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b999c0a-c56c-48f8-2402-08df29f35aab
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:02:08.6336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdAVNyRjE4WycIucghLgtxZfA+D/NBJ8UkZ+Q8Ywhe69RGCJCLnvybZSqypZds+jWVOfBX58bsUer/YZl/KpWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6789



On 09/10/2026 8:21, Alexandre Cassen wrote:
> An FTE keeps the actions it must release in the array used to build
> them. This is a 1 KB allocation sized for MLX5_FLOW_CONTEXT_ACTION_MAX
> entries while a rule rarely needs more than three. Keep a copy sized to
> the actions in use.
> 
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> ---
>   .../ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c  | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
