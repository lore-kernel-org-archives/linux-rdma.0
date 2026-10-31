Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421388;
	b=S6n6Z5DG2L4MydaS+isIv2iT3U7Izf1KBzVLlpZRFrL/Scy9i9wutN3ig6vQDUVhgbbb
	 3fInoTebqr2Da9swXadJirpeuNd24cNi1f2C0aAtCHjaHhAwUZ1FOOPteqVmmR2FUkutV
	 l/CymIIqelq5O94GHXosSjFOyp0Zardp5pboMYOiN9lAZgGYOq1DVHQuiyXzdTbSrbRD3
	 f72x/THL5B7xkrHFc/p9zDzde9NBzi1tHl4ykhUmeQQ00Dit64EeAPy3GoY/m3qhgHz38
	 w73wMu7sUdA2M6808WoA+XTYM8zofRu6uQem0vXn0S+Vzhweq3HbY3wvFe+ToTkeOuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421388;
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=IPFwwo9KD/5ao7eZ/bGttN2g0HHCAfoWLrsyu7Sjh5M=;
	b=BDWvRUXNc9U5gk7gbL92EdypsUbpvnj6I0hVwYYRjnLtJb51155iqDtJoLjYnQ+UfOYI
	 e8FJWLkD+xrcUi5aVs9q0AVuIyyH3P9d5uPliE3P00xQpp/gm/SVmy9sIEon5fkP3b7zp
	 D5Gcb5Apert6LrNagfjxkVsTR4qu4CLhijPJ+T9rP7M1v9RBe5S84+d2/qnndvoGIRT0w
	 WJX4o4RbpRepeShIdA7qdoZxR+Bbanke1DwKg3bkfoIILqkt4bJYZFyG1IxIxz0iZvHgc
	 HV5QlpVmSwByRYkBroGMbvP9Rd1syQVgwANasbtzoj45C9eav4Ci+hUT06kWhJJUj0w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=H9WoHksH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D793606A330;
	Sat, 31 Oct 2026 04:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D793606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=H9WoHksH
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V1GgfJ2581377;
	Sat, 31 Oct 2026 04:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=IP
	Fwwo9KD/5ao7eZ/bGttN2g0HHCAfoWLrsyu7Sjh5M=; b=H9WoHksHofJznuNPAc
	PnkioXEtqZn7hBGtC7iNubKUd0bITCxpdG0cc4XhK3Q4fG/p47lmZ+L5o6iBv2Iy
	y5rKsyjRF5x9G7forRwGdMdbWnG999bsxaJQM2BHS9LsgM7dA9+KpJMQbjkjKKfQ
	X1mFudUdOl4JEyMzyN+jGEZzt+Sjhz0lcsp4wX45eboPgInMwQmYr+j0rNUVUnov
	Fqd+39/xd+GVt+cWSpPRYRiHqKNlsh1nBBL1v5mymaIBhvvmz33h7qB5Yohfxuwu
	I8HdkBFfYwsB4bVMrVN4mpz/wREHtVLSVSuQs0pPZhRACJPDnwPRhwBt6tRYSIbh
	Fx/w==
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn6h89ebh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:26 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id DF113147AD;
	Sat, 31 Oct 2026 04:36:25 +0000 (UTC)
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:25 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:25 -1200
Received: from BL0PR07CU001.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 04:36:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hhy/gfuazb+pE4LlNdrVdKKB0JmAfVIQWMGY5KE8H2ZoshQOzxbTojnEiYCvm1qSXX2XWPz+q53IqyGBAF6minCxN8t6R/4YcillCHtRaim73NZlN7zwPuLNLl3sqfTH//Sb2DtY9zaGIAvyyR3BuNo/z1HfAB2C8T6CBhX2o0nkIo+y1FYMbFb5jn8v4OkFzBU5VXzt1rzh81/nonUBL1tVjRKki+cz1x6NnyU/AnpQ7IMu6SjVP0QC1GD1D6Pl+ur//SY9SfqBpwaRc8VUZ6yHnbDyf7+TjFiJBaf1b/mHkGyDs8ecub3pfnClxZQ/KcnrKvaHpLu69iXkpZE+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPFwwo9KD/5ao7eZ/bGttN2g0HHCAfoWLrsyu7Sjh5M=;
 b=uYmrP/bhmMmSPLSCdnRcg0VaQISC7TV3zqAooLAZu0sgSBrs+4A29IcWxKeGa644ijgd+45/ezPMehgf32etbE4x8iQM/UzjEN258KOxTVw8rPH2UGDKmXKzZP644YnoSZY/YEjroRCggoatNKxu+anH1KXBRj+VlWeKnFib+dG+6fkIneu5kvU5n/iKL8FoLGTZVK9ijPmQxnXf9xyYzPQj16c8zKst3n0YT/TisiMiRmHc88lqfv/wY7pysyRjx8qWlYHFs/jS+PvLDjhVvK6mSYVV+FsewLXiiw++rIIV0YRFqV4aMbEtXwufvPyWS/0jaWiXpCfWFAzDNOrEhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:21 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:21 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:38 -0700
