Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049934E06C0;
	Mon, 19 Oct 2026 11:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408080; cv=none; b=eSsA6U7xH/SlXe+k2YduxeBwl4tpXjbK+1+F5yhJpFhvjre1mr97WZn9/g6lFpBl0Dai4M3+4OLaX8WjNyDtVVzn62lQwuoZdoa3c0AeGbx6METB41kGpnljGvSE8dddZ9Y8BvazflnCZzuKcz5lIYGsFXvA5bPTKK9nOFMVtg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408080; c=relaxed/simple;
	bh=/SMkyG4D1nKZK3teIM2FvdGn4vPQTljQ7eBlBJplf2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgJoXyW4Vbr/4QTEE8YtpArPAhscS3KHXZk4yAfzBL/DWe/0akvdVoY8qpUDAJ7vyZXl7+xRQDFD1FBTrRTqF4UTk8t+9RoKfBKA97cOJpIuw8vl7D99x9Jh8tqdNdgIjIB0n0zFWC8DHnBrkrT6gFoJFwt4199RMJuG3KrOOvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=e3GUQeO3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="e3GUQeO3"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8iEFb3449572;
	Mon, 19 Oct 2026 11:07:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hZ/LEv
	O2H3SoNtJ0eyRB0NbxK/vVC0zH6TQEI3gnGpo=; b=e3GUQeO3GvcztIELCDMX39
	A44lq4+1LoAp21YrzdsgKEcopCPzZmrlnbYqgfFdhwwhD3V9ncySTVNJcJ4t/E4B
	WhJoCNaP7geKF+m3eT16l9oorwvUEHfiQAox6fErvPYN2tMpW1AW/T+tDetTZJjn
	TLud21AjnRDu50lBal51o8bK6tGw3nRWlsrz2fcay89j3xeIgTU5bkEdT9QFiW9D
	eNT7dMz4nJ3zMN2JVXJfpa/Ic/ZhsyRUL9i2gGNQ5pIjugn2Z6lIqYkMwautLx4E
	cTS9Xc3TqwHViOXTh9n9lEjEEmrGaQtYOK8k3wvVuHM5bh4iBcFn1BjhoMZi87LA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hc0h5ashf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 11:07:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69J8Yqlf3891077;
	Mon, 19 Oct 2026 11:07:47 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hcp1yd4g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 11:07:47 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69JB7jOc32768468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Oct 2026 11:07:45 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2C0E58062;
	Mon, 19 Oct 2026 11:07:45 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7D325805D;
	Mon, 19 Oct 2026 11:07:38 +0000 (GMT)
Received: from [9.124.218.162] (unknown [9.124.218.162])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 Oct 2026 11:07:38 +0000 (GMT)
Message-ID: <2b6f56ed-60ed-4d27-884d-849e85afbce4@linux.ibm.com>
Date: Mon, 19 Oct 2026 16:37:36 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v11] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261015081349.1252391-1-mjambigi@linux.ibm.com>
 <179240154272.3135.17238777571997282600@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179240154272.3135.17238777571997282600@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE5MDA0MiBTYWx0ZWRfXwtbhrS7sdGqy
 JS1b91ug51NZYawPj63J1OFFZKbC5QUVFPBctO9fwTtyHEtyXXdrquLQ2RrLbe28Lf/ORq5atB8
 STszhqpJk1ONeUf5tjwZLi8nj4A9h80=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE5MDA0MiBTYWx0ZWRfX+ogCRlDiaJ0h
 JahbmWrIzJn9WbnOfQNDEmtoeG/KcRoDOmqHSOKCNVhioOQ6feTx7mm8R5xUObxevHuGMlzsxu/
 /b0WZMjN0clU6Kr3+zKMSAdFpTdkaKVy+Mqyv/FjsGX8KqJrsD5t7FGa005nGccZx/ZSTwCBW7n
 1zVZLAnWYDS9/kBIT+crElirNMRHvUj6T0W0/ZDi/m6TcB+tz6XvMWMFg9ttiYH499Oar/AEt83
 zUIK2Noa6t8VWsq+WiIzbdhAwa6qR4HoaBW+2uiESHspURhH9FRl17EdmsLyLIm6uXzJvbgIDBm
 hnIZY1nP1GCf4SfJf7Iw1Bi8WZvutDnWwJu5yJCYsWp47wKeIEDUKFqLY5rNAfFE7WKu3gViUpB
 GQrRsMp3ae84bmtbN9rFCtmqt4Jlgvf8vOei14xbfwNkSIbyDO7zTrqVNniiWWF5c5UjSR0KiTV
 iRfiUuvQWugyqZw3eNA==
X-Proofpoint-ORIG-GUID: 6ubn6E29sA47hik5LBFOuDTQAKx4w7av
X-Proofpoint-GUID: 6lbzOTIPmfaRT5WewsmbvjFpwvEQxI3G
X-Authority-Analysis: v=2.4 cv=KujYSmWN c=1 sm=1 tr=0 ts=6ad5fa04 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=Q6kW5ydU2YLVSL4rxhwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-19_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610190042



