Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A4923643F
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791131741; cv=none; b=WcWgeQEUYayH+WH9uQAGGbkZE9zgl6SOWlNj4rov0PNswkCOixJqU1iMX0lTQWvwVWMIz2rp8heDyngIGctCRsP3vf6daOnH7HZAt0QbjkGgfEDnL3z6ZC5sYJNH6HBzPUhrtixwvurr15PG9soAXYtUXsU5u3JeYpArH0aeiCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791131741; c=relaxed/simple;
	bh=EXL2E8qsXRD9bFgR76fG69HD9oh9SohaI6eB0FtSga0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g2sN09vHCiqvjvdlj/Y1BfxWFXBK0kmgg8s/GodFgqNBYJQMuSPgWOmX00xLqy+HjHYcgmxeQidngdGKExVDzoKluEAXVfUWhDOkkp8LweA/SYlbaeZtdXh2NPJznb4MHacfBzY5UHqemdwxlwdm8KV4ccZPZRidOA/g93jyMWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gvYkfywd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvYkfywd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128BB1F00893;
	Sun,  4 Oct 2026 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791131740;
	bh=p5axOCzBeLZ6IB16xJ2wiEq+2u3D0vacNjK2od9IgYA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gvYkfywdiqJjSPr/ASmCZwj6JtMg9pOfm4lj+5xLgJclrkDiXtpO0ixJaZU3d/OsI
	 KnsasQOOh+kDLB6ABARrwcalxwdE2xM4W15lik9duCQnyPbcaerIhjT5olwG9WKbj4
	 tWua3sX/rwxY6Hqu3V3DRR2t6XkcCqNmkxaYFME7ONPNws+Ga5lN9g4fVSCNAAITSD
	 1MrmNmJKcQY4B1FckzF2tqgX+3dLsdCkebFrPnJ37RW9Qb29B+tbydZgn1/hsQNyAM
	 vbS74LW5axMV29/cLlW0WmDCU6MT0YKGgpFf1t1f9CpVzv416KBABp543embgP85F0
	 7NeWmBIWxRM5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3 2/2] net/rds: include the scope id in the sendmsg
 connection cache check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003163526.250805-3-achender@kernel.org>
References: <20261003163526.250805-1-achender@kernel.org>
 <20261003163526.250805-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 04 Oct 2026 16:35:39 +0000
Message-Id: <20261004163540.128BB1F00893@smtp.kernel.org>
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
> send without a destination carries the connected peer's scope, so the
> comparison is exact for it too.
>=20
> Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003163526.2508=
05-1-achender@kernel.org?part=3D2

