Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795064009;
	b=vhWJi9kz73sd1V+qW+hd3M/52/NeCpH6vpuvlzVcw4i2Y6koxFNG4Rljx9DVXek3mpHj
	 TqLJ1QZ6hBlZ/pAz1x3q3Q2gODVgT1+G/QDWnVF6uaGRxme0q7/f9zxEV9Y8Agn06dQqc
	 PNtNmqzIQVGs8S9mcHdIK05I4rvALgDdjMP6cnBSGrdIVCpNNA5eB3ApUMm2orh5oojFW
	 2MJVn345+Uk4uZ3TzHoZnaR+OkSgvXTyiM6LQxOhj3aA6HRFBhNLmeW3eIjIMWQh+z/n6
	 6yEJcDWPqGOpw3GsvosKSuxLa/RotThArI5DjRMRodCnPA56fqK4zOwCInQMQ5VYKcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795064009;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=KMF4TyqJrgS4jrFxAQVOcsoKi7mGaayIjEdxPJoSCiQ=;
	b=JvniQ8HBsZ9GEiK7oglrZivCvUC+5DpByIW4wmAMpSq83uRS2Fuq4k3PtF+F5J5gzyVv
	 mXUs5xWgQTZ6rD51SYwoqO6CK0zhYiBQ9RPON0hv5O+E7tu3oS+f6KP3h7m4tdbsJVhN8
	 R5dSgWev/13oB/U6eTfIUeox0qS4j7/0yyUNLgqPJtkk3nijGZZHC6jxRqDbXgIhGha/M
	 ZJqa73FvWz6YwOdfLYNQrtiJGskuVsszZaHO3YN0eBep32NpO/U0fkx/ZWxcVssmvs0VO
	 O9Hy3PkjPbEloDeYUSBRenbJGcKitu1R87jjyGPxumwENBK1Pq8+TG+gdlag03uu+Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ouy0yDgA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68566606A320;
	Thu, 19 Nov 2026 04:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ouy0yDgA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A201F000C4;
	Thu, 19 Nov 2026 04:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795064009;
	bh=KMF4TyqJrgS4jrFxAQVOcsoKi7mGaayIjEdxPJoSCiQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Ouy0yDgAy0SjqCU5Jx9DuZaecoZVPP4sJCXzHsriVBPVUKwDU8BSVM89OdN15u1fJ
	 rSBVTV7JbTxzEtIf9HdLya5FdtWxRQqIIN3rZW5fBRWskK9cH1dqkMApxWXtBoaw70
	 jIQMm1GOOWDw1dyBAQpIfGSm/Zt7QJ5ytAWXWZuaaOYZrRx2bItQBttbfAJo/LE/4/
	 gkSS+FV1ZqoWmo1p/cFwmSp3E6C4FUnEz74RBkmhCni03iw4Sym3r8aEclydylsfbh
	 WUl6wBWIGkkcXcd32oKZKB3cHUHB/t8CffgyCahSzyKoSx2whi38Y0BI2yzINIvhAU
	 94NxK/qmTYwbg==
Subject:
 Re: [PATCH net-next v2 4/5] rds: annotate data-races around core rds sysctls
From: netdev-bot+sashiko@kernel.org
To: jiayuan.chen@linux.dev
Cc: netdev@vger.kernel.org, dust.li@linux.alibaba.com, dsahern@kernel.org,
 idosch@nvidia.com, davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, matttbe@kernel.org, martineau@kernel.org,
 geliang@kernel.org, achender@kernel.org, alibuda@linux.alibaba.com,
 sidraya@linux.ibm.com, mjambigi@linux.ibm.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, linux-kernel@vger.kernel.org, mptcp@lists.linux.dev,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-s390@vger.kernel.org
Date: Thu, 19 Nov 2026 04:53:27 +0000
Message-ID: <179506400752.3136.8984114555998117139@kernel.org>
In-Reply-To: <20261118045137.174026-5-jiayuan.chen@linux.dev>
References: <20261118045137.174026-5-jiayuan.chen@linux.dev>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch only annotates the RDS datapath readers of
  rds_sysctl_reconnect_min_jiffies and rds_sysctl_reconnect_max_jiffies.

