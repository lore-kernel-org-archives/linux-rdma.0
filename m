Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795528425;
	b=hmJL22xIazGkkDvbrqTUtVxuLyatqkC0AL0v2v0GYjWkCdn7y9OsffSqFd7z7Tgl6dl8
	 zFMy2/Q0SK3NKp9XmSOoJBnHm3+sjsPUKt11y1y2F4zpgumQaedYGd3XE5/Bpc+/maGNP
	 WzcH3tcgdrk7awzUPtvOablR3m5V/VjyvNbRJ6APN0uTUh53FT7qRDL07YRpQmnJ2dZiB
	 LfPUE15jDiNqYWo0da54mrR409HEZvqwmJIL3P26aip4gxsWJeSc8a72avI1qmEMUfZ62
	 cUZ9MbOf7OSf3C7s9/tQyHLbDkjdkb0byURy5grYuGxNwZsjTSeYPLOwyCVlJhLLx5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795528425;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RYGIGzqQUM0vzsX2/bRDyouuVck8cJQdyz+UWcgDSkM=;
	b=z4ZuhNIPgxgrSipFtPPdBMXFP46o4iGaA8OkRMdKYe5ZXpwDvpKfXieoC1PIipHiC7g1
	 lA2xeeMw5KD6hxu/JomT1I1l4hoMOSWNxyJCIJZa9BHY35OHCaARm1aUf5Cc4F5HhpoYw
	 OXU/R2m8B8iLtOp5f5CT/gCwQ4SoaCVh+QyHUs52odSfKefCfKzUB4g7xFddl2ElrV3L2
	 NbwWj6+UOlo3TyjBejW5eWnhOpn8PEMy2v6ne3oVgQnKbF9o5/0CP1O6J9l3jFLuaGza8
	 iOBt7/dFN1pgN95Tk3qnjUlCctphADTL8/1Ml+PEX5UZrxqmeCOVWGLLK8bSG25zHtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBrr0LwB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F93606A322;
	Tue, 24 Nov 2026 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBrr0LwB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACD61F0093E;
	Tue, 24 Nov 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795528425;
	bh=RYGIGzqQUM0vzsX2/bRDyouuVck8cJQdyz+UWcgDSkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TBrr0LwB+4cGYxvR/BP29oC0bBwrIB9c4RBsm5GDUKMWcRWYa/Xx1XTJFdkWtviU6
	 LEVLKTRe91yEBjP69lEjkgaVrXwLhINg0jC34QcHQaHl0Sd/BKcWrmh+c4/bsIqAJe
	 3FVVXW6Yjjy1G/TOLXHj2XKyfTxsv2TtUJhzSHnE/ipAiF6s6ISq1Z+xDXwEBpFz1r
	 2jozlvMNL29V6ALQAg1Q9OUnvYlXR4Ikz7sGBk4v52eyIYYeR8r/+1gTuXgqtWH7u5
	 KX5WmuG4s6Em7WyzhOtK1I3irJP2uBRKDpp16Ct4QzOVZndRRMDn5STyZrD2JGfy/e
	 uD9+LWTtCOKkA==
Message-ID: <sashiko-outbox-231271@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 2/2] net/smc: bound the DMB-nocopy send-buffer
 credit as well
Reply-To: sashiko-reviews@lists.linux.dev
To: "Piyus Kedia" <piyus@iiitd.ac.in>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261123135327.3953509-2-piyus@iiitd.ac.in>
References: <20261123135327.3953509-1-piyus@iiitd.ac.in>
 <20261123135327.3953509-2-piyus@iiitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 13:53:44 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] net/smc: smc_cdc_msg_recv_action() bounds diff_tx by prepared
  not sent bytes
- [Medium] net/smc: smc_cdc_msg_recv_action() leaves local_rx_ctrl.cons
  unclamped
--

commit 07f52f148d1ba914d6b4ce3e90b172be0a15f763
Author: Piyus Kedia <piyus@iiitd.ac.in>

net/smc: bound the DMB-nocopy send-buffer credit as well

This commit bounds the send-buffer credit on the SMC-D DMB-nocopy path in
smc_cdc_msg_recv_action() by the amount of data outstanding in the send
buffer and advances tx_curs_fin by the bounded amount.

