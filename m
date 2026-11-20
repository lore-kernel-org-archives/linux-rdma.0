Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154290;
	b=zag4usohEw0bi9p7iKpVyKFY8GOTR8wLTM6Kz5xzef8XMw4f0oHYYxGtl5K2P9scEVGx
	 5cmlcVKrmoYaUTGNcsKgfSZ9jFSKiUkFVJ6n2R4wT2I7COZEdgtMNuVCNrbDyLeBuwIWN
	 nX2/5fxxKLaOJBfeqHf2p9QlyAqUkYFqRaculoWZ7iJznkBQyWuT6ZaDM55q3o4yYzNpo
	 R3kKrFBbVlKsV2U1fMI55tOKWNVwEz5OGC0evyqwa4bIHWCImHdaEpAcLtIxIu9l4GInN
	 h5kf/K4uKsu8jYZFLdDkn8FUH14mF/iAqvyuTQ7+IO70GWyGOj3+YpmwTXDKusM5FvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154290;
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
	bh=H0ymkwCskuN5nONbDVElD9EZkAlbWCbG6ID6VyN/cho=;
	b=ukn2tarYLb10ZMPlkq4VguwyekB2fDYp7TudPz+YGor+63BNFLn7kHJizKSaYmeBiIYz
	 UycCmrhU6rSXVw2gl4TjF/bljnnQOZ4zVlTUJyzY1l9JdTbeRnBJ0KaY4BbexqnQt3Rbf
	 aBw5zA+nxpxnTPWE6+vtGh2ZDfPlohpaucvtC7oqbI02ORTZNLSg5djeuDFW5dKjfIfqp
	 Lxd0yYSwJ9i+Dw+rmpjsBCHFpDbrNp+tihaRszNixMYzZXr/qoOesq3Vy8V9ZVGDc2Zae
	 W1uQVaI2UyNo5RjXLZwGLbxIn9OHeVHyW3FalC9FHQ6Jv8jZGcgHAEJ11+wvegT6x8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fui7TMyw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.33
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010033.outbound.protection.outlook.com [52.101.193.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CECF606A330;
	Fri, 20 Nov 2026 05:58:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CECF606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Fui7TMyw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgohVvdVtdwNUqQHY6stI8bNKNWCwVKlv61KJEcIG4T2Zy9ut8ga0DeCWufM5dFUmKzIi7eUR6UgIKuOE21yd7GIBFqikc+3VffGXe5Q4DebV4jgP+1+RtwP0++X0ReFWDYPk2yeLGJJ6kyrccQZIarPU7p3hy6S/jg7R9tM59+DP6RFu8dr5xBP0M19hWipj/jqrWXuHJocHiM9uMXLzywIb0f1p1aW1pQuwDb2t2ar3WQEwWT9CHEo02D0ITXt3V4mPmZVXnIqWNoav1XyH5lAybn2JIfgw8II7xfz0oKkZOpIIZe39oT6MSUpjYlqdPzTShPetF1wa/Ly+eH3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0ymkwCskuN5nONbDVElD9EZkAlbWCbG6ID6VyN/cho=;
 b=FnNM529JxRgFHoDck2tt3/+T++JbVLlYRWLio5yWtH7Lt/NQZccatRFeXEqGHsnJYZc8DwPWDhYOD3iA79LqDCta+Gv7utRC/KSVwX0eG+9Zr8HxQ6rPkHjihKX/mOcNknFfWxdp5JgcHYoxy1HLUszjUAevaCfYbNGRXUoN45xSc2KsFR8XYSG2VjY/TMmjlihpNFA0oFkOH4DTpZM92V0TSNgSPeD4ZjjJcegy7MNobhEBwlquZtaxYeoULaEubTeXODAFauP7mBtT4IX7zNztg3S2jeNVC4jXhhZN1T48OrefO86YP/XIR+AnTYwUKfaavT26YAUwLmKH2MyrbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0ymkwCskuN5nONbDVElD9EZkAlbWCbG6ID6VyN/cho=;
 b=Fui7TMywGJhPg6D6eLda5H/vhW9LLAywG6N/dcdcLjX7DQIY3DoL07NQr0qllT46qTYeNyiGmFAQCHZHAj9tY9zd759g5i24oy7fNUf3cGagIz6xTwHv8WkpCwcNOENrIkQpgyHhozOKf6mYsF4/YVRAGYB9K28e/I0OxjDGGTkXgXHjI6YYxY15ff8emos5Egt7qdo8xK+QMOPfXWpq1Ytui5jc33ku+1p7INySs4zjZer57jqp79/HepwwuYivMWhhcWV7e3KA1LJJkXjjyg5l3FDFccElVc2beTtT6nhpn1NL2UCHZlJTCr7mz0coLl7OgDcYRXJi9ecrbpUUDw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:58 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:58 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:55 +1100
Subject: [PATCH v3 17/24] dma-buf: Convert dma_buf_phys_vec_to_sgt() and
 its users to the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261120-dma_mapping_type_v4-v3-17-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=12571;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=XWFw0NSdXtjNj9fsAx6heckZCnyXD7MS10cW4ik9lg0=;
 b=Bn88lnZMfcGm/0Ls2X5OpACtxoFUAin3G3xW2JrRlUOn+DlTXZNFVVD3y3EAq3jcIBJEsfqh5
 H9Yxijs1c7qBWxtm+DSZTEVnt4TUjSlaYQ5wGCxjCdnwVxUimC9HNKU
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY0PR01CA0004.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::11) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: efacbb27-6852-4670-10ae-08df46cb3a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|5023799004|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Qce4JLxWzO6B/epe0m+Xkyp9hVew62nRk3l3EKWaN8TrqNzjMBNXB+WZiR/vqiz5A7aL0nXor6FdFdHn+vwRrCENzcV3ykArIe/Jw59G0JwFWqFX8wiKz2Fi7h/2n+e1KfwyUQdOXuk/+zo1YAG2MctM1Kg41TDc8xCc4x2UvRWzA2+cVXBZDM4jJxsWKXhQGYWwOfCJadBuURH5Bz2ruRM0iv8P18+tWcRD+FDIfqXYwZsUZvyALWiGsYnjaWc6+SlFS7dAoML3ENNsvKc71ZQLtA5GzFmofeiknMws7+2xsDhymghorLaviYS+uUugnDctzXidQxTi5UB6FxeD4cA4Yq0LMPm695FcuayYmA0mp5NyKcGywrS0BCfCFt5n8Rg+LWU3mxvKSGKpDq3yrb1naR68y1EdCi0Jxiid0gm6lDgv3EF6ZezwaUGsfUGh1l5XoXJk+1l6Dq1YjjN7G3lRWL9ie3qhZ7HUs4IxyMHGKxnB0ADnTGJAjh8w1o37AvSOUu+A++dhzQgPMXMgkv3RJioOleSggYiVt0lM2L6H7ELKjuQ9HmvwDCPYiUugFdJ/1/m/8PE0DVKoyWOWGOF85+Xb2I3+HrjzOCPyHp7T66wjvMyQBxncXo79EMwBhbzcRGJ32Z3n5ntGtNaDtBeI7Z/tArjeyTX9yPR2loj/7iwCChEsQDDBCYFNMDJpYqgeoLqrdn4vgOhVhEdMEw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(5023799004)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U09BZG5RK0FaY25zN3BWbVV2OGdZWnBpWFU3T2dqWWpIcmJhQVFZaitaRjZa?=
 =?utf-8?B?Q1JRNVNGZ2UrbVozbWNlaSs3Y1pvRjJqdW8raEZ3elNyb2ZoWVluSmxxUmFj?=
 =?utf-8?B?UGpLZFZFbmxKQ0Zzc3phUi9jYU8yS2tvKytnaStUK3RhNytoTDZxdzlmS2ph?=
 =?utf-8?B?TEpaanlQTlhqYzVhQ1pBakFSK2R6RXIxTU9CakJYdjN0OVhjWG1Jb2dxQlpC?=
 =?utf-8?B?TEpKV3IzYjN3dlhzRjRlNmRFMHppZzhhN05COSs0OTlYd0RpKy9PRSs1eGla?=
 =?utf-8?B?U24zUFdXNGNndnlvTzN4N3krY05ZUlkxYVh2cDFQUjJnd1R3M2llc0M4TkFu?=
 =?utf-8?B?UUFvVXMvUlRibVR3T0wwd2lZcmFwVFEwcDNtMitKQnZYa2w4UHljVW4rcHdx?=
 =?utf-8?B?NlBHeU5sTFByMDRlRXFRbENXVkcxY0tMdVFya3NTUVFtTHQyVGN2ODRUaTVW?=
 =?utf-8?B?TkZCTXYyZ0ZYZ3J2Y2xseEtUUWRzV1FTVU9mcWlJSDVtczB0ZGdvSXdJb2pq?=
 =?utf-8?B?aENmVDdnNmR2S2cyTlF4TjhZck9lNFUwU3dwTUdIUEtHY0pQNTJ0QnJsQTJJ?=
 =?utf-8?B?UGh5UnNpNTM4YkJIRlNETDZVRXVEd1BhT3o5TTQxTjRNNDlhMERWU3E3ZW43?=
 =?utf-8?B?TE5OcmhUOTB5aFd2Z1ZUV0NnRmxFYzljVUxSZU1zWmJYSzkwMEdBajNQZlZS?=
 =?utf-8?B?NHFGV1lnbDgvdVZSZkFRMVF5Z2pqQ05mZ055MzVWRFN1MnQwUytZQldoZytk?=
 =?utf-8?B?U3ZOZU9KRkZPRWVNVjFPalpPQ1BESXMwdjdHbVhicmRZb0ozRjdSSVhXaE1r?=
 =?utf-8?B?UXluSjRLbDNYVkNuR2U4T1hFUXl3QTFYSnVMS0RYVUQwZGJBMDFBeXlFTWJU?=
 =?utf-8?B?eTcxeVBGZGoxVTh2WVNBWVJkSk0ycnMzN3VOdTFBSTNmT3NLb0V6S09OaHhZ?=
 =?utf-8?B?RjE5VFovV2dmWDR3REorK2pBTzF1UUpEOCtKamVrNUc0LytJVm9sY1RFYXEr?=
 =?utf-8?B?dFdXbE9XbS9CeHBsNFBsKzJ1YzY3ZTdKdk1VYzVKRjk2aHhhNGRKRzlTWnYx?=
 =?utf-8?B?N202ZGxIVFZjQTk1dzQ1VWV1SnQ2QVJBNklDU0RyM09sUXlENER3TndvV01x?=
 =?utf-8?B?RU9mWEt0V2xlYUN6L1pyaFJtMmt0OHY0dFpGUnVDbDRFMFBjMGdtcDE4c05h?=
 =?utf-8?B?TEQvZk15QWh3UWpnNGloNkVZK2NTNGdnV2tMaG1MSUVhY05VM3l6Z0Y5QU5Z?=
 =?utf-8?B?NlhRUlJOSFVpT1gxd2ZrUHpWLzR0ZytvckpHYXRjQzIyczdtREdFK0R4V1BF?=
 =?utf-8?B?a054M1cxSkVKd1FtZXNXNnRMMWpDOE5MckVWV1B0QXZtc3ExK28yVnBOeUto?=
 =?utf-8?B?bFRWNkNOek16YXVFd3BCWCtVQ05LSTFSNHV5TTM1Q0YwMzdWL0syMEMrZE5J?=
 =?utf-8?B?QXFVSnNGYlJidGtXKy9XYjMzZFFVVW5XYVRPbjBTblVXN2NRb2wzUjZTVnVY?=
 =?utf-8?B?RW9XQzJkMlZSRzFaZ0tKM3ZXQjU3dkNFV2ZwMnI0ZjYxcTJMWEFKVzhmNVdp?=
 =?utf-8?B?U2tmMjFRQ0hMWWR1ZkxjOGJUclVTeVZXUVllTkJ3OEc2clhaZHNTbk95cUNF?=
 =?utf-8?B?MmpLazh5Sjh5SjIxZy9VSVBHODFuM0h1Q1l0N2pvR001a2RXZHhFbmQrNzls?=
 =?utf-8?B?dmpPd244ZTRBNDl6K3J6M2FGSnpTUnRqc2VEVThlMk9PMVBHYnU5Z1RrN3Ja?=
 =?utf-8?B?SzRQdjcwczR6UmxOVGdHSXJGd1J3QWFBWUd2ZU5XL0VqRWx0NWREanFuVTRI?=
 =?utf-8?B?dkRhWGROMFBNb2RuT09SL3Nwc1pHdDdVUEl1ODUrQ0JzTXg4Z3Z3S2o4NU8z?=
 =?utf-8?B?M3UxcVVsa0pLSkdyWG11U1dFUGVvZjRQeStvWDZ4YWp3NEpXRjhRdXVYY1dp?=
 =?utf-8?B?WWc0bE1VRm5SWU5udFVPYlFlQ3NGZ2J4WUs5WVEvUTA5TmJ0citFbmtFdlRh?=
 =?utf-8?B?RFk0NWF4ckZObDZrZngwZ0J4OWxVTWJ1YnVEbG1RTW9VNUt0alhlNk9OOTQr?=
 =?utf-8?B?VkVjVFEwWjR0ZWdyNklXUGxNRUNYbTlGMTUyYm5PbGtzL1o5MVU2V3ZqMFFP?=
 =?utf-8?B?OUlLalRiVnJTSTloZGRrRVFrVXNDelkwRVltMDY5ZzNEYzlLZ2Uwdm5wY0Ru?=
 =?utf-8?B?NWNrZk0rY0gvUFlBWGpoSmx4S21NemFtQ2NGdVhKdmpNeVZKOGZuTXV1cjNh?=
 =?utf-8?B?bklqeWlLanFMa1N6ZjNCS2V2M1VrUUFWWlM3MFVZTVozNktweFhFb2JjNTdR?=
 =?utf-8?B?eGpzV2ZtWXBvRHZQQmNjL3B3L0NiZ3VBTURmUng2TXQ0U0h6WUc0UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efacbb27-6852-4670-10ae-08df46cb3a5c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:58.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wpa8GqpKx5S/vYnFB9NEK67W0DNC3iCb31Ge6fVtwYCKuHqNyVQx3N+j19SVxoWd8x1m5fT9OQV8VKY4igiQeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

