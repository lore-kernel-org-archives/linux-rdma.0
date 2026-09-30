Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010063.outbound.protection.outlook.com [52.101.85.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BF34519B3;
	Wed, 30 Sep 2026 07:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790751683; cv=fail; b=bXfMhou9LjfaBDTqf5Q7Ikv1fbxlUdpfIBnpvMe5ZUtTSUVaXEWWUK5idGwM2frc+P+QqBalwkbsUoJzk7vswx4KTClDGFEagqCSu+z+yIQhXU5kBGcd8SmqN7Vab2J+YHKWwQQifTxlmwAmmLLEjrBND8f6G06vCjtD0z585h8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790751683; c=relaxed/simple;
	bh=UzQP+Jz96c9j+bYtxra+S4dF2qGDX8UAv224M4jZ5Ro=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tWVN0VqK73IxcofHnx2EhvJ7wc6Y7DbqSfjtX6UOKfWuLuYVrpAApHZehrrsotOwud4Qz/+XbxQfKwCHzHG5Fyiifgj2EW6l12BHzFtz/X0t4ho8k9UM28Ve8DH0Ynl97Ol6AKPp2CV+TeRhYMkOBkbQX4lvO5PeyM87OCBGV0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rbLGgK7X; arc=fail smtp.client-ip=52.101.85.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rbLGgK7X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVLBec1OPwBnNZl/7T1Bv6fHP+NJYXXYUUMs+thIvIcrcRMiO2MNetxipovL5fbDbYOLIEZYKm3nv5vg+z41X817/1tDTZeRORIzReL/rBGLpYmRXiyjmHEGi6HMdOWa+ugELEtB396JOJUyAJbRdUp9cSN/ZkgIgpH91eXCqTube6yyrrIaiGJp23/e7x5UHLDBXeqjdnoDOGrUPsY+JRsIdSfZ2t3D4wTSwr0T+0Acub3t4hNPNgbl6lBGyd4JSghxLwUCsLGSz8oQO5mOYfutu+QahF0P0NEcyOOiFDn1xA7HI1ECb3ZoNPo1H/csI/nZha+qkTi8KWD/+Weetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qB0piOv5r+/7ZTofJHn29ryFKE/xXRT5rAL22EWBOLQ=;
 b=ZBLQa+v5lxWq77K5TwHpxtG+QReOq2A2TEH4DPH73idGhmt7vJaWKJJZPpcQFYIGhjWpXqaFhVvjstvKnE9busitc5XCaQfRg8BX9X5cwioTf0SBhFBBF/LVMzLNRgWIZtZ/wrtzHbdvxqj/322pA1m0HbXiuVAxgjDg30rQ4FHsYM+gs7uD4dOWGj/Xz5hb0DvS9t28FGXNOhXzLShPoHuhiBlc7WygERaxKt+WWA8zuisV/QcV4pBYsjMR5E8BQJHP38q8bXe6nAMBvDR87ZVEuumOIILzsDiN5bXXHJx1bFGOWMpwqKY1MqWgPhj2Yj+Tq8nFbPlBnIALCUf6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qB0piOv5r+/7ZTofJHn29ryFKE/xXRT5rAL22EWBOLQ=;
 b=rbLGgK7XTObWDGcBM1Yik99Tx1YVmaEGXcwUA0HEoK96T9HyMlaFAlUxXqzw7DMuFDfccrWV2tre8KWpIeyXeZ3oQ1V6zddOCSloAhXmuxAcc4mBqMjMpKXPoQVdv8RNj/8Q0/3BE1KlyrF5VXO9/WV4o70nx2YuBfssQlrAQVU=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH7PR12MB8155.namprd12.prod.outlook.com (2603:10b6:510:2b2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 07:01:07 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 07:01:05 +0000
Message-ID: <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
Date: Wed, 30 Sep 2026 09:00:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
 Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Sumit Semwal <sumit.semwal@linaro.org>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
 <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
 <607e8903-a979-4d78-bf08-447321c03119@amd.com>
 <20260929132305.GJ563127@unreal>
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260929175737.GK563127@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0415.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::12) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH7PR12MB8155:EE_
X-MS-Office365-Filtering-Correlation-Id: d2b4e980-25fb-46aa-3fbc-08df1ec09886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|18002099003|22082099003|4143699003|6133799003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	7MWexdFLvXPnE4eXTCyT5clLgorMWCLYf0TAGTKoBYIQxuckXIYoJgzL3Eu7RMi7tewD67A0J/Iq633iDiFA195BmLM3BkGFcIBGTsLRDTKO94tu8df3U7kbkDslApdaoyiBbIItbTrp/qjMLcGH0j+df9Ox2hY+BlHDZLKbH8b/QWNziDZEwL6rLgWl2zVOf2099e1s3D1Qvy4rjSPSXDdU4YuaP1iEd7mFzy2DMd31VHpKcARtaeofTCD5yNec8KZsjwYTJW9V8G6HemLRHRhwfaJWxmQOLNYUuOUaDAYYM8CDj3F/BSllzPRbbtUJeRxci2Tw0cA3DwOQXZCdQjRZTmmxWPKtRh9CfXDoD90iqZS0RX177l3X7vbtjmJuxrzP5IppjLk9rB0e08PTkVOYoT4QDqWjVGBJBtFfyov35Zx5cCdazaZaVlRk7BXth2wae2Ll446fbxoYdGyyKd3gYybtxPLeeWU+JYe7fKF77RtPjMRl3XvpiUnFuBxzKCu+BkUul4Ubsk4tlN1qEVVgIXBZVE+UhZX+bpQYiBNiTIkDhWksZUYvicthzme7lE5pOwhrEy14hF/97FAkA2lYCKqmIDV/SMp4jRLACVqquuLhNcg/Ij7SKHSIVDzz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(4143699003)(6133799003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnVsbS9zVUFlMkIwWHZUTWFsdlFKdERmK2JRRGkyeWFlYlFVV09WWWJsT1hJ?=
 =?utf-8?B?L3lPLzlpYy9Qc3ZoNTQxOXlVY2t5SzkvcWI0Wkh2SWFZRU5oUm03VjZEazZ4?=
 =?utf-8?B?QU8xR1ZMMzhsc1JNbDRuSEU5M2t5Q1QxWmlPenhIRnEyNU9ZUkRZRjdUb1J3?=
 =?utf-8?B?dVBpMVRJek42T0FJdHl0WVNXRnJxL0YxdVhVOG1LdURkY2pjOGxLUFJZU3BB?=
 =?utf-8?B?V0lRbUtldmNwWDd4c0tWNURpeWtnbFljSE03NjAxL2lETWMxZE4raXNVZ0JB?=
 =?utf-8?B?UWJDSFZCYVRNTGkxMitYdytMUEh6Qk83WUJ5cmhTaWFSNlJDM3Q3eVA4RVZ6?=
 =?utf-8?B?RlZMelIxWTVLOHNyd0FzSm5LSEEzZ3F2akd3Y2hJN2MrK3pGcE5ScDFuMkpa?=
 =?utf-8?B?STF3TEdXZzdBT3lleTVtMjkyOUIzT2hmSjJMR2EzVEVvRDlCRFNrVEV3RG5N?=
 =?utf-8?B?NXhKcjlyRjQyckxNVml6UjhFdjB6NHhCNW02TDZCemNxcHlMNzZzcjVQSVhF?=
 =?utf-8?B?RVdLODFrWmNLY0hRbEdLWFBFVmJ3djI2YTk2clVYSGQxK0xHcFV4anN0SWFV?=
 =?utf-8?B?MnorUThuRDhPMFk0T05QRUd0TDFhMGNmcFlNcHB6MnJjTTR2UEJpemlIcWRw?=
 =?utf-8?B?am9pUy80aDZDM0hxY28yMjI0NFBqaFY3SnpWcTNKZy9TZGNvTU1heGxuYUVo?=
 =?utf-8?B?Wk43clZIZTE4VGlMQzRiRWE3WVpKWGRQTC91TXRCUllmMzZoTG9yd2h1QlNG?=
 =?utf-8?B?MTc2MVVmY01SdDc4S3dLL0pIaEdkcmFZNVArcUp4OTlzZ2k0aEpTVkFxSkRw?=
 =?utf-8?B?Y0ZOMW4rZmFXbndHeDVUeTlrcFVWeU1YNytFa2tqbmZmQkp4Y3NlTzh4Skh5?=
 =?utf-8?B?YWJJSHZQY3A1M3FMR09UUEFFZ29XeUJHekJLc09SbVVidVJCZTlKRFpnTFY0?=
 =?utf-8?B?bWlLVFpwRE9MSDNYSUdBTE04VW1iQTN4QXJlSGx4UnFwL1U0aDI0bXZnOWM5?=
 =?utf-8?B?YzJwQlM1OEJKeXY5eHcrN25WZkphNGtCT1VBUDFtQkE1YmduV1V2Z1VWemZS?=
 =?utf-8?B?MDN6N0FDYlh2cGNVdFhCWTVodC8zUk5hTGsvVmJhTXZkNjFJZVAwc3JlRGxi?=
 =?utf-8?B?a1B6OHZTZk9WS0Q1Q08ydklVR0ZvOE9yWEIyU3ZnV0YrRDVRK0ttc0Z5Z1h2?=
 =?utf-8?B?bXlNQTk1ZU9yaCtINFVvWjNtS1ZYRUdnb0UzdmlPM2V3OFpDdVhTa3Bwa2RS?=
 =?utf-8?B?SEVORjUrRW41SENURmNpalptcDlpak50OGV1SDR3SDNxZDBqSFBtY3lNcktv?=
 =?utf-8?B?SGNLdTZjRW4yVTVTNS9wN3g1cE5OZFI0STZ6ZE5qZUpoSkFkVlYvQkhSRHc4?=
 =?utf-8?B?UDNwVUVUUmRma2wwL3JWNlVmWkVsMVhmRFk0N3ppRHdHRkNWeGFlcFprMktB?=
 =?utf-8?B?MTJhaDBER0tiM3QyUjhrc3BzUG0wczJYaUxtdEwydWY1SEw1L0xhTWgvc2Na?=
 =?utf-8?B?WnBWTC9FUnQvbmJwSXQ4cEpIUWs5b2lhS1FWdCt0ZVVCZHdYZGVvV2RYd3Q2?=
 =?utf-8?B?M29UamgyMk9ZZWlEbWV5N2gxUGlsT0ZpRUtVNzYrL0dUclNDVWdISTBwbVVM?=
 =?utf-8?B?Wi9DNVNaUVB0Tk5TVlhwcGEvVDZqUU82bjhBQzBpOEpJSHdWUU8xcTVxM3NC?=
 =?utf-8?B?djBQSWdUL3hodUIvRE9PZUJja3FmU0lpVDR3TFZ4WHI2blNaQXp6SHUxSVEz?=
 =?utf-8?B?Q3ZpOUl6TnplK2JNMFA2dmJvZkd3TXI1WnRCdGpFNDhvTWlxUkYveHlDSnlz?=
 =?utf-8?B?RzFCMm9ubTZuS1pxYU1BS2pKMjZvTm5IUURZNXY4NHNJSFVlY1JKTmNYejA0?=
 =?utf-8?B?SkJtYm54SFI0dGdmdzl2a0xVUm1tQ3hTb0hwdnE3VEVxNFVUNjBWNVRHK2NV?=
 =?utf-8?B?cFR1M2k4alJnVmFETUs1WFZZZks5ZkpVWFMrenZVM09mTTMzZW9xcWxKSU5w?=
 =?utf-8?B?dExqOFluQ05WZ3UxdEZRcUJ3Qkw1cEhzdTE0MDdXT3RPM0lQUlZsby9WaFJS?=
 =?utf-8?B?Q1FqT1hwNldoSThKdUdGOTcvc2U4UDNjMWFqOTY3ZVJHajEwdU85K3ZpSExX?=
 =?utf-8?B?QjdqbjREYjBOTjVOcWNUNTZWajFTL2tpRGR0WTRMVTlXWnhnbC9HOXlUVldB?=
 =?utf-8?B?bURjeWhnK3V2aDNiQXYyRy9uZ0pSTjVNZ2FYQ2hlNGh0Y25SK0dnWm81M01H?=
 =?utf-8?B?TGsxallWa012bHVTRml5aFRDN2xMRFlFY1dyNzA0Z2JURW83MTlyQ3RtV2dR?=
 =?utf-8?Q?YwcccW+0owr4zzV4kD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2b4e980-25fb-46aa-3fbc-08df1ec09886
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 07:01:05.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4ymUtqE/ed5dcrsRWr4f7YFPAUZYU6+68mwAFSAgfyuz/ldpLo2bOBa33nAm8jv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8155

On 9/29/26 19:57, Leon Romanovsky wrote:
> On Tue, Sep 29, 2026 at 03:39:42PM +0200, Christian König wrote:
>> On 9/29/26 15:23, Leon Romanovsky wrote:
>>> On Tue, Sep 29, 2026 at 11:34:05AM +0200, Christian König wrote:
>>>> On 9/28/26 13:19, Leon Romanovsky wrote:
>> ...>>
>>>>> +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);
>>>>
>>>> This function call here *must* be in the exporter and not the DMA-buf framework.
>>>>
>>>> So clear NAK to putting that here.
>>>
>>> "Look, it is easy to complain you don't like how it looks, but this
>>> stuff is hard there are lots of competing concerns, if you have a
>>> better idea now is a good time to present it."
>>> https://lore.kernel.org/all/20260921130858.GO11599@ziepe.ca/#t
>>>
>>> Do you have a viable solution?
>>
>> Ok, that sounds like you haven't understood why I'm rejecting this.
>>
>> By moving the calls to pci_p2pdma functions into DMA-buf you bypass the NAK to expose those functions to drivers from the DMA maintainers.
> 
> No, you have misunderstood Hellwig's position. His request was to ensure that only
> subsystems deal with P2P internals. He was perfectly fine with bringing P2P
> complexity into dma-buf, since it is the agreed-upon mechanism for sharing DMA
> regions between devices.

Thanks for clearing that up, I indeed didn't realized that.

But that is pretty much against my standpoint that I don't want any P2P complexity in DMA-buf.

> 
> So this is not a NAK bypass; it is a correct implementation of his request.
> He handled P2P-related complexity in the block layer.
> 
> Let's add Christoph to the thread so he can correct me if I'm wrong.
> 
>>
>> I unfortunately didn't understood that when the dma-buf-mapping.c code was added and just assumed that you just needed a place to put some common code.
> 
> That is not correct. Devices A and B share a DMA region via the dma-buf
> mechanism. Where do you expect the code common to dma-buf to be placed?

In the DMA layer!

>>
>> So as long as that NAK from the DMA maintainers to expose the pci_p2p functions to drivers stand I will push hard to get that stuff removed again from DMA-buf as well.
> 
> Are you seriously suggesting that every dma-buf driver in the world should
> have to reimplement this mess?

Well I completely agree that this should probably not be replicated into each exporter, but that is the job of the DMA layer and not DMA-buf.

The purpose of DMA-buf is to exchange DMA addresses between an exporter and one or more importers and handle things like lifetime and synchronization of accesses. 

What the framework should do is to transport the capabilities of the importer to the exporter, e.g. what physical connections we have etc..

What the framework can also do is to have additional information from the exporter to the importer regarding addresses and mappings, for example if they are bus, IOVA or some special internal DMA addresses or how to stitch together your PCIe TLP or whatever.

As long as both the exporter and importer agree on what those values mean I have no problem at all with that.

But how those DMA addresses come to be should *absolutely not* be part of DMA-buf! The complexity of that is seriously not something we should have here.

Regards,
Christian.

> 
> Thanks
> 
>>
>> What you try to do here is seriously not ok and I will push back hard on that in the future.
>>
>> Regards,
>> Christian.
>>
>>>
>>> Thanks
>>>
>>>>
>>>> Regards,
>>>> Christian.
>>
>>

