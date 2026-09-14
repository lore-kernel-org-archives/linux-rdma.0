Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010020.outbound.protection.outlook.com [52.101.46.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145E03E0C5C;
	Mon, 14 Sep 2026 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396034; cv=fail; b=q0OR7Wtd4brZugYUkS6htW2x7M382FKW7bij8tJQ/8JtC2NSapJNWztlNXSuPLe/6ihb1W0Yx4e64wiY/OcRpc4AcASFopISTLT4o6m9CfQcKOza3nV53SJ07BvOvTFyqJcXOoueIIEqmFNRRQj5t3un4593m25NXtAYTPp6h3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396034; c=relaxed/simple;
	bh=TWQ2feNja6wOTztd1ksvCavZFvEg8mGEMMyywTjmSyE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=flcMLM2MGMaaYC1OK0SPhy7K+HmY5TvRbnYc2BHBD9BJE2n7P7OSCQVCazMGwxVnQnIeCmQxS+FOSPR7DjUja1vBQFNM3n+i0XQY+q84Sa5nvwpIhrY6gh0OlJfVBipJmhnUqt7IKUDjtWV8G4ekf28s1WTBa6U3KaTmXy8/tqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sTlp/X+a; arc=fail smtp.client-ip=52.101.46.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sTlp/X+a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fjhzNVLrvmSAcTX5ZftRhRb26tjBOIzbiHpp+fK+a94TVptNTzzRX+H0/7XxbYemipiBvusTT0r/Cz0BHfX2CUtLidHr0fVwWUVKDdGf9M4eJdX5ZaPFc9POsABN/E3yG6nT8oH5iYyH1TEccxpnNuew9g9x6Yp5d+cTJMDNyuKeCEXqtMJkxhcHEx0TRXptHO/AwfrRlvge9Pm6R163PyOBV5MF53n2EeuskmuENYiZV8m4AGVCRN5zNfKCcNCFCKNNvaLV6y2mLoNZbzN+onTmCow7roDj3c0qwSzEaElRsdJlPqysjc3iLUZYDFRCWQ/wydeGiiARL8jqJp7p8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Dql893JRWlhROYV0BvfSIJ2xw0z+unPgSLAVRC0fuw=;
 b=Q5roa+Y0D73Qyq3Lze2fpG8uorWMcikhF3WSXr8ydMLc07XyMPfGwgI2wBilOJGHnz4cCQJfo93LokA0VYLVgEqswwKLHvCFzP5h24MNsRd4FgnKzdP9YSDB+8pbYKi/AabaUTbGty3Twm4m1aZZ3wIQ2GRcL83M/HPFA75pL+v5C9FkhvSYuRwx8bPy5gMgFTxD8p0isu/d4Wfc75i2beB38ivq6Ea2qhQcXqf8Rt+y69tF2XRHnTBLi4Z/ttx0264jgDCAHnCv63smMvnzk6iSuE6s0tuZs/SoEc+Z02B2fYBzWCrGDFRa81BC45YEE1VddI5yKsZqnGxnOjgj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Dql893JRWlhROYV0BvfSIJ2xw0z+unPgSLAVRC0fuw=;
 b=sTlp/X+adYt1ntxUXlyF5+I12YQMkL2bAlG8Wgng3CEcqOzhnwhhNVoLXDIZXgVigHz2LVXuposMGByim+8GAOT+ikPWl7UGM9DeH8luCjLwbKhBJWsI35TbxT+tP2cTi3ZbX5CaBTWVtF3mHzDwNlWH1NEedVJtvcAAdrYwUS8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 14:27:08 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0406.005; Mon, 14 Sep 2026
 14:27:08 +0000
Message-ID: <d3fb7ea0-019f-4311-bf0f-00d25bdebda0@amd.com>
Date: Mon, 14 Sep 2026 16:27:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/18] dma-buf: Let importers ask how peer-to-peer
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
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
 <20260914-fix-p2p-acs-v4-0-v6-17-5ef07ec9ef06@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-17-5ef07ec9ef06@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:208:32a::7) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA0PR12MB4349:EE_
