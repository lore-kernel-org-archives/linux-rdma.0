Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2FE202F70;
	Wed, 26 Aug 2026 09:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787735572; cv=none; b=hwDr4dv1ewx/7CS7E6mZtLsfvGgMbrCr/R7/Er4IepVefB3CUSg08uLP1ETlfzNjSu7GkfRVdbsrCSyKQUnBlcjBcAld/vnJsUPtFsf4FKZZym/Wab+8WX6Ahz2Vzu9lrmfOL2IccfqBSkzBT2F5AMjlQidORwBEI0rsWB/LHys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787735572; c=relaxed/simple;
	bh=CgYMcnAFOs7A667WO/AnopTwRSxlXcu7jyEPEx1Tjeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B6YTV2kEThoDqFlpubFVuFWlWoiUbRFc4g3+DE7m5J1/W6bE9SC6UOO081O+Srzzt1JTduROmBUdihelGsmzCNJQr6/rg1Kuhn3iD4ZXdBONHm/OU6caLXAeyeT35Njmjo8S9PFEEjWUsFV52D8Z4fWB19QvZaV9IZAqGpecsXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fdBLU58g; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fdBLU58g"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67Q6VXkd3215877;
	Wed, 26 Aug 2026 09:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=kQMhXx
	HrVSAgfEQM1EGI3dSOANE6r/W1m7YpbF90zMM=; b=fdBLU58gO6fiQRIr1a/8ic
	I6Qo6EWxhvGkurZt50zgIpGNc6VQGnYD2sPh5rBRoz9jaI/VRX8fZnk0RITyJcNT
	wtzRV21T8BWaHcXGdEBCK46do5YNdVP2PdhCzb5FFMpZDz/j0J7X2JZ9ETWStprz
	6NlVcDw71udB99Oax9mDIOMvo/E/8PTjJmTkUWEfe1tYlIFoQy/FUujyfo9bsOmM
	tHBV1t+S3oHzmPFZj7JE93+oLct4x03qp6uAYOJmNQ09vjSzbkgm1R11K0llWfsO
	k+2ktEhIMj71Re4Hxj5k3Kl66QljcLIv/JvrNameiaLtga8apOeK8rBbLCKpBSwA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g4wpj3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 09:12:42 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67Q9BvJ1032478;
	Wed, 26 Aug 2026 09:12:41 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkh91kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 26 Aug 2026 09:12:41 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67Q9CdGI4325892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Aug 2026 09:12:40 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E10F45805A;
	Wed, 26 Aug 2026 09:12:39 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C7E058054;
	Wed, 26 Aug 2026 09:12:33 +0000 (GMT)
Received: from [9.39.21.214] (unknown [9.39.21.214])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 26 Aug 2026 09:12:32 +0000 (GMT)
Message-ID: <bd56d983-e5bf-4343-910e-8965c3ff57dc@linux.ibm.com>
Date: Wed, 26 Aug 2026 14:42:31 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: serialize clcsock teardown in
 smc_accept_dequeue
To: dust.li@linux.alibaba.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alibuda@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        stable@vger.kernel.org
References: <20260824065851.1070988-1-mjambigi@linux.ibm.com>
 <ao5bB9OCbJ5PQbEp@linux.alibaba.com>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <ao5bB9OCbJ5PQbEp@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 0EGFz7L7CCyLoUkJTrx8Y4THJ2Yg2B_x
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI2MDA3NCBTYWx0ZWRfX78SiIYXFQoTG
 VPDzpNZu3GkAfSSiLUH4WoHwUjDLcaDlzxesG+gwg9661eR5GwzD1tmxuwsShZuO64VxtR/Ze24
 TP8EFnh58dvz9E02SalQEXjSr8SNrtk=
X-Proofpoint-GUID: 2b_4YxuO4qjkVY6LTv84xLLIfZ0QNvjK
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a8eae0b cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=9-ipJYhsd5VgnM9X28IA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI2MDA3NCBTYWx0ZWRfX/UM2awxsjRCT
 9z/QfiICsdws6lJJTM2SMLWCwee0duZP+bM0E7U+CQDmZCIpWiOLVqOMqa0CLiRSplyA5uol7LS
 9A51NJaDF4YnA8PmyHgSnhRaE7R1M7HVvylxqLEteZcunlVpw2vPoLl/Etujg+FmjkcASI7+PFt
 F4dgMY3D23BvDTv06X5Exmmux24AqSYHbWcUa2kwhrEf6qwjsvbyrRmN994L7rw/Vsf6XyBXLWB
 WszOIuCHQl97PuR+LcNR9aj/9pj6f/PV3hSE1uFwazCZtFEISvuNR6wX6rEGqGpDqV3N3hS4can
 f6dy6n+R4NiCHBkej77zrDuUz1KTWu99lkIs1u8U75I/sNLM6DArbGQEaBJbizqi3MSU6KsYPGu
 up6vg6qfX1svLMGqKkIAYPuPC9AYuCnvJnya3v8btYHUwTLvXMwEVYi5j8vgSEizCCRgq0616k2
 QClq61JB/I5AlpRVsDg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-26_02,2026-08-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608260074



