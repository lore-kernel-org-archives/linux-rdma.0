Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.40
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860969;
	b=sL+bpAKylUTF2KayQPShoIgc77rkI5w/xHt51Pgp/4dwOcaHEhUK1bgcErPrZuXGDr85
	 cI/VQPzzP1mznzN4bLMZ6NX4MwcQEnkFDBbyJ1JCk1BHEBdQcTq+EJUbzCqtSgxThUKVj
	 AlNtK1etdK2FJyIdRcQESWFA6py08zwrL52pg4D8FBSfZPpyssAPWkhy77oiCsPQP5s3g
	 J82Gg3IUJdaP/QuT2OQdSh+Z4tgTBensVzsVQyaKpi4D87AAOuoEwzPjU/f5gQwkA6BYr
	 FfDmLBMdGZT/HAl7HITMVPD0+GIyhm+dCJLIqVRERrruXtijXHLWweQSWy9+bYCNHpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860969;
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
	bh=PLYQkqwZDzCmH4BbptjdELdW6CQE7GgCM2mdix1SzJI=;
	b=FVEVKX2oo93NiKXJfn8d/PTxK5CRz6cVRjf/NgWTciYTfh5PGAiPF4Q0dOSujHUEJXIH
	 iGDBDS9RVqqghLmeoLYIuyhWzQ74/Dpg2i5EdI5+DnBbF3YYnLOTAMUIlitalEFW2c/FV
	 bgPboHbuZOa1FCGKn++aeSmAvvFiVhjKliMDbWBmEwnOCB2Kn6irjb03joiqcIjXu3l5c
	 6cH/BiCdII9+YaXb0DaEv07JowBt3X+cndDDrMprlfPO5IHL7RF7WyzvAZ9uiqR0+VcUO
	 AiIBKKBiqGpzS4CSh7RQ9ooacPfuJqA/JWvZIsx4tCBTLyMs20X8NJvHCjO2G9ggfcw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bthKNio9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.40
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A794606EEBF;
	Thu,  5 Nov 2026 06:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A794606EEBF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bthKNio9
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6lRs+yWxwOY/BGJYOES1EVXWzQYQM4dxIj98I4+nKrYHkLM+xJasUaq+ejZXVj1beKyjugxHuf3kNKwN6piBUyazRPqfwEJR+2YsYrc+fu2qO8L90SV7bdSqXVidEC4ERAOMkfca4lvJ8hvEdQUp48N3wfAUXmMomsri6KMg7lCh9YnPIKxJLZiYP8h0VWnVmDj8buHyN3yof19LTQ046QDoi7ueU25nRr6+40Gs/nqedyic3zfJiGt+mmXyKEO+54a69m1nLG2ntLr4ZFtV/uTmWNErz4pLTWa4QppEPIH0L82dnm8bPzH/s2ta8QWk+XDcg1dzZKUrDA+clAmqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLYQkqwZDzCmH4BbptjdELdW6CQE7GgCM2mdix1SzJI=;
 b=m3aS9KbW3WOWt3rjYCx+xLdeCK+sHLzd3CjD1b3g3FxmRo4DXX42zsLAMCOZWjStvMQIBTWkxuimCNzXSai68I0cjAnD//zWgJ0nYMdhPaqR+bADccsTUmDOVJxWbhIUD0SOUGiMe326jvqFRLYV+HjBGz8ocpMrs8O8XYs/ObpbsK8aacEehQ/IVJFpXIFs4zs9rcjtckNuTPITgKEPDelxqcaGQVyLze5LlR4RLBJZK6Ps6Qq729QpdEMKln0ZOYa3Y44sPWnm6Dl7VwLvMZsanzGQCHW3ir+4sXZa0d7JuBtuw5aShBB/68hgWvtot8/9QWlkhNy4brifT/aSYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLYQkqwZDzCmH4BbptjdELdW6CQE7GgCM2mdix1SzJI=;
 b=bthKNio9XmdKCoVjXlon0+kSeqQQMhp6pkjn8pza6T45bI/SOwimVjewtPmDdmy0cBhiIYmHBvs/QjR1Ks2w19sUenWHdg+UCr/fV38MLy10RUypnh2yTcQjrcvzQgSR730AvQCY++XPiPJzbz21T5hIgm7lz2CADSojrwFXdfTx1bibw4csuJmBhwlc9alFKFtYhb6N3ibJ1UqQJL4WNkBb1jq7eTX1E11aasBs2Nwqoshn7Yhk+MvKg6Au2EgIWzvV1c6fTZIN0FYuntlewdFs8OrRAf09Rx3g/qnfjBumTVGG5o1+VkWfd7TG7OzNLi4HLXCAqwMS9ZfRehfJqw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:43 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:43 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:51 +1100
