Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686235C1AE;
	Wed,  9 Sep 2026 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974813; cv=fail; b=bcEXxStj615Jtp6/9z/hiTHueOYiza8tz2IVsNyMiKhQB5Cc+rn2NxPwAURuVSbrf7gA4Ib4gVlaF1O7i4hMiJDBRVLwxofsdS+n+a3YZMgle8vqgcFPA+6VaclL8YJZEOMUTry5QFYnBaVxxDa51o39e6p471AKdW+fRx1SSEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974813; c=relaxed/simple;
	bh=jo2Fb6ydIwevwNdufwLXbO8rXBDe0utNzTxt4iy6TCE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AafB2uYB+ongGdakWBZipx027UJjPf8TqY7jcFXzOEzc9eCEiffvsPRUbyb4CSNV8urHiifKRtbnyTQUWfR28QNe26OFyuHeQH1xtjT/o74rxgUluQ3Uuby3DIeDA+gAnNJvmFq654naHVpmX8a5EKSl4tzz5/M7MjSGtrjVhg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RfbkS6T/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zNi9z0hj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RfbkS6T/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zNi9z0hj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689Budte2027323;
	Wed, 9 Sep 2026 17:26:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OM3quJrlMXk/Q8AlI4vHVHQqeWOGjy9JwDDLqwEQdEc=; b=
	RfbkS6T/EU1Au9mzLMIhUe4E0NPwl9FXj80CtqfWT919tpYCHzfJlzHoxvOmVx9W
	jdAEmfTGLFcxq/wQ+27Yv8769EysKR3iK4t0ESaZOvZJ4JM5/ivhE0wre2ZC261j
	fpm2O2pRxa8eh/oyJefgx64ddKooaaHARCM5ZSD+w8h5YUiaq/IdUtkngEB9k5mo
	QcPjchUuDeNAOi5ndwCXtJprejDAfjgV3mXiwpwEAcK/Qz2TOJtOqfznblNFj0z8
	9Cp5Ox1lOYc8jIa9taHyW4lEkFXlCO5RZ/5HFrA9nfFEIfP2acyEdRQ4f/W0Zmmx
	QW08KMP5qnRZB9UEa8z4dQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbhunmf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Sep 2026 17:26:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 689HP17o004338;
	Wed, 9 Sep 2026 17:26:30 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gh74syff6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 09 Sep 2026 17:26:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TQZXuia7FX9++Ht/12d0h/JEzMDZRuxFYS4v+76Sw8gN0Mzx7HQwRHD3CM9vHBtV8nH42Sym7QKXxGyZFMqQAd90lgujmrERCxt22tHXmm6U/hqMMY7mCWJRlIzKLAI4x6sIg4kULkuX64oac9LisNOO9UEqJ1uj3cO64iA1XsXrC9uSkSeMsUxa86pNHAD/k9i5UrlpnRYBzITzlgrMSph4p8y8g3iSwSBAoL0kry8HmlnSX9d+zDU5JLMfYCPB6rCJ8BTix/6Tsu+Xq/a1xXhNqTvbMPkvGfuSAY54Hzs/N0zI2kuws0/8tY9oLr2ZvamZnlx6qnBNZpu4psfinw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OM3quJrlMXk/Q8AlI4vHVHQqeWOGjy9JwDDLqwEQdEc=;
 b=XASVuXcXtpYXyOcOP5JhkTpocS7ERpSx1dVMHyVEpzEC61nvXOBa+A3eDeY4NjHwA+psfTz4eGDRV0pbRZkWhlLS+zRlq+HVNiTmcO0NMDdstkof3QgujmlEh0wbIXGBPSWsg+gk/CwSa6a8LduraSc5ZgRk8G7fR1gjkfUb00b3jJVU2crp0NrpRCmPXQLMm1xgXsC2uP8Ycg34mZTVDP1MA6aEj9fqj+ROKB1CYekydC+WUFh18eB4x3Ab7N4R7kld7hIFRNds0x83wVcQoAT8F84HBqUzigHXLC6to6z6oY818R/8w6II+0QmwOq+Fp+jCJI2riVUzqv6DH5XYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OM3quJrlMXk/Q8AlI4vHVHQqeWOGjy9JwDDLqwEQdEc=;
 b=zNi9z0hjY13gzQ3I2vCnLws0vn+egFBomFsxvkhFtsI2jSXIax4DfZ/50XsAicbggMRNofEBRR4OHzA6Uvuv3B93Xzv/G/yVv9pJPwEytHk92KwU+yDU/gFzRKsEoOtSWFwW2oRUPW/W26HoydWj9R9UHrR/z5lZeCg1u5+yZXc=
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by MW4PR10MB6558.namprd10.prod.outlook.com (2603:10b6:303:229::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 17:26:02 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0428.004; Wed, 9 Sep 2026
 17:26:02 +0000
Message-ID: <10cf2701-211a-42fe-bb1b-c218d718ed2b@oracle.com>
Date: Wed, 9 Sep 2026 10:25:59 -0700
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
From: Gerd Rausch <gerd.rausch@oracle.com>
In-Reply-To: <4fda023c1e7152aee2d5f977f5045dcddcd08d8d.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::13) To IA1PR10MB6050.namprd10.prod.outlook.com
 (2603:10b6:208:38a::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB6050:EE_|MW4PR10MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: b4229cde-23cd-41ba-f3c6-08df0e976c04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|22082099003|18002099003|56012099006|3023799007|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	0SRwNiAL2gWPvcTUXSbHIps9qsSh72Bjpn1K0k+ElHBtdVh2Dxgo57u9eSGWBr3AiruvwxpUUDEiZnimWtZXaowhXMMyzydzP0MBsqJJ9UoKnz6WZ7bzY83ZMAyQqkcXnmSS4okTz1m6LPNsAY6PXur2AV5eoWtlC/uNb1PvAVmXFRa8SdRK0U5L4rilYIs3NueRfA5+kQLFP883tbVYt5PPHfVTDS1ZW1xbL3NdSgviEwSX0ZIUlk3AA4L1yDYCDa/JL1epDQWjZnYUnumCKmeFbvcFFLDQYhtMlpYfEJB/WrBD2lrv36zg81NjdreXD3otwaAXf8zbcZEAY2x1EE2q0xofjs0KTFxf8nGf39dJjILWv7YOQ4+Mma/kFFlNU+CnuecojrBTepFyEbntJAFwuNUbyKDqQpXErtZArSKSHewRAkFoOro4TI6xcWBW5Tur0SAvivoBt/0SZk5LLDMHaRMmqrn+B82c0O2Dytta4YaSTnjlOEimzq+XT6uCnmpMVnPSD2RWT9Q+n9QKnvAh/p5ApQnIWVZ1oDS4q8sChlQK2VSSIhg10o5EIayvzWjaf4k+CLMkspc54QWOMXeNzNO4mUKcEBiEYhwS/U1FhhoBKgXNtu3veEVa9XbLvLBoLuTs5c1hhv8HDc0GouU8cTENy1Pi0CNOPzSyCrc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099006)(3023799007)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1Nla2RDQ1ZKeXRLUU9yenBSZmF5RktmdEJVYmxjR0Y0TXI4Tk9HTVFCM3BG?=
 =?utf-8?B?KzlpQkhYYjRDY2MwWFF0Zk5jY0IyYkJPS2xpVnl1R3ZwVTZRcjJnUnZUVVBW?=
 =?utf-8?B?Nlo1MnJiT0hFeGpoL2VxUDRRMGRBZDBHYXY1SlJwY1VJK095cU1McEk2VTJy?=
 =?utf-8?B?cFY4OHlCLzRQT2x4dTdQQmdnbmpWaitOYS8wQXoxTU5QWlRsakhaeXJQVVhn?=
 =?utf-8?B?RUxHUFNmNnRST3BheWhEQVBLekVBZ2NzT3lYcHJGNlR5ckxnYXE4ZGdDdEg5?=
 =?utf-8?B?SkJSOGNRMmRLZG5xVTVRaHlvRXVxaWRrRDd1eGQyZ09Ob3pRUGIrTVp4N0xi?=
 =?utf-8?B?Z2YyS0Z3ODRRS0pLVFJjWGd6QXlVbWdlY2ZZcjJWNEt4Ri9WNlpWMGk5UkJi?=
 =?utf-8?B?Mm1WczdPSmxBZEkwbXE1emY0ZExHSUVZTmlBTkt6Y2hZNXZhOEFQWXhYVDg5?=
 =?utf-8?B?N2tqREIxcWM3cVMyRmY4RlE0QlVkRlhNOVFXcDYyL2VSbEFGc1RiQmNoU1h5?=
 =?utf-8?B?dlhYWnl1M0dCcUtwdTRVaEU1WlU2eXI2UmJDLy9tWCtPYWdEb0xPZ3lPSHZx?=
 =?utf-8?B?b2p5ZUgyaGhTQU55eWRwNEVHSm5ndGZDM3dvbkpiYkxwaUdTQXgzdFI4YXhX?=
 =?utf-8?B?R3NRRzlPUWdBRFdkY29tTzhBclBuYnZtbGJ3cDdWMzhIV1VXNGszbjB3MUUx?=
 =?utf-8?B?NEYxLzk4SGVCNHkzTHpBMVNZM1pyUU1EcURwcmc0VzJGdy91M0JUdi9NREdh?=
 =?utf-8?B?TmpGa0R3a3BGd2theG5mN0xwbmdEeE5rRVFNVVlyZEgvOE9zamdGeGNKNnIr?=
 =?utf-8?B?a0pXTDJQTGZaU0c2U3dQZmRuVmN2NXljZlBDMTEzd1k3cC9WTDFXcUQ3U2gy?=
 =?utf-8?B?UGxqakdUNjFiUzdsNlpmV3lkZHNwUFY3TGhSNW04U2w2dHpkc2gxaHp1QWEx?=
 =?utf-8?B?T0hWeVBnY1VpeC84SkptNFBHZlBUQytmRVJJbHF2cDV4b0w1TUhmMVl2cGtV?=
 =?utf-8?B?RnkrVVVCZkVvaEkwVkoya085UlovUFVkdElHOHp5c2pITGZ1OEhCOW5RZEZW?=
 =?utf-8?B?TzZPM1NuKzhnS0IrcHJTZFI1TnhpQXFwN2RoeUYyeEtOb2RGclRHMVo4NVVR?=
 =?utf-8?B?YmtmOGVRQkRYMjFTUGkxNW1KaFduVUtEZlpZNVJaUlZ6ditHRVZkd1JlNmRn?=
 =?utf-8?B?UjIxWVd1Z2dUNEpiZ0YrT2tMZk1vSTlKcmdIREpsOFF6L3ZJQk1kcWF1cy9C?=
 =?utf-8?B?YnRjbEc1ZTRWaHgvN3J0eTRzZVZJVUtVWDA3Qlpyc00yQjIvYzlUMFRrWDFR?=
 =?utf-8?B?UDY2eG1MMzZhMGY0Vm5OdFNobXV1ZHY4ZUN0T3Zzbnl4RlJjTktaWFpqNkhk?=
 =?utf-8?B?Y0FOMGZEWHNyS1JLUUV6QjlSektVQkJ1REJvb0RoN2dhSERuZmFlNHVCR0Nz?=
 =?utf-8?B?WXZua2RTYVpVSTFlSVRIWTR2NFo2alBBMWNvalZlRFlhZk9OdTBvN2t2TWpi?=
 =?utf-8?B?T1BTdTk5UFF3T1cyNm5ORjN5bDhCVWtXNUFOV0VBYjhKd2VobXpGR0s2THNT?=
 =?utf-8?B?dldZdXZmbWk5cHI3RDZZZVRhM2k4Qmx0Wm1xTzhwUVNPZEFyb1AyVlVwemMv?=
 =?utf-8?B?SlhGT1l4VmcxaFBkNlgvVVpYN1NBYTNyTHNkalN2Slo4SkFNa010eWlSL2NB?=
 =?utf-8?B?M0hDRlU0YW5TREdMU3BmbnQ5Wk1UWjVIUXRyVDM4TTlQUTQ1UHBmdDQ0OFRJ?=
 =?utf-8?B?WGg1c3g1UHVnU0RBbjYranNxdC9UYm85bFgxVDJKZFVENjJSWE1iVHR4YTJT?=
 =?utf-8?B?QTdWNHp6djZkTTUxTDAveURUcDE5YmlkV0Q1NW44QlNPcXd5RS9NRVNuMzRv?=
 =?utf-8?B?V0YzcmlTeG5NbEhvWU95Sy9IaWYzc28xWEhrdksxL2E3d2pNbzBNRVlKbHd0?=
 =?utf-8?B?UDhxb3R4REczVEJXZE1MbmtGd0p4U0F2QzdDajRrR3V2ZVZaMWpRbjdnMEMz?=
 =?utf-8?B?cTNJRzQ5Y0VzQlVMV0FSMXAyZllVR0FEVWplS3dtYlE5SnB0a2l1emNWTHYv?=
 =?utf-8?B?M1pXaG5QQUR4cjhZWVU5Zk1VMXM5N1RjOTI3N1RDK1A4Q3JOVGdPTlFndlFF?=
 =?utf-8?B?Y1pkMXBCWDcwVExpVUpJWng3M1NFV2Z6ZG9MaHQxb3RUWWZuN2ZzZktLMG1K?=
 =?utf-8?B?QkNMMjRyci9RRFc3Vy9lM3l5NXViaDFsREZndndzOVMybDkzeU5qVnNta0Ny?=
 =?utf-8?B?NFZCMHphSWxPYjI0VmRHN2pTVnJlOGRsY0VjbERrQmNoWFMycGNXUERmaElr?=
 =?utf-8?B?NFFSTjdVQXYvWlJBS3hWWVRubEYwV1dLZzkrbFQvdFVEczRLeit3dz09?=
