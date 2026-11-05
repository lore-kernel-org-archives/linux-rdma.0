Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860929;
	b=G7RtiE2qg3IzR1UXvSBawQkDOdnPQ65tNlnz2ij8JFILpUoPdQBBuVeCpliSRsOZ0UXQ
	 AN5UiftpfRjWLSXzC2MK3InWWTc6INj7RaPKdUEUt+FRZu8wKvT+meKuAXEugQWUJEfNu
	 fwAC/TiJvncWtR25op8xmBmHPV8BZML5dJItT+gQgHgwBrmz4dRfJBbLfw95wKzioxTT+
	 oreWpH7y54lo74T2SsTh3fKjFDVpex05FnH3Y7sf4xZJlDATCcfkNNiIOdN8CrFbznI9p
	 fL83m0HW/FbgWzuuf9G9XJl7+IPQBhS/CxYoodLV0mItKs7ejXqr6x6ohmz9QimdyNA==
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
	bh=92GI72CtwA+Ch3qH59ZwWxFKWbCdMj8c8OxUaeJOFFU=;
	b=fnUIapst8FbXjhz6mcM9oG4kDTnHiqGRjsXfUJYCzZC3Hb3Ln0gRHkWXw302mijsely5
	 CTZWkL+CWCe8UcCqG6Etam7/m0QfE9rfEsz8gM6rHMg3zNdxgrGIqIV1i44nJZfV3mGD8
	 D9Rr46nQMySuIZGwT5br3ynpcay5++VxkfMsWlQeFODNdbUnpTgYO8cA///3S8LK+s11A
	 TPVlDWUmBHXX9LJA0PBka+txq8yDv57xHh+D0Hb3QrQKPjURbuRp7fTmLfUFCX91lveOE
	 EHakhvLx73wp9y05Zpw+QUUNlbm1t6EBIpw1VPQ13snnplVKcS2lyOxsLGv4vHJZa9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cIKWyGGx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BC6606A335;
	Thu,  5 Nov 2026 06:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2BC6606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cIKWyGGx
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuR+TRQewPqe28Cwc74ZrORN3ZZ6uSb7cqKIYOW1cnar3SvEL5erb4DekXnzxBsbWshfnZHX52sLOkJpJvNk5cymoEkxPNYazy7nyLeMFeZw7tODnqUov3lHMnoCBUFHvz2w1n3DnvGwE0UlBKN9kyRlAsrBi9fjmQWwKFfA38bjn8ILInzLdtNsSo3+2/pBS5HcpalXCGUVTROJklhEqejNXayY7mVxO7rb9Q0NJenOA73uFvAU7Lc+L819COybTIV2ctHwgIJjgQ8o0GYRJjK8U8jLtiJswvLfMrJX6rlodxtRXUoYWZIWobCf/jcegzwZPfd2w77Hl+vjspAlQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=92GI72CtwA+Ch3qH59ZwWxFKWbCdMj8c8OxUaeJOFFU=;
 b=fZOzm6trD/CwSfdraJKWnf/ARsWxwEf7Csm4e5XUW9ymHEbpcVyrhiVjnX12kx/jmZVegKLaZWVVejb8mEa3bMh+CtsX0iKun3TgGeRObH0UAROU5XUmzNfOLgDSlEkIcuJhtTGKQvMNTpilJiNpRpm8XyYxxe99HSId3rrO0thjl7pGGs15nu1hQysI7JiD89180IE3Vu4Kh4vf3yLXvi/URe0fHigkfE0vFOo54mgwfMmKkzfe1m6rAWKLOT0Wmj+ge82T8eo/pr9lRgatqlUTnvXfj12QJZX623BXwoUryS25M2S7wvz2hexK545Gp4oHz/lTN9T4hihfoEbWOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=92GI72CtwA+Ch3qH59ZwWxFKWbCdMj8c8OxUaeJOFFU=;
 b=cIKWyGGxen9kY3NeqMA3SFfnNAWmQyJZ8IAawKSSvu19vBEVeVF36LZN5pvVR6/nhF8sikiPKMGAgKMV1OAdvSHJ0jht51rObsWWrsYnVLZo0Ar3H4JEji+aASz7pA5YjJa98fDAEUHxuwAHVV6xiyScg6n714TSKvl/62x8/ngTFOgjX1qDqJFNYh1WknoesiKrWdamyEZu6/ZR2ce4/bAwuaVJ+lF37U9m24zwZa+lJylS6e4lcOpuEipnkU2tnQuC8D0Yv5UKXXZvoF/pcP9Q9+iPLluCF5iws1P/qd8nERGgJzW5l19rLFTJRPtgl+jN3LeIEWgjVwjFM2Z4ZQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:41:47 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:41:46 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:39 +1100
