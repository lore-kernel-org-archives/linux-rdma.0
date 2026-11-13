Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546312;
	b=g/2GIqNRqlAcV2mUEL62Aq2L8fA14Ri/QeR5Uz4QpfZYPg00rKIQY4n0uqsAtMHTq4cy
	 Paod8YwZXsXhw62owv+7h485NGU5psqoLabR+HKXkwQH4V7RVwt5gwhYKUuZeTLoOL6nQ
	 rkVUkzpzyv6ye3iScPeuM1yWMZ7OwYuJ8rQPNKZPbGn9i0Yse1fbIZjkILFL+3YUSBUpH
	 6+DlqW7XXSslqYw4T9q0CHgGZm7HyEROyqQo3zzL7GMr69YUUm3V+WMwaCY/d5bcTdFwQ
	 ydwPkXhc+Ce137Bfxq9xtt1xt9nEOp/ULzo5BM6BzcfPRr7RZGhTtsM9n4YQ98xvOmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=J88UePbA3wa8F5l8ERYmVfwaqcJV62N6x2Mtjs+aGUo=;
	b=TmcBggUIXQOWReUlDdrFavk+mefsJvZ633tkt/AfSi9C0Zv8CkbppKqs5/4ioHWR7qIV
	 BS+3bGX4LqOWdTojhW1yTdVmog7mbt6RwAj8vvjGhi3zab1QngG5NLRxCkHebGBIfuHyZ
	 fSuRaUuCM4cS4/PbCj0+e9Oo3WA0Y+rKi03WJFocfCJWMLB8vNfBAew1aSjCSPkDbLxci
	 dg+KwfcxLxcDEuOo+3GK7/vqo2MeLpfPpdSkXuG1oJTGycZvCWQsrWN2uAl0mR8JZku4X
	 kugSgwNmVVpmGF5Zve4diZhjOCU24mRGCQ+2RZFbjsKP1s18WWfX6KLpdgOUI4lAelQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="h/JNoNLS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06E2606A332
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/JNoNLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB6A1F000C5;
	Fri, 13 Nov 2026 05:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546312;
	bh=J88UePbA3wa8F5l8ERYmVfwaqcJV62N6x2Mtjs+aGUo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=h/JNoNLSnI4479or0phY+L7ArmwI3gi+Zk65CDvmh/orN6OVWwi0MlqirOrB61W0q
	 PPTvJgJmdakLA0xs14GF33kPxieTxctlJk8Yl35ghkw1enQGb6jok4hvWipnA2bmiX
	 bmm2Poj3V/I3S7XwZxl7lFLRlGNeHyARzf217/qQABFPmsD8DvChu14GIvmtIuKiiV
	 uiiyLY8uOsp1TasOE+5DqWLInR/LYQqUhAczoHCCQW1rVbh2rqAQHsemwdIh/+5hyi
	 MYzqXcI34gjtxr1+hbXpo2ZV+jHHIiKEuv29OGQItSB5Tw90o5nUF+jRRVkDuIyDu7
	 H4+cHA0F9DHdA==
Message-ID: <sashiko-outbox-212192@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 03/12] net/rds: guard every work-requeueing
 site with rds_destroy_pending()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-4-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-4-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  The sites that can re-arm those works are
> supposed to test rds_destroy_pending() under rcu_read_lock() first,
> paired with the synchronize_rcu() in the destroy path, so that no new
> work can be queued once the cancellation has begun.
>=20
> Five arming sites never got that guard:
>=20
>   - rds_ib_send_cqe_handler() and rds_ib_send_add_credits() re-arm
>     cp_send_w when a send completion or a credit update clears
>     RDS_LL_SEND_FULL,
>   - rds_ib_recv_refill() re-arms cp_recv_w when the recv ring runs
>     low,
>   - rds_tcp_accept_one() kicks cp_recv_w on the freshly accepted
>     socket, and
> [ ... ]
> module unload cases; the following patch extends it to the destroy of a
> single connection.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D3

