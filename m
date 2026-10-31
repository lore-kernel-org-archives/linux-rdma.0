Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474850;
	b=A+EMc1/aBxtLWXdni7EsGkrxeENxNTCMObcKYLDB2EhU1QiQvhVJPrsgD0213QO90JcM
	 L4lamZsKJddgBGf9prbv/K8lJUYLQl5sKYcEZ/UnkroVr/2atOjfq2YQdFhU6CM6FlV24
	 nqZEuNZV5JwIcyKB/N85anRwf6WtA8hPLgQ9ix2fBKv272W5lXkLsS/d5p9jsexs7RvNU
	 eQ2B1ZzY5Tf5EFQfq0LMNjioT/897yFVsVIV1B2vmKwglcwj31SUSs1Obvl6zje2REjDO
	 KbJxDLMrLtKS9ECuypPheChw50JMgVUAntxD5XCcdp1BAZLD5kLyMLTCJYCdZSgLv8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474850;
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/qyiBrYh2tXcS3RIuCa+/n3ue7JW7MwMHyPqFGp6jII=;
	b=dEwzX1HFV8AQ3hd7QQ5wsl3olR5IINFcyeld6E6y9vJx3lAca7VhGdt+996r94diV4qf
	 lCSGkDigO5bUC/ZgRh9cNpnUDEHTJ/vS0FjWZhRxIFxzG/NRwSHjSUOaHezxpAssgXfs0
	 1PBkJeHv7dKNci/HdNn3Tq50uWKU0IaKpQDU4i4NvN0wWHpdsBi+MCX0rAkHEXoT9F6xW
	 CZGeTWYbcBDHjZdt32DgiW84AzQOO1oyLkiEQneTUalFxaO+WFmx8dX0/5cPtTQqYGmqf
	 lKUxXniqoKSJ6+79bMU2rtuVb8pV8CfnHs2qfSLc7jT1ZNjgmugSyarlZ9YeV5bohyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=oFPdmiCB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695F560A261B;
	Sat, 31 Oct 2026 19:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 695F560A261B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=oFPdmiCB
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJCg4m279239;
	Sat, 31 Oct 2026 19:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=/q
	yiBrYh2tXcS3RIuCa+/n3ue7JW7MwMHyPqFGp6jII=; b=oFPdmiCBMtUriVqc3w
	zwE1N2xzllA3cJIQGZUd+yTYwgr1lizO0HKZ4vqEBipuC0pMfVyuLWiYMdp3nDfJ
	oee8Zyr29+f22y9oUZbQSXTaa/TzuY/JrlLJVHCIk4+7mvnk9R67i5yp2Xq5qtYS
	/bH0hkdtmYXlIHj8iXjQD3qqo3IoeAqgGlVhdFYyM3bWTLySkbOOHyFgNmaFiBqX
	dUtSzbgbJ9dQlB89QgLw+7zbuIDYgDhlylqqTXBTS8QnmiXe4u9kUB1EC+PogYcS
	tEYEel4hzceQd4Y1PnfzSZgpJa/OUEaxgbysMuGH+AtRBClLvArv721oVrLObgih
	9aNQ==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn7ajq2b3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:27:28 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id A3F04D2BB;
	Sat, 31 Oct 2026 19:27:27 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:27:15 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:27:15 -1200
Received: from SN1PR07CU001.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 19:27:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOgWrYp8gB/ETiga/D4FyhtIRWfMp9W33g8TImQHZFwLmbS228FrfmD4uprxUwbBjmMfQ53euJTCcXbqtq/iPdyo/yMVvu3oQT7i8h8rsC3rv5jyiT5WD/TSxYRfPKogqav8e4i1lglwQCUWMEloUNpZJYGA+D7br3tj88OvsDq3I9rXwv7XpWyc5LRACO/rzPN29Xid1A0J4/ZcQQXH6NTpBf6cCQXmBK8PpbOmSljJhZSHVxfINL/qOfFdbwaq+QnEvkRUvlIiQF6nM1yaVBVvcesJIZZpdQp8yBtCf4gU5h53yJjUVfp86JZjy2Gwx2Q+vxysb66gZCd5eWsalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/qyiBrYh2tXcS3RIuCa+/n3ue7JW7MwMHyPqFGp6jII=;
 b=O+cMqe+E41b5z2B0A25pWcJKStRAAzQi+DNyhs5UPxmuKVDG4bNFb4vhOOAmhO5O3FIGVHePoIxCTAD/JDiNPzDpqmB0XwYbf7vldEAu/U3+SoSZ4zHBME3brm5qO8nq0PW5DZoxvd5ojokSUx29WQAGJEhn0y6RjncH7zbJX8z5uPx288TR4dPCaBgZwu1HJZBJyw+Wf+bCVC65jxVFWBfVAEIsZtAqKbIsa9MRw6nbUasd4PQexq/ZisBXof9w2U+RQmxIf9LemvQznN28RWWOChZHcYx4ovF4lk6Vympx+ZZdk4BXosGZToh97lozmPdU3mxLNQ22S+tzNWMiaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW5PR84MB1891.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:27:11 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:27:10 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:26:05 -0700
