Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154216;
	b=spv/hRP4w79t4MmVkB1Z/ejDHck0Sx4ExhtMM8COkMXpP8eQiBvgjQZfFJ+9wvcIfrOF
	 kT50H1M5gAH0zfAgT4s3+cWrcgMlWp4OUYojuDH0TQZQ6uuIzz/myFbOwropb4y0Lwtvc
	 OeSjOQio42F8XFpbenJ5JuBuuHjs6pRDbsFE6B5AqVhjlCXsnvJa0JMAKQ0eKLLw9JFhs
	 nWj2lxx9cxh5SDDvplipJ+7tVDb/ASFrKjJ8jVoGAYQiWgksWT/mL0Cmbh0j1HJMQZAA+
	 c5X2prV6/dYP6xAd7qxxy5Hm171T28plFACi4UERGyXY5N+1nNS/3HFoJpANI/EmlhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154216;
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
	bh=vTrtYYnZHKo1HxsLTxhcrPxtyKPpYu+TzYTN2jo9BCE=;
	b=CUZCRoBJoeYuwVNu3ag7v33raHEXxKVmY1D0yqeBh/JWUCcIvMGOeMKteGm+HWuoqc93
	 IC/pli06gGSykmhAvikEDXTkAZ/P6MZflGrhla/jYAiecIwwUh7SMlU02aWzlDp0ukdFc
	 4Z+axtnAiGlJ7xD+VaXQaAL8WtxbnV0ZM8pFQqpgHmbc+PFENcBJOaSCTgWa7oP9XZ2ue
	 lw5QvnH5L5zs3pcPLTMOk+nDM+S0aVfZXsQtrX6PT4YWvlNfkAaAOfP8o9kY6TE16sz9i
	 /ttQs3iMTKV5yJgXxiHCnj0NS7GxtQpy8dNyKj9oWoYMexqCczEZhhWgOb6jeqX8FxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="DY/Obedw";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.46
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011046.outbound.protection.outlook.com [52.101.52.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA9606A332;
	Fri, 20 Nov 2026 05:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BAA9606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DY/Obedw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ckmh1cFg3HB4jaW76bvbZ2I0Km216nVaq22LihiTrOybX6+e4+oEOOrlafF51xj8okzrdm79Oa3j33aKsiClxD3kA37yscRhQHG2xSwmXAi/hhI+2dAsEG3K/Bikp9XxPd76CzNWLPsDERQrlAMs6o9ag1MBFupQckuvqjEzRN3+WD7A9l9WehrZ1RO5lkTUe9ZAs1lcpcROZT/RuLAta1Rq0+hxhKUE+/TDyZydw31leW+jfOrKcQz0uFnwwo/p5L3XNl3j1lI5J3rfYNVMPcfMJC1u6WwKJH0QiYCGXroFITsyCsdXWm9qiubt3rkR1Crfo2Vtuv3Ci1WJI40v+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTrtYYnZHKo1HxsLTxhcrPxtyKPpYu+TzYTN2jo9BCE=;
 b=DNSOt6XSjgZsD5f3+AuqjVExgN2I0GxIA3nCwqT3Itr+I5mshxwACDNMwA3OPQHRW7UJhsGp9G+atlOT4X5TJwiwU+VSo1qJmj7GBTLNWN/+6WCcqH2Fc3CqOWCVne4uQpjVcK6VqfyBAFOibdaSlgyEiCd/NK+/7TOQ4sike1bms/5R7EUcs5a+MKEeqWZ/sj4Ahv753AiX1jLxWxJYPXC/zNTU5h9nKQ5GGuLDXLsProX7O2fSEFhy7KY3WbktIt+e+KfBtzFtyBQkcb0Iaqwe32UOXqP8i6zgj9TtCed9dzjyzy8qfibCPnhoOipn1njj4L4nAQmRUh8qcyzohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTrtYYnZHKo1HxsLTxhcrPxtyKPpYu+TzYTN2jo9BCE=;
 b=DY/ObedwKb+f/2bzJ7HBRm8Q8hTCBzQNxaC5HybkSE4cBxwJ1+CynwU+IEQiP0JUtmvM1ZfBmXeOIFG4SKxCW5t8w57zZWh32nVJRPdvYbLTcYzIcBCuQS9p79owtyUWNR1Db+ttDwB6t+K6auykcK6ix/vO8e+s2JzxLQrkEvtwqOgcOTAieYY3Q/f1ZWkzKguKQ0xSMiSRQh6oNM5iu33ZA9XLYVDoIaN7z28NUfa48l1mbjPt0JkIbno7X9McC3wtlbp55nyW3wItqDm0yhonMPxAOeQfaujxoXMNzkcwSee9a2qcQgKiXr5X3BWyfAvHgtgstOXYHMxkZnpCkw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:56:46 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:56:46 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:41 +1100
Subject: [PATCH v3 03/24] dma-buf: Add the SGT DMA mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-3-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=12253;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=80JRLSS43VjwQXNk4n1FCCY55eCEjIMwIjSr24cE1Dw=;
 b=Tb4vTbT5NV0elK8wcOYf7m7wesgbRfLWJTyQxHDkdJo17uT/zina7ot+VVaYJUzLijHzOR47s
 RBIGhflwuGuAzKMPU0KSrMo+e7dpUmoZPzt7P0H+OdyVTfGIfKaWd6i
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::11) To DS4PR12MB634945.namprd12.prod.outlook.com
 (2603:10b6:8:514::7)
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
X-MS-Office365-Filtering-Correlation-Id: b883466f-37a3-4cf4-f623-08df46cb0f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	2/QH2xQUhQVfAxAvvAkRLEaoVrQaZBqGFAMWwi8mmV8T2yAfLtkCFm5/n5MFHo7wAtdFPCRDpuscaVb7xJ9yL7qaOJBS2OLjRPGzTA1VlmDiROZsJLNWEzw8rXuCa7NPxexAORMt0a13FxU6jTcFy50bkX+yI1JQQNpSvFUYFK6XscSPJ94Zz0MVTwtQ2a32bqi1k0BpyQ/sF/bnzB1yGyYTvP8HW3zZRYPeD7jCNn1dJp5XSBN8K3UgLoqoj4pxcZPWJHbHYouZ104rkq9iZQ0AfVYZx2/L35fQnSiuxPmgZkSCpJkQEvJdCgOYdLKKo0chATyeAAMQgr4i6dwFvmXXCyWq548zMxo21O58nwf8njTPmMO80gPivKg2UFsDYkYfWBKSwrUmOslr0obo2nZRpq6whBaJ7kQFmRxbu1YwcIZrrGxaE2Pm8uSkvh3WK3gqCNVqPN1XbuOQTUCdUA7O69Hzutj7yXHPtp6MmM11zm3mWzPv0276Ol6R7KIKF23ZTPWkPfigQ3VaHzz93sA6FBIUyxKNbqBTPE54GFKF6zgvk0Oc4gvUQ+Cfxm3yexMrPr+6De3wj/CEOrxnMYjjYjsRSj6boxAHb3MGi2phiuGo8Rt6oGPNP4V/rsH5TDLY62JCEc3OiB5QUiPG6D9ZYuJ/9LoUqWRVuFB+HdYD+89CbWyYInG9GuUf6vcVtMOn1rtGoXQnFzOHE33SRw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b2J6Q2orUVlVZC9ycExOOGpHMDN2ODY5dWRBZkpxbldraytCeEYwUlNyeVZG?=
 =?utf-8?B?TkdUVUhLcnhVSi9wSXBxMnNmTGg1WTk3ZlVQVXZjYWJCY2crQ1ErQ1pXaVZP?=
 =?utf-8?B?ZEE3andvRjZvdGpFaG10c0M3WGQ0eXdpbmYwMUNiS1k4WlRSSTFGY0VsUTBX?=
 =?utf-8?B?dlp6YlRoMDRMb0dQcDJXcVRZWUNOY1RDVkZlQUpGYjEyczQ5TDM4dkRKOGwv?=
 =?utf-8?B?K0p5cGJUQW0vbjRDZDVYc0ZFajZHUnhiZmZrWk9VNzhHcWZ3aWpGRnJvMlFW?=
 =?utf-8?B?K2luNTQxTEpHTnVPOGovWCtvcVlGMzVWZGd1RmVMdk5VUmtaeHJHdEpJeHk0?=
 =?utf-8?B?eFJNdGdQVVJPZkR3K05GM1dXdW4vYTg5b2pXSWxpUmp4eStXOXA1MjU4UkQ1?=
 =?utf-8?B?QUlQQmhBdHZtaElZZVNrcWR0NktsKzJQeVRPSXZjc09MYkJLVG1xRFpMb09P?=
 =?utf-8?B?NWJzejRoQS9TNFBWODdvaXF1OWhCSGRReGFLZ1QwcDA4VXF1WGpObXhWaTEx?=
 =?utf-8?B?Nm9EZWhqc3E4a2IrRG9uczB6M1UzTWZOTmplTnJacTJnQVFTSk94ZnBKZUwr?=
 =?utf-8?B?ek4ycUhZUS8zalgxd1MrcnFUYXlnU0hPVkhNRlVEb2kwMzFZc283SkxtY1FU?=
 =?utf-8?B?VVltKzdnbzRGb1Rjak1PbUEvT21JYVVrckNnWDJmR3pJV2l3T2plWWhnSlZ2?=
 =?utf-8?B?N2wrb3Rud0JBV2wxanhMR0dtdVY2SWx5SjNZczlJL0NFNjQ5VW9pWEpubngz?=
 =?utf-8?B?QjROSDh5Ymd5T0d6dzNFMXR2SXo0Qm1JUjI2U1piV3ZWRjcvTkhZQm5HZkYr?=
 =?utf-8?B?L1pndkw5MnZRdDh6dW9BVjJPK3k1MDU0aCtmOTdNMXJnbUZDanozaXJlTGxa?=
 =?utf-8?B?WVpIL0xLMlN3ZkpWbVZkV1hMSzZqOHluZGwrbi8rOFZWRS9RN2QwZFZNNWtL?=
 =?utf-8?B?dVhxNjZnQXd3ajc4RUpmZkZkNzc5WFZUbnFBaEcvYWk5Y1phTEFyNmFiTVNZ?=
 =?utf-8?B?WG1NRU5PVU16RlI4bU5XcFU3TU1HYWt5VXJyeTJhYkhoWk5UOFJGeFBBaDI2?=
 =?utf-8?B?WkZ1QUVRdGJSaVM4YStLUmJOd1E3eDdybEdCeXVaOTlUblo5U21KUUl2VmFj?=
 =?utf-8?B?NVN5UjdNQUFNVTBEU0I5QTlQWERpci9qeGRpNjkyMVhWNGNyVys3R2hwdXpQ?=
 =?utf-8?B?SGVXSGJJV1dURDMyRWl3RmFSNUhqSyszVnAzYnp1MllRNE43NkhjUnRjV3lT?=
 =?utf-8?B?aEdLeVhnenFyVTk0NENMU1I3dVl5RXRuNXloZU4yMlhVWS84TitmYkZBQWFT?=
 =?utf-8?B?aGtxVmhsUnR3VmlTenFLSGpBNGc3bGVVRlRjY09YWURkYVh1NVl3RHFnbnZu?=
 =?utf-8?B?Z0hCRmRZb253cmI0ODJ1REh4UGpCYm53VnUySWVZd3lwaUx2RnBxMGRVV2Fa?=
 =?utf-8?B?R0tab0RjUnA4NjFaaFVQVDFpREEyZDNBNkpjZXhyK1NITlhVMjY2UUI4Q1Js?=
 =?utf-8?B?d2paWi9TUTdZL05KZG5vNy8ydUNjdmZrVmhPdnhJdTB3V0lyYVdJeHdWK3Bn?=
 =?utf-8?B?LzNYUlQ0bDR4dDVqamhOWmFzcUp6aDdaTUhtVk5nMTN3QkxGdms0R2pjdWZZ?=
 =?utf-8?B?UkFKRnhFdWRMSjk0OGk5VTFFSGtvWXBxTldsTGxjTEkxZnJVL2tMRVJaL2xV?=
 =?utf-8?B?OFF1MUNiTzIxOWVpeGFmbzlocjFoTVkzV0xEbkZyclIwY3FDaEhHQlZoMldu?=
 =?utf-8?B?OVBSd21hTW1PQjRaN21rcjNyK1JpTzNlem15RlJzV2lubTZ0NVcrc1huV0FM?=
 =?utf-8?B?UDAwZVdzVzBtTTY1VjZlVXdtQ09aNE9qekdKdVZHTlVJMXRQUDBiSm1zQzh1?=
 =?utf-8?B?Y2FQd0xULytYdHBQNWpVUXhXSnN0UCs5ZWI2LzNLWVdxd3R4YmM1S28wYWxO?=
 =?utf-8?B?bDhSNXp3eW5XWGsrYVB6WXE3YVFFdEZLTjI3VlIvZzhwMVN3N09ndHV5VjdC?=
 =?utf-8?B?OXpabzFIQ1JBeEtFVWhUVVVRMWdIbW1kUGRsbzE2WTlFcTREV0hRaExPMlRk?=
 =?utf-8?B?Q2gvK0NpNFBLVlJaQ0gzTFlNV2JUcklOTUtKYVBhRFpac3NBcUtSSnAyd2VI?=
 =?utf-8?B?cWNFVVFjeWZOODd6SVhOQkFZNEEvd3kwL2NpWDIvSW8rdzhHZjZpVHU5SDIz?=
 =?utf-8?B?Z29KLzVEZkV3U3JnRFR1QnlZZmFsL0s1SmFxTlZRLzB4YXdRRnBhSTBtd29H?=
 =?utf-8?B?OHZGQkN1YlE1eU5KdVZNK3ovcjNWREVmd3owN3BvS2FFY3lIekNRWFREWWU3?=
 =?utf-8?B?dVV0a3ZmVXRqNDVlTjFKdjRSemFpZEwxV1dCcjA2Zm1rTHl4K3duZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b883466f-37a3-4cf4-f623-08df46cb0f28
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB634945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:56:46.4563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V62Pnoul7BJMwaY9lGXrZtN1rfUjHo4E9HtCGGboebRE0rmDmYNVx1xoE3HHre29NB1OIAGOSjkGZXExJbsN/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

