Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022131.outbound.protection.outlook.com [40.107.200.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75540379974
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788459764; cv=fail; b=dzADmc61itv6/OPMu913CqP9ktqDE8/jF8x44E1pmBZNdGXdh/lhfvFVGshO251IpZnQfmaW2pJqvHMK0R2ImP5QUmB2EZpn9GtfZ/XAVP6njboDn8agIgvHFW2evtVxyOn5uonmmmKOCkDuih9hgNKAiD4WF/swGCmCyhecaf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788459764; c=relaxed/simple;
	bh=3NTz7HU43LCe+iwPtMdU8TqL4FzoH80U5dC1AiLKiMs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z103VRGMgZjIOv0+m2GAEJwTysiba4evxTPUlsdd/7Rhg4WloXubtJPl4jwFUEhQkavkcMAVlMLnfZihA0qEy7c1+7T87YMan/frDevHMIyWxjZaLxuNhriEgbOrNdmGdBhfzxJvfT9L3F77LCqmBqpd6c6D2tAUXB/3QVKU7PY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=kNxnO4GB; arc=fail smtp.client-ip=40.107.200.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="kNxnO4GB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYqXyXFsuG1YIDLZ3mdjq4FlVUIPJk40w9+UXy/Dr6H1QeF2umZn83JETX0bXACkrSCRInXH1i5GJ4YBX9r6kmkds/5JEdL02I6mBa6IiTQTfZy6xz8oI7ZZN6zG2UCYY8yI5FvCcnrC0pKm4L9M0AvqMCkWQjL9h+ppKeceqAmq+ZAu6iS+GT+hJubiMfF5+0cBLwXPsz4cNC7jSiiCTHTzOFMkL7KJV1is84btO1NGt43+hoIFrXhnw1VIswF/VJRqdVI8TkE7UmzKL3NPWzP2eKKqTiqxyGcoxIhiimNTjsdbGYMXZlv6Dv3Y+pq2JVYclsT+uKXj1nuKVbqr5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jlWK4k7JgioUuRTq/SdFe7h4gSZE7lI9jhtRQtWk+c=;
 b=Oz2w7EnHf0DJS2fmJlTfzQWNc+c9ibo6PcqwEsrsBjA6h5DiZv5CdmnrKegIv+7z5/pB8bb1oeeTqg1VTvsXu5evlc9+obqPO0nb9XHy1Rr845nL31OMTXayory5Sy/qi0ShiRj4dHLtFEyuHuTJskXDGAnQMemdgEVcigWNIZUlSis/w1QcROCDjjuB+58KUVIM1ZchwmEfVnM/WM/Mw/FWEHnj2ibMIPIbGxdv+8cQ70nKosm2KpoY6DBRYLJlVM3PUxT2nKwHAU61QSvVBj6QI7Yz2mAm4wjlpFg4B9SQun4sGIQ2GhYA3JtbZCdwAFk8yOaB2vs4dNrTzhuVxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jlWK4k7JgioUuRTq/SdFe7h4gSZE7lI9jhtRQtWk+c=;
 b=kNxnO4GByTx3v2hc4T+Q8Q8gNqlvgO52zT4Tyi1k64hnA8iZ9GfVSV1AOuX1mNJr+QU7EWtkuDVyZ410Hb612NxVZfCG2nZSapUl/gSh5gRnlxYT0qgec7qbCKrGgf8gdCImxuHW4bKmp5A1XibEx4Pxq01gCMcSpEzNs5h0+n75X4GvFtVJyzQdG9Y1QUnu6jD9pOikYLTlHTGjSKeVgRYEDLvB3PmIYCh1lMZjAUaYLa3xFPcmlxFx3/TYb6jkBlqul5cVT6oFuxn8rpZGr7oZZN1sEes8O6tJLM7ez5EbZnC+KGNm0Wz11NyzzP6dW/qjhqpAN3mbQlSJnM39Ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from SA1PR01MB7248.prod.exchangelabs.com (2603:10b6:806:1f3::14) by
 CO1PR01MB6646.prod.exchangelabs.com (2603:10b6:303:f7::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Thu, 3 Sep 2026 18:22:37 +0000
Received: from SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be]) by SA1PR01MB7248.prod.exchangelabs.com
 ([fe80::42ce:7e6d:25b5:95be%7]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 18:22:37 +0000
Message-ID: <4d55cfa6-ee84-4688-b15b-3c35b06a89fd@cornelisnetworks.com>
Date: Thu, 3 Sep 2026 14:22:05 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/24] Migrate to hfi2 driver
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: leon@kernel.org, Dean Luick <dean.luick@cornelisnetworks.com>,
 Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
 Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org