Subject: [PATCH 12/12] libibverbs: port RU examples to explicitly granted
 resources
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-12-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SN7PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:806:120::21) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 73d663ad-3aa7-4403-a26b-08df3784f591
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|261026135527099003|56012099006|261009223027099003|261028144727099003|261026121527099003|261021121427099003|261021123027099003|261021133027099003|261021135927099003|261021130227099003|261022105027099003|261026140227099003|261022115727099003|261022075727099003|261022113327099003|261026130827099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: oxhAbSWnZaezOVM9jYtwPPAXcY8NuHB1GJCz1i+0gL00ahg3SbHt3N2seZ3LEe6UmMcjYMW49hl4ESalNOUz0Y881R69lnM2EY0kMWiEjpIOf5hHbo/uSpKbwpgh/dxxC0AcuagwVHY8xLMUPjLY3/k51KjXh5KILGL3ajOBxNKBOiJqUQ7XLIpdjgM0Jy6rfhdlZRkWUGfdQI2WxEKAGCSP0Vd6aKEU84RgoJBK4xAPps1Q45pT7lAC/9a2db8KpAqTTXDRfKMzRVr3iys8ZV/0Hf2UH2/afVZxmYVrPNbEr5ea4sVPHntLR10seu3cWvXS5uu4MLAaAlgqTLaUxK2xDuK9t6BoaIeWZGhIILMwVjJkoqhEqYws5thp5rOOqzpB+nMVwo0XiitWOUhVyCzsfipLvIOeFGNBPQJFhOsBhaHy1zx0wQ9Zk1m/LH8v9rhIwnigmaQfCK/0odSqfC5+x1P/yOXJVAkte9EYvpG2znu61AsBNKS+vlkmXbcpY0nTq/CY8IC9l3IACtF88UFn3Lyvb0sHwGQI8Z+g7q/XBI6yq5XTv593bRX19tnbtftBoKLDe94KQxo6GG1CNiGq434I1x2yI7zGgKLjU4E9ktocdt2WYBZ72et90ClB3/9/xBDZfuLb2EWxOlkGwvisLVI7kvEIQqxcZpP22Gc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(261026135527099003)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261021121427099003)(261021123027099003)(261021133027099003)(261021135927099003)(261021130227099003)(261022105027099003)(261026140227099003)(261022115727099003)(261022075727099003)(261022113327099003)(261026130827099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTVYcndrYXlLWVU4a1U4V3pCQVZNeGxIUzRXWHBLNHhoeStkTDRzeFM4OG9T?=
 =?utf-8?B?RWJoeGlkMllOMjl1aUtacDRqZGlDVFI5SjVBSWdXMExFMVZLZ3J5UnRReG1k?=
 =?utf-8?B?cVgrOTFuOWxmdEUxdXppcC9xSTNhYm12bENuNjZzNGhyYmswUmR3KzU4ZU1j?=
 =?utf-8?B?VUhRTXV0QUk2R1VQRmxBTVlRdjl0MG45TVMyeWI0VTIwVHVsdjJhc29sQUVJ?=
 =?utf-8?B?elprdU9TNkY4YWFFcnlDdXVid2FwUjZLeTIvSUo1emk5c0tHQXdEdjY2d2hw?=
 =?utf-8?B?SHBTYkxZNXk2ZkN3T0lUZVVMemFpU3cyclhpOEdvanhHbC8vSUMwZjk2dkg5?=
 =?utf-8?B?NTRka2NFZndCK2p3dStKY1Z2akdnWGVwa1FxWFVPYVlhYWs0UG1NUDJpbW9s?=
 =?utf-8?B?bFJhYU5KVWl1TmtZdlprdyttbVUyVlVxd3JiU2hHRWdDZDh0N21yVXFSY2kx?=
 =?utf-8?B?cmtxVWF6R01pZGpaSlJtamZHYzl1RWFmZG1WMEd2d0dIV210MVdidjV5VGcy?=
 =?utf-8?B?UkdGbldrSEtneVhlZHdzMzY5Q01sZzk1UjRMMFlMcXFueGtEZUhZcjR0aUM0?=
 =?utf-8?B?V1lhMkdrZ1ZueEk0WEJ0M1pjVzJnV2piVVJpSW1oWmJjcDRwL3pXdkY2UDZC?=
 =?utf-8?B?REhxeGI5TlJDdDZ1aXoxT3ZhTWtOMkZVZ0NMY3BoNElaSkl0aDJCbXd6VElO?=
 =?utf-8?B?THR4dzVrdW00RllTcGR6NXVhQ01OdmxJZnNaWFFlWnoyR0hLYzRoM01JNE1Z?=
 =?utf-8?B?RVhaalMrWlN2cnJ2RHdDVGxDZ1pUSmMyL3hqNGFTdDJ1Nmk5c1Q5RzlpcVpU?=
 =?utf-8?B?eE5md3BXRjZDeFliNnhrZ3dEWlU4UENUY0hsUmFHRXNhcUF3MHM1QVpwbStF?=
 =?utf-8?B?SkNZc2NUUFV1aU81MnJsTDNkRFgyUXdaY2RnNEdUZmVIRVdBd0VKYm52eTJY?=
 =?utf-8?B?V210NTVLeVpYd2Z6eEd5Rm90dnBTdytyMWpQbCtIN0ZVeFB3T3BlSFovUFk1?=
 =?utf-8?B?TkVoQUJtYUpaUmVHWFc1aTMxY1Y0d1h2SlNxSzQ3RGplT0EwZDhCVGVuMmxh?=
 =?utf-8?B?U2pET3B4enFMaVV4UHc1NGVnSkJUQWJWNXVtR1F4c2E3aStvUm8zVjFhR2RQ?=
 =?utf-8?B?SkdlTFY4a01sZ3NhTVg5bjZESjJaUkFxQmxyckJ2Q050MUJhQjgwOTdrdkNm?=
 =?utf-8?B?L01zTis5aEdSRis5c0d6c0hkbFZROXYraFJHVlYrR29Benk3bXBnckc2LytW?=
 =?utf-8?B?SGljeXdhTnZidGV3UlhpYi9JSzJLY1pFcGplZW9QUlFwZ0I1TFZjdVcxY2dh?=
 =?utf-8?B?cWsrZHQwT0hLVmcxc1ZxaGhDeDJhalBGbVQrTWRRQkNXQWdRYnh2YnhET3VG?=
 =?utf-8?B?RlZzL29INVlYVUhuQ2RFcmdmYlcvZE5Sbms0eVh6bStEVlF2dmJQUmZCWGVY?=
 =?utf-8?B?eTZneFdRTGY0ZTRBbENPVXlYOXBnUFV0V0xUeFBKeWJSY0U2WGxqUm5IaWxJ?=
 =?utf-8?B?K3VIMjZ3ODVqdUlNT2NjSjdKTXRlRjZaMk42bkFjRHNYQkRXQUZ6cldHWmVI?=
 =?utf-8?B?a1JTelZSa2YweXdseUxVNU81cDZxQW1UenlUOC94Z2F3YjR2dS91LzBSczV6?=
 =?utf-8?B?YUY4dHExL2NVUFRuQ0tqVlRUTVJtSG9NbHBHL3dPTmRPT2ZrZ2VOYzdBNDlp?=
 =?utf-8?B?OUJxVXpxdHJxN2ttbUw1eHplSlFBTWNKL0F4bE1UL05NNFlBa2lkTkNvSmN6?=
 =?utf-8?B?dW1kbnNlMElVM0tmSThXNlJFK0tDdm0wNGx4UlgvVm9ZQnNEMlByS0NBZVBt?=
 =?utf-8?B?RkU0VzljS01BRlN6ZDlDVTVhRTZNNTNQZEpTNFRYVWp0STVnNGxYM3BSMzdi?=
 =?utf-8?B?c2s4QnY0cEV5bkpWUnJTdXZOYlBKaWFlaFFldDNKL1RmTSt4WXc4bHdDbzBt?=
 =?utf-8?B?TFRVMmVGWmM2OUxSV3NuczBTZnF1NytMMW9TdUZQcW9HR3c4ZkhoeCsrSUJx?=
 =?utf-8?B?TU00RmhRbUgwSjJwdTUxdHU4djZIQkJSUnRKdWhuT29tZll0SVFRWnlhd0JZ?=
 =?utf-8?B?K1pVb3dnOGorNEE2VkxJYitxeW81L3h6dGptNVBzZ3FBdWJFcXFUOTRNd0p3?=
 =?utf-8?B?dncxcThBZHUxTGIrSnlmOEJtRnBSekZhS3hDcmhPMXNna1NLcUFwSG9Uek9u?=
 =?utf-8?B?OUJTUEtXOTZDWThnOVg4L1dqTm9VcEJEcWFlYzd1VDFHSGhhbXRuc0dDL0t6?=
 =?utf-8?B?RUpDWG5IdzNPMWRKME5HV0xYQm9sZy8wdTc0ZjQ2dEZuRTF3b2ord2c5bTc3?=
 =?utf-8?B?TnVQNjVkNk0wN2w3aVUyU0Q4L0xTbldnS1I2NS9oZUsxU0MyVzVQZz09?=
X-Exchange-RoutingPolicyChecked: Lteus3Dh15KPo7aG1ePowt/ZSd/UjLpHLs/QXjB69EZfgVFLShI2yctoShhtyq7dcG2g8GsKoOcQu3UGfFvQSp400JBFOO43AatUftVtr837y+bqHayhGCB5nvSuOa+g40hSAZEOx9eT674d2Fb6ZKQcY/66ObgA6kLhyxKxtURmEOZfjIIHyy0ySNxeJ8Li+vE9o6K7pGn1YwETk//JIV2jNin83scF/HoTMdEyDVEUvh919T9M3jW9+z92jQ8BwK7asxb4OErtcuRzWpyr3zpMpraLgllujw2XYgQon73G6FQs7GSs/NSAB/ZZRvobeSyQFijxs1kN9gjziUO1Bg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d663ad-3aa7-4403-a26b-08df3784f591
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:27:10.8078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRUF3VSStMcaL0sK3cqL7OWUn615Zpj3hyeBYjbOsEMEcoG2vxBBKP3N2soqJIPojyXYPP1UUPRvEybdWl0CoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1891
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: HhahQBIydgucp8sGLVun3B5qjqFuUJpU
X-Authority-Analysis: v=2.4 cv=O+asLx9W c=1 sm=1 tr=0 ts=6ae64120 cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=3haJ9R1Aw3gUfsUHDaCR:22 a=RiIid9coAAAA:8 a=MvuuwTCpAAAA:8
 a=Bol2QhK9G5Jno62YP8wA:9 a=QEXdDO2ut3YA:10 a=XKWKsq0CuoyFKVVHhDP9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfXwtA0Oc7kyHZy
 4MGMP03aTatjnxK9HuTUj64PtkO/6i1SsyCc8Dtib892xko0s9WnN6r5v2BQCdCm6nkjOTLrEYD
 A9lSMYqNq3yl8ylQx8CFt9YaAwYX8LoAdxpSZqSHFOlZLoNxihrFtrfxn5yKlAdHVePPG9ev2OO
 pvXXqrwTIpqr9xMyPKb1ArKuU65H8yTvzPi6+xJGWhV+Slgs1m90qEHYZl4dxEPkin4660UI2AF
 jvdpk/vm00NZWbhXrWOamarRCq0DKXbWQx65EqaBKLePUm0Fa5EFnU74CCOX2QAsOILf1peQ1Sv
 WSBT254DQAnY8LUJRCurlf2gDb43WxrnwoU0vIQZRkAE/bk/5YA7Q+pY+6gViTpWaGuSyzKU8IA
 PWKSTGml+Wh8PWJTYW95pafWgDFEcM3BRycFLX6a5IjeUQDInwwuM9tiutaWYAF5Kvfi0RlunDn
 Qg02Adw4pJObydX4ETA==
X-Proofpoint-GUID: HhahQBIydgucp8sGLVun3B5qjqFuUJpU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfXxE/Z3Qu6lKjX
 fn2FUwrOxKOUGt1ROXe4EcaPEjsCl5wyW3KB+kLVb4I68be5F7MmyOC6cAl5RfB6PDvd52ZbmXo
 uj+CUg6KX31QCuPgxaYsL589wqhuu/Q=
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

Teach ibv_ru_pingpong and ibv_ru_rma to run on a Slingshot device.

CXI has no implicit resources and the service and job grant that
authorise them can only be created by root.  On a Slingshot transport
a program that finds no grant (UET_JOB_FD unset) runs itself again
under cxi_launcher, which creates the grant and then runs the program
as the sudo user.  The second run finds the grant, allocates its LNI,
PD and PID from it, imports the job and runs the test.  A user
starts it with "sudo ibv_ru_pingpong -d DEV ..." and, as with
ibv_ru_rma, may choose the JobID (the VNI) with -j.  The launcher
is found next to the program or in the install bindir, never through
PATH.  Other transports use the existing code path.

The programs no longer create a service of their own.  The SGE count
is checked against the device maximum instead of a fixed constant,
and devinfo reports the Slingshot transport and GID type names.

The Slingshot path uses the cxidv API.  It, and the link against
libcxiverbs, is built only when the CXI provider is, which requires
HAVE_COHERENT_DMA; elsewhere the examples build without it.

UET ABI decision needed: this keeps the RU examples, and the generic
pyverbs.ru module, available on platforms without coherent DMA.  If
UET, and by extension the RU queue pair type, is not expected to
support such platforms, the RU examples and pyverbs.ru should instead
be built only when HAVE_COHERENT_DMA is set, as the mlx5 and efa
pyverbs modules are.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 libibverbs/examples/CMakeLists.txt  |  10 +++
 libibverbs/examples/devinfo.c       |   2 +
 libibverbs/examples/ru_cxi_launch.h | 138 ++++++++++++++++++++++++++++++++++++
 libibverbs/examples/ru_pingpong.c   | 126 ++++++++++++++++++++++++++++----
 libibverbs/examples/ru_rma.c        | 112 +++++++++++++++++++++++++----
 5 files changed, 361 insertions(+), 27 deletions(-)

diff --git a/libibverbs/examples/CMakeLists.txt b/libibverbs/examples/CMakeLists.txt
index a3e5c26ac190..e2134f3e963c 100644
--- a/libibverbs/examples/CMakeLists.txt
+++ b/libibverbs/examples/CMakeLists.txt
@@ -25,6 +25,16 @@ target_link_libraries(ibv_ru_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
 rdma_executable(ibv_ru_rma ru_rma.c)
 target_link_libraries(ibv_ru_rma LINK_PRIVATE ibverbs ibverbs_tools)
 
+# CXI is only built with coherent DMA. The examples run themselves again
+# under cxi_launcher on Slingshot devices.
+if (HAVE_COHERENT_DMA)
+  foreach(ru_example ibv_ru_pingpong ibv_ru_rma)
+    target_link_libraries(${ru_example} LINK_PRIVATE cxiverbs)
+    target_compile_definitions(${ru_example} PRIVATE HAVE_CXIVERBS
+      CXI_LAUNCHER_BINDIR="${CMAKE_INSTALL_FULL_BINDIR}")
+  endforeach()
+endif()
+
 rdma_executable(ibv_srq_pingpong srq_pingpong.c)
 target_link_libraries(ibv_srq_pingpong LINK_PRIVATE ibverbs ibverbs_tools)
 
diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index c10c8e21f64a..eb87b3c40d1d 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -72,6 +72,7 @@ static const char *transport_str(enum ibv_transport_type transport)
 	case IBV_TRANSPORT_USNIC:	return "usNIC";
 	case IBV_TRANSPORT_USNIC_UDP:	return "usNIC UDP";
 	case IBV_TRANSPORT_UNSPECIFIED:	return "unspecified";
+	case IBV_TRANSPORT_SLINGSHOT:	return "Slingshot";
 	default:			return "invalid transport";
 	}
 }
