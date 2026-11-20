Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154254;
	b=mrFpOiThEpLCLxmkiRWC2aw0myGmNZwuhEFBLVBnhj9C2bEWh04AXyStgqERNlnP8386
	 scZyFpLt/AC2ChVFzokUM68zkHP1PpHs4B+oN0w6qSBEB3pkHARBAQnl85DvLIknGsQLt
	 h0m6YubuK5GrSlbW7lDLTra5YtLJxDXSOXJoitJNfsfJkOVCqxSUSbQwACAT/gyKahbwx
	 gpdY54a+LBxhYI5WbcUO3qUhZFYJZ1eGBvGim9g4nluvsVCCqsoXBfUaN5Z/jd/hS3Opu
	 V8fJbYai8ntIz9gyi/YnDep6Z20BGhfbmIatuiXS8nR5DTQmsi3iOxrrPAlzyUvSeFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154254;
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
	bh=ilJTpCVYnbcauG+r163VQYJ9uMnUanPL7rw0X3q9/H4=;
	b=NpIuef7Z30pS7y1X1841ccnhYKUmRSDNoH4ebfsBMYCrLjuhVC5yp0uBcfvjuwj9rHp5
	 jVx4GajaxmIGtZNgfl/sZlhGe6Q05Yo53lSPt5cnjw5Zy7naSkx6rrfAQlOX686SZ+pRf
	 VsiB0l8bKRb8hnFyLzd+S2GUCrsZmmqMwAoZWXPiRZEnwPUg75RE8CsknCkgMOQjG643E
	 zooH5yjDmpDxIefYEXl0e76VwE6i3dhM+MUAif0NpYMDoURQb/Roj+xVESLY3ovkSZEIA
	 fJwNw6MhsoZ9mWtEdX4O49ZTW4ndn47KuogN9mahWnWYp3QJmO7Wh6YoTc8qsaBpBkg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aLXqUXQl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.11
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011011.outbound.protection.outlook.com [40.107.208.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6073D606A335;
	Fri, 20 Nov 2026 05:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6073D606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aLXqUXQl
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u8noMm0L9emcy45Bj+JVx2GSp12btm8GHN1Q3STHBx6zgMwoHN9FvkuU9JcqGMMt1hK1HsxvlgaWnrZyfJ4/U2cU3NjK/oUMFFGmFyXcSscE91ZmHQVwFN/LFEFMFs3h1MbyPrvIpzw01gji+1atWxKf7VHs9Ct5YQxrEWmzpIHHF5Ou0G60Vav/B3yvFrF6OvpMESREGIriWGAPX8WH/kaM7uP2I/1b0KgmiwRlrgL2c0CkOcpmhHf65SoKfym9eX+ExtVE83dNZwInwdt8X6buJ6XQFqj9q7EhzhlbrgLOWs9VCbq7nI0hokTmFU+q9z9sdsHxWgStY+h7hTgmQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilJTpCVYnbcauG+r163VQYJ9uMnUanPL7rw0X3q9/H4=;
 b=mzLtyAngc2drZGWnmkl23aOR/UfnurQEV24L8IDoPs1/3O2Aek4nLrhwLHWhtxJtOJHAfCn+01Dz9xq67y6cqt17H+w20bVmd3offmDwZGlH9lDpaH0IwGqQMgrKbW7xb/7rLpCtdwypG5yFZ6fO6h7Q3Der3hb5QwqCfs9WT6oMvkMUcob7KHq9qeWPtOVPggtixdf64w/zvCCSqwjzyXClb9jUbEmwywewTk70lqqPywTkkcL6b3ZKN3Up9Zl1tTw1bjmvbP5CsGFubKnNgmDWkLnTGboqFH6AiaUSqWoe8HH9z9So4fOV/GVEMY559sBh7ihyDRgpGpDWkgFcPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilJTpCVYnbcauG+r163VQYJ9uMnUanPL7rw0X3q9/H4=;
 b=aLXqUXQl2Rvj2vwbxeVaD7sDAq3FiTgT+V4cyG+Wa/L3etmyDGTjHxnFGumny/waV1ze9FeTBD6IQNu+rXad0VXBhwSL/FXdUeXZtEb52ruWuWy1P8UIkXRqYbKLfkJMtqVOxGFij4XtvwaSPWFuOC0TggwxjwH6DToF4NvObC9fSx+5ypncvBQ30UYAseYpHCblGXFs5TX2EhtiVYKe/170i+Y5WT5/bPgydinXugyEzoMxNoFV9x4DYcZIGogJOUWjgOj0kNovpCiiA9CO+emqB7BkNWh8bSBI7evXZmSjfms2VR8nckYF7Y0kECOJzZ2KfYwpTZFvzxbnFf1uHg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:27 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:27 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:49 +1100
Subject: [PATCH v3 11/24] drm/xe/dma-buf: Use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-11-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=8345;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=QXILmliAthZUhxhVQclg06Ip3Kj8qDkHmgTOBHOzM74=;
 b=1eD8OXvoJJkwwPTUKf1Bjtk5IXuXaxHtBdBYlSaziR0JEFtvGlL6CPN87tz45HlzDdxVsiCpA
 H96xMvlvOXrAtixBLWNYl9LMrbF7lVTds95NppC8oKK73ul7uJo6Oo8
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0016.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::12) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: c01c78aa-16dc-4cd0-d5b2-08df46cb284a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Bb/H8ZWJ13XevsfJpWY6N0Rex8Amk5YXQy379wkVAJWciq5CZdUsOvybnodb4Quovqk0T3hkyaT9E85H0VFiXpZYZKmp+A7Qh3jh3s03XLbY+o33J1PgMpKL70+5IPHv4gTlqvSNN4t9UzIEbE/HetUmE+p5eYX49rrrCIgBkGWITCJi+PzV166V+0nowjAfcpno7vthem1tl3dvs1MUSLDNhVNl5wO0SVXqU2Bw9vMuBzqtQZn34dOSdiP9olV5R5PwNFHjjg73lhrjubdeMnB9FRxNqm1WwSUwvHvA+GN4NVnrRR7iKOGKsBj3lu75VvFFuLjONo//GkUNPKNHks8jQKlj1oXQq6huaX7wNZfb6NNdidKQMu80rty3lxzdDrLGGTH1GqwG6Wl3CqkJ8Zfyii59OF8UJTxpW5rE1iZP5JenWUfXr5jahNfZNe/Fl+N1vm/x9BanVFSCvyzGAwvETJSrit9BbE6qUVFEmn18x1V80Kgdp7mOt5A4UvDep8SpB9oHzBICH6KH+YdO4Y+fL+pys4/mzz81cm1m+7B6RXVKLn19bcLsVPxh7LLCmJUnrLmKIsp2jsNmYC9ltKmDgI1hKUkOfLn9zE3lShOrH+81+dgn9QY6jNKVt2suUQyxVXjuvkfeErJXVqy96CNaIwhbee8bMJK6+U9RA/xHQnhICW8rJSxaOa8uI+XVrLwNtGgeblbAXXGXSnKzKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEMvbTN4WllWTjR6UUlBOTE5dFNESTh6M015ZjNXSjJjM0pRcmdpbGFSRGt1?=
 =?utf-8?B?ZFZnQXVXV0hSRklqa2Fmc3JZMTRWUkVZVFNhUG1ySm50d0dXYm9iYWdkRFJN?=
 =?utf-8?B?YXJwcGhyZk1Fb0xETmFjSFlOOHB1czlWWE5yZ0xERExiMXAvcC9zYU41UU00?=
 =?utf-8?B?em9qWk5XNU9rald4UVE1RHBjMHFNY0VWYlk5NHhEckVSczZDUmFKUUVjdWwy?=
 =?utf-8?B?eXJwZVVicDRhckJHK2pPZW55RmY0L080cGNLTHdnYThvTm4zam5FbDVPMEhl?=
 =?utf-8?B?RHJtTnk4aEpBTG5SVmgyendsbGlTV3Rubi9ZbUFWN1hLZjU0c0JFaFNWMlJa?=
 =?utf-8?B?TXBBbHZtZmtBc29pYlk4endNc1RLbGhtZDB1akZsMGdLV2RmSG9HRVNRNDB5?=
 =?utf-8?B?TXBQQ3M2N3BUcUFSTzU4ektIQTN0WlZUYVRIem5vRnJsRkVXaTlmMUJGRElz?=
 =?utf-8?B?TlFTNDV4R3NDOHpMaXhuc0dObjIvTThBSDBRZ1YwQXdWWDBqb0lYOUMwdGdu?=
 =?utf-8?B?VEsvbUpqaFF5UGJ1Y0gvSkorUHdSZmxmcDk0VkxTT0xwSHVpRkxhN1V5VjVN?=
 =?utf-8?B?N3BmcHY5RTJqdjNvUDFHRkZyNDcxenRqS2ZUYjdhRktaMW8wK2tNRXh1UWdi?=
 =?utf-8?B?clZEVXQwNDNTRXhsaHVKSno3aEVCYnFCajlWN3JjaXhqRmkyTlRXdFRCNHVs?=
 =?utf-8?B?WCtsUTdQY2JqSzVzR1kvQkZiRXpYV1lMSzRBc2xOMWRDVFRCNUJkSjIzaXVr?=
 =?utf-8?B?Y0wxVUVEMXh0Ym9VU0c2YmVoVnFaRmpaTi9pZmFBWm91bWh5STVCbEpaS2E2?=
 =?utf-8?B?ZnVEbHlPajZiTjVHSVdIcWpwaHE5SStRdktYZjhIOGVyZGZFUkdFbUsrOFlx?=
 =?utf-8?B?bnpZT0xGc1VZZ3NRUG9HVHV4UnN5aW4xdzNEM2hrNkgwdUNVM0l0TXBVRHJT?=
 =?utf-8?B?TG15eVdUY2U3RkpVWEpoM1d1Q29JL2Vqbk01U1NPS1hYczhnOS9Ba3Z2SitZ?=
 =?utf-8?B?NjdzRGFTaGxlblNYN3dXMmwrTTNMblpaMkdTQXE1TFNVOEZWa294NDN0L2ln?=
 =?utf-8?B?TjNRQW5mVnBDSmEvZ3dZQXB0bXlOcGw0eVh4WU1DZ1IrSTdJd25NemZLQlFC?=
 =?utf-8?B?OEEvQnhKVVByQ0NENFptU2R6ejgyZS9weGx3dk8rNUpaRERLa09BMURpT05y?=
 =?utf-8?B?SFhhckxsS2RxTWZJWVBnQlE1Tk8xTG8xMHlIZ3c3M0g5UE5wN2x2MENlODlk?=
 =?utf-8?B?Tlk0L2V3cEI2TTdQajBvOStyZWFCcEExRGJ5bTFjQ0EzVHVPZHM5SzkvcUUx?=
 =?utf-8?B?UzliN3lKaEdmWlhSeHBYOVVIVkEwb0tBNVhoazd5NEI5Tk10SWRlQk00WDZx?=
 =?utf-8?B?OHlQaEJWZnRuanBIYU4zdXJXUnU4Q0x2TXlmNnJJOTRueVQ3a0NWSHNQL09P?=
 =?utf-8?B?WVJjVlc2b2ZlVHhGS3IvdURLN2hISEh4S3RKamlxdGxmRjhCWnJGbi9qOHZ2?=
 =?utf-8?B?cnFlSmdiRno0eFFYWDZ0bHVHZnFrK0pzSVZIYkdFUEhENkRaR040eW96dXhr?=
 =?utf-8?B?cDZxb0ttblpOYnRabFV4QTBjLytFVW9Xd25rTS9BS3NxWE5KUEd4WjltbG5Z?=
 =?utf-8?B?SHMvZzZZYmhlWWF4ZldvNzljMGdwT3Q1RzJPYWJva3EvTnc5RU9HSGJwUkp2?=
 =?utf-8?B?NitWaStKUExVZ2NkRVdUT0h0LzZySVo3V1ZOUHNtVzlza1dBVkpRRHlIMHBp?=
 =?utf-8?B?RTdKZS9sMVlWRjVTeXl1c0V0VTJyM0YrcFhNK3lXQXo1UTg0QnVBTlhHSkNF?=
 =?utf-8?B?amYwN0pYYnJnaWppU3A4eE1oYWFBVldhTGQvVUV4VmF1cm12YVR0NzNNaXdH?=
 =?utf-8?B?SUo5SkNONm9lc2xsMFNReFZKRFhyeEtFN1VLUWxBUFB2R2Q0UWFHSW1nWkhK?=
 =?utf-8?B?YmkvWFJBSG1BWW5uYmpTWm9ueWV1dFdwbjRrSElqcUN3QU52QWxwSWZ1eENX?=
 =?utf-8?B?MUt4ZHdQb2t5UXlJUldXZTJSMGc5U3BVc2tGRnZCNlFBQXdRS0ZnUWNpblA3?=
 =?utf-8?B?WUh2cGhTZ3U4dUVmYlA2VEw3OUNudGx0dHdVSW5GczBmYTVYQjdxZUUwbXpL?=
 =?utf-8?B?ZmRSaS9OZ1d4aDZ4QVFtNStTQzRWRlFmdWdSL3JaaXFNT21QenZGc3RjaFk3?=
 =?utf-8?B?cmJWQUFrNWtkVTBZOG00cGpmUGE5Y2hRaURTVDFucEpkZ1lhM2d0K2c0OXhS?=
 =?utf-8?B?cGtUQVpmN3JwYllrdTNCNTdKd1FMWENjK3JlaFpUaTN4VXpnVVJIUGRLbHdn?=
 =?utf-8?B?U0toVnlJWXFZR3ZqZkxjaTBxVkRHR0N6akI5UklDbU1KaExkZi9OZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01c78aa-16dc-4cd0-d5b2-08df46cb284a
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:27.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGenuf+nBTxJSqk9RmDyIFxyqURzEQYqYy7rCHbJRseEg+NzfC4ak9oCGU1lqgVnv9SiJ2Q4vsR4jMoQAW/GsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

