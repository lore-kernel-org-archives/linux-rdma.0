Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD03B995E;
	Thu, 15 Oct 2026 02:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030513; cv=none; b=uLiBcrQNYcFF3SVwva0Gu1HATBhfMg3AyG2p0RFEo2axRFEF81Fwmu5Yt7WQzMhaO3n+jY5aDaSD49qA07ULIzeuC2kaVyUREcfBTGdCQj7EAZW+JTJ77IBniRBsWSmbj4aGfdrrzuJI3mzQtDMOpWB4+q/eZ+ppRqCmi5bQD/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030513; c=relaxed/simple;
	bh=nC+Ea8VuZ9s/+ylbktqMK3Faszr0wVmFAFNiGBbdnGQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K3+oJcZklJ4zljCYJcCWUFYO8Qoh4KPFHFvEbBOil9JZOIbA9H7Sok1503eA4YC6QzV0c5wsX9VAyhKPRb1YONHa0dPvbz6XKmhwKdjqtJuul/GSL7/rB9BSSTZWo7xqZENiWCdgmSmB/vZVVFqhmS+s432srDmWaHOUI25BCNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLKTo0dF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLKTo0dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6031F000C4;
	Thu, 15 Oct 2026 02:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792030511;
	bh=+rXf/xKMRpoP2YDqUubFyOYnj4r2y2GwZMRV5dIrDGg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=NLKTo0dFxGsWNzHpSl2OQ2luouswLzOdwtk9AnHnvstPmwFTCX3ieaNOKmKkMWC4q
	 C5t5S1IdQADX1K+gZm3sPg0WV7Pyfw1N+Nkx88jmTyMAnCNVtdSxTTehSh+A6CNirR
	 6EmaA19yWRott3XaK8MoVwjZMvy5RgFkd2ScUyzYBeUzoLbJ12WYvukBG4vPkfFRnH
	 I/HCjCwDrFVtnSRbHs7KaJmkjmuoiaQQgELsfDWOHdLDDZEuFEYokvOTK/2gXKD9dR
	 ElnWpyLwsAlnRefG2rOe+4kj6Tj0UA2Llv+YnhFU2Fxs6kTwEvURuO5iokFXJq5jXf
	 /bhU3j/tfZxiw==
Message-ID: <b5d28ed79b3d7039aadeb445b62882cf3e970c7a.camel@kernel.org>
Subject: Re: [PATCH net v4] RDS/IB: validate receive fragment completions
From: Allison Henderson <achender@kernel.org>
To: Shubham Antil <shubham@octane.security>, netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com,  horms@kernel.org, andy.grover@oracle.com,
 linux-rdma@vger.kernel.org,  rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, gio@octane.security,  sungbyeongchan
 <tjdqudcks0424@naver.com>, Robert van Eijk <robert@octane.security>, Paolo
 Gentry <paolo@octane.security>, stable@vger.kernel.org
Date: Wed, 14 Oct 2026 19:15:09 -0700
In-Reply-To: <20261013025729.40815-1-shubham@octane.security>
References: <20261013025729.40815-1-shubham@octane.security>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-10-13 at 08:27 +0530, Shubham Antil wrote:
> rds_ib_process_recv() accounts every receive fragment as contributing
> min(i_recv_data_rem, RDS_FRAG_SIZE) bytes, regardless of the completion
> length. When a completion is shorter than the header-declared amount,
> receive accounting can advance beyond the payload supplied by the
> completion.
>=20
> Only an IB_WC_RECV completion has the buffer layout expected by this
> receive path. Other successful completion opcodes must not be interpreted
> as ordinary receive completions.
>=20
> Reject successful completions with any other opcode before processing
> their length. For ordinary receive completions, require enough payload
> to cover the amount accounted to the fragment before linking its page
> into the incoming message.
>=20
> This is compatible with the current transmit paths. MSG_ZEROCOPY is
> restricted to RDS/TCP, while RDS/IB copied and page-vector messages use
> full-sized non-final scatterlist entries.
>=20
> Found during an LLM-assisted source audit and validated under KMSAN with
> a malformed short receive completion.
>=20
> Reported-by: sungbyeongchan <tjdqudcks0424@naver.com>
> Closes: https://lore.kernel.org/netdev/20261006205204.1322102-1-tjdqudcks=
0424@naver.com/
> Reported-by: Giovanni Vignone <gio@octane.security>
> Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207=
e204.camel@kernel.org/
> Reported-by: Robert van Eijk <robert@octane.security>
> Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207=
e204.camel@kernel.org/
> Reported-by: Paolo Gentry <paolo@octane.security>
> Link: https://lore.kernel.org/netdev/8a6ee1d5336ae65b8ffdc8c40a1135657207=
e204.camel@kernel.org/
> Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM (OpenAI Codex, gpt-5.6-sol)
> Signed-off-by: Shubham Antil <shubham@octane.security>
Thanks Shubham,=C2=A0

This version looks good to me. I also tested it and found no regressions.=
=20
Reviewed-by: Allison Henderson <achender@kernel.org>
Tested-by: Allison Henderson <achender@kernel.org>

Thank you!
Allison

> ---
> Changes in v4:
> - Reject malformed short fragments instead of normalizing their length.
> - Reject successful non-IB_WC_RECV completions before trusting byte_len.
> - Explain why MSG_ZEROCOPY cannot reach the RDS/IB transmit path.
> - Add the source-audit and KMSAN discovery details.
> - Remove the author's self-Reported-by while retaining linked reporters.
> - Leave maximum h_len validation to a separate investigation.
>=20
> v3: https://lore.kernel.org/netdev/20261008124940.13371-1-shubham@octane.=
security/
> v2: https://lore.kernel.org/netdev/20261007062135.49946-1-shubham@octane.=
security/
>=20
>  net/rds/ib_recv.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa..aa50b85b0f 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -949,6 +949,12 @@ static void rds_ib_process_recv(struct rds_connectio=
n *conn,
>  		}
>  	}
> =20
> +	if (data_len < min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
> +		rds_ib_conn_error(conn,
> +				  "fragment shorter than header-declared length; forcing reconnect\n=
");
> +		goto done;
> +	}
> +
>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag =3D NULL;
> =20
> @@ -1004,7 +1010,12 @@ void rds_ib_recv_cqe_handler(struct rds_ib_connect=
ion *ic,
>  	 * event is processed.
>  	 */
>  	if (wc->status =3D=3D IB_WC_SUCCESS) {
> -		rds_ib_process_recv(conn, recv, wc->byte_len, state);
> +		if (wc->opcode !=3D IB_WC_RECV)
> +			rds_ib_conn_error(conn,
> +					  "recv completion had unexpected opcode %u, disconnecting and reco=
nnecting\n",
> +					  wc->opcode);
> +		else
> +			rds_ib_process_recv(conn, recv, wc->byte_len, state);
>  	} else {
>  		/* We expect errors as the qp is drained during shutdown */
>  		if (rds_conn_up(conn) || rds_conn_connecting(conn))
>=20
> base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e

