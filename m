Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.135.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794779917;
	b=SouUqxeKwLwfBYMXCeF/Fhkc9N+J1PwhlXvZ05t1Xae/PiVf6Xo58JRGTcBXfXTke58P
	 od46tqwxTV8T9V2YoFFLewJMERNMVtH0PYl5gDPpl5n7/V5UxzIywXy8+3n7szQfX+Qoa
	 59d/fLgZpSXXXXQ3nGOh5KuwXJ1Hm5aLNfcElp7JIESQJmloaJQnQNZp4TH9QXKIgQ2oL
	 jpEqlgDX7Hl2j9ARwkrLJXZxlSKPpDN7Ve2/l8I4sslV467Yq7wTi1Aad6CKZhQQY4a7N
	 EsxRi0C1i0oC1kHBwepA1t2Qj7CU/8WYhDKGFqbce982c6DOvdoCg4rO3152Ijk7ihA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794779917;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:From:
	 To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
	 In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
	 X-MS-TNEF-Correlator:msip_labels:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details:X-Spam-Score:
	 X-Spam-OrigSender:X-Spam-Bar;
	bh=4WReseMnBwm6tAd5IMwynwt7b+YihKHFt/bzQu/Ur9g=;
	b=JWTJ0Jh4FZMSXL9V0dQDM/kKheWDdOOjAEgG/bx789Oiiob0FgTzDxpZlXle3roOtz1p
	 NkGR7JlHKQ+/ftraj6M7r8rTPjsg3ylBUHbp5t5tys9Pnf7zqIQATZOqSkvL1bb200Iw4
	 8FvN1n8yW3HMIOnogASVmt19kd19tV9Z0IVysnczCCS00rVmBQ/HzzFrCyhlwOniC4VwG
	 b/YlW5NhpQYFCx+cDWIfoAvyqiyR64aapmZy1vsywVR//1K/xuWUh44p6G+k7UP5z8Ipm
	 RA/wxkRTyeTfokIcZgFUQHVGOH0hxqiZaBsu9uHFtILm5YNGJ5yxQrRXg51dyGxlBIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=illinois.edu;
	spf=pass smtp.mailfrom=illinois.edu;
	dkim=pass header.d=illinois.edu header.i=@illinois.edu header.a=rsa-sha256 header.s=campusrelays header.b=p8aJ5tm1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.135.28