From: Jason Gunthorpe <jgg@nvidia.com>

Move xe's map and unmap callbacks to the SGT exporter ops through
DMA_BUF_SIMPLE_SGT_EXP_MATCH() and take the importing device from the
match entry with dma_buf_sgt_dma_device().

The SGT exporter ops return a struct dma_buf_sgt_mapping, so
xe_dma_buf_map() must allocate one and build the table in it.
Doing so requires the TT path to take over the table entries
drm_prime_pages_to_sg() returns, while xe_ttm_vram_mgr_alloc_sgt() and
xe_ttm_vram_mgr_free_sgt() now take caller provided tables instead of
allocating and freeing themselves.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/xe/xe_dma_buf.c      | 62 ++++++++++++++++++++++++------------
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.c | 22 ++++---------
 drivers/gpu/drm/xe/xe_ttm_vram_mgr.h |  2 +-
 3 files changed, 49 insertions(+), 37 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index 6a85b292dee7..2394330e93bb 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -7,6 +7,7 @@
 
 #include <kunit/test.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dynamic_debug.h>
 #include <linux/pci-p2pdma.h>
 
@@ -45,7 +46,9 @@ static int xe_dma_buf_attach(struct dma_buf *dmabuf,
 	xe_dma_buf_p2p_debug_flip(&verbose_p2p_dist);
 
 	if (attach->peer2peer &&
-	    pci_p2pdma_distance(to_pci_dev(obj->dev->dev), attach->dev, verbose_p2p_dist) < 0)
+	    pci_p2pdma_distance(to_pci_dev(obj->dev->dev),
+				dma_buf_sgt_dma_device(attach),
+				verbose_p2p_dist) < 0)
 		attach->peer2peer = false;
 
 	if (!attach->peer2peer && !xe_bo_can_migrate(gem_to_xe_bo(obj), XE_PL_TT))
