Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D463EB0F7;
	Tue, 22 Sep 2026 06:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059581; cv=none; b=XB003bTdTYuFSXzYb3lk85tdzKGS0EsBLQX72nBB9dbNB0kiw0cY544W2Egfa8lSW76UN1PgskAMUu9PbxnQrB8ikK7YdjAmZeXvaT9Ic0cZoHfSa8LOxdYT8za75crKhFk/TlXEyMFgVAoQL3gnb0NzzjnWeedyOhIHZ8jZu7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059581; c=relaxed/simple;
	bh=HiLAUlk7tp4IKxyU2eei1MfApC4m812B/TJuAW+00C0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PvDlyZdzEy42aT1XTEqZG0+HEIqLzS0DVnJRTOTu98RQ/5M+fbRF/jy11W1xiSpaf8SFFBwJENAcwpZ6EuASIn//5zElL0zlGK570d3CZONQDLyPq5+9Biry2XG1VuPJaZUJPlC6topiVAObpHtxHdBqk/kImdaX+T7zZWvTmCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsMF0hks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsMF0hks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A11E1F000FF;
	Tue, 22 Sep 2026 06:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790059580;
	bh=JoYNk54DolH7u5h/eDEws4Flazl5+JKTFfpxG7rlqjs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JsMF0hksnW4BoKtkXHEJGVuBXvkcurW19X8cP/po2JYYKHeW8yIhTaDaGfsup1Mps
	 g6Z3j5kQkRvxoIrRTNc3mLHewRn6j0MQDrAeG3xZHf1FJOgNkDhj3S0wTG6xGU9wQ3
	 +jLouA0DBOJ8nGu/M3kE8c8TRtm5aQ7HV/SQCZt9CsUup0Ib8I4pwy8DdKq0siiU/E
	 E8/gCuO71qzUn1mSrKm4fpRlmfYuuGK89SUdLgDlGkvfB15fAGZyhXgw/XAJkePbwa
	 OcDNQs6PkZLisTUtNF4N7q2AMCvwnaFmy4i+70jJ3YRBf+4Ojh/qkUrfDocX1KGXH3
	 qq/FIvJY/GadQ==
Message-ID: <620b8a46421cc1f1f94890dd541ddf54d351c459.camel@kernel.org>
Subject: Re: [PATCH] net/rds: fix incoming message refcount leak and header
 bounds check in rds_recv.c
From: Allison Henderson <achender@kernel.org>
To: Hui Peng <benquike@gmail.com>, davem@davemloft.net, edumazet@google.com,
  kuba@kernel.org, pabeni@redhat.com, horms@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Date: Mon, 21 Sep 2026 23:46:18 -0700
In-Reply-To: <20260919223429.3882046-1-benquike@gmail.com>
References: <20260919223429.3882046-1-benquike@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-09-19 at 22:34 +0000, Hui Peng wrote:
> In net/rds/recv.c, ensure incoming RDS message references (rds_inc_put)
> and socket receive queue bounds are properly balanced when handling
> error or truncated incoming frames.
>=20
Hi Hui

Thanks for the patch but this description doesn't seem to quite describe th=
e code.
I don't see any new puts, or a leaked reference.  I'm presuming there must =
have
been a mistake of sorts?

Allison

> Fixes: bdbe6fbc6a2f ("RDS: recv.c")
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90a..0743706af8ca 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -637,8 +637,10 @@ static int rds_cmsg_recv(struct rds_incoming *inc, s=
truct msghdr *msg,
>  		for (i =3D 0; i < rs->rs_rx_traces; i++) {
>  			j =3D rs->rs_rx_trace[i];
>  			t.rx_trace_pos[i] =3D j;
> -			t.rx_trace[i] =3D inc->i_rx_lat_trace[j + 1] -
> -					  inc->i_rx_lat_trace[j];
> +			if (inc->i_rx_lat_trace[j + 1] &&
> +			    inc->i_rx_lat_trace[j])
> +				t.rx_trace[i] =3D inc->i_rx_lat_trace[j + 1] -
> +						inc->i_rx_lat_trace[j];
>  		}
> =20
>  		ret =3D put_cmsg(msg, SOL_RDS, RDS_CMSG_RXPATH_LATENCY,

