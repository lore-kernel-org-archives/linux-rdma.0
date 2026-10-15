Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA203C09F2;
	Thu, 15 Oct 2026 05:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792042180; cv=none; b=hwRri1Ks4UqrZTSROTbIRehamn76ZtHwCVqRKgYqUZipebzXvsIQ1n3IE2DFAgnaz7nTHav7X7rSRol4XnGYYJdEWNhNAU94Ssakt5T554MoCZR8l7xRvcPRQzvnRnQhteFwV3SFY+d2MhH+uqa8V6bawbtNBuH4xkKfhzPM9GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792042180; c=relaxed/simple;
	bh=J96CPq9KNfSGwmFfSwnow8d1VRCNy1lykVWEa4BRv5s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mJAVUg6pRtsRrx/P0bLfdFtcjWi1doRR0+bGlk62iMqaIIlNvHKktPsmPkOleukuwrVeaLJy7eo0RT6X69d8NgEkGMs/j2gibffqd1e37Xiy/MVKs17NHHi5N2Ma6h4HVzba+hYipwXSPVFf/zTvZpZR5G42wZ1diGDsWi1hxMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfxzQI/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfxzQI/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20881F000C4;
	Thu, 15 Oct 2026 05:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792042178;
	bh=mosaqDMrnIIYI76F1/ztKvBh4xcaQ41OBgNMnDxgPXw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=cfxzQI/BmSlZ6JiSpe4YMKvEFO7zN9jq3yeuCt97nRbyY5SVTgfc64ygdLL1csrYS
	 N43cXgV0/a0Du+vj3dRxNX/NSsLk/35Cn7Qydzb6gsE+YGCCatdxuGosXeeOmvcHVC
	 nqQXtsIscv0Cs+svQ7wpdhSWddqSJRY+lsxoCxn2zDPr3R3x8mrjrT+p+qXv/BI39r
	 F140vlp5VRuLSsYTPFwWoTR/bOucpT+BF5J5SXwdVJJZ0OcQrLftaaePT4XkReUPJz
	 1UlbckKwHzsF+BZAg2Qpj20euGWUAAa77BKb1gx5wtVkOtY0U8Jy8mlU2Yhr2qo5lG
	 fwYYPqoMv5nxg==
Message-ID: <220faca993d7a88c356b1e146f4a4397eedfe5de.camel@kernel.org>
Subject: Re: [PATCH net v2] rds: fix out-of-bounds conn_path walks via
 handshake exthdrs
From: Allison Henderson <achender@kernel.org>
To: Henry Martin <bsdhenrymartin@gmail.com>, Paula <pamoutafpro@gmail.com>, 
 "David S . Miller"
	 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet
	 <edumazet@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 14 Oct 2026 22:29:37 -0700
In-Reply-To: <20261012025336.54756-1-bsdhenrymartin@gmail.com>
References: <20261012025336.54756-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-10-12 at 10:53 +0800, Henry Martin wrote:
> Both the lane and the connection-generation negotiation are driven by
> extension headers in handshake packets, and both are processed
> unconditionally, even on transports that are not multipath capable.
> A non-MP connection (t_mp_capable unset) owns exactly one
> rds_conn_path slot, so a peer claiming up to RDS_MPATH_WORKERS lanes
> makes every subsequent fan-out walk conn->c_path[0..7] at 504-byte
> strides past the single allocated slot (KASAN: "Read of size 8 in
> rds_conn_path_connect_if_down"); the generation negotiation opens a
> similar out-of-bounds walk on the same array.
>=20
> Only process handshake extension headers when the connection's
> transport is multipath capable, so a peer can never make us walk
> lanes that do not exist.  Both call sites in rds_recv_incoming() are
> gated.
>=20
> This is a port of the Oracle UEK fix for the same issue, picked up
> where Paula's series of the same change left off.
>=20
> This issue was discovered by Tencent CodeBuddy Security.
>=20
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/netdev/20260825120132.51636-1-pamoutafpro@g=
mail.com/
> Link: https://github.com/oracle/linux-uek/commit/2fdeb0513f18
> Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport=
 is RDMA")
> Fixes: 905dd4184e07 ("RDS: TCP: Track peer's connection generation number=
")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>

Hi Henry,

Looks like a straight forward port.  Thank you!

Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>

Thank you!
Allison

> ---
>=20
> v2: Replace the two allocation-bound clamps with a port of the UEK
>     t_mp_capable handshake gating (suggested by Allison Henderson),
>     correct the Fixes tags and link Paula's series.
>=20
>  net/rds/recv.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..93ee4546ae362 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -379,7 +379,8 @@ void rds_recv_incoming(struct rds_connection *conn, s=
truct in6_addr *saddr,
>  		rds_stats_inc(s_recv_ping);
>  		rds_send_pong(cp, inc->i_hdr.h_sport);
>  		/* if this is a handshake ping, start multipath if necessary */
> -		if (RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
> +		if (conn->c_trans->t_mp_capable &&
> +		    RDS_HS_PROBE(be16_to_cpu(inc->i_hdr.h_sport),
>  				 be16_to_cpu(inc->i_hdr.h_dport))) {
>  			rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
>  			rds_start_mprds(cp->cp_conn);
> @@ -387,7 +388,8 @@ void rds_recv_incoming(struct rds_connection *conn, s=
truct in6_addr *saddr,
>  		goto out;
>  	}
> =20
> -	if (be16_to_cpu(inc->i_hdr.h_dport) =3D=3D  RDS_FLAG_PROBE_PORT &&
> +	if (conn->c_trans->t_mp_capable &&
> +	    be16_to_cpu(inc->i_hdr.h_dport) =3D=3D  RDS_FLAG_PROBE_PORT &&
>  	    inc->i_hdr.h_sport =3D=3D 0) {
>  		rds_recv_hs_exthdrs(&inc->i_hdr, cp->cp_conn);
>  		/* if this is a handshake pong, start multipath if necessary */

