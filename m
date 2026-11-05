Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860993;
	b=IpQfUsutbRWaGrDcfc7j8xZkTnqP8ZS0Pp753BOvkr9hZnyPsOt8v/zhdbbpIejXKF8o
	 8L8eddDrGEPC2sTIK3oPIMNo2szcHAb/Wa91pywAUPrb5k5/3lydihSKxvRo+J2BaVFjg
	 eZvnCpwzL0DPdWFfQ0AtL/j2Q2HW0g11yuXkmtsJQCcPWZVMLMm/DqlB6Pk2VOY2S4LwP
	 SBU7zwPnLIp4Xddxa+C1gcpkSXlG46OUMU7NQq2yX6cxHY4VlvI9cH+7ZtjgKr00BimR1
	 4PV4ewfknrwqxBc+xkWemquNa0hvH9b5VA/PosGrmqkB6mDCBBX/kL+WsuHZKDuD5Lw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860993;
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
	bh=37C1rI28qJ+MFTLsSth5SETEjOzzCPz7HcHI9/Sa2lw=;
	b=bjvZL8uPMAHChN2EZYq8gXRzFFGIy96B+L5vMwhQmjZ7niL5Al3M1mJ4w5p7zp1oUkk4
	 9ovc/ZjUYPliYmZ6SDr+9qB8t+yp6nqyPrqmoPJsajLXrWnYBojOBaidC3sJJ6JBagYz6
	 doJgUka4av7arx3/zvfTWeN4yw1KT8SQASusSnEBBNiTd5aiQ7q8FBOZ5DFF7qoTH5qZN
	 K9L1v+8f76V93nzjv1H3+How9SXyzGjNzg+s2JEL2qZZCrv3BsFREDmSfktXJZ/9uR6UE
	 QdTijCmDuUbNGjSLLuMQ9gTvERQUpF3q0UIclKQzMZXD7zvpjpX2tG9Se2P5z9oFhTA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dEH9+v3d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.12
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010012.outbound.protection.outlook.com [52.101.201.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541E6606D806;
	Thu,  5 Nov 2026 06:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 541E6606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dEH9+v3d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lc6GxaKv7nUgeerqIusKRHTC+IjMQvTik7qCqrmjypXoWdiDwXlb44k9xd4XSYAgELS+enrKht4cSg8jWu+zsLcP5z4Gdb7Go9auckpbO7EWDjzMVoLd2Od9NdCLYFc6TVhHEazKazsxgv63n+6OLJe6b2N18TjNZCRyv085jNddYFy5pp8O9XKs2YYiVtRhGBTR2T8SsCtro+jwk0wu+HppX3zQS4XEniVPtHWNOOGNWWqZxB4BH7/wcrKtIDZe2ySPnRqlo50yQ0PtR2lnDp09NUaG2rP/ZEe5wKJEd+vEMqcaft4NsrwOvQ4E2URKsrUtkaS2l2GjZl2ofMFOHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37C1rI28qJ+MFTLsSth5SETEjOzzCPz7HcHI9/Sa2lw=;
 b=e1ji8nr1FK7ppO+nj+7dJvBJZn5UHTJ7EXNbalsUBVQpVwuX8IFasNI3wcOVfqb64Cv3RgSmnZdraVA1Mchxiq69LNADQF8UxvKtzPqKGpgY+U5mANudVz5luqALDedZ3JFofrRL+uc+K3cBa0WGuG+YcCIPEk62TKvrTo5GwjYgBjO+S1huIsByTlLbmLfkc6FhO0E+D0/gu6Ac76NR0R8DmoAAGIPfjR4ls8QcXLovrA+h91uE5UQWb52rR7hx+1Let5J+19A5vIFqpzmq8rgzfeBXvJtOcXX8bcFp5LQK7prwpnmw2CGGnd7BSCuyQsEEzsIIEKXmSB17pShgtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37C1rI28qJ+MFTLsSth5SETEjOzzCPz7HcHI9/Sa2lw=;
 b=dEH9+v3dOxRbps36Yw6Vx4MrUSqAi9ObktrwsQITOJ+EtpQlz/I1MC1oadIWtKQrhB0pSj8CllJhvzA+Z7M16GUXYZ7AOIoeUwT14U6BT2FEzoC2W9dUkmYa6yz2jS9747vaHKzoaztGOwefaBuiETUXuZ8RGDlKvdRmkdw4VgQovI0jFKdnfTOCCAXqMLCpsbIfg0LOFp3ePY8xf+cosQQUfRvzgOojqXh0NlttmAP/b+95POLzBZHwHNNIuDmZnPGtwXb5YZeuqnFaoaENWQ1Z0RE/ZYYygjKO6I8ya7jRhaJJvootl4AG9rfW9S+kYgX2OPd4czVX9nkYplPZ+g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:43:08 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:43:08 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:56 +1100
Subject: [PATCH v2 21/23] dma-buf: Remove unused SGT stuff from the common
 structures
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-21-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
In-Reply-To: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
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
 Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, 
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com, 
 jhubbard@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=14815;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=Nelud7sKdOQMlqeAE1X52UYtzvHh1yX0++E5hs0/fjc=;
 b=wFfIxmdwI75onK2TRvqyHDqeQnEujmtsacaeaBedhsZRAanPbqIjy+m54slYl9iEAr/F/fRDr
 HUltHPHqeAeBQ7cUgtt6IYa9g8G4/LUPj6FvlKIZwzqxRLHLjgasTbn
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0001.ausprd01.prod.outlook.com
 (2603:10c6:10:e8::6) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: beb1b322-cc7e-4e13-87b2-08df3b080da1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|6133799003|22082099003|18002099003|56012099006|261009221227099003|3023799007|261021123027099003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	Dvab9QOaG0oaixPStb7AJBkyt1fIiMHOODQneoMyZJoJpYJZfv8wFqdNp0kHye/OssOV1jX+M58oeXFMfXaJtS7eG32VVL8fhq09rawvkYR7br6bumJsziosb+Umybl8jODuks37wmKBN1HQB47bhEpmMsDzcjE13CRnPVulkVbqzPqXtp57YIng4NXv35dcO7JPqkmJAiID+Pp7m+jZ2262snc/QjSgYsbzMe+g+xTRuoWtxjU3rWpjcoLP3+j7kAzGS1haqMAiKi4KiSJXHACpcCtxcj3ldvoAUXxsf8lqz3ub0MGJZL3JWdmmNpEegnsS4ST25dggWptuqSuML0RV7jfp2txKh5T2zeObTpgmkgfK/+lyqafFtejWFGlYizEpldRiZH65fAhwTxCxfoK9YfBV7wfkmZ1GnWrFNpcQnrpJcl2lhnhfo4fyBgxnG3noW37P6micpLc+Plzl5tYmMxDTazbtmhFfc+t+PSAi0qc9q8pFDswTlLI6uvIkI8n1O7Lilq6zZNTy+FiIvtngpx0jkM5Odon4dBLTY7Z0w/Cn2OD2u/+xDXPNlR/Q+Ni3wNSfD/Asn/gFycXg6K7BdCMNgIvYTYLgQZzxANwG8wG7boOFiJMPSOzbkggqHpB4koewkEmRkJcLezELWVCBRkQX9S174JFnu+0DEZBNYNfG+1pkdcOiOPtvMEetyWjcWv3ccai8iUPXbY2Xqg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(56012099006)(261009221227099003)(3023799007)(261021123027099003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N08wdjE2MTNBZ1hBUjBPdzBxQklSZmMvSGxmbW4ycFhWbXVJNW9SYjNmSnFn?=
 =?utf-8?B?aGFPWkwwY0tsQzNCRFNPSGxXQXpOS0w2b3J3WnZLN1dEb1B1RU1ZdXdrZ3ha?=
 =?utf-8?B?SFBLWmNPTGZUekVNdG5FUTJudU9VQW1XZ0ZPdnpPRVR5MVBMdUlHdzZUdFRs?=
 =?utf-8?B?NU9KRUtKdURMdGUxNUhKc2Zldm5IQlM2eEo1Z0c1blFobVhxemFiN1VRWThM?=
 =?utf-8?B?TUJZaEREL1dqZmRUcTBBVWFZYTY0NjZ4K1k0a2NDaXI3VENvZmZxSVdJSGQ3?=
 =?utf-8?B?NW9BK2ErVEhHS0VRWmsyNUgrdm1qOXozWXppRHhmc1JZRU9TMXBheFM5ZnhR?=
 =?utf-8?B?ZEloZHhxblE3bDdGWmUxSW5YT1h0MXZXbkVjNXV5K3I1Ukp0L3gxYWJKaytq?=
 =?utf-8?B?ZVRzMXliakljSzRQSUtCVkUyMlMxOTlzZEo0azBYdkswZ0J3R0tFSnIwakVy?=
 =?utf-8?B?MnNUWmpOMk9sK0w4a1dXTGJESitya2doV1ppRmhOb01wQWlCcno4SVVWbm1n?=
 =?utf-8?B?NzhZSmZ6R1c4TVhzN1ZPeGhvS3pGMk9GWCtZa2sxVElCaUR2azdxaFloeG1l?=
 =?utf-8?B?YXlqOEtMM3FoUk1PWURrTllEdVRzdkF0OWxiSWR1c251OGtlcWpwbHBHVVNt?=
 =?utf-8?B?c0VqYnhhQ0lFRFB0dE12THVrcVFCMXovbXJobm56T1R4UW1sMW5rSittNzF2?=
 =?utf-8?B?OVpQQmx5Vlk4U0QxQ3NFc0hnWUVLUWF3YlJiSUJlcFhHQlJTMGRMMkZzaGw5?=
 =?utf-8?B?ZVp6cW4yaGxJRktUOG9RWmV5UGpjcnRzYmZaSmt5Y3BHQmhPS0huU3RiVzNZ?=
 =?utf-8?B?enlVSmdpTnhHM2x4VVZnREpVWHJBckc1NFFLS2ZQc08zRmJvWTlUZ1RwSEx4?=
 =?utf-8?B?OUNmMnVpaXkvWkQ3VkRJZlBpWW1WTUYyRFpHaTVuVVkvNTJkdFMzK1BhTngr?=
 =?utf-8?B?TStrZGdNZGlIYXd0dUU4Ty81UDJLbmxmOWNGaDZjNkZzWVBhZi8zalFhc2FT?=
 =?utf-8?B?MkYrcmFBL3EwWVkzakVUWExBNTBJSFFLSGNtUUY2M2NteGUyeUZPSXROdkdn?=
 =?utf-8?B?MUlCMXhqU29GNzMrQUlKdFJWV1JJR2Q1K2tuU3kwc256SHdvWXRUSzEwbzdK?=
 =?utf-8?B?enBveld4Mk9PaXpOZlNoSmhjVzZqYVF1NHU3UUNoc3Z4WU1FbW1lQlZHTXhC?=
 =?utf-8?B?NVd3VFFKZTU1cmZ2ZkNTYURxVEhSOFliOGVNb1RkQXlFWW9Dcnhob2FrbkZi?=
 =?utf-8?B?dE44aXZBMWo4UTloUzgyMUtBakVpU0o0NVdpQjhrY1cra0JzOE1CMmFmVFkr?=
 =?utf-8?B?dXV3TXZBTWg5dHJUYXZZaHJPZS9iWUoxaStjclFOT2NRS2xnMzZXRGtRZjky?=
 =?utf-8?B?WWVKa1lpbE1KeXhoYlBLczN5WDhORlUzTEd0ZUlIZ2FrMzRUZ1ZUeWJUQkgw?=
 =?utf-8?B?bWYvN2hmMEM3ZStnMkhyTnZqNklPN1orTTNkcVlTcW9jcjlxQkJEOUN0VHFw?=
 =?utf-8?B?Ky9YWFpHZGYxMGRoT2RXUDN4NEU0YVd1UENSbWlNekpJc2JYWGthMU42dlZu?=
 =?utf-8?B?RVRUWTJYbHRkOGd2TUVHdFVQc2lhWjJxOEpPZlpSV1llQzFrZlU0QVVQWDd3?=
 =?utf-8?B?R0t1Nm9lQnByR3NoSUtibHI1NUNNTjI1UmpYcDF5YmRENUpEVEhpa2JjKzdC?=
 =?utf-8?B?YXo4eC9uSWU5STIrakg3amZTWENVNW5kRlQ3RTl4eHh2a2lpT3V5aUNhbTFw?=
 =?utf-8?B?Ykk1dkVwNUFyTEJpWUh3YlN1UDFnZkhCUDNmaXh2UVdOaUtIeTFuTnhkNjVp?=
 =?utf-8?B?REMyU3gzODFIR0FJUjQ3VVdVaW9iQVc2cVgxblpEVzVGNVk0TUpzZUtQTnpw?=
 =?utf-8?B?WDBEMldqbkVPenhwL3FtRnVFUTB3OTdDQkFtc01HUlhUWDlsQ3oxTHUzQ1J0?=
 =?utf-8?B?QzRwMTRYUXhmL1RjU0ZPMy8xTWxxMklOM2ExSmJNY0JOeVcxZ04yejg1aDdZ?=
 =?utf-8?B?M1BGT1lpYVhlYmpwZ0hjRU81UWVBVzdpZTUrZkZVZTdjRFc0VE4xamZqcmJN?=
 =?utf-8?B?NWRlQkE0ZERFa3hadGl0cDFFT28vMzBIMTVUNHRJdWtxR0k2eW4yazlvaVVJ?=
 =?utf-8?B?c092Q20xS1FEbzdYYnM2dmxoTWVFeVVMQ2pOcy82SDQzUnlqU3U2N1NOdC9w?=
 =?utf-8?B?SlY3VSt1L2M5MmRjaFZIQWgxZTJDV2ROSTFkWTY0Y0RsS2R0ZWtKWllMMjFp?=
 =?utf-8?B?bWkrRnlXOVpIbWVZMEU4dWROTTRMbUludmtVWWhIdm85a2tHRGJjUkFoSEJU?=
 =?utf-8?B?b0pqNXk3SkJ2WUVIK01Jdmw0UFplL1BMSzZ0YmZGUTZtTndZdXoyUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb1b322-cc7e-4e13-87b2-08df3b080da1
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:43:08.6430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wqy9yPcHI6IcA7AGRd0dVpDlhgRo9K+p6WgJh0hN2GDaThQ+yuHH0BC5sZO2SEhKCEAHlLo1AayWyFt+EJXTuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

Now that all exporters are converted these compatibility things can be
removed:

dma_buf_ops: map_dma_buf/unmap_dma_buf
             Moved to dma_buf_mapping_sgt_exp_ops

dma_buf_attachment: dev
		    Moved to the match set entry's sgt_data.importing_dma_device,
		    accessed via dma_buf_sgt_dma_device()

dma_buf_attachment: peer2peer
		    Moved to the match set entry's sgt_data.exporter_requires_p2p,
                    accessed via dma_buf_sgt_p2p_allowed()

dma_buf_sgt_exp_compat_match: No compatibility exporters anymore

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 42 ----------------------
 drivers/dma-buf/dma-buf.c         | 27 ++++-----------
 drivers/gpu/drm/drm_prime.c       |  2 --
 include/linux/dma-buf-mapping.h   | 67 +++++++++++++++++++++++++++++++++--
 include/linux/dma-buf.h           | 73 ---------------------------------------
 include/trace/events/dma_buf.h    |  2 +-
 6 files changed, 73 insertions(+), 140 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index ea5762a73730..3854e6052947 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -501,8 +501,6 @@ dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			 const struct dma_buf_mapping_match *imp,
 			 struct dma_buf_mapping_match *match)
 {
-	struct dma_buf_attachment *attach = args->attach;
-
 	*match = (struct dma_buf_mapping_match) {
 		.type = &dma_buf_mapping_sgt_type,
 		.exp_ops = exp->exp_ops,
@@ -513,16 +511,6 @@ dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			.exporter_requires_p2p = exp->sgt_data.exporter_requires_p2p,
 		},
 	};
-
-	/*
-	 * Setup the SGT type variables stored in attach because importers and
-	 * exporters that do not natively use mappings expect them to be there.
-	 * When converting to use mappings users should use the match versions
-	 * of these instead.
-	 */
-	attach->dev = args->dev;
-	attach->peer2peer = match->sgt_data.importer_accepts_p2p ==
-			    DMA_SGT_IMPORTER_ACCEPTS_P2P;
 }
 
 static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
