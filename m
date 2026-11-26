Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795675860;
	b=psAvlOWJuPRcFQUfMDViwNCSTF0oU7GDyauBC1USAMIC8gYijoUhfz/dywolBmpePSRI
	 iprS07GbVjdPbzrqgu00k4kwnXbfxnXyp0nPAaQyVpZ0BWBtFPG4O2j7mZ5MsVtabFXdW
	 oEJJ2zu1tz5CdOhGb7FSdO2Lwk5GUZQU1oaA1rOmFE31LEfYf8tNTmbFIZ5UqDi0l6QfI
	 bUXMEB64o6Uh0l8dbjuudrou6mbGYv2YtF7tN+kpmWxszbABNe7DQqd5GUHvMkQT73EVM
	 DZaPFa2iWsYgZcXYz63q6CUzXJND0jHbsitMym/eo73bCWIHiubXFhTOADJJThqJ8VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795675860;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=S104IabMkSBSvU4huPto/izpSQtTagcwY+/ZZl14rFw=;
	b=OTMxDsQRNHDEdhxpiHp7VtbSfK3LutVZah8zx5iMffrtc2icvQDarAjuDeUIm/AYWNkf
	 sYwaaU0dZlYefvSRE98oCmXbW4e4vH1xs1Gi21HZX3CUCqFMtgXqvZbzyX7EoNj+PrT+b
	 ci0F/wTxPHpY9Ou27NGvyAxqW071HHTLRhForlQLDpaXi1zu0gNp+56g5d3sLdWMeA97f
	 12Mnzn6gviEF0US1cJFE/U7CfNu8gNPkVfco0rGeZF58FalYOtgosgtLJ0+4tpNbjD9Id
	 BU+d/z1s87qfxAAvkOYiHqiCBmdQGqnPO8OiYHUZDSVpHR34tnQe3ZNY6agRoyxUFng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oWtBpu8A;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F6E606A32C;
	Thu, 26 Nov 2026 06:50:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07F6E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=oWtBpu8A
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ356cs3087614;
	Thu, 26 Nov 2026 06:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=S104Ia
	bMkSBSvU4huPto/izpSQtTagcwY+/ZZl14rFw=; b=oWtBpu8AzuKphHkcr4IXb3
	0ZDxPku1cfH25p34rn8apzaDu22Zp+r6dl5lSJzTamkFYSS4p2mhVvmwum8xuszC
	vFr4u+llMmhCnTEhAyOz8iOqxVut0m32KR7EQsffRPJKU3yl9SoSBna2+k4VyQSf
	duESN6jNpCczrXat85UlXTSltjBN76MxKxHxKeogBf43i8RJO77VTp33IdLdi+bm
	Dj6q/nlr0a4NS1MX297Du2jdfZS5hhh5VCbDcv33tHoIdLm9ReNFpG2ez72WtPG+
	iy0QL2gPYJSGlJvp3pjSfzY7ZRpew10CoWL5k8xEccZa8gm+RL3UOT+KRz1oXing
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34gvfhef-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:50:58 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ34bgW2799182;
	Thu, 26 Nov 2026 06:50:58 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3q4hhduq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 06:50:58 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQ6ovSG37683890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 06:50:58 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A456D58056;
	Thu, 26 Nov 2026 06:50:57 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DC3358052;
	Thu, 26 Nov 2026 06:50:56 +0000 (GMT)
Received: from [9.123.8.233] (unknown [9.123.8.233])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Nov 2026 06:50:56 +0000 (GMT)
Message-ID: <18349a41-0fce-4edb-a5fe-2c56de44b12b@linux.ibm.com>
Date: Thu, 26 Nov 2026 12:20:55 +0530
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
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Read the CQ consumer index under
 cq->lock when arming
To: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
References: <20261125084054.1349677-1-mjambigi@linux.ibm.com>
 <sashiko-outbox-232958@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <sashiko-outbox-232958@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=CYCdd7rl c=1 sm=1 tr=0 ts=6b07d6d2 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=FZYZ6916GaroF2OMbLMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX1934S3N0QhuI
 Uw5rOmZEcZ7iPIhnD4GfrtKwg+B8tMAQUro4tGkubbp277W1zv8dNpFJ6lwYeuwl9JYeoVATXeO
 MeuZ8H2jDf4EwH94y9lCd0DKfcFZ45A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAyNSBTYWx0ZWRfX05sjp/X+AgJi
 KasnLmcS9KGxWu4iOgR6XQus1a92fd5Idnp42k9g3jnhl0h1NQIqT7U3rbCzaOlSewZK23qaXM2
 15CzF9ubAelZHRHntqAG5i/QywsEl4PcSmh9FE7oP2XrB4F9ZssThxpKwIrGYnrUnFmXLjA6fcj
 gld1Y/ij2RHRY2tLETLn9ZrL+MpBMsaGJqB0evmA1beVz0/jRkG7Jez/ep8rAC7/MXXjYwe3oJg
 P7A57e8nqcvTrCsLgA0aFBgO368wiJZO6YxHkU5pvQOsqylZjMTSEWxFssJy7DrADpK1GTRlmLH
 zbvGdXYckR5CVOzOkj3hjgz7iriIShUcloiS3rym59586bkKJfcVlsOtPiInQxDVB6ZmB175vAw
 ZBGSFkDtaj8WVl5F/a0lv6870rV8R/vbpBI62aPwvCbWad2F/nChXhb2bOGmc1N3S5inWnuP8GI
 OAE5fWBv2I/xkBqUORQ==
