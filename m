Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021089.outbound.protection.outlook.com [52.101.52.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF03455175
	for <linux-rdma@vger.kernel.org>; Tue, 25 Aug 2026 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664502; cv=fail; b=l1A1OkLRidP90B/J+gv6XjbbcF2+rPTe04M8C1/7Q6mOiQZGFrMVQ1eABnnAkC0LZyk5ECMde3NFOKb9Lb4tFZDNWUE6iirEqr2COSHl3BGxBgrmqLh9GnBiJkkSwbggWcgRVLhmoIdM75QQKhMQclpTj8PaxjqtqLH5lQob2SE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664502; c=relaxed/simple;
	bh=LVr08K16W9u7VkJt1zI7gGJZg+TDSQobzqIEvXP4Ff8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nxlQd6Kz5VZkA0vLQ8QF3lngGv+8n8X1/AdP70O8Tvs4sAPXPDUtZbe2iHBhYpxxymEEGVSbZSzMnEBYkejb3GuqYGnBLF6pzYYI1FjS5482awVzAYEWCwVSnLM0fr3GKPlVssXcEIrSaGCWpB0675A5wxE8C/N11tvpABtqb8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=LU3i7H0W; arc=fail smtp.client-ip=52.101.52.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="LU3i7H0W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6pT+jOtd+lYm2TiEFwhsk53CMiWgo3fiMyCH3Btf6AOqyJIIOIY6pu4h63i/1cobZXDGrKso/iBGTJeZzHYqtz6KJ/yoi7EkrwWeO/4WknNVKOU/LZA9CxZAvkp+01KagGPhCLr+qsjm5tQ30iIwOoj1LfBqx8J13KALsUYSCYrHMIhW0rUR0HtEM57fHMnrXrAnxTmXmYeIQ0CXFwAs1Qjo3r1IVr5P1/bmaTfXLtAxY+cakmJw0ysfr6oCiOWfmsQrRExZEiv+vEw4rd6KVyhJqvOmdQ5/bk5vRmuDQtvqZSiLmFWN5XO21UCf/j7qnTwwuXouYVfkmF1ETwcMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFjWI9/9cbR9cAUEVe0o+XQf3HfZebSayLhRdkDw8tY=;
 b=JOSNIHV5pOE9zY3I9P5xDnqLtwF873sYw7gFA+74pkQl4aeUacuCmF6CD2/wTfdlvjZorb/dGWdMaYRVt9L+u+tq0F2So4ox9ZAP46X8oOrKlLM5bsT8mFREZqHLhnfVR2ZhgmBmgDtsn6LJivpsK4ZaRJl7SUFeF3TaTjwn8DBl8e+1EH5DDx7vYlitlDcap2xkvuVflc46gCTweyd8JGCivmG6XBJrVIkxdzV4PqqxfJZbhHX4VzNesI26WBWj+/MRxnh2RfdSYtUDPJKPqCTfG+mjEANWkqMnS3e3l5KBo632PAS0TDf9eRlVebt51TS4tO6vRSzje85Tlkkdzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFjWI9/9cbR9cAUEVe0o+XQf3HfZebSayLhRdkDw8tY=;
 b=LU3i7H0WsgtubZyIXlTACaBPPTRDadHllGhzsi8zu5z+zAwO75o8RZRTkw9qjsEAmuTeBtSqgpJs2IL5IcyP9cCyOz+405DVoFDWmWh4QTyJJPWA26EJLhBeVoQYKJ9O9vxpyhAFbnqvCOxIYu33nUsuItsY7nrk3Yd2WU4zTZzJSxglTJIKhcqmE9tRMcZMTYF+TCHY+4F/s119RhfXHd5h2oxLtCfFZlrgT3qiInrj24tp/MfRo6h+jnLElWQhmiWJRSwAbZwtMC+6j9QU2raaWlbzdXAWaUoMkHYmHtKUQBtZqvn4vgpvxzINKjtyFRDnpxQGGN7eDU+ZnBbg1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from SA1PR01MB7248.prod.exchangelabs.com (2603:10b6:806:1f3::14) by
 DM2PR01MB9463.prod.exchangelabs.com (2603:10b6:8:2e4::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.6; Tue, 25 Aug 2026 13:28:14 +0000
Received: from SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be]) by SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be%7]) with mapi id 15.21.0339.012; Tue, 25 Aug 2026
 13:28:13 +0000