From: Jason Gunthorpe <jgg@nvidia.com>

The SGT (Scatter Gather Table) DMA mapping type represents the existing
sg_table/scatterlist based DMA mapping. For now it continues to use a
sg_table for map/unmap, but this will allow a future patch series to
convert to using a different data structure for importers without having
to convert all at once.

dma_buf_sgt_compat_match_mapping() is used during the conversion of
exporters to transparently wrap an unaware exporter's sg_table. It is
removed later in this series once all exporters have been converted.

A mapping is an object allocated by an exporter which embeds the generic
struct dma_buf_mapping type header which core dma-buf code fills in. For
the SGT type that is currently a struct dma_buf_sgt_mapping embedding a
struct sg_table.

Importers continue to receive a struct sg_table from dma_buf_map_sgt()
and are unaffected. A future series will convert the embedded sg_table
into a list of DMA addresses more appropriate for importers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

Changes for v3:

 - PCIe P2P will be added as its own type in future, so dropped the P2P
   flags from the SGT type.
 - Exporters allocate and return struct dma_buf_sgt_mapping with the
   sg_table embedded instead of a bare struct sg_table. This ensures
   an unmap happens against the correct type once multiple mapping types
   are possible.
---
 drivers/dma-buf/dma-buf-mapping.c | 104 +++++++++++++++++++++++++++++
 include/linux/dma-buf-mapping.h   | 135 ++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h           |   6 +-
 3 files changed, 244 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index d27f02610c2a..cc3d8d6fe009 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -6,6 +6,7 @@
 #include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/dma-buf.h>