@@ -540,33 +528,3 @@ struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
 	.unmap = dma_buf_sgt_type_unmap,
 };
 EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
-
-static struct sg_table *
-dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
-			       enum dma_data_direction dir)
-{
-	return attach->dmabuf->ops->map_dma_buf(attach, dir);
-}
-
-static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
-					     struct sg_table *sgt,
-					     enum dma_data_direction dir)
-{
-	attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
-}
-
-/* Route the classic map/unmap ops through the exp ops for old importers */
-static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
-	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
-	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
-};
-
-/*
- * This mapping type is used for unaware exporters that do not support
- * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
- * type so aware importers can transparently work with unaware exporters. This
- * does not require p2p because old exporters will check it through the
- * attach->peer2peer mechanism.
- */
-const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match =
-	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops);
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 70cfab4d9c49..112ffd3a5234 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -718,19 +718,9 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
-	if (exp_info->ops->match_mapping ||
-	    exp_info->ops->single_exporter_match) {
-		if (WARN_ON(exp_info->ops->map_dma_buf ||
-			    exp_info->ops->unmap_dma_buf))
-			return ERR_PTR(-EINVAL);
-		if (WARN_ON(exp_info->ops->match_mapping &&
-			    exp_info->ops->single_exporter_match))
-			return ERR_PTR(-EINVAL);
-	} else {
-		if (WARN_ON(!exp_info->ops->map_dma_buf ||
-			    !exp_info->ops->unmap_dma_buf))
-			return ERR_PTR(-EINVAL);
-	}
+	if (WARN_ON(!exp_info->ops->match_mapping &&
+		    !exp_info->ops->single_exporter_match))
+		return ERR_PTR(-EINVAL);
 
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
@@ -1100,12 +1090,8 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		if (ret)
 			goto err_attach;
 	} else {
-		const struct dma_buf_mapping_match *exp_match =
-			dmabuf->ops->single_exporter_match;
-
-		if (!exp_match)
-			exp_match = &dma_buf_sgt_exp_compat_match;
-		ret = dma_buf_match_mapping(&match_args, exp_match, 1);
+		ret = dma_buf_match_mapping(
+			&match_args, dmabuf->ops->single_exporter_match, 1);
 		if (ret)
 			goto err_attach;
 	}