--

rds: annotate data-races around core rds sysctls

This patch adds READ_ONCE() to the lockless RDS readers of
reconnect_min_delay_ms, reconnect_max_delay_ms, max_unacked_packets,
max_unacked_bytes and ping_enable. The sysctl handlers already update
these with WRITE_ONCE().

[ ... ]

> diff --git a/net/rds/threads.c b/net/rds/threads.c
> index 639302bab51ef..115fcff0a5b13 100644
> --- a/net/rds/threads.c
> +++ b/net/rds/threads.c
> @@ -137,7 +137,7 @@ void rds_queue_reconnect(struct rds_conn_path *cp)
>  
>  	set_bit(RDS_RECONNECT_PENDING, &cp->cp_flags);
>  	if (cp->cp_reconnect_jiffies == 0) {
> -		cp->cp_reconnect_jiffies = rds_sysctl_reconnect_min_jiffies;
> +		cp->cp_reconnect_jiffies = READ_ONCE(rds_sysctl_reconnect_min_jiffies);
>  		rcu_read_lock();
>  		if (!rds_destroy_pending(cp->cp_conn))
>  			queue_delayed_work(cp->cp_wq, &cp->cp_conn_w, 0);
> @@ -156,7 +156,7 @@ void rds_queue_reconnect(struct rds_conn_path *cp)
>  	rcu_read_unlock();
>  
>  	cp->cp_reconnect_jiffies = min(cp->cp_reconnect_jiffies * 2,
> -					rds_sysctl_reconnect_max_jiffies);
> +					READ_ONCE(rds_sysctl_reconnect_max_jiffies));
>  }

[Severity: Medium]
These two variables have one more lockless reader that is still a plain
load: the sysctl handlers themselves. Does that leave part of the race
described in the commit message unfixed?

In net/rds/sysctl.c, each reconnect sysctl uses the other one's variable
as its range bound:

net/rds/sysctl.c:rds_sysctl_rds_table[] {
	.procname       = "reconnect_min_delay_ms",
	.data		= &rds_sysctl_reconnect_min_jiffies,
	...
	.extra2		= &rds_sysctl_reconnect_max_jiffies,
	...
	.procname       = "reconnect_max_delay_ms",
	.data		= &rds_sysctl_reconnect_max_jiffies,
	...
	.extra1		= &rds_sysctl_reconnect_min_jiffies,
}

Both entries use proc_doulongvec_ms_jiffies_minmax(), which ends up in
proc_ulong_conv() in kernel/sysctl.c:

kernel/sysctl.c:proc_ulong_conv() {
	...
		if ((tbl->extra1 && *(ulong *)tbl->extra1 > tmp_k) ||
		    (tbl->extra2 && *(ulong *)tbl->extra2 < tmp_k))
			return -ERANGE;
		WRITE_ONCE(*k_ptr, tmp_k);
	...
}

If one task writes reconnect_min_delay_ms while another writes
reconnect_max_delay_ms, each handler's WRITE_ONCE() races with the other
handler's plain read of the same variable. KCSAN would report this.

The bound check is also not atomic with the store, so both writers can
pass their checks against the other's old value. For example, with min=100
and max=1000:

task A: write min=500, checked against max=1000, passes
task B: write max=200, checked against min=100, passes

Both writes succeed and leave min=500 > max=200. rds_queue_reconnect()
then starts the backoff at READ_ONCE(min) = 500 and caps the next value at
min(1000, READ_ONCE(max)) = 200. That puts the backoff below the
configured minimum.

Could the extra1/extra2 loads in proc_ulong_conv() use READ_ONCE()? Or
could the two RDS handlers be serialized so that min <= max is enforced
atomically? As far as I can tell, no later patch in the series changes
kernel/sysctl.c or net/rds/sysctl.c.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261118045137.174026-1-jiayuan.chen%40linux.dev
