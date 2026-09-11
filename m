Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012036.outbound.protection.outlook.com [52.101.53.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB26457E7A;
	Fri, 11 Sep 2026 07:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113127; cv=fail; b=XAwihs9qnbK0dy2Bhej2tSCLRZagHrRCBVNvEpPwin2PpK7QMUwzd2vkMjb17Ve1pgda9lq1VsCYk1/H62IHAgSXm4hS0pT7e5e0oLdH/AkKYOuwcsYOsDwCp+YWaaKrchrdaWA4SEilKSfW3OyO5PlrWzBq7FgYfqcGvC3182k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113127; c=relaxed/simple;
	bh=0MC+WU+nWp7J4mqjn6M0OPVMUtm/qMSCKXW9xkJevys=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z9gRuqxnG363GYs2KbPyV5Gc7a8ER2P7eHcGQIrExOngg6a3r9HNqIfVnUJZPNTPNhMQ6SV2L3C9wV+Dcy/mq8NbCEHSnEeGRibJN5OEUj38Lv6nuEh2CJLLUflqFr/irfeNIypCmrBQeSPb3uSyU9ab+k8kmNNTClr4XSyWfNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1MS+g7mm; arc=fail smtp.client-ip=52.101.53.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1MS+g7mm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e8P+kX/naPg+xKlYg+V5PosbashBFMv2uIhS59s3ovOAd0sY6DIKjw6hfP+GN8yK8UfgRrsLPj3xcSFG2mJ9HRZU0us79j3uvDjvAFge5pgCNhvRhlVZrfpt+Lk/NTsZ9dWhB8c8smevjg8n057b6MU/3co4aqKwhr7InNPtULpl3Oj/PiYuPa1GTWq/Y/f0/ejsVtb+PXiCPyL1b/Max4wRMEnj8nWhTgeKW7whVvi6v34Abo8B7Ct+uLdDEpdqQl1NnHLCu899va5BpLpxzhzbwi67L8m/+2vHCuaz7AwSmis49+fT/BqrXrkDEk1XgNLLyCOsxJjRXGVgRh3iOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4xsf7EBCyH2cj8ZFFkA8wuthLDfQyDMumPJc3wfx3o=;
 b=Ujn11UANmzarCjrBtlOVGmg90I0ulIdlf8+ll6KLdR9Kti/6iocvdPNIN8uZySQ5++g8OEDeb7JNiZghYtuUOsAVvEj2LPpAenda2BoYk047Sx2BCeHFFheUjJArPbYuJGWy0kSmSkushOzajEpSTQdWN1BHb7YV5cL3zJ7HCymE4/jmoYMWXVsoQNxBCkW4TMZUyqa0SFSTwguMZeFoXAdh0yE80vT5zztRd2IgYFHv9tiC4zqG6VaHA/aBj12sqztK15QdCEcoTKTXXf0YFmwupujRCpoT9x85/JRra4NlQx8/qpi9AC9eNrOfNSKfEtiMVNTEYYYPOenR+MhHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4xsf7EBCyH2cj8ZFFkA8wuthLDfQyDMumPJc3wfx3o=;
 b=1MS+g7mm5XrJRi4/G4jqy8IRNv4jNzr9X1mGwV0B9MCerHIV5KGPNRx0iMkXAQWir0Gzp6MmcnqPQqfypz6F2mUJ9Y6X3VQrVj+v/Tn3yj6av9YkhJBaf/HX91LF550acJPJTPefaAYllJ1SqTTEkMLbyGoKkwuKeFFDtUOxXMw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8481.namprd12.prod.outlook.com (2603:10b6:610:157::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 07:52:01 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 07:51:55 +0000
Message-ID: <7805bb89-2c46-46f6-9f15-8dce842d5ae5@amd.com>
Date: Fri, 11 Sep 2026 09:51:48 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/18] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jens Axboe
 <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
 Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, iommu@lists.linux.dev,
 Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-rdma@vger.kernel.org, kvm@vger.kernel.org
References: <20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com>
 <20260910-fix-p2p-acs-v4-0-v5-17-856087f63c0d@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260910-fix-p2p-acs-v4-0-v5-17-856087f63c0d@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b8::9) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8481:EE_
