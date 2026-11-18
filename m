Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795000459;
	b=2exwrTTLczwRLOspwWK6Ksv0TWk7qKke8lFKYSL7srXdWE5BR3u1RWz7HnVppf2HW+RL
	 IL+zvx+K38tP/xOak4HoWZ6FSsUCPN7fD5zaU5ln6Vtam4NWr0FLE7BkQBqKA7O7aHsl1
	 a7v4gSwmeI4AaTKB151VVJswz+GIghveAiy/91Mxq5qFRmL7TjX8/hw4xzt+DL2Q+/D9/
	 hHlUY/yscMHhPtedkIAbHNp5tUMUHecxpiTDMz7FxoYFmCiKmgRFhU3M0xkocE8ZbPtQM
	 3v0Q85E/z2ME28eMy+x4MLgDfPZCq8eFZzHsxXrpuXagROUTIpw93jCU3UeUvOqX04A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000459;
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
	bh=SuhMM5tP+Ue3jEYH4yR2NPhl037xN9ikemfgGprro5s=;
	b=cbEw7ZEW7A8o45hSQAkYF1OYp3ncp9SsU5mm1mVcVFS7vvqHFcjN4lHlqNAEO5ROgPPA
	 lk5RtQckNrPuYGbNUMProok11yVXyKUQZAgJYIlPIfZLzbZJdtzyjn+fPtSxxP1kkNCPu
	 JfILH8cUCCeQnbr7bTROkEibcW/Z2Wt/nm8/ZpE/SpKfhDgatIMtSBzPtg6Y1GvWAYPRH
	 Z2Y+EElAoknsuoVeCMw0YYdU00JP+I8JxeMBu2j5B3tP+bjWbC9Lr3FZSkEKJ6NpIs6fY
	 AZU300Vwza9sj/RWjZaNtitQh8g/CdGOYx3/O1yXw75bmV/dM5r5sC7NPZUACF4wtIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z21eXcWX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.34
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D027D606A31C;
	Wed, 18 Nov 2026 11:14:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D027D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Z21eXcWX
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TX3HWKWZ2k8NUIwIt/66aWrVyL8It1wQcvENUEv/uepI/OOJfLms+yj/4sA06tr0TVHV1WaTX80diSzUbrqOuoaswEYOElFk2yNHws6EpBpw+yLrILx9ND2EYbzxKtIZlsKr+vdeH04QnZYzdshCO9PQnAhCveKP0iR942iwpqsWvuDB5+y7/EMrQ9pC/SiiQ1jklZjJnqur0NXyodiwKw0OtQMSAyEaz/Rznj3AoDmf7xMbG5j6fNZ3Hf0gjB4p6aYhj31g+pKEdd6MwR2YFPnC2P1iSZSkZ2t7MT2vwswkb9SFLKdXOSqK1PYJ5lkbc89vjh0npO+xuW1erFLblg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SuhMM5tP+Ue3jEYH4yR2NPhl037xN9ikemfgGprro5s=;
 b=nberDHYPaw/rxN0ZnH8eLyeC5AEiHOUTrphjKsou7xFMeFMqF0+AbaE+rE+n81npv/iFYgtycyfAJ7CXS6DTaa3nM39KQe2JVNGmKMMY6menolBqob68BiQQFwlgVYoFhKWYmIfbdVlOPAacw34duoD3HM19sLpXdlYUqyJyPiyLpH074zZQeolGmyvugu8Sk7i+cG7HOcjhq5Uavq7klyy0GVCqx8PJb+D8FVq2VDEaCStOm5vdSArPcB+xdzo8USRn6YBBoAdszXb/5IS6x4a+Y6+JonkYbD35z9iInQc4zyAOgTswzbQUZ40lwYkUcEl0SxFrJpWfrwFf4k9vKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuhMM5tP+Ue3jEYH4yR2NPhl037xN9ikemfgGprro5s=;
 b=Z21eXcWXmKTypgeZgYFm75riYUtO4bG3SADVN2AiuuSBVdZjvDX2ioEu6MOduHWyoQj8npJi1NBbCVA0sWn1ITs3zmN20ZiIHtBACYK04TRF3iFmmxnCdFd13zSZYeFIXfTERjhUIgzMdNJs5FXlkQjzJLQuRhlmLclwpU9ZylIaxLDipFATnftGNAykNzgjAdDpFwML0r30RAIhvOwbjnpaX43yrVUUP8OklDisAvWuXCYWj7hKxesYKEpPBN2B19LWQ05fSF8iDHVt2uaPHmmhj7Z681O+IpfAKcfXxhYp1VyfdH5ATpW/KDF261kZxcqeOvsEKEjmIKvRo+VLsw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by BN3PR12MB9593.namprd12.prod.outlook.com
 (2603:10b6:408:2cb::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:14:14 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:14:14 +0000
Message-ID: <773ac747-b58b-45eb-8072-8f048da3c54f@nvidia.com>
Date: Wed, 18 Nov 2026 13:14:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v1] net/mlx5e: TX, Do not open a multi-packet WQE
 for a single packet
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261117085036.3138779-1-xuanqiang.luo@linux.dev>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261117085036.3138779-1-xuanqiang.luo@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0027.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::11) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|BN3PR12MB9593:EE_
X-MS-Office365-Filtering-Correlation-Id: 1099ff59-19f3-4027-5773-08df4565140f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|261009223027099003|5023799004|11063799006|56012099006|261102123227099003|261021121427099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	WcSURO3snV//DvC51eSwX8WFm1JXilBTCXnJvBSm2DO8sgheSx0/QDCjC23gmbzGOMJ2CPw71IWM2CMIVlA9YLyRNBC1hKE1eIJfHDtHtV7re88vOa41xkXSmOxx/M4NV6oAH+keMCZmdEpGhJl68+EuYBCF8xaGyd8sGNgM54lFJ0YT/2Us36XK+x4TcpeFtQ2ZTCLgvIrAviQGRgAtl5HFMm4QRRfs62DxnSsT5EHyYspJHemGRk2qKx4p3+3DwcVkBraWhoYyJrNh6pdd++IDnrj9jY4Vg5Rxu0T1J4xOwHUT7Ug+kODOzTQMGuAqzGiyR6pIC7edTIJfhsNKNNNp2t4WInuC9VtqvfkIVlbnyOsdavaAVf7YS6F/yjcun2GFquVHCmBXA+fGejDdnxuDcqY1WcQYIRN65oTR+T9NYQgCB4H2mz2f8lRAvn1SEFq0bfR+zZzDxOegXxDJcx82EXzaN0REgi28mT3/39LfoDbGjyHY42PiV7NAeG5u0BgflvCUyQwmyUFKg2tYjCu0bWz5/KKdd1aakJTihdgeg+vIUGOje7eZzx7ok8TDLvT2AtbW8LKafTnrjY2TM7NfNP88cNHimtlLxKHwhWkUFxXkLCIerOZkCDsy+CFX3tjhsVn2bev+i02qFS5rJSmiWUDjRXDAouknrFvQkaA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(261021121427099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGVxekVBcmQvOEFsbE9EWWpkSEF4R2tKREF5TkhNZnZGVnNOa3hrSVZxZVdM?=
 =?utf-8?B?UC8yT25ZOWJPc2ZvZDBaU0NzdTFzL3hGTFM5VC9rOWZhbzAwMkZSQ0ZSWS83?=
 =?utf-8?B?eWFOVFpPNkl6eDlaYkl2YXFudUs5VktwVTNBMUo1ZTFsbHM3b2xqcDBFZTQ1?=
 =?utf-8?B?YU9LTFozaDh6SUlKVGRMRVlTaDlsRHFNaHFTc2tpVFI3UlBnbGt0d1RpZWt2?=
 =?utf-8?B?bnlmcCsvNzV6bnJxRDR3ejdGOUFNa1BEb24rSFlFUTZKcHdROXVYcVZXWmNk?=
 =?utf-8?B?K0tvd0k0disrVTkwZWw0OVNJaVdFVktsUDJ0dzhhVWQ1U2xDMjB3WjlhWFc4?=
 =?utf-8?B?T1IvejU1K3BITnk0cVY0b2VRWTZQNzZpUndxVWxIQVhDRnRzUFpORE04eVZD?=
 =?utf-8?B?ZEcwcm5lQzVnWE11akhLV0wvMSszbmtyaisyMGtqNWVPYUUrWUJZbmdrUXEr?=
 =?utf-8?B?d3RibDV6c2M3bEJpVCt4Y0xoWkZYcjdwbkFETXJTRVNIZ25aZXJ1NHVEcS94?=
 =?utf-8?B?WVB3NUZxS3ZGWU1CSmFiTk1YUG5aN2JGcDBGV1kzYlYvVTI0TE9NQzZxVlRH?=
 =?utf-8?B?WHk2TXErYVN2eGtwYzVZa2ExUFE0K3ZwSlIxRmRUYWxmVXV5Rmp0enBJUVlU?=
 =?utf-8?B?RTFxQVRGajBFb1o3bG1mSFlWYVdOY2szOXhwSGtmMTJqK1M1RkVFMFUwYzJr?=
 =?utf-8?B?U3VXY0RRRmRNVWxVMUxGTXArKzdNWFJueWFycDI5Ti9KUkRTMVc1L2htby9u?=
 =?utf-8?B?czUvQVBBY21zT1dNTTdKajh1SEVBV1kwUGdQRUhINFV3ZUFnY2NtcE5NM1c2?=
 =?utf-8?B?Q0hvYzYrVDZaREN1Vmt2dENYMldlNjF1NnFFWHhxbU52aHE5RmNBTEpMUFgv?=
 =?utf-8?B?d092N0cza1Q0enRSSzhiM2dJdXVoQXpERitLWTY2dDMvNUYwTzNpVCs5V2dw?=
 =?utf-8?B?MXZHOWVhU25lc2xpN1A3UGlkZ3QyaklFS2wrYnpBLzFCQ2E5ZFdjaUFSdEcw?=
 =?utf-8?B?VlJ5ekFIL2NER293Qm9BU3RjYnhHZGE1bUQ2QXBWQVB5Q3lNQW16Z3FCMk9J?=
 =?utf-8?B?RTYwcHNYOE5pV2ZudkZoM2tFK3BjMFRRNzVPTmJHQWthbndjZmtBU1NjRlVW?=
 =?utf-8?B?T3FtWElzZ2ZHMHFmeUNnc0VpNnhlVWw4Y3FRZVZVenNHK1E3Y3ZYOGlJVGpZ?=
 =?utf-8?B?S09qNXpSNmIvdGIwcFpxUXRkRXNIdWpyM1BYTE93N3BVRmozVEloS1FDY2Q5?=
 =?utf-8?B?U1kwWXhEUzJnOXRGUmIzcWc5NFlqclZOVFhKbzJkOFlOdFBQL1doUTB1Nkps?=
 =?utf-8?B?L1pIVG4yQ2psZmZoSWN4R3RvODdZMkhPVzZWVVB1NGUzNnNTN1FaSjlnZi9H?=
 =?utf-8?B?bXdHNlpUZUJUVjU2eG5PWWpEQmZubklJa0ZDRjZ4NldNZXZLQlVuRk9EMEJt?=
 =?utf-8?B?ei9oRjczT3pkaGppKytZSnVabmpCVXZ4MHhWK1l1eUhzRm14Uytqa3BqVUFa?=
 =?utf-8?B?aGEvdnJZSmVUa1VXOGJYcmF3RnMyb2cvS1VZTVpFcXVaa0lwR3lCaGcxVWFG?=
 =?utf-8?B?UzY0U1JUYy9oRmhMVEdYTzJqOFVkako5UGduSGRFalMzZ1NQWG56Z0htSFBZ?=
 =?utf-8?B?aDlUd3E3RnBvK1ZjZHNtbTNRQVY1K2FvTGNBL1FDNC9FY3BpcWY1YXloZ2JD?=
 =?utf-8?B?TGZ5bnRWYUxLaUdRdm5TMGtRY2RZNlFmdUxmS3VBRHowd3dHa1lKUk9DeEFT?=
 =?utf-8?B?QzhXWit1RmkySmgvamZiakpQQjJTbEhCUVpPTllSUnpUY0hiMC80ME9ic1pL?=
 =?utf-8?B?c0pwS0M5OFYyd1Z5N09WUWN4ZFhXM1ZaMlBzdVd1dEhkT2ZHb0o5cStPY09S?=
 =?utf-8?B?WlRwZUMwb2VYeWZ6WjNDUzlWc1ExY0dRQlQyM09yak41TXRCSU5meXo2STRW?=
 =?utf-8?B?ODZhUTBURXprZ1RlWXJmT3Y0ZDQvdGJqR2JKeFo3ajNGeDFjbWZqTTJRSlBm?=
 =?utf-8?B?Y2lzbklZZEJMN292MmhZN2xYRXJuZnNHMGVEeFNTVTVDTHpWS2pWV24xL1pa?=
 =?utf-8?B?LzdDeitvZkdDV3d1KzVlYlBVREVITXJheFRVSjE4MzRXaWRSK0hBcmpTUGps?=
 =?utf-8?B?T1lKZEZHaFhQSHJzVFpuUmtRc1AvYW8vNWxBNHROeU5JbXpGdVlkYktjMHZL?=
 =?utf-8?B?UXNJZEdHRHlMdTNVaUNGOGNENVg1VUtIbk8rZFo1WTJVSS9wOE5wVThyNzhu?=
 =?utf-8?B?WlhPOWJQbXc0SDVYRWJkeW1XNlR1S2NsR2ozbXFMUWxOVzg0cVgvTGdaeXl6?=
 =?utf-8?B?dkJQR0FLMlZ1d3ZBMVVENzJRS25naTJCQWZkdGsvWmRmUllpQUlZQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1099ff59-19f3-4027-5773-08df4565140f
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 11:14:14.2237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJoEcJKpBu+u8hi0TFXYHTGFrN7FSQYTfdZxsJKgK79ej2ah5Kqsf/E+9str0UGpyaqYL4EvQx+r+Xbb0nZEIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9593



On 17/11/2026 10:50, Xuanqiang Luo wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 

[...]

> @@ -678,11 +679,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>   	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
>   
>   	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
> -		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
> +		/* An MPWQE for a lone packet saves nothing, use a regular WQE. */
> +		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr) &&
> +		    (xmit_more || mlx5e_tx_mpwqe_session_is_active(sq))) {

I'd swap the two conditions:

	if ((xmit_more || mlx5e_tx_mpwqe_session_is_active(sq)) &&
		mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {

A lone packet, which is the case you optimize, then skips the skb 
checks, and it reads in the natural order: is there a batch to join, and 
can this skb join it.

Also, it's be nice if you could test for traffic that goes through the 
stack, for example UDP_RR / TCP_RR and a UDP stream with netperf, in 
addition to pktgen.
