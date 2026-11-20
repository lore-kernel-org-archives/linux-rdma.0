Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154266;
	b=Ayl2v7HIQyieCXDHrMu43GkmqXyymHDBoc3cSx8fBHG93t36BHUQDr3iDDp9CRZ0KtEg
	 a0tTFZOl4NzgrvXFb/Yn/GhqhMl18jFoSUBRFRyqLKJ6R90P4zu680aWFrJaUKgIKqPzs
	 d08THKJtYK0junV0UJbw/qXQoD5s9QqASR/qC9N2ldUjG7svYjZrrRiDR85BGkz3kRCRz
	 MAy9Zc9raIDR+HCUVwf8KtQ+OHkfr4P9zPZ+X2qreHsiSJ0wDIYEPaQVcQPnxgHvPF2/K
	 dQXIb5NUP05+cOis35+VsLtLzEMo5yBAaSTVGpXJhkh0DmKItZTJIDtDG3sv58/xCoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154266;
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
	bh=YhbwySng7lrQxamXpZMo2Q+hxGy77+m9k+59D9Q9ldI=;
	b=neVWz0921lqf3pfpp9xY5TVSGa+J2IG+7RLpPd4EftWeegAAKhShyor1GyKHMnu4ehkK
	 RlqDnBOlzOzTnjEPkLztAu8eW63ejubXTKaNwSQqLi0beZPT4oLs/R5J4sjnqyG52LiU+
	 ABN+kfN3rrQB+cy6RDZ6Jtjn1NzcyViiw23Ewf3bIBk50N8rSqCmcpj917zlBp2wdvaTc
	 BaAgbsV/ufLHmMnVKOdckbDoTZOhgM7kMULQIgFFjVlRaSUHGxYxqHidmLV7ouVJm5IO+
	 lIL0ja4S8lxDTvFA85A0rRpHpE3VBIeH3udg4L3dStEqg4b5L281+PEsgpxHcMSqzQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=c7NETS7s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.52
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2810B60A261C;
	Fri, 20 Nov 2026 05:57:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2810B60A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=c7NETS7s
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j3qUnGIzSGpE2XT1ciH07kHHVt1HmJJF7IwrQEjJrAOr33SUztpumjMYuyA7D0LogjriLU/D2f3fRyj1IA2V5uPzWsOSfRKNkUXnmH8jLPWswXn/x6f3O9G4QyI5oHzxgGDXWuLTMrcpozw2u8LRSO+mAV5VHlcDz+keluF3vUtUe5Qre9dEoct8HNpZoSzi8ZbdBoTaO90DbcjGCCgJj/FFN3FpPg9JwMPlHPLEnJjd/qC7Pqy7h76GWxJcmOp/HDEw8Si8NPHaidtrNn1o0bQjoy5AHav7NvEV2WFJvXFb7u74HmlpBzHuF2Xs4qY022PHuPWjxnIsS22GUoNooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YhbwySng7lrQxamXpZMo2Q+hxGy77+m9k+59D9Q9ldI=;
 b=SgUotCTTARY58GFTW/pHFLhfvAzwyHk4z2yzbD6Q/TxV9aFCDPBdEeHDPlIpFXR8zpX0dAV6+NK6itG8birf1ZaSPjtfDBWw7GYDGrS2OkOZogMuTw/G23W203ql8jY9QP0WwlYkIo7Mi9j3adHhrgKGJPuRDBDneenzbWqWI2qYk3dwYqRR4IhsSqPkEow9eK4b/unAs9HFpJvXVgkvbkNFs6LYtaukHe2bEdk9I0hVYDHInQozy5U6IJjU7PjufG0ROpc4FhxIECA3FQFFBina7OxQJQ/d0VV9Gtn3V6HthD6raED50Pvux6Tz3GbWr3Qqe8Y2NEeg+bJ79Xv+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YhbwySng7lrQxamXpZMo2Q+hxGy77+m9k+59D9Q9ldI=;
 b=c7NETS7sSsa3cQeEal322xl58rHFf0MXgNZXNI44M00ips3VLtNpEIVLyiNU3uzKV027uKz8DwE5jbDX9bVLwODaH5Pd12IxEQ+kds0DR3MdU1WGGI8gsgXqAp3BkI4A2xGsAi7YZegheL8DiVhNvjiUTHe+khthHcldrm/C/Pk5YZyMZJLltd5GsWfxoEgmiqgMbU57HxeMhL7eOh79IUwJ0WpcTNE4P+vuxLZf8+4jqqNxmkybmpuXR5cHUR9/3mY5w5DUna6uZMdLwcQEPK1XS0H/Hvg8FuRUM6eTKu0w1NkMiAxb3bMHD88LdDPwgwHwNo5aZ1qSFCfqXad2DA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:37 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:37 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:51 +1100
