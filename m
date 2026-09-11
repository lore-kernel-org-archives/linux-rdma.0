Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCA43C553F;
	Fri, 11 Sep 2026 08:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789114280; cv=none; b=f7Ylj32ZSNT4e3Ah0TbDmYslwoloLhUmtVdh2H4Wk+GLlFT5Svf8itOUI0JJmq3UtDNUMyaXtIPtkbvrLNRxQvdsLcfn19qM4oWZMQReMuR/ibtL21U40ALPzy7Ts1X0p5rUWYtcz4u9qGJaeNo3RzWjM89kss2pNJvHxtcHGQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789114280; c=relaxed/simple;
	bh=CJT2p9SlPyVoxkc+xNpTmVVgRjP9ZO2oUDXkLTIN5ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F7l0PCon6nhYgXqNbmAGk/sdaZkNh5EaRdopCbSS4goBr8Iw7t80eV/T7/ccye9Rwe+Xv2YjZZF2xC3WgMJcp8JIhA8Rrq43/G0178X0Wb57G2u2MQ0Ub9xRLmXcvbzqpRkeKtKuO3BYkzJouw9mrKNZbccqYFQ/RLycPgGAw/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ptENdfi4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ptENdfi4"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B820nF1083168;
	Fri, 11 Sep 2026 08:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KRxG3Y
	lWaQCfHO1tkzVz33gbVSWtfmKiIFXIn1hK/Q4=; b=ptENdfi4p5eAtCGnnbxi2S
	Kx5Qo8Qe2tiAYY1dQvpz2kJNIcn93Q+T67TC8EYcs1a0AI3p6+ENxdahRiB15jgx
	BIgaOm3Z7DhWBzQspaMh4XHG31p59phSXpI2FeMOy2TF56ZeoFdsIBsEBmPgtH8I
	NPrtaQ6vzBbBv5ESr5XswDu5aGhXsQeCumwHEf5A2A211shKcYKIgRw6cHyDFlZ8
	H2lXgMUHclW871OX9+rSK1Hz+tiaLO9QeMYpeETHHoFJuST9+/BiPdcA6Ldq/FqU
	TmshZg/zE9LIu4VHamYLUEvoWUEWSpNM72PepxNqiVQQMqtYcc0/JMGMDnhP8tfw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8sa4d0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 08:11:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B7o4Ju1327318;
	Fri, 11 Sep 2026 08:11:06 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrn7a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 08:11:06 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B8B4Uj3867390
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 08:11:04 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4312858064;
	Fri, 11 Sep 2026 08:11:04 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D36975805A;
	Fri, 11 Sep 2026 08:10:58 +0000 (GMT)
Received: from [9.111.170.138] (unknown [9.111.170.138])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 08:10:58 +0000 (GMT)
Message-ID: <9c7868b7-f125-455d-9486-d5bf82a81ea0@linux.ibm.com>
Date: Fri, 11 Sep 2026 13:40:57 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3] net/smc: fix lgr/lnk lifetime vs diag reader race
To: netdev-bot+sashiko@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com, pasic@linux.ibm.com,
        horms@kernel.org, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        hidayath@linux.ibm.com, stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260908092252.3832975-1-mjambigi@linux.ibm.com>
 <178908624996.219967.16908117009364362685@kernel.org>
