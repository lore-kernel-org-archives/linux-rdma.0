Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860894;
	b=pXDGNbTdvWVs4tIhSYpMsUIZuxClw8Rj6xCNx3fnu7mowm+RLjrFgYByDeo/5oBIILU/
	 pV+XzIjA0ttfI3GqD08pnNhQmEybLBwkq/AejQxeLYwKi8Hqoidp2R3Cljp7RxwtJYrED
	 8M+bJWfiwSbh7cE3HXFHEayFkhaglzxOmxERY9CMGKW1lpCFsQg18fVjG2fS1nyEozUsS
	 bu5XRD7cnjfunfhIkpZZMidPyQKKF0lzzlZhj7k5yyJiX7moTqZDktxpLvIy1Logcx2Rx
	 BnumN46nIwzw9gUjIieiEd4QzmILJjQl9Ljoqst5Fexpi7N4uarBkzSOH+GxGQEBFCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860894;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Subject:Date:
	 Message-Id:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
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
	bh=8krLz6WLisOSdaE675GO7A0nD00WAm/r/HFxyyrgaAU=;
	b=QCJgkATv30Dfol9s/4xjhOZekQIQ6lgMTkDpCquoDeHzmJM78T1VTvGFHvBIn1GNMxMq
	 3oGHjQ5H2W8mO+HHkWiZlT8ACFFrTrAvuPciEc4SGTQrHXg0rhatCG4GVLFTOPuq9q6N4
	 z4IUYtDNQpRRZs5L5oRK8HnUk04X0P3AT51878mIxczRGmR4UB+NNrTyFNCSspW+0jvPQ
	 1Y0IAP2x3/17DqA9vKnhNS63ttLoOR2EyKhQUW1EKvQFEZfya4ad8U/MicsiL34uKr05I
	 qaIG7mE2asixjADmkN6+uCbX5PpTWZ2FuljIFx7alFiq+6VSP+aezoEs0rrCgf9emaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R79+7MHK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.54
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012054.outbound.protection.outlook.com [40.93.195.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531D4606A332;
	Thu,  5 Nov 2026 06:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531D4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=R79+7MHK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUhH4qnKmSf0ZJWA1sime39DIdP8EQMo982fmrTk/k/sLUFcbWTw8C2ZhprP14Dv/hGb0XB+Pgq2jEoTGajdrL944qDJjBFRjJLMkXzZoyffViwdWl9ukB4bk9EktTIWp2+LwsMSIt+UZBMoF8bcmksC1UTt6CHZ9rcYVXCWvCMeWJyLV7vKC1Dj7XUo+80XrQfOwaiPnAsTewn3HSfo4RUm4TYbXhciMVho2SjFE0OirZvzUplqs7HEEijxba4A77gUnxdIlg1uEombd47cYzgHn4TdwhKFFRZoWfJQkfdeqEei/H1XWxOjbHZy0wMHRpce9sY4VeX2y4Miu/gr+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8krLz6WLisOSdaE675GO7A0nD00WAm/r/HFxyyrgaAU=;
 b=ZMrGpbMiKDpVjt/0RsVAthPnH2606qU9OlWWU/Jgwz1Y6zyPAhgTv4lxvUiiOCbvWKQhOuOIjvHIgsTVuje0WZjdDJoWhKQQYNtZ//B0zwWxfqu/nTu9yJhyon7Gczq84S4x3VyMNgYkhRTKJh5sHlgdofM1fvIYbuBSLfXSgSum2y2n6xuHVVqRm33OLg3DdJVhER5MaA6UjHRY5ZR6p1u4Zg/NZT+RCk/LknDc3NHaS7U2qEEutOHBM5VvghBXP5y1OqOWgJx8xTzusvPCIQ/d29aqU+SYW/QDcDZ9GvP8sSZKx1PTMfeEO4CJac8/HjKtk2sQ4YkIQoMnjysWGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8krLz6WLisOSdaE675GO7A0nD00WAm/r/HFxyyrgaAU=;
 b=R79+7MHKKEhWBw9RHWWb+Jslv7g8GJkew5OSs40ievQJ7bS2SOcHLClYiDTtZh5WUyyGzfVzHb2nO+5bp0NYedZGT8Ge78nBYLGTbIPjU8qfw11o6ud9W7B5GBGJHCte02yWOcJRmtpYvPZjVB9rQ6Xe42We86ja5s9nhlxdhusEI4HXKr9jDlbGcttpCKXNwGGK80s+mJFfUGwy7CgZPq9EMe1lcJ9/15F+t4eNX97o3vhcc6/7IvvGd5KqnYswid4Ur4uRVJwg1jJN/09CyVWRJmcvggJ3V6fB2EXjZV1X5U2P224CI4PgL0PsCYAVGdUsQyAXTKbmQp62B9DiNg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:25 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:25 +0000
From: Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 00/23] DMA-buf mapping types
Date: Thu, 05 Nov 2026 17:40:35 +1100
Message-Id: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOQk7GoC/yXM0QqDIBSA4VeJcz1BZWX1KmOI1alOkIk6WUTvP
 leX38X/HxDQEwZoiwM8Jgq02Qz5KKCfjZ2Q0ZANkstKCF6yYTV6Nc6RnXTcHer0ZKMSouZdoxT
 WkEvncaTvdX29b4dPt2Af/ys4zx8xiDrZdwAAAA==
