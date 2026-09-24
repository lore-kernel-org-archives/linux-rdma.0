Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD907420897;
	Thu, 24 Sep 2026 07:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790234421; cv=none; b=i4cD9hvQgUP4+e3zvzwryoIp11yh3ZdSEQ2Nl8eIm3Z0xLIy0DigRoyBMgoMoHWjEdHEAwE+l37YqcqJU86uexEEgQkADNUia4jZ6bVSlUkFMFIbmaSEVKV1cJHR2r4NcaSSizeCnnwTGLnG2NZXN5grRT0pBWFV8sA42ZMrz20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790234421; c=relaxed/simple;
	bh=8/+n6ttYS5k4bW8rAJAuplqWZrECTussHVcG4y8g0Gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=upShDqww1avct6ovujdPXEpdevFWok9pd2yBoC5hc1+CjebPSTiMHDfnbmcjW5KTfl34C5Gqy4AF5sE/d/6DaxbxzRJ/GOpeLvnlhvdA4ZuoC5kz5ieoVDpvR4/PDyHJ+u506lSIwGyKObxaadmBfpyqOPxqxuhOoCh8S+jVR1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CJrZGpVx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CJrZGpVx"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5bsmn1373014;
	Thu, 24 Sep 2026 07:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WJhehG
	Qd9aRPX7vjgjx/ERcpmc89lp0B6IGpXEk+EOo=; b=CJrZGpVxrEK0isBpFslGtp
	G67LPbJQuPPlMciSA3NlNHsuqg2MENAyzgo1R2YNMF6yRb5mLHtZM7tPZ7AVBkkf
	mOyTMgYHWJzMVEtdr9TLDVLJ8drcuthkf7pjN/X3ykVMsZIY0Ee3LmTQzRZlC0R9
	C+MJsK7k26cicpPP7Fet3kc68xTiyYhAWdO0b1Or8FOdTlmRAQDnJ2/pFa+EllIl
	H/Sdgmh0PZjfM1AJa72l5yHoTiUj8x4Zm/8ABdLHe7F2NB/Xyhb2MEwef7l4E/y/
	QRxh4Xw0wHS2t4sWATGWPKn+HRpUoB9EtQ5xY65FwHP8z/l7zhAxCTFpvnPfadjg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gskdvexj8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 07:20:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5laFx1555050;
	Thu, 24 Sep 2026 07:20:06 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb8jvky1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Sep 2026 07:20:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68O7K2CS50397634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Sep 2026 07:20:02 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B6DB2004D;
	Thu, 24 Sep 2026 07:20:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D30720040;
	Thu, 24 Sep 2026 07:19:59 +0000 (GMT)
Received: from [9.123.13.199] (unknown [9.123.13.199])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 24 Sep 2026 07:19:58 +0000 (GMT)
Message-ID: <8ff9a376-ac7d-4b72-bb56-01eecb939984@linux.ibm.com>
Date: Thu, 24 Sep 2026 12:49:58 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v5] net/smc: fix lgr/lnk lifetime vs diag reader race
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alibuda@linux.alibaba.com,
        dust.li@linux.alibaba.com
Cc: hidayath@linux.ibm.com, pasic@linux.ibm.com, horms@kernel.org,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
Content-Language: en-US
From: Sidraya Jayagond <sidraya@linux.ibm.com>
In-Reply-To: <20260923061716.1970059-1-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: LydTOY3ZeSpXk65VTGFwI-UWm0F6MsGJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzMCBTYWx0ZWRfXyV0quSZJwNTV
 dUCxd+snDUcZhLJKbqY2jmugnZAKpmePYoo+TjilzISu/9KpfW+IVz/diypud0uB232ds4vliyI
 0Tk3i0gUBYyrOl/B9ibphdZ3HeS1hWc=
X-Authority-Analysis: v=2.4 cv=FLiOVOos c=1 sm=1 tr=0 ts=6ab4cf27 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=LpUJkNdiZc8MTJID-NQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lNS6KwxTJoNfvWvPq3xAF4OhWovsaF3r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzMCBTYWx0ZWRfX7CwQ9odjSmuv
 aG6KXAe85jM7FuFYDEjD9wSikvHnJkrFFzXhJ6MebAXvCwmneDHOddoKDy3w1yPJkaw064Yp6aL
 nOzGw/efj93lrH86Y3pMCGhcdh2oidYNw736ykOoWMsZ6SE3n8fduoW31JjxS+T5OCgMnzBZDKm
 fXlVfmGH7CvRJaCLZPPq5ooiF5pXWVAz3DBFhjfFP7JTZs/Zd9w6e90d+NQpU6B/NCHLmsuVrP0
 p5KQz8V/H6ZtmS9PbWQH0psRz8gyPn5YcVEwwtKvuP5y/5fAqRWGL69t5jXw022Wjcg56yBmEGz
 F6/akUYKXKDmieM/t7VxvL+ghqtBdq67Wk+7BzcTWX1RvlO6djfEFLe4ttxNnzrbAmApXsGEbZd
 EFuvUHrS2EbRINq3vQhgtbz3LrVEnj/gOBFy32sAwWV6HgG56Fs44s8ldyuB2EuMxs0DLzO99uq
 0vGERq5HEVULAw+oylQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609240030