@@ -173,6 +174,7 @@ static const char *gid_type_str(enum ibv_gid_type_sysfs type)
 	case IBV_GID_TYPE_SYSFS_ROCE_V2: return "RoCE v2";
 	case IBV_GID_TYPE_SYSFS_UET_UDP: return "UET UDP";
 	case IBV_GID_TYPE_SYSFS_UET_IP: return "UET IP";
+	case IBV_GID_TYPE_SYSFS_SLINGSHOT_UFH: return "SLINGSHOT UFH";
 	default: return "Invalid gid type";
 	}
 }
diff --git a/libibverbs/examples/ru_cxi_launch.h b/libibverbs/examples/ru_cxi_launch.h
new file mode 100644
index 000000000000..ba87a6cd506d
--- /dev/null
+++ b/libibverbs/examples/ru_cxi_launch.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/* Copyright 2026 Hewlett Packard Enterprise Development LP */
+
+/*
+ * Slingshot (CXI) devices need a service and job grant that only root can
+ * create. cxi_launcher creates them and runs a command under the grant. A
+ * program that finds no grant calls ru_cxi_relaunch() to run itself again
+ * under the launcher; the second run finds UET_JOB_FD and carries on.
+ */
+
+#ifndef RU_CXI_LAUNCH_H
+#define RU_CXI_LAUNCH_H
+
+#include <errno.h>
+#include <limits.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#ifndef CXI_LAUNCHER_BINDIR
+#define CXI_LAUNCHER_BINDIR "/usr/bin"
+#endif
+
+#define RU_CXI_MAX_ARGS 256
+
+/* Returns 0 if already running under a grant, -1 on error; else never returns. */
+static inline int ru_cxi_relaunch(const char *devname, uint32_t job_id, int port, int gidx,
+				  uint32_t max_addr_entries)
+{
+	char exe[PATH_MAX], launcher[PATH_MAX + 16], cmdline[16384];
+	const char *args[RU_CXI_MAX_ARGS + 16];
+	char idbuf[16], portbuf[16], gidbuf[16], addrbuf[16];
+	ssize_t len, total;
+	size_t n = 0, i;
+	int fd;
+
+	if (getenv("UET_JOB_FD"))
+		return 0;
+	if (geteuid() != 0) {
+		fprintf(stderr,
+			"Slingshot jobs are set up by cxi_launcher, which must run as root; use sudo\n");
+		return -1;
+	}
+
+	len = readlink("/proc/self/exe", exe, sizeof(exe) - 1);
+	if (len < 0 || (size_t)len == sizeof(exe) - 1) {
+		if (len >= 0)
+			errno = ENAMETOOLONG;
+		perror("readlink /proc/self/exe");
+		return -1;
+	}
+	exe[len] = 0;
+
+	len = snprintf(launcher, sizeof(launcher), "%s/cxi_launcher", CXI_LAUNCHER_BINDIR);
+	if (len < 0 || (size_t)len >= sizeof(launcher)) {
+		errno = ENAMETOOLONG;
+		return -1;
+	}
+
+	fd = open("/proc/self/cmdline", O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		perror("open /proc/self/cmdline");
+		return -1;
+	}
+	total = 0;
+	while ((len = read(fd, cmdline + total, sizeof(cmdline) - 1 - total)) > 0)
+		total += len;
+	if ((size_t)total == sizeof(cmdline) - 1) {
+		char extra;
+
+		len = read(fd, &extra, sizeof(extra));
+		if (len > 0) {
+			close(fd);
+			errno = E2BIG;
+			fprintf(stderr, "command line exceeds launcher capacity\n");
+			return -1;
+		}
+	}
+	close(fd);
+	if (len < 0 || total <= 0) {
+		fprintf(stderr, "couldn't read the command line\n");
+		return -1;
+	}
+	if (cmdline[total - 1] != '\0') {
+		errno = E2BIG;
+		return -1;
+	}
+	cmdline[total] = 0;
+
+	snprintf(idbuf, sizeof(idbuf), "%u", job_id);
+	args[n++] = launcher;
+	args[n++] = "-d";
+	args[n++] = devname;
+	args[n++] = "--vni";
+	args[n++] = idbuf;
+	if (port > 0) {
+		snprintf(portbuf, sizeof(portbuf), "%d", port);
+		args[n++] = "-i";
+		args[n++] = portbuf;
+	}
+	if (gidx >= 0) {
+		snprintf(gidbuf, sizeof(gidbuf), "%d", gidx);
+		args[n++] = "-g";
+		args[n++] = gidbuf;
+	}
+	if (max_addr_entries) {
+		snprintf(addrbuf, sizeof(addrbuf), "%u", max_addr_entries);
+		args[n++] = "--max-addr-entries";
+		args[n++] = addrbuf;
+	}
+	/* Run as the sudo caller; a plain root login runs the job as root. */
+	if (!getenv("SUDO_UID")) {
+		args[n++] = "--uid";
+		args[n++] = "0";
+	}
+	args[n++] = "--";
+	args[n++] = exe;
+	/* Skip argv[0] of the original command line. */
+	i = strlen(cmdline) + 1;
+	while (i < (size_t)total && n < RU_CXI_MAX_ARGS) {
+		args[n++] = cmdline + i;
+		i += strlen(cmdline + i) + 1;
+	}
+	if (i < (size_t)total) {
+		fprintf(stderr, "too many arguments\n");
+		return -1;
+	}
+	args[n] = NULL;
+
+	execv(launcher, (char *const *)args);
+	fprintf(stderr, "couldn't run %s: %s\n", launcher, strerror(errno));
+	return -1;
+}
+
+#endif
diff --git a/libibverbs/examples/ru_pingpong.c b/libibverbs/examples/ru_pingpong.c
index 21cc068f2f5b..21a467715a0e 100644
--- a/libibverbs/examples/ru_pingpong.c
+++ b/libibverbs/examples/ru_pingpong.c
@@ -51,8 +51,14 @@
 #include <time.h>
 #include <inttypes.h>
 #include <endian.h>