@@ -1167,7 +1153,8 @@ void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *attach)
 		dmabuf->ops->detach(dmabuf, attach);
 
 	DMA_BUF_TRACE(trace_dma_buf_detach, dmabuf, attach,
-		dma_buf_attachment_is_dynamic(attach), attach->dev);
+		dma_buf_attachment_is_dynamic(attach),
+		dma_buf_sgt_dma_device(attach));
 
 	kfree(attach);
 }
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index a50ab33cd7b9..c8bd285ed7f6 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -593,8 +593,6 @@ static bool is_gem_map_dma_buf(struct dma_buf_attachment *attach)
 	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
 		dma_buf_get_sgt_ops(attach);
 
-	if (attach->dmabuf->ops->map_dma_buf == drm_gem_map_dma_buf)
-		return true;
 	if (sgt_exp_ops && sgt_exp_ops->map_dma_buf == drm_gem_map_dma_buf)
 		return true;
 	return false;
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index b02eb6759d38..c134324db345 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -240,8 +240,73 @@ dma_buf_sgt_mapping_table(struct dma_buf_mapping *mapping)
 
 struct dma_buf_mapping_sgt_exp_ops {
 	struct dma_buf_mapping_exp_ops ops;
+
+	/**
+	 * @map_dma_buf:
+	 *
+	 * This is called by dma_buf_map_sgt() and is used to map a
+	 * shared &dma_buf into device address space, and it is mandatory. It
+	 * can only be called if @attach has been called successfully.
+	 *
+	 * This call may sleep, e.g. when the backing storage first needs to be
+	 * allocated, or moved to a location suitable for all currently attached
+	 * devices.
+	 *
+	 * Note that any specific buffer attributes required for this function
+	 * should get added to device_dma_parameters accessible via
+	 * &device.dma_params from the &dma_buf_attachment. The @attach callback
+	 * should also check these constraints.
+	 *
+	 * If this is being called for the first time, the exporter can now
+	 * choose to scan through the list of attachments for this buffer,
+	 * collate the requirements of the attached devices, and choose an
+	 * appropriate backing storage for the buffer.
+	 *
+	 * Based on enum dma_data_direction, it might be possible to have
+	 * multiple users accessing at the same time (for reading, maybe), or
+	 * any other kind of sharing that the exporter might wish to make
+	 * available to buffer-users.
+	 *
+	 * This is always called with the dmabuf->resv object locked when
+	 * the dynamic_mapping flag is true.
+	 *
+	 * Note that for non-dynamic exporters the driver must guarantee that
+	 * that the memory is available for use and cleared of any old data by
+	 * the time this function returns.  Drivers which pipeline their buffer
+	 * moves internally must wait for all moves and clears to complete.
+	 * Dynamic exporters do not need to follow this rule: For non-dynamic
+	 * importers the buffer is already pinned through @pin, which has the
+	 * same requirements. Dynamic importers otoh are required to obey the
+	 * dma_resv fences.
+	 *
+	 * Returns:
+	 *
+	 * A &sg_table scatter list of the backing storage of the DMA buffer,
+	 * already mapped into the device address space of the &device attached
+	 * with the provided &dma_buf_attachment. The addresses and lengths in
+	 * the scatter list are PAGE_SIZE aligned.
+	 *
+	 * On failure, returns a negative error value wrapped into a pointer.
+	 * May also return -EINTR when a signal was received while being
+	 * blocked.
+	 *
+	 * Note that exporters should not try to cache the scatter list, or
+	 * return the same one for multiple calls. Caching is done either by the
+	 * DMA-BUF code (for non-dynamic importers) or the importer. Ownership
+	 * of the scatter list is transferred to the caller, and returned by
+	 * @unmap_dma_buf.
+	 */
 	struct sg_table *(*map_dma_buf)(struct dma_buf_attachment *attach,
 					enum dma_data_direction dir);
+
+	/**
+	 * @unmap_dma_buf:
+	 *
+	 * This is called by dma_buf_unmap_sgt() and should unmap and
+	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
+	 * For static dma_buf handling this might also unpin the backing
+	 * storage if this is the last mapping of the DMA buffer.
+	 */
 	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
 			      struct sg_table *sgt,
 			      enum dma_data_direction dir);