Subject: [PATCH v2 04/23] dma-buf: Negotiate the mapping type in
 dma_buf_dynamic_attach()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-4-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=9039;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=k0kfHDLfm1xP0OacajHtz7IRV4QRvRL6Q82T8dG2tZk=;
 b=PaR/xQPUsk+Z1Ufyk5u8yCqMcDWPIZV26Xs8J/svBj2HZlGTUHNUBLvrZVIUJj/jP4bZmuvGO
 PX3yhExsqBEB1cvnrCBOK6BHATGTaifA0KSh5YHJBMLw8dHSxlseWYw
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0171.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::29) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 3177c3d0-372d-42dd-99ed-08df3b07dcbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|261021123027099003|261022075727099003|11063799006|5023799004|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Kv3OYYi0ooC0+4fyA9IcI9Lh42Cc6hznmkeORlZvHMACz0an8nJ6rsFhtIm9NBAAcKP3kJY+RviwpfWlVYQdQumqnzWZfIpT8XCRgLmANYVSrSqx9CTaioa4HIrQydj0507G9hdzQNgQA6TZzz0doIrJQ7Afnm9vemNHtLYJQhNlkgOr84G4MhTPJlzHOLDlgD/HXYkXK8dKgw8qzdj419PSBvRJwpRUlC/DffxsrshDLBuoh5DRDAOrrKGeoP2b/lDc3VBoBmu8L0ht+vZsU+ONOg2DHzlKtXajJKnqRyovd+rFuwwAYuLyFcUHcIJn3jB9Y3QVPAMyNSeHPhhqPqTFYZUd6kWV2kMGWH6dLXWB2hWEQHrTKU1f94pYrHFhhjXeqrDFGt99/gXMf4KIOXFtHSluoYBSdHb8gPeUQhMC0DTyrznYkSVILIh3QK40X/f6Fy8hh6vhLRjEgqV/rP+FaKdQfYRLdwgHIyX64p0pSVRhSUINSDObFwIuaJxLAO1MRvwpgoin5dm0yJfvk8+3EQpnfilf7yUTswfKgBxkp/ZvJ63lLSs9isO0nc+JOsPkGAlNLOYWlCETE7RdYw8vmmeDvsLEivehLvCg6xmzqnFxWrzTVaTfCD2XGTguLhhPA6Co97y4/0t1XKbyx5Gb9Va+9Yna4yOUHiNha8crgptsoIBOknKCOZBxI2MFJ0JswX7WOhC9Oqs8ZGFf8Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(261021123027099003)(261022075727099003)(11063799006)(5023799004)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cERjQnhWMFk3MHJ4eUhCbmlKWjhjL3hDQ0IwYjRVajN3cURYWStKcVk4YTJS?=
 =?utf-8?B?R1FTb3JOU3VDeXc0RmNTU1U5WTYvdFVCeGZ1d1l5TjM2alNNUG8wR3F2UWQ2?=
 =?utf-8?B?S29lSVNiWC81NWRRa3puQkdxcSs3MVROVC9rS1h4NncwRXhWNVU2ekRzNm5q?=
 =?utf-8?B?ZEIvZnpsZnZHNXJnY0l3UWlYcmdXNGRnM09QYmNCWlA4WTFQczNmOTRQMlIv?=
 =?utf-8?B?YzJqTWhDa0pJdUZzb3pLWXVWOGk5a3pZeFV3SE5RQnFVS0JwYW1XR0p0ZUlC?=
 =?utf-8?B?dDNJdDAwWTJ1azBpLy9QTUJIQlQyblRBM3pYeTZUMEVjNWo0bjFRMFVPZFJG?=
 =?utf-8?B?Mk5RWGo2UXRhMzIrUlU3MVIxdjZIUGxnTVRHNW12dys3WVZ1eEtzYzRYWndW?=
 =?utf-8?B?SGhmRzE2TlV6Zmh5WHpJS0JiVnVKMjc5ejJlcy9HNVVua0tCWmI3cVhlWW1J?=
 =?utf-8?B?VGtOS1c3b2p4eElpSUM0QXF0aWlKaTNzQm9TL3AycHYrYWhrWXBtendoOUVr?=
 =?utf-8?B?MlZNOERvbmROWlhxaTErakYwZTJyN3U1a1BlVDRnT0J2SDdDZkovMFJadklX?=
 =?utf-8?B?RDNNZHBZUXlTa1pkcXZuOUFQYWNEejBjMjY3aVV1eUNaKzUxcUpqTFpvY2VN?=
 =?utf-8?B?NkdtZnpKMUI5WUVDVlVFY2hoZTk2N1VsNEIyUWRGVk8xQlhtN20xYy9JeURB?=
 =?utf-8?B?UVpNV2ZqUjZKR3FrM0pUd2V3WHFtd3E5VDROZ0tzQ1hWVU9VVjUrL3dGbkFk?=
 =?utf-8?B?ajVKNHhDMmlwMEVKeXZocHIwTmtReVY3bHRlYUE4U2dvSEdSbUdnUDlVN1dn?=
 =?utf-8?B?WDlIb0lia3NOOWY4ZlZNTWFjd1pIWnlSNDBSSjJMcnBCS3NVQWJSZEprWElh?=
 =?utf-8?B?U3BhdlZrUjlUUWVOcnNMTit1dzU3aXIzRG5NV3IyOFJpd2RoZWJjVTZON0FU?=
 =?utf-8?B?ekVKTVR5aUdmYk9HTXhJNHZLdkdjblNNaHk1Z01aQnpLVjY2QWFPUXlNTzlY?=
 =?utf-8?B?MGFBeWFDTjhMQ2ViNEtmRUhrMEJZMFhvNnhFSE5LMGxYakhnWE9BcWZTaDBl?=
 =?utf-8?B?ODVIcHQzU1doSElCZXBOYjBoU1J5QWkyNWk0S29qTEQ3NysrQUF2ME9MRXNj?=
 =?utf-8?B?Y0VycUlCT2RwdFB6blJHUjZ3KzBEL21KWVk4cmROWXgyRXk5S3VxQVNsTmty?=
 =?utf-8?B?WDArR0kzWDVRdmtWbGJSQ3pMMDgydVRNdk55RHc5L3ZSN3RJWnk5MGwzaHU2?=
 =?utf-8?B?ZGxzQ2g1clRlandQVmRMVlRBVytTYmJxTDJIOGZYK0JoaGVqblR3S1F1Ykhm?=
 =?utf-8?B?YzZhbUZPYVU1bW9CbXJMUjhrSmdsa1YzbVZzT2VmOVJrWGt5Z05TL1NEMVRt?=
 =?utf-8?B?Z0ZFNXdoQVdZM1A4WXM2b1F4R0lFQnFOZXVXbi9yaWFXSHNUV1czWXp0Sm5H?=
 =?utf-8?B?SmtZVFV2dkZzQzl0WW9tT1laelBheFBSOUd5QlJzeEwzbExubXFVL3pCZWZT?=
 =?utf-8?B?YjR1RUpTdG90YVVUTEdUbVBFa3ZOeHdFUlp5WnVrQjlyaFZib21ZdElqRko3?=
 =?utf-8?B?dHlFOHBRcnVtNDVjMkJ4UmZpakNtMG9kYVdZVHRNM0xwQWZXdFI4SEE0ZHM3?=
 =?utf-8?B?RFVZRm50TDJVNFRzdWRzSjBYMWtMallzKzFZR3BXUklMTU5oRnJrUFJxbnRS?=
 =?utf-8?B?b3gyTkVPTFh4N3M0Mm1MWjVTNVQ3TmRXVE5ZT3lTREN5VEYwbU14UzZacnp2?=
 =?utf-8?B?QjdDcENMQjNnSkRoUURKOUhoYi9XcFo2c3U0TmY5NTFrOG9pcnlTemx2c3RX?=
 =?utf-8?B?S1BuNVFaRmtwTE9oOHlROGNXT3lNelJQeEEwMTBYV1FHMTB6cFRWd1R4dXpk?=
 =?utf-8?B?R21NTE1wNTk1ZUlQMjN4aTJyVm5tMGw0aWxmU2J5ODIrU1JlVlZvTktQTklE?=
 =?utf-8?B?UDlnYzFHcHBscEF3aUhSNWQ5T1FZamRyeno4RzlMNmROdkJnV1IxNTVpWWtx?=
 =?utf-8?B?RGh4d2E5a2prNk5EcmNrOCtoS29Ed1lEZ1hFRTNhVjlDRlJpL2ZzVURSU1JT?=
 =?utf-8?B?b1I0R0FRUWtIYVhBK25VM3JGbkdHaVMyTkJhdVl0Q1Z2V1BCU2RodU9zdUls?=
 =?utf-8?B?MXppOWFURGNKS0taOStudVdSdXVKRFc1SlNQZFBraklsemx5aGlNend3YTVE?=
 =?utf-8?B?U1QrdTVvNGlUU3l4WWFXOVJ2VXd0a3haQUNRVVpsS1I3RlpRcVhxWWJLTHl0?=
 =?utf-8?B?WldRWXJqTjg1Y2VhRkhyeFUwc1RhNVBWSlFzK1R2MUEzUWFyUXRDNkYwVUpJ?=
 =?utf-8?B?Y2t3TzRjc09CVGQwRXd2V3hTMUsxV3JBY2FJZ0Q1ckVFL01nTTVpZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3177c3d0-372d-42dd-99ed-08df3b07dcbb
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:41:46.6173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: arM96r8cfq6OsZV9AUc6xpeV+6qhBmje5DI0eztnWbFjoPwdHuxQwOuw/scGut1C9krx7k3Q++CSMjyOEUfbcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

