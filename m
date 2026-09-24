Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012012.outbound.protection.outlook.com [40.93.195.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7D486BB0
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 12:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790251853; cv=fail; b=JFmKGsj+OA5u312MwhHJQ1nzuADS+00F5NYAJAHUyKKtSkUfvCyzVTqcY0tqwrWWuCXz83AC7MZN7bDymNf8Y/WrJS9jXKrEZxFtE9WLGfQ72WCGiPkH/c8mXkSxqvUO57nxj9hPff2wc+e9KJHt6yWhqFqRuh4P0Fyj5kCgqRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790251853; c=relaxed/simple;
	bh=iXW26ZqoT2M8wgdu4nh6DfrMM8n30jQO1dgMoAsaDLY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fNHBk/5pP4E1TP5xsroyW7CiIv6YM7NLPMSgaEMFzeGthBknZ6Z/zRBiwzxruVBPlVBEMAo/sUl5jymhRAzuGgaHVmUBxlRS8LdoaIqoQJtvk0zneu5ddawElQz/Xir8h/NAwWjxnxbcihYKJpWRnOuokCfwXW2mLQvMP8ZMSOI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DwHzfsXA; arc=fail smtp.client-ip=40.93.195.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DwHzfsXA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vsViZI2wQIck5hTAayCr+2LQlEoqg9X6AtNjir0eKClur45VDutE82pPJqWUt77498LEuw4tQi+1pZ5NuWbq8HoOy8osu+NZT7Emit1S3ElPleX/iL/Rmi6t1nPE6daVEz/yR08VjNzOlkOM+POb+ZDPxNiefXp99MDrNV08xxS036M5vrUkTklYAaoSQaDrJBzTJtChmhCVu+Y4fa7nBI9VJS0EHybGYmLxgjx/LB3xO/Dx/82wQbBP66KkMs/J5D9g90VFLCXDtDsu7RA4NNnEk/Mwd4jL4XOTWJW5bwxp32GVmxxT+69+kMLdt1n31SteIJpCjD01Y4I7EzEveQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPG0WwGi2ozKAnwog72ML1GUDQJ2MN3WdDxcg7nAOKw=;
 b=WYyNYFPJU26pw2sA63oUI0S2bd1OZuSIFg2Lpe8pL9UHMiKgEC1Vx0jJ/sj3pKRr7PyKBSaszzjmmaLp1lNW+e4BCNiTPvSYy34sCCVlBnZH3uCXGBWzBe5BrcO/A4Pm3NzjltRYZbZnmefLufaNEI1hxrua9wyHbwAePqz+hSt/5s94tC3J6GxbCMUBSYa/XAHjXznVaCxNhuhgTOnAUwbYh/z2YiLCXJpIE0uXdSi0Hyunlj4LwUxsvjrtyz4rEH/oVvmKVVz1j8ot2AJr985SLkQY5JcMioBueaCyGb3szlUm1A82b2GgdzHtOvCtxyFXLz+N0frArC3W+hnGYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPG0WwGi2ozKAnwog72ML1GUDQJ2MN3WdDxcg7nAOKw=;
 b=DwHzfsXA4FhfXTWwt3WbDjKEhw8oDArdZgM3G2j64oW84MYagSzGv2bZC1jibhvi+63yhaDETNuUaSbzwcEoai+vZapgEPa7J2Qx85ydgJEvBwi3fYHYZXhIHL5e3a8nUHgigyWRi65/dyeLlelRcL6wClNO8Zn7e+K+hckW5as=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS4PR12MB999102.namprd12.prod.outlook.com (2603:10b6:8:2fc::9)
 by PH8PR12MB6865.namprd12.prod.outlook.com (2603:10b6:510:1c8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 12:10:41 +0000
Received: from DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25]) by DS4PR12MB999102.namprd12.prod.outlook.com
 ([fe80::dd7a:c52c:c74c:2a25%4]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 12:10:41 +0000
Message-ID: <ea205038-ee47-a764-edc6-d03c6ee94513@amd.com>
Date: Thu, 24 Sep 2026 17:40:36 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v2 4/5] RDMA/ionic: add Shared receive queue (SRQ)
 support
