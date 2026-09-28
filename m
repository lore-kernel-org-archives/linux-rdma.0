Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11020112.outbound.protection.outlook.com [40.93.198.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E52F4EBAFD
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609420; cv=fail; b=PGvrR2D8PW4lzOPr0roN3iCdXUAn3GLGj4eL4JC2RA0VJUoaEYKldHUcxE/SekSC1l3BJ/L3CnaugRTuIM4EsLvQPc0eDmO97jdXS+/htk/A5qidYbBZ8guw5W4dwUu72SxBo7HaozSiqis3qawMuXNJTone1feuLlJbrkHZgT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609420; c=relaxed/simple;
	bh=wjofqcnSqunnTU+TVoZ0TxZT0CjNN+pPPQYZPGvi+l8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N6XSetBjli1sNkt/6POEOQQqRo67t4amVt67vvMBxVFBd5K0lthe4iJWtODc0WEDFLznzwauKgXlofdoZ5QMdvjLv54gbuskK3Ms5EhoaaiZh4qELke/qg4Uyef4KIwhtuojVIEzTH9XsXHN35PjkkGMvXjMTDpEMx+DEckgbMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=LEa5AfJo; arc=fail smtp.client-ip=40.93.198.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="LEa5AfJo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pnfDxGC7kzMuDqTIW/mdRwyXBNTbo2/zkBJfF8Nqb2/LcbuNYPED53KWCOwbVWyYb6RKOeEy7xwesDVRFiIZ/FmqrlqCg+1ed9BCFyjBW6TCosfPkBeuIlwV1iCRtWe9EIjR65DcxHhvp992hhabQoypcy4vk9H1u0YYDojqvpNsDeMyoIIWiawC2lokIkREm69qF7KiiVIOh6tMDrgVMqAJ+ZQH6YcZYtSTLtzVeqzinE/YKU0oXKVyoshxWSO8ftapMbquRqKP3PRip2seeEzruIYayomF1El19jEfU5w9Mqull6UXYNJB1qd0d07BTyPP59EPpF90b3sviiVcBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rd2EaOlZ8QelZd5vI+XRv38Cg9UNCgwJeG4orOLalLI=;
 b=wrUWQFbTgs6vG+qaVU6GGyYvA6i4oiHtqcqJz2vovxzgHmzYPNGAD1V9YZQtf3vrRupLKBUjWLbZARD/NFIOoUYBqxTnxQzbYs+DypRFxRpaEz5WVTZhUefA5LZoHhGBmC9VjRrNd8HOmFV7WJqBal/J9AzwNhjEy2DSqFG7bNDcafZCqKWwD+jVD72DTulTbbtelZ3u3Om1Aj+hq2e5llNI1eGf+LGbNePQlLlm7wV7PjzP8ulaBB6DfE8XPZC3VjERzaLLzbTBJcu/NYS5fnP4XtVbxu7T1hbDavr6gwFq1EP+JF62/BfFT+i0bKUTU2i7LHuDOcGr2AVId0fAjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rd2EaOlZ8QelZd5vI+XRv38Cg9UNCgwJeG4orOLalLI=;
 b=LEa5AfJowI9Q2vNtWv2Woshnu309xBFJuV3CFYx0Qbq20KtxO2bjY2+1fUX5uPiW91cLaJK0j4fu/mwRc/6ovrheEiSO8nKdpEdda9JHXA2txriYFlbdFsSsT8/Ud4Nhwc4cAyl5arM8Ct6kPnNeyqVPDNNDWdy0+j41R6I3yAFJbuxYIZfWnnJeOhyeJH+D1pbFFq/DI7djI4/BztNCHTx/xv6wsQ5Q6rj2FxWbO2veIn+ZTPYwq8DdE6Ge5N/IaWn3kcOkiOj7k8YfnXIEE1fS1OKp+Ag1TZv0GO33K+wYbf4Z0icyc3i6HkOCZ0kwkn45a7l6FwhGVs+0AOroWA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from SA1PR01MB7248.prod.exchangelabs.com (2603:10b6:806:1f3::14) by
 SA5PR01MB994140.prod.exchangelabs.com (2603:10b6:806:474::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.24; Mon, 28 Sep 2026 15:30:14 +0000
Received: from SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be]) by SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be%3]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 15:30:14 +0000
Message-ID: <cdb1f27b-c10d-4392-b6e3-44ac76b47b78@cornelisnetworks.com>
Date: Mon, 28 Sep 2026 11:30:11 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rdmavt: Fix potential use-after-free in rvt_mmap()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nguyen Van Tien <nguyenvantiennani@gmail.com>,
 linux-rdma@vger.kernel.org, leonro@nvidia.com
References: <20260825042058.561-1-nguyenvantiennani@gmail.com>
 <bf986ada-b869-498b-8aca-2497198a019f@cornelisnetworks.com>
 <20260928142550.GA1668261@nvidia.com>
