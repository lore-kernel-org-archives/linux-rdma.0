Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794637303;
	b=VItC6vPSW3mPr1PkcUt0L7xJqLyjh5A4FP+gNumtQ5ZT1UHaAWTBBRZguvA4+clM0Aq1
	 FBaW5WPsRyiQk2AA3wjCc4kzwlkHHceASnzVCuWNsfPIjKQpolaH6GRU0u7hALXdqY6ou
	 EuI3k6aGvXW1USDJ8QSap6R6TnLLqdwZMDTS76Owo8McFAfBJ2909QL691/3SBxk+Bl08
	 NAeZqLJdBoSv05Okc0Zzfqlt+kkDpxUP8192gZp9iAEtSlHkDh/u0cBYfT3xxaOksI5vd
	 ZbucO5U7DwIi4PfIinZfS3fNV5od1nxLPl6Zc+LBht0vtnZcNMjUNqu3d7QJGY3MTSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794637303;
	h=Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=5viyWZGS4n9c+qBE/aLwmO7/aPYsv3JV1TvkOfw09wU=;
	b=zqMDuN8WUyi94W1T5GtQYa8J5Vxt0Xe54w1WDCuejx83X7/u3x/WBH/zFjNbD/cEJRrN
	 EgloWN1HmlRi8uVLLa8lHNEwZpTfAg9BA568j7ADCAX4Ovt++TbEmNYkPSekxAuQPGFFs
	 MrhWnFsVRWeUPqw+NqDxmdl3kLX406OmU+5NpbN5/XMst6yAqPdExfGIZ84M/nXvyrPh5
	 u8fDCZpj68Q0mMepd01JNIwIkYbjSWAGpXtKS4Km0bSVYedFrkFJWL6sr99li8qAqj1Sv
	 moQzArFWcdw4NAhyKdruOFHO2bIzT16QwGARUP8o8XxbocEtJyCbBet0AUOs1TFqOrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XC+gEUcA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB996606A323;
	Sat, 14 Nov 2026 06:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XC+gEUcA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70BB1F000C6;
	Sat, 14 Nov 2026 06:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794637303;
	bh=5viyWZGS4n9c+qBE/aLwmO7/aPYsv3JV1TvkOfw09wU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XC+gEUcAgljdNI9CNr8OtTIIYyToLb8c8i5IyPkEDFiavefdyg34PlOH+1wjjojvv
	 pimJRi4fB56RNROND/9Jf/LHpWVAuSuCMF3SQ3CJuypchnc65mPCxhtJhHVWkGxGnY
	 fYwzcvLt20eqdJIs1oBdQeGGur9aUundQ0BrADhe/9ZRBzseTZAj5AtuPvSfb4CPXG
	 DohCPtZD/jgQu9X5Z7/eMofYsJ+yeQtNkcz4RSzAsP9e7S9eknpX+kn240Tdx06a45
	 1WJi7gDjgJCvtQqsVyvaw2x5fD4ZCUCyEnoYcNn9sNa0FjANoxlocXPGLMsK+8QcKE
	 lf94vcPVQ3L9A==
Message-ID: <7874eba61c2ec79221496cbc43c253f9e023fa4b.camel@kernel.org>
Subject: Re: [PATCH net] net/rds: tcp: bound the message length announced by
 the peer
From: Allison Henderson <achender@kernel.org>
To: weidongw@illinois.edu
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,  Zijie Zhao <zijie4@illinois.edu>
Date: Fri, 13 Nov 2026 23:21:42 -0700
In-Reply-To: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
References: <20261111-h047-send-v1-1-2727a38dbfcd@illinois.edu>
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

