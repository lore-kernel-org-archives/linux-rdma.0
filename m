Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487481C861D;
	Wed,  7 Oct 2026 01:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335600; cv=none; b=GbdhcR3NPJyOzJMPkdOitQAxAV8gaN5+DFfbxZm/y18egWwdjvy0ZNzLf/H2lz0CHG2vJ4jcF5YSsp+cmGgfHTF0ACoiDKBXMdv+xbYO2794gVCf97PfNywMqSp40dsdO6r5bjEZHQ18QCijb+GvKURhIaSKBiqcQZY7ZYG83yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335600; c=relaxed/simple;
	bh=DBFA5sFC9WD+opKlW7ITYJCAfHENnpaiqVEyIAbo2BQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nsl7Kbl8tEhW47ZD5goO9hdIWYtT9Ehg1iBgp2yc9Av9xNDWGVnQ7Dc8EbNffjYtqd04i/887jOkCveDDZt3L6yCCxrkVBwGB+uZggQ+Sz3eMR8kdKaixQqP+T6DwYMdKPfYSVcLbkH64djKetmnSmhJ2Ack+Ttu81Fr8AO/AsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbiTx7b5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbiTx7b5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573361F0089B;
	Wed,  7 Oct 2026 01:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335598;
	bh=qjyKuDRA86Hk/S2fjOT5ttpFNeWmESp7ej6Do7qKEUQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=RbiTx7b5M3wwKXtYVAXET5krPtmPJM+sCxjwAfCox8DNFG96mj24oc0GAUq23xNgt
	 OMLzkfnuQz4oebYTQylWcA2Q6dZS7GrOLcixh9Kdw72k0NUOJQoyTNJC6MU6aeBsad
	 sAIppy1iP3Z4sd6sJpT6Qno+bE3+sUJUPq+2YDuRfpukMymrYhbeT9BxgOYKCQoNYq
	 RxZNlrEQFm852jGifXLqbmYnhOSqcc1UT9/2jcoyNIwfaTzwfXOLhvrtTLTq+7ukZp
	 sy4BZM72XVnv6XhottcVuPh6rGdJjLrsqB7/oWThxRA4Mg5Mv4XLNW4w8XKmbvsvzQ
	 ynxWaGqPfk9kw==
Message-ID: <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
Subject: Re: [PATCH net] RDS/IB: validate receive completion payload length
From: Allison Henderson <achender@kernel.org>
To: sungbyeongchan <tjdqudcks0424@naver.com>, "David S . Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>, Andy Grover <andy.grover@oracle.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Tue, 06 Oct 2026 18:13:17 -0700
In-Reply-To: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-10-07 at 05:52 +0900, sungbyeongchan wrote:
> An RDS/RDMA peer can declare a fragment length larger than the payload
> reported by the receive completion. The receive path attaches the recycle=
d
> receive fragment without validating those lengths, allowing recvmsg() to
> return stale bytes beyond the actual payload.
>=20
> Validate data_len against the expected current-fragment length before
> transferring fragment ownership. Disconnect and reconnect on mismatch.
>=20
> The issue reproduced in two clean QEMU boots. A peer declared 4096 bytes
> while posting only 16 bytes, and a receiver under a different UID obtaine=
d
> 4080-byte tails from prior messages in all 256 attempts in each boot. Wit=
h
> this change, the malformed message was not delivered, reconnection
> succeeded, and a subsequent normal 4096-byte message was delivered intact=
.
>=20
> Fixes: 1e23b3ee0e94 ("RDS/IB: Receive datagrams via IB")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: sungbyeongchan <tjdqudcks0424@naver.com>

Hi Sungbyeongchan,

Thanks for sending this, and for following up on the earlier feedback so
quickly.  However, I realized after I sent it that another contributor had
already publicly sent an equivalent fix earlier today, and the convention i=
s
to take the first correct patch on the list.
https://lore.kernel.org/netdev/20261006125720.81227-1-shubham@octane.securi=
ty/

So no need to follow up with the sashiko review, and I apologize for the
miss-communication, but I will ask your Reported-by tag to be applied since=
 you
were the first to report the same bug. This was a solid find, and the repro=
duction
was very well done. Please continue to send RDS fixes as you find them.

Thank you!
Allison

> ---
>  net/rds/ib_recv.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index bd6cb3ffaa571..0daddb108c8a7 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connectio=
n *conn,
>  		}
>  	}
> =20
> +	if (data_len !=3D min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
> +		rds_ib_conn_error(conn,
> +				  "incoming fragment payload length %u, expected %u; "
> +				  "disconnecting and reconnecting\n",
> +				  data_len,
> +				  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
> +		goto done;
> +	}
> +
>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>  	recv->r_frag =3D NULL;
> =20

