Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0899036C0D6;
	Tue, 11 Aug 2026 19:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476729; cv=fail; b=Ro5cur2Pg1dZBYjcv4TK/SZ3RNYCZ7cePzm9dOea4RAs/Er1h2YrkIEL7P81GpS0SxpooHUahqQ2jp3HorsQdFZREpR1J03sK/gZv7PCYtCJnuaIWRIgnwaqa7Ha23MHBZLXAT2P/rlbtz3FL2ACo7cbpr7lSgWbwOpdtR1q2Q0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476729; c=relaxed/simple;
	bh=v3mRwqxx1PouP8hQzo+z1xLyOsdrFS3+8teXG3jiyyw=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=lAc4fu91nV570UQQkWt8RXkpDaOkp/ADNX1Pdh0LLhVWBBK2JDQL+iwCcUz6Wr6RMGFoPCFUqu5p5L+CmXWexQjLW54KmGTIWgOsaTVKXOAfmGYqxovT8kMV88a7gwkjwVdqGbWcTDM4luacopbcsbiSa3tKEIaVLAsJQotCw7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p7+XgCiJ; arc=fail smtp.client-ip=52.101.53.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p7+XgCiJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZiMBlWKxp1T5278i5sPv3ynVZrlkVzfYCjH6SOVUACvH4LEcKE7kypl5EpUIuRZwdfKxQ01nEjmWhnjZaFHGv3Qu64cTej+pVoWQv3G1r0eEk0dYfKWJAvCzXXJtvFZx+wAfOo2L+JdH5Bzflhzxg8RFcf2uaZnTicMlys/FGk6YO4yJKlVajpi3CLE3L006pmOOzpVQUKRkqu+VUV6/uAV5PNtIhjk3i+KxAQoot3AcWlCoyswUvipj2a/n38BY2BvbZse65QYUHit/zt3T3zHnKmthcZEqKBWdPVTcLcXhgnVwgAz8fUxMxI8TbUk5jFIqE3XWxb9WRcd+8qD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlDWtJfEMhUVwsCJqpOU0KvMPFPyRRAKRGxb7RwXrJU=;
 b=FiT8ZPdInwN6ngNmCCw6WL1qW5bC65ivfnhlqLVxQg8pnSllUMRgtxdSmHTAlnh5UxIXNq1v4AB5Smj77dzpzXT6Cd6c/IQoO95nuw81hKu195tqzb35Ywv3G3tFkagT5Bw6Qzpm5P0yrydnVqBFC8aOKVdwABR5cT/grJBsUh+vdVrx7RJTYWQ1fk+NJn391ukjAP98DjGBohVnNe562/KbSsgk3xgYUEehpLkiDgTWa9ZSq0hLbEwupZUGtTRzs4vbiylsjLLn1ATF1Etxqw+BZb5TZ+6EjWlEal3/VldyFB9lo+vJJPqRC8Qw+q0xhEtSKARiXXGrze06QVU3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlDWtJfEMhUVwsCJqpOU0KvMPFPyRRAKRGxb7RwXrJU=;
 b=p7+XgCiJHhpDI5b6/7vNN8Y3Y7nSlhp4KVfJR969mzq4Ed23jPqz0iYBbn+eJE5XMudn4qyCYuT08ttu3BcZgTUKyJsQLUQS69pLPleihXkwhFqvL6HooVvuvaiu04SBKSlGDbFSpM8nI6mWRZeTM0lWe0q5oLq4+Eng9JHh2xVPVtBlyGdlVAr3cHuVbUbrNlJpwuF++MUIgDMHKDpA3iCTUs6ABD+P8q91V4iNQjoFHeUKDQ++eFJAprdRFkTAyHCcweV98fEsE79gqYIuXskJYjgRBHRqAoVlq5UaLjflMVIhZjRFWxCib6gHcz2Za0zrpI8Y86YIzUJO1OrKjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA5PR12MB999277.namprd12.prod.outlook.com (2603:10b6:208:608::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:55 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:55 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 11/15] RDMA/mlx5: Enable relaxed ordering on
 Memory Window mkey on strict-RO HW
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-12-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-12-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669516.282103.7957209371605560705.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:610:cc::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA5PR12MB999277:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a1fe3e8-4ef2-435b-fa56-08def7df30bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	b2pXZKx5MRw4Fe0N4V7+hPU3hSt48cd08HWJUHd5G5lb2M0vK3CKraOvtO1kjKMstsuOEYe2jARdEkAMhAvrkltsPbbU1mXigvPCMfUL15tVDhb4b9QVkUz993BBJ2W5yTrS42vS5PRkFHIpq0Fm6BrtssItRX791KE8weqWQ9UKYAFPtG2OF72N5utrHOuII8lr7hGWBCadjGvwl+anwVcOelmPdfocMRncIMX/d2iSAa2sYNDG4eyBnnDKu2BN16I57c8WTg2a913B3fGjYQEpwmHVH4jZ996vsuiKHJN0ssi4e7HM7w4kK2YeQfjoduxeyUbAaTlqhxGulPiScPy1DptGcz77uD5Mv83VnAMv5cq5CGghvVRO5l2aeZ9Noj7sJCSQSsAIsTSkHVTpY3C8CQFizUcRgHBxV5kHd7GGJC0nu7PnE06F8ljnYqk4zpy9wZMFVlQSFw9twXNaBvxZcsk7cnJDDL9X9vpksE9/yPcQ5QAYurduZ8zRLG8XlVPvNagd++lS9PERU6gBYQQRzdJHJ/yJBM9Zmcxwj7IYjil1JEt0vhq846Mg9xg39RkkalCsZ9bhdtyCeKDUWqljQK2v50B0+FiMf+ys+QRQ79OVYdNvDiFQYmrW+I7A1/Yoxds/wG3Km3hUn6BfdZ2G9l3ewRC4AsnI2fi3chs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHBFYnUxdTNmaEJ0V05EdjJ2bGZLUTdybVo4MUlNS0s4ZUZaeTM4MjRXSUoy?=
 =?utf-8?B?ZEkva0tBREtpVDZIWnZKa0dXYXhoWGQ1UDcyQU9Rb2lYdTdNQXNEYWN1aFRt?=
 =?utf-8?B?ZVpZQlNIWHhGZjBIOFB5cU52SjFld3FZT1JFR2Q4bkd5TTl6WjgwR3ZHbW5J?=
 =?utf-8?B?QXMzTjl6b3ZRSzZWams4WEZZV2t5V3hwVkxobmJvdVozMExYZFVSQVU2cXdI?=
 =?utf-8?B?UWFOR25USi9ZYWRHZ1Nub3k2WFJKZldIZERxdU85SW1JWkRQdzVZTU9lTHcz?=
 =?utf-8?B?c3h0dEFvZmNKSlh1VWREZW1FdEtwTUJSZGlwM0k3NjZuT01CU0ZCckhndFpV?=
 =?utf-8?B?SnhTNDVOcXVUK1VlTEJLcFkxc1gvNVJIWUNlQXZyYjVhNE1KOWRXV3QwZ2dj?=
 =?utf-8?B?ZTVIeXRHMStZcWUzZC9GdXh4MEdJL2Y5cjlxQ3NMMG9XeDh1VHJCMkFhQlJD?=
 =?utf-8?B?aEUydVZ2LzNWeVhrcGJnQnF2TE5NMUMya2ZRTlA3TDBEcjlTTHhMaEVuOEVq?=
 =?utf-8?B?eEUyMFBEVzZLQzBJbDd2TzRtMzUwd1RLZzZYT2FjMEh0U1pXVURMcXRVNUp6?=
 =?utf-8?B?N0NtUUdDclZ5L0dSZkZSK3JUNUZVUE0wYVV0L1dQVGpvM3h2SjBXYmlQWWI1?=
 =?utf-8?B?aGJleGdTcmlGVnArREd4WVRxUFRlUnEzUUxvTmtQWVJTb04yZVBsdVM3aTFl?=
 =?utf-8?B?bEVDVWs5VEdhcjFiOVJnN2VPdk9DaFhscnZiUE9WZDNSYlJPc3FDWDI2SVpI?=
 =?utf-8?B?Ty9JT1ZLM0h6ZXhWM3ppNkVYTHM4K01mcjlwb0Yzc09WeTJmRG5XTDAyTnhi?=
 =?utf-8?B?SDRNV0RPV2FXNThyMndWV29ZTkhoNUxkbUIzWlpyS2dVWW1NOUxxU1ROWVI2?=
 =?utf-8?B?VXlIRWIyQW1uNHRXajFwSFhkVmJMNW1hcWtVWHV2ZUJseFBQalByWVN4TmZq?=
 =?utf-8?B?M01zbHoydUp1Y0lwd3dqcVVHT1dERS9xSVBleDF1cXV3RWN2V0lDbnVMODF5?=
 =?utf-8?B?RFNKdDdrNVJaNUJ4Vllldi9RWGhDUUNiV3VDZU1vdHdQeFI3djYyYTU5VTM0?=
 =?utf-8?B?YnVCSk1qRXlqVkpPODFqVnBPZDltUnJsakNXM3prN0x1b1NLMEUrYU1nL2li?=
 =?utf-8?B?K1RyVjREUmVpditUY2RLdWl2M2ZTRXVHTW9JMkU1RVFTU0hHcm9RdjAzcUFV?=
 =?utf-8?B?aTZrU01CVVVoOEdNVk1FK0NsOHNycUxOSVlQdzJhNDNNT1hGbWIyR29RUldN?=
 =?utf-8?B?K1VUbTZFWUNxa2d3VXB0b2RIdlNVc3MvVHEzNnBGTU8yVUVTRGV2RUVJUjdV?=
 =?utf-8?B?R2tPay9KaldjUG9RUXBlTG1VUVp6TjFUQVRicVU1Q3VEOHN5MTJwRjBER3hH?=
 =?utf-8?B?WHFnOUsyR1U3Skp6V0pvaUJCZk5hMUZ6RmRNWDQ3Tmc1M0JUTUswa3M0Um83?=
 =?utf-8?B?RCtycERRL0VUNW9ML2xleG9ob2o5RERvTnlQNUQ3V1BQakk4bDBVQmc4QWo2?=
 =?utf-8?B?WVBHd3VOcnVSS2xBOU1OTXppUjl0NVY3LzRnYWZ3V0l3UjdGU3lBbXYwOTVo?=
 =?utf-8?B?VG9NVWYzUmY1Z0srVndRcXJ5U1pGU2QxT2JGY1NHSDBmZkkrMXp5NW0vMHVo?=
 =?utf-8?B?NlpJYm1pK1VEc21rdk14MnJEZ210LzZaV2krT2NZcjJ2R3N3d2tLSDczY2Nv?=
 =?utf-8?B?SG5rRC9LeVZERHRFR0VQU0hKWVFzMjFVOGdiS0luVXptN0NkS00zSEo1bnFU?=
 =?utf-8?B?ZitrWUY3UEx4YWtQOUtDMHlzVU5laHU5RTBBV1JWclRrU25QdldFeVEzaC93?=
 =?utf-8?B?WVFGdEE3WmdtZXdvM2NtZnRFam85VDlHN2FTeG5BaHpZakpmMmh4STVRdkow?=
 =?utf-8?B?dnF0cGtDWE9CU25tV0xlUUk5Rno3ODVuU0t6Vmk2TTEyeGNTM2dXWUl4emFI?=
 =?utf-8?B?R0Y4T2ZPeVBKNkd0aXJSZ0E1MW10VDNLcDQyS2Q3T0ttWHloTzF0bkl0N1BS?=
 =?utf-8?B?SkZPcU1ZbUxCL1pabVdOTFc2dnd0c25KWVp5QkYwWWpnM0JPcjlPZW94V0lk?=
 =?utf-8?B?VVRZSXV3TS90SjYzeDJEci91YkNNajVPVXFrd3hrRWZCeXJ6VC9jQ1lGWXRZ?=
 =?utf-8?B?c2ZIRlpXUnAwMitoeWhSN2VIM2FLVWF0UXE5SlBCK1QzdXVDT2J6QUNBazBm?=
 =?utf-8?B?VW55VnlUcG03K2hoUUtpRzVyTldBNnV1d3ZIa0Npa0lyVWo0TVJ0dFA1M3ll?=
 =?utf-8?B?ZG8wOWRPdTU0aGRoV3g2N0hSS1JXZXpFSE5oRW1zZVgyWHREYWtEQW16eXFv?=
 =?utf-8?B?eGZBc09GeitBZHlzWGtiMkt0SndEQ0JWT2FVRXVycEpTZVl3NlpXdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1fe3e8-4ef2-435b-fa56-08def7df30bf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:50.3610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDW+FIv74l8oucfpxdpHRDx7mWRXY5powmrnyLaxrt7m8q8bRQ+KRu4E8kcJYiB2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999277

> On hardware that restricts strong-ordering access for memory
> registrations, set relaxed ordering on MW mkeys.
> Without this change, MW allocation mkey creation fails on such HW.
> 
> Enabling RO implicitly for users in this case is acceptable since all
> users share the same memory registration restriction, so any MR bound to
> this MW is guaranteed to have relaxed ordering as well.

Are you sure this isn't a FW issue? With a KLM mkey what flags actually take
effect? I would expect the leaf mkey to be the one that provides the actual
in effect flags, not the MW.

If so then the FW shouldn't even be checking the ordering flags on the KLM
creations?

It is harmless either way, but it doesn't seem right.

-- 
Jason
