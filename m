Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474848;
	b=JWSbUkDJTXegKFyoZlU40gWdhEuZUUPzY6cnMWm/XPpsrw9IC18Cw4T3vuJ7F0uBE77E
	 qXiSaJPczPVeA/A/vNyUP7JyPel4YDklM4+vqma4j/ELaNQ2dBNuR8Dxz0xYslnV0H8S0
	 5TBtixKQxeSaGxPZW52y+jU7yzX0xos2EeJpOIs4pJ8j+KExh867ThZI7MKuOl4RMQRMi
	 8ZLoRGrj1QveGkX65gDird3hcchOc3gPnHgiq8FDfQRvxgre7n+TkUmsBepD7Z4g1wDIL
	 9LiXjW5wpqAQ4L04HhNzWRZVBLVeQ/xksygzGmWCPQXz6b/LQ4FaU127NB0Zn0Xa5NA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474848;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:CC:
	 X-Mailer:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=SrvUhXpMCuro3KPlz8R/QnZgTj8N8c5TQNW5rftN4lc=;
	b=L5MsghoMdSMseWv2LP35rpFBiFv0gsBs7nVKpj/U+pX0/YLvirt2QoUBgn1q89qimFh3
	 96BA0rCRl7IeMfS6222Fe7j1T3iLfpV6PnMD2MPWxs0a6XBlGYfHv1h42O7F82YQ3LzFK
	 rOmYz+OQYLgQe8xPHGx69MqBHp69pAG3SslomLoDVq7ERHg+TWGpYGFYdIM/ha7E7cduw
	 ffrUX5J98286pCpdzXjoULJCjajW5qDQ5EnNR2+C+do1EmUGY2TS2XH/BkXz3ybqoj4Xj
	 sDhxHpxj6EHFtOEo79WhJyZhkkQIpA3mUaWWb5xcCv8MOJpTP5xAGyVjOZXY2HMPuKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=kXVbVh1F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39DD60A260E;
	Sat, 31 Oct 2026 19:27:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B39DD60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=kXVbVh1F
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJCcPW010339;
	Sat, 31 Oct 2026 19:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=Sr
	vUhXpMCuro3KPlz8R/QnZgTj8N8c5TQNW5rftN4lc=; b=kXVbVh1FBLvSpXbukD
	Ifu/ue/lc1+7SdERs2ZX4h+B6X2bcwNfgU/ZPVQ+Ihte9XJzZzGk/qW5TKqZogUW
	j4cHZh8gb0Bu2zgQ10Q+emDCQC1f2FpP/E3CixcXh39IdnFoKhrF3Ig5JtFWkTYx
	JnvzYW1A9geCF/8hKYRUU8azx5dluC4mbx7+8de6O1ok6INSNs5iLkqmbci0hVUQ
	RkNiu9YMpalkQqhEhb5O5xJbR2RDrj/OEVJPHPuGAtY3kZYwlPxqPjVhGHDAGdwt
	+uJLC2AZhxeJPPKvVmA9vI5pVn8mRY9LqCskP6jGuEoWat2geUdx1FYtKRowykZ3
	8B8w==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn900e8ds-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:27:24 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id DF74ED241;
	Sat, 31 Oct 2026 19:27:23 +0000 (UTC)
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:27:08 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:27:08 -1200
Received: from SN1PR07CU001.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:27:08 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wz+SNTLYFsvvIlyfg3/VnVJsU6APchfVpxl4S8Yv9zxgwMcbeCQlLq5B9svGxxv0+T6QEANjbKwZTZAo1towlV9HUwbF5WSrlAgGAwQJoEBNdrIEpDmK4ZPxIfdWxlVf8JeBihkH9XbuZCHt+KFeQYtJgc3jcV0jw/jYduYx9If/2e6o3NtQVpxZfKbOLElYd1Yx0dRvXPlIq3Nn1/grSELBKPkC3FTOKGnYHWPfhmM+Q7Q/W69DWFkzfZ08BBfEiq4gaNaGdSGc1HiwYLKHkTGM3QbjwAl0QhY4mPwm+MumB2vrP5ClFSJaIxgS4WWmvSxRiYy1YNr37fh7gv6svQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrvUhXpMCuro3KPlz8R/QnZgTj8N8c5TQNW5rftN4lc=;
 b=QHJ+yJBv1LhMvs451pDhI5mA7wKer+ETFQCsBiX/7FdSTypnUfy6KGWCTVw8WTvlN0awLHdEgOlc5gayZYDoB60g8JqFjZ8rqY1O0ZrgI0Kvyl587F25UhCnaGMGRqS+GxLFefSJxetD+NVMxKmdk7xElXiPPtR8YMrWHz8HKRL5TNAI3JNBDF9FQG1Cb8QxsiNm8ZjodKgeH2M4AHUsseaxOHNIXSHfiIpIWxt+LUIOO5gpcTh3NqCKAW9fSYDz6LbCOUZdXhgLb45WgjKfODGuIKIE4baZUhN4/Apl8+8SeG+fY+ueD1q2438GViS9r+/DaVfRX6WarZXQFrqbMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW5PR84MB1891.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:27:05 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:27:04 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:26:03 -0700
