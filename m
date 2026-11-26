Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795678391;
	b=ys9NRM8C4Tr+X10rNJHw3RNS4cFAue0Lf8KUQz5303phM1IDFdBjVvE8kdZarkoqsoYr
	 zlDiYefGl9vureo4GFTjLRtROioYVkWw9vmpb+LCChsYQbnSqGPlcYIQYCIZjZRe7hxKS
	 MO66uIonZI+4wAq44hOBApszon+B/rFbbj4yypFgVqDNKqj6tFHldXO1nD2DA93g67nZZ
	 bfP/QvCTiIlTS3eWFFK3El/xIOqkt8uh6tFSZs14LdljuRxws+jZqkPUtE7gS2L66EZz2
	 mYVvwH+KO6Rxu2xPmclFQ9e2p9Glv7Qp7+m7V2j3deImfmABYPRThGaili/QLsGrOqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795678391;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=cdDzVB8qNOSII3G41JiBZ4JauAcZaGmBDR6lwdxvzig=;
	b=go0M840cZIdRpwjuqgIwcM5uAho1HTMT4O9BCwdVVBMibEfbaw6Ft0Sz14iOGFFv99wM
	 KiNg3scrSRt8lZfULI+qUXUY1/fwODtPmqSzMmt6xRYOqy6jE+uqRlxOwqZrFhnTkvIft
	 krk/8eT0WKK93O67kKn/XeIvs4VHfEs9JxTihRNhX3xW3uwu8yZpr5pz5AZGASg1x59XG
	 ZyRlV+eGo8dc4bvBAmT2HkAjmcC3IimF/KF9+WmP9MC5BL6jmfawwFGnMpIOa0YVjyzzL
	 Zk3SPRT8U6xXvMv4PvdB40lSC15j4R3k6M/D/4OfOjg+TpprbbFegn0uOIMqGOc+GvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=KLi2ZcHO;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5115E606A31C;
	Thu, 26 Nov 2026 07:33:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5115E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=KLi2ZcHO
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34l9d3130858;
	Thu, 26 Nov 2026 07:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cdDzVB
	8qNOSII3G41JiBZ4JauAcZaGmBDR6lwdxvzig=; b=KLi2ZcHOXmuy9n7pD9NKCn
	tm2q2KgpNRHpCfMO6up9yA8BkyJhPZap7vYZglAWfgFAFWKlr28jig3SAw6QqH7e
	ji9l5JuhopWuMS1cEhvlrACm7/HiYaabMFa77EQNDfF2mfxWScS1dNgjDM/UuwW/
	vObbZpms0VlH6xTFMyuNYLRHxsgu0XnSOM50pwUel8eHQc7RvPvuqSGFFClohvMJ
	Qzkw84PDC0KhK2GgkCP63Z+XBWZK4sBRZs97E4sd72hwf/vLnowbwln7XrpkOyM6
	PfW5CPVIjOreYG+A45zefp6lxwXBhLLu262P3wM2W3x/ugnmGgjRtVSrIu7lVPZw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fkr7yf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 07:33:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ7JH8Q1263840;
	Thu, 26 Nov 2026 07:33:09 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx3vq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 07:33:09 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ7X8It26411608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 07:33:08 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8450658052;
	Thu, 26 Nov 2026 07:33:08 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 87F1458065;
	Thu, 26 Nov 2026 07:33:07 +0000 (GMT)
Received: from [9.123.8.233] (unknown [9.123.8.233])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Nov 2026 07:33:07 +0000 (GMT)
Message-ID: <f3facfd4-56f7-42fe-a98a-78e983e2f36b@linux.ibm.com>
Date: Thu, 26 Nov 2026 13:03:06 +0530
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next v2] RDMA/mlx5: Read the CQ consumer index under
 cq->lock when arming
To: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
References: <20261126065219.1367677-1-mjambigi@linux.ibm.com>
 <sashiko-outbox-234933@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <sashiko-outbox-234933@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNyBTYWx0ZWRfXznk+TNDIZ64E
 Pg4crRjoCoSkw3qesM1DAdEcHnKtz1825AUg6FPSvcIowC8To8UXvwjSo1XFqorFFHWgAHBDc0U
 1HYxQ4ZtK2DNUUnn0u3hLsgng18+oVyhn21BzCmC/9MmiJYNJbpW+Wuu4DnvnjRj1ibcMrNr6k8
 rUWX0ivTVS6YeQYG1F3GKhxGlv5m+pYm9KcYt3aYEIIFKLz59kS+aZLReT9raqqRaxceGERK4dm
 uRx+IJUdGD761zjVsQcFWNwLOx9iji3ZVWMlFHcA87XaHKIyNRH2oA3Bv9lo077SsxAmYWoIzwe
 N6kJz0Dap8vm8C9FHujtHx3iQd8Iyx162ZH8qHj/0rhRPGpYmnGjXvX4Tg4Lou0QEratwMid3ok
 qvU6WdM2QstnBRvEpBGzJRkiaCiiH/HmR+/n9LlclT4kQeu1SCkBrSwuvmwPObeQBCYuE32eFb4
 1ayTefs8w0PpkzDZqvw==
