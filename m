Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860900;
	b=Pph8Mfroc3ToDYY/LLQc/6k1KRw/njxOtxQHta1d3BTwBteXaKr4f6/bVlVOq1RKxUjP
	 wUpgA0yqO+zJLQDeAeNah/r9YXdGMWNzQ/mWK2uwrr9EKlIh3fbsJWafZRj/wBoo437PH
	 2k7Pb74pREicq4Y3f9FGeIT5zZmXhR3FQrKz3n88erh8z+cdiSNJbvpr77drvY2+HgCk4
	 9ThyWS6KnbGI++9hmSId+7nUmpMSzucJJjtJTeGOluYRRIgVXzSEJQ4vTwL7U7zk2jOoz
	 yd4BChEJ5TZZIp4m2oR7XE9U6k1/ZqwmZ91VEi2ZmVcETeKK6QgiFq8MIWstQ222kCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860900;
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
	bh=PsJxWY+KKhmeX3KoURxp8i4ClxiuU3eSXI9iCsEqzuw=;
	b=C9GDbZDWMvTPTOx8nZ2Y9fod02t7dcY+vzhIVaQJW6pb9OFy5F5X1X/gfCWvPX0J1+yb
	 Kh4dTw9KRvnayj/2N//aIa4X6jjUKsZqBpSPBRILbnX7HZ8r/SeQ+/0s1O3NXoyWhLonQ
	 Cvw3u8qlYd06kd5O6Z8gGMkWSWP0r3M2YF7btgmzPqer9+mSjfF9N6un2kEhPRmyx6YMb
	 np6b+isLXrJorC3er2Skth/NTuobWIk8PEMA06AL1K2m5RWuWmJ46CvD6YZ4K7peAuK43
	 sUtZitHE6rXiJaq9XruUW/oYU61klBL2AN3kJWfEmhvULPKnZs2RHLZf65+rNZh9mUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bK+vI3KL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.47
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C6606D801;
	Thu,  5 Nov 2026 06:41:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF9C6606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bK+vI3KL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OUAEVlOdWilslbaKz1bpwu3fp5Z+UzZnnytfephfD+GgWmL+9zUybC3JDs8EOVDOSSTqt/wLxn1TFlMRwebIWVCJlVSyGmFchsvMBfhL+FVKCNi3+++H/e8tthePOXUCOCTT3gDGz/JPUSWDh352FOMu5CJF92PtFweOxcqtRQCyU3jxyMu0JcEYiZPqv8khLO2YElwUZcpzbqp1TCQPDH6rKGs+vn+t0G2nSW1Nc4VNspmHVSoJzQkElIexsiHNv4bQP9v02WQ5BCZ5JEPuRVUcn8vOF5J8o95n0p1LTOmkksdA+cutfqnkhFxJJfrIb7deBm9XtvC3B6zmERPrBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsJxWY+KKhmeX3KoURxp8i4ClxiuU3eSXI9iCsEqzuw=;
 b=v0yF41gprBEs+y2+v6r1dr+CBdT4vRVOyjijsFMUSurCfk3Gevz8BCja8rJtmsFaShL6xXrsoPzwzaDd7W45x01rBwCLdpf9IzsZs561N5MkkM/XnUOOpgMR0kuqS+R4yCxshEdm0v03Y0FIilyMUKFvUbCYns1JSgpcnChUHWvT/g+46PxiIa+KtcPT9mDOG1G8lBq6zJi7wtANiHYGqNa9xTpmMHnEuGQiQio1QHVGM+35R3iaMJTEHFzAPcbWm3koWNuy4FdXXorl4zdHHd8AxFUNW+5SJ1cUNdQttc3CIfnQGR+Tl4hyiL24gdy+nLaFm8N/vx7NIPXL1QOfgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PsJxWY+KKhmeX3KoURxp8i4ClxiuU3eSXI9iCsEqzuw=;
 b=bK+vI3KLqFvS2oZ9UNIAuGg+V3GcCXMeCtSdWlUDAv7OEBYriB8shMQg5AmIfZzjspOItWF1wYAyNv3RzGZHHP2G7nLuQ5rtdq8u5cS/sy/GYlFy6jEsrDDXkTi51mTtnnIdChoA28ZT6nx+5E3CGSWvk0Jmag3fEtbN5UVC7LPsGx5ho9Y23q+iEvwQzReVZoR0qWoZ+4rkzLXqarqDnH9qfMpxfLu8PlWfbUp7zo+IVNhVLmJKDZFYDottScowK+WMQMqobj9+zsyKwpPp8ykrHVDHSrlGyWzJ2cdPxF6eNvxmIF206S1sQS78Hr7U42UIEJ6DE3iAN2mcJxeObg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:31 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:31 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:36 +1100