X-Change-ID: 20261105-dma_mapping_type_v4-f71180b977e8
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=13194;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=22aYsrhytE5V5lbwMjwTI9upi4fNUAl1CWB6/lCkMk0=;
 b=lEhjTIPsmDQUYXPdj977VzYcRt0MAD4pxjy7BpgQdJ6kI5tb+7uOQPL52vSg9qYsBMdBdr94x
 6KX3MOJkivKA8rj13wpG6i1X8SMDPuKmU12I8/3fjXH9sadg8wXvu5+
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0057.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:20a::9) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 7e280a08-45a8-43ce-e224-08df3b07d04d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261009223327099003|261022075727099003|261022113327099003|11063799006|5023799004|56012099006|261009221227099003|261009220027099003|261009221727099003|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	5wigsuY+54vg22Tak3M0VTh/L5Iat2R15N95ve+13jd6cerLd0iH3dtPr+WbsQjCnMqxGSZlGO1un1po6wGm+QXrz1pMPtF70Q1Rrrkr35yda3FOdgg9S5VJPO/mTmPNUN6tp5ESH3s7fRibvWSe5yA8bj6eXHGskuCGOEY6vul6BxJyeLmUCn3hH1vFyWntUyaYX4P3OaluP/U8p7/nfU84ZWBuOPXpVbv1OZM7QIZ38FIwsCIEGSSoiHhn1MWJDvJG2uHv3uGjuWYhCKPyDxTwWniwoAjmv7EhtNbFXx4Pl0E5Y/pQsmF+bhCXVaE14pPW4YDxFlcOVtQnrYs9L52c47gJtOaSaZDVMRUm6ue9138hLrfojIdhlGR8PwUvi/3XT69Ls0dGz0C8w2ojqw1r6U8lPxdcvO+1qxP2V+XS+Qw36sSSNvI6JkKhp9XfGySYGyXUX1s3Byj3CuTo3Y/+s6pAD3xCYyBbMR6VBxzCfujPG2wdG6cewrueIiHEF4Rf8PUDeMFBBZMK+5rIzj/G9SN9xbNA5VlCYyHOYldv9mAwz3pBUPxb6lSXxcJ+yr5CghmsjgDxLUOnFfFnOzigiqO7ih+HnOkLQSBaAU7obGIN/NrbWynxTS9U5PA1FTVlxAJzIImx7BnJYqFthNQCKv9hUr0cofXT5C17BvW3QAEoeKnSqT5I5S/fp1fmujyZ06TXpl7uRiZIfw81hg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261009223327099003)(261022075727099003)(261022113327099003)(11063799006)(5023799004)(56012099006)(261009221227099003)(261009220027099003)(261009221727099003)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDRYaExEMS95OHVLWUQrRjJPWm1LRkY5MUh2UktWb1UvRUFPNVFnOCtHS1Vi?=
 =?utf-8?B?RnBSTVFsU0tiMWFoY05UZ3dXZldYNEJzMWUvU2tMU1JCU3NsSWgyK2ZNTkl1?=
 =?utf-8?B?Qm5XeW1oUEJ1T3ZGd0xSMUw3NUpPR21GWitwWkVpS1ZsUHdMcWErSjd6Zmt5?=
 =?utf-8?B?amZtY3g4T0U4M3BKNzZNZVcweWVDVDI0NEpJRGlSMnI5Q2I1RXZUNnZFU0VS?=
 =?utf-8?B?YmVObEhvbW1HS2NYMzRWUVBhbWNMNlBudXg4Y244OWhIMmNneUFTZVMvRmwx?=
 =?utf-8?B?K1owTmxqcDdiZmVHcHpocWwwa2tNME11c3E3L1g3STNVRFJsV0U0QlFCbXJO?=
 =?utf-8?B?RjUxYkVKUmdqYzBEeXJuZkRGRjZFc2dwWE5xazJidGY2U2s0SHlmZFBmVHE5?=
 =?utf-8?B?NjQwL2lra2JTb1c0dFFPMkwwRUVDN2FjcHNxbHNscHh0aEY1U3EzL2xtVVMw?=
 =?utf-8?B?WTV0djdJQlJxWHFTbzkzamFCcVEwRzBKWE5ibkFvZHRxV1VPUXYwaEdSUEhy?=
 =?utf-8?B?a2thQUV6UWZDcTFtYmg2OGNEeHFxcDNWbHdUZnUvV2wxRDV0S3dVaitic0hu?=
 =?utf-8?B?MzNoVXF6aDR0TUFDZU80WlhDRmRIejhPaTl3YXNXWWoxaDhCMVlhSktDKzdS?=
 =?utf-8?B?UkpzU09sRC9TMXJZVVhBNUFvd3c1NFVaQnhvaklOWWp1NVB2YVVQZ1ZPdEFt?=
 =?utf-8?B?ZS8rNFlGTTNYb3cwTnp6RmgyRlovRWZDLzZzK0wrWkhLbE90TlFWMWpnS3RX?=
 =?utf-8?B?M24zZmFBaTNuTFQrM0F4eVVvcUdQaTR1VkNPcGZjK3J6V0xCMWxWTlZxa01P?=
 =?utf-8?B?aklqcFl5cmE2Vktpa3cyYXYzM3lTZ2U0cXhDNlVKYnplai9aY1Rod3VCU3kv?=
 =?utf-8?B?M3A2ZVNGSWdJbHBseDNrbFVZQXUySklLaGJ6OFhnci9xSXFPZGhMSXlRUVd5?=
 =?utf-8?B?alBtTkpVbWlQb0R4NGFZZHdCZnhxR09oMU0xOHJZbXpuM0FsWlFWdGVSb3E0?=
 =?utf-8?B?K3dvelk2THY0Y3pQeFRCZWhZb2JYNm9EZXVBS3M2NENENlpXNUJiZU10bmF5?=
 =?utf-8?B?bEJEYUUrMXY0a0hYb3ZUU1RVTkF5UHpJUWlIRk52WTZobEEzNnNNZ2YrOVVJ?=
 =?utf-8?B?UGxvSFZPOTdQMitvUXMzYzZCTGYvc3RUZEd2em42UnBFRVRpUUxmOVJhZm5x?=
 =?utf-8?B?YVZEYkJtTWVZL08rTzZGYS9VK3VqWEFkUFV1RDlPdlEwQ3BNdWtwQ2hmUkgy?=
 =?utf-8?B?ejdrOUdCU3J6dG1TMnFFcENweVRhbzk3SnFudWZ5RVkydUZ0UDNHOEl0MXpj?=
 =?utf-8?B?OUpnTStJc0Q2VHZ1dyttdmovYmVZdDZHVnpaNDAwenVycURjRHhDTFkyNHFu?=
 =?utf-8?B?T2NqSFZIV0RUWGVRY2xZc3VxZVYzOUVETnV2UWJBNUxkT0YrVXVZOWI0eFlK?=
 =?utf-8?B?ekU2Yk1pM3ZTcHJ3b0NTS1NlQWl2K3lNVEx1ZlpHQTIwRUlRaUY4MW5vQ1hU?=
 =?utf-8?B?SGJWZmpXWEIyOXllTkpVRy9WdkdOUnhWQncwQlZzVWtZN0JpVWVRN2V0d2c1?=
 =?utf-8?B?ZmdIbGVWMm16SXA1bnNXcXVqTk1QWWhRU0RpdFJsRWR4T1lkdFpHZElQOVdZ?=
 =?utf-8?B?ODhSSit3Mmh6VGZrRzVOQS9oTXgyUmFRUWVBaTZyd0tJQ0V4MytYZ3p6UVMx?=
 =?utf-8?B?VENJamJhN3UyT25ucERyaiszSzdEbWFtWk53RUlGZTliZ2IzdGdqSUFHNDFE?=
 =?utf-8?B?VUpxVEMxN1VTODhnZlpDTkozSlhJOUdZSEhmb1dPRTRSeTBYM3ROOUs2MHFG?=
 =?utf-8?B?KzZEVC9Tdm5rWkVVekhvdEkzYmYrUk1rNmU3a2F1dXRlWC9TaGU2RjJESllj?=
 =?utf-8?B?UnBFdXJRbndmalpmN2YwZlNaeEhwbEVLTzJmeTB1OFpJYk1GZzZTQmVXYzlj?=
 =?utf-8?B?V3FKaVpYVVpVVzNuNlhZZ2x2WDZxM2xiN2lQaThuMWVma3JuV0EzbUNOUFhT?=
 =?utf-8?B?SW9rODJ2QmJtaGdFOVlQODNtbDFYcnhjUERmNFhWZUoxN3lrdTBwbXJXK1Ev?=
 =?utf-8?B?dEpzQ1d1QzEyWmd1KzlUeGowN0tnajVmRHo3QjNXcEVwSkhUYllwZE51QWky?=
 =?utf-8?B?ajk3S2IvMzFqSTRRMysxeDRiQnQwN2srYzd4cjhNRzdPekliL21sck51OVVD?=
 =?utf-8?B?N2IzWGpyVXU3N3lrNXRSQnQ0cjU0eDdmTzBoaXlsTFJPUjFvTSs5UHp4Rjkx?=
 =?utf-8?B?bkxXRWNaZDk1L0lWZE1wYmM0bVZGZEFnK2U1YzB3WWpVQlRrYXlLdXFBL3ZR?=
 =?utf-8?B?QjFUTE5PU0RPWEljQTZUdDAvVVVtMzBwQVBidDNibTlaekdPZmloQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e280a08-45a8-43ce-e224-08df3b07d04d
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:25.7646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxblD7pkGRbKmdciqKMJyki3UxBagk7gvchNOB1faVCfMeiEDnyNDdSFmeFyz3t7yjNEVrivvcp4sVlA1sF1lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

