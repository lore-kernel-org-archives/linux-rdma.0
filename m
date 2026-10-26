Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993004;
	b=1h7lhPqyC1N0cVXhWCSwnt9YoHu406HQDRv/nrWN1ooLwTnG0tTEI57jmF2IJ3WAeQNx
	 Na/Isbma7V1VhH7akZR4/Mge8/0MQMOUw/4HUVDFvWkIcVtr4W9O2ypDfYRDVkOI7TdDO
	 yUxCwQ/Yw9K3vvFttS4NAkPe2QjgTgpkiQO5/obLISBOgfSXi63u1f7yD5zP0rtoIqTXq
	 htFeBY4u0GMA/bE7hkFmZiQBaoN/axfwcX/Kz7g3nFCbc/evMVqewfN934Wi5w25j9rj0
	 WX8orAWCre9BHLYsOX4G0ha2h9tQA5+RUPer+9Q6ROFkDfnMOIRbdU/+t241+dDJKFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993004;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
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
	bh=eNAdjfyEatk7nsGpmjY9cim8uI6gSEgRJ+DC63x0cSc=;
	b=RcpBWzgX+hMy7dwM4A3rkxSuRqGrJ4MNS3V8g3qbjy7hibwb1SgoJS8LO9nmRFWs9JS8
	 3SEQRh1/5QvRy65ytd9cfZ1o6XTO2+O0xSxyqHW18pokrOfOa+jc0ewh3IQUWpjRdB4Nk
	 tj6YPVvxAgcfsajCzS15J8Xg2Qdo8Ch7EdxaqbtFehOX9Mq+mFA8SU4z5MkCUGZC36Q3D
	 cErAm9KGLF/KGJm7aFT9kpA8ks/Sj0M8Ad2AbzhoVg5aMNThE9GryrWIW4CaRcof1SaQF
	 mY8bhkCXj3OA3A6L7iF7G1bDi8ZcpBVuSWNCuA/8R7mAgs5fS9K9T6oRreftoL8Vmmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qHuAR03M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.43
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013043.outbound.protection.outlook.com [40.107.201.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E629606A31A;
	Mon, 26 Oct 2026 05:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E629606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qHuAR03M
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PxWn/5SY5EQjEF2RdToza6bL2V7cg/ChSZFQq+nco2e3hHeQTK+fNXoQMGe9fVOIG2v4GjTMNoRBTL75zT/W982oc6K8OX42+jxN+guaC2/6o8Ip0ARHkj86ajobzaKRIeQgQr5S3Icy1KNJ3paARmmC7QLOyDMa5p6JAKjA1qHLR516SEiieUaDrtu6ko2WszgIdIMHjJyvNss2XwRhu9D8qjzqmBLVDdA4sm/+yfnXYUnoRTrr/o0cWdGoNj0E+sUcH/ZxsoQ85ra+UIvI3oOsG0TAKKteNNnBLuw2u/4ThW//TA7VQxpi4Gj57NJ7IgAOcdOofJqjKJNZf51pfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNAdjfyEatk7nsGpmjY9cim8uI6gSEgRJ+DC63x0cSc=;
 b=uRHYnoJrczLf7psieX9Uyh1zjlxIF1JMkSK36X1i04OZdtMjiVQfqWxgM0fd8nzoygKmoN2VaOjNOeZLDvzduvG8U+S1B7L/ContpHR/+hT7nqTVev3QCKWeOc23aRNvJFqEUEhN5fe/nncVGovBTdrGmJwBdQaqJ76jgt3BvGwXMc1fU+SexkZa05ARm6gMROmKaJbI+6jECUWOWkpSoKL5Jxi1bInvCwMC3y2jWva1MtthulSGPvqPFClRFtERz1I1g76mfqzvWtheQpphe5I/Ft6QyHKj9yDOb65/mUnD1yy4FHFzmeqHl5O4VvtITtWid38OrEBvathwtfZAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNAdjfyEatk7nsGpmjY9cim8uI6gSEgRJ+DC63x0cSc=;
 b=qHuAR03MmXljPPMDLCMa5acfmY3O49xyx4f05VZansqsVpSBwPOO+V3D68JnvcwJs7pgNzDScu+1LDpUsAU1KICmBbMOt6l7eEJUXQ+DPX5C5RUedakoj1baH+R30K/aw/6F0fM2AMOwdyhAzs9z9xolhtUyysuAPGq7SqOn+kfiRqocTea+jszJ0uEhZbajrxQ3VR20kuRu+1blPCIIVTI75bZQ0abF4/vDnA7UCngMLHfFjI3CekZSUQ/wHg6LHVp3bBw/EG9itWSDVIpCkrBWY9GhqrNuTKwkscIp0JCfqsg0jXs6ju4JVy5u+Tq6Bbcxh+VZdQcfw2CEpVgqsA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA0PR12MB4496.namprd12.prod.outlook.com
 (2603:10b6:806:9b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:36:39 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:39 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 01/26] dma-buf: Introduce DMA-buf mapping types
Date: Mon, 26 Oct 2026 16:35:52 +1100
Message-ID: <20261026053623.202642-2-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0126.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::19) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f9faa1d-ad55-4c77-7f37-08df33231bd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261009223027099003|261022113327099003|261022075727099003|261021121427099003|261022105027099003|10067099003|56012099006|3023799007|6133799003|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	cai0XVimyOfOCxDHfd42hjMWDI5LC0Mlcblrxpp75nqFbW09RML2O5vHxcFyKRHov3Si/2cEI3kJ49JlysgZGtzedOwy9g30a7tjYqdrb66++kiVwIIz+RDU6iNQ0BWlrLwD+rug1suyPoLgHr/0mpuh6q3OnNZOANAMziEo8rBV6wfEEaCH/+Als9Lg6HQG8VSLQFDxtl5wUmPUHacYgUdPX+H9SzqF+SS6iGKfIs/WPHsor6+Nazu5YZNToFTFNExBxTe4gsluRQfrOMTai+fI3Smgi9F2k/5P8/NjWu+aDSLdcO+H/2ZwegWH86i7eVnBroaARCddnriUDpUL7+i8CLeqreI5XOBqBoe61eGceX0gGTUrET/IhBOvhQVTygBscqz38zeRu9uDAag1iXR7VfRXYrQW3YhSZ7gbEU6w9/ntS53A46l2HlfosF1HL3HTtKTaAO/tODNjGlBTYTcJBLeqJ3Tzsa+LQBCxltvDOZ/MaE8LLjuYtRnekIL+c88Istmy4NacvjfKYlhjWP54HIUDbHFMaDV/uf6YXacxyfXK4pSpUDgBUvMg38Xd0tmH/BJvEWrA8mDJBlxfm0LGyOvcUcFYNTe8DVZ3dDmTUxNlxMOPpQ2hFwabjXMEn/BliqW5HVvCHVub8MyYw+Wb41F9A9nlgfRqpBMFaJo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261009223027099003)(261022113327099003)(261022075727099003)(261021121427099003)(261022105027099003)(10067099003)(56012099006)(3023799007)(6133799003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R+wm2Apm7uXh5YS3h1J+zIgZ9zbnFsVlMY8H8UKpCSTFfoH0lOl3UBaRPrrG?=
 =?us-ascii?Q?GxmkDOhX/Q0+3fJz/JAH7WiM+37fwWF4oWV0JqvkIvwtJ8y05Y6JhAqTczPo?=
 =?us-ascii?Q?+hUmLDiRkYK3vyCTmmzz+Bq7mQSnchEoB9MGzwIO5jHxlgFB9YZm7XJo2QnX?=
 =?us-ascii?Q?gswr8cuT3s0b4qsV2mWwdknwYB7lh/4qQZIAu6D5qGwe6V7kP3LCWGqQjBqH?=
 =?us-ascii?Q?Nc3DbWbRmpwc/t3NZ2oBMRTnwtCjDmWdzYeBGBTtNG3ItkxG3g3E88eFYJhL?=
 =?us-ascii?Q?llz989B90uHojZYn3i+2+R5/cP0erasCouMBV7gsFA9oGyW8VHT1ywEfgqW7?=
 =?us-ascii?Q?0FYK73TKz0bs652wc5XUip+to+EMSyFkp+u1dHSD6BMMc68jgf4kkWYM5S2B?=
 =?us-ascii?Q?jaVJAjx9iz9IDB1FIdRxDgSMx7DmiLB1P9o6154mAU490A75DbbqqkrmBnzl?=
 =?us-ascii?Q?z/WMAumhcKrA1/wQfiWy9ivKwMizMaKex5IO100rpKE2VsMxZgGz1VokE7lB?=
 =?us-ascii?Q?h7DUadzZ/zwLlNeVJoeJ1Vfv8z+sJaqXBXyYfDl6Z1JOk4Ji4MmaQCgNW4KX?=
 =?us-ascii?Q?sSQsJKAVAaDQhwvUJtW3kK+uMKhHGWqKqswQioGOOLJwlGjvdC6c26Yz9szn?=
 =?us-ascii?Q?CUikDpPS69pWzXJdwg6KSqA419z16ypkxvVUrBqoSM1Wnvp9QN4JqAXx+PfO?=
 =?us-ascii?Q?yDOpRiuxExJwnU+HK3mno9lFZl5tK/eTo9ZDGgTBHkmhqRq2YmqidkPNabgT?=
 =?us-ascii?Q?ty3LLx2fef+K8NuiCd5/aclwLB/V77Ni7Mdnk7gw7HPEvsXt92sWSpAtiKVW?=
 =?us-ascii?Q?A9JpgmEX4C/3Do1H4oMq28yMu1iocgo+HW4CJ6ma113oICaHLggsQy7DIadh?=
 =?us-ascii?Q?rOoeZ/+7z88jeYEJgYJN7KkfV7VCainbYvyXsQANm88SyveCSTc65EtaTd3L?=
 =?us-ascii?Q?OQLxJfuFwsQcMCHEjvawPXJe7XE5j3kJ72IudES3baNiMpbzK1V1M7KoEF+3?=
 =?us-ascii?Q?ycxn9V6z8NJCwe/EuaxqSmip97HmT+n9cqjEGrVpAuGjxDI9j4cE0Ng0kEpG?=
 =?us-ascii?Q?wgxtgLp/AaGjxBWFf774+wUWYAjGfeXCt+NSqHEW1Mtt5e9Fa2cUZQzbMUs1?=
 =?us-ascii?Q?IzU+MGr981vQA3TBLsE5568JNZW//eBkdjWrdqLmp6tsy+SMJnZruvu2aHGw?=
 =?us-ascii?Q?WZxrIvzsW2aVKjNvEalG13e1ExFBrUD5BIm11Jke74X9ZRfIJiyhW5z4mvYx?=
 =?us-ascii?Q?7wdpisOQ4GwOAwIRxBiHbubiN+bKoK5M372m0krsyas0mZ2fCceBa8s4caCt?=
 =?us-ascii?Q?3T4a8tVVVUE0EjqfsAHjsvrMUfkNpZxLdQGhZlJarBqS1mrKAdwYRualzaHL?=
 =?us-ascii?Q?MkKuZqeIXwmqdtRYJL7dnazydupFGNi9cN+IgL7f/FaJ3FC06pfLnSUPf1Cv?=
 =?us-ascii?Q?IwWCpiyvQBN4AM9xk5lplLGoQZLbxoW7ktv2oh8nyLG5R+N+oj6fRc8w20xW?=
 =?us-ascii?Q?M/EyjbR/FP4mNhz1uXZgd79rTmhbiybH6VQyDh8V+fMUz6jldEHmRssQfW4q?=
 =?us-ascii?Q?koV83DHWPZQCz2LENitnSxgk914WjclYnwr/seejxOwKaFP1rxBq/9yrbto1?=
 =?us-ascii?Q?2EcQ19iXuEw6MUG4ccjKBiDtL+DLpQETKJDQJ2EAnVXsZMZjHRlAi2/I5Kqx?=
 =?us-ascii?Q?/B0iv3VZLA7q5RNNVURXBkFEDeh0gfsyQlsGLElRhsEvAS0RJpPfp97rtYRg?=
 =?us-ascii?Q?W6/vmF5ASg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f9faa1d-ad55-4c77-7f37-08df33231bd8
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:39.4618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tv7DofqYpK1deGYb+TtKExxAjqHWCpi0X5dZE2Qg/4G24kSAVq9wCiNbOVQWnwHslC38SBZr7T1LsigPHty5eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496

From: Jason Gunthorpe <jgg@nvidia.com>

DMA-buf mapping types allow the importer and exporter to negotiate the
format of the map/unmap to be used during the attachment.

Currently DMA-buf only supports struct scatterlist as the attachment map
operation.  This is not sufficient for all use cases as dma_addr_t is a
very specific and limited type.

With mapping types the importing driver can declare what it supports. For
example:

	struct dma_buf_mapping_match imp_match[] = {
		DMA_BUF_IMAPPING_MY_DRIVER(dev, ...),
		DMA_BUF_IMAPPING_SGT(dev, false),
	};
	attach = dma_buf_mapping_attach(dmabuf, imp_match, ...)

And the exporting driver can declare what it supports:

int exporter_match_mapping(struct dma_buf_match_args *args)
{
	struct dma_buf_mapping_match exp_match[] = {
		DMA_BUF_EMAPPING_MY_DRIVER(my_ops, dev, ...),
		DMA_BUF_EMAPPING_SGT(sgt_ops, dev, false),
		DMA_BUF_EMAPPING_PAL(PAL_ops),
	};
	return dma_buf_match_mapping(args, exp_match, ...);
}

During dma_buf_mapping_attach() the core code records every mutually
acceptable (exporter entry, importer entry) pair in attach->matches, a
small fixed-size array in the attachment, in the exporter's order of
preference. The first entry is the default and is what attach->map_type
holds; later patches let the exporter choose a different entry of the set
at pin or map time, when the buffer's placement and the other attachments
are known. Importers and exporters that list a single type see exactly one
entry.

Add the basic types:

struct dma_buf_mapping_type
   Type tag and ops for each mapping type.

struct dma_buf_mapping_match
   Entry in a list of importer or exporter match specifications.
   The match specification can be extended by the mapping type with
   unique data.

dma_buf_match_mapping() / struct dma_buf_match_args
   Helper to do the matching. Called by the exporting driver
   via a dma_buf_ops callback.

struct dma_buf_mapping_exp_ops
   Base type for the per-mapping type exporter provided functions. This
   would be the map/unmap callbacks. Each mapping type can provide its own
   functions for map/unmap type operations with optimal type signatures.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ dma_buf_match_mapping() records the whole match set in
  attach->matches instead of stopping at the first match, so that the
  exporter can choose among the mutually acceptable types later, at pin or
  map time, rather than the core fixing one type at attach. - apopple ]