X-MS-Office365-Filtering-Correlation-Id: dcffc161-2a03-4621-2d6a-08df126c41ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|4143699003|6133799003|10067099003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DwAjwAr87okZYfDGFWllejVVlBzvbvTHy+41dzVYbOOcwU1bVvSsuW60+xtrYd0yAZrdo5a4aLfl+x8teEtxrPmRsIbVtiqll5t3dFnn9PjReQQyAiU6BdZJRH035VTaDUL0h2pdud1hvtfPRHrEuJtzTsysCiH7DM7cTuAb4GBEUrN7hE2HZwICr/Z+qc0OGpUIuChZShAjkO/GWz7/QKfR6hWJC7JnUmoQO49VgxjnZsro/SMYuZW7yraxHLcyzatc/ntNONhH/owo77NrRK6GVn8iCsVhon+g5erX0jYtyLmEPihxsk/reA4gbi1yHzfyRE4PcZyN1O2vOFQn593pzz3f6uUGO9ckkdS/Z/glPWve+KZqdzeuwIYgauL3Ca32w4xN2YEDbUP/52rNGbbwLgJa7Of2X861msT+e/OtVbYKcuYj+8WgPj1zczNzlWIPYg+E2LvYqMB0vZ+9VbBLqOQGAJBEnez9Wp4spFalq+aKZEezGuVeMxP4VtoM2HcyAfOfFTwN/k9NHClVvzyXdUJmPrp6j6MMROPX4gg+g6nXf7x6hfc7+DPA15KA8KMxBEecAAogwfGTvz9gqmJBpvmQus+I5q7qHGZMYyH2T/78DsnGp4hULK/uDJ5VUg/e3ncx63Oudv5MRPvSthivelPo+Xk3AePrLsbgXkrXVcWNjCkHWsukSYP0GYv1ivoX9D5qZeYrzy6AlOYtIA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(4143699003)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3FhSjB2bVdFb2srOVlzdGxXSnd4STYzdDJHTm54VlV4ZEVWT3cyaEx4c2w4?=
 =?utf-8?B?b0hYSmsvREtVUEtuZWNpRGRVVjk1ZGNBc1B5RnRhOWlBbWwyK0ZsYnZFYTBI?=
 =?utf-8?B?SVh4VmxHR1FRclFhSmhmWXY4Zi9CNjdJNE1DdlVybVZBcXVka0pOWmdaYWl1?=
 =?utf-8?B?c0N4aTQ0SFFPcS90OU9IdDZoa1FCMnQ0OG1EWXJEUU5OU2VoUXVteG5La0pO?=
 =?utf-8?B?M2doeS9FTzRjalppTldoWGk5VTdQa0tGdTBiV1JIQTBENDI2emNiUUw1dGNW?=
 =?utf-8?B?TVFkQzRUNnpCcmdmNC9QTkdkMXFuZm5yTk1QbDFpWWVrakhRU0lud2lPb09S?=
 =?utf-8?B?ZDAzVkNNbWdHc3R4WUl3c3BxWTVwTmFOOW1KVWVSM2VoY1RxbjRyTm9OeTJk?=
 =?utf-8?B?eGszTzcrYjJDc1FYejdWYVQ1WEJseGRPS1hNcWloYlZkWngzbG8zRWh5OWg5?=
 =?utf-8?B?cVNUSWNJTElzem1xcktSWXZEN2dFUmwrbVpvc25CWkY2NE5VTm9icCtNWDdn?=
 =?utf-8?B?OVJpeHVmYXlYZVBjQTkreFNGNjFHV0VmU2lCOElQSE10ZGtocmRPR1FiMkNl?=
 =?utf-8?B?NnIxaHdwWWxrSUNhZTdzdEZab0ZLaHRhMDdpR1dYR08zZzJtNFQ2cDRoVE1h?=
 =?utf-8?B?TTNET2JxM0d6T29aNTR2M3V0eXBmcS9hQmp4VU9rcko2VDQveFpNVHpzU3Js?=
 =?utf-8?B?eis0WERJV0ljTitnaUhtRTZXeWtEMC9NM0NLZ3ZDUGl4bU1ZU0pQQ0VvNWZo?=
 =?utf-8?B?SFAzMTJrZnBwK2h3K0xhYVJLQ1laMm1JQUtLdHY3bHlpVXdZdC81MHZ3M0VV?=
 =?utf-8?B?dWtuc0RSSzd5aWJjQkYwTTVCMHBRSmZCeUthbVRMUTZsRFZhSDVHVEhDZU1J?=
 =?utf-8?B?MkJQQng3cVNYSVdKalNUR09xbG5Oc3NjV3hOQ0Z2eUw0cStxRVpWYUFjUVZj?=
 =?utf-8?B?MUJ1WUtwMDJwL3Z4aUJ6NlVFbFlFaDlZclF4bks4YmwvYzUzU1BUM1NPbTF6?=
 =?utf-8?B?azBpUjZUclYwODlIaHZlcTZneHB3RjRWbDBNQXgzUUxhdFBxWW0zNG5HMmpy?=
 =?utf-8?B?K2pvelhmUUtIM2thUFdWYnJiMXhJVWMwTzZad3Z2eTJReHg2QVRVcGJ4bWhP?=
 =?utf-8?B?VUZ2OVpQV3hjMzRTNGphUkxaNTNqa21pYnBYam1XYU5SOVJYVzhMQ3JWZTYy?=
 =?utf-8?B?S0xmakU4Y3FpV1gwSlhLSU5obkZ5dzFLdzFkUDJIV1VKdGtyZVZkVFVyWE1H?=
 =?utf-8?B?U1RsMm9vd1NTT1lMek1DQ2tyOS9vcmRBMXdEZzZCbEMwTEdrU0YxZjVxSHhL?=
 =?utf-8?B?YTd5eWgyVWlpbkJhS0t6aEJER1ZUdnRheGJkbDZNTlMydjFPc1BBOEUycXNZ?=
 =?utf-8?B?YXlRUEw5RkdIczBQTC81bW83SmcrbFVITkJsdUFHUFlLOVZOcjI4RDhUbVE0?=
 =?utf-8?B?aG1ITmNIYzd4NXRpVXVXdVpBbFNQNjZnbitNMnM2bERKd1ZIRGFPcGVzVlBJ?=
 =?utf-8?B?dEM2MmtYai9mY2JJNzNZUytvMng3eStuZTlGY2VVakFnOUxGU29qb0dEd0Nv?=
 =?utf-8?B?dHJjR1JLUzkwL1BncEpCT21qbUNMbUIzV2V4VGVOM0U5STBNVjN4UFJrZnAw?=
 =?utf-8?B?Q0diNmdueDRBMEVCNElhTVo4TU90NGpjRzVLMXN4OVNrajJncW9vT1Y0OUxR?=
 =?utf-8?B?NjV5VEt1K2w0aHg5Zk1FdVF2OThOTlB0OUJkc2x6cjUvQ0VGRUpxejdVN3RH?=
 =?utf-8?B?U051VVFYSnJRVFRkMEcrQk5mRVorMDlGT1BTZmZJa09mdTViL0RKZXdBR01V?=
 =?utf-8?B?bWVaeU8zcnlLZStyQmlFbFhQM2lnWVV3dmJWZWhRUVV1NkxST25VaFdqamR4?=
 =?utf-8?B?WjY5cGRKc3BHUmdBdTRKQ2duTzVTNnZiMTF2SG1LUEVHcTdDWGpQeGVzcnE0?=
 =?utf-8?B?bnFIQUJZZ0t6SU1Uazg2bFFQVWFaOGlMRXNnS2p2OUw2d1YrbFptQ0xQZDF6?=
 =?utf-8?B?akFTai9DVURYQjAvYUxvdk5ud3JNQk9NbXJJRXFZS1NzNG9wUjlLSTZLRFkz?=
 =?utf-8?B?T2Y0WE5iQ0x6OVk2SkppNUlHRjY0VnNjRVJsV0JRU2RJaVlnZkd4ajVIRWVj?=
 =?utf-8?B?VUdubXRrKys4ZkdBSUlrWlhTNDU5bVQ2cHQ3aHFVa2x1K1NDK1hLaEE2NFQ1?=
 =?utf-8?B?djhqdkcwOHF2dHh4VXEzYUZiUWpjRDFLQmVLeldUU1A0RjdYcFFlQWNvbGtD?=
 =?utf-8?B?ZkpGRExHWkhRMjA0RTZNRVowR05oRWpCLzRyQ2J5dGJacWRhZVZ4bE05YWt4?=
 =?utf-8?Q?MuftXWeeS1b0jZoJsA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcffc161-2a03-4621-2d6a-08df126c41ae
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 14:27:07.9161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Kn8umPTtNqmFVW7oPMfi3R1jasEzJWvv/pBJlhaP/Fup7pyq3zg+HOTVvpbWNVH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349