This is v2 of the DMA-buf mapping types series [1]. It keeps the framework
and the SGT conversions from the RFC but defers the final mapping type
selection until the first pin/map of the buffer.

At pin/map the exporter chooses one of the types matched, taking the other
attachments and the buffer's placement into account. That choice is held by the
core until the exporter explicitly invalidates the attachment. This ensures
unmap/remap cannot cause buffer movement and ping/pong.

Future work will build on top of this series to add an iommufd importer type
per the plan in [2], separate out PCIe P2P as its own mapping type and convert
XGMI to an exclusive mapping type.

Why mapping types
-----------------

Since its introduction, DMA-buf has only supported using scatterlist for
the exporter and importer to exchange address information.  This is not
sufficient for all use cases as dma_addr_t is a very specific and limited
type that should not be abused for things unrelated to the DMA API.

There are several motivations for addressing this now:
 1) VFIO to IOMMUFD and KVM requires a physical address, not a dma_addr_t
    scatterlist, it cannot be represented in the scatterlist structure
 2) xe vGPU requires the host driver to accept a DMABUF from VFIO of its
    own VF and convert it into an internal VRAM address on the PF
 3) We are starting to look at replacement datastructures for
    scatterlist
 4) Ideas around UALink/etc are suggesting not using the DMA API
 5) Private interconnects, such as XGMI, are forced to work around this using
    driver-specific hacks.

