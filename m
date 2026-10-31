Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474846;
	b=PZKRTI4w6nHVEbwe3k8YOLFpc/sCmFBKnPtrC6b1d8h5p+ClgUo6oNEqk2AEGLR7yZzp
	 NsIMKOLXOdD+J+Lkzy/TYqiLdlRzisTdoPj0tSh0LjrrSJx+B7ezHwWkUZ13vv+OKzI74
	 OT4F0RKAOIfbKEoZ3n/jSW2VaMog9ni94cPeHL0qKp74T6KTWf7zH8ZrWfSqvvnGOl/GS
	 2L12vfGrc/BuSm97dC5eoCNOGc0QOVwigleFM5OGuHYHln6RtBVhk+hepEnb+zq9T9QeR
	 o1upPA9zYjD5CwiWoP4z2sfT+B8WSgn29oRGXI7nZvRb9IOlUCFls8il3I0R7lqE0iw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474846;
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=hoE2R4A4F4Gcug8WSkzxfMk0Ll2YmpzbtEeV3JIvsAo=;
	b=XcayqlcN4dCmvx/Cf3p22PEVov/m3ZgW/bXY0pL+f6wa+8FITVsuBI2zInI4AjNJ+FOU
	 cq6jZx4qGdCEXii7ldDejC7jYs9RQ42vUmyp9M18bQCGLfaI7XMuWfGgJBuRjJvp8x6SM
	 hRexAMMzJjSSkUNiTDTVSjnS8plfSVN/FU1y2HOfrraeRfOAaNFT+kAoaOu2X6WpnAgXp
	 ZCXVaYyLf38C3U2CjWMKXV+kNbvQeavUHs+rqrQov57weBT3IThPljKD3zg3Qg4Gitv0V
	 B6TfCofqPEk1pH6sJ0FkaPch6zR1TtOfmEfwX3Xs8Ta631E3mO88JJ10Bq+26zizSzw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=NdyoCyvC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77A60A260B;
	Sat, 31 Oct 2026 19:27:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE77A60A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=NdyoCyvC
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJCqgK279356;
	Sat, 31 Oct 2026 19:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=ho
	E2R4A4F4Gcug8WSkzxfMk0Ll2YmpzbtEeV3JIvsAo=; b=NdyoCyvCK9HZishpWc
	R7LqGPg/XcAxsPDWBfFYeyToTs6ZQv8oBcIJ2Sfqu50w3th66HfjGZL94sbBVaSw
	w8jOmt8meGVtazPpM+EfSBfjH+CukZf3uMdt8JXDBKlRydoHBFVQDaHsT+bK1Qib
	//aUT0lgZm1pkk86kzi2dHwP/CbkNQPGGL5p2mtkktQgyNlwNg6gj/wcXOKj+35/
	hMjDq0jH1N2RRJIphQqWtMT3Q++H9L0OVel+4dQU5sLyxEjeZ61JGyaHyOCvVOrQ
	Gbl0xXGOshgY8qz89fK4cB4/ptWyi6vGg5v8lu1kukaA/Or7/APvu2OCr390IK0U
	4Buw==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn7ajq2aq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:27:24 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id CEDB3D2A1;
	Sat, 31 Oct 2026 19:27:23 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:57 -1200
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:56 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:56 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:26:56 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZGzg5lHkfjxfj05+s4KgE4S3Rahg92KRBylZDqCWht9THqh06iEs9xnvwFJJu/9zGVLrFZqhR62i7dV5qNifGPfKdcov2HQzIE1krzjxgvBVzgct1/cvF7Izz1IRd0OZGxtFicwcHsw4/p7QytlBMPWhp5JmcV+r3SCAIYaLag6Vg7Zfm83oIv3GByGOglDAH6IfTG7OhbZiH3KQmLjMfwwGMDeaRTVjGQkYyO+T7PdM51pzBUge4yokeLPSZ5pZpF5+HvFwHXcbHvLm2IsNaMkfOAtqFsPFcpnX5mY1Ei4I35N/zHjj2PE7zVoy5s5pkx/eQFQDNopIg9NuWEdgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hoE2R4A4F4Gcug8WSkzxfMk0Ll2YmpzbtEeV3JIvsAo=;
 b=yJAMenzYK3jYRv/9grdrM3fN0hwd6VH6oEkVB2SFcAl827Off3/c8Z3QYP3avcYx/7Ox+9Evg+6payGISZlDNGGdKi0LrZPgu9N6NcBM5gq4AcaFpdSoRtAFHl5vuNpjzI4tUoim3rKggQCZMKWVX2H1DouHBgLLzsusdLWgFYHYPASZ8tjuCkI9CQp8Ms9RHHmTzPoaNyG+1A9lZdA7VxXHko++MOIHaEnH9BjteRN8h8IabTlYdCTOLhukxb8CSF3ct2GeiM6ORjKm9sOnACxIKwqWHBwlEjcX41GmZXryBDLtfD5mqxdZz2ItkBYoTJfD2HOmCA/Oz3H+rG8EyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:52 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:52 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:25:59 -0700
