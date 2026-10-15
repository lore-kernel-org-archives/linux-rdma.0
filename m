Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA89547063
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792026288; cv=fail; b=H0XIP97TokPeQ+BLPtL6u5C1fhMdbtdZ8D5obM+SCnj2PO/cJW1vMdgVjCWj8p+olXjz+zTwYflLpm1C60hq9Avl6rDw4B+aFbP/Zy0qf25JVHCF8cFkpFsXNN0L5tb2xkeKXf7dTjJynWqmWRgURITgWbFNgtUBARkRKpOaJJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792026288; c=relaxed/simple;
	bh=sPLA12iSYXUg7vxu/cRJhJi83SBy/IAv5zYZABIT+jA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HFs5hqZ2FvxCLoMPLTyL3hCMDP7IcK+dXfaubxBBN2rRIk1QpdrC9ggtROtEBnBekL5US6/LMYAE7DMRSRk0ikP2hq79xy6GwYseSfPSsUAOEutku/GsTzV9EH0MeYcYjC5x1zT0RXb7oAl4ueK0MjwJ8ps48LJ22pyOFcQWVGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=Un9SwYr+; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="Un9SwYr+"
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F0PkfO3350724;
	Thu, 15 Oct 2026 01:02:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps0720; bh=juFr2nifVSfnp0s5GPY3+vxyKM
	9flsVHsU+FU0f8dQY=; b=Un9SwYr+oTHnXzHZXdCWDfJp5DTmugVJbV/TFuUIX3
	YL7+pPI/1KdRDQ0TATDwV/Gb+eyUCcDkswiscHdwBcMlBn+h9TC6eFucvxJmr8XM
	xFkFZIjpqTtltxZng8WXX1mKzGRP0cxy+UGTupc8m6ZV+k3b9UEBrEqz8/aAw8ve
	yDdZXGBuqeICkpdpjbArbf0ruRK4PCcix01jJNQG2yOZA2o73or+kcIygnyM+KXT
	mZQdHSaEoVuSu5Mt+PR5YsygzzfvVwmZnQsjbrJi4Rld6xVUYrXbsEeuBRc+3Gv3
	TvLjoImlAOrZ1XMaUzi/XNiKVFViY2ogmdE3x4mzTP3w==
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4ham9hrc7x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 01:02:53 +0000 (GMT)
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id 2C32714783;
	Thu, 15 Oct 2026 01:02:53 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 14 Oct 2026 13:02:43 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 14 Oct 2026 13:02:43 -1200
Received: from PH0PR07CU006.outbound.protection.outlook.com (192.58.206.35) by
 edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 14 Oct
 2026 13:02:43 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKtEvG6BO59/EH61rPPnhPPKECZjbJD57vCHxY0jQ6sGv59QVQEqmTHnU2erVCQQ/nzPta36Qlw8ojmQ5hL+4cW0UxrzAmHt1mJcHdOREMwcKG7QLFeTRDc8kFvDwdE2oNLqmBsiZWNtNyoAn3oTbRpWEqVUy84j2zozuuywbii2td1kfZIy6nkSVTcl2IEkjQJISFgnOq8LRZuCoarXUkLWzWlsYpN4NdDE1OT9JOgZrNJxbWA0Zqd+Joby8zu9BNpiU8AKb6jCcfdiEgzHv1f+BTA6xAjB1N52YM/tSws3k8fvKwt5FkbJu8SVb/iDl6tnaaIG1Xjhjbo5y9rh6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=juFr2nifVSfnp0s5GPY3+vxyKM9flsVHsU+FU0f8dQY=;
 b=CeMdm+brDZI3sXp5JVCXqBWrg6NgCQTX/OG8JNEVewD5n6DDspbkJfcOUItXwN6dvkPrTL6N4dDtNJp1YUQSK+xAvj3lah8NxVN3hpSlA+6RwSA2aiKR7iXR5aTGnoGpXf9k6LAVedWki4F4SHZas3C+OzgyMHRdO7TzwfOnFDMEHFpwSO7HxOnAg3CFF8No6VxG/yYdlr4bwNK6J9WQP8oPsxnSAgfcseSGxLye8abom/4EHJXS9DK5gL7wjGS0VlTmFKHyHOohjzxlVTNnDN9FBo2fWjJyHwnNJ6cv/IGVqjZvaPAUwTcm3qXyq9LEj+v6LoyN48a51B5FqKaQKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by SJ2PR84MB3781.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:58d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.26; Thu, 15 Oct
 2026 01:02:41 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 01:02:41 +0000
