Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A402EB84E;
	Fri, 31 Jul 2026 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505955; cv=fail; b=jJVWfbvPpHOg8SD+QndDMyT8ad6wT+uxQcHYz85nk0S0P7ykIro6RKdV3/IweUVu9gegbHd1uJGZZL3dWkcVxd7mEOeCNgrTTo1/g/T7PjTcRmFP0DwO4KDvo333xD11hImCAJlenz28wPpS6lHA9yrF/XWn2DtBdlfTZNmP4V4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505955; c=relaxed/simple;
	bh=+XNMJoMUG/KnFzfJYrB4zjy4eQ8pdRnjQqpkJD7tjLg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=doCipjrV9YXEfowqtAFulLLy1g4bLnzOTcCBT1vXF306vS6c4wA6Gg3GxBcSUc5vCi3hikIa7Ce79v96f8qSkLKc/h6JVZ49Vh6JyXVsyXN2YMaJny4oY7dSoaknJppCWYOuGp+RPHyR8HdkWX53SiJa+KQeH4uXADqH8LUq9x8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kdffkY4Z; arc=fail smtp.client-ip=52.101.46.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kdffkY4Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8LBrDxQnZo7B1N9UiyMl+6H+BQhT1DxNtXuiIrDGPUljUQCU6SOiFrJ3Gsm+GGL7e48/mO1hlJFVotL+3UhQyh9oPmeDyAMXJchYD4WHGQm8h7ugbIN+U5EzdZnN0vKK1P25O5IS2yi6kvmmA2mTflWQj/HCyHLQgAuVPfNWXJyumM4H/iS+nqaEr4jVxHLdDlp2t/K4CmHcdF2jP2o3v/gTSRzLTkiv3LbyE1/EkuKRQLFZpZzs2MWxtsqcZJo1f7PzD1URVXdx4QI0VA6REINYtneNBEHlDHTEXzl8K0D9Sngh8Mo8ysaLwoecwcPGkFnRVTZaet5+tQzCc11RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jmbIFSkZcAcOhbc18zk1nAZwRVyXS2vgSSsXsENgCA=;
 b=U9m/lSHSysGBrU/wGvY5wF8ZAtZEY9nYvOzZe+ApNs4qItbMTD+C+gr24FfJWGNvdPq2iAgAWsB3KGHt//hSY3x+CMAptAMxmHy0rWIi1OmY0EafnwS/fyCiZ91xHeB0KON/ahbpyIwxL//fcOt3hEFvG9xz1Q4YbrYi49jACV3/cWKF8HcNHGrj+gZN7dseXKu9vD9gNomkojg9c9Z4ZQzMD+8w1xzm5MF8QnEBJ9ZbuB8VKgbOLpL+5AWSFLVrjax/llc6I6mGlEsg85ENFHtIHOl3Rdj5n46eC454/S0FTyzAwGSYMrWFSmCE/AO4VtD32VJlGa3LebwtFe5WKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jmbIFSkZcAcOhbc18zk1nAZwRVyXS2vgSSsXsENgCA=;
 b=kdffkY4ZXbDCNNos3gFwDUdtqmMYAW8/vEN7Qxk6VOZV7zDukR8nD5rhGAM3c9e19qsckokbmBDQ9XneZi6rZS7S9YgkUcccLCFv9vL0RKzndQbabYgd+Iz1kxJAuSLlf+p5K+tzENEK9yHHMGvqo1JJ9rVnO7+dEsraUJRep3X/aRpR5TGX2YSSxROlezP+hGrggoM+BdSDAvcKG5C8su1AofhX8JHrc3g57dfAOXEYdoDls7ZTDseecvcUcmpckfeHAl9pdSldDcQW3kqihhEQOVjwpm4lStl/A/BpuxdPXS5Jj83tkaelJ0a8Cbw3voQh/pvmkFyCHfaTO1AkFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by SA1PR12MB999108.namprd12.prod.outlook.com (2603:10b6:806:4a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 13:52:31 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 13:52:31 +0000
Message-ID: <716eaf68-6168-41fb-b705-e14e84910ea2@nvidia.com>
Date: Fri, 31 Jul 2026 16:52:25 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot defaults
To: Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org,
 Jiri Pirko <jiri@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
 <20260716084852.549909-5-mbloch@nvidia.com>
 <20260724161111.2ac47089@kernel.org>
 <c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
 <20260727131033.237f70b6@kernel.org> <amnDfSmMVzpiH2gE@FV6GYCPJ69>
 <20260729160608.3c491568@kernel.org> <amsu3mbWht_pc4KJ@FV6GYCPJ69>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <amsu3mbWht_pc4KJ@FV6GYCPJ69>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::17) To CH3PR12MB7548.namprd12.prod.outlook.com
 (2603:10b6:610:144::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7548:EE_|SA1PR12MB999108:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f98cbef-b008-4d7f-720f-08deef0af70d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|4143699003|11063799006|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4a3H1Wugmk0qd0QCQR0xIpF1p478BNQKPKMXZXofTye+e2zy/ph0jz91K21sd0qsYFT2N+TGz9Sglj8LYaEAV7xq0k6ybudwge9o/YKwigSKXJVQJ4z+IVSOKRtxD+7AmmYBb2YUlLW2HgzqbleZ4qx3pXtcbgn3U4i2krnG7qtGxg05f973jQ5lKBp0C7BPBDvunfWwG6+nMZaJbujFjLPnthjdQgZI6Qddov0Yx1b6ohNLTjot4YxlCNabYEKt3xhcqHt+Ip6Yv0wX7TAcEijp6whK9SH/UtOpfHks8ymhXQhEQgO0mVhb8vLNFzGKTEym5aRPT0+wW0YUuN/zWBOUdM07VefxTh5Spm8YyddDeQ7XmhO+FfdAwVJW3Uip4Q9vCvOkVMCXE5BoQjprJV6+yqcxee2LSmu54QFWqtDqRcqI+AaYNOhdjSq/N3MLxnnnvq08R4DwSz0B4Cxj1s3FEVTElT6A2z9DHH9LZjmghQGH9Jdore0qkh4VYCoZPO/+GnOCMg7z91YEpDm3vSUJ+49HS9MPNLMTdOf3qWwTW+ewwtavxTuXItFArEYnKLs6QtoDaB7cwE3Zq3XFZ9YHOXbwkvx1NkKHKktp/Qbt696oTiYtxCUOQPGjeuNGQG93sb6AnBylnvCsnhTceq2ax3b3bLlk8x49H+mTL/c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjhNNElpbmdTVEh0NXZtS0RTZzNRdjV1QmRlRVU2SWRabGdBaHljK3pnam1M?=
 =?utf-8?B?dzQ2cGZRdTY4UGk1blFSVzljbk1NK0JiUHBPbjh6SHJuMmFxVUtXT2d2cTdE?=
 =?utf-8?B?ekhURHk0QUNpVWNPNkJ5Y2NjZEFTdG1yV1FDZzI0QW1sV3YvMDdRQng0bXdR?=
 =?utf-8?B?Qm5mUmp4TzlkeUJteDNxMlduZjF2NE42d1ZtSms5Szl5R01uekl2VzB5NXJT?=
 =?utf-8?B?Z0dOZmFKSTdwc2w3TEZVRWJTMGlScjh4R0dybjdkRExNNVdLaXlBQjZPMkoz?=
 =?utf-8?B?SXhFSFRLNUVXY0tvOUFpOFk3YnJjckh5ZTZsaHpjSmVMWFdIYmhlZUhkV0or?=
 =?utf-8?B?eGYrb1UxNWZpQmpIeDdiVzdaUGh2VldBZnNPeXBZMjJ5cmpGcSs1RVgyOTZz?=
 =?utf-8?B?WnlhMkhXaGJ4UFo2WEdnYWtVNUhhZEkwMFhXeGFwemhKdDFBZnc1aVNZdGFT?=
 =?utf-8?B?UUpKdU04Kyt6dktXOWFFcFNsTXhDa1l4cmFkWk15R1hlK0VlK3NrL3JLOTFK?=
 =?utf-8?B?ak4rOURnbDRBb1NldU1KbUNNVXAvNHhuRUhocGQyTCtXaEFTQmwvNTl0TzVO?=
 =?utf-8?B?TlowQTBYdlBiSE5zQi9Nd3VFbGJXdUhpeHlEcEp2ZmxtQ3J0VjFqOUQ0eDNa?=
 =?utf-8?B?Y2pyYjEzUlhDREdTSTBKbEVyTnB4aTYvbDFSbjFabzQ3OWlPYWJtb3d0UVY3?=
 =?utf-8?B?U3ljaENBUmI2emR0am1zNUZmakJ6ay9OaDRMR3NRRGRuaWt6S3NScFo5c1Rz?=
 =?utf-8?B?Qjl6Y28vYTk1alc3U0dFQkkxVVlDNmhmNjNaaFdXSk9aM2M5UGVQR1FFMDJn?=
 =?utf-8?B?eEhxMGxwT1dPN05mV0tqSTJMWjhHOExiQkVZRmlIR25XTHRkNDUxWndxZnZF?=
 =?utf-8?B?bGU1WTRZN3dWbWJ5bVlXT1dvTEE5OVBtZ2EzUkx6Qmt2b28xUVY0WHhIQzl5?=
 =?utf-8?B?bjBLWXdUaHI3VTNIMmg5NG5wQ0phRlRFVTBCTlJHQmc4Zkd0RHh5L0FlTmg0?=
 =?utf-8?B?bURxQm1Wa2o3Ujdjd0VsRlE1c29CVWRHNnBTdlMzYlE3VCtKQjAwNm1qcVNK?=
 =?utf-8?B?dnZuaHJCbzRzM0NSV0lkVGVvL3Qxb3IxOExFcXFEK1ZoaVlFdlBCK0ZMeXha?=
 =?utf-8?B?WlE4N2JiWXZLZmROK1FhZGZmSVJCVisyZ2RjQlQvZzdTUVNZRnZQcXp0ZFd2?=
 =?utf-8?B?dEljenF0bm1acnNWZ2RtWWwwZE5CeUR4VFFqb1RWNG9CeVpnVzFuRXBYWTBo?=
 =?utf-8?B?clN1cUF5Q3k2RTdSQ24xUXJPWHEyazhtc1ZSYjRoQURib1hhcFl1d0xJSEl2?=
 =?utf-8?B?bGwySnAzdzlBU2lvNmtJUzdkejJaZkN2aVMwTUFVRFlnamJkdFowc3B2U0tH?=
 =?utf-8?B?TGxzTHU0WFIwaldpcGNONTBhVTQ5V3o0ekV6L21CdVI0UExhVE5idWtrSnlX?=
 =?utf-8?B?TUxJeW1WbmhkZ0FPSjNTRitMRGUvWkN2VEFkcFd4ZjVwQlYzanRXNHRTenVB?=
 =?utf-8?B?UkgxVWxVc3c2VHlKYUVQNWhseStWM0VJajhBbExRa1QrQXdlMS9tWXRyZWsz?=
 =?utf-8?B?Y3pKd0djVmlDODNDSngrcHRoYVBRaUJQNjQvMVVjeU5TTUZleGNqb0NmOVhP?=
 =?utf-8?B?cm1NSDJxaEN3a3dnSlZHbnNabThRaGFwTkVXbC9zWUZWWGM2K0NSZ2pKRlpX?=
 =?utf-8?B?dTJvN1FhWmJmYlJRZEZHcUxFb0NXOE1ocUhwMzkrcFRrZHVMd2pOSlZnK2xC?=
 =?utf-8?B?em5MNVhuMHN5aVA2Z21pZTZWdDBGRGdibnJic0EvL2ErczZkaWhPNDd0akVo?=
 =?utf-8?B?V0w3Tm42a1NKY2tpN2RPaEZlT1AyVWNMbTZETEF5ajQ1QVk2TmtwdUNaeVdK?=
 =?utf-8?B?MnpGWGo3UlpxOWZrZVRlRjE5eGxQR3hTY0RtSjlaRWN0dFBkVjRWSXhmRHBF?=
 =?utf-8?B?enA0Q2VNS0VnbWJ5NEliaGUwczN6WUM5Y2oxR3ZQSDdvM3FodzFqNjVITjR2?=
 =?utf-8?B?WEtvOWsxU2lCcEhIMVZCZW1la3paTDJrTk5ITkdUTVNYN254c3pubFF3eGVm?=
 =?utf-8?B?Z0xCaHIwNklxMmYyQjNzNFI1dnBOWkZvcW4yU1o2dElwelpKUzBxYlh2N29B?=
 =?utf-8?B?NGVBc0xiKzZ4NFVMWjhLUFdRNFg4TUpWSytoQ3hEOUxxdXgrVHFrR0g2bVk4?=
 =?utf-8?B?RFlhdlRmbXBqZzF2RFdKaTVzV29uckFEeFUzVXlLM1RrRkxGSnA2VVNLZndP?=
 =?utf-8?B?Nnc5bXhtUGxtNmd1M21PUlBmVEhES1NrSkFTSi8xc2FWTCtkUVhGaDdpdW1E?=
 =?utf-8?B?N1lUb0ltVW1YUmtvTEFEMEgxaTlvTXpBSjRPemh6bm5nQnlMN2FHdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f98cbef-b008-4d7f-720f-08deef0af70d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 13:52:30.9274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7OvluKzFd/2+kNs41pSf0JtkFmLtOiRY0H91zZtIZDhia2XPhrZ7/88c91WI0Q8gVak3k7upBbKpkz+niP1wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999108



On 30/07/2026 14:00, Jiri Pirko wrote:
> Thu, Jul 30, 2026 at 01:06:08AM +0200, kuba@kernel.org wrote:
>> On Wed, 29 Jul 2026 11:11:53 +0200 Jiri Pirko wrote:
>>>> Maybe a middle ground would be to add a dedicated devl_init_unlock()*
>>>> were we can stick such init? Slap a WARN_ON(!registered) in the normal
>>>> unlock? I don't want the normal unlock to grow in complexity like
>>>> rtnl_unlock ended up growing.  
>>>
>>> Yep, that was +- my idea when I suggested this, to have this in a
>>> separate helper.
>>>
>>> devl_unlock_in_init()
>>> ?
>>
>> Maybe "after_init()" ? "in" sounds like we can release it multiple
>> times but I think the idea is that it's the final, single "release 
>> into the wild" unlock.
> 
> ack

Just to make sure I understand the proposal.

AFAIU devl_unlock_after_init() can be used in one of two ways:

Convert all devlink drivers to use it for the final unlock, including
drivers which don't support eswitch mode setting.

That's a lot of churn for the few drivers which need this. We'd also
need to make sure existing drivers are converted and new drivers use
the right helper.

Convert only drivers which support eswitch mode setting.

Then applying the default becomes driver opt-in, which AFAIU we were
trying to avoid. For this feature it also looks very similar to the
explicit apply API Jiri objected to.

Which one do you have in mind?

I don't think either option is great. Wouldn't it be simpler to queue
work from devl_register(), as before? That keeps the logic out of
devl_unlock() and doesn't require driver opt-in.

Mark
