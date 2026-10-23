Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763808;
	b=hxVQZ2UzN2DDPfqdiedz4ibSNU3wjG+K8tx9138w4j6ixbZYpgC3fEhtgpKgNdiolhRn
	 xTGhPA5pI5S+6kAsttBTnTzJy4psV9SGHJr8hKNl71nzcIMsDhZiRnYkiHO7r5s4oqKq+
	 3Pvi+Zz/rvaHDQ3vR5IaCAkzbvqUgBZ2Rr3JBnH2qRmdktg2cBCWbi+T+fkCJOxj+llpp
	 wIO+VhAt5Hp4gnV9y/9hKM5pnWgL3UGxvZvoW+sysx1uv6cdyjLaumpd+Rxcbey9kzV+8
	 oPRQ3iApH0nR5an14z9Bs8p/N/x8L+5iT5KZ3PBvNJU9WpFCn5ikII0HixpZxjidlbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763808;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-TM-AS-GCONF:
	 X-Proofpoint-Reinject:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=1EjqEPgguT3TOPa/YTqb2hSy/Ffheovv8t9rHxhQQs0=;
	b=UbHp/PKqE4QB5U1Frknjgmvw7OTwCKqNnevYIeMhiZNPTmSQWnewKAHZHC01Ewkg/eoE
	 ac6/I7cdFd9gE78FxAcNh9XKJ8zc2Fa+BBuSqy94K0QuKiVqADR69V87xSjxza+YqQbBJ
	 XKaKJVGqobD3b5Gz6qruA3UA3K6qsRuQ7fCOH76wdez/KMbLuawmnnu8f5cNtJp4S+apQ
	 2LiGegCPqyu0fiUP66JbjT4qqTbc3u4Far9qg6mV4QHasDmgNQssm+KFcXkU+tYbixrYg
	 MdQH8dqwQhPJn7mDcTD7IMbmq4VRE5vRIvoI+hUGJ/dHXVuoc+KM6lk8IiPC3qTbtfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tUFQLtnl;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED74606A31A;
	Fri, 23 Oct 2026 13:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ED74606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=tUFQLtnl
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAEDfB2540741;
	Fri, 23 Oct 2026 13:56:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1EjqEP
	gguT3TOPa/YTqb2hSy/Ffheovv8t9rHxhQQs0=; b=tUFQLtnl1Y+w9j/uCoZMYd
	Wcl1WHNiRtxs7tlKYkZftGgkXySFywpUtk1sLGK2BVcPO4PU9E5y1HZ4eDX1oGRX
	UnVhuECMMotjKGfeRuNTGonWny/3SxSV/3+pKvZcVYmWag7NlyIMDCmFiY0Jm1+C
	msqbZ+G1o3HFZH5OoRFFdSbzdVsqWei+kxvqrkgbdrpX/xoJDCPu5EqIM9iekYAE
	GNogTA4ajUyVUQMe0OBaTwRnrHiFGW2UqsI8eitiFS28yUk4zlZKlzSPMxucT1+J
	bnM3zOxQ8FevU/Y/2aSLCmunVPaX3oV4ilJcMX+3AbbPHXvQpdlvTfnKZ5qPY9Xw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5b4yem-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 13:56:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAK0YI1967011;
	Fri, 23 Oct 2026 13:56:39 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hfj1x5ddb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 13:56:39 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69NDubWL852612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 13:56:38 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D550E58065;
	Fri, 23 Oct 2026 13:56:37 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB3F658043;
	Fri, 23 Oct 2026 13:56:29 +0000 (GMT)
