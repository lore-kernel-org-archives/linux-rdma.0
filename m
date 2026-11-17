Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794953786;
	b=mGS4FOnpgjURFjBHdvq5VivoSxTnbd4bGfS0lguhIA3mo5frMyga2VLbhk0bf7c+1EUt
	 UHu7624dczcaM6BcNgjpdohBcdbczQ8XKfJPDGmLBoh5q3D0qH/sHgu5AdcbsBG35xZtu
	 FzRb4xDbATilHnZZBD+UQ3ae7VFR5OwaCUADWnp8ESGnu1A9NeW2rYssBihLmDmakTf/m
	 A5/aEFi+ZfE5lKaYTLOgYrAalW63J4QqbEnwW5KjpRWE50yT/3+IxX4in+3peFbhCSOp0
	 FXhTUZxcNUm3EHVC6HH9cqHNDLtgB+8MDlfhOr6f2EOtKZq4+l3jYN3LIIhrNmB+qKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953786;
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
	bh=vPBwrsdWDY9Sr6YPCiHlRLO45FDuJXi9lhZx2LhDu+A=;
	b=ilaqMPijEzl4owtOuzwpCuRVrWO6eLXoaZo+mlgpZ4FS10hWeHs/8NtHus1bbSjzMWBd
	 LxoQp82BPQ6ANBzcqP1TqgBkadcI3QxjXRvj6q6lMdvkyJlGKx44Iv1c0JBb0AjxJts2F
	 YazBc1TnTPP8uEenQffv67u7nLINiURHfO1yP6hGwnTYnn8Cv7yEqH09MxOC3oWKxd5YW
	 QLdul9ZvsMmX/tavwsd3y2coKfWBA/z5HPGE1paYFMDk9iy5y2QzDc+B0XNOoEHQaE+/r
	 s2dbk5s5EEMHNOtZMOA7rq+XVyM5rEFLL8msfrQpsUHoC7UTH3ji8QUSLDpcCP4Tt8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YAs36xfE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.40
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F80606A32A;
	Tue, 17 Nov 2026 22:16:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66F80606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YAs36xfE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5cA/rrxhhr7Xfb7lgK1YLCb2UKtZ7fS6xmAKFZjxYgZPMUVRqvP+/ayusW5Ehh3W/OCN/ta4h4e08rWXQyZEVPuzIJls2vbu4geH4Nd1nvgUR3FWURampZXdTTH3cx3+P5JADkNGqDhM64Nf/PfgducbYfvx3ZK/pBJt1Mjz2XHZ3qSQ9kxAuM9Ad5mMa95En4yRaqx/3nF+MQileoEN76gXYRsbgH8Eh7kL/sPi7RlSJrRoOFLMBnpbLAm0QWPSCs0ZTMMAvvdkY8Zi8A9zCmaaZWfP2h2p0ytTocJB5qnGaS62Ck1ZSn6oJiCisNdTpp2xPTpxuG8rjbXf/WoZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPBwrsdWDY9Sr6YPCiHlRLO45FDuJXi9lhZx2LhDu+A=;
 b=QVvUR2WNabE5IPOOBA1iWD7CCW/Kz0W5xrgpRUNqnvgkn995l9350ev1X24Op3Kb/2PN5v5s1pf+nFCFeDbclQNcpWe8Tvppe8wydK40RTjA+oIegS1GgkcNZgCCbd7IE+/UZa8pj2ZNobhpTRaMW8SNC00t91qFYhuAvyYRb1sY6bWQFC9ZB11WDQTUP0s4YJwV51PtYMn1rlWOLKeCE8REIEOGpU0D09mq2PCPJ8U8bk0/D+fUeDbTXr2EI+eg2y1m7e1OH1ORsCtb5jMgihUGCymb3MYiz7r6/+QvnsDtHQkpiTOWOk11dolVAPxN8/IKX6XKwESnxCMxEaB+dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPBwrsdWDY9Sr6YPCiHlRLO45FDuJXi9lhZx2LhDu+A=;
 b=YAs36xfEILLYmGbcaX5kz5NsDP5CdJueY2+LLGY2ZEpJtBlJGAOy5pCQG3Ss+Vb57HrVMbc+4YqWiMo0xYcoPw6FuB8Nn9jucA67hi7eIajvGJWv08/V4R5X4Z3+XeaBqxwFgze57+dU20APTkiK+M+f2ETjSC0NGl1C5lk63pqIXBLdIOR8QCYUcoCP2qtc05u6GTUt8xvQ/6h1LsOgcTRH4TxLy0CgjQ6SoduAPtC0gQE4VJ56O+rP4HqaipxPlQd5LXzDJ4McJlTrmPB4SKe1I807XH7AgWQYP552/vrbpJwQYZ77wjJ2XWTmJk+FhLF7nORr1koo6EE9+pXGwQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by CH1PPFC596BECF8.namprd12.prod.outlook.com (2603:10b6:61f:fc00::621) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 22:14:57 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0615.013; Tue, 17 Nov 2026
 22:14:57 +0000
