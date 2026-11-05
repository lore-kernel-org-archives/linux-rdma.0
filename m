Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860930;
	b=o7TyqmpJyKQgWNmhNAAQe6UA/mZJjJso1y0D+e6tRQo+xmk3CKWIsKPx87iFihVbDxng
	 4R/1dQ+rqFVJKW+/mPRnLwKdvVejOqG+6sVBVZprsWL6oedA2hRqiTJzyEaFLGBrCxfDD
	 VuRS+INTr2qs6lF98UZwoIdIOu4CxpKMh5TxKAQjNtsJJRSJ0P62jjbOs4skTxdW0KMDe
	 mB6Y8qtaGdyxhQ/brxTUPVvRJCoG+jMUuAUt9Hvn+C3Otl5vQvwSyGdLf/i7L/yDOZP3m
	 IYigNOYKhDEsmyBrLP59veGUuXl9gFMmVeRRw+3Lz/oQkNJlPZAap48QMk1pV1iiopA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860930;
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
	bh=xIIecvJXS9Er8DIesAIXHWiK6wRtkZqY9zOmfKOWoNI=;
	b=fc6EnvaofCLqFFUGhzGJlmpv4jbp9H7v9NXNOrd+spwBQ/d3UX6ctAa44k89704o8GQ2
	 ok8gD1+F1UliQIfAU62W2CjQXA8hwgUuAIq0QUCcqcjyzE72YfV9rPrHdlyH58Ow4eJHA
	 0/RLjkxRNnUdsJceVVHPxXX3WkHPRE1T9MvRAoyRbCKwfDJ9PBb10VkorhIxhj7cPsKrE
	 6T/A6llf+0aBX1kZqjjex9wppYu8VuHekYXoXYaqYA+HC/eLN6AK3FSkYGo3hTwQASxAW
	 ziIIolAw9L1qUvJNxdKwhVfP9cyPzTaAQRhFSFDp7+EbSMcn/3MeU2HaK8KuJhMCcqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AZJCpTrc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FEB606D806;
	Thu,  5 Nov 2026 06:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3FEB606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AZJCpTrc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uSfvHi7QyP7dCEDrE3+MxSjkXRAtRt8K19jyqUXciAGVo/PgiGDvt5JWXD6Fw55kKqCYipcM4nwexcQIeX1V+mjD/q9J5pWcY0xEnV0u91wHeaCv7RxZrEixZuoJ7PmQ3k5rwo5JUpREhtyt5HVZB0+Lv+OtlADkCo6+iGvfklc070h3mT6nWz1sXVPOojbc79ZfKG3mDYVCbxT+lCTQu1UCkuggPSF202U7caBAhxwlAZ6M12updsYk/OWfcTvaWjxZz7PHMpHxb6+epucboHRb8SMG1bfIP2h1nFBtjtYgNG/RPbpL5tJLfoslNEcR6SfRM1WiEJsU3SH48qAlBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIIecvJXS9Er8DIesAIXHWiK6wRtkZqY9zOmfKOWoNI=;
 b=nw9HcAM+pkdVKpA1uX9l84+esDUBZj7dPritinbK/aVZFhFFeickiME6Mp1JVfWJo/uyDthuRiAju+tq28iG9bMly+ZkxFX2ihc2iwFZWvzn5BWPo+27YhHQRH+KFw3Mx06Hp6DqghBinaWQpUPoCEnR7u243jpXeTL+Z2p1WnYggtlgxV0RCfVdbyujpns8uf2c1kVNRQTwAzDZ9aLTg1NKW0bjz9pWQtuYiZYUjP8V5B4hu1sjgJcgLMNygrT76K6ideVpHxBJbTjox05QjkOkQvnIFp89d82sblzOkIDUfboJ1gbwYrTF7zQ3ny7g4X6DN4TBzUB86KJvvyKgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIIecvJXS9Er8DIesAIXHWiK6wRtkZqY9zOmfKOWoNI=;
 b=AZJCpTrcbNw2wUah2PiZ6EATefYD/iSqDWlQgglXb1ehOwouR0Bqo2OkPPEGPNzzjwNyAW+ziHFAo1jieIiB/Zns1coNB4u03MhkQq6ZwdcCy8bgIy1/7qxZn4k7aTAmGaoZ0pKvMazupOieevryTJ0lft/XrT9r2m1oZYdRt/M2mW46DXVdair4nS2AxkYg7zRFewrxaJfkclk/gf7uup+yJ/UrW0QMHn3hgUIHBQiWqo1eVPZX1cxiWBdj44aRayhqvhp0rL6Y0+sqDQZJ/cw0ORYSG2VHU28Y3HMhC5ewfDMK9j+OTxlUGmaMS+lvWJkEg76VzB6tgmnFtRJ8pQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:56 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:56 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:41 +1100
