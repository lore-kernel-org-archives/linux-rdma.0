Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146C043CECB;
	Wed, 23 Sep 2026 07:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147140; cv=none; b=FRFPgdxaswwr4rKa81kZnbidfVgmxl6epUkp72XdJn7QWTCvIropYGu+2eUK/ii7ZLLrRmb6Bm/cet/ikSfcyVfMowzm/nsSA8rcR+DTlr8zK9wGovD2Zyo3UUO54EYKsPoqO9d3BicXFuj9Lm7IEWdbSWimRcFzwrHrf5/WgxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147140; c=relaxed/simple;
	bh=27vpwdgl3OeoImEKbFkRdIhTD1sNRxWgus+Es2lrpjo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jgdxrg+3JC62p/AENCy5K+Zo7vUXbL9okYuvQuPZWqt8M6bPk4YqJi/YMfSF5mDBmV5KN6EozQK58nCtbao7NK9s/4tkSI4vJia4klNp+3LtKIlRhDD1flOmLGeqlatcpmwpZUIoAVxLzp0Sa2S46Zke7qpAdvHSYWlOIFIna4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMBM3EcN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMBM3EcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DBB1F00893;
	Wed, 23 Sep 2026 07:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147137;
	bh=/sxulSnyvVD18U479eSRV3tTjaQVahI5tsiyX6mHLpI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JMBM3EcNDs+asutoja1zN4cCHn217CPpcLlK2Yt+FMC6gwRr1H2GN4XOfpCrB/yla
	 PAHL3h/vV/mREpbGSLzM/tNAnrvrGEsUiM/o+D3DOggYbUq0PwcVh7ISJu4jmlOg/M
	 8UJT4NqbfG1UeXsziqlgKWCPg0CCRbkuuuNh/uFg9SlBlWxYEtLhkssJO5zARSYW0g
	 wTTq9KiVTUQgLu1Z2xRXcaq6jiEkKStozswU6+5A/a3tXv9GThFHpfJ806bSyDQjf7
	 jSZ2E8WT0mZMzMu10byomk/nqyOXD9FjZ7Xd+TLGtCioQBn8x0HLW94RnJ0BSpNuJ4
	 1TFNBLWMzKZcA==
Message-ID: <fc0e0a9deffa162ac4599ee8ef94323d3d1ec2c4.camel@kernel.org>
Subject: Re: [PATCH net v2] rds: ib: Clear the sg list when mapping an MR
 fails
From: Allison Henderson <achender@kernel.org>
To: Dongliang Qin <cccccccccccc777777@gmail.com>, netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 23 Sep 2026 00:05:36 -0700
In-Reply-To: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
References: <20260922031546.3874605-1-cccccccccccc777777@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-22 at 11:15 +0800, Dongliang Qin wrote:
> rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
> mapping and registration can fail. On failure, __rds_rdma_map() unpins
> the pages and frees the scatterlist, but rds_ib_free_frmr() can still
> return the MR to the pool with the stale pointer set.
>=20
> This leaves the pool with a dangling scatterlist and can lead to local
> privilege escalation. KASAN detects the resulting use-after-free when the
> MR is later torn down:
>=20
> BUG: KASAN: slab-use-after-free in __rds_ib_teardown_mr
> Read of size 8
>=20
> Call Trace:
>  __rds_ib_teardown_mr
>  rds_ib_unreg_frmr
>  rds_ib_flush_mr_pool
>  rds_ib_flush_mrs
>  rds_free_mr
>  rds_setsockopt
>=20
> Store the scatterlist in the MR only after DMA mapping succeeds. If DMA
> mapping fails, return directly while the MR fields remain clear; the call=
er
> keeps ownership of the scatterlist and its pinned pages. If a later
> registration step fails, unmap the scatterlist and clear the MR fields
> before returning.
>=20
> Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registrat=
ion mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>

New v2 looks good to me.  Thanks!

Reviewed-by: Allison Henderson <achender@kernel.org>
Allison

> ---
> Changes in v2:
> - Store the scatterlist in the MR only after DMA mapping succeeds.
> - Return directly if DMA mapping fails, leaving the MR fields clear.
> - Link to v1: https://lore.kernel.org/netdev/20260920063449.1594203-1-ccc=
ccccccccc777777@gmail.com/
>=20
> net/rds/ib_frmr.c | 11 +++++------
> 1 file changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> index bd8611911..8397aa4a1 100644
> --- a/net/rds/ib_frmr.c
> +++ b/net/rds/ib_frmr.c
> @@ -204,19 +204,16 @@ static int rds_ib_map_frmr(struct rds_ib_device *rd=
s_ibdev,
>  	 */
>  	rds_ib_teardown_mr(ibmr);
> =20
> -	ibmr->sg =3D sg;
> -	ibmr->sg_len =3D sg_len;
> -	ibmr->sg_dma_len =3D 0;
>  	frmr->sg_byte_len =3D 0;
> -	WARN_ON(ibmr->sg_dma_len);
> -	ibmr->sg_dma_len =3D ib_dma_map_sg(dev, ibmr->sg, ibmr->sg_len,
> +	ibmr->sg_dma_len =3D ib_dma_map_sg(dev, sg, sg_len,
>  					 DMA_BIDIRECTIONAL);
>  	if (unlikely(!ibmr->sg_dma_len)) {
>  		pr_warn("RDS/IB: %s failed!\n", __func__);
>  		return -EBUSY;
>  	}
> =20
> -	frmr->sg_byte_len =3D 0;
> +	ibmr->sg =3D sg;
> +	ibmr->sg_len =3D sg_len;
>  	frmr->dma_npages =3D 0;
>  	len =3D 0;
> =20
> @@ -264,6 +261,8 @@ static int rds_ib_map_frmr(struct rds_ib_device *rds_=
ibdev,
>  	ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
>  			DMA_BIDIRECTIONAL);
>  	ibmr->sg_dma_len =3D 0;
> +	ibmr->sg =3D NULL;
> +	ibmr->sg_len =3D 0;
>  	return ret;
>  }
> =20

