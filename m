Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76502212542;
	Fri, 14 Aug 2026 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786667158; cv=none; b=E480+nIvUXNfeLL05qOBoQNJUko0YLAAAXDt8wUbCesR0TsEw5EYyQmJ37d4MrzENLJTCz4sQo0IlgauZwbNbVOuHydUcOA4egWpke5GtUXvcgOc9s5vhDNV4KDr+/B/xV/96oUoCZmtZ9ct/AeQXER+wOcwEPrH25sH68qEgCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786667158; c=relaxed/simple;
	bh=cZJTzR5Hx4UWbn13RghLAesi2GnX5lu+4E0boHoADuc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b2H0k+ETJCf17Azo36H2RwCDkI4aEg8L/DM3HIYYYIbpMHUUi+DHiFOBOyyNA5TZeL8q/+JSnCwgPLtPGICg4EMxU27g4rIrzQYeOs0JC+/D7yU7HnX0zmwLhRfjS6sK/2ef0eVQDkoXPWHWTh4uGJkrMayt+jwuCOvBFv6yJCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hnw8c5kG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hnw8c5kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C1D1F000E9;
	Fri, 14 Aug 2026 00:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786667157;
	bh=fs+BbQHNUF2bHJQ9C/xxrrrUGFhEJCvZ6H+kP+H6GRw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Hnw8c5kGn+e8Vd+DITJgExRB5mA1qYvbnqXaPoZSTb7FV/lwnDWHEjWA4uYMQrqjc
	 vGp2JjdaOfcs7/B6S0UiTZWywhp2vhjv9USMZI1/JnpD0RD15rzoMXQg/uYSGSkfIF
	 hbpgf9zY8C0D6cQltWiqMDKJSBWGaW0m8d/iwhDYUxxAyibBOeB4THIBUCuftEBE+K
	 jB52VTh2dsftSl6/dmEJCfsdir3o+Sx+xu7wwMRvIb1S3/jsp6rvI3LYdWEZkzNWXP
	 qILs0P5UC7SkjQwrA2tpJrbclIEsVz7jt+bD6hrGhygCI5VNj+gR8txjEIy546rd8K
	 kMi/CMLQRmwNA==
Message-ID: <920ffe1984d3fe81ae3deb72129499444a99703f.camel@kernel.org>
Subject: Re: [PATCH net-next] net/rds: clear i_rx_lat_trace in
 rds_inc_path_init()
From: Allison Henderson <achender@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
 linux-rdma@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
 horms@kernel.org
Cc: jhubbard@nvidia.com, leon@kernel.org
Date: Thu, 13 Aug 2026 17:25:55 -0700
In-Reply-To: <a227ef96-9b2a-4f8f-9fac-c725eeb0e998@redhat.com>
References: <20260810055631.299558-1-achender@kernel.org>
	 <a227ef96-9b2a-4f8f-9fac-c725eeb0e998@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-13 at 12:50 +0200, Paolo Abeni wrote:
> On 8/10/26 7:56 AM, Allison Henderson wrote:
> > The commit that introduced the receive-path latency trace added the
> > clearing of inc->i_rx_lat_trace[] to rds_inc_init() only;
> > rds_inc_path_init() never got it.
> >=20
> > That asymmetry matters for the one caller that reuses memory:
> > rds_tcp_data_recv() carves its rds_tcp_incoming out of a kmem_cache
> > with no zeroing and no constructor, so after rds_inc_path_init() the
> > array still holds the timestamps of whatever message previously
> > occupied that slab object.  No stale value is user-visible today -
> > every message that reaches the socket happens to overwrite all four
> > slots (RX_HDR at allocation, RX_START when the header completes,
> > RX_END at delivery, RX_CMSG at recvmsg time) before
> > RDS_CMSG_RXPATH_LATENCY reads them back as deltas - but that is a
> > property of the current writers, not of the init contract, and a
> > future trace point or an early-exit path would expose another
> > message's timestamps to userspace.
> >=20
> > Clear the array in rds_inc_path_init() too, so both init helpers
> > leave the inc fully initialized.  memset is the form the clearing
> > already takes on the rds_inc_init() side since commit 1635bb548f84
> > ("net: rds: use memset to optimize the recv").  Hardening only; no
> > user-visible bug in the current code.
> >=20
> > Assisted-by: Claude-Code:claude-fable-5
> > Signed-off-by: Allison Henderson <achender@kernel.org>
> Mentioning this change in the previous series thread would have saved me
> a lot of time :(
>=20
> /P
>=20
Sorry about that!  You're right, the follow-up came out of the same
review pass as v2, and I should have replied to the series thread with
a pointer to it.  I'll be sure to cross-reference follow-ups like that
in the future.

Thank you for picking up all three!

Allison



