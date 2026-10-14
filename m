Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734BF48F82B;
	Wed, 14 Oct 2026 20:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792008786; cv=none; b=evY4VTgkeN2JnUj1z+K2TYs/h+Sqxs03J2x4w6NglC6Z3vbLIYmDIy/sEfdsXqj0TavXXgXtVWCbiq8YSaRJNoq5/26FLTponUWjTfBX1EqJyPKcXyZKlmHgOmn0F3CFZ8i9hgvsinHRipC15tj/e+Lwt1NAXr4cqHBQsI4114Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792008786; c=relaxed/simple;
	bh=GIFVDql/ai0ZBa5z5UjlpQ1A8/t6dphkRFBpECuqTHI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XKV3cVVsDBkPxYrrb0L/We832xaTXbDRDntZL54tYiC+xP8C5rMrzNqtKCs+pQpwqrMI0CcgChcHXn8MhmIL26xxS8DR/G8zjPeLj+TEQw8vxlYAxunaz7yRP1LjGJevEwgvdvs+7985dFGizaFLOX6sm/bomeOx44RBz3pU7fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfVHG864; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfVHG864"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872AA1F000C5;
	Wed, 14 Oct 2026 20:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792008774;
	bh=yoieG2xtzmkUWK+b/AZnps7H1FErXTJ4CyjCpRBt5EI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bfVHG864/Uh5sDDSPnP23R4y4xz7MIP6aiXA1GWg54cUUs+qYMUZxSstz1a6msHD3
	 1n/Glb6jnYWsJga/+tvGReAbQS4X7mQzErfK8ys8HZIFyQEmgXej4nZrg99waQpzP1
	 O1X5WrLA3+PGstPSX8OLSOZsgAOiHaSO/ZGY7SV7cgL1T6EPiVOsO7Ul6CLvVqIOwq
	 KB5JyhBNTW/2EsVo1pC4tAJZQzr/5ku1HEXwgz9VWc7eizr45Lm99speEgpbTHGR2o
	 RUkWw84sKTfVjJDoszSGyqZut8zb9eS8rl63iiXy2OEzV3ak+x2xUbFBt7M/bGISNL
	 S1sWn38XIJLXg==
Message-ID: <sashiko-outbox-171844@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v7 3/4] net/smc: bound the send length to the send
 buffer in smc_tx_sendmsg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261013-b4-disp-f345196c-v7-3-ef3dddfbfa68@proton.me>
References: <20261013-b4-disp-f345196c-v7-0-ef3dddfbfa68@proton.me>
 <20261013-b4-disp-f345196c-v7-3-ef3dddfbfa68@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 20:12:54 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] smc: flow control bypass and data corruption on negative sndbuf_sp=
ace
--

commit 44a09d8e6fd4a65a3a6817c2d3b58d4da753540a
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: bound the send length to the send buffer in smc_tx_sendmsg()

This commit limits the writespace to the size of the send buffer descriptor
to prevent writing past the send buffer when sndbuf_space exceeds its
bounds. It explicitly maps negative writespace values to the full buffer
length.

Cc: stable@vger.kernel.org

> diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
> --- a/net/smc/smc_tx.c
> +++ b/net/smc/smc_tx.c

[ ... ]

> @@ -233,6 +233,14 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msgh=
dr *msg, size_t len)
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after smc_tx_wait above */
>  		writespace =3D atomic_read(&conn->sndbuf_space);
> +		/* sndbuf_space can be out of range: late completions of an
> +		 * old SMC-R link credit it again after a failover, and with
> +		 * SMC-D DMB merge it follows the peer's consumer cursor.
> +		 * Bound writespace, which sizes the copy; a negative value
> +		 * would become huge in the size_t min_t() below.
> +		 */
> +		if (writespace < 0 || writespace > conn->sndbuf_desc->len)
> +			writespace =3D conn->sndbuf_desc->len;

[Severity: High]
Does this mapping of negative writespace to the full buffer length bypass
flow control and overwrite unacknowledged data?

When sndbuf_space becomes negative due to over-credits, the earlier check
in smc_tx_sendmsg() for !atomic_read(&conn->sndbuf_space) will evaluate to
false, which completely skips smc_tx_wait().

By then forcing the negative writespace to conn->sndbuf_desc->len, the loop
will copy up to the full buffer length over unacknowledged data.

The subsequent atomic_sub() later in this loop will drive the space even
further negative, creating an unthrottled copy loop until the user message
is exhausted.

Could we handle negative values by treating them as zero to properly wait
for space, rather than mapping them to the maximum buffer length?

>  		/* not more than what user space asked for */
>  		copylen =3D min_t(size_t, send_remaining, writespace);
>  		/* determine start of sndbuf */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-b4-disp-f3=
45196c-v7-0-ef3dddfbfa68@proton.me?part=3D3
