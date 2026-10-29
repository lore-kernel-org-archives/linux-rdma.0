Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793278334;
	b=P44rH5KQBhkfCeaknltPpvwQtemLrepzyUzqoXVF52l6UdpIPnxh3s/WfEglpGGg68Ds
	 XTV+9r30otI7odANT7MWLMi0Ue65AooJNxdSjNmXGIa5WZPIRHrvfpDJTNyD8h7QTuqij
	 9AhIAKQA+05pNyul/kbTpH9q+syCcU8pCspSqtWcUuZ8Z0rgSH8M++kkuVwPePSe6kqQX
	 0cPiIyoLiBZ+HNGq6ZXfLab5k09nWmeq3OWNZ1iwgs9EwkuU1VBqzJ/idYMG3yvXBLBSX
	 7jBgL9SAZvaPTWqK1BC6KxhUkBGlarjw2woP/Ty7S8/Meew3xZ1VXME9uoJxGmleeXg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793278334;
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
	bh=Z4bPCiVHaDq5LGf017MyoLCoqj2e0B7lCXHI5kLxMjE=;
	b=YcHcbNqVWfxuGafkmvP16sP5Z8MO7joZZ2XEkbQfCDpWHl41AxMYhF+MkWCkNQbkjcwo
	 zv5R3HHU05pmiERbz6/wZjgwinm6hwo7qS/ohuFD3AGhdWlrvC2mYl8lTy7iR/ENnNyrz
	 JIgTZngKFbnYr8c9zjPJIjSLf3dB8b0mCzjd7thKT7YeaszOos2PbUO6IsRtDc1i+EkzA
	 ubtGh+Tv1x8SXR+idoxUKcpC1Zw0GOHq4ATL/+GUbnPCx7LDaNp8SrjDD1V64uGgSEmuD
	 pYFO0HZ+KtbBI4tPuhKg48R3vuasPpO4iSQxsJawh4mWKm4gt050EcLG6qhN86W8ehg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DHe7m8gN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.26
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012026.outbound.protection.outlook.com [40.93.195.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B798606A31C;
	Thu, 29 Oct 2026 12:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B798606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DHe7m8gN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=womfWGAEUofwfiDU6cAZsKi5HcisdKSQnXmuwhS4ClQPHFwDKyccYopdrKoXv+gqP3vUSFYEwBv+RdhOppjqSXIk1oqZcn37xEblnitdossSQWg7CXEpuTXLfrOLBwQjcBWgQIgYUhFlpaAB9y2T9Si3NjJXP5BtFQxkH/xmxnqbNIpsLRgjMYu273TsbdPFElNVjBpw12aaYN4zW/u54WfhE3v++zSUNj2Cp5uH5ad3BQC5at6EfXAeuPyYGGEsWD2J0vaOhS5CvT1IFOsJeWjcZEh79wzh856IS8qU2LlEdur5VWVbM1NS03LiOHoHDxc0jqjjvVV21Pg8uLHkkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4bPCiVHaDq5LGf017MyoLCoqj2e0B7lCXHI5kLxMjE=;
 b=eN5gU7O8NXB8JUu9pMIQS0IRjjNwpTcwhfPAwdATn/34Kg65anT2Wdg6ijfnc8+qC/jr5V3Eovw0xbnxML57ok/KrDTqPkydoJzSh9k3MkuhfAyfeJTCB43DZwT4wuwckiz1dEjeKpHGLYWFegkMYCgVLSTnZYmoZ07RrnRsLwqQ71Lp1MWF8NB0T4eOoauPsn7VuROfb1XTNxDupXIN2pARze9+YZYBgKbOlxZzrhN8vYfDVUMFf7BiTjYaVgLeAcwyGnFPynQ/CoWSnyacQrewIhhV6VrlTfEygC+PHDNBemBSk8HOh2kQi52/qzaGBMFh97MHlj/gKAo6D+j5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4bPCiVHaDq5LGf017MyoLCoqj2e0B7lCXHI5kLxMjE=;
 b=DHe7m8gN0iOc+clbKwYwJh+jarfTJu43nAcN+mqXl5TQmd4jm7mJJKyMTgcwrAA3WX7UcyzNfz0QX6BC141g/jMts8EhnQEf5qzPyEWg2Qmv0/4pmbMa874IW2yH7F4DxF4CHuq08E862Yo5hHX3jtFw5HV/6jltZ50G0G1biCJ33P5g16GXP05naVRju+wz5lvd51xA1rgEEP5p8y7xglSk49jgd3jDk/WaHe1Ywn7tPv6SSuP+3qnV4IFd+4cgkE3OuIz7HbJo9BFbONzN2QCrvNeN+YW6RKxf9khQGi0xQNDKRzW6uungp9ueVMNraQUnhVerGq/veZEDbGwasA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by BN7PPFABD533732.namprd12.prod.outlook.com
 (2603:10b6:40f:fc02::6df) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 12:52:11 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 12:52:10 +0000
Message-ID: <1a26c186-bba5-40f9-8cd9-3967b2b268bf@nvidia.com>
Date: Thu, 29 Oct 2026 14:52:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
From: Tariq Toukan <tariqt@nvidia.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jakub Kicinski <kuba@kernel.org>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
 <cd140948-317a-49d8-885e-0ded451195c6@nvidia.com>
 <17926738093796.1.mlx5e-threaded-napi-stall@toxicpanda.com>
 <bf7ecec5-8bf4-47b0-bbf5-6dc8fa4e64d4@nvidia.com>
Content-Language: en-US
In-Reply-To: <bf7ecec5-8bf4-47b0-bbf5-6dc8fa4e64d4@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0004.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::13) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|BN7PPFABD533732:EE_
X-MS-Office365-Filtering-Correlation-Id: 694ea2c5-4476-4186-f9b1-08df35bb7265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261028144727099003|4143699003|5023799004|56012099006|11063799006|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VhPbHnrwfUcM5wuEguVlLGFgbnoi5BA/meGc2TNsCc2MchqAxJk2PL1SOGgtWnsTcz8BkUb5Cmv/7ikZPd6je5n8H9RgHbJ8Z2eE4Sy3YRmHY6fk9cdOajIuxeSSx/i0JU5e/AhkoIBT4cXDRN9JavmuQMBDvAfxPBpqscxAomRdw5TLxguIkcP191CHWU+8y90cPLZrlQbhHhzZ2WXspQYf+tJFWy4ahspshx/3PwtslOvdHi9l0o7HCRVPcz/m1COn+UEqhgyYq0YGcQ2va0qjK8o8B5TSnCzXPgELSwIbHBJoUB1hvVA7fJMjS079vcA/GMfoFwTg1q1x2Znuyt8E7TKyHjsqBqkXJ6zLmtb075eglF5wzU0ql7M+9n4DQk9dbNcnCQHeO0Vyux+hsIXwTREnppdkc17Wx24569Q1V/Iotykfl6V3gMy+qMR4eCrSwSh/cq1qw1Zgcm4uxmBL4CG+yCsMHaMHayM4bl9HE5JRk9zhBqip04D8bdFFi3duwnk62okL300Z5o0lYxxtkiBL8KyJSr4GRhI9kjVas0bjJpnDwMSovMwzLwFqMFV9g2uRyL3KTcrxQXhtINkowQWOhRZ6tGZtRoYWsx88eYbJe3MSC4W4mzLwtu3tx7bwrTiIjA5z/WzDZ1IoJIisWtguxiQH04HUj4LuL00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261028144727099003)(4143699003)(5023799004)(56012099006)(11063799006)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXNvWU1jNEpHcVE3aC9vRDljRWQwLzZKTnFFaHhRWnlkWSt2TmVvNUhGNU9w?=
 =?utf-8?B?dFU1aGhGYnhIWGdZc3NNQ2s1WXFKYkw5bHRZdGdWUVAxNjdLcVJ1YVQ4Mmwr?=
 =?utf-8?B?UUxCL280ZGhZK0VVL0h5SURra3ZmM1BaczhOeHFMemh3K3RheVdhcE1FR0Jy?=
 =?utf-8?B?bGtzaVkwdDg4NDFBbCtCYWRHWUxBRHBuZjdjOXlTbmI1TUdVVlQ1ZmhuRnda?=
 =?utf-8?B?V2JRUFJYR2VWdmdZQk5GZzlQWUR1N01qSFA4eEFMRVQrUUNKWmMzcUV1WGJX?=
 =?utf-8?B?TDBVcnZiSG9pNENWNnpqdFFNcldKQmdaUmVMYVFXSG9hNERvcTZTOXlIRW1s?=
 =?utf-8?B?VytyclhSdXMvQ205RWd6MmI4LzBpU05nU0FERE5YbXRMeVR4RGVacFRYNHB1?=
 =?utf-8?B?cGxLcjFtZVJ6dElCcTNkRFJ3R2tqUHVSNm5lRHRSMW5PRVdlelR3Qzg1b0pD?=
 =?utf-8?B?S1Jkd2NXVkZySFZSbU1LK1E0QUg5NHd2alp0cUxEb1YxZVJjRXhHRWs0TUcx?=
 =?utf-8?B?UFBTNmhWMjV2RytncTY1djJpSFk3Z2ErNS9pV1Y0RVZkQ1ZQWkNRUkNReHhW?=
 =?utf-8?B?c3kvYmllUU96TXFMdDgySGcxbnJ1NXZ5Q2V0SGlZZThxQTNKaCtCOTBEUFNt?=
 =?utf-8?B?U2hKZ2FSbHVCc2dCREdrYi81eXloM3A0ck1pRlhxTDR0Tm0ySzgvLzZTd21E?=
 =?utf-8?B?SklDeFhzZlJEWmVHWitWTEhRUVkyN3BxQTA0a3pSOFp1OEtmRnFFa2RJdmNm?=
 =?utf-8?B?NnEzTDhES2orN2doRHJIQnlwTVhWamo0dXpPbm5JcFpWQzBkSEtYRDRkeVQz?=
 =?utf-8?B?eVBnLzN6dlM0Y3Qwem9NUVJYNTNYN0lsNVV0N09TRmZrZTBSNDluTU1YaFJm?=
 =?utf-8?B?R3FmVjgveVNzT29xRXBJT1pDS3U0L3g3NGE5NmRSUEZuV1hLalJ4eC9ycHVK?=
 =?utf-8?B?S1RqcytvUUxpT2N4Q1BwVklXaDd4dFZzeWNWZ2pvSEZ3VEVLV3NqR0F4cHRG?=
 =?utf-8?B?RmZXRWdUcDhnV0pTdE1kamltUDdRNWU4SFZWNk9iMUVYbDdaT2ZFUVBsQTJ6?=
 =?utf-8?B?MXVkSncrTGE5ZllWaWQvNmlZbDRKYVNVd2hpaUkrMlgrcWppNUJNOUNmaGk3?=
 =?utf-8?B?bjRHQk5EOFkzWGsvN0NiVUxCNXVIRDlGc3AyZDUwU3paQjZCOWFycC9xeU9D?=
 =?utf-8?B?Sm5FTHgvZkZjWWJ6S2VmR0FMMVIyVUwzemtkZC9lU3I0TFhyUC9RZnhJVnZH?=
 =?utf-8?B?MVJ1KzI5N05tdHJjV0Y1aEwzOGJZYWJhOFlVQzIxTUNubDdZaGpXMEsxb1dx?=
 =?utf-8?B?TmZaZWxKY1RJaFpBbmRTTmNKdjkyaTEzekZTU3RSVzdvVE44NkZHd1NEYld3?=
 =?utf-8?B?dlpiZnJyekxQWk5tL3BIWVg5Y2Q1cnBzem5LbXJZQ1NoamxDaTg2UHlPNzRN?=
 =?utf-8?B?YXA4emdYYjNtOTVnSlR3VWZjSHFkbkhpalpyYm1iOTNaV0NRVGpQRG1uQm44?=
 =?utf-8?B?ZG5JMElsZGh4ajMvUTJTZnMrQXZydlk3eThTb2g1UTF0RFdrV1RndjlNVXJT?=
 =?utf-8?B?MUdBOEtNZ3ZRL2NRdnNnT3dpaDJrNTJCWWNMV0NpQVhLUVU3TFFvazZDYmMy?=
 =?utf-8?B?aXNndE1rTGlJeEVNdFFjVHE2QUNtamg4cDAvUnpxM2R3bVBRNnBPb1lNeEdV?=
 =?utf-8?B?S3Y0WnlRaDhIV2hNNTh4a2ZBakZCWXFJNHA4T3NPdlZNZ3pwMVl0SHBRN2I2?=
 =?utf-8?B?Y1RsMEQxRXd5RWZqa1A0bjlZQzdJT25SeFp3eXZ1Yk5DMGxtMEZyZnpBd0Rm?=
 =?utf-8?B?RGpuekJwT2N2VzN2OTN5T2hqL1Y5d1dSOE9PSVZJT2htbUpRUXI4Z3VvZlQ4?=
 =?utf-8?B?UlBER2xBN0VPZ0NveW9ORll4WEltUGtZYTk4aHpXUml0dlRwdVJpUFRWYmd0?=
 =?utf-8?B?VkRYeVFQMkN5aGFVR2g0M1hha1JZWDI2czVMM3pFSlRHOUd3QldWY1ZTSXhU?=
 =?utf-8?B?d0NjUVZiTy9Dd2syNFd4YzFnK3p4VS9DOHV3YmJOeURJQllUK1RuOVQ1bEsx?=
 =?utf-8?B?b0s2Y2xtSmIrR3B6SWNaeHg1UkkrQjdoU2Z4TDlGTmdZRGw5ZzUrckRsK3BI?=
 =?utf-8?B?aW91RzYzL3lVSlcrR0xIVE0zdW81U1AvS0ptajhRTTdGc1VXcVczV3R1Y2Zi?=
 =?utf-8?B?VTdZMWNmUCtTZlZsb1BLOFVMNVBIWk5UNkpjakJ5RlUxV2NwbWY4MjE5eXpR?=
 =?utf-8?B?eXo0L0FvbjlTNEY3VkVlaklVZ2FEN3NrN2hTckJ1S1BxWWd0NHVtYlBKUm5m?=
 =?utf-8?B?V1FpbDIzME9rVzBzRFQ1eG5rdkJPZ0krVk5PZ0hMeURyOFk4VWVuUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694ea2c5-4476-4186-f9b1-08df35bb7265
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 12:52:10.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oBtau9g1I1kWijdAGyWVD7FvUG+GgytqgZlkcrCvfCUbVj7DRQxxvjFI+Jk9EjNzI/BYiQd5/tUeJIf23hbL2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFABD533732



