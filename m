Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792774160;
	b=T0oSQFSgYp/bl1OKiNNfn2LcgvaXVqxGrqUqSEmxh4h6ingMbJ60574XXHBqiOCalLFd
	 i0BHKge7xdR6LO+Ox3Xs2gqvpVFRZhTm7UeV9QGXLJ2q9obRdFVPDChCaPuRIzdKwF/gF
	 6q+j+tV2AxpB9gUWCjOgiEexl8biw45hIimF2N4LqvbMexEnuKSmn4EM3xOCIsKyt8wO6
	 8CdAn5vuylDubjdsHUdHBaJ+ZYKQ+pjf9GOiZHcfQvOSBcWNinssGZOrVnyWZhtIhxsW5
	 nyq1mweFOUOy2qBi9cQRhybLxj04VxvTUGw8Wt4PtgKwSeLx2I+9DT9hn3sQIxDVrOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774160;
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
	bh=z5Mn9+ncpkndBJy/GulsRQ6XTzGLdJS3qXDyAxNlw5w=;
	b=3osd9beEcNH/28TOYuVzHG4/CICH6cBN8HzxMJuq0KLoJvEObr2ukxX7dSZurrVTj2GC
	 tEbI0z1+Y1bBKz3BLyqAgkUNb59zSi56jmNW0lhRCA0D+3RlVlrL6guFEPrP/7H/5Copz
	 0NfNnv9MBiWGRyHWi79sl+ydkrD2G7zJm479lMwrTXtSXqaxE0P25yrfvkBiwHXLmF5hj
	 Q+vM28fa1NGwFfeNJ2DMrn1aXUsWBD8vbp/+sEpeErwwVqciAcn4NYhjoc0qESwEr56hV
	 6lopjqviNbcQ3BJ8zJfZTjV7UyazA3mERet8T0xFoXmpCcpaEJ2zqJyL+8pnM1klmXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iqLDBOn5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.55
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF63606A31D;
	Fri, 23 Oct 2026 16:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AF63606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iqLDBOn5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DUPtMMziBURWccxik3NggWr3DpPp+Z/dw9766bRZlmelzQm3Vdyc/ZrPwMqdf/uVBm15uyvL1GuHIzb8+AVbxsI1iuLz+YehskB+u/0ex9LOUVeBAzwcCC4ex9yxWNVoK3QPl2GaY91PFvZCZAa9OY3lr4+iiZRdgkf0io2mwVFTj+1/foNgaCuqKHAOR0LC+ecEGnHNoR9r1Ttk4XCzNTRqAfz4GwJzXTfqHCey6Lgm8eviFMXrhUz3TmjdwJ4dRrkoGVMJblGdB18x2w5WTECXLVSfzH97O4QJjpFlvM0HhZW+j4s5nKMzmD0ZcHjU/Fu0RCUjM67T2Q6zjGiOBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5Mn9+ncpkndBJy/GulsRQ6XTzGLdJS3qXDyAxNlw5w=;
 b=ttkAt+jCmrB/EXBt8+MZTf8w6G0yDmnByvRYHiln+msSQwDOpi+GvgEJC08bs2jg/wuwRFwM86YpPj12kn2Nl97VYAimpq4QkPMiGwwhdtvW38jSyVZO1bpTK76L/DnoD1P49aO4Zm7nkmi1h78vj4As0rfm8hTG5nhmjW77lS0Pcpi5be8ouZ9fftjppZoAmj0JpEF13mW5E4Krfn5xP1pIQg1h51z0dKWZUCwmDsXlqlhRcgXD6wEmSjM0FXCRWI2vRZqA2s890F9Db7atcVRKNSYyKCzntiRXyu74iu/mjN7uvmUw8OpsCPZcr1GIe0UDPR4fbDQoDjPYxdEjoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5Mn9+ncpkndBJy/GulsRQ6XTzGLdJS3qXDyAxNlw5w=;
 b=iqLDBOn5iiTWYbjLnByjoxQONn/lJRdHNEy+DS5rWy2BytwQ7zfrS6wkYNQI2YF2s6x9MnHOiIGGbljyQlRvPt7WxRno7jKPu6tNMLq+N398CSpA1pAw+b72Z0sUFf21P0IfqW6/UHQ03bASblUaiGDy4X4eR++pR+Iuo4FVxKRj0k9s6Xede93g49D3wFKddtqv1olt1/mQWjrTYHlPR1OtI0IJfobL/aUp9PpatMmCvXMc/VQsP4sIDin/V29bfiMedcq7xzPhmSYGw7qir0yaxwV7CvYIrpppMJwtaAybjJGAMe1WEH/9BNfCCD9WbTB0OxPwGDErkGkT8XpJbA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by SJ2PR12MB8876.namprd12.prod.outlook.com (2603:10b6:a03:539::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Fri, 23 Oct
 2026 16:49:16 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%4]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 16:49:15 +0000