+#include <stdbool.h>
 
 #include "pingpong.h"
+#ifdef HAVE_CXIVERBS
+#include <infiniband/cxidv.h>
+
+#include "ru_cxi_launch.h"
+#endif
 
 #include <ccan/minmax.h>
 
@@ -92,6 +98,11 @@ struct pingpong_context {
 	union ibv_gid		 gid;
 	struct ibv_comp_channel *channel;
 	struct ibv_pd		*pd;
+#ifdef HAVE_CXIVERBS
+	struct cxidv_lni *cxi_lni;
+	uint32_t cxi_svc_id;
+#endif
+	uint32_t job_id;
 	struct ibv_mr		*mr;
 	struct ibv_job		*job;
 	struct ibv_job_key	*job_key;
@@ -439,13 +450,10 @@ static int pp_check_dev_caps(struct ibv_context *context)
 		return -1;
 	}
 
-	/* The scatter/gather buffer array is sized at PP_MAX_SGE; make sure
-	 * the device can actually accept that many SGEs per WR.
-	 */
-	if (attr.orig_attr.max_sge < PP_MAX_SGE) {
+	if (use_sge > attr.orig_attr.max_sge) {
 		fprintf(stderr,
-			"PP_MAX_SGE (%d) exceeds device max_sge (%d)\n",
-			PP_MAX_SGE, attr.orig_attr.max_sge);
+			"Requested SGEs (%d) exceed device max_sge (%d)\n",
+			use_sge, attr.orig_attr.max_sge);
 		return -1;
 	}
 
