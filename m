Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.59
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795464743;
	b=rh4WorfvotFfJQmpQaw6saum3FOotmYLAvVZDUQlaAn06yUSXPOFJnf5AU0XUfmhJeai
	 16VwjtbWnCTNtnqBJz1vTAiesdz2efLuiO9TTC53G588ZAilviKH+Xqsm2h9/kxxzDsb1
	 OOamwF1D3NKxWoBV6C2Neg9LxbXH8JRhM5W4uKDhT96CoIwK5pLDOSCBmvn2sbFm6eA6K
	 6+jQtGjVN0Mm796JDzDRpQ8ISTcTlESCDiO3C7pPhq1BjIdk11Wo1t+7SmkoELVfsgYaG
	 QzJrTIK21JcCcsbMXprUwSz9N61tcTUoY/rxIKBVNCqvp5HwFm//vu4at8Zapqqpisw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795464743;
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
	bh=UQdycFzFVBZk9+FyH5+It9nqH+iTqNXy1ZlW393wjwg=;
	b=I1ownn0sxyJIjh4GZl3lAjLPpQ/Tscu2zfSXYigq0u/9RLVUknARc6IWNa2VJUR4cwCM
	 VwzKuFEqHZFeU+KYc2G/W2QtNJgEgRl1W3GyDV8Qz7LXyhpumPqI2uMWdZc3wlnKVm+rn
	 3cjLAp2PenRHOjPvrCgzSPRXTovl0K0L+fuuDjwc9kZxCcL3IsD4pFStbpTscCmIIeEzv
	 MqNgPWJS19JRGl05jrcd5GwkBaf9EgDepX1Y6tR5yblVTayeqTeZaQeNsVUYXfa0xR7lj
	 Ckin07zC4z4Jp9Nldp3PaUTPffzoG2jH9XmGgmZ1Q+QiRCUzrXmBrPtVTtFL2eKgTxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=QKfVpHEu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.59
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010059.outbound.protection.outlook.com [52.101.201.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9357606A321;
	Mon, 23 Nov 2026 20:12:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9357606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=QKfVpHEu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7BbOQFl6dtYLFppspIMqn6dHRCoF4/Z4DSUx+WvnT8xzgUKDeKqMRrWGIqRz8EU7l2ml1bBUzy+7UMbFWqkM4VXF5IHbDyQkJZVs4p0hHoG4sxxk9le365pXgZPW6FAnFGFRPk9AWtdvj8ciEhw1zZNknGcECeRUvwp1N6zJ/j/1KarYeQ4oybRz6dgrng52sRNC2Ei9+DWTozGnyluvvoPj90FaFOUpkP9j362Xai/e49Kd/L0mghxtFh8+I0yQaRF0pi9uAwxIyCkKI6cafKHiYUPP3ZnzKh7zIneKM20GMwizW+mho7XvbWZjWR142K60idCrE1euxNNUnmwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UQdycFzFVBZk9+FyH5+It9nqH+iTqNXy1ZlW393wjwg=;
 b=DG5rC7Jdsn6/9k9RsLARIKFG1AwkFAgogYf8FfNX69koVlQD4N6Rq5WYdwDj3lSvMukF/VxKOzSRtky+gsgqK5J2bMSdsOxlZREuqLGfYcWH5yrcYLjw5NgdUgSluwS/yGqPhYQE9L9qfxb5fO6TT6xqOM4CxuQi0sD9LAFkGiuJL5BSVKOn7UbyZyn+PkGqWjyTL0Nryuc82LczUMtoyTRUuk3Pmc0Xfncq9yHTr3NVrmRwdmtm3/joeKPIy/NaTJLUqJVbV6ZIqYDtr7CWlLSrXQZAjrcFBDHjF4zHKDTa+fBNyAyFUprtpJ79SQ1vGK6SNYJTdiLFrAw3123pWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UQdycFzFVBZk9+FyH5+It9nqH+iTqNXy1ZlW393wjwg=;
 b=QKfVpHEu2uDlIr0fDRlYB6XQt9tIMZbJetQfDlRxbtnxMyE3FGZVVh6v91jIPkE7Xi0qQUMaBMb09CoHoqYU6dDF7szeGyNx2vWiAGZhRfOZZb+53PIyOKks6XLurhFvz+bhLlS2r8UpCv3HJpGlvZguocJSW16pABuOFvlOwAE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22)
 by MW6PR12MB8952.namprd12.prod.outlook.com (2603:10b6:303:246::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Mon, 23 Nov
 2026 20:12:09 +0000
Received: from MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9]) by MN2PR12MB3485.namprd12.prod.outlook.com
 ([fe80::7ac:5acc:f8b7:65c9%7]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 20:12:09 +0000
Message-ID: <6e984d96-4341-45a5-b1de-05d06462d968@amd.com>
Date: Mon, 23 Nov 2026 12:12:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-rc] RDMA/ionic: Wait the device command timeout for
 admin queue commands
To: Leon Romanovsky <leon@kernel.org>, "Nikhil P. Rao" <nikhil.rao@amd.com>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>,
 Allen Hubbe <allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Boyer <andrew.boyer@amd.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com>
 <20261122131456.GE14811@unreal>
