Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860977;
	b=tE63MLS7IM69PfsJJSB8G4d/Ryu+vVKfBvALr4JHp9bjcy/TSBxMEJAs64AMmA+n54N/
	 0Od1Ndrcwi7MY+ZrdCRPsoSP4dY1EWnxJ6S/fkPLI6Gf31iDybB5tyWxbknfQXQHBas82
	 ecZf72BiMG6W7fYmE53NAF0asLqE6yD7bjwksQ0BxG486JX7vLAsbIKJfU+VCWS+o+bpn
	 AuT2E63X62+vIlJlD91/hoKaJNQpwtQ4yvRWtDPygMIGLceV8K59ocAIvq/j5wuwUkshs
	 O5jdqKP4oi20/bk9x5F+HipmECQRK/tR0RtAAl83E5JsXlFx5gZbP2hKMi0ysnj4RWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860977;
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
	bh=OSMczb+HXADbCzirhy+SfZK86tJg2F9qrTbVYJ5NIpo=;
	b=Y38yA5WaytKtjN0mxvzoHr+HOIy05yl8vPCYD6ooRoxm3T0TWJzSgqMj7aICZBwQ1vQE
	 I9cnsDuT8D8E20MlrOv0W1P5xBLQ1oyJ8ExBQ56Ak+9hmZEMgdK8E9plJmUIB3HhPU5rU
	 9lYcf9OAS/UYvBw3rbrnWP/uwPZ+9O8sxRlMo1NXUFy73dUsASsmq1bRqDYYtyV3S1CTJ
	 lTNZzn1GefBlHa8F807vOyWIWCwAN9ZrloILmXRqkxIWIcqtTsjE2qRBit65LFmTtzBCu
	 UbL2ncB42Qkf3QmfKYzeC1Enabi+6lxxEAai2Ld+4gtklEqNI7AXsYKOZAbmxcxzGoQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M4soq58e;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.1
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DED606A332;
	Thu,  5 Nov 2026 06:42:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96DED606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M4soq58e
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mrHn9tTnahVtFitsxP6nRwGWPT6RR+Zb41BvyY8xt8RZMLchhakX5amL7CVF3gcpR4k+x9irrFgZCzt0xPOy78UwR0rY7gVb4BvqoVKZ/rA8ZtF78hykmgfPFEA3fjtpvWAhmr2lc/D32f8Exc6Gm9sMGYAB7l00jyHlk4BT30DIVpNdZyXWKY9gL4U1oKbuM6SsLPozJg53c4bYW1i7m8EbTjAjr9RN1cLoNoc8dXoNJJglcFIdG7y0upxOK9Sk72bQl7S/pWqXyGU6OEXSVTMstM5/wS7QsVNwst1AZsjPNWCTv08CPPEKmq7yF08jreEK/PX8A7C9s8G7JKXfww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSMczb+HXADbCzirhy+SfZK86tJg2F9qrTbVYJ5NIpo=;
 b=rJ7YvuDyW1pbKhoHeloYf51dPPdvO3L+j8a+q2/LFz8eakVakv3jUxshK0T+g4AOYq6s/dWnfFRouRMkI/wS9PeuJj/er75D6iT/mTIT6z0ZCyBX8e646wf5g1iF6G96z5V8L6peOjw1bMmgwnP/g1PG1fPqJYucfFwt3KDw9gh6FuJR7L82OLClZayy/34NTIN3iqSZofbGKyth2+tqGYQ5qubwE0eSBX537z8iPyUGoQxDW9Rwrv0J8ojbXXolnRaycs/MLNhTjrKrsT+JQLobCIq848sS9G6OCzwycVrBPjUQRdpWocu5frZFpHwRt4ZoVN7SG1BXNBerxLXsZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSMczb+HXADbCzirhy+SfZK86tJg2F9qrTbVYJ5NIpo=;
 b=M4soq58e2Lx1RWmha1+EwQ/tPEMvA4wTrDqxNV9WJAgdLoBQ/R+E0BLPeaUoQqqmb/j60IxXJecb1cZynHCWyWKliWeISeFqF6nm0qokxRAzynuE0+ZobLd6WHhEphWVcUoY/vekASjE8Bro08GPnYl5DTu14PvrWCVVSuMwj/TgmlILFUsz3h5SKnE2v9hA4MH4twNjIxfZYGhXaKGefDBxbUSs8b0AeSRN4AK8q+YsxD5BSskHx3l8TdePkjg5MslP7Zf6p5oAmy3SNWWLj4GepPR0EjaOoMKtFk+p4T/g4dJ6KlGIB+I8I1dl36VxQNxGK71/C3NA817DaFSY7g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:53 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:53 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:53 +1100
