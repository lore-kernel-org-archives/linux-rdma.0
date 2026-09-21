Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71644B3364;
	Mon, 21 Sep 2026 17:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790012059; cv=none; b=HmPxFHGxigqAhw+Tk/fgC77C3EF78JJKYqqjaMe894cBTKCCfqeLHJKYqLo1DuhuFaURmi1HmVxzg++yvvDIlyOMwWZGNp7pHRdc2fWOscaBKB8fSRCiCCuSDiA5AOLTjH3Xb6+2DYPxdZSc78CHHn/RXKpg35sX2m1Qn7UY7h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790012059; c=relaxed/simple;
	bh=NWPMLmKR5H+NciSlzSpaXKEQ9o8CFGTkrapK+qDVBsQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZGag79ZfFV75bbM04PZwD0eNdVI1clUEVa0PYwgrE/d1VOGvpZerPLYoghD8UAx536TZDKnhd9CTK6mJFecEnOZyjJcvFjvryVN2ylATqA4pdoCEl8zqSr0pwbYtd+T4Ql+f8F3fkk4pCG8aOeHoGBh9pnwRZLLvh55W+FVUjxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntfIleXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntfIleXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4CF1F000FF;
	Mon, 21 Sep 2026 17:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790012057;
	bh=alPDCc/SUV227jYN2Mo1xAda//QTLk70i3b6IwDM7UI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ntfIleXtOngS9kgtd13aXHkN8riuMFwNMcUzajbCcBRQQBzBVoBr8ak1m1TfU92GE
	 JI84svf3uFDwrccHoW+x64Ww2sS0QtdqhKvj91gutkuCzXF0exSukcQ5vInYuvLjpL
	 PqqEDW5cX3eOn3T8ucVJx1OBRf0lJnMrk4oqUOOkZuD82IVo35bb8m7AR8LOvHuZF/
	 s8Pkcvg2VNUxARnEhCpojVMdqOsKLjIjOR0E7/KE+VXw/t6Bakr0GKzvEf2mJKaQf4
	 q4cb8gEn2UvgHB6qUTJXvV7QBgspz1ciY3EX+z/8AFZGYFDbMTXhrkAk/rctKHJp9Y
	 vhn9X1eUgqahA==
Subject: Re: [PATCH] net/smc: Fix socket use-after-free in smc_shutdown()
From: netdev-bot+sashiko@kernel.org
To: vulab@iscas.ac.cn
Cc: alibuda@linux.alibaba.com, davem@davemloft.net, dust.li@linux.alibaba.com,
 edumazet@google.com, guwen@linux.alibaba.com, horms@kernel.org,
 kgraul@linux.ibm.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 mjambigi@linux.ibm.com, netdev@vger.kernel.org, pabeni@redhat.com,
 sidraya@linux.ibm.com, tonylu@linux.alibaba.com, wenjia@linux.ibm.com,
 stable@vger.kernel.org
Date: Mon, 21 Sep 2026 17:34:15 +0000
Message-ID: <179001205598.2160803.12068131189751847433@kernel.org>
In-Reply-To: <20260917163956.2162779-1-vulab@iscas.ac.cn>
References: <20260917163956.2162779-1-vulab@iscas.ac.cn>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] net/smc/af_smc.c:smc_shutdown() — the commit claims to fix a
  use-after-free where the passive-closing sock_put() frees sk before…

--

net/smc: Fix socket use-after-free in smc_shutdown()

This moves the passive-closing sock_put() in the smc->use_fallback branch
of smc_shutdown() past release_sock(), using a new passive_close flag, on
the grounds that the put could otherwise free sk before release_sock()
runs.  It carries a Fixes: tag and Cc: stable.

> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index e9f93b3ab435b..70d6da4c6267d 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2946,6 +2946,7 @@ int smc_shutdown(struct socket *sock, int how)
>  {
>  	struct sock *sk = sock->sk;
>  	bool do_shutdown = true;
> +	bool passive_close = false;
>  	struct smc_sock *smc;
>  	int rc = -EINVAL;
>  	int old_state;
> @@ -2983,7 +2984,7 @@ int smc_shutdown(struct socket *sock, int how)
>  		if (sk->sk_shutdown == SHUTDOWN_MASK) {
>  			sk->sk_state = SMC_CLOSED;
>  			sk->sk_socket->state = SS_UNCONNECTED;
> -			sock_put(sk);
> +			passive_close = true;
>  		}
>  		goto out;
>  	}

[Severity: High]
Can the use-after-free described in the changelog actually happen here?

smc_shutdown() is only installed as proto_ops->shutdown (af_smc.c and
smc_inet.c), so it is entered from __sys_shutdown() or
kernel_sock_shutdown() while a struct socket/file reference is alive.  The
socket's own reference on sk is dropped only in smc_release():

net/smc/af_smc.c:smc_release() {
	...
	sock_orphan(sk);
	sock->sk = NULL;
	release_sock(sk);

	sock_put(sk); /* sock_hold above */
	sock_put(sk); /* final sock_put */
}

and smc_release() cannot run while the shutdown syscall holds the fd.  With
that reference plus the passive-closing reference, wouldn't sk_refcnt be at
least 2 at the old sock_put(), making the release_sock()-on-freed-sk path
unreachable?

The commit message also states the reference may be gone because "the
passive closing reference was already consumed by an abort of the active
link group".  Can that state be reached in this branch?  This branch runs
only for smc->use_fallback sockets, and the abort paths leave sk_state at
SMC_CLOSED, SMC_PEERABORTWAIT or SMC_PROCESSABORT:

net/smc/smc_close.c:smc_close_active_abort() {
	case SMC_ACTIVE:
	case SMC_APPCLOSEWAIT1:
	case SMC_APPCLOSEWAIT2:
		sk->sk_state = SMC_PEERABORTWAIT;
		...
		sk->sk_state = SMC_CLOSED;
		sock_put(sk); /* (postponed) passive closing */
}

net/smc/smc_close.c:smc_close_passive_abort_received() {
	case SMC_INIT:
	case SMC_ACTIVE:
	case SMC_APPCLOSEWAIT1:
		sk->sk_state = SMC_PROCESSABORT;
		sock_put(sk); /* passive closing */
}

All three of those states are rejected earlier in smc_shutdown() with
-ENOTCONN:

	rc = -ENOTCONN;
	if ((sk->sk_state != SMC_ACTIVE) &&
	    (sk->sk_state != SMC_PEERCLOSEWAIT1) &&
	    (sk->sk_state != SMC_PEERCLOSEWAIT2) &&
	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
	    (sk->sk_state != SMC_APPCLOSEWAIT2) &&
	    (sk->sk_state != SMC_APPFINCLOSEWAIT))
		goto out;

so the fallback branch is never reached after such an abort.  Could a
reachable path (ideally a KASAN splat) be added to the changelog?

> @@ -3014,6 +3015,8 @@ int smc_shutdown(struct socket *sock, int how)
>  		sock->state = SS_DISCONNECTING;
>  out:
>  	release_sock(sk);
> +	if (passive_close)
> +		sock_put(sk); /* passive closing */
>  	return rc ? rc : rc1;
>  }

[Severity: High]
If the premise in the changelog did hold, does this reordering remove the
problem or just move it?

passive_close is derived solely from sk_shutdown == SHUTDOWN_MASK, which
says nothing about whether this call still owns the passive-closing
reference.  The same unconditional decrement therefore still runs, just
later.

If it drops the last reference, sk is freed while sock->sk still points at
it for an open fd, and the next fd operation touches freed memory:

net/smc/af_smc.c:smc_release() {
	struct sock *sk = sock->sk;
	...
	sock_hold(sk); /* sock_put below */

Wouldn't an ownership check (or bracketing the region with
sock_hold()/sock_put() as smc_release() does) be needed instead of a
reordering, if there really is a stray put to fix?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260917163956.2162779-1-vulab%40iscas.ac.cn
