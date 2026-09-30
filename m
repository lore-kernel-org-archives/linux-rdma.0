Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCCA2AEF5;
	Wed, 30 Sep 2026 00:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790726820; cv=none; b=HoFMwirn3FDkXY7KzGzRtjJ2WdEE0SvExVylkojMVwO/AG0bDm6fyCozGgcNajudB41cW7KStsrPOzYnMl7nXgKy0M2rjv0H70F4G56DC5gThYoL9kWEuqBReUcAMYoQEXiK4QVIgKupFXPsxY0bFCf+0C9ioUbryZ8wIIMVLmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790726820; c=relaxed/simple;
	bh=mPTPIKAUNjmfguNjYpT/EavXKWLKkJoW8vykJFb4ZrE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M1cTJG2jsE8RCWmKuBLjwCz2vk0PMpfHv8AxjHAURK8vRPL9stJbNWOAvLVPJVxkPpZWjh5kKzsGQotM9POKL7cEB5GFQmg7LqtU8M2AqCnv00mBc5zSVwWL6F1AwMkOBxHakhaOw+CzjACwss5IjIJgQVStnuSnLBofcJV8mnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAmquCZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAmquCZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714C31F000FF;
	Wed, 30 Sep 2026 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790726818;
	bh=xXVQ9W7M/mZGqFATe6fQKCdJL/j0F5r4P8laP4JUb4M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gAmquCZ94fV+KT6LSBOcB7E6THqPXKBtjapsF4kwQBEQTSvpU6vqKQODg6ns22w3X
	 4SVmfb43jSSwAagke5mcGNJLhY+MID9zJN1O2EpfuVtVbp1r8S05AH9jon+te/HvWk
	 CExEH2skWyjj/8K16h6YNuK/SFz6Qwp8SHjcKczL+6r8lttJa/YeBp/rwz8KQMfUIH
	 oOskGXIrlIYBoWaR5ja2nGbwAnrYZAm/6oGK+WAyhYPrjICecoe9WDdfNAZ6kBpPiS
	 BXgVYDObGov+WVDak8ljbKi7oyDB6nQ7rRDhS7cZg67w69H/h6NnLUockVsZMMJkJW
	 8dk3814MZw8mw==
Subject: Re: [PATCH net] net/smc: protect clcsock lifetime in smc_getname
From: netdev-bot+sashiko@kernel.org
To: nicoyip.dev@gmail.com
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, ubraun@linux.ibm.com,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 30 Sep 2026 00:06:57 +0000
Message-ID: <179072681701.434549.13763000893839581310@kernel.org>
In-Reply-To: <20260926180404.2721010-1-nicoyip.dev@gmail.com>
References: <20260926180404.2721010-1-nicoyip.dev@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 (2) · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch fixes smc_getname(), and its commit message says
  socket option handlers already guard clcsock.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but
  smc_diag_msg_common_fill() (net/smc/smc_diag.c:42-55) has the same…
