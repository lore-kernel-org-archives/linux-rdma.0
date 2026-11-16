Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821751;
	b=0jbjGd5rCrnBivg154/Jojx7pgXUzig+KL7zFnJ+5TraDXc7GoK43BgCEzSu3aeQltss
	 laRAYd7K07u7/R1KEx8VbFNqB9mk0uizfSQlmZY4Y8fflcUQs8jmDNuLYsxmCKena01tI
	 YcPGG5vSkrMj2pd4oJ4jlzzaLqfwDSrwcYWbm8lfEK94AySbcmiaytLgxpyA/fNFBljkC
	 QqSotS4DWE5H80KGQsKMt9ggieDNb1ewVBbFiPWKw63LYoARtUOhTYrXEG3DNAuwa8Izx
	 rEdudZOP3reYqwy5Azv/cmDSLnrEmnubC6UtMk0fwLKEB4e+0kixsi9qeKa6xzaPwLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821751;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wU5BlvOSWQHWuUD3CMofjN5+zYIYJJVIozjcDpM3rSc=;
	b=iSvUS+Iwlyx8FDVzg5Fsm9dFjQIqIs2bBWAxm9eXZMuQyicvuqya1wlRh73BGnwAiVHg
	 +SWKuXMD4VN6NdzhmONhAh4z0alEu3hueAqnjq7K0QWD5vM1np+/EVE+giAY5GMf9XYpR
	 gX9sU+uLy4ZoiefF7xn//ROdRnM5YDVSabKHXy5ZZmezCNO7RDI2p0HbgEYkfJd10Zdx6
	 789UdUdHoCRa1GtL3b5Ok/JQIiC2JUVw9vXRPln2quT2OhREr0XF9dYvqpHSyNAPIKMuH
	 nKswfh6SBF04qr/lPOT7rWYN3IPi7afuqdJ+TvCEUlBJL/mxYFkK3amYzC5yMJG9eSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0T4koTP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EE2606A899;
	Mon, 16 Nov 2026 09:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0T4koTP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9C11F00925;
	Mon, 16 Nov 2026 09:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794821751;
	bh=wU5BlvOSWQHWuUD3CMofjN5+zYIYJJVIozjcDpM3rSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T0T4koTPiY7e4mXjHYi8Pwge+tWwQZBGA40k18ZIfwNT9H7+AQNKwi0Iz1/RPpqKn
	 6rE+2LIlKuXmScZSULIODOa9rzqAOQZX6uSSr5Pu5sMZDKRVEoeqGFfENViz6j1kJ2
	 IpFUq8KQ1BYLXT1/4ok4ct0X7EUsa24NvkkhjgjevhthBiMZuq3BF0aoTxWuLgCBe8
	 6utJSjluND8pK7Y4SubYdJNKwB29yEP1O8qNC+UoHI3VQP8P38CAa2R99T+ZNIJRA+
	 XjtPNClOji8YqtKhKfyZynY4BXKuWxktTBo6qi3Nx2r+wgmL5aJu8gu6itVZ9oYpwY
	 75N4qNH87y/YA==
Date: Mon, 16 Nov 2026 11:35:48 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
	kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	davem@davemloft.net, andrew+netdev@lunn.ch, dtatulea@nvidia.com,
	moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 rdma-next 20/24] RDMA/mlx5: Clamp log_max_cq_sz shift
 in CQ size checks
Message-ID: <20261116093548.GE11319@unreal>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-21-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110134320.34408-21-yishaih@nvidia.com>

On Tue, Nov 10, 2026 at 03:43:16PM +0200, Yishai Hadas wrote:
> The CQ create and resize paths check the requested size against
> 1 << log_max_cq_sz. The cap is 8 bits wide, so an untrusted NIC can
> report 31 or more, which makes the shift undefined. A large limit also
> lets the rounded up CQ size exceed INT_MAX, and it is then truncated
> when passed on as an int.
> 
> Such a size also overflows the CQ buffer size, entries * cqe_size,
> which create_cq_user() and alloc_cq_frag_buf() compute as an int. A
> user CQ buffer smaller than the CQ the NIC is given then passes the
> umem size check, and a kernel CQ gets a zero-sized buffer that
> init_cq_frag_buf() writes to.
> 
> Take the limit from MLX5_CAP_GEN_LOGSZ_U64(), round up in 64 bits, and
> reject sizes above INT_MAX. Compute the buffer size with
> check_mul_overflow(), as resize_user() already does.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/cq.c | 52 ++++++++++++++++++++++++---------
>  1 file changed, 39 insertions(+), 13 deletions(-)

<...>

> +/*
> + * Next power of 2 above entries. It can be 2^32, which doesn't fit the
> + * unsigned long of roundup_pow_of_two() on 32-bit archs.

This is not correct. unsigned long in the kernel continue to be 64bits
even for 32bits archs.

Thanks

> + */
> +static u64 cq_roundup_entries(u64 entries)
> +{
> +	return 1ULL << fls64(entries);
> +}
> +