Subject: [PATCH 10/12] cxiverbs: launch Slurm-style exact VNI TC and
 resource grants
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-10-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SN7PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:806:121::24) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW5PR84MB1891:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e698127-d4e0-45aa-0fe5-08df3784f209
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|260925022911599003|260925021911599003|260925021311599003|5023799004|261026135527099003|56012099006|261009223027099003|261028144727099003|261026121527099003|261021121427099003|261021123027099003|261021133027099003|261021135927099003|261021130227099003|261022105027099003|261026140227099003|261022115727099003|261022075727099003|261022113327099003|261026130827099003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: YCFhr7Q3DYpS/CFms46ZxnSobHfES9VUqMGfjnYRljCTZzgQCoThLj5+0S1jGaFJIUJajOYci1QVlqa3MB5Y2Do2GZ45y1IaGrMVrvEXK2kvNo3UqvMOq4/qkutaJQsJBF/f1H3ZMSzOODLZIKn6msRjBixB8GtjhqUKBXSG/Um1iNtmJiI5x2yjYnSh41t1Pv7l1EZhhOq3m0mlm2lGOw+bpLtgoLM2PNB34Q3yr1Y1hQyh3/fYtLEPaDoQOmhfpAV9EHj7pPt2m6J0/hVLLvLGdCSCJ6f6UntvqjWuCFsxJAxkhEfTY+04au+hRW+6hGBhFGCKxs5FEzRCe2VQgw/bQ2DUFj2pVK43nI2CKOdXK0jA5OkZTCUqJ6RX9CehjiYYlr5y9G+5lkfaOQQ/U+oKzQHyGlPDHh+SoUpAPP7bX12EfsSq9ev6Xoy4ILyy+nARdXV7YDcKr4oUKNQ4AsjpDKZbuLerCQU4xeNAHK6W0dKsboi30xd40vkr/AXyToCioFjm65zDToTYOw7RfVki4USMIMJG/GCeOWILXTUuFxDrGABmnFJIrtuA1ej8kySRIzIS574NtOhe5WFNFa+Zo6YAYamzOqYkQj4Sqo+bdzCwOu79SCisepRZXsbqTyGvYMbXFFVTzuOcLb8ZeaVZQ5wpPtLFlrlPz68tanY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(260925022911599003)(260925021911599003)(260925021311599003)(5023799004)(261026135527099003)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261021121427099003)(261021123027099003)(261021133027099003)(261021135927099003)(261021130227099003)(261022105027099003)(261026140227099003)(261022115727099003)(261022075727099003)(261022113327099003)(261026130827099003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2JNeFBGejFUTjhJc1R5dWFiY1VxMzNhcktCdnQ2UjJxOVlLZUlCelNqRUx3?=
 =?utf-8?B?UHUrbXdjYTZjdzdkZ3NRMGdxQVFZQiswNEZXcmIzYXlSckRKSXN4NzlDektK?=
 =?utf-8?B?QXFSQlJqWkg3NEw0eWhJNTFqWEpMVjhWSHN2YlNIcW40OXJPOGpRM2RQbm5a?=
 =?utf-8?B?T3FVODFmdkdUWTlzT3B4QnBWSDJVZDlCRk9tc2s1ZFJkNTFYUHpkc1JKcHlo?=
 =?utf-8?B?VWZadTdIdXJiZ0ZQZ2tYbEZ4cDVlOEp4UnN3YkJKb3FoQlFIRW1HWkZpK0Fz?=
 =?utf-8?B?Nlp5dDNPTHFZaUtMcFVKYjdZM0p0OEhvYzcyNVRUVUxoY1B1S0Q4a2RQNktk?=
 =?utf-8?B?QzVhUUxYa1JSQWVuU2VuajJQRHVGSWk1Ynh6T25RTEdiQzJkdWI1MGN5MG94?=
 =?utf-8?B?YjdHZDV6ZEFlSXBUbVdDVmE2dVNjcVpIZW0vbThLTVZCQ3pHQWRVVEJRaDQ2?=
 =?utf-8?B?a3J2UXcwamNweWtJK3M1QmhZYkxqMnM4Y2xMQmx0WElGbmMvTXlaZVY3ck9I?=
 =?utf-8?B?ZW1vdy9WWllqRkt4SEJZbE9EbFgxVU5zNDhpVFZTNEc1WjZFTzdXU0RNR3hl?=
 =?utf-8?B?QXJ5TW9rYTZYNGEvNXl4N2NWZXA0WlVHYldDTWY1REdRbGFHTHlIV0NlWTV0?=
 =?utf-8?B?OWJRaHc4SUlUTVZQWnJqOXIwcitWUHlJOGZYNitJYmg4THJ2N1BSMFhYUENB?=
 =?utf-8?B?ekxYejdHckZabWljeTV2OWlObVkzVWd1VG1qbzd0OTMrUWVWb2FiNlkxVE5S?=
 =?utf-8?B?M3J6YzVNYzQ1VGlNclJmVTQyMUxGWklFYjNSUGVSTTNySkczUXFXQmYvOHFT?=
 =?utf-8?B?bEVIZGNkcHB1VTlvTDVLUUU4LzI3ZU85akdsY08zclFmR0FQTFNyRml3M1JF?=
 =?utf-8?B?azZwc0NCZmdPNEtOL1ZueXRYWkNIbzJRVURITk5TclVJUnM0dkh6K3JIZzN2?=
 =?utf-8?B?dHZmZ2dvTTA1VXNVWGx1TVpwTEJpb25saklmZ3BUeVArOFhFd281UDVHODF6?=
 =?utf-8?B?YXZvUEZHN0M2TDN1a2ZUYnpuWU5XRndqSnhBRmRqczhNeWVhL3Y3WGNSc1Zx?=
 =?utf-8?B?Q1V1UkkyN2QzbUNsSVVLNlUyZGZnTENPb2hIQnpMblBENmdvaGduRkZLdFpy?=
 =?utf-8?B?QmVMNFJ0Mk82aHNLOHhHMUtTVEFqTTdYTzJkQm10aGhkMExyNjltYW9pWU05?=
 =?utf-8?B?cURUTC9GcENVRGV4Rnk5b0h6Zm5xNk5WUzRvczBYdmQvUkQveFp3N1h6Wmk5?=
 =?utf-8?B?TnJsVFptTUZsMlk1cWMzYU12c3Z4ekVyK05BV3VtS1ZycHQ0eFZybWVoVFdv?=
 =?utf-8?B?alhyRE1pd3dWeXJ4akN3WndzbGoxWXZpT0xsQ2FWNnNDR083ek54VzZGQnNm?=
 =?utf-8?B?MElDekZKMmZmeGdnWVhGUU5KTU9DbHI3RlJ5cjNBSzYwNXh6b1VvbTJla3dX?=
 =?utf-8?B?OGdCZnhkUEhIYkk3MXpNOHFieXJIdllQL2dGZ2ZIQi9FNi9FVndyRUljaGly?=
 =?utf-8?B?ZVhlbjdRQ21IVm1IMjNaU09nbFBISHp4cU1kdWh3MTRXTDZSajN1UnlNNjZX?=
 =?utf-8?B?ZVozcEdqR2pHbU1SUlZGREhSREhrc0cyd1JJd3NvUjVld0pza0xNWkR3NS91?=
 =?utf-8?B?TFhKMnc5YXRsT2JzTW8za01CN2JkWFNkVVhNTUFaOUp6RUVaVWc2MElsZE9Z?=
 =?utf-8?B?L3F6L0J0b3loajdiTk1UOC9iTTM4QW94U1FpMWVQMDBUM3M3dTZPbVY3a3Ni?=
 =?utf-8?B?ZE1hNmF1eGN5TUhnT0oxeFh3cnNoaDNCTWc5amVpWWExRERjMnMzTGE4NzIz?=
 =?utf-8?B?clZqcU41UmVkemNzQTVPTUpGMUdFUmdaa0ZXSWVpMjBNU3VoNDNIRkFHclpo?=
 =?utf-8?B?SEsrTVduN1dHUm1tNzZGR2ZHaStJWHdmMlhJNEJZSDVLWVpsekRaa1Zsbyti?=
 =?utf-8?B?eVVCSjY0dHJVZDd0bEx4QWpaMXdOM2JGYy92VTgrSTBtbEpWRVUyck9zUURE?=
 =?utf-8?B?dERMcVYxMVNicTFhN1g1K1BXRVB1K2pBUkR4THZUUjFLOVNlS0d5cExoQkpS?=
 =?utf-8?B?amZXSjJlOS9Rb1dCSGV5MmNCL3ZqcldETk15d24yU1ZkbnFyZTlZSWRrcGV0?=
 =?utf-8?B?ZWNaUGNHWHdvbkpBMnBQT1dkVHNuTzVkandGV0h5eFBIZ3FNallaRmlILzZ5?=
 =?utf-8?B?YmhQU084bkp0Q21QN0RLbXFTQUdpMXZEOGlDcnd5aUV2RHZRTlQ5UnBJVzRk?=
 =?utf-8?B?M0xsODhXOHVITmlsOFdwWHdpRmtGTlpTcmJuMGxiOFdOdXkyQmRFQXpGYUVY?=
 =?utf-8?B?aE92aGJPS1N2Mm9oMVJSOFFtcTB4WVp1NkNmU0dOeE9DMENIVU9Rdz09?=
X-Exchange-RoutingPolicyChecked: nZ55PPvfN6ruA00sDKGvIU1gyVDdQ64iGiMQKuo7ud69fJBTOddg0y266xjMheDY7SMohq8BJXYd/rmUWSdSTydwTAzCW/o2uG91nZzsma/w7uRs8Kip/4Lv1Y4spoq70BCHEvsh2QQI/z3wErC04ottqUFeRaQiHruCcFh4Y09Xk4yknNV6n7Cxu9tDq1ydqD/jp4q7nYIBdlwPxTWp3mWBfTLoTIBgO7PksaHgLRhBw5QHaGWEfBX3PpPiGieaJQcb+71ygSzv62byW7Hb7vr8MUAn9hGgRU4fdG8sjIzVIOYD7TilstBeqntEaclvJeBMJDbmf9OYkxbQFWq8jg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e698127-d4e0-45aa-0fe5-08df3784f209
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:27:04.9644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /yTahXvXwsxPjV8QYnb/ByTBLhF2Bl/x0/677p13HVKetGu4A6wgLJoFDIxp1OTJVjIKo7Ir9B0OQZO1cgn2hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1891
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=J5I/fwnS c=1 sm=1 tr=0 ts=6ae6411c cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=k7r4yCLl9DVLXMiQTbtC:22 a=MvuuwTCpAAAA:8 a=7wrLxfBo2xsZqo0QAsMA:9
 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
X-Proofpoint-ORIG-GUID: 34Qvt4rltdAlNFxkSkA7vYWp0lLow5SX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX2c6QGUQBStyf
 6UZ3NMcc8pmx8BSrJBO2FUB3P9C53Mo6O2TtGH7cnxczwg58KTxdvw4AvvnuGFOBp6mVOzkesKo
 V+8GHHeT0OJl4jUJ2HhCr1X2pLha44DS0A0jCLjGG4SwQki0XRzMEWr0CsWiEgG5upUAhZnqZi8
 V4VIDjOENzqiCYT0t2b64l2vJKQaXnMA7ZMzt3uZ1aa2674KMFN9fWKONJgji0SMio/dN/tFbzh
 HrT5MBhFf52H6V95+vGYJQLmymvK8PqNuQAq6jBwcPCjLtlx/XrmVarlTJVosU7q4meOkEASSZ2
 ZE6rAxSQOFk9EeEuPePXoEjMcUTQL9wmCZiVE+b7qLd49bcmvbj6e08ZxEnrqP2YFgxcg430DzM
 h6taRu0V+jGFqnBEwewVy7FvZCWVPIn8rEkFEoYp4x2ikfyeQ3KsYSXT9ljE9JLLV8zVBwLGLVr
 5jSp51hp5VZriMafuGQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX3yJ2d213DMC4
 KlegVVKcIwUPbQg8+4UT/qLoeHRpSfyuuR5DVdEAyPNp9OPEkLCQLVKodWDup5dk2hUZcIkvOQJ
 tBO99jRyUBahPGqxFr+8SFKtWfizQUY=
X-Proofpoint-GUID: 34Qvt4rltdAlNFxkSkA7vYWp0lLow5SX
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310077

Add cxi_launcher, which provisions a service and job grant for a
single test process and then runs it.  It stands in for a workload
manager when testing the provider without one: it creates a service
restricted to the target UID with exact VNIs, traffic classes and
resource limits, exports a job grant, drops privileges for the child
and removes the service when the child exits.  The cxi_telem utility, a
small telemetry dumper built on ibv_read_counters_ex(), is added with it.
The environment the child
sees follows the Slingshot names (SLINGSHOT_SVC_IDS,
SLINGSHOT_VNIS, SLINGSHOT_TCS, SLINGSHOT_DEVICES) plus the UET_*
names the RU examples read.

It is meant for developer testing.  It must be run by root and exits
at once otherwise, and refuses to run setuid or with file capabilities.
It keeps root only for service and job setup and cleanup.  The forked
child closes every descriptor but stdio and the job grant, drops
groups, gid and uid irreversibly and sets no_new_privs; the job
runs as root only if --uid 0 is given. Inherited UET_*, SLINGSHOT_*
and CXI_VERBS_* variables are
scrubbed first.  README.md describes the options.

checkpatch (rdma-core CI settings) still reports VOLATILE (2) in this
patch. Both are intentional, documented in providers/cxi/utils/README.md:
the launcher's state is volatile sig_atomic_t because it is shared with
its signal handler. If reviewers prefer a different form, it needs
coordination with the internal repositories and will be changed in V2.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 providers/cxi/utils/README.md      | 134 +++++
 providers/cxi/utils/cxi_launcher.c | 967 +++++++++++++++++++++++++++++++++++++
 providers/cxi/utils/cxi_telem.c    | 201 ++++++++
 3 files changed, 1302 insertions(+)

diff --git a/providers/cxi/utils/README.md b/providers/cxi/utils/README.md
new file mode 100644
index 000000000000..6d53fe39faa8
--- /dev/null
+++ b/providers/cxi/utils/README.md
@@ -0,0 +1,134 @@
+# CXI launcher
+
+`cxi_launcher` provides privileged setup and teardown for standalone CXI verbs
+tests without a workload manager. It links directly to `libcxiverbs`; there is
+no generic launcher, vendor plugin, or module-search environment variable.
+
+Build with `cmake --build build --target cxi_launcher`. For an uninstalled tree:
+
+```sh
+sudo env IBV_DRIVERS=cxiverbs LD_LIBRARY_PATH="$PWD/build/lib" \
+  build/bin/cxi_launcher -d rdmap1s0 --vni 42 --tc 3 -- \
+  "$PWD/build/bin/ibv_ru_pingpong" -d rdmap1s0 -g 0 -c -n 1000
+```
+
+Run the same command on the peer with the server hostname appended to
+`ibv_ru_pingpong`. Use `ibv_ru_rma` in place of `ibv_ru_pingpong` for RMA.
+Device/VNI/TC values must agree with the intended test policy on both ends.
+
+The ibv_ru_pingpong and ibv_ru_rma examples call the launcher themselves on
+a Slingshot device: run them as `sudo ibv_ru_pingpong -d rdmap1s0 ...` (add
+`-j ID` to choose the JobID/VNI). They re-run themselves under the launcher,
+as the sudo user, and the second run finds `UET_JOB_FD` and starts the test.
+Automatic relaunch uses only the compiled-in installation directory, never a
+sibling executable from a build directory. For an uninstalled tree, invoke
+the built `cxi_launcher` explicitly as in the command above.
+
+`cxi_launcher_test` checks the descriptor-closing fallback without creating
+device resources. Run it under sudo if the process hard descriptor limit is
+below 70001; only forked test children raise and then lower their own limits.
+
+The launcher must be run by root (real and effective uid 0) and exits at
+once otherwise. It refuses to run if it is installed setuid or with file
+capabilities, and it is never meant to be. It needs no privilege beyond
+what root already has: it keeps root only to create and destroy the
+service and job grant and to clean up after the command.
+
+The parent creates a service restricted to the child UID, allocates and
+exports a generic job grant, launches the child, waits for it, and
+releases its owned resources. The child UID is `SUDO_UID` or `--uid`; the
+command is not run as root unless `--uid 0` is given explicitly. Immediately after fork the child closes
+every descriptor except stdio and the exported job grant, drops
+supplementary groups, gid and uid for good, and sets no_new_privs, so
+it holds no capabilities and cannot regain them. Inherited `UET_*`,
+`SLINGSHOT_*` and `CXI_VERBS_*` variables are removed before the launcher
+defines its own, so the caller cannot pre-set a service or job.
+SIGINT/SIGTERM/SIGHUP are forwarded to the child process group, and
+cleanup errors make the launch fail.
+
+`--service ID` reuses an existing enabled service only if its UID, every VNI,
+and every requested TC are permitted. The launcher does not modify or destroy
+that service. There is no default-service fallback. `--tc` selects the child's
+class; repeat `--allow-tc` to grant the service additional classes. The selected
+class must be included. `SLINGSHOT_TCS` receives the full bitmask, while
+`UET_TC` remains the selected class. Without `--allow-tc`, the selected class is
+the only grant. `--create-tc` configures all granted classes on a newly owned
+service. `--tc-* MAX[:RESERVED]` options set resource limits; unspecified maxima
+come from device capacity, and explicit zero limits are retained. These are
+administrator test grants, not Slurm's per-thread resource-budget calculation.
+
+`--threads-per-task N` models Slurm's depth-based defaults by reserving the
+per-thread resource default multiplied by N, capped at the configured maximum.
+The design defaults are PTES=6, TXQS=2, TGQS=1, EQS=2, CTS=1, ACS=2, TLES=1,
+and LES=16 per thread. Override them with
+`--default-{ptes,txqs,tgqs,eqs,cts,acs,tles,les}`. Explicit `--tc-* MAX`
+options override the maximum while retaining the depth-based reservation;
+`MAX:RESERVED` supplies both values explicitly. Resource-limit calculations
+apply only when creating a service, not when reusing one.
+
+The child receives `SLINGSHOT_SVC_IDS`, `SLINGSHOT_VNIS`, `SLINGSHOT_TCS` and
+the native `SLINGSHOT_DEVICES` name correlated by NID. `UET_JOB_ID`,
+`UET_JOB_FD`, `UET_SERVICE_ID`, `UET_TC` and `CXI_VERBS_DEVICE` retain the current
+RU example handoff. Values alone are not authorization: the service and exported
+grant must permit the operations.
+
+Repeat `--vni` to grant a step VNI and an optional shared-job VNI (up to the
+native four-VNI service limit). The first value is used as the transport job
+ID; every value is placed, in order, in `SLINGSHOT_VNIS` and is checked against
+an existing service before reuse. The service stores the exact list, not the
+min/max range around it. Multi-device provisioning, full native
+membership/update/LPR management and the complete unchanged Slurm/libcxi
+workflow remain separate required work.
+
+## Optional Job Address Tables
+
+The launcher keeps zero-entry jobs as its default. Explicit-AH requests do not
+need a table. Applications choosing indexed addressing must explicitly request
+a positive `max_addr_entries` with `IBV_JOB_ATTR_MAX_ADDR_ENTRIES`.
+For example, `cxi_launcher --max-addr-entries 16` opts a launched job into a
+16-entry table; omitting the option preserves the zero-entry default. The RU
+RMA example requests 16 entries automatically when `-A` is selected.
+
+Build `cxi_le_test` and run it without arguments for device-free checks. These
+exercise omitted/zero capacity through the public API, actual provider command
+encoding for explicit and indexed SEND/WRITE/READ, pre-lock address resolution,
+extended-batch abort/rollback, and concurrent mock table updates/submissions.
+The command ring and doorbell are ordinary memory, not hardware mappings.
+
+With hardware-test approval, run `cxi_le_test --resources DEVICE` for the
+existing explicit-AH/zero-entry resource checks. Running the same command with
+`CXI_TEST_INDEXED=1` opts the sending job into a two-entry table and exercises
+real insert/query/remove, duplicate/unset/out-of-bounds entries, and indexed
+SEND at index 1. These resource tests alter device resources and must not be
+run as part of device-free validation.
+
+NIC RMA completion, concurrent kernel-table updates versus NIC sends, and
+performance measurements remain hardware validation gates. Compare explicit-AH
+and indexed paths with identical message sizes, batch sizes, thread counts,
+completion handling, and device setup; report throughput, CPU time, and latency
+including lookup cost. The indexed path queries the kernel for each address
+snapshot rather than caching possibly stale entries. The extended API stages
+requests in a reusable buffer before emission. Neither CPU-only tests nor a
+successful build establish a NIC performance result. Indexed addressing must
+not become the default without this comparison.
+
+## Checkpatch Exceptions
+
+Use the userspace exclusions in `buildlib/azp-checkpatch` when reviewing this
+series. In particular, kernel type names and negative errno returns are not
+the libibverbs API conventions. Do not change those contracts for checkpatch.
+
+The following additional diagnostics are documented exceptions, not disabled
+checks:
+
+- Imported UAPI headers use portable packed attributes and explicit bit
+  constants rather than kernel-private `__packed` and `BIT()` helpers.
+- The command-queue status and event accesses retain `volatile` for device
+  updates. The launcher's `volatile sig_atomic_t` state is shared with signal
+  handlers. Removing these qualifiers is not a formatting change.
+- `CXI_MATCH_ID` repeats its width argument to remain a constant expression
+  in static initializers. Callers must pass a side-effect-free width.
+
+Check each patch separately to avoid false duplicate-trailer diagnostics.
+If a combined header-import patch produces type-inference diagnostics in a
+later file, check that file independently before changing valid declarations.
diff --git a/providers/cxi/utils/cxi_launcher.c b/providers/cxi/utils/cxi_launcher.c
new file mode 100644
index 000000000000..9e32e31f680e
--- /dev/null
+++ b/providers/cxi/utils/cxi_launcher.c
@@ -0,0 +1,967 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Copyright 2026 Hewlett Packard Enterprise Development LP
+ */
+
+#define _GNU_SOURCE
+#include <config.h>
+
+#include <ctype.h>
+#include <errno.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <grp.h>
+#include <limits.h>
+#include <pwd.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/auxv.h>
+#include <sys/prctl.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include <infiniband/cxidv.h>
+#include <infiniband/verbs.h>
+#include <ccan/array_size.h>
+
+#define CXI_MAX_TRAFFIC_CLASS CXIDV_TC_ETH
+
+struct cxirdma_state {
+	struct cxidv_job_tc_attr tc_attr;
+	uint32_t traffic_class;
+	uint32_t allowed_tc_mask;
+	uint32_t threads_per_task;
+	uint16_t thread_defaults[CXIDV_SVC_RSRC_COUNT];
+	bool create_tc;
+	bool explicit_tc;
+	bool list_tcs;
+	bool dry_run;
+	bool threads_per_task_set;
+	uint32_t svc_id;
+	uint32_t max_addr_entries;
+	bool owns_svc;
+	uint16_t vnis[CXIDV_SVC_MAX_VNIS];
+	uint32_t vni_count;
+	uid_t uid;
+	uint32_t limits_mask;
+	uint32_t explicit_reserved_mask;
+	uint32_t thread_default_mask;
+};
+
+static const struct option cxirdma_options[] = {
+	{ "device", required_argument, NULL, 'd' },
+	{ "vni", required_argument, NULL, 'j' },
+	{ "job-id", required_argument, NULL, 'j' },
+	{ "uid", required_argument, NULL, 'u' },
+	{ "service", required_argument, NULL, 'S' },
+	{ "port", required_argument, NULL, 'i' },
+	{ "gid-index", required_argument, NULL, 'g' },
+	{ "max-addr-entries", required_argument, NULL, 1002 },
+	{ "help", no_argument, NULL, 'h' },
+	{ "tc", required_argument, NULL, 1000 },
+	{ "create-tc", required_argument, NULL, 1000 },
+	{ "allow-tc", required_argument, NULL, 1000 },
+	{ "default-ptes", required_argument, NULL, 1000 },
+	{ "default-txqs", required_argument, NULL, 1000 },
+	{ "default-tgqs", required_argument, NULL, 1000 },
+	{ "default-eqs", required_argument, NULL, 1000 },
+	{ "default-cts", required_argument, NULL, 1000 },
+	{ "default-acs", required_argument, NULL, 1000 },
+	{ "default-tles", required_argument, NULL, 1000 },
+	{ "default-les", required_argument, NULL, 1000 },
+	{ "threads-per-task", required_argument, NULL, 1001 },
+	{ "dry-run", no_argument, NULL, 1000 },
+	{ "tc-ptes", required_argument, NULL, 1000 },
+	{ "tc-txqs", required_argument, NULL, 1000 },
+	{ "tc-tgqs", required_argument, NULL, 1000 },
+	{ "tc-eqs", required_argument, NULL, 1000 },
+	{ "tc-cts", required_argument, NULL, 1000 },
+	{ "tc-tles", required_argument, NULL, 1000 },
+	{ "tc-les", required_argument, NULL, 1000 },
+	{ "tc-acs", required_argument, NULL, 1000 },
+	{ "list-tcs", no_argument, NULL, 1000 },
+	{}
+};
+
+static volatile sig_atomic_t child_group;
+static volatile sig_atomic_t interrupted;
+
+static void forward_signal(int number)
+{
+	int saved_errno = errno;
+
+	interrupted = number;
+	if (child_group)
+		kill(-(pid_t)child_group, number);
+	errno = saved_errno;
+}
+
+static int parse_number(const char *text, uint32_t maximum, uint32_t *value)
+{
+	char *end;
+	unsigned long parsed;
+
+	if (!text || !*text)
+		return -1;
+	errno = 0;
+	parsed = strtoul(text, &end, 0);
+	if (errno || *end || parsed > maximum || !isdigit((unsigned char)*text))
+		return -1;
+	*value = parsed;
+	return 0;
+}
+
+static int parse_limit(const char *arg, struct cxidv_limits *limit, bool *reserved_specified)
+{
+	unsigned long max, res = 0;
+	char *end;
+	bool has_reserved = false;
+
+	if (!arg || !*arg || *arg == '-')
+		return -1;
+	errno = 0;
+	max = strtoul(arg, &end, 0);
+	if (errno || max > UINT16_MAX)
+		return -1;
+	if (*end == ':') {
+		has_reserved = true;
+		arg = end + 1;
+		if (!*arg || *arg == '-')
+			return -1;
+		errno = 0;
+		res = strtoul(arg, &end, 0);
+		if (errno || res > UINT16_MAX)
+			return -1;
+	}
+	if (*end)
+		return -1;
+
+	limit->max = max;
+	limit->res = res;
+	*reserved_specified = has_reserved;
+	return 0;
+}
+
+static int parse_tc(const char *arg, const char *option, uint32_t *out)
+{
+	unsigned long tc;
+	char *end;
+
+	if (!arg || !*arg || *arg == '-')
+		return -1;
+	errno = 0;
+	tc = strtoul(arg, &end, 0);
+	if (errno || *end || tc > CXI_MAX_TRAFFIC_CLASS) {
+		fprintf(stderr, "--%s must be 0..%d\n", option, CXI_MAX_TRAFFIC_CLASS);
+		return -1;
+	}
+
+	*out = tc;
+	return 0;
+}
+
+static bool service_allows_vni(const struct cxidv_svc_attr *attr, uint16_t vni)
+{
+	unsigned int index;
+
+	if (attr->vni_count) {
+		if (attr->vni_count > CXIDV_SVC_MAX_VNIS)
+			return false;
+		for (index = 0; index < attr->vni_count; index++)
+			if (attr->vnis[index] == vni)
+				return true;
+		return false;
+	}
+	if (attr->is_range)
+		return vni >= attr->vnis[0] && vni <= attr->vnis[1];
+
+	return false;
+}
+
+static int format_vni_list(const uint16_t *vnis, uint32_t count, char *buffer, size_t capacity)
+{
+	size_t used = 0;
+	uint32_t index;
+
+	for (index = 0; index < count; index++) {
+		int length = snprintf(buffer + used, capacity - used, "%s%u", index ? "," : "",
+				      vnis[index]);
+
+		if (length < 0 || (size_t)length >= capacity - used)
+			return -1;
+		used += length;
+	}
+	return 0;
+}
+
+static int list_tcs(struct ibv_context *context)
+{
+	struct cxidv_tc_entry entries[32];
+	uint32_t capacity = ARRAY_SIZE(entries);
+	uint32_t count = 0;
+	uint32_t shown;
+	uint32_t i;
+	int ret;
+
+	ret = cxidv_query_tcs(context, entries, capacity, &count);
+	if (ret) {
+		fprintf(stderr, "couldn't query CXI traffic classes: %s\n", strerror(ret));
+		return -1;
+	}
+
+	shown = count < capacity ? count : capacity;
+	printf("%5s %7s %12s %14s %12s %14s %7s %7s %7s %7s %7s %7s\n", "TC", "TYPE", "RES_REQ",
+	       "UNRES_REQ", "RES_RSP", "UNRES_RSP", "REQPCP", "RSPPCP", "OCUSET", "CQTC", "REQBC",
+	       "FLAGS");
+	for (i = 0; i < shown; i++)
+		printf("%5u %7u %12u %14u %12u %14u %7u %7u %7u %7u %7u 0x%05x\n", entries[i].tc,
+		       entries[i].tc_type, entries[i].res_req_dscp, entries[i].unres_req_dscp,
+		       entries[i].res_rsp_dscp, entries[i].unres_rsp_dscp, entries[i].req_pcp,
+		       entries[i].rsp_pcp, entries[i].ocuset, entries[i].cq_tc, entries[i].req_bc,
+		       entries[i].flags);
+	if (shown < count)
+		printf("... %u more entries not shown\n", count - shown);
+
+	return 0;
+}
+
+static int validate_tc_mask(struct ibv_context *context, uint32_t mask, bool create_tc)
+{
+	struct cxidv_tc_entry entries[32];
+	uint32_t count = 0;
+	uint32_t tc;
+	int ret;
+
+	if (create_tc)
+		return 0;
+	ret = cxidv_query_tcs(context, entries, ARRAY_SIZE(entries), &count);
+	if (ret) {
+		fprintf(stderr, "couldn't query CXI traffic classes: %s\n", strerror(ret));
+		return -1;
+	}
+
+	for (tc = 0; tc <= CXI_MAX_TRAFFIC_CLASS; tc++) {
+		uint32_t index;
+		bool found = false;
+
+		if (!(mask & (1U << tc)))
+			continue;
+		for (index = 0; index < count && index < ARRAY_SIZE(entries); index++) {
+			if (entries[index].tc == tc) {
+				found = true;
+				break;
+			}
+		}
+		if (!found) {
+			fprintf(stderr, "traffic class %u is not configured\n", tc);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int cxirdma_parse_option(void *priv, const char *name, const char *value)
+{
+	struct cxirdma_state *state = priv;
+
+	if (!strcmp(name, "tc")) {
+		state->explicit_tc = true;
+		return parse_tc(value, name, &state->traffic_class);
+	}
+	if (!strcmp(name, "create-tc")) {
+		state->create_tc = true;
+		return parse_tc(value, name, &state->traffic_class);
+	}
+	if (!strcmp(name, "allow-tc")) {
+		uint32_t tc;
+
+		if (parse_tc(value, name, &tc))
+			return -1;
+		state->allowed_tc_mask |= 1U << tc;
+		return 0;
+	}
+	if (!strcmp(name, "list-tcs")) {
+		state->list_tcs = true;
+		return 0;
+	}
+	if (!strcmp(name, "dry-run")) {
+		state->dry_run = true;
+		return 0;
+	}
+
+	{
+		static const struct {
+			const char *name;
+			size_t offset;
+		} limits[] = {
+			{ "tc-ptes", offsetof(struct cxidv_job_tc_attr, ptes) },
+			{ "tc-txqs", offsetof(struct cxidv_job_tc_attr, txqs) },
+			{ "tc-tgqs", offsetof(struct cxidv_job_tc_attr, tgqs) },
+			{ "tc-eqs", offsetof(struct cxidv_job_tc_attr, eqs) },
+			{ "tc-cts", offsetof(struct cxidv_job_tc_attr, cts) },
+			{ "tc-acs", offsetof(struct cxidv_job_tc_attr, acs) },
+			{ "tc-tles", offsetof(struct cxidv_job_tc_attr, tles) },
+			{ "tc-les", offsetof(struct cxidv_job_tc_attr, les) },
+		};
+		size_t i;
+		bool reserved_specified;
+
+		for (i = 0; i < ARRAY_SIZE(limits); i++) {
+			if (strcmp(name, limits[i].name))
+				continue;
+			if (parse_limit(value,
+					(struct cxidv_limits *)((char *)&state->tc_attr +
+								limits[i].offset),
+					&reserved_specified)) {
+				fprintf(stderr, "--%s expects MAX[:RESERVED]\n", name);
+				return -1;
+			}
+			state->limits_mask |= 1U << i;
+			if (reserved_specified)
+				state->explicit_reserved_mask |= 1U << i;
+			else
+				state->explicit_reserved_mask &= ~(1U << i);
+			return 0;
+		}
+	}
+
+	{
+		static const struct {
+			const char *name;
+			enum cxidv_svc_resource resource;
+		} defaults[] = {
+			{ "default-ptes", CXIDV_SVC_PTES }, { "default-txqs", CXIDV_SVC_TXQS },
+			{ "default-tgqs", CXIDV_SVC_TGQS }, { "default-eqs", CXIDV_SVC_EQS },
+			{ "default-cts", CXIDV_SVC_CTS },   { "default-acs", CXIDV_SVC_ACS },
+			{ "default-tles", CXIDV_SVC_TLES }, { "default-les", CXIDV_SVC_LES },
+		};
+		size_t index;
+		uint32_t parsed;
+
+		for (index = 0; index < ARRAY_SIZE(defaults); index++) {
+			if (strcmp(name, defaults[index].name))
+				continue;
+			if (parse_number(value, UINT16_MAX, &parsed)) {
+				fprintf(stderr, "--%s expects 0..%u\n", name, UINT16_MAX);
+				return -1;
+			}
+			state->thread_defaults[defaults[index].resource] = parsed;
+			state->thread_default_mask |= 1U << defaults[index].resource;
+			return 0;
+		}
+	}
+
+	fprintf(stderr, "unknown cxirdma option --%s\n", name);
+	return -1;
+}
+
+static void print_service_plan(const struct cxirdma_state *state, const struct cxidv_svc_attr *attr)
+{
+	static const char *const names[CXIDV_SVC_RSRC_COUNT] = {
+		"ptes", "txqs", "tgqs", "eqs", "cts", "acs", "tles", "les",
+	};
+	unsigned int index;
+
+	printf("service=%s uid=%u tc_mask=0x%x\n", state->svc_id ? "reuse" : "create", state->uid,
+	       attr->tc_mask);
+	if (attr->vni_count) {
+		printf("vnis=");
+		for (index = 0; index < attr->vni_count; index++)
+			printf("%s%u", index ? "," : "", attr->vnis[index]);
+		printf("\n");
+	} else if (attr->is_range) {
+		printf("vnis=%u-%u\n", attr->vnis[0], attr->vnis[1]);
+	} else if (attr->is_system_svc) {
+		printf("vnis=restricted-empty\n");
+	} else {
+		printf("vnis=invalid\n");
+	}
+	for (index = 0; index < CXIDV_SVC_RSRC_COUNT; index++)
+		printf("%s max=%u reserved=%u\n", names[index], attr->maximum[index],
+		       attr->reserved[index]);
+}
+
+static int cxirdma_configure(void *priv, struct ibv_context *context, uint32_t job_id)
+{
+	struct cxirdma_state *state = priv;
+
+	if (state->create_tc && state->explicit_tc) {
+		fprintf(stderr, "--tc and --create-tc are mutually exclusive\n");
+		return -1;
+	}
+	if (!(state->allowed_tc_mask & (1U << state->traffic_class))) {
+		fprintf(stderr, "selected --tc must be included in --allow-tc grants\n");
+		return -1;
+	}
+	if (validate_tc_mask(context, state->allowed_tc_mask, state->create_tc))
+		return -1;
+
+	{
+		struct cxidv_svc_attr attr = {
+			.vni_count = state->vni_count,
+			.tc_mask = state->allowed_tc_mask,
+			.uid = state->uid,
+			.flags = state->create_tc ? CXIDV_SVC_CREATE_TC : 0,
+		};
+		const struct cxidv_limits *limits[] = {
+			&state->tc_attr.ptes, &state->tc_attr.txqs, &state->tc_attr.tgqs,
+			&state->tc_attr.eqs,  &state->tc_attr.cts,  &state->tc_attr.acs,
+			&state->tc_attr.tles, &state->tc_attr.les,
+		};
+		unsigned int index;
+		int ret;
+
+		memcpy(attr.vnis, state->vnis, state->vni_count * sizeof(state->vnis[0]));
+		if (state->svc_id) {
+			if (state->limits_mask || state->threads_per_task_set) {
+				fprintf(stderr, "limits cannot change a selected service\n");
+				return -1;
+			}
+			ret = cxidv_query_svc(context, state->svc_id, &attr);
+			if (ret || !(attr.flags & CXIDV_SVC_ENABLED) || attr.uid != state->uid ||
+			    (attr.tc_mask & state->allowed_tc_mask) != state->allowed_tc_mask) {
+				fprintf(stderr,
+					"selected service does not grant the requested policy\n");
+				return -1;
+			}
+			for (index = 0; index < state->vni_count; index++) {
+				if (!service_allows_vni(&attr, state->vnis[index])) {
+					fprintf(stderr, "selected service does not grant VNI %u\n",
+						state->vnis[index]);
+					return -1;
+				}
+			}
+			if (state->create_tc) {
+				fprintf(stderr, "--create-tc cannot change a selected service\n");
+				return -1;
+			}
+			if (state->dry_run) {
+				print_service_plan(state, &attr);
+				return 0;
+			}
+		} else {
+			struct cxidv_devinfo info;
+			bool have_limits = state->limits_mask != 0 || state->threads_per_task_set;
+
+			if (have_limits) {
+				ret = cxidv_query_device(context, &info);
+				if (ret)
+					return -1;
+				attr.maximum[CXIDV_SVC_PTES] = info.num_ptes;
+				attr.maximum[CXIDV_SVC_TXQS] = info.num_txqs;
+				attr.maximum[CXIDV_SVC_TGQS] = info.num_tgqs;
+				attr.maximum[CXIDV_SVC_EQS] = info.num_eqs;
+				attr.maximum[CXIDV_SVC_CTS] = info.num_cts;
+				attr.maximum[CXIDV_SVC_ACS] = info.num_acs;
+				attr.maximum[CXIDV_SVC_TLES] = info.num_tles;
+				attr.maximum[CXIDV_SVC_LES] = info.num_les;
+			}
+			for (index = 0; index < CXIDV_SVC_RSRC_COUNT; index++) {
+				uint32_t bit = 1U << index;
+				uint16_t maximum = attr.maximum[index];
+				uint64_t reservation = 0;
+				bool reservation_set = state->threads_per_task_set;
+
+				if (state->threads_per_task_set)
+					reservation = (uint64_t)state->thread_defaults[index] *
+						      state->threads_per_task;
+				if (state->limits_mask & bit) {
+					maximum = limits[index]->max;
+					if ((state->explicit_reserved_mask & bit) ||
+					    !state->threads_per_task_set) {
+						reservation = limits[index]->res;
+						reservation_set = true;
+					}
+				}
+				if (reservation_set) {
+					if (reservation > maximum && !state->threads_per_task_set) {
+						fprintf(stderr,
+							"--tc resource reservation exceeds maximum\n");
+						return -1;
+					}
+					if (reservation > maximum) {
+						fprintf(stderr,
+							"resource %u reservation clamped to maximum %u\n",
+							index, maximum);
+						reservation = maximum;
+					}
+					attr.reserved[index] = reservation;
+				}
+				attr.maximum[index] = maximum;
+				if (state->threads_per_task_set || (state->limits_mask & bit))
+					attr.flags |= CXIDV_SVC_LIMITS;
+			}
+			if (state->dry_run) {
+				print_service_plan(state, &attr);
+				return 0;
+			}
+			ret = cxidv_alloc_svc(context, &attr, &state->svc_id);
+			if (ret) {
+				fprintf(stderr, "couldn't provision service for JobID %u: %s\n",
+					job_id, strerror(ret));
+				return -1;
+			}
+			state->owns_svc = true;
+		}
+	}
+
+	/*
+	 * The target picks its service from UET_SERVICE_ID; without this it
+	 * falls back to the default service, which is not the one the binding
+	 * just provisioned for this traffic class.
+	 */
+	if (state->svc_id) {
+		char value[16];
+
+		snprintf(value, sizeof(value), "%u", state->svc_id);
+		if (setenv("UET_SERVICE_ID", value, 1)) {
+			perror("setenv UET_SERVICE_ID");
+			return -1;
+		}
+		if (setenv("SLINGSHOT_SVC_IDS", value, 1))
+			return -1;
+	}
+
+	/*
+	 * The service authorises the VNI, but QP creation still needs
+	 * UET_TC to pick the same traffic class; ctx->tc_valid never
+	 * survives exec() into the target process.
+	 */
+	{
+		char value[16];
+
+		snprintf(value, sizeof(value), "%u", state->traffic_class);
+		if (setenv("UET_TC", value, 1)) {
+			perror("setenv UET_TC");
+			return -1;
+		}
+		snprintf(value, sizeof(value), "%x", state->allowed_tc_mask);
+		if (setenv("SLINGSHOT_TCS", value, 1))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int cxirdma_cleanup(void *priv, struct ibv_context *context)
+{
+	struct cxirdma_state *state = priv;
+
+	if (state->owns_svc) {
+		int ret = cxidv_destroy_svc(context, state->svc_id);
+
+		if (ret)
+			fprintf(stderr, "couldn't destroy launcher service %u: %s\n", state->svc_id,
+				strerror(ret));
+		return ret;
+	}
+	return 0;
+}
+
+static void usage(const char *program)
+{
+	printf("Usage: %s [options] -- command [args...]\n", program);
+	printf("  -d, --device NAME        RDMA device\n");
+	printf("  -j, --vni NUMBER         granted VNI; repeat up to %u times\n",
+	       CXIDV_SVC_MAX_VNIS);
+	printf("  -u, --uid NUMBER         child/service owner (default sudo user; 0=root)\n");
+	printf("  -S, --service NUMBER     reuse a permitted service without destroying it\n");
+	printf("  --tc NUMBER              existing TC (default best effort)\n");
+	printf("  --allow-tc NUMBER        grant a TC; repeat to grant more classes\n");
+	printf("  --create-tc NUMBER       provision a TC for the owned service\n");
+	printf("  --tc-{ptes,txqs,tgqs,eqs,cts,acs,tles,les} MAX[:RESERVED]\n");
+	printf("  --threads-per-task N     apply Slurm per-thread resource defaults\n");
+	printf("  --default-{ptes,txqs,tgqs,eqs,cts,acs,tles,les} N\n");
+	printf("  --dry-run                print policy without creating a service\n");
+	printf("  -i, --port NUMBER        port (default 1)\n");
+	printf("  -g, --gid-index NUMBER   GID index (default 0)\n");
+	printf("  --max-addr-entries N     opt in to a job address table\n");
+	printf("  --list-tcs               query traffic classes without launching\n");
+}
+
+static int child_environment(const struct cxirdma_state *state, int descriptor, const char *device)
+{
+	char value[32];
+	char vni_list[CXIDV_SVC_MAX_VNIS * 6];
+
+	snprintf(value, sizeof(value), "%u", state->vnis[0]);
+	if (format_vni_list(state->vnis, state->vni_count, vni_list, sizeof(vni_list)) ||
+	    setenv("UET_JOB_ID", value, 1) || setenv("SLINGSHOT_VNIS", vni_list, 1))
+		return -1;
+	snprintf(value, sizeof(value), "%d", descriptor);
+	if (setenv("UET_JOB_FD", value, 1) || setenv("CXI_VERBS_DEVICE", device, 1))
+		return -1;
+	return 0;
+}
+
+static int native_device_name(struct ibv_context *context, char *name, size_t capacity)
+{
+	struct cxidv_devinfo info;
+	struct dirent *entry;
+	DIR *directory;
+	int result = -1;
+
+	if (cxidv_query_device(context, &info))
+		return -1;
+	directory = opendir("/sys/class/cxi");
+	if (!directory)
+		return -1;
+	while ((entry = readdir(directory))) {
+		char path[PATH_MAX];
+		FILE *property;
+		unsigned int nid;
+		int parsed;
+
+		if (strncmp(entry->d_name, "cxi", 3))
+			continue;
+		snprintf(path, sizeof(path), "/sys/class/cxi/%s/device/properties/nid",
+			 entry->d_name);
+		property = fopen(path, "r");
+		if (!property)
+			continue;
+		parsed = fscanf(property, "%x", &nid);
+		fclose(property);
+		if (parsed != 1 || nid != info.nid)
+			continue;
+		if (strlen(entry->d_name) >= capacity)
+			break;
+		memcpy(name, entry->d_name, strlen(entry->d_name) + 1);
+		result = 0;
+		break;
+	}
+	closedir(directory);
+	return result;
+}
+
+/*
+ * Variables this tool defines for the child. Inherited values are removed so
+ * a caller cannot make the child use a service or job it was not granted.
+ */
+static void scrub_environment(void)
+{
+	char **env;
+
+	for (env = environ; env && *env;) {
+		if (!strncmp(*env, "UET_", 4) || !strncmp(*env, "SLINGSHOT_", 10) ||
+		    !strncmp(*env, "CXI_VERBS_", 10)) {
+			char *name = strndup(*env, strcspn(*env, "="));
+
+			if (!name)
+				_exit(1);
+			unsetenv(name);
+			free(name);
+			env = environ;
+			continue;
+		}
+		env++;
+	}
+}
+
+/* Close everything except stdio and the exported job grant. */
+static int close_inherited_fds(int keep)
+{
+	struct dirent *entry;
+	DIR *directory;
+	int ret = 0;
+
+#ifdef SYS_close_range
+	unsigned int first = keep < 3 ? 3 : (unsigned int)keep + 1;
+
+	if (keep > 3 && syscall(SYS_close_range, 3, keep - 1, 0))
+		goto slow;
+	if (!syscall(SYS_close_range, first, ~0U, 0))
+		return 0;
+slow:
+#endif
+	directory = opendir("/proc/self/fd");
+	if (!directory)
+		return -1;
+	for (;;) {
+		char *end;
+		long number;
+
+		errno = 0;
+		entry = readdir(directory);
+		if (!entry) {
+			ret = errno ? -1 : 0;
+			break;
+		}
+		number = strtol(entry->d_name, &end, 10);
+		if (*end || number < 3 || number > INT_MAX ||
+		    number == keep || number == dirfd(directory))
+			continue;
+		close((int)number);
+	}
+	closedir(directory);
+	return ret;
+}
+
+/* Runs in the forked child, before anything of the user's runs. */
+static int drop_privileges(uid_t uid, gid_t gid, const char *name)
+{
+	if (initgroups(name, gid) || setresgid(gid, gid, gid) || setresuid(uid, uid, uid))
+		return -1;
+	/* Explicit --uid 0 runs the job as root: nothing to take away. */
+	if (!uid)
+		return prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) ? -1 : 0;
+	/* Irreversible: the real, effective and saved ids are all the user's. */
+	if (setuid(0) == 0 || seteuid(0) == 0 || setgid(0) == 0)
+		return -1;
+	if (getuid() != uid || geteuid() != uid || getgid() != gid || getegid() != gid)
+		return -1;
+	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) || prctl(PR_SET_DUMPABLE, 0, 0, 0, 0) ||
+	    prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_CLEAR_ALL, 0, 0, 0))
+		return -1;
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct cxirdma_state state = {
+		.traffic_class = CXIDV_TC_BEST_EFFORT,
+		.thread_defaults = { 6, 2, 1, 2, 1, 2, 1, 16 },
+	};
+	struct ibv_device **devices = NULL;
+	struct ibv_device *device = NULL;
+	struct ibv_context *context = NULL;
+	struct ibv_job *job = NULL;
+	struct ibv_job_attr job_attr = {
+		.comp_mask = IBV_JOB_ATTR_ID | IBV_JOB_ATTR_PORT_NUM | IBV_JOB_ATTR_SGID_INDEX,
+		.port_num = 1,
+	};
+	struct sigaction action = { .sa_handler = forward_signal };
+	struct passwd *owner;
+	const char *device_name = NULL;
+	const char *sudo_uid = getenv("SUDO_UID");
+	char *owner_name = NULL;
+	char native_name[64];
+	gid_t owner_gid;
+	uint32_t value;
+	bool uid_set = false;
+	int descriptor = -1, result = 1, status, option_index, option;
+	pid_t child;
+	sigset_t blocked, previous;
+
+	/*
+	 * Root only, and never setuid or file-capability installed: the real
+	 * uid must be 0 and the loader must not be in secure-exec mode.
+	 */
+	if (getuid() != 0 || geteuid() != 0 || getauxval(AT_SECURE)) {
+		fprintf(stderr, "%s: must be run by root, not setuid\n", argv[0]);
+		return 1;
+	}
+	/* Default target is the sudo invoker; root only if asked with --uid 0. */
+	if (sudo_uid) {
+		if (parse_number(sudo_uid, UINT32_MAX, &value))
+			return 1;
+		state.uid = value;
+		uid_set = true;
+	}
+	scrub_environment();
+	while ((option = getopt_long(argc, argv, "+d:j:u:S:i:g:h", cxirdma_options,
+				     &option_index)) != -1) {
+		if (option == 'h') {
+			usage(argv[0]);
+			return 0;
+		}
+		if (option == 'd') {
+			device_name = optarg;
+			continue;
+		}
+		if (option == 1000) {
+			if (cxirdma_parse_option(&state, cxirdma_options[option_index].name,
+						 optarg))
+				return 1;
+			continue;
+		}
+		if (option == 1001) {
+			if (state.threads_per_task_set ||
+			    parse_number(optarg, UINT32_MAX, &value) || !value) {
+				fprintf(stderr, "--threads-per-task requires a positive integer\n");
+				return 1;
+			}
+			state.threads_per_task = value;
+			state.threads_per_task_set = true;
+			continue;
+		}
+		if (option == 1002) {
+			if (parse_number(optarg, UINT32_MAX, &value) || !value) {
+				fprintf(stderr, "--max-addr-entries requires a positive integer\n");
+				return 1;
+			}
+			state.max_addr_entries = value;
+			continue;
+		}
+		if (parse_number(optarg, UINT32_MAX, &value))
+			return 1;
+		switch (option) {
+		case 'j':
+			if (!value || value > UINT16_MAX || state.vni_count == CXIDV_SVC_MAX_VNIS) {
+				fprintf(stderr,
+					"--vni requires a unique nonzero value; at most %u are allowed\n",
+					CXIDV_SVC_MAX_VNIS);
+				return 1;
+			}
+			for (uint32_t index = 0; index < state.vni_count; index++)
+				if (state.vnis[index] == value) {
+					fprintf(stderr, "duplicate --vni %u\n", value);
+					return 1;
+				}
+			state.vnis[state.vni_count++] = value;
+			break;
+		case 'u':
+			state.uid = value;
+			uid_set = true;
+			break;
+		case 'S':
+			if (!value)
+				return 1;
+			state.svc_id = value;
+			break;
+		case 'i':
+			if (!value || value > UINT8_MAX)
+				return 1;
+			job_attr.port_num = value;
+			break;
+		case 'g':
+			if (value > UINT8_MAX)
+				return 1;
+			job_attr.sgid_index = value;
+			break;
+		default:
+			return 1;
+		}
+	}
+	if ((!state.vni_count && !state.list_tcs) ||
+	    (optind == argc && !state.list_tcs && !state.dry_run)) {
+		usage(argv[0]);
+		return 1;
+	}
+	if (state.vni_count)
+		job_attr.id = state.vnis[0];
+	if (state.max_addr_entries) {
+		job_attr.comp_mask |= IBV_JOB_ATTR_MAX_ADDR_ENTRIES;
+		job_attr.max_addr_entries = state.max_addr_entries;
+	}
+	if (state.thread_default_mask && !state.threads_per_task_set) {
+		fprintf(stderr, "--default-* requires --threads-per-task\n");
+		return 1;
+	}
+	if (!state.allowed_tc_mask)
+		state.allowed_tc_mask = 1U << state.traffic_class;
+	if (!(state.allowed_tc_mask & (1U << state.traffic_class))) {
+		fprintf(stderr, "selected --tc must be included in --allow-tc grants\n");
+		return 1;
+	}
+	if (!uid_set && !state.list_tcs) {
+		fprintf(stderr, "no target user: run under sudo or pass --uid\n");
+		return 1;
+	}
+	owner = getpwuid(state.uid);
+	if (!owner)
+		return 1;
+	owner_gid = owner->pw_gid;
+	owner_name = strdup(owner->pw_name);
+	if (!owner_name)
+		return 1;
+	devices = ibv_get_device_list(NULL);
+	if (!devices)
+		goto out;
+	for (size_t index = 0; devices[index]; index++) {
+		if (devices[index]->transport_type != IBV_TRANSPORT_SLINGSHOT)
+			continue;
+		if (!device_name || !strcmp(device_name, ibv_get_device_name(devices[index]))) {
+			device = devices[index];
+			break;
+		}
+	}
+	if (!device)
+		goto out;
+	context = ibv_open_device(device);
+	if (!context)
+		goto out;
+	if (state.list_tcs) {
+		result = list_tcs(context) ? 1 : 0;
+		goto out;
+	}
+	if (native_device_name(context, native_name, sizeof(native_name)) ||
+	    setenv("SLINGSHOT_DEVICES", native_name, 1)) {
+		fprintf(stderr, "couldn't identify the native CXI device\n");
+		goto out;
+	}
+	if (sigaction(SIGINT, &action, NULL) || sigaction(SIGTERM, &action, NULL) ||
+	    sigaction(SIGHUP, &action, NULL))
+		goto out;
+	if (cxirdma_configure(&state, context, job_attr.id))
+		goto out;
+	if (state.dry_run) {
+		result = 0;
+		goto out;
+	}
+	job = ibv_alloc_job(context, &job_attr, NULL);
+	if (!job || ibv_export_job(job, &descriptor))
+		goto out;
+	value = fcntl(descriptor, F_GETFD);
+	if (value == (uint32_t)-1 || fcntl(descriptor, F_SETFD, value & ~FD_CLOEXEC))
+		goto out;
+	if (child_environment(&state, descriptor, ibv_get_device_name(device)))
+		goto out;
+	sigemptyset(&blocked);
+	sigaddset(&blocked, SIGINT);
+	sigaddset(&blocked, SIGTERM);
+	sigaddset(&blocked, SIGHUP);
+	if (sigprocmask(SIG_BLOCK, &blocked, &previous))
+		goto out;
+	child = fork();
+	if (child == 0) {
+		signal(SIGINT, SIG_DFL);
+		signal(SIGTERM, SIG_DFL);
+		signal(SIGHUP, SIG_DFL);
+		/* The child must not keep the root-owned verbs context. */
+		if (close_inherited_fds(descriptor) || setpgid(0, 0) ||
+		    drop_privileges(state.uid, owner_gid, owner_name) ||
+		    sigprocmask(SIG_SETMASK, &previous, NULL))
+			_exit(126);
+		execvp(argv[optind], &argv[optind]);
+		perror("execvp");
+		_exit(127);
+	}
+	if (child > 0) {
+		setpgid(child, child);
+		child_group = child;
+	}
+	sigprocmask(SIG_SETMASK, &previous, NULL);
+	if (child < 0)
+		goto out;
+	if (interrupted)
+		kill(-child, interrupted);
+	while (waitpid(child, &status, 0) < 0) {
+		if (errno != EINTR)
+			goto out;
+	}
+	child_group = 0;
+	if (WIFEXITED(status))
+		result = WEXITSTATUS(status);
+	else if (WIFSIGNALED(status))
+		result = 128 + WTERMSIG(status);
+out:
+	if (descriptor >= 0)
+		close(descriptor);
+	if (job && ibv_dealloc_job(job)) {
+		perror("deallocate launcher job");
+		result = 1;
+	}
+	if (context && cxirdma_cleanup(&state, context))
+		result = 1;
+	if (context && ibv_close_device(context))
+		result = 1;
+	if (devices)
+		ibv_free_device_list(devices);
+	free(owner_name);
+	return result;
+}
diff --git a/providers/cxi/utils/cxi_telem.c b/providers/cxi/utils/cxi_telem.c
new file mode 100644
index 000000000000..e8b94ab2dd49
--- /dev/null
+++ b/providers/cxi/utils/cxi_telem.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/* Copyright 2026 Hewlett Packard Enterprise Development LP */
+
+/*
+ * Print Cassini telemetry, one "name value@seconds.nanoseconds" per line,
+ * the format the telemetry sysfs files used to have.
+ */
+
+#include <errno.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <infiniband/verbs.h>
+#include <infiniband/cxidv_telem.h>
+
+static const char *const set_names[] = {
+	[CXIDV_TELEM_SET_ETHTOOL] = "ethtool", [CXIDV_TELEM_SET_ATU] = "atu",
+	[CXIDV_TELEM_SET_CQ] = "cq",	       [CXIDV_TELEM_SET_EE] = "ee",
+	[CXIDV_TELEM_SET_HNI] = "hni",	       [CXIDV_TELEM_SET_IXE] = "ixe",
+	[CXIDV_TELEM_SET_LPE] = "lpe",	       [CXIDV_TELEM_SET_MB] = "mb",
+	[CXIDV_TELEM_SET_MST] = "mst",	       [CXIDV_TELEM_SET_OXE] = "oxe",
+	[CXIDV_TELEM_SET_PARBS] = "parbs",     [CXIDV_TELEM_SET_PCT] = "pct",
+	[CXIDV_TELEM_SET_PI] = "pi",
+	[CXIDV_TELEM_SET_RMU] = "rmu",         [CXIDV_TELEM_SET_TOU] = "tou",
+};
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"Usage: %s [-d DEVICE] [-a | -s SET | -i NAME[,NAME...]] [-l]\n"
+		"  -a  all items defined on the device (default)\n"
+		"  -s  a predefined set: ethtool, atu, cq, ee, hni, ixe, lpe, mb,\n"
+		"      mst, oxe, parbs, pct, pi, rmu, tou\n"
+		"  -i  the named items\n"
+		"  -l  list item names without reading them\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	const char *devname = NULL, *setname = NULL, *names = NULL;
+	struct ibv_counters_init_attr init_attr = {};
+	struct ibv_device **list = NULL, *dev = NULL;
+	const uint64_t *set_items = NULL;
+	uint64_t *items = NULL, *values = NULL, *stamps = NULL;
+	struct ibv_counters *counters = NULL;
+	struct ibv_context *ctx = NULL;
+	uint32_t count = 0, i;
+	bool all = true, list_only = false, items_allocated = false;
+	int opt, ret, exit_code = 1;
+
+	while ((opt = getopt(argc, argv, "d:as:i:lh")) != -1) {
+		switch (opt) {
+		case 'd':
+			devname = optarg;
+			break;
+		case 'a':
+			all = true;
+			break;
+		case 's':
+			setname = optarg;
+			all = false;
+			break;
+		case 'i':
+			names = optarg;
+			all = false;
+			break;
+		case 'l':
+			list_only = true;
+			break;
+		default:
+			usage(argv[0]);
+			return 1;
+		}
+	}
+
+	if (list_only) {
+		for (i = 1; i < CXIDV_TELEM_COUNT; i++)
+			printf("%s\n", cxidv_telem_name(i));
+		return 0;
+	}
+
+	list = ibv_get_device_list(NULL);
+	if (!list) {
+		perror("ibv_get_device_list");
+		goto out;
+	}
+	for (i = 0; list && list[i]; i++) {
+		if (list[i]->transport_type != IBV_TRANSPORT_SLINGSHOT)
+			continue;
+		if (!devname || !strcmp(devname, ibv_get_device_name(list[i]))) {
+			dev = list[i];
+			break;
+		}
+	}
+	if (!dev) {
+		fprintf(stderr, "no Slingshot device found\n");
+		goto out;
+	}
+	ctx = ibv_open_device(dev);
+	if (!ctx) {
+		perror("ibv_open_device");
+		goto out;
+	}
+	ibv_free_device_list(list);
+	list = NULL;
+	counters = ibv_create_counters(ctx, &init_attr);
+	if (!counters) {
+		perror("ibv_create_counters");
+		goto out;
+	}
+
+	if (setname) {
+		for (i = 0; i < CXIDV_TELEM_SET_COUNT; i++)
+			if (set_names[i] && !strcmp(set_names[i], setname))
+				break;
+		if (i == CXIDV_TELEM_SET_COUNT || cxidv_telem_get_set(i, &set_items, &count)) {
+			fprintf(stderr, "unknown set %s\n", setname);
+			goto out;
+		}
+		items = (uint64_t *)set_items;
+	} else if (names) {
+		char *copy = strdup(names), *tok, *save = NULL;
+		int item;
+
+		if (!copy) {
+			perror("strdup");
+			goto out;
+		}
+		items = calloc(strlen(names) + 1, sizeof(*items));
+		if (!items) {
+			perror("calloc");
+			free(copy);
+			goto out;
+		}
+		items_allocated = true;
+		for (tok = strtok_r(copy, ",", &save); tok; tok = strtok_r(NULL, ",", &save)) {
+			item = cxidv_telem_lookup(tok);
+			if (item < 0) {
+				fprintf(stderr, "unknown item %s\n", tok);
+				free(copy);
+				goto out;
+			}
+			items[count++] = item;
+		}
+		free(copy);
+		if (!count) {
+			fprintf(stderr, "no telemetry items selected\n");
+			goto out;
+		}
+	} else if (all) {
+		count = CXIDV_TELEM_COUNT;
+	}
+
+	if (!count) {
+		fprintf(stderr, "no telemetry items selected\n");
+		goto out;
+	}
+	values = calloc(count, sizeof(*values));
+	stamps = calloc(count, sizeof(*stamps));
+	if (!values || !stamps) {
+		perror("calloc");
+		goto out;
+	}
+
+	ret = ibv_read_counters_ex(counters, items, values, stamps, count, 0);
+	if (ret) {
+		fprintf(stderr, "ibv_read_counters_ex: %s\n", strerror(ret));
+		goto out;
+	}
+
+	for (i = 0; i < count; i++) {
+		uint32_t item = items ? items[i] : i;
+
+		/* A zero timestamp marks an item this device doesn't have. */
+		if (!stamps[i])
+			continue;
+		printf("%s %llu@%llu.%09llu\n", cxidv_telem_name(item),
+		       (unsigned long long)values[i],
+		       (unsigned long long)(stamps[i] / 1000000000ULL),
+		       (unsigned long long)(stamps[i] % 1000000000ULL));
+	}
+
+	exit_code = 0;
+out:
+	free(stamps);
+	free(values);
+	if (items_allocated)
+		free(items);
+	if (counters)
+		ibv_destroy_counters(counters);
+	if (ctx)
+		ibv_close_device(ctx);
+	if (list)
+		ibv_free_device_list(list);
+	return exit_code;
+}

-- 
2.56.0