Subject: [PATCH 10/11] RDMA/cxi: read the NIC telemetry through counters
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cxi-for-next-v1-10-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0093.namprd11.prod.outlook.com
 (2603:10b6:806:d1::8) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 531a919e-e4fc-4d68-e128-08df37088339
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|18002099003|22082099003|56012099006|261021121427099003|261021135927099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: IKpGmL0EBnrHhxmNErZlKjSDJYY62uaF8ISkwVDYF2ZACGXAJM6qAjrdOtPtuLy4+u8uS0oSgsZxOZmJLs6mWONWIiWyy2KdolDWRCaOZ96nkehAOlpE5WS7jjE4VxmQCFowGb9C7Hobn/f6TgYPy7RfC+CRLnUbWDIQYsAyH6CiP0XyXZIEnizwUVRS8gKVRxpI/PzojDjNCClorOLn+nKapv+bm5FpC48TFEF0s6LyKII2N9YGqN17gYPnj2xyV7//JVm0L/tG8UQviT0OUPMlr7br8h/5IbHcNRL/E86dxDrtKqmXshcKXZKiVVLTFOWmw3oSiX6MAWJGQ/mEvc2FtCGaeqBrcnGHDiGqNnlR5jVvmM+hrq8VOW2Q3auccigFbM7yyWivnhgYjb3A7l7OOuuTC1euOHVxH3insT9dljc4sVyllA69C+VWi+yhSGDieZoMA/72oJEh7RF1qFa12piCsmW59UGiUcQw0NaRWD/Ww9yw8djT3JlHW9Z3aFHW+NHTddJdlIhfrmrqEXqlepBrB9IK8xLuFKAai99rc4M2vQ7fiHISH6FjvzpyA0tfu0yOStzgJDekUibgxXiVEgveeIE7s1e/gyNPBhnAYMkPj6vU3UPW19wPnamDdXEhKJhifmMHjByuwhyYLeEfEuKIWf48AcLzGivvGOc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(18002099003)(22082099003)(56012099006)(261021121427099003)(261021135927099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm8zd3FicTJjOUJCNEJWS2lPTFJGRTc4NVYzTVpaSi9YZytma0V1Sm1Mb3ZV?=
 =?utf-8?B?dm9kQkNrMXlVNGlIdGFpSGpUalBDTWloenltYko0VWM0d2hiNVR2MzdmckNR?=
 =?utf-8?B?UXFaWFFJZEVDY3BZYXY1bGxDZ2Rma3QxYlcxYkFJV3BKMmFFRTI0UnQ4ejlF?=
 =?utf-8?B?Mll0c1ZTakx2ZVAwMVZSY0NGR3pYWHNhMDZYcE1JMWR1TkRkV1NSSWxsZWhU?=
 =?utf-8?B?cndHMHExdHl1NkdRYU1SdVpzdGpNNGl6SkV3ckUvZkEwTk8xR1J3dWhjY0FC?=
 =?utf-8?B?Nk1uMVlOR09oQ2YrU1FlUzJnbmlmSjE5YkpmT1N4Mk1kaU41Zisrc0EvN05x?=
 =?utf-8?B?bTlRQitaZHhEV3YvZndGaEFJNnphYXpQRkxJWTBoaGZIR3p1dW9nTVNwQ010?=
 =?utf-8?B?S201OEJmQ0RaU09SVTV4Z2Faa2NKQ0dXUTBRUmxnSVdTRUF5aGcrblF2ckNy?=
 =?utf-8?B?ODd0QmhpaXZQVzZKZ3ppRWswVGtLZHVXTjV5czFEVCtiSk5obTBEdGlBZFRm?=
 =?utf-8?B?L2crZ2l1d1JxNk40NGtKM0l2R0I5bGNZZk5uNTh3Q1l6Vlh5OE1YSWdHelVY?=
 =?utf-8?B?ZjhlREZSSUVFRk5nNHllZEV6d214NlAxVEg3TU51aUdJcXZxNzhvcXNYL2xF?=
 =?utf-8?B?ZVp4UHJYOWs1VXozTFFnbURWVDlMNld2TzBkWWc3S1R3K0RyYkEzblgyaUVR?=
 =?utf-8?B?eVphOUNVZUprNnRVVUtNRm5leUxIcUpKWVF3SVp4QTVuRVpidytRcGdBcEdI?=
 =?utf-8?B?RCsxTUlSVi9rbkFFamdJb0xzUHU2U1BSKzB1UEVNUjB2cWtZcko4ak0ra2xF?=
 =?utf-8?B?K1JLd1NNS2kxdjhyYTRZL0E1OVI4d0tTRHFDd3I1eWlEUUR3ZmtJU0J4NlZP?=
 =?utf-8?B?d21OakxWdmlVK2xGWEdlK1pPV0ZXWXY4M3NxYm53UnpFVjRHRi82OU9MU3lt?=
 =?utf-8?B?djhqbFo0N1poMzA1SHVabVVrMEg3WWtIa3VpMEVpdk0za0hJVktUSjFMVTVE?=
 =?utf-8?B?anBlVkMxbzV5c1U5czF1eW4wN2dKdWZHOWwrMUlKdmR3Q0JuUUxtT05CTnZw?=
 =?utf-8?B?SlFEajNkWHEvMG5YaTVDcXhML3R2ckZKOVBXcXYrNW9CWUtFaU1xMDdIR3Nw?=
 =?utf-8?B?Yk1ib3ZLcWJBY0JNZTI1bFlzSnRqZk1jOTRnc0RBOGRyQkN2WmUrTW9FeDVa?=
 =?utf-8?B?bnVBNkFqaHhweHFGQ3laR3h5TTlZTWlIYTlSMFV3MXJnRVpVeHNtdmlFSnBI?=
 =?utf-8?B?WjAzRkcrRUJNQnJKeUxwdmprVjFvZENxUHRDY2ZuVWNwM3lOKzNQejFWcHRB?=
 =?utf-8?B?dVNYYldHYXk1N1RCS2g1aVREODFQaGQ4NEhjMnhxYUNwTUxrenpieEpkTGhG?=
 =?utf-8?B?M0ZIcWhzQlhSVDFzWmVNdlp6MW5jcDNYMU9LWGJQY3I3dGpWOTBOWHp2ZkNV?=
 =?utf-8?B?YUFoY3dYbjlISjBvMHgveU1FdW9BcDc3SVNacE9zMkRGUUlkOFNmOUFDamFo?=
 =?utf-8?B?Lzd0ZWMrL2JnOFJiZjlMdklaRDdzSGdMTHpuaGt4ZUZoN256aG9oR3B2QmdJ?=
 =?utf-8?B?R1JHazF0ZjNWck1UYlVtblFzaGpGZ21lVUpjeFdBQ1BNTUp2Y0Zxdk5sSHc3?=
 =?utf-8?B?YUNMZHd1MVZpT0pxNCtJNEhkYXh5dDFDSHZycjJDK283eWQ1bkpNR0plR3lG?=
 =?utf-8?B?dzBGTDUra216eno2TndwS1lrdlo0Z3dHVnd4SXJSNUlrRWRnMWdUWnQwdVRQ?=
 =?utf-8?B?d1djY3BPS2hXT0NDUnFkZmxoQXlVQlFiZFFid1M1dWhSdm1zRnFEcTJFaFJP?=
 =?utf-8?B?QWo3Y25VLytOME1aOHFLMWRwTjFWWDh1cDRpS04zRUZHNlZabS9OdEhnL3NC?=
 =?utf-8?B?V3p0T1d3ZW9EWUYxZ1Z6bENJcTNYT28zL0R5c05HRHFRVkVIY0JkaDNmMi9x?=
 =?utf-8?B?UUVYQ3BLSGVBUmVSTVZSN09WdklvK0xqSzY3aTFDWHZkc2dWeFpJSGhDa0Za?=
 =?utf-8?B?eHpScGR2bU1qN3RiZDNtdmxwVnROT0cwV3l0TnVKTEJIWWF0V2ZkT0NtMHhC?=
 =?utf-8?B?YXY1SDltNVd3OG5FZ2luODlnVWtIUG9LYTAyclI3b2ZpY21hdVhyazNiQ010?=
 =?utf-8?B?UWcwZDRHa1lUYTVkemV2cFl1VXlPQW0xaTd6eS96bG5vYU83UnFJd3ZPK1Bn?=
 =?utf-8?B?bjRhYmRrb3dGd2R4a3JNeUJsZjBqeWJGTmU2OVBMbTRVR1NnckR2dU9tVFkv?=
 =?utf-8?B?KzJvQnhZdlhWWEp5ZllmRjdxYlBVYjc2SXlVM2sxWjJLU3FhZ0xpeFFmdTdV?=
 =?utf-8?B?NHJEdVpYTSt5UUpEQjQrS3g1YndpWDlVNEJ0R25mLzlxZkFQSkE1QT09?=
