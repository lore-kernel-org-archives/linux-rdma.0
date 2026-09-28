Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD6E4DD3D3
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 14:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605362; cv=fail; b=RokF1tHX22mWoDXDUm5sam/31wwcFTgdPZdGEgQUIrPVjgk1YwDuywMMxJeEOdhUUh4zGr5LisUHJkEvb4EnGRh+j278U7eVabw2j4dhF7OP1ELFOa2C/+hSnH3oJuPsSMZ6ajITwLlAyHRZ78kL/21Ioj0FFV2D5PDloe40nZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605362; c=relaxed/simple;
	bh=tJV5r4XJOw5HfzqZy6UMLzXOHVJIV7XoQcCUZas9q44=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=GKFqIevh2euyRxEu5DtWoYQCZcCx57ovaUshEGuYfRccUH1Xh0iiQQ8MW2BAPyowkv8YlPdwqVkE0A/qaa6DNgumPeoqwhuzOVkigbwhL6DHxpc3jfcxiS1ytTC0SEp5wnxj0StEoBnM+3svLAK3B0p6jfHYnkCHbTpVIBpQWcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rdiOuct5; arc=fail smtp.client-ip=40.93.194.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rdiOuct5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAdG5bcYrhar7iACCoPb0ax0zte3XI81euO6w9GE2Od+DHkHl0eZ2uhgITzF2ZUDnlfuObMmDfPmGgsymrZUPu1cGcr6znILAIzAaZLtIlLiqlRR0v0NqEq7zNMKq+WDuwkbvp8ZSl3MIgncC8HL3vYEJCIHoU//vJOzD3ESaKjVEoiIF40TsVEGwEw/4bmAQy7GdWHwpj7/0d7Vzq3Z0WOBBDx3tyzAv4i450xwLJpcWNHg2yeRi75CX4HcVIof3b0VHOWrUpuMhPxLoVqbUFZvfOOw4hTsR/JjXcNG9/8X94Nw7mQg7TPoUfPucTrntvv0InVv3KUO48HyLIAMcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2pfzRCyG6NwR+Fnqr1cTI6zQiMQ7kSaIktj2RuAMIs=;
 b=oV0geb3F12871QcS/oJZM5aoztEZyk62ru8tyJwKiP/zVd/JtnXI+If/0ToIaEquZtHDWzrTLBW96ypzj3oIQZmXAskxMHugyePEYYmdlwNTwlPmOS6LraFTDKrmpQ73ZiIOgSN2PUwm+SHTaWiIY6uRycwBmCUXW3ToA8F60ouXiyhnp6ol6EKCS37Bt/PRS2jk0aHBL5raselIIac73MJVJN7Ey22/53r+Y0fBZDs9huOa1JAtw8t6TBp1G7ySBQGjLHw+HYiU73gsTUUmVVNgvz669+9ypIpcEz56ME50DEZQk6e833H2r04hGP9albyofqzqtyGSjMp0oXA5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2pfzRCyG6NwR+Fnqr1cTI6zQiMQ7kSaIktj2RuAMIs=;
 b=rdiOuct5EG6zBtkksU52Uw6jaQ5APbofxINfYx77fQINn92cxiD+skyQ1jzgCMLfiHx3fXXGGcsirpVOzKWgUfeY5j8+b+ifK92NaxeXogXkfQJShhxkvcCnUwMUQem+erBxPJlqzXdN6CJSGIF6zWyeyL/Ei/oOMGDOir17kETnWeZHxn8CU8QTFPFS5DXXloCBpxVEwDiXTiTfcEHVgW+N8eG8dysFtwKgnA2HtD2BfQUVm2S5Bx+Ma5diyOBx/+IGrGnCTB5O8OzPx8ZgpOUpJZdO6OLrWH9kvoOfCfS0k98JfpcCzKEUYu9E03uZZFEsy04L9o1OUkkvijq3zA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS3PR12MB460943.namprd12.prod.outlook.com
 (2603:10b6:8:43d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Mon, 28 Sep
 2026 14:22:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0451.022; Mon, 28 Sep 2026
 14:22:20 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH for-next 1/4] RDMA/bnxt_re: Update the page sizes
 supported for MR
From: Jason Gunthorpe <jgg@nvidia.com>
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: leon@kernel.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
 saravanan.vajravel@broadcom.com
In-Reply-To: <20260807005138.771669-2-selvin.xavier@broadcom.com>
References: <20260807005138.771669-1-selvin.xavier@broadcom.com>
 <20260807005138.771669-2-selvin.xavier@broadcom.com>
