Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421367;
	b=tTNlgCzTBicFE9S/dKWqr5OrkytANXzwAiSwMFO9HqUKtxhmcLD85oFdSQked+4m7dwg
	 IV4KMSTeVaIH5MdBy+x+1lJF+zMt33Ojj2OCBnDiDT9+9PsaLgc3MIIQ1V/bqox96132y
	 S3klUlF75+AFH0mc9svUJ3AkH9De0sX10dLettqC0qQHWbvwHyfasN6k39jXOmFEGeIUA
	 z6RKXBOUDi2z9NPVU+JrGXGzBcJ8p8PmTzpOqk8RoiW4RWCMjFreqKWFcmyJ/mc2lTicj
	 cLVQj6cWMoqrLZmqiFnlmyCgwkPTSFybrN22ZeHyERxk4D+rOktddDs+iW/tERPckew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421367;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-HPE-SCL:X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=zdRRsR17U1IQjJpCNDBAf1NEKxEKXj8wR0AWW4c0Z+w=;
	b=5UGCEuJ4pN+NwDtKTUF1UdZLb7qyS4TXOS/GxUKiyHJKLrF+j6mDlfxOWR+NNdLZrLfs
	 vTP9Qb6BggmCmtOCnAn7v69j3M3sC/L6CYI6Boglb55V3KldR7R5p6HAl1D+LrzzbHtxY
	 IIvJf9HLpxKJlZNZV7HR+afBEtGBsFqO6Vh+TLy6MfuoTHMQVMRGe2f5f+/qNUP9NcAKs
	 W/htSjpzaw9mZxWChakDMRnwmI3qB+UJsC3pdivTUkAMKdC4shyDB28UrMHDdH+rY8bhB
	 k+bnZnq9kp5UORNX5xJcs3CsNH02fRAsdbEX63MtMSoMdqKvdIR2FU6iic8/aVENyww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=bj2YRfNe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266EF606A32F;
	Sat, 31 Oct 2026 04:36:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 266EF606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=bj2YRfNe
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V4VtOi524247;
	Sat, 31 Oct 2026 04:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=zd
	RRsR17U1IQjJpCNDBAf1NEKxEKXj8wR0AWW4c0Z+w=; b=bj2YRfNecQg5+FmnxD
	vuH1A053Ileotp8ZO3VXLNUWvJ4Mp9cfjBn4mjwO+r0K+5IyY+w2mKW93aFKrXoo
	Skw5f7i6iRDrGedGi9zZawuDk7YseK+X4kfnnCiYzxbHOBGllsX2c0MLQ8bGfqJv
	Cx75TNLPZMtIe857B+woU+jraIJxRprAuuey33F/PTLOa/iJzHYWC9gHUokyOoIL
	F6xsEcUPxhJPh+gTGNnAuIuGfPc8yG7uaBK3qpMvKqy8euqe0d4nP3brWwqPbkb4
	4CX55wbxVsEYDMxXA0gqi/0DxQRwTdUdh0p0RH/aVkbbk2PEfYNLuJOOxash/Cdg
	SZPQ==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn5ptht8m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:04 +0000 (GMT)
