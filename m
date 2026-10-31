Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793474830;
	b=4MhkVPEScL7soiM9/fvwXab4x/tUgHwEnA29JtV301WieKuhlfKb5hMevOm4oJ/yzxBL
	 D8VDqEYcr+KH7UnjL/GH27jzvzEs+UrYiS1zi5tmkcyRHZMn92Fh5HRWzU97cUS5+qvsV
	 CS8AlGVVyirDLCCXWB//xyWBt6JD09hZSOCNWBn540ZO0TrD8Ro3FU+e6MwhJYR5GnMkB
	 i1a+jxxYVZrxVIP8128gyEspUVkl+O/c9EnA9aqtLCQ1Jx0QeB6+8ajELeyjOlbzZFcrg
	 XsmQad+Ogybzbhve+zYueubfiWJR4c8On1K7JG4xZUYin7SViSwoyigAz02G+HNIHzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474830;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=34K2lmQ/ofH5owaNn1tfCNQNwHmILPbI7P8NB9qZs1k=;
	b=symr0gvQni4fMOO3SlEm4avKf5qDqhZqUis/ni+fCtEH9rhyNaUZhO0sqoS3C17wSzR7
	 BXtUqMUrU30ZyCs13HRjN97xdpFCyed26+KgoaDFCnvdiQ6jJU+xGvIhnje/vwuz440bt
	 2tQPCHNMkdn6Du0MGYRHha6Ezf0dnZ9ci5uAGng702Y9+e0Cj8tPfWwU63RgIsDKCP949
	 Fsjgpg+FPR2yJzgYInhF8dhxBLmlYIgN9X3lx+qaVUx3wfzRuH40o07HjrSY+XghmNfGw
	 y/wwRG4c+spDYAU3S37kBwvW+aa6UYtFhNowkBVz0/hR2DcVMvcG+Ym+6xqHi8WJf9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=aCekz0Qg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.147.86
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF7D606A31E;
	Sat, 31 Oct 2026 19:27:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FF7D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=aCekz0Qg
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VJEtcN4164554;
	Sat, 31 Oct 2026 19:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=34
	K2lmQ/ofH5owaNn1tfCNQNwHmILPbI7P8NB9qZs1k=; b=aCekz0Qgaa6r9bby8b
	uApCJ8gwVRqSzs5ZV302RqnS2TDSqbbZsc6lFg0NPl/5vZP5SLRXqWlEXX8iXmo7
	Yr8ZL90iMREcWozgd0zk0Ywt+F23G5+DJ0cphLNIH8fdyqkqx7pcCxOM+WZ1Z/Wm
	ImWu1q5TzrueCf42TTYyLlkzXv29CtHnvDchtf40pfoHBKWBIZ0RvmBDhY1v4pqS
	nl9C/HHyFKe1AaWOoiWpEbJUAyDVeL1nW3Z8VBX5GGD1IdnFeNvpFezq5hva7TWO
	BWp6TqDyU2oyS9OD8ynxDbtoeTMw42heAaatsHlsPhy1i034AyH60+igl9MOq1XN
	+RDA==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn9qewg1x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 19:27:08 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id 2E0F3800EE7;
	Sat, 31 Oct 2026 19:27:08 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:40 -1200
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Sat, 31 Oct 2026 07:26:40 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Sat, 31 Oct 2026 07:26:40 -1200
Received: from BYAPR08CU003.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Sat, 31 Oct
 2026 07:26:39 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McG9Zyk3DPS7/5XlF0utX99gV94F96MR0qfBb0VxXDHspTzHJvxK2ANmlWa9pmLhiozwP0E2HpILZs8iJUc/ZnuWmKvJRk3u3dlID2AePdtAVRcXGbJbKU9je/lUTuaWBnNvRR3dB71rQ1wmphPc7EB7W3qGqZoIH+wMu9xib9KVLR8eLFRN2wRstbc+Urg9GmFDOQll3JZVe+UOdYC7s3ntiSyNWrRDcD5CgaLqE1oZRqRIL4pb7pabdJ8GisF3rAmBQq2OcrPHDu/OoNbJoO6+K72TMTSB8j7XQsMgPWIDcgvGVGaSiC1HB6F6kRUhb1ATMrQlJl9YC0NZJFyDhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34K2lmQ/ofH5owaNn1tfCNQNwHmILPbI7P8NB9qZs1k=;
 b=XSGANRPiqOVkDisbQmhfmfLRoF3ZO6aDjpp3CHehKAKcbLSt4IRmdwpGlfdnxrGVxXBZTYWKoJTCbVd5Qeyuiyz3DsfJ23qeBvJ2RufXxL4rKF9A1Qmugh/YDpE1ALL81kGYGAYISMV8WYO2wUH1s5QhVSAbzCtjf2ldT8brSh8E754DkatvAwQ9MX2obTdApK3aU9zel2d6QJaXRLB/Vq0Y5PAVKSMMmO6xztLgbGjGKSEWGfcW6gc+kBM3L+VQFfntRoP7KMU6wbTYKBXxlX1JZcnMLmiw6os9aAgFRy4RrItp7IH2TpOee1UUsbzHmOGrSVEFxYs8oIoSCs2cFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by CYXPR84MB3613.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:930:e6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sat, 31 Oct
 2026 19:26:38 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.010; Sat, 31 Oct 2026
 19:26:38 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Sat, 31 Oct 2026 12:25:55 -0700