Content-Language: en-US
From: Mahanta Jambigi <mjambigi@linux.ibm.com>
In-Reply-To: <178908624996.219967.16908117009364362685@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: QEgWSaMRmkpPrnoqjQVxqEdWi02rMG3m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDExMSBTYWx0ZWRfX+NImZQROUGs4
 sSAOCDTOVAKWScPgJvWDucP1z3ECYesCrNxtUdKjbf+cHntEiVdySTVEiITgRdR4VRuNiZOxe38
 KXGiUV/jTDFvH52X7fe6u5JSAsZHcObprC/fVPVBpBpSs+UoYi8hNeiY3r66xCYkZHPJbsG58Xh
 xBSlL8YQqXXhVLwNucDG576c6PAkN7RCv5L447OWepOlLO32YMyeZVKNn/dQE1T4yOafHg9vA5A
 7MDxoU3ZCqp6nHPEZP9gwkEgabNGr0097M3aclGTWia4Ht72ytKeC0dqDjt+U5xaQf0YZ9NhzUF
 IPoSbAOOR1i43v+dgFGGXvpHTaR2roajuJAFrL9FOGSLMOT9xVxkkEEYvusC4Q2+uraWV50SyWu
 /2f6FZqlQ8kz7Pa1vJrnz5D/zeF/yKjaVwC0KE2M+qzLzELGjiB4goH1mvHp40uAo3G9nDLJRHx
 xm7IhSTPV1JEAhL4PYw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDExMSBTYWx0ZWRfX6CwuboyToGN9
 HOBYml8EdQp+2ryx8V+lEIP4EbSTH0BWlWPY7VVHHUFodI6BPLAGAQX7qwdjNaYO9X4Uk2hwO3v
 oL5mwwmJZSDXb51+KriCEq24AxYulRE=
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aa3b79b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=9zdcP_bucDMI420jQq4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ISJzs1OyZ-Cyv2ONTUZzawWVnjPTjohr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1011 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110111



