Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CAA429CD6;
	Tue, 28 Jul 2026 11:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785237520; cv=fail; b=C3abE4BEKDombj7FWnH8VTMiWrn8GDQ7CKUjyJ1A8d2AgM7lShAhDWw1TbeORXcTqoksv8EPJyKJofCn/SdiQ3m2wXLiW0utum4tGWJGLl7ITr2k4zSfyRuKzbiK77JW7XAYZ9vJUzny0Mf3FUbbracvqZuAOgXCEZx3wgpdQQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785237520; c=relaxed/simple;
	bh=mnYbIiDq6wWD7xgJVU7KxQQuVcm7YgQgeHzRCwSXbMc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mjb1ePhEjH03GVZsDDmHIV0vwHUprKWf4Zcnwo9QQjH0RW5XTomgs2I0mmC51WyTBKv8AbbzzrwsjEkTnU+rY0qMrd6su8bRKrTMZOAtQWoyrHj5peFzemvejtoRo1yagH2dpUU94LEZIt2/+moUhzIMPJX3PSeiFoJMTsG7Iso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PsFZbIUP; arc=fail smtp.client-ip=52.101.43.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PsFZbIUP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7ifNSA+jn7h9rIOSQaJZw4+1GkEuTt1BcjJyy0fOVCIe5BzKiLA8HWSh/bTW9kMb8Ex3R1uSUmuaHt7c/wEkOJHfMq1ojG1rMVzAtr8ae1deKtgDv2LUy9L2+9Yn53NryNAjkIyt1Fkf01VzCUQ1Cf9kWIyYC4+aMiwyvTox2VgwYQQ/WIR3UEC/kd9NqmF6pLyryJP9lY/i41uh8YQOkILodtjaSwa57s6gOWpI3tvgreuEilpWLkjdUJLzd1DX0IM6x5GVSdikussGQpVXbE9yo15qUEGHYfomyCN6IybgfJus7kfSU1JhGa75i6VdkP4f+3pvdXQKTNVgU2Uag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqDK3lb+ydqQtpqtTqL9bbiFk9t/6Q+og6sbcK5CEgA=;
 b=jZgs0Xi23gXeFRZXOl6H6Xibyy9LOw6Lor1IuVIAzp1PFQ+vdmTv1WYSj3f4nQCHXXTxUD1m5DO1A8za0YDAQdPMUyn7HY7lzKfA6PVfuyY0712H7Pi/S9pIcd0dIBKt0VgASQb3LMHl+lwIHEbT3WsJ3b50JZ+76A2tev+DpPBWsfgT8KwHNp0U3rM+6sEt+FF//kP0opK92RXdc2tTrg4g8H5AYQWz6TQP1Vc5piaKzXDS1I2lc/gOV0P3U51KUusHp6WWUgfFTy4K3lU+b1P8wV3D+ZTotjuXkOhKY3txYKzOIw+sUJklsfMNTg4JaSK6ifrbtlg2hWSKyvAYAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqDK3lb+ydqQtpqtTqL9bbiFk9t/6Q+og6sbcK5CEgA=;
 b=PsFZbIUP277TG8/0qUeX/0dKbj+ZJAvwlB3tXrmkjIeXuz6Kd+eVcMEZI3eHaN9CUZZrc3MCA+AssAq2/YUfGkzpkInRMoDYjmTRZm1i+h+4QH+ZQzqfDynNbXU1gk+DdYCB8g0d1yRM5Z+RytQROAlnXE7Lsqv9ej/qij9ljeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22)
 by MW4PR12MB6825.namprd12.prod.outlook.com (2603:10b6:303:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 11:18:34 +0000
Received: from DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74]) by DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74%4]) with mapi id 15.21.0270.009; Tue, 28 Jul 2026
 11:18:34 +0000