Subject: [PATCH 06/12] cxiverbs: encode list entries and VNI-isolated
 remote keys
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-6-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0159.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::14) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 79f7021a-f560-4e4a-126c-08df3784ea82
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|5023799004|56012099006|261009223027099003|261028144727099003|261021121427099003|261026121527099003|261022075727099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: gRu/IlcqGZ/xDArZ5gcfKglkH6zBf9SlQ10xpCuQxO8QkyalbsGEN615UnE2JraB6WavEuyPoUue+ri0WfOrNduCGbYmIlLph6WcJggpu7CAt/wl1ayEYf9NoCLDCE/K2YA4QEQ1cJvs/+wDfgWqvNcg0VVREgR9ByKmekwNcCWjlcqmLLjqfVo//1cBfopw7Qmuz7ib/8C+iDJR+7r79qk4IjhFTg5Rue7GY2repyrfDoSHg5K7Zlx3zJEOEWWWLET6ZQmGjEUx8dAWc1fcl1hPwKjHssBRSHx7KJg2++tCd4XWiI0uFJ7hD6jkyoQOnRDlBMjCcwNmFWLfejZMCcc3VS9LSaHI0uNA91H2JGRsDtzXy1AcdMOBOgqbs45ics05L08se4h14q5de/OkEGHWtEYsWK9VV7viOQWekiSC2yvcAaucx9pW0yLg2QVkNxn30Mr4ZzlrcedoWOmRh5t2PozhFc6CBdxGuIlKxhqSkMiUti5Kf5gl3ZaOh8KBjZYIZcBbXhOQ616NLhGGP4SQV3Ez4G2ZjhoECXfyGMEZ4jEfucY+TRz06bLtoXHYa85fxhI5+7l8RphCDkbXRdv8GL5lVcEidTnzA5D6LCUcrUS2KwVPVr6ltmCrgAQbHmtVII2/ESFSWtBFqwpjeD7kKjkm8csQZ4ChbyIFN4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(5023799004)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261026121527099003)(261022075727099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkcxTWNpdHFKYnA5Qkp1NnBqM28xYmNvRUEwQ3JTbEhWYmtReDdGWll6clpP?=
 =?utf-8?B?N1BHYzkwbVpnQWRNVzFtWFYvU1J4QW5XNG9VeTVwMGdmL0RPdnptUmVHYm12?=
 =?utf-8?B?VWFRL0ZHZHBSQmZQaEIzQ3cvaXhUeWoxZWNpM2lYOWVuY1NzNDgzQURtRi9W?=
 =?utf-8?B?Vkk2a3Y0NmMrOHlBY3E4WHJrdmdtb1VVWTFpVG9CazNFRUxMK0FhR3RDcGxB?=
 =?utf-8?B?UFRIWUk2bHk3UnBiVGplYnV0WXV3RS9udWYwUmRRbDBZQ2xIWmVtWmFGRHN6?=
 =?utf-8?B?S2pwVW13MUd2eXdCQzJJQ1crb0VJRU5vZFcySzhqK1k1NExTeDgwdnJtM3lT?=
 =?utf-8?B?dTZqcDlobkxXL1o4amRaWGVNMG5LSnk4N2wxUlhaSUNWMHZ1UkNZYU9WMm1h?=
 =?utf-8?B?R29EVkFUSzFhanZUdUlIY2dPSzFiZkkvdUtHUCtqYVR4ejhNN3kyVnBFVm50?=
 =?utf-8?B?ckhPWWZna0dsdkw4KzlreDk3RG9CWGdEaDlmbkJEYXc4eHlNcGFLT2txUEx5?=
 =?utf-8?B?OEUwTlJENHJwVDJscmpSUHZNbytlZkVYd3lscVFZV0hGcnVTLzFXQzh0ZTYx?=
 =?utf-8?B?dE1kRkN4QWc4d3orNk5OWjVPTURQYitkTitYMWVXQXB2dFFubUpMWit5RllU?=
 =?utf-8?B?dHBlN1ZCN0ZNb044aEF5TzAwQXRnTXAzWVp1TjdyYmNPcXF2RW96VkVvWjQw?=
 =?utf-8?B?eGViM0xMN0NOMVBHMVBKODgwWXhoN2pHZURHL0tRWXdpcXdsSUlvaFFNR04z?=
 =?utf-8?B?bmFXTlhKRGRUY3Y3ZDhLVHVuUFZwZmNuaHJFTXlsUklBMVYremxEcmdxZTlT?=
 =?utf-8?B?YzV1VldQb0hlZmRzQ2JlN2tCOUlhRVdQRWhjZS9tSzQvZnEvWTQwNVluNllT?=
 =?utf-8?B?dlRjbEp5WmlRaUoyUXY0Q2Juck41YUZRcG5BVnhlKzhjTk0vcGpEMDRia3d0?=
 =?utf-8?B?aHNJOFNvR293Qzc4TFc4TnJJdmc3L2xhYWw5VFNkNVlLUTVuQ1crRUUvUS93?=
 =?utf-8?B?SytzV2t0a21zRjFkclhKN3B2anhmcG9zaVFMVkN5VzZmMWVrSTFRU3lxSmNB?=
 =?utf-8?B?M2VmMHVnamh4M0gwcHErVXhiTXBHMk95MGY4NHVJSXR3RllaaG5pRzdzclRx?=
 =?utf-8?B?UmZTdmtoTnlJUVU1VU80bnNScGZLa282MWMyZDYyb290R0Frd0pBbzBLY2ZH?=
 =?utf-8?B?OENOcjBwbVJNdHRCclJEN1NrdmZTdDlsNFJXTWFMUmp6RG5JM2tqOElWS0Rt?=
 =?utf-8?B?dnJaQ2gySnJ0Z0taVVZHc28wbFlXUmtrbXFNZFJGbWhYMGVLRnhFRW5NWG9I?=
 =?utf-8?B?d1ByMWlDNVBYYktZQTRuWnpHTVB4eVROb2R4MVFDd0lZbEJyZFhhMEs1TENw?=
 =?utf-8?B?aTN6R0xYRjJsTWVTcDc5bUo1T2RFRWJZNEtiMzRHSWJCL2RKUi9xaXhvN3dY?=
 =?utf-8?B?dnc5UElqUk1sMlBYcU1pSDlia3dLMmdicGxrNzhKd0YxK25DcHpuci9VWDls?=
 =?utf-8?B?c2JPWlFPaUhYK1MzYzhiTExJYmJFME5oQ0l3cVppMFBzL1ZTTlZ4RUxEMDI3?=
 =?utf-8?B?Qk5aTEdEM0hMRXgzNnRrMlRhU3lZYlBIOXlNMTFJMDA2T0JmU0J5VEtRaTdE?=
 =?utf-8?B?NDg2TkNwM3lVQldoQzdoc3VreG1Bdk5kNWszeGR6WEdCcGtJRk9HNVR3MHpr?=
 =?utf-8?B?RmU5aTRSQ3RVZTJSU2xmS20rZmtSNHM4OWZ0Q2w1VTdoN0M2aCs1ajMzdDhQ?=
 =?utf-8?B?L0NuR05QSFBUbVk5ZnRxY3o4NGZUWFdXUlRuZFVaTVZqZ2UyY1FDQzZyMHky?=
 =?utf-8?B?aGVZV3h5cDdidENNNFQyTk1zZDVUM045ZWs5YmtpQ0ZNbm5mSC9hZzBEQXRX?=
 =?utf-8?B?aTFoU1JuWlZ4aUNlQmw5MFBINnhTdlg2bzUzN2Z0ZUpVcmZJWHk5L2xEcFZk?=
 =?utf-8?B?d1RXL1hmbXlTOG5Dbkovb0dnUHNPamNZS3UyZTJnOHAxWUl0cXlXSHIvb0tB?=
 =?utf-8?B?dkw2UXFkdm1RSENHMFRldEt0ZGJWRk9jUy9VeDZQczRGMVlpbVUydEVTTnVx?=
 =?utf-8?B?eFVkVTFORHZwT3M2S0FQVDJDYlQzTUdyMHVNQXBZNmlTTUtncFBMbm5MZ2hv?=
 =?utf-8?B?T1NHTmcxc2hYQ1lrYWFKM2NQRTdPMDBOYTM1dVFFdWNSSm9ZQW95aWlza3kv?=
 =?utf-8?B?Vk1jVjVNNG9RaTJKVjR4Ti9XaDYremprMytMa000YWF5Z3d5MzdIZDQrcnYv?=
 =?utf-8?B?aWdMaHhHVzhoTGg5dEtKUWo5SGRpUDNLMTJ0RFp6UllHZHlIT3N1bVdnU2FQ?=
 =?utf-8?B?V2N4bHRlRERoKzgzRGg1dktiLzA1UnJKcDJEUXdYUm9zOWhFcFo5Zz09?=