Subject: [PATCH v2 06/23] dma-buf: Let the exporter select mapping type at
 pin/map
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-6-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=14640;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=hTe5m5VVafbkiEJbQWcPWlFtiBdDONn5ROqORJ1mjdw=;
 b=RIMuF9MsgGsUIVXgQMlSNclJkLujMN0dkFLUR+tAWZWjncefGRRB80LsQtN5AruatFfRUpdim
 Ilc4ZQFUqhQDvq7xrxRoEr7OdLJX0suLlEe393g4g8EHAaw0d1gxS/a
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0099.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:204::8) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6c73186a-c13c-48d6-d1aa-08df3b07e275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261022075727099003|11063799006|5023799004|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	TnsQEiXMChAg2tNgvvvZ1FYF6hmtBgUizHf9Gq2Q2mRoH3m8WvnQkQSZ7Ecruwd/x7vdFZ3EHSC8C5Kx0enHC3nt0sTQ7PKqYxQ41LoHWtL+aFgOe0td6WYXGfeWOAjAW/iTzjXC0WEwknro6I7gYy/XnlZUg6HSgG2A1rSlLlPtJ4tEF1/2ykTn+nWd/0+EYWPZpMCHL3LNlqNhWGytHZuNpb4c15qnzNOKX5miwnh4WSR5lMUDwWJDl9lYUIs4u0sasTOgKkWaTR4B2+I/VLpp669XE056lKDhj7pS0q8PI7TMhJLocqxWenopJIsPATgLNUTvwJo7SwRVIOynJpJiTMEDzGk99MEUeKxk9ktAckFPBflV/aEuoVo2aJWyqLHk7IZuO9yTMsRVx2yolMy7GyiMOB1MlTTBGiJyDb45EKMjWtb01xyB9Ax8MtgxpW/+kQS6C51S4Ony0uqlhaF/k+ZBAmvVf5+6KY0PDy1MYgwKiRDZf0zMIYRgZEXNrOuihZA6rdwcJLfFXBb75J5qx3W1cTXm1ttVjZ7hRUdANUI/pdvMehCQ9/H5ozlzasBxIiKYvZT+HOtmmqxkU6rFI+ErizYl7ARL5E9z04b0YUBC59BVmr4fDySYoSPLXngETg8lSorakC+5GNqTPrUnewnOH3EM0X/CUo7YXM9BtAqBSc8LXJu37x1sfOWQb0blV7XGEoFw3pdlJSGNEQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261022075727099003)(11063799006)(5023799004)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MThoVUV6enVVd3BmQTVaaUc3anU5N1d4QWN0MkpFYjV1dzZybTRJazR1MzZU?=
 =?utf-8?B?Q3I3S1RLbTZrTUN6WGhIdFJvcW0yMXZUaGREeTBkRkM4cGJ0NHpDbjFsa0lL?=
 =?utf-8?B?T3hSODZKdE9kN0VGeXh5ZlliQjVtcEJkZjEzM2hGWlpTN3hlQVY1RFltZm1x?=
 =?utf-8?B?RG9DNlEra3VuMVRLM2J0aGRBeTJTNlRQZDhYendlaG1TWGpUOXpkamNOSWNL?=
 =?utf-8?B?QVFsNzRwVndkcXc0ZUFqSUFyaWZ3T3VxWFVWdDdTZ0gyeXM3RVhjbENvOHFq?=
 =?utf-8?B?VGFlYzlMcStjQllVY1NzVVBtZW1Mem93dFBOQXJYdUJwM3haOHhGMC9VenFZ?=
 =?utf-8?B?MmI1TmNXcHd0cDdXOStOdHhBWFB6NEFQb2plaGtudHJaeGllSWVXbk5MRHhv?=
 =?utf-8?B?bmRXZzViZlJOY0RxTjJEa3pzWlN1Yi9kaXlkNjYwbHJLbnljSWpJeUdueXU4?=
 =?utf-8?B?YVFUNWswVDJIaDhybW5IV0xUSCtEeEJaN2pEMUptR0RtUVpTblpSOFhiZWRq?=
 =?utf-8?B?OFpOMjJiWjZDbVI3TnJVZWFBK3MvdjlaQ0lIWjR6TXBuQUF1eUJ6cUUrb052?=
 =?utf-8?B?YmZEY2lGT2paRDdOS3ZqV0dsYUUzK08yTVVCVEo2L0JHUkIrR0drSmxidExO?=
 =?utf-8?B?RW9TdE5ncnJaUm5LK05RZmhTUmxPZjZEQzBWWWtwWitEU1BBcXBSQ3ZZZk52?=
 =?utf-8?B?ZE9LbHFDTXNuekRQYmlrbEVGOW1rNEtjdy9QUkNIeGhNaFI0bzRpNHlwSjl5?=
 =?utf-8?B?SU5jbkNJbUFYRHI5K21aS3BJOVNneWRaSTFsbm91emlXNWk2c3JFaVRhanF1?=
 =?utf-8?B?WEQzSTJhdlM1QnZrTUZ6bXI1LzFNbURpTjZYa0c0azltd1c2SDNFZUxxcDh2?=
 =?utf-8?B?dndZQldVWDc4eFdvMEh6c2lyR2dnbXN4TEJpWUhpUVlHbmc4TUNvU2NCbnJ6?=
 =?utf-8?B?dG84Lzl6aCtVcnpqSnNxbEJUakkxZEdjL1FLUEdaRzM2TXNiZGJPYk51T3ly?=
 =?utf-8?B?enA5QTZ1cndVZDZvM0tXRythMlZFb2dsY1ljUmJOZFdtejdva2Q1aU8vMWVo?=
 =?utf-8?B?cGJscW1tV0NvODZlTjVia0lWUjJ3TCtwYjRrTit1R3VsME41SnlrQUNSUGln?=
 =?utf-8?B?cFU5RVJLQ1lyQ2YzL2g5dUFtVC96ZzB6L1VuRGo0NEgzRGQyK3Ryby9tYjZl?=
 =?utf-8?B?QnJITzNKN3U2cE5sS0VJWEN4cE83eWUzVUxkQTh2eHZ1dmxheEM2NlE2VUhQ?=
 =?utf-8?B?UmZXUHA5M1NHaTcxZExyT1pDdXd5VTJuWm0yYm04UmpTcXFLMENsMk1XRytk?=
 =?utf-8?B?MDdCT2I5bjN4bVlZR29MRFhkLzJYeHBIZ0srNldVZExiT3ZENXdFRDg5OEtU?=
 =?utf-8?B?akMwQkh4WHp3M0ZYL0MrZzcrcVVGUWRqSllsTUd2TGpWSTdoUGVFeFc5d1pB?=
 =?utf-8?B?KzBVOU5aZE5SaWM3TmE3V2FrcFFVdFJ2bVY2bXVZN2JSZG5uU1dXcVY5TkFO?=
 =?utf-8?B?YkFIN1h5QVErQlB5Uk90UjdQM2JkV2kvSHBMNjhSSkdlR0YxT2lhanEvNzNv?=
 =?utf-8?B?dXBuMlJOVWltMERZVUdzNVZFbFpwei9CR01YcGFudHlMMUxnOXJnYllqQ0tB?=
 =?utf-8?B?UVFPSGFOOXdHUE9CaWN2TWxlSG1mZWJ2TG4yUHNXbjdpUkVMZFErWXY2Z21Y?=
 =?utf-8?B?VnZlZFpaWVJTMk85QU1YcWZJVlhDMS9CcHUwa1FiUkpyWFJoZFNLZXE0dk1q?=
 =?utf-8?B?VDh4dGcxVG8wZktXNVpjZ3hqSHVIcmJpbVRZbHlRZ1RUWWVnWWtVM3ZUWVZI?=
 =?utf-8?B?UHhqZElsVDI4aVBSNU43dWgzVTE0R0Y3RmlMRWVBN3duWU5TZ0JFTUwrVy94?=
 =?utf-8?B?QzYvb1RIK2xKbS9HNE5oWGlQeG1kUVcvakRRYWZyem16czlBa053d29HMUVW?=
 =?utf-8?B?elNuMHdLZlhzTlBZNnBVc2tEOXhKaEk0NTZML0RCeTFqVWc5Q2UrM3ZUTDNP?=
 =?utf-8?B?akVsQW8rVWxIc0xiZWxpWUE5Uk1melc5cWdzdzJseXg2QVFCWHBRQzR1M3pV?=
 =?utf-8?B?L0p4Vkd2YVlwV0x2eklxd1hFUkg4VDVtUXJEVi8xajNKUWJiZmh5Qmx0OTFD?=
 =?utf-8?B?TkhleGJNNkFaRUttZTJBeU1HamdwQWw4Z1ZzSmtIZ2EzanFsMlNtRi9Fd3R5?=
 =?utf-8?B?TGlMNnk5dlVrNldqVXJpUk9CZkJVbHhZSUF6QzBCZDFqejBZR3BXLzFnaVhS?=
 =?utf-8?B?NDE2bVM3dUlHekp4S05jV2cxTUFsWDJqd1ZWeVYvMzJCRXZKWHhWYlRROWNz?=
 =?utf-8?Q?41P76ZBWxYnokL3V6g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c73186a-c13c-48d6-d1aa-08df3b07e275
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:56.2210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ER5kLU4A+TipXuFJcB5D4jlgUJq9e08Jq5C/MiyeDsKYybyF+hNJudC8Q3qc4dQIwQfoI4YHgkoBNwZbH3EXLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

