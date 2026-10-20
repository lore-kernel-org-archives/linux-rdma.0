Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792456329;
	b=ktuwl43lj5nADwWDFqVMFZiDfAquf4VBZiTujrTQrJOITcQ4G4vI0SpdmYQIYN1PRdwl
	 2aCzqGDx71HnqM4LtmmNjdpaXeYNXoVbswBm7wj/ct8sJdMR/WppuKuWd2HKEuZgE3NDW
	 SCQaUVR6kpF56IKJ5E5UINvMqnqjgsC6ord1P2CSeD9bZvvQGVHieNQMymyhZIn1nHV/e
	 EyIwLAD14DJaqe1oDbzo0dC+Os+UgNfw/C6DfZUhBJ+L9mpK6yDuZaOO/MdtadfBjC+iE
	 m8f9mUly5wrIE4ERAn3zFlCMtIgTHUKY11ckgAW5z3h8GDOwE1M84R3Z3kyf8+YBmhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792456329;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QJ8h/oVErMzM0vSYkQhGGuLaSUk++WV/immKq+7D79o=;
	b=XMHmWyHyzuu3bCl+Nzm9iGi540gZodoti4v7cWOlHQRbvu3Qx6n14+IFHn0R2UZ3DC26
	 Ko72cr7arqsVeR7PYAWs7rklGwMiJkQJr7kP8yCkzMDCtcwIwEAx5EE5aa6pr+J8zV/T/
	 fokjT2+hnVqCL5SrDXQcKVdAG8oDg6ygv4fLqx5CeTmdm52K1CfstUNN3IH9j42AKjdrc
	 TJ8+3R6TLJi129QywTdMZU+X8eftQrWqvMd7ALVFDQlL77r4i6oEsiNMGiZgO0+ffqh6q
	 PUurrmVRaISbU1Xx7Nmiq5Z6o6vlNIcXsr1zgXAcNV4HjK4iU6bcaqPk+y61kxdIv1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NkV+W5Dm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2AA606A31D
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NkV+W5Dm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8FC1F000C5;
	Tue, 20 Oct 2026 00:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456329;
	bh=QJ8h/oVErMzM0vSYkQhGGuLaSUk++WV/immKq+7D79o=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NkV+W5DmXFi4ej5rqbFMUtEJW7veOJq8KdX2CxtZByoJQfJBb/lvlAjAixT4+VwiT
	 lHJrcqL+sky2eSD/A1rZ0/bUoZfgL7C6jkQI0+7KIkmZCLCTW428z6WB6wLl0BlrvY
	 cSrycHA7kE2+XdARV2CDWRyqJ6qICeTm3T/AL2a36ZsCpEdUi/nckwBnUfTehTKTfr
	 DSzIh0HxWKWSf1qrAtzkAafv0/JSIkk/ceTwBx6IgeamFOcdClihvllVNfMHr/tzzb
	 vwJCwZkD1mlIE5rrjTSXuwbu23HUgz9oxHjqhlT4XuU8YkHGoTnlm+zfwInYgJlA5E
	 CHeX/ejGI13Hw==
Message-ID: <sashiko-outbox-178387@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 2/2] net/rds: keep the connected peer's
 scope id apart from the bound one
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261020002816.3087414-3-achender@kernel.org>
References: <20261020002816.3087414-1-achender@kernel.org>
 <20261020002816.3087414-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 00:32:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_connect() has nowhere to keep the scope of a link-local peer, so
> it stores it in rs_bound_scope_id, the scope of the socket's own
> bound address, for rds_bind() to check a later link-local bind
> against.  That field is then also what a send without a destination
> uses as the request's scope, what getpeername() and recvmsg() report
> as the peer's scope, and what a later bind() overwrites:
> rds_add_bound() stores the bound address's scope unconditionally,
> which for a non-link-local address is 0.
>=20
> So after connect(fe80::x%ifA) followed by bind(global), a send() with
> no destination asks for fe80::x with scope 0.  rds_conn_lookup() keys
> on the interface, so that finds or creates a connection with c_dev_if
> 0, which the TCP transport then tries to connect through
> sin6_scope_id 0 and tcp_v6_connect() rejects for a link-local peer:
> the connected socket's data is queued on a connection that can never
> [ ... ]
> observed in the field.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020002816.3087=
414-2-achender@kernel.org?part=3D2