Message-ID: <bf986ada-b869-498b-8aca-2497198a019f@cornelisnetworks.com>
Date: Tue, 25 Aug 2026 09:28:11 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rdmavt: Fix potential use-after-free in rvt_mmap()
To: Nguyen Van Tien <nguyenvantiennani@gmail.com>, linux-rdma@vger.kernel.org
Cc: jgg@nvidia.com, leonro@nvidia.com
References: <20260825042058.561-1-nguyenvantiennani@gmail.com>
Content-Language: en-US
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <20260825042058.561-1-nguyenvantiennani@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0117.namprd04.prod.outlook.com
 (2603:10b6:610:75::32) To SA1PR01MB7248.prod.exchangelabs.com
 (2603:10b6:806:1f3::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR01MB7248:EE_|DM2PR01MB9463:EE_
X-MS-Office365-Filtering-Correlation-Id: 06df158d-dab6-4bb0-e6ab-08df02acb6ce
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|10067099003|55112099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LqH03XCglrT1r2ItPzjtCpUJQ6gA3s+zF+Yh15XTU5NLpHtbEiDh9kG7d6MkhE9VpMv8bob7q29TN86qADWw057T3csAtuLxj5kBm5M1as+xWttUfqV0AASeE2fvg1y7YFgK3fUiX6oVy9ShaALe/8pc3T7SQdo785+Y2nhQ0h7CznNpBPyq3laNyTQxZl0fZakyEakZYpEetgtV2+hsJVvKvym9cnBsYiL/D1kTDrAhgqWjj5JsORAI3vlMrPR6POsuHZrHjguOa7UZ+vX4zNkElGydCV7w/+WAFukanmyR2fC0B8ptK5dAEObzFUuqXyDYJqvIVz75u9Sym1I2hdNvkyz5aLndb5Uq1m1nY3SuzHNuJS3iVPfhXD8u0meXwHyUBeQtOugmeoNWPHX4Mi4HVnHt1ND73iPFjnPP1n28DRJVCi0JMXvMCxe3hmGnvnJj5ZTGW75BH7ZK27zjCRDvcfa2q/DsQVYUK9lMR6fzvusvO/lFTmKaPID/z+kV/G3alsHgFdGPIoBJQ50I96qYKd81RzEWgJsBFB6unrdTM1kxMaK+t0st1CSDhXWz0g7M/hXDYYxFLwW5xMViLoUuC6o7XfwT8ExeBykMrkXA7LiYBKzxgocLf/lPfA349HkdG9doh/Dxq/RfCu4lpO68KTj2Nu7QrPw6soqEicM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR01MB7248.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(10067099003)(55112099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nzh3WmFJVE0vbERYNklleldjZkl6dnVBYlJLOHl6c2hZM2Y2dm9IeHZEQ0VQ?=
 =?utf-8?B?dkZINENkZThQbVlQR2RLSXI5UWdNUU1rdGRHSFhzbHhRbFgvUHlMbHpPdlBa?=
 =?utf-8?B?OFFybFJPZmVlbHBWa2xlNkNLVCtWY3BubDZ3UThST0ZuR3hxY2U4VnNTT2wv?=
 =?utf-8?B?SEtTOU5FRTBGL0d4c2d4Z29BdjdyejhoY2lRazdOS2dHa1hiSzlMUWFUQzha?=
 =?utf-8?B?Zm0rc1dXWkJlU1lJcmprSjEvTnl5SFl0ZVhjb2xpc2hITEFGNCs0Y05wYjhT?=
 =?utf-8?B?aE9Rdm9OWVR6ZDBpZEYrMHJNSEJva3QxMm1Lc0NnTUhJMi9TNHUwc1BuL0ll?=
 =?utf-8?B?VEs1V3RqS2M0VjdvRU00bmFKTjJGQkJLc05aM3pndkFlYlRWTHoxbGR5eGha?=
 =?utf-8?B?a1MxR0Y2ZlhXZ1I2cFQyeFVycHU1Njl6dm1FVzJMNHM3RVRzMWtNekJoUStE?=
 =?utf-8?B?UFJRdStLalhWb0FoM1MxWjJpZklML216RUtMbjVlUmozZDdGZFc1MWRVMHB6?=
 =?utf-8?B?WXJxSnQ1WktWQ3dxVjhyUGdDMnYzcStaTGEvcXM5WlhuTFF4b3ZXVXF2eGtZ?=
 =?utf-8?B?ZTNmUkc3SUo5cXR2UzdUUStnaHQxZDZJcWhRTHMwWklJZGZ6ditUa29GSllH?=
 =?utf-8?B?ZVdmL0crRlZEMGI3Tkh4TGNiUU1MMkNkRVk1U1kxYTRsWVZ4VFhYdmowRm9p?=
 =?utf-8?B?c29CcHlpL08zZDZaVlVDbXlsNXRSQ3hqRkpiR0NlbTY1cmtENks4REtNSFNp?=
 =?utf-8?B?d010ZjcycHpGZGo1Ukt2aGJQdHJzVVZvazQ3QVlkZ1JtR0UzNHE4b1c4VjlT?=
 =?utf-8?B?aTNhRFpZWjkzVG1VUUFDbTJwVExGb2hNU3FFejJqNFhxOUVJVjFHSHFCV24r?=
 =?utf-8?B?ZUtMMlpXZlNCMTJtbmZMTmRmWEFuYWkrSjV3Q09uQWl2U0JoVWRxbFFMd2JY?=
 =?utf-8?B?eUJiaURsNm1OOC95NWh2WE9qeG5mRk9Oc0M5RHBPMmpKTDl4RDJBMUlDSElj?=
 =?utf-8?B?Q2JsNWtwNUg2Y2doeG9OZldtL2tEZjB3RVBZY0tOUFJVUis1dVZNWHNMNWtz?=
 =?utf-8?B?VS85WVp6QzBGM3ROVklTZktIMEM3WklGd0NpNGhCL0ZmRFYvQWJueUZTMTBj?=
 =?utf-8?B?U2puSUx6MWtiSGtybzkrL2xCdTFIZzhFWlpLRVNPTDM1SHJZTjB4OEkvUk52?=
 =?utf-8?B?S2MyNmZhTm1ZRDBVUzVWdElRbVZqZGxuK0xiampCWW5yS1V4Yk83WWxMUHR6?=
 =?utf-8?B?Q25LSXlpa2RiU1RhOFQ3K3hmWFBVbndDREdqT1dxN1JJU08xSDBBa1lsZEhY?=
 =?utf-8?B?ZXdjQ3BXNWh6U2plRGJrc2c4U3RWTjZsVDhxUFljSVNDOFVLZnk4eTJOajNX?=
 =?utf-8?B?RDRibE1uVXV5RTFFL3RjQjl5cy96UnhaTzRoRG40c3VORzFDcS9BbUZNZ3Jj?=
 =?utf-8?B?UkNLY1l5bWpWV0ZMa09vczRJRzdRZ0t1RHJpWHlVVUJkazFLTy9kZGhzMEZS?=
 =?utf-8?B?VnFZUDhMbmhmdlZhQWVNSGtkTUVHLzZYSEs3VUJwVkZXZHhCN0lGZzFtWXlC?=
 =?utf-8?B?VW1CV3RSbHVMY3c3bnJGZ1dLRTdmZ2tpengzb25HS1NzbTRYdHFBaFlMb1Ev?=
 =?utf-8?B?aldzdU9MakFFbDI3TnFTT0ZtdzFYY2ZNTFd1a3piOWZ0Mkx2akcyUjNRMHph?=
 =?utf-8?B?TksxOHFxUjlacE9Yd2luSVI2elBhL1NqTWZrNWhJYWVCT1NzTkRvVVBqekt0?=
 =?utf-8?B?MkhaUHVzQUd3RzB6Z0J0d1hCanV6TEVsR0J5UUd6OWw0akdDTUJxRDZ3RHU0?=
 =?utf-8?B?Tys3Z3llTUtyNHFFdzdyYS84ZXgrSCt1WWdLZ3N4VDhYYmlrWVVQeWE0WlJ1?=
 =?utf-8?B?a1ZTaldjMXVxeThib2c4ZlprbktlTjA0cGlhUUpBemEvOEdobGx2VTI4NVRZ?=
 =?utf-8?B?aEZzV2RpYnp4ZVpFQnVqVkFIQzhpWENSZGJQVkt3ZDJzYklIdGdWSDZFekkw?=
 =?utf-8?B?TEpIV0FsdEJwZG1JUTZQa284alBncGdpejgzbnUyb1Z5RmxxTFVrcUJRMzJx?=
 =?utf-8?B?ZlhnUVR1bDFBS0pRcjc3NzVTSnV3RmkyZEJEWFhIU0pFaFM5ZHVuTnV0d1dU?=
 =?utf-8?B?VmU0YURtM0tXUjBoNG8yWmpzWlN4T09idlZBaHJYa3pxR1B0UzhmUTdmNDJ2?=
 =?utf-8?B?Tkx6aWZLSnhSTlI5K2JYZHkySlpTZHlqR3VYMU9oOHhYZEROR0RLWEJ1QnB1?=
 =?utf-8?B?eHhLUlVGMitqVFJ2YjJKZTArRlBKbDlZdndkZzE5QjQ3d25WZXVHMTUxNW0x?=
 =?utf-8?B?RVNXQnkrTzBpRm8zbXhiZ0JpclFKZkl1RExPQXVxQzF2c1RPQ1UwU3dKSjhL?=
 =?utf-8?Q?ba7rmah5ekL/b8pi/SVHLCH0DcwKdZfrQoZDG?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06df158d-dab6-4bb0-e6ab-08df02acb6ce
X-MS-Exchange-CrossTenant-AuthSource: SA1PR01MB7248.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 13:28:13.8167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DszCa6I5ibBzpGPHrkEtr07Gp1SxIIcanbqHKcofNXo52U1iS+D58q2tBcphlmudOq4py+qvRnrEZBLQ3TamSkU7XpUljdSpSdFXgPyzXHJCL36QPr4lyDab+H0ur/cX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR01MB9463

On 8/25/26 12:20 AM, Nguyen Van Tien wrote:
> rvt_mmap() drops the pending lock and only takes the VMA reference in
> rvt_vma_open() after remap_vmalloc_range() returns. A concurrent owner
> teardown can free ip->obj and ip between list_del_init() and the later
> kref_get(), leaving rvt_mmap() operating on freed memory.
> 
> Apply the same fix pattern as the RXE provider (CVE-2026-64582): take
> the reference with kref_get_unless_zero() while pending_lock is held,
> release the lock only after the reference is secured, and on remap
> failure clear the VMA state and put the reference.
> 
> Signed-off-by: Nguyen Van Tien <nguyenvantiennani@gmail.com>
> ---
>   drivers/infiniband/sw/rdmavt/mmap.c | 23 +++++++++++++++++++----
>   1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
> index 473f464f3..318e8877b 100644
> --- a/drivers/infiniband/sw/rdmavt/mmap.c
> +++ b/drivers/infiniband/sw/rdmavt/mmap.c
> @@ -100,15 +100,30 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
>   		if (size > ip->size)
>   			break;
>   
> +		/*
> +		 * Increment refcount and check whether it is being freed atm
> +		 * while holding the lock to prevent UAF, matching the RXE
> +		 * provider fix.
> +		 */
> +		if (!kref_get_unless_zero(&ip->ref)) {
> +			spin_unlock_irq(&rdi->pending_lock);
> +			ret = -ENXIO;
> +			goto done;
> +		}
> +
>   		list_del_init(&ip->pending_mmaps);
>   		spin_unlock_irq(&rdi->pending_lock);
>   
> -		ret = remap_vmalloc_range(vma, ip->obj, 0);
> -		if (ret)
> -			goto done;
>   		vma->vm_ops = &rvt_vm_ops;
>   		vma->vm_private_data = ip;
> -		rvt_vma_open(vma);
> +
> +		ret = remap_vmalloc_range(vma, ip->obj, 0);
> +		if (ret) {
> +			vma->vm_private_data = NULL;
> +			vma->vm_ops = NULL;
> +			kref_put(&ip->ref, rvt_release_mmap_info);
> +			goto done;
> +		}
>   		goto done;
>   	}
>   	spin_unlock_irq(&rdi->pending_lock);

My AI cranked out basically the same patch. Only it will be tested and 
reviewed. I'd say drop this and pick up my validated version. If you go 
with this one the commit message should be updated to explain why we 
aren't calling rvt_vma_open() anymore.

-Denny
