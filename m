Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769784;
	b=LpUH9MbUouTS1ezUn+DkKguDkXzCv5hNk6ADnNkD0wslvlk9w6ujg9dOrY887gN77U8f
	 ZtyXbutlbhjeFmv/y/OTq2phEcgZxO2ft/fUKLXE7hA85XgrFFSaKlMkE6eajIV5gwzH4
	 Mjm3XVpz0Cn1Ns+9a24NiMiaEeooRialx00jYUgHTHx82NuINUq1N28YDyyIwWS/v+/Yb
	 0oWZ2uPcbF5Lud6vVOSf+x6vPhcy0Y9CNeQwavna25O/pBXOUKILOXGSDJpR0dSvKjzSG
	 JigokCdbTFULnbGvm+ZzcJaJ2Y+xDTSWc0C+dG4cIQvAhyZcyf+QIXr9ErPTqHWSm7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769784;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IGf6BUs3c9ORTQyT5Ve+82R2iif1ZUqeDb52+oEabUI=;
	b=R+gRPbkSnX4zQJearRG7wWqqZlSRuqOHs3GQY354rPYn/YQZNtpZpL4gfP3115SDaDbu
	 xHlo9wD0bCom7wQ41XIfXMbCIFIezNQRqhqI5fChPZyvVipGQ8xxdiByPpHuqNWdsssKo
	 QrtvXTB1k6g/6H9ihZoLSG0FVqgl9KOJqynsNdHLLCsjK5/N7XVWnmcPGQqh3omHdx2Sr
	 gp1FrTrg19hvXXAP6kNY3A1AKzkrq2W2gVvlH3+iWTqYhflGKWDTx5QvVW0zHNE9kTmd6
	 Q8pqZpy0C+lb5crHnkKD/ThGA5IAvw44Jsqftq7dNLKklqaASQCNa4Ak2B1noNOP4tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuIgtOkk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44DA606A32C;
	Sun, 15 Nov 2026 19:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AuIgtOkk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237DE1F000C5;
	Sun, 15 Nov 2026 19:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794769784;
	bh=IGf6BUs3c9ORTQyT5Ve+82R2iif1ZUqeDb52+oEabUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AuIgtOkk/9PPoM69iGmA8sfdq6g7oJj0KKg7yIx2XnNJEELqL3whhrdzn3cdX2z+J
	 bNpL0BinxY0sxz44bzuV/nlZnQaclbnlXw2msZ1NCjOAkZt50j+V6dsWf2YcQL8x5K
	 SyXoQT79i69Ah7MGLKV8eCIHhT6nQ5d1uoo5yPYP358EoquuZFhdXDeIVtTOTDk7dR
	 ZnALRwORXZaQkcEKtfQ3h1gHIl6R93FUjyEBJ2sbVgu5VKBvMPPZSXlgnGdbD2GZ7H
	 woHvfjyOtLP1h3JtgRsZB4VpYPWzExYdfLJIrX+7qhDQHYpAdSzAOcwK4ebdVEpvLX
	 qXRi6RfpGkyNQ==
Message-ID: <sashiko-outbox-215740@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 2/2] net/smc: do not reuse the DMB of a nocopy
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261114-b4-disp-4e6374c2-v2-2-3b7050bddef7@proton.me>
References: <20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me>
 <20261114-b4-disp-4e6374c2-v2-2-3b7050bddef7@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 19:09:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] net/smc: smc_conn_free() skips smcd_rmb_drop() after
  smc_conn_kill()
--

commit 0276e117c19ed3d088959046a595c0d87ce90a1b
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: do not reuse the DMB of a nocopy device

This commit unregisters and frees the DMB of a nocopy SMC-D device when a
connection ends instead of returning it to the link group's buffer pool.

> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index a3164201c1420..6a673ce74937e 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c

[ ... ]

> @@ -1306,6 +1327,9 @@ void smc_conn_free(struct smc_connection *conn)
>  	 */
>  	if (!list_empty(&lgr->list))
>  		smc_buf_unuse(conn, lgr); /* allow buffer reuse */
> +	else if (lgr->is_smcd && conn->rmb_desc &&
> +		 smc_ism_support_dmb_nocopy(lgr->smcd))
> +		smcd_rmb_drop(conn, lgr);
>  	smc_lgr_unregister_conn(conn);
> =20
>  	if (!lgr->conns_num)

[Severity: Medium]
Does smc_conn_free() skip smcd_rmb_drop() when the connection was already
killed by smc_conn_kill()?

When __smc_lgr_terminate() calls smc_conn_kill(), it detaches sndbuf_desc
and calls smc_lgr_unregister_conn(conn) (clearing conn->alert_token_local)
before smc_conn_free() runs:

net/smc/smc_core.c:smc_conn_kill() {
	...
	if (conn->lgr->is_smcd) {
		...
		if (smc_ism_support_dmb_nocopy(conn->lgr->smcd)) {
			smc->sk.sk_prot->unhash(&smc->sk);
			smcd_buf_detach(conn);
		}
	} else {
		smc_cdc_wait_pend_tx_wr(conn);
	}
	smc_lgr_unregister_conn(conn);
	smc_close_active_abort(smc);
}

When smc_conn_free() then runs (either from smc_close_active_abort() or
later from __smc_release()), smc_conn_lgr_valid(conn) is false and it
jumps to lgr_put before reaching smcd_rmb_drop().  While any other killed
socket in the link group remains open and holds a reference on lgr, the
closed connection's nocopy DMB stays registered in the device, allowing a
late peer attach to succeed on the dead connection's DMB, and
conn->rmb_desc is left non-NULL.

Running the smcd_rmb_drop() check at the lgr_put label before
smc_lgr_put(lgr) would cover both the off-list case and connections
unregistered by smc_conn_kill().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-b4-disp-4e=
6374c2-v2-0-3b7050bddef7@proton.me?part=3D2
