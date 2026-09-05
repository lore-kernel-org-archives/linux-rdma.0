Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF87E105;
	Sat,  5 Sep 2026 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788627656; cv=fail; b=YM2H7YTbhgzkmu/CDKFFRCMPGxYN2vFzYp4wyjnY5dTnG7aAldMey/He54M4yk/NMnV/0KfociSGGAsu58yhrAxOML/xUL5ELiKatrwAcMFkfpPI5Dm41QpUwyhOxnOnR4TnWzFmqLioQkN8xKMu9XxNx8WzlY9cl1mQt8Fbrzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788627656; c=relaxed/simple;
	bh=fXUq2e641tv2RGcCj/lJytFOFKw09LIYc09UZMGDFEM=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=JVgA66WnJchEThR4B9bUHbrh95emEuplwxdWeMxNAZji60Xwb3XSZcWxulsKbUWVM1wqMO5tjr+UJB/p75Y2IyjgWvylmYYiqGTFivFKv9ZlL0V/6sNFlxl+93T4Y26UCTv0BjmO5E9pVtOMGUacIv0f2vUU9JScsFka4LrHkS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=qpHONwz+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eKtxUn/8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qpHONwz+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eKtxUn/8"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 685GeRsA1914495;
	Sat, 5 Sep 2026 17:00:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:message-id:mime-version:reply-to:subject
	:to; s=corp-2025-04-25; bh=++RIvOuBxq7hwYXEbwsLVgVcKfiFPWTaHGQe8
	UB/VTg=; b=qpHONwz+P41WD0NfwdntwhSJykA+4yb999btHCJX+cI+V/td0zwDx
	2p69SifPnwiWo3fPlaA12iqsAl2pv3CiRGPbs3izYg0aRoTApLWP2wUJdLk3qIAq
	lx9A7FWGI/GY55Y76x3GwHzrOofvEuh2u1eoFfUx97iJRz0LrlQewMJGhtXgnOF2
	T7omu1wF6XYEpb+JVYPkUp0Uj8PKzAFNY7XDwTW/lQrOwOh5fM6do0Zzu3pckNU1
	0h/M69euX2aFo9cK8Ri5+AnBfcO5K7dSOD22OFvfj9G0DGal7/tqcsQHWz4dTXxt
	btfoEx2opefa2f/S5uDqDpLUMjsFWCD9w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ggbh08bjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 05 Sep 2026 17:00:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 685H0R66012381;
	Sat, 5 Sep 2026 17:00:51 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gg9hmunn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Sat, 05 Sep 2026 17:00:51 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dtI6j7wTVsKDwkjkoiRTmGopVPDX4zsxfbHUVsMRpRD0mWJiGHA+uo4h2H+2rIRok2Fr592ZIAGC+iHd7L0LGQXx2Hmjc5bZXK3PbDGuOON0jxwc16d5u0vZObXqo2ydWV+vCYMKyTcq5enpKZag7lVbKmUxuRYpt+Zu9Mgl4ABwRJLQtEolG6HEcdlijNEJABdiDhMj/kpVUkNwxnkaLDKwuWuSbSSdv5TlC+tboIIhE1xc97Owit0j+U9qgNKFBXtusLcpt2Qc+QcjuSB4eDVUKs7YvYHffho393LEDqc7cnp6xhG4dEsP+/Vl5l/gNmMKyNgO9mdHIGxItnxLCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++RIvOuBxq7hwYXEbwsLVgVcKfiFPWTaHGQe8UB/VTg=;
 b=rbS+IXhVxQrxBzNylTVHxKUB0DHM2xt+pcH1pdpIToIiJLdnIwWTKHd5RcvBkhk6aYB1sQj27CEYL+wRfm18Gp+yEc5VcMv6X+hulAE1qNpd96Hx5VWR1tr+jaKsEGd9VauV6QjmXkCym7auNK8CP1bBW+7nRsXLC9fT/vTR2OORQYI2Gi9mL/BzQj2dxlyby9jrhM4z3vzGG1iwQMPlG8/dZGq06AhQbQALPfl8on+rIfSTDUbL3GvHy8Jwaxz7aP8goxqsjeBxJheEWDNm7R5hE4BOVSRMLWGz2KZbSH3O1htkkV7O/L+tCVX24ZVJ1Z97XyFlz5gT0IJ4n+AYIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++RIvOuBxq7hwYXEbwsLVgVcKfiFPWTaHGQe8UB/VTg=;
 b=eKtxUn/8gvn2NNEYDGLsYXPIRoh0WC6RFGiD/skAJj6a6QyYKdcm3OcC1f1PryuaIq/AdEnQ2GWDD9eq2ra8W0kaBCodsWyoW1FDSsnRv48Th5zckUiHNdzs16pZMPHXCwWlj7wj5v1MW64YnfHKBa9+KG+UZlzBNzrAwwUnlX0=