Subject: [PATCH 02/12] libibverbs: permit jobs without an address table
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-cxi-for-next-v1-2-93ce01907ce2@hpe.com>
References: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
In-Reply-To: <20261031-cxi-for-next-v1-0-93ce01907ce2@hpe.com>
To: <linux-rdma@vger.kernel.org>, <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-kernel@vger.kernel.org>, Doug Ledford <doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA0PR11CA0162.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::17) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-Office365-Filtering-Correlation-Id: 4961554c-ec17-4aae-7cdf-08df3784e26d
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|56012099006|261009223027099003|261028144727099003|261021121427099003|261021123027099003|261026121527099003|261022105027099003|261026140227099003|10067099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info: zYyWsLp420Bi4uwMbjHLB/EA//c7HDnX7GJKfj/Ew2xmMUZoDvUTCG3GXZrxszWnCAs3WaggdpO+CDU3LJ3lrD/noCOD4KtOKOwNyYe4kZnzxHmmHawlTG6O1TJAT/zCpM4n44lexqmqFCkJHrwGYK+6HEVfg1+q+vLxrwaFhPvzRREed1LPTFFqXgGIt6A9G9BYRzBw9Bxoh4VE96halI+HGyUiO3nZEH18sYOoa5i01wt+GR3NcgqDtavHzRej0iYls1QUvTyhDl8iI6YZWAumtnOkbMeivdnUfZLPmGdOe4BYjiS9cQ23n+rf2BMYFkuk79a99dizTv9RWAJs0LHNPQx8xjVrrPHOxYyB5QP1fq5DU7LGOdgcwLOZM5+e3PURatGdhsYzDQJ1Qj43gvNy/sW+sDfuC2LP8DmGaCbJKxKlO6mO+kIqKnpaOoK0dOav1EdKPZYo/cYFYbTVRJyRWMtCKw/JJ6PEiLDjCrpo8pWzZj/TdHoETHtSMkCOD3TQKZfYKICc3QUoM/LpxRvfcek8UYfllXUDA6U00EozMe4K4QwTSuOkwGvd2b4//j+RT9Tvi6MpopnRHlqWqqLsVymplHp1Kws6Uw5jchvoqQp+BxdR78W4M7pS95BzqfiGCp8PTPXikPy6nftQuwNKqlu2pgEFhp68Av4yAzs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(56012099006)(261009223027099003)(261028144727099003)(261021121427099003)(261021123027099003)(261026121527099003)(261022105027099003)(261026140227099003)(10067099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEhjWGNzMjVyK3ZnSXR2R2dOVW5wQkhnR0pveW02cEFTbkZnMWdTYTVQZFpz?=
 =?utf-8?B?TDYyRUgrcDJLUlg0SFliSi9sbDdnSUd4ankxQjJSZ0x6eUd2RmhxVnYvTVpx?=
 =?utf-8?B?MzhoVXl4bHJvcy93VXVieXhYMDEvUlh0QkJUdzhZNTdzdVNYQ2dQZDdLUzVn?=
 =?utf-8?B?SUw3UnRBZm1xYWxYMGYybjFTTGw5ang2QzdicGVyay9VaTEzbEVyWitTWU5Q?=
 =?utf-8?B?bWhqcy9RU2RnaC9SMUxaY0UxY0RqRlh3RUVUZW00VGF3UVFMdUtGZGpFNzI2?=
 =?utf-8?B?Ry9EQmgzZTFQV3hyaWU1Ty9PdnZFR0RwdFVVSzdrYXEwZ3dhRmVRelRFOG5L?=
 =?utf-8?B?MS9wbDhNNnNBODJZVDllT25PU3BXTWphV2NVQS9lZTFlZ3J3aEdKOUhXYk80?=
 =?utf-8?B?NFlNVmdTVTB3MmJ4SmJMMDBXT2NFcVFhbXB0UnpkbFduQmJTbmlWUGx1ajVl?=
 =?utf-8?B?REYxcnEzZVVyZWs5Z0ZnQWVBRTZjQkl1ZURjUEEzSXU4Z2tIZjR2NXUrQnp3?=
 =?utf-8?B?V3VYRGVUL282Vjh3eHZBMjlPcXFDdUdmS2hKZmlWVDVFY05ySUFiU1VjM0Jx?=
 =?utf-8?B?K2Z3VnZWQmc1VjFoZkp0VEY2UEFQM1FrVFhCWGE5VS84UnJlMW51ak5kZUZT?=
 =?utf-8?B?Vko0N1Nia0dNR1d6b05mVkExcjduOHN1c3BLTFZlWTJJdmZ6OGN2enNGRUlU?=
 =?utf-8?B?UURqNmlqYitBU09zckxkdGJxZTZ2ZHZ6NzU5a1ZUZ3dYRzFTQTdmUEMzYkVU?=
 =?utf-8?B?L21GWTgzV2ZUcVkwSHd1L3lmbEpwbE1Tcmx6NldXK3dabUFPZDBmejdLOGZJ?=
 =?utf-8?B?UVAyZTB4aEJxdDBmeXF1UEl5TTdLZzJlRXhQUWV2c2tMMHNza0tMTEY0bS8z?=
 =?utf-8?B?QVkrVUFVV0FsbDE4My94NlJXcjNrWmFpNHNYSzlzVjE2WHpaamY4dS9oSTBm?=
 =?utf-8?B?YWdPdmVzMjhIT1ppaEZUQjNHajJ1bVEzQkxMYVdqNHVOejVQZ3FqeC8vdnJi?=
 =?utf-8?B?Qk85WHp5Zk1KNmhWSXpnZGJLWkZNSm1Xdkx2WDdjZmViVVZJcU52UXo1VnRN?=
 =?utf-8?B?cm5GWFJlaVk3NFU4SlFybTVMckRmbjFvS1oxZjl0R0VjSUdRVVVCbmpyS3NY?=
 =?utf-8?B?UU1QOVh0YU5hYVNCNGttb0ovVFd2ekc1SUhOREQ1MkNUR0lJYVhJZTB5ZGU5?=
 =?utf-8?B?N0F4ZGd6UUp0cUhYeTZ0WkZ0TGxWTGVmMmZoZWwxSVlXSkRGQ1pCbUx2TnNk?=
 =?utf-8?B?Z3NJcTJ5bEdSU2Yxd0FRWURFMzkxejNpMS9HcG8zTDIyTHZoak5kaU83cnQz?=
 =?utf-8?B?eXVybk5tUW8vSEp2ckNrU2NqKzFLbE9RUjY3VGlJS3FsVkZEZmRHWUp5cktK?=
 =?utf-8?B?aTYvbHpWcDZ4NXFQUlNnbWphZHU4VnFRMzVXWDZIRThnQVZZdWVod2RjOGNn?=
 =?utf-8?B?N0k2dkFNSkFVdnNtOG5wRVVBVVZJVEE1WjlSMzJZQ3ZldmUvRXU4b051MnFC?=
 =?utf-8?B?czlCb2duOGxoWndYblF3ZlNtTHZUUU5KekRndndhbFpaMEVEeGk0ZklpNzM3?=
 =?utf-8?B?b1dCQi9YSGRjMkNiMExON1FjakRBL0xuK01OU1hBaG5kNmUyandBNUo5Nzlz?=
 =?utf-8?B?RDB3cTROdnBWU3Z0SGNxWXhtYjlhMEwrbXlXUXRuYjFna0taa2t1VjJmTjg0?=
 =?utf-8?B?aVNONlNsTWFkcEMraDh3Y3UwdWZ1UVExM25ZMmlpRmVjOGZqZGFjQkYwSXJZ?=
 =?utf-8?B?SzZvdGpkN3BwUUcwZjk3OU5ZTy9WdTFHNk81dEpiK1ZUZzIwNXY2RUZjbjZo?=
 =?utf-8?B?MkZVQVlsTmoycWxnNEMwWmszditrZnRZTmc3OHA0MUc3cHZFVDhPblM2cGNp?=
 =?utf-8?B?S3IzdjMxK2dPY3haNzNBVjR3c0ZYb1Z6ajRaNUlMSnBXWHF3aFpsYmpBZUVW?=
 =?utf-8?B?Q2xNT1VUUjExOGZWZW1sN05QU3hzcGU2RTF2M3BTVHFOMzhUYkQxRWVBRWZH?=
 =?utf-8?B?MU5XWE1yaGZOa0FMR0h6ZmIycDM3UmFuVUQ0b1dCQ3l1UTZKeG0zYTQ3ZFVX?=
 =?utf-8?B?UDRSc1ZRbXh1Q01PSTNRaER6cGc4U3ZEemJRdTV1a094djlkNkM5Ynl3N1NQ?=
 =?utf-8?B?WXREVmxMMElzOENhZ3ZVZGdaTVlrZDQrbHNkT1RtekVkU2c2bTFkNmI5SEhw?=
 =?utf-8?B?OUJMTXNZak5Tc1BDZVZTRXNBZ1JxYnRKSjRRcS9MVUQ1UGk4SE5Sa28xNHBz?=
 =?utf-8?B?S1JOeXludk10dngzSGVyOGxoVkh2c2hDQXhkTXMvYW42ejhVblBCUW1OZE9X?=
 =?utf-8?B?bWJ5eUFMU3ZqR1lRK3IvK1ZwNHI3aExpL1Q1L0ZJQ1d3ZE45MWJiZz09?=
