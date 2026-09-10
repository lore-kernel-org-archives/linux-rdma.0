Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED26346A07;
	Thu, 10 Sep 2026 05:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019660; cv=none; b=W5ldpjRijAYyXjdZydAj5sqm/b/fNMpGDpbBQKL2sxztyZTaGldBIZdU6EKuQudIWEA05oxr2mozqvFnjl5KjUKVV1PQCWJUiL8QJnydEWBIBcoKJLx7hMvh5xBdUNIYVKS3Qh9sKf9ToCAGAw5B3vkOno7Z7VYkgxfFTGey7m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019660; c=relaxed/simple;
	bh=A02rMbNNtwCqzYs4y4VSc6SFlLsdLDwvxKQEDvFTHFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z20tSmNCMOhHtsuxeB2Ilkl8zqKyv+xradwJp2qjSFLnOzSV6lbCvicvZzWgTvPN+xevTDEWub084MLfT5lJVtqIcb7EW/k1zX4x4PyWQyFEbCzcQGtPlZm2dJRW0j2EO1gKk5hCiqlgnoPeI6c0c92IYCFKrmkyYGuDyl+9j3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nTK/arDN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nTK/arDN"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A5VUKE1996996;
	Thu, 10 Sep 2026 05:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/zF0L5
	VHL9AQ4O6fmulBpHz2m8hV+u+f2gkM8aGTiJQ=; b=nTK/arDNhRUqa2nEHXsV/p
	GgT6F2Kxk3OP+pXrHbPc1dgUzD1uZT2I6faBZjl8XEIn+WMJHUltxyXVvYLqM+w8
	ts5T1koc3YY/SYEVEvvJfvVq3kzEW0Li0AhwYGCtuAq4XqruI/nymJALj82QntD9
	ZYyDXYA1Jdc6nvA4iKFyo0d3dNepKmbeTtGXG+ezYGCEcKROK6A6FCvhVR75ihYW
	BoNDQ8um3vV2EgRvNbztszIieZU5SL0LdFvwqk428qQ7sEiEWbTeNcbqRPD4rA+o
	n4l+l8RBjylqNnIuZZHWIU3sjpuupu9FcrFhWJwY2YfzIlHM9BondIaqwmoRi86w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qjkt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:54:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 68A5fEeX032387;
	Thu, 10 Sep 2026 05:54:15 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkcr3aqg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:54:15 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68A5sEqL30212838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 05:54:14 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89E8258056;
	Thu, 10 Sep 2026 05:54:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB3F458052;
	Thu, 10 Sep 2026 05:54:11 +0000 (GMT)
Received: from [9.123.4.74] (unknown [9.123.4.74])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 05:54:11 +0000 (GMT)
Message-ID: <5ab3dcd5-34e7-41f8-98a6-5af1bd1fd7b5@linux.ibm.com>
Date: Thu, 10 Sep 2026 11:24:10 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] net/smc: fix lgr/lnk lifetime vs diag reader race
To: sashiko-reviews@lists.linux.dev
Cc: linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-rdma@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, netdev@vger.kernel.org
References: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
 <20260909092315.64CC41F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <20260909092315.64CC41F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa24608 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=SNswcDxCQnACgjUyoWIA:9 a=90Hdc2SX5DDjr3W5:21
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XQUMq8P2GJcFWsZzwnpn3eI_NvAR2XcQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA1OCBTYWx0ZWRfX8BnPMr4o1R0v
 t+5AnzvhDePsQ68JbWk0qokMaJ5ATxCP1prKBy6hQTVRDY6b7DgTh7vdHRFxuY0/oAwY0vMUJtn
 yywUr+Md12MYZBPNbFzL+IlB2sEdsV3SnTc05RU3L63r90fP4ctLObq5vbSjqhibyvzgFl958go
 3gzVnLuK0VAAoX5ULDWVAW+JsRf+HuW9Thq2/XVMhVloM+YQIEbqLjEYMi2eOLxmC99T9dM4fou
 wx/8WDpR04mdWfwQImiRgj5h2Y0RiCkp9vMJebwEKMSThkWuEoc33Zxe6EYhgvtrOnXtEibqinf
 KkMeh9uSDH2z2Xgj88y2gc01e2zcJbVx4CQ1paCSmDcTAmtZhBBSyCH8ZFle0D3+wZGIYIE5Ctj
 XXq5/fotjF/JKGNiJ0a+/tqQjxBpPJPVBQ2lEUL1i2eHZCXLMzsYNJ8GWH/92WjdpIR/+aXJm2J
 cT+2YBHj3sUzUfI6PTw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDA1OCBTYWx0ZWRfX9LCxplkx1i/2
 e4X/60gDszy6WqDMF8jqVBiPgEMPQORDxja+QNhNAhPA4gIesWhjYJmRQpWGd443nOFaQK/qynN
 jGVopuILFpEhOd3+FY59FxmbJKUt53w=
X-Proofpoint-GUID: XQUMq8P2GJcFWsZzwnpn3eI_NvAR2XcQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100058