X-Exchange-RoutingPolicyChecked: yHwlCPC0aPdQEhJ+NLw+/gMN9GnbRO+dhckjWoSDDsf1ylBEd5OuSQAHf/lea9pA8jSmorDTMb+uvaPXOQYtI1VtLYNTYFcmMOi1tj37aV6gdvl5BpLUwxDklr6CZnZ8bYYefHcC164S1po+qBzHz0eQUX4sUfcLRet5LXMyq5wF8YnJdU/gwbr6JBToJS5LbScoejQJ3bO9F/yUQGTiJExwIU+AXKcz/Z43yAY7IMo8aJrL9FzU3AL5scCvlqpTxzjvMuXODD6cukeJ4UbKlLNgHWL22JSbfLWCoJ5qsrURoTgrTpt0hlHNb7AVZuxWf1XKAm8JKeslU+N1/vHkIA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f7021a-f560-4e4a-126c-08df3784ea82
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:52.1338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMgWg54hJaRvDNiSfBHYejYlaf5J4qn8XMdkS6+Etquy0EDr4fLmIwx1TuIMIAHrY2KWSWnQSJIZBLnYsL909A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: -z0AtdWPrL48ck_JThbwNe0cyd_auNji
X-Authority-Analysis: v=2.4 cv=O+asLx9W c=1 sm=1 tr=0 ts=6ae6411c cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=3haJ9R1Aw3gUfsUHDaCR:22 a=MvuuwTCpAAAA:8 a=vFDPoNe_BgQx39Q_3wcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfXwMuqD812AHbY
 IELQZgBsz2zoEIaBO8F3wAw91+1WgUyiBKmrFevMqItmxxYwS67SIdcEBWwHKOkSmX6JbowxEIC
 anN0wPhncLOAJnH+4+2Q1cNpf93W+lxBf1/O092dw1iPNTqb+dUNSydgn/F6qbtKsMMc1LwsHAe
 urFVUlhuzEFPLr/FI+/pZp4NTKbCUrgjKu1TYpWsNJ2lovmShaYsqO8r9+cqPb55qsn1TX0wr+V
 XGA/oL3Rc8Bw6lOFeroqJct71am0A0ERg/rGnh1j5W7gqy4tyxAMSqbimoQ9U1cdaJVdEYakVFE
 cO05yGef3jqNpHD7x490BUOptbP1wl/yxuqErCrxtuxc9D2y9yv0qmv6xTzjOSZ0nm/wpPHkqXN
 Osm7iKt+u16Atn6psGPxD7dmXajC34nKh8izG7Ff7lHhf//FxDIUwqDwZLom2gveuVC4WGTS7vn
 m7WhC6e6zDB8olifKzA==
