Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35A447FB00
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.147.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022308; cv=fail; b=NfZsB8ueoiA+b7IFecQiRI6ZuE1mqMpI2YVRg/nPa+WYAuYmYbeXJ3S/wkKbg3lvKfohqSUjUWRxjbULeWMf8EjYn7UUn2rQdnFbhn9SdzP19EhZZ0TrPpKfXlEoLCSxhiqG8iH7cAFblMRLJrlGhMnQ7gcPqzP0SLqKPCkUFxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022308; c=relaxed/simple;
	bh=miraOEufovmmCpnpTu21iTYB3L5OVWmhSHsmeIn2/XI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BQMfn15OHqmi0Yh2nHFYvoQJLLkRW7RU6I7evJcB/Xnnt2HTpC7MVg60u2s3YX3ha8IjzZtJM9iVJBjRgOEUWDLc8xEm2yAJvW/tJ9u2j+56d34fakefnSC8cMcwWANh8dfOTZ23eefeH4EsdyQpUiTxCfSb+MlSBovOyBOqikw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=JnNfbxja; arc=fail smtp.client-ip=148.163.147.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="JnNfbxja"
Received: from pps.filterd (m0148663.ppops.net [127.0.0.1])
	by mx0a-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EMmLQB292361;
	Wed, 14 Oct 2026 23:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=Llv2zUCegp27fO+m5n85OGIYY+
	HGTD1xiOVQFP6XSvA=; b=JnNfbxja4lRTYI1x/YZMkHP0vIUqRqafQVLjzC3B0f
	Z7srxVII/O6R7soemrMcEK3uA6e1WDGpeh3J0j6w3IXIM7oDxy24MBG13VDhII6f
	U2P+Q4ha+YfVPgBR3ENCds5jGsWbsFO4E/CsLKXPDDl8x/jcCxdBG2OEMVpESdc6
	gAvQkiBJjM60Y3FtQJqNjAldAsoAnKV3vGeH57cY6qnP9zNLRGb9komxs5rE2vSN
	jZwD+64q0ui++rw9cKzrkODhcg8z9LJy3L5SHnGPVvN8iTz7hFAvChKZY+E5zVWc
	GM3Fni1B5JN7astzPefrDXjkNcUV4ZYQp/pjaiVHXFEA==
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
	by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 4hagcw2kwj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 14 Oct 2026 23:58:23 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14878.it.hpe.com (Postfix) with ESMTPS id 68429D2F8;
	Wed, 14 Oct 2026 23:58:23 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 14 Oct 2026 11:57:22 -1200
Received: from p1wg14924.americas.hpqcorp.net (10.119.18.113) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 14 Oct 2026 11:57:22 -1200
Received: from p1wg14921.americas.hpqcorp.net (16.230.19.124) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 14 Oct 2026 11:57:22 -1200
Received: from DM2PR04CU003.outbound.protection.outlook.com (192.58.206.38) by
 edge.it.hpe.com (16.230.19.124) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 14 Oct
 2026 11:57:21 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J++31Gg0P3LTLVRnlEOwGcJnKZm43QQdbbMrw2Dn2a9+1erUAXnk2Q4kUGHd/tt42+e9QhlKiEIzPc8yHsik1xMG/GFwEj+HG6J665NLi7HSMQKrGiIIKqi/DGRAzCYgCX4Ro0iBm8KlyVo/9OT7XhDBgrERTiMceYlTFMgAfGIwIhrG5ycvp1iuBfKwH5DzDzXK9EyvoLtHh0s7pUYh1dDMbUw468MkpB65yfdq8i1/J0NLRQvIcGhy7Q2QEsgPTNtpp/x0khW9g4gt6LRZv9jmjG2ci2Y09gCGFgCPAXHkNivsHndf+6fgWnjUm3s9uo/LPHuxP9nTx++rw8worg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Llv2zUCegp27fO+m5n85OGIYY+HGTD1xiOVQFP6XSvA=;
 b=XqCHMgwi2/+AwhvdE8NKWsNi8644VuE46jfBVlAPKUjzXrNAPgq/h3UhBbU0xhbY9+AKOxLoc1IMF6unVyfSgucVsGNZYYE3cc24oUwIKvifNt+RX8hF79aAJomQQAjDO3QHl5aKu7tiCk1XET3dmqvWeaw1p9n0YJhyEQR5VLwrZ1DFGzJqyCJFeaJXolvmSju3MBFf6vCaZJQdcoVcORzYEeQk8Pw5tgmc5qsGYc6d6qShlgxlOYA24JlQ5eW9SQK5QJ734W8ecNMtcNtx294sHeJAxWwZFdEbB+7t06aUfC+mV67iEt7phf6JSRYQ0Nl7/TWIny2YS6CoTOj73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by PH0PR84MB1669.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 23:57:19 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 23:57:19 +0000
