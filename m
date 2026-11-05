Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.1
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860982;
	b=t8h9ZkmUnkKipXHOArwtkaCYDtiJ1rFXci99meVvJTC4l3m0f6xqFc3OCq4//TC4nMGV
	 ibrJ3QnNF/c7ZvrAiyyQdUJ01CoHT3yoxSkHYy1gJe7JLcy1KlXiyebiZxquhKPsnzmPk
	 +9fAFboeGA+EYNa8ReVcEaom3b4Yqpk+URLH3i4nepg2bYCl/lL7r7LrvuYy4ruVtYb+H
	 iuSiXVB55yz9C5xx0fTlmewFpUCC8lErzKjpLfLGlGaMX6egifvWmQiJhlHXxGDB5fH6v
	 TMhWtsaET5gJtPys6Zm7UetU5Jthksr6kutHiM2TZvnqwZhZvkxqMWAc4IWMLvYEwFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860982;
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
	bh=8GTdNPmSGRqkufcgG3RA/KpcwHiqDFcK2OrE1+6yC4M=;
	b=Ug1JIi8/rv4Wu4fuGTJmkC0b6IKOpnKwITYhoX1hQy1pmTd/WcunJGjNPDMp45Plmbgk
	 nP8ONVBibnSIHCNYXxZFzWdl6Sq+Tj+raSUw039ZxWYEBEwywW9L6aICgtPaj29d8278g
	 PpjBw9Tuy8O9kRShjet8k3Sh/Z72Jrq8M4IzC6wX95p+yfiFj5XtglnRd86WSd5j+Zzz4
	 /sAR1tfuz/hgE4pLNTnZL71R9zvJ6JbsJ1TmDD3hZ98IOccVQLHGGnQSozH42G5W14NGn
	 ATfxtlDfYmqJPzw8Wj4TqamRZWAez7kzT+XE0V1gtnTM+oF4Vgchra/tU5EDQtfXDhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T1Gns2ta;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.1
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FCE606EE93;
	Thu,  5 Nov 2026 06:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59FCE606EE93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=T1Gns2ta
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oT5+Z6YgUwJdCInYMVF0+fRmrAwTnwNjA7SIhiWiAVt2Fu7kZxX4HmxRfvWYxZ3AhWwwZWomSyy34eS7DFFOZ63OyW9cVWXLdoQ/asLyFsC2poPXuhwrsOXc1h6WqmHmfh79MCaDwHOHeEPMeHTwA+pnGPW+DnT7/4xzbRoNMyK05yklsJMkW3GBmAkq26vz2fgIPlbXtcDMSlrygY3AHn2Qe3nsMvYK3XIfwk9hkJ9bYpLS+hcQiAej1P3peoy44SA7kAoK5SUl7jx0KdcRBqUnGMC21UCNnKcYC26ZTWibbdX4Zxy+z82r5A9tnJJ3u9Q3N0rjqWcOb8LybGpsDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GTdNPmSGRqkufcgG3RA/KpcwHiqDFcK2OrE1+6yC4M=;
 b=ljNz7+pLkzYiNORUTi2T2uGR5Dmr0l3tXbu1j85YLL4cnz10tXAm/hOjTDfraIkznuLKQslOJD6//7lPOhMQmMYOZOBoZbmsOYRrL3OIHf4lIeqZSaZhSH5a0HowdKEboYOQ60b+vFjFKu/LGGt41LS4gMV43duG9xnO4HsT+Ijdp9A99UoEqnjOJqZwmXhasOSEj7dyxr3okfWI2e38ixt+G3dXEH2AfrVVqsNroiKjcar2XZBp6MLTr4YHcxPDIZFK9eqt+UT7d12QRbN9D9czvyCmXbo4+JSbEZYThG+67CfHi2E0lVF11CLfz1Z5a2omlD4i13mJ1cg+A6sUyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GTdNPmSGRqkufcgG3RA/KpcwHiqDFcK2OrE1+6yC4M=;
 b=T1Gns2tapm8f3BjYCKemPzBn3TKhgzUmsZ135s2AXixfHDDE6ka547b7PV4czh322mwllqbdc0fWvqmPS0xEPziyc10n20935AZIzp35Oa418lAk8hEOknpNb/DwOtER7lxQ+mDJ118HTUX6ZkHXVvtU5971zv8x+r1PYTA6YAeynhpW8LpI63r/8qOZstoYoFqv6dwzdDMSxf4xjtkapB9hpbcGH9eoW9earin9HErT40sLI4A30eM115Sw3dxGkcMnlaTgrcvI81/KqYw0f+7gnILqp/fBFr05dqR2cJoMk2D5YN/UKCdoo7RlUKEaxQn1+oEE9VlzO4NiGsN3Wg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:58 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:58 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:54 +1100
