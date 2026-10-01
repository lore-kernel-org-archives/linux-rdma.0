Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FF33B8105;
	Thu,  1 Oct 2026 07:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790841354; cv=none; b=Ic19+igxzBl6EYLwal/pRpZseR0OYdT3NBqnXWDkpi7rqilZYCw38AtluML7ALCigToIhr7jgFIBntvHX7fXAxF5pMcjFUUh2LSmxT7c33usuBbUDxcHT3c9FuZIa0n3tdJpWaA42X4VASEappw2Dsz5sQC7tTb/lhjqq/cZ85g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790841354; c=relaxed/simple;
	bh=C8gPQJI2uaYaOSlfv/z97nLLJ9Fn6xvQ9MTKQYENmj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQvXkJHKkUQwnZKV3hHNS/H2nitOJLrKtn+pak9J5xygBkqWd7Hph1l0BFUbUeQjxXDJzTf7qmFYPeBDzePguLGYhFLqm0fOSA0Pyi+S3scujNIbh9f+mcGoJKZxkKudQvCinCp/4AwnUqMHoxfctA2YYL0MgOhiBqpKt836cxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SFr5qC77; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SFr5qC77"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69175Xhp1086072;
	Thu, 1 Oct 2026 07:55:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=KLMNfY
	qF5B/kYcb4IfRlNaFStDBYxcLJtTImFTI9Kic=; b=SFr5qC77v5HSQJ7j5BZSYM
	iKLEvldV7GJ1TjGBVgIgYKFrUnj5cEj2Q6NkEFXuP32BjYDyRXQNB5l9+RZkRUVX
	qgDVDIVd4sR1e2bVHcT4OQ6RPGQJW13ozcWkCO5WZ9gZ7S0pGoPX05aOxa6606eq
	z2ooxX4Vj/cZtMvt01Oo7GiNE47dSDuVTeHdecdP+ScuDizdbfbaHWKc9v6E32BL
	n06lsOZikuvrCZD5XjUgIKcbs8fvrecL57Uo3CYRmebODhoPd9uLdF6xDj24aLp1
	KM2LIgEQexiwLfKu2YfWuDdUu3m1BhOpiDayYh/dFNOTLViIvaezIJVWMZZ0VGww
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5ptgq3m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 07:55:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6917Hqrv545802;
	Thu, 1 Oct 2026 07:55:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4h0xcscx0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 07:55:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6917te9t45023622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Oct 2026 07:55:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FA552004D;
	Thu,  1 Oct 2026 07:55:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F8C62004B;
	Thu,  1 Oct 2026 07:55:37 +0000 (GMT)