On 9/14/26 13:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Exporters keep the &struct p2pdma_provider backing a buffer in their own
> private data. An importer cannot reach it, so it has no way to learn how
> its own peer-to-peer traffic would be routed before it programs its
> hardware.
> 
> Add an optional @p2pdma_provider callback for an exporter to hand that
> provider out, and dma_buf_p2pdma_map_type() for an importer to ask by TLP
> class. Exporters keep the provider where it already lives, so this adds an
> operation rather than changing any existing signature or structure.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/dma-buf/dma-buf-mapping.c                 | 32 +++++++++++++++++++++++
>  drivers/infiniband/core/uverbs_std_types_dmabuf.c | 12 +++++++++
>  drivers/vfio/pci/vfio_pci_dmabuf.c                | 12 +++++++++
>  include/linux/dma-buf-mapping.h                   |  3 +++
>  include/linux/dma-buf.h                           | 17 ++++++++++++
>  5 files changed, 76 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> index 794acff2546a..fb03a698b381 100644
> --- a/drivers/dma-buf/dma-buf-mapping.c
> +++ b/drivers/dma-buf/dma-buf-mapping.c
> @@ -6,6 +6,38 @@
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
> + * when the exporter names no &struct p2pdma_provider and nothing is known
> + * about the route.
> + */
> +enum pci_p2pdma_map_type
> +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> +			unsigned int tlp_flags)
> +{
> +	struct dma_buf *dmabuf = attach->dmabuf;
> +	struct p2pdma_provider *provider;
> +
> +	if (!dmabuf->ops->p2pdma_provider)
> +		return PCI_P2PDMA_MAP_NONE;
> +
> +	provider = dmabuf->ops->p2pdma_provider(dmabuf);
> +	if (!provider)
> +		return PCI_P2PDMA_MAP_NONE;
> +
> +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);