X-Exchange-RoutingPolicyChecked: UC+L5Du4YF1KQJD+fnK0/VgK/VoDhu+7krqGvCQg7plxQGo3OovhL5nY13YMBjQ9BZsaL1dn320hFwPfNFAWrgefFRkypFTpH9Lb/zpYUphbohSM9EIvjKqlLoZeE0KSfkdDm+Ignqs5b60/3WlwVx8CwAQlavdYcZaeNuNt//AwdVOuk+dxhN+NCDUkkyIt/EJ+qLYGYIxi9WJrohJU7RWaCpBvXxekEvYjbXc7mf86wKqdVQOkENPMjtkMeFdKJyjIBx6JJbyKNmXFBGPvGenra/rYVotoOQZwPgwKgbtgDiwFBd/5m7WLVFApK+beTxLz7C+X1vDc3/7nYV3wIg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4961554c-ec17-4aae-7cdf-08df3784e26d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 19:26:38.5150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MVHiwI1U/HLKdOMVVcTMlpBSspSfxba91uWFg/OwPWibPjBlGKM1xyhSZ959FFWOZIThgYqY9G9FEsQrrxHydw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR84MB3613
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: 4qoMV8LL6YPBzbuGdU5eEavUvIIFD1aH
X-Proofpoint-GUID: 4qoMV8LL6YPBzbuGdU5eEavUvIIFD1aH
X-Authority-Analysis: v=2.4 cv=T5EZ3PKQ c=1 sm=1 tr=0 ts=6ae6410c cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=ModqzXLkJJ0tFyq98apW:22 a=MvuuwTCpAAAA:8 a=dWQM02b8RPzZQlb8plAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX4nAwf0a93DbY
 aEMXHPZBz7OX6KtwdvRw7WdRas6emu39RfEsSDewTv6DwVikqs0lBmao4Lu+mvPp60YPe2iF3fX
 bi/mZi9HkzR3JTlpzvTsl6+OYa8pQARQLKaOYTKZaR/jBYKMNMS6WewqgWY+eZW+aL8cLpidU7A
 aEdHufcbSjTebmAivtXy+yt7exmGaTVDyxaImXu4UNYda+Ni30o7ZtNmkOZY571sZBv5LI1p5ad
 AHEqt6zEXluz5tc9w0XClOjl+PeNCLy+/GvWtmtPdjVg03NrknA7TmnGUKWZu85ro7wcoGT+LGn
 2IDuWP4tFjtDF7vo8tyUmY78lfcZsG8k7+MSPx9+x/qi52e8gHOTCm0M4LO5Ny/kD/LyNwQqpXL
 pX/pSEuL0BJqxBEW+Qz9wQjY76fBUYhtQMpquyQ6RivArjIC0sku0g916y1qrvPJw9GgjXb/Hc1
 e+rlnj5mfK2duch2WHQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA3NyBTYWx0ZWRfX+jcQSIZRYO3L
 7/6OFflh/gw+njfrHKdUwCk1VyF6VFC+H+XXIRyMvPhUf9pJM08v24IF+LaBuV2qdYeXVNrnBLw
 CKq7lflvaZQT/U7cVmBZ5XSRhyRV4e4=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0
 phishscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2610310077

