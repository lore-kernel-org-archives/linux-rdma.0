Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793808864;
	b=hcsmLhaxOOW+FSw1EnlQiI+1jz31+egKiHZmyYakevOsVGsk+jhmLgYPfm2lQa5Ohq5m
	 F4hGXMnYS2YcpZvPPhiWo9sK7cRAGoqZlkk58h9xqlPWdUFLQMzIQYDtNphZk/FCD7q+H
	 ARGWhvjA24tY7dlxvooZBR+xPZLRhglgf/I6Sw9H4wZ2YV+p5ILd162qrbXT6j48RqSSQ
	 bkRGxzlJ+B5DddrZD4dz2ZM4eIqhjCrJU50AgujMnn2+1DRfz2cB+g5kbzvI49GgWLTSm
	 se7Nz4JFR87JH9Ek9JJacRIoB06/sRRRM3vdMsoxL0kNQt7gE62H8BtGLjv2VK5xuyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793808864;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:User-Agent:
	 Subject:To:CC:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:X-ClientProxiedBy:MIME-Version:
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
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:X-HPE-SCL:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qwP77Qu9OIfSA1PGYHBekUfp7HsFxizoBYPB0glF9h8=;
	b=ChQYkMtstkgp3YsNoi58LsXCzmk5xCCy4vXb3X76zJ4MUCCxs4D92Q6aqg4TvTU+xEHJ
	 2/CJKKpcYy4t6eB41AcX4Dcq1mAOpkXRrOPEIob0rUW+RolusrQoX9Iqv+fuef4Tq9jOB
	 Td302iv1OpZ3CT8zYRICApoS8S/ZY8yHlRGiDoHP/OfehVyRV54KYc+6mZxDIaW9w9FG9
	 r5oEjcFlfZwMBl0m4dC9ZbmfYz7iF8UcfbFcwUYVMzVXTDkzQa7A8p2RJSETSIASTYsC2
	 EwG2VpJGCW8k8jZlBo3Lsfe+pb/yZermDq0H7XPDs1yVJwEWt3nola+Tyja9+OZwq3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b="amTYH/7v";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22096606A31B;
	Wed,  4 Nov 2026 16:14:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22096606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=amTYH/7v
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A4FhLmB4161736;
	Wed, 4 Nov 2026 16:14:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=qwP77Qu9OIfSA1PGYHBekUfp7H
	sFxizoBYPB0glF9h8=; b=amTYH/7vfPmc57jSgdGqRigK9kGQkYyCuKjYXo/5d/
	2ZIsC+ahPVPLnWB7fRi2q3p7rENruXhsATLVPtQG/JDUrpcVAHMXOKJMRPXBy5ib
	t7BsSPE6zSdBCnb9Wp4IBkyzVHI+St5qCXLoCd7fhy0GTibfk0yqrXDuegHs4P6z
	EnMfzKauOeWfu7WHPiNPPRqUSFaMbNhYIPQpWl/yLZiuSfZL/29pTrk9lBYFQYdS
	9TtfiGt4FnY0LFajPl3imF4qBQB4Pj+phE1bdKnrAez/R3j7RPaoNfpxYVFjw8zo
	zR3rosXst2bQDpleu+s7soMSnnslWKsR1jm8G312kB+Q==
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hr5aharff-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 04 Nov 2026 16:14:21 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14881.it.hpe.com (Postfix) with ESMTPS id A83688047A5;
	Wed,  4 Nov 2026 16:14:20 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 4 Nov 2026 04:14:20 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 4 Nov 2026 04:14:20 -1200