Message-ID: <4cbcc997-181b-4d67-bda7-cecc83e06d08@nvidia.com>
Date: Fri, 23 Oct 2026 19:49:07 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5: Use only loaded devices for PTP clock
 operations
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 cratiu@nvidia.com, gal@nvidia.com, kees@kernel.org, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 markb@mellanox.com, mbloch@nvidia.com, moshe@mellanox.com,
 phaddad@nvidia.com, richardcochran@gmail.com, saeedm@mellanox.com,
 saeedm@nvidia.com, shshitrit@nvidia.com, tglx@kernel.org
References: <20261021105600.3481485-1-tariqt@nvidia.com>
 <179275313029.3134.3941989506677148178@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179275313029.3134.3941989506677148178@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
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
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|SJ2PR12MB8876:EE_
X-MS-Office365-Filtering-Correlation-Id: 53bb49bd-59ac-420e-f6e1-08df3125929f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|6133799003|10067099003|18002099003|22082099003|11063799006|56012099006|4143699003|261022105027099003|261021121427099003|261009223027099003|261022075727099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	7SWMUZ3rjd6P0EHOsc2JWuHAZWoXaZImGZFoIi0oyu6DSqlxGW6LDviNOn9MSilVrQ79KrDsl5bA36nXmNJmTtk3+K45D3YpQfVnHuD6cPAUEZ21bZpUFX+hkZs/vpJWzzq4kmVyIMxafWZ9TN7VCM9qtrr56OnGIiqNIh+z5Jurz+pYWSIzMmNjNgS6dwYQGnBg+p+vWvCI+89fykDu6L5kg+a6eFv3gFnpyTMXrgdZmV/C4uPSHImYKDLinVSvwvk3rKV1CzknIUIJEBGjCZXlhJ7Nq0Yqsk2jt7B3AIUo5TQPhcgMhjnj1Xzm9c/kjez8r64eThjRhUG0kNJIH/VmoQJV4v0ddegNAY3yjWsjvykIobjq6iKvwBXWhM9q//1wb0FNZFAz2hXGtn8de2wKXApUcCIZVOFqca7Qlu1mT+l135REQhkphEriRFlKSxaXq9kXb4Rx+JTRQcaFFzOuOG9fIOSBFHb5S5WSGkwtwHqHKMctWJOqqya0KaSAZhF85YT2NfLtO3A6uctVmhT8wpQuk9aasuJGsQmg7EQaWtsd18b7Yu5sKjCCuVIAz45d02frM19ZbnHKh94Z2P1E6OL6yUKCR+L2AjNUuTNrx/suO1ol8OLNseYqk2Dhy0Pe8kLeeYH8ZU7QGQOICUAzs9iH/2gObcpSKQCK1Iw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003)(261022105027099003)(261021121427099003)(261009223027099003)(261022075727099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUFiR2pSSVcvM3hLZVl6RXpZM2xyYzJpOW1NalRWMDhENkVDdlA3QXBCNTFI?=
 =?utf-8?B?RFJUeVNNN2NSSDVXWHlvVXlxdGVVVU1uS0dONDdSYSt0L1FLL0N5Z1ZVTTNk?=
 =?utf-8?B?YXEzcUpyLytMc3dHcVNBQkc1T1I4N3VRb2lybHJZZHNVbk44eG1pU291aW1D?=
 =?utf-8?B?TjdzRFhYbVJPVk9WeFJHS2dvYU9ZeXcrV3RqS1M2UXpRY09rbFRHaVdSM3Bj?=
 =?utf-8?B?N0dxUTF1bFR2c2FoM3hTMTRieVFtd2p6VGl3aU9UOW5vbngrcUhwdGxOMTBO?=
 =?utf-8?B?U0JiTC9FQjc4Q1EybGVmQkJ5RFJIYjQ1T0ZZbk1XaEdBbFhLcG9Ga1ZoOFRH?=
 =?utf-8?B?YUY2UWVMMXpKUkg1V0VEdmZrVzRXUmpNYjNPbFlQSU1uSHJ3d1UxMkMzRTUr?=
 =?utf-8?B?WVBvbGRGMXl2WUExYWtyWm5uSEJXUWl0TWhnNlkvWjRNZHg0Ui9OQmNmaExE?=
 =?utf-8?B?RnA2S3hFTTNpdHhZVzNVamFKb1NHZm56K1FqQWhQUXhRb1ZPRFhnRUxhUm5x?=
 =?utf-8?B?Y0FCTWo0OVBzYTRpN2ZZZEg3VkNBZ2ZHY2MvNHo5OVJzZldRRHVGbjgzZ2pL?=
 =?utf-8?B?L3JPZWRTZUxyTmZQWGJkZzFPeTVqVUg0RjB1TXZ2MjlLOHdYVDZNdXErZmQx?=
 =?utf-8?B?KzE3cXlOY2J3cDVPTCt0dTZhL1pMMHIveHVLbzF0QkRPUGNvcngvMlFLeGkr?=
 =?utf-8?B?KzQ5a1pQcFBWb0FGeWVpRVZtclQvWGhoNjVlZDFDUUZBQk5FMTRyeTk4NlFp?=
 =?utf-8?B?dnhEYlh5TnlHOUcxNWZOZ1JIRmc0cUs4Mm5wNm1ORThOek44SCtqaTBPb2FC?=
 =?utf-8?B?NURwOGRDaFVqcW5Yc1NNeFI0cmJYeEZMQUhxK2JIV3M5R0hzbDRFSnlqNmgr?=
 =?utf-8?B?M3VnZ0lrWUorTTZMeFVra2JrUldGRGlVOWEvZnlJQURqUndTY3lzbTZTdjdO?=
 =?utf-8?B?dkM4Zm5aVDN0WjBOWkRFb3hEZFR6YUpVK2dYSWhHMVNUUWNUaE1XVitRU2JN?=
 =?utf-8?B?YVI4QkZNaUgyVmZDaVY4bWdiQUc2aVBZcFR0azY4cVJ4ZFphS3VHM3hCOFVt?=
 =?utf-8?B?c0VxbXFTMWloOGFVL0N5LzlKV09rQllFb3F4MVBYWFpod1o4OFROckdMV2V0?=
 =?utf-8?B?cE1iR0lrRjhjREI5YWdGWHh5bFE0dHgreHVSSTY1a3RCK1RLOXlteHR0cmhM?=
 =?utf-8?B?UXJ4NFc2WjdHVjlQa2U2cEFUUHFUSEtiOFJmL25sWHRDWFgwM25HTWh4Q0RX?=
 =?utf-8?B?eW9aRVBIRGlUelRpbXlBMzJFdzRvbkJhcWxJN1N2UUZyTGM3LzE0clZNSitU?=
 =?utf-8?B?Zm5tNlBQQU9LcUVwZXhLbkQwQkZJWkZ6Mk9TVi9uMWdJTGgvaFRpbDVmS2ND?=
 =?utf-8?B?ak94VGFJZlpFY2lRcUZmbmZDa0hSOUdKbDZDRGFjMGEvdXhXeFRGS0pPbG9W?=
 =?utf-8?B?TU04dTJ0clJWY3VqbExZa1JMZ1pnQjc2YjllTS9TMnRDWVQ3ZklieWxUOEF1?=
 =?utf-8?B?U3dnVStLYnM2OWdXRjQ1bUlPanpkZDJ1T1RvVTFlQUlRcytaa29UdTdZbmlF?=
 =?utf-8?B?eXVVOWpuUjVkT1l4WXNKTkpSa0ViQ3kvRmVPNytkWGw5MGlYRDBVK3c2UFd1?=
 =?utf-8?B?cEJCQWY2c2xYbndQNUdqRHIyeHVtL0xGVlk4cE12L2ZVYXBPNGRkUGZTYTBP?=
 =?utf-8?B?V0VkVDRhMXU5VFExYURySUwwQ3ZwZkZwZU1PaUdsVXEyd2c3VXJMUFV1aExM?=
 =?utf-8?B?VzBFY0puWXcwZTI1WG1rL2JMWmhRamNMdW4zK0FpR0hBTWVpQndBSVlKcVI0?=
 =?utf-8?B?VG5JK3lxV1loTmlnVVNOY1pqeUJJQlpzVXJnOGVWU3FjVWhuVS8xeCtIN3E2?=
 =?utf-8?B?WTEvVmNIVFUrUUFVWWVJUTZ0cHRXUDV1Y3pHNXVCWG5WdCs4Ymh1cFJrcHJv?=
 =?utf-8?B?VFhjc2gweWpHY3Jhd1dBZndRZDgwMDFNUWk3OUVuZ3hwY3dCTG80SGx4S2wy?=
 =?utf-8?B?WW5rczhRWXZPU1pkckV1aEorZ2dZdHN1bjhrQXhhQ0docStFRForRytEZHN6?=
 =?utf-8?B?QUp5WW1jdjJpME1LcytpbUtSM3NTakZxWnBqMkdVQzRUTzBNcE81dEFpd2JE?=
 =?utf-8?B?MEhIQlpjT1o4V25BL1Y2TXRLa0NjbytjSTIxUjdkbnhIbUlDS1VXUXczaFh6?=
 =?utf-8?B?ak1uZElKVjNUVjhTZ0RnUkdVNWlSUEdORERYT0JoVHJEMm1nVDhxYUZlSEJL?=
 =?utf-8?B?RFQ5WkVPWld5QnhjWDZkaVd4UFNncSsvTC9MVVVwSTZ4aElDMzZoQjFWTjd1?=
 =?utf-8?B?RnZOdTlMVVFBNGd4QXdXRE1BenlGZzhaamxsNFBkanVjeXRDVHpWdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53bb49bd-59ac-420e-f6e1-08df3125929f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 16:49:15.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIKeVVTCK9hMQ1e4OpVOm/lgN8nRlPgSmcg5Oy9vwnAgVF5zDV39V4dbMb9LkogMJA8ZfqrzeHKJJPYViLX2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8876


