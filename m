Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A27C492E32;
	Wed, 14 Oct 2026 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792008786; cv=none; b=oyCyWqP3/nsem9h58XA7MV/AgukakVTe2pXg7qpUjllS81DQKFj/pv2mvNWPK8LsaJkIZ4Tmeq0x/SQzEwesni5kFQOOCLjm9pq9yAPy+xWkC9YhP6F47RbN5BEGeH/mX4yrNsDQb6Gbp7MbwHbMpzo2itIHuLu8MYTwftTbXkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792008786; c=relaxed/simple;
	bh=hfaZQa0O46ns1+lIjtFEoazrhgmh4CWflUKN63OrJPI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VhiL3rVMLWm8oLr7mSzNhMIAoWcVjEe6FzXn1VbW+th8ejPLrN3jrg8Mkn89CIV71Vaay41n+Hq7Z9gvazWenQUCsX8CYBn/ONDMRk+Y+nNkWJuHEqAAUap80YH1g2S+muajeqO7pEZCjfEVGUP0l+LbjJRa6Dph9DR5Ju19lNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XA3A/gvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XA3A/gvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678421F000C7;
	Wed, 14 Oct 2026 20:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008776;
	bh=zq0VNMf9rJgF/JjPhMDguneFuINfQZWAHiiC+Es1+f8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XA3A/gvOXR1vhXe5Kkw2jMSieneF5iGMFhymccjp9JFLk0p6gyI0kJORAxzZ4eKe4
	 EG0sHlrGdCdo4ulxn6XaTPgQo84aW+ZQOspQS0fH1YO0tgRsW6NZIja4f3t5MXxpwd
	 9ksmM5lr8wJ/zFss7LnOOnp53+GvpoL80ecIV0XBSpH2Bho1ExGj9pjQY016fBcF6x
	 qIAINoAc6+JCpu3/VCNvumDYVRis3VhWsNY61zEkOB31se333bODue0SKTGbj0SqV7
	 s/1OaCFLVHGNzmq7QtkCgc5NDPtlC0dfB34FxTlAn8yGUqLWpILmStLXJlbOACc4Sj
	 eY3beXMXC++0Q==
Message-ID: <sashiko-outbox-171846@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v7 2/4] net/smc: bound the receive length to the RMB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-disp-f345196c-v7-2-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
 <20261013-b4-disp-f345196c-v7-2-ef3dddfbfa68@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 20:12:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/smc: missing bounds check on bytes_to_rcv in poll/ioctl
- [High] net: smc: UAF in smc_rx_recvmsg() if rmb_desc is freed during unlo=
cked wait
--

commit 724586149d84b7c3037623750dccc8a10739e047
Author: Bryam Vargas <hexlabsecurity@proton.me>
Subject: net/smc: bound the receive length to the RMB

This commit fixes an issue where a forged producer cursor can drive the
receive byte count past the buffer size or into negative values. It
bounds the data available in the receive buffer to the cached RMB length,
preventing out-of-bounds memory accesses during receive operations.

Link: https://sashiko.dev/#/patchset/20261008-b4-disp-f7cd3d96-v6-0-fba616c=
0920c@proton.me?part=3D2
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-=
f7cd3d96-v6-0-fba616c0920c%40proton.me?part=3D2
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261008-b4-disp-=
f7cd3d96-v6-0-fba616c0920c%40proton.me?part=3D1

[ ... ]

> diff --git a/net/smc/smc_rx.h b/net/smc/smc_rx.h
> index 994f5e42d1ba2..6bf44e3cc33a0 100644
> --- a/net/smc/smc_rx.h
> +++ b/net/smc/smc_rx.h
> @@ -25,7 +25,16 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo, siz=
e_t peeked,
>  		int (*fcrit)(struct smc_connection *conn, size_t baseline));
>  static inline int smc_rx_data_available(struct smc_connection *conn, siz=
e_t peeked)
>  {
> -	return atomic_read(&conn->bytes_to_rcv) - peeked;
> +	int avail =3D atomic_read(&conn->bytes_to_rcv);
> +
> +	/* bytes_to_rcv follows the peer's producer cursor and can be past
> +	 * the RMB or negative. Report no more than fits in the RMB behind the
> +	 * bytes already spliced or peeked. Compare before subtracting: near
> +	 * INT_MIN, avail - peeked wraps. This also runs unlocked, possibly
> +	 * after rmb_desc was freed, hence rmb_len.
> +	 */

[Severity: High]
If this runs after rmb_desc was freed during an unlocked wait in
smc_rx_recvmsg(), and returns true because avail is greater than peeked,
won't the reader proceed to use the freed buffer?

Looking at smc_rx_recvmsg() in net/smc/smc_rx.c, the base pointer is
calculated before the wait:

    rcvbuf_base =3D conn->rx_off + conn->rmb_desc->cpu_addr;

If the connection is closed and rmb_desc is freed during the wait, and
smc_rx_recvmsg_data_available() returns true here, the code jumps directly
to the copy phase:

    if (smc_rx_recvmsg_data_available(smc, peeked_bytes))
        goto copy;

Can this lead to a use-after-free when dereferencing the freed
conn->rmb_desc->len in smc_curs_add() and reading from the stale
rcvbuf_base pointer?

[Severity: High]
While this handles the negative value in recvmsg() by clamping it to 0, what
happens to other readers of bytes_to_rcv when a forged cursor in
smc_cdc_msg_recv_action() drives it negative?

For instance, in smc_poll() in net/smc/af_smc.c:

    if (atomic_read(&smc->conn.bytes_to_rcv))
        mask |=3D EPOLLIN | EPOLLRDNORM;

Does this evaluate to true for negative values, potentially causing an
infinite epoll_wait loop?

Also, in __smc_getsockopt() in net/smc/af_smc.c:

    answ =3D atomic_read(&smc->conn.bytes_to_rcv);

Could this leak the negative byte count to userspace via the SIOCINQ ioctl?

> +	avail =3D min(avail, conn->rmb_len - atomic_read(&conn->splice_pending)=
);
> +	return avail > (int)peeked ? avail - (int)peeked : 0;
>  }
> =20
>  #endif /* SMC_RX_H */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-disp-f3=
45196c-v7-0-ef3dddfbfa68@proton.me?part=3D2