Message-ID: <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
Date: Wed, 14 Oct 2026 16:57:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: <eric.davis@broadcom.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky
	<leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------no5m5Djhh0J7lHWmPqS3fEed"
X-ClientProxiedBy: SJ0PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::33) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|PH0PR84MB1669:EE_
X-MS-Office365-Filtering-Correlation-Id: 2416bec7-fd34-4f97-e316-08df2a4ee1ac
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|56012099006|10067099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: xDCBUFSLFEv4hMA80hQurMLkjHFG25RxgTEqVHbAGDbaHqqpbNaVWaZv8xjGX7G3R1jCoJXRqRHYrklD6ury/m0vPKQZBcVpmUcdPO9eIAAKg3BPtmyp9jt55ow64tu2SEvkd1p/wBmBbwxN3OeZm+VxtIGWyPKbOTLGYd7Ub+rl4ebFfjO+s+stj04aXY4FGFObBQH3jRIlG0HbmvPlADU6IM5B+mhTR5v316bNj5G9StiZa0mOi9S23di1jgS0J3cKEBc2KFHVg8na1mqVgPu68bwHGirymQRCCTtof3KNMIZgjSFeOABve6BxWgG/z1C1w1y5vQgFtqHWzX6fWvS3xifvbQGcqFV6E2m7GJbVfzhSBL14BRaLYeECvVnc96uXV7dbvMteWf/KpukcJA+32MEq31qdzuAHZgJE7Copq6MHk9dCE79igoNVH96ZOwxveuesUCwa841DOuglaT9m1RSX4fb2BuIfgTAdhCfA98S9Qv5Otr3T1wzT+anedB58trZnOBd/EjrKEFmaY8OHTiVH0rDj1qX1Rce81M80ZI5nPPQ+/HCT9swVJbMq8rvGgVRqmAESEYgJQHxcJWR3GVQgtXrd1mQKpJSsQz+EW52ii2lZr9yYv/AmU6baACA8sdrjUdDSNqlqP4AzMO42GY9TxcTOOzSzi9mMY88=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(56012099006)(10067099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1FVRCt4Z3M1Z253Vm1vazFMS2dvL2VMbkgxd3FsWGxoNGZ0UThadW5jVnVp?=
 =?utf-8?B?N2NzT08wY01WT3ZheG1lejZDSDc3Nm5LVHZ4enJVcWNWME4rWVU4bkxpOFVH?=
 =?utf-8?B?bi9ucjJQYUg2clY0ajhvbnZ5VmF1cWlJMTE5TjFRMXhTVExEZndodDFJUE9y?=
 =?utf-8?B?dnMwalYvekVDRVQ0ajVweEhlTGo5TDdvUFlqcnRIREozR0UzUVhEeFJOVUJ6?=
 =?utf-8?B?WG16QVBPdzlLbnNlOWFpdS9LTE9tYmZjZG9BVVZqbGdLL2x6d0VVZzBDNXI0?=
 =?utf-8?B?Y010VGhaRjZrZzQ3TSszVWluZVBVSFRSaUJYdVZnbUVEekE2ajRQVzdndmEv?=
 =?utf-8?B?ZU1rcXR4OTNiWnlKeGdMLysvV1o4QkxsOWJMUThnVEdMbzNjL2NqaUFZQ1Ur?=
 =?utf-8?B?cHNqcEFXZDhqbEZZMkU5OTBVUVNQaGNMV1YwekMxSXVBb3Q2bk1zWFRvQmg1?=
 =?utf-8?B?b0ZONUdnQ3k0QzdpWjhjOVl4UWNyODRKOFZvUUVkYURzeitZVUpEVlRIejVY?=
 =?utf-8?B?Z0xZOWRNcDN6NEdJMFF4NEZMdGMwbTRHL3R0SVhmOFBWY0Q1M0dyTWtDTWF3?=
 =?utf-8?B?bnlQL3BzTTZPMFdSMnNVcnRTSHZYaUZ0d3BJclBWMjM3bkVwdUM5b0UrdHJp?=
 =?utf-8?B?c1hzbTBaWS9hSlZxTnZLaEdzZlRjL0wxcXp3LzllbStkTFE5OFlnVGhpVEt0?=
 =?utf-8?B?WGtiWU1hK1k1WkJzdllNeCs2ckRpV09YZHAxT1cxQUh3c2kwYWluUHhWbXJt?=
 =?utf-8?B?THhPdjNGL1ltTHpxdjBpNEFVWUp1am9ic29FTVFrTTk1VlVnenZ2dGl1QU1G?=
 =?utf-8?B?SWc2anB0L2RleFZQamhTMmE3cDF6NnZLUXdtV1VhODNVV1dhbVFwa1dCTUt4?=
 =?utf-8?B?N3l5YVVKOXIrNXY3U1hXdUUzN2p1S3M5TjNqaDBKcXZFSmxhTUtKV3JSWFlX?=
 =?utf-8?B?cGR5MTF3enRtaG91NGpLR0pJTjZNVERLM2RVYTFTckhuc3R0eDYvMzMwdE1G?=
 =?utf-8?B?bk5Yb01QM0tUZWZqbXplU2ZoRnpnNHJQeUJZWDRnYVhYVTg2OUoyUG93U0ZP?=
 =?utf-8?B?QytXa3RDbDJlZU5wK3lCdUlPaUpnS0s2b0l1NnFVU0lNQjE0eFpvNXhtNzlY?=
 =?utf-8?B?Ry8xN1d5RmJPbTJLZFBEQVhpek9KdExCakdMV0Z0OWJTK1NZVWtOYUxBQU1G?=
 =?utf-8?B?UnlvdytpeE1BM1hnMHo5cVVVMDRmRk8wN2xwTkpVOWtYa09FaEI5L1hXbHl2?=
 =?utf-8?B?QWdlWUNBalJ5ekVWMlBxbTVFSFJvNlVQRnVBU3hqcEdGT0JoTllXZjJPN09h?=
 =?utf-8?B?RC9XbE0xMERYNVBDMGhiMkE2TjZock1IR3JDZis5T2VYcXFvVEZ0MWZ1RHVE?=
 =?utf-8?B?TDd4MERYdG5zdjkwamdwWXFmMUh2cDJicDJScytVVzY1K1FTWHlHbTRvK1k1?=
 =?utf-8?B?dTY3VS9FaWlhQTNtYjR1VXRhekQ3SzFsSFVFZG5TdUpGMi9na3o4Y2taS25t?=
 =?utf-8?B?ekxvTVJzd2tYR25hSVZIdU5mTW1xMW5jcU9abmNTNmcwcFhtdEtwSVZTWGht?=
 =?utf-8?B?QkxNcUFTMjFkZVBMWS9QN0szMU44M00xWnRjUG9sWHlOZHhhN2dtWHNnVnlo?=
 =?utf-8?B?MVhyYVNNdzlNVmtEL0NkSW5Sd3g3V2xFUUwzMml1c29yVFdOMTF4SG1CWUlX?=
 =?utf-8?B?dFFFRGEzakkxYi95eGZ6M1ZZZW1nQ0UzL1J1Z1BXMS8zcXdJY1dUT2FLU1k3?=
 =?utf-8?B?QTVxeFlMb2U0T0VSYTV6OVRNZlJnTlNiVUxOZ1ZKQWcvamdkUzhkVEhsOHI1?=
 =?utf-8?B?RDJmS01HbEVYQ3N3M3VDTFBrK1g3d2R0dkovUzlBMmtlVG9iYk4ySzY0ME9P?=
 =?utf-8?B?TzRJVy9xeWZoT3hrU2dBc1JNSDRmNXlGY2gwbjVWanNwSEhzRFh2cHY2eWR4?=
 =?utf-8?B?ZHVPZHFZWlFIWVoyV1grYkh3VEdjeVM5RDYzb0M2VjdsTDYvcUtLZys2L1lF?=
 =?utf-8?B?V3NPVmQ4aStHRW5VdTgwMmx6UWl3R1lZcFNVNWtRdG8zZElNaFVJOStweERI?=
 =?utf-8?B?WWpkNmVTVURQNlhwcDhBc3VKaXZIeFRwT3JFaXd6blhDaW15b1hhaWdwQWFF?=
 =?utf-8?B?aTZEU2FURkF6Vk5LeVBYYmdFc0ZzbjUvUXJ6WXVRMkRJQjRNRTVBSEpGa0tu?=
 =?utf-8?B?djg4Zkk1TXJ6dXhhV2FDdlBoeVNuWFBVc2FwWjhDWlNmM1dEWVlkWHlidWFx?=
 =?utf-8?B?SEpJbGY1SDJCeENzTk5ITnJSNmJxTWVXUWdlMUF0OThYSXhISzhmcjBmTUJq?=
 =?utf-8?B?NEFXRUVJUlVhUGZ3RU15Z01WQzM0OG9xUm5TTnNibndqYzFmUENkUT09?=
X-Exchange-RoutingPolicyChecked: LO3sfiy2egfwNV1la9qvIOA/sErlXHcRKm9BZgPtpDs8SizogD4totc04mP83AcCk7XcGG4S70LZTDyi3nJyx4V3GfFDZTn75VnzhkZ19RydOf/LVQZ+Px+uaUQlCSB8Re7SHB8i+5flJHMzE0NVPiO4hBYEPz8a2aIwJokWbFSSN7ZH3A9jn8Rk9xuLHQyehMAAs5UoP+IjMLyJPEHEOqQYhsQXJVLYutT+novwweCw49tdz//4w4R1u9VH7Svo9jSxUwhNnhXXa+9gosuyxRZ2DARd8ejPe5+f1DODeG4qvAjbU8QQn8YXiSgpQa2H79cJrc1zSx2oehWDaDK2wg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2416bec7-fd34-4f97-e316-08df2a4ee1ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 23:57:19.2909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgliFHT7HPSxg4lI00B7VnFB5Qmei3ey5549i3iKZ0f8a+kGL4iNiGQ4YRO5hEW6MBnG2pTEK1vYrH/jZyAeGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1669
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA5NSBTYWx0ZWRfX+GoXqE5RYNAh
 PlU6pc0EIAWNIoGJsQ+ozrbbV8Lb404Gz+AdRbvSlz8x68I24Sm0rFRF8jdnZa8yRvgE3nD8aYm
 fXbwH+cFrepn4Bp78ye+9X7ICDqe9E4VZfZF79yvlu8rXnwgJM+Jd+iqYXJ6OGi5wgFvid1YecG
 gvZI4Md2nsRaz65vVbfC2h2wiYffQHzIg29n4WEqvEzMAq+5zI/Avnnr5fz9wNWQoF8BItmccgH
 LSLFShgF4H8jv/uw86RDa6C/lCf9tD4PIJD+22Q6G9QSSBLSg5RtTavEFkBntzPga/aQDLL9MXP
 SagkUu9H9VFCpKee8mwDXPLmML41jMsVtaeDmhnIoIfbRxuPY0sLU9RXCI/MtK12tLFrZUaS2Wy
 0u9qLULZq4/2BEaQ5qd5muUEd5GxW142A85g/bVAOQX9WyZn3yw00rObXl1/te8mIr8aUQjaa6i
 R3RIhIiuaSBSK11tk+w==
X-Proofpoint-ORIG-GUID: TTBObmqas1-HS-vm-0_YVUa5K3l4miGL
X-Authority-Analysis: v=2.4 cv=Wuq+otfv c=1 sm=1 tr=0 ts=6ad0171f cx=c_pps
 a=UObrlqRbTUrrdMEdGJ+KZA==:117 a=UObrlqRbTUrrdMEdGJ+KZA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=6_mrDcixewTG61oOsKN3:22
 a=MvuuwTCpAAAA:8 a=9yoZTssRaaYa3L_QUNsA:9 a=QEXdDO2ut3YA:10
 a=Mdb9A_LM1Kuw_9yv7NEA:9 a=FfaGCDsud1wA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA5NSBTYWx0ZWRfXyAPNdwDZgbGU
 Uss+Rx5dJPI/POV/3U5gek2ewuiOOFrO7DrMIa36vj46l1YVFIfO0SiMuBsKBcLtevz0KeNhMk6
 onM0hXwJxc/Wmwv7ZaRNOAHgCJntPXo=
X-Proofpoint-GUID: TTBObmqas1-HS-vm-0_YVUa5K3l4miGL
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1011
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610140095

--------------no5m5Djhh0J7lHWmPqS3fEed
Content-Type: multipart/mixed; boundary="------------dYOgZXrZXh0CPmlt9t850X1J";
 protected-headers="v1"; hp="clear"
Message-ID: <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
Date: Wed, 14 Oct 2026 16:57:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: eric.davis@broadcom.com, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>

--------------dYOgZXrZXh0CPmlt9t850X1J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/14/26 3:21 PM, Eric Davis via B4 Relay wrote:
> Ultra Ethernet defines a reliable unconnected transport. A queue pair
> sends to any peer in its job without a connection, incoming traffic is
> demultiplexed on a JobID rather than on a connection, and what a device=

> orders is far weaker than IB or RoCE and varies between devices. None o=
f
> that has a home in the current uverbs ABI.
>=20
> This series adds the generic half. The objects, methods, and attributes=

> any UET device implements. No driver is part of it, though two already
> exist against this ABI. A reference device model that implements all of=

> it, and HPE's Slingshot driver implementing a large subset. That is the=

> argument for ib_core carrying this. What is device specific should come=

> from private interfaces per vendor.

I'm doing some cleanups and then will be sending our Slingshot driver
for initial review as a dependent item on this patchset.  Look for that
by the end of this week.

Note: I dropped linux-kernel.  Unless things have changed, they usually
don't care too much about the rdma stuff until it's time for the merge
window and that list is already way overloaded as it stands.

--=20
Doug Ledford <doug.ledford@hpe.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D

--------------dYOgZXrZXh0CPmlt9t850X1J--

--------------no5m5Djhh0J7lHWmPqS3fEed
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmrQFtwFAwAAAAAACgkQuCajMw5XL90m
xBAAsMV1G1ZW+Bp7ZTeF6w6Da/yi8f/RWFPdLoPdl98e0lGVJI1UvLwD4Fj7kFQlnoiiUsSDbNrU
TthxBwD34B6R0By2FyRpm4EidZqR12kGbAmSLrv1c29UxPapZMZHJCJNJXDNM5HZbcg22rIV1Czn
/UV7Ao6N6D42OOfwouueog8tDN+xN6iApG8e2qS74sExU48QyMS6+xYFZFggtNxxKtT0qXImjKxT
45wEjQA1IIT/C9n3xCpV0wJSOI3l+NfxuYfprEttWxRcZERqe6j+JSnwD5A86d8T/+F8g12nT9HJ
hqMRBKKqpAJOhW+L9MoM/Iw4p0rTrxQEKP/E8XP+aD+TaTy5d4aiTzlkv3WkPogQ5GEWtaTCHWpn
//7cN/VbCGqdEsk6pCy4yF+B1eBJPnoaTS2WK1ANNIG4DAMHYdJ95GPf6vZdO1kIxxklTCo9eabe
L+VSAyWzRCv4z6YBUaOZLScA3u3HgGKD3D0g8BxsztwAQnnT20wwy56O8VJdruU8zfWrhSpjiimc
+PUbrZ+yXmQhrQF4RmsrnCZgjSzXtV3U63EN5gNU4QO8gB8rtMmQpJuqf84cwVRW9feP9QhPyNcE
aqJzNZjJGdJJYlwjaTMTdVYD6Z4zqzjCE2ZX7PZY6NzfYoye95PCtZEdqO05K9/8SHigrQL2UF08
spE=
=oeuj
-----END PGP SIGNATURE-----

--------------no5m5Djhh0J7lHWmPqS3fEed--
