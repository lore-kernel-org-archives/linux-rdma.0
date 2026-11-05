Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860929;
	b=tjxO+yrNFasBF+oHbWeD3qS8TMofwXEZzplFBQLQkW7PIcUKt5uf6J6NAoas+jb5j+HF
	 1g2ZP13LKpI0Fn4CsLTzC3KCpmkvrDCd+NLDy6FYw/vbJqTAlZFRuJ66b4LZoakLNPO2P
	 TJZtv8ccxm/cQ+F1QeyPKPTEf5H5brFlVAOPqlt/sewBSCQmXpveUThVc+enS7WvFFNJ2
	 7nGsHWNABmPOK1CfP1BKlLcQ/dIswKxpgsILGGmB6LZ8KKz/sYtOm0WDooRTvGvt1p7Y6
	 BsLai6D0F6W4KWAsuh2PLCTP5zd6nADaMcmBY5CKwt+T0hHcnkXtRHmlthikzJtDGWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860929;
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
	bh=m2RiDXPNYALdkAA+vKQtgNlMW6GjJbtLl3n0btzjV0I=;
	b=hcqgeuDpwwa3+fm0FbriptE7CuGvMrNtWKjrHrnEu3vIDchlVPkFqI+ua2ytj3mCizFB
	 2m4WIFiSbVfb2w7ojEeR/o8379NGJStCKNv8NBZ6Do7A4ScHvLxT7QY4lQZCgcyAoP2I6
	 SsqdhGm8ijoSNNb7wg33rnL86qGlNynrRQopVf2dhqYY/Y2DsXj90Raap4TqqkefC/FXf
	 qY+S16K9HP01nl12HvDDMKziueCNM6adisHTFJe8B181r9XjUJNTD0qDYx1Uu+orzL7K0
	 2GnXUlvirGDyOM2NAnQek/msrjZ4bnLPYRsIsrMhSbboVlQ7vTcfnPFgd4WY5RolapQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RqVGdqJk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A9606A33E;
	Thu,  5 Nov 2026 06:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E1A9606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RqVGdqJk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jAyCAtny3Em1vbEy/I4QqWAiwI1KKVQvXSt5VO26FmSlSYW04zlSYbCAikpqH0zFRh4sihh4dSj6pao/PHgzuDmBi+U5FbcsZqfjupKvzc4gbJgs/hcydha6bFzi5j1o5gZ5Xx/xoVuFEtRD5SLZOHje5kN3Uh0gUlcFSv/3tAPn4s1Cei7D+yx6I4e1hY2oniQp55bOxZmeQr9toQhKHZvGAjNWb12sYfuuOy4KASzlfkgnhBQY8RBueqhhtNodEez1xEjp0an1URnQOdj1XIN831hjVMumlkEdH15h2DO4VIlSAPa6sp2AKYY4KxwEL3hMHbDZGK1C2f/44JRNfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2RiDXPNYALdkAA+vKQtgNlMW6GjJbtLl3n0btzjV0I=;
 b=Lur3qvgn7tQaxUi7U87RvM9TCz91JlZ01B0kdgEdU8z6Rer2NUNnG61cDi7gutwrmo2N+gE+JkW6unGmlYLlnephtc5A0YqPMThRC782A0xY8Akul4jo/8XqpqSHtE3AdPUbiRTEa+ZGev21jxI7PBak7KftOtGgctr0eJgeMDb9UIGodYoRBlLDpY5pnE/NxHXgsyBHYIFa5EG6lguzIFjFFv40MHc75PJoTzUr9EYcQi0psAk4BJ1Ht4MKA4nkZh77baE0qb+OddyraZJqrrgvNwJe9guDSHTwQRm1cbw0xAvSGrOjGAZAgGba0bOEhDp0eCfZCxa5+p2jWkJagg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2RiDXPNYALdkAA+vKQtgNlMW6GjJbtLl3n0btzjV0I=;
 b=RqVGdqJkTqXmgwxAQ0hd2tpld7d19LyVRWUIa2f5LKZLMSnobHJsUcHAA5geWiqB/a53GL3Gs+aYd4CjsrOEPtXeHrVQ8RkX2R8ZTTQe2BsQbelYae/0yoK3Cl087S1J217fn6NcCBxhP2yA78tCb87dwjavQHjjXmfEcq6bgMcjKlS4qKyMx6M4iDZROUSRh1p/ECXAdb3UCBmlYFrLzmu/HFtyqZfXw2S6KKWStzljsoN/djPefIijp2k2kKR0OsUsX0eQam/CQNRO1MuGDudgQE/BqX1YP2B9J33Yj1GQz1PoY+Gi+g/0NE4TcbFkXNkbXoeBtlze6mS7MhVTbA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:51 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:51 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:40 +1100
