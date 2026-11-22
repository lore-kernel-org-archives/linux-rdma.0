Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376046;
	b=SavoPmoxpTHCeaMaovUtfeaf2dyl/dpr3gweh6H4Zzi53137dkJg7b7bwVDxH/m/zd+m
	 LwwvlvVSAhgy+S7/FK39ChsN6/WxbjH5y/bl3qEIrHP/pcpbXi4+jmBLSXPi8s2g7x0QV
	 ZA59jQ+61IYBsPcIgj9CevLXx++AYfmNrZL2PhhyrMZxZjNPXnxuscbkyKBI1j1+NtvEe
	 PMg2lhFjMeSKp2rd4Q2cIVGI1D25S1QVNCmIJ+cgrmdxVjpHY94urYmDihFdG2NJNOyiO
	 qXGkdB+RrF3TxlLqhSSUYtIRooEIxBcQz9BxKPJe/f2Zt1nblIfTlemUvAquePZeGBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376046;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7O1AJOC6TyT8w/nD4cSAhTXrc3NCeAQaDJZ0Ti+5Ssk=;
	b=Jb2Rd8oQuLTiGfpYWT9Wtyfzcv+4iPlJ+IDX+tGIrxeUmTyItnwWUD0Qt12di72w+URN
	 P4XVGN+Z84e1JXunyQ0xk+UoHqtJq+QqIAYg3ff7i6YmpJKBVicYLzr+qedCgK5wspqJf
	 9pF4lj/U0H8gjnKrMtyg5dobbO+0P+/BoNS0Ns9E+3VvQIoRq4b4OODWp2hzzgwiGGQit
	 zyc3t5GeaAdwRym2Qih1sVm9pD832cdwUUUmL8Svz++hkPxEr02flYFxiTscYisIJgs+m
	 wismWD4DjCDf/6mF4jtephHxQv4SK4nisitfZBB/FGJh9TI290fj6pShojcJOcgjJsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nyXqH+RV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCCE606A31D;
	Sun, 22 Nov 2026 19:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nyXqH+RV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FA41F000C4;
	Sun, 22 Nov 2026 19:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376045;
	bh=7O1AJOC6TyT8w/nD4cSAhTXrc3NCeAQaDJZ0Ti+5Ssk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nyXqH+RVGfdhDQVnG9KqyUug2DksAdU2iCghHoLaERP0PANKT6/u65auoI/qqSeN2
	 hTvBEN7Vwc2m5O8JFCdGGkOd7tnhLw3f2Am5w+rkVxfW0y/glXeT7oaW1ZXroIHxrh
	 WQDmJ6CB/lvg2s/N6e8gVsVpBlgljzReHDQ6qpmeC8qDftjUax3JYN+bHv0OrNLVyh
	 NeqQLnM5yYTFYFr8K41UhmzHNGWqdGAQVkVsJXyfLlWMbbr+Rs7m9/emOX9ldL9ssM
	 tsS/oqZr2LJReFChrQmE4XXRt++zsMn0u62KG3hcjuH6GeV29/0Gja0yJu27I394up
	 p4jzxf7ReJTvQ==
Message-ID: <sashiko-outbox-228259@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: validate the peer's CDC cursors against
 our own buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Piyus Kedia" <piyus@iiitd.ac.in>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261121193345.2148966-2-piyus@iiitd.ac.in>
References: <20261121193345.2148966-1-piyus@iiitd.ac.in>
 <20261121193345.2148966-2-piyus@iiitd.ac.in>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 19:34:05 +0000
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
- [Critical] net/smc: incomplete cursor validation in
  smcr_cdc_cursors_invalid()
- [Medium] net/smc: off-by-one cursor bounds check in
  smcr_cdc_cursors_invalid()
--

commit a56e3215d9b6d4c759609c097e5d65fd47a70a6a
Author: Piyus Kedia <piyus@iiitd.ac.in>

net/smc: validate the peer's CDC cursors against our own buffers

This commit adds smcr_cdc_cursors_invalid() in smc_cdc_rx_handler() to
check incoming CDC producer and consumer cursor counts against the local
RMB length and peer RMBE size before processing the message.

> diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
> index 32d6d03df3214..03ff10fef7da6 100644
> --- a/net/smc/smc_cdc.c
> +++ b/net/smc/smc_cdc.c
> @@ -466,6 +466,26 @@ void smcd_cdc_rx_init(struct smc_connection *conn)
> =20
>  /***************************** init, exit, misc ************************=
******/
> =20
> +/* A peer's cursors are offsets into OUR buffers: the producer cursor co=
unts the
> + * bytes it has written into the RMB we gave it, the consumer cursor the=
 bytes it
> + * has taken from the RMB it published to us.  Nothing else checks them.=
  smcr_cdc_msg_to_host()
> + * copies both into the connection, and from there smc_cdc_msg_recv_acti=
on() adds the
> + * producer difference to conn->bytes_to_rcv and the receive path uses t=
hat as a
> + * length - so a peer that reports more than the buffer holds makes the =
kernel read
> + * past it.
> + */
> +static bool smcr_cdc_cursors_invalid(struct smc_connection *conn,
> +				     struct smc_cdc_msg *cdc)
> +{
> +	if (!conn->rmb_desc)
> +		return true;
> +	if (ntohl(cdc->prod.count) > (u32)conn->rmb_desc->len)
> +		return true;
> +	if (ntohl(cdc->cons.count) > conn->peer_rmbe_size)
> +		return true;

[Severity: Medium]
Should these two bounds checks use >=3D instead of >?

SMC cursors are 0-based offsets modulo the ring size: smc_curs_add() wraps
curs->count to 0 and increments curs->wrap as soon as curs->count >=3D size,
so a valid cursor never has count equal to the buffer length.

If a peer sends cdc->prod with wrap =3D W and count =3D conn->rmb_desc->len,
consuming those bytes advances conn->rx_curs_confirmed via smc_curs_add()
to wrap =3D W + 1 and count =3D 0 while conn->local_rx_ctrl.prod stays at
wrap =3D W and count =3D len.  In smc_tx_consumer_update(),
smc_curs_diff_large() then sees old->wrap > new->wrap, takes the 0xffff ->
0x0000 wrap-around branch, and returns conn->rmb_desc->len instead of 0.
On sockets without SOCK_URGINLINE, an urgent cursor at wrap =3D W and
count =3D len similarly causes smc_rx_recv_urg() to compute a difference of
2 * len against the wrapped consumer cursor and erroneously set
conn->urg_rx_skip_pend =3D true.

> +	return false;
> +}

[Severity: Critical]
Can a peer still push conn->bytes_to_rcv past conn->rmb_desc->len and
trigger the same out-of-bounds read in smc_rx_recvmsg() by advancing
cdc->prod.wrap?

smcr_cdc_cursors_invalid() checks only cdc->prod.count and
cdc->cons.count, ignoring the wrap counters and the bytes already queued:

net/smc/smc_cdc.h:smc_curs_diff() {
	if (old->wrap !=3D new->wrap)
		return max_t(int, 0,
			     ((size - old->count) + new->count));

	return max_t(int, 0, (new->count - old->count));
}

If prod_old is at wrap =3D 0, count =3D 0 on a 64 KiB RMB and a single CDC
message arrives with prod.wrap =3D 1, prod.count =3D 65535,
smcr_cdc_cursors_invalid() accepts it, smc_curs_diff() returns 131071, and
smc_cdc_msg_recv_action() adds that to conn->bytes_to_rcv.  A peer can
also send multiple CDC messages that increment prod.wrap before userspace
drains the buffer, accumulating arbitrary values in conn->bytes_to_rcv
(and similarly inflating conn->peer_rmbe_space past conn->peer_rmbe_size
via cdc->cons).

When smc_rx_recvmsg() then runs with copylen > conn->rmb_desc->len, its
first chunk is clamped to conn->rmb_desc->len - cons.count, but the second
chunk copies the unclamped remainder copylen - chunk_len starting at
rcvbuf_base + 0, reading past the end of the RMB into userspace.  In
addition, smc_rx_update_consumer() passes copylen > conn->rmb_desc->len to
smc_curs_add(), which subtracts size only once and leaves
conn->local_tx_ctrl.cons.count >=3D conn->rmb_desc->len.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121193345.2148=
966-2-piyus@iiitd.ac.in?part=3D1