@@ -354,8 +419,6 @@ DMA_BUF_EMAPPING_SGT_REQUIRES_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_
 	return match;
 }
 
-extern const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match;
-
 /*
  * dma_buf_ops initializer helper for simple drivers that use a single
  * SGT map/unmap operation without P2P.
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index fc341b1257c3..8b27725c7dc9 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -153,75 +153,6 @@ struct dma_buf_ops {
 	 */
 	void (*unpin)(struct dma_buf_attachment *attach);
 
-	/**
-	 * @map_dma_buf:
-	 *
-	 * This is called by dma_buf_map_sgt() and is used to map a
-	 * shared &dma_buf into device address space, and it is mandatory. It
-	 * can only be called if @attach has been called successfully.
-	 *
-	 * This call may sleep, e.g. when the backing storage first needs to be
-	 * allocated, or moved to a location suitable for all currently attached
-	 * devices.
-	 *
-	 * Note that any specific buffer attributes required for this function
-	 * should get added to device_dma_parameters accessible via
-	 * &device.dma_params from the &dma_buf_attachment. The @attach callback
-	 * should also check these constraints.
-	 *
-	 * If this is being called for the first time, the exporter can now
-	 * choose to scan through the list of attachments for this buffer,
-	 * collate the requirements of the attached devices, and choose an
-	 * appropriate backing storage for the buffer.
-	 *
-	 * Based on enum dma_data_direction, it might be possible to have
-	 * multiple users accessing at the same time (for reading, maybe), or
-	 * any other kind of sharing that the exporter might wish to make
-	 * available to buffer-users.
-	 *
-	 * This is always called with the dmabuf->resv object locked when
-	 * the dynamic_mapping flag is true.
-	 *
-	 * Note that for non-dynamic exporters the driver must guarantee that
-	 * that the memory is available for use and cleared of any old data by
-	 * the time this function returns.  Drivers which pipeline their buffer
-	 * moves internally must wait for all moves and clears to complete.
-	 * Dynamic exporters do not need to follow this rule: For non-dynamic
-	 * importers the buffer is already pinned through @pin, which has the
-	 * same requirements. Dynamic importers otoh are required to obey the
-	 * dma_resv fences.
-	 *
-	 * Returns:
-	 *
-	 * A &sg_table scatter list of the backing storage of the DMA buffer,
-	 * already mapped into the device address space of the &device attached
-	 * with the provided &dma_buf_attachment. The addresses and lengths in
-	 * the scatter list are PAGE_SIZE aligned.
-	 *
-	 * On failure, returns a negative error value wrapped into a pointer.
-	 * May also return -EINTR when a signal was received while being
-	 * blocked.
-	 *
-	 * Note that exporters should not try to cache the scatter list, or
-	 * return the same one for multiple calls. Caching is done either by the
-	 * DMA-BUF code (for non-dynamic importers) or the importer. Ownership
-	 * of the scatter list is transferred to the caller, and returned by
-	 * @unmap_dma_buf.
-	 */
-	struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
-					 enum dma_data_direction);
-	/**
-	 * @unmap_dma_buf:
-	 *
-	 * This is called by dma_buf_unmap_sgt() and should unmap and
-	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
-	 * For static dma_buf handling this might also unpin the backing
-	 * storage if this is the last mapping of the DMA buffer.
-	 */
-	void (*unmap_dma_buf)(struct dma_buf_attachment *,
-			      struct sg_table *,
-			      enum dma_data_direction);
-
 	/* TODO: Add try_map_dma_buf version, to return immed with -EBUSY
 	 * if the call would block.
 	 */