On 26/08/26 8:48 am, Dust Li wrote:
> On 2026-08-24 08:58:51, Mahanta Jambigi wrote:
>> smc_accept_dequeue() open-codes clcsock teardown for SMC_CLOSED child sockets
>> without taking clcsock_release_lock:
>>
>>  new_sk->sk_prot->unhash(new_sk);
>>  if (isk->clcsock) {
>>      sock_release(isk->clcsock);
>>      isk->clcsock = NULL;
>>  }
>>
>> This bypasses the clcsock_release_lock discipline used elsewhere in SMC clcsock
>> lifetime handling. In particular, other paths serialize clcsock access and
>> updates with clcsock_release_lock, but this local teardown path does not.
>>
>> Fix it by taking clcsock_release_lock around the local teardown and by storing
>> NULL before sock_release(), matching the established ordering used by other
>> clcsock teardown paths.
>>
>> Fixes: 127f49705823 ("net/smc: release clcsock from tcp_listen_worker")
>> Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
>> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>> ---
>> net/smc/af_smc.c | 12 ++++++++----
>> 1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> index 00403175b740..bbf8269876ee 100644
>> --- a/net/smc/af_smc.c
>> +++ b/net/smc/af_smc.c
>> @@ -1833,10 +1833,14 @@ struct sock *smc_accept_dequeue(struct sock *parent,
>> 		smc_accept_unlink(new_sk);
>> 		if (new_sk->sk_state == SMC_CLOSED) {
>> 			new_sk->sk_prot->unhash(new_sk);
>> -			if (isk->clcsock) {
>> -				sock_release(isk->clcsock);
>> -				isk->clcsock = NULL;
>> -			}
>> +			mutex_lock(&isk->clcsock_release_lock);
>> +			if (isk->clcsock) {
>> +				struct socket *clcsock = isk->clcsock;
>> +
>> +				isk->clcsock = NULL;
>> +				sock_release(clcsock);
>> +			}
>> +			mutex_unlock(&isk->clcsock_release_lock);
> 
> Why not call smc_clcsock_release() here ?

I initially considered *smc_clcsock_release()*, but it unconditionally
calls cancel_work_sync() for child sockets (since listen_smc is always
set and current_work() != &smc->smc_listen_work is always true here).
Even though smc_listen_work has already completed before
smc_accept_enqueue() is called, cancel_work_sync() is not truly free on
that path — it still acquires the worker pool spinlock and scans the
executing-worker list before determining the work is idle. The inline
open-coding avoids that overhead entirely.

> 
> After looking deeper into this issue, I found smc_diag_msg_common_fill()/
> smc_getname() and many other branches hasn't hold lock_sock() and may also
> have the race issue ? For example, smc_getname() calling smc->clcsock->ops->getname()
> while the other workqueue is releasing the clcsock.

I am addressing the smc_diag_msg_common_fill() issue via a separate
patch[1].

> 
> Since SMC has long been plagued by this kind of locking issue, I think we
> should consider a long-term solution to address it.
> 
> What about stop releasing the clcsock early and tie its lifetime to the SMC
> socket itself. The early paths don't really need to release it ??? a
> kernel_sock_shutdown()/tcp_abort() is enough to stop it, and calling them more
> than once is safe because the TCP layer already handles that.  sock_release()
> is different: it frees the socket, so it must happen exactly once. If we move
> this single release to the final teardown of the SMC socket, no user can exist
> at that point anymore (fd users are gone after smc_release(), and every
> work/accept-queue context holds a sock reference), which makes both
> clcsock_release_lock and all the if (smc->clcsock) NULL checks removable.
> 
> Ideas ?

I agree, but it is a significant refactor touching every early-release
path in af_smc.c, smc_close.c etc & it warrants its own patch series
with careful ordering of changes.

[1] -
https://lore.kernel.org/netdev/20260807081606.3200128-1-mjambigi@linux.ibm.com/

