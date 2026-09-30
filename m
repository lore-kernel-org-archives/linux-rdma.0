Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00D94E50B5;
	Wed, 30 Sep 2026 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780636; cv=fail; b=DIM4IvfOmFIXYdOmzG3/JrCcQTXRarl0QZynHUO/PJvnAoRvETViQPCyMsQjndryqUGJsleeVqrrLOQNsxP6Pft/fjSqnSoOJvRrBcb56n/aKj/dXY7GdiwlB8GdxzqSH/U/J//h+NdIh7k5cIQYm3s1t2jKZWKRmbwolafr488=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780636; c=relaxed/simple;
	bh=30YXpFHnj59MX0sBI+Quk6AJ+E1W8i3fAIJC/YSlSDY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lTfaxm6D/GTNE0G9cNl2CjbygaiVHuMmByXS3X1Pq9sAwy8PltNALbjWFlUwqBA1Af9/R/8ZxV946rYs6paJ07bLBFNeifsmjZLdk4C5FpzfVZHa+tLVz/WmR1Pzq/+Te8lAIzAV9wByJXbqAF/hSj16HxxWHDZRdjDKm9sSsPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=erUXk/cz; arc=fail smtp.client-ip=52.101.53.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="erUXk/cz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UNr2F4hvVELtdt4l3yb9UWXxwLKzErBKqnDysvlpDygh3gHO6fbGSfj8pQNgufz5H2tZl116GK2WVT+211POC6psQeki/sZH8nJue7laMVcO3dHq3rMsqYFm+gs0BadfQN6cC5WNA+OD/mTjYcHqBJV6ZXwGrhF/isZI/m1zLbhG3Ic8C/A9InjE0N6+hwi0EHp818ExoGFMi0tcge4X9wmrY6h/zYx/U5nsSdIUqD+V1eJISW5cTUqZfVP+4U5eXtqhyt/IIzFEfYZHr/eVLtKNbrN2oFVa3U6Ygx3it8K0b3SH2PqpX/kB26VlTP1XsEM56isISB70+/oMzA5e7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JGRjOuqYfm4gb+GLMSqBwtsApOklEQyA2jSI1XAsBs=;
 b=Yg15MzWarFhyrpxI2L5AeJam8y+/JK5zAFiGHLXl/Rc/ZY+Jk1UQL7wcuQLe9I2eHHgNy3gwJreRZIDIPYngthvT6SlYZ6Oimsyh6cpF0TAzDgoIOnjmOJoBvaihAzoB1CaEkHOY4RgGDhlJTGEXd0y8/J+J70Jg3GBLvysSaNA2zFI1uRJ9tH32NzLk124R8Ob4h3bgA6jizYoTG8xqTCYTu3pbFV4RrmwPZZZ80BSxcXnEf+bOaWStAsxIQcJ2AjmE0nyYNNEqJT+coLK+42pmrE8HI7TRLzLtV6BNQW67m1HkHpPv1T+qdsHvnJ4XanrLVBbtLIeIlBGDFuXzHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JGRjOuqYfm4gb+GLMSqBwtsApOklEQyA2jSI1XAsBs=;
 b=erUXk/czrmmw398Vvfm+7dLnBfTVXeGQLqLU2h13c/N3FX5FRrSVTustP3edtDNR+PcFeMqmzGm7Zq4rFUsqTa/pi3qnkFlCN0pN+yq1jB5BrcJnFbIL89wl9Lsi10oVXToBGgDhiyVaK4ePEkK1SFhYCLHX0Bp+qlnmwlsciBE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH2PR12MB9457.namprd12.prod.outlook.com (2603:10b6:610:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Wed, 30 Sep
 2026 15:03:31 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 15:03:31 +0000
Message-ID: <31fdf414-1345-4db2-9fb7-08265a7bb6d6@amd.com>
Date: Wed, 30 Sep 2026 17:03:24 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 iommu@lists.linux.dev, Tushar Dave <tdave@nvidia.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
 kvm@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Sumit Semwal <sumit.semwal@linaro.org>
References: <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
 <607e8903-a979-4d78-bf08-447321c03119@amd.com>
 <20260929132305.GJ563127@unreal>
 <720dbac3-24f6-4c91-899e-e205865c1fd1@amd.com>
 <20260929175737.GK563127@unreal>
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
 <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
 <20260930143237.GI3401365@unreal>
 <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <b2e766389e57a55da959369c5ad4b9e39e425659.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR5P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f1::8) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH2PR12MB9457:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5f3c06-9614-4b6e-c419-08df1f03fdc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FpNND/XMs6D8Q3O0+ukZoUzLOkUBcdoYL8MbYnOFzBevW68KY4Qq5snEzo9yku1j/P7QEmG8EYqxZWoYUjIJQS0wrEN5mNMvziymB8/ZYv82H1eQPdMP02pjkAz05gjDXvcKoxrzVEMrLzb9iw3jR8nDEDm09OXGKe41MBzsw3xsumscerE+N9gdEQn2bmXk7ydyDOcpS8oGl91u0xmHzTydS+ynlp73Y0mXJcuY5dzOAQR1Xto/llQwO2Y2/Y9DzKR1mNl5xOypLv+sN42V9rffhodnAIN4Ugy9BushUmtbJPHp7as4fcNV3DssDMM4hgsQX/x69Ut6TL+jY3k29jFfZJoV3mVEekU7nxENsM/iDwt/+2VC6BAarpPnCng7Lote3ZdFjU6xM2LngEi/AfhrN96ruFe7BjcwWW3aRdnzeYqXzMrSAdv9k1+vvLCBo7C2+hlW/W24EW31LjPmRfN0mvYM5+0MN9iiUZ5Sx183B21nZ3UJnDQm+hlCVoCSPiHGilMNT02NeG57/ETG7BF8+suATstpTQeKNoYURc1VZs1zs+HsrHt1/P4KtSAZuW4FlVZWDieuYhatrfzyq09Oy72dXErDkNS0X7wqNUwTZyKjGqg3lPZJXMzF76YTz9C6ERLmXjWcMF3xeV6LNSe9trmB0A06cYpB+HTv204=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dW10Y0hubkYrci9ua08vcnkzSmQyaGl6VkhlR1poOGdrRnN5L0RNRnJaSndl?=
 =?utf-8?B?cXdvR29OcmhudnR1a2lxRldZbGo5Rm50c1ZnT0pvOUt1NzlRQ1d2S0ZvZDUw?=
 =?utf-8?B?cDI0bUgxOElaOFJxUTdrQWVUaldHbHkzUnBzblkzdjVscUdrUkZPZEZoa1No?=
 =?utf-8?B?QjhQcDdxZW1yWElDTkkxNFNpTE10TkRqbnJ6TlBrR2F5TUxMS1ZDa08waitl?=
 =?utf-8?B?Q0FDUVFXRUoySjhBVUtWcmo4L0t4aVREeVlJY0gzN1M4Nkd3dDkydXYzalFj?=
 =?utf-8?B?bzd3aDRqaTVSdkFxejBLZDNod2pQY2RxK3FZL1JGNVJYaE5FY25EbmkxOW4r?=
 =?utf-8?B?THVhOFVmQnJXOXUxVDlzWExaVlorbzhvV2FzdFZKT3NMdUJqV3dCUTJkanZo?=
 =?utf-8?B?MjlWUHdsdUNvYUVYZUpHaGtFeGFxNUpicHdoQjVmWWM0azZIQ2hVSndVaDQy?=
 =?utf-8?B?c3psSHEwcVhxajZLeWRKampIQkJNTEpiUnQrSE5ucVYxeFFHVk5uenFuNFda?=
 =?utf-8?B?amRLUGpmMVJBT0REMDJWeTBMbnZud29kUFJKNGk5ZFBDaE9hN2xMM3NIKzBR?=
 =?utf-8?B?OC9QR21NU3RsN3RuSXJKemlHeVVZSUF6cDBBcmh2RW9jVlhDY0czSXlyeFE5?=
 =?utf-8?B?NlJncm1rWDBud0FrUCs4cjNDVUEyaXRQYUxnM1lnbVQ2UnB0bTRZQkp6Tit6?=
 =?utf-8?B?MHo5NmFFZjFkSGpickRrSURsS3VjdEs0eGJzSVZ5bXBlWDdQRzZLRFZsQ3pr?=
 =?utf-8?B?VkpPcDR6UlBkd2ZBNjIvUHdxVjZvSWZhdS80K255RVRkWWdSQktMbkI0UUo4?=
 =?utf-8?B?Y2pEQTd1dlVwSWdWNHhRSEZyVGd5a2NUNHJFd2JUL3JTeW9Sdmo3dy94dmRs?=
 =?utf-8?B?ekdDRzR3dkxJVklaMFY4bCtSTlQxZmxpTitmMSs1NWllNUhsY0tIL1lmZzY5?=
 =?utf-8?B?cHQrVDc1dHVsUVJHd2c0VWtxZW8yL2QzQVAxYzNObkZMTFRQeGw3cFk3RXB4?=
 =?utf-8?B?S2tKWlFrTnVVUStCN005Yk5Nditub0tJaE1TYXkzallOdStsUmZsbUNKdVpV?=
 =?utf-8?B?UHZhODhxWUoxUC93UC9DUVg5dFZjaWIxYzlLdy84aGtvRk9sUmhjU0ZlY0ho?=
 =?utf-8?B?SENxMERpZ25VSjYwazlXWDQ5TExaNmk2NjhEMERwclg4V1ROTUsrWU5LNWhv?=
 =?utf-8?B?b1NyejBjTUYyeDhtTzNkS3VEaTArQkxwRjRsejhod254dDJheE4zMFZqVHFm?=
 =?utf-8?B?RVhXZjVCMjVSL2JPWVJNZVBVNkk1ZHVtcHltTk9LbmUxbVlqbWJNN3BxdTdo?=
 =?utf-8?B?aFJXZ3A4cjdtNTNmUGFDZHpIdFN5Z3h2N1JiaG9sSG5pNnFiU21iMmE2c1Fv?=
 =?utf-8?B?UnV5eDVFTkpUdmJ1OVAxaHd0cndTTGFaQXpIdW1sNUdZTzJaY3F0V2c3RGEx?=
 =?utf-8?B?bnQrVUlEZTdlVUxKbitPenBzNzZXZUhSTlZ1RkVEaGF6Y0ppY250UERoR0p2?=
 =?utf-8?B?Ky85Q2lyTVBvS0V4V3U3NldKbm8yVjBIWTR3amdITHY4Mi8wNUdvWGo1bElC?=
 =?utf-8?B?LzFRNkVMZmtFc0p3eSs2dDJNcGxlN3FoNkhZM0lXamk3ck13RFdsRlY2YXd4?=
 =?utf-8?B?MklnUS9kcmM3MWU1RmUreU9BeWFUVlpHV2tOcXgxRTN0UExpT0hvV3ZUVmxZ?=
 =?utf-8?B?c2I4WkNVQzU1RkhQR2x3WU9yajVFaDdlbWFHcWUrclBZVW82eW96dUt3aTFR?=
 =?utf-8?B?UC9IV21zYVF6d213TlJ1cmlIYXRpWlRWR2pMNkZLbTJHZzM0dXNabTMzNi9v?=
 =?utf-8?B?dkVqZWE4bW1xWWwrdVdVRDFHcTQvSU1IUzY1SnYvU08yMFY2aDdUQW9uMWJE?=
 =?utf-8?B?bnNMZFNObE8vVDhlejJtVm9kdVdTK3FhcHdkUktYTGxFNjlIOGJBY2RjRmw3?=
 =?utf-8?B?WUJIenA3UXY5N2tkOU9VcWM3cDNFSzZzamIzTm45WnRWVzdEUWxGbTFhZlA1?=
 =?utf-8?B?Vi9IVi93djNTTmVHc2pGUWhpYTlGa1lxOVZOSTArdDRvQ01FQWUvT0NaSG44?=
 =?utf-8?B?MFVsNXdxaFliS2h4RlRwTHJZUldSdlRJN012RHlSMStJL0RuNERURUc0Z2Q4?=
 =?utf-8?B?bGFGemJuMmRYNUFlanBSWWV2dnhXRGpBaGh6Z3ZSV0pMZGJZV2p6cDhteHFC?=
 =?utf-8?B?US9QSCszbFpqempGUVJtRVlaVDZHVitqc2QvYjlHQXcrU2dEMHlnbzErdjFp?=
 =?utf-8?B?RjQ0MnNHSi9vazIzQkZQaDI3VlFQOTVpaUdHWFZoNGprb2ZvbXVjTEZ2dGRV?=
 =?utf-8?Q?sV0Jlu9oMcxfTr8gQ/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5f3c06-9614-4b6e-c419-08df1f03fdc3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 15:03:31.4750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: watFlT0cA5KKclqD9Jkahtwq9XhWwv2KWSDNXL/RgYl/Ok3jl3Gj3m+giT7IGiJb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9457