Date: Mon, 28 Sep 2026 11:22:15 -0300
Message-Id: <179060533568.122959.5409976292461211488.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: BY3PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:a03:254::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS3PR12MB460943:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c7adea9-8ff0-498e-9e70-08df1d6be77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7/PpE/d9NV5PGbdzpEs61IGKR9y1E6A4x0tfaFNyqpeAzm0xz8uxveyOTDpJoyBjXUSnMr1lGcLGdTQRXWqX+IW/vvRB+OE9y4dMUW1MFopNYsKtJ/5d8yp8vP0jRGFKgT/m/L1oZne9HJYezboyHxmb4+ncadfqcoEVWTrYtQKmzwFaCZmqTd3N3ScwvzhikTq4YZrVrdYvUZLCOqYAn+pp3yR9TZKpbTFoNURw805a4JkLKIdsJaKpkRkri3ZAho21K9s7sOxV4c+7krPdqpwiYKc7OyNAfr26nCyz99HiaC9duin4lUX0AYVVR1XU1pnXRH2t0SVkHwlkPrFuIH2nd9MWrYHYcGam3kTl4K8InJRlyIH73tmiN9Q9BpG1QyhgIVfDLsFuoHRTNx26xmC44Z6nEX+QhqZGrCW74nb/BHIxtBbMc6HV+I3OrCFn87BfHwXMLh2jLGBG2UqMBk08bkwL+IMjsB3FIv/NSxOQWriqZarCW+dMq13bVQ5WU3sE/2szC1WTvladah5ngIfoPQU5WBvfXiR74aOl6YSfVi9KnYa8XtJoriX+Kv4UbxgGh7pAHJQ6Bzi6RSsoFnx4A162n53nxSXYkLDJYpq0fy73lNXKKPF4/9QfruWgdAcBbc/aocd2CFFbHZlrRFGA0manvLPLCIoDUX/MkyA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG91TlZRSXljWHNUWS9yb0tiNjNUWFZqSDROSHYzYXljYkduQ1Q1Vlo3Y3Ux?=
 =?utf-8?B?Q0xQazNLVkhGdFZuWE42a1ZZUWdXWmJZZWJUelIzcW9vaUxoTFY1UTFvWXpm?=
 =?utf-8?B?MFJNM1duUDVSRjhEVXczRDJ6aGdHOVlobm4zR1QwZE9TQWlqd052TzEyQzZm?=
 =?utf-8?B?dXdoZHZsSmNQREs5cXM5bGVCOWNTU0FWaGJKR2dFS2NtZmV1NUVDWFVQZTFO?=
 =?utf-8?B?Q3RxcXppTldPZ2NZNDZWWkdIb3huME42V1N2dy8rU09HMk50bHpPRzc2SVVq?=
 =?utf-8?B?SG9vUW5mcU9CREwwbXoxTXA1MURNRUs4ZmJWc1dqUjAwVHFSYzVQdVg4akdO?=
 =?utf-8?B?L0YycU0vdnl3Q3RSVFhNWUFSYVJ3c0xacGJWSmYvVHdHTk5rOGQ3ZW9mZkRn?=
 =?utf-8?B?ZjFGSTVYeGliMWx5YUxPUnJIVUVDMU9GM0VXNVFtTDIvdEpaS1lDd0Y1Q2NL?=
 =?utf-8?B?V0NvYk1ZcnpzWHJSVlVLKy9GMjhXWGJvdzZuVEFhSHJZdUN3eklvNytJdDlP?=
 =?utf-8?B?VDYramJNUjZBOWNTVFZzeTQrVnlIM1ZtRk9RVUhGcU96dGc5MGNYaGlxV3NX?=
 =?utf-8?B?RVpua0tnQSttWTRzUmQyVk5CTzRhU2Exa3ZMRzBhNGpjKzhVMjJWVUdkbmhJ?=
 =?utf-8?B?b1NZQkRSMXNpdzJ6NUtQSnJGNG1jaGFVNktnYlNRdWJNRzVoai8rZFE5cmFZ?=
 =?utf-8?B?cmlHRGR1MTBkeGpNcTFWOWdMZnJoZUx0S04rTy90L2J0YU9OUDd5ZWp5Mlcr?=
 =?utf-8?B?clFLZ3pqYjhFS2FyWWV6NWVwQ2xpUnl2RXBoMlBiS21oRTZUV1J6dWx3UE83?=
 =?utf-8?B?REZLeGIwRHMzYmNJQU0yaEI5dUpqSnJNOTNXYlJxMWxza05zdVQrNURNUnVC?=
 =?utf-8?B?OENRWjlwbnNFUHRTVkRacEVPZjFEaGNmSUsyME1MUnlIS2JTaXdmNzJLWnBv?=
 =?utf-8?B?STRvRVZhMitJZVlmYWRBZGE1cmkxSFJNbTZjOHp2aEFndEp4aFMydHc5RGNL?=
 =?utf-8?B?SkI1L0NRWWUzdXIybkZkTjBROWtZazdFWGRObHBUL2x3UWRqTFZjNU54RUlC?=
 =?utf-8?B?SEFZdmt3ekhpb1N3cUlYdDVUeU9jUUkvSmxzMmo3SXRhdDFndU9SaTZkZXBR?=
 =?utf-8?B?TjhVSUpVbkJyZmpmdnRYQnEwRHNtdXlGeThkTmdSUDJwRmNBNFdNcjFNZE51?=
 =?utf-8?B?MmsrYmRWL0pHWlI3VHJYb0IxcUE2dWQyd2NNNVdac2tnRDlKRUxYR2J4Umps?=
 =?utf-8?B?SUFkNlVIWEZZSVlSajRjcnBkYjM2blMyQWtFVUJXQjVYRnhsMFZWOGVlMlEr?=
 =?utf-8?B?UHAwMUZQakNhV0NiRU5TR3dDejVmblFCVFhJNVZZcENwU1A2b1MwVVJpVkJR?=
 =?utf-8?B?U2xkaEhIUFZtVGVweEhYQm1QQ2MxQk43TDE2SHFiNEFSYzd3Z0YxVE9KNHVh?=
 =?utf-8?B?SkpNendHWS9RQ1BkcGF5a3B1RURhVzNnN1d5ZTJpSGUzM2dXa3I3UUtIV0x4?=
 =?utf-8?B?N3hvR0xhbFVBenNLYU1qOVp4OVUrQ1ZrbndLcC8xVlkrR2ZrSmxHVzdWbmZu?=
 =?utf-8?B?YjRwZ2Y3bWM5cjZUdHlaZDBML0Y1QnV5RDRUWTVhWlNyZ1BuamYwZTVnQ28w?=
 =?utf-8?B?N2JEWGpXeVVFa3d3cG5zU21rcHAzUWtSWGlmbDIzQnliK2d2Z28zNm9JRDFD?=
 =?utf-8?B?WmtZbllEUGtjRHcyalpveDIwVTRITWhURkFOdzBWM3o4YlE4Wlc3MU5sRlhN?=
 =?utf-8?B?QmVyTFZsVmREck1LcUpVYXZXdWI4MEJBVjk4SjJWM3QxS1c0VFljVEVrb2lY?=
 =?utf-8?B?VWVBT3NUVU0rUW1FWmZydmlVSFJhYytzY1BCbVhhNEZFY0NtU0VZSVVCVm5k?=
 =?utf-8?B?THhFK0I0bUxoL3FPNHhtOGRSTDFZNVZIUWhxdHQ0V2R5Q1JyNit3R2U4bjdl?=
 =?utf-8?B?OVNZTFZhMThDQStrSEo4UHhjd1k2NDRZZUQ2cnhpTnBpeTVKdERaaXZyNE01?=
 =?utf-8?B?QnpoZnlSbnI5TTJGWDV1clRTYUZONFova0l1TjlqMnU4L3ZTUHdmVlczSEJR?=
 =?utf-8?B?L3hsb2ZOWHlpckpXOEhndkNicUFjY0dSWlNMaXVWMGZLWjZPS3hDM0JzNTcz?=
 =?utf-8?B?REVpWGFRWm9XTTU4eC80UzBPcG1NMllDMlNnUVNBdXJMNUs5ZUR6QnphZTds?=
 =?utf-8?B?RTZVc0cvRlljaEpVM3U4WDVVTERIRnpmTTFuQUFzdDlWVEo0UXJoTHMzMDd2?=
 =?utf-8?B?L2d4MzFVMTRMS2k3eWhVUnZlTTM4dm9ScGxXVUNCMEZJMXQxdFpBbkt1UzVR?=
 =?utf-8?Q?Ubx8BbUHMKR6piU7wg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7adea9-8ff0-498e-9e70-08df1d6be77a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2026 14:22:19.3621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdJj9wNv2yUF0374nENCq2XugB5AcNrz6cHNvI+DHcR/nRBkx/zc7plW0kI9s8zP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB460943

> [ ... 49 lines skipped ... ]
> +++ b/drivers/infiniband/hw/bnxt_re/qplib_sp.c
> @@ -177,6 +177,8 @@ int bnxt_qplib_get_dev_attr(struct bnxt_qplib_rcfw *rcfw)
>  	attr->dev_cap_flags = le16_to_cpu(sb->dev_cap_flags);
>  	attr->dev_cap_flags2 = le16_to_cpu(sb->dev_cap_ext_flags_2);
>  
> +	attr->mr_page_size_cap = BIT_ULL(28) | BIT_ULL(21) | BIT_ULL(16) | BIT_ULL(12);
> +

This is clearer if you use the SZ_4K/etc constants

-- 
Jason