X-Exchange-RoutingPolicyChecked: Qlxv17+vuxAtd7PsC0L/dJkW6/EwKLvm8/wy0RDbHDohaQMxQ6mR0phP/jTEMMYDXr1QujypmfS4KrAbm0dLJ0gABmvvvaG0lO8iEK+zUVXZ2wt+metnDNY+bl9A5eN8ZgMF5+Ep79etbWfRIIsKs8oBInG+HXgeqIsuPDGWiZa03E/kVJ4wCjstRTwlPLedy6DFq1OpaUQZJM3Qmu2T898V/Cjjc+Kikaii1Cqzdric9Wt7VA5KPNn76DKRPaD0vQy/YXfgYaJ5JrBC9/OWharzz6Diy9bwCfTLaUCVUG8Q76h/k4CtX3Ya7c/PxHqlqYymZHs0okAxF7CO5FTw+g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 531a919e-e4fc-4d68-e128-08df37088339
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:21.1869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dX1/63d8dSQWm9yJzPMGu1Hyn+nrkiegLFSXXlkLp6M9KW8g/QaePD0Lfkez/FKryFr9QIZ4P/agD0kzjplCtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=bYL+w+PB c=1 sm=1 tr=0 ts=6ae5704a cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=ay80y3fxfMS_JZZz1qJy:22 a=MvuuwTCpAAAA:8 a=cVylBbLDli51mRLdwJUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 7uOFon1Iq3breZ7_OxZ_CnidETnzwOsV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX18Cq7tW5371D
 CbPcXgBa9V2qJAsTXEEJwA5KIndS5QNsisKGeNpUBi6pF/VLMM3S9pMyNdn8x9d5OR4ScGTmH2z
 dsM1ueuNBIgVgjUlLAerW+VOD4A5DUY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX7HmZc84YbOQr
 0933m0+3PaNoWo2Pye7M8H/OTcDmMAVAjj7Lm7Lx5UvnnuJB89qgPbaPxemhoPuOngwO1CcW1Qx
 9oLiWQ2DzwxKVbVOA/e8MeiVDbXhp9zYnvyy2PZfeFt4J2Wpex2aTTDiT8SSkeTjGPuqGTkzHAT
 7RdBMA/TPId9p675JQwluCEDdnTdX93Ew+fbfP0Wr1Uc7Hg7yr/yoGe0vhxEQxSp1REP6ZjVdA0
 OEK4D1bWoOrpTw0wE4GJSqwAEBNP1Usul4HgmbFXsUvecbYEXa1w2tWMKl7sZvJ1R+rxCJdhx5d
 V/gDosiSxsRRmxGezW0u8YA/4XAvv7Dq+8b/uIJzMaM2/ql/HOHBjMn1bGkIMCWY3H9LXfqLhf5
 9tIXzBhi7HLF8QEawfqYxghJfXdI7Xx6FEkFQGI5p6V2Modyj2mXLKR1PYTVqofDhzsCN4FuocU
 oSFjrynzayScqLfdkRA==