X-MS-Office365-Filtering-Correlation-Id: c4ced7f8-639b-4d66-a7ca-08df0fd98c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|1800799024|376014|5023799004|921020|56012099006|11063799006|10067099003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Dj2bG12+Yz3d53wtUG5XGKfXmCbpe8D8VDeT5KGdgUKvutE9CClrX3gP0nRk16631aTud++kjT3awU/C0WmUQYR3fo+5DVCJFe4LmgDtZXff+ZcGRyPKvcsoSShC3GYvzUgbSBDrWTEM+vLncGb36qoC5I3I/HjbsKMQL2eG9bk/lC/rhPF/u2PaQYsp2hBgmsK9e3BtMMsnmVtgwyWgIuAvqqpA1hOLGUf6CRhnCeKPf7z8Zk6GgbPOx+3TWWxNCnnC62p59E83ThecaaHNR95CmEmzFOWFEOSeflEYJgvEQ0MPV3GO5US1GzsRxsbeVCG4IvPJWFhUcJAEpdmyHFzZHJ4kDbTFTs2FdDcGwZnGXfq72JtPwkAHPkw8r9L1X0RrAM3v4POnvBwRkkdm7XZX5xaRPLN2k1bk432WEAUxlf6wRfIZtzjj77lGiQ70H7SNCZnwgM9YG8BFN1V2WxM5yYVXcxFk+PJV/Sw2+eKmHj7cqNDXDR5Q5/DYAv6jUD2B3OB+cJdxyHSP0Vj2KQs+nkBUVqEzXRHxJZnIRQaa3q8hSFym8hbx50EWORK87dUdvbF7wLxn+1r5+3ictcBpuCzF6V1smWxnz1bKiup0w8f3gmGf3BZNClOAD/sB4+mJaZPbKj/7EY8ubRivsfWmmGlpgaLYgAmM18M93HhfEdY9anjKxXrj2N/My3Q4qNPtIGreF8QcdF9OH41ykw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(1800799024)(376014)(5023799004)(921020)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjcvSFV4eGFwK2hiZDZzaXdIR2pmR2VlRmdlNm9pSkpkVjRSUnlOeEloQ01P?=
 =?utf-8?B?Zmp1Y1FtUjZFWHNMSUFSZVQvbG1RQTZmemxCSENFRmIrU29CZjY3WEFCY2Fu?=
 =?utf-8?B?WEFySXBQV0VLemh5WVQ1OWVQMVBOTGNQT0JGVy9lZmlkQnozWlJRVlBiVE1I?=
 =?utf-8?B?cHhWeFNucnZCTHB5djdydFo2bVNTNW1Id296RzdBT1N4alBLaXBubG94VjRK?=
 =?utf-8?B?bjlEZjRxbWQ0YjNwK0F3QzVvUXVTWnZLQ000R0hENUd2M3VtYXZyNVU5MkJ5?=
 =?utf-8?B?alZTYzdhMkRNdkdhaUhjcVlock1xN1pRRE8wdW1PUmVTeW04S2dEcGFSb2tZ?=
 =?utf-8?B?UVUwWjNWREZYOXJuSG1uYWZwL2Uxa1RtdXdnaVJncDd0bGhDQzVoU0kzd1d2?=
 =?utf-8?B?K0ZPRDN3WmJTWE5jekJ5czlXanFUek04b1kyM1ZsZC9kVkNnQkFlbXc5WGt2?=
 =?utf-8?B?MW10TlFTZXMyMVZWRzcrWVVtNFdvTlgwbEswVmF2ditueFJlQ2EwRUV2Yklp?=
 =?utf-8?B?Y1M0UmRUNWhxa09WTGZaRVJvNVpuWlNxYmp3bm5vdTI4Uk9Wc0E3ZHlmbDVs?=
 =?utf-8?B?emVLNCtyUm42dEFQSTFGNDNIcDFWVlNUVG9kSE1KVU9sMkpnc3ZLUUZQZ01Y?=
 =?utf-8?B?cnJ5QWZhR3htUUFJbmJZQnFaVlZ1Q21hS210c3EzWEo2d3pRYUt1cU9JYnM4?=
 =?utf-8?B?aUhsdWhlNWNmbFVFaTZhSDQ1MlRpT0JRNW9pMzk5ZWFuOWlCSU44Nk5GeGxQ?=
 =?utf-8?B?OGFNeDducCtNb0dIc2tsVkpqWWwzaEJiSXNjMXNXaGF0SFhxT0VqaEJUK05G?=
 =?utf-8?B?ZExyMEZ4d0NhMldENFhTVElUOExiVHN0dndReVpqVDJMZnQ5YVBWc3hYWnpC?=
 =?utf-8?B?UzFLbTAwVFJobnZpOXRoZisvU0hNZ2RiTXJrSHJPaEhuaU0za2FCYXBUa1VT?=
 =?utf-8?B?TUR5T2ZRdDhMTDMweHRoNUgxY1BVbklLQm9aODJOTzdGRzJ0alR6b1dVbTJk?=
 =?utf-8?B?TlAzZjVPY2t5Tmd5c0wwM0hkQm9JSXpTRGd2MjhjT1NweUdFNjFDR1FjeEt1?=
 =?utf-8?B?U0lkdm5qVkZzcCtNci9KbloyaTlERHhHSUNFaHdFOERTME1reTNtS1ZWOUJr?=
 =?utf-8?B?bGFXMXpSaFd2U0hvcEhjdjV6R0pibUJzbU5pbFFaWDc5WmdzSzJ2U1RsLzFQ?=
 =?utf-8?B?ZkVCY2xRZUMrcU40Z0FkVDFXK056WXhYUWIxU24vaUdWY0dkZXcyU2Q1SnZM?=
 =?utf-8?B?dFAyRXRrd3lUN0N2SUNFZU85RWMwL3VidDRPK0oxMXc0eEpaOUNleWorVlFi?=
 =?utf-8?B?RXlQNFZRbXZXRXNhV21pcjFHOFU2V3N4QWl1VGU2K0FKMEF0czRxdy9IQW5M?=
 =?utf-8?B?YktSY05qQmZFeHowWEU5aUNMTC9kSnBSeFpGQldCM0hqZGdUQWlPNEhQOVBP?=
 =?utf-8?B?c1hLSllDdGdNampvOXZ4ek5OYzdRa29qbHdpQWtEUDd6UFVaQ1RJcitldUZX?=
 =?utf-8?B?RXJZOThMV3k5U3lUVXduN2JkY1VCbnYxeGYwZXFDZjhWYnJEUVpvWVArME5o?=
 =?utf-8?B?QzArU1BQd2FXeXFnUjJTL1JOWGpCV0xHRG1DV01QSE9Vb0pRRjVJdWVZaHdL?=
 =?utf-8?B?TjByRmM5MmthQ2RIQU9kQnNmZmlPRVBkbkZVVGZaMTk5bG1NanJYWmxkMTI1?=
 =?utf-8?B?SzNLbkNnU2xOQWdNOGN5bXpRejRLN0w3UDV2eFRJUlJKNkFTamFCeDUvdWlz?=
 =?utf-8?B?TUNwWFFoYWpXZU0xVXBZVHpaM3BzNlVQenFrRVJpNkdKWm9YeHN1MzZwaXdq?=
 =?utf-8?B?OWJjSjhkSGRTVG44ZmZGZ1BncVlTTnc5dXhTemNwc2s1WGxhTkJuU3JET0pE?=
 =?utf-8?B?T0UrU1hCMGR3RitQR0U1cEIvWjJxMy82cm9CSi9XT1N0VUVLWnh3VlQzYm1H?=
 =?utf-8?B?T2xhd3FxVUhiR0dERWR1aVpKKzQ0eDFDYWJaTllMZVZjaGVpamU3QjcwSHZ5?=
 =?utf-8?B?YWJFeUVKS0NxVVA5blh4RHd2R0Fua254SVlGYWh2NHdiK2VBNlJ2U3ZwNHMy?=
 =?utf-8?B?RVlJUW5OWndXRTMyTThRVXBEWUdWcUVJN2hsTU41eG5yTW1QRVF5UE1oOHhF?=
 =?utf-8?B?dk9lN2Jqb3BJYTFQRDcwUHpnOGp6K2RGNVZKNjM0QkRiTitQb2YyUUh1THhE?=
 =?utf-8?B?VkNqTEREcXl0QjhnVHhPZmpHZEU4ZTNGSW50N1BpT255WDZjYVpCbWkxUnZE?=
 =?utf-8?B?Rlpzd3BiUGMxZ0F2R2M1TnNtZFZicjlpWVNRanVHNDkybUdNQ0R3ajd2UFBS?=
 =?utf-8?Q?Y9KBBdUheuq75GdHac?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4ced7f8-639b-4d66-a7ca-08df0fd98c7b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 07:51:55.1383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F25tz68ME8GnsWHbNXtfcMji+a+CuFqY6NwOWMPBWkzOzdPj4pBP2M0UZSNbY9Zr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8481