Message-ID: <18c6130a-c8e0-8e58-ad1c-f1578e1c5f46@amd.com>
Date: Tue, 28 Jul 2026 16:48:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: jgg@ziepe.ca, leon@kernel.org, brett.creeley@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, allen.hubbe@amd.com, nikhil.agarwal@amd.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
 <20260727182825.7b9bdffe@kernel.org>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260727182825.7b9bdffe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0111.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::17) To DS0PR12MB7777.namprd12.prod.outlook.com
 (2603:10b6:8:153::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7777:EE_|MW4PR12MB6825:EE_
X-MS-Office365-Filtering-Correlation-Id: d6111e3d-d236-4450-8894-08deec99f634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iljDAvaypYWYxOgu9nX/BJ66EBbNg9g2+bfZJHeKhX6TVUyHejsqRhVkQteBJCEoRLYP1Sk+7giD4b0G8pY2mFj+a8IZLiTLJKVxRcPRftRTIj8GKB+OKI5JBafv/jmBRAplBwHM1wesOH36Kwco/eCYotz2fea+LCyWl93vUXgUoL9QpQ8hOQIwARH+MLeNUAGXswgbePv2dkMml+XdbpDkVJ/uMpkbGE3HSdQPjzvNQHl1kH8VxCPe8sFir/2EyfG1vhIEIQ6kukXP/bKVFyp2dJiQexz7+wxthI+GPT0etET/gd0MdcGB93M5uMhhWSpAagV6LKCVgJcdAOGckMq5v8Nti7I62Xdz62HBzOIqMq2r10pZiacehA6j8tK5NkEfH3nj591HdxlEb+lIgHTPhayIHY+hnnBjwGseeVO779Jo1n0RwkUZHbFoND0+i9hTmoGs3CqrNk2HlzJX++JZW7yyLHQ+eYQfTgfpgriZepyBfHu2gNKlAzRaK1cWJzRxyoOwy5U+c5q/GPKnRHnyvs0sMdF2g1R1ILDuEK1A2yYnk6KAvwZ6boEGw2OC1h4elokvQ2sJlNoHOGMLBUeLBmqRQWtjFlalRNn6odouDx0PadCKfo66ks9GJO+umPyUgH29qZUoiz2gq85ZuDO756TANU7a8HM6fRN6WY8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7777.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEZqTU5vQll0SDJSS2s4U2tFQnliV3F3ZWY2WUhneVpqSzE3WTRrNnVrd0Y5?=
 =?utf-8?B?UXJYcTM0Qjl4ZnhhL1FtM1ZGT1F2Z1RaazQ4TjJ2aCtKaG9UVUh6TFVwVlJH?=
 =?utf-8?B?REFFQW1wL1JmajBmOWlzd1BEYlQ2YW91TEJmV2d2S255SGVpSGhELzltSTl3?=
 =?utf-8?B?dVVDdXFMSFJzMFJ0TUN6VldELzg1VXZTVHBmK3JEeWluTDdRZjhtd1pqMWtu?=
 =?utf-8?B?VkdvaE1WSWx6YTlnYkVZbS9nUzUyVWdCZnRTVFhjdEF0UnYxNllrcExyOWVD?=
 =?utf-8?B?TlFQMTRWWWhyTENFdWZNanV3RWVNSklVVUg1Mkt5aGU5UDR1cTFaV2tzTzZO?=
 =?utf-8?B?M1FrSHpaS2dieEpSUUF4K0FMSkNOcXRsQ2ZTamJyWG11YVFNTVpQWHpwZnY0?=
 =?utf-8?B?Mm4wTGRVT2wyVXVlYi9NQTg2UjdOYnU4K3BWYWtkSXZoZ0J1RTR4TTZYc0dy?=
 =?utf-8?B?N2pYdGRleWw0bXcxMk9lKy84NzFlVVdPYUZ1MytPVHN5T21CVCtXZHBtekFL?=
 =?utf-8?B?RnFnb3cvcVBXVERXcldhMFVPUnZMcW9aa2NtN1RjVlNBQXcvWnpPVEJUU0sr?=
 =?utf-8?B?UkxHUXpkZE1mNzhudHcvZzJnMlVMR1d6NmtjbzE5clMwZ1FObDN4UlhrVURG?=
 =?utf-8?B?NW5TZm5UREc0eEdETjcyeWpGa0dGelRRb0N0R2RqV2FFVHZ4OCtEQkRvVjUv?=
 =?utf-8?B?V0xhencxbjdtRmlPV284ZWt3Q0R1VkNZeVFBQWdNQnlnNk12cnFyV1FRRXQr?=
 =?utf-8?B?clFUWW5SQXI5RktNME1lcDFqSWx2bjYrclJFR0RELzk4c0IvWW1RQjJ5MDRy?=
 =?utf-8?B?SjJURm1SdmVQeGVVUGd3QlY4MHZHRFJzNTJzREhvRVRGM3NlZVJReWJEby9O?=
 =?utf-8?B?RnpKcndSQ00xd3htMDRJTEp6ZFNlN1Zjd3lkZmZuZEFTd0cwVjVaeFI5M0gr?=
 =?utf-8?B?SW5tSnFWU21kRXUvcU5SSFBzMFc2blcxMlVXMnhJU0FrZzdDbjZ6R0o1ZTFL?=
 =?utf-8?B?a2hqdDA3UXlXUXJYTm1LS203eGFWUWdmZjFpb3NJaXMvb1llZmc2c3kyYkxh?=
 =?utf-8?B?U2t1WGgxYm16R0VxRnFlNWFxTkdCZ0hOUUgycWk3M1RwNndKVTVBaEtkTFRY?=
 =?utf-8?B?eFhYcVhNYm45WVprTzZyNzU5UWd5R3QwcFF3NmJJaGQreDRxdlkxM0NXMnpW?=
 =?utf-8?B?a3ZLdU1wWkJ1QnkrY0EwY1hhdDJ2V0x2bUsvdlFwbnZMU3hoNVVXa3d4Q2F3?=
 =?utf-8?B?OWEwNU5LL3pDOWFqU291eXlDNk9PRnZrS2ExcmE2d29wOE1GTnlWOEt0Ritl?=
 =?utf-8?B?VzRXZVpsaWlXVzM5OVYwOWJWUmN6R3Q2cjNTcW1meGZsT044S0FQUmhrMVpj?=
 =?utf-8?B?WmFhU0xKU3IvTEsvZlowaklVbUR1VU9lK1o5aEtMSmNYWG5SejZDNXozcHho?=
 =?utf-8?B?OGNhdFBQeGlMelU4ZDVmVXhHR0h0N3dsREZOTS9TaWxQeXJqR1JrWkd0VHhz?=
 =?utf-8?B?SkxVeU9Gak05VHVtcUN4Rnc5bUJnWXpWekovL2NIMHdzTDhEdHBoMzR6OGZJ?=
 =?utf-8?B?N3NKSFkwck1heGd0a0NnY1RzSnNKdHRNZWhpRmY3QUt2UWUrbDJnT3dTUmlv?=
 =?utf-8?B?UEpHMEUxZkdoRXBQNmpKcXU0RUZ1OG8zbzlEVXFpM2xBejM3WmVoUUdCcUNY?=
 =?utf-8?B?MElVTDNwbWhmWnVJbmF1Z0VUWWoydW4zcjNHZGtRSFVSanRrZ2dZR1MzRWJy?=
 =?utf-8?B?b3d4WGQxZHU0dDQrL1Y1cUUxWC9LTzlJWnQ5SHNya0NOSFZxMjI1Y21pYm1C?=
 =?utf-8?B?R3M5SE5NNzFjbm9JQlF0NW1ieHZXUG9pNVBPTjY1NXViZEhBWkJib0d1WU1l?=
 =?utf-8?B?VFZ0QTRsV2d6Y3BZWS9INjlVbmRCNWI3Y0lDYUJQOFU2QjNjM3BLa00zS1cx?=
 =?utf-8?B?Ync5ckVYV2QzcWZsMjlBcGRnU3RTd3ZyTUFUa1E1YWwwUzlpcEpjUUMyd1Jx?=
 =?utf-8?B?SnBwcGR1dFlId0ZDeVpKaklBdHF2MGM0UlY4N1hlaVdxc3FtNTBRNnoxdFNM?=
 =?utf-8?B?ek9MeTIvRjcrZzlWOHo1OHFHOTQyZnBKa1JEVFh3aG80aTFuaW9LYTQ1ZWtH?=
 =?utf-8?B?UDNlRlRiUHZrY29aMW5TSTA1TlJXUjZxQ3hkMTRPMlhJdkFvVU5tbEFRWHVp?=
 =?utf-8?B?dGZNUWRpMUgwRHdmeGxlWDQ1SVRiZnZzcUxtQThmSloxWGEyd3QvWTdsOGhm?=
 =?utf-8?B?YmFiMlY0QWpBWmNPYnFXOUo4blM2Rm5OMjNKVzAzOVFuek5QVlk0eUN1aW5M?=
 =?utf-8?B?OWxUbDc0SzgxNC9rR3hHZkw5SW1oZ3hUWmpPTS93T3BqaWxieitNQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6111e3d-d236-4450-8894-08deec99f634
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7777.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 11:18:34.1622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGq5tvKm6ppQ6cg3chhDgUGnKNIYsFTMuB5OvzuqpEwZ1lf/PJb4sfOYyt5Z2DEDejXZsJ6jW8Z0swRDyjcP8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6825


On 7/28/26 06:58, Jakub Kicinski wrote:
> On Tue, 21 Jul 2026 17:40:32 +0530 Abhijit Gangurde wrote:
>> Patch 1 extends the net/ionic firmware identity structure to expose the
>> rcq_sign_bit field from the RDMA LIF identity.
> Can you apply this on a linux/master tag and send a PR so that
> both networking and RDMA can pull?

Hi Jakub,

For the earlier PHC series [1] Leon picked up both the net/ionic and 
RDMA changes through the rdma tree. Would you be okay with the same 
approach for this series or would you still prefer a shared branch with 
a PR?

If you'd still prefer a separate PR, I can set that up.

[1] 
https://lore.kernel.org/linux-rdma/20260610154216.712374-1-abhijit.gangurde@amd.com/


Thanks,
Abhijit


