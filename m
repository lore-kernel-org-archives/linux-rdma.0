Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4232AD00;
	Sun, 11 Oct 2026 20:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791751293; cv=none; b=phyTTTm0T/bRs6tVp5ngRbyUN9qZeq7WlDW40EaBrcIFNaMDZa+Gq6ZxhjGhuqrgh5oAryyWV8TqWz2/JLuBTFsIy4sDnmKwZNuJg0Y8nt7t+T0Im574QZr4XYYd6GA4ipXvm9rvt+rlulqLzgoOLx95ZALZNM6Tr7ZnUuHLYDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791751293; c=relaxed/simple;
	bh=RO9ISlZvPFFXP6l+PwZzFLx38QyGRFkuORHAOV9ntKI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B5hu8d/hEiXyyq6WL3w9xcdi0Rfk75mLrz4DeTdlMf52bROplzsLH1a5WxRDz6wolA1KrA9V3zJVlC8k5dFaGdaW/sBvSpHXAzzUTetpVgLi44Hq/Alpa9mSzEhVoh/IR9bXvRQUulvU/6cxBIJKWt/5yld3cK/wiRCZr9Jb4hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b10v1nnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b10v1nnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB471F0089B;
	Sun, 11 Oct 2026 20:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791751292;
	bh=RfXdrFXcfp1opR3x45dOBQyYz5kPQ9A4aytmThsJMzs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=b10v1nnBor0aJ+7mOPZ7PlfPUck6RaGHusprk/0cO2RrvqP7qh1tHC64dSh06RjPZ
	 Ms3NNUca0hdC4XWG1CLDKZ88HtkZ7ne7eipytvh6+BBpEBhD+nTvCyHqgyfMVWJb/I
	 dymnSiL0xoMy+u6tZeIPDLt03wp1J1z85ge3StxB1LpTRN0VFNJdutoJ9c17kbezD6
	 Pw+/XBMnYZoVHdywC3e1RUV+qY7sBj6WURvdSh83bp29+F5vxblG4wldigE2pM+5Tp
	 91f5guh+WqASznr+N/u2xSxAzRfy9EJ6NhfK1FynkWCbDbjKHKo8eeg3S9XwB9/tey
	 gLYQ1FdU/fcJg==
Message-ID: <9cdaa7743cbd1e6e39345647f4ef95ab308ca7ad.camel@kernel.org>
Subject: Re: [PATCH] rds: fix out-of-bounds conn_path access via handshake
 NPATHS
From: Allison Henderson <achender@kernel.org>
To: Henry Martin <bsdhenrymartin@gmail.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 11 Oct 2026 13:41:31 -0700
In-Reply-To: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
References: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-09 at 00:38 +0800, Henry Martin wrote:
> Connections on the IB transport (t_mp_capable unset) own exactly one
> rds_conn_path slot, but the peer can still claim eight lanes through
> the NPATHS extension header of a handshake packet, and every
> subsequent fan-out path then treats all eight entries as real: the
> mp-start helper iterates conn->c_path[0..7], dereferencing cp->cp_conn,
> taking cp->cp_lock and queueing delayed work on cp->cp_wq at 504-byte
> strides into whatever comes after the single allocated slot (KASAN:
> "Read of size 8 in rds_conn_path_connect_if_down").
>=20
> The negotiated lane count is now clamped to the same value the
> transport was allocated with (trans->t_mp_capable ?
> RDS_MPATH_WORKERS : 1), so a peer can never ask us to walk lanes that
> do not exist.
>=20
> This vulnerability was discovered by Tencent CodeBuddy Security.

Hi Henry,

Thanks for the patches.  This patch looked a little familiar, and it turns =
out this fix and the
companion patch ("fix out-of-bounds conn_path walk in peer gen update") are=
 the same fix Paula
posted in August:

https://lore.kernel.org/netdev/20260825120132.51636-1-pamoutafpro@gmail.com=
/

The AI review of that version came back with some complaints:

https://lore.kernel.org/netdev/20260828230506.385788-1-kuba@kernel.org/

The good news is, I think the fix is a very simple port of a uek patch:
https://github.com/oracle/linux-uek/commit/2fdeb0513f18

If your willing to step in where this series left off, you'll want to start=
 with the v2 thread,
and pick up the porting task described there:
https://lore.kernel.org/netdev/83915f73efb509328a3d4963b093e2cffcf9af99.cam=
el@kernel.org/

Please send a single v2 that is just that port, against net.  The fix tag b=
a3d1f480c7a doesnt
look like it changes the allocations. The tags you want should be:
Fixes: 840df162b3eb ("rds: reduce memory footprint for RDS when transport i=
s RDMA")
Fixes: 905dd4184e07 ("RDS: TCP: Track peer's connection generation number")

A link to Paula's v2 would also be a nice way to credit her analysis as wel=
l.

Thanks!
Allison

>=20
> Cc: stable@vger.kernel.org
> Fixes: ba3d1f480c7a ("net/rds: size a connection's path set by the transp=
ort it ends up with")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  net/rds/recv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -224,7 +224,8 @@
>  		/* Process extension header here */
>  		switch (type) {
>  		case RDS_EXTHDR_NPATHS:
> -			new_npaths =3D min_t(int, RDS_MPATH_WORKERS,
> +			new_npaths =3D min_t(int, conn->c_trans->t_mp_capable ?
> +					   RDS_MPATH_WORKERS : 1,
>  					   be16_to_cpu(buffer.rds_npaths));
>  			break;
>  		case RDS_EXTHDR_GEN_NUM:
> --
> 2.43.7

