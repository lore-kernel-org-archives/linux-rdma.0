Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474805;
	b=v5MuyRJQeMBmaMbOe/9Ef/ksGQGhzyxvTjZuxrvCX6l10wCk1IBP7/5ipJDCXdpJuueB
	 gQ7vNeLa5JzeMNb9Z02fBYqzJ0er8HQBazO9FJvsholTU0OJsrZHdozEPL6LlEj9mEtCo
	 6txv+l9Dw5qN+UhhpQSgQu9U1/yRs2aPp9Cxxodk79XpE/7ZoVrpEpfthneQRHqoX29+n
	 h0KJ7kBiHVq553yvuEv8XnQg44soIymjoUxKu7Ztt8VEt48mmmMzZZJQfV7SCRbOZhRa5
	 L409r3qmnbaRnGRIpGUjxoYeP/7UWlJqLT6AYpZ3MncVYtJaEGPhEe/o9lmoyQrMc5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474805;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Received:From:Subject:Date:
	 Message-Id:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:CC:X-Mailer:X-ClientProxiedBy:MIME-Version:
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=ONv1758GSGWbk5+1zC/xrJsaPk32LjDe0Q3LXjmsgVg=;
	b=bknGYQ9ozQBb2cK6VO2O3FBQiRej0E0CXzlN4ObsQ1qNWhVtMn1dNLxEnGcITyyO2ZCK
	 eYbLaU3eGzDkrfNl0KXowS+En7N/1/nysRmT9B87aNDM8haqSoGGbqacocPvUIvpPY/ug
	 01mTRyz5JALLYIz3XsOcNt1ZGOIg2ad5yY9Lz+j37X8OH+OpCK09jfX/Mnruio+YvBFbD
	 L94FJAHtRfjqi8WXAxfqO98eQ7In3YuXmVn+14j2iT3oSUVvpKd4U0m4bbbp80FX9r8Y7
	 s8Ql8Bz/ghbNcw2AU4rD8fQV3z0QMmQesGL6fRmF0lIqqyLN1ssXQuj1udfCJKgB+yw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=dMvDYZT8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C36C606A322;
	Sat, 31 Oct 2026 19:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C36C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=dMvDYZT8
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJE2R5744000;
	Sat, 31 Oct 2026 19:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps0720; bh=ONv1758GSGWbk5+1zC/xrJsa
	Pk32LjDe0Q3LXjmsgVg=; b=dMvDYZT8cixSFzAPQDZmTiVIq9xwcH4Acg5a8ehv
	bokWChE/TOoWTCgM07QMeZ4yM3qdkzS06Cl0+VyeKmoPBbgXJmRTp7oGCzTR8Uj4
	uCqi0j52ACdX8xvwgD3A2E+Ni5iFPzkKC8nkRpyf6gzQ1bn2TkfWJzD0FUmgGYj3
	Md2yq2R1lmIYv+iubdOymZVxmvck03G/5ZhSqFttZL2oceCD5LFeAqAcNeQyykr2
	7YG6idztFZYL+aw3GxGwzB3/lNe2Y/o4w2phy2aX9eDUPZ33Tn52G94VnqczB9D6
	/OFc3yLJG9OBKNyRm2hlWNZhGbeQgGwt4AyT2drZyPePfg==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hnn2cgmrf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:26:41 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id AFF0A800EE7;
	Sat, 31 Oct 2026 19:26:41 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:35 -1200
