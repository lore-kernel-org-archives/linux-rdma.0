Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474819;
	b=SBYX5unWpIF1QRa0ZLdLYfRYYDkHETeQvZsPrMrI++8nvFZkORLStmcFtjKmPaedp/QM
	 9huSTG+WXkUHZYMrBlRmv6rtKXYz+4W+gGHlWzj/YBDVdZJlNN8waz6ruRK+nFXzIlaaM
	 8Jy78NPFTD+OSSrK5LsCNoRunU1js6dx9Do6sTs7b7w3dZ1SlEPOVyqP5LonrlhTPax/r
	 dH4SGNhWdJhbz3v5NrGrn721d3yfh1sum/SWK5DSymsNLL/h6xdBMh3HLXfkKKIRp0FGq
	 /6qmQvLhVEp42VjYlY+3D4Tiuzm51RBzqKMZACeTVVWE3GiBUGMalZfI8GsRWbuvFrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474819;
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
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-HPE-SCL:X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=1mcQAul5Mjb/lxtVyGmtEm4HMOv1ZBLKWY8QvdXTCyM=;
	b=boT9ULIv0Uny1D79Jt5MINY828Iq3HTpotVfIyBnH2Lzts7SNMoY0JMFdOKk+WbFoD/x
	 mht9/+D2bknvH6pLVjTTgbjqYgne0lLgZKLciot04gi4SjV+jpwa9baRiuOerlcZGmY2T
	 cDDUBZHnWnbUbG1vIbxgm4ngjzwj6OGbTftjDp72bAMSfItzVzQwhx0QFzg4T6/qCNZ9Q
	 m0QVauaw5pr/xM84SPrBn1LIhD/NLFWqybwRA5FMZ8Veik1f+d3QjDF/IGxlK42fF86fe
	 k+ScbMNx1VsdxJrGAnfkKnSJB/bzC66IfkXmUbX6cNqrLVL9wQqnrhkoaF6GM03x/Yw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=VHlnNhF9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6046606A31F;
	Sat, 31 Oct 2026 19:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6046606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=VHlnNhF9
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJEiK81023313;
	Sat, 31 Oct 2026 19:26:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=1m
	cQAul5Mjb/lxtVyGmtEm4HMOv1ZBLKWY8QvdXTCyM=; b=VHlnNhF95E57CFVFHv
	qMOm9dy/aqqEPlO4a2cNNaMeNzJ1MPeI8UksJPzhPvRHnMIS9s7XeXr1kcQFQ3fD
	iBQP9iXgo9MPzavtj1ddijvktPNK/6Y+oATXJTOOo9yW1Ww8cRWyZ6F2UffFND6a
	CwcOWrhqHMT0Xkw4Lx3hJ3XyqD/KoAtdncZW6a7tpb/5Fsf7qYdsX2iXGj/cUHx9
	YGqj61Wv6gCjS/dM1cz08DGH6e7QUkfRhaDCGyI62KrsL8rFH5J/frYV6pW6s8/2
	0IiYLCRUwsMRbK6QYwUBhLGo2F6qzlOAT0KNlVK9QVREzDhHsrdsZj9R4aAFSBnI
	7Ipg==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4hnp4er645-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:26:58 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id C44F1800EDC;
	Sat, 31 Oct 2026 19:26:57 +0000 (UTC)
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:57 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:57 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:26:57 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q5YuHzbBGVkm+pJxukZyvg6bh9Wz2V2DWzbfUFCzQ9aEEdsvfc2OHVYuUFWIQOaOSLfUHUmeGlJek2L3NiqoiCRa252p13GZzm4ukH5zxRUS2+eWxIdw6ARSUnxOEmih5C+0ToV6GOzG2DUi8pFvrct2xC8V/T/8Xfigh0IpBofSx7J+2urSOQobRbyu8wpmwkZcion7e+qs4UtX3MuflzYzsEl3qwZIeeNhCdBa4IC91UylCD9E2gUKOFRNn/uSmuS5lejIZW3vLfjh8krjhGVulJl4vhMpzWU4rZuPv8Q8kgBBLtUUeWT0eV6vvtbp1NV4C1Q0M7lvLHnKllos8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mcQAul5Mjb/lxtVyGmtEm4HMOv1ZBLKWY8QvdXTCyM=;
 b=IizMabGJ2L3BmjdWMgQ63Mw8ZyRWgvUHwPv+XbO8pqmalSsqjm06srkdHNgG4SxjlnFuJRfxgalWvaQpyPjMF3HkQR1DX+Jg5KnEfe1setpwEtXbrHmM3NEjtvkL2pLgXHLIhsAMEywdezpjyF1wGMZUuau+Ui36958baEzrx7VA4mnsa0+F2Qrb2tnSeMoEBWIqYXHf5FtONJkGAqKGvcmnS/8WtvcW+SYbOpsVSN5UlPOdwVuSFGt0t/bKVD09r7DBoOJmhp0mlvo7lI/7lqLCb8khyTegxT464hk0yzVU7A2aF0j2et0coYiRsjzsImOzQ3balWlMdxnLzaWJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:55 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:55 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:26:00 -0700