Received: from BN1PR07CU003.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 4 Nov
 2026 04:14:20 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I6C//2ZjNPTNx5k6/yMyekxw/Z/LMrDJulReQ7B+lEZdgDNkgnWmqHOSwN+Uz4inzrVY2QBvnW9GIz/yDPvdhmliJQqODKC+r5U8ZusbuKec/fDDeVp2wK2gBlQ8b3ZFN5O3rKOfcI1Fn1XzecU2n80fsuAyPhmCnxJroenQI5isel0XVHw69dfmVPoxOVaZuE+8sBHDNojPiUQ6AWrQSO6cDuZAMwlIimPwSP2kzE8CPtEHI2uTCWI6RLii1w4C8eZNvOp8NDZ3o79rxTUJHCR6YbJfA1jgVoSEQSIYBtGOzsDqSpQ4/ffAzCP8jdtqTwH+6NCmLS1Ec8pWYTqd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwP77Qu9OIfSA1PGYHBekUfp7HsFxizoBYPB0glF9h8=;
 b=hbeh73xXeHsBngY7CAJ5sOPlG3CqXLvrcQyUEINJkLRmxPlggpQ9iu/I1i6SBz1RNwoLY3g7/CCHei1koQL8sgLbVvDD5kSrtMFy8Y1/5kIvZNWim2Zz6g6yzZv7ZPgk/lvh6ewMIEdqdrsfQspgRXNgiZjDS59DfsKkER2dM4Papt8cYBgfECR4J0PZeteXD1uWbfpwiXesE4+IXs/PzDi8rNMzDoY6swAA2HW887WePvsWFaHvgS70L8GKjfz0mNUmrOz9TseNDpiv+atgeFqT53J8GPUEnCVz2U6M6ZI0hvOpqp4B10DHiiuUyxgcOUTzCQcqA+6uoKe7GE2NLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MN0PR84MB3942.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:208:4bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 16:14:16 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 16:14:16 +0000
Message-ID: <37849373-8475-45ea-8440-0849b66c2932@hpe.com>
Date: Wed, 4 Nov 2026 08:14:13 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
CC: Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Iraimani P
	<iraimani.pavadai@hpe.com>,
        Mamila Santosh <santosh-kumar.mamila@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261103142826.GJ264423@unreal> <20261103143004.GJ3889730@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261103143004.GJ3889730@ziepe.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------owAE80pouCfQNSnXpboJkzYd"
