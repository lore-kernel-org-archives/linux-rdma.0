Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688CC2D2488;
	Wed, 19 Aug 2026 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787160939; cv=fail; b=LVaq+6nnl1U16Vk8u2YzZRoceLBhWkEIcRFxANAgpfeM+/7cvBMHB86L5oTV4RHbV70w4GzaChyhgx2DUxGpeimIOPQuXTmCKaqhBti6KFv0DWY+LN+AkPJR1w2nA9XmbsK4ClDb7eziEK1Ynd1Ns7gxgef7TZFaUx+gwXdV7mo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787160939; c=relaxed/simple;
	bh=Tg2oaDFYgfuG7BW+OqYHIbU9u80p8hcxv9Ziort8PnU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KUcKDBRcLbilPFmGggTRcEFFI/HdDdkYWift7LItoHT5MZI3G5tXjZWb+GwXGZcL0GEHC8u18MfodPt9IJg4AqbHrr5FzbvakN06yvY4CIYgPLJRBOFWvRwrLPT0lhbE6a1yswvltCwBecLxUIprv5x4c6ew9cwHuGRcDsfOX4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SRNnVWMi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S1PW7/Qo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SRNnVWMi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S1PW7/Qo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67JHMhZN2136208;
	Wed, 19 Aug 2026 17:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vHFLaZxAn+rWfXgNcNTj/2UXT1g0yB9EjIR+SctQE+Y=; b=
	SRNnVWMiwEatHoEai9yKpqPTJDRZdcOO6+zFiXBbJE+EADcpPDQlY5pzwZiJrzpZ
	BlRPak0lL8Qzv7c/r7XD0sx05SNlQQzmSg0blXoQHmGS0c/PPWkj5To5gz2ILqsg
	48MsxFdE3gCIV8jQ3GuycOb2Qp0e/HNJv2jhqd2d2K4dY9Ju75GZ49nNC4KNgD7X
	xsgR8E0caLPYTl+2YSY8edcXXZEdQ9SSfbxVixDoMmrCI67CeFtVyZFoHGTZWHTT
	Bi5Cva5x/ArWU2yZ7olzIpXS2GMZ6tTzxsXovOyseHcWkeqeWl33Er/z3gxSfF48
	jACSVq679E2mXmTLRBZwlQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g4ydd9t35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Aug 2026 17:35:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67JHUBmt005508;
	Wed, 19 Aug 2026 17:35:19 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011057.outbound.protection.outlook.com [52.101.52.57])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2eje57tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 19 Aug 2026 17:35:19 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpnFDILqt86gCE66j9X8lC95EYFj3Pg03E+QwaQUd0WYSWQhS1xJOxVHQiNxnwV15WF+aaubACSblp526qAypok7T11kmkJXF+owJxZ017KUCB+JMuGamvxWZRT6Au8gSSXll4ojZBIa0ojlvt58j285sSj90qG6PW46a+4Sui4sOLs8yz9zRL1G/mk9xFN/rusVSdLWR/NHtlz9W4qH1pgRjtPzyjAQgeQG8a2tqmo5c2lHl8LPJgY1LO3l3NzkIJSJBCEPjL3QwWuuA7jFNHTOgw/OnkLf/yLKg4/f4okvEa0LCEgFZKnVD8U61Fg5KMzlPcRepjMB8uY2mispXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHFLaZxAn+rWfXgNcNTj/2UXT1g0yB9EjIR+SctQE+Y=;
 b=IBkW52CM7FV4ZlAS75xAzm9EpqownV0nHcqA+l5UwPd5v8LNdDD8U8geTMRrf7BUtJGkUPMDRAEJ4f4BILpTx48ccxCu0bW2qREU/iY8MNZLKYuxxAGdhXbD6C+0Z8s4KUC/gY02ne1EPG8SeGSEk+/zZbLRL5oPh1rJ0sm0gVXwWQclj2vZWAIV+Zx/ie+siAc9+8zYmbS/Tst9IlyVS+XYdYkQ8g9wP632bDA9YjJQ5m8LVSj2NG874bhOMWYtjaCQf0Hpq0wiDXFlhbmkSpEQ7VhIecPLLgshToP0k+zoBHlis6sxXOoPIgiA7maTB2mMzLdKe/ab1BtNgiyzRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHFLaZxAn+rWfXgNcNTj/2UXT1g0yB9EjIR+SctQE+Y=;
 b=S1PW7/Qoxra0Y4AyoBdVyOhSQ1GyrSWYmefZd8B44mQoEwDI99+LrTy0mWFacIH9aNYzsb2co4/uW+/D1TAoLrg3NzBVB4HQPvvV4/1tECgCXDzuYty5SlBSHbaIEFp0tsy+Ql5SWcYVVhAjb5Sqbldjq8FDQPmMUuT/c8T1BTg=
