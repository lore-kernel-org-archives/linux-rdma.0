Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795445569;
	b=ZlXJ12VWWVcg5fs3GhGR4A4WviEhDY8ntu8YdfqCu3YKWu9SW3sKj1oUdKH1YAuWhRA3
	 bB1epaZKK5nAPgVQu3QOIaIvTU8rApdzF0KjM0tgMVQ+4Kui94auV912E1DDzRNPxEaf0
	 +7wwmiNXFWKhQBtznESHVqx5frwuyS9z/TzHayBUecTMAEv2pOmC9nifKkZsSOAmRh0h+
	 ehWIzD8LcXlkWAM4Gpspdi2IxewO2rhSH8ja69VvxMLPekFpidaSMYKTb85meDs/KIL4P
	 UnZEGsh1AXHy5v0uXLM3z02EvnRzeo6Rf7jONyRzgBQYzqP0YfRWj52vZiqjnDIKoBA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445569;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=YR35Dp1NLw39mTcwi+476hcYYIrY3mzPrCnM7jI11Vw=;
	b=vjmtonhDy0PV11u87QoQUMmkqHL4KOGqEqrz97hDB6YTow/jCuAcRJ6XXuYDSMrJEFgc
	 7ZFJDZF3ssfkZGy1lDXZIcWS4P1/ER6RTSefq2avCM0cWeEAj1BeHJpOiqrGHQWROUgsu
	 u7/HtG2JH1CI3GfWBUBJrZpnQ52Ro8O3O/tF6vBnk/zghDCzyOeJgJYVLF4dsfTIAAlv3
	 aAWld9Jn7F0pAMa0C9c1CQYjo0T0hEY0SCUfkg3c4TZ8zo4wHNjKY5Lk5g9p54BKXCK4u
	 4XcT8z1zREc7cR2bje45jg7XZwIRSAANGbR+6rC5AxlYaQthxHSambQeZWvXt5mZ0hQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mb1QjZ6O;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.53
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C275606A31F
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:52:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C275606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stellman-greene-com.20260707.gappssmtp.com header.i=@stellman-greene-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mb1QjZ6O
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-9213eb1f3a7so28614796d6.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:52:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795445568; cv=none;
        d=google.com; s=arc-20260327;
        b=lvt/OMkopRIwd9lcN+ynKmoUA7Dre2TBE6iA0CZBJxBuH4t7gefyx2Phxf+N/hWHJo
         7X7RgRweeH8iEYRx4dE9vNM17OcOiTdezXeQDul3dQMKzz8wxxuUY1CXA4zgGJFQE/z3
         bIgGin8XbnktXukYMAAS/M65/k98YTmcFU0LUwgRtuCKaMO/wnnD6fxTqAsVSIVcdu/6
         beUIlIIZWxSc48rXLht7WiHS2LO9f611k9AH9xsthjs1otxcW0wOAI1w8XuHm8PvjtaO
         yYJyQadOvTvVKGJ1ikKP2jAkBKBmI3s8Bk0sjl9yvvlgIXWcYkFQbESN8cmAZoqprR4f
         5wpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YR35Dp1NLw39mTcwi+476hcYYIrY3mzPrCnM7jI11Vw=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=iJ1ASxc38WEcbVnv3SW59W7bWU5bkCzl+h/EmF+BZFn5yGWgHfDxBNwU4oDxmOMO1M
         BBlI/wKfEUGdz7TX0hi8YTeWzW8GOwoElUQQjrrKzQjvWhHeVMxY/HckZFEISJTzT0M8
         zQzlO3NYf9SNKh5j+XOoYJASkhKitclQfAy07ahm1fX6qvm3Mq2/UuadvkLNuZst2tjl
         ENPqVIeHkpgMa8mHobq39XEEQq+kpr/X7iYsq9HOQaFBBTqb3z32EcLDQiEEX7i9K7/9
         L917TXc9Gd3zL8PqOK2oF6qYWLhStoAzI7bCP3LJuH5OCKAx7N1xMTZVYTWIA/HGARvS
         TFqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stellman-greene-com.20260707.gappssmtp.com; s=20260707; t=1795445568; x=1796050368; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YR35Dp1NLw39mTcwi+476hcYYIrY3mzPrCnM7jI11Vw=;
        b=mb1QjZ6OpdV8yjDxEnpAqG1ZgZ4Gt0gxJ9b/bB6YhKLTdc+t/4wLKmyIBvgxjbBdv8
         O3WdaC8cMbjAzNAXy4Du5cxj1sTJ7suwfN6vWjzUFi5N4tJwRSIQWbcK7jyMyrp011i4
         fhzvRZUrH+J6j4XeSOjniy2eR/THOBu8GVquM2KR6dDXGQ0f2KYDsZXycgA2ewRzf4Zu
         KSSnKcAbLwMppnBja4+kzBEMocF+h4Pld7nPwFM5C/dilt+sfalYBe6s91NL7LDA36fj
         IDyC4jWDgqhWNvI92VDdjIskaJr47JMZGcemWVncL9V5BypO77DYxbOC7J3N7nmVDupX
         7FtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445568; x=1796050368;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YR35Dp1NLw39mTcwi+476hcYYIrY3mzPrCnM7jI11Vw=;
        b=uL3cW0zPn8dqb+aZln1TjoKTUf0fjwFA4LPXjbk7uxRFK2B6O5mEC7fbcUO8speU31
         e62Ld4Gp6w8KGAHbMSZIwVJD77KoDhavAtomLyYnFUr6FlX3yD1msb7v3SwZlV9Y5o9F
         bUuQqhndu+vOu1zlyDA9LHT9pKFBHK+Pn8Zk7p5KaFD4hw+0dFd6RWi8Fcg/mAeGWZi6
         JqvAsFitADfdCwLTw/6YAaClvkl/gCBb1Zspf6TifCk6UVcjNs+L69WC9CLFmhcE29Vf
         IGHYb3/OxLqqsHJl8WRooqpP03iNndIlszxXKB3m88WSx11tUoqRvRvUbC4ZwxFTGBFj
         lAhA==