The match set negotiated at attach determines which types an attachment
could possibly be served with. Which one should actually be served
depends on where the buffer is and other attachments when an importer
first pins or maps. So far the first entry was used unconditionally,
even if it cannot be served to some importers.

Add dma_buf_ops.select_mapping() under dma_resv from both pin and map
paths before the type's map callback to let the exporter choose which to
serve based on the current placement and list of attachments.

The choice is recorded in attach->selected and does not call
select_mapping again across any number of unmaps and remaps, until
dma_buf_invalidate_mappings() has been delivered to the attachment.

This prevents importer remap from bouncing a buffer between placements
- the type cannot change without the exporter explicitly invalidating
first. In other words attachments that are never invalidated keep the
initially selected type for the life of the attachment.

A failed select or map establishes nothing and leaves the choice open.

Importers never select. The importer's list order is a preference the
exporter may weigh or ignore, and an importer must accept any type it
listed.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c |  66 +++++++++++++++++++++++-
 drivers/dma-buf/dma-buf.c         | 106 ++++++++++++++++++++++++++------------
 include/linux/dma-buf-mapping.h   |  17 ++++--
 include/linux/dma-buf.h           |  38 ++++++++++++++
 4 files changed, 190 insertions(+), 37 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 4eb0ea930900..ff2dbcca23d9 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -271,7 +271,8 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_free_sgt, "DMA_BUF");
  * importer entry of the same type that the type's match() callback accepts.
  * Every such pair is recorded in @args->attach->matches, so the match set
  * preserves the exporter's priority. The first entry is the default returned