None of these can be achieved using scatterlist. This series introduces a
"mapping type" mechanism allowing dma-buf to negotiate compatibility between
different types and support alternate mapping options. See the description of
patch 2 for more details.

Selecting mapping type
----------------------

Importers and exporters list possible mapping types with the exporter
responsible for selecting the final type at pin/map time under the dma_resv
lock. A matching phase at attachment time eliminates types which statically
cannot be supported for a given exporter/importer.

This was done in response to review comments on the RFC. Karl found that the
RFC's match callback ran on an uninitialised attachment [3]. Christian noted
that the final decision has to be made under the dma_resv lock before a
mapping is created, not at attach [4], and Thomas proposed the three steps
followed here: agree the possible types at attach, select at map, hold the
selection until invalidate_mappings() [5]. Christian also noted that remaps
must not change type or placement as that makes buffers ping/pong [6].

The dma-buf core enforces that last point by calling select_mapping() only on
the first pin/map after attach or after an invalidate. The pin/map type can
therefore only change once the exporter has explicitly invalidated the mapping.

Future work
-----------

This series stops at the SGT type so that the framework and the
attach/pin/map contract can be reviewed on their own. I already have
proof-of-concept conversions of both PCIe P2P (building on Thomas's work [7])
and XGMI to separate mapping types. If those would be helpful for reviewing
this series let me know and I will post them.

Alternatively this series could be split up with patches 1-9 & 22-23 adding the
general framework and the rest adding the conversions later.

Further work, per [2], is an iommufd importer type to replace the private
vfio/iommufd interface and allow other DMA-bufs to be imported into iommufd.

Testing
-------

- KUnit dma-buf-mapping suite (patches 22 and 23) passes.
- Every patch compile-tested with a config enabling all converted drivers.

Changes since v1 [9]
--------------------

- Rebased onto v7.4-rc1. The rename also covers the new nvme-pci DMA-buf
  importer and devmem's switch to pinning. xe's dynamic-debug knob for the
  p2pdma distance check (3bc497a40178) is dropped, since the check is now
  done by the core at match time, and amdgpu's PREEMPT-domain import
  decision (78cdd96ab497) asks the negotiated match set instead of
  attach->peer2peer.
- The dma_buf_map_attachment()/dma_buf_unmap_attachment() rename is now the
  first patch, squashed into one, and uses the shorter dma_buf_map_sgt() and
  dma_buf_unmap_sgt() names (Christian [9]).
- Dropped dma_buf_mapping_attach() and the dma_buf_sgt_attach() /
  dma_buf_sgt_dynamic_attach() renames. Importers that support more than
  the SGT type list them in a static dma_buf_attach_ops
  ->supported_mapping_types table. The importing device is passed to the
  mapping types through the match arguments rather than stored in each
  entry. dma_buf_attach() and dma_buf_dynamic_attach() are unchanged for
  everyone else (Christian [9]).
- The selected type is an index into the attachment's match set, read
  through dma_buf_attach_map_type(), instead of a copy in attach->map_type.
  finish_match() fills the match set entry directly and select_mapping()
  returns the index.
- A failed pin or map only undoes a selection it made itself, so a map
  failing under a held pin keeps the pinned type and a failed first pin
  leaves the attachment unselected; KUnit tests for both (Karl [10]).
- dma_buf_match_mapping() returns -EOPNOTSUPP when the two sides have no
  type in common, keeping -EINVAL for an empty list, which restores the
  error xe's own tests expect (Sashiko).
- New DMA_SGT_EXPORTER_REQUIRES_P2P flavour that requires a P2P capable
  importer without a pci_p2pdma_distance() check at match time, used by
  vfio and uverbs so iommufd's non-PCI device can still attach and so no
  pci_dev is dereferenced outside the dma_resv lock (Sashiko).
- The SGT P2P distance check is quiet, as it was in xe and amdgpu before
  the conversion (Sashiko).
- Fixed a NULL importer_ops dereference in dma_buf_dynamic_attach() and the
  NULL check order in dma_buf_unmap_sgt() (Sashiko).
- Signed-off-by added to every patch (Jason). Patch 4 is now authored by me
  with Jason as co-developer, as little of the original remains.
- Not addressed: the Tegra fault with CONFIG_DMABUF_DEBUG that Karl
  reported [12] is a pre-existing Tegra bug being fixed separately.

Changes since RFC v1 [1]
------------------------

- Dropped the PAL type and its vfio/iommufd users (RFC 21-25).
- Rebased onto v7.3-rc5: move_notify is now invalidate_mappings,
  CONFIG_DMABUF_MOVE_NOTIFY is gone, new amdxdna/panfrost/panthor
  exporters converted, kzalloc_obj().
- Patch 1 records the whole match set in a fixed-size array in the
  attachment; patch 3 initialises the attachment before match_mapping()
  (Karl); patch 15 holds a pci_dev reference instead of asserting the resv
  lock (Baolu).
- New patches 5, 6 and 7: exporter selection at pin/map with core-enforced
  stickiness, match set queries, and dma_buf_mapping_map()/unmap().
- xe and amdgpu conversions written against the final API; amdgpu's XGMI
  override rewrites the recorded match set entry.
- New patch 26 with KUnit tests for the selection contract.

[1] https://lore.kernel.org/all/0-v1-b5cab63049c0+191af-dmabuf_map_type_jgg@nvidia.com/
[2] https://lore.kernel.org/all/20260422150000.GK3199414@nvidia.com/
[3] https://lore.kernel.org/all/20261016202653.97339-1-kmehltretter@gmail.com/
[4] https://lore.kernel.org/all/d08a26ed-ded7-4447-bf7b-88597ee7df0e@amd.com/
[5] https://lore.kernel.org/all/8d4cb20b70ac4c3f36d8d631769757158af2ac8e.camel@linux.intel.com/
[6] https://lore.kernel.org/all/7b4dc988-5dbd-40e4-b17a-47b6eaf4bf81@amd.com/
[7] https://gitlab.freedesktop.org/thomash/xe-vibe/-/commit/7452df0fc858a7dc5ccac0e2037852cb7ab64d61
[8] https://lore.kernel.org/all/20261026053623.202642-1-apopple@nvidia.com/
[9] https://lore.kernel.org/all/3151a820-c583-4968-8440-673a9e390446@amd.com/
[10] https://lore.kernel.org/all/7193d384-5e28-4f85-8004-1dc9318d5c1c@amd.com/
[11] https://lore.kernel.org/all/at8IQZ34wkHQ_5PL@gmail.com/
[12] https://lore.kernel.org/all/auAIO0y09SXk34CN@gmail.com/

---
Alistair Popple (5):
      dma-buf: Negotiate the mapping type in dma_buf_dynamic_attach()
      dma-buf: Let the exporter select mapping type at pin/map
      dma-buf: Add match set queries for exporter placement decisions
      dma-buf: Add dma_buf_mapping_map() returning a type-tagged mapping
      dma-buf: Add kunit tests for mapping type selection

Jason Gunthorpe (18):
      treewide: Rename dma_buf_(un)map_attachment() to dma_buf_(un)map_sgt()
      dma-buf: Introduce DMA-buf mapping types
      dma-buf: Add the SGT DMA mapping type
      dma-buf: Route SGT related actions through the attachment's mapping type
      dma-buf: Allow single exporter drivers to avoid the match_mapping function
      drm: Check the SGT ops for drm_gem_map_dma_buf()
      dma-buf: Convert all the simple exporters to use SGT mapping type
      drm/vmwgfx: Use match_mapping instead of dummy calls
      accel/habanalabs: Use the SGT_P2P mapping type
      drm/xe/dma-buf: Use the SGT mapping type
      drm/amdgpu: Use the SGT mapping type
      vfio/pci: Change the DMA-buf exporter to use mapping_type
      RDMA/uverbs: Use the SGT_P2P mapping type
      dma-buf: Update dma_buf_phys_vec_to_sgt() to use the SGT mapping type
      iio: buffer: convert to use the SGT mapping type
      functionfs: convert to use the SGT mapping type
      dma-buf: Remove unused SGT stuff from the common structures
      dma-buf: Add kunit tests for mapping type

 drivers/accel/amdxdna/amdxdna_cbuf.c               |   8 +-
 drivers/accel/amdxdna/amdxdna_gem.c                |  11 +-
 drivers/accel/amdxdna/amdxdna_ubuf.c               |   8 +-
 drivers/accel/habanalabs/common/memory.c           |  54 +-
 drivers/accel/ivpu/ivpu_gem.c                      |   6 +-
 drivers/accel/ivpu/ivpu_gem_userptr.c              |  11 +-
 drivers/accel/qaic/qaic_data.c                     |   6 +-
 drivers/dma-buf/Makefile                           |   1 +
 drivers/dma-buf/dma-buf-mapping.c                  | 291 ++++++-
 drivers/dma-buf/dma-buf.c                          | 266 ++++--
 drivers/dma-buf/heaps/cma_heap.c                   |  12 +-
 drivers/dma-buf/heaps/system_heap.c                |  13 +-
 drivers/dma-buf/st-dma-mapping.c                   | 896 +++++++++++++++++++++
 drivers/dma-buf/udmabuf.c                          |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c        | 136 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   4 +-
 drivers/gpu/drm/armada/armada_gem.c                |  28 +-
 drivers/gpu/drm/drm_prime.c                        |  28 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |  16 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |   2 +-
 .../gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c   |   4 +-
 drivers/gpu/drm/i915/gem/selftests/mock_dmabuf.c   |   8 +-
 drivers/gpu/drm/msm/msm_gem_prime.c                |   7 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |   9 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  13 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |  11 +-
 drivers/gpu/drm/tegra/gem.c                        |  26 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c             |  19 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c              |  32 +-
 drivers/gpu/drm/xe/xe_bo.c                         |  16 +-
 drivers/gpu/drm/xe/xe_dma_buf.c                    |  79 +-
 drivers/iio/industrialio-buffer.c                  |  13 +-
 drivers/infiniband/core/umem_dmabuf.c              |   8 +-
 drivers/infiniband/core/uverbs_std_types_dmabuf.c  |  30 +-
 drivers/iommu/iommufd/selftest.c                   |  18 +-
 drivers/media/common/videobuf2/videobuf2-core.c    |   2 +-
 .../media/common/videobuf2/videobuf2-dma-contig.c  |  23 +-
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  18 +-
 drivers/media/common/videobuf2/videobuf2-vmalloc.c |  13 +-
 .../media/platform/nvidia/tegra-vde/dmabuf-cache.c |   6 +-
 drivers/misc/fastrpc.c                             |  18 +-
 drivers/nvme/host/pci-dmabuf.c                     |   6 +-
 drivers/tee/tee_heap.c                             |  13 +-
 drivers/usb/gadget/function/f_fs.c                 |   9 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c                 |  26 +-
 drivers/xen/gntdev-dmabuf.c                        |  27 +-
 include/linux/dma-buf-mapping.h                    | 420 ++++++++++
 include/linux/dma-buf.h                            | 234 ++++--
 include/trace/events/dma_buf.h                     |   2 +-
 io_uring/zcrx.c                                    |   6 +-
 net/core/devmem.c                                  |   8 +-
 samples/vfio-mdev/mbochs.c                         |  10 +-
 sound/soc/fsl/fsl_asrc_m2m.c                       |  12 +-
 53 files changed, 2415 insertions(+), 536 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261105-dma_mapping_type_v4-f71180b977e8

Best regards,
--  
Alistair Popple <apopple@nvidia.com>