Content-Language: en-US
From: "Rao, Nikhil" <nikhirao@amd.com>
In-Reply-To: <20261122131456.GE14811@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::31) To MN2PR12MB3485.namprd12.prod.outlook.com
 (2603:10b6:208:c9::22)
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
X-MS-TrafficTypeDiagnostic: MN2PR12MB3485:EE_|MW6PR12MB8952:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ddc496-5510-4df0-ad81-08df499e0d95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|10067099003|11063799006|4143699003|56012099006|261021121427099003|261026121527099003|261021135927099003|261102123227099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	4oXPWRStbeceIWwMPvG24YDusx3rxuSjUG2Dtc96xRYx5xDaW590G29fgmy83jwhoRWso2sacnRPJdsFATvV0p6BH6S4mS+PXa+QURhnPrlIC028HEf0gr+nWU2cWaqwd7BosUSYDHUbiiibUE5VPvLMo/99xlj+0/92/nyL17rwVr+tOlV5Lcco598UsmRVgCqAa4Cqh0eby/Ym/GGpfvgf8XM+XJkdbfi5qtvKTYYgHPyctKX5/djwpso/DImvMHjl7kSnOeXBTN/ZxXK/MKr9jUqsLIjB8jHM6Ex/2TTX2siHnOjDuxoB51nIX0K7LvdMyUTmKF4jz/PYWsfIVdQV5n8hJc2Azgk9SFUSYtKW2Ae0BIJn5ksolMMX2W412TtHHS0S03cG2Pg4OHcZQjdbCDBUHwSHrh+92Nz4srbzeowwVQkEKqZJM2u55/xn0ok0pxHOATcpqiCj1EDwaloqNBQyVa9Si4w0b3wvFUhpyzY1HAnNfnuBJoUkmKjysMGdirqF/dP7ncirqWWLwpe+mqeZ9TUIEVEajIuXv+Zo5rizvJ+pvHR5RJ3QMp3Ri28Un4A31gj/L7OixkVZSetLaD0FL5BtwkcJPqa9v2EiWTqat+lWGtmBaJSmXENTkX9N21TXBK897BoJDxNKu1Bkct0CRFSz2aBITro/wX8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3485.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(10067099003)(11063799006)(4143699003)(56012099006)(261021121427099003)(261026121527099003)(261021135927099003)(261102123227099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVRvN3NWM1RSZHJQbDl6NW96MVk2UmxHbzBqTGIvQ0gvSHpDUmRmblp3N093?=
 =?utf-8?B?OWZHblpXR0NDbmJWaWdLYnlyWTYxanowcnVlL2pPQkExNkxJL1RETzF6ZjNq?=
 =?utf-8?B?YU1CcUZOcUZEM2pBRXBuaVQyUHJTUUxJOFFzMmE5ejA5MHl4aFVrbU0rM1I1?=
 =?utf-8?B?Ly9RdTJkbUw3azhKbDNQdEpkYVhlNHR0QzA3eE42WE5xVW9pcnd5NHlseEQ4?=
 =?utf-8?B?REdkL0laMmpQeWVUdkVTd285Wi9TL0tRcjNqS3pkajhwZUFoU2t1T0QwdFFo?=
 =?utf-8?B?RU1qbWpkQmM1VlcyaFNtd0pXb0lGbXF5MzFGclg3K1NuQ0QvNGFDTVorZXJN?=
 =?utf-8?B?MHNESjdXa0MzUEJ5UnZLdEZyNWtWUjdlUTdJTTRkWnc1WERUNGx1dVQ1ZG10?=
 =?utf-8?B?MVd0NzI2Vm9FWEdtbU1BandBWUNkMTg0K2NhVVdDUWgzMmFPaFpyU2N2OHcy?=
 =?utf-8?B?Q2xtNVFsYytoOWErM2JJTlIxc2xjS01MWWtnNVNZT0h5NmpGVTcvZGc0OFll?=
 =?utf-8?B?T2J0em92Wm9BNlNIZnJrQkVpM2J6UGdtbUZ3WVUwcGg5MXhTdFZvVWZycXpj?=
 =?utf-8?B?WlVtSzRtbC9nQVVXYUJaSTNLUFdoMXBCRFBKQXlPWTBMV2xiZXk0THIzL1Fm?=
 =?utf-8?B?aHJ3YUdJbWJXMEN3eDgveW1tSlZDRmdCWU9CbkxFaFdwandNdFZ2czJuUCtW?=
 =?utf-8?B?dVJad2laNllLZ0tQQmN2bVBZTFRVaXY4elR1dEp6MkRtMXBkMENua0E5S3E3?=
 =?utf-8?B?aTFxblJoeWNYWXUzZ2tkRUh6bVFHc3JENFBObDV1dzE2dEVqMVlpM05sZXlZ?=
 =?utf-8?B?K1dVamVPbEZnbURvNmRrR25DdE1na21HalhNZEQybnFYYU1DWlJpMlhXeDNi?=
 =?utf-8?B?L2FLY3BUUzJnTGZKTXhYSDdYVE93Q0Z3VEVjRHBraXdsck43SElLd0NUTkk1?=
 =?utf-8?B?ekM1TlF5OEpLWldVRXVzc2I4eHM0UmRhR1BJd0t2RHo1SkFRenRRUGY2dVdJ?=
 =?utf-8?B?eHhqMEpnMklkSXZkZ2xGWjdMa1pvVW5mRGdXcm9COTBnSFloNEpudlNoTm52?=
 =?utf-8?B?MkFVZXdsNVZoQlFmZGpvR3dvNHVvb2pIdjYvOS9PbWdQRHg2UFJ6ZkdUSG4x?=
 =?utf-8?B?MFZaQUdxbTdoQmR5Uk85R2VJWGpuOGRhUG0rS3RuR3ZNdmVnbmNNaGM0d1BJ?=
 =?utf-8?B?MDR0RUxwc1RSOVlIZUYrYklwbGFOeksrUnVpbXBKVjZBRk5YdzNvVzhGZEl6?=
 =?utf-8?B?ZElyd0M4OE1uQ25mQUc4RjE0Z1NYMjNYd25admt5b2U3cTBUdFlVMFRpVkl5?=
 =?utf-8?B?UmI2NUZYbmlvUlJDTzI1VDRtMHBvOE1HZDYrWTliUnlVNWIrc3NSTERtQm5a?=
 =?utf-8?B?elNneVYxWjNaTmtOUWlGVjJVTzVzNnVPcURnZFlqa3FTRnZvSEU5YTZYUjBE?=
 =?utf-8?B?a3pSMGRZcDdWejkwQmYvcWx2UHdCWUF4dWZaSFBCVUhzU2NpOTZTY0lFN09Q?=
 =?utf-8?B?ckV6K1k5MVZLeGZ3emdNMXVJendhb2ZuYlFPaDNxcUNPUVJhVmhkaTVkVlFn?=
 =?utf-8?B?bTZYUDV3Nkp3eXZ3S1hNQkdPRVdoQ0RBVlRNaXY5T1YyRFJzRnZqdWtTZ1NH?=
 =?utf-8?B?ZUZ6b3ljTjJ5UVVUWFVEZ2YvZnpXN1RBWUNtb09SYVRYcFdMcWZtYlJWNDdF?=
 =?utf-8?B?SzM3YUdRYklBbWdzTGhDbkVHVW5IeXJrTUsyY1grOC80SUR0R29Pdmt1VllG?=
 =?utf-8?B?Z0FZdUVXQXhxcFZ6T3J6RVY5Y0hYZmZPbW00c3JzNmdLZUZCVlkvMEMwYXpl?=
 =?utf-8?B?S1BUa3ovLzhYQlRIMG53RmJOaEpieDJNaGN5RElIVmpiTFNpWjhtUlE5YVU3?=
 =?utf-8?B?UEJWYmVXbFlNeGVsd0REUGFPVVlHc3pzOEFkYUo5eXplaVYzb2VBWFJxUER6?=
 =?utf-8?B?eDBPR3VxaFQ1UmhmeVFkZFZlZXNGNEZIUmFRamswQzh5aVJmSko4aTBNdDZo?=
 =?utf-8?B?L0tkWE9OLy9pS3V2M3lrZmc1RFBJZ2UrZ2tYd3ZyNzRJWVRCbVlISWw2TCtS?=
 =?utf-8?B?dUtoaHc1N0RGN21RWUJrdmdxeCtITWpEN1UxRWZqTmoyTFZ6RkJGNG94K2ZE?=
 =?utf-8?B?VWRMeklqWFVXL3BMTHkyVHVNb1AzZjA4M3V0WUJzY1FFY2dvZFZ2TWJKWHJZ?=
 =?utf-8?B?S2NhU3hSbXJYenR3UU5BUEpkQ0ErcWtsQisvZkU0VFFSMlkvREZGYVg2d3Zn?=
 =?utf-8?B?TFppSUh0eENscVpReXRGL21KR1ozMUJkb2lSdVJPSjNSS3dhYUxQbm1ZOHpo?=
 =?utf-8?B?VU56aGFsQkxaaWh4TDRsYmdhbzZPMG96bHMvRjZGY3I4OVpoTlN1UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ddc496-5510-4df0-ad81-08df499e0d95
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3485.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 20:12:09.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A25XQy20OZQk1AQT9Pe8LvEYaetlVxBClIKM2Tu0r+P/cROQqszdB3sXf35S1U+jH//PVsmSVyVfpmMCOmyzxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8952

On 11/22/2026 5:14 AM, Leon Romanovsky wrote:
> 
> 
> Is this a real, user-visible bug, or merely a nice-to-have improvement?
> 
It is real: we have seen RDMA admin commands take longer than 2
seconds, with the firmware not yet having written the completion when
the timeout fired. The patch does not cover commands that take longer
than 5 seconds; that needs the configurable timeout from the net-next
series, which cannot go to stable, so this is the part stable kernels
can get.

Thanks,
Nikhil