@@ -585,9 +516,7 @@ struct dma_buf_attach_ops {
 /**
  * struct dma_buf_attachment - holds device-buffer attachment data
  * @dmabuf: buffer for this attachment.
- * @dev: device attached to the buffer.
  * @node: list of dma_buf_attachment, protected by dma_resv lock of the dmabuf.
- * @peer2peer: true if the importer can handle peer resources without pages.
  * @priv: exporter specific attachment data.
  * @importer_ops: importer operations for this attachment, if provided
  * dma_buf_map/unmap_sgt() must be called with the dma_resv lock held.
@@ -619,9 +548,7 @@ struct dma_buf_attach_ops {
  */
 struct dma_buf_attachment {
 	struct dma_buf *dmabuf;
-	struct device *dev;
 	struct list_head node;
-	bool peer2peer;
 	const struct dma_buf_attach_ops *importer_ops;
 	void *importer_priv;
 	void *priv;
diff --git a/include/trace/events/dma_buf.h b/include/trace/events/dma_buf.h
index 3bb88d05bcc8..13d3a82856b6 100644
--- a/include/trace/events/dma_buf.h
+++ b/include/trace/events/dma_buf.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(dma_buf_attach_dev,
 	TP_ARGS(dmabuf, attach, is_dynamic, dev),
 
 	TP_STRUCT__entry(
-		__string(	dev_name,			dev_name(dev))
+		__string(	dev_name,			dev ? dev_name(dev) : "none")
 		__string(	exp_name,			dmabuf->exp_name)
 		__field(	size_t,				size)
 		__field(	ino_t,				ino)

-- 
2.54.0