X-Exchange-RoutingPolicyChecked:
	vDXR5m/icb/v0OsmOayPRdiCs2LQjeq/xM+8A6i+QULPDWjpR5eKNsz1BQzBZHMzwvEvTCQjcab1Cq96paesZBD/zzs8hzsWFwgk2F64scz6XcgqgslYAE1f5xUsMq7i4ncIWlYuLQYPobAx9dlagOCKansAKlCwKJnL7/GDaXlxZ1VAUHFVG5GaVzI9VfY+9g7jTa3yZXwmqET+rEs6spFcpGxg5pv4inC3wmraVRMku9aeJn/9qNuh7csOz9fZ5RD+K7QuA9tEkV3+fLuVaHMyL/m7NUNPrhm2mx0gQLwgBD1wsVkwENGFzAQ9nkUoj/WjgpDEpDxHN2T1d87jFg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZxTwkaZF1jwEIxsjSqsi72D+VOgqdxF52gAhEQfMRK3ENXzU93BVaigoBLQAcfeHvqkWWsVOBwvljsPyCpIJPdEYoi5RG9xTsRMYXvcRgAkqtl/mJiWbb/iWJA40F2H77ew9EStY4OiIEgyrk1bnmWtzFpOqClTAYHKPQTuata8zXgYzjrBotXS0UJGE6XqZObvH2did8xGVm9uQlIOrFvosm/fp8qYXg2QTS/Rdw1frzmg2rhbVNozAtNYFSnUQxWNyjVwj3ivuCRZNWl4osM0WKanosALzNle0nKfjCvo8S4XImBbc3LbeEQ7LSPZ+rp9oOUA5aIUlzVRnUit0imb3hT+ytL6i6ZJw4Ro2CgiMrVtqsWWtaVk3a5N0VqgtVKMwA3CX7GyXwFBYNJdaP7mPK6myKJyEzoUEOH2v+u0EF48CLEiZw3hYgCLbNGMx/jJuaj36CmlASEYrIQJwSrzxK5GnGW/sOYLyD5rrZPMdG7e8DVRGkzUaxVGOIPD4JOFIlBLyRAFUxQJuLu6NP8QfU/S5GrOjQ1G6mgH+lvkr2NVwCYTMGqVYuspTbzDZ+sYwliePzvNRRrtgQkOR05X6SGiMKDo5lEz1jS5uJDQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4229cde-23cd-41ba-f3c6-08df0e976c04
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 17:26:02.7203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KfhNsmZtuVOr0U4+opsg5V//cBXXcyb5AlH51/X5YmZCdYX+tuwWCfxCoAderTVpdoAXP12jfAuK+4sHutpeYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 bulkscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2609090194
X-Proofpoint-GUID: akaGVATyN8brHF4n_Khi0-TNz1sqLTpg
X-Proofpoint-ORIG-GUID: akaGVATyN8brHF4n_Khi0-TNz1sqLTpg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE5MyBTYWx0ZWRfX08Fb20Yec4uQ
 Nl/ykHHFHyoE+uyEtbHJVpmgYlHElrCovOYQdhHxYj7tdj+iSlBlDQvygsnFNoZ9dp/q95MZX/1
 NLYiHsd8eIjU41iEBmJ9rEeCsAfawLGj/tD2ZEnakS3NG6FnewCmAtuMcj8qzaXJaExfVV+8+Hk
 M0KpluxJdStmfSv08D7d4P4cHmZQ4sRMwN+ctrCS4NHlkgzqO+1bOUREq1x3FBLyYuccyh3/vap
 HHsYbAdTRzDyjxtjsgrfJPSnH9+jy9dRFAJ7O2i4/MLyRSQLXsQhOwB4+fENGelBNeTdBW5dGNE
 p34Nqq8/45iaigEtmSsjZSy4hRtdd8SKrKes7lNFAGug37O3mKzirUZtMsUUEjHjiJ1SX48TYux
 r5qd5ZE9crkkkYlB0aWhvWquBU2ePKudexQe7bxp9WowB8Bf8r2E+AQMwBtlpLc3Di1xAWcZJri
 qKY4+7pDBZkKpdaSwng==
