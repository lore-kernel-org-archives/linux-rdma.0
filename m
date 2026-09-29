Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010031.outbound.protection.outlook.com [52.101.56.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF99A3CFF6F;
	Tue, 29 Sep 2026 09:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790674457; cv=fail; b=M3qX5UwBI91cwfAwKtBxwiKiOT88TeAZIu0eN+OYyJ6EwDV+0M09eMoXPStoknCg4+4RF2Wp/In9uSJ3jMAZSfXbkTpbCtBatwn0A3sXL8KW1BfGWf//BmPKJYnmPgkXAMulEdojI7bs/kPX3FEdpiSk5R8QMEEc18lH/Um4riI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790674457; c=relaxed/simple;
	bh=FxzTS7zYLKZHud2dE+/d8d2tBibJBowEh+0iolJa2V4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nkx22/cScAUfLxr1i5QxBw3rNCZ3A7pdWIDyDrVYUcijvReotKrhdQUb1caw7VqBI/BajQeljNIm9DFFyNa1KDbaji8q7bbCPZCZFz1Z6m5im5jP3mR5n69N4pkzZw2+8uhYwGuPC3PoZ/nmSc0OrGKLzR4cLl/aw0OmQh+MNF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n8UNefGK; arc=fail smtp.client-ip=52.101.56.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n8UNefGK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uOtiRmTnKgBw7qLcZVP6Ql+DeKZ29ek78juXbdTsvTXxp80Utz/MBxvDQIvd9aPPiQkEqubXUeudrwzHduoY6kj77rPc0A/pbNU3nNI7i72D3kkUYSvwkE4wkaBlUAxYEV/nomO0AlG9Wva6ikRt6G9G0DHqk7uYi+t41+So1iLwxaYLFhjCXBhjhMzvEzF8oT5UXIy5wUcUZtXbIpD9619rtT8n3H6Y9ExBay5rEk64xr4niavHewytSocEYzdth9Vv69ls6sy7WF9agcwEyNXSOhIfT+mlzfgsbLLIh/p16usJMhTepbNf2VOSobIu37yrAw6VPg35VJkiWbqHYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgiE4v+ES9hU7TNohJ4+cvHed5bu5p/LR+bfNDswaYg=;
 b=gSnJyfi0D40TLHriqloRvgbbeJEq8Xgty/VigPWGq1Iz9bBWnxcV4sxSLi/kUKVynGs3tDbdilPfPwYDdVGMlluE05rSeAZZy/iTpXYgseNS2XLJ5DERZbtKiM+teJd+xb/NQAX5H4qoBwloEE1ZT9lCATxTEMG/QFTS1M4Rjx3oPAqsCElw2O9s/Rlsqafa9AHx7UKbhMrBxhtXQ3VP7pKCPs7Nzuu4DXZOUMPubDOCQpVGJANBn/2+h9Yo0OnNyIyRQjqgFJM1Fz100B7NcsiTQIUui7U1WesXod9kKv3B05+avyc33LJTEqyDpEkIzLuuGt7YkjKl8SYfwUUubA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgiE4v+ES9hU7TNohJ4+cvHed5bu5p/LR+bfNDswaYg=;
 b=n8UNefGKm6nmPgGvHyA1f0DshXH9e64bISjbFB99KEQ3HaSzUASdzm+9wgZelZ+bCwwt18/MCLQLlEG0QIa7jeKgoa1rrVC9TiN9KTOpoExuI2F69uH9W3iEryFl2x+lVWOqL59V5VjVmJZSm6OiUl0futfeURWl25Qtm+/gl6s=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA3PR12MB342319.namprd12.prod.outlook.com (2603:10b6:806:594::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 09:34:13 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 09:34:13 +0000
Message-ID: <607e8903-a979-4d78-bf08-447321c03119@amd.com>
Date: Tue, 29 Sep 2026 11:34:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/23] dma-buf: Let importers ask how peer-to-peer
 traffic is routed
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
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
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-16-404453b9c435@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0405.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::11) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA3PR12MB342319:EE_
X-MS-Office365-Filtering-Correlation-Id: e096fc85-bcef-4cfe-e70f-08df1e0cd25a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|10067099003|11063799006|56012099006|5023799004|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pEXa4dzaOAEdQGPBWnWyGWj8IaHW4orK+9nUfTJV7Wv/wCP6DDwzzCdKsR0yIObg8XaxC/qB3PGru797sjaPopDcBU5DErjABfLCv+r4NCRTKlHQBRym4zw+kBLS93fWLAcx6r3CGgbsQefSSjkZE6dwKlmuH7YXZhejFwpogvCyW1Gku0DqTr5XqMOjRuIYOC6lznwx3yrf2W4JWjFhdg8jRS1RupE63oSV4yZMB5a2HVih1FQMsIFevu/5jeLoDmM8lb4aGW6JRpnvTyLsAiKfa2idf0yecjDQU5xs0VQl4DeESkB4AUuJwsvWKJCzRk7YloxPnSa4Hl5/P9nLxSkLcRlaCNxaFKkhGx9UO7y4kRDlEES1MXtXwFLmpM3Uyitphfglmv4E+9rMUBOSqi3Oxb8/fTXNzCUuvcl0UwljK1pAoGuLdEXVXe/Ue9uHRAROjAqQgEgZdoPNcBw73jTyU07VvL2Rd3H0+JSNaXkq8K0g3yjPmyVVWpRZPVectasBFHNlarcTux1B33dLO0M6OObafUVl8oGHwnqsBKJeiQ32aM79FQ5EUYvY+u8d23v/gsob6DNpWtr4bk4LandVbB+uVVtY2ImsRqVHpP27JLCBtADR2rX4nCPyuCTjzHt1S9HP+9aIfYd8pXJCozSmmFCy339mS9kgwNdNdYs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(11063799006)(56012099006)(5023799004)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVAycjZWdWdoajdCc0ZOYzBFbHVPR1JoM25yWWZadGVXdW1nczBudnVvdmdI?=
 =?utf-8?B?MkhCa243SFRSUEx5eVQwK1V2OFBYcGJleUNKWmFBN2VUVW1jUXNSZ2J3NGJV?=
 =?utf-8?B?VVNFVUJFQnh3YmpiVnprNGFESjQxa1NaMUlnQVZSaTlNNlhsOENvalRRYit0?=
 =?utf-8?B?S1Q0cWZMWG1qNTM0MFRIajZXMzJsV3pqeWFlY1ZONFFKY2kveFh6MFc1NnZS?=
 =?utf-8?B?YlgvYmt6RGRmMGEyWkJnTFp2Z043ek00blArSjg3c0owelFwc09FRzdsek1t?=
 =?utf-8?B?WngvY3JjaFd0blp1TVdkR2wyNWVOTGM0cHpuKzJHUnVHMEJ4S0FLZ1Zrd1Zp?=
 =?utf-8?B?ZFMrbUVpTTZDRUQ1VUsrTkVLaWp4Mmt0YTdTTml5YmZpYzVxZDRpOVA1M2RB?=
 =?utf-8?B?UGk1a2RvdVVPKzVRdEpNM0pBUGRtc2RYQUlqemlhV09YR1V6VkVmdVJBYWVv?=
 =?utf-8?B?RElqcWNiNlF3U1FtdkFSNWE4NklvQlRhbURCQkNINy9BU2JNc0UveVlDdXVP?=
 =?utf-8?B?NHFwb1RuRUp4RlozcUFWMHRTMi9tSmFXY29oTDR3eWpQcUNMekFzdUF0NGN1?=
 =?utf-8?B?czRBdjdSYmxJdTBKQzVBSjZQUVlnZkNoRVJDa0x0TGxjOVZYMk9IMVlKaGNs?=
 =?utf-8?B?NEd3UmpGQjc0VUdsK1F2R2o1eWpSc2JuaWJLbG93bUo4US9xQkRvYnhvdGJX?=
 =?utf-8?B?Z0RaUkRpN25VdTZEdDR4WVlrM1Q5S0daTndSeGhZbkh3VmtUaWo4TEkvQUJl?=
 =?utf-8?B?MWcyZjFmTVVVVUVmaXhrdGVEc1EwWHEzWmtsZDdoVmltamFqVk9wMW5qOFZW?=
 =?utf-8?B?VFdIOHIxaFFvNlZzeFdnQmxleW81ZjJoRW1iRmUxNGFBQytIZzV2S2I3Q1li?=
 =?utf-8?B?ZlBRdkg3Nmh3dG13T0F1Y1VlcUVrSE9KVk1xUm9Ic0I5bVB6WnZjb080V2lR?=
 =?utf-8?B?eXRKcEIvang3MHFnS3I4STVSbWtjaThhT3pLOXJuOW9Yam8vT3V4L01VREZj?=
 =?utf-8?B?L3NMeWtIbG8vNXN4YkkyWHlVYzVSMy93eGc3Q2hKeFNVUU4vL0FKdDRlZUhX?=
 =?utf-8?B?alBJN2llNGpGUEswOW5QajFSeDZOcXBacjkxdnp0TFp5OUpaclRDdmtqeVls?=
 =?utf-8?B?M0cwcnp5dmhKT2REZFRYZmtCL0FVa0E4Ui9xanRJSVdRS2lYQ3puQXhCVmth?=
 =?utf-8?B?QU8rNThJNUdmSnZHeDdQdVVwQlFHWFNDUnIxQks3WDNMNExLakxydUMwMEdB?=
 =?utf-8?B?c3FwQmdhSXlzeGFIc01SMG5UT2JIaFlWUUNVcHlnWkRPNTV4Rm1xeHozM1E5?=
 =?utf-8?B?cVQzd1h5L0FMMStUOXhrR1BidFNBVjV0cnFRdGdDTElSZmpBZGNBQzV0R3VZ?=
 =?utf-8?B?T0J5UVdETW9wQUlCeXZpY2JVMS9KNWNxdkQzcDBLdExJdlFRQzcvS0pBaEdt?=
 =?utf-8?B?VFErSVhoRXpMUDI4YXJ4UlplRUVLNkpqYUREcmFyeUU4eTFCams4bGd1cXJ0?=
 =?utf-8?B?aGRCQTMzeWVjSXc3Y0t5eDE5QWIwQmcyRWFxT1NtbDRiRUxYV1A5V1dPbGhq?=
 =?utf-8?B?d1I4eGZhMGRCbkFNQnhSM1FrTmd3TC93Q04zTE1VbzJiWmpTYlJLd25zV1Nx?=
 =?utf-8?B?QWgwN2pkc0dQNnlXWVFNYmdFa0syUXVPb1pJc2ZWaWtkMGl5WTFlTzgxN1Ro?=
 =?utf-8?B?Z2cxZ0MwWDF3Z3g4bkpnTFFUemxJeGdiOWJJeUorWUJIUS9nMTM4REwwSWph?=
 =?utf-8?B?eEM4U3pPTEI0YjVJNVRwV3JzOFVyUW0zaXh4TFFjRjB5dnNzTFJxZlZmcTlq?=
 =?utf-8?B?a3RMMk1FWEhUWml5WS9JMllXMDVsajdGdXZTZDZiN3laSWFRdFdsaWMwcXow?=
 =?utf-8?B?Qm8yK2ZBWWJqSUV4M0lFUksxUXUzOTh2WXVWZHVTdW5yUnVPRTdMYzFtOFly?=
 =?utf-8?B?YXdBVVdETmJLclhSa2VrVUwzOGJuUHlzOUZ5OWN5S3RRcEk3RC9ETlN3dGlQ?=
 =?utf-8?B?THJZS0FNQTNqRXpnLzBEVjZjWlIyQUpYNi9idWFyYnAxM0ExK2FOQ0gzb3lL?=
 =?utf-8?B?eUJnRjQ3ZGk0ZVR3OFB0RHUvbzFHMEM4TG5mTlhYOENaNW9GOFMrM1RrYzcr?=
 =?utf-8?B?Z2tFNlVHM2Yxek0veHpuRXZDZWFhUWE5SURldzVFNVFQVzdxTmdTanY5TW9w?=
 =?utf-8?B?dGlxNEdZeVc4VkZ4Q2NUK0Z4ZUxLb3JmbHEwazE2NWsxd1RVbmxaNzU2WFY5?=
 =?utf-8?B?djc3L05NYWlHSlhsZE80cTJwNi9uVHdBcTJ5cmpZOVVrOG1jOVNOaVBWQ0Fo?=
 =?utf-8?Q?+Hm8PX1WDwoKIs710u?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e096fc85-bcef-4cfe-e70f-08df1e0cd25a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 09:34:13.0509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YwLZpdwY6Bnma6PogxhU0/bjnXebor00cj+IhHXEeja1ew2NAaHu5ltojfTIiP7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB342319