@@ -111,13 +114,15 @@ static void xe_dma_buf_unpin(struct dma_buf_attachment *attach)
 	xe_bo_unpin_external(bo);
 }
 
-static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
-				       enum dma_data_direction dir)
+static struct dma_buf_sgt_mapping *
+xe_dma_buf_map(struct dma_buf_attachment *attach, enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct xe_bo *bo = gem_to_xe_bo(obj);
 	struct drm_exec *exec = XE_VALIDATION_UNSUPPORTED;
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 	int r = 0;
 
@@ -136,51 +141,67 @@ static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
 			return ERR_PTR(r);
 	}
 
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
 	switch (bo->ttm.resource->mem_type) {
 	case XE_PL_TT:
 		sgt = drm_prime_pages_to_sg(obj->dev,
 					    bo->ttm.ttm->pages,
 					    obj->size >> PAGE_SHIFT);
-		if (IS_ERR(sgt))
-			return sgt;
+		if (IS_ERR(sgt)) {
+			r = PTR_ERR(sgt);
+			goto error_free_mapping;
+		}
+		/* The mapping takes over the table's entries */
+		mapping->sgt = *sgt;
+		kfree(sgt);
 
-		if (dma_map_sgtable(attach->dev, sgt, dir,
-				    DMA_ATTR_SKIP_CPU_SYNC))
+		if (dma_map_sgtable(dma_dev, &mapping->sgt, dir,
+				    DMA_ATTR_SKIP_CPU_SYNC)) {
+			r = -EBUSY;
 			goto error_free;
+		}
 		break;
 
 	case XE_PL_VRAM0:
 	case XE_PL_VRAM1:
 		r = xe_ttm_vram_mgr_alloc_sgt(xe_bo_device(bo),
 					      bo->ttm.resource, 0,
-					      bo->ttm.base.size, attach->dev,
-					      dir, &sgt);
+					      bo->ttm.base.size, dma_dev,
+					      dir, &mapping->sgt);
 		if (r)
