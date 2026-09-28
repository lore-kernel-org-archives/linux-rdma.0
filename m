Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AFB421223
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605349; cv=fail; b=qWZf9V/hZ7AD9WkeJ87Qb/dbUjQ0EsVM9Lnk2pv1sHOkjMCwG26n/HtMaRphoKqgSb5EZh2pDW8iBwTIYV2bSFL/WiRozvsIRnUE2C4VH8ngQ9gB6962lOyerylTQGsO8wO84DaNG8oW2Cr3fFqWZ3gposU5FHeKXBxadZNmavA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605349; c=relaxed/simple;
	bh=Kd2lLJp3G09+DFal+BIObonH5BHESiCGmuP5Iymt1Nc=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=CmG7fw/8muP0we9/EsUjEF+Fh4Q7imoMyNsubad7VtV1y7STC9iNRYYk8XKp8EhWsGN7Yq27QpHT7CxCRCAzToEikJvGKh6uy7Uc+wI91IfLui+qO+PvDj6DilQQaXIv4kMAoP82cM+SF4CuMlQT4dNgehTF40vNBK5K6pYhWp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rIwRArXn; arc=fail smtp.client-ip=40.93.194.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rIwRArXn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RP8O0j2RxKwJtJg3DA/GOAa+dFTrlrzsC5pG6JBf/VmXH6FCQZ0Ccuych93BDxaOW9lXWt6ZfZwMqdEjND48H5ZH0N2b6WxPsdss4nOiODwMAkbFbBKpkrhvh1diwpytfK8VtVWyuB56BKGu6Q22XetYKwt1HdeV8q8/fgA0VKWdsu1D2QJ3IhZQbo3c5PN3x654tiX1J5jK5iLQ/6usZIJn1PfGn+F1LQYyiX4LBozUD//Wq72grWqHcTyn8t5N4pRnTGWjDrJDV5fmPEZOe9RgHa4qLjSy77kXDapwRtPnq6fjBDN09Tf7Z3ffnyqXGU7ceSwBuYMl2dsIdOsNzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xa8femI62rbH/ZIcGxCkVEs+kCrH85rPwMJhaj9HG2Y=;
 b=tONJUclYyHe3ERQKrcLpSo9Cg/UGmBDCCpwNCxXCzeKYb4tY0PL7NSHVvbnP/A5dZh/yNakLBu7bk1CvvDMKYtFePmbrDPI5r7+gFWIv4UCyu3o9dw2TBh/2N/psM63OP4Yj92MP1oOINK1h4JCGldtt+eJ0w3jbyFN53wrIxewKLm6HUW24xCjD5R3uLIrq9RYNFyYS7MSh55tk5Q72KxVHo8p5mG8sqBGFUitH9d8qNR9jldRliABihUL8BbrN3oGi2gKpjYZ9IqEPnl1YIgFS0IFmiBOF/E40sqoIbQCceUBmXhpMwpkyU0/zJfQx1K/l7BWH/HR4ovC5AvuQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xa8femI62rbH/ZIcGxCkVEs+kCrH85rPwMJhaj9HG2Y=;
 b=rIwRArXnG9iHbEO+d4UPn7Sc0bhHb1k8ie2vaKLiFJ4LAaP9XTPlW93aDzmdTSesVBQ7gN96ISmL/w9Gu4H2iiCovn4oKqlfJFZrsU2UZiJrm0eKZic1+80wDA3cBNXiwWUzqg+1GoBF+ePHM9MHW62mZxz+7POoljU0jhPLBnweO9DJrF8sFNjsS5HY0TnDqeg93Ny9Fe2Aa1CaL8DkupgEnRHEAumKpD11fBWvA/lb/w7s4s3nIrYgwL9xkME9n0UfMYnXA65DCQW69OB4LHi4xO3E8NIEmy2Rsp8fTf4kFNAaCHNjnuk4VWU/D499oTOom+wmD+FC+Exev9qYJw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS3PR12MB460943.namprd12.prod.outlook.com
 (2603:10b6:8:43d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 14:22:19 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 14:22:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for-next 3/4] RDMA/bnxt_re: Add support for larger PBL
 pages for CQ
From: Jason Gunthorpe <jgg@nvidia.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: leon@kernel.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
 saravanan.vajravel@broadcom.com
In-Reply-To: <20260807005138.771669-4-selvin.xavier@broadcom.com>
References: <20260807005138.771669-1-selvin.xavier@broadcom.com>
 <20260807005138.771669-4-selvin.xavier@broadcom.com>
Date: Mon, 28 Sep 2026 11:22:15 -0300
Message-Id: <179060533568.122959.9830582898150474407.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: SJ0PR05CA0110.namprd05.prod.outlook.com
 (2603:10b6:a03:334::25) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS3PR12MB460943:EE_