On 9/28/26 13:19, Leon Romanovsky wrote:
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
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/dma-buf/dma-buf-mapping.c | 39 +++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf-mapping.h   |  3 +++
>  include/linux/dma-buf.h           | 19 +++++++++++++++++++
>  3 files changed, 61 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
> index 794acff2546a..41702045f803 100644
> --- a/drivers/dma-buf/dma-buf-mapping.c
> +++ b/drivers/dma-buf/dma-buf-mapping.c
> @@ -6,6 +6,45 @@
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
> + * The caller must hold the reservation lock. The provider is owned by the
> + * exporter's driver binding, and exporters revoke under that lock before
> + * letting an unbind proceed, so dropping it any earlier would leave this
> + * racing a teardown that frees the provider.
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
> +	dma_resv_assert_held(dmabuf->resv);
> +
> +	if (!dmabuf->ops->p2pdma_provider)
> +		return PCI_P2PDMA_MAP_NONE;
> +
> +	provider = dmabuf->ops->p2pdma_provider(dmabuf);
> +	if (!provider)
> +		return PCI_P2PDMA_MAP_NONE;
> +


> +	return pci_p2pdma_map_type_tlp(provider, attach->dev, tlp_flags);

This function call here *must* be in the exporter and not the DMA-buf framework.

So clear NAK to putting that here.

Regards,
Christian.

> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_p2pdma_map_type, "DMA_BUF");
> +
>  static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
>  					 dma_addr_t addr)
>  {
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
> index d1203da56fc5..d56a48d41215 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -186,6 +186,25 @@ struct dma_buf_ops {
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
> +	 * implement this. Called with the &dma_buf.resv reservation lock held,
> +	 * which is what lets an exporter refuse once it has revoked the buffer
> +	 * and started tearing the provider down. This callback is optional.
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