Let the importer tell the exporter which mapping types it supports when
it attaches. A new optional dma_buf_attach_ops->supported_mapping_types
table lists the importer's DMA_BUF_IMAPPING_*() entries, most preferred
first. The entries carry no device so the table is static and shared by
all of the importer's attachments; the device passed to
dma_buf_dynamic_attach() is handed to the mapping types through the match
arguments. Importers that do not provide a table, which includes every
dma_buf_attach() caller, support only the SGT type with P2P according to
allow_peer2peer, exactly as today.

dma_buf_dynamic_attach() checks if the exporter is mapping aware and calls
its ops->match_mapping() function to pick up the exporter match list and
call dma_buf_match_mapping().

If unaware it will use dma_buf_sgt_exp_compat_match as a compatibility
matchlist that uses the unaware exporter's dma_buf_ops callbacks.

The resulting match set is stored in attach->matches with the first entry,
the exporter's preferred type, returned by dma_buf_attach_map_type().

In effect dma_buf_attach_map_type() is always available and always makes
sense
regardless of what combination of aware/unaware importer/exporter is used.

The attachment's importer side (dmabuf, importer_ops, importer_priv) is
initialised before either callback runs so that exporters can consult it,
for example to recognise an importer driven by the same driver. The
dma_resv lock is not held at this point, so match_mapping() may only look
at properties that cannot change for the lifetime of the attachment.