Content-Language: en-US
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
References: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
 <20260922095724.3683011-5-abhijit.gangurde@amd.com>
 <20260923095925.2121B1F000FF@smtp.kernel.org>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260923095925.2121B1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0056.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:270::14) To DS4PR12MB999102.namprd12.prod.outlook.com
 (2603:10b6:8:2fc::9)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PR12MB999102:EE_|PH8PR12MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: 10c64123-54d9-4faa-bd27-08df1a34da01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|10067099003|56012099006|6133799003|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	anUxZpnvDqZ4ocPFJ+/kdamYdUFn6NtqM8cUoSPbpYGXt7GSyc5cMWcQbuHoX+aQL+nZaMvQ4hvalFLfule5xLiix00jfIlT8rezO5RwHKgEWqXaT8t/XCn1S/ZMTOaIfJKaT9t0+oOduDIkI0kTLoKrXycmx7/WCMs8xdoOHKULPaSnyAkvVWZNt/LCt1pnwdB2hmiFLxlp0SDJz6CxU+q4IjuOMTmUXdJoUSpPl0Epc5ZoO4drKm7DYM3Eca9UQH/mVifdxK6NWwZuu++xz0U55DQtmhVL7Z9A4nwBGsNGabbiOnV1NjvasDNyW4T3c+7alw4yJRO+aesbfibcWbEU9g6OKDKKv2SiWrHYgHgUFLLdUXQtqVwSEM0lK7M0ZmUzCjaLFd8LCNLORjy41Sf1W1kxSYEXnzAUA9MDKDHTjxq0v4KyRZHz7lFmW+81b2Nu8l4i9GpHiOA8vF/BhhbfP0gmb0JFyjQ4vOEs/gYQ0lW9sLsIJqPJQTcwKT5izG35o4UG1lY31cn48jRih15wskosJrY7i1rz/VAJ1G2toR4YZXsO8b5u6Tqcy2qLaB8dilticFym3N/2rfqxRYlIb0rbsDXCRsVN1nxeKM2D1SK6je20O4TQoqJTkPdP3Vro2AQ4e+Ywt0Wo9MmNUkCas8G6EodStuPKggHXNik=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB999102.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUtlSDY0ckd2T1cvQXJxRGx2anV0eHl3S1lWZDBadE9LVmpNNU4xRURwTXdM?=
 =?utf-8?B?eDhvb3BPb3FrV3M3eVdwY0syMTR0NVd3aThJU0tnUVRXOWVoUkc1bXdaVVl6?=
 =?utf-8?B?aTJ4MjRpaDM5L09tT1NnZlk2akRpdC9YVFpjUkg5K1dJWnRWby9QV0ZKU2Jz?=
 =?utf-8?B?QmlRMmpRMkR2N043TlI2SDMwM3htWEdXSjdOdVlQbTVLeFlIZ3BENDgxeWIw?=
 =?utf-8?B?cEh1di9EUUl5UkNlL0NNNFduTkJQWDJ3b1AxSjFhd1Njb0tSTWtyaktITVJa?=
 =?utf-8?B?TERRWnZMeUVOTWpRbURON0d6cHBFeVh3QVBnMVVvVDNJSFpJbjB2RXUxYzJs?=
 =?utf-8?B?ck5iOG1ONlR0WDFWb3N1REQvK014RUUvY3B5SGdENWdJdm1pa3lHS3BTR28y?=
 =?utf-8?B?UTM4Y3ArblBqZ2s3dTY1ci9PaStocXZpSTcyaXZ4V2ZaZ2xrTHk0ZDJBWXBH?=
 =?utf-8?B?dlNpaTJRMll5Zm1VbFBiQSs1cG9kaHhHUjNkekVZcFBDUmFBSEFna092MHBM?=
 =?utf-8?B?cUJYNmttQ09XYk9PZ0tjVXNSaW9NRWJzcmJjdUpYcldVRjl1VzJzTXBKYzV5?=
 =?utf-8?B?OGxFbnNnMGlRRk9EUm9QK3BPWUVHdlZGb1ZQanltak5sNkJKV2tMN1VtYnVV?=
 =?utf-8?B?QU0yWm95K3NLemRaR0NmaWpRdUljbjN6WDMrRkxZcUtSV0RZMjI1dktmRkNs?=
 =?utf-8?B?Mk9CL0t5eDJxOXY2VkI2cURLc1JSOS9remlLcGtpOE56d2ZLN3FibTdYUk4v?=
 =?utf-8?B?UW50ZDJpcW5mdnpNUFUrblhTQUJKemdMTUVuYS9QSkR3OXU5K2JFRElwdEZn?=
 =?utf-8?B?Mkd6UEl6Q2w3a3FYVTd2Y21Dc2JuYU9ESGtPajVQenBWY3VRTEI5M2pLU21y?=
 =?utf-8?B?aC82Mk5OUEFWUGsxVFBmQXZIa3RSc09vNG5HRXMxWFZrSDVVYk9Fc3ExeU5Q?=
 =?utf-8?B?NUdIQ0txSkUrb0tMR1E2QnpDNHd2c1R4bzJpMTN3NFNDaEdFK0IvWWxwNVRE?=
 =?utf-8?B?LzhPQWQ3WHFBQmJDR2h6eUx0YTQwVGU1ZytXK3h6RWNwRkxwVzl6aGZidE1p?=
 =?utf-8?B?VTNuSHpEU0Q2QVBybjhKak42NnNKOUNPVkh3Wlc0eEdRQ1MzOEdqTGVJSEhy?=
 =?utf-8?B?ZjhPTWxwZ0l5WHhRZFNoeG12MEFiOEErb0ZwWUlEcGZZUWZWVmFVRUxyTXg0?=
 =?utf-8?B?b0NneHpPOTg0dUFvU1JYdnpONG80SDhTL2R3ZzMzRHdyUkdacnlCUmp2bFRT?=
 =?utf-8?B?cGNac1FYVkhkbXc2YWt5cHY5T0RyU2dLYTIrUnR1eG9TS3hSdlBsNTc3Zk5Q?=
 =?utf-8?B?ZEUvTzNRckQyU1dJMTY1L29teXlyaldGd1FRaXhIZkhCd2d2ZUwvbkhmMTZs?=
 =?utf-8?B?eldGdlhOVGtMR0hjV3Jwb1pBV0tLcmo3bmpsL0QxRzE5cGM0b3paVTJzUGRF?=
 =?utf-8?B?cTQxZWpaZmU5bzJQdVNKQ1B6WXB0dGVqVExWQkhncEJNT3ZrVnFyeEluSzNl?=
 =?utf-8?B?UWwyYkVJWFVGSlF4Ymo3VjI3aEFIM0J4RnFGM09hem5sV3ZtbWRkOUROeVQ0?=
 =?utf-8?B?UGNpSzlYeVBKUnZRV0hmRWdCTmp0a0RuSHc4dHJPemtUOWcyREFISnBQa1RM?=
 =?utf-8?B?d2ZHOHlFdi9pdHNna2FPcW40ekI4azhQQWtZaTlOYjlqRUw1VTNVTjVLcmV1?=
 =?utf-8?B?M3dSZnVTNWtxZU1GN0d3ZjJ1Y2Q5bndsVUJLMHRZNXFqYzd0d3lDRkd6ZXBq?=
 =?utf-8?B?Z1ExNGZLQUROQ3F3RkhsZkVjT2RNYjdKY1pxR25qa1BlMFZiYmNhS01GLzhU?=
 =?utf-8?B?d0lJbFBFMERwM1QvMGJXMkxxZUI3WHFLUVB5SVhGMzBYZTZnczk2Q28veXBI?=
 =?utf-8?B?ZlgyYzFoOE5GQU9wcjU1QzJIVGlmeVI2N0NsdlRKWngvZEN2VUtOcU1RSjBJ?=
 =?utf-8?B?czFQR3NoZ1ZCVVgzd3prZkd0c1U5OEdMZGk2T0RNZXJicGsvN3pKUGR6NHVI?=
 =?utf-8?B?NHpkeXBXTlpIOVozVXI5S1VhdnJrTlQ0RDRCWWYyNDhLd09QdFdxZFAyZDVB?=
 =?utf-8?B?ODNHdzZvemhINysxUjhqT001bDBROXprR0IvOHFQR1drMUR5U1BVYXBndVcr?=
 =?utf-8?B?bTlkZHFVYVZSUTZ4WXN4ZmN0aXVpVWJhUE5oNURRM1VxV050a2RycmtiSHZr?=
 =?utf-8?B?c2REVUR3akd3UUhtZFF6ckY1NXBIek1IUkNKWm9FK3pkZUpuZ1ZIUVRKbzh5?=
 =?utf-8?B?TWYxSE9HV3J5cThSdGZEcGpZb25IYVZ2VzZzTEJITG0xYU5IK0pGamMzdUtS?=
 =?utf-8?B?a1F4SWtHaCtxRDhGMGVFaEg3Vkw1eC9HRGtVTlEzazJqUzlIREFmdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c64123-54d9-4faa-bd27-08df1a34da01
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB999102.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 12:10:41.1140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1G+hJmYtFgWjwQ1pu6EUfLPiW88muYxq2h2IVLy/CbbuM0As1yWKjqVYcTyiSmxnljE4P+kwRZeKeMaT1RNxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6865


