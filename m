Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D1926A1AC;
	Wed, 30 Sep 2026 00:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728354; cv=none; b=Hp5t6hESYx4Q5mO+i8vT8nvhsuJuSPOwdCk74e93AiSJNImZYiM4Ax/CROxQzqNYQy6QtIhX2Wt243tWntrb10l68ZjtW/Bq6zjoHgeIPyom9xlpF9j3zg8IZIEeHwus08Tu/qQNzYW7yW21lzDtT02soFb/5nWlVfHBtZJ5pDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728354; c=relaxed/simple;
	bh=M8fxDA1DIp7+jAxZIbYPI+tGNnk5OZUmkIF58FCryhY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d7RSFfPMYmdgwc43dfdUII7P44WuQp2garVi8CMJu37LvmWBNuBLo4gET20OlUf7LDSN7fLNrxgebEC402kziJSh7aSVSdY7UJmCS7CfQ1PVR5OL8wjf5EUpSW7DFSl+ncR6Qv3jbzKvILkZpZtmWxBdOC7QKiQQZz2mUeHWsZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbFRKRcV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbFRKRcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F721F000FF;
	Wed, 30 Sep 2026 00:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790728352;
	bh=tkoYgtYrlo5lToTcdwBHyFbcIRv/NUc0CmuJYcReG5c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VbFRKRcVmbjEQ76/uBF/GmVw6/qVxruO5oaHmQUG5dnxR52jgRbM4eoLPqhs3TuY6
	 l/7j2L0uxWb30Jp2UsipUZky6LXLrblRPoO4XaMYgAOB7Ps6TfdSxMLJwjMzm86pJt
	 yXkYjcvmSmKfGhtXfeaVLmcjMnjHy+WWQM4p09cK83zOgkbdlJzkm6tcHxHWe9oeTN
	 aoKKcKEuZHxN28DcwE3KAg9ryzedUO2+YOGTetc5Jpm5r/YCYHl8tXYDNQtJ2Av+Rt
	 RhCLZFrK/YlpbP4SwM0P8r5p7CgxPf1e7cqam4Eowiwy65+vimPd81ex0Z67LYcZwP
	 H0meO36f2k9hw==
Subject: Re: [PATCH net] net/smc: serialize sndbuf descriptor release with
 diagnostic dumps
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, wenjia@linux.ibm.com,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 30 Sep 2026 00:32:31 +0000
Message-ID: <179072835104.434549.14430285577911070387@kernel.org>
In-Reply-To: <20260927073203.3694279-1-nicoyip.dev@gmail.com>
References: <20260927073203.3694279-1-nicoyip.dev@gmail.com>
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

Critical: 0 · High: 2 (1) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix is incomplete: smc_buf_create() still frees
  conn->sndbuf_desc without serializing against __smc_diag_dump().
- [High] The SMC-R release path smc_conn_free() -> smc_buf_unuse() ->
  smcr_buf_unuse() also frees descriptors that the diag reader can still…

Pre-existing issues:
- [High] __smc_diag_dump() checks its guards without any lock:
  smc->conn.alert_token_local (smc_diag.c:107-108) and…

--

net/smc: serialize sndbuf descriptor release with diagnostic dumps