Message-ID: <194e1103-0d28-45d4-986a-819955e11268@nvidia.com>
Date: Wed, 18 Nov 2026 00:14:54 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net: mlx5: Allow police as the last action of a
 TC rule
To: Mohsin Bashir <mohsin.bashr@gmail.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 cjubran@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, idosch@nvidia.com
References: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
 <82d9959a-8176-4433-94a4-ff72445306ca@nvidia.com>
 <09ae2064-38ff-4d25-83e5-0ac4c3eb1658@gmail.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <09ae2064-38ff-4d25-83e5-0ac4c3eb1658@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|CH1PPFC596BECF8:EE_
X-MS-Office365-Filtering-Correlation-Id: 3242d154-a5b2-49d2-e8bb-08df44f836bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|4143699003|56012099006|11063799006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261022105027099003|261028144727099003|6133799003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1dheKLuv4GCP4LPWVW9p9slGezcV80y2M+aLbt8mSeA8+rkYHj0f9owqXxiMJHoWG4eYeSQET0eyx4AIhM46MIau6h8zsidWws0GOMHvYXaAcZ6HBS5sHoPY69ZO4ARGLhz2yaUQvXc04KUYP7Yi1u3UeWBXUPWFE94sA6Vd1OI8R0pnGnkTnaQkZ+DSeeTNMAw6wzD63raCxCdC8HwgVm0zXHy2Xd0jGrnZHBWAlX99peHAipAnGKrr94JA0oO/E0dek7sHQq/kX3hq7R8rlsn/x9UhX7KK5lAPJzvQgUFaWQ3v5brTbj2TpdRm+iCwgDjN+lvszKmiPIJkVP7aaUzpX7Vk4eJvJD8owI4XY9lGnNMc53lXR9Gfla7Zf3My6RfsFE+R+drplTjThDz2fUdasjumsN3J29sGLjq+taOB7ajbj5ysmC8TwZLS1PW1TM9QMVZiWmPv1siYG1+4bMj52L0p7MDE1pO/jQaAZVUZ1PLUxSob5YrUkUS+sfDdJiT4bswyHDlvUyyk+SWpGt/rcMaZoe2ingjNHWBXTM24O7Wxazenxkz0BRzFqj4Q+jqULB5O8+T3YP1xv1jKoNYuP5OUFQ3e4KF6VNeHXNugHVq6YFVUfI8XpUPDtiT882484T/lAHlagT2xkZyfwVfglPYimqFqZBLaaVPQZqU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261022105027099003)(261028144727099003)(6133799003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkNPbmlwaFZrOTg0bVlKa3BpTTlhLzFOblRKU1ZlMkkxY2wxcFJCUlZOQlJW?=
 =?utf-8?B?SFhuenkyeEtQc1g2ak00b09lT3VBanVCcUk5WUJIbjNEQnpJTStRQjBvSnNl?=
 =?utf-8?B?U3lPNXhFT2ZvYnZKZTNoMmhYSzJrOWkwNzZ3RjkzQkdzU0NtbmpNSFhTNWdk?=
 =?utf-8?B?b1ZsekdWRDhiYi9VNzdUQVJQa0FuL1ltNGttbm5hTS91YmVhY2JCM3lidjJQ?=
 =?utf-8?B?YUZLSko1QjAyMS9nRVo5cEhHOWpjNzlBZkNUNmwxRDJFMFJ5Nm9wOUtUM0JS?=
 =?utf-8?B?bEJoNGloRm12MTMyc3hubFNTZVpMdmN5VjRPSnQzdE0vUFlSNzV0UU5pM0tl?=
 =?utf-8?B?a2s0Mk1vQ3dIaGpNS2c1SFN4QzJPYitySURwVWlWTXVEVDA1SGdBSmJtZ3ow?=
 =?utf-8?B?TlhDNWp4M0Z4eHdQZlNPdzdRTmF6TmxreGdZdTdEcE5scFFxZW9BdkdVbEVS?=
 =?utf-8?B?MThuMHorMXJMSmFTQWl1aUs3eFZFb2VmYXlTc05DVmRhQTRuS29qZXJNTUNB?=
 =?utf-8?B?N3YyN2FBb3EvRWNxK0VOVmZjSitNQnVkbXowSjJaeTBsTVByTkZ4R21oUXNI?=
 =?utf-8?B?SE8wY0NOclZDZ2F4Y0dDV0loUzB0dnNxSGFwWDJMTGQ0ZFVWS2IwUXY1Nmhk?=
 =?utf-8?B?WEt5bUo3b1ZlSFYzZEw0eXUzajc3RVJlcFh5eFZsODdHSVhKVjh5Rnk2SEFK?=
 =?utf-8?B?WGk3ZDRKVSt3YzNEb0FXK0JpVVg1UVo2R1lIWU1rbldUZE9KdUU3YTM5RFRF?=
 =?utf-8?B?dWxRQ3REV2UvZVF2OGw3RllHeHBwTGFPMk9VUFVWTm04cGltN3NHOXIrMElo?=
 =?utf-8?B?ZDBPVkd6aU1odHlFWmNlak14ejg4b1hJdUJ2c1ZzSWp3ZEJKTmpPQW51SVI4?=
 =?utf-8?B?MVJJam9qQVBwNDJVby9RUHAweVY0MHBmL0VRbUxnWUZJeE5XQlEvdkNueDVO?=
 =?utf-8?B?WkVjdjEyUjBxMVVYekJ3dGxsQ2daRjI1STFkS3RuVVZsZ3NHYXp3ZXlDL1dp?=
 =?utf-8?B?TnlpNVpjemZHSW1nYm1UNDR4WldpbCtHYkl1eFVEaGRIcGVKNW1HUlJWQXhJ?=
 =?utf-8?B?bTRPQlNzTnhWOG5naGFMWlhtb0txK1BtN3diMnBjZzZVY24vb2Y1cVhqL0gv?=
 =?utf-8?B?cXR1VVZTNHJHSGcwNGxya1BlOFVoT0JoQkZuL2dhc3NMVFVrTWJRMWhlWFVH?=
 =?utf-8?B?VThrcllOQ2t1Z01WSzh2NGJJVEdNZjVPQzQvYUczQjgvc25XMjVXYS9nbEhZ?=
 =?utf-8?B?eDNzQVArNEc2M1JObTlrSnVrNVk1ZmFsRlJnWHpaNGp5R2FVakMycjNtSVlI?=
 =?utf-8?B?SGhHckxxTkpmM0VkbWlNV2ZaZG43N3VCZXhwdVBmLzMzdWRQTGVIdnI5WlBz?=
 =?utf-8?B?OTFXekh5cjROVGxyanhOMGd4Rkd1Y29aSTI4L05ISU9tOG9CVzY1SmhTNTE1?=
 =?utf-8?B?RXJ1RXNheFlIYkJURVFlR3pra3FIVzJFS1hOZmN4RnBEUktyMVkrWFI0Z0VO?=
 =?utf-8?B?eWs0RC85WTcyME9HMHlkZmdqbEhWMzNYdGxNZ1h4cGViaVdXRUwxYjJDcmZs?=
 =?utf-8?B?VnZsWGNEbkJ0ZXpzVnJISWtqRllHSHl0cEJ3RTFUWCtHakxpbjBWOENZZEtV?=
 =?utf-8?B?U2pJcjFNbjdKYzZJQ0FpS1REcDhWMTRDZHNCZGNmQUVlT3BaK1ltL0RGbmJt?=
 =?utf-8?B?RkNoaDJJNWVkbm42WXlGRFhONHVmcE9QSER3WWlpSUNCd1B3d3BmTUtXakZX?=
 =?utf-8?B?L0hjQjdJK2F0MFVhR0pOOVNTNTl1OXJCdkU2cGl0WVpOcURjMjc4aW5hTUJu?=
 =?utf-8?B?ZUQxdTU5NVVCSGFHVzdmVVZHZnhObnN3cnI2YTVtU3VFTlpHKyt2djRTamk4?=
 =?utf-8?B?SDc2K2pwSEhwZVZVK1pnVFA4YXRJa3U4UHlaK0dlaTRQMVVtSHlUUWNyVWtY?=
 =?utf-8?B?UjlYK2RhUU52ZkZKWmVEVWRTeFpSa2JtMUQvVFpUSTFrMGhjMDBFdGZsU0NV?=
 =?utf-8?B?N09LaUo1OVo0TFptWGJEckxPZ1h2Q3Q2NkJTdWlzVFlPRzdXTE9iQ0gzaXlm?=
 =?utf-8?B?QnRVME44R2FkcFB3WGhiQnJiNys3RVpFVUQ0emp3czFrNlVSdW0rYU9xbFBj?=
 =?utf-8?B?SWRkVDZyYjUzaUVMNTZsNi9SUDg1Yzh0VWdUSmF6SVNXZ1RVY0VUUDNRY2JH?=
 =?utf-8?B?c2Zwcmc0QU1DbkZuTGV5U0laNDkxclYwN1lQRWkyMDZRVGhOclpDRGlBWFUx?=
 =?utf-8?B?WXVzbCtGdmtzYUJ5TUxhTHo0VG5nTFh1cThsdzNnbmt3MU1CRHdRWjVPd2t0?=
 =?utf-8?B?aGhkSkYwT3ErdnFCWFhyUmJaUXVBQTRlUjk0M2xJSkE5akZlbTh1QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3242d154-a5b2-49d2-e8bb-08df44f836bb
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 22:14:57.2149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30xEZPU5ro17f0KD8/lYmF9PCOMnVUnmxJLbaqLyHvFbnDRt1Y8+/85kFPoPBifSCGMP5gcf6UgeU95cRmbdZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFC596BECF8



On 17/11/2026 23:52, Mohsin Bashir wrote:
> 
> 
> On 11/17/26 11:18 AM, Mark Bloch wrote:
>> On 17/11/2026 5:13, Mohsin Bashir wrote:
>>> From: Mohsin Bashir <hmohsin@meta.com>
>>>
>>> In switchdev mode, mlx5 offloads police only when other actions follow
>>> it. TC needs no extra action for a police-only rule to work. The mlx5
>>> driver makes every police rule forward to the post meter table, but for
>>> a rate police it adds that forward only after verify_attr_actions() has
>>> checked the rule, so the check rejects it. The ok result of police is
>>> also handled as pipe. In TC, ok accepts the packet and ends the action
>>> list, whereas mlx5 goes on with the actions after police.
>>>
>>> Support police as the only action of a rule. Set the forward while
>>> parsing police, as is already done for police with mtu, and forward
>>> an ok result to the end of the TC chains, as the driver does when it
>>> offloads the gact ok action. The upcoming selftest series also relies on
>>> such rules for TC offload validation.
>>>
>>> The patch was tested on a ConnectX-7 in switchdev mode with the command
>>> below, and it was verified that the rule is offloaded and limits the
>>> matching traffic to the configured rate, using the hardware drop counter.
>>>
>>>    tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>>      ip_proto udp dst_port 5201 \
>>>      action police rate 100mbit burst 1m conform-exceed drop/ok
>>>
>>> Cc: Carolina Jubran <cjubran@nvidia.com>
>>> Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
>>> ---
>>>   drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 3 ++-
>>>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 3 +++
>>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>> index 1bd1c94fb977..52295f5d644c 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
>>> @@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
>>>                 MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
>>>               return -EOPNOTSUPP;
>>>   -        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>>           attr->flags |= MLX5_ATTR_FLAG_MTU;
>>>       } else {
>>>           attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
>>>           attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
>>>       }
>>>   +    attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>
>> This makes every police that is the lact action pass verify_attr_actions()
>> not only ok case described.
>>
>> what happens with:
>> "police ... conform-exceed drop/pipe"
>> with this not writes to FTEID_TO_REG so what happens once a packet
>> reaches the port action table?
>>
>> also what about:
>> tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
>>      ip_proto udp dst_port 5201 \
>>      action police rate 100mbit burst 1m conform-exceed drop/pipe \
>>      action police rate 100mbit burst 1m conform-exceed drop/pipe
>>
>> won't this create a loop?
>>
> 
> Thanks for reviewing Mark.
> 
> Ahh! I missed the loop case. I had a patch to handle pipe on the last police but I dropped it, since my testing showed the post_act table still passed the packets up. Let me respin and send pipe and jump on the last police to the end of the TC chains. Would that work in your opinion?