Subject: [PATCH v3 13/24] udmabuf: Convert to the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-13-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=4814;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=6gupyPQp9juTCFNaa4zUkZXqkc9NXJfK1p1GN1rGsCM=;
 b=3lJ0EzqZX7FG005Qg0pByqpkmh903uhUdYjizLUR46xDVDfkA0TmJw6Eg7RguSHTJmOzf64xs
 VgWwolBmOEZBtwV44+uP9cFGTw/jSvr7ktbDaPbUR7SrrAeDz08n9Bu
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY8P282CA0011.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:29b::8) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: db89cf61-3b2b-4019-d0b3-08df46cb2e1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261021121427099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Wa+3zkR2+hpf+m6K6/4tuxk945PysQLNvCW+qrUb4c7XnYA4pnrqrAVTilLN4J7sf/skz9zS5MNMpZLNxpA3DpFLyfkap9Z13XjV5plKxLi2NIi+jwCYyQWN5tfOfn685Kaih3lb5Itn/4Kx91KZ+eE3n0EaTw83DM3GEIFUkrAwFAx2tJdDr3UY8R0mgezaANyAUQ1GCY2h9w/e0tkIhKrfZ8R5S0wBiSbLkeQkoOGXayAWikANdh8//bXO09QryocvBO4pUnXol0mAh/HleSsNNaKz5mJ0pRuaPrPOtqie6Snu4hRImKPRCvSbfYac/ocuZYvmr3jgBe1s2RQKlc2qiYkvxtumzNo9aef8egs2D15TYZ3t362VdRIGAfgG56wxzpcb2V7dFJokdDv0QFOHNtgpfNVcO+9BipYLc6DK05aOiMDW/AhF3uQoYXycdzUiYqO4gNE4fcqYKQLV6ygB5wiWHyQNwekkoxcwzfXBrfMFqogDGqrOckuPSabV5tue96c+RjOaV7TfYTkUmYli2BOsy2aKaxF4woD4uOU64ONqUfPezBxKW73phMJib+99/tXXaM5SW/JHE2dU39KpQqRjP736qwsDsutPXJlYbr+GfgfYjIP/aSm3X2HkcfLxeHNXz8LV97BsGYJhF/9kS4eVS67lGQWyCPo0iw/E0ZKAOrOGR/oY7e0VN29fJiu+ZunkIBTEixNzAp1ENA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261021121427099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVB2Q1RkeTRYYVpPUkpkZXhDUXlwQjI3Rysyb1FJNWZnYjZYNjB3YUU2YTJF?=
 =?utf-8?B?eHoyT3dqbnlqdVpGeCtuaHVIUFQybjdpR0pjTjd3TUJzajFBbzN5UjVxY25a?=
 =?utf-8?B?bkFFeWlyTWYrQXZ0a3phd290L2tEbUdoUnBXZnViT1o4aHh5WVZmVnRyQ3pt?=
 =?utf-8?B?MEd3aGp1bzBiQWlDSnVUUUJWd1FKUUk2b1h5QzhkMVh2S2lNaGJoOFVjR05B?=
 =?utf-8?B?UnZQcmFtODdTMUV0V0hBNlErZ2c0aWFVWTlQeGx4dVNlSVdudmFyazI0ZnlT?=
 =?utf-8?B?ZFljcVU1dGpaNFNnSEZ5YTU1ZlNRc1FqaWl4THRLWmZmbkVpVTZWa1dHN0Vy?=
 =?utf-8?B?STg2MTNRSWVrWml6bkIzdVl3S2h1bVhmRmNtbXpEcnlrckVpdFVHYW41ck1Y?=
 =?utf-8?B?Q242R1d1UVgrcllJaDM2NjUzSnNDYXpWU29NSTNCRE9ZcmVJUTBOTXJUdWk2?=
 =?utf-8?B?Skp2aE5yamkxRmVGcXUva0l6WXFVMVpBRTJHdGEweU0zZWdwS1UvWmFzVjZy?=
 =?utf-8?B?b0I2eUtOc2RMbDBPS0pFaFlINGVJb0RJOHZpcFJMMUFqbmw3NHV0ai9VTnpo?=
 =?utf-8?B?SkNLU3hsUWhEemU2clpXQ0RDM0J4N3BTU2p4bWdmUWRjL0NkNDI5R0ZzVWs1?=
 =?utf-8?B?WXFPTUc1SWk3aGluelc0ZGVlL1V0blZ5emx5KzhUMzFWS01uamJWNWQyMkJF?=
 =?utf-8?B?dk5SaXdubHNreXBwMDUyd01IVjhFN29oYXZQSk9Tc3Z6K2dxK0FPbHV6U1ZZ?=
 =?utf-8?B?T29WZndzLzZ2akFmRmVld3FyRVlweG4xQ1dZY0czSXFQTUpMVUo3T2tZQ3c3?=
 =?utf-8?B?aFZxTGpZWS95VytsWEZkR01ZWGhucHZpbVJsUU9IVmNUZklSYnRCWmpUOUhQ?=
 =?utf-8?B?c0xjeWs3dWgrV3JpT3ZrMUpkR3QwSlhDL2Eza04xeGc5c1JsWUFsTkFJZ2RB?=
 =?utf-8?B?bXpPdEZNZklPcjN2YWhlcmplNTV3M2ZtZFAxdnJxTGdWcFZjNExhS0IyRkR4?=
 =?utf-8?B?WUJjWkxicUVxek1FTFJxUURGMHpQUUdiYmtGTTZBRXBGTmtxMVk1bThYOHdZ?=
 =?utf-8?B?U0Vlb1UwcXFqamxhTmd4N2lpMnY5N2pLNmVBemM0R0wzc05kNjNZbFpzZGlC?=
 =?utf-8?B?SUw5bFozNHB1b1BpOWVMVk40OUpKOWZza2xIME55MzM2dTBYaDFFVHhSZjJ1?=
 =?utf-8?B?eG1HZTFtUnlTWFozaVpLQ3BPYko0c1M0aUI3SXpaalIzNmM0QWg2Z1FTTFF2?=
 =?utf-8?B?S1diQTdZL2ZuQ3NtUHhhWXBxMUNpQTZ3bjNuY2pMTVd6ekdZb01rN000YWVv?=
 =?utf-8?B?QU9DYnhnclljdVJ6Zk1nZXg3dG1qVkhlZlRDaExtdUtnSjBPelU3NzFGaEdw?=
 =?utf-8?B?NldWVXFlb0t4OS9kcTNMN2dPK0NEa3BZc0JrWnJkeWtRWXhwNWREYnJDeGNu?=
 =?utf-8?B?VExtMFBuZTE3Y3p4L0lCQmF2MlFaMXNGaklOUTd5Mk1MNzJNRlhiYTNtVGFU?=
 =?utf-8?B?VDJ3TXYxbVZ4MU1pYVZTbGsyVEZaZzI4dStyeVk1YktSYy9leURKOTIvY0Rk?=
 =?utf-8?B?WGNremtWb2VhMkgzMzNwcUY1UGl5Y0p4cTdDTVIrYVFvYzhwL2k3QXdCd2Ft?=
 =?utf-8?B?bGZpcjdDUUVoQVpHZ3RFeC9GUVNrQjFiZU5xcG5hd3VCRUQ1eWlpM2hySThR?=
 =?utf-8?B?Nk96UGJSaG5VS2FmejlZalUzOW02UXFNdnV3V3FiWUdYZEpVb0xGbHhFamx2?=
 =?utf-8?B?aG9nVHJuY0k4RTYvTG5UdEpMYkIycnpJbFRFaW9jL2tyRDdiYlVJdk1uRzJz?=
 =?utf-8?B?cGVXTTU1WjhyZEFzZGZGamhlYXBjWmsvMzBwUncrQ2NSeWJZOEYya1pqdmhP?=
 =?utf-8?B?clA1WVN2aExGYkxrK2ZFeXlXbC9TTXlZdVlRZUpXeDhDWG1UTkcvemM1amJC?=
 =?utf-8?B?OVVGeEpPOVZOQk5mVEt1Y1huLzExaWNWS0FmTkNWQURsdHdOTVNRQkUxSCtK?=
 =?utf-8?B?MlBPdXpieFJEZ3dqYmNRTDJTUEI0ekcyV3Z1OUgvSU1Td1RZNW5LNysyV0cy?=
 =?utf-8?B?Y1k4VHJUU3FqbGhGaHZJR0x0eURoaVU5LzhhT0M1KzVkWGhqaDZuOGtkb0ln?=
 =?utf-8?B?QjE5SmlITHNFU291dlZqcVkxcDBobWJmSFAxTTRiSmxURW9LRjI4dnhjN2Jv?=
 =?utf-8?B?MmQvUjF1UVlISVIrd0NEYjlZYlFUNEo5VDdFUUQ5VGlXdStZUGJrWC9LSzlr?=
 =?utf-8?B?N0VJQ2ZQUHFTdm5aQ2lZTCtMT2JKUno0bitoemJBS2xOMDFKNm1lRVl1b1Bo?=
 =?utf-8?B?Y0xPYk9GMWFveVJEcjVGUnhpSlZ1LzUrRUoxQ1BERHFkSWozWlcwQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db89cf61-3b2b-4019-d0b3-08df46cb2e1a
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:37.7950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZF4/UCTJbloPBksMQ6e/WjchPKbGoQsEQ+MBEACLLeA9E6G0HSxuYMi6a+0QsVBZlWovvd3qIHPcOc+0QubO8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