- * by dma_buf_attach_map_type().
+ * by dma_buf_attach_map_type() until &dma_buf_ops.select_mapping chooses
+ * otherwise at pin or map time.
  *
  * Because the exporter list is walked in order, the exporter controls the
  * priority of mapping types.
@@ -324,6 +325,69 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
 
+/**
+ * dma_buf_mapping_select - Let the exporter choose the type to map with
+ * @attach: Attachment about to be pinned or mapped
+ *
+ * Called with the dma_resv lock held by dma_buf_pin() and the map functions.
+ * The first call after attach, and after each dma_buf_invalidate_mappings(),
+ * calls &dma_buf_ops.select_mapping to pick an entry of the match set given
+ * the buffer's placement and the other live mappings. Exporters without the
+ * callback get the first entry. Every other call returns the previous choice
+ * unchanged, so the mapping type cannot change between unmap and remap without
+ * the exporter having explicitly invalidated.
+ *
+ * Returns: 0 on success or the exporter's error, typically -EBUSY when the
+ * attachment cannot be served without disturbing a mapping that cannot be
+ * invalidated.
+ */
+int dma_buf_mapping_select(struct dma_buf_attachment *attach)
+{
+	int idx = 0;
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (attach->selected)
+		return 0;
+
+	if (WARN_ON(!attach->nr_matches))
+		return -EINVAL;
+
+	if (attach->dmabuf->ops->select_mapping) {
+		idx = attach->dmabuf->ops->select_mapping(attach);
+		if (idx < 0)
+			return idx;
+		if (WARN_ON(idx >= attach->nr_matches))
+			return -EINVAL;
+	}
+
+	attach->selected_idx = idx;
+	attach->selected = true;
+	return 0;
+}
+
+/**
+ * dma_buf_mapping_unselect - Undo a selection that established nothing
+ * @attach: Attachment whose pin or map just failed
+ * @was_selected: attach->selected before the failed pin or map began
+ *
+ * A pin or map that fails after dma_buf_mapping_select() may reopen the
+ * choice only if it was the one that made it. A selection that predates the
+ * call belongs to a live pin or mapping and must survive, otherwise the next
+ * pin or map would reselect under it without an invalidate.
+ */
+void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
+			      bool was_selected)
+{
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	if (was_selected)
+		return;
+
+	attach->selected = false;
+	attach->selected_idx = 0;
+}
+
 static int dma_buf_sgt_match(struct dma_buf_match_args *args,
 			     const struct dma_buf_mapping_match *exp,
 			     const struct dma_buf_mapping_match *imp)
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index b3d1f0f863a5..f052184da5ed 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1182,14 +1182,22 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_detach, "DMA_BUF");
 int dma_buf_pin(struct dma_buf_attachment *attach)
 {
 	struct dma_buf *dmabuf = attach->dmabuf;
+	bool selected = attach->selected;
 	int ret = 0;
 
 	WARN_ON(!attach->importer_ops);
 
 	dma_resv_assert_held(dmabuf->resv);
 
-	if (dmabuf->ops->pin)
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ret;
+
+	if (dmabuf->ops->pin) {
 		ret = dmabuf->ops->pin(attach);
+		if (ret)
+			dma_buf_mapping_unselect(attach, selected);
+	}
 
 	return ret;
 }
