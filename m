Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795688570;
	b=fY53UbzFt54YVvM2OBAEtCtUBwz4nR+/cA5o8E35RE6JC3sVnl7WGMauzWxvgBeIMKVX
	 IdOMx/501Gdy3AoR1jI5jJFXMOON98Q8unLHj+qCED0NyqdNyvIg8e2/1CelOKIhpsUph
	 32AAgvSzQiHjdEaypHQ9EUum31oxTmBOiGqdXXGjT933daa2FfOIAV+x4JJzCG/ts4Pq/
	 ci44xo/o+ClAg7lesxebPrSL59wSwkJ1G5zvcPSM/sWnqlPJY15mnldbGGGDwzJ0cY5ku
	 NNHL0roHR8bOytfYZrI5jLKyiwirCUjcAKeoP1cbE60+r139EcTTvpcgsS0Bhvk5HHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795688570;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=ddV3AyM6dDP89kTV9C7uTPYK6u/O0e8Sk1//pYBvMLk=;
	b=dDgrVxf+T+OGY4lGOtw2DNmmgWf71MBVMmhlpRQ5CxdrGI9mnDYzHWaYzBigRuYTgiPx
	 S+zBaAUQz2DIANoQHuW2qOsth2byWv10+I14rCOs0DbD+TsnAFCwFBRrMwFSD6gHU1IHs
	 11c1ED+XVicHHfMsVenSZdJAeUbpPzoxPl+1wNQMqWPnOyfzlPj7t3UpeBn3hjpC8pUm/
	 dTWzouu/car13pK15wRTeE57PyMjT3X6nLkDaB9yQrMZdSXw68wj4JQizSJ+dgX5uvKJi
	 UMMkDqnaLvHEJWzRZmEC+SuvWVKQxAxwpqgcOL9RdhnLZhMhlG44zwIpW0v1G96Xl1Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TGUMlgXV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B771A606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 10:22:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B771A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TGUMlgXV
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb8ecdcbb8so5022145e9.2
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 02:22:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795688568; cv=none;
        d=google.com; s=arc-20260327;
        b=dk/SvVvL7d35Dv/wEodQNc9tV3l57fn4XXaD31q9ohUP0q1oovjVd9WkAOLhdovz4k
         ghvGkCtSNi/Uf2k0ee/qp123R2wnlVHcKuwn0VIIAp80VoFvagwHkss+AqYdZBLwGz2v
         ew663UV75yhI0AeNCODIg0WILO1Xn4j9FhveR7yJR3JMBk+Exb+gr84/XkGJ4hegnqvk
         UftZiKaX0omLmGUVtqoCZTZQzDMx3jlaDI00vdW6qhqLouXW6J+BVP5FVxHXDzb1kxHQ
         /S5dP5ZRQDRaRakdvzoeqwoV3kaKmysbfXiuvya17j5+0h58hd4VjNjw9ObcCJPiRSy7
         06HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ddV3AyM6dDP89kTV9C7uTPYK6u/O0e8Sk1//pYBvMLk=;
        fh=mMozUUn1lnEKUl0fxMFi/GxRnQ7tHyvW9zbiO/RxI98=;
        b=KSXJeyJRpDuh4x6HxJd3qPs0O3k8TAnrhUuA6iDqyXjpF216FZ82GqWrc3ysntrJAl
         AprV23v19ewL5X2ZZIoYfdceYwdxqWvitdA9iwb7jCAa7oXR8ZjD9h8NtQXRx0/EvNNL
         RKBPLg+HB2PBrIqQGqMLHBvT7IBBRtBKL/nkPLSU7foJu6W0/Imh90FNwhFq8lbDkcJP
         kMSHpsmb76mpIc9c77G9UbNzulv6nbiNbo5l3mspLdZGX5z9oH2huc/8v3tktr5eQvNx
         qAWg4yJl3RcRwrGKlkif4ZYYmQsakNmYNLUIhLuARpPiVT+9whPwnNmxM21W0x847Z8i
         kD3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795688568; x=1796293368; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ddV3AyM6dDP89kTV9C7uTPYK6u/O0e8Sk1//pYBvMLk=;
        b=TGUMlgXVvhvgTgKqqOO9T59oQrRiNo0oHvANZmmDaiIfPFIZCFKt6gH7lgmVjaNlPA
         Bw2keeY5uu4Lh03FAI9hlaaLr3pbZ4HwbgT0Tz//KnlqEPDenLdAY5XH+TqDav+ui4nK
         qiLGnTzOTt55HD8cT++ShrMRfaL1nade3B+LdVNKt/rU+lkCz3tRosdSn4cHYTd/khMM
         TsSSpt51wrzLQL4uiLNChgp1idZyBDZGCJXvMyiLft72ABw5cC4ecafNAWljwzj3BB/n
         KAtzMgEQqP+hXB+l5zryXszTOGvDV50C1LlJaSXqViBHHdGODNHtCThwnF1oijPJuxOV
         uINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795688568; x=1796293368;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ddV3AyM6dDP89kTV9C7uTPYK6u/O0e8Sk1//pYBvMLk=;
        b=wJ/i8BtM66BmEIekd3JJ7p2qInMcLrVN0hORKgWxGD+IBVD2VGCS4xKbQoF8q1bPVC
         VdlWvbcg9XWs5KJw4PyXklbbM1ITXuGmsev6qEOx9lsBRIaBh/a4lacAyr9zJOBxMBYO
         EccPlwe7nUaP9dsqY6unrA0r0Duf9mQaTUb7XU1rmChvH7Eb2YQgZ4KkSW6kdkSZ0ha6
         oPRWMFzbR1vrxcjgAWghSclLJS03qxMc3Xsh8fQUs+AQMTJAS3Kfg4ViugQcGE2EyVj9
         6Lgw312539NbgiOP/G7aaeGaA4K7zdogcjgMnzTBrSJ90w6gEW5Rqqw5XDOXAg2WhUPJ
         +7Eg==
