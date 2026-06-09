Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346ED2D7DC6;
	Tue,  9 Jun 2026 08:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780992124; cv=none; b=RaA4Gx5/YQcP6TQ2A2/ChgTg+z/qXYAQYP39bYL2/UALptQc1fwEnrqSKC6lfiFY5SOws7P+8Fde+2uKzxKCIaaNhPO1LGQr2ID1cv3P4gYefRCYsMo7GEp2Om5kzHF2rYhb1hso81qQW03hVq2gPX17vlj0zICXGHP1ZSC5mGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780992124; c=relaxed/simple;
	bh=16z0nb2qGfs6Z2maprE1CVF/YuZWUpbSpq91LDNUAlI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s9kwi+hUMGg9av8jgXJRx1uIqRp55Tx/1FoSoLrNwpoFrAA6+qfF25nOdLqT/s1MypbbjDK/3V2EaCkHyRtlIGP15+fRTlKd0Q8Hnt8bi55MNdEnfdUeX7XrFN1m/FXuqAUhiC8Cf4JdT/tJhs3JUjb0GaeSPwQp0OdeC/beBCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqLGEOoB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqLGEOoB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DE51F00893;
	Tue,  9 Jun 2026 08:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780992122;
	bh=oSBHxgyAAZgnL2cLmJ1SW2H3oqLDAuVwnjO7iHUNkkU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CqLGEOoBf5yeAlzmhKOmqgh4eDSP0mbUzySlQd3mGBhxMCqiK1wQeoYvSotG9sirk
	 NrO7FMj01zzGWrfsHbn7qKZy+3NuBR5Nr1w4EuxEEdTYN74DeLhYWHAb1egkNdwrGj
	 qWcOqbakI3WnSyxCzCQkOQn1L+OPQwZeUcmVcXA8sZkKts2V1ahq4VPF7faB5BdA5u
	 Uf91uEIPsf3pJiEwgTvz+mGt+CveGT2sHCc6TgiTPk52ujwysSbSD+Q+w/0ULede+5
	 17al5iICvYMzCE4/5luW8XYKucOxxgNmJvAgNXk1HyqtcME0A7249bVEkjvYH6bGYl
	 enZy9u1W4QSwg==
Message-ID: <7f310d00c39da9edf0019c130d346ce30107fd29.camel@kernel.org>
Subject: Re: [PATCH net] rds: mark snapshot pages dirty in
 rds_info_getsockopt()
From: Allison Henderson <achender@kernel.org>
To: Breno Leitao <leitao@debian.org>, "David S. Miller"
 <davem@davemloft.net>,  Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,  Simon Horman
 <horms@kernel.org>, Andy Grover <andy.grover@oracle.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
Date: Tue, 09 Jun 2026 01:02:00 -0700
In-Reply-To: <20260608-rds_fix-v1-1-006c88543408@debian.org>
References: <20260608-rds_fix-v1-1-006c88543408@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-06-08 at 02:32 -0700, Breno Leitao wrote:
> rds_info_getsockopt() pins the destination user pages with FOLL_WRITE and
> the RDS_INFO_* producers memcpy the snapshot into them through
> kmap_atomic(). Because that copy goes through the kernel direct map, the
> dirty bit on the user PTE is never set, so unpin_user_pages() releases th=
e
> pages without marking them dirty. A file-backed destination page can then
> be reclaimed without writeback, silently discarding the copied data.
>=20
> Use unpin_user_pages_dirty_lock() with make_dirty=3Dtrue so the modified
> pages are marked dirty before they are unpinned.
>=20
> Fixes: a8c879a7ee98 ("RDS: Info and stats")
> Signed-off-by: Breno Leitao <leitao@debian.org>
Hi Breno,

Thanks for adding the Fixes tag. One thing though: now that this is
standalone, it collides with "[PATCH net-next v3 2/2] rds: convert to
getsockopt_iter" since both rewrite the same unpin in the out: block of
rds_info_getsockopt(). =20

Easiest on everyone is to just keep it folded into the net-next series as
a three-patch set, rather than splitting the fix out to net.

With that, you can add my:
Reviewed-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison


> ---
>  net/rds/info.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/rds/info.c b/net/rds/info.c
> index f1b29994934a..17061f6ff74e 100644
> --- a/net/rds/info.c
> +++ b/net/rds/info.c
> @@ -235,7 +235,7 @@ int rds_info_getsockopt(struct socket *sock, int optn=
ame, char __user *optval,
> =20
>  out:
>  	if (pages)
> -		unpin_user_pages(pages, nr_pages);
> +		unpin_user_pages_dirty_lock(pages, nr_pages, true);
>  	kfree(pages);
> =20
>  	return ret;
>=20
> ---
> base-commit: 9772589b57e44aedc240211c5c3f7a684a034d3a
> change-id: 20260608-rds_fix-92d6c7f04fe2
>=20
> Best regards,

