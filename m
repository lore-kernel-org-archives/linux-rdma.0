Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792609827;
	b=jJx1tkYAL8oTbrHEj/4FApntHhUc9lA0Xtelqmrqi73uVEPf8Ha/4MkysXquBECz0JeX
	 Tqg3BePDjzUhp9TY20Cm1rKfuZvcmIollwput9yOzwiLHJEZztKDQX8OOg2z+t8fKEmto
	 3OzLeUOIq7vrWlahgUgG4bSw7jyjARzePC/Rs0MGISP8r1auaJ9iJ6E/zDdT/NUG6zmwR
	 nBUWTb4ThTEvgh0naqblzvSq37qByKE68VmTV+l7cqoWzOjRT78ayNkj7IZxcjkNNz84/
	 n2rZFBQ9eYLk3PnK9kc9ASo+0vRiw4BdfZ+0FMVb5tUXMVsK0eNw9Xuvl2vpIyy4Dcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792609827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=y9dMWwPZHkR8GrsKR89BPmqqiEWw72wgPYPBzD9JJ9U=;
	b=W3hvJdxtxIYkgbnROk69PbLMDK826QKGkgfYm+QQPvdUZM1PfQm5jBpoPKnfoxfjW6l8
	 +YUprfLTu4hWUuO1+G/HRRHK+6rvf4fD33bj+4R2+TeOfU7SZV+MpgdGzU0qb9Q8kPb2K
	 RVmgiscMWbdyIs4elz0nj8YRaWV+x4Q0xxo8bonwykuNbLO2l19Gi+agUMs2b/ipYqTGc
	 sutxpjpTH/2wGPw+if28hyPAw210EvLi+Fn0cF3fibBJ3Dx5CWlpC9X4zS9FkR4z8cLlr
	 siDeo9eYo+/Xb3Mhs/vA5qo8uoabj0+GL/Fn1CnX2ofS+7Olaw81U7d8tFSS7+ce/ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oXBNe13O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A6606A319;
	Wed, 21 Oct 2026 19:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oXBNe13O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82121F000C1;
	Wed, 21 Oct 2026 19:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792609826;
	bh=y9dMWwPZHkR8GrsKR89BPmqqiEWw72wgPYPBzD9JJ9U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=oXBNe13Ol5KzhB16HiGxDnbxkLHm0gbPn8FRd/wvGdvCu2mppoI+c+8OLMQ5bC/zu
	 RhvJsqP/HB9AYOd/P2wkByxeDQxSNbStfO11SDn687fKxMgvK3X5TXRpiYt9Z3iBUy
	 d0ZpjCIRKb1p0nW490FIhStWFtFNOpr2Z2jUkBFr83eJAK3kLxa2HJTRLW/cQSr3W+
	 sciUt0hdQA+m3G+5oEoJkrSXDiDRNuFH0fxh6vAWLNiJmk5hMZ/+RXbpXbSOXrOAIS
	 1Gqq/lJeNMEepBWLLiKh0dlj02EpOdDBBE5GYUeGXRNVNlCbX3/l/Lk+rYpQmf9iWe
	 +wPzoMq+u4d4w==
From: =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon
 Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Josef Bacik
 <josef@toxicpanda.com>
Subject: Re: [PATCH net] net/mlx5e: Fix stalled channels with threaded NAPI
In-Reply-To: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
References: <20261021-b4-mlx5e-threaded-napi-stall-v1-1-d719c17b3ec4@toxicpanda.com>
Date: Wed, 21 Oct 2026 21:10:23 +0200
Message-ID: <87h5ie7tuo.fsf@all.your.base.are.belong.to.us>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Josef Bacik <josef@toxicpanda.com> writes:

> With threaded NAPI an mlx5e channel can stop receiving when a burst of
> traffic ends. It stays dead for minutes on an idle machine, while the
> connections hashed to it time out.
>
> When mlx5e_napi_poll() has more to do, it checks that it runs on a CPU of
> its interrupt's affinity mask. If it does not, it takes the affinity to
> have been changed: it completes the NAPI after at most budget - 1 packets
> and arms the CQs, so that the next interrupt moves the poll to the new CP=
U.
>
> A NAPI thread runs wherever the scheduler puts it, so with threaded NAPI a
> busy queue takes this path at nearly every poll. That costs an interrupt
> for every 64 packets. Worse, it counts on an interrupt for the CQEs that
> are still in the CQ when it is armed, and none comes: the next event is
> raised by the next new completion. While packets keep arriving this goes
> unnoticed. When a flood stops, what is in the CQ stays there, and is work=
ed
> off one poll of 64 packets per new arrival. If the RQ has run dry as well,
> arrivals are dropped (rx_out_of_buffer) and bring no completion either.
>
> Seen on a 50 Gbit/s port (firmware 22.47.1088) with 63 channels, threaded
> NAPI and rx-usecs 64: a CPU-bound task bound to each of the 128 CPUs and
> 32 Gbit/s of UDP in 8 flows for 7 seconds, then both stopped. After the
> second round one channel had 0 polls and 0 events for 150 seconds on an
> idle machine, while TCP connections hashed to it timed out and
> rx_out_of_buffer counted their SYNs. Later arrivals took it 16 polls and
> 1018 packets further, it stood still again for 14 seconds, and another 93
> polls and 5917 packets emptied it. In a longer test 22 of 48 iperf3 runs
> failed with "unable to connect stream: Connection timed out", with no ping
> to the same address lost.
>
> i40e and iavf force an interrupt at this point, and mlx5e does for XSK.
> Doing that here would cure the stall and keep the interrupt per 64 packet=
s.
>
> Fix by going on polling when the NAPI is threaded. With that, 8 of 8
> rounds leave every channel alive, ch_aff_change stays 0, rx_out_of_buffer
> does not move once the flood is over, none of the 48 runs fails, and the
> interrupts taken during the flood halve.
>
> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support=
")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> I hit this while comparing threaded NAPI with softirq on two bare metal
> machines.  The runs in the changelog are from a 7.3-rc5 based kernel, with
> and without this change.  The patch applies to net unchanged, there I've
> only compiled it.
>
> I don't have the PRM, so "arming the CQ raises no event for the CQEs that
> are already there" is what the counters showed and not something I checked
> against the documentation.
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en_txrx.c
> index 185105606469..3142e90e68ce 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> @@ -207,7 +207,14 @@ int mlx5e_napi_poll(struct napi_struct *napi, int bu=
dget)
>  				rq);
>=20=20
>  	if (busy) {
> -		if (likely(mlx5e_channel_no_affinity_change(c))) {
> +		/* A NAPI thread runs where the scheduler puts it, which says
> +		 * nothing about the affinity of the interrupt. Completing here
> +		 * would leave the CQEs that are pending to the next interrupt,
> +		 * and arming the CQs raises none for those, only for a new
> +		 * completion.
> +		 */
> +		if (likely(mlx5e_channel_no_affinity_change(c)) ||
> +		    test_bit(NAPI_STATE_THREADED, &napi->state)) {

Interesting. I wonder if more drivers hit this -- I think I've seen
similar affinity checks elsewhere.

I'd move this into a helper to hide these NAPI details. Regardless,

Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