Subject: [PATCH v2 05/23] dma-buf: Route SGT related actions through the
 attachment's mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-5-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=3184;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=xEyB6/yAemJWVnakwhulhM0TZJ4KFTrVGJbQnB07EBw=;
 b=LoXTVhhNReV0IVmUBdMVbwWyRNZj9e2H0XeBvWHMGFjD0DGZg0p7LTiYwtGkXQ4Zmdkr75B/m
 lVBdOUv88H0AVujm9Qjbpa6TP8boykyqpv26R6offXGUrwkbrTME+qE
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0005.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::13) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|CH1PR12MB9573:EE_
X-MS-Office365-Filtering-Correlation-Id: cf9ecf82-9a58-4151-237a-08df3b07dfd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261022075727099003|11063799006|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	VyDpoh82YUxyumulcRnxW8fWi6c0/PDSr0jiony3hSc+pnK/IW1rL55mDg3Z1JZRBRuMJneSX45TuXWbyEdbfoC222rcKZ101cP1yr/MsA6o3Kk53FqyFScdaBpM0HDEDEt0fvLTJppyfs3TbRpO3C/ZBm4SFSGcUEqp61X7wzhA7SvTPK7WLwqjQ9MYgbLOumr/XIltgumks7Uz/DpDA82jLDu3HSkT847Wn6XNz4Fk5AARgWb6iwVXljlf10sJRhdz2KFLuj7emOkXfI/UsYoCo13MHPkNNLIow/ukh40iXWwIVpX7U0vnkujQ2SlOPtgK5THIHfkzF+O2vG0lQTlDWqTmtho6I1nXzOKbJpcAnXz9Puga2ATosZ87TRxbaJNEx6c89KjL1K055U9GP6Zxlz0biKXKl88YmXYPGX03sMk4XiYTQROpApM6uOfRcw/ov0g+UdmZfoXsw1QleWkz6ir3jUTMdRjTJGRfYL2mNObbte5SCAN3pgcuYrcyDBaKtXzeIRCq2/HmoZE2D0t8Jal5qJSYaY8Sr56Cf32OXQJtUiKuEMdkmFmVRn4rMHQirxItixxjuEsLAOhVSUqxyTk2ugxkbXqTM+KRL+ApjBrjLtqh7PpoZjvOve1l1iV+W3CUJCAS8j9kokFwgk4j9hYovSWVtScYwOmSQMhDeHsCrLP/5Eff1J8hUlISmqZ1RnvbNN4h+SSV/B7SKw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261022075727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkF4MlF2VmVoWGJVY0NtejgyS0c5K2tvWEl6WmVNbFNSOUxlMmErQi9tZ1hh?=
 =?utf-8?B?cnVPUU9TRVZXTWp3SUZCRUNYcC9qZEVmQ2pBS3Z3SDlxYlZrb21mcFVUMm43?=
 =?utf-8?B?N2RiUnFMd2xXNTBVU3hnbHAxdDFmQkxlMmowMXR2MXZHbngwMDRCTUdxQWxP?=
 =?utf-8?B?YzN5U2NGaFpuVkVKVjFkSk81Mi9QWGcvbFN4OVVaMGFIcEtEVUtxeGxyU2dL?=
 =?utf-8?B?SjNoWThNSitpQWpFNVoyTk1sS1hWNUswQkpwc0VzQUZYZVVyUExhQmtTTm5q?=
 =?utf-8?B?LytjbjVoQ0x0ek1EeVVNZ1owakYzTXZ2bDBhNG15OHZpbmFROVZ2TEwwcTln?=
 =?utf-8?B?UjVqaXlHVzJRL0ZiZDZHdTZ5d1lvSUgxQThLR3RUdGVTd2llblozNEtia25t?=
 =?utf-8?B?aDJSUTVyQlhpUjF0Q0hkT3liejlOS0R2L0lQREdiMUxNMDMzMEtXZjZldUJz?=
 =?utf-8?B?OVF6N3hUOFd0cG1mb2hQQUVKK3RHNU9VeGw2L1RLNmtLc25mcGlBTy9YNVhw?=
 =?utf-8?B?a2g5Z1BXdzlHQ0dlQmthSHdHQjU1d0ZQS1l5SG56UmwvZWU4bk12aDZneFhR?=
 =?utf-8?B?eis5M2JkYldYcHVQMzM1ZSszenVHMlJDTEZmdlNZTjJWQklJVlcvQmF5bk1H?=
 =?utf-8?B?TTFNQSt0RE1Zc0JTNEgvVk9idEdJSmRCckN1QVNieit2d1hWeVh5MFdzdkZo?=
 =?utf-8?B?TzQ0b1dIbWgyTk5YcS9Ra2UwU09sZTZMSVpQTTl5aW5lY2hMcHBDUHI2b3cw?=
 =?utf-8?B?a0Z0L0lNa1UvOGxEdzBVSm9MZVZzRkthU0FJbmVzb1diZnB1T3R0L1lPYmNq?=
 =?utf-8?B?QkUyTzFsTmcwb2Y2TWhjM1JwWWVRODdReU5qL0k4TDBnYjcwQ2E4V1N3bGRP?=
 =?utf-8?B?S29BSkRWU01CUXlxL3ExZXRyVlFnSTFINE1aUVJzUzVrUGxEVk5SL09UUUpE?=
 =?utf-8?B?SmVYc0lYemo4a0lmZnFYR1RFRmJOSlFKOGdEYzZ6akJKS3QzZHFESUMwYVpO?=
 =?utf-8?B?TlhqWVBMRGZza0pPRXdKY0hQazJDRHRZM05UNUEvQ0ord01maUgzQVhBNHRT?=
 =?utf-8?B?c20xVXdaZWlVcHBvNzdtbHZwNVA0YTE1anlGeVY3MmE3ck1qN1U2MUJzclFa?=
 =?utf-8?B?N2VkSnNuMVVMUlIyMTVnekZqRjVGanhkSGd2a3htSXB4Wkh0cFlnTGxENnds?=
 =?utf-8?B?Q1hTV0dSREZoNjBYeVZwWGFKemF5ZlorbTdMaUFCRnd6eTY3SGZiYWtIT1RO?=
 =?utf-8?B?SnpZSnVKdzdKQ2RwSnBLT1VSZWNpd1IzNlM5Q2h1WGdtZTdwU2xiVjFJc1RR?=
 =?utf-8?B?RFIrOTU1Uml1T25xMkxwd3pwMnVrNHBTa0RVeEVqaXcyczEraDNVTE1wWWMy?=
 =?utf-8?B?WC91alZnV3FhWHBuTXN0emVSSzJrRTVGZDlPdlRBbCszbHhvWGo2QkFteEdE?=
 =?utf-8?B?ODhXU0ErK3h1ejZjaUxXaEwrQzM3NTBGQTBjNEFPVmRSZkRtakdEd2hnVWRZ?=
 =?utf-8?B?Q2pBWXh2WU9LN3NjT05CcUNFS2tFZ1JuVGhOZ1REeVR4NE5YNngreUFZMTFm?=
 =?utf-8?B?TVFRNmhXKzF3QXZ2OTdmOFc5OGdVT2s3U2Y4OUVGT1VpRFVxeUxydURvTEww?=
 =?utf-8?B?WVFYblJteGY0c2IySVFiRFFhaEhIYWEwYTNOV0k0L0U2Q1QwcWNnZlN4T2F3?=
 =?utf-8?B?MnVYWVVrSGhVQkd6OUk1eUR3eEZXdjFSeExscEgvNWU0RkFSZjVVNWJKaXFF?=
 =?utf-8?B?bitKaVhMcEUzbFBRNmNISC94Vlk1b0tSeFJXNlp3NVpydWd6TGdEclkwb1FC?=
 =?utf-8?B?T0g5cUtSc0lYaGQzaEJvMXk1d0ZkdFVrOVdrVXoxRWZ3RGpIeEJIZEU3cnBq?=
 =?utf-8?B?NGVzY1hWTHpKWFFoZkorWVJDa1pERG1ET3JYSGNBdW5aeEltcXBCdjNuSjB5?=
 =?utf-8?B?bllKUEZVWit4Z29kQ2pnNFMzSFFIMmlEUkRlZ3cyZ3A3ZWtZeDF4Z3ZBblM4?=
 =?utf-8?B?SmUrWUNIZWh5bmJRQUZWY3QzSlFldlpzZjNrTkhIZ01IRlY1aG9BOXdHUnk3?=
 =?utf-8?B?MFBCWjdJcWh1Sis4Z2xJeUlQc25qeTlOQmVWTVBzbDB0NTJud20rWEVtRi9q?=
 =?utf-8?B?WUU2dDFvdWtjWlZrZ0k3YWp6UVlWSWVaempkeDJLZ1RYZTV0TEFVSnk2NDlh?=
 =?utf-8?B?SFhNODdDYWl3enJGQ281L1NVTkh4QjZFNzBqK3NpT2ZnUm9JUDNXZllTTHRU?=
 =?utf-8?B?Uk52SDN2WEpXYVRCNHVEeHVUVlZpTi9zRDJsRWZ3UmJtV2t5VjJKd2NhdWlX?=
 =?utf-8?B?NmdWT3Q5RDlTaUtQaytVWVNvd3JyYWQxQS8yR2JIWmZ4MXpxMXhKZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9ecf82-9a58-4151-237a-08df3b07dfd0
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:51.6179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +p5+bsKeR9G5zdpu5nChhUO7h9a9p5bAoSl30j+r1JvsYawQP6Zpam8NMwCiFtBKOtLaVzDZJVOsQFtYZWbFxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

