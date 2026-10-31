Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421375;
	b=R5RZcPlGhkrX2tYUWAHWNfHAwK75jaWiJzP/pguq8vbf5lI6uf16GJeqzBHO6hJ4fgdO
	 ngRFVRvs55OQflC1pXEZ5VdB9xDK2t2o8jNyi5i3ZBVxsKWFovJ+b9aoUHbITMQMxCy9D
	 9o0jVHsBkR21Ys9wU8++BlXEM13X7A9afiYOCj4W1e+o/ZDgYIobJPyldHIhohi5g0CFu
	 2tYg8/zlpr15kFOVJuK9LEMQjkCb/znJ+zoYZZ1yy0rYOHvHu4iL2AXbfizvQ5x6cfjQj
	 ZHfFUB32SnKIJB8vuSL9fdvRrZ/ckB/naysKirraOfa9J78PhT5no1KjVOPIXXbkwTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421375;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:CC:X-Mailer:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-LD-Processed:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
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
	bh=UqPN5dEa5yNQE5Qs5xyLnK1z64+EOgR13tHgARJejiI=;
	b=k1+VDbZzvRUaIPZxyuLqWRTaPUepfOGQ99X22XSvfCC27bkmStDDC9eSt0sz+71ZPepB
	 Gy4r0sl8jn3Vco2TwKENRsZBxo26NpcdB75HsV/wqaZ27P7b5JiF0GuR+TYQ3rFHo0WZW
	 jRJDsTu/4quLsx7rGisdAKigjMnJDPVzD1sarob0g7NNvhxa7qWvkxS7DhowzR4Wx2aJ7
	 YwelEC0nmuGX5rrIrXxf/icTlDeHhbBNPR1Ij36ASrUyyNEaW6NZLwe8Atu8EurLEA4Oe
	 wuCo7soKed09XW5GHK8Gtoou0LO+Ik2wJieM02pF4mQO5b1pXq475Y20dwqM7sAQ8LA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b="alPBwBo/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A79606A320;
	Sat, 31 Oct 2026 04:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40A79606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=alPBwBo/
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V44VAv2205853;
	Sat, 31 Oct 2026 04:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=Uq
	PN5dEa5yNQE5Qs5xyLnK1z64+EOgR13tHgARJejiI=; b=alPBwBo/uOeoEGxX13
	/m/+Z9Qk0Esa0xrbfNqFkIyJUEIElCDws3pDkNhHp1bgjs3X9tNzn4qD7pz5B1mu
	fwDaS7WSuxObazRxV8eq+M45dQP6iGZvZh7EkbAWUbYpvSu8KBOFTyLlC51ryx+3
	6kdgEmBzJKIjRQhSrAqAvXavkYs7DTR5rbv92p3gwJjgLnIzMGG6kLpyPV5nE85f
	wM+isIdsxe0YQpuUEdtB4iXFa2wvADcgynkGCZzxt7C1B4YKqh8GfF5Ym10/37LT
	5+hX1Q4eKrW0/Upe0bGVocz/zwJMazOYUYruLjN9Xo3yOwWprndsy8PjC8yN/+NI
	YI4A==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn900877k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:08 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id EDD9B800EE0;
	Sat, 31 Oct 2026 04:36:07 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:07 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:07 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:07 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:07 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9gIxJdlVYzRcT54GkoinzFdJwTyd/8GbloOnKVOXqN3ALcgomT3qR6HdFzBw7ISAV/hA5SzJdScv2q1MSQSszoMa0jvkF6I+n5oRB4kaK7Hi0LVKvP0ff3YrKemcJxV9hpInb4w8u0ABPzTtQumvWNMUIsoYfMNxNkNavOL400c2Ejwc0yNCptLYitrITismKgzSajpTg+BAtj+W7zkhGJ7c5rm8C4oKTwzmtKeqNAlW75OCKXz2x77CqIEXngwAiZQ7p6mm7F+XrASNgv/SRAUrbNFOq/Yz80fJK7CpfnF8V857gF/hmF080pYK6fjCjF9oUgaqSu/eKRJ3L/RHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UqPN5dEa5yNQE5Qs5xyLnK1z64+EOgR13tHgARJejiI=;
 b=fT4pUZEY8FiKM+mB+1ixt59YQSKcB35hImbA+XjGelCdgw+U8egnL4R/lwB0kgwzK7DAeTZca1CN+YO5EQxy2k+5hG8tzkrhosXQpFmpmbC6n8I0c6mGYNDIpXS7L3RgxTm7KwyJ58agGdBbvi6MvTUNqa52qUpylrR8uY+Bbg7tMzYUdyNNK83cYRe4xku7+a1XMEU7iEVw+SVvl9kRE9F0wjJoCvBq9pT+mvIJ50Hco0+xt3aN4rU2VH/C8lYICFl3gFbIy6xKjexZctbkN3Q07dDU2R+SGA9YM8qrvMgqsemc53wGVtQ9RUHQmNa0ZRRvGEVSKoomhI2utXNn8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:03 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:03 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:32 -0700
Subject: [PATCH 04/11] RDMA/cxi: add the native ABI and resource
 definitions
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-cxi-for-next-v1-4-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>,
        Mamila Santosh
	<santosh-kumar.mamila@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: DS7P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:25c::8)
 To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB2091:EE_
