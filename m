Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860953;
	b=b1M2+nhtxEaWvOtEPRjkMSWlhByxN18lkvQivPmpgbK0oEWHsSp2aDXZdK5zPRCwOKhi
	 XhKtxdaL8XD1SuBI0u9gFakEX1bYgxD0XEZmomEIVKnaTk0+QVQd3D95bRgdMcW3eSPYX
	 fnL5MGCw0NBy92jxumSHKZheAycZplOWJuG1PXDFXTwWFDjRNxH0Xd12HExvKEUrMalyf
	 OI9VqSEfg0MZ9XhyZxw1CQ4VKHCG4Olco4j6vpFkCvGY2G8Gt28Lf7LiYZgHOPOwAGje8
	 BasiRSJVy5mFN3bLV0MXr2HaZGaHbti7wIphYjthuLdI8OYGTnDdOqMQcnmWLPgmvBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860953;
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
	bh=cZ2rUVqunrZ4/kGFOGkC51vIX7QxtZEXyOoofOGegRQ=;
	b=zsfs3DxNd8UgPDLxYtXGv3+4RozogQHQtJGv9++FJVeTo5aOOLm7QrcnUH+lGLxDMV6i
	 cUZre3b/6mcA/k0VIZcYYi6tewkYqgy0sWJZdMu3OGmiG1/cL+O2RDzsQ1Lm05x+Ehy30
	 N7k671QNlx5s0hZV8awuOZYt0nReMU+elw1R2Y4hcRKN+h9P9gyNzPYRzBBJUwkrFEEFM
	 iQvGtqWlSjQL7UbY5OXAuKyFj8tNdJm8WMXkozmxQoK4N9Sjum8O6umRYU37PO9w5F/AS
	 aIFZif2lnl6kN1iyBn0qScWUoW9QUCeJzsB9lDNs1eUaBS+OteUJqHLPfABFsfn+WqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SkZqgApN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.7
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A3E606A330;
	Thu,  5 Nov 2026 06:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30A3E606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=SkZqgApN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gThBOPv0MDQAfTC0Mpc3qfSbx/nvTS49J3qTba9IN0pVFvRjV5ueols4XJjiEgNUOuf+9cJXIKEn95isc4SMradUDy0q5Eval2Lc/KeSGNyYLH/8PMHt55FSxpckZdkixbRygRczZ2WIRzhybOnKQ6FYFQeHH7JqrgU+6KANHsBwTBt48rWMXJ3Eo1XsTHHTG05q3GMOcXfdaZsWk5QlDe3VVG8kD3Q/tyqUG3snSiN6W/w8K0Hr9NP2eFHTb5ven1RgYXJvL33Mh7MWH2/Loma5OifYniJO3Np12d2dSBwsIMzn1iIcble3EFudQgsAtL3nXSpv2mPw4jRufA5jcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZ2rUVqunrZ4/kGFOGkC51vIX7QxtZEXyOoofOGegRQ=;
 b=hF/RjDl67zfyXmcWsajfxnydUZFqdcSLgF7DNfhuNc9Z3xiI+Yx+Lq3uQZftvyWMXYS7NppWFQdf8YDkZ+u4HtvYWZH+5oh3J5aL/IYfmhv1btAy4XgyQ8k4Z+Ukn+yQg0WGUy4crWKJcRUTJnF8uys2m408W1Smjw957X2zvHnPDPwdqYSoJHkB9x0Sa8SZyh4KlmWW3YsuXOHeER6j0P4wRpUrc2IgeW/eLtTx6atULT76Mv8r0LbDk8uJ/UFtA4DEZXbG2CDgx+gBtwnzzafLNF/wfSwDhyY5ZgpXPAKDhPXy2A/ZexxhtII8zL/zOro43zOexJROIW3TQGgNDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZ2rUVqunrZ4/kGFOGkC51vIX7QxtZEXyOoofOGegRQ=;
 b=SkZqgApNTooVyr/qAzqGap0pvepzhXxJo2OD8oujxS8lkXaGh6ZE/mZUpRlyHA+1CHp7PKfUs/v8OEjzZz/rxfI8hfwFCSuT72trVGPMSaHh5UK9IZEogOltKeMV0sx3bN5oF4qEppWxqv4HgsxE8QaUBcvU46knQ0I0e+GHjR17QXn+9rPUK0nfzQdYl506Y73JyC5WOaoVdH1I/lFmY70MqG98xnQEBt0HUfHiL6CgPUtT8R0x98DyhsFbjfB892utfAlbNZjaBcdseFae4UJwI9nytp0fX4m8f/7d6zu8cczZKwKAhxdx5h7dDKnB2dA0pjDP1IJJ6iX/Hs9x+g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:42:10 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:10 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:44 +1100