@@ -510,7 +518,39 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		ctx->channel = NULL;
 	}
 
-	ctx->pd = ibv_alloc_pd(ctx->context);
+	ctx->job_id = DEFAULT_JOB_ID;
+	if (getenv("UET_JOB_ID"))
+		ctx->job_id = strtoul(getenv("UET_JOB_ID"), NULL, 0);
+#ifdef HAVE_CXIVERBS
+	if (ib_dev->transport_type == IBV_TRANSPORT_SLINGSHOT) {
+		const char *service = getenv("UET_SERVICE_ID");
+		uint32_t pid;
+		int ret;
+
+		if (!service) {
+			fprintf(stderr, "No service granted; run under cxi_launcher\n");
+			goto clean_comp_channel;
+		}
+		ctx->cxi_svc_id = strtoul(service, NULL, 0);
+		ret = cxidv_alloc_lni(ctx->context, ctx->cxi_svc_id, &ctx->cxi_lni);
+		if (ret) {
+			fprintf(stderr, "Couldn't allocate LNI: %s\n", strerror(ret));
+			goto clean_comp_channel;
+		}
+		ctx->pd = cxidv_alloc_pd(ctx->cxi_lni);
+		if (!ctx->pd)
+			goto clean_comp_channel;
+		ret = cxidv_alloc_pid(ctx->pd, 0, &pid);
+		if (ret) {
+			fprintf(stderr, "Couldn't bind PD PID: %s\n", strerror(ret));
+			goto clean_pd;
+		}
+		pid_on_fep = pid;
+	} else
+#endif
+	{
+		ctx->pd = ibv_alloc_pd(ctx->context);
+	}
 	if (!ctx->pd) {
 		fprintf(stderr, "Couldn't allocate PD\n");
 		goto clean_comp_channel;
@@ -522,13 +562,20 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 				      IBV_JOB_ATTR_MAX_ADDR_ENTRIES |
 				      IBV_JOB_ATTR_PORT_NUM |
 				      IBV_JOB_ATTR_SGID_INDEX),