On 9/23/26 15:29, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] rdma/ionic: Invalid pointer dereference in ionic_create_qp when recv_cq is NULL
> - [Medium] rdma/ionic: Missing assignment of negotiated max_sge in ionic_create_srq()
> - [Medium] rdma/ionic: Missing ABI validation for reserved bytes in ionic_srq_req
> - [Medium] rdma/ionic: Incorrect TEARDOWN flag in ionic_modify_srq_cmd masks hardware errors
> --
>
> commit d35f9d0b1f3bb4677ebdb531833d86b7ea9eaeb7
> Author: Amit Kumar <a.k@amd.com>
>
> RDMA/ionic: add Shared receive queue (SRQ) support
>
> Implement device supported verb APIs for shared receive queue.
> SRQ is supported for userspace only. ionic_create_srq() returns
> -EOPNOTSUPP when there is no ucontext, so kernel ULPs cannot create an
> SRQ.
>
>> diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
>> index 7f0e8b63ed76c..ec9e1188f556f 100644
>> --- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
>> +++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
> [ ... ]
>> @@ -2360,22 +2401,25 @@ int ionic_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attr,
> [ ... ]
>> +	} else {
>> +		if (udata && (req.rq_cmb & IONIC_CMB_ENABLE))
>> +			qp->rq.cmb = req.rq_cmb;
>> +
>> +		/* for non-srq qps, rq qid is same as qpid */
>> +		qp->rq.qid = qp->qpid;
>> +		rc = ionic_rq_init(dev, ctx, &qp->rq, &req.rq, &rq_buf,
>> +				   attr->cap.max_recv_wr, attr->cap.max_recv_sge,
>> +				   req.rq_spec, udata);
>>   	}
>> +	if (rc)
>> +		goto err_rq;
>>   
>>   	rc = ionic_create_qp_cmd(dev, pd,
>>   				 to_ionic_vcq_cq(attr->send_cq, qp->udma_idx),
>>   				 to_ionic_vcq_cq(attr->recv_cq, qp->udma_idx),
>>   				 qp, &sq_buf, &rq_buf, attr, req.ionic_flags);
> [Severity: High]
> Since this patch adds SRQ support, it permits QPs to be created without a
> receive CQ, meaning attr->recv_cq can be NULL.
>
> However, to_ionic_vcq_cq() calculates an offset from its argument.
> If attr->recv_cq is NULL, won't to_ionic_vcq_cq() return a non-NULL offset
> pointer?
>
> That invalid pointer is passed into ionic_create_qp_cmd() where it gets
> unconditionally dereferenced to access recv_cq->cqid:
>
> 	} else {
> 		wr.wqe.cmd.create_qp.rq_tbl_index_srq_id = cpu_to_le32(qp->srq->rq.qid);
> 		wr.wqe.cmd.create_qp.rq_cq_id = cpu_to_le32(recv_cq->cqid);
> 	}
>
> Would this cause a kernel panic upon dereference?

