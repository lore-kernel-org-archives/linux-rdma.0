Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154207;
	b=Fl3QdDR9t9RlwmEOESztPXYqU0UuqH9HNHMAhOg9TJAcxtudH24slWgubUO5wZg/a1uB
	 MP8XFaCHG2xvCh7L5mHbzlWIU3VP35Bw7WfPW8+zrZB1EtyRRbIyR0HQwWb3/rasz8drR
	 LqkSYyud8iYcjTmPtbO5de4UMHAFrWNE41fViEirIDpcvgjOn5+rUxjizAnT5E8WP+Eib
	 AeTxd11oN379XUiAUGmxIMM8kWS0QAqvWFhXluDI55Mrys/o/rfo3B0k12Z3d+lmnJT5l
	 Ed6/j1aT7MlkLvoJBBufRIxTEmQf2vpVVtvwSSeg7zl31CWTuHbFNE56fHhha2Qb1sg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154207;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=5C4Ov4muh61MqXAp4gyEw9nfwkG839CdaXx2frm0hQ8=;
	b=pEqG2Bs/feqL7KS+II5XkpnHovlHbGyy6PrLOtoAQ8i7c3QIEOqmid6Irnovc4v0BNqw
	 VVjp4eAux/A09CxKn6icmiR0WtBi09IoadZ61lI9JxINOdEk4jW0MhD5owqf7EwBaM6UQ
	 TA/XM42BeREi/3kL69gF6ke9usvb0+Jy0AGOTDi0VjQW9pqKMrvYKFpPr6pwTnXPEtc+P
	 TNWmC2LZcZqtXduFDnNCbWrNq0/Jz8WLcaU3HTWY57S7XySInLoxxlWW/3JBUFwcTTTAL
	 shc2YSF/OCp3gBJH1jKMWWaEZ26pTXXyqbuHkYEVRSpWxBMT5FfmFOLtArLqAXUc41w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZvWMdAc0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.24
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013024.outbound.protection.outlook.com [40.93.201.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B6960A2607;
	Fri, 20 Nov 2026 05:56:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22B6960A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZvWMdAc0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qZyFTC2Dr4VUHGnI8wilB9CEJynP7RiuYjhr4lyiDeVp9lg4aiTqUX8uG8WVn6+pPK1huV4rlLs3Vb0SQyp4rjuMtQ2GBz6HePnj2K86Dop1tKrZVZ5HR1c8vIXlta1LSw8RKzU4JjhKm+bfRsG1vcRfwZIjx3H6nCc1Mv52EiSZNDkuDFrfa7ru+BXvQ/DEOEQZ822dAx8U+5fZeuCwawSMkGm9cIqGlUh4XwARGMx48xpkBxzLeIwt17rZFXbX/X5ggeWoapzY49Y6t41f630ckRKeCsjWLQUKREBhe1KsYPVuiSuxh5oowvF2p9tm06meUd2p4SfRkBxZ1K6h2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5C4Ov4muh61MqXAp4gyEw9nfwkG839CdaXx2frm0hQ8=;
 b=lgfqr7+gqp6uGkHEsjlcCwv5EFASA1iEGq8v9MGXo1ddGiKO+Jb6WDhmtzqXIWlcSmoG1NLBN2fXPsrsvMG2siZHW0tnQaUHKg/T8TV3Is4kNdUoTQXRTOJSgPE0j6UxMGW9h6GmUl+ieDLK+NW13TERctEzt2xHiikAwAr8p4G7pXMJ+etr3t23SRVLWWNRQPZ54lzPhoCd5MIAa/UC2i4PoQkP+w1krMntUZLCW0oHtLaa1yAhN1qzXUv9NTHNg25AdD8IgX6lymU/VoVr4X+1R3izZsqR7LOqs21g8P0gLj3FLOxSxTGv0nZQ+LHRMlNlsChRrAcDmGq7d2xy1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5C4Ov4muh61MqXAp4gyEw9nfwkG839CdaXx2frm0hQ8=;
 b=ZvWMdAc0J0nJBt2I/PExrtnR0K26Lk7EjrT0ynUKZxy5+KrvHLHQuexlKZAhRj9av0T+Iy+9Yn3rqgi8IkwqONOqyfYFoCJJuxGsDoz5eAr5qp+KB/AFnR3Xlj8K+L+9R+jQ7X1y6DVbjnUptaUni0Pz8FOD7UkdYZVfaZGCO1G+UKsRmC8eqxLgCWmy6FiyQjMj0lPq4siz8VrxRN2A0ls2uhrZKQ0symbBGmknofG+qajDuRb7A9+HKkn8IbFgnuL5w6dV0x5TsTJh15tsTuq30knusFj2VLsWek01EvW0qmrf+fsCKogy9Zg+ONmEAOj4ouEjoVgRB3X4fhZGhw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:56:40 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:56:40 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:40 +1100
Subject: [PATCH v3 02/24] dma-buf: Introduce DMA-buf mapping types
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-2-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
In-Reply-To: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Simona Vetter <simona.vetter@ffwll.ch>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, 
 Felix Kuehling <felix.kuehling@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
 iommu@lists.linux.dev, Keith Busch <kbusch@kernel.org>, 
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Mina Almasry <almasrymina@google.com>, 
 netdev@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>, 
 zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com, 
 chaitanyak@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=11325;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=/9UTTo3a/2FO9sdj6K4gNVj0Ke5UuHPrYWoVXPvmmbQ=;
 b=EqD21hz4ovxnDZEPy/7GcDVINY3CaLGSeF2utuiRvC9m3mjJErs40p13YgRmg5LLSjpGZY5Uw
 VFbNIifjql/CT2yooHNoSr4+SKUQ7smeFZnWA5J3aaxFRQ4A7rzb2Jb
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0193.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:249::16) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 7416258b-dd81-44db-acfe-08df46cb0c3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261022113327099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	YwtnHmjL8R4c1kzyLQ0cKd/gnWqaHIKYVtKIOMQ71N4nYBHntogd1NtqzV3oSY7/sV31rUghB+sPLV2mLsUpAUFCAXh/jzqir3SQp2UOAjJPEKN9GSj9VSgqaJf8lltPF/AUQoUnBXlof20d3pd/DF9fT6IeUWPsK0dDVNlm50a/VDj3WnRG9ivop54wwQ9ovyIpzc1L0tRQG0QVe8d7Pf5+26LZ+Tv8ORYjh+vMX9YVzzVbBvn2PfZV4KsjO8m+2nv/CozXXJT6kJB1ALvM8JJnjQCJi3RzA7BPdr9tBwvdFNwndw2K8tkWJha8YBhHzO875xU/W2oPbPfIbd2k+kgSDzYcIQHduRnETsfKLOM14qiqKjugLMbUKs7+O/HsUPl0VAO+GwBWA3kKLMDBaJ/sljbEpYp2JryOXi4XIlXCkhnBLIhPjO6tEBuQZqCD5sGbFIPmSzpfPu3c4aypHxN34+xVIzDn3KCrVYuCn7Fa8Y0yH2qJIyGC1xB/IZemSzBRuTNwBVWVgO7jb30gIYq/2UdEPcw5JzYGGS9nl8B3ZFnj9l7f9r5NNXvkHqvC3YJZv0JnQh8ynyKgS9TuWtvakxkAVY5KLDAwYypC9TVURZ1YALcs+lFl0LAcPgyKx0NhAeeH+4yPUXlKDut6UPKNJ54Ec+H6Fz1UTiFciILZh/DPKCVS1Aq6Q/yyi6/sBvfUCtVTiC+iwaICpNziNA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261022113327099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDVLRFlFdDkxUENqeVp4L3RvLzVQNlc2bWxFR0JvRUhzbnpkVDVDKzJPVmVO?=
 =?utf-8?B?N3dQZGRNbkxHNm9FWVZqN1NFZ05vcTlFRG5rN1F4QmVESks0dXhXeHB2bFA2?=
 =?utf-8?B?T05jY3pTV1dwMlEyaWZUWGh2VjRzSC85amNIRDZWYU94VG1IaW5kamQrcFF1?=
 =?utf-8?B?TFQrVlhJd1Job2pkL3VyMWNtK1VtMVZXejhCdVVBenBVdGZjYzdYaHkyWlZO?=
 =?utf-8?B?aUhLbzVKK1VNTG16bk9YSm9ZdWpxS1hINzFFVG1sSGpaWGpyYzlseW5hMXRj?=
 =?utf-8?B?QVJSU0hyNEhLbWk2b0tQVUhXUmdqUjhNcmpQQ3JRS0VoeURTWVZRL29FTDg5?=
 =?utf-8?B?M3NvU0lGSWF6RnZxcDZMajlnNUhWYkNPa1dSbEVjakJJOTIwciswRmNTSXhN?=
 =?utf-8?B?WmhEbkJvWUJ4ZmErYVNYb254alBQbzVjeXBMd3ZnMDJsUVY2V1QyR3NLdWlo?=
 =?utf-8?B?OStkMGFBTndwLzBxaVJLdjVUcVh3eDcrUkxPOCt1cGFEakFlY2pPakQzdXIz?=
 =?utf-8?B?QjhKQTQzSHpod3cyYmRpTmh6YkY5NG9Kc2NrQnYwWjZ3eXplaWVPVmFCOXFm?=
 =?utf-8?B?MUpDZHBrQzJCakxwWGhKaVpTNmxmMzdpd1IxMGN5WWNyU1lubTVSakJpSVR1?=
 =?utf-8?B?VUJ4RnBMNVppSW5UNWxIWmhXRE1HaFdJUVRrQll1MGRnUWJEd2xnVWNvdU40?=
 =?utf-8?B?Y1FFTWZ4Qm9mYUxQaFJlanFiL05LdnFvOC9nZmJGaVlDYUY4U3Q4YW1rQnNt?=
 =?utf-8?B?d05TR2M1Y29qVkNVSkJ6eEFOZTBsRmFQSFcweFVpUEoyNGJPNW0zWlNydzV1?=
 =?utf-8?B?V3M0MWpYWWZvS0Rxdlg3VGNxV1gvM1Ivc0ZlU0p1YWMzNE80MTFERmxVY2Yw?=
 =?utf-8?B?ajRCS0lRMFFacnArV0k2bnJzbVNFRXgzMVV5SXZTMEhWSUtQNEdISWs1NEdk?=
 =?utf-8?B?VGovdk9UWnF1VW01ZktMNHMzaHp4MWhlZFFubmo0Q09LcHpnaGlQS1ZOcGw1?=
 =?utf-8?B?YVFNa3FNSVdDejdpZWh4MmZwTTlvb0F1TSswSkljMG1kc3VLQ1YxT1hWYTBQ?=
 =?utf-8?B?bzhTV3JzNktXU0hXb21VUitKNjJocEN4RWJlYys2RlhnaCtrMmFVcnZPMmJj?=
 =?utf-8?B?VkZxRDlkczc2Wm5ocjhNajA1SGtXKzlSckJ0MFh3U3NlSTZtblhKTDZPdWpF?=
 =?utf-8?B?cmVsMEtacnRZeFgxWHBrVWViQkE1OGhIOUlVdkEvNEFEaW5NNWFzNHZOZWdz?=
 =?utf-8?B?TmNOdndET3dyMjVnREUwWXFaVmRKYWh6cVp1S3gwSXdnOEdNeGo0elVwQi9S?=
 =?utf-8?B?RmpsbGFpYU9WWUNHZmM0SEZxdHZZUk81cWp1NGdZNWYxb1VLYmRXdHBML3JK?=
 =?utf-8?B?V3YzUUdpb3dNZGNTN0RrNDJLNTdaS1lmK0ZKQWc2cHdzbzFjSFlERmU0ZVdH?=
 =?utf-8?B?dWtUUi9wTDd1R1preWF0SWJWTmRXYjgyajF0V2MyZHFkL3dqMnNZbFZFSUhY?=
 =?utf-8?B?VVBPMEw5UGFxTG5tQWU5NDliUVJHc0hsbFNuMm4zeEl6TmRxVCs5cHFOSVFi?=
 =?utf-8?B?UGpzL1c2VWU5cys2SFZyUFh3THowUXhmQ3k4T0w3Q0YrOEJGSVc1K1JRL2lM?=
 =?utf-8?B?YVFSZ3NzRGx6bjROR1o4Q3pkd1VKbDNNSy9odGt2bXRoc1Q2dTdDbkxacFZM?=
 =?utf-8?B?Wm5ndWxsTkRkZ1AwMnp0UXpsdWdDRGdFWWsreVBtS05XM3oxcW01NHA5dFBm?=
 =?utf-8?B?bmFaWFZic0IzTkp5ZzRsdVhIenB3K2k0dGpRcmpEMTZxSTh0WUxuMHZrekM2?=
 =?utf-8?B?bUVaTzA5czNsMjUwTzNrS0tvbVd2R2hxODhZRDU2SkdGTytUUFRxRFljTU9h?=
 =?utf-8?B?KzM2RFc1dVlTYTIyUHEyWE95L3VKNG8zc2p3ZUpjWlJUMG1vTGUyRmFrL00w?=
 =?utf-8?B?c2xWTFNSVnhoYUQ5elgrR2w1Y0VKNDdyODlhNEZyaThZNithc2VHVWpzMkpo?=
 =?utf-8?B?RTlDNGZ6eG5YYmlnM2RPSTBDMzNjQy80Z2V0ZFFINDVuZ3hSUmNsSXpYTnBq?=
 =?utf-8?B?aXdFTXl3VFZFaGF4YUxDeDFiUGZ6ZlNtU3I1NWU4bXJCK0ora211aDNrUnhT?=
 =?utf-8?B?aHUzMkdlaTV5cDcxcCtnaS9abmNoeHYrV1NZaVpOUmJiNnAzUXI4OFJRSGxx?=
 =?utf-8?B?cmtXVEpXNllIYVF2K2xlUVVIRlNlclF5OTI2RWRtTUZDS0hOQVBUUC9kZlM3?=
 =?utf-8?B?c1MzRXJjZCt1RWZkSXlROE9QUUw0V1Z2VDRqSUo2R0ZDOFZjY2lrdmRCaVcx?=
 =?utf-8?B?R3pxUHVNc044eXc3RExTTHM3aUZWWmh1bTFXTHJJNmpGYlhSakd1Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7416258b-dd81-44db-acfe-08df46cb0c3f
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:56:40.8573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lGaz6G313O5xkelrZh8IvbELfzEPOWLqzxZ8fD0ElT8+l/acEM+aLECy+5vBIP0ZLeq+o5g3D6KopL1nwAyog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