X-Gm-Message-State: APuU4Z9VfBWG/K193FWO5vKO3jjt/TTzSQLSrOA1IC4kO1FQ8Rv1Ik2e
	O59Swl37MU9gZVMgAI4jvxKRvLpnOuZzqLSyl+WSb2OfkYLerdd1cFqdv0oP6+1Rk8h5UwlDtD9
	sXBwxmnAw4O82bicRatfxtkX/eEA/0ik=
X-Gm-Gg: AZFdTZdPCy8742yh+5KXu6O2ZShmHN5RX9YwbgsY2SyEAfVbMMT2rhos9MhlzQoB6pS
	974zORNepN0iA15SoXr29KJo2Mwr2xEt6D0Q1S33HAfaEoR++qdjamuZskJUtS+et/Kh3pMo+AS
	h11kaGxajwbVxKYpF+CiFHO8HZJHlX3g6kz9Suqe23MMskFGj2F/FoKbqaPrWH2IGu06YigB1X/
	g8dzxikFCpZ3FFXRXK1cV6XwsrIEh0BVntzJt6DmZkRbF8uyEA8jZcv67ekMtYvPmqPuKAvLYLM
	lSTmDD914bxzmHecoa8oeEEumEbbw8GZyqPUJD7yD48hxQsXTjDOTRvyRAwXceDmd0XnniZw9Dd
	TCoPHIgVF3eEcD52gtPZBlp/xlhpeKThkbu6fZTzXhOhkVIaxA01aNzkMytaBkfxRqoycpQogOL
	/U0Tuj0GqULzsKQkXIUG63HI7+zlSkUT987jJJve31uOpLqupPHHVGK85PwzapVUbMWjs93UXhB
	c7mrLGZ7B5Zp0mw