This is not reachable. ionic_create_qp() rejects qp_type > IB_QPT_UD, so 
only GSI/RC/UC/UD reach the driver, and uverbs always supplies a recv_cq 
for those types.

>
> [ ... ]
>> +static int ionic_modify_srq_cmd(struct ionic_ibdev *dev, u32 srqid,
>> +				u16 srq_limit)
>> +{
>> +	struct ionic_admin_wr wr = {
>> +		.work = COMPLETION_INITIALIZER_ONSTACK(wr.work),
>> +		.wqe = {
>> +			.op = IONIC_V1_ADMIN_MODIFY_SRQ,
>> +			.len = cpu_to_le16(IONIC_ADMIN_MODIFY_SRQ_IN_V1_LEN),
>> +			.cmd.modify_srq = {
>> +				.qid = cpu_to_le32(srqid),
>> +				.low_wqes_limit = cpu_to_le16(srq_limit),
>> +			},
>> +		}
>> +	};
>> +
>> +	if (dev->lif_cfg.admin_opcodes <= IONIC_V1_ADMIN_MODIFY_SRQ)
>> +		return -EOPNOTSUPP;
>> +
>> +	ionic_admin_post(dev, &wr);
>> +
>> +	return ionic_admin_wait(dev, &wr, IONIC_ADMIN_F_TEARDOWN);
> [Severity: Medium]
> Does using IONIC_ADMIN_F_TEARDOWN here mask hardware errors?
>
> If the device is resetting, ionic_admin_wait() will return 0 instead of
> -ENODEV. This would cause ionic_modify_srq() to incorrectly assume success
> and update the software srq->srq_limit, permanently desynchronizing it from
> the actual hardware limit.
Ack
>
>> +}
>> +
>> +int ionic_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *attr,
>> +		     struct ib_udata *udata)
>> +{
> [ ... ]
>> +	udma_mask = BIT(dev->lif_cfg.udma_count) - 1;
>> +	if (udata) {
>> +		rc = ib_copy_validate_udata_in(udata, req, rsvd);
>> +		if (rc)
>> +			return rc;
>> +
>> +		udma_mask &= req.udma_mask;
>> +	}
> [Severity: Medium]
> The ib_copy_validate_udata_in() macro checks that any userspace bytes beyond
> the req struct are zeroed, but it doesn't validate the contents of the rsvd
> array within the struct itself.
>
> Is there a missing check to ensure req.rsvd is strictly zeroed? Without it,
> buggy userspace applications could pass garbage in these reserved bytes,
> preventing them from being safely repurposed for future ABI extensions.
Ack
>
> [ ... ]
>> +		if (srq->rq.cmb & IONIC_CMB_ENABLE) {
>> +			ionic_rq_mmap_cmb(dev, ctx, &srq->rq, &resp.rq_cmb_offset);
>> +			if (!srq->rq.mmap_cmb) {
>> +				rc = -ENOMEM;
>> +				goto err_srq_cmd;
>> +			}
>> +
>> +			resp.rq_cmb = srq->rq.cmb;
>> +		}
>> +
>> +		rc = ib_respond_udata(udata, resp);
>> +		if (rc)
>> +			goto err_srq_cmd;
>> +	}
>> +
>> +	ionic_pgtbl_unbuf(dev, &buf);
>> +
>> +	attr->attr.max_wr = srq->rq.q.mask;
>> +
>> +	return 0;
> [Severity: Medium]
> This updates the negotiated max_wr, but is it missing an assignment to
> attr->attr.max_sge before returning? Without it, userspace wouldn't receive
> the actual negotiated max_sge limits.

Since driver does not modify it, ib_uverbs_create_srq() just echoes back 
whatever userspace requested.

Thanks,
Abhijit

>
>> +
>> +err_srq_cmd:
>> +	ionic_destroy_srq_cmd(dev, srq->rq.qid);
>> +err_cmd:
>> +	ionic_pgtbl_unbuf(dev, &buf);
>> +	ionic_rq_destroy(dev, ctx, &srq->rq);
>> +
>> +	return rc;
>> +}