The job address table stores indexed remote fabric endpoints using
address-handle attributes and a remote QPN. Its entry count is not a
limit on memory regions, mapped pages, or ATU translation contexts.

Cassini transmit commands carry a destination fabric address directly.
The CXI provider currently supports address-handle-based sends, not the
job address-table operations or indexed sends. The documented hardware
transmit interface exposes no equivalent programmable peer table.
Connection/retry state is not a replacement for it. Native memory
translation and resource accounting are separate ATU operations.

Do not reject an address-handle-only job merely because it requests no
peer-table entries. Dispatch allocation to the provider, which supplies
the mandatory MAX_ADDR_ENTRIES uverbs attribute explicitly as zero when
the caller omits it. The companion core change permits zero and retains
the device upper bound and job-allocation privilege checks. Jobs still
carry a JobID and use job keys; CXI indexed sends remain unsupported.

This relaxes the shared libibverbs allocation contract and needs review
together with the corresponding core API policy change.

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 libibverbs/man/ibv_alloc_job.3.md | 8 +++++---
 libibverbs/verbs.c                | 7 -------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/libibverbs/man/ibv_alloc_job.3.md b/libibverbs/man/ibv_alloc_job.3.md
index 2be8e482c4cf..e90f025e5357 100644
--- a/libibverbs/man/ibv_alloc_job.3.md
+++ b/libibverbs/man/ibv_alloc_job.3.md
@@ -97,9 +97,11 @@ struct ibv_job_attr {
 
 *max_addr_entries*
 :	Number of entries in the job address table. Selected by
-	*IBV_JOB_ATTR_MAX_ADDR_ENTRIES*, which allocation requires. It MUST be
-	non-zero and MUST NOT exceed the *max_addr_entries* limit reported by
-	**ibv_query_device_ex**(3). See **ibv_insert_addr**(3).
+	*IBV_JOB_ATTR_MAX_ADDR_ENTRIES*. Omitting this member or specifying zero
+	creates a job without an address table; work requests must then use
+	explicit address handles. Consumers using indexed addresses must request
+	a positive capacity. The capacity MUST NOT exceed the *max_addr_entries*
+	limit reported by **ibv_query_device_ex**(3). See **ibv_insert_addr**(3).
 
 *port_num*
 :	Device port the job is associated with. Selected by
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index 1df4dbf94dcc..b2f9f4e3f8c0 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -321,13 +321,6 @@ struct ibv_job *ibv_alloc_job(struct ibv_context *context,
 		return NULL;
 	}
 
-	/* the address table is sized once, when the job is allocated */
-	if (!(attr->comp_mask & IBV_JOB_ATTR_MAX_ADDR_ENTRIES) ||
-	    !attr->max_addr_entries) {
-		errno = EINVAL;
-		return NULL;
-	}
-
 	job = vctx->alloc_job(context, attr, user_context);
 	if (job) {
 		job->context = context;

-- 
2.56.0