Now that dma_buf_dynamic_attach() ensures a mapping type exists, even for
exporters and importers that don't provide it, route operations through
dma_buf_attach_map_type().

For map/unmap this will go through dma_buf_sgt_compat_map_dma_buf() which
calls the same attach->dmabuf->ops->map_dma_buf().

Move the debugfs processing unique to SGT into a callback too.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 1913a84d3363..b3d1f0f863a5 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1240,12 +1240,14 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
 struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 				 enum dma_data_direction direction)
 {
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
 	struct sg_table *sg_table;
 	signed long ret;
 
 	might_sleep();
 
-	if (WARN_ON(!attach || !attach->dmabuf))
+	if (WARN_ON(!attach || !attach->dmabuf || !sgt_exp_ops))
 		return ERR_PTR(-EINVAL);
 
 	dma_resv_assert_held(attach->dmabuf->resv);
@@ -1261,7 +1263,7 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 			return ERR_PTR(ret);
 	}
 
-	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
+	sg_table = sgt_exp_ops->map_dma_buf(attach, direction);
 	if (!sg_table)
 		sg_table = ERR_PTR(-ENOMEM);
 	if (IS_ERR(sg_table))
@@ -1300,7 +1302,7 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 	return sg_table;
 
 error_unmap:
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table, direction);
+	sgt_exp_ops->unmap_dma_buf(attach, sg_table, direction);
 	sg_table = ERR_PTR(ret);
 
 error_unpin:
@@ -1353,15 +1355,21 @@ void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
 				enum dma_data_direction direction)
 {
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops;
+
 	might_sleep();
 
 	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
 		return;
 
+	sgt_exp_ops = dma_buf_get_sgt_ops(attach);
+	if (WARN_ON(!sgt_exp_ops))
+		return;
+
 	dma_resv_assert_held(attach->dmabuf->resv);
 
 	dma_buf_unwrap_sg_table(&sg_table);
-	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table, direction);
+	sgt_exp_ops->unmap_dma_buf(attach, sg_table, direction);
 
 	if (dma_buf_pin_on_map(attach))
 		attach->dmabuf->ops->unpin(attach);
@@ -1842,7 +1850,13 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		attach_count = 0;
 
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_printf(s, "\t%s\n", dev_name(attach_obj->dev));
+			const struct dma_buf_mapping_type *type =
+				dma_buf_attach_map_type(attach_obj)->type;
+
+			seq_printf(s, "\t%s:", type->name);
+			if (type->debugfs_dump)
+				type->debugfs_dump(s, attach_obj);
+			seq_putc(s, '\n');
 			attach_count++;
 		}
 		dma_resv_unlock(buf_obj->resv);

-- 
2.54.0