Message-ID: <733df751-5e7a-4004-84d8-627320734c30@hpe.com>
Date: Wed, 14 Oct 2026 18:02:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <eric.davis@broadcom.com>, Leon Romanovsky <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
 <20261015000834.GQ14213@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261015000834.GQ14213@ziepe.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------i2YvFioyoJpzxaYNK4u2kl6v"
X-ClientProxiedBy: DS7PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::19) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|SJ2PR84MB3781:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f010f9c-e876-444b-d1b0-08df2a580348
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|261009223027099003|4143699003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: +1kNTfLs1cu4D126NhV7L3LrvQB6sMxVmQ8EQ/uQVWuNP5x3tuDCKIu5H5lDyU/zrnZ/d7ayBWYnq3RXJChvKo7HFAvf+/UwyweVdWaUgdeiyGEYn+RZyNgTa808yxTfo3sXBiVmu+J03TF9v8RnlsY5aOFc7aK0YukdjNPJ5GCEknHczvva7JCRX7JqacG8vOMuHvMtQokc005Dgc0W4xpHRhy+wX/ws6A1aXSkdjtuqamM1IdpO60RkUNGEzyJtJfldNqUVoPNnUW9tv/U1J4BpFlwsdK0RA3FjS8I8EIjmk1Yw8Z4K1KyW6nch/LL6N3SNbpGnu25iT2BbhI/6ViFQ6ATHEN1PzaCs6kQ5+KCc927jylsAQfC9k04ZKc3U0E1CQYNLhMmDBKkppHAGmmEwjvofCclQQIHw5AVQ3ojVQ6dyLEr7DX/lyoX0wa6aOoFDrGsiXUEsm1cbY/wOtotpDchDQrb4yftL0iZd88SlPO+MgFa2nV2fInF1Y8x+JaWkRm5NuFzY/VbYCouoG8Qq0ivg8XQS3Ba/Xn4Md0G/jG2vsY/sVPqhYsUJWBgFP0no44Wq/a/5enU+N6iOXjlb7vWduDViW9dNkx00ThNwcwVdDbBpx9mYTuTvKAtn8CMwQxcNoZbYtQtUuT55JNy42vpAIUvfGVhGPGeMTk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(261009223027099003)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVZIZ2w4azlPMmVRSjRzU3FlL1hFcDA3eUY3YUNpbnpOeWd3VGlXSU0wOXht?=
 =?utf-8?B?RW8wODZodnJBeEo5UzZEbGJlV2phdndDbDZYMlRyanRidm5yWUhEVkpNU1VH?=
 =?utf-8?B?UmhWMGFYK2toYmlQRG11Sy9JY3VFekl0NFdGMEpwYk9haTRNTlJOUU05WmFB?=
 =?utf-8?B?NllVd1l2Z1pKY2hYTVBISE4rWTlhd280YmFMNkJlKzg4MWFvM2dhdXlXaFUx?=
 =?utf-8?B?blNGM2VsNFBGQ0NObVNYQlFoRFRBMzgzcExMRStta3JXZDJvdzlZYmNPbnhM?=
 =?utf-8?B?QlFBYUt1MlBwbXNoMWsrY2IwSVo5ZTRFbGkwNU9rbEpEZHBrOHRLTjBHeHpJ?=
 =?utf-8?B?WjlWVVpNL0pMUjRpcUkwaDNseEdHUDF2Smp4NFlaekpwS3ZUNUlrdEJYRFJz?=
 =?utf-8?B?cTRQWDJkTTY4WUtsNHBscmZZZFdYYzh2OU03UVJVYXpZalF1WE5mSGdPV3F6?=
 =?utf-8?B?US9wV2NNZWdXL2psNlAybS9KMXV0eU9LQUdSV3k3d1MrTmVDRGZQYnZjT0lO?=
 =?utf-8?B?VGptRkZ3Qkl0aTZJbW0wd0E1dkFFd3ZTM2RBRkFGWUVWU0FJMU9ObzB1Ri9E?=
 =?utf-8?B?bFNQSi9YWjBLSWlNSW9YYlAvRkZDK1hscVN2U2poZU9TUGxrUTJTSnBPaGpn?=
 =?utf-8?B?ZDVWR0JQd2oyNDhjc2tuMHVwVitiSy9WUFg0U2hGRURyV3hteTRZVm1jb0Ev?=
 =?utf-8?B?T0lFbTRKakZXTWlCRmF1blVhSzd6M2hHcHRxYzFpREtRVDZ1c1d2R3ZHRUtn?=
 =?utf-8?B?bWREdVlMV1RjbUFNa01BOWxMZEdSMnFTTmExRU9mTHZSSHVGcE1UcmZYcDJM?=
 =?utf-8?B?MEhFdjJ0Ynl1YUxjZ0NpM21BS2NCUXNXbTkvWWwwZ3BoSkxPMllYSjQ1Qmd1?=
 =?utf-8?B?aGQ2S2RIdHZ3cUt4OXF3NmZ2V1E5Qy9CaHB3Vks0UnhwRUxoVy9JalM4RnJT?=
 =?utf-8?B?VXlqZ09OU0pJd2x3NGszQlloVnljWHI0VktSVWdRVDVWTGpLMnd3Mmx4ZlZR?=
 =?utf-8?B?ZGZNekRkczVZai8rU0VKOEJJdEFlRVlLUTE5OUNkT3JMK0pSdEg4aWN3c3VM?=
 =?utf-8?B?a0lWeGZwZkVwckRXQVJ6TGlJUHNDQzZxRk1wWDVXL0p1QjBPc3lWSm8wWFdq?=
 =?utf-8?B?K045U3BFNzlHUU5uYkkwRlhqc01LTTBxZjBCV0dxemdCSmtqNmlDTlR4eEs2?=
 =?utf-8?B?QlVyMkVKa213MDRVOW9FYks1WDBEdG8ycmZ3SytTZEpoQldUdFdJSG9JdmZn?=
 =?utf-8?B?aytIQmlaY0QxbHhHS3R6TitUVFAzMnBtM0k1Z3Q4SEJ5dGVLL3V2MUcyMzZC?=
 =?utf-8?B?VkhEUmsrSnpycURHK0FSWmtLQWdTdUtrOXd2NnVCZ1RvNXdxNUR6dm54V0E5?=
 =?utf-8?B?VnBUNUU3bWtoTzYwRzM5dkowWGR6VTdCNXBrN3pOTDQzQXpMdDZsWEYzSDFn?=
 =?utf-8?B?UHhpajVRSUJkNWZieU5QKzcrQUc3YjYwMGcxRFg1TGNsQmxYK3A4UDdrV2ph?=
 =?utf-8?B?amtuMjJoeElnOU5TbXR0alcvWWhrcFQyN3hTc2tJZXhSZHQ5eXlkUFhCekdP?=
 =?utf-8?B?UXFidFFiRENsclhGNDdMMUFyOE1WUEltU2hPZFdYT01BYUpvMkZqbmVJUG5R?=
 =?utf-8?B?RHM0RE56T0w0SXVJS3pIU0FHRm56WXR5QzViZy9VNXplNlRkSTQvcmRlQUpn?=
 =?utf-8?B?a0RFQ2J4dlZDRXdsVVFDRkRWTXRtNSttSkhKZ0lnbXlBWmtSRkw4Mmx3Qm8v?=
 =?utf-8?B?c0RVZ3VPSjhKTFJmTnljWC9aRU00TXVNWVZvN0NXcWQ1Y0VLaTdvcXFxdHdU?=
 =?utf-8?B?YmZoaHVOVnF1RmRCb2QrN1lUMFBoTGk2TUZxVWJOakR0Z1dOYXlKWWwwR1Nk?=
 =?utf-8?B?MSs0T1JKUHBSWXlTL3RsNFdsV1BWZTFwdDlLaVNiMW1EOG5TNVF6VGwvU0Nm?=
 =?utf-8?B?K3I2K0RmanVQYzFDTWszL0RQbjYyV1VoUDg1WTVXenBFY0IrVGlyMC9ocm1I?=
 =?utf-8?B?VnJhTk9YSmpxN0VyeVR6MDRKVndPR2tlenBZUVJIYzROMk9IS3Y0UElUK002?=
 =?utf-8?B?QjVQZk55QXFBWWM2bTVVOGtHTDhmc2lRdUMvVHdHaGlNUXNPOXlpeUEwTElS?=
 =?utf-8?B?bEQ3Y0RGdHV2Zk1NRnd5ZEFHZ05UNGhOMi9UUUhIZGNqYTBHR0xUYk56eTdM?=
 =?utf-8?B?ZFoveW5WM2ZNVWZPMm1Va0FmMUJtZ21sYWN0RWZRYUZqcC91UGM3UnF4cGdN?=
 =?utf-8?B?Q0l0dnJLOGNVeWdqNEFGS0xnTDNpRU5RdWxPbEYzUlZuS1U4cVpRSzRKbjNo?=
 =?utf-8?B?UWsrM3IwWm9mVFlvdzJtaVFTTHB0VDBvOXlLaXNhTmdrWEp0Qmcwdz09?=