X-Proofpoint-ORIG-GUID: -xlNgPhGd7Qe6qPXIef-uKPYE6B8hVb_
X-Proofpoint-GUID: -xlNgPhGd7Qe6qPXIef-uKPYE6B8hVb_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_01,2026-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611260025



On 25/11/26 2:26 pm, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] RDMA/mlx5: race on arm_db and doorbell in mlx5_ib_arm_cq()
>   outside cq->lock
> - [Low] RDMA/mlx5: inaccurate Fixes trailer in mlx5_ib_arm_cq() commit
>   message
> --
> 
> commit d56119318ab1d6b70585159d086babf002396fda
> Author: Mahanta Jambigi <mjambigi@linux.ibm.com>
> 
>> RDMA/mlx5: Read the CQ consumer index under cq->lock when arming
>>
>> mlx5_ib_arm_cq() reads cq->mcq.cons_index after dropping cq->lock, while
>> the poll path advances the index under that lock. A ULP that arms the CQ
>> from process context while the completion tasklet polls races on the
>> index, as SMC-R does from smc_wr_tx_send():
>>
>>     BUG: KCSAN: data-race in mlx5_ib_arm_cq [mlx5_ib] / mlx5_poll_one
>>     [mlx5_ib]
>>
>> Read the index under cq->lock, which every writer of it already holds,
>> so the doorbell is programmed with a consistent value. A stale index can
>> only cause a spurious completion event, never a lost one.
>>
>> Fixes: ce0f75093282 ("net/mlx5_core: Modify arm CQ in preparation for upcoming Ethernet driver")
>> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
> 
> [Severity: Low]
> Is ce0f75093282 ("net/mlx5_core: Modify arm CQ in preparation for upcoming
> Ethernet driver") the right commit for the Fixes: tag?  That commit only

No. The unlocked read predates it: e126ba97dba9 already read
cq->cons_index inside mlx5_cq_arm() while mlx5_ib_poll_cq() held
cq->lock, and ce0f75093282 only moved that read to the caller.
25361e02c448 added cq->lock to mlx5_ib_arm_cq() for notify_flags, after
the read had moved, so it did not create the race either. I will drop
the tag: this is a KCSAN annotation, not a regression fix worth stable
backports.

> moved the unlocked read of cons_index from inside mlx5_cq_arm() to its caller
> at a time when mlx5_ib_arm_cq() did not take cq->lock at all.  The unlocked
> read against mlx5_poll_one() dates back to e126ba97dba9 ("mlx5: Add driver
> for Mellanox Connect-IB adapters"), and cq->lock in mlx5_ib_arm_cq() was
> introduced by 25361e02c448 ("IB/mlx5: Generate completions in software").
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
> Can dropping cq->lock before mlx5_cq_arm() still let a delayed caller
> overwrite *cq->mcq.arm_db and MLX5_CQ_DOORBELL out of order?

That ordering is not introduced by this patch. *cq->arm_db has never
been written under cq->lock, and the 32-bit doorbell write lost its
serialization when 5fe9dec0d045 removed doorbell_lock from
mlx5_write64(). It is a real, older issue and this change does not claim
to fix it; I am keeping this patch to the cons_index data race and can
follow up on arm serialization separately. I will also reword the
message to talk about the value handed to mlx5_cq_arm() rather than the
doorbell.

> 
> In SMC-R, smc_wr_tx_send() arms roce_cq_send from process context while
> smc_wr_tx_tasklet_fn() polls and re-arms the same CQ from softirq context:
> 
> CPU0 (smc_wr_tx_send)             CPU1 (smc_wr_tx_tasklet_fn)
> mlx5_ib_arm_cq()
>   spin_lock_irqsave(&cq->lock)
>   cons_index = cq->mcq.cons_index (N)
>   spin_unlock_irqrestore(&cq->lock)
>   mlx5_cq_arm(..., N)
>     sn = cq->arm_sn & 3
>                                   <hardirq>
>                                     mlx5_eq_comp_int()
>                                       cq->arm_sn++
>                                   mlx5_ib_poll_cq()
>                                     cons_index = N + k
>                                   mlx5_ib_arm_cq()
>                                     mlx5_cq_arm(..., N + k)
>                                       *cq->arm_db = (sn + 1) | (N + k)
>                                       mlx5_write64(..., (sn + 1) | (N + k))
>     *cq->arm_db = sn | N  <-- overwrites with stale sn and index
>     mlx5_write64(..., sn | N)
> 
> Even without an intervening EQE, CPU0 rewinds *cq->mcq.arm_db and the MMIO
> doorbell from N + k back to N; if a completion EQE also incremented
> cq->arm_sn before CPU1 re-armed, CPU0 overwrites *cq->mcq.arm_db in host DMA
> memory with the already-fired sn, which can lose the completion event if the
> HCA reads the doorbell record.  Concurrent mlx5_ib_arm_cq() callers also
> still have a data race on *cq->mcq.arm_db and unserialized 32-bit doorbell
> writes in mlx5_write64() on 32-bit architectures.
> 
> Calling mlx5_cq_arm() before spin_unlock_irqrestore(&cq->lock, irq_flags)
> would serialize the cons_index snapshot, the *cq->mcq.arm_db update, and the
> MMIO doorbell write.
> 