-			return ERR_PTR(r);
+			goto error_free_mapping;
 		break;
 	default:
-		return ERR_PTR(-EINVAL);
+		r = -EINVAL;
+		goto error_free_mapping;
 	}
 
-	return sgt;
+	return mapping;
 
 error_free:
-	sg_free_table(sgt);
-	kfree(sgt);
-	return ERR_PTR(-EBUSY);
+	sg_free_table(&mapping->sgt);
+error_free_mapping:
+	kfree(mapping);
+	return ERR_PTR(r);
 }
 
 static void xe_dma_buf_unmap(struct dma_buf_attachment *attach,
-			     struct sg_table *sgt,
+			     struct dma_buf_sgt_mapping *mapping,
 			     enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_mapping_dma_device(mapping);
+	struct sg_table *sgt = &mapping->sgt;
+
 	if (sg_page(sgt->sgl)) {
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, dir, 0);
 		sg_free_table(sgt);
-		kfree(sgt);
 	} else {
-		xe_ttm_vram_mgr_free_sgt(attach->dev, dir, sgt);
+		xe_ttm_vram_mgr_free_sgt(dma_dev, dir, sgt);
 	}
+	kfree(mapping);
 }
 
 static int xe_dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
@@ -230,13 +251,12 @@ static const struct dma_buf_ops xe_dmabuf_ops = {
 	.detach = xe_dma_buf_detach,
 	.pin = xe_dma_buf_pin,
 	.unpin = xe_dma_buf_unpin,
-	.map_dma_buf = xe_dma_buf_map,
-	.unmap_dma_buf = xe_dma_buf_unmap,
 	.release = xe_dma_buf_release,
 	.begin_cpu_access = xe_dma_buf_begin_cpu_access,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = drm_gem_dmabuf_vmap,
 	.vunmap = drm_gem_dmabuf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(xe_dma_buf_map, xe_dma_buf_unmap),
 };
 
 struct dma_buf *xe_gem_prime_export(struct drm_gem_object *obj, int flags)
diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
index 9a514d983e90..f5801e81e080 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.c
@@ -505,7 +505,7 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 			      u64 offset, u64 length,
 			      struct device *dev,
 			      enum dma_data_direction dir,
-			      struct sg_table **sgt)
+			      struct sg_table *sgt)
 {
 	struct xe_tile *tile = &xe->tiles[res->mem_type - XE_PL_VRAM0];
 	struct xe_ttm_vram_mgr_resource *vres = to_xe_ttm_vram_mgr_resource(res);
@@ -517,10 +517,6 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 	if (vres->used_visible_size < res->size)
 		return -EOPNOTSUPP;
 
-	*sgt = kmalloc_obj(**sgt);
-	if (!*sgt)
-		return -ENOMEM;
-
 	/* Determine the number of GPU_BUDDY blocks to export */
 	xe_res_first(res, offset, length, &cursor);
 	while (cursor.remaining) {
@@ -529,12 +525,12 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 		xe_res_next(&cursor, min_t(u64, cursor.size, SZ_2G));
 	}
 
-	r = sg_alloc_table(*sgt, num_entries, GFP_KERNEL);
+	r = sg_alloc_table(sgt, num_entries, GFP_KERNEL);
 	if (r)
-		goto error_free;
+		return r;
 
 	/* Initialize scatterlist nodes of sg_table */
-	for_each_sgtable_sg((*sgt), sg, i)
+	for_each_sgtable_sg(sgt, sg, i)
 		sg->length = 0;
 
 	/*
@@ -544,7 +540,7 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 	 * GPU_BUDDY block(s) if more buffer needs to exported
 	 */
 	xe_res_first(res, offset, length, &cursor);
-	for_each_sgtable_sg((*sgt), sg, i) {
+	for_each_sgtable_sg(sgt, sg, i) {
 		phys_addr_t phys = cursor.start + xe_vram_region_io_start(tile->mem.vram);
 		size_t size = min_t(u64, cursor.size, SZ_2G);
 		dma_addr_t addr;
@@ -565,7 +561,7 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 	return 0;
 
 error_unmap:
-	for_each_sgtable_sg((*sgt), sg, i) {
+	for_each_sgtable_sg(sgt, sg, i) {
 		if (!sg->length)
 			continue;
 
@@ -573,10 +569,7 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 				   sg->length, dir,
 				   DMA_ATTR_SKIP_CPU_SYNC);
 	}
-	sg_free_table(*sgt);
-
-error_free:
-	kfree(*sgt);
+	sg_free_table(sgt);
 	return r;
 }
 
@@ -591,7 +584,6 @@ void xe_ttm_vram_mgr_free_sgt(struct device *dev, enum dma_data_direction dir,
 				   sg->length, dir,
 				   DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
-	kfree(sgt);
 }
 
 u64 xe_ttm_vram_get_cpu_visible_size(struct ttm_resource_manager *man)
diff --git a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.h b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.h
index d77f067d197b..d6531f0e0317 100644
--- a/drivers/gpu/drm/xe/xe_ttm_vram_mgr.h
+++ b/drivers/gpu/drm/xe/xe_ttm_vram_mgr.h
@@ -23,7 +23,7 @@ int xe_ttm_vram_mgr_alloc_sgt(struct xe_device *xe,
 			      u64 offset, u64 length,
 			      struct device *dev,
 			      enum dma_data_direction dir,
-			      struct sg_table **sgt);
+			      struct sg_table *sgt);
 void xe_ttm_vram_mgr_free_sgt(struct device *dev, enum dma_data_direction dir,
 			      struct sg_table *sgt);
 

-- 
2.54.0

