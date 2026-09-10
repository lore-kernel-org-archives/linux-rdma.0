Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F4353ECE8;
	Thu, 10 Sep 2026 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789060175; cv=fail; b=Ordf2EIq93z9WojBR48FUB6hSoDCW0hmQwqvQzGhCU806zsTGHC7IHnnTWuVQWUGGR5pCSfXkykbRs7ub9UO/omiJicj/X0ctNZv6de7CIvQjzmZGWQD7ayJn/11X4Tb3bWn/NCRq7UitYo0p/2JtMt1yU44kjDOJbKUo63t5DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789060175; c=relaxed/simple;
	bh=jX9Yc/cTX1484g1EIp7kYixrv9q6zQKaGQHghP7u1HM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=afsHmYwm9w+ev5Nzper4qxnev9P7scdpD2gA+XBGaDe3u8yyEm8AeurT+w9YJ1+3lVxqr9cXUz3mheGCQ6yMNY3RpKALJkff0iHW/BHfhOTjF4I4OpbmyafIuMbKwCqxE8GhNfF8ftUgviT9gFLlSlp2mO91V8aHlqGT6vZKYTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J7JGBhYo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uDysyygD; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J7JGBhYo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uDysyygD"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AFuAQu695744;
	Thu, 10 Sep 2026 17:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vo+SXoU69Wr1nU6TyuT2CjZGpUqi+7reso16xETvsuE=; b=
	J7JGBhYoObuWpv6l7+/OZtqtf23FEAoAqCIAXjIzVofGpnIcNKFdAUSnY19zmdFg
	DL/mTC27f5chwrHE5WCgtBgfVyw6A0q2OZC7VR5AVuZ8Z9BDJlcv/jxlF9r+xkkE
	qRnfsyuCZQA8Aol/p70YZ/wDApkPUtdNsQCBwlY4tYz7iErTH+UwOl0KroYoc9fu
	oD6KLVjx3ll78vcL3p5oXBz0Tsk1pVJZ8IyUDsvjyH/9arSy4zzMeMnIVpe0lk4m
	FsQBxxCLhJlWfiYyio7+/3Cw70gmD5a5urqJ2+JRxUF1hwPKLvKAF2uPwp4JWZ+n
	PvMyMUymgSC8qRCJBN5EAw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gkcys9mp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 17:08:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68AH5QKg006920;
	Thu, 10 Sep 2026 17:08:55 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011062.outbound.protection.outlook.com [52.101.52.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gkrjsaua7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 17:08:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXggSOS9Y6Z8TvTidMGxNuNXNuQOWlasqFmE8+St0wQZwaBASsHTpNFXS2fA7ZPxmyJJee3ryzhBN2elCEYKahMKEtzTb6OLnUoioXWum/aofmYq3zzQQvimfa/7gnDDibXSmEIr8n1C3jVVtYv+8SWN0OYFtRxxORSG801fggPfTHPp78cP2UMmz7v4cumFHm438/6AmYRWKt+4c+YPGDnN15geDmyx/jIghQio8WMGT1cEc5l0PCLpwIv8G4sehSJjAMhanFlnIzpSww5DO5aHsYTbaa+fwesEXHQs4FS68VW2rYUSQxQkwR8OnC3Ta5aPeAWSRtWupJWP7PXQ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo+SXoU69Wr1nU6TyuT2CjZGpUqi+7reso16xETvsuE=;
 b=R4V7B1zRPZNx+0ZFT1SfZSUIwqQWIpnlkfevXCoyF/96KMwnhaIgUK6CdIzqGS+BG6iI7TZ425NzY4ktqcVsXwF1HRuFA6DSfsWD6VFjD+mFM1a+6yi0EVPAtiBJphFiw0VbqQo0KkKM/C/KQ9/cdkfGlcMjcmroPwPwS0Z2icdRhB3qj/znIRi7r2B1z+9urgsklKvdIJA1SbjJUiSRfi2hN650UCMtmKWjol9lFUKKbqLOYf8KF1X6VVDU0FsVuh8SY0/RjHaRvp8O8P7QrCdU3fwIkMa945Vzgp1xJB1FoG4tzCJP6QR8h2PVi7ZWqu66mHVAj/GaokoVBiF1Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo+SXoU69Wr1nU6TyuT2CjZGpUqi+7reso16xETvsuE=;
 b=uDysyygDt5HD8Y/H3WGIgP8kxh6gCSBQHXGllVSjsBf2t4SCQZllplNREZlXyRanDUMaCe0XBFFhaXoS6+w9oLovCNeTzWQ49t60Yt/c/CypRfiIKO0j2IcDY5CEvsqTuMhoTRGBwAeZTxYsvekVHjvtAauBxClFpexY3gLhRqo=
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by DSVPR10MB997963.namprd10.prod.outlook.com (2603:10b6:8:3ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:08:53 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0428.004; Thu, 10 Sep 2026
 17:08:53 +0000
Message-ID: <a4b5d873-4746-4e36-ae15-c45957459fb4@oracle.com>
Date: Thu, 10 Sep 2026 10:08:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [rds-devel] [External] : Re: [PATCH net] rds: ib: use
 rds_conn_drop() on protocol version mismatch
Content-Language: en-US
To: Allison Henderson <achender@kernel.org>,
        henrymei <ljp1205831794@gmail.com>, netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        santosh.shilimkar@oracle.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
        Aohan Mei <henrymei@tencent.com>,
        TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
References: <20260908123356.1163970-1-henrymei@tencent.com>
 <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
 <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
 <2338b4729960abdf0c753d39cb3b7056421bac18.camel@kernel.org>
From: Gerd Rausch <gerd.rausch@oracle.com>
In-Reply-To: <2338b4729960abdf0c753d39cb3b7056421bac18.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::6) To IA1PR10MB6050.namprd10.prod.outlook.com
 (2603:10b6:208:38a::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB6050:EE_|DSVPR10MB997963:EE_
X-MS-Office365-Filtering-Correlation-Id: 383cce07-866f-4ef4-f933-08df0f5e30ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|10067099003|6133799003|3023799007|18002099003|5023799004|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	hYoTIqiF+Jb6k52sirpX0DLTe8z2yzPk9/wwzurST6LXK2M2U/VGb+5SmnockJgzxwm7omowmuwNdS7HTdjQfRkRcpB1ix/oVdcDWN0rih5NH2vGEEfPysBq/yl9oeQYKUYVhhdjNQEixuUO6Ojj4yA8xIWx7lLZA+i3HOABv260REf/jq0XLN+Rr+nCyefJBRgaSpU4+1XzfWAnsy7ZEukoictS5OVI1vxMdLDhXXqKsHuK2KBcieKqEUkNkbFIJAsU7ymVe5zwVQcDfjCSvbv8GBag2PFjgON+9SL4fsXq6GPsGLn0lwCCGShZXS4as4k8B2fu4oIGXUUotpg4oklvpk5X7EU/lkW2uHDnlfeLZH+OgrKbgDBYllFjaAfjJkt11k1j7220g2v0yInsjX6KwyVSQQ2TgxFdE/5J7lWE/R/+TB8NNk+1FZsx7e+F125cWvMDq4svK6x4sU0tCsAkgXkedho6AjIXRP5h1DFcjDB4fPODRc5SbdPWO1twBcwN86U3Ue9Og1H4vzByj3ixx5d2oVTWme9/dRdsAoXmD1MBeLVPKZYtjsDSBnPa8qPWs8ReHBuU1n/GrXysFRYRJ2tHVAtKmxuE++MbKXViaU21OYkHvch4uLbEYawTzYChVTWGebjnXMayT6HHCefHXiN9jgzirBzBH5Dg1yw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(10067099003)(6133799003)(3023799007)(18002099003)(5023799004)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2xhN0htMnkwMjBNb3VFdE1TWHJ1YmxnVFUxand3TnFseDlSdDVoQUlrdHR6?=
 =?utf-8?B?R3dZbUNjTWMyV3djOW9rVDg4bTJGQUo5NjN0MXVnLzkwVWNoenhhbUlUUHZU?=
 =?utf-8?B?V09nb1NsNjFvd0ROQmNscVNYN05ZVXoxbUNacll0ZW0rU3RNRW84Q1RlY1g2?=
 =?utf-8?B?eEIrcTNEL3kvMmdOUFRuQUdtUzJsN2pMQVhCaW5uRXhxMENEZy9ZcGtvcmI4?=
 =?utf-8?B?L01xOEx4emNuSjU5cEFCWFBleGdUbmNPTjB5SDh6VmJlekRUWGxaaHY2QzdJ?=
 =?utf-8?B?TXN3bHRKamRibUF2SG1tcTRDM05NVHpyRVZqWHczOTROazJ3Zlk4QzNybmt2?=
 =?utf-8?B?U3RBdG0wbmtKcGNqK0NjVGhYbjRZWmRvY3R6cm9vWi9kaFZlOXIxS0VRQTEy?=
 =?utf-8?B?QzV1NUgzcVA0czlHdCs4cng4Rk02eVJaWXNMNWJ2VGdIeHc0WGN2WStrVHM1?=
 =?utf-8?B?SmpPRzVyKzNKMEtrK0o3bGIreDNraXBJc09qdEt0S1ppQ05BNVpsS2FjZkFp?=
 =?utf-8?B?VEVPWGVYeWFPdmlaVG9ENnBIaWNTS1IyUkN3aDhQMU84VHdCTmltMFhpUzQ3?=
 =?utf-8?B?MUMzWFdNWDJRWTZrMVJPTkpzN0o4a2VUNTFwSnJBUkhxMGtJVW5jM2hXU3hm?=
 =?utf-8?B?UTdQTkgvM2FoU0g4L3FlaUtXR0NFYjZPdG1lVHViNlB5VzU2amJ4d0ZmQVZ6?=
 =?utf-8?B?eDViTFdvWUprMHI2TnU1UU9HRzlVRmo5REJ2cWNqWkhTbjNTcW93VGlCMG9X?=
 =?utf-8?B?cTAwVng2WGlNSEdDRzNWdklNcVkvQTUyalBvdDVyZGhUMWRSeFZrRFgveEFY?=
 =?utf-8?B?SHZlT3JtWi92Zm5oeEpnZlVmYWJaVy9GN3UzWmEvbEhzUDQwWHoxamFjR2I1?=
 =?utf-8?B?cTJkZ2p3SW56b25GbE81ajQ1c3pSMWRwdHcydE9MaHgybzNTRVN2eW9MQlpv?=
 =?utf-8?B?b2Z2cFVIWis5ODBVcVdXT25tS2pZU0VHT3BCOEtWbnFOQTZCanRZUktNdGxo?=
 =?utf-8?B?cGJPNGNlb2JmVjc0U29HZmd1Y2JlQnRyR0V3cE9ZOVVkZWFhamRSSkZtdWFa?=
 =?utf-8?B?U3FGVGJCYklZckVGWEVJN3FzSTVzZE9ZUG9waHd6YTZCdTNEMkh1SUI1dzVh?=
 =?utf-8?B?SzVLUnBoRUtSb3pKcUpXRGdHUythZnNvMW9SWDcyOUh4VnJyb2kza0FWdUhD?=
 =?utf-8?B?Y09OTTIzSlAxQmMvL001RUp0aG1XNnE3RThtOERzNUpUMlBRamRWVnA5bHcz?=
 =?utf-8?B?R0ZLSGVoSlFGUkcxUzBQKy9DbHdUMDhEUmpzOUdLbGk4aHhXcTQ2V3hsV2ZD?=
 =?utf-8?B?N3JXWEZIc2x2bUY5SEhMOGZtVFdsUWd4V2RrbFdxb2tJWkZHZzFiS2pkdnpY?=
 =?utf-8?B?RXVmYzNoQ05MZERMN2thK01HdFlKTFJvc2d2MVY1TjdsVTNybDdFQ1ZsSWI1?=
 =?utf-8?B?YmZqU2JhS2Qyc1hwNzFBb01IUDhaMDlNQmZPMmh4NG9BYS9BSTdlUTlZRUtH?=
 =?utf-8?B?dFd0aVZlekVzbU5BeGMwOFF2WWJ2ek5TKzgyNE80Vm9FenEvWEl6bzVaVXpn?=
 =?utf-8?B?Y0NoK2ZIb0ZOUDkvcjVmRml0OXdiSXFoKzl1bGJsVi9QcDFSMk9pMUFQZnpU?=
 =?utf-8?B?bm80dk9SQ3ZWa0FZUzdnaThaY3drSUk3MEFRekI4YitPNEZYdStYTG0zZW10?=
 =?utf-8?B?Y0lEN3NIRkVCKzJGU21GUUUxOVJQOU9jL2tYTVFqbWNMbXArMXhaeU91VTZa?=
 =?utf-8?B?TW5vVHUrYUw1SC8rcFI4NDUxN1YyUExCUEZORjA5bnpBWHFsd1dEZWphWktH?=
 =?utf-8?B?UGxFc0dvUUtSd2VSTU94Y25DY0xzYkRlanBYTVA4OU1pdjNGMFlpdjVCdWox?=
 =?utf-8?B?TG9lRXI3WHB4WmwxdXdIMk91YTVPRlQzb0VtNjZ0TkRZNC84R2dROEt6elJD?=
 =?utf-8?B?SkFVTXkrbUFFYkFiRGl5SmkxUGRoQmFkY2ZGRGo1c2ZUajNIWktDQzF5a20x?=
 =?utf-8?B?VGxNd1cvUVMzbmxtdmJCMDdSK1FIMWxmZWY4N2J5dmJXa3ZwRmpxbGtnZEtk?=
 =?utf-8?B?b0RxMDFocXptQUJsMlhTODJ5QWJjMm5yZUs0d05NWFpxdXdpTGxIbHNVUW1V?=
 =?utf-8?B?UkFCQ1VLbzRxVGt2L050YkV6RjU3a1c4djQwV2ExUWp2UGNWemRvWFpvaHEv?=
 =?utf-8?B?dVdzdStvNXZ2bUFnY3FBU3FMczhpUU92QTRhZ042bzFqWENxZklhTHNGV2x6?=
 =?utf-8?B?S0hBTGxwdXVTYXNNUitYSU1oNmJ3TEY2V2NCM1E3K05nbWh5dEFxVmRqeGlB?=
 =?utf-8?B?dVhvemlLd1FKQmlpZ3RpWmFibWFaQWZ0ejZCWkM1UHdIM0ovZG83UT09?=
X-Exchange-RoutingPolicyChecked:
	RZvOlbDy8SkiPIkxcVAFlC6QX0lLqE5twPA5A+iomb7CkM411HFc1qAdld5fIChChOh24KiWoEedK7yv8allW8hzPBirB9nn17TKOJV1YTpVC/M7ww2W4s/w8c353/XDJCQxJcmAQ6V7hmIKHbelCMNd2Ul1tqfxR9KSkhE+fNIjKLMONLNn8TOS/DFx07rlh+psN8HI2Q0Jd8TjUonvCHKWKRJlppGYogVjVHrVLS/xDap8pkoG3d+zXk5ayCD+NLnddUPBSWdPjOPuNvS9iDt1eY/2cPf936ZZEVuc6kMOEWlJZks3SQopwQ0QqYmDK1xd8drLZjIhdUXrUKFHzA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+i2SDl7OemSmlMuHgmZxbTGornADJ8OevZZYVKOE+rnjaLkHRAQ3jZOb1tBfocYhCyN8i31Afu+JY4LOGy3tge0bUZ2YXCKqsfcUkCIPHof4YOIJnq+wrGute681GN+/ahrWeaT+7xx0qElS9V1eE0UX2JagFq/sbtsYuNFHv0/OjvQhPaJNLZRc2JchPevWfmqZiZvKeBSor2cgj/8Vl5Nkzy+cxB72NqnmXT16d41fZvwz+jh25xibduzFp43dqvmX+xNq3c1fs/G9vQT8XcCorHsoCtPLeYGMBp6APTm1C8BT0j8MgNAea6n05PaJx5dwKEoLhHYu9k7R4bQZmf0rMFXtAIdmJhXdUwZhikZ2WDHkmlSQ6riOf82noIdqa0S+7M2ZmAuWKP6gpIDfGDKkSUihDwgdlj7Fwmmkvp/VdFOYSOAqPIunfWUQOja/cwYCnlXejxnK0+U/rDDlMnberXvpbLHR+/oN78Ee5r6f/pqxRHtXMTIsMrV7dZH/C64HhiEXmqG5ep3JDnJPGQTSj6ZWC1mQK08p201cMIVL/GAHCY9wXVouqUaU6BNT9+v9fh8POJiwdK1Hdf7Dg3KD1RamBDD+UDUutRI0eyA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383cce07-866f-4ef4-f933-08df0f5e30ba
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:08:53.0701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+KdmFd0EjdJF9EY/hObQQobfrY5wcyUEQvyPM3+BwxfHqIjLztV42Q3gAWzjGxLNU90U4vgCJDd2ahoapM2jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR10MB997963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2609100209
X-Authority-Analysis: v=2.4 cv=KNfPn1Fo c=1 sm=1 tr=0 ts=6aa2e428 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=fY4sNaunltbptA8ZdI0A:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12106
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIwOSBTYWx0ZWRfX1oJq7BMGmMGm
 Uhtj54E5oiNTucHpbevezXxEUwrpxZweSrPVwizpe5hn/bbUXkyMUY4WWtjGg8QAUGdpfMIlFNa
 vJtZi+LHZH9+Ful40OszaNr/l4trzq6526XrtRis1dZUO7nlMnlIzyHhsJ0wFRmj5VMtKvOiD4h
 vhrMq+O4dva2X6NawkyltK4rArCfM46TbjtOiP6HpKV8h5/ULdmuvwo4FrkGgxITE1nbfyrDPZ2
 fUz9xtSZDhMrq3j1Wmq+zeMfu7Osuh103/N/gN+iTALkqhePZqzfytsZ7Tn6lIDupBvfYu+/gsd
 856x5i9UOOs/ox2jF+eGbCh+FRKLW0w3LxG9ANm1uHxXh1qB0XgWhJ+//praN5i2eJxiMEmrKTL
 gzqv30vJaHfFpYx8HbLUzoZEDlBNxBBXba8TM+gNSIzCHnOS3MRFxfzg0ronn73x3QUQ1uvWC6P
 EzWOgn2AOnFcBKAjmZm5cHnTMXyNeN56gx4AgCQY=
X-Proofpoint-GUID: HMzJuFFpdk5xsK0vHoO5agDHEoz7JUWX
X-Proofpoint-ORIG-GUID: HMzJuFFpdk5xsK0vHoO5agDHEoz7JUWX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIwOSBTYWx0ZWRfX4PVvgdP4MS9G
 jAyOamXzwjpTQPM8gGY/WM3+USWRXSjdmXWMzcxy53VetSnV/2Yj92IFT9iEHg+nW+cYAL92g+4
 RJd5o40k2/t6/HGTC3qjUPbNOLnFeWTrlCOXTfTfKmI5E2+DrpW4

Hi Allison,

On 2026-09-09 15:55, Allison Henderson wrote:
> On Wed, 2026-09-09 at 10:25 -0700, Gerd Rausch wrote:
>> On 2026-09-09 00:09, Allison Henderson via rds-devel wrote:
>> I don't get this.
>>
>> So RDS should just keep on retrying to connect every second instead
>> of giving up on that incompatible peer? Forever?
>>
>> The version number the peer uses remains the same until it gets upgraded somehow.
> 
> Hi Gerd,
> 
> You're right that this ends up as a ~1s retry loop.  While that may
> not be pretty, I think it's still the right call for a net/stable
> fix, for a few reasons.
> 
> First, it's already what we do for the same condition in the other
> direction.  When the passive side rejects us with RDS_RDMA_REJ_INCOMPAT,
> the REJECTED case in rds_rdma_cm_event_handler_cmn() calls
> rds_conn_drop(), we reconnect with the usual backoff (capped at
> rds_sysctl_reconnect_max_jiffies, one second), and we log a pr_warn
> on every attempt.  That's the common direction, a new node talking to
> an old one.  Aohan's patch just makes the rare direction behave the
> same way instead of wedging.
> 

The important difference is that when this happens, and the client
sees a RDS_RDMA_REJ_INCOMPAT from the peer, it'll downgrade to
RDS_PROTOCOL_COMPAT_VERSION (3.1):
An older version expected to be understood by all RDS modules.

And thus the connection will be retried with version 3.1,
and is expected to be accepted by the peer:

Function rds_ib_cm_connect_complete() explicitly exempts
RDS_PROTOCOL_COMPAT_VERSION from the rds_conn_destroy() treatment,
but allows the connection to proceed.

So it is not the same way at all.

Before this patch, a version 3.1 connection is expected to be established.
After this patch, there's an infinite connection retry attempt every second,
that'll never succeed.

> Second, rds_conn_destroy() doesn't actually give up on the peer either.
> Nothing in RDS remembers that a peer is incompatible.  Destroy frees
> the conn, and the next rds_sendmsg() to that address either reuses the
> socket's cached rs->rs_conn or goesthrough rds_conn_create_outgoing()
> and rds_conn_connect_if_down() and then connects again.  With an
> application actively sending, that's a create/connect/mismatch/destroy
> cycle at the application level.  With an idle application the only
> difference from the drop is whether the retry is timer-driven or
> send-driven.  Deferring the destroy to a worker doesn't change that
> picture, it just avoids the deadlock.
> 

I can't follow.
Are you suggesting to ban an IP-address / peer for life?

A node can always retry an RDS connect, triggered by a sendmsg().
Much like a failed TCP connect() doesn't ban a peer for life.

There's a big difference between an application trying to send data again,
and the RDS module itself spinning around every second and re-trying
a connect with a version# that is known to be incompatible,
and thus never succeeding, because the fallback mechanism became broken.

> 
>>
>> I understand how the rds_conn_destroy() path is full of bugs.
>>
>> But shouldn't that just mean those bugs ought to be fixed,
> 
> While that code path does have bugs, making rds_conn_destroy()
> safe to call from the CM path is a much bigger change, and one that
> should probably go through net-next rather than holding up a small
> fix like this.  The current code hangs every RDS connection on the
> node the first time this fires, and a one second retry on one conn is
> strictly better than that.
> 

It is not only the infinite retry every second that's of concern:

This change also implies that all RDS kernel modules speak
the exact same protocol version.

I don't see how that assumption can ever be valid.

Because after this change, if versions differ, there's no fallback to 3.1,
but connections won't ever get established.

Thanks,

   Gerd