On 9/10/26 13:32, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Exporters keep the &struct p2pdma_provider in their own private data and
> hand it to dma_buf_phys_vec_to_sgt() on every map. An importer cannot reach
> it, so it has no way to learn how its own peer-to-peer traffic would be
> routed before it programs its hardware.

Why should that be interesting to importers?

In general importers should just consome the data provided by a DMA-buf and don't participate in any way in the decision how that data is made available.
 
> Publish the provider through &struct dma_buf_export_info instead,

That is a very bad idea and not even remotely acceptable.

This needs to be a callback instead if that should really fly.

Regards,
Christian.

> and add
> dma_buf_p2pdma_map_type() for importers to query it by TLP class. It is
> fixed at export time, so dma_buf_phys_vec_to_sgt() no longer needs it as an
> argument and the two exporters no longer need a copy of it.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/dma-buf/dma-buf-mapping.c                 | 41 +++++++++++++++++++----
>  drivers/dma-buf/dma-buf.c                         |  1 +
>  drivers/infiniband/core/uverbs.h                  |  1 -
>  drivers/infiniband/core/uverbs_std_types_dmabuf.c |  7 ++--
>  drivers/vfio/pci/vfio_pci_dmabuf.c                |  8 ++---
>  include/linux/dma-buf-mapping.h                   |  4 ++-
>  include/linux/dma-buf.h                           |  5 +++
>  7 files changed, 49 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> index 794acff2546a..8b431000e906 100644
> --- a/drivers/dma-buf/dma-buf-mapping.c
> +++ b/drivers/dma-buf/dma-buf-mapping.c
> @@ -6,6 +6,32 @@
>  #include <linux/dma-buf-mapping.h>
>  #include <linux/dma-resv.h>
>  
> +/**
> + * dma_buf_p2pdma_map_type - How peer-to-peer traffic to a buffer is routed
> + * @attach:	attachment of the importer that will issue the traffic
> + * @tlp_flags:	&enum pci_p2pdma_tlp_flags describing the TLPs it will issue
> + *
> + * Reports how the PCIe fabric routes @tlp_flags traffic between the buffer
> + * behind @attach and the importer attached to it, so that an importer can
> + * choose the TLP attributes that earn it a direct route before it programs
> + * its hardware.
> + *
> + * Return: the mapping type for @tlp_flags traffic, or PCI_P2PDMA_MAP_NONE
> + * when the exporter named no &struct p2pdma_provider and nothing is known
> + * about the route.
> + */
> +enum pci_p2pdma_map_type
> +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> +			unsigned int tlp_flags)
> +{
> +	if (!attach->dmabuf->provider)
> +		return PCI_P2PDMA_MAP_NONE;
> +
> +	return pci_p2pdma_map_type_tlp(attach->dmabuf->provider, attach->dev,
> +				       tlp_flags);
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_p2pdma_map_type, "DMA_BUF");
> +
>  static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
>  					 dma_addr_t addr)
>  {
> @@ -71,7 +97,6 @@ struct dma_buf_dma {
>   * from arrays of physical vectors. This funciton is intended for MMIO memory
>   * only.
>   * @attach:	[in]	attachment whose scatterlist is to be returned
> - * @provider:	[in]	p2pdma provider
>   * @phys_vec:	[in]	array of physical vectors
>   * @nr_ranges:	[in]	number of entries in phys_vec array
>   * @size:	[in]	total size of phys_vec
> @@ -85,16 +110,17 @@ struct dma_buf_dma {
>   *
>   * A mapping must be unmapped by using dma_buf_free_sgt().
>   *
> - * NOTE: This function is intended for exporters. If direct traffic routing is
> - * mandatory exporter should call routing pci_p2pdma_map_type() before calling
> - * this function.
> + * NOTE: This function is intended for exporters, and works on MMIO memory
> + * only, so &dma_buf.provider must have been set at export time. If direct
> + * traffic routing is mandatory the exporter should call
> + * pci_p2pdma_map_type() before calling this function.
>   */
>  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
> -					 struct p2pdma_provider *provider,
>  					 struct phys_vec *phys_vec,
>  					 size_t nr_ranges, size_t size,
>  					 enum dma_data_direction dir)
>  {
> +	struct p2pdma_provider *provider;
>  	unsigned int nents, mapped_len = 0;
>  	struct dma_buf_dma *dma;
>  	struct scatterlist *sgl;
> @@ -104,10 +130,11 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
>  
>  	dma_resv_assert_held(attach->dmabuf->resv);
>  
> -	if (WARN_ON(!attach || !attach->dmabuf || !provider))
> -		/* This function is supposed to work on MMIO memory only */
> +	if (WARN_ON(!attach || !attach->dmabuf || !attach->dmabuf->provider))
>  		return ERR_PTR(-EINVAL);
>  
> +	provider = attach->dmabuf->provider;
> +
>  	dma = kzalloc_obj(*dma);
>  	if (!dma)
>  		return ERR_PTR(-ENOMEM);
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index d504c636dc29..c2b9944e9659 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -747,6 +747,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  	dmabuf->size = exp_info->size;
>  	dmabuf->exp_name = exp_info->exp_name;
>  	dmabuf->owner = exp_info->owner;
> +	dmabuf->provider = exp_info->provider;
>  	spin_lock_init(&dmabuf->name_lock);
>  	init_waitqueue_head(&dmabuf->poll);
>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
> diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
> index c64dd6b94e10..fbdac18b69ca 100644
> --- a/drivers/infiniband/core/uverbs.h
> +++ b/drivers/infiniband/core/uverbs.h
> @@ -139,7 +139,6 @@ struct ib_uverbs_dmabuf_file {
>  	struct list_head dmabufs_elm;
>  	struct rdma_user_mmap_entry *mmap_entry;
>  	struct phys_vec phys_vec;
> -	struct p2pdma_provider *provider;
>  	struct kref kref;
>  	struct completion comp;
>  	u8 revoked :1;
> diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> index 2411ebee69e2..94d3719a34da 100644
> --- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> +++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> @@ -33,9 +33,8 @@ uverbs_dmabuf_map(struct dma_buf_attachment *attachment,
>  	if (priv->revoked)
>  		return ERR_PTR(-ENODEV);
>  
> -	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
> -				      &priv->phys_vec, 1, priv->phys_vec.len,
> -				      dir);
> +	ret = dma_buf_phys_vec_to_sgt(attachment, &priv->phys_vec, 1,
> +				      priv->phys_vec.len, dir);
>  	if (IS_ERR(ret))
>  		return ret;
>  
> @@ -108,7 +107,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
>  		return -EINVAL;
>  
>  	ret = ib_dev->ops.mmap_get_pfns(mmap_entry, &uverbs_dmabuf->phys_vec,
> -					&uverbs_dmabuf->provider);
> +					&exp_info.provider);
>  	if (ret)
>  		goto err;
>  
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> index c16f460c01d6..10f47992e7f5 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> @@ -15,7 +15,6 @@ struct vfio_pci_dma_buf {
>  	struct list_head dmabufs_elm;
>  	size_t size;
>  	struct phys_vec *phys_vec;
> -	struct p2pdma_provider *provider;
>  	u32 nr_ranges;
>  	struct kref kref;
>  	struct completion comp;
> @@ -59,9 +58,8 @@ vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
>  	if (priv->revoked)
>  		return ERR_PTR(-ENODEV);
>  
> -	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
> -				      priv->phys_vec, priv->nr_ranges,
> -				      priv->size, dir);
> +	ret = dma_buf_phys_vec_to_sgt(attachment, priv->phys_vec,
> +				      priv->nr_ranges, priv->size, dir);
>  	if (IS_ERR(ret))
>  		return ret;
>  
> @@ -274,7 +272,7 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
>  	priv->vdev = vdev;
>  	priv->nr_ranges = get_dma_buf.nr_ranges;
>  	priv->size = length;
> -	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &priv->provider,
> +	ret = vdev->pci_ops->get_dmabuf_phys(vdev, &exp_info.provider,
>  					     get_dma_buf.region_index,
>  					     priv->phys_vec, dma_ranges,
>  					     priv->nr_ranges);
> diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
> index 09bde3f748e4..d63ac4d52aa5 100644
> --- a/include/linux/dma-buf-mapping.h
> +++ b/include/linux/dma-buf-mapping.h
> @@ -7,8 +7,10 @@
>  #define __DMA_BUF_MAPPING_H__
>  #include <linux/dma-buf.h>
>  
> +enum pci_p2pdma_map_type
> +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> +			unsigned int tlp_flags);
>  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
> -					 struct p2pdma_provider *provider,
>  					 struct phys_vec *phys_vec,
>  					 size_t nr_ranges, size_t size,
>  					 enum dma_data_direction dir);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d1203da56fc5..81c136fcee6e 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -368,6 +368,9 @@ struct dma_buf {
>  	/** @priv: exporter specific private data for this buffer object. */
>  	void *priv;
>  
> +	/** @provider: The peer-to-peer provider backing this buffer. */
> +	struct p2pdma_provider *provider;
> +
>  	/**
>  	 * @resv:
>  	 *
> @@ -501,6 +504,7 @@ struct dma_buf_attachment {
>   * @flags:	mode flags for the file
>   * @resv:	reservation-object, NULL to allocate default one
>   * @priv:	Attach private data of allocator to this buffer
> + * @provider:	Peer-to-peer provider backing the buffer
>   *
>   * This structure holds the information required to export the buffer. Used
>   * with dma_buf_export() only.
> @@ -512,6 +516,7 @@ struct dma_buf_export_info {
>  	size_t size;
>  	int flags;
>  	struct dma_resv *resv;
> +	struct p2pdma_provider *provider;
>  	void *priv;
>  };
>  
> 

