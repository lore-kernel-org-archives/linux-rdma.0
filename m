Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4043F3769F4
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430338; cv=none; b=srfNQ9uwXYoY6kHo6qAtlO7+3OIY/MeSdzGUpVMNOZPz5Im/Pct+1nLZrC0WarwoGS51/l/WIVSyH+ruOAVpVdKPW9/hwZQrGqbw+EXVI417a51wODbgEKi3HanL6cdT85JigdsGZ0ptZbu2Jex8xv7MW+qX6sLhWFSEL12WEuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430338; c=relaxed/simple;
	bh=64IOf4NeMW96usz85geCvCswwLe7w0bXNac4GsAr8dg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jHo679Fc5H1z3cbOYev2KzCm1Ip2tl4IByVsxvMRsMEK5V3kTMuIGcx65D4L99NS3P0SHNeLQqn3Ac061Wkfb+ZsQB8Q7GI5AwzMU83RvNuiU5XaAeGK/p2tJmUm5ufRDk7lF09HykAHwsXzEkMeY2gzOH7aD//27DTMelnczO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYEApYpf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYEApYpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24371F00893;
	Thu,  8 Oct 2026 03:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430336;
	bh=jtF8PMiz7vKwDOXGabN0LEjzPW5Rx1oyzsEm3JVuR54=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GYEApYpfL+Ncsp3dbw9DchYTX5rtft9j/oEiBny87PaMN7g9dPeFmqvmU227OEBIZ
	 c3oYlHvzT4wMkqDxQNr+oFqMQCZ4XBvn3waHsmQaAVAWvKohfBP2SSUpjTtgUHLDzr
	 69JJgTYBkV8muOUYZR8vNKg8q1rlzhrdAvaG0+Iz+HhxKpBrCGmCdfLEIbvl3RRCv0
	 9vp7xdyEsAczkJJ1P3ds9OMdyQDs8pOi8BPbPlw8HSqVpWCbOoB0twRVfU3Tnw+Yvi
	 anTiRjrCQbdMk3yvegLQZ5wb+ITR5KbZFO5wpvQRMWkJlE9ogL2VU2yr6eBqqivKFq
	 q44o+2rz6kDwg==
Message-ID: <sashiko-outbox-163546@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 08/13] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-9-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-9-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:16 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending - once the following patches hand out references to lookups,
> sockets and incs - would execute transport module code after that
> module's text is gone.  At this point in the series the initial
> reference is the only one, so the wait only has work to do for IB,
> where it also catches the late arrivals described below; the
> guarantee becomes load-bearing with those patches.
>=20
> Count each transport's live connections in t_conn_count (incremented
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D8