Received: from p1wg14926.americas.hpqcorp.net (10.119.18.115) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:35 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:35 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 19:26:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLmvTsHnOopKleZj8vTdmI//Dm64w2xhPBBjrwSF2FZTOE0+1/DlYR4tPgQkJvW29OwzSJ14gpeOScM7UpfR7X0LFgHSqRBmzoC/wMGbl2ngjdlGrK/frmn1noisuF+uQO5lofRqkx3egnuBB56gdpVgXkFvNqWPxOqi/5A0MB0GaAHdGxX98G0Kd8PqaC2rMZGJ5x20TDaY1RvztxPQqFeecXq+Wle3YevcksoMWrcm3b0J37iwYKOOIHg1WX7rGfP0XKDsjHP01hwogkPGYM54/vr2cPoesERRBot3R45s8ntab/GSHYG74as9rerWrzZkb2I7gU/r0YLQW30dzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONv1758GSGWbk5+1zC/xrJsaPk32LjDe0Q3LXjmsgVg=;
 b=p5Pur3GwRn7OtpAkfHpR3sbGxLGx/+wTEvLDTbnFs3rCJRZ9dTh25HcmdQNmWNHf80NvKasb2gDItpQ//fuvxw5muO+1tqTS4n5c08YHnFkiyWazzdfng+IWvrP7dMHD/O46BmKq6cQgmNzzHYv+NbvIcZ+R/7lPOn8BRTo580UJ/UMTqFI+q7hUv/EwrQDLfXE9msl/JsUZRJ9dRrEFxxaun4t0FeFNWRjoB/3OgOq5xi3sqPVA9+593p0pY7oNp4gK5cRJTYLyzgSeMrpTaXrxXOx3UfqTNDRad4gcTxqqEgTEvMZ5iCSxjLRZm0bbGPh4dI8yaBcs0pgYDE8j7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:33 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:33 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Subject: [PATCH 00/12] cxiverbs: add the HPE Cassini verbs provider
Date: Sat, 31 Oct 2026 12:25:53 -0700
Message-Id: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/yXMTQ5AMBBA4avIrE1i6i9cRSyowViUtEgTcXfF8
 lu8d4FjK+ygji6wfIqT1QRQHIGeOzMxyhAMKlEFJSmh9oLjatGw37HMVE6ZTqkoKwjJZnkU/+2
 a9rc7+oX1/j7gvh/SpWricAAAAA==