Co-developed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 62 +++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   | 76 +++++++++++++++++++++++++++++++
 include/linux/dma-buf.h           | 31 +++++++++++++
 3 files changed, 169 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 833be519e1e6..616ab057fb28 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -5,6 +5,7 @@
  */
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
+#include <linux/dma-buf.h>
 #include <linux/overflow.h>
 #include <linux/align.h>
 
@@ -257,3 +258,64 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_free_sgt, "DMA_BUF");
+
+/**
+ * dma_buf_match_mapping - Record the mapping types agreed upon by exporter
+ *                         and importer
+ * @args: Match arguments from attach
+ * @exp: Array of mapping types supported by the exporter, in priority order
+ * @exp_len: Number of entries in @exp
+ *
+ * Walk the exporter's list in order and, for each entry, find the first
+ * importer entry of the same type that the type's match() callback accepts.
+ * Every such pair is recorded in @args->attach->matches, so the match set
+ * preserves the exporter's priority. The first entry becomes the default in
+ * @args->attach->map_type.
+ *
+ * Because the exporter list is walked in order, the exporter controls the
+ * priority of mapping types.
+ *
+ * Returns: 0 if at least one type matched, -EINVAL if none did, -E2BIG if
+ * more than DMA_BUF_MAX_MATCHES types matched, or the error a match() callback
+ * aborted the search with.
+ */
+int dma_buf_match_mapping(struct dma_buf_match_args *args,
+			  const struct dma_buf_mapping_match *exp,
+			  size_t exp_len)
+{
+	const struct dma_buf_mapping_match *exp_end = exp + exp_len;
+	const struct dma_buf_mapping_match *imp_end =
+		args->imp_matches + args->imp_len;
+	struct dma_buf_attachment *attach = args->attach;
+	unsigned int nr = 0;
+	int ret;
+
+	for (; exp != exp_end; exp++) {
+		const struct dma_buf_mapping_match *imp = args->imp_matches;
+
+		for (; imp != imp_end; imp++) {
+			if (exp->type != imp->type)
+				continue;
+			if (exp->type->match) {
+				ret = exp->type->match(args->dmabuf, exp, imp);
+				if (ret == -EOPNOTSUPP)
+					continue;
+				if (ret != 0)
+					return ret;
+			}
+			if (nr == ARRAY_SIZE(attach->matches))
+				return -E2BIG;
+			exp->type->finish_match(args, exp, imp);
+			attach->matches[nr++] = attach->map_type;
+			break;
+		}
+	}
+
+	if (!nr)
+		return -EINVAL;
+
+	attach->nr_matches = nr;
+	attach->map_type = attach->matches[0];
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 09bde3f748e4..03a03624166b 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -7,6 +7,77 @@
 #define __DMA_BUF_MAPPING_H__
 #include <linux/dma-buf.h>
 
+struct device;
+struct dma_buf;
+struct dma_buf_attachment;
+struct dma_buf_mapping_exp_ops;
+
+/* Type tag for all mapping operations */
+struct dma_buf_mapping_exp_ops {};
+
+/*
+ * Internal struct to pass arguments from the attach function to the matching
+ * function
+ */
+struct dma_buf_match_args {
+	struct dma_buf *dmabuf;
+	struct dma_buf_attachment *attach;
+	const struct dma_buf_mapping_match *imp_matches;
+	size_t imp_len;
+};
+
+/**
+ * struct dma_buf_mapping_type - Operations for a DMA-buf mapping type
+ *
+ * Each mapping type provides a singleton instance of this struct to describe
+ * the mapping type and its operations.
+ */
+struct dma_buf_mapping_type {
+	/**
+	 * @name: Human-readable name for this mapping type, used in debugfs
+	 *        output
+	 */
+	const char *name;
+
+	/**
+	 * @match:
+	 *
+	 * Called during attach from dma_buf_match_mapping(). &exp and &imp are
+	 * single items from the importer and exporter mapping match lists.
+	 * Both will have the same instance of this struct as their type member.
+	 *
+	 * It determines if the exporter/importer are compatible.
+	 *
+	 * Returns: 0 on success
+	 *   -EOPNOTSUPP means ignore the failure and continue
+	 *   Everything else aborts the search and returns the -errno
+	 */
+	int (*match)(struct dma_buf *dmabuf,
+		     const struct dma_buf_mapping_match *exp,
+		     const struct dma_buf_mapping_match *imp);
+
+	/**
+	 * @finish_match:
+	 *
+	 * Called by dma_buf_match_mapping() after a successful match to store
+	 * the negotiated result in @args->attach. The matched @exp and @imp
+	 * entries are provided so the callback can copy type-specific data into
+	 * the attachment.
+	 */
+	void (*finish_match)(struct dma_buf_match_args *args,
+			     const struct dma_buf_mapping_match *exp,
+			     const struct dma_buf_mapping_match *imp);
+
+	/**
+	 * @debugfs_dump:
+	 *
+	 * Optional callback to write mapping-type-specific diagnostic
+	 * information about @attach to the debugfs seq_file @s.
+	 */
+	void (*debugfs_dump)(struct seq_file *s,
+			     struct dma_buf_attachment *attach);
+};
+
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
@@ -14,4 +85,9 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 enum dma_data_direction dir);
 void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 		      enum dma_data_direction dir);