-			.id = DEFAULT_JOB_ID,
+			.id = ctx->job_id,
 			.max_addr_entries = DEFAULT_ADDR_ENTRIES,
 			.port_num = port,
 			.sgid_index = gidx,
 		};
 
-		ctx->job = ibv_alloc_job(ctx->context, &job_attr, NULL);
+		if (getenv("UET_JOB_FD")) {
+			int fd = strtol(getenv("UET_JOB_FD"), NULL, 0);
+
+			if (ibv_import_job(ctx->context, fd, &ctx->job))
+				ctx->job = NULL;
+		} else {
+			ctx->job = ibv_alloc_job(ctx->context, &job_attr, NULL);
+		}
 		if (!ctx->job) {
 			fprintf(stderr, "Couldn't allocate job\n");
 			goto clean_pd;
@@ -692,6 +739,10 @@ clean_pd:
 	ibv_dealloc_pd(ctx->pd);
 
 clean_comp_channel:
+#ifdef HAVE_CXIVERBS
+	if (ctx->cxi_lni)
+		cxidv_destroy_lni(ctx->cxi_lni);
+#endif
 	if (ctx->channel)
 		ibv_destroy_comp_channel(ctx->channel);
 
@@ -709,6 +760,8 @@ clean_ctx:
 
 static int pp_close_ctx(struct pingpong_context *ctx)
 {
+	int ret = 0;
+
 	if (ibv_destroy_qp(ctx->qp)) {
 		fprintf(stderr, "Couldn't destroy QP\n");
 		return 1;
@@ -747,8 +800,16 @@ static int pp_close_ctx(struct pingpong_context *ctx)
 
 	if (ibv_dealloc_pd(ctx->pd)) {
 		fprintf(stderr, "Couldn't deallocate PD\n");
-		return 1;
+		ret = 1;
 	}
+#ifdef HAVE_CXIVERBS
+	if (ctx->cxi_lni && cxidv_destroy_lni(ctx->cxi_lni)) {
+		fprintf(stderr, "Couldn't destroy LNI\n");
+		ret = 1;
+	}
+#endif
+	if (ret)
+		return ret;
 
 	if (ctx->channel) {
 		if (ibv_destroy_comp_channel(ctx->channel)) {
@@ -1044,6 +1105,8 @@ static void usage(const char *argv0)
 	printf("  -p, --port <port>         listen on/connect to port <port> (default 18515)\n");
 	printf("  -d, --ib-dev <dev>        use IB device <dev> (default first device found)\n");
 	printf("  -i, --ib-port <port>      use port <port> of IB device (default 1)\n");
+	printf("  -j, --job-id <id>         JobID (Slingshot VNI) for this side (default %d)\n",
+	       DEFAULT_JOB_ID);
 	printf("  -s, --size <size>         size of message to exchange (default 4096)\n");
 	printf("  -m, --mtu <size>          path MTU (default 1024, same on both sides)\n");
 	printf("  -r, --rx-depth <dep>      number of receives to post at a time (default 500)\n");
@@ -1099,6 +1162,7 @@ int main(int argc, char *argv[])
 		static struct option long_options[] = {
 			{ .name = "port",     .has_arg = 1, .val = 'p' },
 			{ .name = "ib-dev",   .has_arg = 1, .val = 'd' },
+		{ .name = "job-id",   .has_arg = 1, .val = 'j' },
 			{ .name = "ib-port",  .has_arg = 1, .val = 'i' },
 			{ .name = "size",     .has_arg = 1, .val = 's' },
 			{ .name = "mtu",      .has_arg = 1, .val = 'm' },
@@ -1117,7 +1181,7 @@ int main(int argc, char *argv[])
 			{}
 		};
 
-		c = getopt_long(argc, argv, "p:d:i:s:m:r:n:eg:cNQI:S:L",
+		c = getopt_long(argc, argv, "p:d:i:j:s:m:r:n:eg:cNQI:S:L",
 				long_options, NULL);
 
 		if (c == -1)
@@ -1163,6 +1227,9 @@ int main(int argc, char *argv[])
 		case 'g':
 			gidx = strtol(optarg, NULL, 0);
 			break;
+		case 'j':
+			setenv("UET_JOB_ID", optarg, 1);
+			break;
 		case 'c':
 			validate_buf = 1;
 			break;
@@ -1245,6 +1312,19 @@ int main(int argc, char *argv[])
 		}
 	}
 
+#ifdef HAVE_CXIVERBS
+	if (ib_dev->transport_type == IBV_TRANSPORT_SLINGSHOT) {
+		const char *job = getenv("UET_JOB_ID");
+
+		if (ru_cxi_relaunch(ibv_get_device_name(ib_dev),
+				    job ? strtoul(job, NULL, 0) : DEFAULT_JOB_ID,
+				    ib_port, gidx, 0)) {
+			ibv_free_device_list(dev_list);
+			return 1;
+		}
+	}
+#endif
+
 	ctx = pp_init_ctx(ib_dev, size, rx_depth, ib_port, gidx, use_event,
 			  pid_on_fep, resource_index);
 	if (!ctx)
@@ -1289,8 +1369,11 @@ int main(int argc, char *argv[])
 		rem_dest = pp_server_exch_dest(ctx, ib_port, mtu, port, 0,
 					       &my_dest, gidx);
 
-	if (!rem_dest)
+	if (!rem_dest) {
+		pp_close_ctx(ctx);
+		ibv_free_device_list(dev_list);
 		return 1;
+	}
 
 	inet_ntop(AF_INET6, &rem_dest->gid, gid, sizeof(gid));
 	printf("  remote address: LID 0x%04x, QPN 0x%06x, PSN 0x%06x, GID %s\n",
@@ -1298,8 +1381,12 @@ int main(int argc, char *argv[])
 
 	if (servername) {
 		if (pp_connect_ctx(ctx, ib_port, my_dest.psn, mtu, 0,
-				   rem_dest, gidx))
+				  rem_dest, gidx)) {
+			pp_close_ctx(ctx);
+			ibv_free_device_list(dev_list);
+			free(rem_dest);
 			return 1;
+		}
 	}
 
 	ctx->pending = PINGPONG_RECV_WRID;
@@ -1408,11 +1495,22 @@ int main(int argc, char *argv[])
 		       iters, usec / 1000000., usec / iters);
 
 		if ((!servername) && (validate_buf)) {
+			int invalid = 0;
+
 			for (int i = 0; i < size; i += page_size) {
-				if (ctx->buf[i] != i / page_size % sizeof(char))
+				if (ctx->buf[i] != i / page_size % sizeof(char)) {
 					printf("invalid data in page %d\n",
 					       i / page_size);
+					invalid = 1;
+				}
+			}
+			if (invalid) {
+				pp_close_ctx(ctx);
+				ibv_free_device_list(dev_list);
+				free(rem_dest);
+				return 1;
 			}
+			printf("validate: buffer verified\n");
 		}
 	}
 
diff --git a/libibverbs/examples/ru_rma.c b/libibverbs/examples/ru_rma.c
index ba3f3d1ea198..bd78d9383dbc 100644
--- a/libibverbs/examples/ru_rma.c
+++ b/libibverbs/examples/ru_rma.c
@@ -52,8 +52,14 @@
 #include <time.h>
 #include <inttypes.h>
 #include <endian.h>
+#include <sys/random.h>
 
 #include "pingpong.h"
+#ifdef HAVE_CXIVERBS
+#include <infiniband/cxidv.h>
+
+#include "ru_cxi_launch.h"
+#endif
 
 #include <ccan/minmax.h>
 
@@ -151,6 +157,7 @@ struct ru_cfg {
 	uint64_t imm_data64;
 	int use_event;
 	int validate_buf;
+	bool mtu_set;
 	enum ibv_mtu mtu;
 };
 
@@ -162,6 +169,10 @@ struct ru_exchange_info {
 };
 
 struct ru_context {
+#ifdef HAVE_CXIVERBS
+	struct cxidv_lni *cxi_lni;
+	uint32_t cxi_svc_id;
+#endif
 	struct ru_cfg cfg;
 	struct ibv_job *job;
 	struct ibv_job_key *job_key;
@@ -243,6 +254,10 @@ static void ru_free_res(struct ru_context *ctx)
 		ibv_destroy_qp(ctx->qp);
 		ctx->qp = NULL;
 	}
+	if (ctx->ah) {
+		ibv_destroy_ah(&ctx->ah->ah_base);
+		ctx->ah = NULL;
+	}
 
 	if (ctx->cq) {
 		ibv_destroy_cq(ctx->cq);
@@ -286,6 +301,15 @@ static void ru_free_res(struct ru_context *ctx)
 		ibv_dealloc_pd(ctx->pd);
 		ctx->pd = NULL;
 	}
+#ifdef HAVE_CXIVERBS
+	if (ctx->cxi_lni) {
+		int ret = cxidv_destroy_lni(ctx->cxi_lni);
+
+		if (ret)
+			RU_ERR("Couldn't destroy LNI: %s", strerror(ret));
+		ctx->cxi_lni = NULL;
+	}
+#endif
 
 	if (ctx->channel) {
 		ibv_destroy_comp_channel(ctx->channel);
@@ -338,6 +362,8 @@ static int ru_init_cfg(int argc, char *argv[], struct ru_context *ctx)
 	ctx->cfg.do_rma_ex = false;
 	ctx->cfg.do_rma_ex64 = true;  /* default to rma_ex64 */
 	ctx->cfg.job_id = RU_DEFAULT_JOB_ID;
+	if (getenv("UET_JOB_ID"))
+		ctx->cfg.job_id = strtoul(getenv("UET_JOB_ID"), NULL, 0);
 
 	while (1) {
 		int c;
@@ -402,6 +428,7 @@ static int ru_init_cfg(int argc, char *argv[], struct ru_context *ctx)
 				RU_USAGE(argv[0]);
 				return RU_ERR_RC;
 			}
+			ctx->cfg.mtu_set = true;
 			break;
 		case 'r':
 			ctx->cfg.rx_depth = strtoul(optarg, NULL, 0);
@@ -540,12 +567,9 @@ static int ru_check_dev_caps(struct ru_context *ctx)
 		return RU_ERR_RC;
 	}
 
-	/* the local SGE array is sized at RU_MAX_SGE; the device must accept
-	 * that many SGEs per WR.
-	 */
-	if (attr.orig_attr.max_sge < RU_MAX_SGE) {
-		RU_ERR("RU_MAX_SGE (%d) exceeds device max_sge (%d)",
-		       RU_MAX_SGE, attr.orig_attr.max_sge);
+	if (ctx->cfg.sge > attr.orig_attr.max_sge) {
+		RU_ERR("Requested SGEs (%d) exceed device max_sge (%d)",
+		       ctx->cfg.sge, attr.orig_attr.max_sge);
 		return RU_ERR_RC;
 	}
 
@@ -574,7 +598,7 @@ static int ru_init_ctx(struct ru_context *ctx)
 		ib_dev = *dev_list;
 		if (!ib_dev) {
 			RU_ERR("No IB devices found");
-			return RU_ERR_RC;
+			goto err_free_devices;
 		}
 	} else {
 		int i;
@@ -588,16 +612,24 @@ static int ru_init_ctx(struct ru_context *ctx)
 		ib_dev = dev_list[i];
 		if (!ib_dev) {
 			RU_ERR("IB device %s not found", ctx->cfg.ib_devname);
-			return RU_ERR_RC;
+			goto err_free_devices;
 		}
 	}
 
+#ifdef HAVE_CXIVERBS
+	if (ib_dev->transport_type == IBV_TRANSPORT_SLINGSHOT &&
+	    ru_cxi_relaunch(ibv_get_device_name(ib_dev), ctx->cfg.job_id,
+			    ctx->cfg.ib_port, ctx->cfg.gidx,
+			    ctx->cfg.addr_table ? RU_ADDR_ENTRIES : 0))
+		goto err_free_devices;
+#endif
+
 	page_size = sysconf(_SC_PAGESIZE);
 
 	ctx->buf = memalign(page_size, ctx->cfg.msg_size);
 	if (!ctx->buf) {
 		RU_ERR("Couldn't allocate buffer");
-		return RU_ERR_RC;
+		goto err_free_devices;
 	}
 
 	if (ctx->cfg.client)
@@ -636,8 +668,48 @@ static int ru_init_ctx(struct ru_context *ctx)
 	}
 
 	memcpy(&ctx->src_id, &ctx->gid.raw[12], sizeof(ctx->src_id));