On 23/10/2026 13:58, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 · High: 0 · Medium: 2 · Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
>
> - [Medium] The commit message leaves out a large change in how the PHC
>    keeps time.
> - [Medium] The patch makes mlx5_ptp_getcyclesx() (and
>    mlx5_ptp_gettimex(), used as the getcyclesx64 fallback when cycles are…
>
> --
>
> net/mlx5: Use only loaded devices for PTP clock operations
>
> This patch serializes PTP clock hardware access with the clock mutex for
> all clocks, not only shared ones. PTP callbacks now return -EAGAIN when no
> loaded function backs the clock. It also ties the PTP overflow worker to
> mlx5_clock_load()/mlx5_clock_unload() and uses the devcom lock to
> synchronize with peer loads and unloads.
>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
>> index 5df786133e4bc..c3e53d219496f 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> [ ... ]
>
>> @@ -580,14 +616,20 @@ static int mlx5_ptp_getcyclesx(struct ptp_clock_info *ptp,
>>   						ptp_info);
>>   	struct mlx5_core_dev *mdev;
>>   	u64 cycles;
>> +	int err = 0;
>>   
>>   	mlx5_clock_lock(clock);
>> -	mdev = mlx5_clock_mdev_get(clock);
>> +	mdev = mlx5_clock_active_mdev_get(clock);
>> +	if (!mdev) {
>> +		err = -EAGAIN;
>> +		goto unlock;
>> +	}
> [Severity: Medium]
> Can this corrupt PTP virtual clocks built on top of the mlx5 PHC?
>
> When expose_cycles is set, mlx5_init_timer_clock() installs
> mlx5_ptp_getcyclesx as getcyclesx64. Otherwise ptp_getcycles64() falls
> back to gettime64, which is mlx5_ptp_gettimex(), and that also returns
> -EAGAIN now.
>
> ptp_vclock_read() in drivers/ptp/ptp_vclock.c ignores the return value:
>
> 	struct timespec64 ts = {};
>
> 	ptp->info->getcycles64(ptp->info, &ts);
>
> 	return timespec64_to_ns(&ts);
>
> So while the function is unloaded, the cycle sample becomes 0.
>
> mlx5_clock_unload() only cancels the physical clock's worker, through
> ptp_cancel_worker_sync(clock->ptp). The vclock's own worker keeps
> running. ptp_vclock_register() schedules it with
> PTP_VCLOCK_REFRESH_INTERVAL (HZ * 2):
>
> ptp_vclock_refresh()
>    ptp_vclock_gettime()
>      timecounter_read()
>        timecounter_read_delta()
>          ptp_vclock_read()    /* returns 0 */
>
> timecounter_read_delta() then adds (0 - cycle_last) & mask to
> vclock->tc.nsec and sets cycle_last to 0. Once the function is loaded
> again, the next sample adds (real - 0) & mask. With the 32-bit vclock
> mask, the two partial deltas can add up to the real delta plus 2^32, so
> the vclock may jump forward by about 4.3 seconds.
>
> Before this patch, mlx5_ptp_getcyclesx() always read
> dev->iseg->internal_timer. The iseg stays mapped across
> mlx5_unload()/mlx5_load() and is only unmapped in mlx5_pci_close(). So
> these reads returned valid values during a devlink reload or recovery
> window.
>
> The missing error check in ptp_vclock_read() is an older weakness in the
> ptp core. The new -EAGAIN return here is what makes it reachable.
>
> Should ptp_vclock_read() handle the error? Or should the mlx5 getcycles
> path keep returning valid cycles from the still-mapped iseg?


I think the error should be handled in the PTP core rather than accessing
the hardware while the backing function is unloaded.

There is already a series addressing this issue
https://lore.kernel.org/netdev/20261022-ptp-vclock-sampling-v5-0-06ceace17bac@gmail.com/


>
>>   
>>   	cycles = mlx5_read_time(mdev, sts, false);
>>   	*ts = ns_to_timespec64(cycles);
>> +unlock:
>>   	mlx5_clock_unlock(clock);
>> -	return 0;
>> +	return err;
>>   }
> [ ... ]
>
>> @@ -1554,18 +1646,32 @@ void mlx5_clock_load(struct mlx5_core_dev *mdev)
> [ ... ]
>
>> +	start = !cpriv->mdev->clock_state->loaded;
>> +	mdev->clock_state->loaded = true;
>> +	if (start) {
>> +		struct mlx5_timer *timer = &clock->timer;
>> +		u64 ns;
>> +
>> +		cpriv->mdev = mdev;
>> +		if (mlx5_real_time_mode(mdev))
>> +			ns = mlx5_read_time(mdev, NULL, true);
>> +		else
>> +			ns = timer->saved_phc_ns +
>> +			     ktime_get_boottime_ns() - timer->saved_boot_ns;
>> +
>> +		mlx5_set_timecounter(mdev, ns);
> [Severity: Medium]
> The commit message says:
>
>      To fix that, serialize clock hardware access with the clock mutex for
>      all clocks and fail callbacks with -EAGAIN when there is no loaded
>      function to service the clock. Additionally, tie the worker's lifetime
>      to load/unload and use the devcom lock to synchronize with peer
>      loads/unloads.
>
> Should it also describe the change in how the PHC keeps time across
> unload/load?
>
> Before this patch, mlx5_init_timer_clock() set up the timecounter once,
> and it carried over unload/load unchanged. mlx5_clock_load() only
> registered the notifier and re-armed PPS.
>
> With this patch, the first load re-bases the timecounter through
> mlx5_set_timecounter()->timecounter_init(). In real-time mode the value
> comes from the HW real-time register. In free-running mode it is
> extrapolated from the saved_phc_ns/saved_boot_ns pair shown above.
>
> The commit message does not mention these related changes either:
>
>    - mlx5_update_clock_info_page() now calls mlx5_timer_snapshot() on every
>      update. This stores tc.nsec and CLOCK_BOOTTIME in the new
>      saved_phc_ns and saved_boot_ns fields of struct mlx5_timer.
>
>    - mlx5_ptp_adjtime() now calls timecounter_read() before
>      timecounter_adjtime(). This changes the cycle_last/nsec values
>      published in the RDMA clock_info page.
>
>    - mlx5_clock_unload() now calls timecounter_read() through
>      mlx5_save_timecounter().
>
> As a result, the PHC value and the clock_info cycle_last/nsec pair are
> re-based after every devlink reload, health recovery and suspend/resume.
> While no function is loaded, a free-running PHC also advances at the
> CLOCK_BOOTTIME rate rather than its adjfine'd rate.
>
> This looks necessary because the overflow worker is now cancelled while
> unloaded, so the 41-bit counter could wrap without being observed.
>
> Could the commit message describe this change in time behavior and the
> reason for it? This matters more because the Fixes: tag will bring the
> patch into stable.

Fair point. I will update the commit message.

Thanks,

Carolina