X-Proofpoint-GUID: -z0AtdWPrL48ck_JThbwNe0cyd_auNji
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX85+wKtKAy7Ul
 Bt91/Drse9gDDKeKkiD2SW84PJGALrm1XTwDpnZRgryIbW+MUivFRmd2IJml6Iv7rikIt0MUy6i
 VgHhW07iI1YpMslN/P4iPqNjQmoZtcY=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310077

Add cxi_le.h, which encodes receive list entries and remote keys.

A logical remote key is at most 48 bits.  The wire key is the logical
key shifted left by 16 with the job's VNI in the low 16 bits, and the
list entry clears the ignore bits covering the VNI so it is always
compared.  A logical key that does not fit is rejected with EOPNOTSUPP
rather than truncated, and a zero key is rejected with EINVAL, because
zero match bits are reserved for receives that do not use a key.

The helpers return negative errno values like the rest of the
hardware interface; the verbs entry points negate them before
setting errno.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 providers/cxi/cxi_le.h | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/providers/cxi/cxi_le.h b/providers/cxi/cxi_le.h
new file mode 100644
index 000000000000..096b3933adee
--- /dev/null
+++ b/providers/cxi/cxi_le.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright 2026 Hewlett Packard Enterprise Development LP
+ */
+
+/*
+ * List entries the provider appends to an RU QP's PTE. The PTE is a
+ * matching PTE, so an entry is selected by match_bits (under ignore_bits)
+ * and by the initiator's match_id; both must be right or nothing matches.
+ */
+
+#ifndef CXI_LE_H
+#define CXI_LE_H
+
+#include <stdint.h>
+#include <errno.h>
+#include <string.h>
+#include "cxi_prov_hw.h"
+#include <rdma/cxiverbs-abi.h>
+
+/* SEND carries no key, so a receive buffer matches exactly the zero no rkey is. */
+#define CXI_LE_RECV_MATCH_BITS 0ULL
+
+#define CXI_LE_VNI_MASK 0xffffULL
+#define CXI_LE_RKEY_MAX 0xffffffffffffULL
+
+static inline int cxi_le_wire_key(uint64_t rkey, uint64_t *wire_key)
+{
+	if (rkey > CXI_LE_RKEY_MAX)
+		return -EOPNOTSUPP;
+	*wire_key = rkey << 16;
+	return 0;
+}
+
+static inline int cxi_le_set_vni(union c_cmdu *cmd, uint64_t rkey, uint16_t vni)
+{
+	uint64_t wire_key;
+	int ret = cxi_le_wire_key(rkey, &wire_key);
+
+	if (ret)
+		return ret;
+	cmd->target.match_bits = wire_key | vni;
+	cmd->target.ignore_bits &= ~CXI_LE_VNI_MASK;
+	return 0;
+}
+
+static inline void cxi_le_recv(union c_cmdu *cmd, uint16_t ptlte_index, uint8_t lac, uint64_t iova,
+			       uint64_t length)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->command.opcode = C_CMD_TGT_APPEND;
+	cmd->target.ptlte_index = ptlte_index;
+	cmd->target.ptl_list = C_PTL_LIST_PRIORITY;
+	cmd->target.op_put = 1;
+	cmd->target.use_once = 1;
+	cmd->target.lac = lac;
+	cmd->target.start = iova;
+	cmd->target.length = length;
+	cmd->target.match_bits = CXI_LE_RECV_MATCH_BITS;
+	cmd->target.ignore_bits = 0;
+	cmd->target.match_id = CXI_MATCH_ID_ANY;
+}
+
+/*
+ * An attached region matches its rkey exactly: a region reachable by a
+ * narrow key is made that way at registration, so the key carries its own
+ * width. It persists until detached, and buffer_id names it for the unlink.
+ */
+static inline void cxi_le_region(union c_cmdu *cmd, uint16_t ptlte_index, uint64_t lkey64,
+				 uint64_t rkey64, uint64_t iova, uint64_t length)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->command.opcode = C_CMD_TGT_APPEND;
+	cmd->target.ptlte_index = ptlte_index;
+	cmd->target.ptl_list = C_PTL_LIST_PRIORITY;
+	cmd->target.op_put = 1;
+	cmd->target.op_get = 1;
+	cmd->target.lac = lkey64 & CXI_LKEY64_LAC_MASK;
+	cmd->target.start = iova;
+	cmd->target.length = length;
+	cmd->target.match_bits = rkey64;
+	cmd->target.ignore_bits = 0;
+	cmd->target.match_id = CXI_MATCH_ID_ANY;
+	cmd->target.use_once = 0;
+	cmd->target.buffer_id = (uint16_t)(rkey64 & 0xffff);
+}
+
+static inline void cxi_le_region_unlink(union c_cmdu *cmd, uint16_t ptlte_index, uint64_t rkey64)
+{
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->command.opcode = C_CMD_TGT_UNLINK;
+	cmd->target.ptlte_index = ptlte_index;
+	cmd->target.ptl_list = C_PTL_LIST_PRIORITY;
+	cmd->target.buffer_id = (uint16_t)(rkey64 & 0xffff);
+}
+
+#endif /* CXI_LE_H */

-- 
2.56.0