Subject: [PATCH v2 18/23] dma-buf: Update dma_buf_phys_vec_to_sgt() to use
 the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-18-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=4239;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=lfy2ztpGuXBdOD2YUjsJL68otEwFCrei2X20ZFcm+Ew=;
 b=vP7L2unBwMN5rYkTUj1mdyRQij7khojRb9DK9ImmhItSvNqTTNKR/qEfueq+eH/xhBe8NEI/i
 ZFS2XZrpslvCgllHRBLuHxSeRXxKuNh7Un/qwm3JMlosxReUIYROL+u
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0067.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:203::18) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 13a1e6af-c1ef-4217-ac21-08df3b08047d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|5023799004|10067099003|261028144727099003|11063799006|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	/lbCZhSCtYrbTknLHwO0aium322Hu31cXWQYrItpiAt00ivp4f/T/8sOVEYhHSoXioZZhj0wSMFYetRmdplnwQgJgtstk8X619Mi/2QVFfXYcElg0rYUY6V+ZF4LbVr66PZlttlKbQy2rViNyYjdhwCaLXJ3iOuC8eOQG1vX9yE5cxCS9JnY7toV35+jSd8Sn5wyHsH4Zm6Y96egBfZIUvNgXocmBpzMGqMdAAuCiov+5yPQk+hLnxv1wSZqlP6rLthDsxfvY8y9ltbrRW53Xj1ZQss/ELRo0kcdx1GF7qxD93lpd/ElfQxLyd+5AmiBEdC18OcMdBS4Y4LrYRql3V9StDfmk6mSmlxVXev0k71FNOK1yyIkV27d+54vEQED2uyIMdfYPkG+UQtklgHacAV5zQt+s+U9oKCf5kulZyjaFErZMj1Sx/TGDyb0TM4fqE3eSppeEWD9FWGnX8kc9JFbojCAQQbPJ25Y1YU6BlGY4WJ6DUWnh0Zp2M2ig2QolABNNc3ThIrncnd4uW0lRoF4eds8d9STJQ0EdpeVe+WFKd+p2uFsNtQhTti9m4QX2BMTNeo+AiWrGN9jQf2FIM6vd2CPBqWk/N01xd4a8Ptg1ha8/ebPiCbh1kGhzm71WgxG5szkfD3QXIYLMGhtA+VljigeUt+ARiQxHavLu/bZf7ZzJJ+JAsMrKMDZi5hNsmBrnJTR9TvHKDF84Qvcpg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(5023799004)(10067099003)(261028144727099003)(11063799006)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2NoYUFkZ1RmaGZyNGMvSFRQa3RkR1ZYNFlKVVRPbjFYUWlwemVTeGhlZnRh?=
 =?utf-8?B?alhDYjVjSndFdklvMTVVazRkcDIvMThzeTIwUGlzRUJzczBpNGdYaUJFc1g2?=
 =?utf-8?B?UE40Q2FiM3NNTmNtUWZjZmcrbFZSOEYzSFVNUktHUksyL3RQZ0d0cnBEVU53?=
 =?utf-8?B?S3orVFhjN01SNmpsME9pZzRvclFlU3BveHdJdk9UY0pBN0xibjU4YXA4Y25J?=
 =?utf-8?B?T2FxK1gvZVVCSVJrbjF5czZlMWNaVGl4SHgyM0NyMENiUkh4SndKMytpeGVn?=
 =?utf-8?B?WUMzaDlpWDB3dEZpR2h0NVdkK1AzSUhtSFJnbzkybkVET3M4eGdMZHEyc2pL?=
 =?utf-8?B?VkhXV2x4R2FJY09oNTI4a2NYdzc0akVieXo0YU0xSktjWm83cG9nM3VtSkhk?=
 =?utf-8?B?TXlHQUdJVG9pdU5FZmtoV2xBSFhuNExtc3NhWXJ4ZGE4WGgzR09YZy81bGR3?=
 =?utf-8?B?a2Vic3NQUFJDN1E0V2lNSWRjZWNWNHl6c1M0QnNiWTRIMEpnSzlCdVV6aU5l?=
 =?utf-8?B?dFo5VEpRNGQ5TEMzckxpWjdGNG9lUTMyalNRbUZRZGY0bHB0QU9OUm1yS0Zn?=
 =?utf-8?B?Wi9MRUdIWHlCMnVnejVNK09HWm5DWDhDWGJmT1IxenBYbFhEd0tPajZDT21E?=
 =?utf-8?B?cDFSbzFieWVwR2U4ZFpmZnM3aStmWnlLaTh3TUlTbnM4eVFvQ2dhTUVVRW5S?=
 =?utf-8?B?Um1pUFVSY3NhcEllS3NaVnlnS2ZiZTB5T0p6Vk1aV0pxMEo3S0ptWjczYUZD?=
 =?utf-8?B?UzZOVHpCcllMTWZIckx4SGFpa29wVCttRUowdFJNRU42b25XMkRDMXg5d0wy?=
 =?utf-8?B?b2d0bTNndDZlMmVoVXhra2RlV2syU01Xb29GTkNYMzVqWTc3a1RINmJCbGZx?=
 =?utf-8?B?Skk1ZERUeG1QU1Fpa2FYZmtrWkV0TktEYUt1ekQ2aWFRYi9uaXV5QithQ21E?=
 =?utf-8?B?dml0NXgzZ1B0V0FlZWJ1VkltYWxOMkFWVlF1ZE1kY0JmZnUxS0k3N2lQVWdp?=
 =?utf-8?B?VDBFMXh4OEZEb0lqOXM3dTYwTENKYnQ5cE94bysxNkduUTdGd1BQUzFZUldm?=
 =?utf-8?B?c1ZCK0l3QnNXN05tWjBWY1dncjkzcm5tUTVmcWRYSmlpVnRaMkcxLzlrR2xm?=
 =?utf-8?B?WnZGT2FjV0lQOXhYZHdLdlB0ekcwVVJpcWVVMUJRT2d0QUVGcTlrdE5uQlQ0?=
 =?utf-8?B?SmU4akNGaVdoMXdVTU1heU8yMm5nN1YyRUo0RnM5VlhlR3Z6Z3FRZDBhY1ZE?=
 =?utf-8?B?MS84Sk40MnVpaExVM01lTnpvcGorNVBJdkdRQkZLUEo0cG9pMkR0RDYwSGRV?=
 =?utf-8?B?YmFXdzVDUzVSNUNHaWZLMmZMVDBjaDhVYWp5Ukc1c0VUOVIvVmNEVkRKZmpx?=
 =?utf-8?B?OWMvMHQvN29BMkg5dnlsR1V1V2ZHU243WHNTWlJFL3FXZzVaeUxEOWozWWJj?=
 =?utf-8?B?QXcwZXNzVTBEMVVxUGc1c201azVSV0JjKzZqWTdONnUxbW5vV1UyVUJ4OWNj?=
 =?utf-8?B?cGI3VnVKdkJVUkc4dFM3bFUwTnVPZFNGRnh5ZzUrKy9LaE1XemF4ZzZMbW5K?=
 =?utf-8?B?ejUyQStEdGRMTTFNRGJQb0RKaWV2bFNjN1d1TmZmZk9tMVJGdm15SFQ0M0ds?=
 =?utf-8?B?UUlwWFhSYXdkMWhKUER5UlY2VkR1cUJCM3lJRUlKdWJBVDA0NTVYMGtPcnNk?=
 =?utf-8?B?dlJDeXBiMkltTk1xTnB4WGM2N0Rsd2NMRDBpWko4R3BDbUE2WXNDaUsrazVQ?=
 =?utf-8?B?WUpkcDB0YkZ3OENJbU1MYzdJTFJrOU5uMzI1MldjRkt2TmViNmEvNmEwNWhj?=
 =?utf-8?B?SVdiT244eWZROEU4aCt4RkdpT0IrSUUxdlg4NExwTGZJZnRGNUhCM0c4V291?=
 =?utf-8?B?K3c1UlViYk9vdExlN3MxRnRveEFXK29qc2dPRmVMVnorUlRSVU9TQVVKeGhH?=
 =?utf-8?B?bldNMGJmMnNXcmF0QVBFd2J1Z2YwWHNZcU5MYnJRV1JYK0RxZmZ0WVY5bGV6?=
 =?utf-8?B?Z1Z2OHQ3NnNkNk5DcVlqRlFuUEYraWsxK3d0Q1RIVmM3ay9DUGNyQ1dZelo1?=
 =?utf-8?B?dlRrU1AwQi9zOFJ2ZXpwZ0xqUk5mdjZtZFJpTU1wc1d6ZGEzVUdTNTF3U2lR?=
 =?utf-8?B?UmsyTFZHeUtoOGJmUG92SGpodDMxd3pGWHk1UlBKTzIrVHovOTE4U2NocXMx?=
 =?utf-8?B?dDJZc3kydUFxanMvbTUyQkpIVkwrZWpjVTZhVzNOc1l2ZTB5Q2hBdnhlbUJG?=
 =?utf-8?B?Y3lGeHNLN3U4ZnBncjNFVnlFaHY3Y3Rscndkc1pWcEpLR0lMSHVPUzRKQUpx?=
 =?utf-8?B?cDVzbFJjamZXUkg5QlVITUs2NkMzVDhITjgyRkxSMDhKcVZwcHVldz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a1e6af-c1ef-4217-ac21-08df3b08047d
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:53.1679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GnOfm+IF5R6F7TvIJkDmgJAX1mZf3jysiwRnQpg57ujLT9EOmXxwcifnloFKXAl/vsvplo8P7lC6dAakHWzpew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