Calling PCI subsystem functions from dma-buf is a hard NO-GO.

Then wrappers for DMA-buf backend functions should be in dma-buf.c and not here.

I shouldn't have allowed the mapping functions to be added to DMA-buf in the first place, all of this belongs either into the DMA layer or the exporter.

We should probably have a single callback the exporter provides to fill in a structure with PCI specific information for a mapping.


> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_p2pdma_map_type, "DMA_BUF");
> +
>  static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
>  					 dma_addr_t addr)
>  {
> diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> index 2411ebee69e2..5a6a1ee430a7 100644
> --- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> +++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
> @@ -76,6 +76,17 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
>  	uverbs_uobject_release(&priv->uobj);
>  }
>  
> +static struct p2pdma_provider *
> +uverbs_dmabuf_provider(struct dma_buf *dmabuf)
> +{
> +	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
> +
> +	if (priv->revoked)
> +		return NULL;
> +
> +	return priv->provider;
> +}
> +
>  static const struct dma_buf_ops uverbs_dmabuf_ops = {
>  	.attach = uverbs_dmabuf_attach,
>  	.map_dma_buf = uverbs_dmabuf_map,
> @@ -83,6 +94,7 @@ static const struct dma_buf_ops uverbs_dmabuf_ops = {
>  	.pin = uverbs_dmabuf_pin,
>  	.unpin = uverbs_dmabuf_unpin,
>  	.release = uverbs_dmabuf_release,
> +	.p2pdma_provider = uverbs_dmabuf_provider,
>  };
>  
>  static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> index c16f460c01d6..fcf392cfc3c5 100644
> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> @@ -99,11 +99,23 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
>  	kfree(priv);
>  }
>  
> +static struct p2pdma_provider *
> +vfio_pci_dma_buf_provider(struct dma_buf *dmabuf)
> +{
> +	struct vfio_pci_dma_buf *priv = dmabuf->priv;
> +
> +	if (priv->revoked)
> +		return NULL;
> +
> +	return priv->provider;
> +}
> +
>  static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
>  	.attach = vfio_pci_dma_buf_attach,
>  	.map_dma_buf = vfio_pci_dma_buf_map,
>  	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
>  	.release = vfio_pci_dma_buf_release,
> +	.p2pdma_provider = vfio_pci_dma_buf_provider,

Please split up the patch into the actual DMA-buf changes, exporter changes and importer changes.

Regards,
Christian.

>  };
>  
>  /*
> diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
> index 09bde3f748e4..37b3da10b17a 100644
> --- a/include/linux/dma-buf-mapping.h
> +++ b/include/linux/dma-buf-mapping.h
> @@ -7,6 +7,9 @@
>  #define __DMA_BUF_MAPPING_H__
>  #include <linux/dma-buf.h>
>  
> +enum pci_p2pdma_map_type
> +dma_buf_p2pdma_map_type(struct dma_buf_attachment *attach,
> +			unsigned int tlp_flags);
>  struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
>  					 struct p2pdma_provider *provider,
>  					 struct phys_vec *phys_vec,
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index d1203da56fc5..cff1ee0838f0 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -186,6 +186,23 @@ struct dma_buf_ops {
>  	 * if the call would block.
>  	 */
>  
> +	/**
> +	 * @p2pdma_provider:
> +	 *
> +	 * Returns the &struct p2pdma_provider backing this buffer, so that an
> +	 * importer can ask how its peer-to-peer traffic would be routed before
> +	 * it programs its hardware. Importers reach this through
> +	 * dma_buf_p2pdma_map_type() rather than calling it directly.
> +	 *
> +	 * Exporters of MMIO memory that is reachable peer-to-peer should
> +	 * implement this. This callback is optional.
> +	 *
> +	 * Returns:
> +	 *
> +	 * The provider backing the buffer.
> +	 */
> +	struct p2pdma_provider *(*p2pdma_provider)(struct dma_buf *dmabuf);
> +
>  	/**
>  	 * @release:
>  	 *
> 

