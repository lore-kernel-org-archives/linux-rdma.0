Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506084;
	b=AnCna44+AhKmN8umEFvIph6UchKbDjXM0cGdICU5YLJ1o/t8ZZ2sa6y+LZr3SGRMq71e
	 aJD2irF4mGN6aG6jSl66tFgcRw6XTbgSdCsCWtLHDVrq1nQa/mTozxFzjksLE6MvltZ/w
	 tACnGMlZeOfs8q4Z/EHXuWInMb1et4Ekub8R9E1Tvy1XY8vYkuv3EnY5ZLAJp+uOy4CQ0
	 U/tj+hw5UoaoYb0qWBnJNhYR/By3+TRy/rAZQg0GSM1PwPLK7r+5fTd5JxC5OdaFRBYyH
	 LZ75znCl6k865nzWYHbr3vm1M2aeTHNsZv7V+D73QUX1o99vAeFuy8EPXoqChqO9mxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506084;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cGvJ8Tills6NF9wa7o203CIt71teZVf/kDT1QzVtUL0=;
	b=w2zgE9BnOJYVryz38t0NChI1dR+ETqlPLOYGiD0unSgZ9n0rdG2/R0d9HDNfczRpN0ob
	 Cl4v6gvuPAAC16zIFbtj4vQgkAxg1D1/M9/63lIAVDbFv4kyZV8in9qzpZC3K+fJ1AtGd
	 Yyr3qhbFto4gX323OP6YsTFyxbh2+KpHcHKDyWUxVketnt4RFccFOZHovslLSuz5hazIr
	 QFKDQp65zrFUA0Stgcl04NdPrZVXEFGKsuYXuc7WzxD64Ena2OyskeBt3OtQ0568tt7XU
	 4lMiaCawT45pZloBS/j9U3zWocTeCjQ62+MojCQVctaree2EaCzZ5OSrQkaZphnyEMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wa43p8p7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94F2606A32A;
	Tue, 24 Nov 2026 07:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wa43p8p7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DA81F000D3;
	Tue, 24 Nov 2026 07:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795506084;
	bh=cGvJ8Tills6NF9wa7o203CIt71teZVf/kDT1QzVtUL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wa43p8p7smu6rIkl+UrkDTLKI5Jd50zAYC4uphdznDaO8V+u0Y/PBihbr6D7kIj1K
	 Br3NNKZzWgV7GtzAC+51Fruc0izhOQdU0lDQP3ZR477HRyNE+IrnjHy/ZJYPo7PUqO
	 8+FXEbkIfoh/70MZN/cs/PvZigbdbdROqX5ENz5FCJf0mSU1Rtvlvm57iM+wWqJsGE
	 XMJekD3h/mAJu6AyMXWn77BMl2mZrIYPH8verM6QCacJRcGwVQ9pETCCMb7Al5w0l7
	 6KsZpa6AL8y16c25jrxX8wr0Ooyd8lum4d80MU4urt9mm0n/9QpRDhwGPoJEmMza+K
	 +zXei5iINv0LQ==
Message-ID: <sashiko-outbox-230657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/smc: serialize clcsock release against CDC
 receive path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qican Ma" <goonsomeway@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <179550535135.21127.16258389542236461283@gmail.com>
References: <179550535135.21127.16258389542236461283@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 07:41:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In smc_cdc_msg_recv_action(), receiving a close or senddone flag writes
> RCV_SHUTDOWN to smc->clcsock->sk->sk_shutdown while holding only
> bh_lock_sock(&smc->sk). Meanwhile __smc_release() drops the socket lock
> and calls smc_clcsock_release() (which clears smc->clcsock and calls
> sock_release() under clcsock_release_lock) before calling
> smc_conn_free(&smc->conn). Even on paths that call smc_conn_free() first,
> an in-flight SMC-R softirq that already looked up the connection in
> smc_cdc_rx_handler() can still enter smc_cdc_msg_recv() concurrently with
> smc_clcsock_release() and dereference or write through a freed clcsock.
>=20
> Free the SMC connection before releasing clcsock in __smc_release(),
> matching smc_close_active_abort() and smc_close_passive_work(). Because
> smc_conn_free() sets conn->freed =3D 1 while lock_sock(sk) is held and
> release_sock(sk) synchronizes on sk->sk_lock.slock before
> smc_clcsock_release() runs, checking !smc->conn.freed under
> bh_lock_sock(&smc->sk) in smc_cdc_msg_recv() guarantees that no CDC
> handler accesses smc->clcsock once smc_clcsock_release() can start.
>=20
> Found with an LLM-assisted code review tool and verified by inspection on
> v7.4-rc4 (b6a9fa34ce4). Build-tested only; not runtime-tested due to lack
> of an SMC-R/SMC-D setup.
>=20
> Fixes: b38d732477e4 ("smc: socket closing and linkgroup cleanup")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qican Ma <goonsomeway@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179550535135.21127.=
16258389542236461283@gmail.com?part=3D1