Link: https://lore.kernel.org/all/20261122053223.2497832-2-piyus@iiitd.ac.i=
n/

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..9ffa3e422aa1f 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -333,6 +333,7 @@ static void smc_cdc_msg_recv_action(struct smc_sock *=
smc,
>  	union smc_host_cursor cons_old, prod_old;
>  	struct smc_connection *conn =3D &smc->conn;
>  	int diff_cons, diff_prod, diff_tx;
> +	int sent;
> =20
>  	smc_curs_copy(&prod_old, &conn->local_rx_ctrl.prod, conn);
>  	smc_curs_copy(&cons_old, &conn->local_rx_ctrl.cons, conn);
> @@ -361,13 +362,26 @@ static void smc_cdc_msg_recv_action(struct smc_sock=
 *smc,
>  			diff_tx =3D smc_curs_diff(conn->sndbuf_desc->len,
>  						&conn->tx_curs_fin,
>  						&conn->local_rx_ctrl.cons);
> +			/* This difference comes from the cursor the peer
> +			 * reported, which is taken as it arrives.  A peer
> +			 * cannot have consumed more than this side has
> +			 * outstanding, so bound it by that and advance
> +			 * tx_curs_fin by the bounded amount rather than
> +			 * assigning the reported cursor: the invariant below
> +			 * then holds by construction, and tx_curs_fin stays
> +			 * inside the send buffer.
> +			 */
> +			sent =3D conn->sndbuf_desc->len -
> +			       atomic_read(&conn->sndbuf_space);
> +			diff_tx =3D min_t(int, diff_tx, max_t(int, sent, 0));

[Severity: Medium]
Can bounding diff_tx by conn->sndbuf_desc->len - sndbuf_space still advance
conn->tx_curs_fin past conn->tx_curs_sent and credit sndbuf_space for
prepared data that has not been sent yet?

smc_tx_sendmsg() advances conn->tx_curs_prep and subtracts copylen from
conn->sndbuf_space as soon as data is copied into the send buffer, before
smc_tx_sndbuf_nonempty() advances conn->tx_curs_sent (which is skipped when
corked via MSG_MORE or TCP_CORK).  When prepared-but-unsent bytes exist,
conn->sndbuf_desc->len - sndbuf_space includes [tx_curs_sent, tx_curs_prep),
so a peer consumer cursor ahead of tx_curs_sent pushes tx_curs_fin past
tx_curs_sent and allows subsequent smc_tx_sendmsg() calls to overwrite the
unsent bytes.  Should sent be computed with smc_curs_diff() between
conn->tx_curs_fin and conn->tx_curs_sent, as smcd_cdc_msg_send() does?

>  			/* increase local sndbuf space and fin_curs */
>  			smp_mb__before_atomic();
>  			atomic_add(diff_tx, &conn->sndbuf_space);
>  			/* guarantee 0 <=3D sndbuf_space <=3D sndbuf_desc->len */
>  			smp_mb__after_atomic();
> -			smc_curs_copy(&conn->tx_curs_fin,
> -				      &conn->local_rx_ctrl.cons, conn);
> +			smc_curs_add(conn->sndbuf_desc->len,
> +				     &conn->tx_curs_fin, diff_tx);

[Severity: Medium]
Does advancing conn->tx_curs_fin by the clamped diff_tx while leaving
conn->local_rx_ctrl.cons at the peer's raw cursor desynchronize the two
cursors for subsequent CDC messages?

smc_cdc_msg_to_host() has already written the unclamped cursor into
conn->local_rx_ctrl.cons.  Once diff_tx is clamped, local_rx_ctrl.cons sits
ahead of tx_curs_fin: if more data is sent and the peer advances its forged
cursor by 1 byte, diff_cons is 1 and smc_cdc_msg_recv_action() recomputes
diff_tx across the entire remaining gap between tx_curs_fin and the forged
local_rx_ctrl.cons, crediting all newly sent bytes at once (whereas a later
valid cursor below the forged cons_old yields diff_cons =3D=3D 0 and credits
nothing).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123135327.3953=
509-1-piyus@iiitd.ac.in?part=3D2
