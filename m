Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D352165EA;
	Sun, 16 Aug 2026 00:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786839760; cv=none; b=s+NXVbqX4BEK4SucSH9q9k0P/f2MsS/8tY6yj6GR41XgZ/751230g2KxaoDvcqePIdH2Pb/iT1qKVUJ6LqOEJaUOvxqE3tPJJUZ3ogW2yiBmy6XgVy7K5Ka2czEyoq4RqoR+nZV+O5Md0KXC+RCqoOpXUTj9JVDymLvFev3RIy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786839760; c=relaxed/simple;
	bh=zKlCQYWcHdjbuyCBXwCynd9auFturLdU6X9Doa3TAhc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LFiUceMVeE1OltqlJ6gzcswsgQ0Y17sO67SASNjep/0jDmZvh2CP2mOM3MIjmEfXKt3WaJmItgqR0iqRD5pv22lYpqCJDt+BQ1TwnYfPAtuGYdroanXLui2cfmMrqq5uk4qoSlW3aAIiZXbrOWvl7zCNmXkaza0ilXuKXr23K0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpE8PLgu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpE8PLgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C021F000E9;
	Sun, 16 Aug 2026 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786839759;
	bh=XJa/UyXEtTw7MLmpkX5R4VUXV2/F/vFnBbQsA6jM2Ks=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IpE8PLguzhrs+Z67NVY0OAGBJ3R9OAtAyFhwoc+X4IkmbORCSMyN4Wy9s1UWs9raT
	 t8iS4jZrQ/f4qmbMHlou7QbasPqm+T0QwLUUwaLnaC01vrMsKV+w33Q/jJB8IxbA2O
	 cPFO/aahZYH0SFUINgTsBI//4zAoNhUgy+1q7aRa4YrBe70e0VqBqa0Dye+ZeC+QFf
	 +VS9slw/0QMBhN4f1nftDAAiZSGtj2hUkt/n0F1QGkiR/zHGPR3GiXuak+TiP9P/4v
	 AwUQ96ScByEJrXLW/aqMj0Q0os4xIam7y6I0yXgtAlqs2BvAOXBd4NrRKBklNh+mpt
	 eZQVxjBy6RweQ==
Message-ID: <42f28ec71c23639f900213f4f654d0a6556ef8dd.camel@kernel.org>
Subject: Re: [PATCH net-next 0/4] net/rds: own the fastpath locks across
 connection teardown
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, kuba@kernel.org, horms@kernel.org
Cc: jhubbard@nvidia.com, leon@kernel.org
Date: Sat, 15 Aug 2026 17:22:38 -0700
In-Reply-To: <20260814013501.43760-1-achender@kernel.org>
References: <20260814013501.43760-1-achender@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-13 at 18:34 -0700, Allison Henderson wrote:
> Hi all,
>=20
> This is a follow-up set to the recent "net/rds: Bug fix ports, part 2"
> series [1]. During review of v1, the later half of the set needed more
> work than just a respin, so it was split off into a separate set here
> along with a few other companion fixes identified in the reivew.
>=20
> RDS connection teardown quiesces the transmit and receive-refill fast
> paths by waiting for the RDS_IN_XMIT/RDS_RECV_REFILL bits to be
> sampled clear.  Sampling a bit clear is not owning it: the fast path
> can re-take its bit right after the wait returns and then run
> concurrently with the transport shutdown and the send-state reset.
> Oracle UEK closed this by making teardown acquire the bits as locks
> ("rds: Make sure transmit path and connection tear-down does not run
> concurrently"); patches 3 and 4 do the same for the two
> rds_send_path_reset() call sites upstream.  These pacthes are
> effectively v2 of patches 3 and 4 from the aforementioned
> "net/rds: Bug fix ports, part 2" [1] set.
>=20
> Making teardown block on the bits as locks promotes two latent
> ordering bugs from rare to load-bearing, so they are fixed first:
>=20
>   Patch 1: release_in_xmit() checks waitqueue_active() after
>   clear_bit_unlock(), which does not order that read; the wake-up of
>   the (now uninterruptible, untimed) teardown wait can be lost.  Use
>   wq_has_sleeper().
>=20
>   Patch 2: rds_conn_path_reset() wipes the whole cp_flags word with a
>   plain store.  Once teardown owns bits in that word across the
>   reset, a blanket store would end lock ownership early - and it
>   already races atomic RMWs on the same word today.  Clear the bits
>   the reset is responsible for individually, as Oracle UEK also does.
>=20
> With those in place, patch 3 has rds_conn_shutdown() hold both bit
> locks across the transport shutdown and path reset, and patch 4
> converts rds_tcp_reset_callbacks() from waiting on RDS_IN_XMIT to
> acquiring it, which also serializes the duelling-SYN accept path
> against a concurrent teardown of the same path (the old code could
> resume with a socket pointer the teardown had already released).
>=20
> [PATCH net-next 1/4] net/rds: use wq_has_sleeper() in release_in_xmit()
>   Restore full barrier before wake-up checks in release_in_xmit()
>=20
> [PATCH net-next 2/4] net/rds: clear cp_flags bits individually in rds_con=
n_path_reset()
>   Partial port of commit d04896037223 ("net/rds: Preserve essential conne=
ction state flags")
>   https://github.com/oracle/linux-uek/commit/d04896037223
>=20
> [PATCH net 3/4] net/rds: acquire the fastpath locks in rds_conn_shutdown(=
)
>   Port commit 2b8aaa4f163b ("rds: Make sure transmit path and connection =
tear-down does not run concurrently")
>   https://github.com/oracle/linux-uek/commit/2b8aaa4f163b=20
>=20
> [PATCH net 4/4] net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
>   Extend the last port to cover extra call sites in rds_tcp_reset_callbac=
ks()
>=20
> Questions and comments appreciated!
>=20
> Thanks,
> Allison

Sent v2 to address sashiko complaints
https://lore.kernel.org/all/20260816001510.73645-1-achender@kernel.org

>=20
> [1] https://lore.kernel.org/netdev/20260806072045.1092968-1-achender@kern=
el.org/
>=20
> Allison Henderson (3):
>   net/rds: use wq_has_sleeper() in release_in_xmit()
>   net/rds: clear cp_flags bits individually in rds_conn_path_reset()
>   net/rds: acquire RDS_IN_XMIT in rds_tcp_reset_callbacks()
>=20
> H=C3=A5kon Bugge (1):
>   net/rds: acquire the fastpath locks in rds_conn_shutdown()
>=20
>  net/rds/connection.c | 32 +++++++++++++++++++++++++---
>  net/rds/send.c       | 12 ++++++++---
>  net/rds/tcp.c        | 50 +++++++++++++++++++++++++++-----------------
>  3 files changed, 69 insertions(+), 25 deletions(-)
>=20
>=20
> base-commit: 3da8c3c8b8fa99505624b65ef590482f48e766b6