X-Exchange-RoutingPolicyChecked: O4dwCMC5NfJyPpiMkJAGmcCM6ALdNdiSHnWVXsnrvZ5y6qbfDipWdvFjUeIpyNNdsoYz5ISuDeNWwep2C5AO2Gkk5pSABD10CrgrvdoQ/6++oOAt7tmcArctZxmISTzKatWg5SlHYr8FrqgLAqAZdDu21mTD7NfqsVLInESmTW4fEkzict13hkZvu2/6QlOkLlQL75Ptnuz3JI2IsArPPqovtXOKuLs1+xwAVbntc/LqejvKOZp8YmzIAX2MWyc8eVhrEi3Pzywj/lDO852ugGSK99f5QGmBiIX7oKgyf0y8OH4/y4DUXSdhoCTgb3o36JfArEhkfLKTiCsCIlLkoQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f010f9c-e876-444b-d1b0-08df2a580348
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 01:02:41.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrrnW00SqAWOFbSssUb7OF/milNWm/x7RcSWOIN+Av6hb3lasuddf5j9SWyom/ZXZePY85Teo3Riv4LTqaluxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR84MB3781
X-OriginatorOrg: hpe.com
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDAwMyBTYWx0ZWRfX6b60eaCjlRfs
 Ti/WrXEoLwRUCrUFEDf1oKLnQu/AABQiD1ob+/tYPDVidQOIDtjlmUMDWEPNH/1Oz0mhqvg0cdV
 zFLn5GbKgjLm6MfLwE8oWwFHB0kmmNo=