Received: from SJ2PR10MB7560.namprd10.prod.outlook.com (2603:10b6:a03:537::15)
 by IA3PR10MB8345.namprd10.prod.outlook.com (2603:10b6:208:577::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Sat, 5 Sep 2026
 17:00:47 +0000
Received: from SJ2PR10MB7560.namprd10.prod.outlook.com
 ([fe80::474d:99c8:4b0:dc72]) by SJ2PR10MB7560.namprd10.prod.outlook.com
 ([fe80::474d:99c8:4b0:dc72%6]) with mapi id 15.21.0406.002; Sat, 5 Sep 2026
 17:00:47 +0000
Date: Sat, 5 Sep 2026 10:00:41 -0700
From: Greg Marsden <greg.marsden@oracle.com>
To: Allison Henderson <achender@kernel.org>
Cc: kuba@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, greg.marsden@oracle.com
Subject: [PATCH net] net/rds: fix tcp stream corruption with large pages
Message-ID: <apxJjxvStibPI0AS@oracle.com>
Reply-To: Greg Marsden <greg.marsden@oracle.com>
Organization: Oracle America
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PH8PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::9) To SJ2PR10MB7560.namprd10.prod.outlook.com
 (2603:10b6:a03:537::15)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR10MB7560:EE_|IA3PR10MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 4548376d-c00c-4551-1dcb-08df0b6f3b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	kfOcFGTaOFMN9CI43fKk0+QwNrp54y6JUQZrI5Gu69RIihdJN7sV/g4U8UXVDXfd/BkFFCJcWN6rHzCdHTeRzZ73y0bp7Nf3fImJpf8ZYRGmVX35uZonnebJUCBS4Q2k8w8nrFQ8zdNEmRHb/EYJFKafcsDdgV3zAN5nJmKyCMNomgBDHpEXz8sIxs4pNWL/Dh8Oz3JWxrfnJ3uicDUVF6p9oC/laJbC7c166mbjYJJQMEXK+bTaiWGLFH/JkqgHyOdOuRihCdjNCZiBuUIGYd2+F9LCorrqqYzphravmowvO2xh6b2lZHJ2nV0Q5CmVPsOW3I5t89kg4lR32KR6rWezc9xcnYHmNL+/dJnUWYwnxMzHHxBkPgGfL/Rufd0aGxUff8eu3EJUMC2rz6DHWwfBTk1zZCGVF4jzj55YniVOpbta6Gywmbyy0hdEu3k+uFRL8ya48zbf86ddzcza+WfQxD3J8qMFufSC17ozMQZQ0qhweNJu4ZmCvEMjrxWMcoDOQxpJvjYf/VnNxFQ1jFW4bJSdFuySYJlBz1mqQx0oLfSXlrUARCd4rbB6jBYRnLPD11vrca67kG2ahpcGc/fbu9ZQrrolyAxdaBJfjUk0GVt98SFvRO5V7Vg96kphXqbw4eXc0rGhXxHmfu/RQZhWVO8UyVIXdEPz97XJVa8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR10MB7560.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AbpkIFGV8klheqElab0dabzO61o0srx8Lcjwc2se/PDOpgGFHu2HmhT8D0fX?=
 =?us-ascii?Q?vyVjN0KKB7lJviNSE84VGCkK0kzxIaNZYmf/hnbic4pgBNaehmHIKIS+s1ra?=
 =?us-ascii?Q?2VggWO8ku1PpcbciN/9UM1X86DrZkOD1nl1skqF+taLblOaYBcApvyYFbLbA?=
 =?us-ascii?Q?jRbRLQ0B30SBSYphN7TnPtxE/sPxOLRYL7h3PrkweNVO11dPmaBOaJjlt7Y+?=
 =?us-ascii?Q?lU9gfVQNoY+xs7QMIDsfVJK/O13WLzwr+KXO2A3XWwKoWlLyR2bKkWcsw42g?=
 =?us-ascii?Q?9HOI/dkBU9shsVkm0Q8VN8q21oQsYs1MkjboM5G4YlF8YpvH03LaBcEQxDOg?=
 =?us-ascii?Q?WtyRf/hDMlGarj6pdQM3lN6lSWpTmc+pJrY29gdRaJrG6g8lt7zTbw96rIfh?=
 =?us-ascii?Q?272ZgMw9LT2PLjKc+Vz6lpMPU/F53/zEQq8XAIbqsLrIL4erRnU/oDz4FPkZ?=
 =?us-ascii?Q?rSmNnsRrzZUuDzuljDHym9q6xPL5idXsps5mjLZVRsL9QcJ/OX1XMI+PmARw?=
 =?us-ascii?Q?xxlfpz0zFbr3STCD836D9r7TcIBVqWCeivyxLfkA+ZiduDCUhZeS2Xb6YjgF?=
 =?us-ascii?Q?hzzRXV9o6mhbpD/AeFmGoMMwKW3is3mQqQq66LdOjhJncwgjINEK/po9ZMCQ?=
 =?us-ascii?Q?ENfavruKkzc+EFA6UP+nLL6Sl9yg1SviBaB33CMsbMawFiGylP8ShcX3Y6K3?=
 =?us-ascii?Q?UTRUoS2Lsz0+CxGYPaioZ4jhT11672aDzRUNA3BQwebUqNmqNTKDfii3z2a4?=
 =?us-ascii?Q?WyPxyG690SzlYo1zUif/ftbjFR+rMS8GZ19JNuvO8o56nn0bv4D0D8+zn+q7?=
 =?us-ascii?Q?zhfjrWlVjR6Dyj7YsJ6KzlbnASO7BfUGQgnxYgYXIqFxbbLTAgdBinj5ZXd7?=
 =?us-ascii?Q?QUPuo8JoR++i3z0Qnpg5mXRSNKtHlz1wWBRT0m5LFKCu4qZNDy4yhKxAyrUB?=
 =?us-ascii?Q?nWl6NyHfzrZHZju21dy92bVVB7I28ZmQu5VHh3xyCHZJthPnakH2IdENDRwv?=
 =?us-ascii?Q?vElkVmqhDH4St+ncnB6B6G7zRyd4B7Lxeyaj6Bju/VelRYlrpIoLfiFPhBvt?=
 =?us-ascii?Q?kGsyXsdGZ2HaXLa8pBTUQ1PJB6V3mXxJ1Uxzjhbpx4E3r0zAST21MjgfJdCV?=
 =?us-ascii?Q?jqEg6IrFVbgFhZ+4yNRE2lnfapds4VsGQGaB8Jlo9r/JvnyHv+lcHN0ixuc1?=
 =?us-ascii?Q?eV8m0tdRqyZ6JFwAIQJrqMC/WTSmwOcu9cfiaWJRSAe8Dhl0rxfL4Q5ykhst?=
 =?us-ascii?Q?dyBXLuVjxJ7OXT9slIPa3KduTOxIwvIzmWN58rIeWye4/TVeYT1U6B/Xt2Md?=
 =?us-ascii?Q?F8u9iEK6eW6biiXrVn7+HIGDUvYd0tO/1Iq8Zm5vaYDzwrUH/+Kcyk1ZzS0X?=
 =?us-ascii?Q?j77udfnFej3eW13Dm7YUjEk14Lv3QhhTLz13rtK4+6n/jnIH9EUFDL2G3Cye?=
 =?us-ascii?Q?1etFszEHqynoZVUiOZYdHeI5MyOGeJ42WsR4P09jaDYv07+yRCm04tzrNBsq?=
 =?us-ascii?Q?pDzo7130syQjtniNCTyMIGRIR9GGSj5sUSwFUmw11qRX9t+rB+xAxXRdnRPH?=
 =?us-ascii?Q?zEK3v0rkBv9rkE4eRJCBFf5mRKPJc8cQ2uX29KwM28JY0qXOkiZgHxtiF5HI?=
 =?us-ascii?Q?PHJOB7xmiwfSFvgjP75Z+ZeKn0Gje1xX1qVS/f9hY74+6znj5PAQIZoh7lMz?=
 =?us-ascii?Q?5MSL5lYza+rttWFoypplHC0pwU1AvlPvDAxZJw4Y3kfTwarMIVW5LGP2fPvN?=
 =?us-ascii?Q?gLYVbAmFVHoA55TZ9sLT9NVOG53u9I8=3D?=
