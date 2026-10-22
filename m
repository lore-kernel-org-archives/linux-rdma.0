Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792689223;
	b=nH6TLKcqeesdh7PcPkEOyx4IJ99MfVkVddVcJUbG0nQPpLekI/6K6dHrXqEGwV8j2n49
	 /rxpvU9mfgFqhCs18WJKPtirEdEj49SqRYokw5lH3glIpcZ51qXR1xffO3rDu9woUON3Q
	 4yNT6bN37o2TkhfT+Xa2NsPSCJGrsVbwudeO7mTJHSJHj7J1cO4sPoP8hT+DvrvyVXb2U
	 7IgLN6s/GzoyCCCsnvqCJA9IQ4zGD5yj0/7Pm+B2VZGzjLFnrX/hzNofdZSJMkecX1A4k
	 /3u86WqkakxnHOmNa9hQkqy98pEXjDbiBsuYVlJyFlJMNlYZDDExuCVmhuSXWWl8GWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792689223;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oUQ6L2l1B4d2WH0wn6VK3uY+euWvowYu10mI+yzi6PI=;
	b=oB+zVHBVxte5JsunYIanDdBYDC3ZrJmHWAiSfz30yc6DVcsNDQi2QQ5v14twCgFDyAnY
	 J/b8RqkMfSvGMyy/fE3DeIFdXeIkGoR/Er7rHdZPhz3t7EYGrF+fwRlG+jhW8Rzk5k1a9
	 jL4gM34VrDqEBFapqrWHVLo2I5fqndQulAsAeL+1cOQxpZ562KeQP8xjk7TRLrsHaF+/U
	 FE7NbsbVjZSHqNAHvZjSCj5muh6VoJn8W/nNqi3FzKuN9DRaoJFIcsa6kOA7wlPWXVmAm
	 9PkCaCD1EmvaQprz722LtyqhkUCzT/EYpgGwIFmsidlo/g0M8mHVPryF2kY72mGg7Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lv3lm5V3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA03A606A31F;
	Thu, 22 Oct 2026 17:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lv3lm5V3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D8B1F01825;
	Thu, 22 Oct 2026 17:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792689222;
	bh=oUQ6L2l1B4d2WH0wn6VK3uY+euWvowYu10mI+yzi6PI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lv3lm5V3y1/WAyQwODofH/x9Y2hsc/V+RLzbGC0LFntqCy9+h1o4GMBm0GJlQ0ITM
	 KRGn0LcyNxkmnhEHiC0teRJ5+l+ZONyXAoBQsP7/CP7utRQw6j66zFvx2sslsE2hkj
	 nAi8VRRMdG06h5q5BiIFuBwrcGqgZ8SHfPaUCtsnIlmsLHwqatLy2mxqZhIsxRNHUj
	 2Q3tR08FNuTOhbu2bJvf+Xwg5cmdFN8nOn6q/1lrL8RLzKTEws9BM/8bKXiyfUU1gT
	 UU8xYd6/9cw1CrScCi/Ha+CawbV8GjPoOV95lJB/7GcodOLCwHe4BDE/ZCrC6u2p0n
	 /ZcsstfTh+xGA==
Message-ID: <sashiko-outbox-181848@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] net/smc: reject CDC messages after connection teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weiming Shi" <bestswngs@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261021171256.166870-2-bestswngs@gmail.com>
References: <20261021171256.166870-2-bestswngs@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 17:13:41 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] net/smc: bh_lock_sock() in smc_cdc_msg_recv() does not exclude=
 smc_conn_free()
--

commit 64de84c513a98ece4d44144df98874a465343ddf
Author: Weiming Shi <bestswngs@gmail.com>

net/smc: reject CDC messages after connection teardown

This commit checks smc->conn.freed in smc_cdc_msg_recv() after acquiring
bh_lock_sock(&smc->sk) to avoid processing CDC messages and dereferencing
released receive buffer descriptors after connection teardown.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..499a2473b79b4 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -428,7 +428,8 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, st=
ruct smc_cdc_msg *cdc)
>  {
>  	sock_hold(&smc->sk);
>  	bh_lock_sock(&smc->sk);
> -	smc_cdc_msg_recv_action(smc, cdc);
> +	if (!smc->conn.freed)
> +		smc_cdc_msg_recv_action(smc, cdc);
>  	bh_unlock_sock(&smc->sk);
>  	sock_put(&smc->sk); /* no free sk in softirq-context */
>  }

[Severity: Critical]
Does checking smc->conn.freed under bh_lock_sock(&smc->sk) actually seriali=
ze
smc_cdc_msg_recv() against smc_conn_free()?

Process-context callers of smc_conn_free(), such as smc_release() ->
__smc_release() -> smc_conn_free(), hold the sleeping socket lock via
lock_sock(&smc->sk). In net/core/sock.c:lock_sock_nested(), acquiring the
user-context socket lock sets sk->sk_lock.owned =3D 1 and immediately drops
sk->sk_lock.slock so the caller can sleep:

net/core/sock.c:lock_sock_nested() {
	spin_lock_bh(&sk->sk_lock.slock);
	if (unlikely(sock_owned_by_user_nocheck(sk)))
		__lock_sock(sk);
	sk->sk_lock.owned =3D 1;
	spin_unlock_bh(&sk->sk_lock.slock);
}

Meanwhile, smc_cdc_msg_recv() runs in tasklet context via
smc_wr_rx_tasklet_fn() -> smc_cdc_rx_handler() -> smc_cdc_msg_recv() and
calls bh_lock_sock(&smc->sk), which only acquires sk->sk_lock.slock without
waiting on sk->sk_lock.owned. In fact, smc_cdc_msg_recv_action() in
net/smc/smc_cdc.c explicitly checks sock_owned_by_user(&smc->sk) because it
can run while a process holds lock_sock(&smc->sk):

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
	...
		if (!sock_owned_by_user(&smc->sk))
			smc_tx_pending(conn);
		else
			conn->tx_in_release_sock =3D true;
	...
}

In net/smc/smc_core.c:smc_conn_free(), conn->freed =3D 1 and smc_buf_unuse()
run without holding bh_lock_sock(&smc->sk) and before
smc_lgr_unregister_conn(conn):

net/smc/smc_core.c:smc_conn_free() {
	...
	conn->freed =3D 1;
	...
	if (!list_empty(&lgr->list)) {
		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
		smc_lgr_unregister_conn(conn);
	}
	...
}

If CPU 0 enters smc_cdc_msg_recv(), acquires bh_lock_sock(&smc->sk), and se=
es
!smc->conn.freed just before CPU 1 in smc_conn_free() sets conn->freed =3D 1
and frees conn->rmb_desc or conn->sndbuf_desc via smc_buf_unuse(), can CPU 0
still concurrently dereference the freed conn->rmb_desc->len in
smc_cdc_msg_recv_action():

net/smc/smc_cdc.c:smc_cdc_msg_recv_action() {
	...
	diff_prod =3D smc_curs_diff(conn->rmb_desc->len, &prod_old,
				  &conn->local_rx_ctrl.prod);
	...
}

Additionally, if smc_cdc_msg_recv_action() observes
sock_owned_by_user(&smc->sk) while __smc_release() holds lock_sock(&smc->sk=
),
won't setting conn->tx_in_release_sock =3D true cause the subsequent
release_sock(&smc->sk) in smc_release() to invoke smc_release_cb() ->
smc_tx_pending() on a connection that smc_conn_free() has already torn down?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021171256.1668=
70-2-bestswngs@gmail.com?part=3D1
