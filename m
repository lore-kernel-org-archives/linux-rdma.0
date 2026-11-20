Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154329;
	b=q/GfJJjxFW7/5TYDZuMW2DB8JtOvTat39Fo4pQY5LxcIj8ulFMtOjNl2n0Z9m3RMdLbI
	 gMfIS764vW1GgdWOjAVr1aqJI/cCNgfEdirSGiupkp4VXVSt5v+njvlPoD76jRjbmFEJh
	 11qj6sw6Lwv/yNsZ+PM2h7iuAb4vUBoU6qhDzYz7uAh4VUTawPlOQ0W9eco5ohDCIY/GR
	 YJBeoTW4eW0mkaKD7y8wJUr68SZQ74HihCRBCFQC4exy4xpErTmAtIv1/6axuzWgCl1Da
	 5wj5Si6fGE/WUZ2RGBHy/djSTd4Kc2SErK3v73NOm1NZv5fikZnuyB4uX9GXjZ4Nh3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154329;
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
	bh=P8MEGgwFkZ/5xrrjKNhLYkfAKtMAgXeKCG4RXs5cVs0=;
	b=CX77dCdyN03y/0/Ijvh7/s+cAehsL4Xt445wpHsQ/7rmzus/xp4qR0ZA0u7oejeyPN2D
	 N0IBOwcHgGhsxrkO7yFnNhhniX3VfudJGPmsipL1PAZHcxkzwj4Kbj0p+423CO8aq12YR
	 UhcXCnVrj08501TR5a1C0OcdrxYX+k00WHiXee74TJeTPDEjc4bEsiwBJ+BQBxL0W6O0E
	 QPb8eFJk8HtjVwPaOYZ2bydJvewFqYQv9MlGqGPTfEpH1cIbPOwJLDFiPBHBoxt9t62tr
	 /IE4+RlVklJ3BRsFdvX2lGPIFbIsQ95HYijHV6DcGnhzXhLHUqVttKAp2b+AUFvZOWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kfHk02Nq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.63
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011063.outbound.protection.outlook.com [52.101.57.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8958606A334;
	Fri, 20 Nov 2026 05:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8958606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kfHk02Nq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V7vcTO99BRRqFoOlm9Z0c38jSzY4S6smU4TIAG0DUZeBq5v7NOWojdnXPGuHTNgleNbEM9lXRdsB8akjSfMHYkWUZVnUgppCISrvnnGK/Ui7g7cfq8xEC93EyrtdHiCe8/5pZJi08bEtmG3yq7KZQJhPcKyta1JcZEP0k4ZloEieDI29ptZNiX0RYyVO+Dy1UXFeUwse3nWFTYiDkHiUus5QJ8ZWyWOhA3e9lfWayp74/2WIK16VLRT1Y0sVPye2J65mcWXF//2lGwZjClXVGiRchAbpellcjSHXHr86wJDQ67jE6rI7UToV/axegLhOVTrpZO1MTDKneiBbhRqy8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P8MEGgwFkZ/5xrrjKNhLYkfAKtMAgXeKCG4RXs5cVs0=;
 b=UMKMpy/gcC77N0sN0EhlYsaGAEuTYc51SM88pzzthKACibAAHWcrVguZ5/PPps1eO6vGi89YlOkDujiE7M3TUNlJ+smV0kS+TX0zetkwvFhqWW5M0X/0Mk9rNxxW5I1mZXqTjKXGFfJCDqsMMFZN2f42Fj75pKINDdFaf9R5KcOgl4GIH/mik1EikYYemZGKKwCOJDvNIYi/2Wle5iCA358pbe31kLDWxs/HcvASeZWTE03Bm26K1iKEk1ze5vAkTs+X9O6TZzBQaTuXGKzVKFpM/DF1QcVt4kk1d5+VPDwzFaGCcQegVGo51Uwg+3V+dPew4eJqP/oy9b55ztVBpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P8MEGgwFkZ/5xrrjKNhLYkfAKtMAgXeKCG4RXs5cVs0=;
 b=kfHk02NqR5H6ffXwDMIL5d2uyUf6dSmtZMIE/fIVwYQNRIoTq1iW/xTG5wCsTkWUZQLQgk19AEiJwSUAilAzTjj5jjak8HG9WgKRmDWe6H6o4Gwf8OLt4SG0ctiIrUyzhX/81IiptEoykJtaZ973sP6ETMOPXAAmkmSeoCn7v2f+NVEPnvj1ZgpHQtjEEposDy8Q7SKcfT1g7VnvG1oSUDgUhPEbCdC+pePuQfx9uVuQRyBOCzVA91b32Vhe52IP9xXVSZKUwHe/MVidXn95TR9EZVsvJ+2Usn9aTd8S+in2hJwzDrwTzUpqWb5wCPMPGHIoHi2qzKlDcf/s7cqrVw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by PH7PR12MB6717.namprd12.prod.outlook.com
 (2603:10b6:510:1b0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:58:33 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:58:33 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:56:02 +1100
Subject: [PATCH v3 24/24] dma-buf: Add kunit tests for mapping type
 selection
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-dma_mapping_type_v4-v3-24-c0183a409bdf@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=27463;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=X6MOMHA5yR9Or4dwu/StNGYyBebhWLwpFsX7toq7H+k=;
 b=NZzBPR6jeC+JXwYi+CzoSuPQbXGoiZvJ3UUHweQk5XYNPf3zQfjXJ1cpE6WlHdzULmf+TOn24
 fbCQJaqUa5FDbWkmnRW1sW3a1opm9v61xfy+hoHihaJJ9vX+dkMtOK8
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY6PR01CA0162.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::20) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 67018038-5a86-4724-2880-08df46cb4f25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|921020|261102123227099003|261021121427099003|10067099003|11063799006|261102130727099003|5023799004|261026121527099003|56012099006|261026140227099003|261022075727099003|261028144727099003|261022105027099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MgJnBNowX52BknRoOM3RZlr7ObBp+TWoaoXxj1Q64J+YArhlHdXdwoaCpNVwl5eaxLRxYW65rTpyvPJ/PM470c4I2O7EtS90GDAGqnrB63xfXRm8BxJz/a4n4lD/5a2ve/I15jIKBBkwuh20FSkjPbIBCWvJdvcAaQ3rFFe/qPinOTFrAdKhczcaHs/jvFSy54uRClNjtP3TyIs9P6IMuuRvexF19fGHixYygjwhvj9hr6EYjmiD4yGGM8Q8fKc/RvH8fkw7ejqSeSrRpJTRRWCLCYnXYJAV1qQBdGutsuFTeAotgMLdg65FpLmXyPYYs9JNT9BqXguQ10gfiG+n2QSnaAkgj9lfeaI7v5HXkK7zpj/oqCbDz05ymCRUepJVDPSTmgNW/xLnDL3ShxrUCHbzBp4jztxu5eEcMcCL0hGEHlJxhvTYdKNmrorDZOEXg3HHUXEbxoJeMSlUNS1/QjL3xucpXF5U14SOsD+qU3Bjx8btgK78dw+FiadoAfWWZWXftXRhch/ewshgPSoznVUjuaMEqayoudqEUm6Ns+yTtr1nGMUxHpheH10x/7rPLECv6AaAZNDIoXTxgPSO5/A71tGWMIktWrV93kI/hLuoLICymnI7/R6B5XwOUzrpxYcuTr9W4Jn5IsHKz4lWrKHlygMM5h0smeTOflvLnGp6JnGVraBCs06xjgwWobkvS6okIHgSt4AgHST5HzJUeg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(921020)(261102123227099003)(261021121427099003)(10067099003)(11063799006)(261102130727099003)(5023799004)(261026121527099003)(56012099006)(261026140227099003)(261022075727099003)(261028144727099003)(261022105027099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHV0b3B3VENKM2oweisrR2ZRU3NvaHp1MGJtOGZBTDAyemszUEN6bm0rRU5j?=
 =?utf-8?B?YlNpeWgwZGx5QlU3Yllqc1FlSVMrMWwzUWsxc240VnA1dUIxaXZGV3p5anRa?=
 =?utf-8?B?TW1xWlptUjRadXJxM01hMUQxd1prSkN3VzBUbklqZ2J4dmlkVjJNUEJrUkQz?=
 =?utf-8?B?dWRMck80WWF4aG1tZkpGZEpIUjQ2cXptWGpqQU5ZYitwRnlKTFNHblRlQ25z?=
 =?utf-8?B?Q3R2TjBZR0poTWViSjUzM0o0QmRFSFNSMnlqOTc4dW9TVmRPdFlueEN1SnVC?=
 =?utf-8?B?UE5NNGNKQ1NhNWpQMzQzWldBcFRmQzUyeW0zdUIwSXdiVzRIQU5PYi85bjYz?=
 =?utf-8?B?UnlzTlBJTTJyWU96U1dsTWRERE5sOGtCNHZ0YllleEFJZDU1Mlo4Ukdnek9m?=
 =?utf-8?B?Vm5SU3I5NHdIRFowNStiMzI2cjJlUWhscmJoZDNEdFRWLzQrSTFzTkxCQUF4?=
 =?utf-8?B?ZUY1UHVhWmlSM0V0YzVoY1h3aVBrK3VZa0JYY2xMZ04vNWdkT2g0N1lCVjNy?=
 =?utf-8?B?TzlEUWw1cndtVkhMQWx6YXNRamd5Z0ZVdHJRUEY4S1Z5NS84Q2tCR0dBTS9i?=
 =?utf-8?B?Rk5JSmhiTVl1TWlzZWQxZW91RjBzM2o4QzljR3pNOXg2dEJ5bVFmZUhtSVhl?=
 =?utf-8?B?RVoxclZxNTFDenJGRXdXOUN3em9KakJLWGZGb0QwMnRiOTY3eGFaVzRCaUw3?=
 =?utf-8?B?bnFSYVhvR0dIU3FOV2FxWUhoc3hoUkIrYmhuRnVDZHZWSnhvQVoxZXhlYXV6?=
 =?utf-8?B?MnlwbUx2TmZ2aWJRUC82WmhwODhha2NTUzB3aC9zdHZ1WHZqSGZ4cDJtaGJU?=
 =?utf-8?B?VHFid3ZXbjZXZENCc0tZdENnOVBNS2FkLzVIcHBNT2E2eGR3MXUvVjRJdFdS?=
 =?utf-8?B?d2JoRGlsVUo1WkNIWXgxVWR4eS9hQlZQc2dVZWIyRmo0ZXFQY0FYRGV3T1pk?=
 =?utf-8?B?bjdlbnpDWm40RjJxQ20yNmV2ZzhKdTEzN21sdytMbXVFbG1RbGwzaWxCQk5B?=
 =?utf-8?B?em8vZ2VoYTlINUZGZ2MrRGxaOVZWb0E4bzV2YzlKVTM4ald4VXg5eWp3WEp3?=
 =?utf-8?B?bDBpRExCYUxXV2Z4bzF3ZkNsbVZ6ajJLa3FaSjVQYVd3bGQwb0p6cjNmT1pB?=
 =?utf-8?B?TjJNTER0VmErN3I4NXBXSzJlQXJpYktJMzg2cUJWa2RzTmRtMDg5b0pHWWg3?=
 =?utf-8?B?MG90aXZxdlN3OVM3Tm9tYmdsNmE3Skt5amRsT01vSm5hN1B5VTd1b1pjOXdJ?=
 =?utf-8?B?ZW4vblBBdjg3KytjMTFZK1RBcjQ5RE1VWE1rbHZSNlZ5WGhMcjhIQml0RWZY?=
 =?utf-8?B?Z25DaEhuaDA4VFNSVU4xVlpqaXVMUlFpblZTb1Y2YVFnVHNBemdVc254L0Vy?=
 =?utf-8?B?cjhXcVFQMmg5WWErMTBMeVcybno0QVl0WGJnc1BPeXFXdUI1NFpHYU1zM0Np?=
 =?utf-8?B?RGp0Rlc3OEJ2OHNNcHMzbTlVQ1pKL0RFcERMZXFZWDUwUDZkTzNCbW5rSHR4?=
 =?utf-8?B?REhuNW1Mb01PTEdtS21sOXROMmZYeFllNHBNSkMyeExxdm96TjNxMHRKWU52?=
 =?utf-8?B?cWs4RjdlMm9xZmc3RHBOeFJzTDRINzJPZzN1SnRtUHVtMzA5NTl5bzcwYmww?=
 =?utf-8?B?WU1Yc2l3V05ZNldNejIwM1F1Z3kxbVJCT01uY2xwUmNiM0g3ZTdLSXdkQXN0?=
 =?utf-8?B?Y1VPVVFXZHlVVXJoemFRb3lKZGtPZXhMOEV4QkViSmZIVkszOTlMQmo0d2xF?=
 =?utf-8?B?cmVPY3lQVitEWmRDQ1dZeXRBR3NmclNSNUJQVEVoT05qbjZNOEpyU3BwSjBa?=
 =?utf-8?B?ZG40bW9KaFllazEwOFN3emdLdkhlbkN5TGFQcEZBbCtZd2NWcHJmY0FoamxF?=
 =?utf-8?B?ZTR4MHlaOE91ZTJUOUEraytpNHRGbkQ5OGJzU21sTlNmZmt1c054NXV1TEg2?=
 =?utf-8?B?STY5bmt0aEsyaGhLTE5QOWhLRnVKd3lrVGk3VTBWZTV3VlQ4OVBFUGsyR0RS?=
 =?utf-8?B?dEVxU1lRZHA5QzZuVlozVG5XM2RvZ2pVY1BQZDBxSHRKYytvU3QrV0F2TnBU?=
 =?utf-8?B?ZzloMWhwZlU1cSs1U2dPVGlzR0FPWDdKN0swM1IwWDB0QmFraXZpYWEycFBH?=
 =?utf-8?B?cjhCaGozNEY3dUZVVm55MDd3VCtRd0REdmdPT29WYm9IMnRpSGpUNnhOOE40?=
 =?utf-8?B?ZUJrMWRObFdkRXFOQURyWDQ5UWN0djhFWG9XbEFXNDBwMndxMS9MSDd4Z0Rz?=
 =?utf-8?B?UFZRanVyQ2pyNTJCcXU1VW1aanRvbHgxaTNsWGQwUTl1NTRWU1dWWTd5bGo4?=
 =?utf-8?B?MmpuTDVKNmVWU1NSZDM3VE1IQjV4UUprd3RkWk8rT1RIbzJrZFN1UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67018038-5a86-4724-2880-08df46cb4f25
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:58:33.2551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnzQdcN9aq3WwRiyfD0IIIutVK/XSda5MhsFMjJlqpGlXkY3z+8w2ZYj7OH8ncrZj4KBFvj/qgmdjLMcY1Rmpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6717

Add an offer list and a select_mapping() callback to the mock exporter
along with map/unmap for the two mock types.

Adds tests for the exporter/importer contract.

 - test_match_set_is_final: a later importer attaching does not change
   an existing attachment's match set or default. Later attachments
   influence what the exporter selects at pin and map time but not
   previous attachments.

 - test_select_at_map: the exporter chooses a non-default entry on first
   map and the result is tagged with it. A pin taken while there is a
   live mapping inherits the type and the choice survives unmap/remap.
   Only dma_buf_invalidate_mappings() allows the exporter to make
   a different selection. An -EBUSY from selection leaves nothing
   established.

 - test_select_at_pin: pin selects, and the choice survives map, unmap
   and unpin so a pinned importer that is never invalidated keeps its
   first type for the life of the import.

 - test_unmap_uses_own_type: after an invalidate the exporter may select
   another type for the next map. A mapping made with the previous one
   is still live, and each mapping must be torn down with the type it
   was made with.

 - test_select_survives_own_invalidate: a pin or map whose exporter
   callback invalidates every attachment still ends up selected, and one
   that invalidates and fails does not.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/dma-buf/st-dma-mapping.c | 703 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 703 insertions(+)

diff --git a/drivers/dma-buf/st-dma-mapping.c b/drivers/dma-buf/st-dma-mapping.c
index 8c69ae212455..42e6748f0ae6 100644
--- a/drivers/dma-buf/st-dma-mapping.c
+++ b/drivers/dma-buf/st-dma-mapping.c
@@ -7,6 +7,7 @@
 #include <kunit/test.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-buf-mapping.h>
+#include <linux/dma-resv.h>
 #include <linux/errno.h>
 
 /* Mock tracking state -- reset before each test */
@@ -21,6 +22,27 @@ static const struct dma_buf_match_args *mock_finish_args_arg;
 static const struct dma_buf_mapping_match *mock_finish_exp_arg;
 static const struct dma_buf_mapping_match *mock_finish_imp_arg;
 
+/* Mapping types the configurable mock exporter currently offers */
+static const struct dma_buf_mapping_match *mock_exp_offer;
+static size_t mock_exp_offer_len;
+
+/* Which match set entry the selecting mock exporter picks, or an error */
+static int mock_select_idx;
+static int mock_select_err;
+static int mock_select_count;
+
+/* Make the mock exporter's pin and map invalidate everyone, as a move does */
+static bool mock_invalidate_in_callback;
+
+/* What the mock types' unmap saw: the mapping's header type and its map's */
+static const struct dma_buf_mapping_type *mock_unmap_type;
+static const struct dma_buf_mapping_type *mock_unmap_made_by;
+
+/* Failure injection for the mock types' map and the mock exporter's pin */
+static int mock_map_err;
+static int mock_pin_err;
+static int mock_pin_count;
+
 static int reset_mock_state(struct kunit *test)
 {
 	mock_match_called = false;
@@ -32,6 +54,17 @@ static int reset_mock_state(struct kunit *test)
 	mock_finish_args_arg = NULL;
 	mock_finish_exp_arg = NULL;
 	mock_finish_imp_arg = NULL;
+	mock_exp_offer = NULL;
+	mock_exp_offer_len = 0;
+	mock_select_idx = 0;
+	mock_select_err = 0;
+	mock_select_count = 0;
+	mock_invalidate_in_callback = false;
+	mock_unmap_type = NULL;
+	mock_unmap_made_by = NULL;
+	mock_map_err = 0;
+	mock_pin_err = 0;
+	mock_pin_count = 0;
 	return 0;
 }
 
@@ -374,6 +407,485 @@ static void test_mock_attach(struct kunit *test)
 	dma_buf_put(dmabuf);
 }
 
+static int mock_dmabuf_offer_match_mapping(struct dma_buf_match_args *args)
+{
+	return dma_buf_match_mapping(args, mock_exp_offer, mock_exp_offer_len);
+}
+
+static const struct dma_buf_ops mock_dmabuf_offer_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_offer_match_mapping,
+};
+
+/*
+ * The match set is final once attached. A later importer attaching must not
+ * change an existing attachment even if the exporter returns a different set.
+ *
+ * Later attachments influence what the exporter selects at pin or map time,
+ * not what was previously negotiated.
+ */
+static void test_match_set_is_final(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	static const struct dma_buf_mapping_match offer_b[] = {
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp1[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp2[] = { { .type = &mock_type_b } };
+
+	MOCK_IMPORTER_OPS(importer1_ops, imp1);
+	MOCK_IMPORTER_OPS(importer2_ops, imp2);
+	struct dma_buf_attachment *attach1, *attach2;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_offer_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach1 = dma_buf_dynamic_attach(dmabuf, dev, &importer1_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach1);
+	KUNIT_ASSERT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach1)->type,
+			    &mock_type_a);
+
+	/* Exporter's answer for new importers changes; attach1 does not */
+	mock_exp_offer = offer_b;
+	mock_exp_offer_len = ARRAY_SIZE(offer_b);
+	attach2 = dma_buf_dynamic_attach(dmabuf, dev, &importer2_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach2);
+	KUNIT_ASSERT_EQ(test, attach2->nr_matches, 1);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach2)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach1)->type,
+			    &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach2);
+	KUNIT_EXPECT_EQ(test, attach1->nr_matches, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach1)->type,
+			    &mock_type_a);
+
+	dma_buf_detach(dmabuf, attach1);
+	dma_buf_put(dmabuf);
+}
+
+/* Mock mapping result for the generic map path */
+struct mock_mapping {
+	struct dma_buf_mapping base;
+	const struct dma_buf_mapping_type *made_by;
+};
+
+static struct dma_buf_mapping *mock_type_map(struct dma_buf_attachment *attach,
+					     enum dma_data_direction dir)
+{
+	struct mock_mapping *m;
+
+	if (mock_invalidate_in_callback)
+		dma_buf_invalidate_mappings(attach->dmabuf);
+	if (mock_map_err)
+		return ERR_PTR(mock_map_err);
+	m = kzalloc_obj(*m);
+	if (!m)
+		return ERR_PTR(-ENOMEM);
+	m->made_by = dma_buf_attach_map_type(attach)->type;
+	return &m->base;
+}
+
+static void mock_type_unmap(struct dma_buf_attachment *attach,
+			    struct dma_buf_mapping *mapping,
+			    enum dma_data_direction dir)
+{
+	struct mock_mapping *m = container_of(mapping, struct mock_mapping, base);
+
+	mock_unmap_type = dma_buf_mapping_type_of(mapping);
+	mock_unmap_made_by = m->made_by;
+	kfree(m);
+}
+
+/* Exporter choosing the match set entry the test asks for */
+static int mock_dmabuf_select_mapping(struct dma_buf_attachment *attach)
+{
+	mock_select_count++;
+	if (mock_select_err)
+		return mock_select_err;
+	return mock_select_idx;
+}
+
+static int mock_dmabuf_pin(struct dma_buf_attachment *attach)
+{
+	if (mock_invalidate_in_callback)
+		dma_buf_invalidate_mappings(attach->dmabuf);
+	if (mock_pin_err)
+		return mock_pin_err;
+	mock_pin_count++;
+	return 0;
+}
+
+static void mock_dmabuf_unpin(struct dma_buf_attachment *attach)
+{
+	mock_pin_count--;
+}
+
+static const struct dma_buf_ops mock_dmabuf_select_ops = {
+	.release = mock_dmabuf_release,
+	.match_mapping = mock_dmabuf_offer_match_mapping,
+	.select_mapping = mock_dmabuf_select_mapping,
+	.pin = mock_dmabuf_pin,
+	.unpin = mock_dmabuf_unpin,
+};
+
+/*
+ * Exporter decides type at first map from the match set. The result is tagged
+ * with it and the core holds the choice across unmap/remap until the attachment
+ * has been explicitly invalidated.
+ */
+static void test_select_at_map(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* Exporter picks the second entry (mock_type_b) */
+	mock_select_idx = 1;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+
+	/* A pin taken whilst mapping is live gets the same type */
+	mock_select_idx = 0;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	dma_buf_unpin(attach);
+
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/*
+	 * Unmapped the exporter would now pick A, but no invalidate has
+	 * happened so remap must get B again to avoid ping-ponging.
+	 */
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* Only an explicit invalidation allows the type to change */
+	dma_buf_invalidate_mappings(dmabuf);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	/* Nothing is reselected until the next pin or map */
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_a);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* Exporter cannot serve this importer right now */
+	dma_buf_invalidate_mappings(dmabuf);
+	mock_select_err = -EBUSY;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EBUSY);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	mock_select_err = 0;
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * Pin selects too and the choice survives map, unmap and unpin. A pinned
+ * importer that is never invalidated keeps its first type for the life of the
+ * attachment.
+ */
+static void test_select_at_pin(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	mock_select_idx = 1;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	/* Map after pin uses the pinned type regardless of the exporter now */
+	mock_select_idx = 0;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	dma_buf_unpin(attach);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * If the first map/pin fails it shouldn't pin the selection. However all
+ * subsequent map/pin failure must not reset the selection state, otherwise a
+ * retry could reselect without an invalidate.
+ */
+static void test_select_survives_failed_map(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* A map that selected and then failed does not change the selected state */
+	mock_select_idx = 1;
+	mock_map_err = -EIO;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EIO);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	mock_map_err = 0;
+
+	/* Pin selects B and holds it */
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 1);
+
+	/* A map failing under that pin must not allow a different selection */
+	mock_select_idx = 0;
+	mock_map_err = -EIO;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EIO);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_b);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 1);
+	mock_map_err = 0;
+
+	/* The retry gets the pinned type, not a new selection */
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_b);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	dma_buf_unpin(attach);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 0);
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * The same rule for a failing exporter pin. A pin that selected and then
+ * failed resets the selection state, and one that failed after an existing map
+ * does not.
+ */
+static void test_select_after_failed_pin(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_attachment *attach;
+	struct dma_buf_mapping *mapping;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* First pin selects B but the exporter cannot pin: nothing is kept */
+	mock_select_idx = 1;
+	mock_pin_err = -ENOSPC;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), -ENOSPC);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	KUNIT_EXPECT_EQ(test, mock_pin_count, 0);
+	mock_pin_err = 0;
+
+	/* A live mapping selects A */
+	mock_select_idx = 0;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_a);
+
+	/* A pin failing under it leaves that selection in place */
+	mock_select_idx = 1;
+	mock_pin_err = -ENOSPC;
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), -ENOSPC);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	mock_pin_err = 0;
+
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
 static const struct dma_exporter dma_exporter_params[] = {
 	{ &mock_dmabuf_simple_sgt_ops, "simple_sgt" },
 	{ &mock_dmabuf_two_exp_ops, "two_exp" },
@@ -381,6 +893,190 @@ static const struct dma_exporter dma_exporter_params[] = {
 
 KUNIT_ARRAY_PARAM_DESC(dma_exporter, dma_exporter_params, desc);
 
+/*
+ * After an invalidate the exporter may select another type for the next map
+ * while a mapping made with the previous selection is still live. Since
+ * importers don't have to unmap on invalidate the attachment selection may
+ * have changed by the time unmap is called. Therefore every mapping must be
+ * torn down with the type it was made with, and the new selection governs new
+ * maps only not unmap.
+ */
+static void test_unmap_uses_own_type(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_mapping *mapping, *mapping2;
+	struct dma_buf_attachment *attach;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* Mapped with the exporter's second entry */
+	mock_select_idx = 1;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mapping->match, &attach->matches[1]);
+	KUNIT_EXPECT_EQ(test, mock_select_count, 1);
+
+	/* Invalidated while that mapping is live: the next map reselects */
+	dma_buf_invalidate_mappings(dmabuf);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	mock_select_idx = 0;
+	mapping2 = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping2);
+	KUNIT_EXPECT_PTR_EQ(test, mapping2->type, &mock_type_a);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_EQ(test, mock_select_count, 2);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+
+	/* The old mapping is still torn down as B, the new one as A */
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_PTR_EQ(test, mock_unmap_type, &mock_type_b);
+	KUNIT_EXPECT_PTR_EQ(test, mock_unmap_made_by, &mock_type_b);
+	/* The selection itself is untouched by the unmap */
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+
+	dma_buf_mapping_unmap(attach, mapping2, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_PTR_EQ(test, mock_unmap_type, &mock_type_a);
+	KUNIT_EXPECT_PTR_EQ(test, mock_unmap_made_by, &mock_type_a);
+
+	/* Nothing live, but the selection stands until the next invalidate */
+	mock_select_idx = 1;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_a);
+	KUNIT_EXPECT_EQ(test, mock_select_count, 2);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
+/*
+ * An exporter that moves the buffer during map/pin after invalidating must not
+ * leave the attachment in an unselected state after the map/pin succeeds. Once
+ * a mapping succeeds it must lock in the selection made after the invalidate and
+ * move and subsequent map/pin operations must get the same type.
+ */
+static void test_select_survives_own_invalidate(struct kunit *test)
+{
+	static const struct dma_buf_mapping_match offer_ab[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	struct dma_buf_mapping_match imp[] = {
+		{ .type = &mock_type_a },
+		{ .type = &mock_type_b },
+	};
+	MOCK_IMPORTER_OPS(importer_ops, imp);
+	struct dma_buf_mapping *mapping, *mapping2;
+	struct dma_buf_attachment *attach;
+	struct dma_buf *dmabuf;
+	struct device *dev;
+
+	mock_type_a.map = mock_type_map;
+	mock_type_a.unmap = mock_type_unmap;
+	mock_type_b.map = mock_type_map;
+	mock_type_b.unmap = mock_type_unmap;
+
+	dev = kunit_device_register(test, "dma-buf-test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	dmabuf = mock_dmabuf_export(&mock_dmabuf_select_ops);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dmabuf);
+
+	mock_exp_offer = offer_ab;
+	mock_exp_offer_len = ARRAY_SIZE(offer_ab);
+	attach = dma_buf_dynamic_attach(dmabuf, dev, &importer_ops, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, attach);
+
+	mock_invalidate_in_callback = true;
+	dma_resv_lock(dmabuf->resv, NULL);
+
+	/* The map's move invalidates the attachment selection. */
+	mock_select_idx = 1;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_mapping_type_of(mapping),
+			    &mock_type_b);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_EQ(test, mock_select_count, 1);
+
+	/* A second map does not reselect. */
+	mock_select_idx = 0;
+	mapping2 = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mapping2);
+	KUNIT_EXPECT_PTR_EQ(test, mapping2->type, &mock_type_b);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_EQ(test, mock_select_count, 1);
+
+	/* Nor does a pin taken under it */
+	KUNIT_EXPECT_EQ(test, dma_buf_pin(attach), 0);
+	KUNIT_EXPECT_TRUE(test, attach->selected);
+	KUNIT_EXPECT_EQ(test, mock_select_count, 1);
+	dma_buf_unpin(attach);
+
+	dma_buf_mapping_unmap(attach, mapping2, DMA_BIDIRECTIONAL);
+	dma_buf_mapping_unmap(attach, mapping, DMA_BIDIRECTIONAL);
+
+	/* A map that invalidates and then fails establishes nothing */
+	dma_buf_invalidate_mappings(dmabuf);
+	mock_map_err = -EIO;
+	mapping = dma_buf_mapping_map(attach, DMA_BIDIRECTIONAL);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(mapping), -EIO);
+	KUNIT_EXPECT_FALSE(test, attach->selected);
+	KUNIT_EXPECT_PTR_EQ(test, dma_buf_attach_map_type(attach)->type,
+			    &mock_type_a);
+	mock_map_err = 0;
+
+	dma_resv_unlock(dmabuf->resv);
+
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+
+	mock_type_a.map = NULL;
+	mock_type_a.unmap = NULL;
+	mock_type_b.map = NULL;
+	mock_type_b.unmap = NULL;
+}
+
 static struct kunit_case dma_mapping_cases[] = {
 	KUNIT_CASE(test_match_fail),
 	KUNIT_CASE(test_match_no_match_callback),
@@ -389,6 +1085,13 @@ static struct kunit_case dma_mapping_cases[] = {
 	KUNIT_CASE(test_match_importer_priority),
 	KUNIT_CASE_PARAM(test_sgt_attach, dma_exporter_gen_params),
 	KUNIT_CASE(test_mock_attach),
+	KUNIT_CASE(test_match_set_is_final),
+	KUNIT_CASE(test_select_at_map),
+	KUNIT_CASE(test_select_at_pin),
+	KUNIT_CASE(test_select_survives_failed_map),
+	KUNIT_CASE(test_select_after_failed_pin),
+	KUNIT_CASE(test_unmap_uses_own_type),
+	KUNIT_CASE(test_select_survives_own_invalidate),
 	{}
 };
 

-- 
2.54.0