+	if (ctx->context->device->transport_type == IBV_TRANSPORT_SLINGSHOT &&
+	    (ctx->cfg.write32 || ctx->cfg.read32) && !ctx->cfg.user_rkey) {
+		uint32_t key;
+
+		if (getrandom(&key, sizeof(key), 0) != sizeof(key)) {
+			RU_PRINT_ERRNO("Couldn't generate narrow remote key");
+			goto err_exit;
+		}
+		ctx->cfg.user_rkey = true;
+		ctx->cfg.user_rkey_val = key | (1U << 31);
+	}
+
+#ifdef HAVE_CXIVERBS
+	if (ctx->context->device->transport_type == IBV_TRANSPORT_SLINGSHOT) {
+		const char *service = getenv("UET_SERVICE_ID");
+		uint32_t pid;
+		int ret;
 
-	ctx->pd = ibv_alloc_pd(ctx->context);
+		if (!service) {
+			RU_ERR("No service granted; run under cxi_launcher");
+			goto err_exit;
+		}
+		ctx->cxi_svc_id = strtoul(service, NULL, 0);
+		ret = cxidv_alloc_lni(ctx->context, ctx->cxi_svc_id, &ctx->cxi_lni);
+		if (ret) {
+			RU_ERR("Couldn't allocate LNI: %s", strerror(ret));
+			goto err_exit;
+		}
+		ctx->pd = cxidv_alloc_pd(ctx->cxi_lni);
+		if (!ctx->pd)
+			goto err_exit;
+		ret = cxidv_alloc_pid(ctx->pd, ctx->cfg.absolute ? CXIDV_PID_ABSOLUTE : 0, &pid);
+		if (ret) {
+			RU_ERR("Couldn't bind PD PID: %s", strerror(ret));
+			goto err_exit;
+		}
+		ctx->cfg.pid_on_fep = pid;
+	} else
+#endif
+	{
+		ctx->pd = ibv_alloc_pd(ctx->context);
+	}
 	if (!ctx->pd) {
 		RU_PRINT_ERRNO("Couldn't allocate protection domain");
 		goto err_exit;
@@ -654,9 +726,16 @@ static int ru_init_ctx(struct ru_context *ctx)
 		.sgid_index = ctx->cfg.gidx,
 	};
 
