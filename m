Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD2E369990;
	Thu,  1 Oct 2026 06:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835877; cv=none; b=VaJJfV+de8JiynIR+6XG54Uhg5iMQEBoaGQ8iaqPAcKMR0qzVc279sERsTgIxO1o4EpwVYVATY+ntOAgE7ryQvrSv7fMQotszTn9WHRnMoGfXEBVp2Uwd85NBr4T82AEI/xrLdgR/zg/GE0p8XXjkz70FOr83AFDPcv/y1nBF94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835877; c=relaxed/simple;
	bh=QhVaF7LpTRlzWHSFo28mgjy0Ulqvkfu+iqnD9A9Wx6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pULzDQR6L2PIsmRvJGUcu5thAORBRZA+oTxGDpxKYMmvtoL1ACQaMeQzmMnuHqJxb6HCwu7slzGZa8CqIrfHJhqPK2x/kW7EN2deT6ApoN7xLvmkIQ4Xs4ckvPS7TnxMmnpu6DiZbeFaZeJEq8fzB7HqfPTpgh30aqpFBQ7I840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XCjojpSb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XCjojpSb"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69145hGk756563;
	Thu, 1 Oct 2026 06:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M9AnNW
	X9SR6RKj3kFz3OBbKEw6Xz0SoE6TMyY8Gpmxc=; b=XCjojpSbtCv6F9kbS6g7Va
	xmPVjc7AuZoo3YrEZ4r4jbPONhzZ4ZTxZbIurD62UFfqVzrsDxLqNtmDWNg85hQz
	DomD9yE1N50wvx++3IoZBJhjZBREtLeeAW02tpk295Zpx//7N7+tIUiRcKTkCCrJ
	//tI5dyf3GJDUEDajRNRth6HBWXPd0EFLDZAeoN2S068B1/65y5dP8g3Q+jZamUO
	jhOQ2Gpu9nMt8nYU6SbKAcR2qFQFprrjtCqABp8pT67pdI+fHNLELqxDOcmESd5Z
	ezkw6OI2gZK4Edepsm80XITikxySJ8UHuE4Su7h49cccSXXYcVhluuBby7MHc3+g
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5hpe9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 06:24:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6913lfes3245992;
	Thu, 1 Oct 2026 06:24:28 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h0q4pe38s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 06:24:28 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6916OQTR1639222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 06:24:26 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 146A258056;
	Thu,  1 Oct 2026 06:24:26 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C64795805D;
	Thu,  1 Oct 2026 06:24:20 +0000 (GMT)
Received: from [9.123.9.27] (unknown [9.123.9.27])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Oct 2026 06:24:20 +0000 (GMT)
Message-ID: <9a7a893b-edd2-453b-b843-5b582a6f86a1@linux.ibm.com>
Date: Thu, 1 Oct 2026 11:54:19 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v7] net/smc: fix lgr/lnk lifetime vs diag reader race
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
        guwen@linux.alibaba.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
Content-Language: en-GB
From: Hidayath Khan <hidayath@linux.ibm.com>
In-Reply-To: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAyNCBTYWx0ZWRfX0Q6H6pc2cd5v
 HuiONgiEI4m1/dLgguVmbsMk+crC1s1V8N1VRWAdvO5FEnEmklESVnXvEQZYEXqaZYExAf36xYc
 aah4I/H6Oc4euYK+apijGEAjx4GlS/A=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAyNCBTYWx0ZWRfX5Ekb0W2i06NF
 zM91Y0wuhf9LhjFf/nBOjM0yPzkU6vLs6sMqEPqZ3cJiUco0GyKzHvfMwZIzisE874dXO+Xi3S8
 WADptrm/qWI9abaLZ1WU+02uqgzy/0rFcs5AcSnMFyH2tOSMwMPyQ37jXl8NxF12425FI+4kxoX
 GhhgmsL3wbQhuZkHXiQyfggXH8SFTpDg3mc0P3VRqjinzylJB4RHzHRWarFxORbKBsDDLZK4+5J
 s6exEYhT7ZLVUyfX/ilqpsTlb7lPBUTnbgSpGBvDd6T9X9WCKiFPqysCf9dq9jnJuHF5El+1OgO
 Q7JJ88cjxQnXytVF+vWHpL8Kd9lWmb7pEiQ13Ti1SjQSeyQdP/8+iagK4krSMysdgv0+I3d4SV9
 nAy8TbU8OfCkQe6AuT0Kf9GLAv16p1s47z9lIpdLp3J8Q1HiZLKPN3Cny+FZzhfiJ2yD1n+QwNm
 XhH+X8KtNiMrNBf3yYQ==