Received: from LV3PR10MB7796.namprd10.prod.outlook.com (2603:10b6:408:1ae::6)
 by PH0PR10MB4743.namprd10.prod.outlook.com (2603:10b6:510:3e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 17:35:13 +0000
Received: from LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8]) by LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8%4]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 17:35:13 +0000
Message-ID: <af46fce4-1d13-4d62-a627-acb837386634@oracle.com>
Date: Wed, 19 Aug 2026 10:35:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5e: Report link down on administrative
 close
From: manjunath.b.patil@oracle.com
To: Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260608234223.3731557-1-manjunath.b.patil@oracle.com>
 <9845fd42-e84f-43d7-98d3-9b2d0d1f23d9@nvidia.com>
 <3806aa95-fbf7-4713-8013-6dcf81d31535@oracle.com>
Content-Language: en-US
In-Reply-To: <3806aa95-fbf7-4713-8013-6dcf81d31535@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:510:339::16) To LV3PR10MB7796.namprd10.prod.outlook.com
 (2603:10b6:408:1ae::6)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR10MB7796:EE_|PH0PR10MB4743:EE_
X-MS-Office365-Filtering-Correlation-Id: 85e6f215-d31b-4ae8-f880-08defe1839cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UTkbn+HwI2aQ3/CWkMYKozPIVT+btCHdvpvUl7PkniQFTH6spnild8FaZ2nSgPrdVbH1HRhpEfB7SdnF6Su6koChig6CmZ1EXaC0Ig1j3ai7VDmxsRTt+e/eHnrTRnqyGZ2RJDIRTZiJINkMbVLHS2ZDLZ9192Ua2ijzYGeJQGDnBqjf9s9gx0a+/yWQHHYPlixOtVj9TAx9JFk3T80RjBrwCSSAEwcGzn4mfX23196/mjkBfhkU3aT3TaArCLFuvsFYKX6oYsqPQ2o8M58njHk4wqkhN3pB3+s3DajV9KIbkmKQxhj76IcLcx+1UkfAEVJ4LsCLt8QQCv6c7QrH/AiKic/+Emn7kXpU9m18CtE5XtZymtBLEbVS6WdQ0DG5yiU6ojoLZUa+d++vMJvEgPxV3lN+++pvNXIvOvm65h4PxS+yp7StVlsENxpVWynIUICbOw14IUM/2Ja/4un/0UdWRnm7q47u44qXRyE/Qp6yK8j0rrRcx9qgi41MWCmpKEhmkHPCqV5yFwv4EtxFO3szIelAdNbEbAG7QGZL7fF1+pUUEbV1QCczddr3yqIgKJIHod1DlXtSEuR+i356I1rnb5RC/TzdFP0BxxPpyGDQYCs2l7a7gnxtUBvZ3lJ/wzF03mMW1untkZBf+3hnId8P4jBBGoBGyYEa84VsXJs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR10MB7796.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1E4SXdIMnc2ZWtRZEZOeG9qK0QwaTBnejRGK3F2QzYyOHVQb3NMdXRtMzNT?=
 =?utf-8?B?SE1XN3lna1JwZi85NlN2MUpWTldkY0d0QmZyRnhVWTM4OVlLS3R3U045eHdB?=
 =?utf-8?B?bFpyVGQ2N2g0WjZVanpudWZJVVh2dkRxL250UjJRSGFFNHptSlN2azJCMWh1?=
 =?utf-8?B?ZGVrQWlRSmpTTkJVT3pnSDgxRytTdVVaTnRrenVKSXg1K0V2Z3BGZUxqNGYx?=
 =?utf-8?B?RDlVUGJTTnlXNG1PRlhhZ1U0NVdrYXdadllyTDVSZE1UYXkxN05ZTXhPYlFC?=
 =?utf-8?B?ekczNEI3OWZPVjFpOTRJMWJEUUZFbFhYSEFaWjR6cFNOb01PUkZybGRqNEFY?=
 =?utf-8?B?M3BySm5qQjVIYnp4MzQvRUhqd2dmdkduNFRzaEJMWmtDdUZYdGE0VFIvb2pa?=
 =?utf-8?B?UEhDSEx0enBHUTlMK2tJeXN5T2lJOERpTVNRNEdrajVqUEl4allWck1JTXVo?=
 =?utf-8?B?OTJ0Rm1QNXk0U1gxNS82SjV5SFh1MTJxZk9BUjAyakRDeGZZUCtkakZSMGdC?=
 =?utf-8?B?S2Jpb3dUNG1wTlpQNW9pRjA4REdlV29rQW9TRzFJdTlhQkRHZktuWlA5WW1K?=
 =?utf-8?B?bzM0Znd2WmtnU2g4d0ZveWxhZkw5VUowWXprWW9mdmRMWlhhNzFJZ3VOK2U1?=
 =?utf-8?B?bjNBU3cxVE9rMTdTcXBsQmFldmE3N2VDUk1JTStzbHRIMHRkUFd0TGY2ZlhU?=
 =?utf-8?B?UjAyS3BJTUhTcDJtSDllYjBSRzdsTEJreWFjQkJnTzZJSFptbUtKODZCMGp5?=
 =?utf-8?B?VFRoWWFadStUY0hRZUtLZitsVWc0WU8wNW02d3pubFhPbVpwa1dUbSt4U0g1?=
 =?utf-8?B?NjQrVzRMdWwxUzl5K0tlR0s4RkRjNWEvSjVyaU05YU1DdGc4dkhPUGc1elcw?=
 =?utf-8?B?UUZycytENEJDeFExMjh2aHUzbG9QR1hSSWlGT2dqVk5rWDhHTStBaDRkTTJV?=
 =?utf-8?B?eDJkek9qZHBnZkNWcTJnZyt3K3NRUTVzQ2tDMys2MmN5cDFjeld2K2FSQjdJ?=
 =?utf-8?B?VzhJWFNVWW1tNzBBRlNnZFEyckJXMy84MitGR3lRZnBOSkppYlh1NS9pSmdS?=
 =?utf-8?B?TUlCV0VCSlBkR2t6cjZtUlZaQk1GTVk5YjFHWHFZNmRKNlJRaFN6U1JnNW91?=
 =?utf-8?B?K05zRy9CMmRuWHlIQ2k3QjdNNUlGRkREaFpabVpwbjFyQldRZng5aU1iSm5F?=
 =?utf-8?B?d1hKUUJWakp5bjFmanZjb1lHMmh1WWZ1Q2VYTTJxdHkxU2ZsR0tWbFVOK3Vm?=
 =?utf-8?B?OU8ySE9jUzNhRlhpd0NwS0ljSnpYYWNrcWRza0REUml2ZkJWOVlNTFRjWGJQ?=
 =?utf-8?B?TmpPNmoyMUlyd1paZWZYMm0wTDZYdmFaZVgvc210dXdtUWZ5U2JKOHVtREVW?=
 =?utf-8?B?enVzMzN3bFoxVlprL2NsK0p4N3lFOS83OXNFWWFiYy9jQVhaRExHV3VqeFdZ?=
 =?utf-8?B?RWhOMS9JUlgzSkxsazdzMHJjSnBHVzNFMlk0bWRDQ3dPcnU0YUV1MGVsZXNp?=
 =?utf-8?B?bTlDZ0M2TGp0NS9OaHpoOUxlTmt6MzRKNDhHaW1NVXo0VjJTa21GMWtLMTJv?=
 =?utf-8?B?UFY5MFBmRHBWeHRGTnFja2s5NndrTkFUZ0duUy9tWStYZ04xVDJ2YSs0cTdB?=
 =?utf-8?B?Um0rN2dZeTRocE1BbjMrVjM3WlRRTUhzYWQ0aTg0cXdhVU5nOXRJeUNYZmtx?=
 =?utf-8?B?Z0dDQUpwNjF1NmtKaWxvQzU4Z3VRYmllejJjenExOFo5QjQ4dUJTU3RGNmlY?=
 =?utf-8?B?SWhWL1BBS1VKYUNqSFJSS0lMWnJGQUxKeW4rcXlZODZoR2twUU4yOW5yZU5W?=
 =?utf-8?B?elBiMW1PREZGWEwzR2wzbFY4QmxyMm9MR2VPNndoT25sclZyNnFSb1p4MTla?=
 =?utf-8?B?MDQ3ZnJGcUVBQzJaeitKdERxZmplSEV4SGdncTg1V3BjVzZyaTVZWXpDNTdS?=
 =?utf-8?B?SmxPbXRoam9SNzdDU3JPZTE4aFFQOU1ndU8zQnBrRE0vV016RFpiUEVqOVZP?=
 =?utf-8?B?U3ZibjN3YkpDRktxOE5XdnZpak5waUVVUHFJWVU1ODI0Z3dHQ0JFWjhLNlJ1?=
 =?utf-8?B?SWtSVW1QdWdCZGJmN0xPQkx0MHIycVpqaHJRcnZVRmVnWGsyYnlONTdKVGJN?=
 =?utf-8?B?RlZUeGVYdmxWV0JPUjY2ZmVZclRGMk9RQTNhZ0p0THVNWXVMU1ZxUjlkaFQx?=
 =?utf-8?B?Ym84TVJiZW5FN3phSWNYNDBIelQwZlJjbVlCRjNhMVZwRXlodXVBRHdHZTFu?=
 =?utf-8?B?c2hFQzlTak4yWDNyT3lHRjRsbCt2dTIyME95bWErRHU1ek9WR2tzUHhkRkll?=
 =?utf-8?B?a044eUg0OXMvMUM2SUo3S3RjKzBtaUhhNXVtenJnNzltYTJxcXJQdVRETUlH?=
 =?utf-8?Q?2cN455j97EvmAF+8=3D?=