+
+int dma_buf_match_mapping(struct dma_buf_match_args *args,
+			  const struct dma_buf_mapping_match *exp_mappings,
+			  size_t exp_len);
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d15b2b31d3c9..a749562c1728 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -27,6 +27,28 @@
 struct device;
 struct dma_buf;
 struct dma_buf_attachment;
+struct dma_buf_mapping_type;
+struct dma_buf_mapping_exp_ops;
+
+/*
+ * Upper bound on the number of mapping types an attachment can record as
+ * mutually acceptable. An exporter offering more compatible types than this
+ * to one importer fails the attach with -E2BIG.
+ */
+#define DMA_BUF_MAX_MATCHES 4
+
+/*
+ * Match items are generated by the importer using the DMA_BUF_IMAPPING_*() and
+ * the exporter using the DMA_BUF_EMAPPING_*() functions. Each mapping type
+ * defines its own signature with its own data to make the match and attachment.
+ */
+struct dma_buf_mapping_match {
+	const struct dma_buf_mapping_type *type;
+	const struct dma_buf_mapping_exp_ops *exp_ops;
+	union {
+		/* Each mapping_type has unique match parameters here */
+	};
+};
 
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
@@ -472,6 +494,12 @@ struct dma_buf_attach_ops {
  * @importer_ops: importer operations for this attachment, if provided
  * dma_buf_map/unmap_attachment() must be called with the dma_resv lock held.
  * @importer_priv: importer specific attachment data.
+ * @map_type: The match this attachment is mapped with. Until the exporter
+ *            selects otherwise it holds the exporter's default, the first
+ *            entry of @matches.
+ * @matches: The match set negotiated at attach time: every mapping type both
+ *           sides accept, in the exporter's order of preference.
+ * @nr_matches: Number of valid entries in @matches.
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -490,6 +518,9 @@ struct dma_buf_attachment {
 	const struct dma_buf_attach_ops *importer_ops;
 	void *importer_priv;
 	void *priv;
+	struct dma_buf_mapping_match map_type;
+	struct dma_buf_mapping_match matches[DMA_BUF_MAX_MATCHES];
+	unsigned int nr_matches;
 };
 
 /**
-- 
2.54.0