Subject: [PATCH v2 19/23] iio: buffer: convert to use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-19-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=1891;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=LE7YFP1ARjpZf3SmEkIIrOo2zY3aq4eZTVUr3LoUroI=;
 b=2H8uiSu5beIZJGIg2nrFaD3BCe0NCbx+fH2OOGpPNYtOpC0K4mQ55QHMTGE55YR8mS6HQX2OD
 a1FvZlR41CFBjA7VGMMfFutreA7ou5eYOtmL+5UayQ3AEIGrvbwPITE
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0166.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:24a::14) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: 80375182-407f-4e61-3abc-08df3b08076a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|6133799003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	ZC7p+cE0uJkqwKNVGezm3nr71/525tHqgusOSxSWWnYZJ9JNAmF+P8q6LKb9CMicMqaSTYUXHG1Zd8Uo2diClTwIHeZ1uUlZEbny2toDcEgM46k+O9HhTn4uY2a4IWCRC1i5qODgwrWOT00/2PDpckjd+3f3eHq7FJw16txHSk0oMVJzw6TQanG0lwC4E2GwcSCAxbIZ7/ito6vlspeDZo1bzllRJzcQHDsWTbTWcZbyXf4NFJejjsGUkyRZhl/G1QhbITS68necyhA7AwwyP6rf/iZEMAzhsyAuU40e7mnzAN1lL6IhzwjGuTUn4NgGp8Q3IA7U1Ci1r3k5wAHhDSL7R7zLgwuJwPZGNsLdLjv7l3+SMkdPGHKxiIqcR9654lZq/6pYn0XFqwi/Yy4nGau/REZqMLb6HFAcdadm3BvNnCzDdyw4bgPVHCwsG7IM0XLWnL4S5h97ZXzE/AHhoqyJEZ/MIGkcW3xtSNvdO4sCEu8V+mVCYL0PZvtiGn8EBFYJHiy326hIxtPM/ApZkh4kN27ag8vIZMN+8FhfgBgmsvkaVWRty6eWh18mIoBX/wWxTPEO36F5fuYbnlTcXYI2hhPEzvK21/4fsYBMkFlvUrDVa5RonKGvVStcBkQeLrFa9pXR760hWwZaeEVUDllRdJdctP1tYjpkuwhTXoXCCaFzR1ISkgi8ovF85EDXqzV00WvI102N3HKbsFKwIA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(6133799003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE1vUTZSdW9UTnFoSS9VZ1dYYTF2cEZ3NGtMUGlZYlpRZUNnZ2RBNTc3a2Rz?=
 =?utf-8?B?TVNoV0tjUmhkUHQ5RHZUR1dTL3hVZ0JpM0NHby9OWERmNDhSUlRWQSthS0Vi?=
 =?utf-8?B?VDFqMnlVQzVWNWF6RGNrR0dOY1dWY1R0bGZkQnVxMjJwVmdyd29iUEx5TDFv?=
 =?utf-8?B?M3E3c0pKZmRpeU5IZ0FjL3dLL29BTE5FdFBad3ZWRkw4VzFPV1RKWEtqeVVo?=
 =?utf-8?B?cThhU01VSG1FSW9XN3JlWUExR2xwRW4wZ0t1dlQ2bXgyMXFFYTh4T0U4dnFB?=
 =?utf-8?B?Z2dEZ3dHWlZLVzgrUzBrOWtzMUppTzlvbG10MzJ2bkdOU1ZjaFJUOW4xNmlF?=
 =?utf-8?B?bHR2aHJPZmtObjc4MGRMRXl2cFI5dUdkVVpkODc5SVc3a2Q0NjVEWjQ2RzV5?=
 =?utf-8?B?NjFlTHNqUCtmNXNPZFNERmxJd1owUG10ZVVDLzF0RVh3UHIyazE0OXZmU2J3?=
 =?utf-8?B?RGI3MUIvMUNNQVp6T0d6QkNoZ294WnoxZHo1RitaT21VRVNqdFVNZFlvSEFW?=
 =?utf-8?B?SmF4bkN2U1dJSlUwVlFaVi9rVTJiWjRpek84Mlk5c3gxb1R5U0lZV2Q2Q3c5?=
 =?utf-8?B?ZWp1dW9Ra2JIYW14VUpvSmR1Nk5qT3hveVM2OC9sY0x5MEtqQ0pmMnZUd2Zy?=
 =?utf-8?B?cGRzK0I2STVUUUJIalhyL3g4L3M2eVpTYlNHTnIxOXhxNllaRkRnNWlZM1E2?=
 =?utf-8?B?cjhkT2VheTNPbk9Qcm9wREZkRXFmcnZ5MDZxOUFVc2NOOXl2NlRwcUd5T1Zp?=
 =?utf-8?B?a1ZIaDIybk5iTlZCQTk3VXFZQytoMDFkaHJCOCtVdkdnV1pHNzBRdU1FOEpC?=
 =?utf-8?B?Z0FNNTF4VnpVbndDQnFCcVhvMGZxelMwTklqSkQ4dm9seHo4WkNpZFloV0ZG?=
 =?utf-8?B?dlFZWWhXVEU5aDNqWUMyK0UwQkNiVTVkRlYzWXIzY1RCdGxXektSSFpRMHQ0?=
 =?utf-8?B?S1VET3daMm0rT29lMzRFN2xqVWsydWRqMlZDZUNNeGw3MHljNnFJRUhaeGpj?=
 =?utf-8?B?ZXpLTGtKTG1UY3hzYld3ODZqVFFyemkzcTlud1JXZUFwMVo3aGtTTUtMTzEx?=
 =?utf-8?B?UG8wMGdWZzhmSmp4YUZzOTZxaHhkU0dPZ3BjMHprWWtQTkpsYzZVanpDZGNk?=
 =?utf-8?B?TkptQWFxZFJIallQb3J2REpLaWU5ZzBjSHJPeldQRzJrMkRncXRCYW80V3pU?=
 =?utf-8?B?TTB2d1FQQkxJek1nRlBMbjVXNkthTzZKQzdpWHZVbVJpRmo0Qnc2OTJXZFpB?=
 =?utf-8?B?SFdEakZ0SWdZVjJvaVkzRFZtSStWRXNyVTZ2Vjl5SU9iOVlqam5vQ2VNOHBT?=
 =?utf-8?B?c2dLalZoaWVFL0J0Zm9Ic2tJS0xZV0NwNkVDWmZESktLYkN6a1hLa1hrYm9N?=
 =?utf-8?B?eXpTYU5SOU9reGdJcGdDNDhqT016TEZiM1pmV0NVckkyQkgvRHo4c2FuSXl4?=
 =?utf-8?B?MjFzL3Y2S3pPR1RQNkhtUFBMR2NCWkFFMW4weVk4VUdob1lCUVJUZ1NDZmVR?=
 =?utf-8?B?d0FodjkxNTFDdzRHbEtWRTNlN1dEZWJPVXBJajRvWWd0NHFxdEIwNGtTMFNw?=
 =?utf-8?B?U3EvTjVxY3hDdWRzQjcvczdPOTMxOUFXSVJJdWlhZFh2UnVnTEswTE4wbGM2?=
 =?utf-8?B?c1BuT2JVMWdLcVQ0dWFmYlpseVpnWk80elV0NXQwTTNQbHRGdmhXcTVhOUN0?=
 =?utf-8?B?T0dMaHdZeTJIZkZOZTJGMXE1Q1U0SG1RNW1aaE5weDZwWkNaNXJtNUNad3Rr?=
 =?utf-8?B?di9HZkdlQW9ubi9rSzlJRlpKSWhpZzcxRitPSmhWeENsNk9WM1oyRVorNHVE?=
 =?utf-8?B?U3BPSmt3YStDWHJ1Q2twaitWK0J1SERkSkYxMWd4aTdyajNvZGVQdHlFSXNK?=
 =?utf-8?B?ZG0vemhvNVVhTEdRdTQwM2ZuNnJLc0NnL3pvNVBnN1gvUWx6Sk5TNnN0QWh3?=
 =?utf-8?B?MCtMY0JkY29aeVd2OVN1NzNMUkJqajhHUWRqOGVWREdSVFoxeE9zaDA5R200?=
 =?utf-8?B?L3d2bFlrQmhGZ0wrc3RFaDhDclBEMEdKMjZYdWxqcWpVa2dTT09pSWI4UFVG?=
 =?utf-8?B?YmIwYlNpRW92UzdyZkhFaFVuWTNTT2hFQXVRZ3lFZVB2eWZuc2UybVpTNUN2?=
 =?utf-8?B?akhlc0kzWkkrMGpsK0ZEWGJ1N3czcWpVNTNhTDZoRUV0bnlsMVNZNzV6MnNZ?=
 =?utf-8?B?SVN2UEZES2FIZklhOWxTWlA4VE55eW5EemFhaTFDYml5Nno5Vm5Wbmxyd210?=
 =?utf-8?B?Z3gzVFFNM2RSd1doQjlnS0Z5clJEMzZOR3d3RHJEU1hrOU5TS0ZaWXo5SENU?=
 =?utf-8?B?MmhabGFSNjJvT3NHejIzbDZ2TEkyRVcxTEE4SlJrV0VuOGxOeTZPdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80375182-407f-4e61-3abc-08df3b08076a
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:58.0633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TcQTAnzoCgvlx6OP7PmAhI4QMVJiDhqCw5vtY9K/7Js1+S5zRC3cXSej2kW2izkCu7LR9EpOmbaJkxgDUSPMfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

These importer helper functions should call dma_buf_sgt_dma_device() as
they are always working with SGTs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/iio/industrialio-buffer.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 4a1063e4891f..f907fb6ca936 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/device.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
 #include <linux/file.h>
@@ -1676,7 +1677,7 @@ iio_buffer_find_attachment(struct iio_dev_buffer_pair *ib,
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			attach = priv->attach;
 			break;
@@ -1760,7 +1761,7 @@ static int iio_buffer_attach_dmabuf(struct iio_dev_buffer_pair *ib,
 	 * combo. If we do, refuse to attach.
 	 */
 	list_for_each_entry(each, &buffer->dmabufs, entry) {
-		if (each->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(each->attach) == dma_dev
 		    && each->attach->dmabuf == dmabuf) {
 			/*
 			 * We unlocked the reservation object, so going through
@@ -1814,7 +1815,7 @@ static int iio_buffer_detach_dmabuf(struct iio_dev_buffer_pair *ib,
 	guard(mutex)(&buffer->dmabufs_mutex);
 
 	list_for_each_entry(priv, &buffer->dmabufs, entry) {
-		if (priv->attach->dev == dma_dev
+		if (dma_buf_sgt_dma_device(priv->attach) == dma_dev
 		    && priv->attach->dmabuf == dmabuf) {
 			list_del(&priv->entry);
 

-- 
2.54.0

