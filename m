Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012012.outbound.protection.outlook.com [52.101.48.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520223EC815;
	Wed, 30 Sep 2026 11:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769170; cv=fail; b=hoI2qbIJpx4CYi/HX5WOpMp3f1uhWYiFjsKKNJlrgVBsgkDheyMr8rdoZOJ1qN54iX+zQIHhCLTobe6ZlFCCwub/BFT55dhcZT2ammlUQQTqFOLRfsdb1dGrF0bVKspuTCVSCXzgPqBxu2gbD8YoPdhsu7wFlRlx/Xg8m2/ah2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769170; c=relaxed/simple;
	bh=Zrab33aLlEAZPZeGSjNpVOzRk159Rr+NBE9iHb0KhCw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fnbdq75xWnzDlxsFB9qVAwE5+3jgCnJjyiNY/vPKnok4st8j10Pt0C+uNTf4SKpR8ghgReM1NJEG6pDYF0EiHLh6PLz0kWL5lS58hApYb6Cu9d6hjgmsDrsMK3RLHLGF5TNfECChgW9cUvVguLNVzsEeC6mrlWXgY8RXvkUDnZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RZdUEce1; arc=fail smtp.client-ip=52.101.48.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RZdUEce1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwyV6i7SBpIEdWjMDnvq3mgF/ZySU+lRi97X+HMv8iPLZaisXLcKgvdoxfeGqkedQUnYfI0igCcdINu5iWXd4G0QicrmZOxWT4GL1N8IfIuFHF3lwP5xFIJKNM7xJdvqERnc6saK/T98Ht1bp+Vr3s3ZckdwQjT6lUnlxfd8jENehkbUtvg0a4eev+KDSEDOjgipfitimYJiYsdidMfq3K2k2qo3yNlYl86yagBdx92HUaMdBTPK2rnyimq4PmL6nih6R3M5mse05NYR4qK95Ol1Lt3wvZsJ3A6vU+NfARAk4X8E3vpl7BTjdv7XssXlAlCFpc3/SAJkol7ekTnxPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEvHtxIdqsfhTBVkbiCMeBSGo6IMfO8OaXy6tKtqooo=;
 b=SpLADxOjDDVk4lqxV4M8MWrLisuZqsJL6IKqseWpkO6lfqG/uGAMx3eshP87hotOmkfoDtI1KpWx6dn422XISkSAATr0X4FBMA6ARAaB4yxxb7+4o1VtbiHw3a+x/KK9cognT6+SCZRqyXmR8rHUtT5NvZ9ynfmrD7fQtj1mMB7DiF2infhkT0ksEvzDtYj+5wTRowSxrWockC4B1k6F+0QQwNKkmia5lBi/pbjT0jThrwH5eDbQxCaYInZCZe9JIA6hTkd1N3KfX/rNypznmg36CHLAvjREEvxsAtG+ESJjwBJ7gx9JKOByKiaaj5YHqDKq95NXkJwe8zH91OEwTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEvHtxIdqsfhTBVkbiCMeBSGo6IMfO8OaXy6tKtqooo=;
 b=RZdUEce16NeuFpEtoZqU317MFFd0O2B+yCel8M0PsF9LWGuVKNCrkyexVg0vGC7XbRvqn1+v9Hl+GMOaUW51UJFd5H/Np3iIASUeJ2RliBR2wcf+Kfg97usHyMLPbmcnkmCeuwpxaGuJQnJFvFqIMcMgIrbOBOftHLh6PWPLeZk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LV3PR12MB9354.namprd12.prod.outlook.com (2603:10b6:408:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Wed, 30 Sep
 2026 11:52:46 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 11:52:46 +0000
Message-ID: <fbdc710d-7be1-4021-83c2-548c798d9d14@amd.com>
Date: Wed, 30 Sep 2026 13:52:39 +0200
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
 <eeef5951-825e-459f-b474-bf8c59588446@amd.com>
 <20260930081832.GA3401365@unreal>
 <4549640c-f4a5-4dac-9be3-2e5aa127555c@amd.com>
 <20260930114356.GC3401365@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260930114356.GC3401365@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::30) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LV3PR12MB9354:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1ecc12-d9b8-45f0-9fcd-08df1ee95813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	EL3Iq4afWzlfx15QkZBURGTPkrJtm0eSmKYmLkmvNjCqCVuCKP2ANCJueefyiW3zWfsagk0HyB0l4e3gJRn2Z39ednKnF+eHvHNGc51ab7M+s7dD8UXhokBWp+EjE+LJAfp4XqOL6rj2hDj/zon0WtCkRucuAMES3TJSpmoewPp7IJh/XG21YTJvrqJdySmSZMBJdCwkwHMa7i0lMGHI8wTzB2mRmtYHChXZM8u3qgXwl6uQXhEmbBbx5E8NTGeWKzlpLl03BjGypimNzFG8I6KLkYFGVkNZxcOsfN3ZF6oO351g1zZFluC+QUIDWrDf8dKy2MNxsum0bStJQcuceC1RsDIcZNh1fi/OTun4UFMjzDEWtjm+YMyaRbBfuvrxktDZR3Aj79Qs1/nAaDXJpJEJnUSMpnvavnRuHsfjbltbS3lMD7hc3rNvE3rdGthQVHux7/JuK1Nl/Q58Dsz7b3L/nCG0kRGYA2eQd6yrMfmKSow2St7r+noc+IGKu+TAd3EChhDbdIvO93d1nK415SoemPtZtwsYYWUZhLvUtr9pgU82/sOf9/1ARt85CMnviYrrUfpBjrW9o7VJbDGT0odWhB+qzAOvD92Tg2ZFAgenwmoasEwH0v/QQdO/P8c0keBoI1Ryy8M/5puhrG78P5KgIirkjQ0DqlTssLdkkZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUFWemFuV0R0RXZlcGtoZmk1c2psOS9jV2xFbk9qcHBjdTJXYkVkQXR5NG80?=
 =?utf-8?B?MGRKOHJPUVdFZ1JXYVgvays2cGNjbDJ1Q1VxYk4xSFhxWC9aQXJTTXZSTjNw?=
 =?utf-8?B?Q3ZsdVl0alNsYzgrMWJ5YXR0OXduRk84bTEzNzUxSEpJSzIwOTB5Wm9hcjVl?=
 =?utf-8?B?VEt2YWtHblNQcE51eHkxOGk3RmN3ZFg5S01WN3BhL1pSZDMrOFdRajNVYm5l?=
 =?utf-8?B?L0ZoTGF0c2dMNk1rZmZIT3lwWDQzNnY0cXhIaUhXOGpwWTRpYkV1NU5NenA2?=
 =?utf-8?B?Tk5qZHdaa2Q5RVRFaDFweEdKSi9UVGFqSXNYSk1LcnJpVXFzRVd6T0ZHTWt0?=
 =?utf-8?B?eEhsaWFsTkUrY09LK1JaL3ltUUFoTFcwWlY4TDdrSXdqaG93RWFIMUFUN1NY?=
 =?utf-8?B?YVB3OXFadmsxc2FuRzhuKzVSbWVScEZmWjV5NGI3RG1yOE84dWphY1BqQlZw?=
 =?utf-8?B?OHV3T00xTCtudmNCMmc1QzRtUWp5aUFCR1c2cEJMT3Z5Q241cjZhODRvTGJY?=
 =?utf-8?B?ZjNaSXNGNW80dVkrQ21RTVgyMkRid3l0NVlZZjV1Yy9Pd1ZGcFkrazFHWmND?=
 =?utf-8?B?RWVLN0RqZ1oycmZyOUlMbXE3MGJjT0VseUNWTVc5eDVINS8xOHh0SFdNQzZ3?=
 =?utf-8?B?NFJxbGVtRHU4L2VYWnVDbjlIdFJtOGg4TXF4TTJlc0hZbFhMSENRems2clRj?=
 =?utf-8?B?Kzl5SHhvVGhLV2pXY2NxRnJKVTJ3NXowMXBYZlBuRDBEMk9GVktIbjlnVU9o?=
 =?utf-8?B?QWdobVh1Ri9zb0JEN28xWVNwNU4waHB6bXFHaTBudDFiYkk3YWZHcHYwb0Nn?=
 =?utf-8?B?a2krSFhoWkRLOXZHVXRnZllvZ1lGS3VLZWNNaTJ6L3loL2pYWU5yUmY4L3Qy?=
 =?utf-8?B?UHdnQjFLbk8wWW5nckV0SkJheVYvb290N2k1TW9meHRRQklybmZaem1QK09D?=
 =?utf-8?B?SmZ6aWdxSDE4bzFlclNIMHl3U1JLWXYrME1NbVBVZGlsRk4rVDgvRm1vOU9y?=
 =?utf-8?B?NjhOZVNpRnRGOTZPR25Dc2paYURTL2N5dVVQeXdFaHlYQVdPSGRCL1prdE14?=
 =?utf-8?B?dnRidHRpR1pOMTNTOWVGMUJJOXRjVG5BOWxkeCt2ZjYvVVIyYlZ1RzVCc29F?=
 =?utf-8?B?Z3A3ZlFPbnh0OTVla21RV3RleTJYcUozTXBRa2ttMzFPV3duVmlFdHBGNEhR?=
 =?utf-8?B?S2hpSmdRc2QrUHJac1hFb3VYME02MEFqbnFKOElhTDd4a1VaMTdWa1RjTVJm?=
 =?utf-8?B?dHJENE13eDV3WDM3N21Yem1rVWtmR1ZUSkMrenpoUnRZbGRZRGxXR2ltSVRT?=
 =?utf-8?B?STJ6YjcyN1RPNHN5NE05UzZjVTNXOXVpSFdjb0Fhais2dHdkeEpyY3FLOUdB?=
 =?utf-8?B?RXI4NkdRN1hVVHcvcEZKQ3RPNXF5RGxzZEpNVG80blhId1lpUkFrOTgyZDNH?=
 =?utf-8?B?K2M2MGIyOXdDS0RzR3J3NXY0S1dRaENXMjZWYVJESjdYVmduNXZkUm5PTkFo?=
 =?utf-8?B?NEhwaHVGcy8vcGV5Z3VIQjlqU0tGUmdlajlrV200MVd3OFlZUDRqemdOcnpY?=
 =?utf-8?B?Sit0YWd2MzUxNGswdnBSWDBHOXBYRjh5MitTaVdyQTBBNlRLNENvcmNLcjJP?=
 =?utf-8?B?LzZnSnFSVHViTzRUVm9FWGJ0K20rQzgzYnRTMTAvTjdpV1BDQkk3YTVxTFp0?=
 =?utf-8?B?RWptWmRudkRYM0QxeXpJVHl5THdydTFvNnQ3ckZKS2RVVEprRml4RE4rN3pq?=
 =?utf-8?B?Uy9RRWlsRGFFM3RXQ1Y0akkwYUtaeUQvNUp3Qk8xT1BVbjJnQTl0enpKNVVz?=
 =?utf-8?B?UU5FYkdRd2V0cS9nWjdnaUZSNmNscGc4R0JRbkpPYjhMVFUwckhwbGpxZUFu?=
 =?utf-8?B?Tko2Y1dCSDVXNzQ5bERwd3pEUVBsbkNoNTF2UWxjSS8zZEFCeXhvUVpYZTI1?=
 =?utf-8?B?Y3Z6b2JXUnh0aHl5cFpiZXExQWNKTzlKUGo0eEREb2dhcklxTUZHRHdBWTI0?=
 =?utf-8?B?UlNIbHM0a0ZlZmEzdzE5bEhGUTB4SkFYOTZOczVpRFhwOWtmcHBUL2dmd3Bz?=
 =?utf-8?B?aXMzY3pFMEduYXBxT3VQZmc4WFJacWd4R3cvVFhhYUE5Y3NXZktWSmhWWVZ2?=
 =?utf-8?B?Ym5IQWh2RUJIQWhpck9PSmNEZnRJUTcrQ2pTS3VKRXE3V0tXOElSaDh0dXh3?=
 =?utf-8?B?cTBZSlg3SkpqVXVoMnJoOER4ZUc0N2JHME9PL09uTUtaRDIyUWk5M1ZIcU42?=
 =?utf-8?B?VEpURUdacHJCRU5maVpuRGttbHExNlN2TTdkb1BWRE9QNVlUeWgxeUFXWjh4?=
 =?utf-8?Q?r6nMYVwmHYpj8ichVy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1ecc12-d9b8-45f0-9fcd-08df1ee95813
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:52:46.4761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4DPS43uxPJ4WjafJ+UreikyAOxE2ZE/geMwQ7VmW4b+Mdhhj00wjakdkq68WAZ3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9354

On 9/30/26 13:43, Leon Romanovsky wrote:
> On Wed, Sep 30, 2026 at 10:34:56AM +0200, Christian König wrote:
>> On 9/30/26 10:18, Leon Romanovsky wrote:
...
>>>
>>> At a minimum, exporters need to pass `p2pdma_provider`.
>>
>> No, exactly that is a no-go. The neither the framework nor the importer should see the p2pdma_provider.
>>
>> Only fully translated addresses where the DMA access should happen.
>>
>>>
>>> If I keep the “dma-buf: Let exporters hand out the P2PDMA provider behind a
>>> buffer” patch, I can move the P2P TLP types back into `p2pdma.c` and export
>>> only the function that indicates whether ATS is required.
>>>
>>> Is it ok?
>>
>> What you can do is to forward declare enum pci_p2pdma_map_type and than pass that 1 to 1 from the exporter to the importer.
> 
> Unfortunately, neither suggestion applies to RDMA NICs. They need to know,
> before mapping addresses, whether to create the memory region with ATS
> enabled.

The design principle here is that the final location and access path of the data isn't determined when the buffer is created.

The importer first need to attach before it can query such information from the exporter.
> The importer needs a way to obtain device information from the exporter so
> that it can configure itself correctly.

That won't work with DMA-buf then, the exporter is completely opaque to the importer and that is for really good reasons.

Why in the world does the importer needs to know the information from the exporter before the mapping is created?

It is the exporter who decides how data is accessed by the importer and not the other way around.

Regards,
Christian.

> 
> Thanks