X-Authority-Analysis: v=2.4 cv=S4HpBosP c=1 sm=1 tr=0 ts=6aa196c6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8 a=p-1J0zvc49KmOv1BP9wA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE5MyBTYWx0ZWRfX98RUJSkKRnt7
 CDl7Sd/cieL8hK2i/X3ERc4HhTqMSozErilzl34zYCbwW9AyzhQJyyjwYUoRPs0eX57GDgh8tET
 vPss9P0HR9VxzjXvsvHDO0EEpBdkeVyvlsq0Ns/SxQ4HRADlStoP

Hi,

On 2026-09-09 00:09, Allison Henderson via rds-devel wrote:
> On Tue, 2026-09-08 at 20: 33 +0800, henrymei wrote: > From: Aohan Mei <henrymei@ tencent. com> > > rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with > conn->c_cm_lock held. When the peer negotiates a protocol
> On Tue, 2026-09-08 at 20:33 +0800, henrymei wrote:
>> From: Aohan Mei <henrymei@tencent.com>
>> 
>> rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
>> conn->c_cm_lock held.  When the peer negotiates a protocol version
>> older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
>> rds_conn_destroy(), which is only safe in the rmmod path: it
>> synchronously tears the connection down and flush_work()es the
>> shutdown work cp_down_w.
>> 
>> That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
>> the very lock the event handler still holds, so the flush never
>> completes: the two workers wait on each other and the RDS connection
>> workqueues stall for good.
>> 
>> All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
>> DISCONNECTED) use rds_conn_drop(), which marks the connection
>> RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
>> it here as well.
>> 

