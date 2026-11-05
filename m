Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860931;
	b=ooj/eiBwp/0iHJG3OjqRgudt52PDG8JT/PiIQB1XY7TjTcXGearl1ExHMtpcITTcwcJO
	 qyyOoQ3zIq4ycjmA+QfT3YyZUkmlLJjmKpLWJAaaha94yQdXS1gVZ+5f46N3lvNYgVSp8
	 +XYIbKVaTNm55a/q1kgu6Sf8/WiMUoe6ZHmHdyhyWnDeivMK7BPTxZFeaLioQvqERnihA
	 +pJgXuPpBxLHNH0HA5mocBaf1gFJZzaIhoEVI+zD6LpXg2pLpnmojdad7ICxZaN88aF4P
	 VOBBweIcfLSXwhAlHnhciWGgyq2koi98PfjlEcDe3CcvhSH3p6BBjzbimsty9G/Ue3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860931;
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
	bh=V1wc6FZi7FD2Jw3qoczsBVBnO6a9UN4O2E2N8ekamm4=;
	b=Oz2cnGpTG487ltttnMrYxWOnFoJEdZPo7CzPt8v4Khp4WgrM1OLBg2lPcEE1Ldz1ABDL
	 jV6hd07db/66K/sMFXETkIWHrQxgVPS47GmYU+4uDHsZdSRgKGEWNqP24+G8MTKNgRZ2B
	 9qExxPIvfNGQdS3DMBhcu+s88QexGc3t0RKONjkIVUUFyG27xXf3nyrT3j4lX/JQi4hJV
	 dqnFSLtKxTgi+G8/Jrj+K1mlXy5U0yAREOCaPTlPgaJwFqQ2qc5iaVf7oje6r2pQWAF+t
	 sVTGIxmbWVIiYJlP94DnR4EU/oBKjnqqABlfU9yLURb0WAoGgsPeodsRgwLq20wkCrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aXt6B05A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.21
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012021.outbound.protection.outlook.com [52.101.43.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD086606D810;
	Thu,  5 Nov 2026 06:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD086606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aXt6B05A
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWEjnzJKUuofCN36lT8IfjTD3iLdz/Fj40b40fwzF0AmM8SpkIhQaXk8eZtgwNtJXQytRBz55SSHkwDch7gpX/51s+zVdiUa9Ffya7fDhg/uM9eXuSIVOFIy4pdFR2YhLyUpaRdw+b1oQ+6+7ZD6sDXyUWxCo3pgaXCyC6U3/Xann44SvB9/yTvvYYy/dQioFBwZl+wRWzzQAgRkd3v0aumlgY4HvoU8M2KJXUYeoRILXP6qJSYdhXl8npeobV3ltB10Tma9c0H1MeQfYG+m2l73pcoQ+pc5E6lzmxqWCLlArRvPWghtHEYMJJIt8irCeSCSHVPCXkevmRSaK6zKwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1wc6FZi7FD2Jw3qoczsBVBnO6a9UN4O2E2N8ekamm4=;
 b=H5cg6tJ13NQPsD4RiO+1gOLgyA9v0pQZrFUoRRr3p6VheS+A8skvb1fBFoAbuf5+uPOru9dsY6lASYBDI+KeIcd1dsdbC69XE2HwF7HsENg1yX79jww9eaTUmwqQAtB2yruXRiaA3xc8gkGMrJmwPILuYGucMAJ0xtXIodGHeA0fb03YCIzdIkUJNv+ZSYjn32hmzSrj9rFWZTJ/ar1Hf+W2w4O2An5v0EZ1gIMRfomGXjKuh/dWC6kK91qNG+ZG4Z+tQfTdlYff1Hfzui+j5cUl4d7dcXt6lYLO0dIPzGmxLftMpGPGe2kgkQDxXgm+4YeOuXJaGrgNIxmk/xnRHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1wc6FZi7FD2Jw3qoczsBVBnO6a9UN4O2E2N8ekamm4=;
 b=aXt6B05AIdqLvyQUeV8t9bnNz3M/mngkav1Rmprnhwz0M4A47aA5A/ErZl+qiwZGOFqoFhElZBzSUcCLNMrEeX1iLsm95qWK04EoxleoIE4nM7TRC4siD6lX01WoRYnW4Df2SuRVP4W1a26v/PuIKNRKMWGRNURVugX/8iHL5uDbPPL5qKcQ+jsC7OfYQ0E0CxQMSWlSkgUaL+p5OZBzrjaxBZR+KzxnMBOr6A3AWpiq5Yl8b6a7oNXCr10FVjLO5XKuHMamEQOUfEMhtVOpg/u9bSZ1ts3WxXQYlQUJDJuzIjPwI9q+DmgriMxkvqa1p5KIU+waJyZ5X2X3P2HQ4A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by CH1PR12MB9573.namprd12.prod.outlook.com
 (2603:10b6:610:2ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 06:42:00 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:00 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:42 +1100
Subject: [PATCH v2 07/23] dma-buf: Add match set queries for exporter
 placement decisions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-7-78b8dc9ae80a@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=3212;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=KJypAseily6vdhHOC5nyj+0IcgdXBBY4w3rJAVl1AZc=;
 b=5vXOik/JhMRshU6ZoWxsY1CfycNLdntBg9Ly//e8b1KAi12PB60XO3PGyTTl6xjq5HSuGiUOL
 eDubPOCg3e5A7EU9v5NZvVfZ44wcPZVDLfQoDg6//HaOT2alGf11xKF
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5PR01CA0083.ausprd01.prod.outlook.com
 (2603:10c6:10:1f5::17) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: bc09790a-602c-46b7-ac6c-08df3b07e54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|11063799006|56012099006|261009223027099003|261026121527099003|261102123227099003|261021121427099003|261022105027099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kzrvolOCBpoUOLsEStRHV1oIhefVp8c/xA7X9O4OuNoRpH1pzbBIOTpFScOXCjlKGzQvrWSVAkweXAFzLy9OdHTPcHcsNiIe2JscfKqGomJjSFGEpXEn45yUcHhDhGGbQSWrul53ZQdnCE+6VtIjnPHDpKzC96psI6XnikrkSeMnrUlWTk7qjVTVPe2d4eBXqHHAcy8KGP097FT876ITyxGCbiydZ7JP9RVwLNh4AKOjc7f+XONsDwcXOSQ8LHOu5VaZmHyiCX1q8+KjZy+sSK7czMRriMqfTUhRFhVb0UBL1jCWlRX3dggTDaSHKPcx3u7CINRC4QIKtSZxhW/9zdjQn9PmOCXW/hqiRRctUGKu+AMil+9EoCLnc0hBKTBDTdFDb28nzIZxnwJNdCOMl4rvEapK70hdqfpqHKOg1U3ePMB14Vz7bsGf1boPkWXvVnSDtU4xHjSs1/VDB79qGvQhhU0hUTVZuRkr9tk5RDRmeP0REPAisCI3RNH0KxCXdR2ITorH9LJFu4/bhMqKxAkptMQVLoacMxceCOZ/R7bHIXUKm2zZkL42XTMBWg7sb+bDDW5X1HC1LLEXDVfuDao0jz9kpPlW/5uHLLxxedM2KRd2lN0hZpFzDZgzad46VFiq4/BJPW+EyS1wKvY+AM7AGqWet7oaoF/Xj5bJ0C+RXnf2W/zumaVsI+WGat+huCqpa597xKAy7qhpOsEzYg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(11063799006)(56012099006)(261009223027099003)(261026121527099003)(261102123227099003)(261021121427099003)(261022105027099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnU1Ykp6R1c4dDJSbEtycmZwdVc0R0EwdWdZK2dQM3JHaVZCam1KaVVoWjVI?=
 =?utf-8?B?WWFOMUFncnRxbFdXaFVGaGordlBudlZwcXdsL0JiTUd0YkI3ZzVyT2kxVmpp?=
 =?utf-8?B?YXBKWkN1WGY1ckJ4UjFETTZwMzFkUmlCam0wNmxUazIzQURJdjJ0MXoxQUcx?=
 =?utf-8?B?UGExNHhUcmJGcWFTL29BN25Hek51bmVvbjJpOThrZTFWUE5GU0hEY3VVNVlQ?=
 =?utf-8?B?VWpYU3h5UlVrN3dyUVJuUE1XRGU1L2ZYdmxIWU93Yk5Talo5OHBaRjQ1Y2xr?=
 =?utf-8?B?czFTT01CZTBTZjgrYkVyUGxOcy9VMTFLdXJEOFNOUitQbUdKQzFpbXFzbGNk?=
 =?utf-8?B?aFJYSEx1LzVjemc3c2xIbGVkc2c0Q1RTU3VKSVdlYXIzT1JHNmFpODNiQUtH?=
 =?utf-8?B?SUlud0gyV20rWC9DQUlmWnRzQnFuWkpsUDFidzhrUEFYL1ZoQWl5TEZqVHpQ?=
 =?utf-8?B?YnZQeWxBOVl6YVBZSDZOaDZhZXo5SFRXa20vd1d4emNsOUIyUTFHaS9xdEx5?=
 =?utf-8?B?TXlKeklkVWVnaEpyK3BWd2d3aFA2QnlaQkU4L0pMcjMxek5qOGdpMlVobmlp?=
 =?utf-8?B?VktHVWtXU0xOSDNsYk12NzE5VVUxcjBKZHJST3VVNWFEOW8yN2VPL0oyRldE?=
 =?utf-8?B?bllWS1AyZkpGRzFYa1hwSjAvTDI0UFFtSEJNNkFVcitDbVo0NE9va0lZQmJS?=
 =?utf-8?B?NDM3M3FnMUpEcThkUkhWdUNXclhMSmRvWXpraVZRdENSTU96WTg3N1BzR3BO?=
 =?utf-8?B?UThnbWRGNXNrUzlWSHliVld0NWJWMEFnWWJjcTgzQTlxMDloV09RVGRvV2hi?=
 =?utf-8?B?amtjSldNbGFZMjljV3VPK0FjR3dVZGxGWWVFSTV5ZnppbHFDVEdNOFFRK3pk?=
 =?utf-8?B?TFg1Sy9CT0JqQlRIbWF3TEdGSDdaaWZ4c0l2RW56NHRQT3c1WnFUVVNzZVlK?=
 =?utf-8?B?czQwQ0F6MFNmRzQ0NzZ4MXpHOXo1RjlodEJFYjdqc1hHVUQ5SU1oNEdMUnpE?=
 =?utf-8?B?VWRLVk83cG1nQVhKTzdlSWVvcER4K0x2S2tjWUI2TFN0RGdVc08wNTV3dnU3?=
 =?utf-8?B?NTYzeTZNNllXeGYvZXFQbC80UGg2OFNCQkppbmVRM01QZ3pMd2Q3L3Z3b2pn?=
 =?utf-8?B?aXErbTVwK2tMMUZwMmticnpzalMxZWVrZjBRWHN0cUtlWllUUy9VNnh5eGs5?=
 =?utf-8?B?NVN3WEJ6QUs0RVNZc2dUSjlDQy9Ba2l3Njd4ZjR6YVpORkViOUU0R3ZVRTls?=
 =?utf-8?B?QUNLWDkwdnM2TzlYQ0x6K1F3Mk9oZnJDd3ZHQUdXMmdteXppVnBrdVhvbEVh?=
 =?utf-8?B?WHFId2NQL1Foek85c1dEZU40d1BpNnpPV2Y0MVR3SVVzUGNaZ3FXY0swTnFZ?=
 =?utf-8?B?bVVqdnAyaXY2T0VqUzduR3k2UzV1K3RZU3RPRjdPd0NJazBJdTZ4R3U2R2FD?=
 =?utf-8?B?UGRaNSszeCs5d0xEK1o5MVRpbEp5WWNCYnkyYXlaaStralJiaGIwTG40TU95?=
 =?utf-8?B?OWZ6aWpaWmo4ZmNSeHY5YlZ3dUJUNGh6YjIxNG1GbmtxUkFxelNMaDJiQzJV?=
 =?utf-8?B?NVUzc3BSRnlucE1LdUlIekQ0cmZENzJWeE1HZjlodzlFbmhDV2R0aUNhTm1E?=
 =?utf-8?B?dVN2RjkyeHNxSUhwOUh6UmlvdDNFM3hSQ1BpWlMzVWJ4MndVZ2VVeitEM3Zj?=
 =?utf-8?B?blJCdWN4eVhoWHFlYkdBUHhtQ050aEo4N0cycitGNjEwZTFwRFlXbU9GNWl0?=
 =?utf-8?B?Y3ZwT0NJbE5aU2FQZEFEMmFMNy8vZERyWnh1TE9keDZ2WE91bHI0bEppS2M1?=
 =?utf-8?B?YkpuUVZHL2k2RnJZMTNQeWtROEZBRGhOY3EvOFBjMHY1ai8xVmhKcUpiTUJh?=
 =?utf-8?B?WU1ETFRHUVNYR0xPaTNETzdXd3RldTMrZm9pY3dpdXM0Qm9hYWdzRlpOZU1T?=
 =?utf-8?B?RVpseTFoUEhHcFJRYkxFWHcrbkFIdG9UOWhOT3RsckdjWUs0NTE3Z2FIYlE0?=
 =?utf-8?B?WXBERzFxUlYxaDQ4Ty9FT1Z3ZVdTWU93cDJKVXgrRTZ6UDJXYmV1bzBxN1pi?=
 =?utf-8?B?WUloRVZxK2dFT0tSVnVuU0VrOU4zcWtTd3AzUU04clJzcjdaWU91dHJjZGlZ?=
 =?utf-8?B?Sm53TVdDa2kyY1l0aU53MDM5S2VRVFFIRkczMFg5MHh6UFR1RjFLblhtZzRT?=
 =?utf-8?B?eG01SDBRNUYyY2Q4REJWSFNpd3ArK09sSjNpRy9vb3lIcnVuWXJRdXVwVEZQ?=
 =?utf-8?B?WGZoQVhDaWRuTWpFczQraGNDYmFBVTYzWWZ4Nm9QZy9uMG5NVmQ1dXRlVzZn?=
 =?utf-8?Q?GitVl5UYaN/iOedAis?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc09790a-602c-46b7-ac6c-08df3b07e54e
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:00.8463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JF6oOIcLzMRsUBEferhdlqKNRVAAXZAIoP6uIZVIsuPA6A9T/O1tH7VEiQcs76JE1vM7gbyxBAsZrRpAjtG0Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9573

Exporters deciding placement in their pin path walk every attachment
to determine whether it can take P2P. With selection deferred to pin or
map an unmapped attachment only holds the exporter's default. Therefore
determining what is possible requires walking attachments.

Add dma_buf_attach_accepts() and dma_buf_attach_accepts_sgt_p2p() to
walk the match set and determine if an attachment is possible with P2P.
A future series will convert P2P into a distinct match type.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/dma-buf-mapping.h | 46 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/include/linux/dma-buf-mapping.h b/include/linux/dma-buf-mapping.h
index 0ee798a5acdd..7140fc13dd00 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -138,6 +138,26 @@ int dma_buf_mapping_select(struct dma_buf_attachment *attach);
 void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
 			      bool was_selected);
 
+/**
+ * dma_buf_attach_accepts - Is @type in the attachment's match set
+ * @attach: the attachment
+ * @type: a mapping type
+ *
+ * Called by exporters deciding placement in pin or select_mapping to determine
+ * whether the importer could be served with @type.
+ */
+static inline bool
+dma_buf_attach_accepts(const struct dma_buf_attachment *attach,
+		       const struct dma_buf_mapping_type *type)
+{
+	unsigned int i;
+
+	for (i = 0; i < attach->nr_matches; i++)
+		if (attach->matches[i].type == type)
+			return true;
+	return false;
+}
+
 /*
  * DMA Mapped Scatterlist Type
  *
@@ -185,6 +205,10 @@ dma_buf_sgt_dma_device(struct dma_buf_attachment *attach)
  *
  * Should be called by exporters, returns true if the exporter's
  * DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE was matched.
+ *
+ * Reflects the current selection, so is only meaningful inside the
+ * exporter's pin and map callbacks. For attachments which may be unmapped use
+ * dma_buf_attach_accepts_sgt_p2p().
  */
 static inline bool dma_buf_sgt_p2p_allowed(struct dma_buf_attachment *attach)
 {
@@ -194,6 +218,28 @@ static inline bool dma_buf_sgt_p2p_allowed(struct dma_buf_attachment *attach)
 	       DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
 }
 
+/**
+ * dma_buf_attach_accepts_sgt_p2p - Could this attachment take a P2P SGT?
+ * @attach: any attachment
+ *
+ * Like dma_buf_sgt_p2p_allowed() but valid for attachments that are not mapped.
+ * Instead determines if p2p is part of the current possible match set rather
+ * than the current selection. Called by exporters walking all attachments in
+ * their pin path.
+ */
+static inline bool
+dma_buf_attach_accepts_sgt_p2p(const struct dma_buf_attachment *attach)
+{
+	unsigned int i;
+
+	for (i = 0; i < attach->nr_matches; i++)
+		if (attach->matches[i].type == &dma_buf_mapping_sgt_type &&
+		    attach->matches[i].sgt_data.exporter_requires_p2p ==
+			    DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE)
+			return true;
+	return false;
+}
+
 static inline const struct dma_buf_mapping_sgt_exp_ops *
 dma_buf_get_sgt_ops(struct dma_buf_attachment *attach)
 {

-- 
2.54.0