X-Authority-Analysis: v=2.4 cv=I7Tw19gg c=1 sm=1 tr=0 ts=6ad0263d cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22 a=6XKncaru_qjgLvANlS_8:22
 a=MvuuwTCpAAAA:8 a=XSBGc0TME-Ls4eIamg4A:9 a=QEXdDO2ut3YA:10
 a=zbcFYc_5J1R7ydP2jqkA:9 a=FfaGCDsud1wA:10
X-Proofpoint-ORIG-GUID: AGiB9O16_vcJF9UuRXdDGRHB6lNNlhR3
X-Proofpoint-GUID: AGiB9O16_vcJF9UuRXdDGRHB6lNNlhR3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDAwMyBTYWx0ZWRfX6dejo0erk3Ai
 1YUbF/18V0PT37aP0uje3EqFV7VPilcmR4pfbC4kWq/KGED9MlV9EOqoK+SXo2tnHK0JQicBBWH
 2RfX+Su59x5xy1bqrSBseCY+vDQoO3659x82e8hd1mgNcZjAQujp6mySPb3TVN+Kcg3UHaSQOGE
 HxcWUU18JwKz6zcLcRiE/sTqd+yn5wn5oNZ2XkVusJz+4QnFirkmVgmpxu2N0SA40JvAvkmakS9
 0HzF1Ar6UQ9iiALtO8Rw1QauWopnogupg6JLWa0TS8xkSfSkOgg57o1cNY8AeefZZF9/fvP1ed+
 daCN/EujFM7Amgk95/6Glxiga7CVnRJFFTlGLsf6aM99oX1PDvk4wlmZ5T9UYNnOf7UhBc+NfjX
 v5RI2nTS4jdhBVewuzEEV/gvOV0vSgO+bRiq/GD7eRzf/7u3Rdjsfg0KUhaWnfdEJwkoL3gEZJB
 /Dmn8d4L0NL2O+W9QqQ==
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150003

--------------i2YvFioyoJpzxaYNK4u2kl6v
Content-Type: multipart/mixed; boundary="------------ioccwob78b96MIkR7AroIQmO";
 protected-headers="v1"; hp="clear"
Message-ID: <733df751-5e7a-4004-84d8-627320734c30@hpe.com>
Date: Wed, 14 Oct 2026 18:02:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: eric.davis@broadcom.com, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com>
 <20261015000834.GQ14213@ziepe.ca>
Content-Language: en-US
From: Doug Ledford <doug.ledford@hpe.com>
Organization: Hewlett Packard Enterprise
In-Reply-To: <20261015000834.GQ14213@ziepe.ca>

--------------ioccwob78b96MIkR7AroIQmO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/14/26 5:08 PM, Jason Gunthorpe wrote:
> On Wed, Oct 14, 2026 at 04:57:16PM -0700, Doug Ledford wrote:
>> On 10/14/26 3:21 PM, Eric Davis via B4 Relay wrote:
>>> Ultra Ethernet defines a reliable unconnected transport. A queue pair=

