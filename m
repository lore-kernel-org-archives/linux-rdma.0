Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154313;
	b=3IFFq3HXYcx5IThHiom4yetzK+NdZ7257cPwLrC5UzzqYwzL9M0rDzwh1C7+2r+7++WY
	 NX1oVbuQjJi5ZjeWnDVicqTes6B7QtTHeFpEBHJc/TnedgIX/9WcC9HSFQnmk8bZU1Uw6
	 iNlVsis7g+YNrL1XTOEf9GwOVJ+4qF1nq+SJ9pbkfuTegKhToC8iyWseq7KN0GhVm00Xn
	 F94mITCpSFnbdrpi9gosoQZgauBsPbvnqXx7igajpKPHMC4p4oUHszeoTHycbRLvnBZ+h
	 OP9ouvD23exI17xKG/0fvEuGWBGYkPwfQpG77IW4QFtWbQ4JE4DZWpfzrNhog6Ox6xw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154313;
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
	bh=WS16R8Cy0Z6lc3EGXLe8nJ8SatnphZOqos7p47YV1qM=;
	b=OvzsJNPCCuvt3B/YUBH/JYhQbvDQCqw3Qtd9UEcCQKLXzSmtxIQBcWpF5kOLsSqIHLdf
	 +MaOsUPh6snr7s+uSAZyyp9lUraVYTs3n2f7fIGTFNH7jLUZyBs0fCZLzRTszsqFPmURj
	 sSu9p4zASDMfiRvlxCV5hStZAgb2cwECcxOt4AnkcWlIe9OYhemLQrtdVPGer4aS/xfW8
	 mV5e7nGRZEY67f7HRgbQhYh7mTh3ZvRHfaPGTJIyTOud6t4kifZJAbJvny+lD+27OCx9W
	 2DBGPL5UsxTKwzvT9mBiFwbm2bjeOIcmfssvP6FmvwbDGtmyhVn6UtPAk62D44IyG9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NotGYaVA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.4
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013004.outbound.protection.outlook.com [40.93.201.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A89960A5BCB;
	Fri, 20 Nov 2026 05:58:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A89960A5BCB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NotGYaVA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vcxspjQas5rEb9Q91blR95fOhCIRrxdcC8PDfbRv2qubBkR4g/n5qmDiTV+8qXxMQIrskrLbqKy7SlT5kfhmFVMRbu6M7uUQX9lwFE5YYuLwGGBhEcQSB8AKjNidzzTZYs/USXzJBxV43etH+5E//pfXiCEfVw9P7yZJR/tHDKTcKuwdLGTHnTSaX6LMh5bDEnXKxHSkMvWnhMu+ZS8SKx+/lzQyDdL4WuKYMhkpgClPYWG0KOvX8w6yiA4hTpHF/d1aqdlbNTijTxBlroPkZb7nr7mvnKsYzPdMKXyiNif53j9fXukz0/j1r1DQav3SO8kuguCx6owKyvD6jBIGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WS16R8Cy0Z6lc3EGXLe8nJ8SatnphZOqos7p47YV1qM=;
 b=IXEYXy7hc5dxwOvxjhxYcG32P9yX7XeTNnVLMuCORzW/Z2Q2gzOkkTv8FhZ0NusqbmTwaND+diWC5lbzut/L+KeUFhf7Zf8h9xmMqljNzw/jN7RhCSW/QvCFQpgTWcW42MJkmcQtoRnSmhf4hYnfl3k8Z2Idli9jP4cBNxzE50bGvbgPgdNzRu66mS6asfurCGa5GYW8hxIQ/4IWv1WC/AzqFrPF1Z5ReNNLeYFecsFumZvlqXPuQ1xs0FVIjJSYLf4kM+Msx3tIY+Y44cpTiL/EWBuz3xErzvIBE+hTx/6OoNybOCTX7DhYlDIJY52B+ejj7TXPyuYcMGqCeBIsXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WS16R8Cy0Z6lc3EGXLe8nJ8SatnphZOqos7p47YV1qM=;
 b=NotGYaVA7tdmy4JIBFVedYLxD5kw0eFwWyLISQdD1GBk56tkfU6SzBsSmFtYGAS/I+w6czzq4CjOiS24O+6+QSvb0bWlL6trj/fK+rCg3Y0AfZQPx5pPUBAlblopU8fKxPGQi7YU/sN6WX3fW6BAtS12f5Hk8Ybt9xmukSZ+eKYd7MbXZDAqCqN2S21oaQv+D3Gd+krj7pzwaJCm1EqOJvcbxTc8AFuKksJ82KYQuURcRVGValZ4rmV3S3vBvUJoDz8dntP/J9iulo5ys8SCW4cshfgyH4ICXnVpJQqZHrgDpY/gmngSUc6VUvz76xh+HgWwTZaiNbK7MuREL93v0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by PH7PR12MB6717.namprd12.prod.outlook.com
 (2603:10b6:510:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:58:23 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:58:23 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:56:00 +1100
Subject: [PATCH v3 22/24] dma-buf: Let the exporter select mapping type at
 pin/map
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-22-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=20147;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=B81BE4ZsWBjZfFDMLGRGqJsAhruBPMXB9Qn8Ii91pwk=;
 b=zrqvpGr4b4WJZ8V6Uqd6OAq+8Go2EGDcswlciqsrBHnD5D5UplawQp0M+l2JioLX09wP5iSVz
 fElprtjQtygCsPGwABPAZ7z2oacYf7UA8LjPHMdgK61DExXvQzqM9YP
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P300CA0011.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fb::18) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|PH7PR12MB6717:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aab44c5-eb8c-49ef-fd62-08df46cb4918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|921020|261102123227099003|261021121427099003|10067099003|11063799006|261021123027099003|261102130727099003|5023799004|261026121527099003|56012099006|261026140227099003|261022075727099003|261028144727099003|261022105027099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	hOH2iEQH7I25b/+9zo6q/pqImKyw6k/82JtaESQ3O94Dhx8NIE+VyHnSY3pfQ5zPFCfnUm1n45d9bJVw3brv0M8SXFfRrB2mnb30I5JVp3QDAjtB8V79tB9imwsvaWphGg3hIvuOdNrVOKg8fLmRLe6J/lGB5l9uK0W5/OU/9A0Qn75t6Hx7jkLdgU065jBb9q2y0yarZkGw7PRPXAvppYmYNiuPcT45WMbQV8EqaGOVDaDI8nZP4A372x/sJ/PkjhvqL+fuACif3CE+dDRgQb7sYWJzABBatMFzOLm6UlGPrGFFn29a+ZGDy4pxzFwf3O5izJyZcqPIBdzgBhABMuvbvibnwpd22LOmPyw+SFxGStKhqXHKcokf2i9enEGlwRuXsZdojVRBT/fbZjn5A1dAmNN7BgoIBBHxoGa6/3fJk7YNlQ3ghdKixo7XixeG1RIlPYNPD7sOONaj2I9gbtJUnZcQWHkP2dRnHpsbjzpGZrBsEnEZ55+EhtEtwUnyzh46mNXFDB7BSNBlRJwIlBR7BZU1dPsitPZkR587aNHjzGdC2N9eFyNopCGG1XKmcAnzRtUrM1skjceysARTcZFcbTlpp67YX+jI2C0ZQCDK6ylxrMPwQ9SYXVb0cpV79MzYTKxbb3QjgjEFHWO0+AtVQ+5dhQAhLJYQWo6gSd+EYoDEiKO4DBvMSijg3XKzegZ2OxuaX5VohiOtqDamDg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(921020)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(261021123027099003)(261102130727099003)(5023799004)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261028144727099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eU9SZ3JUNDBuMzl1bjNERUcyOTZ1aHJPTExEdDZHc0JHWE8ybDd3UytGUlc0?=
 =?utf-8?B?aXVGMFZzbTFXSjBBOHlJUWw1bDFvMnlRZnE4cndIV1p0OWQyeDVnSm50d1VG?=
 =?utf-8?B?VXpSNk1vaHlCL0JKcEZTL1IwajFPakluZjM4NGZGeHpSSzAwVDlkY3dFRldn?=
 =?utf-8?B?RjNMcHUzeUc3QXlTQ0ExZm9JdGZpOUJNL2pNWDRMQko2Wk84VzZKdGprMWdj?=
 =?utf-8?B?K3NBbHYvK3UyK2dPNU9EdTlFUTJBb0Y2N0tyYlp3blI2WFRLVFAzUTk3alpY?=
 =?utf-8?B?Ym5RMXlVVS9DTXp4aW5BQTQrSFhVaUE5RjhLWlI4dklGZ2ZtS1drT2hodFY0?=
 =?utf-8?B?VDBLaHlJSDkrYzB4c3R4Y1l0UmYxUVRBd25oVnNhMC82OWhTcmZVdFdRZUlK?=
 =?utf-8?B?L0JLT05QWnZVU0hJdmxSOFNvM21SSlpHQitIdHY3QnIvWjlwUXd5bDhuckNr?=
 =?utf-8?B?Zng1Sk9CVHJGemQyREZxZEJZbzlwUW52SUh0cldEOFhCWUVtWktqenpRcnY0?=
 =?utf-8?B?ZlZlQmRPNUlpUzdlZnB6QnlFOVRvNGkzKzdOL043RHJDalJVL2QycmNySkpF?=
 =?utf-8?B?VHdqb2U0b01qQ3lOUExCVjlWM1o3bnl6OVoxVkZoTnAwNElXOEwvSnlwZjRp?=
 =?utf-8?B?RlBCbHQ2dDlsN2JKelZoUUhSRHhiZW4xZFlLQTIzUk16aVR2RklwMStYc1R5?=
 =?utf-8?B?Y0hBa3AvaGFmemFTYXVveUVIUER5WWxHQzFCT056ZVIzTTNUS2k1TFFBVGg4?=
 =?utf-8?B?R1FzeXdxQmQxRGNmOWd5bGlUdVg1dDJsQVczMUQwZk4rNVZudHkrWUhRYi9h?=
 =?utf-8?B?dXl0dGZUY0JUWDV0ZUJjTjBLVTBzeWxwbXMvWUltY2VwcnFyYTArRkxWVkhl?=
 =?utf-8?B?TkNvMmhXdkFqMzV5czNic1dIOENCcEN0K1RzUjFtaUNHc242T0RWczBZeXBq?=
 =?utf-8?B?ekhSWlVaajBKZW5sSDVNVHhmSlUybVByR3g0RWlpaEF5eExFS0N2SnpiT20y?=
 =?utf-8?B?b05ZMUVhaUdRdXpDT285cWlGdnlqdDlPdEx4bjIydFc1cXgvUzIrTlVYVjJi?=
 =?utf-8?B?Z3cvWnZNOXRxUmMvNDVrajJXRFQzaHVQZWNjUXNQNnBueEErd2FGMmMrV3hW?=
 =?utf-8?B?d0cweEk4c3FlQ2JiMzZpR2JqVFdzTXI1UVVvdlFHd3hkZzNrTVcrRkgrb3F0?=
 =?utf-8?B?YklBOEJRWi9TM1owSHJVRFVNWFpKQlBHcUQrQUNrcDlIVEordlhrcnQ1QVpI?=
 =?utf-8?B?VlZrWkQzcHRuTzd0NUZNL0FGRXBzS2JMQWlvTE5obGpEazM5NVJEWDFkMEQz?=
 =?utf-8?B?WFZDbkh6UndrZEZlUGpIVUtZRkVoemlTQ0RqOEZQSE1CdWMrS3d3R2syTldp?=
 =?utf-8?B?WkNIcGdtbmYwN2VxUFdPRll4blQraXR2SjQwQ0kyb29acjlESzI2S2g2T0pv?=
 =?utf-8?B?a0U5eHZTRHdtWTJmZU96VjlFcmRHSVpjNkJHdEc2L05DUGpMN1NhbjBEbkpI?=
 =?utf-8?B?YkQ3QkNCc1Q3dHkvTzI1NTR2WG4rWTJBYlprWmw2UklybzlVVnhMdWJHWEpz?=
 =?utf-8?B?ZmV3ZU80ckd5Q2YzZ3lTWG1NQWNwUGdESE41ckd4VFNKTnRXdUFwN3g2U0s5?=
 =?utf-8?B?QzFjT2tobWJGcVFNRXZoQkd2Uy8zcDIvOVVkR1pjb05MQ0dKQWMzVUpUb3o5?=
 =?utf-8?B?N09ORmFyUjlKVjA4VVU3cXNKVG1WVVlDZGJvTjhSbEtYaTZ0TU1NSTl2M3Fw?=
 =?utf-8?B?S1h5ZUoxMkhVcmxOME9kZHRyTGpDbVFSSHpKVkE1SnZONWlSY1gwbVl5QjQ0?=
 =?utf-8?B?VmRvRlI3QXJSWWtUM0xPZ1Rrc05kVVl5eFE2VVJXSkJ5SWNEcWlsS3diejM1?=
 =?utf-8?B?WkR6cUh4OHpvc3NKYk1Ub2l2azZDbkk5Skt0ZXpobG9xNzF4OXo5OFc1UGYy?=
 =?utf-8?B?cHdBMVZCK3N1ME5Rd2w1d0tJV0FVRHRqWDkybVd4M2w4VDBhOVZpVU85d1NN?=
 =?utf-8?B?SUluVlROMTF4SWNtZjFyTUo1RXQzbjVMQVB2RUxnSXR6MGJERVpTMER1bE1V?=
 =?utf-8?B?S0lNSVAxMFYvalM1Y0kvN3ZUaEFyci9Ba1FYdGJhY0k4Y2ZpeWtYQ0JUdzlJ?=
 =?utf-8?B?RXErMkpPd1JKbEw4MVg2TEUvMDdDRVRXRnFMLzE0bWFLNVV5ZGl0emgwZTBC?=
 =?utf-8?B?UlJhQno0WjY3dStFTmxHbmJZeVR4a05BV015QVFnTE12ZnNuMUx3Q01mQ0ww?=
 =?utf-8?B?a0pCeUd1Zy9FNTRhbEdTMWdpVno4VGJmUHMyWUl0WjFoM3UveFpLSWc4NUl3?=
 =?utf-8?B?aGtZWnpXaFNWNzk3SGN0VXBxblN4ODBXMnRQYUxQMitWK0JnN2lNdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aab44c5-eb8c-49ef-fd62-08df46cb4918
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:58:22.9694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFFbewHf55ItT5LKrlkoV5IsslaW8RGAR8aJZY8r8BOHI1XHaDZ8VtJ4LTM98IJlw+By6RWm/NOkLmKFdyZy/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

Currently an attachment is always mapped with the first entry of the
match set negotiated at attach. The match set only records which types
both sides could use. Which of them the exporter can actually use time
depends on where the buffer is and on the other attachments at the time
an importer first pins or maps.

However currently an exporter offering more than one mapping type has
no way to select the mapping type to use. To allow that add an optional
dma_buf_ops.select_mapping() callback.

dma_buf_pin() and the map functions call it under the dma_resv lock
before the exporter's own pin or map callback. The exporter returns the
index of the entry to use given the current placement and attachments,
or -EBUSY if the attachment cannot be used without disturbing a mapping
that cannot be invalidated.

To avoid ping-ponging of buffers and other sub-optimal behaviour the
selection is not allowed to change without existing attachments being
explicitly invalidated by the exporter.

The core enforces this by recording the selection on first
map/pin and not calling it again across subsequent unmap/map until
dma_buf_invalidate_mappings() has been called on the attachment. This
means an importer remapping cannot bounce the buffer between placements
as the type cannot change unless the exporter invalidates first. An
attachment that is never invalidated keeps its type for life.

Mappings are unmapped via the returned mapping type to ensure the
correct unmap function is called. This is because whilst mappings should
no longer be used after an invalidate the mapping itself can outlive the
invalidate. Thus the attachment selection may have changed between map
and unmap.

Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

Changes for v3:

 - Return a type specific struct and unmap through it to ensure the
   correct unmap callbacks are called.
---
 drivers/dma-buf/dma-buf-mapping-internal.h |  29 +++++
 drivers/dma-buf/dma-buf-mapping.c          |  68 ++++++++++-
 drivers/dma-buf/dma-buf.c                  | 179 +++++++++++++++++++----------
 include/linux/dma-buf-mapping.h            |   9 +-
 include/linux/dma-buf.h                    |  35 ++++++
 5 files changed, 256 insertions(+), 64 deletions(-)

diff --git a/drivers/dma-buf/dma-buf-mapping-internal.h b/drivers/dma-buf/dma-buf-mapping-internal.h
new file mode 100644
index 000000000000..e1337db2b205
--- /dev/null
+++ b/drivers/dma-buf/dma-buf-mapping-internal.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * DMA-buf mapping type internals shared by dma-buf.c and dma-buf-mapping.c.
+ * Nothing in here is for exporters or importers.
+ */
+#ifndef __DMA_BUF_MAPPING_INTERNAL_H__
+#define __DMA_BUF_MAPPING_INTERNAL_H__
+
+#include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
+
+/*
+ * Internal: Selection is made by exporters through &dma_buf_ops.select_mapping
+ * in dma_buf_pin() or map paths. Importers never call this.
+ */
+int dma_buf_mapping_select(struct dma_buf_attachment *attach);
+void dma_buf_mapping_unselect(struct dma_buf_attachment *attach,
+			      bool was_selected);
+
+/*
+ * Internal: Records the selection was successful after the pin or map that
+ * followed dma_buf_mapping_select() succeeds.
+ */
+static inline void dma_buf_mapping_commit(struct dma_buf_attachment *attach)
+{
+	attach->selected = true;
+}
+
+#endif /* __DMA_BUF_MAPPING_INTERNAL_H__ */
diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index cf3d25aa3884..248ac81f616b 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -10,6 +10,8 @@
 #include <linux/overflow.h>
 #include <linux/align.h>
 
+#include "dma-buf-mapping-internal.h"
+
 #define MAX_SG_ENT_SZ ALIGN_DOWN(UINT_MAX, PAGE_SIZE)
 
 static struct scatterlist *fill_sg_entry(struct scatterlist *sgl, size_t length,
@@ -276,7 +278,8 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_free_sgt, "DMA_BUF");
  * importer entry of the same type that the type's match() callback accepts.
  * Every such pair is recorded in @args->attach->matches, so the match set
  * preserves the exporter's priority. The first entry is the default returned
- * by dma_buf_attach_map_type().
+ * by dma_buf_attach_map_type() until &dma_buf_ops.select_mapping chooses
+ * otherwise at pin or map time.
  *
  * Because the exporter list is walked in order, the exporter controls the
  * priority of mapping types.
@@ -329,6 +332,69 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_match_mapping, "DMA_BUF");
 