On 19/10/26 2:49 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 1 · High: 0 · Medium: 0 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Critical] The patch makes smc_conn_free() call
>   smc_lgr_unregister_conn() unconditionally.
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch closes races between the SMC sock_diag dump and teardown of
> conn/lgr/lnk state. It unhashes sockets before smc_conn_free() and
> smcd_buf_detach(), orders sk_state with acquire/release, skips the
> extension attributes for sockets in SMC_INIT/SMC_CLOSED, and uses the
> cached link->ibname. It also makes smc_conn_free() always call
> smc_lgr_unregister_conn().
> 
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 9974149659c2..6735f185cf48 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -1279,10 +1279,9 @@ void smc_conn_free(struct smc_connection *conn)
>>  		if (current_work() != &conn->abort_work)
>>  			cancel_work_sync(&conn->abort_work);
>>  	}
>> -	if (!list_empty(&lgr->list)) {
>> +	if (!list_empty(&lgr->list))
>>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
>> -		smc_lgr_unregister_conn(conn);
>> -	}
>> +	smc_lgr_unregister_conn(conn);
>>  
>>  	if (!lgr->conns_num)
>>  		smc_lgr_schedule_free_work(lgr);
> 
> [Severity: Critical]
> Now that the unregister is unconditional, can lgr->free_work get re-armed
> on a link group that is already being torn down? If so, the lgr could be
> freed while that timer is still pending.
> 
> smc_lgr_cleanup_early() unlinks the lgr but never sets lgr->freeing:
> 
> smc_lgr_cleanup_early() {
>     ...
> 	if (!list_empty(&lgr->list))
> 		list_del_init(&lgr->list);
> 	spin_unlock_bh(lgr_lock);
> 	__smc_lgr_terminate(lgr, true);
> }
> 
> smc_lgr_schedule_free_work() checks only lgr->freeing, not
> lgr->terminating:
> 
> 	if (!lgr->freeing) {
> 		mod_delayed_work(system_percpu_wq, &lgr->free_work, ...
> 
> __smc_lgr_terminate() cancels free_work once, before a loop that sleeps
> in lock_sock(). After the loop it calls smc_lgr_free(), and nothing on
> that path cancels free_work again:
> 
> __smc_lgr_terminate() {
>     ...
> 	cancel_delayed_work(&lgr->free_work);
> 	lgr->terminating = 1;
> 	...
> 		lock_sock(&smc->sk);
> 		smc_conn_kill(conn, soft);
> 	...
> 	smc_lgr_cleanup(lgr);
> 	smc_lgr_free(lgr);
> }
> 
> One possible sequence on an SMC-D server:
> 
> - Conn X creates a first-contact lgr L. smc_listen_work() releases
>   smc_server_lgr_pending for SMC-D right after sending ACCEPT.
> 
> - Conn Y joins L. smc_conn_create() has no conns_num limit for SMC-D.
> 
> - X's CONFIRM fails:
>   smc_listen_decline(X) -> smc_conn_abort() -> smc_conn_free(X), while
>   L is still listed. Then smc_lgr_cleanup_early(L) runs list_del_init()
>   and __smc_lgr_terminate(L) cancels free_work, sets terminating = 1 and
>   blocks in lock_sock(Y). Y's listen worker holds that lock while it
>   waits for its own CONFIRM.
> 
> - Y's CONFIRM also fails:
>   smc_listen_decline(Y) -> smc_conn_abort() -> smc_conn_free(Y). The
>   lgr list is now empty, but with this change smc_lgr_unregister_conn(Y)
>   still runs. conns_num drops to 0, freeing is 0, so
>   smc_lgr_schedule_free_work() arms free_work with
>   SMC_LGR_FREE_DELAY_SERV.
> 
> - X's worker resumes, the loop ends, and smc_lgr_free(L) ->
>   smc_lgr_put() -> __smc_lgr_free() -> kfree(L) runs while free_work is
>   still pending.
> 
> Would the timer then fire on freed memory? If L were still alive at that
> point, smc_lgr_free_work() would see freeing == 0 and an empty conns_all
> and call smc_lgr_free() a second time.
> 
> Before this patch, smc_conn_free(Y) skipped smc_lgr_unregister_conn() when
> the lgr list was empty, so conns_num stayed at 1 and free_work was not
> re-armed.
> 
> The peer decides whether and when each CONFIRM fails, and with
> loopback-ism the client can be a local unprivileged user.
> 
> Should smc_lgr_cleanup_early() set lgr->freeing like the other unlink
> paths do? Alternatively, smc_lgr_schedule_free_work() could also check
> lgr->terminating.
> 
> [ ... ]
> 

You are correct. v11 introduced unconditional smc_lgr_unregister_conn()
which correctly fixes the alert_token_local UAF, but left
smc_lgr_schedule_free_work() with only the !lgr->freeing check. On the
smc_lgr_cleanup_early() path, __smc_lgr_terminate() sets terminating=1
and cancels free_work without setting freeing=1, so a concurrent
smc_conn_free() decrementing conns_num to 0 would re-arm free_work. The
subsequent kfree(lgr) inside __smc_lgr_terminate() → smc_lgr_free()
leaves the re-armed work pointing at freed memory.

Fixed in v12 by adding !lgr->terminating to the guard in
smc_lgr_schedule_free_work():

-	if (!lgr->freeing) {
+	if (!lgr->freeing && !lgr->terminating) {

This is safe: on the smc_lgr_cleanup_early() path __smc_lgr_terminate()
walks the full conns_all tree, kills every connection via
smc_conn_kill(), and then calls smc_lgr_free() unconditionally — it does
not rely on free_work to complete the teardown. Blocking the re-arm when
terminating=1 just prevents the UAF; the LGR is still freed by
__smc_lgr_terminate() itself.

On all other teardown paths (smc_lgr_terminate_sched,
smc_smcd_terminate, smc_smcd_terminate_all, smc_smcr_terminate_all)
freeing=1 is set before __smc_lgr_terminate() or terminate_work is
scheduled, so !lgr->freeing already blocked smc_lgr_schedule_free_work()
there — the !lgr->terminating addition changes nothing for those paths.

pw-bot: cr