X-Exchange-RoutingPolicyChecked:
	kxNtNL5E7BDmMotKfmI8q+HqHEu1HZAhJyMZGdRNs/cAPYAaWuB0y8gdcYBB95q84n95W+MnLWmVw/KlcIlTaDI31tG8ZZ77uvCzhBL7DGyfcVDQSpIny4hNIPlT0oobKHgKkkOW9JRe5qSOj+oUplF4RnqOp13sQgjcoJ3DLpznscNNN45oRtgds/dVnXb9hs70hyVkf2iM7ZlOv0/4mfP0QjKlSmTNihjpsbNFfsy9MxkSuRORXbrZzqa+RKCFTiePyIL+6DLRTpNnfZgjt9QTYmXob9NGsPAH0lA05ZuK2+cyaGntZG1BQC51DWurPnT8eCT9sBZzp2HC45KeYg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uvDfR8VssOFvGHABpzSjfcv/Auj/9sw+JWSTc8T3QjBJduup8BYyXvV3+4z+Pyw4tnxg1sHVzzexU2XUi8RXN1P3kassGzWyK4TSf4gurH48AhWzBlUOXfZ/U6va+F8eBjSYaeEWW1LHUETXerAnOrW9RZfnTb6pip5PjjL68/RdyOSD1fHX3IKULzdL3uUD8BsVArGxPzX7yR+OBAOkP+LcdcdafCqtuXyZvTI3fWm8SW0rvZBOj8KmMb3Khw5RRSqE7XQMgkoDhnhhDIHw0rgDYSPHr6DqGFCaW6TrINFtg2xeyNftY23FSndzeXhC+kZn6PxsNJKc71iqMjUcyY3sBd2VmW+NMmseWGzDPqKv3KS4TuOrh/9ZltYuhhdB1FVsnBw3zn52VL5oPEbFdHBQ3kcgrboE87H5rD5FEdHITmQJQhOIWdQRZwPWZBvqbPouxq95OGDVRREf2wVIg7BTE5vZJ2sDs0VMWAQj2L4ut0PoegeOcY33ORqfsjq+bkCw7UyVC8QGAsug2gZTNipXyYrQhjnitGuhIqZ+qow1vBQwkocMwtTDPBfLYpTQVc1MRcdqzM1zgtOezWFkJGKoCw3CN19GH6o5Ou237NU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e6f215-d31b-4ae8-f880-08defe1839cd