Subject: [PATCH v2 09/23] dma-buf: Allow single exporter drivers to avoid
 the match_mapping function
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-9-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=3849;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=2UfxhqUk3K+Bb5Hx7vQja5KGKd21rn9RjSIozboHA3U=;
 b=8joLTlbKJbrf/mpe9so8HzS8W0f/bRRDI8jPm33sR4FRHbW1pqVURBz5ySWO8CLOh0NPJ/5iz
 jrthFaOElj8ARWFWsG9imwG8pgZEvGGRE6PJr6AcFIg8lqGFhKYtR3i
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P300CA0042.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fd::13) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: c274c9ff-d17a-49cd-33c7-08df3b07eb25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261022075727099003|261022113327099003|261021130227099003|11063799006|56012099006|261021135927099003|261022115727099003|261009223027099003|261026121527099003|261026130827099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	y3/U3uzdTZNvVuCFEC+ITjwqOKEfDjP81ZHM4gb5Nr4lLqVn3GOpe/X3bWV5kbKoRbCW7z/MaNPqkbbrgUdPYS4LMZQkfn0FrCY4YnJtS/J1/a026QniCIxsqlQWefChnUySes/rK3Rq6x+vVqrd9bDhqrI6X4lBCEKBrXPXvJ5UOIrAZKF+igjwNeCplbq3Ig2uhBVl73+Ru0Cm+AP9HQNylYf/H2tXdjztjuKcaW4RCt3xidyoaSC5yOTH7STgtzubpthJ+w1tuJLcjMaEG3rJjnBy8EQeOsp5AMsIeHqo3eKpZroM86obvgqg4ESCQQraKJCfvVwkw3p+c/tm1yh8nzPaQKZE30Sfio5U7p39nzPxgNSIkl+r+eSHNQxxstyaQjr6AiSQGePm+S+d0mzDeYgZDFh6+cXIdu/v4n4yBYpisOFEmnCW22NLETHx32jVjYu8v+gxWyAzpSNerh9hFB7LEfDKuJd77yiC3wqHu8NL7pgUnvfXpyomGyceJv7YxbvAxe/pLk8pp7I4cZ3rc8ZCPHmtvNH0DnTSTGuqckRaH2zJHH3s6kKgf8nGd7VLm2aF5ZDlPTOWi1qcVODlQ7Wa0avduO6df65TDI25ou2hf8au5K4mlZGJhnGArve/fHoIOv2ZKEwLrlMH89CAsw/Oqw62w3BnQA9ms2RwxJcSuSNeIApzRb4aiQWBgY+mZXWXcCm0jSbpyCRGMg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261022075727099003)(261022113327099003)(261021130227099003)(11063799006)(56012099006)(261021135927099003)(261022115727099003)(261009223027099003)(261026121527099003)(261026130827099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OTFFWlAvMlhjL3dIeVpVMkFHYWZVaUdPM00xQjYvMlA1bm43RXdwb2EwektC?=
 =?utf-8?B?T0hyY052UTJsL3ErVXhRMFRqYWdPdjdidVpOTmt3UWh4ZDRCWjZvaUhxSG9j?=
 =?utf-8?B?bjhZcEFScWxXUUZIK2JYdDYwYUh6YnpoUzRWTjk0L05KZDJtOFlVZ1R0TGtB?=
 =?utf-8?B?a210cW52bC9jMVltL3U0OGZVSFJHd3NKZ1hBVkJhaHVLdVRLSWptSUZMcVlE?=
 =?utf-8?B?NTFLdEhHajRES1BWdmpVd0ZtTVRSUWx2aXduVStmQTRLbGZna2N6aS9pL25X?=
 =?utf-8?B?MEZjR1gzVGdHbUE2NDVMUFRjQWkyeDM5NXV3dTkxY2VsdXNiM01PTWNRTkZN?=
 =?utf-8?B?VUJTOTEvVFhyaU1HR2c4ZXdyb0hKb3lVSDI5aitQeFBLazY1eGp4ak14QnQr?=
 =?utf-8?B?WUljM1hIUWpVSVJCWDFZMXB1Ulg4aFBHa2JGUzBwQXNmOXlZUThQQSt6cDVw?=
 =?utf-8?B?cDVWdGRJY0tMcnhLWUc4ZmExS2IrYkw4U2o1bnZTR05yd3B2NGExcFlnV2lO?=
 =?utf-8?B?VnhzZ05FT1ZFL2cveDRsMWdyTnZ6cmlCWnRJUGNqU0sxeWdMUXVwbzAvWTNJ?=
 =?utf-8?B?RW9CYkFiSHRJSzBWZ1NYR2Q1TE5ramxOeUFlSUFKbmFGUHYvYVliTWdYZlc0?=
 =?utf-8?B?ZWJLVmVYWlFsMXZCc3g5V1g5SSs3RTA0dTNJSitiejZHWENvZmtpRW9aL05B?=
 =?utf-8?B?a25PYzQxWDBPV2JwbitCcE5KZlVFclNKYWxRYS9PbjkrdW9rYjE3WmVlV04y?=
 =?utf-8?B?Ykw2WDZTSm1ibmpIZkRCaGFzc0ZkbisyVklnUXRZL2k2NVRoVFVNNHQzQmdF?=
 =?utf-8?B?cGsrYW9FbWhOOEV4OUt0YkExUnlXSXZCYUtGQVpsc3ZxUFVpSmxTaVVqd0c5?=
 =?utf-8?B?emNQc2djZzl2a0JyMmFNNkZxUnA0NWNLUy9wa0dpbjE4VjY0aHV4VE02RE9Z?=
 =?utf-8?B?YTA0UEVRbmZuVkd6SERYR3MyVEhsamVnemVKemhKQTFyMDBmR2tPd1hjc0dy?=
 =?utf-8?B?ak1XbFlTdFBhVzI0aElsazByY2JISXlhems3MzJ6NkJ6STBzWTBqOWZzbDNo?=
 =?utf-8?B?bEJiMXJyZ0hVWTNzTU5IMnZRZFBMUzFSMXNRejI3ZHM3R2s2RWN3a1JtSis4?=
 =?utf-8?B?S0EycFJxOExkYnAwcWR1cVdza1JRbzY3dXBvWnVGcXBqb2pKSldrSXBVNk5a?=
 =?utf-8?B?Y2lRdHV5c2lyUWxCUHh4Y044aUgwd1p3bG5tN1pnVUZBSmFNVDV2ZHdHbEdj?=
 =?utf-8?B?NHhCWUFlZ0diMm5PMmJ1THloZkU4Y3ArQmNiREZ2UW1peEo3MDBuRUJtamtC?=
 =?utf-8?B?Njd3ZEhiZnNRaFhjN0s0SFlMZFBJMDFlWHM2UXdHQkh6ajdaUUdzWkEwRWVn?=
 =?utf-8?B?NkQzOUtGTmJvYkNzQnJueFhiNVFxdVhjQk5JbWR5YjgwV3Y5YTFaTTlTN3Nz?=
 =?utf-8?B?THp0U1dpT1MyV2YvVGZWWkhuNWc4WCtiVWJDZDZpc0dmRjgrclFHU042R2xi?=
 =?utf-8?B?cGo5L1VTNGpZRDY0QWd0WDFaVDl1RldQdjlSVnhqelZoeXJ3TTVOaFBad0hi?=
 =?utf-8?B?TXBJS1hHa2htRW82SWszWlpubkRWU0xLYy8xK2lMS3Q1dHZ1N2hqVUhaaVVh?=
 =?utf-8?B?RGs0YUpudnpTUlM4Y2ppMG12Q1J6Z1hDYmVJM3lyNm5seGRYMEp0TDFDckFL?=
 =?utf-8?B?eXAvM0NLYVVnbTh0dmR2Z2lOMy9nRE1uUHZVZ1c5SDVFZzZVV1VTQ3NJWElC?=
 =?utf-8?B?L3puMTdOQUNDTjBTUUpvT2VXTFRmbnJiMzV5N3RpdU5XRFJWVUgzQ0lTK3BI?=
 =?utf-8?B?UkRqSkVDYlcyMmRiN1lleklLSHNvY3RRVUE5eW01SThrNHdRaE5OWHZsZlAr?=
 =?utf-8?B?endWeVZrQkNGemtZYVlwVFVuNjlkYk9aNStueTFiVEtudmVqUzc0ZVZmbzlq?=
 =?utf-8?B?WjJlQWtmS202eXV3aXpxN1IwNXBXbWlJTjU4aDYwVTBnSTVBTTlQanpPQWVW?=
 =?utf-8?B?STBVaTdJTm9JWFo4bGQ1eGpRd3NGbXpCWm9ibEQwVXh1eGgxS1RDRjRGN3Ja?=
 =?utf-8?B?Ly9MZHg3eTFzL0FOR1Z0Snh1SjI4eElEVnZJOVd1K0lQckFxeU9PVjNIdE0r?=
 =?utf-8?B?Wlg0M2hiWmw2WWxKODREZjNPSGZmeGNqS1dLKy9LbjFQZHBPU0NWR0JFYnFG?=
 =?utf-8?B?c090L2pZUFhVYlpDbVVGMzNzWHhvUXpnTEpzUHVQa3UrUXEyZHJnWkxpQ2Fk?=
 =?utf-8?B?UmZySlE0ME94UkhFbEpRNk1UaHI0VWVUNlJYRGxLSEp3aDJWaTYyWVJJK3JG?=
 =?utf-8?B?TXFYZ0xtSXhDZXJQM0lORXdYLzZlaHhMSWVCL3h1NmVWcElwZW1DQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c274c9ff-d17a-49cd-33c7-08df3b07eb25
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:10.6346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwNSDMa3CuGhdfr8wDPPMoZN4ChuZbZ6NTXyxqeqkWciJ+fkBWMSdVhxrT10ndnsxRbQYLYTSZ3ZxpUNsKT+8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

Introduce single_exporter_match into the dma_buf_ops so that single
exporter drivers can simply set it using a static initializer to use the
mapping type APIs. Provide a helper macro DMA_BUF_SIMPLE_SGT_EXP_MATCH()
that generates the initializer for simple drivers that don't use P2P.

More complex exporters, especially those with P2P, need to implement the
match_mapping call back to extract things like their DMA struct device
from the dma_buf in order to do the P2P calculations.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c       | 14 +++++++++++---
 include/linux/dma-buf-mapping.h | 15 +++++++++++++++
 include/linux/dma-buf.h         |  9 +++++++++
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index fc1e62a0b388..70cfab4d9c49 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -718,10 +718,14 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
-	if (exp_info->ops->match_mapping) {
+	if (exp_info->ops->match_mapping ||
+	    exp_info->ops->single_exporter_match) {
 		if (WARN_ON(exp_info->ops->map_dma_buf ||
 			    exp_info->ops->unmap_dma_buf))
 			return ERR_PTR(-EINVAL);
+		if (WARN_ON(exp_info->ops->match_mapping &&
+			    exp_info->ops->single_exporter_match))
+			return ERR_PTR(-EINVAL);
 	} else {
 		if (WARN_ON(!exp_info->ops->map_dma_buf ||
 			    !exp_info->ops->unmap_dma_buf))
@@ -1096,8 +1100,12 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		if (ret)
 			goto err_attach;
 	} else {
-		ret = dma_buf_match_mapping(&match_args,
-					    &dma_buf_sgt_exp_compat_match, 1);
+		const struct dma_buf_mapping_match *exp_match =
+			dmabuf->ops->single_exporter_match;
+
+		if (!exp_match)
+			exp_match = &dma_buf_sgt_exp_compat_match;
+		ret = dma_buf_match_mapping(&match_args, exp_match, 1);
 		if (ret)
 			goto err_attach;
 	}
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index a961314dbd99..b02eb6759d38 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -356,4 +356,19 @@ DMA_BUF_EMAPPING_SGT_REQUIRES_P2P(const struct dma_buf_mapping_sgt_exp_ops *exp_
 
 extern const struct dma_buf_mapping_match dma_buf_sgt_exp_compat_match;
 
+/*
+ * dma_buf_ops initializer helper for simple drivers that use a single
+ * SGT map/unmap operation without P2P.
+ */
+#define DMA_BUF_SIMPLE_SGT_EXP_MATCH(_map, _unmap)                       \
+	.single_exporter_match = &((const struct dma_buf_mapping_match){ \
+		.type = &dma_buf_mapping_sgt_type,                       \
+		.exp_ops = &((const struct dma_buf_mapping_sgt_exp_ops){ \
+			.map_dma_buf = _map,                             \
+			.unmap_dma_buf = _unmap,                         \
+		}.ops),                                                  \
+		.sgt_data = {                                            \
+			.exporter_requires_p2p = DMA_SGT_NO_P2P,         \
+		} })
+
 #endif
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 33582713a104..fc341b1257c3 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -364,6 +364,15 @@ struct dma_buf_ops {
 	 * disturbing a mapping that cannot be invalidated.
 	 */
 	int (*select_mapping)(struct dma_buf_attachment *attach);
+
+	/**
+	 * @single_exporter_match:
+	 *
+	 * Should only be set by the DMA_BUF_SIMPLE_*_EXP_MATCH() helper macros.
+	 * Exactly one of @match_mapping or @single_exporter_match must be
+	 * provided.
+	 */
+	const struct dma_buf_mapping_match *single_exporter_match;
 };
 
 /**

-- 
2.54.0