Received: from [9.123.13.199] (unknown [9.123.13.199])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Oct 2026 07:55:37 +0000 (GMT)
Message-ID: <6fbba8cd-a555-4faf-bf3e-e7169c9f259c@linux.ibm.com>
Date: Thu, 1 Oct 2026 13:25:36 +0530
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
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 8vOtg9njpSP5sMTkC9Ilbd66grI20iNV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzMCBTYWx0ZWRfXz4b4ySRgaukf
 Q/bL6hiWa0DZyIqA4w3LBPV7F+UpEkNVkXuyWDIR74CwrK/c4JEGSsOCqbntQUJNqKximRxl1za
 r07OFihpT75cGU1RMi5mHZdHCLg3HGb3WnInR4gv0n1fRnPXtvPShW5+e/C4uXZMLblWsCcpxEn
 EhcU1e2j4pQd0JYjQQB3yY1PtH+4LsFqcrj6atRzUblHRR9mj9t7WH0xuvRWpb06BCU2C0wmr9/
 VI/sHIie7RSNDQ7mLcy10rZtK7j5uYOmMg9ilYppDl6A8StgLaZd90We9b/JYMi5sbqeRPYm5oA
 qwhk9vRvra6Z4Fu4K5YGbG4RO4ZOP1x0b4T1Aa3vg9WZCZXx2reXTNvrq/YQoqF+IQwwTfbaCiq
 U20L9li5BcHX50klyEPEk09RA6LpBPj/81rnH3dh4s2/puhwSbpnfHMA8Rj2ezgZnjorlIRH0uT
 euJv2aRfo7g14E/+WzQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzMCBTYWx0ZWRfX2bicjkDOU6jk
 kXJjF/LXbuGfWeKcsOtAeYhsPEwDyHsMxnwVhjq3BnXp1jcxmPpuG8vaCcYnRVhJZYbpgWxwPm4
 SwcIsQE3C4j0Y/nR/x7uByfwRK9D+EY=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6abe1202 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=gVUiB03J6SsEFvwYRAQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Bi_cI25Wm-yVV-qc32b4C0ji_s7qGQm6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010030



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
>   that smcss already skips CLOSED sockets on the userspace side; add
>   Fixes: ae2be35cbed2 for the smc_conn_kill() hunk since
>   smcd_buf_detach() was introduced by that commit
> 
> Changes in v6:
> - smc_diag.c: inline sk->sk_state != SMC_INIT into the else-if condition
>   so conn->lgr->is_smcd is never loaded for SMC_INIT sockets; retain the
>   SMC_INIT || SMC_CLOSED early-exit guard and out: label from v5 to
>   defensively skip the CONNINFO/LGRINFO/DMBINFO blocks for sockets with
>   no live connection
> - smc_close.c: remove the unconditional unhash from the top of
>   smc_close_active_abort(); place it scoped immediately before each of
>   the two smc_conn_free() calls in the PEERCLOSEWAIT and PROCESSABORT
>   branches, and before smc_conn_free() in smc_close_passive_work();
>   this avoids prematurely hiding live SMC_ACTIVE/APPCLOSEWAIT sockets
>   from smcss
> - smc_core.c: unhash at the top of smc_conn_kill(), before
>   smcd_buf_detach(), so the socket is off the hash table before
>   conn->sndbuf_desc is freed on the dmb_nocopy path
> 
> Changes in v5:
> - guard conn/lgr/lnk blocks in __smc_diag_dump() with an
>   (SMC_INIT || SMC_CLOSED) state check placed after the
>   SMC_DIAG_FALLBACK nla_put; SMC_INIT can coexist with fallback
>   (smc_sendmsg() MSG_FASTOPEN path), so the guard must not suppress
>   the fallback reason
> 
> Changes in v4:
> - dropped smc_conn_unhash() wrapper, conn->unhashed flag, and all
>   changes to af_smc.c, smc.h, smc_core.c and smc_core.h;
>   smc_unhash_sk() is already idempotent via sk_hashed(), so direct
>   calls at the two teardown sites in smc_close.c are sufficient
> - dropped the __smc_release() hunk: it needs no change since the
>   subsequent unhash there is already a safe no-op
> - fixed premature-unhash issue present in v3: smc_conn_free() must not
>   unhash because smc_conn_abort() calls it before
>   smc_switch_to_fallback() in both smc_listen_decline() and
>   smc_connect_rdma() error paths; unhashing there would make live
>   fallback sockets invisible to smcss
> - likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(),
>   smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed
>   attempt and then smc_conn_create() on the next device; unhashing in
>   smc_conn_free() would permanently hide the established connection from
>   smc_diag since smc_conn_create() does not re-hash the socket
> 
> Changes in v3:
> - redesigned as a single patch; dropped the lgr_lnk_lock spinlock
>   approach and the 2-patch split
> - fix is now at the socket hash layer: introduce smc_conn_unhash() with
>   a per-connection unhashed flag; smc_conn_free() unhashes before
>   dropping lgr/lnk refs, so any socket visible to the diag reader under
>   the hash read_lock has valid conn->lgr and conn->lnk pointers
> - __smc_release() updated to call smc_conn_unhash() for non-fallback
>   sockets so the flag is honoured when smc_conn_free() already ran first
> - smc_diag.c needs no changes; the hash read_lock invariant is
>   sufficient without any per-connection lock in the dump path
> - dropped the clcsock/mutex_trylock fix as that will be addressed
>   separately
> 
> Changes in v2:
> - this is v2 of the 2-patch series; the earlier submission was
>   mislabelled [PATCH v3] but was in fact the first version sent to the
>   list
> - split into a 2-patch series; patch 1/2 adds per-connection
>   lgr_lnk_lock infrastructure to smc_core, patch 2/2 fixes the diag
>   dump path using it
> - dropped lock_sock()/release_sock() from __smc_diag_dump(); v1 held
>   the socket lock across all lgr/lnk dereferences, requiring the hash
>   read_lock to be dropped and re-acquired around each socket
> - dropped the restart-from-head loop in smc_diag_dump_proto(); the new
>   design does not drop the hash read_lock mid-walk so the hlist
>   truncation concern no longer applies
> - dropped refcount_inc_not_zero() socket pinning from the dump loop for
>   the same reason: the hash read_lock is now held for the full walk
> - added per-connection lgr_lnk_lock spinlock to struct smc_connection;
>   conn->lgr and conn->lnk are NULLed under this lock in smc_conn_free()
>   before borrowed references are released, establishing the invariant: a
>   non-NULL conn->lgr seen under lgr_lnk_lock guarantees the lgr is alive
> - added lgr_lnk_lock to smc_switch_link_and_count() to protect the
>   conn->lnk pointer swap from concurrent diag readers
> - replaced mutex_lock() on clcsock_release_lock in
>   smc_diag_msg_common_fill() with mutex_trylock(); mutex_lock() was
>   valid in v1 because the hash spinlock had been dropped, but the new
>   design holds the hash read_lock throughout so only a non-sleeping
>   trylock is safe; a failed trylock leaves address fields zeroed, which
>   is acceptable for a monitoring tool
> - all conn->lgr and conn->lnk accesses in __smc_diag_dump() use a
>   snapshot-then-use pattern: fields are copied into local stack
>   variables under lgr_lnk_lock and nla_put() is called after releasing
>   the lock, avoiding any sleeping operation under the spinlock
> 
>  net/smc/smc_close.c | 3 +++
>  net/smc/smc_core.c  | 1 +
>  net/smc/smc_diag.c  | 7 ++++++-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c..aa6363abdd74 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -154,6 +154,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>  		if (sk->sk_state != SMC_PEERABORTWAIT)
>  			break;
>  		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>  		smc_conn_free(&smc->conn);
>  		release_clcsock = true;
>  		sock_put(sk); /* passive closing */
> @@ -165,6 +166,7 @@ void smc_close_active_abort(struct smc_sock *smc)
>  		if (sk->sk_state != SMC_PEERABORTWAIT)
>  			break;
>  		sk->sk_state = SMC_CLOSED;
> +		sk->sk_prot->unhash(sk);
>  		smc_conn_free(&smc->conn);
>  		release_clcsock = true;
>  		break;
> @@ -433,6 +435,7 @@ static void smc_close_passive_work(struct work_struct *work)
>  		sk->sk_state_change(sk);
>  		if ((sk->sk_state == SMC_CLOSED) &&
>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			sk->sk_prot->unhash(sk);
>  			smc_conn_free(conn);
>  			if (smc->clcsock)
>  				release_clcsock = true;
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 04aedd957543..d7bd6d7f428b 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1517,6 +1517,7 @@ static void smc_conn_kill(struct smc_connection *conn, bool soft)
>  {
>  	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
> 
> +	smc->sk.sk_prot->unhash(&smc->sk);
>  	if (conn->lgr->is_smcd && conn->lgr->peer_shutdown)
>  		conn->local_tx_ctrl.conn_state_flags.peer_conn_abort = 1;
>  	else
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb..b29bd34acf7b 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -90,7 +90,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	r->diag_state = sk->sk_state;
>  	if (smc->use_fallback)
>  		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> -	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
> +	else if (sk->sk_state != SMC_INIT &&
> +		 smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>  		r->diag_mode = SMC_DIAG_MODE_SMCD;
>  	else
>  		r->diag_mode = SMC_DIAG_MODE_SMCR;
> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
> 
> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
> +		goto out;
> +
>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
>  		struct smc_connection *conn = &smc->conn;
> @@ -185,6 +189,7 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			goto errout;
>  	}
> 
> +out:
>  	nlmsg_end(skb, nlh);
>  	return 0;
> 

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