Yes for PIPE.

For JUMP, we need to check the target. tcf_action_exec() counts from
the start of the action list, so even the last police can jump back
to itself or an earlier action. If we can't offload that, we should
probably reject it.

That's how I read tcf_action_exec(), but please correct me if I'm
missing something as I'm not really a tc expert.

> 
>>> +
>>>       return 0;
>>>   }
>>>   diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> index 1d35c97aea0b..8685e41487f3 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>> @@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
>>>           attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
>>>           break;
>>>       case FLOW_ACTION_ACCEPT:
>>> +        attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>>> +        attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
>>> +        break;
>>>       case FLOW_ACTION_PIPE:
>>>           err = set_branch_dest_ft(flow->priv, attr);
>>>           if (err)
>>
>> This also changes rules where police is not the last action.
>> The conform result defaults to ok when it is not given.
>>
>> action police rate 100mbit burst 1m conform-exceed drop \
>>          action mirred egress redirect dev eth2
>>
>>
>> won't with this change the conforming packets go to the tc end table
>> and not to the redirect dev?
>> The rule is still reported as offloaded and installs the redirect
>> which can't reached now.
>>
> 
> Maybe I am missing something here, but when the conform action is not given, doesn't it default to ok? For example, if we have
>   action police rate 100mbit burst 1m conform-exceed drop action drop
> shouldn't conforming packets still be pushed up rather than dropped by the following action, making the action drop (or the action mirred) dead code?
>

Yes, agreed, the following action is dead code in software too,
a separated cleanup patch maybe?

What about packets that reach the rep? I don't see anything in
the ACCEPT path that tells software TC the packet has already been
processed. For example:

tc filter add dev eth2 ingress pref 100 protocol ipv6 flower skip_sw \
    ip_proto udp dst_port 5201 \
    action police rate 100mbit burst 1m conform-exceed drop/ok

tc filter add dev eth2 ingress pref 200 protocol ipv6 flower skip_hw \
    ip_proto udp dst_port 5201 \
    action drop

Wouldn't a conforming packet reach software, skip the first rule and
get dropped by the second, despite already being accepted in hardware?

Can you test this? The existing gact ok path might have the same issue.

Mark


>> Mark
>>
> 

