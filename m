Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793474604;
	b=L/wyNEtTBq1ngSoC+e3YDsQdxZUJSdhV4lzRQeWkWMBxbfH4le6fKh9pS3LsztEXiYw6
	 H89wA7nkTa4o8nZpu68dSUQJO6OXxPMXwOkytpsykl48kJ0GTt+CKpFZHTUHOA87i0+KL
	 8vhw5sA6n11VPEUZOX3F5E89mtrX/Gi+/tZLLF9aXry83u6ny5OEj1ZpfO2VfIQBf9n4x
	 W2z/loMOW7z/bUCdRc5ijpOw6UVKn3WGg8veVVRl1iiDdYx3Moxfh6vD1hlZlsFEhbN2s
	 VDgjDXy9qVqhjGpjYI/My+z4aEpOkJfjpr97e98DCmXV86W/6GCLmm5LKv4a895Fd7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793474604;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=wiIzSjn+mtGawNfvo8XnzlYZC4Y8Z4jY/HqNPQcZhLE=;
	b=V5oIZKB0OhxkopMBOdBfcxJ+45Q8PIfM87jkcslXvr/Ro+F3wSY7NDnu9zKmxhwZWPVH
	 6TfeRskf7MhnNjcitmMwhJNU90u4qamEAtAUkQqhVjaOz5/y15BA+jgv+/cL7OTV9FSWS
	 8kR+f5QVIePMDwWmRKLuBZtA6CS9HTYljMxso2hagB5IIDMk8EIYaPSSFr2cH6ba4bHl9
	 1vZqkZBUVZV1Ts3GIDWXPaJEuUPIpJ45smRsdef57hzEbu1lUDegF+QgWlND0h77XmAKk
	 iRY2tkt8UmATrdGszSXFgXFje3rjSRJTBIDBArwTm/YDwkPwIntWIS438zz41XAPMNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YczLZU9N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CD2606A31A;
	Sat, 31 Oct 2026 19:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YczLZU9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216DD1F000C1;
	Sat, 31 Oct 2026 19:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793474603;
	bh=wiIzSjn+mtGawNfvo8XnzlYZC4Y8Z4jY/HqNPQcZhLE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YczLZU9NpkjU9wmqof2jos1q9/iRyf8vM+JLnDIj993oHoTpDSuv2SIj4Tc1/UFAZ
	 ITiFlieiA9eaAF/zw/PpxBHhoUW3SkEO0pjoUhRHVpxKIwE0C/dgqwxM1PqIcrDTJf
	 Jxf6YMZW2xYYQAo7B2WXCnCyYLxODmzrrMtQoC5ajUdicAYuIdXuUXShpBWnvAT7pq
	 u7JxXTWMld7l63bJOfhVeSQT2a1N3QgYgvHaO5L04t831wyEIuPRX0Uw9JgbgRGKq/
	 ntzDE7TSDqSsUFDw/iG5vszYGQ6B2uVr+g3vTv1MK+Jc1+JfaTKXKIjzdao9ju8csi
	 WT5Bl4r2KeHYg==
Message-ID: <24b80e47c623063ee9d717ff051a746b9d226a86.camel@kernel.org>
Subject: Re: [PATCH] net/rds: Do not unpin a page after a failed atomic pin
From: Allison Henderson <achender@kernel.org>
To: Kyle Zeng <kylebot@openai.com>, rds-devel@oss.oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Date: Sat, 31 Oct 2026 12:23:21 -0700
In-Reply-To: <20261030042110.73571-1-kylebot@openai.com>
References: <20261030042110.73571-1-kylebot@openai.com>
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

On Thu, 2026-10-29 at 21:21 -0700, Kyle Zeng wrote:
> rds_cmsg_atomic() assumes that a non-NULL output from rds_pin_pages()
> represents a pin that it owns. However, pin_user_pages_fast() can roll
> back a fast-GUP pin after racing fork() and then fail in the slow path,
> for example after a concurrent mprotect(PROT_NONE). The output slot can
> still contain the already-unpinned page.
>=20
> The common error path calls unpin_user_page() on that stale pointer.
> This can consume another subsystem's pin and allow the page to be
> freed while it is still in use.
>=20
> Clear page when rds_pin_pages() does not return one. The error path
> continues to release the page on errors after a successful pin, and
> successful requests retain their existing ownership and behavior. All
> four RDS atomic ancillary operations share this path.
>=20
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Hi Kyle,

Thanks for the patch, the fix itself looks good to me.  Some things we need
add to move you forward:  First, your subject line specify which branch the
patch is applied to.  Since this is a fix for code already in mainline, we=
=C2=A0
should target the net tree.  So rebase the patch on the latest net branch a=
nd
format the subject line like this:

  [PATCH net v2] net/rds: Do not unpin a page after a failed atomic pin

Also, since this patch is a bug fix, it should cc=C2=A0stable@vger.kernel.o=
rg and
carry a fixes tag that identifies which commit the patch is fixing.  For th=
is
fix, I think we want 15133f6e67d8:

  Fixes: 15133f6e67d8 ("RDS: Implement atomic operations")

Lastly, remember to add a short change log below the --- line.  Just someth=
ing
brief like this:

  v2: Target net, add Fixes and Cc stable tags


> ---
> I have a reproducer for this issue and can share via DM

Thanks, could you post it on-list with the v2?  Either below the --- line o=
r as
a reply.  That way others can see and verify the fix too.

Thank you!
Allison

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
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3

