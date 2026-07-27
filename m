Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022082.outbound.protection.outlook.com [52.101.43.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2292D175A9F;
	Mon, 27 Jul 2026 16:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168168; cv=fail; b=LHKHZ7q3E57WT5xQrkUcg/av12VPh/5FM+XI32z8uAC8JRtIrIgw67rb91vOsMqoW21EVGat7sUPQxZGdDoEGUoGGmB7BKwQ0SdKbZe0I5CFWzyuYRb8to0LB0WHZHOEk0C/c1S2T4erzXnvOFQP8IVZwOcPjMqgSJFFnWotIOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168168; c=relaxed/simple;
	bh=1iK1JGRSqUQAVo8mwaU9qFeYVJFP4fiMeRM1f5o5VS0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CbSnZKk6i/cOS4A2fOPw2+E58aJxAVOQUlKGeza7s6MXKHd5U3mhgbRBqu4sI7xtnRMDaiknYZHr8eCdGOYDJibpCBed6SNE7Ylbr+WniX0V+ztc9/4uNfp7BRrq5Ki0mLYpXWtBBn7kapgoSdxOEUO0iovuYitp0dBJ0yr3XFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=Xit3OAAt; arc=fail smtp.client-ip=52.101.43.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="Xit3OAAt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Osb331qxXVOy4A7/ySpQMwPx5+/oUT94aRBYirviCaiPdHX0hTahyvTWxvrGCI61UuCBKuPQCp0qdVzMHCCo2qpsRlSOkbKj61xbg71oYHV6Kbj0WTD/5W4gw5yo97+kX0r2pD49TtIntVxdXo60PBUyL3P9CVQlZ8uMki0GdhkSDYCBYJTAuMruGiaiwRdG5OcCzFJOR0fe3eXxcBYhoDhvB72hDfdkw5eUaNFY3MTN+91wB1471Jt8JvZqDkpqC+Qs7E0y2UoxxWJqdYoqNWxEbSD2rwuzmbjOSmi8T2kcQh05rSFZkUjJ+8cUKDiwIbLiV8WjWNemysd4jAUfLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ie3wN7KJ/UZEoDpXTDpLTo8Vg4OxGIAyU6XtwD9w/vo=;
 b=b1Fw+dkrwowaUzR1+YYSYLMV8ZkaghGCTdO765ZAMQuhZwpOan95mnDFp0k6mzQUr0gab87qelx+T1uMAThn8D0H2qf7g7hdP9QICwo9ZXcUsimneYMGIi8xSxuO3xkxLTX0kISEISlsSLrWRDY1AY4JMkwFb3Gz+H1gJejVFGBW6PUDfVV+g6jqfX+h8q9Re1QLea2EtyXC877XHr0Tf94mu0inOLXRCzm3GRaUwkLC+5ZipGpdsPHHqBHVZWJB0VU0c21o2hV8OMNtYxBsR9+uCDGz2qjs/mF1StrXGf1vtGDJNW2Y9iMN+pbwpdu/DdKx3O4e+pWKzMvLKPwahQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ie3wN7KJ/UZEoDpXTDpLTo8Vg4OxGIAyU6XtwD9w/vo=;
 b=Xit3OAAtCRXxvwqh2nv9DhEHpG2v0Hh2oFjZ8HZBdQrp85GtM4czHXmIQz1dRKCAGGwnDNNH4RgPb9B4D/2bRpRM+NjxWrkSxegf0nKtNE6mjlbstBrFE7yyeOT9QhMlqn/emNhSGJRCtFKdfpc/bFe6o838TaLClGOMkdbZBxP32EO+wvKif4xSLhjvBRkF4X7tfDxOpMKQK9jUcjGhnkSvjvcOPPtB5SXGmW3EwXwcw8QmZ2Lef2GQSVXblO1BVVC6aX0ZigWxb5p9zZYwwc6ZUuSkG/kzu/JwORM5nw2JCZXA/pSxtzjZ/9AccZfCWAu0N8OW252qpaYtBDbj/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from SA1PR01MB7248.prod.exchangelabs.com (2603:10b6:806:1f3::14) by
 PH0PR01MB994238.prod.exchangelabs.com (2603:10b6:510:38e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.13; Mon, 27 Jul 2026 16:02:42 +0000
Received: from SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be]) by SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be%6]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 16:02:42 +0000
Message-ID: <a139a253-9c20-4d03-a687-3e2672972fd7@cornelisnetworks.com>
Date: Mon, 27 Jul 2026 12:02:13 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fix: infiniband/hfi1: __sdma_process_event: fix refcount
 underflow on s00_hw_down + e40_sw_cleaned event path
To: WenTao Liang <vulab@iscas.ac.cn>, linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260626150408.49976-1-vulab@iscas.ac.cn>
 <73DF2AAD-E77F-41BB-9D94-A6A5004420CA@iscas.ac.cn>