X-MS-Office365-Filtering-Correlation-Id: be7f6e22-9750-4fb4-1923-08df1d6be779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	h+bL+CvW6oESU5QsS6zEGp9s+36KQKoII8plUDraWy3U+21ZB9Cgy/CzoQHyaoAmEy4dOf6OW/F2zjtlEt42rHkXAfFAqfCT5Vf7xeWc9BKiiCieEpPtoY8q8FEv8+Rtf+0Tnz3arV0hxNdYQ0E8z7OjwY/YmKFP7XrlEpV21L+NW79I2bqxvr13Vn8Z1dAqED9NACiVVFv1RwhpdrifGGQYGeWnqZvT5dgNk2mrPDOA5W/dHfbpzyc25xii/XbTf7vEkId6VarV9IfGNjXx2QNJgi2O9r9ANBooD7rT2dZsG4noXqCWvKXS0cAtq6Bq7oUO3eiwjktFAJL37GIbt/L4DhFAR6IUdVDmOZuzCIJQg1i3ruYK0h0CTR64BqCY4BZpQGUWDIVz6GWIRuOh3LvXX5boD8vurtbjiyzpADlgHx46YIdDcH6KqbgQpHkyWJMsKiysb/AjJSQ0Z00WPyi5cIWDjgdtWg4i2DblynxEyBZ9QCDAWxm8Vl9T/rMYnIwjAFoo31ZK2sN2xadPE5ayABjo/E+wRrNzyVLMyayvVJ51MD2t+y5FAy/y8JVODsC8kBIPvHl9aOEUfws47mgIk+zRCzsUUUitNe/a0XnWL+ns8YvlpkPTwWU03yp+MLr7Cj9/sqlogZrCNY7A6BdSLm7GoSsnMJoZQsC+gSg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWxJQVNkbU5vWDlGRnNwTXJZaThmOHR4Vy9QeTFzaHlEK1E1blUwakhVWjlz?=
 =?utf-8?B?L1pUbmlyWlEvRWREQ0xUWEFLeG4yMTcwWDVsaWlQK2U2OGJmVEh4RWh0TitN?=
 =?utf-8?B?akhFeWpZN3p5cFZCbHBsNS9EUWQ1K0tla0tmOXp5VGZ5RVlsQnFNMmoyVDFi?=
 =?utf-8?B?TzZ1UjdCNndsemJZQjNyU0g0Q3FSZEV5Q3ROZWNIY1RVcVhyZEhCd2xRalZ3?=
 =?utf-8?B?aUI3ODJ1R2VUdDQ3ditJZUd3RzFEcllMQ0lIc3dzNEVYYkpnRFNmWVczNm5U?=
 =?utf-8?B?d0hyN2FGTDMyL1NhSVZTY2VjR2hUYjdubXVBZ2xjRGlYWHM5QXF4Kzd5THhU?=
 =?utf-8?B?NDhHcE9kdVZWVGtaQjNZWklFY2IzTzJZMmdaVWhlVmsrRk9TRVZVL0U3cXRD?=
 =?utf-8?B?cmtCT0JkSFFMUGxqb3NJZVV0bmFCUTk2c0lScjJoZVBkRG5UNXJYNHZGOFpN?=
 =?utf-8?B?ZkFBTXB4eWVUWitOYy9PdVJEcmxibS82R01jTzFsU0xubzJraXNwTStlZzNU?=
 =?utf-8?B?R1dTa3ZFT01nTUF2UnZ0YzdYQ0h5Zkd2MS9rcWZBU09CVkNUZUlmRG9Od3hN?=
 =?utf-8?B?eEZ2MDF6djB2czhveVUvaTFkd0JFbmVmVGlyQ2k4cnljR1E3Y2pLTGs4V0U1?=
 =?utf-8?B?ZXJTdjFZUGtrSDZsb1lLelQwc2RydXlFY2NLZ296K3c4K0JGaVNzNm4xNHBW?=
 =?utf-8?B?WjlnM3ZybXF3M3JXalR5M0czQ3hzWEp0ZVYycTNpdDFvZWQzODF1NTB6MXhp?=
 =?utf-8?B?ek5VSWxBUmMxWDFwQkZjMGJmeVRZd013bWd3aG9QYzFVZnh0a09RNW1PeGZz?=
 =?utf-8?B?OGlJeFFKc2pXRnB6STNDQVMzMU1CTlhaMmhGQm1vMmFkUXJsV1BjelhBcm5Q?=
 =?utf-8?B?Q2JtM0lOdkRZa3BxcmhnUG9nVC9QNS96QUl5TkI1b2JQZE5pU2l2a3hpNVhL?=
 =?utf-8?B?cFdEcEJjd0M4cE9naFA2QlR4RWYyTGQrV2RnMGhSd3ZVS1FRbldUeEVBdStt?=
 =?utf-8?B?RjVVMGVRUUZPdFlUNnd6aWF1TDEwSURCa3pQeTE5VU02TUJYU3ZaNHl1QU5L?=
 =?utf-8?B?elJoZ2J2N0MrYTl6RFJ3d1MwT2liQ0JacXdYdW5lM0IvK1ZQc3Q1VWNZMzZh?=
 =?utf-8?B?MU9XdE8wakF3L3plMUNsT2xCUlA2VGtXYnhQWE8wNlBPUXJPQ1VEbDJPL0lJ?=
 =?utf-8?B?S0RxRjRTVk5GZVRObGd6OStVOEY3WC91YVZSOFppWDRpQm1JNktLMnZ6UHB2?=
 =?utf-8?B?dzc1SVowYWVUbVd3aTFMNDJmWjJ0V2pvcUdSclJKdlZXaFlXcnZ4WFEyMXVx?=
 =?utf-8?B?WHFxSFIzejdCR0kyVWZkVVRaM0YwWUx6eXpJdFFxVnVPUkdFcjRCUUtqd0t0?=
 =?utf-8?B?ZGVRdXA1Zk1WMFVuc2VXTHA1SkJLb2k4V0Zvb1dKMzdNNkwxT0JpRFIrTEtD?=
 =?utf-8?B?L085b3VpWGdmWXZtNTUyS2Z1UFRxZlJsRTRxTVQwbzZPeE5td0VKY285L3lp?=
 =?utf-8?B?ZXI0S0xYdGtPd2xoblQzRUF3Vm5oU3B1K3MrcDE2c3hVMGpib1ZRQVJjWGd3?=
 =?utf-8?B?SlYwd0tUU3Q3ZEJFaFJkbk03V1JPaldtbXNQTk90SjVaSjV2UWhwbjU4cDE1?=
 =?utf-8?B?c1RhZVRuWWt6bkdkUm1iSzhYSW5jTjUwYmtCOXFyanlxeSsxNXJpeXNLcHNF?=
 =?utf-8?B?SFMwZ3Z3cXUrSDVIU1pGTC9BdUM5TjlxdGhmR0RPY2ZtMExGYXpoNnhRc1Qx?=
 =?utf-8?B?S3lvZDh4anIydmg0dkpxSFNsbkZqTy9DWjU5KzVOUWtTSHhwaHg0Uy9pazdu?=
 =?utf-8?B?VWFaUDJ6UGlHOTBNOU1Ob0pZdmNpVGlvY1d1TVlqaWJpV1RiaGY5OVlPNDJQ?=
 =?utf-8?B?bWNXOUh3blRWV1dNUXl1OFBObXJ6ZlM2RUtlSnBra2N3ejMvUE1oV1B2eFVo?=
 =?utf-8?B?YnRyWmhWZTQ1WUhCQUR1aEh0NnArbnFyTUw5WmkwNzBNY0xsMlRQcmhmZGRm?=
 =?utf-8?B?ekVGZExDR2VISzNQamxXd2hWNENTNlpyUzdJRUtxNm4vUStxdFpZNm1ocVhR?=
 =?utf-8?B?Z2pxVFFFTS9CMFdwai83L3I5WnkvSkVQZFpobVJ2ZEVHUUtvbWI4aVBSRmQy?=
 =?utf-8?B?TFFiaVA3TzBmQ2RUVTBjSzI4a2VoV0tRMnB6c1BSS2xPZzM0a2RkTjZXd3Nj?=
 =?utf-8?B?Nm9LY0s4d3Ntbk5FdEpTM201aUpsZHBrUURzYzJJQUMyMDRtUEJPR3FuNi9l?=
 =?utf-8?B?L0MxMS83MjVmOW5QdDNTY296ckg0OCtBOXJ1ZTZscDZabUhkQklwd2RpRzFL?=
 =?utf-8?Q?9kEvJj/OGIH2o4nzMy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be7f6e22-9750-4fb4-1923-08df1d6be779
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 14:22:19.3358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNPbZg4L9POHw7KqAe26waAuyHUb3nEEAmVYaGR0DiGEo5QgmptVYXVx14pTBPCb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB460943

> [ ... 20 lines skipped ... ]
> +	/*
> +	 * The FCO field passed in the CREATE_CQ command is expressed in
> +	 * 32-byte units, so the offset must be a multiple of 32 bytes.
> +	 */
> +	if (cq->qplib_cq.sg_info.fwo_offset & (BIT(BNXT_QPLIB_CQ_FCO_SHIFT) - 1)) {
> +		rc = -EINVAL;
> +		goto free_umem;
> +	}

Same remark here too, IIRC mlx5 had a 64 byte alignment, follow what
it does

-- 
Jason
