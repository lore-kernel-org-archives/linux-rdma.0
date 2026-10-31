Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421397;
	b=SYunEew1v2Y/hGjomiYVryNaoZIPgjEZ94bJIm9NMh2P0ewvkR/H8HYPe88r4xscnJ2B
	 T+PlxxpknvAyriDeI4dJ3Fcf+9ULWb4tRKyfCt6MCs+rrvKpOGnVDuf35qVA40q2eHo6V
	 7LPeTg76b5n3QRljUKckhvdxHm07LagzA60beiApm0y/5AKG+1AP/H20MkZxr8NQ679Wd
	 /adHxxalU3DiqLvno4UrDItS3Lut0c8MBLp7dnYQSFskX6D8rMNI8/kjXONPufbLWz5mp
	 w95VqbP4KnVMT3wMSrIBiR4s+zLzidZUrtTsB0xan4PWHOBYelKqWrPYway0ORqDwyQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421397;
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
	bh=mFLvntX/Tu7E2x4GikNpPNo2hbPkra+eNCXEjN4cFck=;
	b=XBSqXGvrulrkdyE67ZcivxXEE5X0gTgJUKYRZ1Csvrq2xFnGDoRgceAuV7/7cU7O5hN6
	 dD+72rNVFMxaVSou55GfcZILWi5j+DQA2tosqT9J5wxdGgKg8FQMvyLRS+08KU13s4931
	 TFN8GXkUy0wvDHeE/XhK47lLNNXYG6a4vNxMBXadp/6w4M85DAxwFaPQp7TD4XL8kN23Z
	 938QrIBjnWU7Oj5JyOBx+/eU0U3uax0Kc88/OGo32aj0EM4TLB1Qh0WEOV3XxBZlbyjHD
	 SR0on3VaPeliNnSp2SIP9B0BSq2OPnY7w/+G29RKofY8jgwWSIQYWRqBN899aoqb0cA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=NN5HFONo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69B5606A31D;
	Sat, 31 Oct 2026 04:36:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E69B5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=NN5HFONo
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V44VAw2205853;
	Sat, 31 Oct 2026 04:36:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=mF
	LvntX/Tu7E2x4GikNpPNo2hbPkra+eNCXEjN4cFck=; b=NN5HFONoISTlGxuQf9
	fH32ZYQVzp6VbgN+m+AS8eWCf01SZ7UIg7vbecvFvsFQ2L/WZbWWVfMUT8mCOn9q
	6XVM5a4pUl4e15nhnAdnGuFZQqKusHyhf49pHXgkciDHuL9/e6hTvY60CtAd4IRk
	0bzEhV1bD+CuVEv8GXoOj4lQPQ0avQtJnM3nzEOJRNTFQAabFYeLRnLkFTnwnvFT
	bhj+HfDPWWb79ZGxKos8/QJQOUs/pDarLK3/bVDfggqb8rsnGeWiinhH3n0JYL/B
	IK75faIOgxhFA8hUoNkmoAsG5L8fZ+MRfJQBFCf7CorTaeT1tc0hsF4skXzWeLAh
	DZDw==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn90087b8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:29 +0000 (GMT)
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 52099800EE5;
	Sat, 31 Oct 2026 04:36:29 +0000 (UTC)
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:24 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:24 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:23 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lg80SpOydkTyxpa83UAprQrw4qeINNBsKdkKe+5QPbXacvyxkYyJm4+erk7BnoawKiQ0npBF132lJ1KegljcliiY2e5FK0S7+N5gZRCUO+45mPL2e86qCILrAV//77HAXaeEx4rZq2VK91I7l0IAaZ5FTFvLUON6WS0IEp1yA2MMQY8yPmpaEKLPXRcMBFnhG+XcJkHlte9586qvoFYsJj5nScrAT4a+JYH0vRMCfZ0KVq6N9Mcc98sG+Md3p/kO9t3o6lHBv7J9JcJ3BjtZKDZGxYTlGxEMV/U3btIdr7TqxIP+mKTUffiaezlmqiaXBXR9DMTt+AYt9pPfpM2snA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFLvntX/Tu7E2x4GikNpPNo2hbPkra+eNCXEjN4cFck=;
 b=lp/xvvRuVEH9BZE59mLAMAG62KvT4QoPSxF6sr5YNi8r38z2AIH4Wy2hlHcS4+To8HHNxmJNkkSbjPwkeySepVpJSFNLp70CB7RGqm8B6sY3e88phEErIyWKjAx6mHwAs2DjdEbo7nQY46i4RNei4YVNc2RAHyP2HIY85rRmHmiOFA7NXit3tpZV6/B/bOhczClhA11enty9sbSPsXDcIoOoNIxcSwwigfILfCmwc+KYThxM7k5dKw+2TPvzqkfGSG6UBySBiAcV7i3ZffcfeJBbN4DAATKkOYw83LCsyFqywyW8CUJNldXTpK5eXJnYAIm5onmOKYgRdq3OPTiZig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:18 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:18 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:37 -0700