On 11/09/26 5:54 am, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 2 (1) · Medium: 0 · Low: 0
> 
> - [High] The commit message asserts the invariant "any socket still
>   visible to the diag reader under the hash read_lock has valid…
> - [High] The unconditional smc_conn_unhash() added at the head of
>   smc_conn_free() (net/smc/smc_core.c:1284) removes the socket from the…
> 
> Pre-existing issues:
> - [High] smc_cdc_msg_validate() (net/smc/smc_cdc.c:308-327) retargets
>   conn->lnk to the link a stray failover-validation CDC message arrived…
> 
> --
> 
> net/smc: fix lgr/lnk lifetime vs diag reader race
> 
> This patch adds smc_conn_unhash() plus a per-connection unhashed flag and
> calls it at the top of smc_conn_free(), so the socket leaves the SMC socket
> hash before the connection-owned lgr and lnk references are dropped.
> __smc_release() is changed to use the new helper for non-fallback sockets
> and keeps the direct sk->sk_prot->unhash() call for fallback sockets.
> 
> A few questions below about the paths that reach smc_conn_free() and about
> the invariant described in the changelog.
> 
>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>> index e9f93b3ab435b..8c781a4a4485b 100644
>> --- a/net/smc/af_smc.c
>> +++ b/net/smc/af_smc.c
>> @@ -310,7 +310,15 @@ static int __smc_release(struct smc_sock *smc)
>>  		smc_restore_fallback_changes(smc);
>>  	}
>>  
>> -	sk->sk_prot->unhash(sk);
>> +	/* Fallback sockets never call smc_conn_free(), so unhash directly.
>> +	 * Non-fallback sockets use smc_conn_unhash() so that the conn->unhashed
>> +	 * flag keeps the unhash exactly once even when smc_conn_free() already ran
>> +	 * first (e.g. via smc_conn_kill()).
>> +	 */
>> +	if (smc->use_fallback)
>> +		sk->sk_prot->unhash(sk);
>> +	else
>> +		smc_conn_unhash(&smc->conn);
> 
> [Severity: High]
> Is the premise "Fallback sockets never call smc_conn_free()" accurate?
> smc_listen_decline() calls smc_conn_abort() first and only afterwards turns
> the socket into a fallback socket:
> 
> net/smc/af_smc.c:smc_listen_decline() {
> 	/* RDMA setup failed, switch back to TCP */
> 	smc_conn_abort(new_smc, local_first);
> 	if (reason_code < 0 ||
> 	    smc_switch_to_fallback(new_smc, reason_code)) {
> 	...
> 	smc_listen_out_connected(new_smc);
> }
> 
> net/smc/af_smc.c:smc_conn_abort() {
> 	...
> 	smc_conn_free(conn);
> 	...
> }
> 
> The client side does the same via smc_connect_rdma()'s connect_abort label
> followed by smc_connect_decline_fallback().
> 
> Beyond the comment, smc_conn_free() is also reached for connection
> *attempts* on sockets that stay alive afterwards, and there is no path that
> re-inserts the socket into the hash.  Can this make live sockets invisible
> to smc_diag for the rest of their lifetime?
> 
> For the server ISM retry loop:
> 
> net/smc/af_smc.c:smc_listen_ism_init() {
> 	rc = smc_buf_create(new_smc, true);
> 	if (rc) {
> 		smc_conn_abort(new_smc, ini->first_contact_local);
> 		...
> }
> 
> net/smc/af_smc.c:smc_find_ism_v2_device_serv() {
> 	for (i = 0; i < matches; i++) {
> 		...
> 		rc = smc_listen_ism_init(new_smc, ini);
> 		if (rc) {
> 			smc_init_info_store_rc(rc, ini);
> 			/* try next active ISM device */
> 			continue;
> 		}
> 		return; /* matching and usable V2 ISM device found */
> 	}
> }
> 
> The failed attempt unhashes the socket through smc_conn_free(), the next
> ISM device then succeeds, and smc_conn_create() only does
> "conn->unhashed = 0" without calling sk->sk_prot->hash() again.  The same
> shape exists for the v2 -> v1 RDMA fallthrough in
> smc_find_rdma_v2_device_serv() -> smc_listen_find_device().
> 
> smc_diag_dump_proto() walks only that hash:
> 
> net/smc/smc_diag.c:smc_diag_dump_proto() {
> 	read_lock(&prot->h.smc_hash->lock);
> 	head = &prot->h.smc_hash->ht;
> 	...
> 	sk_for_each(sk, head) {
> 	...
> }
> 
> so an established SMC-D/SMC-R connection or an active TCP-fallback
> connection produced by these paths would no longer show up in ss --smc or
> smcss, including the SMC_DIAG_MODE_FALLBACK_TCP reporting.  The same early
> unhash also hides sockets that user space still has open after
> __smc_lgr_terminate() -> smc_conn_kill() -> smc_close_active_abort() ->
> smc_conn_free().  Should the unhash be restricted to terminal teardown, or
> should the abort paths re-hash the socket?

Good catch. The v3 approach was wrong to put the unhash inside
smc_conn_free() — that path is also reached by the ISM/RDMA retry loop
and the fallback abort paths, which must leave the socket hashed.

Fixed in the next version(v4) by restricting the unhash to the two
terminal teardown sites directly: smc_close_active_abort() (covering the
smc_conn_kill() path) and smc_close_passive_work() (covering the passive
close path). smc_conn_free() is left untouched, so retry aborts and
fallback transitions no longer affect the socket's hash membership.

> 
>> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
>> index 04aedd957543a..e302221c35e3f 100644
>> --- a/net/smc/smc_core.c
>> +++ b/net/smc/smc_core.c
>> @@ -1251,6 +1251,20 @@ static void smc_buf_unuse(struct smc_connection *conn,
>>  	}
>>  }
>>  
>> +/* unhash the socket once; owns the single unhash for all non-fallback paths.
>> + * Every caller holds lock_sock for this socket, so conn->unhashed is protected
>> + * by that lock and no separate synchronisation is needed.
>> + */
>> +void smc_conn_unhash(struct smc_connection *conn)
>> +{
>> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>> +
>> +	if (!conn->unhashed) {
>> +		conn->unhashed = 1;
>> +		smc->sk.sk_prot->unhash(&smc->sk);
>> +	}
>> +}
>> +
>>  /* remove a finished connection from its link group */
>>  void smc_conn_free(struct smc_connection *conn)
>>  {
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
> [Severity: High]
> The changelog states the invariant as "any socket still visible to the diag
> reader under the hash read_lock has valid conn->lgr and conn->lnk
> pointers".  Does the SMC-R link failover path still break that for
> conn->lnk?
> 
> smc_switch_link_and_count() drops the connection-owned link reference and
> republishes conn->lnk while the socket stays hashed:
> 
> net/smc/smc_core.c:smc_switch_link_and_count() {
> 	atomic_dec(&conn->lnk->conn_cnt);
> 	/* link_hold in smc_conn_create() */
> 	smcr_link_put(conn->lnk);
> 	conn->lnk = to_lnk;
> 	...
> }
> 
> It runs under conn->send_lock and lgr->conns_lock only, never under the
> socket hash lock and without unhashing, so a reader that already
> snapshotted the old link keeps using it:
> 
> net/smc/smc_diag.c:__smc_diag_dump() {
> 	struct smc_link *link = smc->conn.lnk;
> 	...
> 	memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
> 	       sizeof(link->smcibdev->ibdev->name));
> 	smc_gid_be16_convert(linfo.lnk[0].gid, link->gid);
> 	...
> }
> 
> Once the last connection has been migrated off the old link,
> smcr_link_clear() -> smcr_link_put() -> __smcr_link_clear() zeroes the
> whole structure:

Actually it doesn't clear the structure because it *never calls*
__smcr_link_clear().

smc_switch_link_and_count() drops one per-connection hold on from_lnk,
but the structural reference set in smcr_link_init()
(refcount_set(&lnk->refcnt, 1)) is still held — smcr_link_clear() has
not run yet at that point. So refcount_dec_and_test() cannot return
true, __smcr_link_clear() is never reached from this path, and the
memset/NULL-deref scenario does not apply here.

The remaining concern is a data race on the conn->lnk pointer itself:
smc_switch_link_and_count() writes conn->lnk = to_lnk under
conn->send_lock, while the diag reader reads it under the hash read_lock
— two independent locks with no intersection. However, because the old
link's structural refcount is still live, reading the stale old pointer
is safe; the worst outcome is a diag dump reporting stale link info
during an active failover, not a crash or use-after-free. The invariant
in the changelog holds for the no-crash case; it just doesn't guarantee
freshness of conn->lnk during failover.
> 
> net/smc/smc_core.c:__smcr_link_clear() {
> 	put_device(&lnk->smcibdev->ibdev->dev);
> 	smcibdev = lnk->smcibdev;
> 	memset(lnk, 0, sizeof(struct smc_link));
> 	lnk->state = SMC_LNK_UNUSED;
> 	...
> }
> 
> so link->smcibdev becomes NULL and the dereference above is a NULL
> dereference, with the device reference already dropped.  This looks like
> the same class of access the cited "Fixes: 9dbe086c69b8 (net/smc: fix
> invalid link access in dumping SMC-R connections)" refers to, and the
> reader/writer lock sets (hash read_lock versus send_lock/conns_lock/
> llc_conf_mutex) do not intersect.  The v2 posting of this series protected
> smc_switch_link_and_count() with lgr_lnk_lock; is anything replacing that
> protection in v3, or should the invariant in the changelog be narrowed to
> conn->lgr?
> 
> [Severity: High]
> This is a pre-existing issue and not introduced by this patch, but it also
> bears on the conn->lnk invariant being asserted: the reference that
> smc_conn_free() releases is not always the one the connection holds.

Agreed, this is pre-existing and orthogonal to the diag race fix. I'll
address it in a separate patch.

The root cause is that smc_cdc_msg_validate() reassigns conn->lnk
without a reference transfer — no smcr_link_hold() on the incoming link
and no smcr_link_put() on the old one — breaking the invariant
established by smc_conn_create(). The fix is to add the missing hold/put
pair around the reassignment, mirroring what smc_switch_link_and_count()
already does correctly.