Received: from [9.39.18.113] (unknown [9.39.18.113])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 Oct 2026 13:56:29 +0000 (GMT)
Message-ID: <c905dac5-78e1-4576-b4f4-6aa29d2861e8@linux.ibm.com>
Date: Fri, 23 Oct 2026 19:26:27 +0530
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
Subject: Re: [PATCH net v12] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
        hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261019111008.3367567-1-mjambigi@linux.ibm.com>
 <179267838686.3135.11610279010793695525@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <179267838686.3135.11610279010793695525@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=X63Hu2Te c=1 sm=1 tr=0 ts=6adb6798 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=ATHYEBQc5O03oyGe7xYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MqmWyBpqaOpOhVz6xjPCW7I95VWcrEzd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA1MyBTYWx0ZWRfX+eK9ZjVJbBOD
 r66JRGrj49zz3H/vlWThbidmnZw5Eq7dghmgwn6NIytuRPYn9l3gkA3ukEuQ9ohsqoElNBt030X
 2NZaFmj89v6iGURelAFePXWcGQ+VIWt/vwLLp4aioR0LeRkmExkm37Xq9SgeNY1cs8MWco9txs2
 xxsS3gvoRZtad0O+Z3FLG4d0dEte9SRYcWWD6bSHeMGmE7CuFxXo8QDbTf8SAiXWy1NdoncPxOS
 nfRp6ULIpmvbYM6SOGn2Tl504exASwH76P1qc+5C1pNXxJu9gs1plzbWNP6coQGb4g0z7sSCBOX
 ZyDx6U71pSVo9s+bHMsHj17dVksf6j4lJFDCO5lXNjeFSW7UEDuS8q2kd55adf/MRzUetWawgow
 va3a+ASoGr4z/No4h6amW6BU9czkRVmo/L9lTe9b5zVohVjuIhrmd301zV3PmXC091MVWH5o/w5
 49t6iv4QO0sVJw/poNQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA1MyBTYWx0ZWRfX+sIuuYZzg9kf
 8cVxG0W5dPcihDPFJUQtjCzTrG6veM8n9qIs+5gVvpwnKjB+uKDz2HGaE60R91QfdqUWcpMVQcd
 wbBawM85ckKT8FK0gz09wdAb+qJtT0Y=
X-Proofpoint-GUID: OfVQhbiETCXAFHKq0TMMkj0V-8k41Q0O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230053



On 22/10/26 7:43 pm, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The v12 `!lgr->terminating` guard in
>   smc_lgr_schedule_free_work() (net/smc/smc_core.c) does not close the…
> - [Low] The commit message says "Other kill paths leave the socket
>   hashed, since it can stay open until close()".
> - [Low] The commit message's 'Fifth' paragraph gets the mechanism of its
>   own example wrong.
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch closes several windows where the SMC sock_diag dump can
> dereference conn/lgr/lnk state that has already been freed. It skips the
> CONNINFO/LGRINFO/DMBINFO attributes for SMC_INIT and SMC_CLOSED sockets,
> orders sk_state with acquire/release, unhashes sockets before teardown in
> several paths, and copies the cached link->ibname. It also unregisters
> connections unconditionally in smc_conn_free() and stops arming free_work
> on a terminating link group.
> 
>> Fifth, on the smc_lgr_cleanup_early() path (e.g. server CLC decline with
>> SYNCERR) __smc_lgr_terminate() sets terminating=1 and unlinks the LGR
>> without setting freeing=1.
> 
> [Severity: Low]
> Is the SYNCERR example here accurate?On the server, smc_clc_wait_msg()

No. On the server, smc_clc_wait_msg() calls smc_lgr_terminate_sched()
for a first-contact DECLINE, which unlinks the LGR and sets freeing
before smc_conn_abort() runs. The skipped unregister comes from there,
not from smc_lgr_cleanup_early().

v13 drops the smc_conn_free() change, so that paragraph is gone. The
SYNCERR case is covered in smc_diag.c instead: a fallback socket is a
plain TCP socket with no SMC connection state, so the CONNINFO/LGRINFO/
DMBINFO blocks are skipped when use_fallback is set.

> [Severity: Low]
> The commit message says:
> 
>   Other kill paths leave the socket hashed, since it can stay open until
>   close().
> 
> Does that match the code? Every smc_conn_kill() ends in

No. Every smc_conn_kill() ends in smc_close_active_abort(), so killed
sockets in the PEERCLOSEWAIT, PROCESSABORT and APPFINCLOSEWAIT states
are unhashed before close(). I removed the sentence, and the commit
message now says that smcss visibility depends on the close state and,
for SMC-D, on the device type.

> [Severity: High]
> Does this check fully stop free_work from being re-armed on a
> terminating link group? The flag check and mod_delayed_work() are not

No. v13 drops the !lgr->terminating check and the unconditional
unregister from v11, so smc_core.c is back to the v10 change only.

The free_work window you describe is independent of the diag reader race
this patch fixes. I'd like to keep it out of this patch.

pw-bot: cr