On 09/09/26 2:53 pm, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [Medium] Premature unhashing of SMC sockets breaks netlink diagnostics for fallback and aborted connections.
> 
> Pre-existing issues:
> - [High] Concurrent link failover clears link memory while diagnostic reader accesses it, causing a NULL pointer dereference.
> --
> 
> commit c0cbdd828a851e80ad0c79e6d2ccf5b0b5d7e16e
> Author: Mahanta Jambigi <mjambigi@linux.ibm.com>
> 
>     net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This commit aims to resolve a race condition between the SMC diagnostic dump
> reader and connection teardown. It introduces a mechanism to ensure sockets
> are unhashed before their link group and link references are released in
> smc_conn_free(), preventing the diagnostic reader from accessing freed
> structures.
> 
>>     The diag path therefore reduces to:
>>       hold hash read_lock -> read conn->lgr -> if non-NULL, dereference -> done
>>     with no new lock, no extra reference count, and no trylock.
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but does this approach still leave
> the link memory vulnerable to concurrent clearance during a link failover?
> 
> When __smc_diag_dump() in net/smc/smc_diag.c iterates over the hash table, it
> extracts link = smc->conn.lnk. Concurrently, a link failure could trigger
> smcr_link_down() -> smc_switch_conns() -> smc_switch_link_and_count().
> 
> The link is swapped and the old link's reference is dropped locklessly with
> respect to the dump:
> 
> net/smc/smc_core.c:smc_switch_link_and_count() {
>     ...
>     smcr_link_put(conn->lnk);
>     conn->lnk = to_lnk;
>     ...
> }
> 
> Next, smcr_link_down() calls smcr_link_clear(). When the reference count hits
> zero, __smcr_link_clear() zeroes out the link memory:
> 
> net/smc/smc_core.c:__smcr_link_clear() {
>     ...
>     memset(lnk, 0, sizeof(struct smc_link));
>     ...
> }
> 
> The diagnostic reader then evaluates link->smcibdev->ibdev->name. Since the
> link was zeroed, link->smcibdev is NULL, leading to a fatal dereference.
> Can the diagnostic reader safely dereference link->smcibdev without holding
> any connection-level lock that protects the link from concurrent clearance?

This is a false positive. The key is the link refcount accounting.

A link starts with refcnt = 1 (set in smcr_link_init()). Each
connection on that link holds an additional ref taken in
smc_conn_create() via smcr_link_hold(), paired with the
smcr_link_put() in smc_conn_free(). So for a link with N active
connections, refcnt = 1 + N.

smc_switch_link_and_count() drops only the *per-connection* ref
for the migrated connection:

    smcr_link_put(conn->lnk);   /* refcnt: (1+N) -> (1+N-1) */

For refcount_dec_and_test() to return true and trigger
__smcr_link_clear() -> memset(), the refcount would need to reach
zero. But the base ref of 1 (set at link init) is still live, so the
count never hits zero from this put.

The base ref is dropped only inside smcr_link_clear() at line 1381:

    smcr_link_put(lnk); /* theoretically last link_put */

smcr_link_clear() is called from smcr_link_down() *after*
smc_switch_conns() has already migrated all connections away. By
the time the base ref is dropped and __smcr_link_clear() fires,
no connection points to the old link anymore -- so the diag reader
cannot reach a being-zeroed link through conn->lnk.

The ordering in smcr_link_down() is:
  1. smc_switch_conns()   <- all conn->lnk updated, per-conn puts done
  2. smcr_link_clear()    <- base ref dropped, memset runs

Step 2 cannot interleave with step 1; memset is only reachable after
all connection refs have been dropped. The diag reader's conn->lnk
dereference is therefore safe.

> 
>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> index e9f93b3ab435b..8c781a4a4485b 100644
>> --- a/net/smc/af_smc.c
>> +++ b/net/smc/af_smc.c
>> @@ -310,7 +310,15 @@ static int __smc_release(struct smc_sock *smc)
> [ ... ]
>> -	sk->sk_prot->unhash(sk);
>> +	/* Fallback sockets never call smc_conn_free(), so unhash directly.
>> +	 * Non-fallback sockets use smc_conn_unhash() so that the conn->unhashed
>> +	 * flag keeps the unhash exactly once even when smc_conn_free() already ran
>> +	 * first (e.g. via smc_conn_kill()).
>> +	 */
> 
> [Severity: Medium]
> Is the assumption that fallback sockets never call smc_conn_free() accurate?
> 
> If a late fallback occurs, it invokes smc_conn_abort(), which calls
> smc_conn_free() before switching to TCP fallback:
> 
> net/smc/af_smc.c:smc_listen_decline() {
>     ...
>     smc_conn_abort(new_smc, local_first);
>     if (reason_code < 0 ||
>         smc_switch_to_fallback(new_smc, reason_code)) {
>     ...
> }
> 
> Does this mean fallback sockets can traverse the smc_conn_free() path?
> 
>> +	if (smc->use_fallback)
>> +		sk->sk_prot->unhash(sk);
>> +	else
>> +		smc_conn_unhash(&smc->conn);
>>  
> [ ... ]
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 04aedd957543a..e302221c35e3f 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -1263,6 +1277,11 @@ void smc_conn_free(struct smc_connection *conn)
>>  		return;
>>  
>>  	conn->freed = 1;
>> +	/* Unhash before dropping lgr/lnk refs so the diag reader, which
>> +	 * iterates under the socket hash read_lock, cannot see a connection whose
>> +	 * lgr or lnk is being freed concurrently.
>> +	 */
>> +	smc_conn_unhash(conn);
> 
> [Severity: Medium]
> Will this prematurely unhash SMC sockets during connection aborts and late
> fallback transitions?
> 
> Since smc_conn_free() is called by smc_conn_abort(), and late fallback calls
> smc_conn_abort() (e.g., smc_listen_decline() -> smc_conn_abort() ->
> smc_conn_free()), the socket is removed from the SMC hash table despite
> remaining an active, functioning fallback socket.
> 
> Could this hide fallback and aborted sockets from diagnostic monitoring tools
> that rely on the hash table (using SMC_DIAG_MODE_FALLBACK_TCP), breaking
> observability for these sockets?

You are right. smc_conn_abort() calls smc_conn_free() while
use_fallback is still false, so placing smc_conn_unhash() inside
smc_conn_free() prematurely removes the socket from the hash before
smc_switch_to_fallback() runs — making live fallback sockets
invisible to smcss. I'll fix it in the next version.