Subject: [PATCH v2 01/23] treewide: Rename dma_buf_(un)map_attachment() to
 dma_buf_(un)map_sgt()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-1-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=41737;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=iKv0U+D0KldEN43OnBfqO4plZykqq3T0fWAR3raw2aQ=;
 b=Wvlw+1omyZtbpzGc0vwZmFZL854j4KakmPSSHLkgUzqgabvO9SVsoULSwL32rLd7DmaK+LRQS
 sMOCaqKOo1wAHKZM1TdT7TMg4U/EijPCs6aM4iWuvhKJ7Fp8GzXKoqX
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0003.ausprd01.prod.outlook.com
 (2603:10c6:10:1fa::16) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 6c83677f-6983-44c2-eadc-08df3b07d3c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|260925021911599003|261021123027099003|261009223327099003|261022075727099003|260925021311599003|260925022911599003|11063799006|5023799004|56012099006|261009221227099003|261009220027099003|261009221727099003|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	TUoOdH/CSRfFx0uwAqiuurJQZOCpMdHo6zLQqatq3SrBJhotAAKq8J4w9mANRtcSKCoIUOHSu8A2XdPNVAsyc1vNxWEJbS4fPnXDkMq+X58RheTp/bAatOQ/oCN64nBelG+2PDcmq3KktPbiVFNn7O+rDF9jIiF6ERN9+572S9u3P52nB8oQ/p234je3i4cyIu5mAIfRmzYGUlMuKluxcNsjKqLEzYAc2Y++CiURZyBl5dC5XIcNflPzVyOemvFzpbpSXNT6+MBIRd9BR1bV7tKFwKqzObV02jlqKmO+9f7gnzyESBAGkdg6TfqVnLHvg5YnN/JuTTLRr51W1RcawvYtD1ixghX+7iAetnkQEkqNxxmmpKYsDqxjqzs2DhhZN/AiwYTTh1ZUdBKdUZOtprotIav7gF2iozOCRlsbH5rUpx7etO3fGpwTx7Pgn7Hpjd6JZCpFXq+m/bq+kiRxxw7ZbJl5P5jTE+SxSvlRPcF+XH+r3DNg+z37vS+n4lQ7Ae99VvAOL6zLz1mVHNBPJC5BAv7BgiT2yz1Td4wy1hWK5rDuaOLq1bmfmhP9pOIK5BOx85VOOqYzCLp0z4W+pJEjNVb3rEAOl4S/SbO+ruNaxyabY3yL9Zh9+x9KTGK0n8qMYzCGjFESPG9R06V2vvLW3cZULua4qwJUgYvAQ8KkMgEejDsRIwAHix9mT4q6mxnfpzO0kRQhLU9uhESKGA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(260925021911599003)(261021123027099003)(261009223327099003)(261022075727099003)(260925021311599003)(260925022911599003)(11063799006)(5023799004)(56012099006)(261009221227099003)(261009220027099003)(261009221727099003)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1EvTFZmV2haRk5ZcVhOa082SmhlZnVkYmVSZCt4ZFFpd3k5SFJWMC9mcGl0?=
 =?utf-8?B?N0JmS0xiemlBZmhjdTl3S2lFakpHd0pWNWZHQ0JIbGZ5akx1bUlNU1lVOXpQ?=
 =?utf-8?B?MWd5b2s4UzZWUU10amQ0YlQxTjE0QmFNM2JCQkdUTnBlTmtZOFFRU0dhaVRs?=
 =?utf-8?B?NjV4VnhOSGhPKzIyeGFOaGh4WW1vZHRRVFlTTEJOWUlsM0xOK2d3WGtDcHdE?=
 =?utf-8?B?amE1SjJYR1dJbGhOMWhlTXJ6UWl4czRpZXFreXJwS3p3MERxaWhQQjJ1SVho?=
 =?utf-8?B?MVVPT1RrYjBmRCswZEp0UXloOXBoeWFsN3NqY215b2NSa0pJR1U4MWE3UitD?=
 =?utf-8?B?OG1pZXQ3MFV4WjdhOThTUC9LTDZiOVdxcDk2SkRrT1Ntak5tSVI0WUlyOVM4?=
 =?utf-8?B?V3RjalVQZy9tcmZhQTMvOW5iZUtaTWVkaWNsT3kyd0VvS2JQKzB0cE94MFlR?=
 =?utf-8?B?eE9ja3paSXZtQjV2U1NpUEpQN2dQOFd3MnVYekxId2ZhVW15NERMS3U1UHJz?=
 =?utf-8?B?SjdKaEJnclJHNHJPQTh0NUxqdXhoOVZqR3N0bDNOdGREY3dpenBoUjY3QTUy?=
 =?utf-8?B?WExsOEM4SWZEK1B2ai9ZYk1OL2NxS0d2MnFEY1dYMVFtY014VFQ4WDcvdTgy?=
 =?utf-8?B?QXRXSGhKT0VqUytrYzdVZkhVNDlWN3ozU0pLd3V0RjJLT2dKUUozeHVKbEtU?=
 =?utf-8?B?RTAwQ1pWbjdINDVFT3hFangxbHRJbUwxcU5FdjlvR1RTTklJeW5ENDVvVXp2?=
 =?utf-8?B?WWhHdXROa1R5ZFovb1MxdlgxeENxNkN3ZStpMEJwc3dxSVVZQzZpUGZjQTRs?=
 =?utf-8?B?Y2N2cU04Sm9ycCs2STA5bTZkanpGQkVRVEhka0RZZnhWSDB2dVhwNVpJV29i?=
 =?utf-8?B?Wi9aYUJWVEc2dU52alByMVg2blB5TFpkYUxnK3FUZGJrU1pFd1NIR09NdUpZ?=
 =?utf-8?B?M1I0bDBKU0tveHAyQ2lPa0tIK3I5YXhzM2J0T0JGb2czZzRzZ3R3K1IyMTh3?=
 =?utf-8?B?MjdvRTBaRGhkRnFDSzdPNDZ6L1pEck9ibVhEbkgyaGhuUlVIWHJHQ3dBTEhK?=
 =?utf-8?B?bnhFV0R3S3V2N1htQUhIazlGdmY1U3NXc3FlcjNwWHo5M1Y4WldiZWtmMnky?=
 =?utf-8?B?cDd6WXE2cXVnTDgzL1VTTUtERUFKRmxmclRUM3dBM3ZTT0sxUkVISzBEOFdt?=
 =?utf-8?B?UzZERXhwa3N4QjhCRFAxbEx1RnQzQ1JhVVhCdXJJZ3hrV1NOcWJRbDBQbDBX?=
 =?utf-8?B?ODFDRS9uWklMMlQxdnpueU9UUE1nS2JaOFJlZHlGMHFFT0tveTlUZVA0aVJj?=
 =?utf-8?B?dXNJbjBqNExLTURBQmJwTCt4VWZPSUNoUWRhYmdJRVdQZUNyR0tvQVpOZ1Ex?=
 =?utf-8?B?RG43VEtNY3lMOE0wMXpsREpKeWhFdjhVNE5GVDlJNUprenpHWkJaN3UxQUsv?=
 =?utf-8?B?UEZ1WHJkSCtqbllGNDFNSzRBeHZpKzNiVEhIWktqUUtibUV3VnhValo0MDV0?=
 =?utf-8?B?REkrYTNiNVloZ2NhNEwzQ1VodW4rNUFvU2pSTlJPbjZwaE1nMDZ4UnNaaTd5?=
 =?utf-8?B?OElqUWlZOURBS3JOTnBzV2ZDbldYanhzOUg1MDAzQlpJVFVpMEpVaWU3V0Jt?=
 =?utf-8?B?ZTUrMjh5TFg4U3l4a2FGTW9wRTZNV2xLMWtoRGlDZHdYNzN2K0tDSGRzNnk3?=
 =?utf-8?B?eXRzQnlJOENDOExMYXdHY29FZnlHUFo0aWZkTDlQbFp0K201TEY1ZGN6NlB3?=
 =?utf-8?B?ekdMQzgzRWp2VWVXcXRUaXQxeGZiRnplRFh3eXhPbkpyVUNjTHUwUmV1Rm1i?=
 =?utf-8?B?VUdHanFjZWxqNkc1Y3pJRG1Xck10akxXSFJMMW53ZU0wKzNqTjRtU1dLNHB4?=
 =?utf-8?B?VXpVNXNNVFpSd3QvYXNWcWxlVDR2UDVXbVdDUHFxVGI5bW9pRWV3empncGhT?=
 =?utf-8?B?YXcxaHZBL2lCRHRBckxHOGZLQk9lRHVhM2xMZEtVT1F1Vkc2RFRwK2F3aW0z?=
 =?utf-8?B?QUNoVDN3bDJXZ05rUzJlRktyZncvdDM5TnRTK2JnM242K256NGUvcnBCNnFN?=
 =?utf-8?B?eXdnL3BaRVdMMDlGdzB4NjRxM1hyQ3FwZHZKbHg1Z2NXVFkxaCtMaEM4UlQ1?=
 =?utf-8?B?N0xuMEErdHR2MU1Ed0ROWFhPMDFwTkRFZm5paDRQeS93ZUdPc01XZGY0dnVF?=
 =?utf-8?B?K1I2TElPQUFhL0ZtdGVnUGNJQTBoZWFEUVJJZmNzSXNRNDVZcFF4MzUwVmZ1?=
 =?utf-8?B?ei9jWDBjaW5yM0NoZVR4b0hsMXhoWGsyMVJlWUxkZFl4elU3WllNR2N4WjdU?=
 =?utf-8?B?aTVMc1MvWGtxR3U4VXFtUnNyL2FMU0w5NmcrZ3oxSGJGcllnMlVBQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c83677f-6983-44c2-eadc-08df3b07d3c4
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:31.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vUrRwPN//cLv/hsteWnvn77myBW3HG6QfnIgSQcBTx0S4xgz6ifFdhY/MAnvZ7g/BzI68CAYE2+6pIM5U9O4Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