Received: from p1wg14925.americas.hpqcorp.net (unknown [10.119.18.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id B8B3180479A;
	Sat, 31 Oct 2026 04:36:03 +0000 (UTC)
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:03 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:03 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:03 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9by2djZiN84d48eAz5SglNIFDhrOfw2kK3SraTnI5FjZwI3uAGYHY+0Mts7+LVfBcjCwjqqy0uoJSsEsEkgAXdA+qK516idywXLeFONKSwfIPBCLoC9qXqLTlRtBxrG0zSZsyZ1snWAyArveQGH7YsPVPSWmnLwgkHyqoRcbR1c1xVOTiYtVATXzogkFbwY6YYHmfM/sLbhzdGXkvGX8NqDikjIUynh0sPf6kZpxh0l6NdJrUC4YkaFHsHfXA6hixShMuCoP3/qSclWyD06+MO2M+rpdjF87TwhdmVGqZmGLtbMU0vaWJ7hrRinQhdXunfwB2Q6qQcQd86EMyzrqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdRRsR17U1IQjJpCNDBAf1NEKxEKXj8wR0AWW4c0Z+w=;
 b=QxJ1KQBClfCAfXNBrRKRfMCRsjf2fKZCW9XQV2OLbEBhMiXml2UchwtkqScX/k8vWs0A9ENxI3lAhR5nIjaJIS3YgkigEp2sW+aHqZ+n7Xpn3noW/U4DMdj6e7Jf5iATEZw4yI7mXKvvF3FEKfzdwV8WpnCxxJBbAN2U/sC7ctXTYcF86QLJ317mM9wUjcXsxj6Y8uINXVl6zbMp1DCQH9F+tlsZsQJwFjOX0+wrecztHjPQT9QP9OapjGROn1Iu3RzSxiEH9YwZjEeJlePWIs5wqhBfMjbDOYsFz3sqrA2XFLiHkSuyiTEgdiR2C1q+I9UlvQoVHbM0wd33vn3Zyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:00 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:00 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:31 -0700
Subject: [PATCH 03/11] RDMA/core: add Slingshot identifiers and
 driver-owned GIDs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cxi-for-next-v1-3-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: DS7P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:25c::7)
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
X-MS-Office365-Filtering-Correlation-Id: b5ddc4e5-19d3-4fed-fecd-08df370876d6
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|3023799007|56012099006|261021121427099003|261021135927099003|261022105027099003|261026140227099003|261026121527099003|261028144727099003|261009223027099003|261009221227099003;
X-Microsoft-Antispam-Message-Info: squAZMu0YU7eVEXyxLDuZJnsnikVkBjoJ611g0fb80lbIf43ayZyWz0FSFeTjvgi2JMnm9tqp99B35dqF7GKGx9KMqKuzRquWHC65qLs8vXzjxSLPLj5Gtx70UwJ3JhgObmeHuP6dKAN2Buzn+X8EyRo3+O5mzfacctb21E1++F4ztHGPVuM6xbqjVNoS4T7aBQ0ArxKqV+LIjk8AISF/+iQE1icjqfx+PQNgLVQymNlbPCM8iO20BpqsNaV/0aiT9Ax9wmrYRPEmAdiAMfWlTqWuNCe3xQ+KkP3jH3npaVbFKkRYlKkYLbYpYFGg6Mm3nhPhlqLaWuF+rbWCvIhVQm2Ky9HC3Yfwq+kzCLxW4hQogLaYrQFt9VW9w4+fxkrd0hyXbWOOQhOqBebjoWVzKxc0uup3GjGSfKIhnnRUYRVOnHsN+kjAA3hnjUF7lA7mbxB9ae4CAK82b6kpVrjoJsYDT2iKKlT6t0wLdq125vxf8CWVHrJze+/FMMyy5WOCx0VSN0wROe6DcVDvzWgztbVIZijWsw3spZDtCdT6tu4X0Ri6hr7qI1fU1y4mIumtvhILVsd6r74/K2jtyXBDHhPEBqm86ptPi18sW1n8GWt/hL0jbM8sIFTGo/hAjiev0vG5YEGzJsq9NbvxIwREfkYKZGx6v0xPdaYa7u5W3k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(56012099006)(261021121427099003)(261021135927099003)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003)(261009221227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3RNQnN6NXphL3lPSTBLM2hMdnRQbkY0bHMxcVIxYThRazdubGtBYjBUVk1q?=
 =?utf-8?B?YXBEei9PNnU5QUY1QTFjZDVtOWlFV3VLMmloeFlySy9PUU9jVkFVQ3ZBbExw?=
 =?utf-8?B?c2M4TzJFVzNnaVphNnhHRHU5RGFxcnRLM2htcU1lQ0gwL0ZTOGtiOWxuK2dS?=
 =?utf-8?B?Q3prVmFQTkw2T29NdTBSZ3JTYk4yQTlwVUVWRFhQZUptQjllTFFsRWtEckdQ?=
 =?utf-8?B?ZFVQY0NLUE9GbFZJMlp2WlA1TU1UTEY3NnJvd25lM3BkeFlXY05ucS9CLzVW?=
 =?utf-8?B?d09PVUx1dkNrSzQwamtpbFE3SHd3YnYzSHpVeGJ5WWwvV3htYTk3U3NTbFox?=
 =?utf-8?B?ektXdm9vdXpUWlR1ZENyUnZLd0hYTy9sOW1zNUdSazErV2RDMjI1bWxUTlE3?=
 =?utf-8?B?TGVRTHExcnZaV0Zjb3NTOTltVlg4VTdrWEF3NVhMeGxKOEErd0dyK2R1RzlJ?=
 =?utf-8?B?T2pXSHFOeWxmd3ozMUdScGEzRitSWW1sd0o2dGo5dmU3V0RIS3ZEQkJNSW1n?=
 =?utf-8?B?UGQ3RHNFOEk4ZTZpNEQ0dGIwSjZCcSsrSWxmTVFQK1pCTFh6YXUvTmdKN3lL?=
 =?utf-8?B?QVp2TkpDeGR6UDJDYVozTzBhTFp0aW9Uby83VTJ3QWg0dmZLRkdueFpJOVJW?=
 =?utf-8?B?TFZ6b2RSbmpkaWVEQytDNGxaWVg1Q1JQYmhiVElFVjdxK0xtWUR4UEhxZC9N?=
 =?utf-8?B?dlNNM2dmY3IwRlMwZnF5elFMbk45cDFTNytjN0J4MXhVbVJTNU9Ocmw1d3dt?=
 =?utf-8?B?c2Via1ZIaHlmaEsvNXJXcXR2MDhpbzVXeWVkcFJzVWo5am9yS1ZNU2ZGbmww?=
 =?utf-8?B?dkZhY0FGVkMzR2I0UGJvQjV1Z2prSTlqaitHY0pPbklJekJRUEVHQ21EK01P?=
 =?utf-8?B?NGN0MDJKa1JzVmJRU2UxbnJNRWdVbFRYUmVqY2lDSnpsYVJhWkdhNkxKWVhW?=
 =?utf-8?B?MmtPVVNmZlRnS1REMHZtVXNFSk5RT0o0RTgzbytDMXlmSitXV3lBb2tySnM2?=
 =?utf-8?B?amxOWFUxWXNaei81NzB3VU83bGNyM0pFdGlGMWNjMHZaNjJuWWlTMnBEVWN2?=
 =?utf-8?B?QnpXMjIxMzlMMFhmRXlwalZYV1Rqam1IK0JzaUJBWHhkV01JdlltaVhmWmh6?=
 =?utf-8?B?aHB6QlJ0U21MR0FUUmF1cXpwb00xVkdtODdPVmYyc2wzS2NXMTYvUVBJUU00?=
 =?utf-8?B?VlV6Y3BHTkwxc0g3dmRTQ2VDMzZVenc3WXZDVFNOM1F4bUl6NlRoc0JkWjgw?=
 =?utf-8?B?R2xEZWh1blZUY2E1WEpiWkZWOHZIbDlCMlRJVnY4Mm96aWxiRnZFSFc0Q2Jt?=
 =?utf-8?B?bTN1R3pCYkNudmlHT3UzbWtzRlBZTTFlWHVoMlA5ZzBvclJ2STBFMmI1RlZ0?=
 =?utf-8?B?T1JJaHNWVlYxcXRkRDVzYUkrM0xwUVkwWU92TjBvK1FyUWVJVXpIaDlNWVBL?=
 =?utf-8?B?MWp1Y2xMY1R3WEkrZDhNZ3Ercjg5U3MrR3Z2cXEraEkzTlVLNUZ1cWNXVGVy?=
 =?utf-8?B?WmYzWkxCWTZFQ1FPZTBZZG9CMDV0NDErZllGcTNrSmQzTFRzWlphRVJaSDBq?=
 =?utf-8?B?L2hvVjg3dkpvOW01djF6NlFqditrZlhJamF1dCtKTUZjYXVQbDJ3OHZqNlVT?=
 =?utf-8?B?R1FLZTFqckZyRk5HdnNqQk92eVU2Vnd3bVg5MjJUU2UxZjZ4ZXJzeWVkMjY5?=
 =?utf-8?B?VGJOOHJxNjlOQmdnby9rN0luOEdHSlpSWXByZ21JeUlzRzUwTlA3ajV1bmhn?=
 =?utf-8?B?SjJGenIwbnJiQUtMVm9Bd3poWnRxa3pYUjlpbWlkSlA4UVVJaGYvVWxhQmdy?=
 =?utf-8?B?U29FYTFIWDhaTkZ4RkkvYUg2WGozY1g5dVhLNUtoYVUzaC9LQUlCM3JUY2Nq?=
 =?utf-8?B?aFEwdFlTODFOMzR1Um5vNHdob3EydWY1YlRqYmF2VEp6QmJGc09Qcy9VZ1V3?=
 =?utf-8?B?N1haWnF0Q1IvWXNUR3VkU1dPY1BZUzlEOHhvTkVFNzFiREVrN3JUUThUcmxn?=
 =?utf-8?B?NzY2c1Awdmt0TUp4Y3lQaDJuOHhwSFhHdUJkdFVjaU5iL29ONDJyTW9hY3BC?=
 =?utf-8?B?NVdDTHl6bnlINTQ3NktTc2gyS3ZjMlR6V2FGQUNJZjYzZlIwTHVEWWJ0WHNC?=
 =?utf-8?B?NytRZ0VMZlpQMm1DdGdoTzI5STdnZ0srMWZkZHZtZTltbTBwYjk0UE1HNXBa?=
 =?utf-8?B?QlF6dFRqVFNxV3dsUnEwcnVMemVsVEV5UktmMk95ekJjVm5mUWxoT2lRbFJF?=
 =?utf-8?B?Ky95RUsvcUhSRURhRHRzVnBOWVR4VnEycXc4VzJMVXkrZWJPVjVyTzlhQVBk?=
 =?utf-8?B?WXBRUjZyV3YxWVhlZy9Za25XaUp5NHdXdFVXeXFlQUZKd1FsV0VVUT09?=
X-Exchange-RoutingPolicyChecked: Y4QIRHv+nNhjiHqkMrnXEnCDlu5xIH9uXOD5tSTCMxYeKq6pxI8Syge8BB1M7BqJKMBmzDCjRRmP7MQs1MoANV/wjCjktIvlWNZ5yycrs7v1xXz41ouUEPlIjHhyN/VKuJ5p3v5i/z4uOjh7SlBr5MWud3WaeoVZi48Y+yPY9tPcon6WYgvhOWymlDwYG04w7v02zzwju+hiPKkw4Kug/kCdz1CwAmXQIpKjNBTZ5SSj5KFK9f7bTrAkmpCeTt5cLj39TBxO1AVQMCD0JIgDjzXEXmivyDi23uKUrRVRXezD2bvU8do4xo94X0CA5IuJjGRxBft6u5bHO74aJwtpQg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ddc4e5-19d3-4fed-fecd-08df370876d6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:00.4189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /y9X+knWT+AqBf3tW55h1j7teJh7LK/Vfowkz7ZiH5M80DAK9pkJ99zOUK60OCLeWxOjtB+Icix7c3dXPseazw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX7G0e55pqEVQz
 OoufR9z2AuvQvHat6oY6//MJ0a6WB1AY02Ncsl7zlnfVTRj8Z4tChcUXrunXGbQig4lCXSMZ1Bt
 JGONhtb9Z0aSsW+FuroT+cE6GZNtjLY=
X-Proofpoint-ORIG-GUID: VQ_8hQusTIm9g0LK50EYGjTKdjKgFNoN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX83Ld6YGHA2+b
 mNw6V4OAMgjqsfN3rQxcR0dT+8jXW+VubgzXzdWtzVcaTcfrNDxKarDDWFxdRoTOue+B/tU10ar
 iQq3WzU2GKehHd4mX2OSru2WqUT5uMvpJ0jq3ZhH0KmOFfNnvpNbLePMOVxHormEvoON6jQ7l3s
 j31iQRknBB5UdRpDDTJSvC1v+IqaPlU91mxZOzRn89Rg6kU20pzV0A9RKtpEKoJgVGBrbqaARTP
 joe4GP3mFof1gKD6KQOKzYR3/QDPsm/VyHzFeOlLDh+XBewgD7Bnx7K0pbzT5XjLZy6SPwJ0+2k
 7+NuEvngzQdv3V6aAGsl3NHFSdgBkbh5PUTp1y4uZoNFy4/F57+0CplCYdk/43SpdOz4DszSgZV
 1S3l9UWNqpkePrYUpEJMuIRM9hNTW3YeQA/ZEpXarQbwC/lBq9raTVZTw+BuRJQLTsBHMK319GE
 1ob5yYM0sBsdsHNycuA==
X-Proofpoint-GUID: VQ_8hQusTIm9g0LK50EYGjTKdjKgFNoN
X-Authority-Analysis: v=2.4 cv=ZPJCCn7b c=1 sm=1 tr=0 ts=6ae57034 cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=RtSn8ETxjE2H05FtM2s8:22 a=MvuuwTCpAAAA:8 a=4gJl8e_CxB3hIM5OUqsA:9
 a=QEXdDO2ut3YA:10
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310017

Add the identifiers the CXI RDMA driver needs from the core: the
RDMA_NODE_SLINGSHOT node type and RDMA_TRANSPORT_SLINGSHOT transport,
the RDMA_CORE_CAP_PROT_SLINGSHOT port capability with the matching
rdma_protocol_slingshot() helper, and the IB_GID_TYPE_SLINGSHOT_UFH
GID type.  Names are added to the sysfs, GID cache and node/transport
lookup tables so the new values are reported like any other.

A Slingshot GID carries only the 20-bit NID of the port, so the port
exposes a single GID type and does not take part in the RoCE style
netdev GID population.  RDMA_CORE_PORT_SLINGSHOT combines the new
capability with RDMA_CORE_CAP_ETH_AH.

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/core/cache.c         |  3 +++
 drivers/infiniband/core/nldev.c         |  3 +++
 drivers/infiniband/core/roce_gid_mgmt.c |  3 +++
 drivers/infiniband/core/sysfs.c         |  2 ++
 drivers/infiniband/core/verbs.c         |  2 ++
 include/rdma/ib_verbs.h                 | 14 ++++++++++++++
 include/uapi/rdma/ib_user_ioctl_verbs.h |  2 ++
 include/uapi/rdma/rdma_netlink.h        |  1 +
 8 files changed, 30 insertions(+)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index d5e17a36f186..b407e5e25dbc 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -141,6 +141,7 @@ static const char * const gid_type_str[] = {
 	[IB_GID_TYPE_ROCE_UDP_ENCAP]	= "RoCE v2",
 	[IB_GID_TYPE_UET_UDP]		= "UET UDP",
 	[IB_GID_TYPE_UET_IP]		= "UET IP",
+	[IB_GID_TYPE_SLINGSHOT_UFH] = "SLINGSHOT UFH",
 };
 
 const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
@@ -1404,6 +1405,8 @@ static int config_non_roce_gid_cache(struct ib_device *device,
 
 	gid_attr.device = device;
 	gid_attr.port_num = port;
+	if (rdma_protocol_slingshot(device, port))
+		gid_attr.gid_type = IB_GID_TYPE_SLINGSHOT_UFH;
 	table = rdma_gid_table(device, port);
 
 	mutex_lock(&table->lock);
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5313eb4849c7..97ee2f5118d6 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -350,6 +350,9 @@ static int fill_dev_info(struct sk_buff *msg, struct ib_device *device)
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL, "iw");
 	else if (rdma_protocol_roce(device, port))
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL, "roce");
+	else if (rdma_protocol_slingshot(device, port))
+		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL,
+				     "slingshot");
 	else if (rdma_protocol_uet(device, port))
 		ret = nla_put_string(msg, RDMA_NLDEV_ATTR_DEV_PROTOCOL, "uet");
 	else if (rdma_protocol_usnic(device, port))
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 214af921341a..bcdbb9e45107 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -77,6 +77,7 @@ static const struct {
 	{rdma_protocol_roce_udp_encap, IB_GID_TYPE_ROCE_UDP_ENCAP},
 	{rdma_protocol_uet_udp, IB_GID_TYPE_UET_UDP},
 	{rdma_protocol_uet_ip, IB_GID_TYPE_UET_IP},
+	{rdma_protocol_slingshot, IB_GID_TYPE_SLINGSHOT_UFH},
 };
 
 #define CAP_TO_GID_TABLE_SIZE	ARRAY_SIZE(PORT_CAP_TO_GID_TYPE)