I don't get this.

So RDS should just keep on retrying to connect every second instead
of giving up on that incompatible peer? Forever?

The version number the peer uses remains the same until it gets upgraded somehow.

I understand how the rds_conn_destroy() path is full of bugs.

But shouldn't that just mean those bugs ought to be fixed,
instead of no longer retiring any connection ever,
even to old & incompatible peers we can't really talk to?

Thanks,

   Gerd

>> Fixes: cdc306a5c9cd ("rds: make v3.1 as compat version")
> 
> Hi Aohan,
> 
> Thanks for the catch, this looks correct to me.  Just one nit on the
> fixes tag.  I think we want: f147dd9ecabf ("RDS/IB: Disallow connections
> less than RDS 3.1").  That looks like the commit that added the
> rds_conn_destroy() call to the version check.  Other than that, I think
> this patch looks good.  With the Fixes tag corrected, you can add my rvb:
> 
> Reviewed-by: Allison Henderson <achender@kernel.org>
> 
> Thanks!
> Allison
> 
>> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
>> Cc: stable@vger.kernel.org
>> Assisted-by: CodeBuddy:Kimi-K3
>> Signed-off-by: Aohan Mei <henrymei@tencent.com>
>> ---
>>  net/rds/ib_cm.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
>> index d46146887ba4..2909da8363f3 100644
>> --- a/net/rds/ib_cm.c
>> +++ b/net/rds/ib_cm.c
>> @@ -115,7 +115,7 @@ void rds_ib_cm_connect_complete(struct rds_connection *conn, struct rdma_cm_even
>>  				  &conn->c_laddr, &conn->c_faddr,
>>  				  RDS_PROTOCOL_MAJOR(conn->c_version),
>>  				  RDS_PROTOCOL_MINOR(conn->c_version));
>> -			rds_conn_destroy(conn);
>> +			rds_conn_drop(conn);
>>  			return;
>>  		}
>>  	}
> 
> 
> _______________________________________________
> rds-devel mailing list
> rds-devel@oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/rds-devel
> 