This patch takes the SMC hash write lock in smcd_buf_detach() while it
clears conn->sndbuf_desc. The goal is to stop __smc_diag_dump(), which
reads the descriptor under read_lock(&h->lock), from seeing a freed
descriptor. The descriptor is freed once the lock has been dropped.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index 9974149659c2f..f32fc1bd5bc85 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -1207,6 +1207,8 @@ static void smcr_buf_unuse(struct smc_buf_desc *buf_desc, bool is_rmb,
>  
>  static void smcd_buf_detach(struct smc_connection *conn)
>  {
> +	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
> +	struct smc_hashinfo *h = smc->sk.sk_prot->h.smc_hash;
>  	struct smcd_dev *smcd = conn->lgr->smcd;
>  	u64 peer_token = conn->peer_token;
>  	struct smc_buf_desc *buf_desc;
> @@ -1216,8 +1218,10 @@ static void smcd_buf_detach(struct smc_connection *conn)
>  
>  	smc_ism_detach_dmb(smcd, peer_token);
>  
> +	write_lock_bh(&h->lock);
>  	buf_desc = conn->sndbuf_desc;
>  	conn->sndbuf_desc = NULL;
> +	write_unlock_bh(&h->lock);
>  	kfree(buf_desc);
>  }

[Severity: High]
The subject says sndbuf descriptor release is now serialized with diag
dumps. Is smcd_buf_detach() the only place that frees conn->sndbuf_desc
while the socket is visible to __smc_diag_dump()?

smc_buf_create() has an error path for when the RMB fails after the
sndbuf was already created:

net/smc/smc_core.c:smc_buf_create() {
    ...
	rc = __smc_buf_create(smc, is_smcd, true);
	if (rc && smc->conn.sndbuf_desc) {
		down_write(&smc->conn.lgr->sndbufs_lock);
		smc_lgr_buf_list_del(smc->conn.lgr, false,
				     smc->conn.sndbuf_desc);
		up_write(&smc->conn.lgr->sndbufs_lock);
		smc_buf_free(smc->conn.lgr, false, smc->conn.sndbuf_desc);
		smc->conn.sndbuf_desc = NULL;
	}
    ...
}

smc_buf_free() goes to smcr_buf_free() or smcd_buf_free() and kfree()s
the descriptor. The pointer is only cleared after that, and h->lock is
never taken.

At this point smc_sk_init() has already hashed the socket via
sk->sk_prot->hash(sk). smc_conn_create()->smc_lgr_register_conn() has
also set conn->alert_token_local. A dump that holds only
read_lock(&h->lock) can pass the alert_token_local check and then
evaluate this on the freed descriptor:

net/smc/smc_diag.c:__smc_diag_dump() {
    ...
			.sndbuf_size = conn->sndbuf_desc ?
				conn->sndbuf_desc->len : 0,
    ...
}

Could this cause the same slab-use-after-free the commit message
describes? It would affect SMC-R, and SMC-D devices without DMB nocopy.
Four callers can reach it when RMB allocation fails (-ENOMEM, or DMB
exhaustion on SMC-D): smc_connect_rdma(), smc_connect_ism(),
smc_listen_rdma_init() and smc_listen_ism_init(). The value is copied
to userspace as cinfo.sndbuf_size, and the SOCK_DIAG dump has no
capability check.

[Severity: High]
Is there a similar unserialized release on SMC-R through
smc_conn_free()->smc_buf_unuse()->smcr_buf_unuse()?

net/smc/smc_core.c:smcr_buf_unuse() {
    ...
	if (buf_desc->is_reg_err) {
		/* buf registration failed, reuse not possible */
		...
		smc_buf_free(lgr, is_rmb, buf_desc);
    ...
}

This kfree()s the descriptor, but conn->sndbuf_desc (for a vzalloc'ed
sndbuf) or conn->rmb_desc still points at it.

In smc_conn_free() this happens before smc_lgr_unregister_conn(), and
alert_token_local is only cleared inside the unregister:

	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}

smcr_link_reg_buf() sets is_reg_err when smc_wr_reg_send() fails.
smc_connect_rdma() then jumps to connect_abort, which calls
smc_conn_abort()->smc_conn_free() on a socket that is hashed and still
has its token set. The listen side follows the same pattern.

Would a dump that runs between smc_buf_unuse() and
smc_lgr_unregister_conn() read sndbuf_desc->len or rmb_desc->len from
freed memory? Should this release site also be serialized with h->lock?

[Severity: High]
This is a pre-existing issue, not one introduced by this patch. The new
h->lock section ends before the rest of the teardown in smc_conn_kill():

net/smc/smc_core.c:smc_conn_kill() {
    ...
	smc_lgr_unregister_conn(conn);
	smc_close_active_abort(smc);
}

__smc_diag_dump() checks smc->conn.alert_token_local, smc_conn_lgr_valid()
and list_empty(&lgr->list), and nothing on the teardown side excludes
those checks. After them it dereferences conn->sndbuf_desc->len,
conn->rmb_desc->len, conn->rmb_desc->token and
conn->lgr->smcd->dibs->gid.

The socket can still be hashed in PEERCLOSEWAIT1/2, PEERFINCLOSEWAIT,
PROCESSABORT or APPFINCLOSEWAIT, for example after shutdown(). In that
case smc_close_active_abort() calls smc_conn_free()->smc_lgr_put(), and
the link group can then be freed through __smc_lgr_free():

	smc_lgr_free_bufs(lgr);
	...
	kfree(lgr);

conn->sndbuf_desc, conn->rmb_desc and conn->lgr are not cleared on this
path.

Suppose a dump passes the checks before smc_lgr_unregister_conn() and is
then delayed before the dereferences. read_lock() is preemptible on
PREEMPT_RT, and IRQ or vCPU preemption can also cause this. Can the dump
then read freed descriptors, or load smcd from a freed lgr and
dereference smcd->dibs?

This also affects the commit's own smc_smcd_terminate_all() scenario.
The sndbuf_desc->len read is still exposed on SMC-D devices without
nocopy, and the rmb_desc->len read on the next line is still exposed on
nocopy devices.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927073203.3694279-1-nicoyip.dev%40gmail.com