On 9/30/26 16:57, Thomas Hellström wrote:
> On Wed, 2026-09-30 at 17:32 +0300, Leon Romanovsky wrote:
>> On Wed, Sep 30, 2026 at 01:52:39PM +0200, Christian König wrote:
>>> On 9/30/26 13:43, Leon Romanovsky wrote:
>>>> On Wed, Sep 30, 2026 at 10:34:56AM +0200, Christian König wrote:
>>>>> On 9/30/26 10:18, Leon Romanovsky wrote:
>>> ...
>>>>>>
>>>>>> At a minimum, exporters need to pass `p2pdma_provider`.
>>>>>
>>>>> No, exactly that is a no-go. The neither the framework nor the
>>>>> importer should see the p2pdma_provider.
>>>>>
>>>>> Only fully translated addresses where the DMA access should
>>>>> happen.
>>>>>
>>>>>>
>>>>>> If I keep the “dma-buf: Let exporters hand out the P2PDMA
>>>>>> provider behind a
>>>>>> buffer” patch, I can move the P2P TLP types back into
>>>>>> `p2pdma.c` and export
>>>>>> only the function that indicates whether ATS is required.
>>>>>>
>>>>>> Is it ok?
>>>>>
>>>>> What you can do is to forward declare enum pci_p2pdma_map_type
>>>>> and than pass that 1 to 1 from the exporter to the importer.
>>>>
>>>> Unfortunately, neither suggestion applies to RDMA NICs. They need
>>>> to know,
>>>> before mapping addresses, whether to create the memory region
>>>> with ATS
>>>> enabled.
>>>
>>> The design principle here is that the final location and access
>>> path of the data isn't determined when the buffer is created.
>>>
>>> The importer first need to attach before it can query such
>>> information from the exporter.
>>
>> In attach yes, this is why importer digs in dma_buf ops to get
>> p2pdma_provide, however it is before addresses are known.
>>
>>>> The importer needs a way to obtain device information from the
>>>> exporter so
>>>> that it can configure itself correctly.
>>>
>>> That won't work with DMA-buf then, the exporter is completely
>>> opaque to the importer and that is for really good reasons.
>>>
>>> Why in the world does the importer needs to know the information
>>> from the exporter before the mapping is created?
>>>
>>> It is the exporter who decides how data is accessed by the importer
>>> and not the other way around.
>>
>> There are several reasons:
>>
>> 1. This is how DMA-BUF MRs are built in RDMA. In mlx5, they rely on
>> the ODP
>>    mechanism, which requires an MKEY to be created first. See commit
>>    90da7dc8206a (“RDMA/mlx5: Support dma-buf based userspace memory
>> region”).
>> 2. P2P routing is a property of devices, not memory. It is known and
>> remains
>>    stable.
>> 3. See the VFIO TPH ST discussion, where the requirement to obtain
>> the
>>    exporter’s P2P information in the importer was raised again.
>>
>> Thanks
> 
> 
> Returning again to Jason's series. Let's say we'd add just the mapping
> type infrastructure, converted users of pcie_p2pdma only to use that
> and then we'd have access to per-mapping-type data. This could actually
> be done as a prereq for this series and merged separately. It's a
> couple of patches only.
> 
> Jason's match() and finish() callbacks could compute the interesting
> routes at attach time,  perhaps even condesed to whether IOVA is used
> and whether ATS translated packages have a direct route (which is what
> mlx5 care about AFAICT). This information is kept outside core dma-buf
> and would be specific to the pcie_p2p mapping type (interconnect) only
> rather than having functions and callbacks bloating the core dma-buf
> structures.

We need to move that to the mapping time because that is when the final location is committed, but apart from that the approach sounds sane to me.

Otherwise the information can change any time there is a new importer attached.

DMA-buf is basically just the frontend for passing mapping information between the exporter and the importer here.

Regards,
Christian.
> Then exactly where the cross-subsystem match() and finish()
> implementations should live I figure remain up for discussion and
> guidance by Christoph?
> 
> Thanks,
> Thomas
> 
> 
> 