Subject: [PATCH 07/12] cxiverbs: add the provider and device discovery
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-7-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Mamila Santosh <santosh-kumar.mamila@hpe.com>,
        Iraimani P
	<iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0171.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::26) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|CYXPR84MB3613:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ccaaff5-b381-4fbf-5cfc-08df3784ec45
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|261009223027099003|261028144727099003|261021121427099003|261026121527099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: RLLcfY1uVrFmLsOs2SgdP+425TxiQBHAWrkZMGbWsZ2qUWAYs5saydZB//AAvTIGJTnp2mgGReb9DEigf9xuTUxm3LSuP01HxwdHScitcnC1RPAry5JD2lhAa3EGW6+ZZj0LlAJmdjm3bT41EDfXRKLVlXcDyIv5Bu/A6W+4mAMqxmEsLrKYAem7984JC860H2xXHba26EXrDD5Qses3LPQ//MVKwi4QS8Ehd4WbL3WcN6w4WMofW3MF3MztNPxO+gI88bAI6GWQG3qqiy0cVYmQred8Y5sCCVJxRD0Bzx+6ziW5E6zeqx75GCr3CExU25CSZPwAcG7kHjRyRyP3AwOFRGniGChlQKHLoZQxE1Py52EqHX1t9SQPZJdIPFQt/rU+l8lgas2oe2FsqhqQ1vhIPjGo4G+BbJSo4t4V8zKVv7K3Gs5cUYexuc20GxFasjcxZVVpZl+o92kHYDO/ufhsCm1RZy6DpHtddytNXDq0b13zSz2poCBgvvv7z/VS70W+tE46l6c/c9GjllIgIiMhO7ziRopZauiDDDknPW2p/LQCxbgz+pucnp6Azo7Zu//BdXWsB0NXl7psfHlkU8B4kX4TAYgoYDxBtW3UiykUZtfOEXHWzE7Sgfl51SQrjP0mLfQLjNguNIoIKq9zeLvS8JaR4Q/4wtrdAh6Tc6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261026121527099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEZEWVY5ZTVnM0pvdTNCZHkybS9jS0x2alNlSDNqcTlueVZ2b095T2gxaHAr?=
 =?utf-8?B?RjVPUmRoajhwTzVBSW90WWZucFdmY3g5K2ZiblpjTXpvbVU2VUYwRjFNMWFn?=
 =?utf-8?B?U3p6bWJnd2tsKy9kOGhWb0JqVW44eE9NOXdvQUNQS0JkbGNERFIzVjQrOUNE?=
 =?utf-8?B?UnVmVFMzcThvZVgzK0lzVnp1RmVVbm5PaysraURKQlVZM203Z1ZnekNFekZT?=
 =?utf-8?B?YUtHaXcrUjhJQVB1a1B6OWpmR1h2NXhMTEhUK0N0RW1hNWNoMUlYQm1vaUhu?=
 =?utf-8?B?OGxnd2dDSi9JVWNoN1JhbFFMSWthQkJHcDEyakdSZStSRXdVKzB5aS9QemF1?=
 =?utf-8?B?eGlQNUhuRWVhRWhnYVdMOHEyMzloQUFTVW82M0pHcm1NalRCQmhWeXBieXI3?=
 =?utf-8?B?eUdId2xJTWM0NXZseGZUb04rcEd4eEEzQklFc0dFcmtUNkVzUVlIdzFqUWY3?=
 =?utf-8?B?eXQ2SDBhRGZ3ZFBTRHpQTE5PRkRvVkV4U1grZ1BjUzlXYTZmMXNuejJOZGt4?=
 =?utf-8?B?OTMwTDNGT3E2OE5SV0NoaVhKRDBpR2FVTHJJMld5bkJsLzU4eUFMVzZzMnhY?=
 =?utf-8?B?THdmZEIrT282QXgxVnh1UGZSSjdTYk52eEM0dmNFVHZEZVhhRVBTaXo5Vlow?=
 =?utf-8?B?Q1V0VlpoZVF3czFDQjd5SlBNYldBWW5rS0UyakZwekRvbDZlNi8xQmFxOUlV?=
 =?utf-8?B?eDltVTlZNm8vSFRSVTJodUIwcy96c1NyTHVSMVY2R2tNYmR4cHcwKy9kTVRR?=
 =?utf-8?B?N1dXWVQ2WkM4WHdhdzE5TFJod0MwY1J0Ry9WNGhrdGgvQkgvZ0xpMjBVVXls?=
 =?utf-8?B?V0FLMUN6ZFpHUnZaOTFvV0FqT1Q5N21oQjNkS3Jxc25jSEFVQjhPR0NnQXlp?=
 =?utf-8?B?ZmEvcmNuMGVYVzdsMVc3dHVUOVZYM2tUR3hvcjRhMGN2NUZRakRxaWxhLzd4?=
 =?utf-8?B?WGREUHRYZ09iOWMwVW1oRm01VXRJM2Y4b2l1Z01CcjRWWEdlQzU3UFBvRFJB?=
 =?utf-8?B?RW9ORytCQVR6SSs0Rzd5N0t6Z2Frb1F5c0tVeTV5Kys1ZkJ5TllnWG1tSWpV?=
 =?utf-8?B?VlgzTERaRkNrck40UkZiMTJaZ3puOFJDUVRJUEhYUWJWRVpOS1p1SEFSR2pl?=
 =?utf-8?B?U3NYWkozTWdRYWc3Qm9BN1ROVHhmL0o5d1JpbnJkWHMzTHRnSGVXMWhjdzhz?=
 =?utf-8?B?NlVCYnM4TVYzZWxCeVhqR3hOay9PRnJtTDA5UUh4S0xCZFJlNElGZ1JQa1BR?=
 =?utf-8?B?RVJOZUpBQXFjTm1Ib25Cd1NDUWlhZWRwKzJyOHJnR3A2QytQbVBRcWVxNGYw?=
 =?utf-8?B?VG1IaWkrT2NTd01McUFhV3JEdHFFNGNYNmVDSHFzaDB0OStBeUNqRjR6UVZS?=
 =?utf-8?B?UzMxbkNJMDVtSE5GcFN5UEZNWm9OTktMcXJaQmt2bWpHc3ZSd3AyZU9aOHFS?=
 =?utf-8?B?VkFhamxKYVhTUC9zZFNzaGR2bUJvYit1NGdXQWJhbGhNTFdHTGFVZFhsZGFU?=
 =?utf-8?B?YXZTc3F6dDZOTGxFN0gyVjhrdVpTKzR5YUxOa3d0N1hJKzllR0V3Zi8vQTFK?=
 =?utf-8?B?eUJxNFB4Z09HOXVBTDNQQ0N5cE9zTmpTOXRrVnZVWFBURWF1MXRYWlhFL1Fs?=
 =?utf-8?B?ZDdBUnJpUExObEVvRUtPTXpodkR3ODlUR2hRVmFFcFRrODZrYlNVZk5DSHY5?=
 =?utf-8?B?dG5ETVB3K0lVRTVyRDFsQ2xMREZ3OE9UMlgwL2pleG81cGE1dHRPNm05MWZk?=
 =?utf-8?B?OXQ0ZWxnK3AwT0NMTkcyNGF4blBzcjdWUWF6SUEyREhPSkEzZ2J1cUk3R3p2?=
 =?utf-8?B?Nnp5NzUrb05kSW5Uam5vNk5pcUJSZ0hlWWhXbVYyMVpuUFJtTHRyYWRXditH?=
 =?utf-8?B?TmtQWGc4TDdxdGJpazNqSk9Dc2tOZSszUkhOQmtaQU9tbWFoV3JoMzdrcTNE?=
 =?utf-8?B?WENvRys2YjltcWQzNUc1Zjk3Vzkvdmk3UU4zWklZZGszTUcyUWI5TFZmSTFG?=
 =?utf-8?B?NjhuTTdaeWhvUGM1elBMMEpLZkpCcEsyM0daVGYwVER3UDRnd0hrcUVJKzBW?=
 =?utf-8?B?T3lUUVpGbldvdXROWTRDcmFrQWlHazlPOWJCREdLVHNkL0FRVklGZnVGWVAx?=
 =?utf-8?B?b0ZsSzVRNlRXWmlvMFNVTEtZVnJpTWpyWFFjQ2VnZnBpYlhzcEpHbzZoV2pm?=
 =?utf-8?B?MDJJelZGaDJYeGdCZHJQQy9hd1gxckdzcjUvazdTek5aZy9HSzVOWkJwd3di?=
 =?utf-8?B?WTFIOSszSDRleW8wSUxLejVQT2hiUlNmUWlEU2lDdDYwRnRVekZVaWZLTWNR?=
 =?utf-8?B?MGc1ZkhVYzZWS2F0djhoSzdpK3hCY2NPUUlLMGZPQVdRZkZkSG96Zz09?=