@@ -86,6 +87,8 @@ unsigned long roce_gid_type_mask_support(struct ib_device *ib_dev, u32 port)
 	int i;
 	unsigned int ret_flags = 0;
 
+	if (rdma_protocol_slingshot(ib_dev, port))
+		return 1UL << IB_GID_TYPE_SLINGSHOT_UFH;
 	if (!rdma_port_gids_from_netdev(ib_dev, port))
 		return 1UL << IB_GID_TYPE_IB;
 
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 4cd861b5d953..5121a622f822 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1262,6 +1262,8 @@ static const char *node_type_string(int node_type)
 		return "usNIC UDP";
 	case RDMA_NODE_UNSPECIFIED:
 		return "unspecified";
+	case RDMA_NODE_SLINGSHOT:
+		return "Slingshot";
 	}
 	return "<unknown>";
 }
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index adcda33b04f2..77d1d71d7167 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -282,6 +282,8 @@ rdma_node_get_transport(unsigned int node_type)
 		return RDMA_TRANSPORT_IWARP;
 	if (node_type == RDMA_NODE_UNSPECIFIED)
 		return RDMA_TRANSPORT_UNSPECIFIED;
+	if (node_type == RDMA_NODE_SLINGSHOT)
+		return RDMA_TRANSPORT_SLINGSHOT;
 
 	return RDMA_TRANSPORT_IB;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5aa1fa576a44..c26d7e562914 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -147,6 +147,7 @@ enum ib_gid_type {
 	IB_GID_TYPE_ROCE_UDP_ENCAP = IB_UVERBS_GID_TYPE_ROCE_V2,
 	IB_GID_TYPE_UET_UDP = IB_UVERBS_GID_TYPE_UET_UDP,
 	IB_GID_TYPE_UET_IP = IB_UVERBS_GID_TYPE_UET_IP,
+	IB_GID_TYPE_SLINGSHOT_UFH = IB_UVERBS_GID_TYPE_SLINGSHOT_UFH,
 	IB_GID_TYPE_SIZE
 };
 
