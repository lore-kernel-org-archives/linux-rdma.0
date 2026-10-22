Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792669135;
	b=bkmeqVHQ3wijk722fGL0LBPBBVCY+RpOKtJCgsTZJj77RrN5y3nShXtMHFcAF7jc6NlO
	 67PC50aZEs4OgzQTh1Ve1I7RTgDM628+ChFA6ZnM8mUeRWfXjrpu/TuliBacCch5+cAq5
	 txQajZCbQzcdkkES8zY0hVwN03C0MT66KAWEKYiBK9wEt99+6COwX2g4nAGrPH/8mIcZy
	 OU5bN1vSO67pg2XuWDpeQLE4wOPB9QPL9QqpmO1HhBJV885/xkHQLJCIidhf+sZ+/sXNa
	 vZgUV71BUtQxbx1T6lbWfNui55NfxsisbR+XBzu+c6FxYl/cfi+v0Rlxpr2e1Lt2WRg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792669135;
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
	bh=/wonTGd3XQlW2nAWIkNg2DOZNRWEezYDaLQMsyW+xIQ=;
	b=B04cy+Mrz92AosnWbihz6ruDfhAvZTvxL6zys6+C0YCxfD/hgwbPLbgwWH7RHtl9EjfY
	 wyhXbYwXVuu1MQdbjL2rbEw+DniOCg04DQQbllkYHhEtoLnTtqAQsl9PqN+Tl2ZES4CL0
	 N7HSPn5LQKW91UGQMTrvRvZJv6sLYwiBg53AcbgpV8riDI5chs+Ts5+w9DGzx9/ouowUh
	 Pa3Oe/Mlyti+4CYUOYVirWUUzc+Gaymsqz74F9xi7CKb/JUfGQ7XJnpVjZGsYS9ktXAVt
	 wxV2sZ5PSIJ4vTkxwaICkQpcV89bWDcdMg4rze2Y6EQQyEtD+4EDBqRdYGd/k0+cuZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=A2d9xKI5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.54
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013054.outbound.protection.outlook.com [40.93.196.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7F606A319;
	Thu, 22 Oct 2026 11:38:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68B7F606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=A2d9xKI5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMdR5nDOOglL9nt6yqCdbyuFmNq74lVnaOcObh0lQFd/4nowJA9I5HBZyQoP67DbU5GnASND1eWsK/pa9j0uy9jPBkeU0hm6u32XkanXUArkTFNX4g9cca+m0Zi32f0PQduV+3e9b+QaGZeShuf0ia1xpVJuUdyZLDS8jhHLJnQXnmTvkjcHwXhD3VRtLFUCHhvFSNnvnTgmtQnutJzp5KOTA0bSfMABdELHAbjUDpdP8AW2UKFN49c/2PBGVpQ896LF0IHCiXZ52uhQgQ0Dm5vUa4NE8rG9tOELXXRAVR/XM582+fbk3xUYtjcfeOUuAUxrVC/2/29FIyGj29MTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wonTGd3XQlW2nAWIkNg2DOZNRWEezYDaLQMsyW+xIQ=;
 b=CFqMwoEfUS1Iw67BBbLZWrrT/7vAfPGwXEkPIuYtVnXoGDdVnSAaSp4/deoGNgm933l4X3puoLcYFWZqAq6Q+wpj0hFUePwKiyc2caF5IH9bGhSXWfBcnW9Nfbq2IudxCA2lMuExRj+NPje3bNl7y4kvRqtHOPLhhQTY036TBiMJjpI6/t7V2QIli74y0IJVqblbZgsT4UvCsmnXGpWZdUEFwtyG4KhpjUshbQzNOjXPXKkfkyYZuLk6L2mTqVWgxgvRJ9GYL1UnJPNGRggevtJ9d4Nm4E3xGu4DJ0EYo0PyQY1aoZ1LLV0FL2g1naDCazjV6pn5L1sQcMTrCznLXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/wonTGd3XQlW2nAWIkNg2DOZNRWEezYDaLQMsyW+xIQ=;
 b=A2d9xKI5BaE6bKnqzOT7+y1t5DXwnyXU7TtXpb2k3rd/HNBNGkmfV6QB8IIcLoQIhPDija4XGItFxfJh0SITndeY4mSZH8AVakWhn2AUcGZ1UzLkMGEC2HOCizE4MVMDwhUf/4uJrKaC3n5Cr9w5Rr8FoOJos32PifgbzkgUOk7eyVAyRxaP/U2WM4iSd3vX9KAsS8YQKgWsfM/ubhvtRF+vchrDGk9JJbAEe2O+vgpzzCHZ6AtfqB3MIY1y1b4TgGXFEhRXJArhj8G8TaEoH3h0SSf2NZbBzUq4I5flqkieGPJPBoYpQxFasB72eJDwiCYilC9R5T01i0rvvKP+uA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by CH3PR12MB7572.namprd12.prod.outlook.com
 (2603:10b6:610:144::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.14; Thu, 22 Oct
 2026 11:38:51 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 11:38:51 +0000
Message-ID: <cd140948-317a-49d8-885e-0ded451195c6@nvidia.com>
Date: Thu, 22 Oct 2026 14:38:41 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
To: Josef Bacik <josef@toxicpanda.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PNYP287CA0058.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:23e::34) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: cc338589-6cab-46f4-4edb-08df30310b5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|261021121427099003|56012099006|5023799004|261009223027099003|11063799006|10067099003|18002099003|22082099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	XFvoZy0Ft+ky59OFr8+KfJfG8WJ6zeg2nJwT5IqqsdY/TO8AAbq1xuD1h+zvRj4s8yoGvs8PYpgZR4SdyVlThu2F+MPColYNBgP1IP8y+uynncEhkMo/F75p/K3AYPA+MrgL2XS7k2jDLJwmtnk78xzMHy2j3mLK6sgR+VwIAadN9dkub67V31TPFTd/y/5W/IezTtOIuXnHJCQrODnXsJ9X4kmshsK67rDPFE0u9QCOCbkA+xJ/T50vm7LOahNhdiD/NmDsGX2HI/gkoLdNA85Ohud+vBfFHIcCQIRildNTMGirkms0cK89BwEMr6jHalZSqjCTu+8tVA1IEkr6RLgDNqfqeGZf0H5LE6rPEvU7lrENzcuCVaZaqv7k/6tDQnzJ2gV+fgfgEC7KJcwQmmgErJvDhiWADBXqJuueYP0uAKG/leMnnrROEPiw2A3dkwsR6hItOTIRncL1hwn9hu//CC6Ysh8IaBJOlf6mj2Vk87OnGaJV5cD4CB0ZBvFQkg71aPPRiTbD1h4L6uZdxmkWeHbZwL7DdI8/icACczC2oRxo8WOov2xw1mNWgksq3vmDrTlyyB/pENtz1zVTq952siQPfs5J9nZPPBVKU5x+empxZSaYRzQQVLpSd8CSQOSyiSv9Z1tNj1Wh21N1nwGhAg9j0m5AdNT+1SAjNFM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(261021121427099003)(56012099006)(5023799004)(261009223027099003)(11063799006)(10067099003)(18002099003)(22082099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHUxYkF5a1JRV0h2c21GaVVUZGl6QlFiR3ZTNWozUkg5Nnl5bzVYeFcwUWdm?=
 =?utf-8?B?dkJrSTFYUEFKVmhMcEpwWmNaOE9iazZIUHFXZHdBZzlMMVNkWHdtVnd2TmRZ?=
 =?utf-8?B?Z1ArS3c3MkxjTGN0eFRveTBCaWtNMW1aUDVzakF3K202VWNiUHRiUzF0Vzd5?=
 =?utf-8?B?Y1Y0T0VlMnZZRTFjako5dGtFMCtNaEl4eFQ4dGRIZEJzZ0pYWFUySk4yNnhS?=
 =?utf-8?B?V1Fvd0ZWc1JZdytQdURCY292MlM1RUlYOHBwcEZCb1BLeDZwUlEvZ2VrY2li?=
 =?utf-8?B?OFV0TS91b21MR0VPN1RKRmIyTW9idHAxUFZ4ZTMxaVlIWHJuK2k4TGt6WkRi?=
 =?utf-8?B?eStKQnlXTUhmUVJpM3VQTjI2b3FHeTUrZWxqMHNYZE5WK25MWnJpTHdKdDFN?=
 =?utf-8?B?ekJJcTNabTd0TFFIUlR1YmFCQksvRlQyL3NURzk4ZGIwWTFmbnNETUlDTTNF?=
 =?utf-8?B?bWhoRXhhdVB6S0tnUFlKemNEZWVMNjljaTFiY1lYTFU2ZnlSRXZ2QWl3Nnhr?=
 =?utf-8?B?NUF6dXBUdVNLM1N3THFnV2dmZmtkaE5IRXYrUDBZcUZmNWU2VU44ZkpxZ1pJ?=
 =?utf-8?B?ZnRIZk1oL09RbmJjcWxXWmhoME51TmtXa1ZIMXFnRXM3dUJVYm92Vm92QktW?=
 =?utf-8?B?NXFkMkx6emlIZ2pSL3ovYUQ5VlFWeXNDMnNvVTJxaXp1ZXV3SFptVzVoREtJ?=
 =?utf-8?B?SU5paVRqWUlSbU9qNDU5M0VlWkhwK2ZIQ1RKR0d2aCtkQVQ0MnJ5Q0d6bEVt?=
 =?utf-8?B?ZC9OWUgyTU1oemhXUXlnU2NQaUI3T2VIeGFzQllpNUt4Y0RMemxDNnBLSEFG?=
 =?utf-8?B?V1lrUWlDUHVOTjlVZUd5bitoNUx5NXkySlgrMGRaRWFBQTlQUXJuNkhQMGdx?=
 =?utf-8?B?RmxES05aQ2VHZGI3U3N0aGxNMWgweEVERWJBYTRWN1FMNFNQL0Z3UXNnNkxq?=
 =?utf-8?B?VWFYejVsOS9zVDU3eUxURTFpMVlyc2lmd0trQm1VMzRJL1IxK1dEQWNqTFVy?=
 =?utf-8?B?Wk13cERGYm8raDlJbXdYRVZmSUdaQW9Xd043ZjZFaEVsSSs0b2ovZ3NLdit0?=
 =?utf-8?B?eGpCclBKYzdOZEJlTEk1V090am81SnhBTlRJckJQTTBta3NhZmh0S2krN1dB?=
 =?utf-8?B?cUd4WGJtOW9QYXlmSVJoOWtvUVp5NkkrZUszVnpnZUhhcUttaDdkVFQzMFFF?=
 =?utf-8?B?a2MvLy9qdXdFSnJhRU5XWTRUc0RpOW4wbGtXOFVWUUUzOXpzZEdpQ3ZkVkZK?=
 =?utf-8?B?NmlyTnRMdUNFNXZwbVltMmdGNG5EWDM0R1duRzZxN2d1b042YXJFa0E5azhp?=
 =?utf-8?B?WXlyMDM2K3VtMWVQVnFmQUcyaWlRcGVHT3dFMzdnc1JyMldsTWN3aXRldkxo?=
 =?utf-8?B?OGl4d3VCS2puczlsY2wrRk82d3Y5Vy9ROFZkV2Rta0pXWVZ0aWVZTENEY04w?=
 =?utf-8?B?cjVPS2NrcXlNYmVXYVQrVDFNazNJS01IZVVFajZLZ1c4UDhaQXdmd0dVdFVM?=
 =?utf-8?B?U1UvYUpZYldYMkZRQmpjZUdZUDYxZU5ISUFyVGhjc3pjRzNkTG5oa3N6OUt6?=
 =?utf-8?B?bFZVbTZjSHg1dGZraU9BRWpLblZyNTdJWDJLUkFmNTZEU2ZBQnl2YzJUc0Rt?=
 =?utf-8?B?a2wvSzZUa01rdHNZbklEZGh1b2dTTlgxeGx3a3JmUnFaUnJ4aEtRcFgrL0pI?=
 =?utf-8?B?dVY2UUR4aHF6SjduUTQyalo5cE52Z2YyRkl2bDNzMzRXM0dnNDAxNndhS0V2?=
 =?utf-8?B?RTc0aU9nSFJBUVN4QTZiS2tUZXRzQUhRbEJMU3ZsR0o0MTdDVDd4V2JHWWlm?=
 =?utf-8?B?d1lqV01hUnJFNThkTTRTL1gyTlZDaThjenRjN1BidFgrTWg3cDFGNHlOM3M0?=
 =?utf-8?B?UC9naCtwUlg1OWtIUVV0REtwZWtROGhLdTFmQUZjc2xKT2cwM2U3aFhKUy9E?=
 =?utf-8?B?WGJzZUw1WVpWMjYwSE1HaDJaVU5reVY2OUg0TWRWZnB3aWZKV0d6K0FxZHJ2?=
 =?utf-8?B?M2g3VjR1aG45Z2piVEl0MTVKT0lJdU5nQVY2bEVpcWdWbVhDb1dEY3RHdmtF?=
 =?utf-8?B?bUlvT0VQYUttODdEU1p0Yk43T3pja2sxUG43QTJTYXF5M1dIZ1VXYVZiL0tQ?=
 =?utf-8?B?TEhWNmNQcEp2UjBUVkd1UUNoWmVSZHdiZkVHNjUzZ0lXUll4RkJ6YkpaUzVz?=
 =?utf-8?B?ZG9YVUhhOVYwY2FaVCsvQUtWQXlzV1ZjYi9ZZitPMHFMWlJJZVR6MCtRTVlD?=
 =?utf-8?B?Wm1XZk51ZXhNbG5zZGdrSDRGK0pZd3pFaUh3d3FJYUI1QlVqaXM2bEdaVjdn?=
 =?utf-8?B?K1M0WTVUY3lkaDI2Q0pGZ2hvL3VEVFZnMU52cGhjK2d5R2E1enRhUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc338589-6cab-46f4-4edb-08df30310b5c
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 11:38:51.2830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVvCxUAcruDATTlJBQH7d0/+zeNrZao/AMLSGwnfmErZXJ09GunEGTY4B7cLrNWKeIsAiKnwYI3RAEvmsK68cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572



On 21/10/2026 20:37, Josef Bacik wrote:
> With threaded NAPI an mlx5e channel can stop receiving when a burst of
> traffic ends. It stays dead for minutes on an idle machine, while the
> connections hashed to it time out.
> 

Hi,

Thanks for this interesting report and patch.

> When mlx5e_napi_poll() has more to do, it checks that it runs on a CPU of
> its interrupt's affinity mask. If it does not, it takes the affinity to
> have been changed: it completes the NAPI after at most budget - 1 packets
> and arms the CQs, so that the next interrupt moves the poll to the new CPU.
> 
> A NAPI thread runs wherever the scheduler puts it, so with threaded NAPI a
> busy queue takes this path at nearly every poll. That costs an interrupt
> for every 64 packets. Worse, it counts on an interrupt for the CQEs that
> are still in the CQ when it is armed, and none comes: the next event is
> raised by the next new completion. While packets keep arriving this goes
> unnoticed. When a flood stops, what is in the CQ stays there, and is worked
> off one poll of 64 packets per new arrival. If the RQ has run dry as well,
> arrivals are dropped (rx_out_of_buffer) and bring no completion either.
> 
> Seen on a 50 Gbit/s port (firmware 22.47.1088) with 63 channels, threaded
> NAPI and rx-usecs 64: a CPU-bound task bound to each of the 128 CPUs and
> 32 Gbit/s of UDP in 8 flows for 7 seconds, then both stopped. After the
> second round one channel had 0 polls and 0 events for 150 seconds on an
> idle machine, while TCP connections hashed to it timed out and
> rx_out_of_buffer counted their SYNs. Later arrivals took it 16 polls and
> 1018 packets further, it stood still again for 14 seconds, and another 93
> polls and 5917 packets emptied it. In a longer test 22 of 48 iperf3 runs
> failed with "unable to connect stream: Connection timed out", with no ping
> to the same address lost.
> 
> i40e and iavf force an interrupt at this point, and mlx5e does for XSK.
> Doing that here would cure the stall and keep the interrupt per 64 packets.
> 

The arm doorbell carries the consumer counter, and the device tracks the 
last index it reported an event for. Arming while CQEs posted after the 
last event are still unconsumed generates an event right away.

The affinity path depends on exactly that, since commit a8c2eb15797a 
("net/mlx5e: Stop NAPI when irq balancer changes affinity").

Event moderation can delay that event, but not drop it.

So the root analysis doesn't match the mlx5 device behavior.

> Fix by going on polling when the NAPI is threaded. With that, 8 of 8
> rounds leave every channel alive, ch_aff_change stays 0, rx_out_of_buffer
> does not move once the flood is over, none of the 48 runs fails, and the
> interrupts taken during the flood halve.
> 
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> I hit this while comparing threaded NAPI with softirq on two bare metal
> machines.  The runs in the changelog are from a 7.3-rc5 based kernel, with
> and without this change.  The patch applies to net unchanged, there I've
> only compiled it.

Is it a degradation? Did you have any "good"/working version?

> 
> I don't have the PRM, so "arming the CQ raises no event for the CQEs that
> are already there" is what the counters showed and not something I checked
> against the documentation.
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> index 185105606469..3142e90e68ce 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> @@ -207,7 +207,14 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
>   				rq);
>   
>   	if (busy) {
> -		if (likely(mlx5e_channel_no_affinity_change(c))) {
> +		/* A NAPI thread runs where the scheduler puts it, which says
> +		 * nothing about the affinity of the interrupt. Completing here
> +		 * would leave the CQEs that are pending to the next interrupt,
> +		 * and arming the CQs raises none for those, only for a new
> +		 * completion.
> +		 */
> +		if (likely(mlx5e_channel_no_affinity_change(c)) ||
> +		    test_bit(NAPI_STATE_THREADED, &napi->state)) {
>   			work_done = budget;
>   			goto out;
>   		}
> 

If arming really doesn't raise an event here, softirq NAPI would stall 
the same way when the IRQ affinity changes under load, for example by 
irqbalance.
Was it seen there too? I believe not, so it must be something else 
causing the stall...

> ---
> base-commit: abeacca61eea4f6803df4a595b656ea45c2d3249
> change-id: 20261021-b4-mlx5e-threaded-napi-stall-7d0a14c7674d