X-Exchange-RoutingPolicyChecked: rAiXmq0ZscHVAcsYul1GFBf4gUb8/HrGoS4vzx0NeLDA9rCgixQ4lyU5jkKRgynbTdv+VwX7TS5vLVCJag85e67qNjKwlOQ+3eZ0hEB5m6FCN0p4q/JxF4Tc26Zn7y1TAfxCC161wyk/PNXU/BtfNjlAa7OCnqkZZAIZC6Tzcl/BSbQ0YyGJ7pQWpOS3GVQmOjRfiIXXSoghlAac0H5vqxCNkzbsr5yFDqK0KNZChZVzY1N1bZPpSA6EqDWHNxQDMucTU1eKIEGxHB3L7gSHoFqqqvaecEeELOUX4LA9z87xsvIRODTCTbx7l6WwHfnDptAUeKlWYjtLxdbyEXVu8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ccaaff5-b381-4fbf-5cfc-08df3784ec45
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:55.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGJHLMRhXY09uK0Hjpj0vUyaAvOK5/C3BFIaxkLGz9maIAQ01UXlAjWaAgoy/oe1dcyh1uSErdBpX76FdE2WxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: kCBWVQd2yf32_UGNHK3w8YK77rUtFWIs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX5A6ypDq0DLhJ
 fLbJdyHLCgjZPIxIBUVn5i8O+jB9Al8D/ugvj1kDg2X5YhuddbeCbg/p3g6kkYzUbFxp+CIjYfO
 OVpV/5Toeqv9o/0HJa5A1HCTPTnWzFTOECl6xiVPgUZ9U2rialECaaTvItfTH6ztytroLevmUjb
 /ll4P+7Ed393yODoSTsGBQImBBdXoyHAzmWx/VyWsRZLrWksoP1HCXcXAM+M3mqMwRbDMvgIBI0
 8AIwxTwXGhHCiCPFxrhrRK2ycEKiIeiSmTnE0h4gAUPD3dkqmSVQNZZ89FqOP2och8IT9mB8xxy
 OnifhmTUd48Yu1mjJPUtpfQn4ys5P+0a3gSU4MUK0MNwLo2Y+CqDYVCHxcl/yfAzOjSgV2XMhRZ
 OCTmdA5bqZPPRUifV3UppNATV3PM55LAVVJgqLHbv7DMapM5I8FQGsyh7tjMhoBPdBDdcw3Hey1
 6J5nNd4CLubL6Zrt3Hw==