On 23/09/26 11:47 am, Mahanta Jambigi wrote:
> The diag dump walks the socket hash table under a read_lock and dereferences
> conn->lgr and conn->lnk. Two terminal teardown paths drop those references via
> smc_conn_free() while the socket is still hashed:
> 
>   - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free()
>   - smc_close_passive_work() -> smc_conn_free()
> 
> This allows the diag reader to dereference a freed lgr or lnk.
> 
> Fix it by unhashing the socket before smc_conn_free() is called at the two
> terminal teardown sites in smc_close.c.
> 
> Additionally, smc_conn_abort() calls smc_conn_free() during early handshake
> aborts while the socket remains hashed in SMC_INIT state. The
> smc_listen_out_err() path leaves the socket hashed in SMC_CLOSED state after
> smc_conn_abort() returns. Guard the conn/lgr/lnk inspection blocks in
> __smc_diag_dump() by skipping them when the socket is in SMC_INIT or SMC_CLOSED
> state.
> 
> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets")
> Fixes: 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R connections")
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
> ---
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
>   a per-connection unhashed flag; smc_conn_free() unhashes before dropping
>   lgr/lnk refs, so any socket visible to the diag reader under the hash
>   read_lock has valid conn->lgr and conn->lnk pointers
> - __smc_release() updated to call smc_conn_unhash() for non-fallback
>   sockets so the flag is honoured when smc_conn_free() already ran first
> - smc_diag.c needs no changes; the hash read_lock invariant is
>   sufficient without any per-connection lock in the dump path
> - dropped the clcsock/mutex_trylock fix as that will be addressed separately
> 
> Changes in v2:
> - this is v2 of the 2-patch series; the earlier submission was mislabelled
>   [PATCH v3] but was in fact the first version sent to the list
> - split into a 2-patch series; patch 1/2 adds per-connection lgr_lnk_lock
>   infrastructure to smc_core, patch 2/2 fixes the diag dump path using it
> - dropped lock_sock()/release_sock() from __smc_diag_dump(); v1 held the
>   socket lock across all lgr/lnk dereferences, requiring the hash read_lock
>   to be dropped and re-acquired around each socket
> - dropped the restart-from-head loop in smc_diag_dump_proto(); the new
>   design does not drop the hash read_lock mid-walk so the hlist truncation
>   concern no longer applies
> - dropped refcount_inc_not_zero() socket pinning from the dump loop for the
>   same reason: the hash read_lock is now held for the full walk
> - added per-connection lgr_lnk_lock spinlock to struct smc_connection;
>   conn->lgr and conn->lnk are NULLed under this lock in smc_conn_free()
>   before borrowed references are released, establishing the invariant: a
>   non-NULL conn->lgr seen under lgr_lnk_lock guarantees the lgr is alive
> - added lgr_lnk_lock to smc_switch_link_and_count() to protect the conn->lnk
>   pointer swap from concurrent diag readers
> - replaced mutex_lock() on clcsock_release_lock in smc_diag_msg_common_fill()
>   with mutex_trylock(); mutex_lock() was valid in v1 because the hash
>   spinlock had been dropped, but the new design holds the hash read_lock
>   throughout so only a non-sleeping trylock is safe; a failed trylock leaves
>   address fields zeroed, which is acceptable for a monitoring tool
> - all conn->lgr and conn->lnk accesses in __smc_diag_dump() use a
>   snapshot-then-use pattern: fields are copied into local stack variables
>   under lgr_lnk_lock and nla_put() is called after releasing the lock,
>   avoiding any sleeping operation under the spinlock
> 
>  net/smc/smc_close.c | 10 ++++++++++
>  net/smc/smc_diag.c  |  4 ++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index bb0313ef5f7c..3940098c651d 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -130,6 +130,11 @@ void smc_close_active_abort(struct smc_sock *smc)
>  	struct sock *sk = &smc->sk;
>  	bool release_clcsock = false;
> 
> +	/*
> +	 * Unhash before any branch calls smc_conn_free() and drops lgr/lnk refs;
> +	 * the diag reader must not see a hashed socket with freed lgr/lnk.
> +	 */
> +	sk->sk_prot->unhash(sk);
>  	if (sk->sk_state != SMC_INIT && smc->clcsock && smc->clcsock->sk) {
>  		sk->sk_err = ECONNABORTED;
>  		if (smc->clcsock && smc->clcsock->sk)
> @@ -433,6 +438,11 @@ static void smc_close_passive_work(struct work_struct *work)
>  		sk->sk_state_change(sk);
>  		if ((sk->sk_state == SMC_CLOSED) &&
>  		    (sock_flag(sk, SOCK_DEAD) || !sk->sk_socket)) {
> +			/*
> +			 * Unhash before smc_conn_free() drops lgr/lnk refs so the diag
> +			 * reader cannot see a hashed socket with freed lgr/lnk.
> +			 */
> +			sk->sk_prot->unhash(sk);
>  			smc_conn_free(conn);
>  			if (smc->clcsock)
>  				release_clcsock = true;
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb..fb615d3af058 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -103,5 +103,8 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
> 
> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
> +		goto out;
> +
>  	if ((req->diag_ext & (1 << (SMC_DIAG_CONNINFO - 1))) &&
>  	    smc->conn.alert_token_local) {
> @@ -185,5 +188,6 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  			goto errout;
>  	}
> 
> +out:
>  	nlmsg_end(skb, nlh);
>  	return 0;

Reviewed-by: Sidraya Jayagond <sidraya@linux.ibm.com>