X-ClientProxiedBy: SA0PR11CA0207.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::32) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MN0PR84MB3942:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e3fd20a-cccb-4fa8-5c5e-08df3a8eac76
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|5023799004|4143699003|56012099006|261021121427099003|261021130227099003|261021135927099003|261009223027099003|261021123027099003|261102123227099003|261102130727099003|261022113327099003|261022075727099003|261026135527099003|261022105027099003|261026121527099003|261022115727099003|261026130827099003|261021133027099003|261028144727099003|261026140227099003|10067099003|22082099003|18002099003|6133799003|4133799003|3023799007;
X-Microsoft-Antispam-Message-Info: ThhBwKht1bafo7O6EPJQt6UtR5TDm0N+8vkB5ztSnD+DEQSQEO7SCKSaXitmSdgA5esuG2IWce1mDVabue5LPDNpsuikobsxlLcbtgyGVTYBq6J+mH21iKbozCLrN4c0fL8SS7+vxhAZ0XKvNuLy0/l/wIhVthQGTuw+Ww2CepWkIpOTdmUl0tFj0+O/4a7Bkfg7uBiH0Ag8q2K944sFROlWkZA5bW9lWurA3Famu47/62w0gsOhzU2o1THdEpgc6IAplVSdnxHPtWdL1yATpMZiSNupCGiWrcRXBXqyYka9/vgnr0Ocm5mnuxbF6mJ0dJIUbgIbIRt3kPeY/CCf+ukaG5Nzq1k5mCKb5jPbBqt06R9hltWLgnD1wKQdOoeiCKkvXBsFIFXt9lkFVRim4sfBz13GLc/55vfF8fGsuttutKf0fhIwKsXuilZZMIWKjZbA5RRnZ6nTzIq/R+bZLADRUuC9IitOzlPXFwTtFBwyBULhX/zglcJFe8zwWZ07JLBAfgnhj8eR2DtAVqUH9wi1r7xoCN8QHPBhId06JECwnnFviVHrQINgSZ8zNiFo1Zu4ugGHrSPutaoncCzGSZUZ+2HIzQwhbnT7eMK8NgQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(5023799004)(4143699003)(56012099006)(261021121427099003)(261021130227099003)(261021135927099003)(261009223027099003)(261021123027099003)(261102123227099003)(261102130727099003)(261022113327099003)(261022075727099003)(261026135527099003)(261022105027099003)(261026121527099003)(261022115727099003)(261026130827099003)(261021133027099003)(261028144727099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003)(4133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUhROEVUM0M3dnRhU1ZXcnlGbEUxOWVubTE0S21TbGk4S3V3UGxkeVpUdFJx?=
 =?utf-8?B?MXdJWTNtUGhTc2FKTUpNK1FoMlc3cnNXMTdEWnhHU2EyeUFZMnN5VCtnQzha?=
 =?utf-8?B?enIxWFdLbHFSN25UZzQ3M1Y1WGZ5NzNHNFVuODZYZllYVVVySEw4VlZpZHdw?=
 =?utf-8?B?bkhlMXVQaEFIZ2xWeWRnUVBtd1hqRUYrUDFZcEg1S2VPUzB2aTRBZGlVcVAy?=
 =?utf-8?B?RFRjNUFkcjNpQStGZmxJZ0RoVWQ0eEtOem1hcGorNmRGSUJ2aTdTR09zRERV?=
 =?utf-8?B?RlQ0RGFCM2ZFR1hZcEhhTCt1TUFLc29lUlhuZnNIOEJKL3ZNYmdzWDAxL2Jh?=
 =?utf-8?B?cU5jUzlsSmhyd3JoSWVaZGErNlg0MlIvQ1dQbzlnVzdQVzVLL0I1UnRod2c5?=
 =?utf-8?B?VmJmRWpVOW1Jb0JpUXFrVDJ3dnAxRUtvNzZaRXpIQnJLTlZZVzFoM0dUV2tB?=
 =?utf-8?B?REV5NERlaS83QlBJeEpRM2JkS296ZFlNWXlsRnovMzR6R2QwWXB6bDdpT1F5?=
 =?utf-8?B?T1RLdjVlWTlrN09JWXlySzJLS2M1eDdUQWNXOEJCMTFqQVo1UVovU08zbCsy?=
 =?utf-8?B?dTJSMElxRDBrSWNKcGhyOTFuNElHbXVTRXE1dnl3MXFGTFRqWEtTbUdDWDRF?=
 =?utf-8?B?cUIzYWE1RjJvdEtFdkdjaDVxajFpOGlwaHJmaUE0dHlaNjE3QTR5L24raCtS?=
 =?utf-8?B?M0FPNjdnay9WdUhVR1haa2E4ckdCdkJhTmkrTXlkUkZhVVhrRVNtYlRwbmNB?=
 =?utf-8?B?QzBOYjlwUERSQXE1TUZIaGRIdDZYcExjRkpCOGdNSnlZc1A0VjRDSnN6SStK?=
 =?utf-8?B?SUpwK3QwSjQ0dGhLM3dCQ0RJWXNuSjV5RDIwZXYxcHdReUIxSXE4c2FLYkRn?=
 =?utf-8?B?Z2dtcHhxb1I1ZUozNVV0L0xnaU5nTXRBMTNxMTdOZXkxN1R2V2pMNnhjeG1D?=
 =?utf-8?B?bE1Sc1llT08yVm1vUFNTZlJldmlNNXJSUlRRWkJhN1lCeFo5OGRqSkd6azBX?=
 =?utf-8?B?YWNQMEZWVi9TM2dJMzVSZFBzZXZJT3FXTVlGSG9JaVpSUU9WMFpDcXV4UVdo?=
 =?utf-8?B?RG1NdGJ6UlRHQndEMXRxVTl1cW1jR2xOTUNCbnVrOUJFNjUrYlcrVmZPbHRp?=
 =?utf-8?B?d1NUdTFzdFo4NFQ1SXR4QmF2aGlaa2RHM0FhRkYydGdhS1gybWRwRlI4eHNV?=
 =?utf-8?B?aE9XRVFmQlRtamVIQ25CMnNxZ3VqSjI0QkVHWFJmZnNYcklFQXV2d3RSaXhN?=
 =?utf-8?B?ZHplbVROcm93RWhkS3BHWWRxRnpybzlRUDFvZHFZUUJCeWNOTzFubENjZXI2?=
 =?utf-8?B?ekxtbldzS0RGOUJhZW5DdnM5OVl6M3Jrc1ZzMldOV1JuZzFwNzczeTRKelk1?=
 =?utf-8?B?YzlidVM1S0p6WkZBUkMzWFlTaWhraXI1N3hiNTZLWGQyR1hlVEhHRFdBNUVK?=
 =?utf-8?B?eGVDMERHcWVBVy92Y3ZUREozYVpuMHNRcHFEYW9tekZxWHd6Nm9nMnUzc0gv?=
 =?utf-8?B?OCtxcDFqL3p2dmNoci9sQldHVGd4c2ZNd1FucDFwVUxyZXMxRjAwNWdFRXJu?=
 =?utf-8?B?a0tLSUpFV0RJOHdiZXNrT2t4azJzckNVdXNlRGNzZHladk1pbE9KdUlQL0Mx?=
 =?utf-8?B?QnRzbHFPNnRJNUJIZjlEMEJMSFk0TTlORm5CZFUvdnA4eEMyTkY1aHkyUVU2?=
 =?utf-8?B?SGMvbEZIYU9SaXVwZDZSWWNNVkEzVWtzRVBvQ0RiUTRUa2w3clBDK2JQZEJv?=
 =?utf-8?B?OVMycC9xakU1T1BDSFQ0dWtNKzh5YVJmMUdWd3gxWTZNYUx5bDBDaFRtdEIr?=
 =?utf-8?B?RHdYL2NTMGR2VFZBUUR4SldwZ0cwUzNaanV0enNsR1p0YldObWNCRXg5WVJu?=
 =?utf-8?B?RHZ3YnlRblU0dHpVRWNGS0RQR2hJbU53a0w0bDh4dDNwaHo5TGxualpCNHRr?=
 =?utf-8?B?MlZUQWVuN25tNTBtcjJ2OHBCQmkzZkFQdy8wUCs2aytGN2V2ZDZnOWtUZmdU?=
 =?utf-8?B?WUY2NnpMRHdaUlV3bmt2NGxQR01wVEI1OWVGZFpLd1orekRuVjhvMzBsbW9T?=
 =?utf-8?B?RCswWFIrbitTY0RRZGFBTmwvTUt4Q29yV25NNG5TOWxydDFObkZZRmlucGhO?=
 =?utf-8?B?UHNvRkhhU1hIODhFdVF5NlA0WTlQUzZSb1BxS2l4UUIySDVrelZNdERzMVBn?=
 =?utf-8?B?QXY4NVdpTjQza1hEcmorODRnemJVWHBQbk5UK2c5bStLd2dBTEdiVVYvcFBz?=
 =?utf-8?B?c3pQQmFjc0w1MElLa1A5ZExQZnk4M3JrNjBFby93bmJnY2pzanJ6VS9KU3BE?=
 =?utf-8?B?U2JKakZZbngyTXJZdGRGUGFjRlU4NnkzRVd4TFFMTTQ1cWppUlhqUT09?=
X-Exchange-RoutingPolicyChecked: eXPJVp0G2QywNWCZRN6bJr+mPLp8ffZ6uYT6cqJkoPw4Lr6ewzphxFpV/2P8+5d60RAGuS1OwLlCXAxnEGfwIWpfsbEtJtUYnfocMxGnKrk+RBSy8lkj3RCJ+9SqoxgkgpbuZ2LjbnzlEFQm2PQSokOEntdXbuBNWmvL/TSv6a1ajaBSGcEcs4UOBS2ptkaj9ctUPd/ew5W9zRztMi107FzdNW5nJRSilLifuoQiiLzeDpJCkUNsUUYfawXOWpgGsHmNkui4cNzZ/DCojl9ZaqIzsP0uKBOq0H/nzc8RkVYgKplIAKzfq7HvNGFnRshEm0EXmEr06inP5BTfeUp+2Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e3fd20a-cccb-4fa8-5c5e-08df3a8eac76
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 16:14:16.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RQ+WWsDdU0X1Aq8c+i897EgXteL5zZZy1YE3IMfCv51yyHLsM30bPfkJ6CeawrATG8OwoDMZuLGQvMgyDCpYCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR84MB3942
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: V8DZaDhLuRMFcN9VZ7MP5dTEk92nhs93
X-Authority-Analysis: v=2.4 cv=Gq7XaU1C c=1 sm=1 tr=0 ts=6aeb59dd cx=c_pps
 a=FAnPgvRYq/vnBSvlTDCQOQ==:117 a=FAnPgvRYq/vnBSvlTDCQOQ==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=g3u0LPWLDYfGfufhFw6-:22
 a=c92rfblmAAAA:8 a=MvuuwTCpAAAA:8 a=Y06IZwgp-2UHUbZ8XgkA:9 a=QEXdDO2ut3YA:10
 a=o7atTUFukcLD1P7mZl0A:9 a=FfaGCDsud1wA:10 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: V8DZaDhLuRMFcN9VZ7MP5dTEk92nhs93
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDA2NCBTYWx0ZWRfX2y/fKKou6BGQ
 76E4l/8iBABbYSZqlk0fD75H5y3MyOhAuD6Y45k5kDOMrW/H8IP8pVes4xFWndADrtMgXlKGsQZ
 KgJXTnmp3YUcPg7aj0hNsSjE0hvseRc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDA2NCBTYWx0ZWRfX/nbnSoSi/Db2
 CuKxDO6MjxhlCwgCW7vvZDgM5ZuvpRzIssB+8oX/PPtYyUpR3G9GksH8hSXFEfDdvdePzjKQNA2
 hYwHSuEjKGFBlhyKH8fTcyOeMrJX2Ijj1hceJ6blRooDgvnqys9qJqlg+j9qkuqSA1IIcdogZMS
 BTXfZr+X5RW/ZfAiXlIVlgDLyZkt8s1dj/kdDGjfNesSW9fGh3bQNKs5clbBjNJh2ntEmE3WV23
 Akdlp9xqo6L9ZPonFP9gDv0123O2ccirBmLwwW1n2O1j/B1lKyZru/0NGHWbUHNmozQ8DSfpAKx
 agYs54TyGTxjLk1IARGllNJRDfET1RZ3Dg2T72wrwLF+1cjmfv6pKNPKUZrxpodnlPPxXyvamUB
 oVf8qipddrxK48dkp2Bv7NL5GL+TwkOJ+Z+xHa43SSb7WvZ0AQIs/H4/y+wonR8Skwi7rXYBiqv
 F1dJWPJVPajYzQlg9lw==
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_05,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040064

--------------owAE80pouCfQNSnXpboJkzYd
Content-Type: multipart/mixed; boundary="------------WU8MJ3JWfXgDQwfb3v2aCRh7";
 protected-headers="v1"; hp="clear"
Message-ID: <37849373-8475-45ea-8440-0849b66c2932@hpe.com>
Date: Wed, 4 Nov 2026 08:14:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] Subject: [PATCH for-next 00/11] RDMA/cxi: add the
 HPE Cassini verbs driver
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 Iraimani P <iraimani.pavadai@hpe.com>,
 Mamila Santosh <santosh-kumar.mamila@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
 <20261103142826.GJ264423@unreal> <20261103143004.GJ3889730@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261103143004.GJ3889730@ziepe.ca>