References: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
 <20260903175949.GO2890729@ziepe.ca>
Content-Language: en-US
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <20260903175949.GO2890729@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0026.namprd18.prod.outlook.com
 (2603:10b6:610:4f::36) To SA1PR01MB7248.prod.exchangelabs.com
 (2603:10b6:806:1f3::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR01MB7248:EE_|CO1PR01MB6646:EE_
X-MS-Office365-Filtering-Correlation-Id: e19ac4b8-53ad-48f7-362f-08df09e854ff
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|56012099006|3023799007|10067099003|4143699003|18002099003|55112099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	nHDEu0iFs5dn2Q/3FeVuj2YbGguKBZ4jGseyPYtZT24X9Z3Nxk10jLT7B4LvXqIQXuDlWCCWpPLpwaq79oPwPDWKkYkWLkDrCobMlVwxZ9xA8qgZOMkFYCmJjq6QYE/GMTj5d3Jcx3KgQr6FA2KbYZPH0BC/FC+UlOsIc4CWIeeWFBU6EtNUrPPLSeJHwljUriKKOu0+AFG3gN7rDJmew2zqupWTF+NxBYgzn/iP6WiZeAteqTFuVfTucGUAP9shXZI4qRKarIwqcraFLvDIFHKdhG44wUAKmF+anQndlK3FHI0/PHzgz2NbMBLlyql1HUEM9FWEODFtO5efX1dUPKvIaO59lPMAABk9FSsXXqz5Ei11WBwSFZhQeAcf1KGVnTSjmwvMUMf2SIyU4hfWOMFGjAdfLEnwO4+4hlLEz2DH5keGyi6y9oQXdXjRNMD8DMGfPHjYvwt2oHkS9M2LCI5jaXKYKC1N+EjlX0KTleOEsfNdJSX99QPdlpLoQmpP7RRL4ls/JTV2ZdZon6mg7EXbLuhGWWG9uo8anUGRELEjJ9StOxJZJ5P2k3KP83s7EUBmUfURMBCs1WvMZ/OgAt8JNqDaJvN2cd++3KH98p1rKnnUrkRcO9pVk3eNLCaNMQC7DjSoCbuXsttJtTvD2LwTLNLSdK0itsRHWV9EK8s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR01MB7248.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(56012099006)(3023799007)(10067099003)(4143699003)(18002099003)(55112099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1JXdHR0NnBSME52ODg5Z3JxcU9xR0VJKy9rNjZnbnpNZ0FZRGRqUFJ0eHhh?=
 =?utf-8?B?WnY3UlU2eUVOWWhuQS9jaTZLYzFPMTdEMk1xOVg4TnlwYThCS2lhMjZtRE9F?=
 =?utf-8?B?NnF4SHF6NW15TU02UThsL21oNmFvK3o2ZVNXbjBOM1pCalNCWU9DcDFFMFpi?=
 =?utf-8?B?UTBwY2Nqbm1GT3YvT1dLV1BYUVlzNjk1WUNSSDRWaEZ1c1Bldys4bzl6N28v?=
 =?utf-8?B?U1FpcUJ2NnlkSzBRNVIxK1NRZFo1bUM2c1dwZXByUVhlZHc2amhKRlpvZFMz?=
 =?utf-8?B?Z3JvVHJWVzRtOTJvK2lPVnR4dVhlRFVmMXpubXRsb0FmV2Q0eXF3SlAvZ0hn?=
 =?utf-8?B?SFcvWjNGcnRiSVdjbVgyanZZNUUyWGVmWXV2UHJtNG53Tm9XdURSUFc1dnI2?=
 =?utf-8?B?QnY1VzU1aTlCK2syaVN0VE11NXQyUHFXSkRKQUJ3U0lSamNZM2hBTkFPQUZT?=
 =?utf-8?B?bnQrK2I1U2JrdVpSSWtSQjhXMFJDWmJmU1Ard1Q1SUxFM2IvUzNDUXpxWm9G?=
 =?utf-8?B?RUVyVSt3OG02UEJBMnZMVTJzL3NnMDJOalJEV3dRUytjTUliSWVxSUJmb0pV?=
 =?utf-8?B?N0tISnhFekZXRnJwWjRKUVpkS2MxMUxBSWFISUlhdnV6RUFGS3A3d1FGbUpZ?=
 =?utf-8?B?dUlod01weW94NVNhcytlaVE1Z1lKUW5GT0VZMytKalU5bHdWUnd5dWZuV05h?=
 =?utf-8?B?ZXd1RmFDTlN5MXpsazNkVUtsVHg4cHhsNUp4NjRTY3pONms2NkcwT1hGR1hz?=
 =?utf-8?B?cXBZUC9WWGtqMDkwZCtTVW9STGlvTGhQTVVVWG1kd1hXRkpQaFVtR0ljczBa?=
 =?utf-8?B?eXp0dkJCVWpZYW55bWNCRkQyQ0puOTZhdUxjeGRrbWJXYWtPRGx0RGlMTW5D?=
 =?utf-8?B?YVhBOFFpa1hzTlpjTk55Y2ZoZHRFYnJTR1FmNEd3UlRLSlMwMXNZcXhMSk9u?=
 =?utf-8?B?UUNFS2NXa1UwMHVrK2JxQmVBeVJhb3NnVFpwMUZkVzJlMVZnaGtpR0V6Q0lH?=
 =?utf-8?B?eExIWlZ2RjFEM3NqRkpZcjU5Z28vSjcwaDVyQmprQi8yRkRmaG15aFp6MnRI?=
 =?utf-8?B?VHZCRXRTRzU2dGlWSjNWNVI0Rm5rM0todmtoZTlFMFVFRTZwS3Y2OUJNK3Jh?=
 =?utf-8?B?QUs4SjhUU3VQRUdpaVpQRHZkam1NNmhsSWFLK3llOFdrR2x5ZUxaY3phaUpP?=
 =?utf-8?B?TVJsNGVGbGFQYWMxZ0g3UG9zRTc1M1JxeDRnZDR4TTY4RjM2SFdZV1VoOWpa?=
 =?utf-8?B?VnNpRkIxMmEwQkZYM054ZFZJTjhVYlV6YUpGcU0zcHRzQXczY2lYUkNZZXVz?=
 =?utf-8?B?NWk4dmYxQXVMK1FOR3c1cGtBNUx2aXl3R3hpMjlHcmc0dlczS0RGU0ZxNUsv?=
 =?utf-8?B?a3drMTdaNmk5NEFYdTVaTzN6SXhYODl1N0NnU3VkbEhCNE9FWWp4azJMRHhy?=
 =?utf-8?B?Y1BEWllhcmNYN3REcnMvYnVRaHlld3MyV2VpY0g5U3hjcG5KeWtqRVlTR29B?=
 =?utf-8?B?Z2hlN1lBb0cxVzRSWExkc0U2YjZoQlMzRGJST3A1VGF4UHd1OHZwU29XaGQy?=
 =?utf-8?B?cFl5Y3hPTnhrZmgvS1M1cWlpMzd5K3IrTGY0Sm5FbHlUVjNCRGErYjlQcEt1?=
 =?utf-8?B?ZWQ5UDh5bXdnZTNYbU1sUGkxaVQ0OFU5VXRPakcvR0wzL1FoYm9Dci9Vbm1U?=
 =?utf-8?B?LzhKc0RsQkhCRW9MTGViVm9YWHF0NEZzZTh0anp6SGlEd2NRanNoOHpVb1BM?=
 =?utf-8?B?ZFk4TlVBMGFZRkE1Ulg4VDd6ZTFiZ1E2V1VUM0lObVZTL1VEYWhYSUsxWldS?=
 =?utf-8?B?S3BaeXN5UVVwMHJmcE9SME9DUGFXUnFHRExWKzNzVVFTWGV2ZGd2R2xGWnRw?=
 =?utf-8?B?MWsyN3Z2dW04ZXNPV20yUHVIZ1pnVFptak45SzZXMmxvUmE3bExLaVdUK3pH?=
 =?utf-8?B?VzhWaHM0bUJBWXBXeGhBUVBvUlRzaHRXNDFsNHVBRW85Sk9KSFlteDhhckhZ?=
 =?utf-8?B?NnRPSEJKZGd1RkxSQkVWb1VONUF3OHdnRy9RWW5sZ05YWng0ZCtCUG45SUZU?=
 =?utf-8?B?MDQ0QkpBUkx4SG1RUXBEc2lHbzhjOEl1aDVvWEhMYTJhNnpzcmxlN21yeHFx?=
 =?utf-8?B?bG1scC96YVEyNGFBNjRKdU9HZ1E2ek9HWFMxSnVHSm16eXErQ2RLeDNPYml0?=
 =?utf-8?B?WFBGNGZhd3RoRytEdFYrT0RVZm5KakdreUoxSjFObUlyUmMwelNrY3cwWWpx?=
 =?utf-8?B?d1BYWXVwaFRXSEI0NXB0NFZWRVhlKzR5ZGVSWUtmdklXMkhERE15U1pmbStj?=
 =?utf-8?B?YzlWWVI4b1RIU1hhK3dFREN6T1dSRlJXc3dDMHNhVjgwb1RRL1g5N3QyREM4?=
 =?utf-8?Q?QPJtIj3EGaTIzbM6ms6lxupej117L5jxDnCqi?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19ac4b8-53ad-48f7-362f-08df09e854ff
X-MS-Exchange-CrossTenant-AuthSource: SA1PR01MB7248.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 18:22:37.4505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9gnR/8lkVtq2cePTk8OR8KKWyVafyvg3D6cIOpilkrF3nrY1kYbHybioKnKEfDcntkvw5b6o/tv/AA7pFIvJ2XU+RKObpqD6I0pNPK9mLwvL7pROvOOndP1yUvWB42l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB6646

On 9/3/26 1:59 PM, Jason Gunthorpe wrote:
> On Thu, Sep 03, 2026 at 01:54:27PM -0400, Dennis Dalessandro wrote:
>> While sharing similar bones, the chip for the Cornelis Networks next
>> generation fabric technology has some fundamental differences that
>> resulted in a near complete re-write of the driver. It also does not
>> use the private cdev interface that the hfi1 driver exposes. After
>> discussing this with the RDMA maintainers we have decided to go with
>> the approach of moving to a new driver and declaring hfi1 obsolete.
>>
>> It is desirable to keep hfi1 around temporarily to let user APIs
>> catch up to support access through the uverbs device rather than the
>> private hfi1 cdev.
>>
>> This driver is designed to support future products as well.
>>
>> Portions of this series were developed with the assistance of a large
>> language model (LLM), reviewed and verified by the author. Each
>> commit affected carries an "Assisted-by: LLM" trailer per
>> Documentation/process/coding-assistants.rst.
>>
>> This series applies on top of the rdma/for-next branch.
>>
>> Changes since v4:
>> - cport.c: rate-limit the "Op N SS failed" error log in cport_req_fn() and fix a
>>    use-after-free where msg->req->hdr fields were read after cwput(msg) had
>>    already freed msg, by moving the error log before the cwput() call.
>> - mad.c: treat undersized CH_OP_UMAD_9B/16B payloads in cport_umad_handler() as
>>    a normal, expected occurrence (e.g. periodic SM keep-alive/poll probes)
>>    rather than a protocol error; count them via n_vl15_dropped and silently
>>    drop instead of returning MSG_RSP_STATUS_INVALID_STATE, to avoid flooding
>>    the console.
>> - Updated the AI attribution trailer on all commits from
>>    "Assisted-by: AGENT:MODEL" to the simplified "Assisted-by: LLM" per updated
>>    upstream guidance.
> 
> There are over a hundred sashiko messages, this change log seems far
> to small. Are you addressing them?

Those were corrected in v3. See the "Changes since v2" or is there 
another Sashiko report I need to look in to?

-Denny