From: Jason Gunthorpe <jgg@nvidia.com>

DMA-buf mapping types allow the importer and exporter to negotiate the
format of the map/unmap to be used during the attachment.

Currently DMA-buf only supports struct scatterlist as the attachment map
operation.  This is not sufficient for all use cases as dma_addr_t is a
very specific and limited type.

With mapping types the importing driver can declare what it supports. For
example:

	static const struct dma_buf_mapping_match imp_match[] = {
		DMA_BUF_IMAPPING_MY_DRIVER(...),
		DMA_BUF_IMAPPING_SGT(),
	};
	static const struct dma_buf_attach_ops importer_ops = {
		.supported_mapping_types = imp_match,
		.nr_supported_mapping_types = ARRAY_SIZE(imp_match),
		...
	};
	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, ...)

And the exporting driver can declare what it supports:

int exporter_match_mapping(struct dma_buf_match_args *args)
{
	struct dma_buf_mapping_match exp_match[] = {
		DMA_BUF_EMAPPING_MY_DRIVER(my_ops, dev, ...),
		DMA_BUF_EMAPPING_SGT(sgt_ops),
	};
	return dma_buf_match_mapping(args, exp_match, ...);
}

During dma_buf_dynamic_attach() the core code records every mutually
acceptable (exporter entry, importer entry) pair in attach->matches, a
small fixed-size array in the attachment, in the exporter's order of
preference. The first entry is the default and is what
dma_buf_attach_map_type() returns; later patches let the exporter choose a
different entry of the set
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
Co-developed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 65 +++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   | 95 +++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h           | 29 ++++++++++++
 3 files changed, 189 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 833be519e1e6..d27f02610c2a 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -5,6 +5,7 @@
  */
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
+#include <linux/dma-buf.h>
 #include <linux/overflow.h>
 #include <linux/align.h>
 
