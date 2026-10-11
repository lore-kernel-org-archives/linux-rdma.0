Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1FA23817E;
	Sun, 11 Oct 2026 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791751450; cv=none; b=Xte5PIRQ+Ek55gqFxJnMsG3mVaGpkL7axyVM/aQLNgz18iFDkdIHW0N4CizQwh5jfL4j9o6pG7mTOycYg8vakeoCXooSdVyTRQ+Pt2uG/arWs4u5w+2K1fqhFJlGeiduSAIhtGNgCIgfQ47Bzk/u+ojDw8yPyF2+suIWd635MA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791751450; c=relaxed/simple;
	bh=qFwGJErAOF1xJhe3RYW0olYnPq0313Jj84maBd/9NRE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gNLeBDmISeQxRkqVKjkDPjtZwaVCunU/OdolNpeU9QiI8luqxsPNGZpo+OmsmeMCU6lfIFvQjujp0Lvbc9un4Y6uFDMUbEH2ElKJ9P+P+rDaeyEg4wyH/I19sdcOX2IoaMF3F+W9axVUjs6muo9425Jb3j/jhY8fO/Vc1ldNBKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFCW3XMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFCW3XMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480121F0089B;
	Sun, 11 Oct 2026 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791751448;
	bh=jwsaWPFL5lSwMPYPKntzvuLOFwYaczrmDVzo/Dx8PRU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PFCW3XMnfU6kH3gRH6dy9KV8ldB4nP1e8vhhv1NMTNMx6U4g670H3uiDL3bPgqujr
	 +grhzBWVN1agI5VrOxN9TtjkpWUBXUAYudMOKS1NnjTdD9udHetuQ9jEMgRNydnpVF
	 0ixyg22xSTAJ2tWuxmbNPmIBWgpX7oOUNCBHR+sukMNSdSh8RuGs9qet2hE3g5CLdH
	 Tqc3LP7mMlPTt5aDB+Pp8lHrgJ/ZQIDb2/I5uNHoIhSb3grNFZxRXCaJ+hovYecilU
	 ZRcDV8fe+U//rdMiY3F8hfh6yibgFmNpaKvQofch421mUSzTT9NFqjVpgPfjU7bXoL
	 qYW4YZVVrnbrw==
Message-ID: <b33f6c72f102b1181e2f6ef605c8958800be4784.camel@kernel.org>
Subject: Re: [PATCH] rds: fix out-of-bounds conn_path walk in peer gen update
From: Allison Henderson <achender@kernel.org>
To: Henry Martin <bsdhenrymartin@gmail.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 11 Oct 2026 13:44:07 -0700
In-Reply-To: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
References: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-09 at 00:40 +0800, Henry Martin wrote:
> A connection on the IB transport (t_mp_capable unset) is allocated
> with exactly one rds_conn_path slot, yet the peer's genetic number
> update routine is hardcoded to walk RDS_MPATH_WORKERS entries whenever
> the peer announces a non-zero gen number that differs from the one we
> cached.  Everything past the first entry lands on whatever happens to
> follow the single-slot array in the same slab slot group, and the loop
> then reads and modifies struct fields there (lock acquired,
> cp_next_tx_seq cleared, retransmit list inspected).  A malicious peer
> can therefore force consecutive out-of-bounds writes into neighbouring
> kmalloc-512 objects (KASAN: "Write of size 4 in
> _raw_spin_lock_irqsave").
>=20
> The allocation and the walk now agree on the same expression
> (trans->t_mp_capable ? RDS_MPATH_WORKERS : 1), so the loop can never
> outlive the array regardless of what the peer reports.
>=20
> This vulnerability was discovered by Tencent CodeBuddy Security.

Hi Henry,

Please see my reply to the NPATHS patch:
https://lore.kernel.org/netdev/20261008163843.957325-1-bsdhenrymartin@gmail=
.com/

We should fold this patch into a single v2 from that thread.

Thank you!
Allison

pw-bot: cr


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
> @@ -144,7 +144,8 @@
>  	if (peer_gen_num !=3D 0) {
>  		if (conn->c_peer_gen_num !=3D 0 &&
>  		    peer_gen_num !=3D conn->c_peer_gen_num) {
> -			for (i =3D 0; i < RDS_MPATH_WORKERS; i++) {
> +			for (i =3D 0; i < (conn->c_trans->t_mp_capable ?
> +			     RDS_MPATH_WORKERS : 1); i++) {
>  				struct rds_conn_path *cp;
>=20
>  				cp =3D &conn->c_path[i];
> --
> 2.43.7

