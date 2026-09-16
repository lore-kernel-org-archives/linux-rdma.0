Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6676C39B4A1;
	Wed, 16 Sep 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572286; cv=none; b=BRW5D9e/P0DCsqoRuitxOXXDrxJJh5WBX9uhFhLvRtq4yiqAyJRPnbpMUmBKkCUU/zSEQ0A+nihomFp6S+dcQ+jxaxgaCZCpvnWbpwrnH/GqZGxj5cle07COmO8FO3cHXAKGEMJ1sQ8VG86UPdEK0B5GWtr6rjXemBDCeYwJ3GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572286; c=relaxed/simple;
	bh=48ov771l7rFfx5BnK/hpYiF20PYqHQ/HNCUJ+lqMgo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGzGVoIy0FGleuusGgtcLAo0YXJhgPWwIek9actksOnmLO/sH7i1HWRX2AVj9UH++XYRSFGEq0wXxvJYckqAddIH3q5S7Q8FePwlhs0F2wQKJpq6nbJE+swKbFZnLjRVa2cwWXjedfL8hK5ctJcIyGS/UvkvJdyHC2ULsUz87Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=igzB62xN; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="igzB62xN"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789572272; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=0SvDXyzZzPJmVIqjiPPsLDemSHDxY7/l7W7nRbF8vlw=;
	b=igzB62xNXbWx4rpFjlApBkBt8roC/UM5nE0UmmwdOwpz9qp8p/jn2AuSE1x7afD1Yt30hNSIeJKXC1sF2qrUYP/orsRPqj4TvlCVhk/MBuYUrW4zN8yRXwU/lEvT4m06/5hZtYTQxuPf1Q+GtoUHY68sW9ZsyUy0qFRbHwK5uSU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XB5IWPz_1789572271;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XB5IWPz_1789572271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 16 Sep 2026 23:24:31 +0800
Date: Wed, 16 Sep 2026 23:24:30 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: Mahanta Jambigi <mjambigi@linux.ibm.com>, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, alibuda@linux.alibaba.com, sidraya@linux.ibm.com
Cc: pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com, hidayath@linux.ibm.com,
	stable@vger.kernel.org, netdev@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v4] net/smc: fix lgr/lnk lifetime vs diag reader race
Message-ID: <aqq0rnQjiKymR3TM@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20260911090906.1949163-1-mjambigi@linux.ibm.com>
 <aqlgtaEk3kNcg-Yp@linux.alibaba.com>
 <69676c38-3d68-41db-8b26-3e589d7477d5@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69676c38-3d68-41db-8b26-3e589d7477d5@linux.ibm.com>

On 2026-09-16 14:04:42, Mahanta Jambigi wrote:
>
>
>On 15/09/26 8:43 pm, Dust Li wrote:
>> On 2026-09-11 11:09:06, Mahanta Jambigi wrote:
>>> The diag dump walks the socket hash table under a read_lock and
>>> dereferences conn->lgr and conn->lnk.  Two terminal teardown paths
>>> drop those references via smc_conn_free() while the socket is still
>>> hashed:
>>> 
>>> - smc_conn_kill() -> smc_close_active_abort() -> smc_conn_free() -
>>> smc_close_passive_work() -> smc_conn_free()
>>> 
>>> This allows the diag reader to dereference a freed lgr or lnk.
>>> 
>>> Fix it by unhashing the socket before smc_conn_free() is called at
>>> each of these two sites.  Any socket visible to the diag reader
>>> under the hash read_lock then has valid conn->lgr and conn->lnk
>>> pointers.
>>> 
>>> Fixes: f16a7dd5cf27 ("smc: netlink interface for SMC sockets") Fixes:
>>> 9dbe086c69b8 ("net/smc: fix invalid link access in dumping SMC-R
>>> connections") Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
>>> --- Changes in v4: - dropped smc_conn_unhash() wrapper, conn-
>>> >unhashed flag, and all changes to af_smc.c, smc.h, smc_core.c and
>>> smc_core.h; smc_unhash_sk() is already idempotent via sk_hashed(),
>>> so direct calls at the two teardown sites in smc_close.c are
>>> sufficient - dropped the __smc_release() hunk: it needs no change
>>> since the subsequent unhash there is already a safe no-op - fixed
>>> premature-unhash issue present in v3: smc_conn_free() must not unhash
>>> because smc_conn_abort() calls it before smc_switch_to_fallback() in
>>> both smc_listen_decline() and smc_connect_rdma() error paths; unhashing
>>> there would make live fallback sockets invisible to smcss -
>>> likewise, the ISM/RDMA retry loops (smc_find_ism_v2_device_serv(), 
>>> smc_find_rdma_v2_device_serv()) call smc_conn_abort() on a failed attempt
>>> and then smc_conn_create() on the next device; unhashing in 
>>> smc_conn_free() would permanently hide the established connection
>>> from smc_diag since smc_conn_create() does not re-hash the socket
>> 
>> Hi Mahanta,
>> 
>> This version looks clean. And you explained why we can't call unhash
>> in smc_conn_abort() well. But smc_conn_abort() still calls
>> smc_conn_free(), when the smc_sk is still hashed, is there still a
>> race window with dump ?
>
>Hi Dust,
>
>Thank you for catching this corner case!
>
>During early handshake setup (when sk_state is *SMC_INIT*),
>smc_conn_abort() can be called on connection failure/fallback and
>invokes smc_conn_free() while the socket remains hashed, leaving a
>window where a concurrent diag dump could evaluate smc_conn_lgr_valid()
>and dereference conn->lgr / conn->lnk.
>
>Since sockets in *SMC_INIT* are in a transient embryonic handshake phase
>and userspace (smcss) *skips displaying link-group, DMB, and connection
>details for INIT state sockets anyway*, we could have __smc_diag_dump()
>skip inspecting connection/link-group extensions when r->diag_state ==
>SMC_INIT:
>
>diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
>--- a/net/smc/smc_diag.c
>+++ b/net/smc/smc_diag.c
>@@ -90,6 +90,9 @@ static int __smc_diag_dump(struct sock *sk, struct
>sk_buff *skb,
> 	r->diag_state = sk->sk_state;
>+	if (r->diag_state == SMC_INIT)
>+		return 0;
>+
> 	if (smc->use_fallback)
> 		r->diag_mode = SMC_DIAG_MODE_FALLBACK_TCP;
> 	else if (smc_conn_lgr_valid(&smc->conn) && smc->conn.lgr->is_smcd)
>
>Together with unhashing before smc_conn_free() in smc_close.c for
>established and closing sockets, this cleanly closes the race window
>across all socket states without touching the hash table mechanics
>during fallback/retry.
>
>Does this approach look good to you? If you agree, I will prepare and
>submit v5 with this change. Please let me know if you have any other
>suggestions or alternative approaches, and I'll be happy to look into them.

What about this path ?

smc_listen_decline() -> smc_listen_out_err(), where smc_conn_abort() has
already run, and the sock state is then changed from SMC_INIT to SMC_CLOSED.

Best regards,
Dust