For compatibility with unaware drivers copy the sgt matching data into the
attach->dev and peer2peer.

If the exporter sets exporter_requires_p2p then only the following are
allowed:
 - importers without a supported_mapping_types table that set
   importer_ops->allow_peer2peer = true
 - importers whose supported_mapping_types table includes
   DMA_BUF_IMAPPING_SGT(DMA_SGT_IMPORTER_ACCEPTS_P2P)

Other combinations are blocked.

Exporters that want to behave differently based on the importer's
capability can declare exporter_requires_p2p=false and check
dma_buf_attach_map_type(attach)->sgt_data.importer_accepts_p2p. Or they can
declare two
SGT exporters with different map/unmap functions.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/dma-buf.c | 62 +++++++++++++++++++++++++++++++++++++++++++----
 include/linux/dma-buf.h   | 46 +++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0dd8d0999a92..1913a84d3363 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-fence-unwrap.h>
 #include <linux/anon_inodes.h>
@@ -714,11 +715,19 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	int ret;
 
 	if (WARN_ON(!exp_info->priv || !exp_info->ops
-		    || !exp_info->ops->map_dma_buf
-		    || !exp_info->ops->unmap_dma_buf
 		    || !exp_info->ops->release))
 		return ERR_PTR(-EINVAL);
 