X-Change-ID: 20261031-cxi-for-next-742514c31679
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>,
        Mamila Santosh
	<santosh-kumar.mamila@hpe.com>,
        Terrence Mitchem <terrence.mitchem@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0166.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::21) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: fe352a2e-4604-46aa-27d0-08df3784df36
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|5023799004|56012099006|261009223027099003|261028144727099003|261021121427099003|261021123027099003|261026121527099003|261021135927099003|261022075727099003|261022105027099003|261026140227099003|10067099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: kI1EtBuj557jfFZcrSWQH54m79TdZnHdo+MT5rlsgmnkt2S7xy6+Elr4qCjf0nO5hSOOSrptOuBcLrtMu57PHWorF9OYOqxk70aPlREBSrgefhAsHsOufWBa0CU7DZGpxl4NUc+CKTgKNB0r+39zs9dF1OhQEV9PXwuXJSglfPaCGuVMmLJCkAIA/Hd/5XHpKF1twhb7v5Tt56nXI/nFzgiYUJpgyseUvkbBUIL8jxO6GuhPhujXD4rYFKhx0d5DTQqPG6AQB9R4DCeH+0InV3wUsraJnjtGakaqoEDh+3WambbBENlAZ20eI/r64t/JZo7+7OB2me/yv54VyTd7VMbGgGlZI6SAGeiElkW2KwNvsOGMxVgxgW5yLBctInGbA1LdbmhYxl1H8ysX2W86PTks6eoSGC7nl+CDko7sWS6+pq6xJ7lmgeM1g3cWUnlpFw44Bc2ozcMhN0AdhAr9oMn4HoE5nvMCpUf+yQK94ZWrJjSuhKhfjRaenrllZb5Ai0m8C5oR0LL96CRm7kSD+cyruQtrUSJCebhWHek1HV/YVEYtdeg73I+OolRqZJQyMBZKvtZ6IuRvxzrGCl2v+0ZVzMvm1I5hRBck+yvL9yk9I6QF8jTYTkWHeiFALPM/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(5023799004)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261026121527099003)(261021135927099003)(261022075727099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFFXY3dBYkw3NHlUc2k5UVZmWnB3RzBKZkp2RGZaTkFBR1poWjZRQmZBdTNy?=
 =?utf-8?B?MjVORXdWSE1ZQ0pqOUloVVlLMjJISi9YWVFzT0dSL0lIOUF6bDUvd09rajFO?=
 =?utf-8?B?T3NQWTZwdXdLSUdxVERINE9lR0VyWkwvd0U2c2xNaWh0Y2MrNG5FWTZJS0Ft?=
 =?utf-8?B?b2xoTE9VYWxzZ2VUb09PeVdkN2Exb3NiQnR3ZFpzTmVCVk9VQTRPVDlSSHkr?=
 =?utf-8?B?Nm5PVDNmbEFPVnJ4ejQ2aHFXa2NDTUdmVHVzMklicCt3WnhnWk5pVDV6b0o2?=
 =?utf-8?B?NFZtN3FWVFI3ZFUrSExJTVFaVWtaSWtCaHY4azBudG5sZDRkaklEMUdTcWQ0?=
 =?utf-8?B?V0hnRG1OT0Evc0xKYzRsNTJxakNFNjlFMVdJYTE2Rm01QW4xTFRYT285NXNW?=
 =?utf-8?B?aitNYTUwT1EzeWw2aEtwb1BheUx3bWJNMDFxNGQ2NGN0ZVc4U09xNzdDeTEr?=
 =?utf-8?B?NlZ6bzl1cVZpTEtJZUk5T0lQc2F1b2ljcTJ4R1FWYVJCUXRLeTlIOWJZb1d2?=
 =?utf-8?B?cmVqejFXanU2UnNKTXREeC9yZVV1V3hZaXMwQ1EyemZZcDV6Vzg1ZEVRRFJo?=
 =?utf-8?B?TkJKNGU0cUVBcE1aUEV5SEZVaEVWMGxJQ2twYkFKZm13eEVlT2E0NTY5RFZ0?=
 =?utf-8?B?NDR5UG5tdFVuT0FDZ29jSmhKME1ERDhXcE9aWmtqbjA5bXhHbCt6TW5sR2Qw?=
 =?utf-8?B?YXRtWDdZZkk5YUhoVzM2eC8xeGlkUGFIOW5MVEVHTjUzSEY2enZTVS9FdEUr?=
 =?utf-8?B?cGZ5TFhYSDdUSk9WZEVnMXcxK09lZFEvLzk2VmFqTVNWTnozM3VFdS8zaUZZ?=
 =?utf-8?B?RHNERG0xQVRSVVlxZ0RVWEtNazNyYWF5RitHQnpabWQreWRKaXNsaS9IeWpp?=
 =?utf-8?B?ZTJoS3Izbjh6ajZ3bHllSnpDVkVqOHozN2R0bTNmcFNndk5mNGgzRUNKOTI1?=
 =?utf-8?B?WWxicXVFMHZ2SStiTU5Uc2pHVDBCdjdGOGlVOVlnTE1DTTl2MlJpb3p3Tk44?=
 =?utf-8?B?dmFjbW1rTFpMVnExV2RRVWNMMkgyOEIxU01XZk13Ui9ROGZueExJekZ2cmx1?=
 =?utf-8?B?N1U2a3B5Qm5RMEZJbkExZTJJSkJ4TnVheHkyKzVqOHJ2WnNqeWs2YkwrUlpX?=
 =?utf-8?B?RnFrNVFXL1dIR3l6Vk11YVhBWjlsbHAxS1IxdzVmdXlud25MMnFLaldIYVVt?=
 =?utf-8?B?cFZxUTRpc2RGVUltY09Eei9MSWs0bmx0WklQSFpBUGZvdUk0WXU4c01LMk04?=
 =?utf-8?B?a0pEbStNMURMRVE0YVJ1ZW5laDVuMVhpdnQxY1VoYUx5eVUxOFhTVzBHM1pL?=
 =?utf-8?B?Ri9GZ1Q1RzN2cG5ML2tXTHhCaHR0REVpUVp4TCtOUTQrVFFwbnVsd3hzTjFH?=
 =?utf-8?B?RjZpMzdUclBCTWoreDU0OGFCMnN6RFI3TWdsZlVwV3RCNytJMTJsZFFpYUMx?=
 =?utf-8?B?L0w0WE9TcU9HWlE5ZTMzWXhadk9hUXR2WWhUV2ZBL2tVWklDMEdPNmdUK1VP?=
 =?utf-8?B?SjUwN3pLbkZsQ0sxNW4zVmFFVngyKzRnSGNyczhZWHRTYys1bExzb3VLeXRZ?=
 =?utf-8?B?M1orNVhiQmg2d3ZmYkVmS21tWUpwQXA0NDM0YkZRUWF3d2hqQVZZand2bWNu?=
 =?utf-8?B?OUdod0NUUmY2YktxUHpsMmlYaHM5V05RMW5qVzZ4NUh2S1UyaVBXeWFUM3RL?=
 =?utf-8?B?QVhHSDc1emlJS3M5cklTaVU2QXYvMWFyRFh6UW5WUU9Ja2Q1MjZQdkoxcllO?=
 =?utf-8?B?TlhHN1pIbVhIWDVMR3pycXozVFlZQkVQcXp6WUJYRU4xV014VkxOTnE1Ylpl?=
 =?utf-8?B?RElNLzdjZ01KQndKUE5lMHFZWmtGZEtTRElvR2hPNXJ2bnRBM3BraGtWWGRR?=
 =?utf-8?B?UThIMDVLNytTeVZIM2hGd2VHcVhNSlZWbXZBT004YUJ1cC94Y2JpczNodmhO?=
 =?utf-8?B?c1QxNmdiZ1phZ3NtYVFpZmF5RFFxUWYvaitMVWpxa1dPYmZYb09LTWUvamNE?=
 =?utf-8?B?aldrRjNYWmVyODRnekxGcXVTbTZNWk9qZHlWTHlOaHF3TG9pME5kSXJ3c1J0?=
 =?utf-8?B?NzMydG1SbkYzYXdUWW5oN0w5R2s0RktQKzB6NW5ZSkZQMW9XeGhVN2tabFNn?=
 =?utf-8?B?Ky9OQ3VtM3VxdUl6a0cyZDZ1aXkwOWIxNnNVSDJsVXg4djBQckVNaWdBT2RY?=
 =?utf-8?B?NklJZVhkWDM3aHhtTXQyVXM0Uys1T3ZxWHBKZ2wwSEFSWTBtcHBuWFhQLzdP?=
 =?utf-8?B?dTFuMEN5K0NhK3FKWStiandNOFR3WGRuMnFKNFZMZXR0U3FvclBRdlhqWitU?=
 =?utf-8?B?Q3l6NWdWem41V25wSHhWdTNoL3NuMTZXZ3VQN1V3MnY3a2VnYU9BQT09?=
X-Exchange-RoutingPolicyChecked: N7RbmIqXEw7Ki3YPQY6nW/wtxpKVjutihCM+VdW9AAWkRrcEVvLehIjXhr4LTfYzvfWDxnZrx27H7quQPZY1sUHss+ZVr9GojFYIPzfth6m7GgZgrODnVzLmKnlFwFHF+FrpiE09msb81jpwEP60jHcNjYdUiuAJQj9/sylWUyETMGHtOB2aXDHGUtcx83j35HqwZCoO6/Vos6uXd5+bwRPmHW5WArsXLOUP+IJNxTTrs2yYjdRPqYbhPpCWVOu41klWHxYhSXjLxUmLe8WaLqmZ94bOZIXs7Safi4+hk7kAa8GdH/N23+Ixk+JEROabHl5fKJVYDOsV0k6F8D/cBg==
X-MS-Exchange-CrossTenant-Network-Message-Id: fe352a2e-4604-46aa-27d0-08df3784df36
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:33.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwL3Y9A263rVlP87w6t6ofu57BdrZru2jycLIyhqXdd/Xgso4dtU8NvRyS5h+wxGrMViMwfJcy+SS/yx3thLIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Authority-Analysis: v=2.4 cv=JpJkP84C c=1 sm=1 tr=0 ts=6ae640f2 cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=ay80y3fxfMS_JZZz1qJy:22 a=VwQbUJbxAAAA:8 a=MvuuwTCpAAAA:8 a=Q-fNiiVtAAAA:8
 a=NEAV23lmAAAA:8 a=RiIid9coAAAA:8 a=oVHknnqCN3cS4MQuQeQA:9 a=QEXdDO2ut3YA:10
 a=XKWKsq0CuoyFKVVHhDP9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfXyXgBIxgWrbCx
 YNTcN+YD8kU5eOJ2kn/Gl7GAoFq2aPrqe2b705GhNUxwCUPvK/OlVK4zRFSIwn6YoOwSXwLb9iI
 uobu4W5XVqmBg9HQamOkQEExmWZoGyw=
X-Proofpoint-GUID: YTFw_Qpe3hCcHZ8-L8-30Xmvmk5VyWtW
X-Proofpoint-ORIG-GUID: YTFw_Qpe3hCcHZ8-L8-30Xmvmk5VyWtW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX1lsT2lH0UxWj
 CAcsXBE/IqTdLgWkSRr+A9paN3uc034Gey2mgNbv5QdW/OkLKZfOt4Ew1UDKi8AOtF5vBgvJxR2
 saaBXnv12srkoijnkOBk1m/BYDNYArSt3ral1SPVM8RiaAJPI2tIkTdDdgoSqaB1RYHr+Mcmyro
 NpAzsBDba459S+7XUviHiQixlLc+LYjQzz1WDG6Vvs4T6WTxCS/hk5kWa2w9smt5wsQtPMX0Jcn
 iai32Fc2qxO9+erFyW+WVRrs9/OozD6nY6gDtWqxcUy7mflaJrvfVurl7Bktgqc+TYgl64gwFT2
 yPZQPCbgQ/aEA6HPy1hib6UXmuWhQoLsOs+JzqK8ZND6BrKE3AuI7XEOLaKSu4jUTLYmwJUFRJP
 hqWCF+otFn+8HKum7RpLOeJ0gSapQt8CAFXdayWN3etJyovLZyFnbGBxDENQ33QKWKtwcwJ+iF+
 X5hQ31hg0O5Dpr8oraA==
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 clxscore=1015 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310077

This pull request adds cxiverbs, the user space provider for the HPE
Slingshot Cassini NIC, matching the cxiverbs kernel driver. It uses the
UET reliable unconnected (RU) queue pair type from the UET rdma-core
series.

Patches 1-3 extend libibverbs:

 - ibv_read_counters_ex(): read selected counters, with per-item
   timestamps, using the kernel counters extension
 - permit UET jobs without an address table, matching the kernel
   change. This relaxes a rule in the UET series and needs agreement
   from its authors; the commit message gives the hardware reasons.
 - provider-owned completion channels and the Slingshot transport

The new provider ops join the private ABI that the UET series already
raised to 66; since 66.0 is unreleased, IBVERBS_PABI_VERSION is not
bumped again.

Patches 4-11 add the provider:

 - the shared native hardware and verbs ABI headers
 - the cxidv direct-verbs interface for native resources (services,
   LNIs, communication profiles, event and command queues, counting
   triggers, CSR access), with explicit ownership
 - list entry encoding and VNI-isolated remote keys
 - the provider, device discovery and the UET verbs
 - model and hardware tests for identity isolation, polling and event
   traffic
 - cxi_launcher, which a workload manager such as Slurm can use to
   grant a job exact VNIs, a traffic class and resource limits before
   it starts the application without privileges
 - build and packaging (Debian, SUSE and Red Hat), with the provider
   library packaged like efa, mana and mlx5 and built only where
   coherent DMA is available, and the pyverbs cxidv bindings used by
   the RU tests. cxi_launcher ships with the provider library, since
   client programs cannot run on CXI hardware without it.

Patch 12 ports the ibv_ru_pingpong and ibv_ru_rma examples to the
explicitly granted resources. On a Slingshot device they run
themselves again under cxi_launcher, so when the CXI provider is built
they use the cxidv API and link against libcxiverbs; that is why they
come after the provider.

Dependencies
------------

This pull request depends on:

 - the Cassini NIC driver series for net-next,
   net: hpe: add HPE Slingshot NIC drivers
   https://lore.kernel.org/netdev/20261030-cxi-netdev-submission-v1-0-8c2c391cc283@hpe.com/
 - the UET RDMA kernel series
   RDMA/core: Ultra Ethernet transport verbs
   https://lore.kernel.org/linux-rdma/20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com/
 - the cxiverbs kernel series,
   RDMA/cxi: add the HPE Cassini verbs driver
   https://lore.kernel.org/linux-rdma/20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com/
 - the UET rdma-core series
   libibverbs: Ultra Ethernet reliable unconnected verbs
   https://github.com/linux-rdma/rdma-core/pull/1829

kernel-headers/ carries the UAPI headers from those kernel series.

Known open issues
-----------------

No known functional issues are open in the provider. Where the
kernel's SR-IOV support is involved, the kernel series notes that V2
will include an updated SR-IOV implementation.

One question needs a UET ABI decision: the RU examples and the generic
pyverbs.ru module are still built on platforms without coherent DMA,
where the CXI provider is not. If UET, and so the RU queue pair type,
is not expected to support those platforms, they should instead be
built only where coherent DMA is available (see patch 12).

checkpatch
----------

With rdma-core's CI checkpatch settings (buildlib/azp-checkpatch),
three patches still report warnings; each patch explains its own:

 - patch 4: PREFER_DEFINED_ATTRIBUTE_MACRO (27) and VOLATILE (2). The
   shared headers use __attribute__((packed)) because the kernel-only
   __packed is not available to user space, and the command queue
   status and event fields stay volatile because the device writes
   them.
 - patch 10: VOLATILE (2) for the launcher's volatile sig_atomic_t
   signal state.
 - patch 11: one REPEATED_WORD false positive in
   pyverbs/providers/cxi/cxidv.pyx ("Context context" is a Cython typed
   parameter).

These exceptions are documented in providers/cxi/utils/README.md. If
reviewers prefer a different form, it needs coordination with the
internal HPE repositories these headers are synchronized from, and will
be changed in V2.

Review and testing
------------------

Before posting, the provider was reviewed with the Sashiko AI code
review tool and checkpatch.

Tool use: GitHub Copilot, an AI coding assistant, was used under our
direction to write many of the review fixes, to fold them into these
patches, to write commit messages and to run the build and hardware
tests. Every change was reviewed by the submitter, who takes
responsibility for it as for any other patch.

 - every patch builds incrementally (with pyverbs enabled) without
   compiler warnings, and the series also builds without warnings with
   coherent DMA disabled, where the CXI provider is left out
 - with exactly this provider and the two kernel series, booted on two
   Cassini 2 x86_64 nodes, the full stack passed a full test matrix on
   both nodes: the rdma-core Python suite (434 tests; tests that need
   features this device lacks are skipped), the provider's model
   tests, launcher file descriptor tests, resource and VNI isolation
   tests in default and indexed addressing modes, including wrong-VNI
   rejection, privileged and unprivileged CSR access tests, and 36
   two-node RU ping-pong and RMA traffic cases (polling and event
   modes) in each direction, 72 in total.

Co-developed by Iraimani P and Mamila Santosh, as shown by the trailers
on each patch.

Doug Ledford (12):
  libibverbs: add ibv_read_counters_ex()
  libibverbs: permit jobs without an address table
  libibverbs: support provider completion channels and Slingshot transport
  cxiverbs: add the synchronized native hardware and verbs headers
  cxiverbs: define the native direct-verbs resource interface
  cxiverbs: encode list entries and VNI-isolated remote keys
  cxiverbs: add the provider and device discovery
  cxiverbs: implement UET verbs with explicit native ownership
  cxiverbs: cover identity isolation and polling and event traffic
  cxiverbs: launch Slurm-style exact VNI TC and resource grants
  cxiverbs: wire and package the CXI verbs provider and tests
  libibverbs: port RU examples to explicitly granted resources

 71 files changed, 32565 insertions(+), 182 deletions(-)

Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
Doug Ledford (12):
      libibverbs: add ibv_read_counters_ex()
      libibverbs: permit jobs without an address table
      libibverbs: support provider completion channels and Slingshot transport
      cxiverbs: add the synchronized native hardware and verbs headers
      cxiverbs: define the native direct-verbs resource interface
      cxiverbs: encode list entries and VNI-isolated remote keys
      cxiverbs: add the provider and device discovery
      cxiverbs: implement UET verbs with explicit native ownership
      cxiverbs: cover identity isolation and polling and event traffic
      cxiverbs: launch Slurm-style exact VNI TC and resource grants
      cxiverbs: wire and package the CXI verbs provider and tests
      libibverbs: port RU examples to explicitly granted resources

 CMakeLists.txt                              |     1 +
 debian/control                              |     1 +
 debian/copyright                            |     5 +
 debian/ibverbs-providers.install            |     3 +
 debian/ibverbs-providers.lintian-overrides  |     4 +-
 debian/ibverbs-providers.symbols            |    46 +
 debian/ibverbs-utils.install                |     1 +
 debian/libibverbs-dev.install               |     5 +
 debian/libibverbs1.symbols                  |     1 +
 debian/rules                                |     6 +-
 kernel-headers/CMakeLists.txt               |     8 +
 kernel-headers/ethernet/cassini_user_defs.h | 15004 ++++++++++++++++++++++++++
 kernel-headers/rdma/cxiverbs-abi.h          |   658 ++
 kernel-headers/rdma/ib_user_ioctl_cmds.h    |     2 +
 kernel-headers/rdma/ib_user_ioctl_verbs.h   |     2 +
 kernel-headers/rdma/rdma_netlink.h          |     1 +
 libibverbs/cmd_counters.c                   |    25 +
 libibverbs/cmd_device.c                     |     7 +-
 libibverbs/driver.h                         |    11 +
 libibverbs/dummy_ops.c                      |    25 +
 libibverbs/enum_strs.c                      |     3 +-
 libibverbs/examples/CMakeLists.txt          |    10 +
 libibverbs/examples/devinfo.c               |     2 +
 libibverbs/examples/ru_cxi_launch.h         |   138 +
 libibverbs/examples/ru_pingpong.c           |   126 +-
 libibverbs/examples/ru_rma.c                |   112 +-
 libibverbs/init.c                           |     5 +
 libibverbs/libibverbs.map.in                |     2 +
 libibverbs/man/ibv_alloc_job.3.md           |     8 +-
 libibverbs/man/ibv_query_gid_ex.3.md        |     3 +-
 libibverbs/verbs.c                          |    30 +-
 libibverbs/verbs.h                          |    23 +
 providers/cxi/CMakeLists.txt                |    19 +
 providers/cxi/cxi.c                         |   196 +
 providers/cxi/cxi.h                         |   265 +
 providers/cxi/cxi_le.h                      |    97 +
 providers/cxi/cxi_prov_hw.h                 |  1838 ++++
 providers/cxi/cxi_telem.c                   |  3948 +++++++
 providers/cxi/cxi_verbs.h                   |    56 +
 providers/cxi/cxidv.h                       |   418 +
 providers/cxi/cxidv_telem.h                 |  1984 ++++
 providers/cxi/cxiverbs-abi.h                |    29 +
 providers/cxi/libcxiverbs.map               |    49 +
 providers/cxi/tests/CMakeLists.txt          |     4 +
 providers/cxi/tests/cxi_launcher_test.c     |    79 +
 providers/cxi/tests/cxi_le_test.c           |  2014 ++++
 providers/cxi/utils/CMakeLists.txt          |     5 +
 providers/cxi/utils/README.md               |   134 +
 providers/cxi/utils/cxi_launcher.c          |   967 ++
 providers/cxi/utils/cxi_telem.c             |   201 +
 providers/cxi/verbs.c                       |  3718 +++++++
 pyverbs/CMakeLists.txt                      |     3 +-
 pyverbs/device.pxd                          |     1 +
 pyverbs/device.pyx                          |     3 +-
 pyverbs/libibverbs_enums.pxd                |     1 +
 pyverbs/providers/cxi/CMakeLists.txt        |     6 +
 pyverbs/providers/cxi/__init__.pxd          |     0
 pyverbs/providers/cxi/__init__.py           |     0
 pyverbs/providers/cxi/cxidv.pxd             |    23 +
 pyverbs/providers/cxi/cxidv.pyx             |    64 +
 pyverbs/ru.pyx                              |     2 +-
 redhat/rdma-core.spec                       |     5 +
 suse/rdma-core.spec                         |    23 +
 tests/base.py                               |    47 +
 tests/ru_base.py                            |    33 +-
 tests/test_addr.py                          |     4 +-
 tests/test_device.py                        |    12 +-
 tests/test_dmah.py                          |    70 +-
 tests/test_mr.py                            |     8 +-
 tests/test_qp.py                            |     7 +-
 tests/test_ru.py                            |   136 +-
 71 files changed, 32565 insertions(+), 182 deletions(-)
---
base-commit: 8db37d9b02fac926ddd099ba7c05fac66f0e243a
change-id: 20261031-cxi-for-next-742514c31679

Best regards,
--  
Doug Ledford <doug.ledford@hpe.com>