On Wed, 2026-11-11 at 14:27 -0600, Weidong Wang via B4 Relay wrote:
> From: Weidong Wang <weidongw@illinois.edu>
>=20
> rds_tcp_data_recv() takes the payload length of an incoming message from
> the peer's header and queues pskb_extract() clones of the received data
> on the incoming message until that many bytes have arrived. Nothing
> checks the length, so a peer that announces h_len =3D 0xffffffff and keep=
s
> sending makes the receiver hold up to 4 GiB per connection. The clones
> are no longer on the socket's receive queue, so they are not charged to
> the socket and TCP keeps the receive window open.
>=20
> Senders are limited to RDS_MAX_MSG_SIZE in rds_sendmsg(). Apply the same
> limit on receive and drop the connection when a header exceeds it. That
> limit has been enforced on send since v4.11; a peer running an older
> kernel could still send larger messages over TCP, and such connections
> are now dropped.
>=20
> The issue was discovered by an AI code review agent (an LLM-based
> bug-finding tool developed by Zijie Zhao and the submitter) and
> confirmed by triggering it on an unmodified kernel, without error
> injection, on x86_64 under QEMU: a plain TCP client in a second network
> namespace connects to the rds_tcp listener (port 16385), sends one RDS
> header with h_len =3D 0xffffffff and then 1 GiB of payload. The receiver
> held about 1.1 GiB until the connection was closed; the same 1 GiB sent
> as 1 MiB messages held about 60 MiB.
>=20
> With this patch the connection is dropped right after the header and
> nothing is held, while the 1 MiB messages are processed as before. The
> RDS selftest (tools/testing/selftests/net/rds, rds_run.sh -T tcp, also
> with -l 10 -c 10 -u 10) passes with the patch applied.
>=20
> The reproducer, fix and changelog were drafted with AI assistance
> (Claude), then reviewed and tested by the submitter.
>=20
> Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
> Cc: stable@vger.kernel.org
> Cc: Zijie Zhao <zijie4@illinois.edu>
> Signed-off-by: Weidong Wang <weidongw@illinois.edu>

Hi Weidong,

Thanks for the catch.  This patch looks fine to me.
Reviewed-by: Allison Henderson <achender@kernel.org>

Thanks!
Allison

> ---
> Tested on v7.4-rc1 (05441d697f7f) and on net (ae89f2724e), x86_64,
> KASAN, QEMU/KVM, 3 GiB guest. Setup: rds_tcp listener in the initial
> netns (10.0.0.2); a plain TCP client (no AF_RDS) in a second netns
> (10.0.0.1) over a veth pair.
>=20
>                    1 GiB after one header     1 GiB as 1 MiB
>                    with h_len =3D 0xffffffff    messages (control)
>   unpatched        ~1.1 GiB held until close  ~60 MiB
>   patched          connection reset after     ~60 MiB, processed
>                    the header, nothing held   as before
>=20
> selftests/net/rds: rds_run.sh -T tcp and rds_run.sh -T tcp -l 10 -c 10
> -u 10 pass on both trees with the patch. No KASAN/UBSAN reports;
> checkpatch clean.
>=20
> The limit is per connection; a peer with several source addresses gets
> one connection per address. The reproducer is not attached (AI-found
> issue, see security-bugs.rst) and can be shared on request.
> ---
>  net/rds/tcp_recv.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
> index ffe843ca2..29db73df8 100644
> --- a/net/rds/tcp_recv.c
> +++ b/net/rds/tcp_recv.c
> @@ -213,6 +213,20 @@ static int rds_tcp_data_recv(read_descriptor_t *desc=
, struct sk_buff *skb,
>  			}
>  		}
> =20
> +		/*
> +		 * The payload is queued on tinc until the whole message has
> +		 * arrived, so a peer must not announce more than a sender is
> +		 * allowed to send. Check on every pass, not only when the
> +		 * header completes: the drop is asynchronous and more data
> +		 * can arrive before the connection is shut down.
> +		 */
> +		if (!tc->t_tinc_hdr_rem &&
> +		    tc->t_tinc_data_rem > RDS_MAX_MSG_SIZE) {
> +			rds_conn_path_drop(cp, false);
> +			desc->error =3D -EPROTO;
> +			goto out;
> +		}
> +
>  		if (left && tc->t_tinc_data_rem) {
>  			to_copy =3D min(tc->t_tinc_data_rem, left);
> =20
>=20
> ---
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> change-id: 20261110-h047-send-52025d442823
>=20
> Best regards,
> -- =20
> Weidong Wang <weidongw@illinois.edu>
>=20
>=20