--------------WU8MJ3JWfXgDQwfb3v2aCRh7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/3/26 6:30 AM, Jason Gunthorpe wrote:
> On Tue, Nov 03, 2026 at 04:28:26PM +0200, Leon Romanovsky wrote:
>> On Fri, Oct 30, 2026 at 09:35:28PM -0700, Doug Ledford wrote:
>>> This series adds cxiverbs, an RDMA driver for the HPE Slingshot Cassi=
ni
>>> NIC. It exposes the NIC through the verbs API using the UET reliable
>>> unconnected (RU) queue pair type from the UET RDMA core series.
>>>
>>> cxiverbs does not drive the hardware itself. It is an auxiliary bus
>>> client of the cxi-ss1 Cassini core driver and does everything through=

>>> that driver's exported CXI interface.
>>
>> <...>
>>
>>> Before posting, the series was reviewed with the Sashiko AI code
>>> review tool and checkpatch. All valid findings are fixed, except the
>>> open items listed above.
>>
>> <...>
>>
>>> ---
>>> base-commit: 306a2f8432f516069b2e673de7a07043132c034f
>>
>> Sashiko failed to apply this series as this base-commit doesn't exist.=

>> =E2=9E=9C  kernel git:(wip/leon-for-rc) git show 306a2f8432f516069b2e6=
73de7a07043132c034f
>> fatal: bad object 306a2f8432f516069b2e673de7a07043132c034f
>>
>> https://urldefense.com/v3/__https://sashiko.dev/*/patchset/20261030-cx=
i-for-next-v1-0-bc6e49e07037@hpe.com__;Iw!!NpxR!jVGLxpaqGEPJ5fZJ3ZoNkSuC5=
-NuVK2GbaWiVfqG__a0SYh3NAgK9UqQPHsk4FEdYNCqDyPzXwao$=20
>>
>> Please make sure that upstream sashiko runs on it too.
>=20
> I don't think he can, it relies on the core code series. I Don't know
> how to instruct sashiko how to find another series to stich it
> together
>=20
> Jason