X-Exchange-RoutingPolicyChecked:
	dwCMzokAGauHg5cCu+F6HsIPGnz1KDaUp0fGBiqfHWem+jyA7i5IooHAKMtXjHRPlixdgwVxw/GIpyvL266ChnDOigt4OF9dqftwSLcvrIAxe/cWCgosoGfpnOk7rhysa24whgEvbHcgfTAQQrDp6V13UMOpZmFrpTT4RigSO5eYg4dwu8f/X/gTv/XwpmwjJmH/tgxO9FW1Aya0ZXvddE2YKK/SUOiTqK1NDVAykCcUHrxFLEiPhCP6ke7vkCB/6dlk0dTyDUUsXm9nD/ja8smt9FGeECqE+p827HeGS61jFSqT7YOe5l4S5iWLacb9FwhuB46LnIYAHHlemdzbAQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3MPyFr3Gw+PUTxFV4Cc9NAHbLN69LC1ji3DJbvWdDJJMHWE4jNV72PCCkv3rUMYYXzB9Arn7leQYC6yx0eIQs1beLg6HxY0no46ZmxGXsPEM5bO5U3SYGg+RUrKDPRUihkMpWzyfAZoTJvimNsbZ3KeiXNUu01VV+OrYtWZoyae85Gy9U3/7XsAQ1PWnwnzTO/bX8Izo7xfSe1rk09LPlO24O5Ad8zsEc43SDuodRIalPeSD33fZ5bL2SV0OTvW940pC6uCAryFPpPIz/SWAHeOXhUdfCq+Sr0nqw4Ngs1LndiNujRoIEjMnCNWuSVI/GyqsCqGwuaVuAG6mineh8jUWGFqfpMaE4qc/JS/g00lRB/1DSBL251k5l2ruK3xANsjZ6UT17ytJgRHq3PH/J6sH5dt27+ZISDUxXpP38MjT330S9yCALoOQhdgq2m5r7gxi8jzeOOb97Et9dB7HimRDU3rutdcLJ4dIS0RWe6vyQww6s2zpc9KF0pLWzbcZ5MU3q+kv5hfEdJvBpHP/ykua80KVLuLLSdJNRlssQ7TEs2TfOjx3xCbZwPH6hvKezvc5jAa5E7OdtUsvgAGC7Gj4FiiPnLfz5RLf2U1MEus=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4548376d-c00c-4551-1dcb-08df0b6f3b04
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR10MB7560.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 17:00:47.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5M5UiPEQ0ENtmhnhDWA7ccU7KkVqUCpa68GqRufvqmhDvfohKBupipTOktw4Y1M0tk6zNYvaREO7TGXphLW8gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-05_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609050189
X-Proofpoint-ORIG-GUID: R-RYJ39rsQCJHQ0mLeXChR5KNk5aGZ-8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA1MDE4OCBTYWx0ZWRfX6l155i6jSM3Z
 rkLZaLxYGvBc8xEceuGsR+Xd8oJVogJf1tmRu6xCPmAIh1QtCmgFGIE61DhqTF5I34oTdJmZq35
 jeTw5npeRq9iAyFNW5HDKZfErgAEyvDE03qOnd8fpDNmkT2DAsCg1Q6y2c5Je/xr1vEap2mkd7i
 r9uDodFKqEJ/YKphuyzczMRhw1yD+3Q1YE8c53CU6YW69fxrVaSmziA9Rvs2QPLmxvvdMfDqUT+
 MJkYXruGBH1tMaeMaVJYatamuGma371tk0GJrQlNUEHLXXaLcoFVEqraA+lVn1NCsDMVj/Vs8hL
 YNWJFHZeNWYkjkbgH+Rw9L+RFAxa5sPe5L6K6MNcHTC1GmyzEnxSYNhh2r5RuHHM4qVfivb6foI
 Gfu1tCYCdGWRQLTqbZ2cBoiDJiRF0AGlfpfUrJ+QaCx67O5PtyFhPHuFf7sDh2tHsQ7jclPjP6C
 8RI1gryrtUuUfiDQ97Cytlpo6O/mstiUyVPrIl9o=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA1MDE4OCBTYWx0ZWRfXwv0GyErDxEzt
 U3AC+PygUX56sF1h8VNB30musfC+LlXzVU6VkgF/V2P+eWr2NWunE7HZ3ugWfgkP6ULXouRvXKx
 faLCTr8SVHlh72LKbgjYR1H6eieTq/si6pBJmk0gM+qrXyAQC1gG