X-Proofpoint-GUID: rngLaTaz9dW3upSjG1PltudTfwBNfTBZ
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6abdfc9d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=gVUiB03J6SsEFvwYRAQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 8zhA_zt4mgYfj9rSZ1kHg9e2LM0G5ZA_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010024


On 30/09/26 1:00 pm, Mahanta Jambigi wrote:
> The diag dump walks the socket hash table under a read_lock and dereferences
> conn->lgr and conn->lnk. Three paths expose a window where a hashed socket has
> freed or partially freed conn/lgr/lnk state.
>
> First, smc_conn_abort() calls smc_conn_free() during early handshake aborts
> while the socket is still hashed in SMC_INIT. On the smc_lgr_cleanup_early()
> path this frees the lgr synchronously without holding the hash write_lock. A
> concurrent diag reader can therefore load a non-NULL conn->lgr and dereference
> lgr->is_smcd after the kfree. Guard the conn->lgr->is_smcd load in
> __smc_diag_dump() by skipping it when the socket is in SMC_INIT state. The same
> guard also skips the CONNINFO/LGRINFO/DMBINFO blocks for SMC_CLOSED sockets,
> which may briefly remain hashed after smc_conn_free() when the fd is still open;
> smcss already suppresses those attributes for closed sockets, so there is no
> observability regression.
>
> Second, in smc_conn_kill() on SMC-D with dmb_nocopy, smcd_buf_detach() NULLs and
> frees conn->sndbuf_desc before the socket is unhashed. A concurrent diag reader
> entering the CONNINFO block can dereference the freed descriptor. Unhash the
> socket at the top of smc_conn_kill(), before smcd_buf_detach().
>
> Third, in the terminal teardown branches of smc_close_active_abort()
> (PEERCLOSEWAIT and PROCESSABORT groups) and in smc_close_passive_work(),
> smc_conn_free() drops lgr and lnk references while the socket is still hashed.
> Unhash immediately before each smc_conn_free() call at those two sites.
>
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R connections")
> Fixes: ae2be35cbed2 ("net/smc: {at|de}tach sndbuf to peer DMB if supported")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
> ---
> Changes in v7:
> - no code changes; commit message only
> - document the SMC_CLOSED leg of the early-exit guard and the rationale
>    that smcss already skips CLOSED sockets on the userspace side; add
>    Fixes: ae2be35cbed2 for the smc_conn_kill() hunk since
>    smcd_buf_detach() was introduced by that commit
>
> Changes in v6:
> - smc_diag.c: inline sk->sk_state != SMC_INIT into the else-if condition
>    so conn->lgr->is_smcd is never loaded for SMC_INIT sockets; retain the
>    SMC_INIT || SMC_CLOSED early-exit guard and out: label from v5 to
>    defensively skip the CONNINFO/LGRINFO/DMBINFO blocks for sockets with
>    no live connection
> - smc_close.c: remove the unconditional unhash from the top of
>    smc_close_active_abort(); place it scoped immediately before each of
>    the two smc_conn_free() calls in the PEERCLOSEWAIT and PROCESSABORT
>    branches, and before smc_conn_free() in smc_close_passive_work();
>    this avoids prematurely hiding live SMC_ACTIVE/APPCLOSEWAIT sockets
>    from smcss
> - smc_core.c: unhash at the top of smc_conn_kill(), before
>    smcd_buf_detach(), so the socket is off the hash table before
>    conn->sndbuf_desc is freed on the dmb_nocopy path
>
> Changes in v5:
> - guard conn/lgr/lnk blocks in __smc_diag_dump() with an
>    (SMC_INIT || SMC_CLOSED) state check placed after the
>    SMC_DIAG_FALLBACK nla_put; SMC_INIT can coexist with fallback
>    (smc_sendmsg() MSG_FASTOPEN path), so the guard must not suppress
>    the fallback reason
>
> Changes in v4:
> - dropped smc_conn_unhash() wrapper, conn->unhashed flag, and all
>    changes to af_smc.c, smc.h, smc_core.c and smc_core.h;
>    smc_unhash_sk() is already idempotent via sk_hashed(), so direct
>    calls at the two teardown sites in smc_close.c are sufficient
> - dropped the __smc_release() hunk: it needs no change since the
>    subsequent unhash there is already a safe no-op
> - fixed premature-unhash issue present in v3: smc_conn_free() must not
>    unhash because smc_conn_abort() calls it before
>    smc_switch_to_fallback() in both smc_listen_decline() and
>    smc_connect_rdma() error paths; unhashing there would make live
>    fallback sockets invisible to smcss
> - likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(),
>    smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed
>    attempt and then smc_conn_create() on the next device; unhashing in
>    smc_conn_free() would permanently hide the established connection from
>    smc_diag since smc_conn_create() does not re-hash the socket
>
> Changes in v3:
> - redesigned as a single patch; dropped the lgr_lnk_lock spinlock
>    approach and the 2-patch split
> - fix is now at the socket hash layer: introduce smc_conn_unhash() with
>    a per-connection unhashed flag; smc_conn_free() unhashes before
>    dropping lgr/lnk refs, so any socket visible to the diag reader under
>    the hash read_lock has valid conn->lgr and conn->lnk pointers
> - __smc_release() updated to call smc_conn_unhash() for non-fallback
>    sockets so the flag is honoured when smc_conn_free() already ran first
> - smc_diag.c needs no changes; the hash read_lock invariant is
>    sufficient without any per-connection lock in the dump path
> - dropped the clcsock/mutex_trylock fix as that will be addressed
>    separately
>
> Changes in v2:
> - this is v2 of the 2-patch series; the earlier submission was
>    mislabelled [PATCH v3] but was in fact the first version sent to the
>    list
> - split into a 2-patch series; patch 1/2 adds per-connection
>    lgr_lnk_lock infrastructure to smc_core, patch 2/2 fixes the diag
>    dump path using it
> - dropped lock_sock()/release_sock() from __smc_diag_dump(); v1 held
>    the socket lock across all lgr/lnk dereferences, requiring the hash
>    read_lock to be dropped and re-acquired around each socket
> - dropped the restart-from-head loop in smc_diag_dump_proto(); the new
>    design does not drop the hash read_lock mid-walk so the hlist
>    truncation concern no longer applies
> - dropped refcount_inc_not_zero() socket pinning from the dump loop for
>    the same reason: the hash read_lock is now held for the full walk
> - added per-connection lgr_lnk_lock spinlock to struct smc_connection;
>    conn->lgr and conn->lnk are NULLed under this lock in smc_conn_free()
>    before borrowed references are released, establishing the invariant: a
>    non-NULL conn->lgr seen under lgr_lnk_lock guarantees the lgr is alive
> - added lgr_lnk_lock to smc_switch_link_and_count() to protect the
>    conn->lnk pointer swap from concurrent diag readers
> - replaced mutex_lock() on clcsock_release_lock in
>    smc_diag_msg_common_fill() with mutex_trylock(); mutex_lock() was
>    valid in v1 because the hash spinlock had been dropped, but the new
>    design holds the hash read_lock throughout so only a non-sleeping
>    trylock is safe; a failed trylock leaves address fields zeroed, which
>    is acceptable for a monitoring tool
> - all conn->lgr and conn->lnk accesses in __smc_diag_dump() use a
>    snapshot-then-use pattern: fields are copied into local stack
>    variables under lgr_lnk_lock and nla_put() is called after releasing
>    the lock, avoiding any sleeping operation under the spinlock
>
>   net/smc/smc_close.c | 3 +++
>   net/smc/smc_core.c  | 1 +
>   net/smc/smc_diag.c  | 7 ++++++-
>   3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c..aa6363abdd74 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -154,6 +154,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>   		if (sk->sk_state != SMC_PEERABORTWAIT)
>   			break;
>   		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>   		smc_conn_free(&smc->conn);
>   		release_clcsock = true;
>   		sock_put(sk); /* passive closing */
> @@ -165,6 +166,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>   		if (sk->sk_state != SMC_PEERABORTWAIT)
>   			break;
>   		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>   		smc_conn_free(&smc->conn);
>   		release_clcsock = true;
>   		break;
> @@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct *work)
>   		sk->sk_state_change(sk);
>   		if ((sk->sk_state == SMC_CLOSED) &&
>   		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			sk->sk_prot->unhash(sk);
>   			smc_conn_free(conn);
>   			if (smc->clcsock)
>   				release_clcsock = true;
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 04aedd957543..d7bd6d7f428b 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>   {
>   	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
>
> +	smc->sk.sk_prot->unhash(&smc->sk);
>   	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>   		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>   	else
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb..b29bd34acf7b 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -90,7 +90,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>   	r->diag_state = sk->sk_state;
>   	if (smc->use_fallback)
>   		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (sk->sk_state != SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>   		r->diag_mode = SMC_DIAG_MODE_SMCD;
>   	else
>   		r->diag_mode = SMC_DIAG_MODE_SMCR;
> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>   	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>   		goto errout;
>
> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
> +		goto out;
> +
>   	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>   	    smc->conn.alert_token_local) {
>   		struct smc_connection *conn = &smc->conn;
> @@ -185,6 +189,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>   			goto errout;
>   	}
>
> +out:
>   	nlmsg_end(skb, nlh);
>   	return 0;
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
>