X-Received: by 2002:a05:6214:ac3:b0:921:3a0b:673f with SMTP id
 6a1803df08f44-9213a0b67admr182677736d6.7.1795445567858; Mon, 23 Nov 2026
 06:52:47 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123140625.64448-1-astellman@stellman-greene.com> <sashiko-outbox-229387@kernel.org>
In-Reply-To: <sashiko-outbox-229387@kernel.org>
From: Andrew Stellman <astellman@stellman-greene.com>
Date: Mon, 23 Nov 2026 09:52:36 -0500
X-Gm-Features: Aa3M54rc4F-5TClUKcb827X9bXMXUA4uNEqDeOxn3kfSSV6VCDKaILTKwoAOCSU
Message-ID: <CAChPuV_NicbAdP74Zej1ko656Uqh2tuTrTP8P8-48DJE74nmzA@mail.gmail.com>
Subject: Re: [PATCH rdma-rc] RDMA/rxe: Fail ATOMIC_WRITE WQEs whose length is
 not 8 bytes
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks. This is already handled by a668a8564748 ("RDMA/rxe: copy send
WQE to kernel buffer before processing") in the rdma tree, which
clamps the ATOMIC_WRITE resid to 8 bytes in req_next_wqe(), so please
drop this patch.

On Mon, Nov 23, 2026 at 9:19=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] RDMA/rxe: unreachable atomic write length check in
>   rxe_requester()
> --
>
> commit 53a7ca51888beabddbfd557ad8447b0102b0d59e
> Author: Andrew Stellman <astellman@stellman-greene.com>
>
> RDMA/rxe: Fail ATOMIC_WRITE WQEs whose length is not 8 bytes
>
> This commit adds a check in rxe_requester() to fail IB_WR_ATOMIC_WRITE
> WQEs with IB_WC_LOC_QP_OP_ERR when the payload length is not sizeof(u64).
>
> > diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/s=
w/rxe/rxe_req.c
> > index 6e01fb18893bf..962aef824ccc2 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_req.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_req.c
> > @@ -824,6 +824,11 @@ int rxe_requester(struct rxe_qp *qp)
> >       mtu =3D get_mtu(qp);
> >       payload =3D (mask & (RXE_WRITE_OR_SEND_MASK | RXE_ATOMIC_WRITE_MA=
SK)) ?
> >                       wqe->dma.resid : 0;
> > +     /* use the local copies: a user QP's WQE can change under us */
> > +     if ((mask & RXE_ATOMIC_WRITE_MASK) && payload !=3D sizeof(u64)) {
> > +             wqe->status =3D IB_WC_LOC_QP_OP_ERR;
> > +             goto err;
> > +     }
>
> [Severity: Medium]
> Can payload ever differ from sizeof(u64) here when RXE_ATOMIC_WRITE_MASK
> is set?
>
> Earlier in rxe_requester(), req_next_wqe() copies the WQE into the
> kernel-private buffer qp->req.send_wqe.wqe and forces wqe->dma.resid to
> sizeof(u64) for atomic writes (added in a668a8564748 ("RDMA/rxe: copy
> send WQE to kernel buffer before processing")):
>
> drivers/infiniband/sw/rxe/rxe_req.c:req_next_wqe() {
>     ...
>         if (unlikely((wqe->mask & WR_ATOMIC_WRITE_MASK) &&
>                      wqe->dma.resid !=3D sizeof(u64)))
>                 wqe->dma.resid =3D sizeof(u64);
>         return wqe;
> }
>
> As a result, this new check is unreachable, and an IB_WR_ATOMIC_WRITE WQE
> with wqe->dma.resid !=3D sizeof(u64) will still be clamped and sent as an
> 8-byte atomic write instead of failing with IB_WC_LOC_QP_OP_ERR.
>
> Also, because this check runs after check_init_depth(), if the clamping i=
n
> req_next_wqe() is removed, a malformed atomic write WQE would consume or
> stall on rd_atomic credits before failing.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123140625.64=
448-1-astellman@stellman-greene.com?part=3D1