>>> sends to any peer in its job without a connection, incoming traffic i=
s
>>> demultiplexed on a JobID rather than on a connection, and what a devi=
ce
>>> orders is far weaker than IB or RoCE and varies between devices. None=
 of
>>> that has a home in the current uverbs ABI.
>>>
>>> This series adds the generic half. The objects, methods, and attribut=
es
>>> any UET device implements. No driver is part of it, though two alread=
y
>>> exist against this ABI. A reference device model that implements all =
of
>>> it, and HPE's Slingshot driver implementing a large subset. That is t=
he
>>> argument for ib_core carrying this. What is device specific should co=
me
>>> from private interfaces per vendor.
>>
>> I'm doing some cleanups and then will be sending our Slingshot driver
>> for initial review as a dependent item on this patchset.  Look for tha=
t
>> by the end of this week.
>=20
> You each will give reviewd-by's for each others?

Absolutely.  We've been working with each other's patch series behind
the scenes already.

> You are running sashiko locally and fixing the bugs it finds?

Yes, but with one caveat here at HPE anyway: We have very limited AI
resources we are allowed to use for data exfiltration reasons (yeah, I
know, this is open source and we're intentionally exfiltrating it, but
company policy guides who we have contracts with).  We can currently
only use Github CoPilot.  We can select models, but those aren't the
same as going elsewhere.  I noticed for example that Eric used Gemini
for his, and I think he honestly got better responses than we did.

However, also keep in mind that this is adding a new QP type with
semantics much closer to Portals 4 API than verbs, and that does create
some friction not just with the rest of the stack, but with the AI
reviews judging by what I've already seen from the Sashiko reviews to
this series.

> There are several other new drivers right now, do we need to do
> another full driver review trading scheme?

Probably wouldn't hurt.  But, our driver is many more lines over in the
drivers/net/ethernet space than it is in the RDMA space.  Unless netdev
community makes me move a bunch of stuff over, we don't plan to move
what we don't have to.  There are reasons for it to be there in the
first place (namely that the device can run as a simple Ethernet
controller if someone so chooses, but it actually needs a lot of that
infrastructure the RDMA portion of the driver calls into just to get
simple Ethernet up and running).

>> Note: I dropped linux-kernel.  Unless things have changed, they usuall=
y
>> don't care too much about the rdma stuff until it's time for the merge=

>> window and that list is already way overloaded as it stands.
>=20
> Nobody reads that list I'm sure?

I dunno...does LWN still do a summary with each report?  Maybe only
automated tools deal with it...

--=20
Doug Ledford <doug.ledford@hpe.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D

--------------ioccwob78b96MIkR7AroIQmO--

--------------i2YvFioyoJpzxaYNK4u2kl6v
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF4BAABCAAjFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmrQJi4FAwAAAAAACgkQuCajMw5XL91H
Dw/2Lbrr5c5SWWHH9YfrKmGcj+mFgiQYcwD7Df4IQwxlxScNkGau/fKOwde4+gIFzBuhfZrajXGc
VrxpBDxiffUZDf0czAo0nFw2Ijig9N1rrM1feRw3M5OSZ7+LScIEzlJoTBOKDuStIMvecV/CyPCu
8rXYqrqxC8FpDXwR5BiRdDdo0h/FbHGSn82k3flf7sbv5ex60cT5Oi/YB66w+uiyNU3HDc3agE1V
QnZ/oToU4jGu3ftgS3Lvc3X9XFk4sP2wG+chta1y49k4XFop2mbGaEtSkEagneZyIP0NYmQno6Ka
Dq0ZLyBfga/sC2yNsP1xxCIPD18xAyPos1GSyJEzVnWw+sNuKFZ4/coHzUBUh911vgHUFkfBGbut
V4/Vr413UHW3Klu/z8dUIsx6lWpT6U+aRUtLj2o4XBb7bf1m8U0yWVeox3EbXBuy31pk/t0cYumP
55KMRgGuAw42MeJG6z5Tjm1/6VXgc+mTNmfne/3jFfecDg7S/RvIzhspHwFxpi+3JAYNa+0syPiT
fsRipVKt66fG5nxnB+JFY2SpA1Jsh3P7kxHquoSoYpmeBmzRD+vt1auEkEieBblQ5xI1Q6Iu3TO2
gA24eUxasfcOl+ubZy4aESAJ4fjYKj+3yrequIXxI+FUTudrVNwkxi2rC2YsdQdfOH5QOtSkleeM
4A==
=IDqk
-----END PGP SIGNATURE-----

--------------i2YvFioyoJpzxaYNK4u2kl6v--