@@ -257,3 +258,67 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 
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
+ * preserves the exporter's priority. The first entry is the default returned
+ * by dma_buf_attach_map_type().
+ *
+ * Because the exporter list is walked in order, the exporter controls the
+ * priority of mapping types.
+ *
+ * Returns: 0 if at least one type matched, -EOPNOTSUPP if the exporter and
+ * importer have no type in common, -EINVAL if either list is empty, -E2BIG if
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
+	if (!exp_len || !args->imp_len)
+		return -EINVAL;
+
+	for (; exp != exp_end; exp++) {
+		const struct dma_buf_mapping_match *imp = args->imp_matches;
+
+		for (; imp != imp_end; imp++) {
+			if (exp->type != imp->type)
+				continue;
+			if (exp->type->match) {
+				ret = exp->type->match(args, exp, imp);
+				if (ret == -EOPNOTSUPP)
+					continue;
+				if (ret != 0)
+					return ret;
+			}
+			if (nr == ARRAY_SIZE(attach->matches))
+				return -E2BIG;
+			exp->type->finish_match(args, exp, imp,
+						&attach->matches[nr++]);
+			break;
+		}
+	}
+
+	if (!nr)
+		return -EOPNOTSUPP;
+
+	attach->nr_matches = nr;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 09bde3f748e4..bb826bdc2911 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -7,6 +7,83 @@
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
+	/* The importing device passed to dma_buf_dynamic_attach() */
+	struct device *dev;
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
+	 * Called during attach from dma_buf_match_mapping(). @exp and @imp are
+	 * single items from the importer and exporter mapping match lists.
+	 * Both will have the same instance of this struct as their type member.
+	 * The importing device is @args->dev; importer entries do not carry
+	 * it, so they can be static tables shared by every attachment.
+	 *
+	 * It determines if the exporter/importer are compatible.
+	 *
+	 * Returns: 0 on success
+	 *   -EOPNOTSUPP means ignore the failure and continue
+	 *   Everything else aborts the search and returns the -errno
+	 */
+	int (*match)(struct dma_buf_match_args *args,
+		     const struct dma_buf_mapping_match *exp,
+		     const struct dma_buf_mapping_match *imp);
+
+	/**
+	 * @finish_match:
+	 *
+	 * Called by dma_buf_match_mapping() after a successful match to fill
+	 * in @match, the entry being added to @args->attach->matches. The
+	 * matched @exp and @imp entries are provided so the callback can copy
+	 * type-specific data into it, along with @args->dev if the type needs
+	 * the importing device later.
+	 */
+	void (*finish_match)(struct dma_buf_match_args *args,
+			     const struct dma_buf_mapping_match *exp,
+			     const struct dma_buf_mapping_match *imp,
+			     struct dma_buf_mapping_match *match);
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
@@ -14,4 +91,22 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 enum dma_data_direction dir);
 void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 		      enum dma_data_direction dir);