X-Proofpoint-ORIG-GUID: kCBWVQd2yf32_UGNHK3w8YK77rUtFWIs
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfXwG8qVPcpf+e9
 b8mjN5IXRCii5XJCkSNky3EflbhS65z8nTDYu8hk/EYzvmi/GhcDj2en7S3SSw2+WORXMcrIgNn
 FaOqQo+sfLPtzBYyNkv+aDtM0b65HJg=
X-Authority-Analysis: v=2.4 cv=XPGl2ghE c=1 sm=1 tr=0 ts=6ae64102 cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=J0OTuHAx6l5K1fCpvPfz:22 a=MvuuwTCpAAAA:8 a=FqZ-w3q0ZkHm_XU5yJgA:9
 a=QEXdDO2ut3YA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310077

Add the provider skeleton: registration with libibverbs, device
matching, context allocation and the context operations.

Allocating the context takes the QP table and MR list locks; a failure
of either pthread_spin_init() is now handled, destroying the first
lock if the second fails.  The context free callback is registered in
the context operations so ibv_close_device() releases the provider
context, the verbs private state, the file descriptors and the device
reference, instead of falling through to the default no-op.

Co-developed-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Signed-off-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 providers/cxi/cxi.c | 196 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 196 insertions(+)

diff --git a/providers/cxi/cxi.c b/providers/cxi/cxi.c
new file mode 100644
index 000000000000..7a71740042e6
--- /dev/null
+++ b/providers/cxi/cxi.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Copyright 2025 HPE. All rights reserved.
+ */
+
+#include <config.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <pthread.h>
+#include <sys/mman.h>
+
+#include <infiniband/driver.h>
+#include <kernel-abi/cxiverbs-abi.h>
+#include <rdma/cxiverbs-abi.h>
+#include "cxiverbs-abi.h"
+#include "cxi_verbs.h"
+#include "cxi.h"
+
+static const struct verbs_match_ent cxi_table[] = {
+	VERBS_DRIVER_ID(RDMA_DRIVER_CXI),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_CRAY, PCI_DEVICE_ID_CASSINI_1, NULL),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HPE, PCI_DEVICE_ID_CASSINI_1, NULL),
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_HPE, PCI_DEVICE_ID_CASSINI_2, NULL),
+	{}
+};
+
+static int cxi_query_qp_semantics(struct ibv_context *context, enum ibv_qp_type type, uint32_t port,
+				  uint8_t sgid_index, struct ibv_qp_semantics *sem, size_t size)
+{
+	if (port != 1 || sgid_index)
+		return EINVAL;
+	return ibv_cmd_query_qp_semantics(context, type, sem, size);
+}
+
+static const struct verbs_context_ops cxi_ctx_ops = {
+	.query_qp_semantics = cxi_query_qp_semantics,
+	.query_device_ex = cxi_query_device,
+	.query_port = cxi_query_port,
+	.alloc_pd = cxi_alloc_pd,
+	.dealloc_pd = cxi_dealloc_pd,
+	.alloc_job = cxi_alloc_job,
+	.dealloc_job = cxi_dealloc_job,
+	.query_job = cxi_query_job,
+	.insert_addr = cxi_insert_addr,
+	.remove_addr = cxi_remove_addr,
+	.query_addr = cxi_query_addr,
+	.export_job = cxi_export_job,
+	.import_job = cxi_import_job,
+	.create_jkey = cxi_create_jkey,
+	.destroy_jkey = cxi_destroy_jkey,
+	.reg_mr = cxi_reg_mr,
+	.reg_mr_ex = cxi_reg_mr_ex,
+	.dereg_mr = cxi_dereg_mr,
+	.create_cq = cxi_create_cq,
+	.create_cq_ex = cxi_create_cq_ex,
+	.destroy_cq = cxi_destroy_cq,
+	.create_counters = cxi_create_counters,
+	.destroy_counters = cxi_destroy_counters,
+	.read_counters_ex = cxi_read_counters_ex,
+	.poll_cq = cxi_poll_cq,
+	.req_notify_cq = cxi_arm_cq,
+	.create_qp_ex = cxi_create_qp_ex,
+	.modify_qp = cxi_modify_qp,
+	.query_qp = cxi_query_qp,
+	.destroy_qp = cxi_destroy_qp,
+	.post_send = cxi_post_send,
+	.post_recv = cxi_post_recv,
+	.post_recv64 = cxi_post_recv64,
+	.attach_mr = cxi_attach_mr,
+	.detach_mr = cxi_detach_mr,
+	.create_ah = cxi_create_ah,
+	.create_ah_ex = cxi_create_ah_ex,
+	.destroy_ah = cxi_destroy_ah,
+	.free_context = cxi_free_context,
+};
+
+static struct verbs_context *cxi_alloc_context(struct ibv_device *vdev, int cmd_fd,
+					       void *private_data)
+{
+	struct cxi_alloc_ucontext_resp resp = {};
+	struct cxi_alloc_ucontext cmd = {};
+	struct cxi_context *ctx;
+	int ret;
+
+	ctx = verbs_init_and_alloc_context(vdev, cmd_fd, ctx, verbs_ctx, RDMA_DRIVER_CXI);
+	if (!ctx)
+		return NULL;
+	atomic_init(&ctx->send_cookie_seq, 0);
+
+	ret = ibv_cmd_get_context(&ctx->verbs_ctx, &cmd.ibv_cmd, sizeof(cmd), NULL, &resp.ibv_resp,
+				  sizeof(resp));
+	if (ret) {
+		verbs_err(&ctx->verbs_ctx, "ibv_cmd_get_context failed: %s\n", strerror(ret));
+		goto err_free_ctx;
+	}
+
+	ctx->nid = resp.nid;
+	ctx->pid_bits = resp.pid_bits;
+
+	{
+		struct cxi_query_device_ex_resp qresp = {};
+		struct ibv_device_attr_ex attr = {};
+		size_t qresp_size = sizeof(qresp);
+
+		/*
+		 * Best-effort: fetch device-wide HW properties (nid,
+		 * pid_bits, pid_count, pid_granule, ...) via the driver's
+		 * query_device response. This is the only source for them
+		 * on the RDMA path (no ioctl/sysfs channel exists there);
+		 * see cxi_ibv_devinfo in kernel-headers/rdma/cxiverbs-abi.h.
+		 * Failure here is not fatal to context alloc: it only means
+		 * cxidv_query_device() will report EOPNOTSUPP later.
+		 */
+		ret = ibv_cmd_query_device_any(&ctx->verbs_ctx.context, NULL, &attr, sizeof(attr),
+					       &qresp.ibv_resp, &qresp_size);
+		if (!ret)
+			ctx->devinfo = qresp.devinfo;
+	}
+
+	ret = pthread_mutex_init(&ctx->tc_lock, NULL);
+	if (ret)
+		goto err_free_ctx;
+	ret = pthread_spin_init(&ctx->qp_table_lock, PTHREAD_PROCESS_PRIVATE);
+	if (ret)
+		goto err_destroy_tc_lock;
+	ret = pthread_spin_init(&ctx->mr_list_lock, PTHREAD_PROCESS_PRIVATE);
+	if (ret)
+		goto err_free_spinlock;
+
+	verbs_set_ops(&ctx->verbs_ctx, &cxi_ctx_ops);
+
+	return &ctx->verbs_ctx;
+
+err_free_spinlock:
+	pthread_spin_destroy(&ctx->qp_table_lock);
+err_destroy_tc_lock:
+	pthread_mutex_destroy(&ctx->tc_lock);
+err_free_ctx:
+	verbs_uninit_context(&ctx->verbs_ctx);
+	free(ctx);
+	errno = ret;
+	return NULL;
+}
+
+void cxi_free_context(struct ibv_context *ibvctx)
+{
+	struct cxi_context *ctx = to_cxi_ctx(ibvctx);
+
+	pthread_spin_destroy(&ctx->mr_list_lock);
+	pthread_spin_destroy(&ctx->qp_table_lock);
+	pthread_mutex_destroy(&ctx->tc_lock);
+	verbs_uninit_context(&ctx->verbs_ctx);
+	free(ctx);
+}
+
+static struct verbs_device *cxi_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
+{
+	struct cxi_device *dev;
+
+	dev = calloc(1, sizeof(*dev));
+	if (!dev)
+		return NULL;
+
+	dev->page_size = sysconf(_SC_PAGESIZE);
+
+	return &dev->verbs_dev;
+}
+
+static void cxi_uninit_device(struct verbs_device *verbs_device)
+{
+	struct cxi_device *dev = to_cxi_dev(&verbs_device->device);
+
+	free(dev);
+}
+
+static const struct verbs_device_ops cxi_dev_ops = {
+	.name = "cxiverbs",
+	.match_min_abi_version = CXI_IB_UVERBS_ABI_VERSION,
+	.match_max_abi_version = CXI_IB_UVERBS_ABI_VERSION,
+	.match_table = cxi_table,
+	.alloc_device = cxi_device_alloc,
+	.uninit_device = cxi_uninit_device,
+	.alloc_context = cxi_alloc_context,
+};
+
+bool is_cxi_dev(struct ibv_device *device)
+{
+	struct verbs_device *verbs_device = verbs_get_device(device);
+
+	return verbs_device->ops == &cxi_dev_ops;
+}
+
+PROVIDER_DRIVER(cxiverbs, cxi_dev_ops);

-- 
2.56.0