On 22/10/2026 16:51, Tariq Toukan wrote:
> 
> 
> On 22/10/2026 15:56, Josef Bacik wrote:
>> On Thu, Oct 22, 2026 at 02:38:41PM +0300, Tariq Toukan wrote:
>>> The arm doorbell carries the consumer counter, and the device tracks the
>>> last index it reported an event for. Arming while CQEs posted after the
>>> last event are still unconsumed generates an event right away.
>>>
>>> The affinity path depends on exactly that, since commit a8c2eb15797a
>>> ("net/mlx5e: Stop NAPI when irq balancer changes affinity").
>>>
>>> Event moderation can delay that event, but not drop it.
>>>
>>> So the root analysis doesn't match the mlx5 device behavior.
>>
>> The CQ has a backlog much deeper than one poll, about 6900 CQEs in the
>> run in the changelog.  The thread polls 64, is off the IRQ's CPU,
>> completes and arms.  There are CQEs posted after the last event, so the
>> event comes right away, and the device now remembers the current
>> producer index.  The thread polls another 64, completes and arms again.
>> If nothing has arrived in between there is no CQE posted after the last
>> event, only older ones that are still unconsumed, so there is no event.
>> The rest of the backlog waits for the next arrival.
>>
>> That matches the counters of the stalled channel.  It had 0 polls and 0
>> events for 150 seconds.  New connections then gave it 16 events, 16
>> polls and 1018 packets, so one poll of 64 per event.  It was armed the
>> whole time, it just took a new completion to get an event.  Then nothing
>> for 14 seconds, then 93 polls and 5917 packets, and it was empty.
>>
>> Is that how the device behaves, no event on arm when everything that is
>> unconsumed was posted before the last event?  That part is my reading of
>> your description, I haven't got a way to check it.
>>
> 
> I have to soften my previous reply: the immediate-event guarantee I 
> quoted covers CQEs posted after the last event, so it does not rule out 
> your scenario, where the leftover backlog was all reported by that 
> event. Your reading is consistent with the documentation and with your 
> counters.
> 
> I'm checking the exact behavior with our HW architects and will update 
> here, hopefully within a few days.
> 

Hi,

We confirmed it on the device, on ConnectX-6 Dx (the generation in your 
report) and on ConnectX-7: an arm raises an immediate event only when 
the CQ holds a CQE newer than the last reported event. A backlog the 
last event already reported raises nothing. Your reading and your 
changelog stand.

We are preparing patches on our side (WIP): a fix that forces a real 
completion event when NAPI completes off the affinity mask, so the path 
is safe wherever it is taken, and a debugfs extension exposing the CQ 
arming state, to make a stalled CQ visible on a live system.

Please hold your v2 until these are out, and rebase on top: your patch 
then stands as what it is, saving a complete-and-rearm cycle per budget 
with threaded NAPI.

One request for the code comment when you reword it: today it reads as 
if arming never raises an event for pending CQEs, "only for a new 
completion". It does raise one immediately when a pending CQE is newer 
than the last reported event; it stays silent only when the last event 
already reported everything that is pending. Something like "arming 
raises no event for CQEs the last event already reported" keeps that 
distinction.

Thanks again for your report!

Thanks,
Tariq