@@ -171,6 +172,7 @@ enum rdma_transport_type {
 	RDMA_TRANSPORT_USNIC,
 	RDMA_TRANSPORT_USNIC_UDP,
 	RDMA_TRANSPORT_UNSPECIFIED,
+	RDMA_TRANSPORT_SLINGSHOT,
 };
 
 enum rdma_protocol_type {
@@ -682,6 +684,7 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 #define RDMA_CORE_CAP_PROT_USNIC        0x02000000
 #define RDMA_CORE_CAP_PROT_UET_UDP      0x04000000
 #define RDMA_CORE_CAP_PROT_UET_IP       0x08000000
+#define RDMA_CORE_CAP_PROT_SLINGSHOT    0x20000000
 
 #define RDMA_CORE_CAP_PROT_UET         (RDMA_CORE_CAP_PROT_UET_UDP \
 					| RDMA_CORE_CAP_PROT_UET_IP)
@@ -722,6 +725,8 @@ void rdma_free_hw_stats_struct(struct rdma_hw_stats *stats);
 
 #define RDMA_CORE_PORT_USNIC		(RDMA_CORE_CAP_PROT_USNIC)
 
+#define RDMA_CORE_PORT_SLINGSHOT        (RDMA_CORE_CAP_PROT_SLINGSHOT | RDMA_CORE_CAP_ETH_AH)
+
 struct ib_port_attr {
 	u64			subnet_prefix;
 	enum ib_port_state	state;
@@ -3596,6 +3601,13 @@ static inline bool rdma_protocol_uet_ip(const struct ib_device *device,
 	       RDMA_CORE_CAP_PROT_UET_IP;
 }
 
+static inline bool rdma_protocol_slingshot(const struct ib_device *device,
+					   u32 port_num)
+{
+	return device->port_data[port_num].immutable.core_cap_flags &
+		RDMA_CORE_CAP_PROT_SLINGSHOT;
+}
+
 static inline bool rdma_port_gids_from_netdev(const struct ib_device *device,
 					      u32 port_num)
 {
@@ -5219,6 +5231,8 @@ void rdma_move_ah_attr(struct rdma_ah_attr *dest, struct rdma_ah_attr *src);
 static inline enum rdma_ah_attr_type rdma_ah_find_type(struct ib_device *dev,
 						       u32 port_num)
 {
+	if (rdma_protocol_slingshot(dev, port_num))
+		return RDMA_AH_ATTR_TYPE_IB;
 	if (rdma_protocol_roce(dev, port_num) ||
 	    rdma_protocol_uet(dev, port_num))
 		return RDMA_AH_ATTR_TYPE_ROCE;
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 75cdfdbdb2f7..e8e84aa034ef 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -258,6 +258,7 @@ enum rdma_driver_id {
 	RDMA_DRIVER_ERDMA,
 	RDMA_DRIVER_MANA,
 	RDMA_DRIVER_IONIC,
+	RDMA_DRIVER_CXI,
 };
 
 enum ib_uverbs_gid_type {
@@ -266,6 +267,7 @@ enum ib_uverbs_gid_type {
 	IB_UVERBS_GID_TYPE_ROCE_V2,
 	IB_UVERBS_GID_TYPE_UET_UDP,
 	IB_UVERBS_GID_TYPE_UET_IP,
+	IB_UVERBS_GID_TYPE_SLINGSHOT_UFH,
 };
 
 struct ib_uverbs_gid_entry {
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index ee11c3bbbae2..69ff1dee2db6 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -158,6 +158,7 @@ enum {
 	RDMA_NODE_USNIC,
 	RDMA_NODE_USNIC_UDP,
 	RDMA_NODE_UNSPECIFIED,
+	RDMA_NODE_SLINGSHOT,
 };
 
 /*

-- 
2.56.0