@@ -1216,42 +1224,19 @@ void dma_buf_unpin(struct dma_buf_attachment *attach)
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
 
-/**
- * dma_buf_map_sgt - Returns the scatterlist table of the attachment;
- * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
- * dma_buf_ops.
- * @attach:	[in]	attachment whose scatterlist is to be returned
- * @direction:	[in]	direction of DMA transfer
- *
- * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
- * on error. May return -EINTR if it is interrupted by a signal.
- *
- * On success, the DMA addresses and lengths in the returned scatterlist are
- * PAGE_SIZE aligned.
- *
- * A mapping must be unmapped by using dma_buf_unmap_sgt(). Note that
- * the underlying backing storage is pinned for as long as a mapping exists,
- * therefore users/importers should not hold onto a mapping for undue amounts of
- * time.
- *
- * Important: Dynamic importers must wait for the exclusive fence of the struct
- * dma_resv attached to the DMA-BUF first.
- */
-struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
-				 enum dma_data_direction direction)
+/* The SGT type must have been selected for the attachment already */
+static struct sg_table *
+__dma_buf_map_sgt(struct dma_buf_attachment *attach,
+		  enum dma_data_direction direction)
 {
 	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
 		dma_buf_get_sgt_ops(attach);
 	struct sg_table *sg_table;
 	signed long ret;
 
-	might_sleep();
-
-	if (WARN_ON(!attach || !attach->dmabuf || !sgt_exp_ops))
+	if (WARN_ON(!sgt_exp_ops))
 		return ERR_PTR(-EINVAL);
 
-	dma_resv_assert_held(attach->dmabuf->resv);
-
 	if (dma_buf_pin_on_map(attach)) {
 		ret = attach->dmabuf->ops->pin(attach);
 		/*
@@ -1311,6 +1296,53 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 
 	return sg_table;
 }
+
+/**
+ * dma_buf_map_sgt - Returns the scatterlist table of the attachment;
+ * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
+ * dma_buf_ops.
+ * @attach:	[in]	attachment whose scatterlist is to be returned
+ * @direction:	[in]	direction of DMA transfer
+ *
+ * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
+ * on error. May return -EINTR if it is interrupted by a signal.
+ *
+ * On success, the DMA addresses and lengths in the returned scatterlist are
+ * PAGE_SIZE aligned.
+ *
+ * A mapping must be unmapped by using dma_buf_unmap_sgt(). Note that
+ * the underlying backing storage is pinned for as long as a mapping exists,
+ * therefore users/importers should not hold onto a mapping for undue amounts of
+ * time.
+ *
+ * Important: Dynamic importers must wait for the exclusive fence of the struct
+ * dma_resv attached to the DMA-BUF first.
+ */
+struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
+				 enum dma_data_direction direction)
+{
+	struct sg_table *sg_table;
+	bool selected;
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(!attach || !attach->dmabuf))
+		return ERR_PTR(-EINVAL);
+
+	dma_resv_assert_held(attach->dmabuf->resv);
+
+	selected = attach->selected;
+	ret = dma_buf_mapping_select(attach);
+	if (ret)
+		return ERR_PTR(ret);
+
+	sg_table = __dma_buf_map_sgt(attach, direction);
+	if (IS_ERR(sg_table))
+		dma_buf_mapping_unselect(attach, selected);
+
+	return sg_table;
+}
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt, "DMA_BUF");
 
 /**
@@ -1455,6 +1487,10 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_attach_revocable, "DMA_BUF");
  *
  * Importers are free to request a new mapping in parallel as this function
  * returns.
+ *
+ * This is also the only point at which an attachment's mapping type
+ * may change after a pin/map: the core keeps the type chosen by
+ * &dma_buf_ops.select_mapping until the attachment has been invalidated here.
  */
 void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 {
@@ -1462,10 +1498,14 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 
 	dma_resv_assert_held(dmabuf->resv);
 
-	list_for_each_entry(attach, &dmabuf->attachments, node)
-		if (attach->importer_ops &&
-		    attach->importer_ops->invalidate_mappings)
-			attach->importer_ops->invalidate_mappings(attach);
+	list_for_each_entry(attach, &dmabuf->attachments, node) {
+		if (!attach->importer_ops ||
+		    !attach->importer_ops->invalidate_mappings)
+			continue;
+
+		attach->selected = false;
+		attach->importer_ops->invalidate_mappings(attach);
+	}
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_invalidate_mappings, "DMA_BUF");
 
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 69073d589e54..0ee798a5acdd 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -118,15 +118,26 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
  * dma_buf_attach_map_type - The match this attachment is mapped with
  * @attach: the attachment
  *
