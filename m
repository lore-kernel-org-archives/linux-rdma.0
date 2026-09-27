Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AFC3B8934
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 06:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490757; cv=none; b=GEEGEDgw+IFgiDpgURMf++/P8sGRLbmEpfbucqeKcmiEyESvNQmQHYxJDMHiFzru0o1YHfklFQ1C8gRIoITyWzxmfoeA5Q47ZLob/0mEibPaB3QA+CVMCiBOb7HuNiIGcP2VV6q/PB+Ej3iWL6pDB/zJANDxX8dSnCqUzOQLqh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490757; c=relaxed/simple;
	bh=9eEJPKjj7ijyv4HH11mW13hqPJID7jQNw13nvL+Uqy4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S/eqfScRNP9YmEQ5B9AEI8JNH4vNY3gN++3UQiuurOQi1QYGhRX9dtHuVpcgxkmtT3IUSZ6iHTTT/7YI3bLoOet7Gfk7Q35SIs+QO2dER0lM9CAHO26qsuofNZb9FN97k4P2l/LsvpfFSR1PKtCDFO2JOfgHjsRw1wGy8B9/CW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sr3gKeaN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr3gKeaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FF41F000FF;
	Sun, 27 Sep 2026 06:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790490756;
	bh=LlOdZf8lxAHTqlC81+H7TkgoQ+8k4SIjNj6nVlVmoQU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sr3gKeaNu8SyOb4yCCmQlEdJj+MyJsO2t5Qq65IRaCwxv0eiOu+accMEhP+FNn8Sp
	 NikskQcFtA84r5ui9cbf9Ep6s+PaxZeMXUlfDgIk9JxDwKee4HUwX/UKbt3Ryj32Uu
	 5onIQPl2jlJdrLSXQyrKhAxwNuAL3PfuMe8dG2VIEYf/IrIariaDu9Vza50j7wF0Um
	 qulPT7sW+yAd9OyVFQNCyW6zcTRsAz/ChXSjPQoJvvR+XGD6yG7nrQkkHmnVILNfB+
	 Kz5sX8qkeMUckAeCWFdVVAfOf7XQCmObZiGzDtaDKImg+M7ID5L1vtcHmiti1pZ7p8
	 3UJ0f7AzSxddg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] net/rds: include the scope id in the sendmsg
 connection cache check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927062312.169097-1-achender@kernel.org>
References: <20260927062312.169097-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 06:32:35 +0000
Message-Id: <20260927063235.D4FF41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_sendmsg() reuses the connection cached in rs->rs_conn when its
> peer address and ToS match the request.  The interface index is part
> of a connection's identity as well: rds_conn_create_outgoing() passes
> the request's scope_id down as dev_if, and rds_conn_lookup() compares
> c_dev_if, so sends to the same link-local address through two
> interfaces are two different connections.  The cache-hit test never
> looked at it.
>=20
> A socket bound to a non-link-local address has rs_bound_scope_id 0,
> and the scope check at the top of rds_sendmsg() accepts any non-zero
> destination scope for such a socket.  So after a send to fe80::x%ifA,
> a send to fe80::x%ifB hits the cached ifA connection and the datagram
> leaves through ifA, to whichever peer answers to that address there.
>=20
> Compare c_dev_if with the request's scope_id in the cache test, so
> that such a send takes the lookup path and finds, or creates, the ifB
> connection.
>=20
> A request without a scope keeps matching the cached connection.  A
> send with a destination always carries one for a link-local peer, but
> a send without a destination takes rs_bound_scope_id, and a bind() to
> a non-link-local address after connect() to a link-local peer resets
> that to 0.  Such a send never named an interface, so the connection
> the socket last used is the one it means; making it miss the cache
> would send it to look up a connection with no interface, which cannot
> be established.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927062312.1690=
97-1-achender@kernel.org?part=3D1