X-Proofpoint-ORIG-GUID: 7uOFon1Iq3breZ7_OxZ_CnidETnzwOsV
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Implement read_counters_ex() so that user space can read the NIC
telemetry through the COUNTERS object.  An item number is the index of
the telemetry item in the core driver's table, so the caller names what
it wants without the driver describing thousands of entries in sysfs.
Items the device does not define read as zero with a zero timestamp.
The values come from the core driver's cxi_telem_read(), which reads
the device BAR directly.

Known limitation, deferred to V2: this patch carries SR-IOV
virtual-function code (VF-to-PF mailbox requests, mailbox opcodes or VF
resource handling) from an older, incomplete version of the Cassini
SR-IOV support. V2 of this series will include the updated SR-IOV
implementation, so issues in the VF paths should be ignored for now.

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs_counters.c | 38 +++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs_counters.c b/drivers/infiniband/hw/cxi/cxiverbs_counters.c
new file mode 100644
index 000000000000..2ece6568ea7d
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs_counters.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CXI RDMA telemetry counters, read through the uverbs counters object.
+ * Counter numbers are Cassini telemetry item IDs; user space names them.
+ * Copyright 2026 Hewlett Packard Enterprise Development LP
+ */
+
+#include <rdma/ib_verbs.h>
+
+#include "cxiverbs.h"
+
+int cxiverbs_create_counters(struct ib_counters *counters,
+			     struct uverbs_attr_bundle *attrs)
+{
+	return 0;
+}
+
+int cxiverbs_destroy_counters(struct ib_counters *counters)
+{
+	return 0;
+}
+
+/*
+ * Counters are not attached to anything, so the core's attach check does
+ * not apply. With no items, counter N is telemetry item N.
+ */
+int cxiverbs_read_counters_ex(struct ib_counters *counters,
+			      struct ib_counters_read_attr *attr,
+			      struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(counters->device);
+
+	if (!dev->cdev->is_physfn)
+		return -EOPNOTSUPP;
+
+	return cxi_telem_read(dev->cdev, attr->items, attr->counters_buff,
+			      attr->timestamps, attr->ncounters);
+}

-- 
2.56.0