From: Jason Gunthorpe <jgg@nvidia.com>

These map and unmap functions only work with SGT importers. Rename them,
and their _unlocked variants, so the scatterlist based interface is
clearly named as such before further mapping types are added.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/amdxdna/amdxdna_gem.c                |  6 +--
 drivers/accel/ivpu/ivpu_gem.c                      |  6 +--
 drivers/accel/qaic/qaic_data.c                     |  6 +--
 drivers/dma-buf/dma-buf.c                          | 54 +++++++++++-----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  4 +-
 drivers/gpu/drm/armada/armada_gem.c                | 16 +++----
 drivers/gpu/drm/drm_prime.c                        |  6 +--
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c         |  8 ++--
 drivers/gpu/drm/i915/gem/i915_gem_object.c         |  2 +-
 .../gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c   |  4 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c          |  4 +-
 drivers/gpu/drm/tegra/gem.c                        | 14 +++---
 drivers/gpu/drm/virtio/virtgpu_prime.c             |  8 ++--
 drivers/gpu/drm/xe/xe_bo.c                         | 16 +++----
 drivers/iio/industrialio-buffer.c                  |  6 +--
 drivers/infiniband/core/umem_dmabuf.c              |  8 ++--
 drivers/media/common/videobuf2/videobuf2-core.c    |  2 +-
 .../media/common/videobuf2/videobuf2-dma-contig.c  |  8 ++--
 drivers/media/common/videobuf2/videobuf2-dma-sg.c  |  4 +-
 .../media/platform/nvidia/tegra-vde/dmabuf-cache.c |  6 +--
 drivers/misc/fastrpc.c                             |  6 +--
 drivers/nvme/host/pci-dmabuf.c                     |  6 +--
 drivers/usb/gadget/function/f_fs.c                 |  4 +-
 drivers/xen/gntdev-dmabuf.c                        |  8 ++--
 include/linux/dma-buf.h                            | 26 +++++------
 io_uring/zcrx.c                                    |  6 +--
 net/core/devmem.c                                  |  8 ++--
 27 files changed, 126 insertions(+), 126 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index f14484bc31ec..adee6e806eed 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -701,7 +701,7 @@ static struct dma_buf *amdxdna_gem_prime_export(struct drm_gem_object *gobj, int
 
 static void amdxdna_imported_obj_free(struct amdxdna_gem_obj *abo)
 {
-	dma_buf_unmap_attachment_unlocked(abo->attach, abo->base.sgt, DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt_unlocked(abo->attach, abo->base.sgt, DMA_BIDIRECTIONAL);
 	dma_buf_detach(abo->dma_buf, abo->attach);
 	dma_buf_put(abo->dma_buf);
 	drm_gem_object_release(to_gobj(abo));
@@ -1075,7 +1075,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
 		goto put_buf;
 	}
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_map_sgt_unlocked(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
@@ -1096,7 +1096,7 @@ amdxdna_gem_prime_import(struct drm_device *dev, struct dma_buf *dma_buf)
 	return gobj;
 
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 put_buf:
diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index c521a53f89bb..276f2a04aeda 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -54,7 +54,7 @@ static struct sg_table *ivpu_bo_map_attachment(struct ivpu_device *vdev, struct
 
 	sgt = bo->base.sgt;
 	if (!sgt) {
-		sgt = dma_buf_map_attachment(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
+		sgt = dma_buf_map_sgt(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
 		if (IS_ERR(sgt))
 			ivpu_err(vdev, "Failed to map BO in IOMMU: %ld\n", PTR_ERR(sgt));
 		else
@@ -158,8 +158,8 @@ static void ivpu_bo_unbind_locked(struct ivpu_bo *bo)
 
 	if (bo->base.sgt) {
 		if (drm_gem_is_imported(&bo->base.base)) {
-			dma_buf_unmap_attachment(bo->base.base.import_attach,
-						 bo->base.sgt, DMA_BIDIRECTIONAL);
+			dma_buf_unmap_sgt(bo->base.base.import_attach,
+					  bo->base.sgt, DMA_BIDIRECTIONAL);
 		} else {
 			dma_unmap_sgtable(vdev->drm.dev, bo->base.sgt, DMA_BIDIRECTIONAL, 0);
 			sg_free_table(bo->base.sgt);
diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index ee35e13091b3..d65578f0368e 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -869,7 +869,7 @@ struct drm_gem_object *qaic_gem_prime_import(struct drm_device *dev, struct dma_
 
 	drm_gem_private_object_init(dev, obj, attach->dmabuf->size);
 	/*
-	 * skipping dma_buf_map_attachment() as we do not know the direction
+	 * skipping dma_buf_map_sgt() as we do not know the direction
 	 * just yet. Once the direction is known in the subsequent IOCTL to
 	 * attach slicing, we can do it then.
 	 */
@@ -895,7 +895,7 @@ static int qaic_prepare_import_bo(struct qaic_bo *bo, struct qaic_attach_slice_h
 	struct sg_table *sgt;
 	int ret;
 
-	sgt = dma_buf_map_attachment(obj->import_attach, hdr->dir);
+	sgt = dma_buf_map_sgt(obj->import_attach, hdr->dir);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		return ret;
@@ -936,7 +936,7 @@ static int qaic_prepare_bo(struct qaic_device *qdev, struct qaic_bo *bo,
 
 static void qaic_unprepare_import_bo(struct qaic_bo *bo)
 {
-	dma_buf_unmap_attachment(bo->base.import_attach, bo->sgt, bo->dir);
+	dma_buf_unmap_sgt(bo->base.import_attach, bo->sgt, bo->dir);
 	bo->sgt = NULL;
 }
 
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 36cdc342627e..0dd8d0999a92 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -677,7 +677,7 @@ static struct file *dma_buf_getfile(size_t size, int flags)
  *
  * 3. Once the buffer is attached to all devices userspace can initiate DMA
  *    access to the shared buffer. In the kernel this is done by calling
- *    dma_buf_map_attachment() and dma_buf_unmap_attachment().
+ *    dma_buf_map_sgt() and dma_buf_unmap_sgt().
  *
  * 4. Once a driver is done with a shared buffer it needs to call
  *    dma_buf_detach() (after cleaning up any mappings) and then release the
@@ -955,8 +955,8 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *
  *     - dma_buf_pin()
  *     - dma_buf_unpin()
- *     - dma_buf_map_attachment()
- *     - dma_buf_unmap_attachment()
+ *     - dma_buf_map_sgt()
+ *     - dma_buf_unmap_sgt()
  *     - dma_buf_vmap()
  *     - dma_buf_vunmap()
  *
@@ -973,8 +973,8 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  *     - dma_buf_mmap()
  *     - dma_buf_begin_cpu_access()
  *     - dma_buf_end_cpu_access()
- *     - dma_buf_map_attachment_unlocked()
- *     - dma_buf_unmap_attachment_unlocked()
+ *     - dma_buf_map_sgt_unlocked()
+ *     - dma_buf_unmap_sgt_unlocked()
  *     - dma_buf_vmap_unlocked()
  *     - dma_buf_vunmap_unlocked()
  *
@@ -1165,7 +1165,7 @@ void dma_buf_unpin(struct dma_buf_attachment *attach)
 EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
 
 /**
- * dma_buf_map_attachment - Returns the scatterlist table of the attachment;
+ * dma_buf_map_sgt - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
  * dma_buf_ops.
  * @attach:	[in]	attachment whose scatterlist is to be returned
@@ -1177,7 +1177,7 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
  * On success, the DMA addresses and lengths in the returned scatterlist are
  * PAGE_SIZE aligned.
  *
- * A mapping must be unmapped by using dma_buf_unmap_attachment(). Note that
+ * A mapping must be unmapped by using dma_buf_unmap_sgt(). Note that
  * the underlying backing storage is pinned for as long as a mapping exists,
  * therefore users/importers should not hold onto a mapping for undue amounts of
  * time.
@@ -1185,8 +1185,8 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_unpin, "DMA_BUF");
  * Important: Dynamic importers must wait for the exclusive fence of the struct
  * dma_resv attached to the DMA-BUF first.
  */
-struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
-					enum dma_data_direction direction)
+struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
+				 enum dma_data_direction direction)
 {
 	struct sg_table *sg_table;
 	signed long ret;
@@ -1257,20 +1257,20 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 
 	return sg_table;
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt, "DMA_BUF");
 
 /**
- * dma_buf_map_attachment_unlocked - Returns the scatterlist table of the attachment;
+ * dma_buf_map_sgt_unlocked - Returns the scatterlist table of the attachment;
  * mapped into _device_ address space. Is a wrapper for map_dma_buf() of the
  * dma_buf_ops.
  * @attach:	[in]	attachment whose scatterlist is to be returned
  * @direction:	[in]	direction of DMA transfer
  *
- * Unlocked variant of dma_buf_map_attachment().
+ * Unlocked variant of dma_buf_map_sgt().
  */
 struct sg_table *
-dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
-				enum dma_data_direction direction)
+dma_buf_map_sgt_unlocked(struct dma_buf_attachment *attach,
+			 enum dma_data_direction direction)
 {
 	struct sg_table *sg_table;
 
@@ -1280,24 +1280,24 @@ dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
 		return ERR_PTR(-EINVAL);
 
 	dma_resv_lock(attach->dmabuf->resv, NULL);
-	sg_table = dma_buf_map_attachment(attach, direction);
+	sg_table = dma_buf_map_sgt(attach, direction);
 	dma_resv_unlock(attach->dmabuf->resv);
 
 	return sg_table;
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_map_attachment_unlocked, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt_unlocked, "DMA_BUF");
 
 /**
- * dma_buf_unmap_attachment - unmaps and decreases usecount of the buffer;might
+ * dma_buf_unmap_sgt - unmaps and decreases usecount of the buffer;might
  * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
  * dma_buf_ops.
  * @attach:	[in]	attachment to unmap buffer from
  * @sg_table:	[in]	scatterlist info of the buffer to unmap
  * @direction:  [in]    direction of DMA transfer
  *
- * This unmaps a DMA mapping for @attached obtained by dma_buf_map_attachment().
+ * This unmaps a DMA mapping for @attached obtained by dma_buf_map_sgt().
  */
-void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
+void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
 				enum dma_data_direction direction)
 {
@@ -1314,21 +1314,21 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
 	if (dma_buf_pin_on_map(attach))
 		attach->dmabuf->ops->unpin(attach);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_sgt, "DMA_BUF");
 
 /**
- * dma_buf_unmap_attachment_unlocked - unmaps and decreases usecount of the buffer;might
+ * dma_buf_unmap_sgt_unlocked - unmaps and decreases usecount of the buffer;might
  * deallocate the scatterlist associated. Is a wrapper for unmap_dma_buf() of
  * dma_buf_ops.
  * @attach:	[in]	attachment to unmap buffer from
  * @sg_table:	[in]	scatterlist info of the buffer to unmap
  * @direction:	[in]	direction of DMA transfer
  *
- * Unlocked variant of dma_buf_unmap_attachment().
+ * Unlocked variant of dma_buf_unmap_sgt().
  */
-void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
-				       struct sg_table *sg_table,
-				       enum dma_data_direction direction)
+void dma_buf_unmap_sgt_unlocked(struct dma_buf_attachment *attach,
+				struct sg_table *sg_table,
+				enum dma_data_direction direction)
 {
 	might_sleep();
 
@@ -1336,10 +1336,10 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
 		return;
 
 	dma_resv_lock(attach->dmabuf->resv, NULL);
-	dma_buf_unmap_attachment(attach, sg_table, direction);
+	dma_buf_unmap_sgt(attach, sg_table, direction);
 	dma_resv_unlock(attach->dmabuf->resv);
 }
-EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
+EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_sgt_unlocked, "DMA_BUF");
 
 /**
  * dma_buf_attach_revocable - check if a DMA-buf importer implements
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 0f86777250fc..30ec5cb9ddf5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -962,7 +962,7 @@ static int amdgpu_ttm_backend_bind(struct ttm_device *bdev,
 			struct sg_table *sgt;
 
 			attach = gtt->gobj->import_attach;
-			sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+			sgt = dma_buf_map_sgt(attach, DMA_BIDIRECTIONAL);
 			if (IS_ERR(sgt))
 				return PTR_ERR(sgt);
 
@@ -1083,7 +1083,7 @@ static void amdgpu_ttm_backend_unbind(struct ttm_device *bdev,
 		struct dma_buf_attachment *attach;
 
 		attach = gtt->gobj->import_attach;
-		dma_buf_unmap_attachment(attach, ttm->sg, DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt(attach, ttm->sg, DMA_BIDIRECTIONAL);
 		ttm->sg = NULL;
 	}
 
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index da7335cbe82d..044acdef6351 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -67,8 +67,8 @@ void armada_gem_free_object(struct drm_gem_object *obj)
 	if (dobj->obj.import_attach) {
 		/* We only ever display imported data */
 		if (dobj->sgt)
-			dma_buf_unmap_attachment_unlocked(dobj->obj.import_attach,
-							  dobj->sgt, DMA_TO_DEVICE);
+			dma_buf_unmap_sgt_unlocked(dobj->obj.import_attach,
+						   dobj->sgt, DMA_TO_DEVICE);
 		drm_prime_gem_destroy(&dobj->obj, NULL);
 	}
 
@@ -529,7 +529,7 @@ armada_gem_prime_import(struct drm_device *dev, struct dma_buf *buf)
 	get_dma_buf(buf);
 
 	/*
-	 * Don't call dma_buf_map_attachment() here - it maps the
+	 * Don't call dma_buf_map_sgt() here - it maps the
 	 * scatterlist immediately for DMA, and this is not always
 	 * an appropriate thing to do.
 	 */
@@ -540,20 +540,20 @@ int armada_gem_map_import(struct armada_gem_object *dobj)
 {
 	int ret;
 
-	dobj->sgt = dma_buf_map_attachment_unlocked(dobj->obj.import_attach,
-						    DMA_TO_DEVICE);
+	dobj->sgt = dma_buf_map_sgt_unlocked(dobj->obj.import_attach,
+					     DMA_TO_DEVICE);
 	if (IS_ERR(dobj->sgt)) {
 		ret = PTR_ERR(dobj->sgt);
 		dobj->sgt = NULL;
-		DRM_ERROR("dma_buf_map_attachment() error: %d\n", ret);
+		DRM_ERROR("dma_buf_map_sgt() error: %d\n", ret);
 		return ret;
 	}
 	if (dobj->sgt->nents > 1) {
-		DRM_ERROR("dma_buf_map_attachment() returned an (unsupported) scattered list\n");
+		DRM_ERROR("dma_buf_map_sgt() returned an (unsupported) scattered list\n");
 		return -EINVAL;
 	}
 	if (sg_dma_len(dobj->sgt->sgl) < dobj->obj.size) {
-		DRM_ERROR("dma_buf_map_attachment() returned a small buffer\n");
+		DRM_ERROR("dma_buf_map_sgt() returned a small buffer\n");
 		return -EINVAL;
 	}
 	dobj->dev_addr = sg_dma_address(dobj->sgt->sgl);
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index fe3436d1235d..e27bda3423ed 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -993,7 +993,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 
 	get_dma_buf(dma_buf);
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_map_sgt_unlocked(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
@@ -1011,7 +1011,7 @@ struct drm_gem_object *drm_gem_prime_import_dev(struct drm_device *dev,
 	return obj;
 
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 	dma_buf_put(dma_buf);
@@ -1109,7 +1109,7 @@ void drm_prime_gem_destroy(struct drm_gem_object *obj, struct sg_table *sg)
 
 	attach = obj->import_attach;
 	if (sg)
-		dma_buf_unmap_attachment_unlocked(attach, sg, DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt_unlocked(attach, sg, DMA_BIDIRECTIONAL);
 	dma_buf = attach->dmabuf;
 	dma_buf_detach(attach->dmabuf, attach);
 	/* remove the reference */
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
index b43d34c7d641..4ab54d2e616f 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c
@@ -240,8 +240,8 @@ static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
 
 	assert_object_held(obj);
 
-	sgt = dma_buf_map_attachment(obj->base.import_attach,
-				     DMA_BIDIRECTIONAL);
+	sgt = dma_buf_map_sgt(obj->base.import_attach,
+			      DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
@@ -268,8 +268,8 @@ static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
 static void i915_gem_object_put_pages_dmabuf(struct drm_i915_gem_object *obj,
 					     struct sg_table *sgt)
 {
-	dma_buf_unmap_attachment(obj->base.import_attach, sgt,
-				 DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt(obj->base.import_attach, sgt,
+			  DMA_BIDIRECTIONAL);
 }
 
 static const struct drm_i915_gem_object_ops i915_gem_object_dmabuf_ops = {
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 9e01f8b2079a..1e0aafc3643b 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -367,7 +367,7 @@ void __i915_gem_object_pages_fini(struct drm_i915_gem_object *obj)
 	atomic_set(&obj->mm.pages_pin_count, 0);
 
 	/*
-	 * dma_buf_unmap_attachment() requires reservation to be
+	 * dma_buf_unmap_sgt() requires reservation to be
 	 * locked. The imported GEM shouldn't share reservation lock
 	 * and ttm_bo_cleanup_memtype_use() shouldn't be invoked for
 	 * dma-buf, so it's safe to take the lock.
diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
index 2fda549dd82d..af9ced05f7a8 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_dmabuf.c
@@ -293,7 +293,7 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
 		goto out_import;
 	}
 
-	st = dma_buf_map_attachment_unlocked(import_attach, DMA_BIDIRECTIONAL);
+	st = dma_buf_map_sgt_unlocked(import_attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(st)) {
 		err = PTR_ERR(st);
 		goto out_detach;
@@ -306,7 +306,7 @@ static int igt_dmabuf_import_same_driver(struct drm_i915_private *i915,
 		timeout = -ETIME;
 	}
 	err = timeout > 0 ? 0 : timeout;
-	dma_buf_unmap_attachment_unlocked(import_attach, st, DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt_unlocked(import_attach, st, DMA_BIDIRECTIONAL);
 out_detach:
 	dma_buf_detach(dmabuf, import_attach);
 out_import:
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index 30cf1cdc1aa3..afae0a56da8c 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -120,7 +120,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 
 	get_dma_buf(dma_buf);
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_TO_DEVICE);
+	sgt = dma_buf_map_sgt_unlocked(attach, DMA_TO_DEVICE);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		goto fail_detach;
@@ -137,7 +137,7 @@ struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 	return obj;
 
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_TO_DEVICE);
+	dma_buf_unmap_sgt_unlocked(attach, sgt, DMA_TO_DEVICE);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 	dma_buf_put(dma_buf);
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index f76af733ea79..e6aa6dae4ec8 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -86,7 +86,7 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 			goto free;
 		}
 
-		map->sgt = dma_buf_map_attachment_unlocked(map->attach, direction);
+		map->sgt = dma_buf_map_sgt_unlocked(map->attach, direction);
 		if (IS_ERR(map->sgt)) {
 			dma_buf_detach(buf, map->attach);
 			err = PTR_ERR(map->sgt);
@@ -162,8 +162,8 @@ static struct host1x_bo_mapping *tegra_bo_pin(struct device *dev, struct host1x_
 static void tegra_bo_unpin(struct host1x_bo_mapping *map)
 {
 	if (map->attach) {
-		dma_buf_unmap_attachment_unlocked(map->attach, map->sgt,
-						  map->direction);
+		dma_buf_unmap_sgt_unlocked(map->attach, map->sgt,
+					   map->direction);
 		dma_buf_detach(map->attach->dmabuf, map->attach);
 	} else {
 		dma_unmap_sgtable(map->dev, map->sgt, map->direction, 0);
@@ -479,7 +479,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 			goto free;
 		}
 
-		bo->sgt = dma_buf_map_attachment_unlocked(attach, DMA_TO_DEVICE);
+		bo->sgt = dma_buf_map_sgt_unlocked(attach, DMA_TO_DEVICE);
 		if (IS_ERR(bo->sgt)) {
 			err = PTR_ERR(bo->sgt);
 			goto detach;
@@ -499,7 +499,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_device *drm,
 
 detach:
 	if (!IS_ERR_OR_NULL(bo->sgt))
-		dma_buf_unmap_attachment_unlocked(attach, bo->sgt, DMA_TO_DEVICE);
+		dma_buf_unmap_sgt_unlocked(attach, bo->sgt, DMA_TO_DEVICE);
 
 	dma_buf_detach(buf, attach);
 	dma_buf_put(buf);
@@ -520,8 +520,8 @@ void tegra_bo_free_object(struct drm_gem_object *gem)
 		tegra_bo_iommu_unmap(tegra, bo);
 
 		if (drm_gem_is_imported(gem)) {
-			dma_buf_unmap_attachment_unlocked(gem->import_attach, bo->sgt,
-							  DMA_TO_DEVICE);
+			dma_buf_unmap_sgt_unlocked(gem->import_attach, bo->sgt,
+						   DMA_TO_DEVICE);
 			dma_buf_detach(gem->import_attach->dmabuf, gem->import_attach);
 		}
 	}
diff --git a/drivers/gpu/drm/virtio/virtgpu_prime.c b/drivers/gpu/drm/virtio/virtgpu_prime.c
index ebf471044d06..a47783b47dcc 100644
--- a/drivers/gpu/drm/virtio/virtgpu_prime.c
+++ b/drivers/gpu/drm/virtio/virtgpu_prime.c
@@ -161,13 +161,13 @@ int virtgpu_dma_buf_import_sgt(struct virtio_gpu_mem_entry **ents,
 	if (ret <= 0)
 		return ret < 0 ? ret : -ETIMEDOUT;
 
-	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_map_sgt(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
 	*ents = kvmalloc_objs(struct virtio_gpu_mem_entry, sgt->nents);
 	if (!(*ents)) {
-		dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt(attach, sgt, DMA_BIDIRECTIONAL);
 		return -ENOMEM;
 	}
 
@@ -192,8 +192,8 @@ static void virtgpu_dma_buf_unmap(struct virtio_gpu_object *bo)
 		virtio_gpu_detach_object_fenced(bo);
 
 		if (bo->sgt)
-			dma_buf_unmap_attachment(attach, bo->sgt,
-						 DMA_BIDIRECTIONAL);
+			dma_buf_unmap_sgt(attach, bo->sgt,
+					  DMA_BIDIRECTIONAL);
 
 		bo->sgt = NULL;
 	}
diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 12e523c61c1f..14b71d951659 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -869,7 +869,7 @@ static int xe_bo_move_dmabuf(struct ttm_buffer_object *ttm_bo,
 	    ttm_bo->sg) {
 		dma_resv_wait_timeout(ttm_bo->base.resv, DMA_RESV_USAGE_BOOKKEEP,
 				      false, MAX_SCHEDULE_TIMEOUT);
-		dma_buf_unmap_attachment(attach, ttm_bo->sg, DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt(attach, ttm_bo->sg, DMA_BIDIRECTIONAL);
 		ttm_bo->sg = NULL;
 	}
 
@@ -877,11 +877,11 @@ static int xe_bo_move_dmabuf(struct ttm_buffer_object *ttm_bo,
 		goto out;
 
 	if (ttm_bo->sg) {
-		dma_buf_unmap_attachment(attach, ttm_bo->sg, DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt(attach, ttm_bo->sg, DMA_BIDIRECTIONAL);
 		ttm_bo->sg = NULL;
 	}
 
-	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
+	sg = dma_buf_map_sgt(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sg))
 		return PTR_ERR(sg);
 
@@ -1750,9 +1750,9 @@ int xe_bo_dma_unmap_pinned(struct xe_bo *bo)
 		struct xe_ttm_tt *xe_tt = container_of(tt, typeof(*xe_tt), ttm);
 
 		if (ttm_bo->type == ttm_bo_type_sg && ttm_bo->sg) {
-			dma_buf_unmap_attachment(ttm_bo->base.import_attach,
-						 ttm_bo->sg,
-						 DMA_BIDIRECTIONAL);
+			dma_buf_unmap_sgt(ttm_bo->base.import_attach,
+					  ttm_bo->sg,
+					  DMA_BIDIRECTIONAL);
 			ttm_bo->sg = NULL;
 			xe_tt->sg = NULL;
 		} else if (xe_tt->sg) {
@@ -1867,8 +1867,8 @@ static void xe_ttm_bo_delete_mem_notify(struct ttm_buffer_object *ttm_bo)
 		struct xe_ttm_tt *xe_tt = container_of(ttm_bo->ttm,
 						       struct xe_ttm_tt, ttm);
 
-		dma_buf_unmap_attachment(ttm_bo->base.import_attach, ttm_bo->sg,
-					 DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt(ttm_bo->base.import_attach, ttm_bo->sg,
+				  DMA_BIDIRECTIONAL);
 		ttm_bo->sg = NULL;
 		xe_tt->sg = NULL;
 	}
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 4294101810fd..4a1063e4891f 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1593,7 +1593,7 @@ static void iio_buffer_dmabuf_release(struct kref *ref)
 	struct iio_buffer *buffer = priv->buffer;
 	struct dma_buf *dmabuf = attach->dmabuf;
 
-	dma_buf_unmap_attachment_unlocked(attach, priv->sgt, priv->dir);
+	dma_buf_unmap_sgt_unlocked(attach, priv->sgt, priv->dir);
 
 	buffer->access->detach_dmabuf(buffer, priv->block);
 
@@ -1733,7 +1733,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	priv->dir = buffer->direction == IIO_BUFFER_DIRECTION_IN
 		? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
-	priv->sgt = dma_buf_map_attachment(attach, priv->dir);
+	priv->sgt = dma_buf_map_sgt(attach, priv->dir);
 	if (IS_ERR(priv->sgt)) {
 		err = PTR_ERR(priv->sgt);
 		dev_err(&indio_dev->dev, "Unable to map attachment: %d\n", err);
@@ -1781,7 +1781,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	return 0;
 
 err_dmabuf_unmap_attachment:
-	dma_buf_unmap_attachment(attach, priv->sgt, priv->dir);
+	dma_buf_unmap_sgt(attach, priv->sgt, priv->dir);
 err_resv_unlock:
 	dma_resv_unlock(dmabuf->resv);
 err_dmabuf_detach:
diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 39b5564a4c35..f233fdac9a17 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -29,8 +29,8 @@ int ib_umem_dmabuf_map_pages(struct ib_umem_dmabuf *umem_dmabuf)
 	if (umem_dmabuf->sgt)
 		goto wait_fence;
 
-	sgt = dma_buf_map_attachment(umem_dmabuf->attach,
-				     DMA_BIDIRECTIONAL);
+	sgt = dma_buf_map_sgt(umem_dmabuf->attach,
+			      DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
@@ -106,8 +106,8 @@ void ib_umem_dmabuf_unmap_pages(struct ib_umem_dmabuf *umem_dmabuf)
 		umem_dmabuf->last_sg_trim = 0;
 	}
 
-	dma_buf_unmap_attachment(umem_dmabuf->attach, umem_dmabuf->sgt,
-				 DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt(umem_dmabuf->attach, umem_dmabuf->sgt,
+			  DMA_BIDIRECTIONAL);
 
 	umem_dmabuf->sgt = NULL;
 }
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index b0a6084f1757..61a614074222 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1464,7 +1464,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
 			vb->planes[plane].mem_priv = mem_priv;
 
 			/*
-			 * This pins the buffer(s) with dma_buf_map_attachment()). It's done
+			 * This pins the buffer(s) with dma_buf_map_sgt()). It's done
 			 * here instead just before the DMA, while queueing the buffer(s) so
 			 * userspace knows sooner rather than later if the dma-buf map fails.
 			 */
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index 9ce6284cd5f2..284482335c1a 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -705,7 +705,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	}
 
 	/* get the associated scatterlist for this buffer */
-	sgt = dma_buf_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
+	sgt = dma_buf_map_sgt_unlocked(buf->db_attach, buf->dma_dir);
 	if (IS_ERR(sgt)) {
 		pr_err("Error getting dmabuf scatterlist\n");
 		return -EINVAL;
@@ -716,8 +716,8 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
 	if (contig_size < buf->size) {
 		pr_err("contiguous chunk is too small %lu/%lu\n",
 		       contig_size, buf->size);
-		dma_buf_unmap_attachment_unlocked(buf->db_attach, sgt,
-						  buf->dma_dir);
+		dma_buf_unmap_sgt_unlocked(buf->db_attach, sgt,
+					   buf->dma_dir);
 		return -EFAULT;
 	}
 
@@ -748,7 +748,7 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
 		dma_buf_vunmap_unlocked(buf->db_attach->dmabuf, &map);
 		buf->vaddr = NULL;
 	}
-	dma_buf_unmap_attachment_unlocked(buf->db_attach, sgt, buf->dma_dir);
+	dma_buf_unmap_sgt_unlocked(buf->db_attach, sgt, buf->dma_dir);
 
 	buf->dma_addr = 0;
 	buf->dma_sgt = NULL;
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index b1d0695cda26..54b07e3840ac 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -565,7 +565,7 @@ static int vb2_dma_sg_map_dmabuf(void *mem_priv)
 	}
 
 	/* get the associated scatterlist for this buffer */
-	sgt = dma_buf_map_attachment_unlocked(buf->db_attach, buf->dma_dir);
+	sgt = dma_buf_map_sgt_unlocked(buf->db_attach, buf->dma_dir);
 	if (IS_ERR(sgt)) {
 		pr_err("Error getting dmabuf scatterlist\n");
 		return -EINVAL;
@@ -597,7 +597,7 @@ static void vb2_dma_sg_unmap_dmabuf(void *mem_priv)
 		dma_buf_vunmap_unlocked(buf->db_attach->dmabuf, &map);
 		buf->vaddr = NULL;
 	}
-	dma_buf_unmap_attachment_unlocked(buf->db_attach, sgt, buf->dma_dir);
+	dma_buf_unmap_sgt_unlocked(buf->db_attach, sgt, buf->dma_dir);
 
 	buf->dma_sgt = NULL;
 }
diff --git a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
index 7752064be783..d9bac7cd855a 100644
--- a/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
+++ b/drivers/media/platform/nvidia/tegra-vde/dmabuf-cache.c
@@ -38,7 +38,7 @@ static void tegra_vde_release_entry(struct tegra_vde_cache_entry *entry)
 	if (entry->vde->domain)
 		tegra_vde_iommu_unmap(entry->vde, entry->iova);
 
-	dma_buf_unmap_attachment_unlocked(entry->a, entry->sgt, entry->dma_dir);
+	dma_buf_unmap_sgt_unlocked(entry->a, entry->sgt, entry->dma_dir);
 	dma_buf_detach(dmabuf, entry->a);
 	dma_buf_put(dmabuf);
 
@@ -102,7 +102,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
 		goto err_unlock;
 	}
 
-	sgt = dma_buf_map_attachment_unlocked(attachment, dma_dir);
+	sgt = dma_buf_map_sgt_unlocked(attachment, dma_dir);
 	if (IS_ERR(sgt)) {
 		dev_err(dev, "Failed to get dmabufs sg_table\n");
 		err = PTR_ERR(sgt);
@@ -152,7 +152,7 @@ int tegra_vde_dmabuf_cache_map(struct tegra_vde *vde,
 err_free:
 	kfree(entry);
 err_unmap:
-	dma_buf_unmap_attachment_unlocked(attachment, sgt, dma_dir);
+	dma_buf_unmap_sgt_unlocked(attachment, sgt, dma_dir);
 err_detach:
 	dma_buf_detach(dmabuf, attachment);
 err_unlock:
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index af18ff1992ee..76c8dc05fa10 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -401,8 +401,8 @@ static void fastrpc_free_map(struct kref *ref)
 				return;
 			}
 		}
-		dma_buf_unmap_attachment_unlocked(map->attach, map->table,
-						  DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt_unlocked(map->attach, map->table,
+					   DMA_BIDIRECTIONAL);
 		dma_buf_detach(map->buf, map->attach);
 		dma_buf_put(map->buf);
 	}
@@ -911,7 +911,7 @@ static int fastrpc_map_attach(struct fastrpc_user *fl, int fd,
 		goto attach_err;
 	}
 
-	table = dma_buf_map_attachment_unlocked(map->attach, DMA_BIDIRECTIONAL);
+	table = dma_buf_map_sgt_unlocked(map->attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(table)) {
 		err = PTR_ERR(table);
 		goto map_err;
diff --git a/drivers/nvme/host/pci-dmabuf.c b/drivers/nvme/host/pci-dmabuf.c
index 161e4ffa6919..fe741dc0d54a 100644
--- a/drivers/nvme/host/pci-dmabuf.c
+++ b/drivers/nvme/host/pci-dmabuf.c
@@ -41,7 +41,7 @@ static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx *ctx)
 		return ERR_PTR(-ENOMEM);
 	map->nr_entries = nr_entries;
 
-	sgt = dma_buf_map_attachment(attach, ctx->dir);
+	sgt = dma_buf_map_sgt(attach, ctx->dir);
 	if (IS_ERR(sgt)) {
 		ret = PTR_ERR(sgt);
 		sgt = NULL;
@@ -71,7 +71,7 @@ static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx *ctx)
 	return &map->base;
 err:
 	if (sgt)
-		dma_buf_unmap_attachment(attach, sgt, ctx->dir);
+		dma_buf_unmap_sgt(attach, sgt, ctx->dir);
 	kvfree(map);
 	return ERR_PTR(ret);
 }
@@ -84,7 +84,7 @@ static void nvme_dma_buf_io_unmap(struct dma_buf_io_ctx *ctx,
 
 	dma_resv_assert_held(ctx->dmabuf->resv);
 
-	dma_buf_unmap_attachment(nvme_ctx->attach, map->sgt, ctx->dir);
+	dma_buf_unmap_sgt(nvme_ctx->attach, map->sgt, ctx->dir);
 	kvfree(map);
 }
 
diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c64a268e98a4..2f221d0a983f 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1365,7 +1365,7 @@ static void ffs_dmabuf_release(struct kref *ref)
 	struct dma_buf *dmabuf = attach->dmabuf;
 
 	pr_vdebug("FFS DMABUF release\n");
-	dma_buf_unmap_attachment_unlocked(attach, priv->sgt, priv->dir);
+	dma_buf_unmap_sgt_unlocked(attach, priv->sgt, priv->dir);
 
 	dma_buf_detach(attach->dmabuf, attach);
 	dma_buf_put(dmabuf);
@@ -1566,7 +1566,7 @@ static int ffs_dmabuf_attach(struct file *file, int fd)
 	if (err)
 		goto err_free_priv;
 
-	sg_table = dma_buf_map_attachment(attach, dir);
+	sg_table = dma_buf_map_sgt(attach, dir);
 	dma_resv_unlock(dmabuf->resv);
 
 	if (IS_ERR(sg_table)) {
diff --git a/drivers/xen/gntdev-dmabuf.c b/drivers/xen/gntdev-dmabuf.c
index df1883aca850..e07e34515421 100644
--- a/drivers/xen/gntdev-dmabuf.c
+++ b/drivers/xen/gntdev-dmabuf.c
@@ -587,7 +587,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 
 	gntdev_dmabuf->u.imp.attach = attach;
 
-	sgt = dma_buf_map_attachment_unlocked(attach, DMA_BIDIRECTIONAL);
+	sgt = dma_buf_map_sgt_unlocked(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sgt)) {
 		ret = ERR_CAST(sgt);
 		goto fail_detach;
@@ -650,7 +650,7 @@ dmabuf_imp_to_refs(struct gntdev_dmabuf_priv *priv, struct device *dev,
 fail_end_access:
 	dmabuf_imp_end_foreign_access(gntdev_dmabuf->u.imp.refs, count);
 fail_unmap:
-	dma_buf_unmap_attachment_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
+	dma_buf_unmap_sgt_unlocked(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
 fail_free_obj:
@@ -700,8 +700,8 @@ static int dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
 	attach = gntdev_dmabuf->u.imp.attach;
 
 	if (gntdev_dmabuf->u.imp.sgt)
-		dma_buf_unmap_attachment_unlocked(attach, gntdev_dmabuf->u.imp.sgt,
-						  DMA_BIDIRECTIONAL);
+		dma_buf_unmap_sgt_unlocked(attach, gntdev_dmabuf->u.imp.sgt,
+					   DMA_BIDIRECTIONAL);
 	dma_buf = attach->dmabuf;
 	dma_buf_detach(attach->dmabuf, attach);
 	dma_buf_put(dma_buf);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index d15b2b31d3c9..cedeb8ebc99e 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -116,7 +116,7 @@ struct dma_buf_ops {
 	/**
 	 * @map_dma_buf:
 	 *
-	 * This is called by dma_buf_map_attachment() and is used to map a
+	 * This is called by dma_buf_map_sgt() and is used to map a
 	 * shared &dma_buf into device address space, and it is mandatory. It
 	 * can only be called if @attach has been called successfully.
 	 *
@@ -173,7 +173,7 @@ struct dma_buf_ops {
 	/**
 	 * @unmap_dma_buf:
 	 *
-	 * This is called by dma_buf_unmap_attachment() and should unmap and
+	 * This is called by dma_buf_unmap_sgt() and should unmap and
 	 * release the &sg_table allocated in @map_dma_buf, and it is mandatory.
 	 * For static dma_buf handling this might also unpin the backing
 	 * storage if this is the last mapping of the DMA buffer.
@@ -470,7 +470,7 @@ struct dma_buf_attach_ops {
  * @peer2peer: true if the importer can handle peer resources without pages.
  * @priv: exporter specific attachment data.
  * @importer_ops: importer operations for this attachment, if provided
- * dma_buf_map/unmap_attachment() must be called with the dma_resv lock held.
+ * dma_buf_map/unmap_sgt() must be called with the dma_resv lock held.
  * @importer_priv: importer specific attachment data.
  *
  * This structure holds the attachment information between the dma_buf buffer
@@ -479,8 +479,8 @@ struct dma_buf_attach_ops {
  *
  * An attachment is created by calling dma_buf_attach(), and released again by
  * calling dma_buf_detach(). The DMA mapping itself needed to initiate a
- * transfer is created by dma_buf_map_attachment() and freed again by calling
- * dma_buf_unmap_attachment().
+ * transfer is created by dma_buf_map_sgt() and freed again by calling
+ * dma_buf_unmap_sgt().
  */
 struct dma_buf_attachment {
 	struct dma_buf *dmabuf;
@@ -571,10 +571,10 @@ void dma_buf_fd_install(struct dma_buf *dmabuf, int fd);
 struct dma_buf *dma_buf_get(int fd);
 void dma_buf_put(struct dma_buf *dmabuf);
 
-struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
-					enum dma_data_direction);
-void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
-				enum dma_data_direction);
+struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *,
+				 enum dma_data_direction);
+void dma_buf_unmap_sgt(struct dma_buf_attachment *, struct sg_table *,
+		       enum dma_data_direction);
 void dma_buf_invalidate_mappings(struct dma_buf *dma_buf);
 bool dma_buf_attach_revocable(struct dma_buf_attachment *attach);
 int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
@@ -582,11 +582,11 @@ int dma_buf_begin_cpu_access(struct dma_buf *dma_buf,
 int dma_buf_end_cpu_access(struct dma_buf *dma_buf,
 			   enum dma_data_direction dir);
 struct sg_table *
-dma_buf_map_attachment_unlocked(struct dma_buf_attachment *attach,
+dma_buf_map_sgt_unlocked(struct dma_buf_attachment *attach,
+			 enum dma_data_direction direction);
+void dma_buf_unmap_sgt_unlocked(struct dma_buf_attachment *attach,
+				struct sg_table *sg_table,
 				enum dma_data_direction direction);
-void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
-				       struct sg_table *sg_table,
-				       enum dma_data_direction direction);
 
 int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 6d7abb1636e7..7c8ce3d2188a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -132,8 +132,8 @@ static void io_unmap_dmabuf(struct io_zcrx_mem *mem)
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
 		return;
 	if (mem->sgt)
-		dma_buf_unmap_attachment_unlocked(mem->attach, mem->sgt,
-						  DMA_FROM_DEVICE);
+		dma_buf_unmap_sgt_unlocked(mem->attach, mem->sgt,
+					   DMA_FROM_DEVICE);
 	if (mem->attach)
 		dma_buf_detach(mem->dmabuf, mem->attach);
 	mem->sgt = NULL;
@@ -182,7 +182,7 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 		goto err;
 	}
 
-	mem->sgt = dma_buf_map_attachment_unlocked(mem->attach, DMA_FROM_DEVICE);
+	mem->sgt = dma_buf_map_sgt_unlocked(mem->attach, DMA_FROM_DEVICE);
 	if (IS_ERR(mem->sgt)) {
 		ret = PTR_ERR(mem->sgt);
 		mem->sgt = NULL;
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 32fafbfa1359..5a984df959f7 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -75,8 +75,8 @@ void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
 
 	kvfree(binding->area.niovs);
 	dma_resv_lock(binding->dmabuf->resv, NULL);
-	dma_buf_unmap_attachment(binding->attachment, binding->sgt,
-				 binding->direction);
+	dma_buf_unmap_sgt(binding->attachment, binding->sgt,
+			  binding->direction);
 	dma_buf_unpin(binding->attachment);
 	dma_resv_unlock(binding->dmabuf->resv);
 	dma_buf_detach(binding->dmabuf, binding->attachment);
@@ -250,7 +250,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 		goto err_unlock;
 	}
 
-	binding->sgt = dma_buf_map_attachment(binding->attachment, direction);
+	binding->sgt = dma_buf_map_sgt(binding->attachment, direction);
 	if (IS_ERR(binding->sgt)) {
 		err = PTR_ERR(binding->sgt);
 		NL_SET_ERR_MSG(extack, "Failed to map dmabuf attachment");
@@ -357,7 +357,7 @@ net_devmem_bind_dmabuf(struct net_device *dev, void *vdev,
 	kvfree(binding->tx_vec);
 err_unmap:
 	dma_resv_lock(dmabuf->resv, NULL);
-	dma_buf_unmap_attachment(binding->attachment, binding->sgt, direction);
+	dma_buf_unmap_sgt(binding->attachment, binding->sgt, direction);
 err_unpin:
 	dma_buf_unpin(binding->attachment);
 err_unlock:

-- 
2.54.0

