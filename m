Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795265170;
	b=mtr182i+tVVRIH8+iLVFz6v9wWYYMC75TL8XvS6+44p8zNFviJEfaiH9lU8w7x2vXVCD
	 Co6xdq03fw+IcQNT0cNbbwmpf7jcs3mHW6WCNswuvi+N1r5YU3SdhP+ZawSCGj5rh8Lqn
	 MSzpmQKJdCm4UAteyc2y62VTVGJhxD7stPAJY0+VgjiQOrjTFyimYgB9nYh7UrgFFR1C3
	 Cr5cc4KHpbgzBNWRmcJ6GhbwtXcr4LaoRclB36xBXQ5Jdh7ucAp2nYwnRoLAzahcv7aTO
	 MqiF06Qez0BWGPWU56D8pVC8LyXubX613d8ty20bcHsrkUh+ckqp9l6mPbkydVokisQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795265170;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kV6fgn3egiS+T6v8CpnN3S7WL/nGN1MUFqZmcsz/PmI=;
	b=u1vMjHoSjZUu0mk2i4iWuykm/n5eqVQGNnss6YRNBq1+1Fsr30Mmj5I4OvNeRl9Cz3uI
	 JJAWtPqw61BQazvp5HbZ3wzhg/AYnmyHLo6DMm5PEANOW3iH9iuuUnBHhUgSomvkpbtQd
	 k+FJWuJfNfSppsauHxVDCNCL7PT2OAtZGxZZ7XRw3BOjVm1GuPdOXySck7+4U5D8OViwn
	 5hNslmTiRreJrtBbvZSMKNS3TAPMGQ9uArpkd4tY9KUzayLjiudrhSixA2pmETdcW8E/A
	 +yaCoQeBFZ6bRIIhdOEUiAH4+IKFy6yZ7f9tHEYjv+9YRNucPpiemkE/tTKBxbk8iaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YiIoGbKJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88E7606A320;
	Sat, 21 Nov 2026 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YiIoGbKJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2851B1F000C0;
	Sat, 21 Nov 2026 12:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795265170;
	bh=kV6fgn3egiS+T6v8CpnN3S7WL/nGN1MUFqZmcsz/PmI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YiIoGbKJ+w920pyhzfa90iaNvMFp5Ut3pQqT5sWEXpeAhR1FkqVjNEARS9Q3SUM9w
	 mXjtdZJDcWA48UV6Our1A5TT/+ZS2htx7Rrbfy72/v4gaViaX1b5cPCMRw78M3zQJr
	 O7VCWtQVoiydYK/1moOTlbRbL30CdLM9Crum+iKgSNI5jXpCleODsnonK3NhIEog9B
	 eG5ziWGuQUh4CrbYksoSjehTAkTOzHKfDQJ7KEty5Ov+y3/yVctx0EG6WZ3qu5ySl0
	 bMuomFY7n1OmMjv8r2RQ7jvpKeVD1Mrhu4TSZ3aJwK6yiYNAN7Xg3EWbMY0laDonWm
	 ahmi5BpXpyRlQ==
Message-ID: <sashiko-outbox-227019@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/3] net/smc: remove the clcsock release lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261120124534.430200-3-mjambigi@linux.ibm.com>
References: <20261120124534.430200-1-mjambigi@linux.ibm.com>
 <20261120124534.430200-3-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 12:46:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] net/smc: socket reference leak in smc_conn_free() and
  smc_clcsock_release() [1]
--

commit 6864a40c043f192c54d4d3afdd20c8aa7e2a7d49
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

net/smc: remove the clcsock release lock

This commit removes smc->clcsock_release_lock and the associated NULL
checks on smc->clcsock, relying instead on the socket lock during accept
and work flushing during clcsock teardown.

> diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
> index cf1add1ffda62..e71245dbb2960 100644
> --- a/net/smc/smc_close.c
> +++ b/net/smc/smc_close.c
> @@ -27,13 +27,13 @@ void smc_clcsock_release(struct smc_sock *smc)
> =20
>  	if (smc->listen_smc && current_work() !=3D &smc->smc_listen_work)
>  		cancel_work_sync(&smc->smc_listen_work);

[Severity: High]
This problem wasn't introduced by this patch, but can ignoring the return
value of cancel_work_sync() here and in smc_conn_free() leak socket
references [1]?

When smc_tcp_listen_work() queues smc->smc_listen_work, it takes
references on both the listener and child sockets that the work handler
is responsible for dropping:

net/smc/af_smc.c:smc_tcp_listen_work() {
	...
	while (lsk->sk_state =3D=3D SMC_LISTEN) {
		...
		sock_hold(lsk); /* sock_put in smc_listen_work */
		INIT_WORK(&new_smc->smc_listen_work, smc_listen_work);
		...
		sock_hold(&new_smc->sk); /* sock_put in passive closing */
		if (!schedule_work(&new_smc->smc_listen_work))
			sock_put(&new_smc->sk);
	}
}

If smc_clcsock_release() cancels smc_listen_work before it runs,
cancel_work_sync() returns true and those references are never released,
leaking the SMC socket structures.  Similarly, smc_cdc_msg_validate()
calls sock_hold(&smc->sk) before scheduling conn->abort_work, and
smc_conn_free() ignores the return value of
cancel_work_sync(&conn->abort_work), leaking smc->sk when the abort work
is cancelled while pending.

[1] https://sashiko.dev/#/bug/linux-6e05f850-6f03-40a8-8a7b-254bd11242da

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120124534.4302=
00-1-mjambigi@linux.ibm.com?part=3D2