Content-Language: en-US
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <73DF2AAD-E77F-41BB-9D94-A6A5004420CA@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:610:e6::15) To SA1PR01MB7248.prod.exchangelabs.com
 (2603:10b6:806:1f3::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR01MB7248:EE_|PH0PR01MB994238:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a140b42-cb9a-4c46-0a41-08deebf87d28
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|56012099006|4143699003|10067099003|55112099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XjM60IdmnaMrbz+z4uwK3pOAjdlKMaSDBV4QMwlHkcwSh9bm/fTWP+7mdsp4+XBX+w+1YJ5CcriV0OiTwiPbyBLq3X9aIBMhPQFAbihb+4q90PmmOSIs1aDq3he2Yy4sOY6d1ixR1D7FEQHKg6+2+0iG4UZX1ziJ4lmclku6nIGSAD1HiPR6hz+gWG0snmTS5S0XTJPcC9AFX1gmb3u1shbQMqdvI3Ul/7SI6JiExXwe30HrX1uBuptdLPeVWf8+tGsb/zwxZJE7uBkKU/YNtzAtrzlBWkqC30oJ+X/H6QbiLjv7a8zM7NBS9ZcWPDPcPLe+XuLN7io1VKSNHn8FUaEqNVWKn1eq8WqV1OKMsaOr6+reaojkA2ns8VIpXg8ExzbE4hWxokVab4GSOjMqwBxSGMjAu/dvXdRvTCSESg2eTQvS5FIpXaTAZZ9kFm71YtEJ/6yDaMw71kV4IqAd7bpKHeTdNJeF6wkLISQSy2fJyGOPSvOaot/ANbh5fH/kKEoBDR7n1iZNkpSST4yGY3ldBbOA6BWyJssmO5Qw26FpiKeO8ut1YAAIg285CY9RCQzLSEN3/GHma2g+ILx2hfEW1F6xiqo2vk2IOgdJ9098NKfRUYCpQe1uRsGkh2q6tlYoGlWi7QJdZMf+qKbFWRixwhIokhIYmynqbUde6zo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR01MB7248.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(56012099006)(4143699003)(10067099003)(55112099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWt6RFpPWnZvQUV2UWFscUExb1dHck9WdG9wYlovRTBpSFFEeWdoZ1FhQkFU?=
 =?utf-8?B?enVBSEh6RmdyeHk3VTZva0N5cEI0dlJTQURxU0VYV1V3WnNOWDBaRDZTcjJX?=
 =?utf-8?B?TE9NZmRTUWxpQjdDTGY1Vkk1NkJ6VTJ1WjVIbHBLV29CSURsSXVxelo0V0pw?=
 =?utf-8?B?TTk3ZEZIS3F6TVliaXQrZFlhK0Y0andKN25wSXVpV0JkdXlKTVh1a1MzeUxW?=
 =?utf-8?B?Z1dhZDlxTk9FY2RmR3R4amd6N21WODdRNlRTWUJYR1BXZURNdDJ4TUlFMk1P?=
 =?utf-8?B?R3Z3M0Vuc20rRWdrYzczRHd0R01ueG0yNUhWRnBDdFV1VkdxTml0TXFSWmds?=
 =?utf-8?B?dTBISHl2czB5N21aZW1kWjRaS0l2RkF0endTZTA3QTBBWTh3YWM4ZFNTdVND?=
 =?utf-8?B?RGNuY1A2T3V2eVVpRnJZdUdZVjNGUStQTlliWDN3b1BYL0NkSHJ1c1Z2RHZ4?=
 =?utf-8?B?Z1VrTGxBT1Z4dSsvaDdiZDBUTllPNEtDdWxPYkEweWRyWEI2WFlscWNtM28v?=
 =?utf-8?B?VXRVb2pIVDMrOTZYaVVIRVJDSkZqZmhqSnd0M2RRTGxZeWppcDR4bXA4WHVQ?=
 =?utf-8?B?MU1xMU1DcHFsMWpMa1p3WDlmMHByNGNSZ3FEZ0lqcUxkRjIrZEhOUkV1RHRo?=
 =?utf-8?B?d0drUTVhUGN6R1l4M3NZZTBnNXBJYWtGL25RVEZGbzhvSTE1SWdKYXdNaTVE?=
 =?utf-8?B?aU1IaTRVUTUrY2MwMjVxMDJEVlgydFd6dXdzcjEzbjAzRTBqTTc2blg0Wlh4?=
 =?utf-8?B?SlgzZHBhRE85Y0NCYm5hU1dCcjNqWTRrbUwzMU5GRTZVUmExVWFNbjlNcTA2?=
 =?utf-8?B?RlpHeTBDMlFnNmNVa3doVHY1MWFHc25EU1BRNWF1Z281SWdVcG1acU9hb0t5?=
 =?utf-8?B?SEhOM0pYMUdzYTVmampqU29reTZTdkNkTGg1eWRVeU53eGRTWEk2bnFRTEJt?=
 =?utf-8?B?NnlWTTVsRFNHL2IzVFBzcGdEVFArdDVRSlBZeTJ3UmM1MTJOYm1FNEhENFd3?=
 =?utf-8?B?dDM3dE9mNStLTFZoSXE3aUdTUVhSL2JaNTZib0FteERBeWpzTEtJUEIwdGtr?=
 =?utf-8?B?c3pVK3gzVjRSdmlTMEpXQTc5MEF0OXhJMzJNVUNiTGpmSHpoaTVlbUdLSXVY?=
 =?utf-8?B?Y0VianhLaXdXRm5QRDFldDVoZS9MakxrZ2U0blNXQlMrdFFJOXoyQ0JxV09R?=
 =?utf-8?B?bDBCRnY3QWJFdW5NTjYyS3FUclhvTFJBYW9VV2R0dnB0TDMxM1h1V2dNOHBq?=
 =?utf-8?B?MTVZSXhlMldBTElTSG9CYUErNEdubDNERDBWZVd5cWNQQ0tyTWMrNk11dTd5?=
 =?utf-8?B?NFk4cHROYWVzeFJNZUJ1MnlGeFBSR3BrL2o4NUsyaUZMOW5lU2twOTZpRTQr?=
 =?utf-8?B?eC8vcU00WFp1TXhMVzZuZm12NXBXU05rYUVmU0laV2hKdlN4SzYvWHJHSlBp?=
 =?utf-8?B?M3ZldGcraDl5bnBTeFoxQnJ5c0hqNjNiZXdiRFlIdlh2ZHZza2I4dFc2VzN4?=
 =?utf-8?B?SVgyQmVyMi9mbGd1aVZnSkNmU2VRaHlsVGhYN3dOZUZFbFl5c3U3VHhUR3c1?=
 =?utf-8?B?NmhQblAvTk9GMkZHOGV0OFN5cDNkejdNaWh5Q2hEajJ3c1M4SENyWEVxeThh?=
 =?utf-8?B?MmM0QzdwcTU2Y2RobkZXUE9Fc2x6d2tQMjZWTnh3YTRrT0d6NmRDM2hsMkJG?=
 =?utf-8?B?TEsyZUJMZENVUzhqNU1UaTFQWkUyMjhJYkd1bjdxY2VJTHBYalA1ZWFFZFBs?=
 =?utf-8?B?NTVoRDF1YmRJcElIbE1zT05YVkwzbURPUzVzaC9IU0tsSjJ2NDdOM25TTm53?=
 =?utf-8?B?bkdmNWpKcXl5VE9LVitBTVArbnpwS1FSUU1KNkV5UGwyczdwQWNtQXRRSThp?=
 =?utf-8?B?RnQrdzBuRENoYzlYeDJvWndCV3VMdkREbk1odXZYdGloK2J0TlYyK2pqeG51?=
 =?utf-8?B?RHFzZUZSVWN5eHB0Z0NaZ045cG0vSFZJYk82VDVESWZKMXRuS2g4NGxXVEc0?=
 =?utf-8?B?Y0psMHEzMkFqT3ZOeHI5aGk0eUQwUjM4TUFwRzhVWVdkTUM1ZlV1d0pVa1lZ?=
 =?utf-8?B?cnduWnA5d0dVM2ZIQzM3czFSbStSRXJYbWJrTWhwT3g3ejFOditaRlp5TTgr?=
 =?utf-8?B?eWRWbHRZdVp0SERkVE5LYjRlVHMrSXdoclpLUkFvbll2OWxJL2ZmbVRHOEZh?=
 =?utf-8?B?bm9EZnBheXY1SkdQNGdINGljTmMxcC9PbHVHblZUa1Q1aG93OUV6YWw4NUI1?=
 =?utf-8?B?eURpOGR4Nm5WS0hWNk45ZGRWdi9uTzJaSEFnNUI1bndNQUhkVzdyUnFZUXVD?=
 =?utf-8?B?YW9Gb0lFbFY3Vi9Nb1pHSHNwR3pmaS9PQlo0ZzNnZzFGWm1TdzdVMEJIaXJp?=
 =?utf-8?Q?wYjgJRDF99alXQHIukdudBA8qgZopIRlqQX+l?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a140b42-cb9a-4c46-0a41-08deebf87d28
X-MS-Exchange-CrossTenant-AuthSource: SA1PR01MB7248.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 16:02:42.4594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkuCJvuCaVzbkyG0chqQvAqe3UAdpMjYDhj3FlPQpaEJ7ax3f6hVfkrSiAIsA7z9c3wrriwVReoiEZbl4hLaf68t5D5ogANe4XWyzW7V0ZpnmRfJ94GW61r5i7sou9H0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB994238

On 6/27/26 11:56 PM, WenTao Liang wrote:
> 
> 
>> 2026年6月26日 23:04，WenTao Liang <vulab@iscas.ac.cn> 写道：
>>
>> eives the
>>  e40_sw_cleaned event, the code directly calls sdma_sw_tea
> 
> Please ignore this patch. I will resend a proper version after
> learning the kernel submission process.
> 
By the way the patch is incorrect as well. Removing the call leaks the 
reference and stalls sdma_exit().

-Denny
