Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8544137F30C
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 03:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792207777; cv=none; b=hqDOAXHKAhh+UM7TcDstUNGb/DisBamxYhfiKmwkdmSKSAkZfaJUWQPxf8QGRakW8zZ01e0hTXvyvZlwV6KD4UHTOELhzsNFBc5+gNuUGQ/y27Q/qWHWQN1U4YfE+cJDESnLzZuiF4MacxfTCZf8uJ3lmASF9PkCdYBb0CSirkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792207777; c=relaxed/simple;
	bh=2b3wYtFJFTdTUIt1iB9cnF6Bc6fgtRjiwkSSKc++JFQ=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=XcYe70WobTzYEFt7Dmq89rL8Zc7bkv5QjOxYibp1S6NjHdrvEaONz6k4WMnV1yTnY+JQw44ir9uE/MEM7lXS4LzzJTEfJ4Xt5PykTWUWLLb11F2o9ghFgfbdFxX3UWkd7CdHJa0o2WI5BXgqQ6JSxgUPiB9Hn6h3mw6jAkJIUG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3zS2s/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3zS2s/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DEE1F000C6;
	Sat, 17 Oct 2026 03:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792207776;
	bh=yx2OSCuuo1Q9X+a7AT4p4Udagsc1c7FJLNPSABOredo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=C3zS2s/MK/sAn2tqkbaT+dDCsvyMFX1R3DK2kVKJuOwxuVNtMt1PkK44mjr6LRnXi
	 G4zKQELjKToAT14y8qGEU97G0AIl0i9xGxrSXDVbRglGZzuHFijWPzrZAJBRXO/K7t
	 pbrsleJopUcWrFi48Sn0+4O++X4667R3KvT98LpFvDA4RifOaY8gihPqJ64s9tt82N
	 DAEDdcVFNnc065iKjFZeNLOcuzVXBl7HggkiOA4itUsGjbvSSfEX9eFqTt5RhqdG+6
	 gvA56NgcqRPMD6x3NyMkB/Hind9apJBwfBux5UKi/LCdY/6pHkFGsNvlgKsIzL340g
	 U0bGfrjjh4Ymg==
Message-ID: <sashiko-outbox-175249@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 2/2] net/rds: include the scope id in the
 sendmsg connection cache check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261017032358.2563121-3-achender@kernel.org>
References: <20261017032358.2563121-1-achender@kernel.org>
 <20261017032358.2563121-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 03:29:36 +0000
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
> connection - the same key the lookup uses.  With the previous patch a
> send without a destination carries the connected peer's scope, or the
> bound scope for a non-link-local peer, which is what an explicit send
> to that peer computes, so the comparison is exact for it too.
>=20
> Found by inspection while reworking this cache for the connection
> lifetime series on net-next; not observed in the field.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017032358.2563=
121-1-achender@kernel.org?part=3D2