udmabuf's get_sg_table() and put_sg_table() allocate and free the struct
sg_table they build and tear down. Both the dma-buf map path and the
CPU access path use the table kept in ubuf->sg. Make them work on a
caller-provided table by having map_udmabuf() pass a table embedded in a
struct dma_buf_sgt_mapping map_udmabuf() allocates instead.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/udmabuf.c | 71 ++++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 31 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index df6dd0046242..ef77ae063ae4 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -2,6 +2,7 @@
 #include <linux/cred.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <linux/highmem.h>
 #include <linux/init.h>
@@ -128,33 +129,22 @@ static void vunmap_udmabuf(struct dma_buf *buf, struct iosys_map *map)
 	vm_unmap_ram(map->vaddr, ubuf->pagecount);
 }
 
-static struct sg_table *get_sg_table(struct device *dev, struct dma_buf *buf,
-				     enum dma_data_direction direction)
+static int get_sg_table(struct device *dev, struct dma_buf *buf,
+			struct sg_table *sg, enum dma_data_direction direction)
 {
 	struct udmabuf *ubuf = buf->priv;
-	struct sg_table *sg;
 	int ret;
 
-	sg = kzalloc_obj(*sg);
-	if (!sg)
-		return ERR_PTR(-ENOMEM);
-
 	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->pagecount, 0,
 					ubuf->pagecount << PAGE_SHIFT,
 					GFP_KERNEL);
 	if (ret < 0)
