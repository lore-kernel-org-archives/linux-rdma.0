Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE3C33E355
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429795; cv=none; b=nARD1vsEYmtSNQL1UTIYRDJWLgMzj/pRqiSEKfVY58mAXrd+6aQJW49vASzTUCe5McHljohvGFx1IQjKhLXIuM6C34ag6XDPb8+Ujty1FL+F72FZhIe3vDomAvH9PJ4r7P2k+hdeDpn8pgz93EL9Jbweyhg5UgWTZ+wT1o8kezM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429795; c=relaxed/simple;
	bh=WX+F4ABAxf+uF4Si6dGzbkDhVMrYvx5aIApvBvhaGkI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JLZFNkW02/6QhJa/MuSbFGpvg9kGzbLPnDvadb4GLhi1ovK9AdKbTCpp8F3wVtVCUDIfZuq1IxNrwi0S7NfD0ZrcLWtOPUVusxfQTk1fj/LYrJrPInqwTzUWcwtgCDPnJmzO9zHLwyqWl1809S9oCpdP2bpGz9NpbM7Ic0LhQng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OY33fucs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OY33fucs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8F21F000FF;
	Thu,  8 Oct 2026 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791429794;
	bh=2j7jYtJRTZ/ZlOA86KBeON7U9ajQgxA4CuDiSB1V5JM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OY33fucsCms1uC/4aNGeRG4dSF5SGSSmq9FTT6qoi5tWUw+yIKXXMq1p40cWGSi2B
	 v83fCRYqay8xYbUr1FEDQHWO5+g2U536g3SehgXQUhQhAFWp/yIe/1fPiXNAXXULxn
	 bZYR+Rbzzx8FqQjDCR5awX7BCmiA+ONMkkWffCk13XGRywf3X9YPoPDoJnY3cS9jvI
	 gYaK2J9inxDbNcaGtTE5zDhm0xtFTwSYKC6tSbyH7VYNCEKYDveArXL3QY6jcFKh92
	 c3h6smXWfY4cg15sqd3OTZpLqGzHV+Q03zqOsRFSOhfNGq1/nVa2G5KTl0g7WehfPn
	 ctezk/4FFb5Sw==
Message-ID: <sashiko-outbox-163529@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v4 2/2] net/rds: include the scope id in the sendmsg
 connection cache check
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031426.1142344-3-achender@kernel.org>
References: <20261008031426.1142344-1-achender@kernel.org>
 <20261008031426.1142344-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:23:13 +0000
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

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031426.1142=
344-1-achender@kernel.org?part=3D2