X-Authority-Analysis: v=2.4 cv=GKE41ONK c=1 sm=1 tr=0 ts=6a9c4ac4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=2e55RR6_Xvg81q7HYskA:9 a=CjuIK1q_8ugA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12102
X-Proofpoint-GUID: R-RYJ39rsQCJHQ0mLeXChR5KNk5aGZ-8

rds_message_map_pages() assigns PAGE_SIZE bytes to every
scatterlist entry, even when total_len ends in a partial page. The RDS
congestion map is defined as 8192 bytes, so on systems with PAGE_SIZE
greater than 8192 the scatterlist maps bytes beyond the end of the
congestion map.  RDS-TCP transmits the SG contents according to those
lengths, so the extra bytes become part of the TCP RDS stream and are
interpreted as subsequent RDS message headers, corrupting the stream.

Limit the final scatterlist mapping to the number of bytes remaining.
This has no effect on systems with a 4K page size and allows RDS-TCP to
be used on systems with 16K and larger page sizes.  

The RDS selftest, which previously hung on 16K pages, now passes.

Fixes: 7875e18e0996 ("RDS: Message parsing")
Signed-off-by: Greg Marsden <greg.marsden@oracle.com>
---
 net/rds/message.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index f25f2592586f..47d5e9ab9b10 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -431,7 +431,9 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	for (i = 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
 				virt_to_page((void *)page_addrs[i]),
-				PAGE_SIZE, 0);
+				i == rm->data.op_nents - 1
+					? total_len - (i * PAGE_SIZE)
+					: PAGE_SIZE, 0);
 	}
 
 	return rm;
-- 
2.51.2