+	if (exp_info->ops->match_mapping) {
+		if (WARN_ON(exp_info->ops->map_dma_buf ||
+			    exp_info->ops->unmap_dma_buf))
+			return ERR_PTR(-EINVAL);
+	} else {
+		if (WARN_ON(!exp_info->ops->map_dma_buf ||
+			    !exp_info->ops->unmap_dma_buf))
+			return ERR_PTR(-EINVAL);
+	}
+
 	if (WARN_ON(!exp_info->ops->pin != !exp_info->ops->unpin))
 		return ERR_PTR(-EINVAL);
 
@@ -1027,12 +1036,26 @@ dma_buf_pin_on_map(struct dma_buf_attachment *attach)
  * Note that this can fail if the backing storage of @dmabuf is in a place not
  * accessible to @dev, and cannot be moved to a more suitable place. This is
  * indicated with the error code -EBUSY.
+ *
+ * The mapping types the importer supports come from
+ * &dma_buf_attach_ops.supported_mapping_types. Importers without it, which
+ * includes every dma_buf_attach() caller, support only the SGT type, with
+ * P2P according to &dma_buf_attach_ops.allow_peer2peer. This records the
+ * attachment's match set, i.e. the intersection of types supported by both
+ * importer and exporter, in &dma_buf_attachment.matches. Later attachments
+ * by other importers never change the set but may affect what type the
+ * exporter selects when the attachment is first mapped or pinned.
  */
 struct dma_buf_attachment *
 dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 		       const struct dma_buf_attach_ops *importer_ops,
 		       void *importer_priv)
 {
+	struct dma_buf_mapping_match default_match;
+	struct dma_buf_match_args match_args = {
+		.dmabuf = dmabuf,
+		.dev = dev,
+	};
 	struct dma_buf_attachment *attach;
 	int ret;
 
@@ -1043,13 +1066,42 @@ dma_buf_dynamic_attach(struct dma_buf *dmabuf, struct device *dev,
 	if (!attach)
 		return ERR_PTR(-ENOMEM);
 
-	attach->dev = dev;
 	attach->dmabuf = dmabuf;
-	if (importer_ops)
-		attach->peer2peer = importer_ops->allow_peer2peer;
 	attach->importer_ops = importer_ops;
 	attach->importer_priv = importer_priv;
 
+	/*
+	 * The exporter's match_mapping() may look at the importer side of the
+	 * attachment, so initialise it before the match.
+	 */
+	match_args.attach = attach;
+	if (importer_ops && importer_ops->supported_mapping_types) {
+		if (WARN_ON(!importer_ops->nr_supported_mapping_types)) {
+			ret = -EINVAL;
+			goto err_attach;
+		}
+		match_args.imp_matches = importer_ops->supported_mapping_types;
+		match_args.imp_len = importer_ops->nr_supported_mapping_types;
+	} else {
+		default_match = DMA_BUF_IMAPPING_SGT(
+			importer_ops && importer_ops->allow_peer2peer ?
+				DMA_SGT_IMPORTER_ACCEPTS_P2P :
+				DMA_SGT_NO_P2P);
+		match_args.imp_matches = &default_match;
+		match_args.imp_len = 1;
+	}
+
+	if (dmabuf->ops->match_mapping) {
+		ret = dmabuf->ops->match_mapping(&match_args);
+		if (ret)
+			goto err_attach;
+	} else {
+		ret = dma_buf_match_mapping(&match_args,
+					    &dma_buf_sgt_exp_compat_match, 1);
+		if (ret)
+			goto err_attach;
+	}
+
 	if (dmabuf->ops->attach) {
 		ret = dmabuf->ops->attach(dmabuf, attach);
 		if (ret)
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index de73f931a2f8..ecfd9b2d2aac 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -29,6 +29,7 @@ struct dma_buf;
 struct dma_buf_attachment;
 struct dma_buf_mapping_type;
 struct dma_buf_mapping_exp_ops;
+struct dma_buf_match_args;
 
 
 /*
@@ -316,6 +317,27 @@ struct dma_buf_ops {
 
 	int (*vmap)(struct dma_buf *dmabuf, struct iosys_map *map);
 	void (*vunmap)(struct dma_buf *dmabuf, struct iosys_map *map);
+
+	/**
+	 * @match_mapping:
+	 *
+	 * Called during attach, without the dma_resv lock held. Allows the
+	 * exporter to build its own exporter struct dma_buf_mapping_match[]
+	 * and call dma_buf_match_mapping() to record every mutually
+	 * acceptable type in &dma_buf_attachment.matches in the exporter's
+	 * order of preference.
+	 *
+	 * The match set is fixed for the lifetime of the attachment, so every
+	 * input to the decision must hold for that long: either static for the
+	 * dma_buf (the importer's list, PCI P2P topology, buffer creation
+	 * flags) or runtime state the exporter pins until @detach, for example
+	 * a runtime PM reference.
+	 *
+	 * It must not depend on the set of attachments or on current buffer
+	 * placement as matches are static and buffer placement can change at
+	 * any time until the final location is resolved during map/pin.
+	 */
+	int (*match_mapping)(struct dma_buf_match_args *args);
 };
 
 /**
@@ -499,6 +521,30 @@ struct dma_buf_attach_ops {
 	 * required behavior.
 	 */
 	void (*invalidate_mappings)(struct dma_buf_attachment *attach);
+
+	/**
+	 * @supported_mapping_types: [optional] mapping types the importer
+	 * can use
+	 *
+	 * Array of @nr_supported_mapping_types DMA_BUF_IMAPPING_*() entries
+	 * the importer can use in priority order. Entries are static so can be
+	 * shared by all of the importer's attachments. Any required dynamic
+	 * information, such as the importing device, is passed to each type's
+	 * callbacks by dma_buf_dynamic_attach() for recording in the
+	 * negotiated entry.
+	 *
+	 * If not provided the importer supports only the SGT mapping type,
+	 * accepting P2P according to @allow_peer2peer. When provided an SGT
+	 * entry's DMA_SGT_IMPORTER_ACCEPTS_P2P flag takes the place of
+	 * @allow_peer2peer.
+	 */
+	const struct dma_buf_mapping_match *supported_mapping_types;
+
+	/**
+	 * @nr_supported_mapping_types: number of entries in
+	 * @supported_mapping_types
+	 */
+	unsigned int nr_supported_mapping_types;
 };
 
 /**

-- 
2.54.0