Currently dma_buf_phys_vec_to_sgt() allocates and returns an sgt.
Instead convert it to allocate and return a dma_buf_sgt_mapping.

vfio-pci and RDMA/uverbs can then return the mapping directly.
Their map and unmap callbacks can then move from dma_buf_ops into
DMA_BUF_SIMPLE_SGT_EXP_MATCH().

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf-mapping.c                 | 57 ++++++++++++-----------
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 23 +++++----
 drivers/vfio/pci/vfio_pci_dmabuf.c                | 24 +++++-----
 include/linux/dma-buf-mapping.h                   | 13 +++---
 4 files changed, 61 insertions(+), 56 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index cc3d8d6fe009..d2730be4a9f5 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -66,12 +66,12 @@ static unsigned int calc_sg_nents(struct dma_iova_state *state,
 
 /**
  * struct dma_buf_dma - holds DMA mapping information
- * @sgt:    Scatter-gather table
+ * @mapping: The SGT mapping handed to the core, with the scatter-gather table
  * @state:  DMA IOVA state relevant in IOMMU-based DMA
  * @size:   Total size of DMA transfer
  */
 struct dma_buf_dma {
-	struct sg_table sgt;
+	struct dma_buf_sgt_mapping mapping;
 	struct dma_iova_state *state;
 	size_t size;
 };
@@ -99,12 +99,13 @@ struct dma_buf_dma {
  * mandatory exporter should call routing pci_p2pdma_map_type() before calling
  * this function.
  */
-struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
-					 struct p2pdma_provider *provider,
-					 struct phys_vec *phys_vec,
-					 size_t nr_ranges, size_t size,
-					 enum dma_data_direction dir)
+struct dma_buf_sgt_mapping *
+dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
+			struct p2pdma_provider *provider,
+			struct phys_vec *phys_vec, size_t nr_ranges,
+			size_t size, enum dma_data_direction dir)
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
@@ -146,18 +147,18 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 	nents = calc_sg_nents(dma->state, phys_vec, nr_ranges, size);
 
 	/* sg_alloc_table will cleanly fail and return -EINVAL if nents == 0 */