-	ctx->job = ibv_alloc_job(ctx->context, &job_attr, NULL);
+	if (getenv("UET_JOB_FD")) {
+		int fd = strtol(getenv("UET_JOB_FD"), NULL, 0);
+
+		if (ibv_import_job(ctx->context, fd, &ctx->job))
+			ctx->job = NULL;
+	} else {
+		ctx->job = ibv_alloc_job(ctx->context, &job_attr, NULL);
+	}
 	if (!ctx->job) {
-		RU_ERR("Couldn't allocate job");
+		RU_PRINT_ERRNO("Couldn't allocate job");
 		goto err_exit;
 	}
 
@@ -816,7 +895,11 @@ static int ru_init_ctx(struct ru_context *ctx)
 	memset(&qp_attr, 0, sizeof(struct ibv_qp_attr));
 	qp_attr.path_mtu = ctx->cfg.mtu;
 	qp_init_attr_ex.qp_attr = &qp_attr;
-	qp_init_attr_ex.qp_attr_mask = IBV_QP_PATH_MTU;
+	qp_init_attr_ex.qp_attr_mask = ctx->cfg.mtu_set ? IBV_QP_PATH_MTU : 0;
+	if (ctx->context->device->transport_type == IBV_TRANSPORT_SLINGSHOT) {
+		qp_attr.port_num = ctx->cfg.ib_port;
+		qp_init_attr_ex.qp_attr_mask |= IBV_QP_PORT;
+	}
 
 	memset(&semantics, 0, sizeof(struct ibv_qp_semantics));
 
@@ -893,12 +976,15 @@ static int ru_init_ctx(struct ru_context *ctx)
 	}
 
 	ctx->mr_attached = true;
+	ibv_free_device_list(dev_list);
 
 	/* the RU QP is created directly in RTS (no INIT/RTR modify) */
 	return RU_SUCCESS_RC;
 
 err_exit:
 	ru_free_res(ctx);
+err_free_devices:
+	ibv_free_device_list(dev_list);
 	return RU_ERR_RC;
 }
 

-- 
2.56.0