+/**
+ * dma_buf_mapping_select - Let the exporter choose the type to map with
+ * @attach: Attachment about to be pinned or mapped
+ *
+ * Called with the dma_resv lock held by dma_buf_pin() and the map functions.
+ * The first call after attach, and after each dma_buf_invalidate_mappings(),
+ * calls &dma_buf_ops.select_mapping to pick the mapping type. Exporters without
+ * the callback get the first entry. Subsequent calls return the previous
+ * choice unchanged unless the mapping has been invalidated. This is to ensure
+ * the mapping type cannot change between unmap and remap.
+ *
+ * The choice only takes effect once the caller's pin or map has succeeded.
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
 static void
 dma_buf_sgt_finish_match(struct dma_buf_match_args *args,
 			 const struct dma_buf_mapping_match *exp,
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 20e397683826..8124e7bcd5c2 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -37,6 +37,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/dma_buf.h>
 
+#include "dma-buf-mapping-internal.h"
+
 /*
  * dmabuf->name must be accessed with holding dmabuf->name_lock.
  * we need to take the lock around the tracepoint call itself where
@@ -1176,16 +1178,27 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_detach, "DMA_BUF");
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
+		if (ret) {
+			dma_buf_mapping_unselect(attach, selected);
+			return ret;
+		}
+	}
 
-	return ret;
+	dma_buf_mapping_commit(attach);
+	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_pin, "DMA_BUF");
 
@@ -1210,46 +1223,21 @@ void dma_buf_unpin(struct dma_buf_attachment *attach)
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
+static struct dma_buf_sgt_mapping *
+__dma_buf_map_sgt(struct dma_buf_attachment *attach,
+		  enum dma_data_direction direction)
 {
-	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops;
+	const struct dma_buf_mapping_match *match =
+		dma_buf_attach_map_type(attach);
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops =
+		dma_buf_get_sgt_ops(attach);
 	struct dma_buf_sgt_mapping *mapping;
-	struct sg_table *sg_table;
 	signed long ret;
 
-	might_sleep();
-
-	if (WARN_ON(!attach || !attach->dmabuf))
-		return ERR_PTR(-EINVAL);
-
-	sgt_exp_ops = dma_buf_get_sgt_ops(attach);
 	if (WARN_ON(!sgt_exp_ops))
 		return ERR_PTR(-EINVAL);
 
-	dma_resv_assert_held(attach->dmabuf->resv);
-
 	if (dma_buf_pin_on_map(attach)) {
 		ret = attach->dmabuf->ops->pin(attach);
 		/*
@@ -1264,11 +1252,12 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 	mapping = sgt_exp_ops->map_dma_buf(attach, direction);
 	if (!mapping)
 		mapping = ERR_PTR(-ENOMEM);
-	if (IS_ERR(mapping)) {
-		sg_table = ERR_CAST(mapping);
+	if (IS_ERR(mapping))
 		goto error_unpin;
-	}
-	mapping->base.match = dma_buf_attach_map_type(attach);
+
+	/* A mapping handed out again must have been made under the same entry */
+	WARN_ON_ONCE(mapping->base.match && mapping->base.match != match);
+	mapping->base.match = match;
 
 	/*
 	 * Importers with static attachments don't wait for fences.
@@ -1280,11 +1269,6 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 		if (ret < 0)
 			goto error_unmap;
 	}
-	sg_table = dma_buf_wrap_sg_table(mapping);
-	if (IS_ERR(sg_table)) {
-		ret = PTR_ERR(sg_table);
-		goto error_unmap;
-	}
 
 	if (IS_ENABLED(CONFIG_DMA_API_DEBUG)) {
 		struct scatterlist *sg;
@@ -1302,16 +1286,93 @@ struct sg_table *dma_buf_map_sgt(struct dma_buf_attachment *attach,
 			}
 		}
 	}
-	return sg_table;
+	return mapping;
 
 error_unmap:
 	sgt_exp_ops->unmap_dma_buf(attach, mapping, direction);
-	sg_table = ERR_PTR(ret);
+	mapping = ERR_PTR(ret);
 
 error_unpin:
 	if (dma_buf_pin_on_map(attach))
 		attach->dmabuf->ops->unpin(attach);
 
+	return mapping;
+}
+
+/* Tears @mapping down through the entry it was made with */
+static void __dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
+				struct dma_buf_sgt_mapping *mapping,
+				enum dma_data_direction direction)
+{
+	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops;
+
+	if (WARN_ON(dma_buf_mapping_type_of(&mapping->base) !=
+		    &dma_buf_mapping_sgt_type))
+		return;
+	sgt_exp_ops = container_of(mapping->base.match->exp_ops,
+				   struct dma_buf_mapping_sgt_exp_ops, ops);
+
+	sgt_exp_ops->unmap_dma_buf(attach, mapping, direction);
+
+	if (dma_buf_pin_on_map(attach))
+		attach->dmabuf->ops->unpin(attach);
+}
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
+	struct dma_buf_sgt_mapping *mapping;
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
+	mapping = __dma_buf_map_sgt(attach, direction);
+	if (IS_ERR(mapping)) {
+		sg_table = ERR_CAST(mapping);
+	} else {
+		sg_table = dma_buf_wrap_sg_table(mapping);
+		if (IS_ERR(sg_table))
+			__dma_buf_unmap_sgt(attach, mapping, direction);
+	}
+
+	if (IS_ERR(sg_table))
+		dma_buf_mapping_unselect(attach, selected);
+	else
+		dma_buf_mapping_commit(attach);
+
 	return sg_table;
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_map_sgt, "DMA_BUF");
@@ -1358,7 +1419,6 @@ void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 				struct sg_table *sg_table,
 				enum dma_data_direction direction)
 {
-	const struct dma_buf_mapping_sgt_exp_ops *sgt_exp_ops;
 	struct dma_buf_sgt_mapping *mapping;
 
 	might_sleep();
@@ -1369,15 +1429,8 @@ void dma_buf_unmap_sgt(struct dma_buf_attachment *attach,
 	dma_resv_assert_held(attach->dmabuf->resv);
 
 	mapping = dma_buf_unwrap_sg_table(sg_table);
-	if (WARN_ON(dma_buf_mapping_type_of(&mapping->base) !=
-		    &dma_buf_mapping_sgt_type))
-		return;
-	sgt_exp_ops = container_of(mapping->base.match->exp_ops,
-				   struct dma_buf_mapping_sgt_exp_ops, ops);
-	sgt_exp_ops->unmap_dma_buf(attach, mapping, direction);
 
-	if (dma_buf_pin_on_map(attach))
-		attach->dmabuf->ops->unpin(attach);
+	__dma_buf_unmap_sgt(attach, mapping, direction);
 }
 EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_sgt, "DMA_BUF");
 