+#include <linux/seq_file.h>
 #include <linux/overflow.h>
 #include <linux/align.h>
 
@@ -322,3 +323,106 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
+
+static void
+dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
+			 const struct dma_buf_mapping_match *exp,
+			 const struct dma_buf_mapping_match *imp,
+			 struct dma_buf_mapping_match *match)
+{
+	struct dma_buf_attachment *attach = args->attach;
+
+	*match = (struct dma_buf_mapping_match) {
+		.type = &dma_buf_mapping_sgt_type,
+		.exp_ops = exp->exp_ops,
+		.sgt_data = {
+			.importing_dma_device = args->dev,
+		},
+	};
+
+	/*
+	 * Setup the SGT type variables stored in attach because importers and
+	 * exporters that do not natively use mappings expect them to be there.
+	 * When converting to use mappings users should use the match versions
+	 * of these instead.
+	 */
+	attach->dev = args->dev;
+}
+
+static void dma_buf_sgt_debugfs_dump(struct seq_file *s,
+				     struct dma_buf_attachment *attach)
+{
+	seq_printf(s, " %s", dev_name(dma_buf_sgt_dma_device(attach)));
+}
+
+const struct dma_buf_mapping_type dma_buf_mapping_sgt_type = {
+	.name = "DMA Mapped Scatter Gather Table",
+	.finish_match = dma_buf_sgt_finish_match,
+	.debugfs_dump = dma_buf_sgt_debugfs_dump,
+};
+EXPORT_SYMBOL_NS_GPL(dma_buf_mapping_sgt_type, "DMA_BUF");
+
+/* An unaware exporter's sg_table presented as an SGT mapping */
+struct dma_buf_sgt_compat_mapping {
+	struct dma_buf_sgt_mapping mapping;
+	struct sg_table *sgt;
+};
+
+static struct dma_buf_sgt_mapping *
+dma_buf_sgt_compat_map_dma_buf(struct dma_buf_attachment *attach,
+			       enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_compat_mapping *compat;
+	struct sg_table *sgt;
+
+	sgt = attach->dmabuf->ops->map_dma_buf(attach, dir);
+	if (!sgt)
+		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(sgt))
+		return ERR_CAST(sgt);
+
+	compat = kzalloc_obj(*compat);
+	if (!compat) {
+		attach->dmabuf->ops->unmap_dma_buf(attach, sgt, dir);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* The exporter keeps its table; the mapping shares its entries */
+	compat->sgt = sgt;
+	compat->mapping.sgt = *sgt;
+	return &compat->mapping;
+}
+
+static void dma_buf_sgt_compat_unmap_dma_buf(struct dma_buf_attachment *attach,
+					     struct dma_buf_sgt_mapping *mapping,
+					     enum dma_data_direction dir)
+{
+	struct dma_buf_sgt_compat_mapping *compat =
+		container_of(mapping, struct dma_buf_sgt_compat_mapping, mapping);
+
+	attach->dmabuf->ops->unmap_dma_buf(attach, compat->sgt, dir);
+	kfree(compat);
+}
+
+/* Route the classic map/unmap ops through the exp ops for old importers */
+static const struct dma_buf_mapping_sgt_exp_ops dma_buf_sgt_compat_exp_ops = {
+	.map_dma_buf = dma_buf_sgt_compat_map_dma_buf,
+	.unmap_dma_buf = dma_buf_sgt_compat_unmap_dma_buf,
+};
+
+/*
+ * This entry is used for unaware exporters that do not support
+ * match_mapping(). It wraps the dma_buf ops for SGT mappings into a mapping
+ * type so aware importers can transparently work with unaware exporters. This
+ * does not require p2p because old exporters will check it through the
+ * attach->peer2peer mechanism.
+ */
+static const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_matches[] = {
+	DMA_BUF_EMAPPING_SGT(&dma_buf_sgt_compat_exp_ops),
+};
+
+int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args)
+{
+	return dma_buf_match_mapping(args, dma_buf_sgt_exp_compat_matches,
+				     ARRAY_SIZE(dma_buf_sgt_exp_compat_matches));
+}
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index bb826bdc2911..8be03b4ba6cc 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -84,6 +84,30 @@ struct dma_buf_mapping_type {
 			     struct dma_buf_attachment *attach);
 };
 