I wouldn't bother running sashiko yet.  I purposefully submitted our
driver in full to the netdev community, knowing that they'd never take
it that way.  But I wanted them to see the full driver and how it works
(most notably that it is not a generic Ethernet NIC with RX/TX
descriptor rings, but it's a Portals 4.0 API device with Portal Table
Entries that filter incoming packets to specific destinations) and what
size and complexity it involves.  It's not clear to me that the driver
should be in the netdev community, but maybe rather in the RDMA
community.  The only catch is that it passes native Ethernet packets via
hardware, it's just how they are mapped to send commands and filter recv
queues that's different.  So, I'm requesting they make a judgement call,
looking at the entire driver and what it would likely become even if I
spoon fed them small chunks at a time, and decide if it should be a
netdev device with an RDMA aux device, or an RDMA device with an
Ethernet aux device.

--=20
Doug Ledford <doug.ledford@hpe.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D

--------------WU8MJ3JWfXgDQwfb3v2aCRh7--

--------------owAE80pouCfQNSnXpboJkzYd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmrrWdUFAwAAAAAACgkQuCajMw5XL92p
3RAArG9GJi77tWxRHK3qFPrEPwNG0rSwDxeMDPyfl6GgSVXbhvAJ0nxl5P8+QvIZREh+ZJkuKBzi
mSy/M8VEDeYPBXzNeVsgwZkoM5ZvwxWgchKqOBX+Q58CekTxg1q41Yih4nrxedkiNKgmc2rwX9+L
XiF8DFtw03bGpPH79Xwuy5AtuNMCW4foMOWLwuoTcDNPmfJhxQfHrR55iZFdQtvXWAukDnT9V5xx
rYpYLw9LmGjZZ0HU1itj9dLcs+E3x0Rq1/ZmTKGzcCpy151azS4FuruO4BoqZK2+TdxSLLn1F+ha
yPAkZsh38iFwRl6YlpqfFJp8TY2nVZ9m66iLgEDqa/O23FjwU5jUNatMK19as0CtPzIjfDL++Oob
b6t0jX5lyiUmlL+1nSkNh5+IQQqCow/pieXw9Tb+qVypNS5/Yt/igL3nawpNOboUUHPZOFnI+1Ak
7AsBW9fFpYT3Ce3YZ6VGWq2ckBoIgMM978Jqqp980qWcSC3bV+MEuR5lC/H9St9svXSV6qxnRJe9
4HcYXxCl6lunKxvHyLGqeneQC+we9O91QqPmGwKuY6UW2F3PJ2YpLST50qzaSpJMEtJAI1R4GOmX
koAQ5t1ZD8yzcZ2gdFFW0wmeu5nF1kgfviq7TI1I6lMZMK89o2MzNbRtnq2CglMAUPea2i8RFXmV
gdY=
=N0Bc
-----END PGP SIGNATURE-----

--------------owAE80pouCfQNSnXpboJkzYd--