Content-Language: en-US
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <20260928142550.GA1668261@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0034.namprd14.prod.outlook.com
 (2603:10b6:610:56::14) To SA1PR01MB7248.prod.exchangelabs.com
 (2603:10b6:806:1f3::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR01MB7248:EE_|SA5PR01MB994140:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c731c9-aa36-4e62-2a1e-08df1d7563bf
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|18002099003|22082099003|55112099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	bhxn74qb6mmafPybZzxNd4HolpD0EkUlHm2SxB8uuguVbHKTPMtHNlGlYuw8WRKtdvU6gI/7Vu7SFGKtXB9kqZbgUL4sg2J9LdAx0063dcGmYsirQZR/13AZYm7kRSYvMgIq/fHSq/7p5JpnZ3wvt5PySx3og5bILfAyYzSXsbsKupSRODKX7Gb3qo+4BeosLpIj9tqyudAoGdjZQRHtm4fNFRhMYtoP+7MHUT59OvW5MENzyrN/oBbH/41D/Go1nYQCGLRJgEV6PTARdKKg+HGJGJu8jyfa5+TMERhejMcKmJ5v7bRB3AvgB71NEdk8D9x/HPDiUaJcPo5otrZ+KPN4Qz+0YtD4wfNpNmgjgETbOVyclSmyvNb9/rpmEmJhM9iQs8ykTVoVesK8q0PmUZX7DiiPrAL0gUswhLU3uuzBmG6IY975LTPh6wSGb64egVW8s2h1L2lXnWnnyIad4zZdZ8pz/iRNAo0T9DgOyMnjihVZybsNXIx0MwB6SmhnifBQsM9B30rob8J2Ls6fO/vQ+pv+M9taruTwhjZZAwNy+IAZSjbw7oVRs5/hhonGN/+7eYG+7C6Hxc1tn6uUzYuBMFL5c7KuDHAsoGvbyku5xhWfqgyTGoOhHLFmV3vQ3FDNKlu+dYDNJLZLPNKQqPYDsMMaU02LCxUGs11VpRk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR01MB7248.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(55112099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S25UckZGUVc1SEx2OFNnZ0NxdzAvVHRWWFlCMTFNeHIzVksrSXZpU3AxenRj?=
 =?utf-8?B?bTIzUENsV2xiTHplWEl6eVJadHYvQ2ExcVlmQURmenorbmFsNGJqQXM0QlRu?=
 =?utf-8?B?RVdqbFg4WG1oSjlVL1l2ZU5OMVc1NktENW9YTnhxbDlhd0orMXBqWTZ5MXRx?=
 =?utf-8?B?NHN2WTU0aEtMSmEzREpLMSt1aTRsQjcwVjIyMlhoZzJoN1dpWDR2UWlQRWpt?=
 =?utf-8?B?cG9YaWU5dENYbGN3RG9TZ01XQm5WZTdkRldndFYyQ2VzQ25YMldyTmhjS1k1?=
 =?utf-8?B?aEhBYmdnNlhJWVRoYTZDYUhqTjI2VVdEWm9RWkdWSkkwbGdQc0tNVThSVXRV?=
 =?utf-8?B?eFFoRng4NWI5blNQeDdNUlBnVkZyTzlqS1hYOWxnWEVPUVBROUNOOFpVRVJO?=
 =?utf-8?B?M2VvTERJZ3pIQldHNzNKK3BxbTVQREUwS3BveUloaHlpeDRiNlFicXdYYys4?=
 =?utf-8?B?UDJ4YVZ6UThxZU1wOHNZTUw0NWU1VjJWc1ZjNGhGWjhOb1pXMkRicngwVjVl?=
 =?utf-8?B?OGw3MVNENzlUZmlVaStjbDU1c1BKTUYrcEpocnZjemVkYm1QYVJyUkt4aHRB?=
 =?utf-8?B?YUZtUmxBOXg4c2hacjA2ZmhiVU9kNTVyMEVncVcweWxSV1E2cjVCM0hMMjlE?=
 =?utf-8?B?ZGtHOU1xV2hxaTBlWkZBQ3RnUVp0Y1pka0FUVmdDdFdmekVqVjRid0RIZFQy?=
 =?utf-8?B?MlRkV1hCcWdRVDRyWlhRTHRhZytnejFYZUZLT1V5RUZtTGRpNDNKRmJ2Y3E2?=
 =?utf-8?B?QWdrNzIydEhobmIvay94WTJPTFFBMzNEY3RwbmFCaDdNZWNjcnFRaGN6VGxB?=
 =?utf-8?B?SUd5NnVKTDZ3M1k5QWIrWEpyNU5JN3phVTNSUHRwWDE2VnFtb2RXVmswTDRH?=
 =?utf-8?B?aVpOWDZKODF3QkxJak15Vk1DN3gwL2g1dDZwOGlCNzV1R2M1WUxJcVdZWlk3?=
 =?utf-8?B?MjBnL00wUXB2NEdkK1krRmJNc2twV2lZcWFCN3BiRTVjQlhwNzRpeWRrbSto?=
 =?utf-8?B?dzAwMlRORC9VeGtTT0ZYdjUyS1ZSSmxSeTVhazVienB3WkdPNCtoeUkvd3VI?=
 =?utf-8?B?M2p1blNKYUM4ZHpwVGNFOWNPNGhmMEpzQVowaXJZYkoyVGZrcWpQc1d3dXJ3?=
 =?utf-8?B?T0Z0dDNueGVRcnJ2akE5WCtFRlJpVGpOT29mbUVWa2FxSk9uNHMrSSsxQU54?=
 =?utf-8?B?OERWS29VUTRQWGtLYjZlbzJrNTEybzJid01yci8zaTRqWTBoS1VMRDdXWkVt?=
 =?utf-8?B?S1lqWHFhWm5lTXU3TWxPVyttTngxZEdVY3MxcUtOS3BCdURpNndib214RlNV?=
 =?utf-8?B?MFo4MElzWEltaGxMWGF2WnlHeVUwZTlmcHNWQkhjTzRvcmNpZXd0T3VJSFgx?=
 =?utf-8?B?cUZ1SWJodDRaSXpXNWVWa1lIL3VZaE9CMnQrbVVxeEU1TUttWUFpclQ0Z1hm?=
 =?utf-8?B?NkRwaVp6REkvMHVLYW0vdHNvdWh0WDMxc2o5RWtjZ1BveGdUQXVCN2lmU1la?=
 =?utf-8?B?ME44NmFjM1hlMHpBdDBpem1kSTlpeW5YczdnL2lYNUlVelRlcnZVN0pFVU5Q?=
 =?utf-8?B?OWhVdHdKa05tOXYwMW1MWUlvenNycEo5V1dOZDJrcGwvdzB0dDQ1OEFVdVN2?=
 =?utf-8?B?dkJMbjBCTkFuMldJWUVOVTdKdlFqeUtoeWRjZDRBSDFjMDN0blFTcVdzVGR4?=
 =?utf-8?B?OHZVTkt1VmtjWjliT0JPc3cza0JQTVIvRytRNHlJMkdibDcwM3djdEMxbWJJ?=
 =?utf-8?B?UXliNXZmbnF4ZFVUb0JLdFN6Z09qSDVXdlQ4REtPaE0rcndLUGRDSEZ0RXNu?=
 =?utf-8?B?cG84VEpDN3pqSmpRc29VejNSYXVSSmxudWI2UkVEMVlIZFFFYWdjQVpzbDVM?=
 =?utf-8?B?WjJ0WHVHajNFSkV3RC83U1ZreEFDQkNzQ01VMmhvNGZsNXFCYUdsTTV3Rzdz?=
 =?utf-8?B?a0hDN1VjZDFqSHhtSll3RHVodXk0SkE3Z2NFbHM4S1ZNQy9ROFMvSzJENGk5?=
 =?utf-8?B?djhyL2VhWHBxd0N5TkZEVTZqbkRDcmllQUVNek1HaU9Hckp0VGtXNVlQK1da?=
 =?utf-8?B?T2Q5Tkh3YkpJMEpSeHJYUW9vaUkvanBoemsrcUpaajJZZU40U2d5NTRMVGZD?=
 =?utf-8?B?MVFvTkVQcEtuOHlMVzJaR0g4TGdUSUNGOUxPK01FNmY4MmIwV2JVcnU5M3do?=
 =?utf-8?B?Ty9FbGxHa3ZoTzByZnE0YitvczNTMVQvKy83RFp3aUpEclRiMGFlNDl4aUFt?=
 =?utf-8?B?NUdESkpUQ01KR21HeUhldXV2dlhUczROTWg1Zm8xQ015UDhFMkIxajBYRS95?=
 =?utf-8?B?MVFPS1NtZnpNczNmMzg3cVphdzY5a28xN25uOXJqK3dGVG16cUxUNkYvTW9N?=
 =?utf-8?Q?0/QjCeAFUxlYtfmOxJxL3hRk4vcjJeY65qux1?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c731c9-aa36-4e62-2a1e-08df1d7563bf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR01MB7248.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 15:30:13.9696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2lVycX00Ba+ZtcTDwJXgimI/wYeaYXeke4Ct6kecgzdh52P/fnOJBYZd/aXkqRNyQiMoJWAHRoa/jH0OYzp2HtmlJoHAfCbuuEJJKxNKDx5QlonaG8OclyyvyAuOaOKh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PR01MB994140

On 9/28/26 10:25 AM, Jason Gunthorpe wrote:
> On Tue, Aug 25, 2026 at 09:28:11AM -0400, Dennis Dalessandro wrote:
> 
>> My AI cranked out basically the same patch. Only it will be tested and
>> reviewed. I'd say drop this and pick up my validated version. If you go with
>> this one the commit message should be updated to explain why we aren't
>> calling rvt_vma_open() anymore.
> 
> It's been a month are you sending yours?
I have it tacked onto my set of patches for hfi2 but it could go 
separately ahead of time if you want to get Nguyen's patch applied instead.

On that topic, I'm doing another round of Sashiko fixes. Should be on 
the list in a few days after 0-day builds chews on it.

-Denny
