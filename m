Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446136;
	b=EAhFR60SPYC4IIwx2zDN0pCld1F6XSTwJN/AB5a2HW2gAg/7h9A6xQ1xt89+VX8UYvwP
	 HzWfO0w+o9esf7n4IxPsjgacLweSMlddBOn8uI8Cq34CUL2ZroF/s4EWP1H2eVY7NJzuN
	 JQQgnG9DkrWAHqVi98LgkQAw4k3DmWqFb3m8BBFd/KdyLhYw9vtvNoG6u/6lGK1ZUdZJ8
	 /XFFgMrKHhteN7bBS5zpYCGyeRWkjKVln2YIPruHqcYQ/An2bOznW3BV5R0HOBVcSGGr/
	 gOuVtuRxL1ofrH0ujUy3W1AJlL8ATH4OEKebMaloO0ONMNGKGG+vSmq5Ynhcq/SkFSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446136;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4+p2Ol9rfv+lZGs8fA3gqiJbeb7tGlOWrTdyBWHI8R8=;
	b=HX48RAGeTA+1nCYcLkRag14XuKRvWsm8BUbKaFDatIVWO/MswP9+HbE8KrjvVjeONxB+
	 0X7m7Pr07C0tIdv+YlCpoAoA/Ne3E7dmXb3PsaK3oRnNwxfo7RK5QySS7xAK6dn/bBslE
	 DQIpaP7NbTq8Xt5Gd3tsCGZhl1ThDRR9E1cGDzcUq0Cbfb4ea9PmCjFrZLjgif8ucTxc1
	 XPIDrmoFlu9BhJTBqSwkdYj4++MFtUgAx9VZIwkwjHsK5xqLKJtmqSKxZIyAf0KrzrOMc
	 TR2fOC0Kb0o4ya7i59VEH1FEaaymzlxc12ewvpzizX7Sqh9vhRpkWddZ7xd2yMXqxFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2mYtoak;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10563606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 15:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2mYtoak
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C5E1F000EC;
	Mon, 23 Nov 2026 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446135;
	bh=4+p2Ol9rfv+lZGs8fA3gqiJbeb7tGlOWrTdyBWHI8R8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M2mYtoakSRKhme8KnnudcreCb/RQ7FUKhQySgYrBhnBLEkKGdPEs2SceC9pB1oXKD
	 x/bKQcOTFqrCs2Z3cEpYG4+3IHcDnWF79gW8i9TqGM7qu81ESTMEsd11HKJn+Yo8dY
	 ZXSTydyPZjRcuqlrc8giUJAtLvXNdt0lReMwOZr1ui6ZQhzEX7qtigdxIqnJAfwyHu
	 I+zo/fq1o1j7HHhtDZvbZI+Dlj0wfMiayBsIycPSOc98YXHU/QYBmneI2vgFiPDgG1
	 FyJij6quLs/9PCJxagmTH7YrW/SncJORQ3YITjxS+f62Kb57n7c9FT0YMtHVz6FRxT
	 u8jJ5LVnVoAIA==
Message-ID: <sashiko-outbox-229467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/iser: Fix deadlock during blocking connect
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziyu Zhang" <ziyuzhang201@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261123144440.65441-1-ziyuzhang201@gmail.com>
References: <20261123144440.65441-1-ziyuzhang201@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 15:02:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] IB/iser: double destroy of iscsi_endpoint and CMA race on
  connect_failure
- [High] IB/iser: blocking iser_connect() still hangs when connection
  fails
--

commit 25481c11c640d37ac59ae7c53e55d7c62c9a8e55
Author: Ziyu Zhang <ziyuzhang201@gmail.com>

IB/iser: Fix deadlock during blocking connect

This commit drops and reacquires iser_conn->state_mutex around
wait_for_completion_interruptible() in iser_connect() so the CMA handler
can acquire state_mutex and complete up_completion during a blocking
connect.

> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniban=
d/ulp/iser/iser_verbs.c
> index ab2a27d23478a..5d865b9bfc983 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -778,7 +778,9 @@ int iser_connect(struct iser_conn *iser_conn, struct =
sockaddr *src_addr,
>  	}
> =20
>  	if (!non_blocking) {
> +		mutex_unlock(&iser_conn->state_mutex);
>  		wait_for_completion_interruptible(&iser_conn->up_completion);
> +		mutex_lock(&iser_conn->state_mutex);

[Severity: High]
Does wait_for_completion_interruptible(&iser_conn->up_completion) still
hang when the connection attempt fails or is rejected?

up_completion is only completed in iser_connected_handler() on
RDMA_CM_EVENT_ESTABLISHED.  On address, route, or connect failure,
iser_connect_error() sets iser_conn->state =3D ISER_CONN_TERMINATING without
completing up_completion, leaving a blocking iser_connect() asleep until a
signal arrives while holding rx_queue_mutex in iscsi_if_rx().

(Note that if error paths complete up_completion, iscsi_iser_ep_poll() will
also need to check iser_conn->state =3D=3D ISER_CONN_UP when
wait_for_completion_interruptible_timeout() returns a positive value.)

> =20
>  		if (iser_conn->state !=3D ISER_CONN_UP) {
>  			err =3D  -EIO;

[Severity: High]
When wait_for_completion_interruptible() returns with iser_conn->state !=3D
ISER_CONN_UP, jumping to connect_failure leaves iser_conn->state as
ISER_CONN_PENDING or ISER_CONN_TERMINATING instead of setting
ISER_CONN_DOWN:

drivers/infiniband/ulp/iser/iser_verbs.c:iser_connect() {
    ...
addr_failure:
	iser_conn->state =3D ISER_CONN_DOWN;
connect_failure:
	mutex_unlock(&iser_conn->state_mutex);
	iser_conn_release(iser_conn);
	return err;
}

Does this cause iscsi_destroy_endpoint() to be called twice on the same
iscsi_endpoint?

Because iser_conn->state is not ISER_CONN_DOWN, iser_conn_release() calls
iscsi_destroy_endpoint(iser_conn->ep), and then iscsi_iser_ep_connect()
calls iscsi_destroy_endpoint(ep) a second time when iser_connect() returns
an error, causing a use-after-free and double free of ep.  In addition,
unlocking state_mutex at connect_failure while state is still
ISER_CONN_PENDING allows concurrent iser_cma_handler() callbacks to keep
running during teardown before iser_conn_release() reacquires state_mutex.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123144440.6544=
1-1-ziyuzhang201@gmail.com?part=3D1
