Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176933EF0AA;
	Sun,  4 Oct 2026 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791100127; cv=none; b=o//XbTZI4Qc8J8LM7bRp8Px36D9MmrwzUwHZyzF9Eb1moptuQm9szca6MwbERC1i3Ku5fUFjXe3Es691S6tPYmYgCQ8S8GKDFpWHDZJt6298Ckus6N0RiclN0TRLd818yqqmFo1dPKh1yV9oozJcwWSyDHLDIf+LVlkaF9FOg9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791100127; c=relaxed/simple;
	bh=ufsoPI5ErQhfwid1FVxSilhHFg/Y1m4Cko/D3D3/ksk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I9KQ7ClqnsyVfxQiPfB4NHlypPCynjB27MyQNcf4uJlFLQRVTor/KAUMILGv0GnRvh+yR4WGFKLICTmfG9/H2d3dnaOTrNsiX8fyBz+OUPH5axx9IDQZyMbFmuZHyssWQvuaCVixAkxDdOty8ZZDJemnYOLNmaRWiQhr0Pq3yGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByMshHBk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByMshHBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FB01F000FF;
	Sun,  4 Oct 2026 07:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791100125;
	bh=qWuqTnRYrVRWB+5EiFqkLhW64/Chnr+y9CqLPL+2oJE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ByMshHBkV60IasVbCdZNNg2rQnG1jxMlC+HK0R+UnGYFr2o7RYGP4OicJePP0RkqD
	 I5ExPMP+uRewlI7zYRY88QZap1sgFcLB+7MfHcHC+/Pp4BO7lqJXaOUsD90SzU1XCH
	 fWbqISa33KhHwOvUOpPScKDJP6Qj5zUrcL9dDgbISfa55xGscG7M9jAfvOOQOZz3N9
	 47tO17ISvW7hoqiHvBi7WevUAgm4pnsoeeXsvG+RJjQhUncMbowaixeRm7FKAyYRmU
	 PYLiKPdau4TV2oxk53q0WrIZUArM6ezFZkVFkdkYssLBykpNuBdfyfmA9H62pk3EYE
	 B4Sh7wxgT0J0A==
Subject: Re: [PATCH net v7] net/smc: fix lgr/lnk lifetime vs diag reader race
From: netdev-bot+sashiko@kernel.org
To: mjambigi@linux.ibm.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Sun, 04 Oct 2026 07:48:44 +0000
Message-ID: <179110012456.434549.13805687630302688897@kernel.org>
In-Reply-To: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
References: <20260930073029.1201202-1-mjambigi@linux.ibm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch does not fully close the diag-reader vs. link-lifetime
  race it says it fixes.
- [Medium] The new safety gates in __smc_diag_dump() depend on a plain,
  lockless load of sk->sk_state.

--

net/smc: fix lgr/lnk lifetime vs diag reader race

This patch tries to close races between the SMC sock_diag dump and
teardown paths. The dump walks the socket hash under read_lock, while the
teardown paths free lgr, lnk or sndbuf_desc state. The patch adds sk_state
based guards for SMC_INIT and SMC_CLOSED sockets to __smc_diag_dump(), and
unhashes the socket earlier in smc_conn_kill(), smc_close_active_abort()
and smc_close_passive_work().

> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index bf0beaa23bdb6..b29bd34acf7b5 100644
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

[Severity: Medium]
Is a plain load of sk->sk_state enough to order the later loads of
conn->alert_token_local, conn->lgr->is_smcd and conn->sndbuf_desc->len?

This check, and the SMC_INIT/SMC_CLOSED guard added below, share no lock
with the writer. Nothing sits between the sk_state load and the conn field
loads: no READ_ONCE(), no smp_load_acquire(), no smp_rmb(). Only a control
dependency links them, and that doesn't order load->load on weakly ordered
CPUs.

On the early abort path the writer runs under lock_sock():

smc_conn_abort()
  smc_conn_free()
    smc_lgr_unregister_conn()    /* alert_token_local = 0 */
  smc_lgr_cleanup_early()
    __smc_lgr_terminate()
      smc_lgr_free()             /* lgr and buffers freed, conn->lgr and
                                    conn->sndbuf_desc left set */
smc_switch_to_fallback()
...
sk->sk_state = SMC_ACTIVE

On arm64, could the reader see sk_state == SMC_ACTIVE together with a
stale non-zero alert_token_local? It would then read lgr->is_smcd or
sndbuf_desc->len from freed memory and copy the value into the netlink
reply.

This can't happen on x86 or s390, which keep load-load order, and the
writer's window is long. The Linux kernel memory model still allows it.

Would READ_ONCE() or smp_load_acquire() on sk_state (or an smp_rmb()
before the conn field loads), paired with release-ordered state changes,
be needed here?

> @@ -103,6 +104,9 @@ static int __smc_diag_dump(struct sock *sk, struct sk_buff *skb,
>  	if (nla_put(skb, SMC_DIAG_FALLBACK, sizeof(fallback), &fallback) < 0)
>  		goto errout;
>  
> +	if (sk->sk_state == SMC_INIT || sk->sk_state == SMC_CLOSED)
> +		goto out;
> +

[Severity: High]
Does this leave the conn->lnk replacement during SMC-R link failover still
racing with the diag reader?

For SMC_ACTIVE and closing-state sockets, the LGRINFO block further down
still does this with only read_lock(&smc_hash->lock) held:

net/smc/smc_diag.c:__smc_diag_dump() {
    ...
		struct smc_link *link = smc->conn.lnk;
		...
		memcpy(linfo.lnk[0].ibname, link->smcibdev->ibdev->name,
		       sizeof(link->smcibdev->ibdev->name));
    ...
}

The failover side doesn't take the hash lock and doesn't unhash the
socket. For example, when the peer sends DELETE_LINK:

smc_llc_process_cli_delete_link()
  smc_switch_conns(lgr, lnk_del, false)
    smc_switch_link_and_count(conn, to_lnk)
      smcr_link_put(conn->lnk);
      conn->lnk = to_lnk;
  smcr_link_clear(lnk_del, true)
    ...
    __smcr_link_clear()
      put_device(&lnk->smcibdev->ibdev->dev);
      smcibdev = lnk->smcibdev;
      memset(lnk, 0, sizeof(struct smc_link));
      ...
      atomic_dec_return(&smcibdev->lnk_cnt)

A local RNIC or port going down reaches smc_switch_conns() the same way,
through smcr_link_down().

smc_switch_link_and_count() runs only under lgr->conns_lock and
conn->send_lock. The diag reader takes neither lock.

Suppose the reader loaded the old conn->lnk before the switch and was
delayed before the later loads. Could it then dereference a NULL
link->smcibdev after the memset()? Could it instead read a freed smcibdev
or ibdev and copy those bytes to userspace?

An unprivileged SOCK_DIAG dump that asks for SMC_DIAG_LGRINFO (for
example smcss -R) can reach this.

The socket stays hashed in SMC_ACTIVE or a closing state. So neither this
guard nor the !list_empty(&smc->conn.lgr->list) check from 9dbe086c69b8
filters it out.

v2 of this patch protected the swap in smc_switch_link_and_count() with
lgr_lnk_lock, but v3 dropped that. The patch still carries Fixes:
9dbe086c69b8 and is titled "fix lgr/lnk lifetime vs diag reader race".
Should the conn->lnk replacement also be covered, for example with a lock
or RCU pairing on the link swap?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260930073029.1201202-1-mjambigi%40linux.ibm.com
