Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.34
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793907119;
	b=KHXspeuZ9SWFC9Lsc4UNnoBg+WluRdkNFHLAqchSJbuBAIoBr1zFf9onC6XJSnILAfE/
	 nBliR65ssCbzK8oSNzEZTXT+VZsWf66EN3LHnEl4e1A8UB8yH/jVS8/NcQb3kTPBs+QBR
	 QeiriG1UEtLaShCabUX51+QtSK4x1S64nxg3otgWVi1O2uo7AM7sATjGZtZYcBL/XBjWb
	 sqUwnY3RDCFZnu+HAJKco9otfuyEMa72H/VjO064K9ERdoEAHjJHV0ZWEF4tTPZwL13/V
	 VNyVCy+ykwEYnAOPPI1E46bTP4aNBw+T52+6MHIeaG+qyUvBxqBvH+eoba+lIe0GXiw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907119;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=WHq6JsXHtT6J1Ah3GMEL9Ry8ZCd9gxlJDVbDT8ZOLHw=;
	b=mSnWuwNka3EJUsoX3G+rcWPLQHgz3Mr4oPp1UUkMJ0A8/N1XFtIFQ7H8MsLoBQCTOBBT
	 lXBqJvcipsgKc3aAdjHNx0G7rzB39xniPiB5/XaefwokrJBOglyK5l3qK6nvslP+MlmFu
	 qs87aQx8pzvzT/5z3R8t5EAVxoVq+1iHaQaR/XEXiUmGsyfsuGaBxKmc9Sv4aMbtHniOy
	 8sog/Q9jxXViwtYDz90kaI4X2WexdfwNGesbexF/QFP/31LSUt/D7kD6+hxSr853vVZU6
	 CoMxjv7HYUC4/PdH9SDdWsAUzBlVPO7UA+K/3itQVUmXMKJ+DX8V8fAHIEJIX36iMYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="TFZGNQB/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.34
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DDA6083612;
	Thu,  5 Nov 2026 19:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3DDA6083612
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TFZGNQB/
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRIsx3iPwmK466Cd8woc0M7z1leJfNVv1wiiiAd8snlWy/j+b07dBZ+KJOIsccb+P+6CxtASpyvLJC4ca35+HtsWlGi4XNcXddOtnmMWflToyaAckYsETPYs41NagN4Vu41qGbMbp8AVdmG6esnTN9i/5H3vz+P+t8kQAMiXtSw2YYkLrK5LF/fz2CpKp2LPihmNhEFBT7W7LpTnE1zPedOb3g2x59dnQq08h7rabDJHv/ceBx5MSZIcb0xZwgiT95wRDRmu1xIKqYvS82DJRpjYXxGd6wW8mjKSk4Qg5DRX4OXaWQUB4r7/8obISoKdMmlDN6MZ11sPSUuB4+6iww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHq6JsXHtT6J1Ah3GMEL9Ry8ZCd9gxlJDVbDT8ZOLHw=;
 b=cXpdv6LodS+31OTSY5gDbkSiayZ+FCpKR0AIswA9NELLJup/077gFHBSg+5yNl/gcDu2EXSygUOaoiwnhEA+LHJ3tBjLhD9nSd4qX1I5lclF3pHhaPG3f40qhOv4VahyApHakNDqTQRVUVGxVYXgEyJmD3R3M2vinsOGB797nHqBRqSAsGUUpkUbtYNe+Tb3Mh3XdrrHCyfUt4BcbxVjKUodAs+eDZhkYxKu3iRt5Fyf5hd6dxGb2FJ+jc0jhcxERtPhDWXr6ENRqNBj/sRXNKl4qnxuckR/Rnd+mgH6PhRVriCK8QgkjelT8Jx2857Dhlqd65kJxWCsM6aF4J1WNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHq6JsXHtT6J1Ah3GMEL9Ry8ZCd9gxlJDVbDT8ZOLHw=;
 b=TFZGNQB/M91LqdT2dD0mVPe3vZ0ro57Da79mz0NGxTQxLiRRhQwR6iEnZ5OFYN3+hMx3dWEqt/5uXySqAiHyZw5bYc3Z+oXJ/rIM3XI+72vZg+F7SvuM6ceGOLug57JtA6F70naDnfVVr6HDIPCbNh7qowe+XFBleAYTLa/Ec+iiEbkGbA3W8/jVsuNbZC8k3udWHbkGXe1Bo6bDobqN51ABzkTA23jkafuEeC3zoO4nuwrUf8PO+LE20j23zXfS7yl277ZkKb01AB9iZIyqoHYfX15gnpjfag1OCPHWtkNIFnwkMI+ZMB5SgLOag11G+7NDOx51B9wWewORO9Ft1A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by LV3PR12MB9409.namprd12.prod.outlook.com (2603:10b6:408:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 19:31:51 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 19:31:50 +0000
Message-ID: <5f6c3f86-23df-4da2-bc03-6ea2c2a7986a@nvidia.com>
Date: Thu, 5 Nov 2026 21:31:43 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net V2] net/mlx5: Use only loaded devices for PTP clock
 operations
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <markb@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@mellanox.com>,
 Richard Cochran <richardcochran@gmail.com>,
 Saeed Mahameed <saeedm@mellanox.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shahar Shitrit <shshitrit@nvidia.com>, Simon Horman <horms@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261104183158.758314-1-tariqt@nvidia.com>
 <179381746658.488859.12055215608519756880@kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <179381746658.488859.12055215608519756880@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
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
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|LV3PR12MB9409:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a84c8c-6dc8-4b62-9146-08df3b7370a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|6133799003|10067099003|18002099003|22082099003|56012099006|4143699003|11063799006|261022105027099003|261028144727099003|261102123227099003|261022075727099003|261021121427099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	kZ62aOxgguRfliyy+PpGYJUortIq2aXJe89xgx86QF3nNM84FRbP59zkwmCbubahm0jP1OQdrp+wlSB9Tx49PRrkatsb84DsrzYbe6EsxzY05t01DsgO9p0FpoFjPRf0zmHsj9CGawWQo4LZuRwJ+jdpKY/xcQPTtEKelZlTvGoijGx5QLUn6454jWJuaGhsPrhAFGAj+vCTo204MYwfBn0RgpzM6BfNzGaPYxw5a+kFLJ1BP/5Lg+nVMYNUkYWPBMf8n2X/cbG5DqvfCF4Smim6isOP9/9yHn7d+ZZQWkc8gTFLkGCMxsmhR4m4H0cD4/bQMsicK43iP70q4WDH8YKJTt1A79qUAQTACe29J/EPi9Tg2rNKvBfb3ZByn7GzZxe16/9H/VI6NP4xtGVicI92N0hgRjjb4r16jKxiX08oHkrKeR07Wloj3uMvVzCbVP2tUaTgmaov2q8wwAv442JGN4HwpeXV2Gsei6h34Yd7mT4zy/kTs7UCYKBLiUDw0KafLXjwF3VmWvg4SI5bfuVll9fBtgpY7ujrixjheM1TYOvR6padws5shdgJoaYNq/SgRgHVJ2YLRILuu3vntKYY8+FtrTR/lBoRlB7CTX8KIuCrCqNEREDugNnFkWGL77Cta71DYlrhoGSctfobLdiAzbY3mYyD/rYLVH4xdiw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(6133799003)(10067099003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(261022105027099003)(261028144727099003)(261102123227099003)(261022075727099003)(261021121427099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHBwVGdxMnVHWUt2NTFuSzZXUUE1SldQNlh1V2plOWQrTHpPR25xYnA4QWlM?=
 =?utf-8?B?STg2S3hsSC9HWlZRYlh1ME1YTmpRTDhMVmc5R0F5Y2dPYkdSMm8rWm5PT2F3?=
 =?utf-8?B?N0FsRi9laTVIMVlab0tsTEdQeDZvR3RIVmoxc2ljOEpOOVBSUXpnR1lJL0U1?=
 =?utf-8?B?UTJDdkRRdGhFc1U2V0NqbWFoTDJpWG4rZENtM29JcTcxMHlTNWRaS1dHbmtn?=
 =?utf-8?B?c1pXSmg0b0ZTSU16Njc1aFZWdWlIb0hqMTdtdE91MEZxV3FjM011enFocWNp?=
 =?utf-8?B?MGJoNHErVFZRbHQyMjcrUEUreUFMeWd3ZHdXZ05kd2hkQ0NadnFjVnlTN2FP?=
 =?utf-8?B?NWh5U3M3Z2NEWGdpSTkxZ0JPamUxSHkvSjdqcGY0dzg0M2VEVlVQK0tFbmJN?=
 =?utf-8?B?azAvVEtPNHc2VVRBVnpOTDdZMGtWOVNoWTZzVTFvMlFIV2E2cGZNaFQ4dlJJ?=
 =?utf-8?B?VW14cVNqU0VsM2JmYUZJQzJ2WU9mNStWV0tOYWlkMXYrbDIveVFjcmlFRFo5?=
 =?utf-8?B?N2FuUEp0SWQwMitDYXBEakVaQmhRS0hteklaY2J1M2w5dGU0WXZkeCsvcStu?=
 =?utf-8?B?TVFOUlJGaDk5VnlOTE9TcVVSeGJUV2NyTjVEa1VETEFZMXRvVDZWRXRROWYr?=
 =?utf-8?B?N2dMeFFpSW9aaFpFT1AvNVFEa3ZCazQxZ2RESnNuZUZ3cW01U3RGRWxMY3Bn?=
 =?utf-8?B?cjBpc3FKM2JoZ3ltS0ZWUnhpQ29iVndHZk5CNDlxK0VFeThXVVJxbVFKUVNF?=
 =?utf-8?B?R2poVkhaRFR1MXFPUE9jUFVjYUhzMnJrdXY0cFAvWEk3bzBXRU1EeXFDUXhQ?=
 =?utf-8?B?ajNXMXN5NTJrNnpzWVoveHlnMDZXMnlpU3FGaG04bW96RFd2RkJvOVREdUJk?=
 =?utf-8?B?VzNoTVcwRy9kME95d29veEhrc1BRc3hvUDg0OWY3SHpNSjZZemErOUpUUzJX?=
 =?utf-8?B?c1BadWFNU1ZaL20yU2RlV2xoVFM5SGl1RlpDL1VaM3JQeURTK2V4SVFIQnRz?=
 =?utf-8?B?UTEwY282R3I0NTdnc3NBTlJzSmNyMXVqYmVJOWU1U0NUMGJIUm1WUVl6NnJF?=
 =?utf-8?B?d3pjcVVpVzlPRXJQVC9wbkJaOTNnemViZ2R0RnhrYVBCMlNBVi9rOUVnNmI4?=
 =?utf-8?B?TElFRHN2b3BCcVg5QXNRNEFsL3Flcm5xUFFYNTVMYyt0SmI5SncvNjhoWFQy?=
 =?utf-8?B?QWJSODlpYUxCc3ZwMVNsbng1Yk9jeGo4NVNyRHFFaXpFWjZvNnBOc1RPMHps?=
 =?utf-8?B?Q3YrNnNsWEJTOTFlZ1FySWE0c2VyRkFKLzNpKzhoMGFzVVdUWXd0QUlXTkhj?=
 =?utf-8?B?WkVaRlFFNk5lSHhRMW9SR2EwQ2RldnpwSTQwVmJTbmpRVHlKUnNBQzVZYkNX?=
 =?utf-8?B?d09Ca05pQkRJdzZXbEJrM083OURyT1owYnFUQW1VUGQrRHY0RUdWMVQrMzdt?=
 =?utf-8?B?SlBmSVV1OCtoU0hpdWNPWXVCQ2lUN3NCVFd5cCtncXdQMlpiRW01Q1VMTnlq?=
 =?utf-8?B?V3pnTXRSa1krRGVMOEZTekJUTmczNUtwWW5yeUxYbXgxekhUdWdQVlBsSitN?=
 =?utf-8?B?aWgrK1Rjc1d1WVdXNkNIVzFXOEJqZUxKQlRTcFViSXNMWnNmUmhScTI1bXg3?=
 =?utf-8?B?c0l6VWxPUnkrc3owd05MN0lLcWZhTXJnbFVsM0hrVHZESWQ1Z2xCZDdVQXBQ?=
 =?utf-8?B?SlBaakV2R3pZdi96RDZrRDhhZmZIYzVPdkJwTUZHMjZRV2xQdVVtbGtIV1Bp?=
 =?utf-8?B?RmgzM0lDTlBITElCTHpEaFoyK3UrWUJ2UE9kR280RjJlaHUrRWRuYjhueVg1?=
 =?utf-8?B?RG5uaEJvZFRJd3orZnhrVkNmUEU3QXNJenlLUVIyTlVtRW1SVnNMaVlsdHZ3?=
 =?utf-8?B?Q1hreEdYNVhyZ2JEZHNZWXRYejZ1SUcxRi9QMkJvaFZJLzJELzRodEFEdmsr?=
 =?utf-8?B?bFVacUt2NmVvSlRwamlFcCtpd0txcjYwUy9pVjl6b3dJOWJ2aC9xYm8yUERG?=
 =?utf-8?B?V1c1WFB4WWkvMlpQMHBKV3c4d0pmUHpwNmkyQ0gwdC9aTGwzcVV0WGtkR3RY?=
 =?utf-8?B?RUtCMTYvcGE2RXpDdW5hNE5tQmpvNzJKSnlUQnFXcHJqeWg4S3ZweXh2bHlI?=
 =?utf-8?B?OWZWZ2ZOS3RGeE5sa1UvbUw0NUdPdTBkZEVQcmhzcEVMdk8xWWIzQVpmNDNE?=
 =?utf-8?B?YjY2SS9kTkFyUldYWnRJYkgzS3pNOWFOSmVKeDg5WTg2NnVTZTU3UmlPWjhX?=
 =?utf-8?B?TkJYNmg4dUF3eGJrUUZkdWY0d2VMUERrS2NpMEhJMkIzYkNQMGdVNitiMkJD?=
 =?utf-8?B?RkpjR1phRnB0L0RlTm85d0F1MisxN0Q0azVYcnFYQXV2T2dpV0RTQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a84c8c-6dc8-4b62-9146-08df3b7370a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 19:31:50.8422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijXuz0rBaYnUGAyFuTKfcmOBDTWqyJ6vsUWphgD+Tj+YSD+rgr2TfcfYxWGHtXPv2mBfIk3slmjai2sixGMFQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9409


On 04/11/2026 20:37, netdev-bot+sinfo@kernel.org wrote:
> Hi!
>
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
>
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
>
>   - What hardware the change was tested on. For driver fixes please
>     mention the device (and if relevant firmware version) used for
>     testing, or say that the change was not tested on real hardware.
>
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
>
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

Hi,

Apologies for missing these details in v2. I'll make sure to include them
if another revision is needed.

The issue was observed and reported internally during PCI suspend/resume.
During the initial investigation, another team found that stopping the
PTP worker prevented the issue. I do not have any logs to share.

I then investigated the report through manual code inspection and found
that the periodic PTP worker could access PCI registers through its
backing function after that function had been unloaded. Stopping the
worker alone wasn't enough because PTP operations could still access
the same unloaded backing mdev. The change therefore ties the worker to
the load state and ensures that PTP hardware operations use only a loaded
backing function.

The change was tested on ConnectX-7 hardware.

Thanks,
Carolina

