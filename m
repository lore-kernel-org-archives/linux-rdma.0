Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021141.outbound.protection.outlook.com [40.107.208.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9B02DB7BB
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115181; cv=fail; b=h7wwyAIG6bgqpTQ942kStoQhPKRyRKdL1S0UTanpgeQwXG+AF4q8kR/eRqthVUjbmRndXfR/11qI1gm7ZJ5l8r5mqtvsDQmSdcSYqURCzTlKFjryJtQNrfZqoVfB4o1QpMuJlfyhXltbsgmEgfQh5rHTMc6rr65JBlVqwTz8FeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115181; c=relaxed/simple;
	bh=AvgpiV63CMLS/vuOa4Prkrpfm2YzO62dhso0pMjD3ng=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q+XFjv5N1D/7gOYHN4CQaqzlP62MZ0g8TDcTI0g+A8d0oFGyltMArotgMo9t1DE2a5eEfwQTI+TjADS296Tmwa+iPsWCgtKrQv1wLcXxExR1Q2X4ShZ+nIVa1Et2FR+sTDEjPR+kDEsEgRw+LDoUSJqxmSnD4g3odJEdw7YZJLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=bKZWErOZ; arc=fail smtp.client-ip=40.107.208.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="bKZWErOZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sxX25//9LIyafA9QN8ogspTV24+XTPe50jtcSGO6Uf7TjAt0HUHkLr+aedPN3wjdTtFHB56oUkrSJVhRHnCYJ5SjH6Mc76N4gB7mpxNKvX/ZJYUvTt1udR4F/OzYgCX+kj34MDpXgHsA5dPBa4MOmwi1TISx3Qi/rcS4BCqzN5s13ZPcd1kCcG4+h87RtfXvl5zVXazLT5YujBJVjunwGRQb+YmvmPdRYZ2xun6Zf+dxRCfvMZuC5APQuRCJSBO3iXRkXIHDPADRyDDVyZZRrfy0MqFWQ0l5i9X/PuQthk0kGa9zV8VpcZUAbDJLX5oPKDJog6JXQp4/TPDA8yGQFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtUcreRSuWa7Vr7yTF6MrswYy+O+W1qOVGnEUzu856M=;
 b=qItNIaUw4elavhPrsOfVDCSB2TmiXH90JT6e0d1rBBWv0zLod2v2GfVuYqs/ut2T/Xck6oj0m0qzFqv0j9DYv105LlRXzPKg4HNrnYXyQTlCpn1z7GbDM0PMQQrMQuBmwKS+zwzD31YtF/XkTE7iuor4eizLvgW+xNI1oKK06+XDKCID2X/o0eiStT/xi2XO/6Nt8eFHcC/0tXc46IbnQXLYywm4AQzsSbKdyPymGuZvWglVE/cWMeLgQ+HoJK6mjB3QgiH3McJqZggg51y2ehs0ftQxNr6OvcUepu8WDxrJYD6UOEujm1OQbgt4Oax6HL+m9Ae6DX34xiPTOuSlsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtUcreRSuWa7Vr7yTF6MrswYy+O+W1qOVGnEUzu856M=;
 b=bKZWErOZgxYRC2mLnCBFZm4WdoiTHe5NRN7TDA4YIorUdlebdaBLHEyoO9LC7UOyxmoRJtLgJQLRfjNwqCKWiO6kXMSKq/NPDiijgoLSSC58FKpgN/+A1O5cYr0qG6mNiAP+KmEwEV65eqz+EE5UGLMHtqBFObrIptoecssIF94QCLHwtARHbrVZedweLND1S3Hy40iADG/YgcNISBv/J0dbN1Qo1AU4xLx9R4NCYCIosrEBwQcMbf17tVZ7FlKTxBaiPUPx7FtXr0LH+jnI7gGrM6x6NGwVuXI19KkP2dTo4I4XrKN06H+yJ+6VUwHj13M3nEFSFcZhdfJWgTSoSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from SA1PR01MB7248.prod.exchangelabs.com (2603:10b6:806:1f3::14) by
 PH7PR01MB8542.prod.exchangelabs.com (2603:10b6:510:2ed::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.21; Fri, 7 Aug 2026 15:06:10 +0000
Received: from SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be]) by SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be%6]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 15:06:10 +0000
Message-ID: <dccb461b-1a11-4275-93bc-eed163d1ee51@cornelisnetworks.com>
Date: Fri, 7 Aug 2026 11:06:08 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/hfi2: Add MAINTAINERS entry
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org
References: <178603994025.3611040.18003173777504573447.stgit@awdrv-04>
 <20260807141820.GC200537@ziepe.ca>