+
+int dma_buf_match_mapping(struct dma_buf_match_args *args,
+			  const struct dma_buf_mapping_match *exp_mappings,
+			  size_t exp_len);
+
+/**
+ * dma_buf_attach_map_type - The match this attachment is mapped with
+ * @attach: the attachment
+ *
+ * Returns: the entry of @attach->matches in force for the attachment: the
+ * exporter's default, which is the first entry.
+ */
+static inline const struct dma_buf_mapping_match *
+dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
+{
+	return &attach->matches[0];
+}
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index cedeb8ebc99e..81bbcd420d60 100644
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
@@ -472,6 +494,11 @@ struct dma_buf_attach_ops {
  * @importer_ops: importer operations for this attachment, if provided
  * dma_buf_map/unmap_sgt() must be called with the dma_resv lock held.
  * @importer_priv: importer specific attachment data.
+ * @matches: The match set negotiated at attach time: every mapping type both
+ *           sides accept, in the exporter's order of preference. The first
+ *           entry is the exporter's default; dma_buf_attach_map_type()
+ *           returns the entry the attachment is mapped with.
+ * @nr_matches: Number of valid entries in @matches.
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -490,6 +517,8 @@ struct dma_buf_attachment {
 	const struct dma_buf_attach_ops *importer_ops;
 	void *importer_priv;
 	void *priv;
+	struct dma_buf_mapping_match matches[DMA_BUF_MAX_MATCHES];
+	unsigned int nr_matches;
 };
 
 /**

-- 
2.54.0