- [High] This problem wasn't introduced by this patch, but smc_shutdown()
  (net/smc/af_smc.c:3011-3012) runs `if (do_shutdown && smc->clcsock)…

--

net/smc: protect clcsock lifetime in smc_getname

This commit takes clcsock_release_lock in smc_getname() around the
smc->clcsock NULL check and the getname() callback. If link-group
termination has already released the CLC socket through
smc_close_active_abort(), it returns -EBADF.

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e9f93b3ab435b..8b3ee70f8433f 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c

[ ... ]

> @@ -2791,7 +2792,11 @@ int smc_getname(struct socket *sock, struct sockaddr *addr,
>  
>  	smc = smc_sk(sock->sk);
>  
> -	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
> +	mutex_lock(&smc->clcsock_release_lock);
> +	if (smc->clcsock)
> +		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
> +	mutex_unlock(&smc->clcsock_release_lock);
> +	return rc;
>  }

[Severity: High]
The commit message says:

    Hold clcsock_release_lock across the pointer check and the getname()
    callback, as the socket option handlers already do.

Does this hold for every socket option path? SMC does not set
SOCK_CUSTOM_SOCKOPT. So setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, ...) on
an AF_SMC socket never reaches smc_setsockopt():

do_sock_setsockopt()
  sock_setsockopt()
    sk_setsockopt()
      sk->sk_prot->keepalive(sk, valbool)
        smc_set_keepalive()

smc_set_keepalive() in net/smc/af_smc.c uses clcsock without a NULL check
and without clcsock_release_lock:

static void smc_set_keepalive(struct sock *sk, int val)
{
	struct smc_sock *smc = smc_sk(sk);

	smc->clcsock->sk->sk_prot->keepalive(smc->clcsock->sk, val);
}

Take the sequence from the commit message: shutdown(SHUT_WR), then
link-group termination. smc_close_active_abort() calls
smc_clcsock_release(). That sets smc->clcsock to NULL and calls
sock_release() while the SMC file is still open.

Would a later setsockopt(SO_KEEPALIVE) then hit a NULL pointer dereference
in smc_set_keepalive()? And if it runs while smc_clcsock_release() is in
progress, could it become a use-after-free of the CLC socket?

This is a pre-existing issue and was not introduced by this patch.
smc_diag_msg_common_fill() in net/smc/smc_diag.c reads clcsock without
a lock, the same pattern this patch removes from smc_getname():

	if (!smc->clcsock)
		return;
	r->id.idiag_sport = htons(smc->clcsock->sk->sk_num);
	r->id.idiag_dport = smc->clcsock->sk->sk_dport;
	r->id.idiag_if = smc->clcsock->sk->sk_bound_dev_if;
	...

[Severity: High]
The dump path is
smc_diag_dump_proto()->__smc_diag_dump()->smc_diag_msg_common_fill(). It
holds only read_lock(&prot->h.smc_hash->lock).

The comment in smc_inet_destroy_sock() says the diag dumps stay safe only
if the socket is unhashed before smc_clcsock_release(). __smc_release()
does this. smc_close_active_abort() does not: it releases clcsock while
the SMC socket is still hashed. It holds only clcsock_release_lock, which
the diag reader never takes.

Each store to r->id can force a reload of smc->clcsock. Can a dump pass
the NULL check and then reload smc->clcsock as NULL? Could it also load
clcsock->sk after __sock_release() has set it to NULL? The AF_SMC diag
dump needs no privileges, so the result would be a NULL dereference
inside the read_lock section.

A mutex can't be taken under the rwlock. Would one of these work here?

  - A single READ_ONCE() snapshot of clcsock and clcsock->sk, with NULL
    checks, relying on the RCU-deferred socket free.
  - Unhashing the socket before the release on the abort path.

[Severity: High]
This is also a pre-existing issue and was not introduced by this patch.
smc_shutdown() in net/smc/af_smc.c uses clcsock while holding only
lock_sock(sk):

	if (do_shutdown && smc->clcsock)
		rc1 = kernel_sock_shutdown(smc->clcsock, how);

smc_close_active_abort() drops lock_sock before it releases clcsock:

	if (release_clcsock) {
		release_sock(sk);
		smc_clcsock_release(smc);
		lock_sock(sk);
	}

This means lock_sock(sk) alone does not keep clcsock alive. One possible
interleaving:

Thread A: shutdown(SHUT_WR) while in SMC_ACTIVE
  smc_close_shutdown_write()
    release_sock(sk);
    cancel_delayed_work_sync(&conn->tx_work);

Thread B: shutdown(SHUT_RDWR) or shutdown(SHUT_WR) on the same fd
  socket moves to SMC_PEERCLOSEWAIT1

Termination worker:
  __smc_lgr_terminate()->smc_conn_kill()->smc_close_active_abort()
    sk_state = SMC_CLOSED, release_clcsock = true
    release_sock(sk);

Thread A:
    lock_sock(sk);
    state != SMC_ACTIVE, goto again, no case matches, returns
  smc_shutdown()
    smc->clcsock is still non-NULL
    kernel_sock_shutdown(smc->clcsock, how);

Termination worker, concurrently:
    smc_clcsock_release(smc)
      __sock_release()
        sock->sk = NULL;
        sock->ops = NULL;
        iput(SOCK_INODE(sock));

Could this be a NULL dereference or a use-after-free of the CLC socket?
Thread A can sleep in lock_sock() inside inet_shutdown(), outside any RCU
read-side section.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260926180404.2721010-1-nicoyip.dev%40gmail.com