Content-Language: en-US
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <20260807141820.GC200537@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:610:11a::14) To SA1PR01MB7248.prod.exchangelabs.com
 (2603:10b6:806:1f3::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR01MB7248:EE_|PH7PR01MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f1473bc-74b4-4046-fc40-08def4956a43
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|10067099003|4143699003|18002099003|55112099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BC7/zmwQubO6VnR6MixylP8O+E2szi02ttuPECvPULke/GpzkWM/EWlbKys0KE1Xj/y/cgThTRtPJ28JGlEwfjNe/u5cgYQoA10R0M3gUD105HJFotItGcru2p2rIH5CJwnXks/ifsNlZcfGcqN5/q8f2VDsQIvCO+5mI+idNfFLKzYHPRL6IWZ+8XmBAIxjskc2hiZVKWcEypqJ9soKN6s9HzX22B1wruNC3MR9DQh3Jbj422MFbSK99LO3OpLX7xqBjLgmJCzCjh9ELkTaUAhN+TtRUjJDqYqxMBwVgpxF0yrXt4Xr/zUzxU9eaSrTeP+9Sst0u8482NNxM7H/jAZ8H9lHxy9yvmuu288y+VcxTwKkZztQBwFsXYmVSpF2uUWKLEGX2PCGGpCVOmBP2oZgAzXEaCdiqDZwfXrhKHvMn5WS2XXHFdIFumGhYRy4u8eIIUhZFLl0uDxoIOxckLdL3+Lv2t8lXRpO7TOea8+NIyzM7VCbywCwynSVWARwTMjDXxGh54N/5yQWw+KMdMFdiZ9C33YfUgmYyZezQiCreVowB+qZ+paZQSkZuoFJsgfNN/NiC4s69w+FbSOjCpsDK4WAeJXFaBodNluLJM/7Y7DmyX2o6VmMqd8xVfoe6qfc3fkPguv4e7k5vd8q8beBXDB8jse9cpD1GZtacjo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR01MB7248.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(4143699003)(18002099003)(55112099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dUFYMFRQcVZHU1hCWjVETUthNmVOaXYvUVlZWm5WV29sdWU5WENkUlM3Wlo4?=
 =?utf-8?B?Vk00ME9zcEowbmZWYXZIbWRlcU9YaCtLNXZXWXpETTgwUjdJZDhUQS9kQ3Mr?=
 =?utf-8?B?RUp1clNaRXA1dzl0OU5NR1QrbXlDZGtFZTRETlhlRXFXcTNLTW5nTk1QTW5k?=
 =?utf-8?B?RUtBYVRmZDB2TU5qRXBETkV5YVpIRGhFN3BIZFJUVDZ2TGRLa2lkSUFqY0Ru?=
 =?utf-8?B?UzUzbWYvRDlqV3poWjJ4NXpsdlRRTXVnVUJjQlQzZDU2UGthYXgzSVZhME1j?=
 =?utf-8?B?WGEySzhxcGlnaFBvNkRJN0dJM2hQNU1nVHpoTEZsZ21rcERGaXplaDFwUks3?=
 =?utf-8?B?d0t4MUNTNERZekhWN3VTOFQ4Z1NsT1VkeU5BOTdYT1pFQUczNXBhQUhUcThH?=
 =?utf-8?B?TmFrd0IxcHY4a0NYUDU2TEVYUTVQYmxoRDNIZ0poQmpZdXZLdC8vZzFlUXZt?=
 =?utf-8?B?d0lKc3BCbHFGRUFmcjdVOUVLNENrd1N6U2ZaRmZjS1k1SnFtaXVrd3FwOGM4?=
 =?utf-8?B?REVaQ0czQjZENUZ5OTNoT0pQQ1hBaG1RTmgvM2t6R3FGQk1tM0Z3SHdOcTFM?=
 =?utf-8?B?eTA5SU9XU0ErU09VRzhveUtQcVFDcmtuaFJKSXRCRkFSOExGaVZkaldkaHJX?=
 =?utf-8?B?eVZVYkU3YXpIZU1NMHdsRi9zTkJkYXpCSkVKWXR0SkdYMVpickcrekYrYmhD?=
 =?utf-8?B?RVZUN3duZHJpMU45bkkwcGpldlVrd3ZJV21nTzhpRGZjMzFrUU14V201b25U?=
 =?utf-8?B?NS8vSnVsOXo5ejNyR1g0OHZJckNlcE1oeVI0TWNkQ25ZcUhld0U5Vzc1akYx?=
 =?utf-8?B?ZWhuWHNUZ25RNVMwZVAzUkVHL1JxcFZCL2pXb3hxcHViZlFVWDRBczVIbTY5?=
 =?utf-8?B?L041cVgyTmFrTUl0b0hFS1F4c1VkSUtCUzliSUZCUzAyK1VQQWpGZVYxWDhy?=
 =?utf-8?B?a09CcFdyNGxWc0N0WkxlWWQrNWtrNFo3WWR5RjlGV0ExVDQ0L3VqVVRrc1Fv?=
 =?utf-8?B?QktURUV0WWY4WUhiNDVpdy9BaGp6ZjNiL1hNTjNaQXdxallUcDdXRkRDVXZN?=
 =?utf-8?B?clpjbVZsWTFQR1ExdHFoYVlWQWFJZVJZMHpqR0tiMHdrMkszaHZCaXJtZ1JL?=
 =?utf-8?B?MDdaT1kwM1RPVjF6NDFxYWthZExibkVwVnplTU5ZSmVYVkQ4WXVJR2lXbFNq?=
 =?utf-8?B?Tkh4M1hBVzZ1NDdqb0lFMDZVSFFiUFluK1I4T3lENjBHcTdQRzBwYTZldzgx?=
 =?utf-8?B?ZEU1Y2VIME9WRGhad3dJL1piMlErVEZ4T0JqNDI2RDViYnFnbGJUMzZXL1Zl?=
 =?utf-8?B?UG91RTBKUytab2pybWJOTmh2OTZjWmJzVWhpNXVXZWFsQUN0Zi9FK1M5Vm5u?=
 =?utf-8?B?RU4yZEFlWDVuaHJjVGRmK2dmWWxVNkt6aFpoQWl0dEluL3N2TkduZkY3Y3Iv?=
 =?utf-8?B?VFJSWlFySDRDYU16VGZkTEdIQWJOclhkZjVVMXk3UEhmc0R6d3Bhd2VYMVdw?=
 =?utf-8?B?c3owZGI5K0xDdnhPV1p5RzU1bmxRSXdWdjhJWHpWTEF5V2w4TkEyNVpvdjN3?=
 =?utf-8?B?NFN1TzI2d3dSYWhTdWJXbzhUSjFTZ3VDeHJ0OUQ3VTBCTDlsZlVwWXdLWUMw?=
 =?utf-8?B?bENabEJhVkZqNzEzdVZ1cy8zMWIybUE0YTM2a3dzODUxWHZUZUtNQ1A3blN1?=
 =?utf-8?B?SGx1VUs3c3BteTU2cmR4cXJXS1VPUXlwQi8vaDlqaFZ2bjRwWGNQQmVVUVA3?=
 =?utf-8?B?dlRLY0szRThvYm9nYVBjdXg0Z0RXR1FLcHlLd3hqalN4SzN3STVBS0d1V0JX?=
 =?utf-8?B?RG9abUNTNWRzRWt5Sk9mSWhER2paV3hVNnZzRU8yQ1NDYWhwY0ZpM0NmWEk2?=
 =?utf-8?B?M05lY201S2t5NnRONkhKYk1RMGdYcEY0eGt2cWlwdlA1c1dMdGhsMFFONjZx?=
 =?utf-8?B?azlIYmozdi9yM0paOXJCd3FZOXIvK29XWUFjcjdFR1djS2tzTUhrMG9PRG0z?=
 =?utf-8?B?YlZQOU9CanU0MWpxUzNLK3BMZ2F1dDcxQ05QNjhEV3grZXQ4VWIvNEFLZisv?=
 =?utf-8?B?MzhWem1DVnZMT0IvY3dCUzZ5bWpKaVNmTytLMjM4cE5ObmZsQkNIZUx0eUNW?=
 =?utf-8?B?ZEdWYWM5UzlyN1AvWS9yYkZuVWVrS2pZMDIxZ2FqSlZIeUVCSUZTU21sa2pH?=
 =?utf-8?B?QXllSEdldy9Gd0ZHNVN4K1hZWDhZejZiNFJydCtnbXloRzhJZlNoMEo0TC9Q?=
 =?utf-8?B?NVFQZUdOSGlHbDc2K3dDZ2NZZXlaK3N0KzRrRk9wdFZ6d3k1TGk1S1J4TXA3?=
 =?utf-8?B?YW5XS1k3V1dJanZYcW9zeFBLN1ZEK0NTbFVqc0lveVBFK1l5QS93MGhqdDlQ?=
 =?utf-8?Q?jm8K5ZcB0HbJNPIZz9yAMSeqdDdHTqACEYOP6?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1473bc-74b4-4046-fc40-08def4956a43
X-MS-Exchange-CrossTenant-AuthSource: SA1PR01MB7248.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 15:06:10.7136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S90V0MKdzRwzgLdylTyyfedp+mzQ2IscKQIKu9yefvMj+oOpLHjgbzRaz+wV82N0UEmbK5lLo23JYd8NHvJWkApUB4Do0fljxVmSIo6COKN39XsSU54P7KUBjLocVq5Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB8542

On 8/7/26 10:18 AM, Jason Gunthorpe wrote:
> On Thu, Aug 06, 2026 at 02:12:20PM -0400, Dennis Dalessandro wrote:
>> The hfi2 driver was never given its own MAINTAINERS entry when it was
>> added; only the pre-existing HFI1 DRIVER entry covers
>> drivers/infiniband/hw/hfi1. Add a matching HFI2 DRIVER entry so that
>> drivers/infiniband/hw/hfi2 is properly tracked.
> 
> Why all these fixup patches? Put all of them into the hfi2 series and
> resend it?

I forgot to add a MAINTAINERS update, so rather than re-sending the 
entire gigantic series just tossed this one out quickly.

> I don't understand the RDMA/hfi2: Sync with upstream hfi1 fixes and
> cleanups series either..
My thinking was this would be easier for reviewers to keep the "base" of 
the patch series the same and just apply the fix ups requested and keep 
the other changes that went into hfi1 that need to come into hfi2 separate.

If you would rather have it all in one series I can certainly do that. I 
get it's a boat load of code and want to reduce the pain on reviewers 
where I can. Maybe that's a moot point though.

So I will resubmit just a single series with all of this stuff combined 
into one set of 24 patches. Does that sound good?

-Denny
