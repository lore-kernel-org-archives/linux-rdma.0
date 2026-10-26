Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.68
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993000;
	b=2oWAOKxGlcv/D1UM1v8ENHAl96wEaAdBKEW08lajowdJ/Dg/46cN9Wk35HzX/A+j2RrA
	 BJRg1i/xzmUJIyqilZ52LJf1+ysw0GuFDw/F/N1dcOEedkCFYMq9rtTIPizb9WJhUUQcd
	 /cGbx1NBYWdTL9y2dz3lI7XgJHBu30tDcarjF12o6o+xRezcmXwyvbFqQw0SatGc6S4G3
	 1PA09JTFDg6gSj0E9SczvfVj+0U0/QzTQbJyXr6UjTPpyFV24zSfe8dR1jj8B3Id0DaPY
	 cubGtE/dPOqt31xXCyK6N9ALoIOYUUUPy9L3v7gZugfHEHyjdWeVpPO5HtPa+9T/klw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993000;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Type:Content-Transfer-Encoding:
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
	bh=8OVkV8I2MZf0TdEBouUn2k1PN90Izil9T6fyUblmp5c=;
	b=V4fRJbej9TFpO/MazaL7vkTubXdLmHP3thxQ4ng3IpOiHeMm07Jl9Y1xffud+xoatx16
	 9/tk+pufuvSAPMvYstwtcaJZ6GJXL3dXIhWRCKxhnCKRFUkYkzne0L/Nix3znBcuTDwu7
	 +YoS4YU1xe2Wa3lvCAoJJVpRhMEte2DDVWQtiWZkGqj4TvoC65itXAqu7saSyfyTrfCWu
	 RLHnPL/8gZ47ZsngE+rNJmZulZMzyj2OpTiEWQjGKl8v0/ItgdY69Y2tNQgQQA6h2FVGY
	 JUSM+cQtScKAfiyX7TdlCijO+lIO9eKMM0GZT4BoOl9Wq32Oj8Q13obRWd9P7e2eNzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M4pMUC8a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.68
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013068.outbound.protection.outlook.com [40.93.196.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F76606A31B;
	Mon, 26 Oct 2026 05:36:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4F76606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M4pMUC8a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K48VwyYnvXz/Jg/mr5JFFlzrK5V37J8l6OHzVhPQ0pSEp8rQM8sKDj8BwivFllQLN+z4ZkV2bCCBNz7e6Szp7cBAOTgujfexBgeyxsy+9pWKwc9CbHXnx9CPG08AQJyTGJM5plfYMO/GHlBNNdlAG4pPWWu4WO/EcHn++Aq8opMPVXuNW8wop+/O5d7+QB78kiacfH1VDqUgtPasp+o8SC2wfu/P3E2e5bOtzv0YCBIcZeQxCo7zHLyHGCpNwsTRnTkZLRo9fc8bMDV/QLQkXmNm8vtuAos/6VuIYTaUiQ36JCLo6jyNjo0cuzDGy+s5q3bHqyWlB9lax232TDbWNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OVkV8I2MZf0TdEBouUn2k1PN90Izil9T6fyUblmp5c=;
 b=r+NfFbFNxIkEsgYke1bGTKYZU7+AakUFIv0SVPH1zw+qdT7gU4NowXjN93eIfvB6x3yBPZkO1TQXxRkDNqJLVd8o7wNorNoUzkSI8QWQkw8DfdojONSbKH4YKvTNt2TCTGaDvoajpFAU21Y/B+6LKNuzJ4JKDVcIKpWLlMHi/rWOIQRrU27uIt+4LLnF0XUbJhEoEb9uc3DedP8NTedtb7QonefL8hgmAbl1KOqEVK3PqNmtMtxyxQ4vGO1Wy2mEJuCVd+mb8iztUUrXDZP2EK8Ioy7rye8f4Db5PXSCrDLz6FVG91eOTi77nPw/hwMH5PUE1Oqhv05IM85Vz2hY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OVkV8I2MZf0TdEBouUn2k1PN90Izil9T6fyUblmp5c=;
 b=M4pMUC8aq2CHortKrM71P6jbm3BSaijXNj4JdUOufKAR4jKy000wmQIJZe8lZZZzbJxJz89sZxlNHjkWHW7zNdlTly3fGSHO3E5jPyJN5zvorUGpNdqGL0yAHyPdDXlxuUu8BF0RChAhmoy8BfqX5Jqc4U6kUwHM2saOMcSxdDHswLi6r+ljgupGNVjpL9gZCRr1OaU+eCaVPRUAb/CIn9kEc5u+Bxh4LGIRmC64USUBeLzijIhzc/EOj24LkY0cu7IR6Q4fugMLM+Ic/9J9mNUItA0Kw85+XyoKI8wuRaxrnY/zHJtZUg0OFPpc9PiJC3oh7xVxGRgPaqmGYJxFbQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by DS7PR12MB8347.namprd12.prod.outlook.com
 (2603:10b6:8:e5::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Mon, 26 Oct
 2026 05:36:34 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:36:34 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 00/26] DMA-buf mapping types
Date: Mon, 26 Oct 2026 16:35:51 +1100
Message-ID: <20261026053623.202642-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0160.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::15) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|DS7PR12MB8347:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a5e2b35-dba9-4655-1853-08df332318df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|3023799007|18002099003|10067099003|56012099006|11063799006|261009221227099003|261009220027099003|261009221727099003|261009223327099003|261009223027099003|261022075727099003|261021121427099003|261021123027099003|261022113327099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	OzPdmTe7DTizLAXQkML88+Xhy7PElpcIv0LI4ZH68IZ5hmHUSJyzFF6EdEjIQAF1hq/Lxwip4M9ryN0osnIOIG5zRDUPBOWiFfxsVZlt+2MflM65IFe0thOs3Ol0P48/RSdcAw61gQ57O5vfYpcYnDiwbbXi5QWja3erOIOgISTLNcmJP0umQDOH6aG8ky3HCB/90JcZQ9F8EOVuMlrnopeFrYEkJ3J80144FdbRU0fB1X8D8PxTnU7+8B0zoCQxSvzlRhsksnMH8NjOie/O6sYvkykkcIWfjbUIF8D8dP9lH2PlKgwwzr7/r9qqru5fSVZFAIMrTcL3DNrUhGCUMyhMPOMlic9k0GtCC/yjMsgrBqjazg8k39KmF3kimf65PHUGXANcjnUeeeL0HziO+8UwRTNaBqvyB+03se4/MpinVzE9I6VuIYtQz1Q3um4YXdYTEcdyV18D9karHEUf0A0OMY5VkpwSBd3LA+D5n4W0qPKB0JG5Q7o1zRCzAtaNfovXiGl+dbsZ1EJ8qfSFeT25doPDsCEEuQlPgvPw+HpJLB2Cv2H5mUrEsQaYkaFYfSAWhfJmWhXBRR+ZDxVJ7Sh3OA1ScN2Pjf1wKxddY/VRyxl1lMORVQYQ1XlKjGvSMKlccrHWl+0gRPxsLlskesXYzTj1Xx8vAmseqnFWUbc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(3023799007)(18002099003)(10067099003)(56012099006)(11063799006)(261009221227099003)(261009220027099003)(261009221727099003)(261009223327099003)(261009223027099003)(261022075727099003)(261021121427099003)(261021123027099003)(261022113327099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlZqZlNZMktHeG1SNEpydkIrUmI3c0U1elBjdkl6dmZ2ZXJDeWZJdWlkRW9q?=
 =?utf-8?B?V2g5MFIwV1BFNlhlckM0RXk2Q2JQM01lZWszdDZrcVJKQkJ0MmxNS1krTkRt?=
 =?utf-8?B?RmxhTXhNSGlXU1IvRXVvRENjZ01xZG40K1NhR1VyZUFnME9lQVB1eUQvVXU1?=
 =?utf-8?B?YzJQNE05RHNlS0Q3SW9jMjZlb0N4Q2RWRzZUT3VkaVhCMThKd0hOQlhBQURB?=
 =?utf-8?B?cjRhc1BoUUgvN3FBOXFHV0JNMml1NmFiT1JuQXg2eGo5a3djT0dQNGR1VGZy?=
 =?utf-8?B?SFZoS0cyRUNqbjRObm5FcjdyMWtOaDRjV25YOWhwdi9GdVJBcEI1MUhVY3RG?=
 =?utf-8?B?TFNNdmREMUZiRytjb29uWFVzQmxhejFIdXVYZjhCNnFyam5RNlFrUFJmc0lq?=
 =?utf-8?B?WkhBeWtWOUpXYXVGdFFvNVZyU2FXVjFGb2QrYVZsWDdhVVdrQ21oeXJHRnVG?=
 =?utf-8?B?bzNDekFZZjQyM3pTNGdaTER0bTlSNVNzMDV5WVM5YzFIRjkyVzZ6MHJWdnhT?=
 =?utf-8?B?N0N1eE9wb0psVkt2akdXcy83THNKS0R3MTg5cGZyNmd4U0tLQlZxaWh2OW03?=
 =?utf-8?B?bkxMeUpCZmpQNk9YSnplNlFoN1VocTBhNUpFUlpiZmI0TmpEOERaSnMyb3N0?=
 =?utf-8?B?ZEIxa2dyQm9zUkRZTzg4Tk1aeVUxcUxMMEVPTlJIVFZoTFRlRDRDZ09kdzhj?=
 =?utf-8?B?ME1zK1Izem9EZ1BidENWTjFVZkY4eUpSRWY4My9wemFGb2xLWjJnWVF3NjdF?=
 =?utf-8?B?S05CRTVUdDRsNjlNR3kzZlpjNG1pNWdvZmZtb0U0WUlrUkM1b2dVVnZnT0lz?=
 =?utf-8?B?RmQ2L21FZThmbmdKWmxReXJJdjRXclZlRGtmNWE4Y3NFTS9yUzFjNWRDVjhl?=
 =?utf-8?B?SlhyRXAxL2VqanFzai9xUDBmQU9aYUluUHhCb2dNdkEyK2llL0djYk9xRnRo?=
 =?utf-8?B?anVuZHVKSVpjczEycHNrV1N3Ymt1UUdvTlVWa29tOVdPSEdPY01FRnB6QzdY?=
 =?utf-8?B?bkVBU0JxUm9XSHdLMGJLNzE4VFBmV0VVNW8zZjZZaDBVa3hqMTMzT1lnZFkz?=
 =?utf-8?B?eVFYb1J0b3ZLTyt5emxYTGVESnB3TnVYMktuSXpzNlFmalhPTm5ldWo2NlRT?=
 =?utf-8?B?NStOcHl6UFpON1g3TG5TeUpQVEpXeThpQU42M2ZBSSt2VnFPVVZuLzAxejBn?=
 =?utf-8?B?clBJTFB6cVhxNC8rUGQ1amVkTjQ3b0F6YXdTcTZRZkpHSEhERE5ydmUxOVdJ?=
 =?utf-8?B?SVdIZ2ZjcTNQUXA5aVBLRU9BOWVXNCtpTGhGZjc2a1MzRndIQUdYSjNLRDJ1?=
 =?utf-8?B?MFQ2d3liVjNGRkdJZHA0d1dKN0ZsRkFhamVsakZpelZ6OWdkZno4YktCSS9E?=
 =?utf-8?B?R3hxaUlXMVZMbmtSWmJUUDFVUVVVOHRWeDN1bXRQcisxY0RQc0crT002Tm1J?=
 =?utf-8?B?ZEc1aEJNSlJZZWZHK3VoUElQOVZTa0Q0RGtBQVFuYWhBWXhqT0xQK2kwbE1B?=
 =?utf-8?B?c21ucHp2RysxV0JzbHZSVlV3L3B6TnpTdzFzVDh5RXo2MEJLSE5DU0ltYVVn?=
 =?utf-8?B?dXVnaVlidVBZc0tia2w2NHNWNmhpWlArdDZtK3UvNWdRSVh0LzVZMXlacUpE?=
 =?utf-8?B?dmUxL1FOOTA2Tk1oQnIwTENJREtmc2VvT3YrMk5mSjdMWWNZVWVOdFpZZFdG?=
 =?utf-8?B?bDdldkViQTBzWDJsYnRycUpqWFMxRWZoZ1JLQ1lxQ3VpYkF2V1Fxd3Rvclda?=
 =?utf-8?B?K1E5NW44QWd6RWg1UncyT05ndE5XUlZ0MFc0MTlJa3NHYzRSK2p1QzJjdnQ5?=
 =?utf-8?B?OFl5U0NlM05yVlJHTjRtai9JYWZrTVJhb2FROUxWTmczRFU4WExLcDgyM0xP?=
 =?utf-8?B?TGZRVVFmMnNZSWVXWWgxZ3lUUHE2eEJHRCttdFRKc1pTamNJWjREYzlPS1RF?=
 =?utf-8?B?dzU1cGIzdGMzTWd5c2xFR3hkakNjUzU3VjR1WlBWMU1jSXdDQ25YaUlDMjAx?=
 =?utf-8?B?Y3lhVVZndk9FRE1lT3IrVy9hWVB0QlVWemFSTW1xSU0wUjhSdE9LeXlxVGNz?=
 =?utf-8?B?eVgxejE2VVFuWFJzSU0wNWo3dGg0T0NUUGRXR0ltYkJNK2c4YUJoSU4yL2RB?=
 =?utf-8?B?UVN4dk11SThFTDc4ZmRNMW15YW1QalFEM016blo3NUZBNWJDM1V1WUlDZ3pY?=
 =?utf-8?B?clFVVmxrc3ZDN2ZuOG1pY1UvMTlSZ1dpZnlhSlk5djlUcXFtamdMRmhaTytu?=
 =?utf-8?B?QzFOYjA3QkZDUUNZMTFDbDFWUWZvU3oxTkJiTlVqNjFpT0hEVm0xZGhMTExW?=
 =?utf-8?B?T2VYV2dwVmppWERSK3gxbVhRVGRVVGFrajJweHJ1Q3VqN0NISjNQQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5e2b35-dba9-4655-1853-08df332318df
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:36:34.4867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGALX2o2uoE8QzGjv15Pvw8ade9CcrhSyuUVtZAIs1MDcYIopsa4oMI0n61/KRPme9Llh9wogNAZrB1bcqxAig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8347

This is the next version of Jason's DMA-buf mapping types series [1]. It keeps
the framework and the SGT conversions from the RFC but defers the final mapping
type selection until the first pin/map of the buffer.

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
patch 1 for more details.

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

Jason noted that some hardware, mlx5 for example, cannot change path once it
has mapped [7]. A pinned importer is covered, since its type is fixed at pin.
An unpinned importer has no way yet to narrow its own set after an invalidate.
This could be resolved if required by introducing a pin operation done under the
dma_resv lock for the mapping selection after attach.

Future work
-----------

This series stops at the SGT type so that the framework and the
attach/pin/map contract can be reviewed on their own. I already have
proof-of-concept conversions of both PCIe P2P (building on Thomas's work [8])
and XGMI to separate mapping types. If those would be helpful for reviewing
this series let me know and I will post them.

Alternatively this series could be split up with patches 1-8 & 25-26 adding the
general framework and the rest adding the conversions later.

Further work, per [2], is an iommufd importer type to replace the private
vfio/iommufd interface and allow other DMA-bufs to be imported into iommufd.

Testing
-------

- KUnit dma-buf-mapping suite (patches 25 and 26).
- Compile-tested with a config enabling all converted drivers.

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
[7] https://lore.kernel.org/all/20261022115239.GY3008132@nvidia.com/
[8] https://gitlab.freedesktop.org/thomash/xe-vibe/-/commit/7452df0fc858a7dc5ccac0e2037852cb7ab64d61

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Simona Vetter <simona.vetter@ffwll.ch>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: linux-rdma@vger.kernel.org
Cc: iommu@lists.linux.dev
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: zhipingz@meta.com
Cc: treding@nvidia.com
Cc: jhubbard@nvidia.com

Alistair Popple (4):
  dma-buf: Let the exporter select mapping type at pin/map
  dma-buf: Add match set queries for exporter placement decisions
  dma-buf: Add dma_buf_mapping_map() returning a type-tagged mapping
  dma-buf: Add kunit tests for mapping type selection

Jason Gunthorpe (22):
  dma-buf: Introduce DMA-buf mapping types
  dma-buf: Add the SGT DMA mapping type
  dma-buf: Add dma_buf_mapping_attach()
  dma-buf: Route SGT related actions through attach->map_type
  dma-buf: Allow single exporter drivers to avoid the match_mapping
    function
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
  treewide: Rename dma_buf_map_attachment(_unlocked) to dma_buf_sgt_
  treewide: Rename dma_buf_unmap_attachment(_unlocked) to dma_buf_sgt_*
  treewide: Rename dma_buf_attach() to dma_buf_sgt_attach()
  treewide: Rename dma_buf_dynamic_attach() to
    dma_buf_sgt_dynamic_attach()
  dma-buf: Add kunit tests for mapping type

 Documentation/gpu/todo.rst                    |   2 +-
 drivers/accel/amdxdna/amdxdna_cbuf.c          |   8 +-
 drivers/accel/amdxdna/amdxdna_gem.c           |  14 +-
 drivers/accel/amdxdna/amdxdna_ubuf.c          |   8 +-
 drivers/accel/habanalabs/common/memory.c      |  54 +-
 drivers/accel/ivpu/ivpu_gem.c                 |  10 +-
 drivers/accel/ivpu/ivpu_gem_userptr.c         |  11 +-
 drivers/accel/qaic/qaic_data.c                |   8 +-
 drivers/dma-buf/Makefile                      |   1 +
 drivers/dma-buf/dma-buf-mapping.c             | 259 ++++++-
 drivers/dma-buf/dma-buf.c                     | 317 ++++++---
 drivers/dma-buf/heaps/cma_heap.c              |  12 +-
 drivers/dma-buf/heaps/system_heap.c           |  13 +-
 drivers/dma-buf/st-dma-mapping.c              | 662 ++++++++++++++++++
 drivers/dma-buf/udmabuf.c                     |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c   | 141 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       |   6 +-
 drivers/gpu/drm/armada/armada_gem.c           |  33 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c        |   2 +-
 drivers/gpu/drm/drm_prime.c                   |  31 +-
 drivers/gpu/drm/i915/gem/i915_gem_dmabuf.c    |  18 +-
 drivers/gpu/drm/i915/gem/i915_gem_object.c    |   2 +-
 .../drm/i915/gem/selftests/i915_gem_dmabuf.c  |   8 +-
 .../gpu/drm/i915/gem/selftests/mock_dmabuf.c  |   8 +-
 drivers/gpu/drm/msm/msm_gem_prime.c           |   7 +-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c     |  11 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c       |  13 +-
 drivers/gpu/drm/panthor/panthor_gem.c         |  11 +-
 drivers/gpu/drm/tegra/gem.c                   |  33 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c        |  23 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_prime.c         |  32 +-
 drivers/gpu/drm/xe/xe_bo.c                    |  18 +-
 drivers/gpu/drm/xe/xe_dma_buf.c               |  64 +-
 drivers/iio/industrialio-buffer.c             |  15 +-
 drivers/infiniband/core/umem_dmabuf.c         |  15 +-
 .../infiniband/core/uverbs_std_types_dmabuf.c |  30 +-
 drivers/iommu/iommufd/pages.c                 |   5 +-
 drivers/iommu/iommufd/selftest.c              |  18 +-
 .../media/common/videobuf2/videobuf2-core.c   |   2 +-
 .../common/videobuf2/videobuf2-dma-contig.c   |  26 +-
 .../media/common/videobuf2/videobuf2-dma-sg.c |  21 +-
 .../common/videobuf2/videobuf2-vmalloc.c      |  13 +-
 .../platform/nvidia/tegra-vde/dmabuf-cache.c  |   9 +-
 drivers/misc/fastrpc.c                        |  21 +-
 drivers/tee/tee_heap.c                        |  13 +-
 drivers/usb/gadget/function/f_fs.c            |  11 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c            |  25 +-
 drivers/xen/gntdev-dmabuf.c                   |  29 +-
 include/linux/dma-buf-mapping.h               | 370 ++++++++++
 include/linux/dma-buf.h                       | 227 +++---
 include/trace/events/dma_buf.h                |   2 +-
 io_uring/zcrx.c                               |   9 +-
 net/core/devmem.c                             |  14 +-
 samples/vfio-mdev/mbochs.c                    |  10 +-
 sound/soc/fsl/fsl_asrc_m2m.c                  |  12 +-
 55 files changed, 2163 insertions(+), 582 deletions(-)
 create mode 100644 drivers/dma-buf/st-dma-mapping.c


base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.54.0