@@ -1460,6 +1513,10 @@ EXPORT_SYMBOL_NS_GPL(dma_buf_attach_revocable, "DMA_BUF");
  *
  * Importers are free to request a new mapping in parallel as this function
  * returns.
+ *
+ * This also allows an attachment's mapping type to change as the core keeps
+ * the type chosen by &dma_buf_ops.select_mapping until the attachment has been
+ * invalidated here to avoid buffer ping-pong.
  */
 void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 {
@@ -1467,10 +1524,14 @@ void dma_buf_invalidate_mappings(struct dma_buf *dmabuf)
 
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
index 850a76ffba14..0a1c2934a932 100644
--- a/include/linux/dma-buf-mapping.h
+++ b/include/linux/dma-buf-mapping.h
@@ -86,7 +86,9 @@ struct dma_buf_mapping_type {
 
 /**
  * struct dma_buf_mapping - header of a mapping made through an attachment
- * @match: The match set entry the mapping was made with
+ * @match: The entry of &dma_buf_attachment.matches the mapping was made with.
+ *         The mapping is torn down through it, whatever the attachment has
+ *         selected by then.
  *
  * A mapping is an object allocated by whoever produces it, the exporter for
  * the SGT type, embedding this header. The core fills the header in once the
@@ -125,13 +127,12 @@ int dma_buf_match_mapping(struct dma_buf_match_args *args,
  * dma_buf_attach_map_type - The match this attachment is mapped with
  * @attach: the attachment
  *
- * Returns: the entry of @attach->matches in force for the attachment: the
- * exporter's default, which is the first entry.
+ * Returns: the entry of @attach->matches the attachment is mapped with.
  */
 static inline const struct dma_buf_mapping_match *
 dma_buf_attach_map_type(const struct dma_buf_attachment *attach)
 {
-	return &attach->matches[0];
+	return &attach->matches[attach->selected_idx];
 }
 
 /*
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index b1d1a239fa27..c60d9f96ec36 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -254,6 +254,30 @@ struct dma_buf_ops {
 	 */
 	int (*match_mapping)(struct dma_buf_match_args *args);
 
+	/**
+	 * @select_mapping:
+	 *
+	 * Called before the type's map callback with the dma_resv lock held
+	 * from dma_buf_pin() or the map functions to choose which entry of
+	 * &dma_buf_attachment.matches maps this attachment. The exporter decides the
+	 * buffer's final placement here taking all live mappings and pinned attachments
+	 * into account.
+	 *
+	 * The core records the choice and does not ask again until the exporter
+	 * has delivered &dma_buf_attach_ops.invalidate_mappings to this
+	 * attachment. The exporter must therefore keep the recorded type
+	 * servable - moving the buffer somewhere the selected type cannot be
+	 * served from requires invalidating first. Attachments that cannot
+	 * be invalidated keep their first choice for life.
+	 *
+	 * Optional. Without it the first entry of the match set is used.
+	 *
+	 * Returns: the index into &dma_buf_attachment.matches to use, or a
+	 * negative errno. -EBUSY means the attachment cannot be served without
+	 * disturbing a mapping that cannot be invalidated.
+	 */
+	int (*select_mapping)(struct dma_buf_attachment *attach);
+
 	/**
 	 * @single_exporter_match:
 	 *
@@ -482,6 +506,15 @@ struct dma_buf_attach_ops {
  *           entry is the exporter's default; dma_buf_attach_map_type()
  *           returns the entry the attachment is mapped with.
  * @nr_matches: Number of valid entries in @matches.
+ * @selected_idx: Index into @matches of the entry the attachment is mapped
+ *                with, chosen by &dma_buf_ops.select_mapping at the first pin
+ *                or map and kept, enforced by the core, until
+ *                &dma_buf_attach_ops.invalidate_mappings is delivered to this
+ *                attachment. Zero, the exporter's default, before the first
+ *                selection.
+ * @selected: True while @selected_idx is in force, i.e. the next pin or map
+ *            must not select again; cleared by dma_buf_invalidate_mappings(),
+ *            or when the pin or map that made the selection fails.
  *
  * This structure holds the attachment information between the dma_buf buffer
  * and its user device(s). The list contains one attachment struct per device
@@ -501,6 +534,8 @@ struct dma_buf_attachment {
 	void *priv;
 	struct dma_buf_mapping_match matches[DMA_BUF_MAX_MATCHES];
 	unsigned int nr_matches;
+	unsigned int selected_idx;
+	bool selected;
 };
 
 /**

-- 
2.54.0