X-Forwarded-Encrypted: i=1; AL+hErEudqdMOfzHaK5jia1FnjTsTzQ5GHZnVQW5tFXwDrDv1yEOhkVXLYVaDvAfgioflTwijlqhfLwK2INF@vger.kernel.org
X-Gm-Message-State: APuU4Z8ac5CQxkdT/ShEZ/CV5BPmgVrFwmdPdVwxmbTgmM0JSDuyN/Hi
	BYQ2eG6yucJRvDVIL7t2bldtn9VMRgPogxUbk7LSU79CVyOu3SEg13K+IYcrVqzJNpnPlTkov6k
	3+jI8jBIPzpwfpLCciwyZf/nLU1WSx00=
X-Gm-Gg: AZFdTZeSuuYaHgpDLasBEx+T7ME1AO1QabDAy59HJmNYz5IeCrUseay2m1Fw9rrRmHn
	x+Mk1GSWVsdOIkbxbYHDArzd59Tfk6UviOjwlUdhihTmSmkKKYpWtzAQvOKmskYwxGcODmgPVVa
	lEuBWiakcluq78M9wh7mjMAzO7+FvOnPkEfv8GMuUZwDlOo184J+taqmWbT5kx/AQ5//t8//BlC
	q+plcOjKS0Jbky3RwFDanGflTuCDnLup8s9TIYA25bF+hRST7xCu2YO/znTUYgAAxnX0OBUvBpb
	scDKYix34iDB89gSiLP1grA6BcSCxUi8OxoLTE2uCogqBxFe7ZwJV5OWGCCtiIjMCg5+UWaokLm
	5jA74fJhMNrWoLVR0w/Ydi/nV7XByLDqip69VHg==
X-Received: by 2002:a05:600c:154c:b0:4ad:5ec2:d3b3 with SMTP id
 5b1f17b1804b1-4bb887f43d8mr396475205e9.1.1795688567655; Thu, 26 Nov 2026
 02:22:47 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123144440.65441-1-ziyuzhang201@gmail.com> <20261126092356.GF774860@unreal>
In-Reply-To: <20261126092356.GF774860@unreal>
From: ziyu zhang <ziyuzhang201@gmail.com>
Date: Thu, 26 Nov 2026 18:22:35 +0800
X-Gm-Features: Aa3M54okF6QAvzv7rzrr-ssSeI4k-zHxuIK9nsyTY1Ek-0XAWmQP1IvVSbC1QmQ
Message-ID: <CACPoYJyqAKZiCJ1OU01njDuwEQzQ+FjT6Ca0m5kSgM0VL5Ndrg@mail.gmail.com>
Subject: Re: [PATCH] IB/iser: Fix deadlock during blocking connect
To: Leon Romanovsky <leon@kernel.org>
Cc: sagi@grimberg.me, mgurtovoy@nvidia.com, jgg@ziepe.ca, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 26 Nov 2026 at 17:24, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Nov 23, 2026 at 10:44:40PM +0800, Ziyu Zhang wrote:
> > iser_connect() holds state_mutex while waiting for up_completion. The
> > CMA handler for the same connection needs state_mutex before it can call
> > iser_connected_handler() and complete up_completion. A blocking connect
> > can therefore prevent its own connection completion and leave the waiter
> > blocked until a signal arrives.
> >
> > Drop state_mutex around the wait and reacquire it before checking the
> > connection state, preserving serialization of state and cleanup paths.
>
> You can't randomly drop locks without any explanation why it is safe.
>
> Thanks

Thanks for pointing this out. I should have explained what keeps the
connection alive while state_mutex is dropped.

iscsi_if_rx() holds rx_queue_mutex for the entire ep_connect() call,
so a netlink bind or disconnect cannot run against this endpoint
during the wait. The endpoint is still unbound, and the connect path
owns iser_conn. RDMA CM callbacks can advance the connection state
or clean up RDMA resources during that window. The only operation
between unlocking and relocking is the wait on up_completion, and
iser_connect() checks the connection state under state_mutex after
reacquiring it.

I sent v2 after the bot review. It also wakes the waiter on
establishment failure and fixes the endpoint double free on the
connect error path.

https://lore.kernel.org/r/20261124090121.77115-1-ziyuzhang201@gmail.com

>
> >
> > Fixes: 504130c039f9 ("IB/iser: Protect iser state machine with a mutex")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>
> > ---
> >  drivers/infiniband/ulp/iser/iser_verbs.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> > index 55fe68e..9fe2d3f 100644
> > --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> > +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> > @@ -778,7 +778,9 @@ int iser_connect(struct iser_conn *iser_conn, struct sockaddr *src_addr,
> >       }
> >
> >       if (!non_blocking) {
> > +             mutex_unlock(&iser_conn->state_mutex);
> >               wait_for_completion_interruptible(&iser_conn->up_completion);
> > +             mutex_lock(&iser_conn->state_mutex);
> >
> >               if (iser_conn->state != ISER_CONN_UP) {
> >                       err =  -EIO;
> > --
> > 2.34.1
> >
> >