Subject: [PATCH v2 16/23] vfio/pci: Change the DMA-buf exporter to use
 mapping_type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-16-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=2141;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=hx1F7Kmn6acBKqA4FiE8vlDa30Cq4vPCVpBLEmUXynQ=;
 b=2QX74a3y0JNAryc3e83cp2IKDIQHhBAG8fPi/A09NbfL++eC+4SrgNyguDHevqWJtPla3rUV7
 Hcl+ZTWOOn/BhbF8+Fs40h6fLHRL7V8hCTRO7qHveCyyxZDi//BvZJD
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0010.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::19) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 5d6fd816-e286-455e-1951-08df3b07fef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	PVKiYhW4240skncVLJxAlmgCtNlrf36Uaj9XaO2mZEOVwPo1Ju2b2hCs46VKbC4rUHWihdAeFLmQFMO4ajGTBrOWRyi5GVpmx5LT8ipmDb1mfwp7nRNPrmh7CRLya805OGlfoFOycCwHSxrgVM0P6/YjCmoC98Ucy6ChQLfpZHQHklezMyyRu1ZlutiLG2uCNU4HFdlhH1/8Vn96ZVFcc9rpYL1eSme6KU6AfEJWWn0xcrDzYd2Icg07A/pMy9PDtbqX6yyhNw9FTfnHMLN/bbJXmjDxX0fHeCnsuam4YSuNgnHOBWcr+X0jOo08PRiNL3jHEnwGlbJi4zggcC4HKMh8IQAVdUtUSu2m+F6PiRmImAx9+CWacm4I+i6ho160EcBjXZ5N0JbffvvHNGU9DBS/G86cDpepk7HbIMHxBAijXGCm4Ucys1+AcNBTCh8iKHf7Ypo/K23uHoapHQ1aGduGz3vF7OhPhCkJlejpLw2QVtMGJoPuHh/pUwfUpYV6IAG1KyL6nrEDIeJ9m5xRZAn2mghr3GyrwZQvrZwjbM26eMDFqz7dNiHTANi2Tauco0AWprZzoNQeyJweX04YYJN83gbNbpkUOLJc8zW0en+4KSPDSISz/6c7dU8uA4a3sCQlDLzSOy85Ud92PTMx0vEBhPxWSAiXreW4i6q3PVCbismtotrYnLFKKYltuMDhcY0n2tCufEQo5/lkgq9lPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sng5NmkzVEk0QXJGT1RDc2ZzZm1YUFVLRWRLTSsxT0pBZE1ZM2JjcFRRSitl?=
 =?utf-8?B?QnBrWEJMbzB3cXRab2ZXdWV4Vmt5NExrd3pWVjlEdHczcU51VG8wcDZtdVlO?=
 =?utf-8?B?ZVY3SWtFNTV2SXRwcTB1ci8rL2dtSVpOejNtbHdzL0hjNDU3bVd6b1RVbGRQ?=
 =?utf-8?B?NmtqWnlKNzl4WG9FSW5ONnZ1dDBEZjNYelYvYzVPVXE0NnhJMnh3Z0dkV0JR?=
 =?utf-8?B?OUlCazRnT1N3T1E4TDlpRGdIUktqS3N4ZFFwd1NsU2hQQ3BndXdTeHFyOVRY?=
 =?utf-8?B?eEcrRERXb0dhQ3ZYTS9BdmFGcElXNllTd2lTKzRCR3NZRkZWNlc5R1ZRaWZF?=
 =?utf-8?B?aU40YVduSWtyM2hCQm5uZ0tFWWtKNitrTnhkdnN5cXJYTTA4eFhJS29YRUpj?=
 =?utf-8?B?U1Zxemk2TzFFMVZSTzcrYkNNUTVkZFg4V3BWSmtaSjJDWGhjUlVldTJPQmxH?=
 =?utf-8?B?cjZnN0dNZXNzdHFPcHQxWENUeUhpQ1M0ZmFma0VQVE9jZXNrY3ZMUGtXUFpO?=
 =?utf-8?B?UTAzbS9tc3JHSFhqSWw1OU96TytqZDJnMk1uOGZ6ZmFZN3hsSmFydzJvZ0RP?=
 =?utf-8?B?SU1YWkNYUngvQWphczhGa0VGRWcrWm8vWndaRXNqVUFScDNMbWJFNlN1SjIr?=
 =?utf-8?B?VlhtNGxyV3ltMUluV2ROOXg3SUx4UFNRbnVOQUVjekg5clU3Y0VTTTEwdXhs?=
 =?utf-8?B?MU9ZSll1b0crZWs2cG5mUUtQZjhtNXFXeDhBNUp5VE1KN0prQWs0dEh0MnIv?=
 =?utf-8?B?N1BEbE8zQmpZZHFIYzNwMXFjZEl4REorK3U2d0MzL1hxZHVkRzAvSW1MSU5N?=
 =?utf-8?B?MVQxS1lETXUydmI2eEpWUkNFcyt1VWxNSzI2Y1poUFllUEVnOFpvU25XbWY0?=
 =?utf-8?B?ZUxIenIxMy9LQ1dzSjgyZ0RqUHVRUXd6NXdTOU5UMGNSRG1zb2p6TGJCeUs2?=
 =?utf-8?B?bVNKTDVxS2lyR2xFUmZ0ak92UTRDVjlLRGlnazdLYVFZcG91UkV2Z0ZWNTVL?=
 =?utf-8?B?WkZGSEJKVFdMd3F3VmNDc1ZnUkljd1FiczJvam05SVZINGljS0JoWFoxSE9r?=
 =?utf-8?B?MnNxSGtiSzBpY1RGZ0t1azFraElveTR0MmlMRS9mSEtnampaMHRucHViQkZQ?=
 =?utf-8?B?NU1MYzlxem5LMDMzWkNQRk5tWWdidHhYaGVkcGtna3I4N1htSnFRWHJ0TEJJ?=
 =?utf-8?B?Y0pSbzBLeTh3Qkg1aHVBeVl5Vlh2enJzNTk0UTBjSDFsU1hpZmxJNHBZRXZz?=
 =?utf-8?B?aDQ5T0poK2hkN1d5UFVRYytPNDhNOW1pbElXaDlESDVJN0tnZGJiQXN5Y1Nl?=
 =?utf-8?B?SzRvL0s1Q0dPVEhyWlNjTTVvVUc0dTBibVlBSTBFTGNWQ0swMjk5SXpzZkx6?=
 =?utf-8?B?bHYxYWdoY2FBZHhkSkN5cU9oUU84MWJLYlp5OHdpcmEwUkJrN0R1RHoybUlr?=
 =?utf-8?B?TldlYUU4L2s2dENFWVhweVR2d0VSUXVyWjBLOXRDVDUxOTE5WW05K09wZlEz?=
 =?utf-8?B?YmpoMDV3L1dxOTM5ZGI4aGV6SGx6MzJvY1ZQWEIwdXJCYnNDcGYrU3RJQm9w?=
 =?utf-8?B?MnRkamhQUTBUeXVvc3RDKzkvVzBiczREZXBzWnBab3Urc1crYUdFOGhyVk5V?=
 =?utf-8?B?WkpyUk9VQUc2V1lJL1JVS3kydDBUb1dhUUlJY05mMFZGRks1OFZJSE9RQVVx?=
 =?utf-8?B?L2dBZ0VnWGJTVlVRNDd3UG1Jc2hwaFZaSHdFeVpXK3Uzd3NJbXRvY1FsejdW?=
 =?utf-8?B?a3dUUXhSYithSnVJMWhhWS9teFVQN05ZaUF6VGlORU5nMUUycWJnZHdBR3Vm?=
 =?utf-8?B?dXZ3bzhWVko4UGV4SytrbnBET1JXZ2haSTJ3Ynk4NFB5RUt3Q3ZQTWtjOHYv?=
 =?utf-8?B?STNhazdrdUM5bVRhNUpNdUgvNHZzekM1QkZEaDg2WUhrVHR0eW1lZFJVd2Fm?=
 =?utf-8?B?WmN0eDQ5b1Q4TzZNellNNnl2ODJreHdnQTNPUG92Z2pRempXZ0U4OHJNZ2ZI?=
 =?utf-8?B?MnJTUm9qaEttcUdLMmJHS0NsbFg2c0h2MzhNYjlJL1U5RnRUTHJpSEttVG1G?=
 =?utf-8?B?QXNLczhvMk9TSzRCdHVYa283SjBRcHRyRTlFUDZGbmJocSs5TVpWa3o3TEpN?=
 =?utf-8?B?M1hZS2w5eGExYlBER3FiRENMYkZCR2huWlA2azZmWTJKdWhIUlg4bDBnUGRh?=
 =?utf-8?B?a2F6ZDlPT0tEV2VCWlh2cHRjUEF2MmVDenlzZ1R3eXFGUVo5dXMrZEVkdnBD?=
 =?utf-8?B?Q1ZnenREREh1MGtiZFo1S3h2NStOZ3BsOVc2eHBvK1FaaHJCd2svV2d0anBH?=
 =?utf-8?B?SUNIa0JEWmZROU5RVTluZkdIMm1zMW5QamtUTm12WHFPcm1GL3haQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6fd816-e286-455e-1951-08df3b07fef4
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:43.8670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAtWou75313fh1n/PeFSDftrfuMp2rikJHRqrzfaKVvQs/q6ZXLbXbKYpmwkPeklBlYMOf7qhdf+ojF/3dskhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