+/**
+ * struct dma_buf_mapping - header of a mapping made through an attachment
+ * @match: The match set entry the mapping was made with
+ *
+ * A mapping is an object allocated by whoever produces it, the exporter for
+ * the SGT type, embedding this header. The core fills the header in once the
+ * producer's map callback has returned and reads it to tear the mapping down.
+ */
+struct dma_buf_mapping {
+	const struct dma_buf_mapping_match *match;
+};
+
+/**
+ * dma_buf_mapping_type_of - The type a mapping was made with
+ * @mapping: the mapping
+ *
+ * Returns: the type of the match set entry recorded in @mapping.
+ */
+static inline const struct dma_buf_mapping_type *
+dma_buf_mapping_type_of(const struct dma_buf_mapping *mapping)
+{
+	return mapping->match->type;
+}
+
 struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 					 struct p2pdma_provider *provider,
 					 struct phys_vec *phys_vec,
@@ -109,4 +133,115 @@ dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
 	return &attach->matches[0];
 }
 
+/*
+ * DMA Mapped Scatterlist Type
+ *
+ * When this type is matched the map/unmap functions are:
+ *
+ *  dma_buf_map_sgt()
+ *  dma_buf_unmap_sgt()
+ *
+ * The struct sg_table returned by those functions has only the DMA portions
+ * available. The caller must not try to use the struct page * information.
+ *
+ * importing_dma_device is the device passed to dma_buf_dynamic_attach(),
+ * recorded at match time, and is passed to the DMA API to provide the
+ * dma_addr_t's.
+ */
+extern const struct dma_buf_mapping_type dma_buf_mapping_sgt_type;
+
+/**
+ * struct dma_buf_sgt_mapping - A mapping of the SGT type
+ * @base: Common header, filled in by the core
+ * @sgt: The DMA mapped scatterlist, filled in by the exporter
+ *
+ * Allocated by the exporter's &dma_buf_mapping_sgt_exp_ops.map_dma_buf, which
+ * may embed it in a larger structure of its own, and released by its
+ * unmap_dma_buf. The core only fills in @base, with the same values for every
+ * map of an attachment, so an exporter that keeps one table per attachment
+ * may keep one of these per attachment and return it on every map. A mapping
+ * must not be shared between attachments. Importers are handed @sgt by
+ * dma_buf_map_sgt().
+ */
+struct dma_buf_sgt_mapping {
+	struct dma_buf_mapping base;
+	struct sg_table sgt;
+};
+
+/**
+ * struct dma_buf_mapping_sgt_exp_ops - Exporter ops of the SGT type
+ * @ops: Type tag
+ * @map_dma_buf: Produce a &struct dma_buf_sgt_mapping for @attach, with
+ *               &dma_buf_sgt_mapping.sgt mapped for the device returned by
+ *               dma_buf_sgt_dma_device(). Called with the dma_resv lock held.
+ *               Returns the mapping, or an ERR_PTR; NULL is taken as -ENOMEM.
+ * @unmap_dma_buf: Unmap and release a mapping returned by @map_dma_buf.
+ */
+struct dma_buf_mapping_sgt_exp_ops {
+	struct dma_buf_mapping_exp_ops ops;
+	struct dma_buf_sgt_mapping *(*map_dma_buf)(struct dma_buf_attachment *attach,
+						   enum dma_data_direction dir);
+	void (*unmap_dma_buf)(struct dma_buf_attachment *attach,
+			      struct dma_buf_sgt_mapping *mapping,
+			      enum dma_data_direction dir);
+};
+
+/**
+ * dma_buf_sgt_dma_device - Return the device to use for DMA mapping
+ * @attach: sgt mapping type attachment
+ *
+ * Called by the exporter to get the struct device to pass to the DMA API
+ * during the map callback. The unmap callback takes it from the mapping with
+ * dma_buf_sgt_mapping_dma_device().
+ *
+ * Returns: the importing device, or NULL if the attachment is not mapped with
+ * the SGT type.
+ */
+static inline struct device *
+dma_buf_sgt_dma_device(struct dma_buf_attachment *attach)
+{
+	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
+		return NULL;
+	return dma_buf_attach_map_type(attach)->sgt_data.importing_dma_device;
+}
+
+static inline const struct dma_buf_mapping_sgt_exp_ops *
+dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
+{
+	if (dma_buf_attach_map_type(attach)->type != &dma_buf_mapping_sgt_type)
+		return NULL;
+	return container_of(dma_buf_attach_map_type(attach)->exp_ops,
+			    struct dma_buf_mapping_sgt_exp_ops, ops);
+}
+
+/**
+ * dma_buf_sgt_mapping_dma_device - Return the device a mapping was made for
+ * @mapping: the mapping passed to the exporter's unmap callback
+ *
+ * Called by the exporter to get the struct device to pass to the DMA API
+ * during the unmap callback. It comes from the match set entry recorded in
+ * the mapping, so it is the device the mapping was DMA mapped for whatever
+ * the attachment is mapped with by the time of the unmap.
+ *
+ * Returns: the device the mapping was DMA mapped for.
+ */
+static inline struct device *
+dma_buf_sgt_mapping_dma_device(const struct dma_buf_sgt_mapping *mapping)
+{
+	return mapping->base.match->sgt_data.importing_dma_device;
+}
+
+/*
+ * Importer SGT entry. Usable in a static table: the importing device is
+ * supplied by dma_buf_dynamic_attach() and recorded in the matched entry.
+ */
+#define DMA_BUF_IMAPPING_SGT()                                              \
+	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type })
+#define DMA_BUF_EMAPPING_SGT(_exp_ops)                                      \
+	((struct dma_buf_mapping_match){ .type = &dma_buf_mapping_sgt_type, \
+					 .exp_ops = &((_exp_ops)->ops) })
+
+/* Match on behalf of an exporter that has no match_mapping() */
+int dma_buf_sgt_compat_match_mapping(struct dma_buf_match_args *args);
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 81bbcd420d60..6b423e22174a 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -46,7 +46,11 @@ struct dma_buf_mapping_match {
 	const struct dma_buf_mapping_type *type;
 	const struct dma_buf_mapping_exp_ops *exp_ops;
 	union {
-		/* Each mapping_type has unique match parameters here */
+		/* For dma_buf_mapping_sgt_type */
+		struct {
+			/* Filled from the attaching device, not by importers */
+			struct device *importing_dma_device;
+		} sgt_data;
 	};
 };
 

-- 
2.54.0