X-Proofpoint-ORIG-GUID: HrzWiOkh83mJ0M0RjO5b61CYEUYg7cwL
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNyBTYWx0ZWRfX/JODjNvVTxvF
 ImvQP3T5QN27CBb3wPbET2FzcW53um7S6ZKCcAHJYK5wPrg8BaEJ2SGMfCENUtsHZPZaHRziJ+t
 4xH5W2P76y25BoQkzG/HpSLieLbpDYc=
X-Authority-Analysis: v=2.4 cv=A9z5rKWG c=1 sm=1 tr=0 ts=6b07e0b6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=g5j6EyKhnGvU3awiH8QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HrzWiOkh83mJ0M0RjO5b61CYEUYg7cwL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260027



On 26/11/26 12:39 pm, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] RDMA/mlx5: stale cons_index and arm_db race in
>   mlx5_ib_arm_cq()
> --
> 
> commit 8599d5eedfaa0e58f45970b9ef54ea48dbceee76
> Author: Mahanta Jambigi <mjambigi@linux.ibm.com>
> 
> RDMA/mlx5: Read the CQ consumer index under cq->lock when arming
> 
> This commit snapshots cq->mcq.cons_index under cq->lock in
> mlx5_ib_arm_cq() before passing it to mlx5_cq_arm().
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 2581a7693585b..65badcb90d34a 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -651,6 +651,7 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
>>  	struct mlx5_ib_cq *cq = to_mcq(ibcq);
>>  	void __iomem *uar_page = mdev->priv.bfreg.up->map;
>>  	unsigned long irq_flags;
>> +	u32 cons_index;
>>  	int ret = 0;
>>  
>>  	spin_lock_irqsave(&cq->lock, irq_flags);
>> @@ -659,12 +660,16 @@ int mlx5_ib_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
>>  
>>  	if ((flags & IB_CQ_REPORT_MISSED_EVENTS) && !list_empty(&cq->wc_list))
>>  		ret = 1;
>> +	/* The poll path advances cons_index under cq->lock; take the
>> +	 * snapshot here so the doorbell sees a consistent index.
>> +	 */
>> +	cons_index = cq->mcq.cons_index;
>>  	spin_unlock_irqrestore(&cq->lock, irq_flags);
>>  
>>  	mlx5_cq_arm(&cq->mcq,
>>  		    (flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
>>  		    MLX5_CQ_DB_REQ_NOT_SOL : MLX5_CQ_DB_REQ_NOT,
>> -		    uar_page, to_mcq(ibcq)->mcq.cons_index);
>> +		    uar_page, cons_index);
>>  
>>  	return ret;
>>  }
> 
> [Severity: Medium]
> Can releasing cq->lock before calling mlx5_cq_arm() overwrite *cq->mcq.arm_db
> and MLX5_CQ_DOORBELL with a stale cons_index and arm_sn?
> 
> Because cq->mcq.cons_index is an aligned u32, reading it under cq->lock and
> dropping the lock before mlx5_cq_arm() does not serialize the doorbell update
> against concurrent polling and re-arming. Moving the read before
> spin_unlock_irqrestore() also opens a window on the local CPU when a
> completion interrupt arrives while IRQs are disabled under cq->lock:
> 
> smc_wr_tx_send()
>   mlx5_ib_arm_cq()
>     spin_lock_irqsave(&cq->lock, irq_flags)
>     cons_index = cq->mcq.cons_index;  /* N */
>     spin_unlock_irqrestore(&cq->lock, irq_flags)
>     <hardirq>
>       mlx5_eq_comp_int()
>         ++cq->arm_sn;
>     <softirq>
>       smc_wr_tx_tasklet_fn()
>         mlx5_ib_poll_cq()             /* advances cons_index to N + k */
>         mlx5_ib_arm_cq()
>           mlx5_cq_arm(..., N + k)     /* writes arm_db with N + k */
>     mlx5_cq_arm(..., N)               <-- rewinds arm_db and doorbell to N
> 
> If the outer caller is delayed between reading cq->arm_sn in mlx5_cq_arm()
> and writing *cq->arm_db while an EQE increments cq->arm_sn and the tasklet
> polls and re-arms the CQ, the delayed write also overwrites *cq->arm_db with
> an already-fired sequence number, which can lose a completion notification
> during doorbell recovery.
> 
> Should mlx5_cq_arm() be called before spin_unlock_irqrestore(&cq->lock,
> irq_flags) so that reading cons_index, updating *cq->mcq.arm_db, and ringing
> MLX5_CQ_DOORBELL are serialized by cq->lock?

That ordering is *pre-existing* and outside this change: the arm record
and the doorbell have always been written after cq->lock is dropped, and
the v2 changelog already records it as a separate issue. Calling
mlx5_cq_arm() under cq->lock would not close it either, because
cq->arm_sn is incremented by mlx5_eq_comp_int() in the EQ hardirq
without that lock, so the stale-sn case remains. A complete fix has to
serialize arm_sn, *arm_db and the doorbell write against the EQ handler;
that is mlx5 work, not part of this cons_index cleanup.