Simple conversion to add a match_mapping() callback that offers an
exporter SGT mapping type. Later patches will add a physical address
exporter so go straight to adding the match_mapping() function.

The check for attachment->peer2peer is replaced with setting
exporter_requires_p2p=true. VFIO always uses MMIO memory.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..ebbdbcc6ecbf 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -27,9 +27,6 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 {
 	struct vfio_pci_dma_buf *priv = dmabuf->priv;
 
-	if (!attachment->peer2peer)
-		return -EOPNOTSUPP;
-
 	if (priv->revoked)
 		return -ENODEV;
 
@@ -99,11 +96,30 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(priv);
 }
 
-static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
-	.attach = vfio_pci_dma_buf_attach,
+static const struct dma_buf_mapping_sgt_exp_ops vfio_pci_dma_buf_sgt_ops = {
 	.map_dma_buf = vfio_pci_dma_buf_map,
 	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
+};
+
+static int vfio_pci_dma_buf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_mapping_match sgt_match[1];
+
+	/*
+	 * MMIO, so the importer must accept P2P, but it need not be a PCI
+	 * device: iommufd attaches with its own non-PCI device and programs
+	 * physical addresses. Reachability is checked when mapping, by
+	 * dma_buf_phys_vec_to_sgt().
+	 */
+	sgt_match[0] = DMA_BUF_EMAPPING_SGT_REQUIRES_P2P(&vfio_pci_dma_buf_sgt_ops);
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
+	.attach = vfio_pci_dma_buf_attach,
 	.release = vfio_pci_dma_buf_release,
+	.match_mapping = vfio_pci_dma_buf_match_mapping,
 };
 
 /*

-- 
2.54.0