- * Returns the entry of @attach->matches in force for the attachment: the
- * exporter's default, which is the first entry.
+ * Returns the entry of @attach->matches the attachment is mapped with: the
+ * one the exporter selected at the last pin or map, or the exporter's
+ * default, the first entry, before anything was selected. After
+ * dma_buf_invalidate_mappings() it still names the type a live mapping was
+ * made with, so a pending unmap can use it, until the next selection.
  */
 static inline const struct dma_buf_mapping_match *
 dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
 {
-	return &attach->matches[0];
+	return &attach->matches[attach->selected_idx];
 }
 
+/*
+ * Internal: Selection is made by exporters through &dma_buf_ops.select_mapping
+ * in dma_buf_pin() or map paths. Importers never call this.
+ */
+int dma_buf_mapping_select(struct dma_buf_attachment *attach);
+void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
+			      bool was_selected);
+
 /*
  * DMA Mapped Scatterlist Type
  *
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index ecfd9b2d2aac..33582713a104 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -338,6 +338,32 @@ struct dma_buf_ops {
 	 * any time until the final location is resolved during map/pin.
 	 */
 	int (*match_mapping)(struct dma_buf_match_args *args);
+
+	/**
+	 * @select_mapping:
+	 *
+	 * Called with the dma_resv lock held from dma_buf_pin() and from the
+	 * map functions, before the type's map callback, to choose which
+	 * entry of &dma_buf_attachment.matches this attachment is mapped
+	 * with. The exporter settles the buffer's placement here, taking all
+	 * live mappings and pinned attachments into account, and returns the
+	 * entry that placement can serve.
+	 *
+	 * The core records the choice and does not ask again until the exporter
+	 * has delivered &dma_buf_attach_ops.invalidate_mappings to this
+	 * attachment. The exporter must therefore keep the recorded type
+	 * servable: moving the buffer somewhere the selected type cannot be
+	 * produced from requires invalidating first. Attachments that cannot
+	 * be invalidated keep their first choice for life.
+	 *
+	 * Optional. Without it the first entry of the match set, the
+	 * exporter's most preferred, is used.
+	 *
+	 * Returns: the index into &dma_buf_attachment.matches to use, or a
+	 * negative errno. -EBUSY means the attachment cannot be served without
+	 * disturbing a mapping that cannot be invalidated.
+	 */
+	int (*select_mapping)(struct dma_buf_attachment *attach);
 };
 
 /**
@@ -562,6 +588,16 @@ struct dma_buf_attach_ops {
  *           entry is the exporter's default; dma_buf_attach_map_type()
  *           returns the entry the attachment is mapped with.
  * @nr_matches: Number of valid entries in @matches.
+ * @selected_idx: Index into @matches of the entry the attachment is mapped
+ *                with, chosen by &dma_buf_ops.select_mapping at the first pin
+ *                or map and kept, enforced by the core, until
+ *                &dma_buf_attach_ops.invalidate_mappings is delivered to this
+ *                attachment. Zero, the exporter's default, before the first
+ *                selection. Still valid after an invalidate so that a pending
+ *                unmap sees the type its mapping was made with.
+ * @selected: True while @selected_idx is in force, i.e. the next pin or map
+ *            must not select again; cleared only by
+ *            dma_buf_invalidate_mappings().
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -582,6 +618,8 @@ struct dma_buf_attachment {
 	void *priv;
 	struct dma_buf_mapping_match matches[DMA_BUF_MAX_MATCHES];
 	unsigned int nr_matches;
+	unsigned int selected_idx;
+	bool selected;
 };
 
 /**

-- 
2.54.0

