Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C72AF1D;
	Fri,  9 Oct 2026 06:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526368; cv=none; b=Kdhx1pr57h0BsR2y4tjkOfF7sRIBbfBd9hf15fT+uI4GSDFqFJ9nc47mXZAcmagBA/UGhVegUUONqRbfNy/e6LFS/To8P9k9xBDbkOe++ZxrJhBF+YccQ9sRiWcZ/vl1wmlQTxEKTPtKgJikJmd18H2nOe0GPAfzjPS9AoDFJlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526368; c=relaxed/simple;
	bh=mHormuMidPM9NH13awdDvQsQdUKBYk1O9yByao+3dCM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lIynK73LRPZ5WX2o6+FpQ3V6VWtS0DVMcFcKdUT5adiUliOqvkqODf4Ld1qMz7+nNEA0vpMUIYa3QsI+EZvVBlTa1XyuCSxwslYc6gTBcQkgoHfOCj2iGOIRckVnCwaQIHbNvXF7ODHK5D/4hMwFbYva7PURp2g12ZaPOyZxVjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXFEdr/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXFEdr/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736F01F00898;
	Fri,  9 Oct 2026 06:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526366;
	bh=AkmV9+K4FRoynwgf24XD0dP9A3SMiZARsqRhONlg9lA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VXFEdr/5b3GVsIcDTSGqMVO94FwSA/1qa+GnUmbKbx5gG9X6b+id3BkHbzN6xblYq
	 pNOG4hiD0SYO/rgwkL1+i+sT+O5ncCykK879DpZKIq0IUfMO87ytpwv1+4FNE2fmAT
	 gBBeGB9TaGAoF66FFt8Iac6q7H+LfYcnrlGdTBgliSvb+gjFXYsAoFNJiazg3eYtZi
	 DM3PBlp2I4R/H1o3ezfSnqB2kIAxy3kFgeytC3wC5tKajA272T7tOA5eas/IaY18iX
	 SXIEHmoqtifBiHAiyyQFrmASFmyEKhVIWaxMIRNsyU/6mZLvAtAYXFLs7U4dx5ypOw
	 t1uC2dqtMLD3g==
Message-ID: <sashiko-outbox-164918@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v6 2/3] net/smc: bound the receive length to the RMB
 in smc_rx_recvmsg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-disp-f7cd3d96-v6-2-fba616c0920c@proton.me>
References: <20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c@proton.me>
 <20261008-b4-disp-f7cd3d96-v6-2-fba616c0920c@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 06:12:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] net/smc: OOB read in smc_rx_recvmsg due to MSG_PEEK/splice offset =
accumulation
- [Low] net/smc: invariant violation by subtracting from negative bytes_to_=
rcv
--

commit aad1c57ecb0dbd6966f102b6de4c64311cbb32d2
Author: Bryam Vargas <hexlabsecurity@proton.me>

net/smc: bound the receive length to the RMB in smc_rx_recvmsg()

conn->bytes_to_rcv is accumulated in the receive tasklet from the peer's
wire-controlled producer cursor via smc_curs_diff(), whose
differing-wrap branch can exceed rmb_desc->len; a forged cursor drives
bytes_to_rcv past the RMB, and over many CDC messages overflows the
signed counter negative. smc_rx_recvmsg() reads it as the readable
length and does a wrap-around copy whose second chunk is not re-bounded
to rmb_desc->len.

> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 197fddc6271f0..f781d7229185c 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -442,6 +442,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msgh=
dr *msg,
>  		/* initialize variables for 1st iteration of subsequent loop */
>  		/* could be just 1 byte, even after waiting on data above */
>  		readable =3D smc_rx_data_available(conn, peeked_bytes);
> +		/* bytes_to_rcv is accumulated from the peer's wire-controlled
> +		 * producer cursor; a forged cursor can drive it past the RMB,
> +		 * or overflow the signed accumulator to a negative value across
> +		 * many CDC messages (which a plain "> len" check would miss
> +		 * before the size_t cast below turns it huge).  Bound it to the
> +		 * RMB in either case so the wrap-around copy cannot run past
> +		 * rmb_desc->len.  This enforces the documented
> +		 * 0 <=3D bytes_to_rcv <=3D rmb_desc->len invariant at the consumer,
> +		 * race-free against the producer update in the receive tasklet.
> +		 */
> +		if (readable < 0 || readable > conn->rmb_desc->len)
> +			readable =3D conn->rmb_desc->len;

[Severity: High]
Does this code introduce an out-of-bounds read due to MSG_PEEK or splice
offset accumulation?

If bytes_to_rcv is inflated by a forged cursor to a value much larger than
rmb_desc->len, readable is clamped here. However, MSG_PEEK accumulates
peeked_bytes and splice() accumulates splbytes across loops.

These accumulated values are added to the local cursor using smc_curs_add():

net/smc/smc_rx.c:smc_rx_recvmsg() {
	...
		if ((flags & MSG_PEEK) && peeked_bytes)
			smc_curs_add(conn->rmb_desc->len, &cons, peeked_bytes);
		/* subsequent splice() calls pick up where previous left */
		if (splbytes)
			smc_curs_add(conn->rmb_desc->len, &cons, splbytes);
	...
}

Because smc_curs_add() only performs a single wrap-around subtraction:

net/smc/smc_cdc.h:smc_curs_add() {
	...
	curs->count +=3D value;
	if (curs->count >=3D size) {
		curs->wrap++;
		curs->count -=3D size;
	}
	...
}

If peeked_bytes or splbytes exceeds 2 * rmb_desc->len, cons.count
fails to wrap completely and remains >=3D rmb_desc->len.

This causes the bounds check calculation to underflow into a huge size_t
value, bypassing the checks and copying out of bounds:

net/smc/smc_rx.c:smc_rx_recvmsg() {
	...
		chunk_len =3D min_t(size_t, copylen, conn->rmb_desc->len -
				  cons.count);
	...
}

[Severity: Low]
Does this clamp completely repair the invariant for bytes_to_rcv?

While readable is clamped to a positive value here, atomic_sub() is later
performed on the underlying bytes_to_rcv counter using copylen (which
is derived from readable):

net/smc/smc_rx.c:smc_rx_recvmsg() {
	...
		/* update cursors */
		if (!(flags & MSG_PEEK)) {
			/* increased in recv tasklet smc_cdc_msg_rcv() */
			smp_mb__before_atomic();
			atomic_sub(copylen, &conn->bytes_to_rcv);
			/* guarantee 0 <=3D bytes_to_rcv <=3D rmb_desc->len */
	...
}

If bytes_to_rcv was already driven negative by a forged cursor,
subtracting a positive copylen from it drives the atomic counter further
negative. This seems to violate the 0 <=3D bytes_to_rcv <=3D rmb_desc->len
invariant that the patch explicitly claims to guarantee.

>  		splbytes =3D atomic_read(&conn->splice_pending);
>  		if (!readable || (msg && splbytes)) {
>  			if (splbytes)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-disp-f7=
cd3d96-v6-0-fba616c0920c@proton.me?part=3D2