Received: from mx0a-00007101.pphosted.com (mx0a-00007101.pphosted.com [148.163.135.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E21606A32C;
	Sun, 15 Nov 2026 21:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80E21606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=illinois.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=illinois.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=illinois.edu header.i=@illinois.edu header.a=rsa-sha256 header.s=campusrelays header.b=p8aJ5tm1
Received: from pps.filterd (m0272704.ppops.net [127.0.0.1])
	by mx0b-00007101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AFLoQPP2848106;
	Sun, 15 Nov 2026 21:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=illinois.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=campusrelays;
	 bh=4WReseMnBwm6tAd5IMwynwt7b+YihKHFt/bzQu/Ur9g=; b=p8aJ5tm1T2Xp
	QeqlhnqbjnD4dm5fgne0zRqToOf+Msk4fiHfQw0j0DGn7h8aN1HJhzQOratLqman
	CJt/rGD8TP9nwgpbp2/jfSfY3roQMwlU0jjiBrLAAAsjuzNfyN8ZFr68Yp9kyK0w
	UwNk5W4jTscG1HuRQb9PqHs2/1wZVQx/4iJ0X88pGGvvCvdujQi+Wuux3orDWb1e
	JwN4i1S1XMtvFCXvyUNemKGznWX1fIj/5lzRprmwn5pZ33ebQcxS81K/0zMu1Dta
	hxrbuCZ5meuaLq1fhdGwopkB+mjkEDuQTE5Z8nXivmZWeCcITfwJDK4tgvAm9beO
	gppf4cXxMQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021092.outbound.protection.outlook.com [40.93.194.92])
	by mx0b-00007101.pphosted.com (PPS) with ESMTPS id 4hy7hxtwn1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 15 Nov 2026 21:58:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OMQQXaAQE5pm6r5ACyvMPuS3SkFqjWMAnjKJNybQapj+r/4iumZ7UoJiC3ZMR4fM1DmgBOtZk/vtSBnetSAlLSPgHKtZwwT4MfDt5xsGFnPLZpVNSdyW6qJdyyEqhmjoCJs5vMbTQjcdjlGbX0+Z+fLu6EsqeKBiJV79v6AuVBplNfzJFkW3bE8yUMIBeft7KbUwK44A2i3GrizwahCTwt0vsaudHyJ9K8EymekCQhXGFrZiMlqoBUZiNPPYQQDECNdnE23PeeQj0OVEEI6Ef8tGLWM3g6q5peR5LX1QKYLdY5D79rfo75Mc2n197M6Nw4FujwNmuA4xZA/JKfaWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WReseMnBwm6tAd5IMwynwt7b+YihKHFt/bzQu/Ur9g=;
 b=PFIr+kD3q1DeeoVOmVY0eXxKdX+Dn6z7NgDEdzw2Kq9r6nfNTes3dc5VwhQQZmiiCK7XDuWASeP26+ZYVC9gzZvX3BXAZ0wG6Z/qnDyyUpV150E7Xz61jvwFGt8cGJX8XWLVV+GOEoKs/9FoRx5UoK+NJoHE9oLqxiIImXEs/IDcLGLHycHTjJCj2ld/Mevxq5IFT8twMyV4S1M8E5DZiV58PSkzoWgCI0MUjmzlHvtUjI34VupJWTgbdbPYOHOdDPFsS61JidTHjvcQ2ho9/C/U/MOb7PyJzmxhXKuBbgDhrQjKlhGuzHMfCPNV67Hu4gCREsJAuGMQEDF2JhttpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=illinois.edu; dmarc=pass action=none header.from=illinois.edu;
 dkim=pass header.d=illinois.edu; arc=none
Received: from LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8)
 by DM4PR11MB6478.namprd11.prod.outlook.com (2603:10b6:8:89::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 15 Nov
 2026 21:58:15 +0000
Received: from LV3PR11MB8508.namprd11.prod.outlook.com
 ([fe80::a1e8:1786:e5d1:8e51]) by LV3PR11MB8508.namprd11.prod.outlook.com
 ([fe80::a1e8:1786:e5d1:8e51%5]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 21:58:14 +0000
From: "Wang, Weidong" <weidongw@illinois.edu>
To: "netdev-bot+sashiko@kernel.org" <netdev-bot+sashiko@kernel.org>
CC: "achender@kernel.org" <achender@kernel.org>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "edumazet@kernel.org" <edumazet@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "horms@kernel.org" <horms@kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com"
	<rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>,
        "Zhao, Zijie" <zijie4@illinois.edu>
Subject: Re: [PATCH net] net/rds: tcp: bound the message length announced by
 the peer
Thread-Topic: [PATCH net] net/rds: tcp: bound the message length announced by
 the peer
Thread-Index: AQHdchs70uH1j0G/cE6GMHf/vLlD6bcvnpKAgAAT41E=
Date: Sun, 15 Nov 2026 21:58:14 +0000
Message-ID:
 <LV3PR11MB8508DE66E9A9A20CBA0CC0D8B57D2@LV3PR11MB8508.namprd11.prod.outlook.com>
References: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
 <179477516170.3136.3481236029450144068@kernel.org>
In-Reply-To: <179477516170.3136.3481236029450144068@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=illinois.edu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8508:EE_|DM4PR11MB6478:EE_
x-ms-office365-filtering-correlation-id: 9c0aaf1b-9398-420e-7962-08df43638c62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|786006|376014|23010399003|7416014|38070700021|4143699003|261028144727099003|56012099006|5023799004|11063799006|261009223027099003|261022075727099003|261021121427099003|261022105027099003|261026140227099003|10067099003|261102123227099003|261026121527099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 bYEBudZDH6CGlyLfSFfLnnva9w935tFNpJMNKJEecOLzqbXzpb4kWbS7Hh+hNkyph5qI51gCkZDBd2EjI//j9PYT8lWPWFTyeTukkcKXbwEXG11nW9v/lmn94ihk30MZqHTs8bJAIbXY9wqqI9j3JSyRAu9hBCUtOYDEhAi6SYfzgqIzvj/uPZ7LacwdsqetJZHTsQVQIIdWqTctbBofrypz27Tze3A5ABsAwFA509kbTmbayw5kux6AGP6Az8hMrOblBpNQrwt4YWgwO9tB54OKYWeXR8+D1ZjFqq9BhlguGJ3O3dtpkrqvYaoV9Ugy0eqvjxAgiuEK9MlAysXhp0dINlahq/0/utWhsg4eyn/n30y1GcBYTqRfQx4ti9xB11A7kc4u7Cl6rz1wByyct47X5MvwzSMsT7TH5kgtQ5cvWFsbhI3XAOScS0zbhFm+ccYY5mIJxD2ava40AeHX7BdUBMGZPC+h+0EUVPKPElj9PdLjVwTAb6B7o4XtGFNglyyedikchkihYqQlY4PHYUgJj6hM+bxwyegmB4x8yyjkEOs/J5IE8QuiPuvqKvVGbeuDNicvUqfwhTycy+N5cHdGdi4yppHsTv3SN7ZG0FW3WErwJL5M25zh9mqcx3LysiTdAsgd+7DsdDj2YSxJw0iIGE7b2auYkGSNaWMRFqSiJ19wOokTBnXH5ZbAWBY57AN3fwW6DxEUtFowz++I4v6zoB/+jsnm71XTggiGf4Y=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(786006)(376014)(23010399003)(7416014)(38070700021)(4143699003)(261028144727099003)(56012099006)(5023799004)(11063799006)(261009223027099003)(261022075727099003)(261021121427099003)(261022105027099003)(261026140227099003)(10067099003)(261102123227099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?a1pURUJORlFzSmVmRHFtUWhtVU5xSzJySzhXTitwNXdTejNZUXdveUxNVGZU?=
 =?gb2312?B?bTVUdDlNckhVdkhsMHZEMnZYbXhDeHdEdmJMR3lRRWtpTGF0c1VJVVRXL3dl?=
 =?gb2312?B?MXZ6MVJZbzhXenJkN0ludys2WUkxcHRmVEM2eW9walJUcDdFWFRpU2E5M0I0?=
 =?gb2312?B?MWFwZ1VCSEpHLzk1bnpLL21oTmhLN3F1bmVwcC9lM0lsbkV0UkNtaHNYS1RE?=
 =?gb2312?B?dlpoKzJBZXBYQVFJVkx6Z1djRUprTTNlN3d2YWQ2NWxyRFo4VWl3YmpLN2w4?=
 =?gb2312?B?OGNvSmtzajNEbzJ5L1lFeXhBb0xRejRLSEFtenF0NC9CQU92RU95K0ZwTlRl?=
 =?gb2312?B?ZXZBVjlwbmplSUwzeE9ZNk5RL3A3ZFZPNjczZUtQbC9YZHRSUS84VmNHN3Nj?=
 =?gb2312?B?K0FjNEh2ZVppclFlZ3VSK2N3bnJ5ZUk0ZWNqZG5jTEk1U2JKV0FYSFBmRFRx?=
 =?gb2312?B?Q0J0WGVwN1VSc1IxQldHalZpWFhkL2ljQnNjZ2U0YU9DQ0IwZHFsdldIU1F0?=
 =?gb2312?B?cTlHcmxSSEQvMFZCOTQyUS9udFBVV1hPek1tVkYyVlFSVHVncVBCRXRTb1Ft?=
 =?gb2312?B?TzM4R3JiMXAxeStMRzEzbzMvOU1PZ3N2WXd5S3Y5L3lEOFkrRjBJSklpaEgy?=
 =?gb2312?B?cEpqUEthRHV6V1puVmpFK29la1d0aFl6YkgyaDBDdUJqUlNGakw1WFpiSkV3?=
 =?gb2312?B?OURvVTJOdGFsVkU4Q1pQVmxrWDE1Q0FjQlBITlRpY3IrR1dwK2tiSUtFZ2Ju?=
 =?gb2312?B?MkRISHVjZmVDODZqWkFUaDc3RzZMbHZZUU5tdU1DWjA3dHhrTUJNNm8yOGxl?=
 =?gb2312?B?TUhKWkFWNmdQbGJuSlFvYVVtSG1FcmhCSHVJUWpHMklTTm90bHdnTTBudEhM?=
 =?gb2312?B?dTdMaytMVmRHVVgyNEx4U0F5QzRtN0ZWUHhrU3lwUzBUcGZTNXNmVE9US0Jt?=
 =?gb2312?B?L3BvUzJlK295UkQrc3JYZExUTjA5d2xFOENDc3FUR1pGdXAyM0VhdXN2Ryta?=
 =?gb2312?B?b2d4ZGdmWFloTGo3SThoZ2xJay9mVWo0bjgweFRRcnRuWFNsMG1JTU1RcWVq?=
 =?gb2312?B?bHJ2bUpBUDBmR0t1SjM3RjIyL0d4YWdocUVYNG5BYzRUTjJSenVsRlFrNCt0?=
 =?gb2312?B?WGV2RjhYZTFHbXlUUVJKZ002SWtCM29zQ1ltc2xDcDNCeHNuZkJhRXhYaW9r?=
 =?gb2312?B?K2RFa3cxdzF1SDVQcWk4RFJSS0w2VEM3Q0lsL0pQR1NSdFh0ZDdXSmxZNTNV?=
 =?gb2312?B?eFduUmFlemc1WGxORU1aaUFUcGhTd2dMa3Z6dWxjbmVKS2lqdkVNbWdoU0ND?=
 =?gb2312?B?ZnpXVWd2TGlSUC8xaXNsYkRBazdJMTlVRVlGVWYxYThQM2JtNktZWXcxaGgr?=
 =?gb2312?B?VkZHeEdlOFc4aFZnZjJuN0s2L0VKY042bFNhMFQrelJtQ1FLQUVCb3lCdmVn?=
 =?gb2312?B?aUVrYTluaDIvUjhzVkpzTHNaRUdTVHBqaHJuT2NOZVRqOFhhSW9Id3VlZTdp?=
 =?gb2312?B?M0ZKMGVoRUcvTCtxZFlzK3YvbGZOaUtiZjlLTitTNUZpVmp5bHIyNnRBUTU2?=
 =?gb2312?B?cFlWMG9kV1dtMXZMaWwvYmh4enNxaitwNGsvbWthM05YK3doQnNkdFA3UFF0?=
 =?gb2312?B?ZVhWUU84dC9zdjlXblZlN0lTUjFvNDBTWnNOTkpjM2VjNk1PQTU3bWNSazlK?=
 =?gb2312?B?Rkc1MHJaNm1KZ1lkY0tkeHVLVDdFZ25vY1djcWVNVFJJRXdpZCtIUStqQ1VE?=
 =?gb2312?B?SUtCNkpOQXlCV1k3Ni9ZVTUwRTVCQm9lUTFtbE1peWFkbGkxZ2w3cENCOHVs?=
 =?gb2312?B?SUR3d1RhbjZvYlUzV1hEejYxRjM4Y1VwNXFiMkhiazBhdk04b3BIZkJFQnMr?=
 =?gb2312?B?MFhRNWZ2R1RXaGJqN2g1dHZXcER5dll2VHl4OXpnYkMweklRZVc4bTVycndR?=
 =?gb2312?B?bmJQbHBLbHhiZHFCUkRKZGRwSnVKc2RTVVhzM1B0TTliZ1hQUHV6YWpnZ0o5?=
 =?gb2312?B?VWp5ZjZCUFZaSEdvRFdUcEpzb0h5ZHdiR2V0dzdncjV1Y1JhdnRqa0xON2xh?=
 =?gb2312?B?OXZzTVZCT0hJMXgrOXF4c1BoR1NmTTRCeEduaUNNRTJyMHljbzhBVEI3QWJr?=
 =?gb2312?B?NjMwNHRObmRQTkNZUWlSc2l1akNLdVBaZEFKZHZrMllEd3lHTWRhRjVKcTRF?=
 =?gb2312?B?bk9ER2xjcVMrRUZyWEJUK1RYMitLQ01ocDd4YmZCYVRsOTZDNS9ZOXgxMzI1?=
 =?gb2312?B?aERKRzhVM2xKb2xmZlJYUWdzaGJLVnowK3crVkVLaHRJaitMZ3AvN2hMdXND?=
 =?gb2312?B?TWtZV200UXNsTS9PTXl1VE1PK0Rld0ZqV21jWVB3WjUzSUFUbGpwdz09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	O9ndmonzwMlXR3m6EC9savgHpZ/2Kh2rlhPdOEqpFbWrFW6IFfqD7zqVRj8cNc5bdDafe91F1moEV7SYp8N199coE/UU4eTR7mxMxJQT2S5UkGwvM+ssMiwvxF9OLYHlFXFjLqiWAM7hwMGtOCiuKRnZLBLh9xA12LpbE2lWlO+ZIfVs0zXiJjaGd288f+cgQD3rp4kXkUV67ZyS+cOjokQvIAK9bXRX2tp+a/HNGpfjGWIkA1hrquqX0Py5lHYJ8Hg8dMIrBfzC+SKffhUNO3P+UpGbXoDlFENx/AcNzEkOL34cLi0Z0e56nsGesXIsPX1A8bMCaDYXixXQEqvbOg==
X-OriginatorOrg: illinois.edu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0aaf1b-9398-420e-7962-08df43638c62
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2026 21:58:14.5784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 44467e6f-462c-4ea2-823f-7800de5434e3
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Us7iY6jiCo0GLVVZ10uPp9KEyM43L83a6EiIOWEJ3opBubkChv1bCIdjDGOq569+E7ZxUQRoR4ip/ggQdrXFng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6478
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE1MDA4NiBTYWx0ZWRfXz5SCZQ3wngWP
 hUc7egT3iYI4otr11bqhT0OGQPAMEXjfUiTvaOXKJvK5ZMFBN9kiZblBvK71sTKuLDC2x7616FN
 ivSf746vCjdrE4dJXx8NOcvkzqvzF/6OTYPNCAX959Yyn9A9Qa6ihkuFZS6Mb4WPtcdpjRJbixU
 fwO6sKrGJLtZIZh4+BOmbkMLmNDmPBgSSxe4FpahQyViD810t0fKj5LUyVhLgSnxyiOT8Pui3es
 8F/o45r4zq/WBra2YpvAY43sREoCgVI/jSo6TL7qlw7yL3SRpvkWH8Kr6ohHaSeRCkWDjuSUfJz
 OTzTCS6f3lFfFkw07oyulX/g7/MC5A7SMhDoeDjU5VXM+UqdMagHI4qwDTVC7EASf0BCAjz/yN/
 rcdpfPRpyp/KLrxvCTE92StKAWq6VSEwAUG6i/PqbUWRF7jsEMiS5orEBKaQ4YdIYpsOdUgqm18
 QejRt57FhGN0Y/9Mvzw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE1MDA4NiBTYWx0ZWRfX6INCMDvqANHu
 /PD1THEbZpKHQNT2hnZCnGw5I8Oz5mZvpSiM10RMs9jVP7CFP94ySLGpkZMhBDkGesWZfmQfXJ0
 LjQImuKg0S46cDkYJQg/Wurl18fQJhs=
X-Proofpoint-GUID: 9IBesh5eLkCtfzbkOvSRMBlClKE8I676
X-Authority-Analysis: v=2.4 cv=Iq+L47/g c=1 sm=1 tr=0 ts=6afa2afa cx=c_pps
 a=FqDfg28UJuADJc1XZx4kXg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=_l4uJm6h9gAA:10
 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=r4lgQ_5M6CoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=1SIdTzcqDbZ_m666SYFU:22 a=kZkouF_95zi_LoiBhZO5:22
 a=VwQbUJbxAAAA:8 a=oGbrohWIeoctaWav7CcA:9 a=mFyHDrcPJccA:10
X-Proofpoint-ORIG-GUID: 9IBesh5eLkCtfzbkOvSRMBlClKE8I676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-15_07,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611150086
X-Spam-Score: 0
X-Spam-OrigSender: weidongw@illinois.edu
X-Spam-Bar: 

T24gU3VuLCAxNSBOb3YgMjAyNiwgbmV0ZGV2LWJvdCtzYXNoaWtvQGtlcm5lbC5vcmcgd3JvdGU6
Cj4gW1NldmVyaXR5OiBNZWRpdW1dCj4gQWZ0ZXIgdGhpcyBjaGVjayBmaXJlcywgdGMtPnRfdGlu
YyBpcyBzdGlsbCBzZXQsIHdpdGggdF90aW5jX2hkcl9yZW0gPT0gMAo+IGFuZCB0X3RpbmNfZGF0
YV9yZW0gPiBSRFNfTUFYX01TR19TSVpFLiBXb24ndCBldmVyeSBsYXRlciBjYWxsIGludG8KPiBy
ZHNfdGNwX2RhdGFfcmVjdigpIGhpdCB0aGUgc2FtZSBjaGVjayBzdHJhaWdodCBhd2F5IGFuZCBy
ZXR1cm4gMCB3aXRob3V0Cj4gY29uc3VtaW5nIGFueXRoaW5nPwoKWWVzLCB0aGF0IGlzIHJpZ2h0
LiBPbmNlIHRoZSBjaGVjayBmaXJlcyBub3RoaW5nIG1vcmUgaXMgY29uc3VtZWQsIHNvIHRoZQpy
ZWNlaXZlIHF1ZXVlIGRvZXMgbm90IGRyYWluLCB0aGUgbG9vcCBpbiByZHNfdGNwX2Nvbm5fcGF0
aF9zaHV0ZG93bigpCnJ1bnMgYWxsIDUwIHJvdW5kcywgYW5kIGVhY2ggcm91bmQgY2FsbHMgcmRz
X2Nvbm5fcGF0aF9kcm9wKCkgYWdhaW4gd2hpbGUKdGhlIHBhdGggaXMgRElTQ09OTkVDVElORy4K
CnYyIHdpbGwgZHJvcCB0aGUgY29ubmVjdGlvbiBvbmNlLCB3aGVuIHRoZSBvdmVyc2l6ZWQgaGVh
ZGVyIGNvbXBsZXRlcywKYW5kIHRoZW4gY29uc3VtZSBhbmQgZGlzY2FyZCB0aGUgcmVzdCBvZiB0
aGUgc3RyZWFtIHdpdGhvdXQgY2xvbmluZyBpdCwKc28gdGhlIGRyYWluIGxvb3AgY2FuIGZpbmlz
aCBhbmQgdGhlIGRyb3AgaXMgbm90IHJlcGVhdGVkLgoKPiBbU2V2ZXJpdHk6IEhpZ2hdCj4gVGhp
cyBpc24ndCBhIGJ1ZyBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2gsIGJ1dCB0aGUgSUIgdHJhbnNw
b3J0IGFwcGVhcnMgdG8KPiBoYXZlIHRoZSBzYW1lIHVuYm91bmRlZCBoX2xlbiBwcm9ibGVtLgoK
SSB3aWxsIGxvb2sgYXQgdGhlIElCIHJlY2VpdmUgcGF0aCBzZXBhcmF0ZWx5LiBUaGUgdjIgY2hh
bmdlbG9nIHdpbGwgc2F5CnRoYXQgdGhlIHBhdGNoIGJvdW5kcyBvbmx5IHRoZSBUQ1AgcmVjZWl2
ZSBwYXRoLgoKQWxsaXNvbiwgc2luY2UgdGhpcyBjaGFuZ2VzIHRoZSBwYXRjaCwgSSB3aWxsIGxl
YXZlIHlvdXIgUmV2aWV3ZWQtYnkKb2ZmIHYyOyBJIHdvdWxkIGJlIGdsYWQgaWYgeW91IGNvdWxk
IGxvb2sgYXQgaXQgYWdhaW4uCgpwdy1ib3Q6IGNy