-		goto err_alloc;
+		return ret;
 
 	ret = dma_map_sgtable(dev, sg, direction, DMA_ATTR_SKIP_CPU_SYNC);
 	if (ret < 0)
-		goto err_map;
-	return sg;
-
-err_map:
-	sg_free_table(sg);
-err_alloc:
-	kfree(sg);
-	return ERR_PTR(ret);
+		sg_free_table(sg);
+	return ret;
 }
 
 static void put_sg_table(struct device *dev, struct sg_table *sg,
@@ -162,20 +152,35 @@ static void put_sg_table(struct device *dev, struct sg_table *sg,
 {
 	dma_unmap_sgtable(dev, sg, direction, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sg);
-	kfree(sg);
 }
 
-static struct sg_table *map_udmabuf(struct dma_buf_attachment *at,
-				    enum dma_data_direction direction)
+static struct dma_buf_sgt_mapping *map_udmabuf(struct dma_buf_attachment *at,
+					       enum dma_data_direction direction)
 {
-	return get_sg_table(at->dev, at->dmabuf, direction);
+	struct dma_buf_sgt_mapping *mapping;
+	int ret;
+
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
+	ret = get_sg_table(dma_buf_sgt_dma_device(at), at->dmabuf,
+			   &mapping->sgt, direction);
+	if (ret) {
+		kfree(mapping);
+		return ERR_PTR(ret);
+	}
+
+	return mapping;
 }
 
 static void unmap_udmabuf(struct dma_buf_attachment *at,
-			  struct sg_table *sg,
+			  struct dma_buf_sgt_mapping *mapping,
 			  enum dma_data_direction direction)
 {
-	return put_sg_table(at->dev, sg, direction);
+	put_sg_table(dma_buf_sgt_mapping_dma_device(mapping), &mapping->sgt,
+		     direction);
+	kfree(mapping);
 }
 
 static void unpin_all_folios(struct udmabuf *ubuf)
@@ -212,8 +217,10 @@ static void release_udmabuf(struct dma_buf *buf)
 	struct udmabuf *ubuf = buf->priv;
 	struct device *dev = ubuf->device->this_device;
 
-	if (ubuf->sg)
+	if (ubuf->sg) {
 		put_sg_table(dev, ubuf->sg, ubuf->sg_dir);
+		kfree(ubuf->sg);
+	}
 
 	deinit_udmabuf(ubuf);
 	kfree(ubuf);
@@ -226,16 +233,19 @@ static int begin_cpu_udmabuf(struct dma_buf *buf,
 	struct device *dev = ubuf->device->this_device;
 
 	if (!ubuf->sg) {
-		ubuf->sg = get_sg_table(dev, buf, direction);
-		if (IS_ERR(ubuf->sg)) {
-			int ret;
+		int ret;
+
+		ubuf->sg = kzalloc_obj(*ubuf->sg);
+		if (!ubuf->sg)
+			return -ENOMEM;
 
-			ret = PTR_ERR(ubuf->sg);
+		ret = get_sg_table(dev, buf, ubuf->sg, direction);
+		if (ret) {
+			kfree(ubuf->sg);
 			ubuf->sg = NULL;
 			return ret;
-		} else {
-			ubuf->sg_dir = direction;
 		}
+		ubuf->sg_dir = direction;
 	}
 
 	dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);
@@ -256,14 +266,13 @@ static int end_cpu_udmabuf(struct dma_buf *buf,
 }
 
 static const struct dma_buf_ops udmabuf_ops = {
-	.map_dma_buf	   = map_udmabuf,
-	.unmap_dma_buf	   = unmap_udmabuf,
 	.release	   = release_udmabuf,
 	.mmap		   = mmap_udmabuf,
 	.vmap		   = vmap_udmabuf,
 	.vunmap		   = vunmap_udmabuf,
 	.begin_cpu_access  = begin_cpu_udmabuf,
 	.end_cpu_access    = end_cpu_udmabuf,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(map_udmabuf, unmap_udmabuf),
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)

-- 
2.54.0

