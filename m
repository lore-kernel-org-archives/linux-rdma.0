Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1A332906;
	Sun,  6 Sep 2026 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788705844; cv=none; b=Qpc1Uy/zVQcHEybmyXH/W5HWxQwH0j61EgJBSrxGs8dUpiKCN6Otko0hjqYhXIv24dfhdcjokJxm0me5n7H1ZVgoz5fnrg4OE6FTdHWnPZ2YWde2UTto4s7mLc4Lo6cvgtEUfYfN+HltC137kKQxExHHZsbvGfzAcuGuoCHKapA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788705844; c=relaxed/simple;
	bh=f6E14dPxs9/EdiAyv7Qjb8W4Xupsto9s8SfquMix/dw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JTaIHfvpj+0c2qiUokMB49bXZM7g6h2GnRoXUKg0962KCBF62Hv6ckniaFiNaTF/DBDdYfZgEoXKxhvcut5CCSBn04Ao/kWqcEiw5zcdWMrjyYlf8gjXAfj6ud1JBhCVHoZT3a56FauzlPBpApxQnXtt+5IE8Ib9F3Nubtk015s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqGEkiyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqGEkiyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832751F00A3A;
	Sun,  6 Sep 2026 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788705842;
	bh=FhBvWn5zlBVcn4zzysQ5WRpXl36PT0HjiqVbtNJef5g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZqGEkiyXzaYCUf9g/U/KT1mYjQdnBxWeEeAYgeWLv0Wv0auosb95PCWcb6C330SqQ
	 s4SPTY5T3WVpnXYGxQ5i5v0kHWz1kj/fiRot3Ejrg6Dg72GseqfROgwlp5nmeTAv3R
	 EXMk9CdMlOO9+lvt8Oo+YuzhQWBiReEeiUrb4i1npQ9XCRhB2j71d83aU5ooIiSuxt
	 twDNDOqqW4f4+N0MV0TIBuRZlK6sGpDtpahaxm25li5+rF39DyOxjZYXQNgGD3Goga
	 N71+i30kySu4VcPlhTAtIKSYUgYDWQbzLUBPrZfHaMEvKWq0iNA8sPe/B10YBOxyOo
	 WOKeQjljYkXmw==
Message-ID: <6cd13a40ffaf62bfb9b967bdd4dd28a38af3e7b1.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: fix tcp stream corruption with large pages
From: Allison Henderson <achender@kernel.org>
To: Greg Marsden <greg.marsden@oracle.com>
Cc: kuba@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com
Date: Sun, 06 Sep 2026 07:44:01 -0700
In-Reply-To: <apxJjxvStibPI0AS@oracle.com>
References: <apxJjxvStibPI0AS@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-09-05 at 10:00 -0700, Greg Marsden wrote:
> rds_message_map_pages() assigns PAGE_SIZE bytes to every
> scatterlist entry, even when total_len ends in a partial page. The RDS
> congestion map is defined as 8192 bytes, so on systems with PAGE_SIZE
> greater than 8192 the scatterlist maps bytes beyond the end of the
> congestion map.  RDS-TCP transmits the SG contents according to those
> lengths, so the extra bytes become part of the TCP RDS stream and are
> interpreted as subsequent RDS message headers, corrupting the stream.
>=20
> Limit the final scatterlist mapping to the number of bytes remaining.
> This has no effect on systems with a 4K page size and allows RDS-TCP to
> be used on systems with 16K and larger page sizes. =20
>=20
> The RDS selftest, which previously hung on 16K pages, now passes.
>=20
> Fixes: 7875e18e0996 ("RDS: Message parsing")
> Signed-off-by: Greg Marsden <greg.marsden@oracle.com>

Looks good, thanks for the catch!
Reviewed-by: Allison Henderson <achender@kernel.org>

> ---
>  net/rds/message.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/rds/message.c b/net/rds/message.c
> index f25f2592586f..47d5e9ab9b10 100644
> --- a/net/rds/message.c
> +++ b/net/rds/message.c
> @@ -431,7 +431,9 @@ struct rds_message *rds_message_map_pages(unsigned lo=
ng *page_addrs, unsigned in
>  	for (i =3D 0; i < rm->data.op_nents; ++i) {
>  		sg_set_page(&rm->data.op_sg[i],
>  				virt_to_page((void *)page_addrs[i]),
> -				PAGE_SIZE, 0);
> +				i =3D=3D rm->data.op_nents - 1
> +					? total_len - (i * PAGE_SIZE)
> +					: PAGE_SIZE, 0);
>  	}
> =20
>  	return rm;

