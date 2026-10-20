Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792456328;
	b=3vaTWf3iRdLGedB9gqolJmIvZAZxRkc9so601+Ed5OVJFfnrSCEHGch3nFIARAbgNEPg
	 TDNpg3TT4AnfVRG2E1Hzf//opyzRC3pd/Vjb1vacOKemcgHi9fD7Q4v0QMnzBjQ+krOlX
	 MeAZxl7MtiFsFJBFbZAuAiQIQYUBhT5SKARKriiiYFsbnmdSQDa5hiHedRplUurQ72CgL
	 85MRjk2RYi7D8gE0oM90NoTTsxOqREN25FVyQOH3eGw5Arq+SH24JxIBnJS/bpMUyB2pj
	 yxtBpEXzTunstmdXPZ33GXFLlF3Bb0bSFT17AuuhIUDqsM2q8bOBwFRrtokpAJzLBCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792456328;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CrW2kxDiqvezrFrbNEcWq5vbSl6RWAC/9EXQWYm+sCY=;
	b=iu2MM7zDnAqUhd7uHgN9G6LA0d/RrVtqhP+sUIJSLpZK9xE64gEQlkfkFjgQwAz+jhmV
	 fIw4NlLxgIc4H9DdY+R9wOQppgmvf5lh1JaoRXRS3hh1wT8KQEdwbzLgCnebXn4WN325w
	 9dlw4eumLUZlKM3uYdukJ9piAlM1QqhBUzexs02aN4YjI9BRV2cPcdPMA0nV0jAJTCQdt
	 QyTcX5+wAT2RSiF4yIIEW5nwwRx/hEpDlnXqgaIDhbBGy7M4ylwhk1k3nwh0NpNCdHD2L
	 KUNJNH+CsUgblvrp3IU40JJweaVpQe/LAu8VnNYxQJopdWvsH1MQlnpe3Zf/l1HR5lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acVxT87R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A154D606A319
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 00:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acVxT87R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351F21F000C4;
	Tue, 20 Oct 2026 00:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456328;
	bh=CrW2kxDiqvezrFrbNEcWq5vbSl6RWAC/9EXQWYm+sCY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=acVxT87R/cgjI0qsqZa2XCXGxzShUXDXRW0chbY4wlVI/pvOITqTo2lAWAaqBriUD
	 5curHoPUmjriiQewP/WfkJJW0GSWGZEbKypXh4uo6fTf2/Q11YWLxxWzurDnj8Aiku
	 uC9TpXjbhdkO7oykZ1eRLI1GYcS9BpXqv1uge66sRSNzqDyT7Q/rBzpvec53tNhELq
	 kRWYo+WHpSIaE5NWMwehWffqBGDSJreN/XOrk+YwR4bjAR3drM6ak3yT1aXzOs+h4M
	 aoG8ZDfUZ/UUqUNcZsaRqKzGsdAL9kIVN1QPlOpmlU+VA0zT3epVURQQzIEQzK3XRS
	 gUboabdSrYmcA==
Message-ID: <sashiko-outbox-178386@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 1/2] net/rds: include the scope id in the
 sendmsg connection cache check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261020002816.3087414-2-achender@kernel.org>
References: <20261020002816.3087414-1-achender@kernel.org>
 <20261020002816.3087414-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 00:32:07 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

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
> connection - the same key the lookup uses.  A send without a
> destination takes its scope from the socket, and the connection it
> created was keyed on that same scope, so the comparison holds for it
> too; the next patch gives that send the connected peer's own scope.
>=20
> Found by inspection while reworking this cache for the connection
> lifetime series on net-next; not observed in the field.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261020002816.3087=
414-2-achender@kernel.org?part=3D1