X-MS-Office365-Filtering-Correlation-Id: f223bcc0-f48f-40a4-6d2b-08df3708786b
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|3023799007|56012099006|261021121427099003|5023799004|261021135927099003|261021123027099003|261022105027099003|261022113327099003|261026140227099003|261026121527099003|261028144727099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: PU1j1UstajgDe0QW0A/M16kN1cLlo10Kx0/sM9yJdOKCCwrfZ9tCIpYHpGgdKQC3CLvz6Q0SJXh8cvhwHyqN1acTRaheaTHEtTuCIhEJPZoC15t6TVvPNSqTSvRXBJq324SriKITqW3tcFBvx7NHlJlsMjKNv/2wpeu2sAwc7sFRv+JRTuaJQAllGmes5WmTqeELQJiVmhVa1Ialh99sOAEFB9bRqdzUHFBMKjL+wM7xWmI5oaYP1TmmjBTs+/ut3gXKXu5hGDbA30hYJmdsiDcr4jo7/mG6S5uMzfafxiTMZofY0dE6l6IQIWVoI9APNgwHgDcUys6Wt1gptXGj1TkNKc8ChMRiozitmiyhc9XAW+bXu8LEPcqUbv6AHj1uaceCnot0l7OLJqzAs8IILQ9g+DaKthlc75ca635ZMmaGcG2LqnRb8iLseaOCUbDnaxvUkbmCVU3kIBmEOe5PWmvks88emJlOP/FV2lCEG21gPAhCRbeY7y0CFiZ2eo2PQm273T0U7iqVWAtc+c+aDa+xaYQ2DpjFKdsCigFN+zwG8HYyxKZN7MzzCt9Kj6LFhy4Q0DJFr6CIq02Fxzg02k2UJ/WJ01VZouBCAZRbdwopNbP5lSxPIfSkSdJzGKQdzyM5kFux9wt2g9nqXJFDnl5w8T2MISedKewSactnVHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(56012099006)(261021121427099003)(5023799004)(261021135927099003)(261021123027099003)(261022105027099003)(261022113327099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUpUczRobGxOWExMcCtqUGN2MzBHTzd0WTdCMWx4cFRsK2ZmL3ZlTUdEcG1I?=
 =?utf-8?B?RUVHdFpBSWMwUWlYeEYyR1VRUHJnVThsT2JvbXFOdUljMDVOSTJ5akxrQmg2?=
 =?utf-8?B?YnBKVm9RU3ZQSFNiZGl2MkVaRzNiMWRNRWlNTlNhQ2JZSjQ5QVY1Z3FnZlZP?=
 =?utf-8?B?QlQwb1U5M2JKS3EwZXV1b1U3YTNSUXIxNTFvL1NHL3FhQXBZNlNpMU1uL3pB?=
 =?utf-8?B?OXNEL292bzhKb0R6M2l6R1B6bkluRy9TSXpCbXVBeWNIZ3hJblUralV0TW1V?=
 =?utf-8?B?UStsR2liMDRNMnFtY3BFYklxRUV5d2xyR2RMTUFsM29PeW5FaGNPdTJoWFlL?=
 =?utf-8?B?bUJPdS9MWXg5ZVFMTk1VczA1d1h0S3VVek5jcm9nZkRlYksrYUpqc2NLbjkw?=
 =?utf-8?B?Rk5zelpOY01IYVpyeFpuZVdYM3RHS2xiUWJNaGs5NmhnWFNJaVV3anhvYk54?=
 =?utf-8?B?TElHYldSa1BqVy9peldGZUxNeHBEK2NHckZuZy9Ed3ZiaE1URzdTdEJzMUVm?=
 =?utf-8?B?OFFVUWtmOFlYc1ltZUY0Y1hEeVhQMzBnN2lPblpJdlBoOEx3M0VxdTIxeDhh?=
 =?utf-8?B?Y2pVOFhlaC9lWlhpeDQvaUl5RkMyRTBZSHpjeG1YS2JxU3F5aW9IRkxhOG5v?=
 =?utf-8?B?MHVkVWR0c3h4dmJteWY0a01FVkdSNXY4SVg4VTk4R3lTUFNhb01xc3prWm1Z?=
 =?utf-8?B?ZGl1dVVPMEM4T3ZYaVF0MnVmY2hod3BIZ0hRTm5lTmVRV2FmTE0yeS9tYW9X?=
 =?utf-8?B?M0lEZnRRYzlyM3IxVUY2N1BuMjJIUFdZNkoyR045UzNNWWhXT3JISjNvRkpX?=
 =?utf-8?B?Qm5oQVpLRzdmM3o3MEUzRDJRZlZ5SWVwRlFteTdTY0pCYW56YWtvd0duS1hh?=
 =?utf-8?B?WUVGTlQ1QmxRc3htSG16TkhkY1I0TjV2N21HSEZGYkk3dUhMbE8xekR4VTI4?=
 =?utf-8?B?WFlDRlpNUnZ4VS9ZYmw5UHVkK2kwdUF3cDBrLzRwZlFJdWc5cFlxeWg0RlFM?=
 =?utf-8?B?OHV5dklEeGhNeXlic2l5dGxPRnE3YktFay96cnF0OFdSV3hxT25uODYxNGZh?=
 =?utf-8?B?a0JoaXNPbU1yVExNaUFOUXF0ZVhqKytkZ285ZmhrRnJoVXNkN2hrV1krWWdw?=
 =?utf-8?B?U0ZpS0czNENsbmZJOXByMzlPK1Vobk51VUhwSm5PTm84LzlJMmt5YlNiN04x?=
 =?utf-8?B?MVBaY24raXpHRDBDcmFKYVJiTzh1SVp6Y3dJcisyTENWVEYvTEtHRnZvSVND?=
 =?utf-8?B?aFZJRjFMcDdLa2U0M1ZXZ1ZzL3NUMjZYMEpSR2F6Z0FvQWl3MktYR1hsZStz?=
 =?utf-8?B?cjE5L0hrMmRjaHAvY3N2Rk5kblhKd2NEbjhNams0TGRvTXRHc3pkSktkR2Vl?=
 =?utf-8?B?Y0VHKzA1cVF3K3hUQW1JSDROVDErMWRaQ3N6Wlc4ZHhFaEozZ01Qd3h3eS9O?=
 =?utf-8?B?T1ZRKzZwbmFOWVF5NmlpbmVraVVsSXppNVBMcFJqUEJLRUhFWHN6UUNxaTRE?=
 =?utf-8?B?YnM5NFZIOU95VVU5MWRaZm5wMjYwU09JcWJlbWFOMXRhc2k5V1BMQ0RCUmE0?=
 =?utf-8?B?VXEzS3BGbjZUSFFJRktiL0pFN2ZqTWtNTDZmQ0hXSzBZN3ZFMk5KNWNZM2Rh?=
 =?utf-8?B?a2NLVUZSSzRNSU1QRGVZREw5bnBaSkNQNVMwQnNBSGRxb2VVN3hnNVJTd2JH?=
 =?utf-8?B?ajhZQURjckszSkE4TTdvL1IxTm0zQWMrK1hnK2tSZXRqTUdxdUY3WHdycHpD?=
 =?utf-8?B?V0NXUXV3S2NMdFFyalJqQmUrbmRSSXlWMmdFdDREQ3NSeDNSRVFvbTdpczU0?=
 =?utf-8?B?ZDhoYkFndU8ySXk4c3NvZS8xUlpNbi9kRzJYNWdVQmlBeDNnWk9WOXAzZ3gy?=
 =?utf-8?B?akJROGloM2g5aTcrS04vd0tGMVFWdlZKQjUxbjhpOFV2RXVaL0tIeWcvZlUr?=
 =?utf-8?B?UnprY3MzL05BZ2h3L0FuVXV3MlV3OHdQZUt5TVY0MTQ3L0hDY2E4RXlZbkli?=
 =?utf-8?B?cGt6blFNcW1CNkx0YUxWSStUVllCNDhUSCt0V3JhcE1RRGg4UUw3bm5BS2JB?=
 =?utf-8?B?WnFRemllTG9xWms3NDJ6Qmg2THBNcURpNzFWdUwxR3NtNmRhYkxtdWswdVYv?=
 =?utf-8?B?VFhhU3FQay9MR1VjbGYwTDI1MEhUT1VDZkg0VEE2dHlreW5Td21JSzFrYTNn?=
 =?utf-8?B?VXU4cHd5NU41TWx1amFjaXpzOVh4WTRUUlgwVmk4WXZPUlhQOWRKcjhNWXFw?=
 =?utf-8?B?Wk55Z3cxK0k1T01xM00wL1B3RklVUDFTU2x1TUh4L0ttay9IWmg4eUcxZ0Zm?=
 =?utf-8?B?TFBhRTNRRkpIWGZZb3VJblU0aDBPallpN3gzelhPVUViejVjd3FqQT09?=
X-Exchange-RoutingPolicyChecked: 2snUA6WbeFHMvzY0W5p1wv4PhU7wxSHCi5LrpFUmjIcKuhktK6sbagEZ5if1PRmOWHNzj/myl6wNrAyhokTIdP0250XJke7hmxCcaDT60EG3eh0STEeDZl4e2PkmXiPD9EjvsAldk7V8mi8CdMPOFM4weBskT7W+/rVc8XEWveE7OzJOM3XMtNF+k7wXyjsVPPgUPqMhEaUSujJ3rc2GzQmv6wBMBTOI0KpDpTs6ETRiT8ChSZNJEsp0zM3WntRiuTOx8/jf7h6OumDAPTI9UodRwcDjm/3HiU+hjFqpsotY6eOoAq35I6rfKvIly5MMXcDmlVf/vxch/UKoeHYymg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f223bcc0-f48f-40a4-6d2b-08df3708786b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:03.4422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GprhxFyJTyNP/RS3wiYcreDMQabPhX23+AKzTBXJczWDNFKDTd31OJ2BnpGY30uXP57MjO7ublSJBSCNHD+bHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=J5I/fwnS c=1 sm=1 tr=0 ts=6ae57038 cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=k7r4yCLl9DVLXMiQTbtC:22 a=MvuuwTCpAAAA:8 a=K6LNPjSUBLwEP7splgsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: iMkA4zSjwWRipbFG0XRXenBWjnZRriz-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfXyLx/bJXLYA5U
 f6M+pRB7aGoQkQOGpzNJz2pidwwKJ9ANFYS4U930rq8PXkklSCakH3zTbYNQvj6G+k1L/JO8tCX
 Gx9XBCzHIhUzjtQ3zO0IRc1lKnWTZ7HFWlgoAQbb92LL7u/lpV9abrP7o9NQn8QswWaGO7yWVsW
 s2eCcorcbnBQM0zCf/aPkBKaq7yxQq2M235ISACur+8rrSv7N50fHJKtDTXVu80ifxy3/lQ+fnW
 wvrMhmPBQwaYND1IS2NQhCQEJEF0R9CltqX9eGEtl7P/nPPTeqn6Js/O/CyPbDCfXrayOpL8R3N
 zoKpuO8/wSCvODJuJYGARej87CSxFp0hRZHwAdUlhIca+i5P6yL4I9QAC2at1lboV4yvnoBBjz+
 32CY507JD75n+5khGGwDKHrpjTHdbAbJqjkzqhq1c63DkVgdcKarki3I1JsqndfTTIgYRDS+79r
 DcDQO5snn0yuSu08l+w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX5agBIB3AX3Ob
 HerppnKYuA1k7PLYwZvu/d7FKXYOANrAwLbJS5Q3lDcS0Ln4TnItCjahabtYdTrrnmK8ejKGn/f
 nJHMcze/kRdSQRKl6DJhxmJGIscrzAo=
X-Proofpoint-GUID: iMkA4zSjwWRipbFG0XRXenBWjnZRriz-
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Start the CXI RDMA (cxiverbs) driver, which exposes a Cassini NIC
through the verbs API using the UET reliable unconnected (RU) queue
pair type, and add its private structures and its user space ABI.

The driver sits on top of the cxi-ss1 core driver as an auxiliary bus
client.  It does not drive the hardware directly: it calls the core
driver's exported CXI interface for everything.  cxiverbs.h holds
the per-device, per-context and per-object state; cxiverbs-abi.h is
the ABI shared with the cxiverbs provider in rdma-core.

The ABI is built around explicit resource ownership instead of a
single implicit context:

 - the ucontext is bare; the CXI service, LNI (logical network
   interface) and PID are allocated explicitly through private uverbs
   methods and are not created as a side effect of opening the device
 - the PID is device-wide, assigned by the driver and bound to a PD
 - the application's service index is carried in the resource index
   bits of the QPN rather than in a core object

QPN layout (UEC-aligned): bit 31 selects absolute (1) or FEP-relative
(0) addressing, bits 23:12 are the resource index and bits 11:0 the
PIDonFEP.  This driver supports only job-relative QPs for now; requests
for an absolute PID or an absolute source QPN are rejected.

Kernel-generated remote keys are limited to 48 bits and always have
bit 31 set.  The ABI version is 1 and has not been published.

The Kconfig and Makefile hookup for this driver is the last patch of
the series.

checkpatch --strict (100 columns) still reports the following in this
patch. They need coordination with the internal repositories this code
is maintained in and will be fixed in V2:
- CHECK: PARENTHESIS_ALIGNMENT (18), UNCOMMENTED_DEFINITION (5)

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Co-developed-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Signed-off-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs.h | 443 +++++++++++++++++++++++
 include/uapi/rdma/cxiverbs-abi.h     | 658 +++++++++++++++++++++++++++++++++++
 2 files changed, 1101 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs.h b/drivers/infiniband/hw/cxi/cxiverbs.h
new file mode 100644
index 000000000000..11a8d218d879
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs.h
@@ -0,0 +1,443 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2018-2025 Hewlett Packard Enterprise Development LP
+ *
+ * Internal header for the CXI InfiniBand RDMA driver.
+ */
+
+#ifndef _CXI_IB_H_
+#define _CXI_IB_H_
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/list.h>
+#include <linux/mm_types.h>
+#include <linux/mmu_notifier.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/random.h>
+#include <linux/refcount.h>
+#include <linux/xarray.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_umem.h>
+#include <rdma/uverbs_ioctl.h>
+
+#include <linux/auxiliary_bus.h>
+#include <linux/mod_devicetable.h>
+#include <linux/hpe/cxi/cxi.h>
+#include <linux/hpe/cxi/driver.h>
+#include <linux/hpe/cxi/cxi_prov_hw.h>
+#include <linux/idr.h>
+
+#include <uapi/rdma/cxiverbs-abi.h>
+
+/*
+ * Default CXI service ID.  Service 1 is the system default created by
+ * the cxi-driver with an unrestricted resource grant.
+ */
+#define CXI_SVC_DEFAULT 1U
+
+/*
+ * QPN field encoding (UEC-aligned)
+ *   bit  31     : addr_mode  (1=absolute, 0=job-relative)
+ *   bits [23:12]: Resource Index (CXI pid_offset within the PID slice)
+ *   bits [11:0] : PIDonFEP  (process-endpoint address)
+ *
+ * The Resource Index is the application's own receive-bucket selector and is
+ * unrelated to a CXI service ID, which only names a resource-limit pool.
+ */
+#define CXI_QPN_ADDR_MODE_MASK   BIT(31)
+#define CXI_QPN_RI_SHIFT         12U
+#define CXI_QPN_RI_MASK          GENMASK(23, 12)
+#define CXI_QPN_PID_MASK         GENMASK(11, 0)
+
+/* -----------------------------------------------------------------------
+ * Per-device mmap entry: wraps rdma_user_mmap_entry with driver context.
+ * Heap-allocated; freed by cxiverbs_mmap_free().
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_mmap_entry {
+	bool admin_only;
+	struct rdma_user_mmap_entry rdma_entry; /* must be first */
+	bool            is_io;      /* true  → io_remap_pfn_range (doorbell) */
+	phys_addr_t     phys;       /* IO mapping physical address */
+	struct page    *first_page; /* first page for buffer mapping */
+	void (*release_owner)(void *owner);
+	void *owner;
+};
+
+struct cxiverbs_job_tc_binding {
+	struct list_head entry;
+	struct cxiverbs_job_entry *job;
+	u32 svc_id;
+};
+
+struct cxiverbs_tc_entry {
+	u32 key;
+	u32 tc;
+	u32 tc_type;
+	bool created;
+	struct list_head job_list;
+};
+
+struct cxiverbs_job_entry {
+	struct ib_job ibjob;
+	struct ib_job_attr attr;
+	struct xarray addr_table;
+	struct mutex addr_lock;
+	u32 job_id;
+	refcount_t refcount;
+};
+
+/* -----------------------------------------------------------------------
+ * Top-level RDMA device container
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_dev {
+	struct ib_device  ib_dev;
+	struct cxi_dev   *cdev;      /* CXI public API handle (cxi_adev->cxi_dev) */
+	struct cxi_adev  *cadev;   /* auxiliary device (PCI access)             */
+
+	/* Device geometry – cached once at probe time */
+	unsigned int      nid;
+	unsigned int      pid_bits;
+	unsigned int      pid_count;
+	unsigned int      pid_granule;
+
+	/*
+	 * Full device-info snapshot, same source as the above four fields.
+	 * Surfaced to user space via query_device's driver-specific response
+	 * (cxi_ibv_query_device_resp.devinfo) since the RDMA path has no
+	 * ioctl/sysfs channel to fetch it on demand the way native access does.
+	 */
+	struct cxi_dev_info_use devinfo;
+
+	struct xarray jobs;
+	struct xarray tcs;
+	struct mutex jobs_lock;
+	struct notifier_block nid_notifier;
+	bool		  ib_registered;
+};
+
+/* -----------------------------------------------------------------------
+ * User context (ib_ucontext)  →  JobID-anchored LNI
+ *
+ * The ucontext opens first. A later privileged Job allocation gets or creates
+ * a refcounted device-wide JobID entry and binds this open context to its LNI.
+ * All PDs, QPs, CQs, and other resources share this LNI after binding.
+ *
+ * No per-service approval cache: services are selected per-QP at creation time.
+ * Job/JobID_end define the VNI/authorization range for this process.
+ * -----------------------------------------------------------------------
+ */
+#define CXIVERBS_TC_MAX		8	/* 0–7 traffic classes */
+
+struct cxiverbs_tc_limit {
+	u32 tc;			/* traffic class 0–7 */
+	u32 max_ptes;		/* max portal table entries */
+	u32 max_cps;		/* max communication profiles */
+	u32 max_qps;		/* max queue pairs */
+	u32 reserved;
+};
+
+struct cxiverbs_counters {
+	struct ib_counters ibcounters;
+};
+
+struct cxiverbs_ucontext {
+	struct ib_ucontext  ibucontext;
+	struct xarray lnis;
+	struct mutex resource_lock;
+	struct cxi_lni     *lni;		/* JobID-anchored, per context */
+	struct cxi_adev    *cadev;
+	struct cxiverbs_job_entry *job;
+
+	/* JobID anchor, valid after privileged job allocation */
+	u32                 job_id;
+
+	/* TC-based resource limits (per JobID) */
+	struct cxiverbs_tc_limit tc_limits[CXIVERBS_TC_MAX];
+	u32                 num_tc_limits;
+	struct mutex        tc_lock;
+
+	/* PIDonFEP defaults (optional) */
+	u32                 default_pidonfep;
+	bool                default_pidonfep_valid;
+};
+
+struct cxiverbs_lni {
+	struct cxi_lni *lni;
+	struct cxiverbs_ucontext *ctx;
+	atomic_t usecnt;
+	u32 svc_id;
+	u32 handle;
+};
+
+struct cxiverbs_lni *cxiverbs_lni_get(struct cxiverbs_ucontext *ctx,
+				    u32 handle);
+void cxiverbs_lni_put(struct cxiverbs_lni *lni);
+
+/* -----------------------------------------------------------------------
+ * Protection domain (ib_pd)  →  shared JobID-anchored LNI + RGID (isolation)
+ *
+ * PD no longer owns its own LNI; instead it references the JobID-anchored LNI
+ * from the ucontext. The PD can optionally express a preferred_svc_id for QPs;
+ * if not set, QPs can select any service at creation.
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_pd {
+	struct ib_pd    ibpd;
+	struct cxiverbs_lni *lni_ref;
+	struct xarray qpns;
+
+	u32             job_id;		/* cached from ucontext->job_id */
+	u32             preferred_svc_id;	/* optional service preference (0 = any) */
+
+	u32             rgid;			/* RGID for resource isolation */
+	u32             pd_id;			/* RGID-based PD identifier */
+	u32             default_pidonfep;
+	u32             pidonfep;
+	u32             qpn_addr_mode;
+	bool            default_pidonfep_valid;
+	bool            pidonfep_valid;
+	struct mutex     resource_lock;
+};
+
+struct cxiverbs_jkey {
+	struct ib_jkey ibjkey;
+	struct cxi_cp *cp;
+};
+
+/* -----------------------------------------------------------------------
+ * Memory region (ib_mr)  →  CXI ATU memory descriptor
+ *
+ * lkey = low 32 bits of (md->id << 3) | lac
+ * rkey = random 32-bit token (portal match_bits for remote access)
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_mr {
+	struct ib_mr                  ibmr;
+	atomic_t native_users;
+	struct cxi_md                *md;
+	u8                            lac;
+	struct cxi_adev  *cadev;
+};
+
+/* -----------------------------------------------------------------------
+ * Completion queue (ib_cq)  →  CXI Event Queue (EQ)
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_cq {
+	struct ib_cq   ibcq;
+	struct cxiverbs_cq_resources *resources;
+	struct cxiverbs_lni *lni_ref;
+
+	struct cxi_eq *eq;
+	struct cxi_adev  *cadev;
+
+	/* Kernel-allocated event ring buffer */
+	struct page  **pages;
+	unsigned int   npages;
+	void          *eq_buf;
+	size_t         eq_buf_size;
+
+	/* ATU descriptor covering the EQ ring */
+	struct cxi_md *eq_md;
+
+	/* EQ doorbell CSR physical address */
+	phys_addr_t    db_phys;
+	size_t         db_size;
+
+	/* User-space mmap entries (heap-allocated, freed via mmap_free) */
+	struct cxiverbs_mmap_entry *buf_mmap;
+	struct cxiverbs_mmap_entry *db_mmap;
+};
+
+/* -----------------------------------------------------------------------
+ * Queue pair (ib_qp)  →  CXI Domain + CP + TXQ + TGQ + PTE
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_qp {
+	struct ib_qp       ibqp;
+	struct cxiverbs_qp_resources *resources;
+
+	/* CXI hardware resources */
+	struct cxi_lni    *lni;   /* == to_cxiverbs_pd(ibqp.pd)->lni */
+	struct cxi_domain *domain;
+	struct cxi_cp     *cp;
+	struct cxi_cq     *txq;    /* initiator (transmit) command queue */
+	struct cxi_cq     *tgq;    /* target (receive) command queue     */
+	struct cxi_pte    *pte;    /* portal table entry                 */
+	int                pt_map_index; /* RMU portal-list slot, for unmap */
+
+	/* User-space mmap entries for libcxi-style direct submission */
+	struct cxiverbs_mmap_entry *txq_cmds_mmap;
+	struct cxiverbs_mmap_entry *txq_db_mmap;
+	struct cxiverbs_mmap_entry *tgq_cmds_mmap;
+	struct cxiverbs_mmap_entry *tgq_db_mmap;
+
+	/* QP state machine */
+	enum ib_qp_state  state;
+	spinlock_t        lock;        /* publishes state to the data path */
+	struct mutex      modify_lock; /* serializes modify_qp, may sleep */
+	u32               qpn_base;
+	bool identity_reserved;
+
+	/* Fabric addressing configured at modify_qp time */
+	u32               vni;
+	u32               svc_id;
+	u32               ri;    /* Resource Index == PTE pid_offset */
+	u32               tc;
+	u32               lcid;
+	u64               match_bits;
+	u64               match_mask;
+
+	/* Capacity */
+	u32               max_send_wr;
+	u32               max_recv_wr;
+	u32               max_send_sge;
+	u32               max_recv_sge;
+	u32               max_inline_data;
+};
+
+/* -----------------------------------------------------------------------
+ * Address handle (ib_ah)  →  remote NID + DSCP
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_ah {
+	struct ib_ah  ibah;
+	u32           nid;   /* 20-bit Cassini NID of the remote endpoint */
+	u16           vni;   /* fabric VNI for the path                   */
+	u8            dscp;  /* DSCP / traffic-class mapped from SL        */
+};
+
+/* -----------------------------------------------------------------------
+ * Accessor macros
+ * -----------------------------------------------------------------------
+ */
+#define to_cxiverbs_dev(ptr)     container_of(ptr, struct cxiverbs_dev, ib_dev)
+#define to_cxiverbs_ucontext(ptr) container_of(ptr, struct cxiverbs_ucontext, ibucontext)
+#define to_cxiverbs_pd(ptr)       container_of(ptr, struct cxiverbs_pd, ibpd)
+#define to_cxiverbs_mr(ptr)       container_of(ptr, struct cxiverbs_mr, ibmr)
+#define to_cxiverbs_cq(ptr)       container_of(ptr, struct cxiverbs_cq, ibcq)
+#define to_cxiverbs_qp(ptr)       container_of(ptr, struct cxiverbs_qp, ibqp)
+#define to_cxiverbs_ah(ptr)       container_of(ptr, struct cxiverbs_ah, ibah)
+
+/* -----------------------------------------------------------------------
+ * Function declarations — cxiverbs_main.c (Phase 0–3, 5)
+ * -----------------------------------------------------------------------
+ */
+
+/* Phase 0 */
+int  cxiverbs_query_device(struct ib_device *ibdev,
+			  struct ib_device_attr *props,
+			  struct ib_udata *udata);
+int  cxiverbs_query_port(struct ib_device *ibdev, u32 port,
+			struct ib_port_attr *props);
+int  cxiverbs_get_port_immutable(struct ib_device *ibdev, u32 port_num,
+				struct ib_port_immutable *immutable);
+struct net_device *cxiverbs_get_netdev(struct ib_device *ibdev, u32 port);
+int cxiverbs_create_counters(struct ib_counters *counters,
+			     struct uverbs_attr_bundle *attrs);
+int cxiverbs_destroy_counters(struct ib_counters *counters);
+int cxiverbs_read_counters_ex(struct ib_counters *counters,
+			      struct ib_counters_read_attr *attr,
+			      struct uverbs_attr_bundle *attrs);
+int  cxiverbs_query_pkey(struct ib_device *device, u32 port_num,
+			u16 index, u16 *pkey);
+int  cxiverbs_query_gid(struct ib_device *device, u32 port_num, int index,
+		       union ib_gid *gid);
+
+/* Phase 1 – user context */
+int  cxiverbs_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata);
+void cxiverbs_dealloc_ucontext(struct ib_ucontext *uctx);
+
+/* Phase 1 – protection domain */
+int cxiverbs_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
+int cxiverbs_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata);
+int cxiverbs_alloc_job(struct ib_job *job, struct ib_job_attr *attr,
+		       struct uverbs_attr_bundle *attrs);
+void cxiverbs_dealloc_job(struct ib_job *job);
+int cxiverbs_query_job(struct ib_job *job, struct ib_job_attr *attr);
+int cxiverbs_job_addr_insert(struct ib_job *job, u32 index,
+			     struct rdma_ah_attr_ex *ah_attr);
+int cxiverbs_job_addr_remove(struct ib_job *job, u32 index);
+int cxiverbs_job_addr_query(struct ib_job *job, u32 index,
+			    struct rdma_ah_attr_ex *ah_attr);
+int cxiverbs_create_jkey(struct ib_jkey *jkey,
+			 struct uverbs_attr_bundle *attrs);
+int cxiverbs_destroy_jkey(struct ib_jkey *jkey,
+			  struct uverbs_attr_bundle *attrs);
+int cxiverbs_query_qp_semantics(struct ib_device *device,
+			       enum ib_qp_type type,
+			       struct ib_qp_semantics *sem);
+
+/* Phase 3 – completion queues */
+int  cxiverbs_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
+		       struct uverbs_attr_bundle *bundle);
+int  cxiverbs_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata);
+int  cxiverbs_poll_cq(struct ib_cq *ibcq, int ne, struct ib_wc *wc);
+int  cxiverbs_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
+int  cxiverbs_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vma);
+void cxiverbs_mmap_free(struct rdma_user_mmap_entry *rdma_entry);
+
+/* Phase 5 – address handles and GID table */
+int  cxiverbs_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
+		       struct ib_udata *udata);
+int  cxiverbs_destroy_ah(struct ib_ah *ibah, u32 flags);
+int  cxiverbs_add_gid(const struct ib_gid_attr *attr, void **context);
+int  cxiverbs_del_gid(const struct ib_gid_attr *attr, void **context);
+
+/* mmap entry helper — used by main and qp */
+struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_alloc(struct ib_ucontext *ibctx, bool is_io,
+			 phys_addr_t phys, struct page *first_page,
+			 size_t size, u64 *offset_out);
+
+struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_alloc_owned(struct ib_ucontext *ibctx, bool is_io,
+			       phys_addr_t phys, struct page *first_page,
+			       size_t size, u64 *offset_out, void *owner,
+			       void (*release_owner)(void *));
+
+struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_alloc_admin(struct ib_ucontext *ibctx, phys_addr_t phys,
+			       size_t size, u64 *offset_out);
+
+/* -----------------------------------------------------------------------
+ * Function declarations — cxiverbs_mr.c (Phase 2)
+ * -----------------------------------------------------------------------
+ */
+struct ib_mr *cxiverbs_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 length,
+				  u64 iova, int access,
+				  struct ib_dmah *dmah,
+				  struct ib_udata *udata);
+int           cxiverbs_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
+
+/* -----------------------------------------------------------------------
+ * Function declarations — cxiverbs_qp.c (Phase 4)
+ * -----------------------------------------------------------------------
+ */
+int cxiverbs_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
+		      struct ib_udata *udata);
+int cxiverbs_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata);
+int cxiverbs_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
+		      int qp_attr_mask, struct ib_udata *udata);
+int cxiverbs_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
+		     int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr);
+int cxiverbs_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
+		      const struct ib_send_wr **bad_wr);
+int cxiverbs_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
+		      const struct ib_recv_wr **bad_wr);
+
+/* -----------------------------------------------------------------------
+ * Driver uapi_definition table — Phase 6 (Counting Triggers)
+ * Defined in cxiverbs_ct.c; assigned to ib_dev.driver_def at probe time.
+ * -----------------------------------------------------------------------
+ */
+extern const struct uapi_definition cxiverbs_defs[];
+
+#endif /* _CXI_IB_H_ */
diff --git a/include/uapi/rdma/cxiverbs-abi.h b/include/uapi/rdma/cxiverbs-abi.h
new file mode 100644
index 000000000000..8bf7b11acb22
--- /dev/null
+++ b/include/uapi/rdma/cxiverbs-abi.h
@@ -0,0 +1,658 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright 2025 Hewlett Packard Enterprise Development LP
+ *
+ * User-space ABI for the CXI InfiniBand RDMA driver.
+ * This header is shared between the kernel driver and the libcxi_verbs
+ * user-space provider in rdma-core.
+ *
+ * QPN encoding (UEC-aligned):
+ *   bit  31     : addr_mode (1 = absolute, 0 = job-relative)
+ *   bits [23:12]: Resource Index (PID-slice receive selector, not service ID)
+ *   bits [11:0] : PIDonFEP (process-endpoint address bits)
+ */
+
+#ifndef __UAPI_RDMA_CXI_ABI_H__
+#define __UAPI_RDMA_CXI_ABI_H__
+
+#include <linux/types.h>
+
+#define CXI_IB_UVERBS_ABI_VERSION	1
+#define CXI_IBV_LNI_ANY		0xffffffffU
+
+/*
+ * alloc_ucontext / GET_CONTEXT
+ *
+ * GET_CONTEXT opens the uverbs device and returns static CXI geometry.
+ * Privileged ibv_alloc_job() creates a device-scoped job; it does not allocate
+ * an LNI or bind the ucontext. LNIs are allocated explicitly and selected by
+ * PDs. QPs require a job key belonging to their PD. PIDonFEP may be supplied
+ * as an optional default for later QP creation.
+ */
+enum cxi_ibv_alloc_ucontext_mask {
+	CXI_IBV_ALLOC_UCONTEXT_PIDONFEP = 1U << 0,
+};
+
+#define CXI_IBV_SERVICE_ID_MAX	0xfffU
+#define CXI_IBV_JOB_ID_MAX	0xffffU
+#define CXI_IBV_PIDONFEP_MAX	0xfffU
+
+/*
+ * A Slingshot GID is just the 20-bit NID: subnet_prefix is zero and the NID
+ * sits in the low bits of interface_id. Userspace never needs to know that -
+ * it exchanges GIDs like any other transport - but a GID handed back to this
+ * device must fit, or it names something we cannot reach.
+ */
+#define CXI_IBV_NID_MASK	0xfffffULL
+
+struct cxi_ibv_alloc_ucontext_cmd {
+	__u32 comp_mask;		/* enum cxi_ibv_alloc_ucontext_mask */
+	__u32 pidonfep;		/* UET PIDonFEP (optional default) */
+};
+
+/*
+ * TC capacity limits (one per traffic class, 0-7).
+ * Used to report per-JobID resource allocation.
+ */
+struct cxi_ibv_tc_limit {
+	__u32 tc;		/* traffic class 0-7 */
+	__u32 max_ptes;		/* max portal table entries for this TC */
+	__u32 max_cps;		/* max communication profiles for this TC */
+	__u32 max_qps;		/* max queue pairs for this TC */
+	__u32 reserved;		/* for future use */
+};
+
+#define CXI_IBV_TC_MAX		8	/* 0-7 traffic classes */
+
+struct cxi_ibv_alloc_ucontext_resp {
+	__u32 nid;		/* 20-bit NIC address (NID) of this port */
+	__u32 pid_bits;		/* width of the PID field (6–9 bits) */
+	__u32 pid_count;	/* number of PIDs per VNI */
+	__u32 pid_granule;	/* PID space granularity */
+	__u32 lni_id;		/* Zero; LNIs are allocated explicitly */
+	__u32 num_tc_limits;	/* number of valid tc_limits[] entries */
+	/* variable-length tc_limits[] follows if num_tc_limits > 0 */
+};
+
+/*
+ * alloc_pd / ALLOC_PD
+ *
+ * The protection domain selects an explicitly allocated LNI. A nonzero
+ * preferred_svc_id must match that LNI's service; zero means no preference.
+ */
+enum cxi_ibv_alloc_pd_mask {
+	CXI_IBV_ALLOC_PD_SVC_ID_PREFERRED = 1U << 0,
+	CXI_IBV_ALLOC_PD_LNI = 1U << 1,
+};
+
+struct cxi_ibv_alloc_pd_cmd {
+	__u32 comp_mask;	/* enum cxi_ibv_alloc_pd_mask */
+	__u32 preferred_svc_id;	/* optional preferred service for QPs (0 = any) */
+	__u32 lni_handle;
+	__u32 reserved;
+};
+
+struct cxi_ibv_alloc_pd_resp {
+	__u32 pd_id;	/* RGID-based PD identifier (informational) */
+	__u32 pad;
+};
+
+/*
+ * create_cq / CREATE_CQ
+ *
+ * The driver allocates a CXI Event Queue (EQ) of the requested size and
+ * maps the ring buffer and doorbell CSR into user space.
+ *
+ * After create_cq succeeds:
+ *   - eq_buf_offset / eq_buf_size : mmap offset+size for the event-ring buffer
+ *     (user polls this for completions)
+ *   - eq_db_offset / eq_db_size   : mmap offset+size for the EQ doorbell/CSR
+ *     (user writes here to arm notifications)
+ *   - eqn                         : hardware EQ index
+ */
+struct cxi_ibv_create_cq_cmd {
+	__u32 n_entries;	/* requested event-ring depth in entries */
+	__u32 cpu_affinity;	/* NUMA / CPU affinity hint for IRQ steering */
+	__u32 lni_handle;
+	__u32 reserved;
+};
+
+struct cxi_ibv_create_cq_resp {
+	__u64 eq_buf_offset;	/* mmap offset for event-ring buffer */
+	__u64 eq_buf_size;	/* event-ring buffer size in bytes */
+	__u64 eq_db_offset;	/* mmap offset for EQ doorbell (CSR) */
+	__u64 eq_db_size;	/* doorbell region size in bytes */
+	__u32 eqn;		/* hardware EQ index */
+	__u32 pad;
+};
+
+/*
+ * create_qp / CREATE_QP
+ *
+ * On creation the driver allocates:
+ *   - a CXI Domain (VNI + PID)
+ *   - a Communication Profile (CP → LCID)
+ *   - a transmit CQ (TXQ)
+ *   - a target CQ (TGQ)
+ *   - a Portal Table Entry (PTE) for receive matching
+ *
+ * The QP uses its required PD job key's JobID. svc_id selects the CXI
+ * service/resource pool for this QP,
+ * independently of its Resource Index, and must match the PD's LNI service.
+ * If omitted, the driver uses that service. TC
+ * defaults to CXI_TC_BEST_EFFORT unless overridden. match_bits / match_mask
+ * control the portal-level receive filter (0 / 0 = accept all).
+ *
+ * After create_qp succeeds:
+ *   - txq_cmds_offset / txq_cmds_size : mmap offset+size for the TXQ command
+ *     ring (user writes commands here)
+ *   - txq_db_offset / txq_db_size     : mmap offset+size for the TXQ doorbell
+ *   - txq_idx                         : TXQ hardware CQ index (0–1023)
+ *   - lcid                            : LCID assigned to this QP (from CP)
+ *   - tgq_cmds_offset / tgq_cmds_size : mmap offset+size for the TGQ command
+ *     ring (user appends receive buffers here)
+ *   - tgq_db_offset / tgq_db_size     : mmap offset+size for the TGQ doorbell
+ *   - tgq_idx                         : TGQ hardware CQ index (1024–1535)
+ *
+ * The PTE hardware index needed to post receives is not known until the QP
+ * reaches RTR (see cxi_ibv_modify_qp_resp below).
+ */
+enum cxi_ibv_create_qp_mask {
+	CXI_IBV_CREATE_QP_SVC_ID = 1U << 0,
+	CXI_IBV_CREATE_QP_TC     = 1U << 1,
+};
+
+struct cxi_ibv_create_qp_cmd {
+	__u32 comp_mask;	/* enum cxi_ibv_create_qp_mask */
+	__u32 svc_id;		/* optional CXI service (resource-limit pool) */
+	__u32 tc;		/* enum cxi_traffic_class */
+	__u32 uec_qp_type;	/* UEC QP type (reserved; use 0 until spec final) */
+	__u32 pad;
+	__u64 match_bits;	/* portal match bits (0 = match all) */
+	__u64 match_mask;	/* matching mask (0 = match all) */
+};
+
+struct cxi_ibv_create_qp_resp {
+	__u64 txq_cmds_offset;	/* mmap offset for TXQ command ring */
+	__u64 txq_cmds_size;	/* TXQ command ring size in bytes */
+	__u64 txq_db_offset;	/* mmap offset for TXQ doorbell */
+	__u64 txq_db_size;	/* TXQ doorbell size in bytes */
+	__u32 txq_idx;		/* TXQ hardware index (0–1023) */
+	__u32 lcid;		/* LCID assigned to this QP */
+	__u64 tgq_cmds_offset;	/* mmap offset for TGQ command ring */
+	__u64 tgq_cmds_size;	/* TGQ command ring size in bytes */
+	__u64 tgq_db_offset;	/* mmap offset for TGQ doorbell */
+	__u64 tgq_db_size;	/* TGQ doorbell size in bytes */
+	__u32 tgq_idx;		/* TGQ hardware index (1024–1535, see cxi_cq_get_cqn()) */
+	__u32 job_id;		/* JobID (VNI) the QP was created under */
+	__u32 pte_index;
+	__u32 reserved;
+};
+
+/*
+ * modify_qp / MODIFY_QP (extended)
+ *
+ * The PTE is mapped into the domain during the INIT->RTR transition, so its
+ * hardware index is not known at create_qp time. Returned here instead.
+ */
+struct cxi_ibv_modify_qp_resp {
+	__u32 pte_index;	/* hardware PTLTE index, valid once QP reaches RTR */
+	__u32 pad;
+};
+
+/*
+ * query_device / QUERY_DEVICE  (driver-specific extended response)
+ *
+ * When the user-space provider calls ibv_query_device_ex(), the kernel
+ * returns this struct as driver-specific data (via udata->out).
+ * The caller must pass at least sizeof(cxi_ibv_query_device_resp) bytes
+ * in the output buffer; unused bytes are zeroed.
+ *
+ * features:
+ *   CXI_DEVICE_CAP_UEC_QPN        - QPN uses UEC bit-31 addr_mode encoding
+ *   CXI_DEVICE_CAP_TRIGGERED_OPS  - counting triggers / triggered operations
+ *   CXI_DEVICE_CAP_ODP            - on-demand paging MRs
+ *
+ * max_ctn: highest counting-trigger number (inclusive) this device supports.
+ */
+#define CXI_DEVICE_CAP_UEC_QPN          (1U << 0)
+#define CXI_DEVICE_CAP_TRIGGERED_OPS    (1U << 1)
+#define CXI_DEVICE_CAP_ODP              (1U << 2)
+
+/*
+ * Device-wide HW properties that the native ABI exposes via the
+ * DEV_INFO_GET ioctl (struct cxi_dev_info_use in uapi/ethernet/cxi-abi.h).
+ * The RDMA path has no ioctl/sysfs control channel, so it must return the
+ * same information here instead. Field-for-field mirror of that struct,
+ * kept separate (rather than #include'd) so this ABI header doesn't pull
+ * in the native ioctl definitions it has no use for; keep the two in sync.
+ */
+struct cxi_ibv_devinfo {
+	__u32 nid;
+	__u32 pid_bits;
+	__u32 pid_count;
+	__u32 pid_granule;
+	__u32 min_free_shift;
+	__u32 rdzv_get_idx;
+	__u32 vendor_id;
+	__u32 device_id;
+	__u32 device_rev;
+	__u32 device_proto;
+	__u32 device_platform;
+	__u32 pct_eq;
+	__s32 uc_nic;
+	__u64 link_mtu;
+	__u64 link_speed;
+	__u8  link_state;
+	__u16 num_ptes;
+	__u16 num_txqs;
+	__u16 num_tgqs;
+	__u16 num_eqs;
+	__u16 num_cts;
+	__u16 num_acs;
+	__u16 num_tles;
+	__u16 num_les;
+	__u32 cassini_version;         /* enum cassini_version */
+	__u32 system_type_identifier;  /* enum system_type_identifier */
+	char  fru_description[16];
+	__u32 vni_matching;
+};
+
+struct cxi_ibv_query_device_resp {
+	__u32 features; /* CXI_DEVICE_CAP_* bitmask */
+	__u32 max_ctn;  /* max counting trigger number */
+	struct cxi_ibv_devinfo devinfo;
+};
+
+/*
+ *
+ * The driver registers user memory with the CXI ATU (Address Translation
+ * Unit).  The lkey encodes the LAC (Local Address Context) slot and the
+ * hardware MD identifier.  The rkey is a random token used as the portal
+ * match-bits for remote RDMA WRITE/READ operations targeting this MR.
+ */
+/*
+ * 64-bit memory keys.
+ *
+ *   lkey64  bits [2:0]   LAC, the hardware address context
+ *           bits [34:3]  ATU memory descriptor index
+ *   rkey64  an opaque token the initiator presents as the portal match bits
+ *
+ * The 32-bit lkey and rkey keep the older narrow encoding, which packs the
+ * LAC into bits [31:24] and truncates the descriptor index to 24 bits, for
+ * callers that cannot carry a wide key.
+ */
+#define CXI_LKEY64_LAC_MASK	0x7ULL
+#define CXI_LKEY64_MD_SHIFT	3
+#define CXI_LKEY64_MD_MASK	0xffffffffULL
+
+/*
+ * A caller may choose the remote key rather than take a generated one. The
+ * value is used exactly as given, so one that fits in 32 bits produces a
+ * region a 32-bit peer can reach without anything having to truncate.
+ */
+#define CXI_REG_MR_USER_RKEY	(1 << 0)
+#define CXI_REG_MR_NATIVE_MAP	(1 << 1)
+
+#define CXI_RKEY_MAX 0xffffffffffffULL
+
+struct cxi_ibv_reg_mr {
+	__aligned_u64 rkey64;
+	__u32 flags;
+	__u32 native_flags;
+};
+
+struct cxi_ibv_mr_info {
+	__u64 va __attribute__((packed));
+	__u64 iova __attribute__((packed));
+	__u64 length __attribute__((packed));
+	__s32 page_shift;
+	__s32 huge_shift;
+	__u32 id;
+	__u32 lac;
+};
+
+struct cxi_ibv_reg_mr_resp {
+	/*
+	 * The narrow keys alias the low word of the wide ones. REG_MR is a
+	 * legacy write command whose response declares __u32 driver_data[], so
+	 * this payload begins at offset 12 and nothing here can be eight-byte
+	 * aligned; packed drops the requirement without moving anything.
+	 */
+	union {
+		__u64 lkey64 __attribute__((packed));
+		struct {
+			__u32 lkey;
+			__u32 lkey_hi;
+		};
+	};
+	union {
+		__u64 rkey64 __attribute__((packed));
+		struct {
+			__u32 rkey;
+			__u32 rkey_hi;
+		};
+	};
+	/* ATU address for @start; commands must use this, not the VA. */
+	__u64 iova __attribute__((packed));
+	struct cxi_ibv_mr_info info;
+};
+
+/*
+ * Custom uverbs for Counting Triggers (CT).
+ *
+ * The driver allocates a CXI Completion Table (CT) of the requested size and
+ * maps the ring buffer (writeback page) and doorbell CSR into user space.
+ *
+ * After create_ct succeeds:
+ *   - ctn               : hardware CT number (u32); used in triggered commands
+ *   - wb_mmap_offset    : mmap() offset for the writeback page
+ *   - wb_mmap_length    : size of the writeback page in bytes
+ *   - db_mmap_offset    : mmap() offset for the CT doorbell CSR
+ *   - db_mmap_length    : size of the doorbell region in bytes
+ *
+ * Object/method/attribute IDs are driver-namespace values
+ * (UVERBS_ID_DRIVER_NS = 1 << UVERBS_ID_NS_SHIFT).
+ */
+#include <rdma/ib_user_ioctl_cmds.h>
+
+enum cxi_ib_object_ids {
+	CXI_IB_OBJECT_CT = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_OBJECT_JOB_TC,
+	CXI_IB_OBJECT_LNI,
+	CXI_IB_OBJECT_SVC,
+	CXI_IB_OBJECT_CP,
+	CXI_IB_OBJECT_EQ,
+	CXI_IB_OBJECT_CSR,
+	CXI_IB_OBJECT_WAIT,
+	CXI_IB_OBJECT_CMDQ,
+};
+
+enum cxi_ib_methods_cmdq {
+	CXI_IB_METHOD_CMDQ_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CMDQ_DESTROY,
+};
+
+enum cxi_ib_attrs_cmdq {
+	CXI_IB_ATTR_CMDQ_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CMDQ_LNI,
+	CXI_IB_ATTR_CMDQ_COUNT,
+	CXI_IB_ATTR_CMDQ_INFO,
+	CXI_IB_ATTR_CMDQ_FLAGS,
+};
+
+enum cxi_ib_cmdq_flags {
+	CXI_IB_CMDQ_TRIGGER = 1U << 0,
+};
+
+struct cxi_ibv_cmdq_info {
+	__aligned_u64 commands_offset;
+	__aligned_u64 commands_length;
+	__aligned_u64 doorbell_offset;
+	__aligned_u64 doorbell_length;
+	__u32 count;
+	__u32 index;
+};
+
+enum cxi_ib_methods_wait {
+	CXI_IB_METHOD_WAIT_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum cxi_ib_attrs_wait {
+	CXI_IB_ATTR_WAIT_FD = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_WAIT_LNI,
+};
+
+enum cxi_ib_methods_csr {
+	CXI_IB_METHOD_CSR_MAP = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CSR_UNMAP,
+	CXI_IB_METHOD_CSR_INBOUND_WAIT,
+};
+
+enum cxi_ib_attrs_csr {
+	CXI_IB_ATTR_CSR_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CSR_INFO,
+};
+
+struct cxi_ibv_csr_info {
+	__aligned_u64 offset;
+	__aligned_u64 length;
+};
+
+enum cxi_ib_methods_eq {
+	CXI_IB_METHOD_EQ_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_EQ_DESTROY,
+};
+
+enum cxi_ib_attrs_eq {
+	CXI_IB_ATTR_EQ_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_EQ_LNI,
+	CXI_IB_ATTR_EQ_MR,
+	CXI_IB_ATTR_EQ_CONFIG,
+	CXI_IB_ATTR_EQ_INFO,
+	CXI_IB_ATTR_EQ_FLAGS,
+	CXI_IB_ATTR_EQ_EVENT_WAIT,
+	CXI_IB_ATTR_EQ_STATUS_WAIT,
+};
+
+enum cxi_ib_eq_flags {
+	CXI_IB_EQ_REGISTER_PCT = 1U << 0,
+	CXI_IB_EQ_PASSTHROUGH = 1U << 1,
+};
+
+struct cxi_ibv_eq_config {
+	__aligned_u64 address;
+	__aligned_u64 length;
+	__u32 threshold_base;
+	__u32 threshold_delta;
+	__u32 threshold_count;
+	__u32 ec_delay;
+	__u32 cpu;
+	__u32 reserved_slots;
+};
+
+struct cxi_ibv_eq_info {
+	__aligned_u64 doorbell_offset;
+	__aligned_u64 doorbell_size;
+	__u32 eqn;
+	__u32 reserved;
+};
+
+enum cxi_ib_methods_cp {
+	CXI_IB_METHOD_CP_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CP_DESTROY,
+};
+
+enum cxi_ib_attrs_cp {
+	CXI_IB_ATTR_CP_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CP_LNI,
+	CXI_IB_ATTR_CP_VNI,
+	CXI_IB_ATTR_CP_TC,
+	CXI_IB_ATTR_CP_TYPE,
+	CXI_IB_ATTR_CP_INFO,
+};
+
+struct cxi_ibv_cp_info {
+	__u32 vni;
+	__u32 tc;
+	__u32 type;
+	__u32 lcid;
+};
+
+enum cxi_ib_methods_svc {
+	CXI_IB_METHOD_SVC_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_SVC_DESTROY,
+	CXI_IB_METHOD_SVC_QUERY,
+	CXI_IB_METHOD_SVC_ENABLE,
+};
+
+enum cxi_ib_attrs_svc {
+	CXI_IB_ATTR_SVC_ID = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_SVC_CONFIG,
+	CXI_IB_ATTR_SVC_FLAGS,
+	CXI_IB_ATTR_SVC_USAGE,
+	CXI_IB_ATTR_SVC_LPR,
+};
+
+enum cxi_ib_svc_flags {
+	CXI_IB_SVC_LIMITS = 1U << 0,
+	CXI_IB_SVC_CREATE_TC = 1U << 1,
+	CXI_IB_SVC_ENABLED = 1U << 2,
+};
+
+enum cxi_ib_svc_resource {
+	CXI_IB_SVC_PTES,
+	CXI_IB_SVC_TXQS,
+	CXI_IB_SVC_TGQS,
+	CXI_IB_SVC_EQS,
+	CXI_IB_SVC_CTS,
+	CXI_IB_SVC_ACS,
+	CXI_IB_SVC_TLES,
+	CXI_IB_SVC_LES,
+	CXI_IB_SVC_RSRC_COUNT,
+};
+
+#define CXI_IB_SVC_MAX_VNIS 4
+
+struct cxi_ibv_svc_config {
+	__u32 svc_id;
+	/* Reserved; must be zero. */
+	__u16 vni_min;
+	__u16 vni_max;
+	/* Exact-list length; zero means system-empty or is_range. */
+	__u32 vni_count;
+	/* System service requires CAP_SYS_ADMIN and svc_id zero on allocation. */
+	__u32 is_system_svc;
+	/* Inclusive range endpoints are carried in vnis[0] and vnis[1]. */
+	__u32 is_range;
+	__u16 vnis[CXI_IB_SVC_MAX_VNIS];
+	__u32 tc_mask;
+	__u32 uid;
+	__u32 flags;
+	__u16 maximum[CXI_IB_SVC_RSRC_COUNT];
+	__u16 reserved[CXI_IB_SVC_RSRC_COUNT];
+};
+
+struct cxi_ibv_svc_rsrc_use {
+	__u32 svc_id;
+	__u32 tle_pool_id;
+	__u16 in_use[CXI_IB_SVC_RSRC_COUNT];
+};
+
+enum cxi_ib_methods_lni {
+	CXI_IB_METHOD_LNI_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_LNI_DESTROY,
+};
+
+enum cxi_ib_attrs_lni_alloc {
+	CXI_IB_ATTR_LNI_ALLOC_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_LNI_ALLOC_SVC_ID,
+	CXI_IB_ATTR_LNI_ALLOC_ID,
+};
+
+enum cxi_ib_attrs_lni_destroy {
+	CXI_IB_ATTR_LNI_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum cxi_ib_methods_pd {
+	CXI_IB_METHOD_PD_PID_ALLOC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_PD_PID_QUERY,
+};
+
+enum cxi_ib_attrs_pd_pid {
+	CXI_IB_ATTR_PD_PID_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_PD_PID_FLAGS,
+	CXI_IB_ATTR_PD_PID_VALUE,
+};
+
+#define CXI_IB_PD_PID_ABSOLUTE (1U << 0)
+
+struct cxi_ibv_create_jkey_cmd {
+	__u32 tc;
+	__u32 reserved;
+};
+
+enum cxi_ib_methods_ct {
+	CXI_IB_METHOD_CT_ALLOC   = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_CT_DESTROY = (1U << UVERBS_ID_NS_SHIFT) + 1,
+};
+
+enum cxi_ib_attrs_ct_alloc {
+	CXI_IB_ATTR_CT_ALLOC_HANDLE        = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_CT_ALLOC_CTN,
+	CXI_IB_ATTR_CT_ALLOC_WB_MMAP_OFFSET,
+	CXI_IB_ATTR_CT_ALLOC_WB_MMAP_LENGTH,
+	CXI_IB_ATTR_CT_ALLOC_DB_MMAP_OFFSET,
+	CXI_IB_ATTR_CT_ALLOC_DB_MMAP_LENGTH,
+	CXI_IB_ATTR_CT_ALLOC_LNI_HANDLE,
+	CXI_IB_ATTR_CT_ALLOC_WB_ADDRESS,
+};
+
+enum cxi_ib_attrs_ct_destroy {
+	CXI_IB_ATTR_CT_DESTROY_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum cxi_ib_job_tc_flags {
+	CXI_IB_JOB_TC_F_CREATE = 1U << 0,
+};
+
+enum cxi_ib_methods_job_tc {
+	CXI_IB_METHOD_JOB_TC_BIND = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_METHOD_JOB_TC_CLEAR,
+	CXI_IB_METHOD_JOB_TC_QUERY,
+};
+
+struct cxi_ibv_tc_entry {
+	__u32 tc;
+	__u32 tc_type;
+	__u32 res_req_dscp;
+	__u32 unres_req_dscp;
+	__u32 res_rsp_dscp;
+	__u32 unres_rsp_dscp;
+	__u32 req_pcp;
+	__u32 rsp_pcp;
+	__u32 ocuset;
+	__u32 cq_tc;
+	__u32 req_bc;
+	__u32 flags;
+};
+
+#define CXI_IBV_TC_ENTRY_F_CREATED_BY_RDMA	(1U << 0)
+
+enum cxi_ib_attrs_job_tc_bind {
+	CXI_IB_ATTR_JOB_TC_BIND_FLAGS = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_JOB_TC_BIND_JOB_ID,
+	CXI_IB_ATTR_JOB_TC_BIND_TC,
+	CXI_IB_ATTR_JOB_TC_BIND_TC_TYPE,
+	CXI_IB_ATTR_JOB_TC_BIND_SVC_ID,
+	CXI_IB_ATTR_JOB_TC_BIND_PTES_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_PTES_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_TXQS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_TXQS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_TGQS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_TGQS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_EQS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_EQS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_CTS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_CTS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_LES_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_LES_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_TLES_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_TLES_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_ACS_MAX,
+	CXI_IB_ATTR_JOB_TC_BIND_ACS_RES,
+	CXI_IB_ATTR_JOB_TC_BIND_RESP_SVC_ID,
+};
+
+enum cxi_ib_attrs_job_tc_clear {
+	CXI_IB_ATTR_JOB_TC_CLEAR_TC = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_JOB_TC_CLEAR_TC_TYPE,
+};
+
+enum cxi_ib_attrs_job_tc_query {
+	CXI_IB_ATTR_JOB_TC_QUERY_MAX_ENTRIES = (1U << UVERBS_ID_NS_SHIFT),
+	CXI_IB_ATTR_JOB_TC_QUERY_RESP_COUNT,
+	CXI_IB_ATTR_JOB_TC_QUERY_RESP_ENTRIES,
+};
+
+#endif /* __UAPI_RDMA_CXI_ABI_H__ */

-- 
2.56.0