X-MS-Exchange-CrossTenant-AuthSource: LV3PR10MB7796.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 17:35:13.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcUrRoP131LCh03/p84/g7jD9fYCuTX5eh0gh9ntPsauvC9iqnjDIyVU/ohpYUEdz9uR8Uz2GPWPXHfL+V61W8EmO2lw9nfDhHyVIjh58VI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_04,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608190136
X-Proofpoint-GUID: 3gBZrd4Imd4C4KgJtEGPOJRnAi-kFRKn
X-Proofpoint-ORIG-GUID: 3gBZrd4Imd4C4KgJtEGPOJRnAi-kFRKn
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDEzNiBTYWx0ZWRfXycJahceAKhiJ
 92JzuCZKjf/VnCOZaoAorWEN36OW+XG58zntMfoiKR+MDHWDvFz8gl5QhWowVvOhA/A7y2NEYRF
 sN24VMmpppleaOn66rVNkv8NmyRH2/mKDi4fiJgVk78VRpAwN6EN
X-Authority-Analysis: v=2.4 cv=BdjoFLt2 c=1 sm=1 tr=0 ts=6a85e958 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=4ORhOll2VWLiCig0GlMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDEzNiBTYWx0ZWRfX2+dzaTMYnXrs
 1Qa7ce3WZ4L8LRm6iOD05OuAQgep67Gb0XPJ9WDMwSZz7mx8zkEgeemamvTxHaRDng15IOjPTV4
 Qy1xTZTR3i9GY3huuC/QQnCfbE0ch9f2Zv3OOHFjZBROZfGH7nialTVfgYBmBCPUaBwIvuqL7yV
 zmV0eZwMCKYSaHtORry2J9pXgNI7u9AJOa1UpQWm3rl2lI58U4xmI91nKXc/2iK8NXkDby5Cz46
 zr37Puj/CHvy9Czizdi/3VoAVudoKRv14gPYmGvN1UjYpxtZsZygbiZzPoq8QpA8kNjs/oNgHuG
 p2o7OwP5D1xKYxRzXM6os3J+visvvM5MfS7MynfFir1/GNwOCKx/J/11b/YodNXlOZVvme4IcJ9
 ISt4r7sAbLioIDVUT82rexvCmT2K7BZVyP7bzoK0iptJigHOr1g+J7lk3f38P64oJIrQt6hi6vN
 WWd3Ve1CYwqNn9L2TRg==