These helpers only work when matched to a SGT mapping type, call
dma_buf_sgt_dma_device() to get the DMA device.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 264c9293438f..ea5762a73730 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -105,6 +105,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 size_t nr_ranges, size_t size,
 					 enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct dma_buf_dma *dma;
 	struct scatterlist *sgl;
 	size_t mapped_len = 0;
@@ -123,7 +124,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 	if (!dma)
 		return ERR_PTR(-ENOMEM);
 
-	switch (pci_p2pdma_map_type(provider, attach->dev)) {
+	switch (pci_p2pdma_map_type(provider, dma_dev)) {
 	case PCI_P2PDMA_MAP_BUS_ADDR:
 		/*
 		 * There is no need in IOVA at all for this flow.
@@ -136,7 +137,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 			goto err_free_dma;
 		}
 
-		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
+		dma_iova_try_alloc(dma_dev, dma->state, 0, size);
 		break;
 	default:
 		ret = -EINVAL;
@@ -157,7 +158,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 			addr = pci_p2pdma_bus_addr_map(provider,
 						       phys_vec[i].paddr);
 		} else if (dma_use_iova(dma->state)) {
-			ret = dma_iova_link(attach->dev, dma->state,
+			ret = dma_iova_link(dma_dev, dma->state,
 					    phys_vec[i].paddr, 0,
 					    phys_vec[i].len, dir,
 					    DMA_ATTR_MMIO);
@@ -166,10 +167,10 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 
 			mapped_len += phys_vec[i].len;
 		} else {
-			addr = dma_map_phys(attach->dev, phys_vec[i].paddr,
+			addr = dma_map_phys(dma_dev, phys_vec[i].paddr,
 					    phys_vec[i].len, dir,
 					    DMA_ATTR_MMIO);
-			ret = dma_mapping_error(attach->dev, addr);
+			ret = dma_mapping_error(dma_dev, addr);
 			if (ret)
 				goto err_unmap_dma;
 		}
@@ -180,7 +181,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 
 	if (dma->state && dma_use_iova(dma->state)) {
 		WARN_ON_ONCE(mapped_len != size);
-		ret = dma_iova_sync(attach->dev, dma->state, 0, mapped_len);
+		ret = dma_iova_sync(dma_dev, dma->state, 0, mapped_len);
 		if (ret)
 			goto err_unmap_dma;
 
@@ -207,11 +208,11 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 	if (!i || !dma->state) {
 		; /* Do nothing */
 	} else if (dma_use_iova(dma->state)) {
-		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
+		dma_iova_destroy(dma_dev, dma->state, mapped_len, dir,
 				 DMA_ATTR_MMIO);
 	} else {
 		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
-			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+			dma_unmap_phys(dma_dev, sg_dma_address(sgl),
 				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
 	}
 	sg_free_table(&dma->sgt);
@@ -236,6 +237,7 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 		      enum dma_data_direction dir)
 {
 	struct dma_buf_dma *dma = container_of(sgt, struct dma_buf_dma, sgt);
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	int i;
 
 	dma_resv_assert_held(attach->dmabuf->resv);
@@ -243,13 +245,13 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 	if (!dma->state) {
 		; /* Do nothing */
 	} else if (dma_use_iova(dma->state)) {
-		dma_iova_destroy(attach->dev, dma->state, dma->size, dir,
+		dma_iova_destroy(dma_dev, dma->state, dma->size, dir,
 				 DMA_ATTR_MMIO);
 	} else {
 		struct scatterlist *sgl;
 
 		for_each_sgtable_dma_sg(sgt, sgl, i)
-			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+			dma_unmap_phys(dma_dev, sg_dma_address(sgl),
 				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
 	}
 

-- 
2.54.0