-	ret = sg_alloc_table(&dma->sgt, nents, GFP_KERNEL | __GFP_ZERO);
+	ret = sg_alloc_table(&dma->mapping.sgt, nents, GFP_KERNEL | __GFP_ZERO);
 	if (ret)
 		goto err_free_state;
 
-	sgl = dma->sgt.sgl;
+	sgl = dma->mapping.sgt.sgl;
 
 	for (i = 0; i < nr_ranges; i++) {
 		if (!dma->state) {
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
 
@@ -193,7 +194,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 	 * No CPU list included — set orig_nents = 0 so others can detect
 	 * this via SG table (use nents only).
 	 */
-	dma->sgt.orig_nents = 0;
+	dma->mapping.sgt.orig_nents = 0;
 
 
 	/*
@@ -201,20 +202,20 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 	 * and we allocated correct number of entries in sg_alloc_table()
 	 */
 	WARN_ON_ONCE(sgl);
-	return &dma->sgt;
+	return &dma->mapping;
 
 err_unmap_dma:
 	if (!i || !dma->state) {
 		; /* Do nothing */
 	} else if (dma_use_iova(dma->state)) {
-		dma_iova_destroy(attach->dev, dma->state, mapped_len, dir,
+		dma_iova_destroy(dma_dev, dma->state, mapped_len, dir,
 				 DMA_ATTR_MMIO);
 	} else {
-		for_each_sgtable_dma_sg(&dma->sgt, sgl, i)
-			dma_unmap_phys(attach->dev, sg_dma_address(sgl),
+		for_each_sgtable_dma_sg(&dma->mapping.sgt, sgl, i)
+			dma_unmap_phys(dma_dev, sg_dma_address(sgl),
 				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
 	}
-	sg_free_table(&dma->sgt);
+	sg_free_table(&dma->mapping.sgt);
 err_free_state:
 	kfree(dma->state);
 err_free_dma:
@@ -226,16 +227,20 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_phys_vec_to_sgt, "DMA_BUF");
 /**
  * dma_buf_free_sgt- unmaps the buffer
  * @attach:	[in]	attachment to unmap buffer from
- * @sgt:	[in]	scatterlist info of the buffer to unmap
+ * @mapping:	[in]	the mapping returned by dma_buf_phys_vec_to_sgt()
  * @dir:	[in]	direction of DMA transfer
  *
  * This unmaps a DMA mapping for @attached obtained
  * by dma_buf_phys_vec_to_sgt().
  */
-void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
+void dma_buf_free_sgt(struct dma_buf_attachment *attach,
+		      struct dma_buf_sgt_mapping *mapping,
 		      enum dma_data_direction dir)
 {
-	struct dma_buf_dma *dma = container_of(sgt, struct dma_buf_dma, sgt);
+	struct dma_buf_dma *dma =
+		container_of(mapping, struct dma_buf_dma, mapping);
+	struct sg_table *sgt = &mapping->sgt;
+	struct device *dma_dev = dma_buf_sgt_mapping_dma_device(mapping);
 	int i;
 
 	dma_resv_assert_held(attach->dmabuf->resv);
@@ -243,13 +248,13 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
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
 
diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 8d8c997a4883..7463877db3d3 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -21,36 +21,36 @@ static int uverbs_dmabuf_attach(struct dma_buf *dmabuf,
 	return 0;
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 uverbs_dmabuf_map(struct dma_buf_attachment *attachment,
 		  enum dma_data_direction dir)
 {
 	struct ib_uverbs_dmabuf_file *priv = attachment->dmabuf->priv;
-	struct sg_table *ret;
+	struct dma_buf_sgt_mapping *mapping;
 
 	dma_resv_assert_held(attachment->dmabuf->resv);
 
 	if (priv->revoked)
 		return ERR_PTR(-ENODEV);
 
-	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
-				      &priv->phys_vec, 1, priv->phys_vec.len,
-				      dir);
-	if (IS_ERR(ret))
-		return ret;
+	mapping = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
+					  &priv->phys_vec, 1,
+					  priv->phys_vec.len, dir);
+	if (IS_ERR(mapping))
+		return ERR_CAST(mapping);
 
 	kref_get(&priv->kref);
-	return ret;
+	return mapping;
 }
 
 static void uverbs_dmabuf_unmap(struct dma_buf_attachment *attachment,
-				struct sg_table *sgt,
+				struct dma_buf_sgt_mapping *mapping,
 				enum dma_data_direction dir)
 {
 	struct ib_uverbs_dmabuf_file *priv = attachment->dmabuf->priv;
 
 	dma_resv_assert_held(attachment->dmabuf->resv);
-	dma_buf_free_sgt(attachment, sgt, dir);
+	dma_buf_free_sgt(attachment, mapping, dir);
 	kref_put(&priv->kref, ib_uverbs_dmabuf_done);
 }
 
@@ -97,11 +97,10 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 
 static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.attach = uverbs_dmabuf_attach,
-	.map_dma_buf = uverbs_dmabuf_map,
-	.unmap_dma_buf = uverbs_dmabuf_unmap,
 	.pin = uverbs_dmabuf_pin,
 	.unpin = uverbs_dmabuf_unpin,
 	.release = uverbs_dmabuf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(uverbs_dmabuf_map, uverbs_dmabuf_unmap),
 };
 
 static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..ab3a7217e0a3 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -47,37 +47,37 @@ static void vfio_pci_dma_buf_done(struct kref *kref)
 	complete(&priv->comp);
 }
 
-static struct sg_table *
+static struct dma_buf_sgt_mapping *
 vfio_pci_dma_buf_map(struct dma_buf_attachment *attachment,
 		     enum dma_data_direction dir)
 {
 	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
-	struct sg_table *ret;
+	struct dma_buf_sgt_mapping *mapping;
 
 	dma_resv_assert_held(priv->dmabuf->resv);
 
 	if (priv->revoked)
 		return ERR_PTR(-ENODEV);
 
-	ret = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
-				      priv->phys_vec, priv->nr_ranges,
-				      priv->size, dir);
-	if (IS_ERR(ret))
-		return ret;
+	mapping = dma_buf_phys_vec_to_sgt(attachment, priv->provider,
+					  priv->phys_vec, priv->nr_ranges,
+					  priv->size, dir);
+	if (IS_ERR(mapping))
+		return ERR_CAST(mapping);
 
 	kref_get(&priv->kref);
-	return ret;
+	return mapping;
 }
 
 static void vfio_pci_dma_buf_unmap(struct dma_buf_attachment *attachment,
-				   struct sg_table *sgt,
+				   struct dma_buf_sgt_mapping *mapping,
 				   enum dma_data_direction dir)
 {
 	struct vfio_pci_dma_buf *priv = attachment->dmabuf->priv;
 
 	dma_resv_assert_held(priv->dmabuf->resv);
 
-	dma_buf_free_sgt(attachment, sgt, dir);
+	dma_buf_free_sgt(attachment, mapping, dir);
 	kref_put(&priv->kref, vfio_pci_dma_buf_done);
 }
 
@@ -101,9 +101,9 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 
 static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
 	.attach = vfio_pci_dma_buf_attach,
-	.map_dma_buf = vfio_pci_dma_buf_map,
-	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
 	.release = vfio_pci_dma_buf_release,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(vfio_pci_dma_buf_map,
+				     vfio_pci_dma_buf_unmap),
 };
 
 /*
diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index e442ed0ede71..d73bff5d6853 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -108,12 +108,13 @@ dma_buf_mapping_type_of(const struct dma_buf_mapping *mapping)
 	return mapping->match->type;
 }
 
-struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
-					 struct p2pdma_provider *provider,
-					 struct phys_vec *phys_vec,
-					 size_t nr_ranges, size_t size,
-					 enum dma_data_direction dir);
-void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
+struct dma_buf_sgt_mapping *
+dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
+			struct p2pdma_provider *provider,
+			struct phys_vec *phys_vec, size_t nr_ranges,
+			size_t size, enum dma_data_direction dir);
+void dma_buf_free_sgt(struct dma_buf_attachment *attach,
+		      struct dma_buf_sgt_mapping *mapping,
 		      enum dma_data_direction dir);
 
 int dma_buf_match_mapping(struct dma_buf_match_args *args,

-- 
2.54.0