On 6/11/26 1:13 PM, manjunath.b.patil@oracle.com wrote:
> On 6/10/26 5:06 AM, Tariq Toukan wrote:
>>
>>
>> On 09/06/2026 2:42, Manjunath Patil wrote:
>>> mlx5e_update_carrier() reports both link-up and link-down carrier
>>> changes, but an administrative down does not reach it in practice. The
>>> close path first changes the port admin state and then clears
>>> MLX5E_STATE_OPENED and drops carrier silently in mlx5e_close_locked().
>>> Any queued carrier worker will skip update_carrier() once the device is
>>> no longer opened.
>>>
>>> This leaves "ip link set dev <dev> down" without a matching netdev
>>> "Link down" message, while reopening the device still reports "Link up".
>>>
>>> Report the link-down transition in mlx5e_close() before the common close
>>> helper clears the opened state and drops carrier. Guard the message with
>>> the current opened and carrier state to avoid duplicates when the netdev
>>> is already closed or carrier is already down.
>>>
>>> Assisted-by: Codex:gpt-5
>>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>>> ---
>>> Validation:
>>> - Built an OL8 mainline test kernel from this change.
>>> - Booted 7.1.0-rc6.bug123456.el8.v1.x86_64 on an mlx5-backed VM.
>>> - Confirmed `ip link set dev re0 down/up` and `re1 down/up` now emit
>>>    netdev `Link down` and `Link up` messages, alongside the existing 
>>> RDMA
>>>    port state notifications.
>>>
>>>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/ 
>>> drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> index 8f2b3abe0092..a04a89f0eddf 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>> @@ -3628,6 +3628,9 @@ int mlx5e_close(struct net_device *netdev)
>>>       mutex_lock(&priv->state_lock);
>>>       mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_DOWN);
>>> +    if (test_bit(MLX5E_STATE_OPENED, &priv->state) &&
>>> +        netif_carrier_ok(netdev))
>>> +        netdev_info(netdev, "Link down\n");
>>>       err = mlx5e_close_locked(netdev);
>>>       mutex_unlock(&priv->state_lock);
>>>
>>> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
>>
>> Thanks for your patch.
>>
>> I wouldn't print "Link down" as part of the "close" callback. I'd 
>> rather get it printed in the event handler. Currently there is a print 
>> there, but the callback is masked by the OPENED bit.
>>
>> This made me revisit this area, and it surely needs some more 
>> interesting enhancements.
>> I'll probably come up with some changes soon.
> 
> thank for you taking a look at this patch.
> I will hold on and wait for your changes.

Any update on this?

I checked a v7.2-rc6 based kernel. That still showed the old behavior - 
'fup re0' reports 're0: Link up', while a successful 'ifdown re0' 
remains silent.

-Manjunath

> 
> -Manjunath

