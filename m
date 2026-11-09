Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243488;
	b=klmbDOG6Bw0sacseETxReSu6+1Mu4qSryFGqaqOzAFessMbxcZwaTRGbA2iTuP0ges+y
	 ZI//faGiPjpIMtU65accHdf05Gc3ZCif9ldGnPdMlvjUHjSw+lloEwSQ6AMEXTi12kA01
	 e4xLzeyA1tFSx1EVsxPupupypprgMKtdsg6BEFGBRZKe4hkFGW72Dfsw/X/aRZNIz6Xjw
	 P7TadR1FJN/k1DRDUzMNb4fvUPwWrGDGRVU67+O4cBgt0ovU2VCLWlcUIauR+lNfk/eDm
	 WmLU9OauiyxXtKTE2RvI8bi/AXS2Ml3Y6DYgPgcpe4pzVl9AssrQSNyJsDHL6CxlwBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243488;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=M+TeyOZEDIkWPVUVs00lBg1GLoZC6RDP3McPSF76HZ8=;
	b=w2nncXYFqP9qrPxPpqruySJJxVIydWsnHGNkVHoPExbbY6/GELag0o5STZREdAHq0EhB
	 fI7GtXcO0dfn7SwLeWAiIf91EyKRWr6IWoPuxWSsIX2Ufe7bQaIkikdHcd3qk+oJ/REZY
	 TUPXugesupIVkHBQLT205277AWmYejKLBQaAO1FVg4G9/7Ai4vQHohL68wIbuNLIZ06by
	 OPWqUwZkliqd1cBb3IpfYS6y/ehyjOWPEZWwMA8y/YsbOQTxIIhZ4f8+hGjNuYeZukcaZ
	 XgLhfRoCPMsIW4LGfb2koUhIcPV1a1B8WQUh5e4FUBhSDh/YkOd4Jer2Y8G+GsjF0ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fwn7kanm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97E0606A339;
	Mon,  9 Nov 2026 16:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fwn7kanm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3341F008A4;
	Mon,  9 Nov 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243487;
	bh=M+TeyOZEDIkWPVUVs00lBg1GLoZC6RDP3McPSF76HZ8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Fwn7kanmqTK3zwaC01D/D+JPKbWz1L2OCBS0biaHmJmFlAJHKjdfofmlceQ1wOb5Q
	 TUjTVWlTlM+VXaDBhJ3myhEGBXpSayUtECXK95jAoA7RHth8La3vb1ZE+3Ecg/VPwY
	 FggvorewlUCxnhe92UAFe2rP1f6NWA8iuWN4nR1jwM1vkJwesJmdDXUxhrQoa9I6+1
	 mgKCNdeNSgY/uT2OTkRFMhriv3BVzfuSPx7G+SvvffVjZwJ48+QEfiE1L6t7Ouy3kj
	 wO3samOV8qxDMUjLgNWmQdmiOW00bl3+RHGvyELEOt62MrWclPMr1ulAnY0MuSwXGC
	 Ao58X9CF6I+ew==
Message-ID: <452bd8cbadba19ce86cdce4c339dadb0d977209b.camel@kernel.org>
Subject: Re: [PATCH net v2] net/rds: Do not unpin a page after a failed
 atomic pin
From: Allison Henderson <achender@kernel.org>
To: Kyle Zeng <kylebot@openai.com>, linux-rdma@vger.kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Mon, 09 Nov 2026 09:58:06 -0700
In-Reply-To: <20261107041804.64213-1-kylebot@openai.com>
References: <20261107041804.64213-1-kylebot@openai.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-11-06 at 20:18 -0800, Kyle Zeng wrote:
> rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
> represents a pin that it owns. However, pin_user_pages_fast() can roll
> back a fast-GUP pin after racing fork() and then fail in the slow path,
> for example after a concurrent mprotect(PROT_NONE). The output slot can
> still contain the already-unpinned page.
>=20
> The common error path calls unpin_user_page() on that stale pointer.
> This can consume another subsystem's pin and allow the page to be freed
> while it is still in use. A local unprivileged reproducer triggers a
> KASAN use-after-free write through an io_uring registered buffer.
>=20
> Clear page when rds_pin_pages() does not return one. The error path
> continues to release the page on errors after a successful pin, and
> successful requests retain their existing ownership and behavior. All
> four RDS atomic ancillary operations share this path.
>=20
> The issue was found by an LLM.
>=20
> Fixes: 15133f6e67d8 ("RDS: Implement atomic operations")
> Cc: stable@kernel.org
Just for future reference, stable@kernel.org is for unpublished security
bugs and stable@vger.kernel.org is for known bugs.  No need to resend,
stable will still find it, but just an fyi for next time.

> Signed-off-by: Kyle Zeng <kylebot@openai.com>
This version looks good to me, thanks Kyle!

Reviewed-by: Allison Henderson <achender@kernel.org>

> ---
> v2: Use the net subject prefix, add Fixes and stable Cc tags, and
>     include the validation results.
> v1: https://lore.kernel.org/r/20261030042110.73571-1-kylebot@openai.com
>=20
> I have a reproducer for this issue and can share via DM
>=20
>  net/rds/rdma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index 078090d292fa..71b57abb96c4 100644
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -957,8 +957,11 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_=
message *rm,
>  	}
> =20
>  	ret =3D rds_pin_pages(args->local_addr, 1, &page, 1);
> -	if (ret !=3D 1)
> +	if (ret !=3D 1) {
> +		/* A failed pin can leave a stale page pointer. */
> +		page =3D NULL;
>  		goto err;
> +	}
>  	ret =3D 0;
> =20
>  	sg_set_page(rm->atomic.op_sg, page, 8, offset_in_page(args->local_addr)=
);
>=20
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d