Subject: [PATCH 09/11] RDMA/cxi: add services jobs profiles queues and
 counting triggers
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-cxi-for-next-v1-9-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Mamila Santosh <santosh-kumar.mamila@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0119.namprd11.prod.outlook.com
 (2603:10b6:806:d1::34) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB2091:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a783075-c3aa-427a-0f58-08df3708815e
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|3023799007|56012099006|261021121427099003|5023799004|261021130227099003|261021135927099003|261021123027099003|261022105027099003|261022113327099003|261026135527099003|261026140227099003|261021133027099003|261026121527099003|261026130827099003|261022115727099003|261028144727099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: Q7eyaWr6ZfdRQPYqvKumbVonWNST5uN+SAm1ys2ohdVbMhQxh4LGzLIIJQASeaYwmmXWw2YtezfgFjU6+38aWhGlw+mmKxoAy3DR5nmPWKs7XRTajBSLfEsXfyKdGGDinLLVWp120TLG0rS1wS9q+iE1mzMZdpnc1ANLNYUlvQnpm7K2O0GWtyIpUfnOPHcZd/8j8+ihCU/p+d8MqnhZtsaLPrWnNwz9b6ijp/l2yqiklwabhgAEUUBmLG4UjnSOZKhB0VX8eAaqYo7lmueFD+jQ4LGD4kCbPVWoJNGPBfuhTbJjWccb9+lO29HYV58oqL9QeG81UugHMuAFv0WpHhVWekulcn9wi0qHx8P7mlygl/vcr/+gfpMQC3zl/6KLlfRXHuQaFeixawKheHfBP+KLgMuYc50/5uek3KqizJRMNJy1fM7hDkzrhIoivZmwSGbiS3xwtWBK1f6NjCVmZ7yc8ljXzvwp0J/g62Ukub/dcqkb8+86jMnDchV6pJbwvgcVbOvaHgTDRk9zCe/mRsLrjLgC3bo+PGQeoCBV9sEFtImKtu/GOJT5fZsxUiQc8nbyR+lHt1O5yFF/ruu+uM1OK/c66xlKUenJXvcPSje23oJgUIqSDkB18uoFoyqDpu677xokFAcH9q3FRwez7y64ewJJs+zIIDGNbsCs4lE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(56012099006)(261021121427099003)(5023799004)(261021130227099003)(261021135927099003)(261021123027099003)(261022105027099003)(261022113327099003)(261026135527099003)(261026140227099003)(261021133027099003)(261026121527099003)(261026130827099003)(261022115727099003)(261028144727099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YU52VXpHOEZlSVNqS2p1b3k3NnNONWxrM0V5ODVBT3N3R3N1RWg1dy9vcW5G?=
 =?utf-8?B?WjZ6L2daSzdVUHdsek1GZFRBMEFkMmJra2dwd1pWRmJXdmxOVkxBMml4NlJp?=
 =?utf-8?B?R2d0OGdJYWxpbTE3MGhJckxDR0Z3S1B2TVFvdDlzclptc0t1cjVNUUlEdWFO?=
 =?utf-8?B?SEJlZUg5VGhQeXNBYmdDK2F3OXNVT3FrWWNSU0xDUkk0dnhQeGhBNHRDU1BH?=
 =?utf-8?B?dVNUUHRvbFIwL2dFdTBsKzc2bXAxZm5LWkMyM2ZkeXU5eXZ2SFpHUnpNcmJ4?=
 =?utf-8?B?OC8yTUpFTzhnS2l6Mm9idlhUWGh2MWExTzFiZlBVNkFJQVdleDQrSVNmNHly?=
 =?utf-8?B?M3pTTzFoaUQwVkxZUVdNRXd0QWVGSUZCWmFpSk1KN3p2c25IejRTcmFmYTk3?=
 =?utf-8?B?TWo4K3JrSkErVFRURWh5UGNNWXgyZ3h0dnczWmlGRDg0NmxhbS9ja1RNcG9C?=
 =?utf-8?B?SXg3d0VMb0N1Sk14SGFJMFRMcVFKRVc0Z3c5WGlHUGNSWTRWVzE3WnErSmx1?=
 =?utf-8?B?dEZNSVFVRXhXdTY1NGNzWjNrZk1BOWdyN0hXVzI4ZjB3TUMvVy8ya21KaE9y?=
 =?utf-8?B?Y1JJMVdRU0FBR3FyRHNjbmFaSWpJYVBWMmVGRU5oQVM0OVV2UFZQYTRia0w0?=
 =?utf-8?B?MnNnSjBXUDhnUGwzaDA4dENnbDQwczU1TllUNjVkYzlxd0ZDZEdWc2NNUTlu?=
 =?utf-8?B?WEJIeFBDQmtOUEQ0bStFWWZyNEQwQ1lsVVdvNnE0TVNybEx0cGhKbW1XWUtF?=
 =?utf-8?B?NXpXYXQrTS8rMjlSOVZGRUJVbVQrRUtFTlBJM3NYbDRYT1hLQlA0U3FjYWtT?=
 =?utf-8?B?bkExVXNLZjM1Qjl1TkpYT0NZa2dLbW5US3FoL1hsNkFaVDliTlpEMjNVbWxp?=
 =?utf-8?B?QktqbzgzSFV4MnpuOWRVZmVtaDdaeTVXOUVYT2RXejJmcHdhR3FSUXZwWHZX?=
 =?utf-8?B?SHA5ZUsrUGhzRktNNTViMGI0WnNHanBZUk9WR25qUDRYYkpFcUZKT3NCdGdT?=
 =?utf-8?B?Nmc5NHY0YjFlYkM5NldJTm1keVYzNjNuL0pVK2QrUkZnZ1plZ1U4anBCYVhI?=
 =?utf-8?B?Qk4yeUNZMjlIN0x2VUFTZWZxVTlzSE8ySzNOdWs1anhyRmxaWmtueTEvaWhp?=
 =?utf-8?B?aTZ4WXQ3Z1pFVWJ0ZEthOCtCZ2pnTlpUdkZKMGZITEhkUUNsUVJYU1RueG0y?=
 =?utf-8?B?MWJuLzhSQzJFSnkxVkVpZVJjV3JnQlF0UnB0VTM3Z3dYM0RkV2hOV2IrcWts?=
 =?utf-8?B?aW5JQU5iNjRZUk5vZmNRSTR6aDVkblM5a0RPUmZ4eWoyT3BvSm90UmhLazVy?=
 =?utf-8?B?Q2tVRm5lWUxTMW1XY2k0bEs2d0pib0RMZ3ZrVU9QSHJrbDROWlZ0eDZPMi9Z?=
 =?utf-8?B?K053WTNvc0sxNTdXL2VXdDR5NUVORnZSZDBML2RIRm5BRTEva1p6NEo5cUU5?=
 =?utf-8?B?aURoUGpsUVNSbVVLSlUyNTUwU2x3cGRqVGRWaXB5bTNsdUhRc2UwWVJnVzNH?=
 =?utf-8?B?elpDWFp3Zk9mbUp2NXdtYjNFRjBmaDVKd0RCVXlIcHFpQjduQ1RGS3RvaFY1?=
 =?utf-8?B?bHdRZTFkbDZWbU5KRWNOcmc2cGZVL2xVc2RzQ3o2OUxiQ0UxbTRtWVpKWkYr?=
 =?utf-8?B?L2tIcUNTMm1nY3VkTHU0cW9sblJyOGxlSmtQYzZzV2RxeDJabFYzdkhrR0pF?=
 =?utf-8?B?bzJEelczcEd3TG8ydGd3MkNicDFUNGRKRzlPS0RUYWJPaE9HMitLaGpIK0Ni?=
 =?utf-8?B?TG9PaDI1dVR5VVMwRXA2dnk5RDVKa0pueUNRSEczZUdLQjhuQ2NCTGNWUjh5?=
 =?utf-8?B?NWJlbk5MY2xQc20wNkpmV1BuZEJHVDF3WFROdjF6TzRGaVFvZ1k3RkNrWjh6?=
 =?utf-8?B?TnpkRDZNeXVMOG11Uy9sdkRHeU8wRlBZdmtuUTFsWHFrLzFtejNYdnJvd0pv?=
 =?utf-8?B?YXVsdUJmQU9meGR0NVNKeUVSVzE4eDFYQWxnNlBVQzZBcXpxeXdFYVNTMjVq?=
 =?utf-8?B?MWVBWDAwbnVkV2YvcnByaGRpZlRES3FzNm5jbC8yMVpFY0p5R0c3d3lleisr?=
 =?utf-8?B?RzlaZTVjOFBVK0lmRWVvZ1FWcEtGVFU1RXU3d3ZDa3lQbWhhNGU3N2dzRVJn?=
 =?utf-8?B?VE1BcXZPTXlackIzWmU4S0x6NCtPdVVhQ0Z6OTBDS01lV1lKbEMvZ2JtelJE?=
 =?utf-8?B?SWRFb0IxMkExaDIvaWlOM3Qybmw0UC9uRitkcm9kL2Izd0ZPZllCTE5YcTF3?=
 =?utf-8?B?MUNOVFlFTDVxaGJBb2x0dWg4andPR0lLZmZLU0hRNnJwdnZVNXFENnNWYjBK?=
 =?utf-8?B?ays5SGxHdTFUNDFhTEQ3elhuY2hCOWhOMmRSNm82d0RvS1NpMWJKdz09?=
X-Exchange-RoutingPolicyChecked: gFYa7WRGJOhR14uFZxPLbpC7jDIOB+9T5PhOOYhxORi/HF5LNa3PchFm9jdBjowalBkYTwsJqxQztQ8p02wDQciYAMOVlCBuL/N5oJpaIiHwDX3Prb1d5NFu5nmQUJTNY3jeiN97eQc4nlHN+XfIpTdEVNjBDSRj3FtcbgdEPw7gAdoJBrEmXSjoKr6jhOrHoMvV49Kc22m6X6rViPakf2aTHnqmCTP7h4Uw2UbosEsRnPdojRRNpKEZ9s6xO+wEsMqCyUUdLmqyCZ7PIdMohD4uWaGmDO3u/uDRFLr7HWkt/DgZdOOI9WW4Epq1ai4vOohCW6yq+HzfDx98Rbv3Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a783075-c3aa-427a-0f58-08df3708815e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:18.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2BlACe4ceVAJEv+WYPE2fJcoWYXU2grbk3XOwZtrCxVlDQFVxmmGSqb9HMCrcClYWpkmOTI8qjKfGnJFJ24uNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=J5I/fwnS c=1 sm=1 tr=0 ts=6ae5704e cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=k7r4yCLl9DVLXMiQTbtC:22 a=MvuuwTCpAAAA:8 a=Zl8AJmhLbWmzNFpIJEkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: uUvLLuoCKIqR3Ez9Rnsoww_MVGUXNnF8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX/4NVB/mLiFtK
 TCWEVhCCBWwtVWCcEvfSQEPE5bEkfprRjA/024ejgNLNi0hBGegZ2ufPldX97Szl9mDJAHl7oAQ
 jvZyV2WCYuqRTyPJ4Q+hceWZXyIwqxDAQwjERDI93XqL+NQc/Y2vKiGS1rL7KJnuHnFRl4/sgIY
 fK4GoDROAQyz1TwzbJUAXz6eA8YQMHrYVYrifaUYI8V+gIP5aFKxSYBo3hbPl3sJ+xWUcARQmFA
 JeH6MRJgbyI5ap7KbCFL7ljkZ0lyy2qpgLN8wGK3TUzlLWYQ/gVKi2P6GN2oSvWEb0g2dKw2MkL
 lqNlIJp+nDw2o3RknpRweq3+SU7rbklQ0+E+f0RvU2JCkDHbLaQBccDsiojQ9N1rVY9PJp4jziO
 OEu+kYTv/xZQ5+pHSiorWzCTCIK1kA68Ab4xZgVKt0nEDrh0NUpeK46qCuX0dKfKHrCup2KHA6c
 rRH3vDxZOxdZr9k48vA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfXywUKFSFjcRVE
 fwtqlbWtTnquhbTfjWlim7utV1tzGHiHS7vNrNu/xeOI49PTxS9u/Ap4vX8j3Ne70nYsdep25Kq
 ZVA9NzXNZ+rhubzQDp9PJpravyUOJxA=
X-Proofpoint-GUID: uUvLLuoCKIqR3Ez9Rnsoww_MVGUXNnF8
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Add the private uverbs object methods through which a privileged
process provisions and drives native Cassini resources.  They exist
so a launcher or workload manager can set policy on the NIC and the
provider can reach native queues without the kernel interpreting every
command:

 - services: allocate, enable, query and destroy a CXI service, with
   VNI, traffic class and resource limits; retry and range VNI modes
   are selectable
 - jobs and job keys, LNI and PD PID allocation and query
 - communication profiles, event queues (with optional pinned PCT
   registration and PCT passthrough), command queues including a target
   command queue and a restricted trigger mode, and counting events
   with a user supplied write-back page
 - priority wait descriptors: a pollable file descriptor that holds the
   LNI and reports event and status wakeups, with positional reads so
   the generation can be consumed without seeking
 - a privileged mapping of the device CSR aperture and an
   administrative inbound-wait method, both requiring CAP_SYS_ADMIN
   and a C1/C2 physical function

Lifetime rules worth knowing when reviewing: a native object stays
allocated until the last VMA that maps it is released, even if the
uverbs object was destroyed first; counting events are accounted
against the LNI and freed together with it; the write-back page for a
counting event must be user memory and is pinned, never a kernel
page, because the core driver treats a kernel address passed this
way as device memory.

Known open issue, deferred to the V2 SR-IOV update (Sashiko H87,
duplicate M88): on a physical function cxi_eq_free() cannot fail. On a
virtual function it fails when the PF mailbox is unreachable; if that
happens while the file is closed or the device is removed, the RDMA core
drops the EQ object without native cleanup and the VF EQ and its
references leak. Explicit EQ destroys are retried.

Known limitation, deferred to V2: this patch carries SR-IOV
virtual-function code (VF-to-PF mailbox requests, mailbox opcodes or VF
resource handling) from an older, incomplete version of the Cassini
SR-IOV support. V2 of this series will include the updated SR-IOV
implementation, so issues in the VF paths should be ignored for now.

checkpatch --strict (100 columns) still reports the following in this
patch. They need coordination with the internal repositories this code
is maintained in and will be fixed in V2:
- CHECK: PARENTHESIS_ALIGNMENT (82), OPEN_ENDED_LINE (23),
  UNCOMMENTED_DEFINITION (1)

Co-developed-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Signed-off-by: Mamila Santosh <santosh-kumar.mamila@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs_ct.c | 1906 +++++++++++++++++++++++++++++++
 1 file changed, 1906 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs_ct.c b/drivers/infiniband/hw/cxi/cxiverbs_ct.c
new file mode 100644
index 000000000000..c8f8974c649b
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs_ct.c
@@ -0,0 +1,1906 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cxiverbs_ct.c: Counting Triggers custom uverbs for the CXI RDMA driver.
+ * Copyright 2025 Hewlett Packard Enterprise Development LP
+ *
+ * Exposes CXI Counting Triggers (CTs) to userspace via the RDMA ioctl()
+ * interface.  A CT is a hardware counter that the NIC decrements when a
+ * triggered operation completes; when the counter hits zero the deferred
+ * command is dispatched.
+ *
+ * ABI:
+ *   CXI_IB_OBJECT_CT / CXI_IB_METHOD_CT_ALLOC
+ *     - allocates a CT against the caller's ucontext LNI
+ *     - returns: ctn, writeback-page mmap params, doorbell CSR mmap params
+ *   CXI_IB_METHOD_CT_DESTROY
+ *     - frees all CT resources; uses default destroy handler
+ *
+ * UVERBS_MODULE_NAME must be defined before uverbs_named_ioctl.h.
+ */
+#define UVERBS_MODULE_NAME cxiverbs
+#include <rdma/uverbs_named_ioctl.h>
+
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/file.h>
+#include <linux/poll.h>
+#include <linux/refcount.h>
+#include <rdma/ib_verbs.h>
+#include <rdma/uverbs_ioctl.h>
+#include <uapi/rdma/cxiverbs-abi.h>
+#include "cxiverbs.h"
+
+static struct cxiverbs_ucontext *cxiverbs_get_ucontext(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_ucontext *context = ib_uverbs_get_ucontext(attrs);
+
+	if (IS_ERR(context))
+		return ERR_CAST(context);
+	return to_cxiverbs_ucontext(context);
+}
+
+struct cxiverbs_csr {
+	struct cxiverbs_mmap_entry *mapping;
+};
+
+static int cxiverbs_csr_cleanup(struct ib_uobject *uobj,
+			       enum rdma_remove_reason why,
+			       struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_csr *csr = uobj->object;
+
+	rdma_user_mmap_entry_remove(&csr->mapping->rdma_entry);
+	kfree(csr);
+	return 0;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_CSR_MAP)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj =
+		uverbs_attr_get_uobject(attrs, CXI_IB_ATTR_CSR_HANDLE);
+	struct cxi_ibv_csr_info info = {};
+	struct cxiverbs_ucontext *ctx;
+	struct cxiverbs_csr *csr;
+	struct cxi_dev *cdev;
+	phys_addr_t physical;
+	size_t length;
+	u32 generation;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	ctx = cxiverbs_get_ucontext(attrs);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	cdev = ctx->cadev->cxi_dev;
+	generation = cdev->prop.cassini_version & 0xf0;
+	if (!cdev->is_physfn ||
+	    (generation != CASSINI_1 && generation != CASSINI_2))
+		return -EOPNOTSUPP;
+	cxi_get_csrs_range(cdev, &physical, &length);
+	if (!length || !IS_ALIGNED(physical, PAGE_SIZE) ||
+	    !IS_ALIGNED(length, PAGE_SIZE))
+		return -EINVAL;
+	csr = kzalloc_obj(*csr, GFP_KERNEL);
+	if (!csr)
+		return -ENOMEM;
+	csr->mapping = cxiverbs_mmap_entry_alloc_admin(&ctx->ibucontext,
+						     physical, length,
+						     &info.offset);
+	if (IS_ERR(csr->mapping)) {
+		ret = PTR_ERR(csr->mapping);
+		kfree(csr);
+		return ret;
+	}
+	info.length = length;
+	uobj->object = csr;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_CSR_HANDLE);
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_CSR_INFO, &info, sizeof(info));
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_CSR_MAP,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CSR_HANDLE, CXI_IB_OBJECT_CSR,
+		       UVERBS_ACCESS_NEW, UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CSR_INFO,
+			    UVERBS_ATTR_TYPE(struct cxi_ibv_csr_info),
+			    UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(CXI_IB_METHOD_CSR_UNMAP,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CSR_HANDLE, CXI_IB_OBJECT_CSR,
+		       UVERBS_ACCESS_DESTROY, UA_MANDATORY));
+
+static int
+UVERBS_HANDLER(CXI_IB_METHOD_CSR_INBOUND_WAIT)(struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ucontext *ctx;
+	struct cxi_dev *cdev;
+	u32 generation;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	ctx = cxiverbs_get_ucontext(attrs);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	cdev = ctx->cadev->cxi_dev;
+	generation = cdev->prop.cassini_version & 0xf0;
+	if (!cdev->is_physfn ||
+	    (generation != CASSINI_1 && generation != CASSINI_2))
+		return -EOPNOTSUPP;
+	return cxi_inbound_wait(cdev);
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_CSR_INBOUND_WAIT);
+
+DECLARE_UVERBS_NAMED_OBJECT(CXI_IB_OBJECT_CSR,
+	UVERBS_TYPE_ALLOC_IDR(cxiverbs_csr_cleanup),
+	&UVERBS_METHOD(CXI_IB_METHOD_CSR_MAP),
+	&UVERBS_METHOD(CXI_IB_METHOD_CSR_UNMAP),
+	&UVERBS_METHOD(CXI_IB_METHOD_CSR_INBOUND_WAIT));
+
+struct cxiverbs_lni *cxiverbs_lni_get(struct cxiverbs_ucontext *ctx, u32 handle)
+{
+	struct cxiverbs_lni *lni = NULL;
+	struct cxiverbs_lni *candidate;
+	unsigned long index;
+
+	mutex_lock(&ctx->resource_lock);
+	if (handle != CXI_IBV_LNI_ANY) {
+		lni = xa_load(&ctx->lnis, handle);
+	} else {
+		xa_for_each(&ctx->lnis, index, candidate) {
+			if (lni) {
+				lni = NULL;
+				break;
+			}
+			lni = candidate;
+		}
+	}
+	if (lni)
+		atomic_inc(&lni->usecnt);
+	mutex_unlock(&ctx->resource_lock);
+	return lni ? lni : ERR_PTR(-EINVAL);
+}
+
+void cxiverbs_lni_put(struct cxiverbs_lni *lni)
+{
+	atomic_dec(&lni->usecnt);
+}
+
+static int cxiverbs_lni_cleanup(struct ib_uobject *uobj,
+			       enum rdma_remove_reason why,
+			       struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_lni *lni = uobj->object;
+	struct cxiverbs_ucontext *ctx = lni->ctx;
+
+	mutex_lock(&ctx->resource_lock);
+	if (atomic_read(&lni->usecnt)) {
+		mutex_unlock(&ctx->resource_lock);
+		return -EBUSY;
+	}
+	xa_erase(&ctx->lnis, lni->handle);
+	mutex_unlock(&ctx->resource_lock);
+	ctx->cadev->lni_free(lni->lni);
+	kfree(lni);
+	return 0;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_LNI_ALLOC)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj =
+		uverbs_attr_get_uobject(attrs, CXI_IB_ATTR_LNI_ALLOC_HANDLE);
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	struct cxiverbs_lni *lni;
+	u32 svc_id;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	ret = uverbs_copy_from(&svc_id, attrs, CXI_IB_ATTR_LNI_ALLOC_SVC_ID);
+	if (ret)
+		return ret;
+	if (!svc_id)
+		return -EINVAL;
+	lni = kzalloc_obj(*lni, GFP_KERNEL);
+	if (!lni)
+		return -ENOMEM;
+	lni->lni = ctx->cadev->lni_alloc(ctx->cadev->cxi_dev, svc_id);
+	if (IS_ERR(lni->lni)) {
+		ret = PTR_ERR(lni->lni);
+		goto err_free;
+	}
+	lni->ctx = ctx;
+	lni->svc_id = svc_id;
+	lni->handle = uobj->id;
+	atomic_set(&lni->usecnt, 0);
+	mutex_lock(&ctx->resource_lock);
+	ret = xa_insert(&ctx->lnis, lni->handle, lni, GFP_KERNEL);
+	mutex_unlock(&ctx->resource_lock);
+	if (ret)
+		goto err_lni;
+	uobj->object = lni;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_LNI_ALLOC_HANDLE);
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_LNI_ALLOC_ID,
+			     &lni->lni->id, sizeof(lni->lni->id));
+err_lni:
+	ctx->cadev->lni_free(lni->lni);
+err_free:
+	kfree(lni);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_LNI_ALLOC,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_LNI_ALLOC_HANDLE, CXI_IB_OBJECT_LNI,
+			UVERBS_ACCESS_NEW, UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_LNI_ALLOC_SVC_ID,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_LNI_ALLOC_ID,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(CXI_IB_METHOD_LNI_DESTROY,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_LNI_DESTROY_HANDLE, CXI_IB_OBJECT_LNI,
+			UVERBS_ACCESS_DESTROY, UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(CXI_IB_OBJECT_LNI,
+	UVERBS_TYPE_ALLOC_IDR(cxiverbs_lni_cleanup),
+	&UVERBS_METHOD(CXI_IB_METHOD_LNI_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_LNI_DESTROY));
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_PD_PID_ALLOC)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_pd *ibpd = uverbs_attr_get_obj(attrs, CXI_IB_ATTR_PD_PID_HANDLE);
+	struct cxiverbs_pd *pd = to_cxiverbs_pd(ibpd);
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibpd->device);
+	u32 flags = 0;
+	u32 value;
+	int pid;
+	int ret;
+
+	ret = uverbs_get_flags32(&flags, attrs, CXI_IB_ATTR_PD_PID_FLAGS,
+				CXI_IB_PD_PID_ABSOLUTE);
+	if (ret)
+		return ret;
+	if (flags || !dev->cadev->pid_alloc || !dev->cadev->pid_free)
+		return -EOPNOTSUPP;
+	mutex_lock(&pd->resource_lock);
+	if (pd->pidonfep_valid) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	pid = dev->cadev->pid_alloc(pd->lni_ref->lni);
+	if (pid < 0) {
+		ret = pid;
+		goto out_unlock;
+	}
+	value = pid;
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_PD_PID_VALUE,
+			     &value, sizeof(value));
+	if (ret) {
+		dev->cadev->pid_free(pd->lni_ref->lni, pid);
+		goto out_unlock;
+	}
+	pd->pidonfep = pid;
+	pd->pidonfep_valid = true;
+out_unlock:
+	mutex_unlock(&pd->resource_lock);
+	return ret;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_PD_PID_QUERY)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_pd *ibpd = uverbs_attr_get_obj(attrs, CXI_IB_ATTR_PD_PID_HANDLE);
+	struct cxiverbs_pd *pd = to_cxiverbs_pd(ibpd);
+	int ret;
+
+	mutex_lock(&pd->resource_lock);
+	ret = pd->pidonfep_valid ?
+		uverbs_copy_to(attrs, CXI_IB_ATTR_PD_PID_VALUE,
+			       &pd->pidonfep, sizeof(pd->pidonfep)) : -ENOENT;
+	mutex_unlock(&pd->resource_lock);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_PD_PID_ALLOC,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_PD_PID_HANDLE, UVERBS_OBJECT_PD,
+			UVERBS_ACCESS_WRITE, UA_MANDATORY),
+	UVERBS_ATTR_FLAGS_IN(CXI_IB_ATTR_PD_PID_FLAGS, u32, UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_PD_PID_VALUE,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_PD_PID_QUERY,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_PD_PID_HANDLE, UVERBS_OBJECT_PD,
+			UVERBS_ACCESS_READ, UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_PD_PID_VALUE,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_PD,
+	&UVERBS_METHOD(CXI_IB_METHOD_PD_PID_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_PD_PID_QUERY));
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_SVC_ALLOC)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	struct cxi_ibv_svc_config config;
+	struct cxi_svc_desc desc = {};
+	struct cxi_svc_fail_info fail = {};
+	struct cxi_limits *limits[] = {
+		&desc.limits.ptes, &desc.limits.txqs, &desc.limits.tgqs,
+		&desc.limits.eqs, &desc.limits.cts, &desc.limits.acs,
+		&desc.limits.tles, &desc.limits.les,
+	};
+	u32 svc_id;
+	unsigned int index;
+	unsigned int vni_index;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+	ret = uverbs_copy_from(&config, attrs, CXI_IB_ATTR_SVC_CONFIG);
+	if (ret)
+		return ret;
+	if (config.is_system_svc && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (config.is_system_svc > 1 || config.is_range > 1 ||
+	    config.vni_count > CXI_IB_SVC_MAX_VNIS ||
+	    config.vni_min || config.vni_max ||
+	    (config.tc_mask >> CXI_TC_MAX) ||
+	    (config.flags & ~(CXI_IB_SVC_LIMITS | CXI_IB_SVC_CREATE_TC)))
+		return -EINVAL;
+	if (config.is_range) {
+		if (config.is_system_svc || config.vni_count ||
+		    !config.vnis[0] || config.vnis[0] > config.vnis[1] ||
+		    config.vnis[2] || config.vnis[3])
+			return -EINVAL;
+	} else if (config.is_system_svc) {
+		if (config.svc_id || config.vni_count || config.tc_mask ||
+		    (config.flags & CXI_IB_SVC_CREATE_TC) ||
+		    !(config.flags & CXI_IB_SVC_LIMITS) ||
+		    config.vnis[0] || config.vnis[1] || config.vnis[2] ||
+		    config.vnis[3])
+			return -EINVAL;
+		for (index = 0; index < ARRAY_SIZE(limits); index++) {
+			u16 expected = index == CXI_IB_SVC_EQS ||
+				       index == CXI_IB_SVC_ACS ? 1 : 0;
+
+			if (config.maximum[index] != expected ||
+			    config.reserved[index] != expected)
+				return -EINVAL;
+		}
+	} else if (!config.vni_count || !config.tc_mask) {
+		return -EINVAL;
+	}
+	for (index = 0; index < CXI_IB_SVC_MAX_VNIS; index++) {
+		if (index >= config.vni_count) {
+			if (!config.is_range && config.vnis[index] &&
+			    !config.is_system_svc)
+				return -EINVAL;
+			continue;
+		}
+		if (!config.vnis[index])
+			return -EINVAL;
+		for (vni_index = 0; vni_index < index; vni_index++)
+			if (config.vnis[index] == config.vnis[vni_index])
+				return -EINVAL;
+	}
+	desc.svc_id = config.svc_id;
+	desc.enable = true;
+	desc.restricted_members = true;
+	desc.members[0].type = CXI_SVC_MEMBER_UID;
+	desc.members[0].svc_member.uid = config.uid;
+	desc.is_system_svc = config.is_system_svc;
+	desc.restricted_tcs = !config.is_system_svc;
+	desc.resource_limits = !!(config.flags & CXI_IB_SVC_LIMITS);
+	for (index = 0; index < ARRAY_SIZE(limits); index++) {
+		if (config.reserved[index] > config.maximum[index])
+			return -EINVAL;
+		limits[index]->max = config.maximum[index];
+		limits[index]->res = config.reserved[index];
+	}
+	for (index = 0; index < CXI_TC_MAX; index++) {
+		desc.tcs[index] = !!(config.tc_mask & BIT(index));
+		if (!desc.tcs[index] || !(config.flags & CXI_IB_SVC_CREATE_TC))
+			continue;
+		ret = ctx->cadev->tc_cfg(ctx->cadev->cxi_dev, index,
+					CXI_TC_TYPE_DEFAULT);
+		if (ret && ret != -EEXIST)
+			return ret;
+	}
+	if (config.is_system_svc) {
+		desc.restricted_vnis = true;
+	} else if (config.is_range) {
+		desc.restricted_vnis = false;
+	} else {
+		desc.restricted_vnis = true;
+		desc.num_vld_vnis = config.vni_count;
+		memcpy(desc.vnis, config.vnis,
+		       config.vni_count * sizeof(config.vnis[0]));
+	}
+	ret = ctx->cadev->svc_alloc(ctx->cadev->cxi_dev, &desc, &fail,
+				   "cxidv-service");
+	if (ret < 0)
+		return ret;
+	svc_id = ret;
+	if (config.is_range) {
+		ret = ctx->cadev->svc_set_vni_range(ctx->cadev->cxi_dev, svc_id,
+						   config.vnis[0], config.vnis[1]);
+		if (ret)
+			goto err_destroy;
+		ret = ctx->cadev->svc_enable(ctx->cadev->cxi_dev, svc_id, true);
+		if (ret)
+			goto err_destroy;
+	}
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_SVC_ID, &svc_id, sizeof(svc_id));
+	if (!ret)
+		return 0;
+err_destroy:
+	ctx->cadev->svc_destroy(ctx->cadev->cxi_dev, svc_id);
+	return ret;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_SVC_DESTROY)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	u32 svc_id;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+	ret = uverbs_copy_from(&svc_id, attrs, CXI_IB_ATTR_SVC_ID);
+	return ret ? ret : ctx->cadev->svc_destroy(ctx->cadev->cxi_dev, svc_id);
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_SVC_ENABLE)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	u32 svc_id;
+	u32 enable;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+	ret = uverbs_copy_from(&svc_id, attrs, CXI_IB_ATTR_SVC_ID);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&enable, attrs, CXI_IB_ATTR_SVC_FLAGS);
+	if (ret)
+		return ret;
+	if (enable > 1)
+		return -EINVAL;
+	return ctx->cadev->svc_enable(ctx->cadev->cxi_dev, svc_id, enable);
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_SVC_QUERY)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	struct cxi_ibv_svc_config config = {};
+	struct cxi_svc_desc desc;
+	const struct cxi_limits *limits[] = {
+		&desc.limits.ptes, &desc.limits.txqs, &desc.limits.tgqs,
+		&desc.limits.eqs, &desc.limits.cts, &desc.limits.acs,
+		&desc.limits.tles, &desc.limits.les,
+	};
+	unsigned int first, last, index;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	ret = uverbs_copy_from(&config.svc_id, attrs, CXI_IB_ATTR_SVC_ID);
+	if (ret)
+		return ret;
+	ret = ctx->cadev->svc_get(ctx->cadev->cxi_dev, config.svc_id, &desc);
+	if (ret)
+		return ret;
+	if (desc.enable)
+		config.flags |= CXI_IB_SVC_ENABLED;
+	if (desc.resource_limits)
+		config.flags |= CXI_IB_SVC_LIMITS;
+	config.is_system_svc = desc.is_system_svc;
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_FLAGS)) {
+		ret = uverbs_copy_to(attrs, CXI_IB_ATTR_SVC_FLAGS,
+				     &config.flags, sizeof(config.flags));
+		if (ret)
+			return ret;
+	}
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_USAGE)) {
+		struct cxi_rsrc_use native = {};
+		struct cxi_ibv_svc_rsrc_use usage = {};
+
+		BUILD_BUG_ON(sizeof(native.in_use) != sizeof(usage.in_use));
+		ret = ctx->cadev->svc_rsrc_get(ctx->cadev->cxi_dev,
+					      config.svc_id, &native);
+		if (ret)
+			return ret;
+		usage.svc_id = native.svc_id;
+		usage.tle_pool_id = native.tle_pool_id;
+		memcpy(usage.in_use, native.in_use, sizeof(usage.in_use));
+		ret = uverbs_copy_to(attrs, CXI_IB_ATTR_SVC_USAGE,
+				     &usage, sizeof(usage));
+		if (ret)
+			return ret;
+	}
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_LPR)) {
+		u32 lpr;
+
+		ret = cxi_svc_get_lpr(ctx->cadev->cxi_dev, config.svc_id);
+		if (ret < 0)
+			return ret;
+		lpr = ret;
+		ret = uverbs_copy_to(attrs, CXI_IB_ATTR_SVC_LPR, &lpr, sizeof(lpr));
+		if (ret)
+			return ret;
+	}
+	if (!uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_CONFIG))
+		return uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_FLAGS) ||
+		       uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_USAGE) ||
+		       uverbs_attr_is_valid(attrs, CXI_IB_ATTR_SVC_LPR) ? 0 : -EINVAL;
+	if (desc.restricted_vnis) {
+		if ((!desc.num_vld_vnis && !desc.is_system_svc) ||
+		    desc.num_vld_vnis > CXI_IB_SVC_MAX_VNIS)
+			return -EOPNOTSUPP;
+		config.vni_count = desc.num_vld_vnis;
+		if (desc.num_vld_vnis)
+			memcpy(config.vnis, desc.vnis,
+			       desc.num_vld_vnis * sizeof(config.vnis[0]));
+	} else {
+		ret = ctx->cadev->svc_get_vni_range(ctx->cadev->cxi_dev,
+						   config.svc_id, &first, &last);
+		if (ret)
+			return ret;
+		config.is_range = 1;
+		config.vnis[0] = first;
+		config.vnis[1] = last;
+	}
+	for (index = 0; index < CXI_TC_MAX; index++)
+		if (!desc.is_system_svc &&
+		    (!desc.restricted_tcs || desc.tcs[index]))
+			config.tc_mask |= BIT(index);
+	config.uid = desc.members[0].svc_member.uid;
+	for (index = 0; index < ARRAY_SIZE(limits); index++) {
+		config.maximum[index] = limits[index]->max;
+		config.reserved[index] = limits[index]->res;
+	}
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_SVC_CONFIG,
+			     &config, sizeof(config));
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_SVC_ALLOC,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_SVC_CONFIG,
+			   UVERBS_ATTR_TYPE(struct cxi_ibv_svc_config), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_SVC_ID,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_SVC_DESTROY,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_SVC_ID,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_SVC_ENABLE,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_SVC_ID,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_SVC_FLAGS,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_SVC_QUERY,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_SVC_ID,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_SVC_CONFIG,
+			    UVERBS_ATTR_TYPE(struct cxi_ibv_svc_config), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_SVC_FLAGS,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_SVC_USAGE,
+			    UVERBS_ATTR_TYPE(struct cxi_ibv_svc_rsrc_use), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_SVC_LPR,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL));
+
+DECLARE_UVERBS_GLOBAL_METHODS(CXI_IB_OBJECT_SVC,
+	&UVERBS_METHOD(CXI_IB_METHOD_SVC_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_SVC_DESTROY),
+	&UVERBS_METHOD(CXI_IB_METHOD_SVC_QUERY),
+	&UVERBS_METHOD(CXI_IB_METHOD_SVC_ENABLE));
+
+struct cxiverbs_wait {
+	struct ib_uobject uobj;
+	struct cxiverbs_lni *lni;
+	wait_queue_head_t poll_wait;
+	struct mutex read_lock;
+	atomic64_t generation;
+	atomic64_t cleared;
+	bool initialized;
+	bool dead;
+};
+
+static ssize_t cxiverbs_wait_read(struct file *file, char __user *buffer,
+				size_t length, loff_t *offset)
+{
+	struct cxiverbs_wait *wait =
+		container_of(file->private_data, struct cxiverbs_wait, uobj);
+	u64 generation;
+	char value = '1';
+	int ret;
+
+	if (!length)
+		return 0;
+	ret = mutex_lock_interruptible(&wait->read_lock);
+	if (ret)
+		return ret;
+	if (READ_ONCE(wait->dead)) {
+		ret = -EIO;
+		goto unlock;
+	}
+	generation = atomic64_read(&wait->generation);
+	if (copy_to_user(buffer, &value, sizeof(value))) {
+		ret = -EFAULT;
+		goto unlock;
+	}
+	atomic64_set(&wait->cleared, generation);
+	ret = sizeof(value);
+unlock:
+	mutex_unlock(&wait->read_lock);
+	return ret;
+}
+
+static __poll_t cxiverbs_wait_poll(struct file *file, poll_table *table)
+{
+	struct cxiverbs_wait *wait =
+		container_of(file->private_data, struct cxiverbs_wait, uobj);
+
+	poll_wait(file, &wait->poll_wait, table);
+	if (READ_ONCE(wait->dead))
+		return EPOLLHUP | EPOLLERR;
+	if (atomic64_read(&wait->generation) != atomic64_read(&wait->cleared))
+		return EPOLLPRI;
+	return 0;
+}
+
+static const struct file_operations cxiverbs_wait_fops = {
+	.owner = THIS_MODULE,
+	.read = cxiverbs_wait_read,
+	.poll = cxiverbs_wait_poll,
+	.release = uverbs_uobject_fd_release,
+	.llseek = noop_llseek,
+};
+
+static void cxiverbs_wait_cleanup(struct ib_uobject *object,
+				 enum rdma_remove_reason reason)
+{
+	struct cxiverbs_wait *wait =
+		container_of(object, struct cxiverbs_wait, uobj);
+
+	if (!wait->initialized)
+		return;
+	WRITE_ONCE(wait->dead, true);
+	wake_up_interruptible_poll(&wait->poll_wait, EPOLLHUP | EPOLLERR);
+	if (wait->lni) {
+		cxiverbs_lni_put(wait->lni);
+		wait->lni = NULL;
+	}
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_WAIT_ALLOC)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *object =
+		uverbs_attr_get_uobject(attrs, CXI_IB_ATTR_WAIT_FD);
+	struct file *file = object->object;
+	struct cxiverbs_wait *wait =
+		container_of(object, struct cxiverbs_wait, uobj);
+	struct cxiverbs_ucontext *ctx;
+	u32 handle;
+	int ret;
+
+	init_waitqueue_head(&wait->poll_wait);
+	mutex_init(&wait->read_lock);
+	atomic64_set(&wait->generation, 1);
+	atomic64_set(&wait->cleared, 0);
+	wait->initialized = true;
+	ctx = cxiverbs_get_ucontext(attrs);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	ret = uverbs_copy_from(&handle, attrs, CXI_IB_ATTR_WAIT_LNI);
+	if (ret)
+		return ret;
+	wait->lni = cxiverbs_lni_get(ctx, handle);
+	if (IS_ERR(wait->lni)) {
+		ret = PTR_ERR(wait->lni);
+		wait->lni = NULL;
+		return ret;
+	}
+	file->f_mode |= FMODE_PREAD;
+	return 0;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_WAIT_ALLOC,
+	UVERBS_ATTR_FD(CXI_IB_ATTR_WAIT_FD, CXI_IB_OBJECT_WAIT,
+		       UVERBS_ACCESS_NEW, UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_WAIT_LNI,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(CXI_IB_OBJECT_WAIT,
+	UVERBS_TYPE_ALLOC_FD(sizeof(struct cxiverbs_wait),
+			     cxiverbs_wait_cleanup,
+			     &cxiverbs_wait_fops, "[cxiwait]", O_RDONLY),
+	&UVERBS_METHOD(CXI_IB_METHOD_WAIT_ALLOC));
+
+static void cxiverbs_wait_notify(void *data)
+{
+	struct file *file = data;
+	struct cxiverbs_wait *wait =
+		container_of(file->private_data, struct cxiverbs_wait, uobj);
+
+	if (READ_ONCE(wait->dead))
+		return;
+	atomic64_inc(&wait->generation);
+	wake_up_interruptible_poll(&wait->poll_wait, EPOLLPRI);
+}
+
+static int cxiverbs_eq_get_wait(struct uverbs_attr_bundle *attrs, u16 attr,
+			       struct cxiverbs_lni *lni, struct file **file)
+{
+	struct ib_uobject *object;
+	struct cxiverbs_wait *wait;
+
+	if (!uverbs_attr_is_valid(attrs, attr))
+		return 0;
+	object = uverbs_attr_get_uobject(attrs, attr);
+	wait = container_of(object, struct cxiverbs_wait, uobj);
+	if (READ_ONCE(wait->dead) || wait->lni != lni)
+		return -EINVAL;
+	*file = get_file(object->object);
+	return 0;
+}
+
+struct cxiverbs_native_eq {
+	struct cxiverbs_lni *lni;
+	struct cxiverbs_mr *mr;
+	struct file *event_wait;
+	struct file *status_wait;
+	struct cxi_eq *eq;
+	struct cxiverbs_mmap_entry *doorbell;
+	atomic_t users;
+};
+
+/*
+ * Runs once the hardware EQ is gone and the last doorbell mapping is closed.
+ * Only drops references and frees memory, so it cannot fail.
+ */
+static void cxiverbs_native_eq_release(void *owner)
+{
+	struct cxiverbs_native_eq *queue = owner;
+
+	if (queue->status_wait)
+		fput(queue->status_wait);
+	if (queue->event_wait)
+		fput(queue->event_wait);
+	if (queue->mr)
+		atomic_dec(&queue->mr->native_users);
+	cxiverbs_lni_put(queue->lni);
+	kfree(queue);
+}
+
+static int cxiverbs_native_eq_cleanup(struct ib_uobject *object,
+				     enum rdma_remove_reason reason,
+				     struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_native_eq *queue = object->object;
+	int ret;
+
+	if (atomic_read(&queue->users))
+		return -EBUSY;
+	/*
+	 * eq_free() can fail (a VF may be unable to reach the PF) and leaves
+	 * the EQ untouched when it does. Do it here, where rdma-core can
+	 * report the error and retry, rather than from mmap_free(), which
+	 * has no way to fail.
+	 */
+	ret = queue->lni->ctx->cadev->eq_free(queue->eq);
+	if (ret)
+		return ret;
+	/*
+	 * The queue, and the LNI reference it holds, stay alive until the last
+	 * doorbell mapping is closed, so the EQ number cannot be recycled
+	 * while the page is still mapped.
+	 */
+	if (queue->doorbell)
+		rdma_user_mmap_entry_remove(&queue->doorbell->rdma_entry);
+	else
+		cxiverbs_native_eq_release(queue);
+	return 0;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_EQ_ALLOC)(struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	struct ib_uobject *object = uverbs_attr_get_uobject(attrs, CXI_IB_ATTR_EQ_HANDLE);
+	struct ib_mr *ibmr = NULL;
+	struct cxiverbs_mr *mr = NULL;
+	struct cxiverbs_native_eq *queue;
+	struct cxi_ibv_eq_config config;
+	struct cxi_ibv_eq_info info = {};
+	struct cxi_eq_attr native = {};
+	phys_addr_t physical;
+	size_t size;
+	u64 offset;
+	u32 lni_handle;
+	u32 flags = 0;
+	bool passthrough;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	ret = uverbs_get_flags32(&flags, attrs, CXI_IB_ATTR_EQ_FLAGS,
+				CXI_IB_EQ_REGISTER_PCT | CXI_IB_EQ_PASSTHROUGH);
+	if (ret)
+		return ret;
+	passthrough = flags & CXI_IB_EQ_PASSTHROUGH;
+	if (passthrough && !(flags & CXI_IB_EQ_REGISTER_PCT))
+		return -EINVAL;
+	if (passthrough == uverbs_attr_is_valid(attrs, CXI_IB_ATTR_EQ_MR))
+		return -EINVAL;
+	if (!passthrough) {
+		ibmr = uverbs_attr_get_obj(attrs, CXI_IB_ATTR_EQ_MR);
+		mr = to_cxiverbs_mr(ibmr);
+	}
+	if (flags & CXI_IB_EQ_REGISTER_PCT) {
+		struct cxi_dev *cdev = ctx->cadev->cxi_dev;
+		u32 generation = cdev->prop.cassini_version & 0xf0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+		if (!cdev->is_physfn ||
+		    (generation != CASSINI_1 && generation != CASSINI_2))
+			return -EOPNOTSUPP;
+	}
+	ret = uverbs_copy_from(&lni_handle, attrs, CXI_IB_ATTR_EQ_LNI);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&config, attrs, CXI_IB_ATTR_EQ_CONFIG);
+	if (ret)
+		return ret;
+	if (!config.length)
+		return -EINVAL;
+	if (mr && (config.address < mr->md->va ||
+		   config.length > mr->md->len ||
+		   config.address - mr->md->va > mr->md->len - config.length))
+		return -EINVAL;
+	queue = kzalloc_obj(*queue, GFP_KERNEL);
+	if (!queue)
+		return -ENOMEM;
+	queue->lni = cxiverbs_lni_get(ctx, lni_handle);
+	if (IS_ERR(queue->lni)) {
+		ret = PTR_ERR(queue->lni);
+		goto free_queue;
+	}
+	if (mr && to_cxiverbs_pd(ibmr->pd)->lni_ref != queue->lni) {
+		ret = -EINVAL;
+		goto put_lni;
+	}
+	queue->mr = mr;
+	if (mr)
+		atomic_inc(&mr->native_users);
+	native.queue = (void *)(uintptr_t)config.address;
+	native.queue_len = config.length;
+	native.flags = CXI_EQ_USER;
+	if (flags & CXI_IB_EQ_REGISTER_PCT)
+		native.flags |= CXI_EQ_REGISTER_PCT;
+	if (passthrough)
+		native.flags |= CXI_EQ_PASSTHROUGH;
+	native.status_thresh_base = config.threshold_base;
+	native.status_thresh_delta = config.threshold_delta;
+	native.status_thresh_count = config.threshold_count;
+	native.ec_delay = config.ec_delay;
+	native.cpu_affinity = config.cpu;
+	native.reserved_slots = config.reserved_slots;
+	ret = cxiverbs_eq_get_wait(attrs, CXI_IB_ATTR_EQ_EVENT_WAIT,
+				   queue->lni, &queue->event_wait);
+	if (ret)
+		goto put_waits;
+	ret = cxiverbs_eq_get_wait(attrs, CXI_IB_ATTR_EQ_STATUS_WAIT,
+				   queue->lni, &queue->status_wait);
+	if (ret)
+		goto put_waits;
+	queue->eq = ctx->cadev->eq_alloc(queue->lni->lni, mr ? mr->md : NULL,
+		&native, queue->event_wait ? cxiverbs_wait_notify : NULL,
+		queue->event_wait,
+		queue->status_wait ? cxiverbs_wait_notify : NULL,
+		queue->status_wait);
+	if (IS_ERR(queue->eq)) {
+		ret = PTR_ERR(queue->eq);
+		goto put_waits;
+	}
+	ret = ctx->cadev->eq_user_info(queue->eq, &physical, &size);
+	if (ret)
+		goto destroy_eq;
+	if (flags & CXI_IB_EQ_REGISTER_PCT)
+		queue->doorbell = cxiverbs_mmap_entry_alloc_admin(
+			&ctx->ibucontext, physical, size, &offset);
+	else
+		queue->doorbell = cxiverbs_mmap_entry_alloc(
+			&ctx->ibucontext, true, physical, NULL, size, &offset);
+	if (IS_ERR(queue->doorbell)) {
+		ret = PTR_ERR(queue->doorbell);
+		queue->doorbell = NULL;
+		goto destroy_eq;
+	}
+	queue->doorbell->owner = queue;
+	queue->doorbell->release_owner = cxiverbs_native_eq_release;
+	info.doorbell_offset = offset;
+	info.doorbell_size = size;
+	info.eqn = queue->eq->eqn;
+	object->object = queue;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_EQ_HANDLE);
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_EQ_INFO, &info, sizeof(info));
+destroy_eq:
+	/*
+	 * The hardware EQ exists, so let rdma-core unwind it through
+	 * cxiverbs_native_eq_cleanup(). If eq_free() fails there, the core
+	 * keeps the object and retries instead of leaking it.
+	 */
+	object->object = queue;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_EQ_HANDLE);
+	return ret;
+put_waits:
+	if (queue->status_wait)
+		fput(queue->status_wait);
+	if (queue->event_wait)
+		fput(queue->event_wait);
+	if (mr)
+		atomic_dec(&mr->native_users);
+put_lni:
+	cxiverbs_lni_put(queue->lni);
+free_queue:
+	kfree(queue);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_EQ_ALLOC,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_EQ_HANDLE, CXI_IB_OBJECT_EQ,
+			UVERBS_ACCESS_NEW, UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_EQ_LNI, UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_EQ_MR, UVERBS_OBJECT_MR,
+			UVERBS_ACCESS_READ, UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_EQ_CONFIG,
+			   UVERBS_ATTR_TYPE(struct cxi_ibv_eq_config), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_EQ_INFO,
+			    UVERBS_ATTR_TYPE(struct cxi_ibv_eq_info),
+			    UA_MANDATORY),
+	UVERBS_ATTR_FLAGS_IN(CXI_IB_ATTR_EQ_FLAGS, u32, UA_OPTIONAL),
+	UVERBS_ATTR_FD(CXI_IB_ATTR_EQ_EVENT_WAIT, CXI_IB_OBJECT_WAIT,
+		       UVERBS_ACCESS_READ, UA_OPTIONAL),
+	UVERBS_ATTR_FD(CXI_IB_ATTR_EQ_STATUS_WAIT, CXI_IB_OBJECT_WAIT,
+		       UVERBS_ACCESS_READ, UA_OPTIONAL));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(CXI_IB_METHOD_EQ_DESTROY,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_EQ_HANDLE, CXI_IB_OBJECT_EQ,
+			UVERBS_ACCESS_DESTROY, UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(CXI_IB_OBJECT_EQ,
+	UVERBS_TYPE_ALLOC_IDR(cxiverbs_native_eq_cleanup),
+	&UVERBS_METHOD(CXI_IB_METHOD_EQ_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_EQ_DESTROY));
+
+struct cxiverbs_cp {
+	struct cxiverbs_lni *lni;
+	struct cxi_cp *cp;
+};
+
+static int cxiverbs_cp_cleanup(struct ib_uobject *object,
+			      enum rdma_remove_reason reason,
+			      struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_cp *profile = object->object;
+
+	profile->lni->ctx->cadev->cp_free(profile->cp);
+	cxiverbs_lni_put(profile->lni);
+	kfree(profile);
+	return 0;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_CP_ALLOC)(struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *object = uverbs_attr_get_uobject(attrs, CXI_IB_ATTR_CP_HANDLE);
+	struct cxiverbs_ucontext *ctx = cxiverbs_get_ucontext(attrs);
+	struct cxiverbs_cp *profile;
+	struct cxi_ibv_cp_info info;
+	u32 lni_handle, vni, tc, type;
+	int ret;
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	ret = uverbs_copy_from(&lni_handle, attrs, CXI_IB_ATTR_CP_LNI);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&vni, attrs, CXI_IB_ATTR_CP_VNI);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&tc, attrs, CXI_IB_ATTR_CP_TC);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&type, attrs, CXI_IB_ATTR_CP_TYPE);
+	if (ret)
+		return ret;
+	if (!vni || vni > U16_MAX || tc >= CXI_TC_MAX || type >= CXI_TC_TYPE_MAX)
+		return -EINVAL;
+	profile = kzalloc_obj(*profile, GFP_KERNEL);
+	if (!profile)
+		return -ENOMEM;
+	profile->lni = cxiverbs_lni_get(ctx, lni_handle);
+	if (IS_ERR(profile->lni)) {
+		ret = PTR_ERR(profile->lni);
+		goto free_profile;
+	}
+	profile->cp = ctx->cadev->cp_alloc(profile->lni->lni, vni, tc, type);
+	if (IS_ERR(profile->cp)) {
+		ret = PTR_ERR(profile->cp);
+		goto put_lni;
+	}
+	info.vni = profile->cp->vni_pcp;
+	info.tc = profile->cp->tc;
+	info.type = profile->cp->tc_type;
+	info.lcid = profile->cp->lcid;
+	object->object = profile;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_CP_HANDLE);
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_CP_INFO, &info, sizeof(info));
+put_lni:
+	cxiverbs_lni_put(profile->lni);
+free_profile:
+	kfree(profile);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_CP_ALLOC,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CP_HANDLE, CXI_IB_OBJECT_CP,
+			UVERBS_ACCESS_NEW, UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CP_LNI, UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CP_VNI, UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CP_TC, UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CP_TYPE, UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CP_INFO,
+			    UVERBS_ATTR_TYPE(struct cxi_ibv_cp_info), UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(CXI_IB_METHOD_CP_DESTROY,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CP_HANDLE, CXI_IB_OBJECT_CP,
+			UVERBS_ACCESS_DESTROY, UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(CXI_IB_OBJECT_CP,
+	UVERBS_TYPE_ALLOC_IDR(cxiverbs_cp_cleanup),
+	&UVERBS_METHOD(CXI_IB_METHOD_CP_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_CP_DESTROY));
+
+/* -----------------------------------------------------------------------
+ * Per-CT kernel object.  Heap-allocated; freed in cxiverbs_ct_cleanup().
+ * -----------------------------------------------------------------------
+ */
+struct cxiverbs_ct {
+	refcount_t refs;
+	struct cxi_ct            *ct;       /* CXI counting trigger          */
+	struct cxiverbs_lni *lni_ref;
+	struct page              *wb_page;  /* writeback-buffer page         */
+	struct cxiverbs_mmap_entry *wb_mmap;  /* userspace mmap: writeback buf */
+	struct cxiverbs_mmap_entry *db_mmap;  /* userspace mmap: CT doorbell   */
+};
+
+static void cxiverbs_ct_release(void *owner)
+{
+	struct cxiverbs_ct *ct = owner;
+
+	if (!refcount_dec_and_test(&ct->refs))
+		return;
+	if (ct->ct)
+		cxi_ct_free(ct->ct);
+	if (ct->wb_page)
+		unpin_user_page(ct->wb_page);
+	cxiverbs_lni_put(ct->lni_ref);
+	kfree(ct);
+}
+
+/* -----------------------------------------------------------------------
+ * IDR object cleanup — called on CT_DESTROY and on context teardown.
+ * -----------------------------------------------------------------------
+ */
+static int cxiverbs_ct_cleanup(struct ib_uobject *uobj,
+			      enum rdma_remove_reason why,
+			      struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_ct *ct = uobj->object;
+
+	if (ct->db_mmap)
+		rdma_user_mmap_entry_remove(&ct->db_mmap->rdma_entry);
+	if (ct->wb_mmap)
+		rdma_user_mmap_entry_remove(&ct->wb_mmap->rdma_entry);
+	cxiverbs_ct_release(ct);
+	return 0;
+}
+
+/* -----------------------------------------------------------------------
+ * CXI_IB_METHOD_CT_ALLOC handler
+ * -----------------------------------------------------------------------
+ */
+static int UVERBS_HANDLER(CXI_IB_METHOD_CT_ALLOC)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject  *uobj   = uverbs_attr_get_uobject(attrs,
+					CXI_IB_ATTR_CT_ALLOC_HANDLE);
+	struct ib_ucontext *ibctx  = ib_uverbs_get_ucontext(attrs);
+	struct cxiverbs_ucontext *uctx;
+	struct cxi_adev *cadev;
+	struct cxiverbs_ct   *ct_obj;
+	struct c_ct_writeback *wb;
+	phys_addr_t db_phys;
+	size_t      db_sz;
+	u64         wb_offset = 0, db_offset = 0;
+	u64         wb_len, db_len;
+	u64 wb_address;
+	u32         ctn;
+	u32 lni_handle = CXI_IBV_LNI_ANY;
+	int         ret;
+
+	if (IS_ERR(ibctx))
+		return PTR_ERR(ibctx);
+
+	uctx = to_cxiverbs_ucontext(ibctx);
+	cadev = uctx->cadev;
+	ret = uverbs_copy_from(&wb_address, attrs,
+			       CXI_IB_ATTR_CT_ALLOC_WB_ADDRESS);
+	if (ret)
+		return ret;
+	if (!wb_address || !IS_ALIGNED(wb_address, PAGE_SIZE) ||
+	    wb_address != (unsigned long)wb_address ||
+	    !access_ok(u64_to_user_ptr(wb_address), PAGE_SIZE))
+		return -EINVAL;
+
+	ct_obj = kzalloc_obj(*ct_obj);
+	if (!ct_obj)
+		return -ENOMEM;
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_CT_ALLOC_LNI_HANDLE)) {
+		ret = uverbs_copy_from(&lni_handle, attrs,
+				       CXI_IB_ATTR_CT_ALLOC_LNI_HANDLE);
+		if (ret)
+			goto err_free_object;
+	}
+	ct_obj->lni_ref = cxiverbs_lni_get(uctx, lni_handle);
+	if (IS_ERR(ct_obj->lni_ref)) {
+		ret = PTR_ERR(ct_obj->lni_ref);
+		goto err_free_object;
+	}
+	refcount_set(&ct_obj->refs, 1);
+
+	ret = pin_user_pages_fast(wb_address, 1, FOLL_WRITE | FOLL_LONGTERM,
+				  &ct_obj->wb_page);
+	if (ret != 1) {
+		ct_obj->wb_page = NULL;
+		if (ret >= 0)
+			ret = -EFAULT;
+		goto err_release;
+	}
+	wb = (struct c_ct_writeback *)(unsigned long)wb_address;
+
+	ct_obj->ct = cadev->ct_alloc(ct_obj->lni_ref->lni, wb, true);
+	if (IS_ERR(ct_obj->ct)) {
+		ret = PTR_ERR(ct_obj->ct);
+		ct_obj->ct = NULL;
+		goto err_release;
+	}
+
+	/* Get the physical address of the CT doorbell CSR for mmap. */
+	ret = cxi_ct_user_info(ct_obj->ct, &db_phys, &db_sz);
+	if (ret)
+		goto err_release;
+
+	wb_len = PAGE_SIZE;
+	db_len = (u64)db_sz;
+
+	/* Create mmap entry for the writeback buffer page. */
+	refcount_inc(&ct_obj->refs);
+	ct_obj->wb_mmap = cxiverbs_mmap_entry_alloc_owned(ibctx, false, 0,
+				ct_obj->wb_page, wb_len, &wb_offset, ct_obj,
+				cxiverbs_ct_release);
+	if (IS_ERR(ct_obj->wb_mmap)) {
+		ret = PTR_ERR(ct_obj->wb_mmap);
+		ct_obj->wb_mmap = NULL;
+		refcount_dec(&ct_obj->refs);
+		goto err_release;
+	}
+
+	/* Create mmap entry for the CT doorbell CSR (IO mapping). */
+	refcount_inc(&ct_obj->refs);
+	ct_obj->db_mmap = cxiverbs_mmap_entry_alloc_owned(ibctx, true, db_phys,
+				NULL, db_len, &db_offset, ct_obj,
+				cxiverbs_ct_release);
+	if (IS_ERR(ct_obj->db_mmap)) {
+		ret = PTR_ERR(ct_obj->db_mmap);
+		ct_obj->db_mmap = NULL;
+		refcount_dec(&ct_obj->refs);
+		goto err_remove_wb;
+	}
+
+	ctn = ct_obj->ct->ctn;
+
+	/* Commit the uobject — after this, returning an error will cause the
+	 * framework to call cxiverbs_ct_cleanup() automatically.
+	 */
+	uobj->object = ct_obj;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_CT_ALLOC_HANDLE);
+
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_CT_ALLOC_CTN,
+			     &ctn, sizeof(ctn));
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_CT_ALLOC_WB_MMAP_OFFSET,
+			     &wb_offset, sizeof(wb_offset));
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_CT_ALLOC_WB_MMAP_LENGTH,
+			     &wb_len, sizeof(wb_len));
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_CT_ALLOC_DB_MMAP_OFFSET,
+			     &db_offset, sizeof(db_offset));
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_CT_ALLOC_DB_MMAP_LENGTH,
+			     &db_len, sizeof(db_len));
+	return ret;
+
+err_remove_wb:
+	rdma_user_mmap_entry_remove(&ct_obj->wb_mmap->rdma_entry);
+err_release:
+	cxiverbs_ct_release(ct_obj);
+	return ret;
+err_free_object:
+	kfree(ct_obj);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------
+ * Method definitions
+ * -----------------------------------------------------------------------
+ */
+DECLARE_UVERBS_NAMED_METHOD(
+	CXI_IB_METHOD_CT_ALLOC,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CT_ALLOC_WB_ADDRESS,
+			   UVERBS_ATTR_TYPE(u64), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CT_ALLOC_LNI_HANDLE,
+			   UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CT_ALLOC_HANDLE,
+			CXI_IB_OBJECT_CT,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CT_ALLOC_CTN,
+			    UVERBS_ATTR_TYPE(u32),
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CT_ALLOC_WB_MMAP_OFFSET,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CT_ALLOC_WB_MMAP_LENGTH,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CT_ALLOC_DB_MMAP_OFFSET,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CT_ALLOC_DB_MMAP_LENGTH,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(
+	CXI_IB_METHOD_CT_DESTROY,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CT_DESTROY_HANDLE,
+			CXI_IB_OBJECT_CT,
+			UVERBS_ACCESS_DESTROY,
+			UA_MANDATORY));
+
+/* -----------------------------------------------------------------------
+ * Object definition
+ * -----------------------------------------------------------------------
+ */
+DECLARE_UVERBS_NAMED_OBJECT(
+	CXI_IB_OBJECT_CT,
+	UVERBS_TYPE_ALLOC_IDR(cxiverbs_ct_cleanup),
+	&UVERBS_METHOD(CXI_IB_METHOD_CT_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_CT_DESTROY));
+
+struct cxiverbs_cmdq {
+	refcount_t refs;
+	struct cxiverbs_lni *lni;
+	struct cxi_cq *cq;
+	struct cxiverbs_mmap_entry *commands;
+	struct cxiverbs_mmap_entry *doorbell;
+};
+
+static void cxiverbs_cmdq_release(void *owner)
+{
+	struct cxiverbs_cmdq *cmdq = owner;
+
+	if (!refcount_dec_and_test(&cmdq->refs))
+		return;
+	if (cmdq->cq)
+		cmdq->lni->ctx->cadev->cq_free(cmdq->cq);
+	cxiverbs_lni_put(cmdq->lni);
+	kfree(cmdq);
+}
+
+static int cxiverbs_cmdq_cleanup(struct ib_uobject *object,
+				enum rdma_remove_reason reason,
+				struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_cmdq *cmdq = object->object;
+
+	if (cmdq->doorbell)
+		rdma_user_mmap_entry_remove(&cmdq->doorbell->rdma_entry);
+	if (cmdq->commands)
+		rdma_user_mmap_entry_remove(&cmdq->commands->rdma_entry);
+	cxiverbs_cmdq_release(cmdq);
+	return 0;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_CMDQ_ALLOC)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *object =
+		uverbs_attr_get_uobject(attrs, CXI_IB_ATTR_CMDQ_HANDLE);
+	struct cxi_cq_alloc_opts opts = { .flags = CXI_CQ_USER };
+	struct cxi_ibv_cmdq_info info = {};
+	struct cxiverbs_ucontext *ctx;
+	struct cxiverbs_cmdq *cmdq;
+	struct page *pages;
+	phys_addr_t doorbell;
+	size_t commands_size;
+	size_t doorbell_size;
+	u64 offset;
+	u32 handle;
+	u32 flags = 0;
+	int ret;
+
+	ctx = cxiverbs_get_ucontext(attrs);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	if (!ctx->cadev->cq_alloc || !ctx->cadev->cq_free ||
+	    !ctx->cadev->cq_user_info)
+		return -EOPNOTSUPP;
+	ret = uverbs_copy_from(&handle, attrs, CXI_IB_ATTR_CMDQ_LNI);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&opts.count, attrs, CXI_IB_ATTR_CMDQ_COUNT);
+	if (ret)
+		return ret;
+	if (!opts.count || opts.count > CXI_MAX_CQ_COUNT)
+		return -EINVAL;
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_CMDQ_FLAGS)) {
+		ret = uverbs_copy_from(&flags, attrs, CXI_IB_ATTR_CMDQ_FLAGS);
+		if (ret)
+			return ret;
+	}
+	if (flags & ~CXI_IB_CMDQ_TRIGGER)
+		return -EINVAL;
+	if (flags & CXI_IB_CMDQ_TRIGGER)
+		opts.flags |= CXI_CQ_IS_TX | CXI_CQ_TX_WITH_TRIG_CMDS;
+	cmdq = kzalloc_obj(*cmdq, GFP_KERNEL);
+	if (!cmdq)
+		return -ENOMEM;
+	cmdq->lni = cxiverbs_lni_get(ctx, handle);
+	if (IS_ERR(cmdq->lni)) {
+		ret = PTR_ERR(cmdq->lni);
+		kfree(cmdq);
+		return ret;
+	}
+	refcount_set(&cmdq->refs, 1);
+	cmdq->cq = ctx->cadev->cq_alloc(cmdq->lni->lni, NULL, &opts,
+				       NUMA_NO_NODE);
+	if (IS_ERR(cmdq->cq)) {
+		ret = PTR_ERR(cmdq->cq);
+		cmdq->cq = NULL;
+		goto release;
+	}
+	ret = ctx->cadev->cq_user_info(cmdq->cq, &commands_size, &pages,
+				      &doorbell, &doorbell_size);
+	if (ret)
+		goto release;
+	info.count = cmdq->cq->size;
+	info.index = cmdq->cq->idx;
+	info.commands_length = commands_size;
+	info.doorbell_length = doorbell_size;
+	refcount_inc(&cmdq->refs);
+	cmdq->commands = cxiverbs_mmap_entry_alloc_owned(&ctx->ibucontext,
+			false, 0, pages, commands_size, &offset, cmdq,
+			cxiverbs_cmdq_release);
+	if (IS_ERR(cmdq->commands)) {
+		ret = PTR_ERR(cmdq->commands);
+		cmdq->commands = NULL;
+		refcount_dec(&cmdq->refs);
+		goto release;
+	}
+	info.commands_offset = offset;
+	refcount_inc(&cmdq->refs);
+	cmdq->doorbell = cxiverbs_mmap_entry_alloc_owned(&ctx->ibucontext,
+			true, doorbell, NULL, doorbell_size, &offset, cmdq,
+			cxiverbs_cmdq_release);
+	if (IS_ERR(cmdq->doorbell)) {
+		ret = PTR_ERR(cmdq->doorbell);
+		cmdq->doorbell = NULL;
+		refcount_dec(&cmdq->refs);
+		rdma_user_mmap_entry_remove(&cmdq->commands->rdma_entry);
+		goto release;
+	}
+	info.doorbell_offset = offset;
+	object->object = cmdq;
+	uverbs_finalize_uobj_create(attrs, CXI_IB_ATTR_CMDQ_HANDLE);
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_CMDQ_INFO,
+			     &info, sizeof(info));
+release:
+	cxiverbs_cmdq_release(cmdq);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(CXI_IB_METHOD_CMDQ_ALLOC,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CMDQ_HANDLE, CXI_IB_OBJECT_CMDQ,
+		       UVERBS_ACCESS_NEW, UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CMDQ_LNI,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CMDQ_COUNT,
+			   UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_CMDQ_INFO,
+			    UVERBS_ATTR_TYPE(struct cxi_ibv_cmdq_info),
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_CMDQ_FLAGS, UVERBS_ATTR_TYPE(u32)));
+
+DECLARE_UVERBS_NAMED_METHOD_DESTROY(CXI_IB_METHOD_CMDQ_DESTROY,
+	UVERBS_ATTR_IDR(CXI_IB_ATTR_CMDQ_HANDLE, CXI_IB_OBJECT_CMDQ,
+		       UVERBS_ACCESS_DESTROY, UA_MANDATORY));
+
+DECLARE_UVERBS_NAMED_OBJECT(CXI_IB_OBJECT_CMDQ,
+	UVERBS_TYPE_ALLOC_IDR(cxiverbs_cmdq_cleanup),
+	&UVERBS_METHOD(CXI_IB_METHOD_CMDQ_ALLOC),
+	&UVERBS_METHOD(CXI_IB_METHOD_CMDQ_DESTROY));
+
+static int cxiverbs_copy_job_tc_limit(struct uverbs_attr_bundle *attrs,
+				    int max_attr, int res_attr,
+				    struct cxi_limits *limit)
+{
+	int ret;
+
+	if (uverbs_attr_is_valid(attrs, max_attr)) {
+		ret = uverbs_copy_from(&limit->max, attrs, max_attr);
+		if (ret)
+			return ret;
+	}
+	if (uverbs_attr_is_valid(attrs, res_attr)) {
+		ret = uverbs_copy_from(&limit->res, attrs, res_attr);
+		if (ret)
+			return ret;
+	}
+
+	return limit->max < limit->res ? -EINVAL : 0;
+}
+
+static u32 cxiverbs_tc_key(u32 tc, u32 tc_type)
+{
+	return (tc_type << 16) | tc;
+}
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_JOB_TC_BIND)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_ucontext *ibctx = ib_uverbs_get_ucontext(attrs);
+	struct cxiverbs_ucontext *uctx;
+	struct cxiverbs_dev *dev;
+	struct cxiverbs_job_entry *job;
+	struct cxiverbs_job_tc_binding *binding = NULL;
+	struct cxiverbs_tc_entry *tc_entry = NULL;
+	struct cxi_rsrc_limits limits = {};
+	u32 flags = 0;
+	u32 tc_key;
+	u32 job_id;
+	u32 svc_id;
+	u32 bound_svc_id;
+	u32 tc;
+	u32 tc_type = CXI_TC_TYPE_DEFAULT;
+	bool create_tc;
+	bool created_tc = false;
+	int ret;
+
+	if (IS_ERR(ibctx))
+		return PTR_ERR(ibctx);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	uctx = to_cxiverbs_ucontext(ibctx);
+	dev = to_cxiverbs_dev(ibctx->device);
+	if (!uctx->cadev->job_tc_bind)
+		return -EOPNOTSUPP;
+
+	ret = uverbs_get_flags32(&flags, attrs,
+				  CXI_IB_ATTR_JOB_TC_BIND_FLAGS,
+				  CXI_IB_JOB_TC_F_CREATE);
+	if (ret)
+		return ret;
+
+	ret = uverbs_copy_from(&job_id, attrs, CXI_IB_ATTR_JOB_TC_BIND_JOB_ID);
+	if (ret)
+		return ret;
+	ret = uverbs_copy_from(&tc, attrs, CXI_IB_ATTR_JOB_TC_BIND_TC);
+	if (ret)
+		return ret;
+
+	svc_id = 0;
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_JOB_TC_BIND_SVC_ID)) {
+		ret = uverbs_copy_from(&svc_id, attrs,
+				       CXI_IB_ATTR_JOB_TC_BIND_SVC_ID);
+		if (ret)
+			return ret;
+	}
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_JOB_TC_BIND_TC_TYPE)) {
+		ret = uverbs_copy_from(&tc_type, attrs,
+				       CXI_IB_ATTR_JOB_TC_BIND_TC_TYPE);
+		if (ret)
+			return ret;
+	}
+
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_PTES_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_PTES_RES,
+			&limits.ptes);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_TXQS_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_TXQS_RES,
+			&limits.txqs);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_TGQS_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_TGQS_RES,
+			&limits.tgqs);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_EQS_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_EQS_RES,
+			&limits.eqs);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_CTS_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_CTS_RES,
+			&limits.cts);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_LES_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_LES_RES,
+			&limits.les);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_TLES_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_TLES_RES,
+			&limits.tles);
+	if (ret)
+		return ret;
+	ret = cxiverbs_copy_job_tc_limit(attrs,
+			CXI_IB_ATTR_JOB_TC_BIND_ACS_MAX,
+			CXI_IB_ATTR_JOB_TC_BIND_ACS_RES,
+			&limits.acs);
+	if (ret)
+		return ret;
+
+	mutex_lock(&dev->jobs_lock);
+	job = uctx->job;
+	if (!job || job->job_id != job_id) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	create_tc = flags & CXI_IB_JOB_TC_F_CREATE;
+	tc_key = cxiverbs_tc_key(tc, tc_type);
+	tc_entry = xa_load(&dev->tcs, tc_key);
+	if (create_tc) {
+		if (tc_entry) {
+			ret = -EEXIST;
+			goto out_unlock;
+		}
+	}
+
+	if (tc_entry) {
+		list_for_each_entry(binding, &tc_entry->job_list, entry) {
+			if (binding->job == job) {
+				ret = -EEXIST;
+				goto out_unlock;
+			}
+		}
+		binding = NULL;
+	}
+
+	binding = kzalloc_obj(*binding);
+	if (!binding) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	ret = uctx->cadev->job_tc_bind(uctx->cadev->cxi_dev, job_id, svc_id,
+					 tc, tc_type, create_tc, &limits,
+					 &bound_svc_id, &created_tc);
+	if (ret)
+		goto err_free_binding;
+
+	if (!tc_entry) {
+		tc_entry = kzalloc_obj(*tc_entry);
+		if (!tc_entry) {
+			ret = -ENOMEM;
+			goto err_clear_created_tc;
+		}
+		tc_entry->key = tc_key;
+		tc_entry->tc = tc;
+		tc_entry->tc_type = tc_type;
+		tc_entry->created = created_tc;
+		INIT_LIST_HEAD(&tc_entry->job_list);
+		ret = xa_insert(&dev->tcs, tc_key, tc_entry, GFP_KERNEL);
+		if (ret) {
+			kfree(tc_entry);
+			tc_entry = NULL;
+			goto err_clear_created_tc;
+		}
+	}
+
+	binding->job = job;
+	binding->svc_id = bound_svc_id;
+	list_add_tail(&binding->entry, &tc_entry->job_list);
+	mutex_unlock(&dev->jobs_lock);
+
+	return uverbs_copy_to(attrs, CXI_IB_ATTR_JOB_TC_BIND_RESP_SVC_ID,
+				    &bound_svc_id, sizeof(bound_svc_id));
+err_clear_created_tc:
+	if (created_tc && uctx->cadev->tc_clear)
+		uctx->cadev->tc_clear(uctx->cadev->cxi_dev, tc, tc_type);
+	if (uctx->cadev->svc_destroy)
+		uctx->cadev->svc_destroy(uctx->cadev->cxi_dev, bound_svc_id);
+err_free_binding:
+	kfree(binding);
+out_unlock:
+	mutex_unlock(&dev->jobs_lock);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	CXI_IB_METHOD_JOB_TC_BIND,
+	UVERBS_ATTR_FLAGS_IN(CXI_IB_ATTR_JOB_TC_BIND_FLAGS, u32, UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_JOB_ID,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TC,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TC_TYPE,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_SVC_ID,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_PTES_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_PTES_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TXQS_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TXQS_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TGQS_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TGQS_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_EQS_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_EQS_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_CTS_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_CTS_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_LES_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_LES_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TLES_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_TLES_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_ACS_MAX,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_BIND_ACS_RES,
+			    UVERBS_ATTR_TYPE(u16), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_JOB_TC_BIND_RESP_SVC_ID,
+			     UVERBS_ATTR_TYPE(u32), UA_MANDATORY));
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_JOB_TC_CLEAR)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_ucontext *ibctx = ib_uverbs_get_ucontext(attrs);
+	struct cxiverbs_ucontext *uctx;
+	struct cxiverbs_dev *dev;
+	struct cxiverbs_tc_entry *tc_entry;
+	u32 tc;
+	u32 tc_type = CXI_TC_TYPE_DEFAULT;
+	u32 tc_key;
+	int ret;
+
+	if (IS_ERR(ibctx))
+		return PTR_ERR(ibctx);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	uctx = to_cxiverbs_ucontext(ibctx);
+	dev = to_cxiverbs_dev(ibctx->device);
+	if (!uctx->cadev->tc_clear)
+		return -EOPNOTSUPP;
+
+	ret = uverbs_copy_from(&tc, attrs, CXI_IB_ATTR_JOB_TC_CLEAR_TC);
+	if (ret)
+		return ret;
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_JOB_TC_CLEAR_TC_TYPE)) {
+		ret = uverbs_copy_from(&tc_type, attrs,
+				       CXI_IB_ATTR_JOB_TC_CLEAR_TC_TYPE);
+		if (ret)
+			return ret;
+	}
+
+	if (tc >= CXI_TC_MAX || tc_type >= CXI_TC_TYPE_MAX)
+		return -EINVAL;
+
+	tc_key = cxiverbs_tc_key(tc, tc_type);
+	mutex_lock(&dev->jobs_lock);
+	tc_entry = xa_load(&dev->tcs, tc_key);
+	if (!tc_entry) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+	if (!list_empty(&tc_entry->job_list)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	ret = tc_entry->created ?
+		uctx->cadev->tc_clear(uctx->cadev->cxi_dev, tc, tc_type) : 0;
+	if (ret)
+		goto out_unlock;
+	xa_erase(&dev->tcs, tc_key);
+	kfree(tc_entry);
+
+out_unlock:
+	mutex_unlock(&dev->jobs_lock);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	CXI_IB_METHOD_JOB_TC_CLEAR,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_CLEAR_TC,
+			    UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_CLEAR_TC_TYPE,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL));
+
+static int UVERBS_HANDLER(CXI_IB_METHOD_JOB_TC_QUERY)(
+		struct uverbs_attr_bundle *attrs)
+{
+	struct ib_ucontext *ibctx = ib_uverbs_get_ucontext(attrs);
+	struct cxiverbs_ucontext *uctx;
+	struct cxiverbs_dev *dev;
+	struct cxi_tc_info *tc_info;
+	struct cxi_ibv_tc_entry *entries;
+	u32 max_entries = 0;
+	u32 count = 0;
+	u32 copied;
+	int ret;
+	u32 i;
+
+	if (IS_ERR(ibctx))
+		return PTR_ERR(ibctx);
+
+	uctx = to_cxiverbs_ucontext(ibctx);
+	dev = to_cxiverbs_dev(ibctx->device);
+	if (!uctx->cadev->tc_list)
+		return -EOPNOTSUPP;
+
+	if (uverbs_attr_is_valid(attrs, CXI_IB_ATTR_JOB_TC_QUERY_MAX_ENTRIES)) {
+		ret = uverbs_copy_from(&max_entries, attrs,
+				       CXI_IB_ATTR_JOB_TC_QUERY_MAX_ENTRIES);
+		if (ret)
+			return ret;
+	}
+
+	if (!max_entries || max_entries > CXI_TC_MAX * CXI_TC_TYPE_MAX)
+		max_entries = CXI_TC_MAX * CXI_TC_TYPE_MAX;
+
+	tc_info = kcalloc(max_entries, sizeof(*tc_info), GFP_KERNEL);
+	if (!tc_info)
+		return -ENOMEM;
+	entries = kcalloc(max_entries, sizeof(*entries), GFP_KERNEL);
+	if (!entries) {
+		kfree(tc_info);
+		return -ENOMEM;
+	}
+
+	ret = uctx->cadev->tc_list(uctx->cadev->cxi_dev, tc_info, max_entries,
+				    &count);
+	if (ret)
+		goto out_free;
+
+	copied = min(count, max_entries);
+	mutex_lock(&dev->jobs_lock);
+	for (i = 0; i < copied; i++) {
+		struct cxiverbs_tc_entry *tracked;
+
+		entries[i].tc = tc_info[i].tc;
+		entries[i].tc_type = tc_info[i].tc_type;
+		entries[i].res_req_dscp = tc_info[i].res_req_dscp;
+		entries[i].unres_req_dscp = tc_info[i].unres_req_dscp;
+		entries[i].res_rsp_dscp = tc_info[i].res_rsp_dscp;
+		entries[i].unres_rsp_dscp = tc_info[i].unres_rsp_dscp;
+		entries[i].req_pcp = tc_info[i].req_pcp;
+		entries[i].rsp_pcp = tc_info[i].rsp_pcp;
+		entries[i].ocuset = tc_info[i].ocuset;
+		entries[i].cq_tc = tc_info[i].cq_tc;
+		entries[i].req_bc = tc_info[i].req_bc;
+
+		tracked = xa_load(&dev->tcs,
+				  cxiverbs_tc_key(entries[i].tc, entries[i].tc_type));
+		if (tracked && tracked->created)
+			entries[i].flags |= CXI_IBV_TC_ENTRY_F_CREATED_BY_RDMA;
+	}
+	mutex_unlock(&dev->jobs_lock);
+
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_JOB_TC_QUERY_RESP_COUNT,
+			     &count, sizeof(count));
+	if (ret)
+		goto out_free;
+	ret = uverbs_copy_to(attrs, CXI_IB_ATTR_JOB_TC_QUERY_RESP_ENTRIES,
+			     entries, copied * sizeof(*entries));
+
+out_free:
+	kfree(entries);
+	kfree(tc_info);
+	return ret;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	CXI_IB_METHOD_JOB_TC_QUERY,
+	UVERBS_ATTR_PTR_IN(CXI_IB_ATTR_JOB_TC_QUERY_MAX_ENTRIES,
+			    UVERBS_ATTR_TYPE(u32), UA_OPTIONAL),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_JOB_TC_QUERY_RESP_COUNT,
+			     UVERBS_ATTR_TYPE(u32), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(CXI_IB_ATTR_JOB_TC_QUERY_RESP_ENTRIES,
+			     UVERBS_ATTR_MIN_SIZE(0), UA_MANDATORY));
+
+DECLARE_UVERBS_GLOBAL_METHODS(CXI_IB_OBJECT_JOB_TC,
+	&UVERBS_METHOD(CXI_IB_METHOD_JOB_TC_BIND),
+	&UVERBS_METHOD(CXI_IB_METHOD_JOB_TC_CLEAR),
+	&UVERBS_METHOD(CXI_IB_METHOD_JOB_TC_QUERY));
+
+/* -----------------------------------------------------------------------
+ * Driver uapi_definition table — assigned to ib_dev.driver_def in probe.
+ * -----------------------------------------------------------------------
+ */
+const struct uapi_definition cxiverbs_defs[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_WAIT),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_CSR),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_EQ),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_CP),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_SVC),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_PD),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_LNI),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_CT),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_CMDQ),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(CXI_IB_OBJECT_JOB_TC),
+	{},
+};

-- 
2.56.0

