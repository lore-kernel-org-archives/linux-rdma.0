Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC0651B18D
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909011; cv=pass; b=p15v3SuWYqm7DcN27C0fsKc4XY2lxDcKZisdvctfVyFAm27cF0FSi7WytKxjrIbY5bt6K1T6TOTIw1VlM6Vn7gqofm6jZAOxumLZ7OLg/p+/PjNQFdiF0y+xqevRkP9baZtpvQHjY6eAz2LQ9JZ/vrqo+izCv/WkRrJCcK0ao3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909011; c=relaxed/simple;
	bh=rr+spJ7n0JW+ovZs/CR2CxF9rmEX93rSF/dATklRBz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Em3iGQU7T4cYWZtOSdG92qDvSGM+i0Ejoh+8R7QQNZkuCXOLXUkSzN/NwCctELeOCQslLq4f+6JN+09YEabyIK6RPTWcTdmtGHd8m2FDpUE4gtNlkFLU8fNQspqyjss7weIvAdARNXRAE4Cb3KM9/3WYC+Kdmym0pUWvSj46je8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FyYzOoKo; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FyYzOoKo"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso27199a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:30:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791909007; cv=none;
        d=google.com; s=arc-20260327;
        b=UaqbmYl2k2g/vLplyvByT8qpw7m1CUh+4LpptwUFkPynlm/a4SOJPLleRMoJr2IVs6
         6aDpmUVSvLOzAq5iyP5wsJ8NKbk9X7Jg/E5X+/nL47RduwTFKo3Txw4T6TywJvVCttdD
         XRxKlPpOQa9boDtTOhUNSfsvasDqEtILveerVDAY/jfyp691vOXBDZEMz5MfMjqeZcfH
         Xgda0mFt+BPELAtj6WN2GxIC0vWSprmiMFMiVSb6PDUuh9PicJHDGt5xp9KZRUrs5pNx
         OYn1d1KpaQKjPYndQr6A5LpzbuMFtJFkrB40VVyKEd4E75N9nS3qjr66lfjrfAg/8/uA
         2efQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=USnWgApP+/1SoteVw2gO1Ar5rEYFG+9nVhj1Ww1rLx0=;
        fh=Ub7alV1mHJbRC1BS6wyadaCth4AxrqFhlx/ZqP7bA6A=;
        b=LxvWi5ju+vfI5llNtfxnNQPz+Z/X3g1uQDHDE2q3MmdP2nvFNlYSMLjeklb9iuYRdj
         iqKvQWbDglqm7OmT+u0kWNE7ztdE9k7woVpLJ5QIDo9AP0SKMa8oA7aDsZwleqy7+qWm
         5SXOFQOMhyjLr36Rq+XIGP/knoHpA51nET03z7pO2rzkAHZT3Qoe4LhzOOi5mXFsQ+69
         OFaj+ccGKbegszhEHzD5cYxtPHMhCXVFWM/2cX/chWYTtFdFhBWhdEsqMzVEokyFxqwM
         XzRjnV2h0smUfi358oUYCYuItS0UPqEvrzqozcu6WGi1esJ3EMbnprdYbqtp+YykT4Hn
         L5+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791909007; x=1792513807; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=USnWgApP+/1SoteVw2gO1Ar5rEYFG+9nVhj1Ww1rLx0=;
        b=FyYzOoKoP+kSYyrfqeJux3/PlQAJikAsqyNzCaYIJF25L5o6DwSIHZnLvdVmvY5qj+
         bCWqP2kv9rlJRMbhMPPY4BCG44rtCH+9TB6SjfM/Y3sm0cXsFIxlnubTqnz7F1tkvdaU
         7xf018W3STozTSJkdhyoq1+TVeidmTRRekSLZoFE7ci68bXgfUhNA8SOaN++mIKZxUYS
         QFKHKWMkadeJbUccTRK9bB0oo5prWdGCg2xznaRmvy2OTIYXVkzlKrO1qkg0Z/y5blGi
         cyHDN5p39gaaZHRvts3rnWGekIBMVjx+6G8tDTy4KgnovdRdtk8+LezMYfqlaWmi1Xjo
         CyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791909007; x=1792513807;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=USnWgApP+/1SoteVw2gO1Ar5rEYFG+9nVhj1Ww1rLx0=;
        b=2EwGkrT72oHzdj+GuNXwymSPRwE7z7pd43oCJDIgzFfQwd/gt7LymjkR28M8/YcBY+
         brpQ3Cn7r5PXwpSxFM3qr9PDsur4kaNufOfXbRdGinCuw3Q0K+Tds004kx9NlDM7E1Co
         sF/mOvuZv9ej2WlZj/xuwzep6sK/eDyp+T5Y533GMBw/Q+224U3xn6jgVix9KHKZuOth
         XIBmD7EIEadsDjxbFvHebdpmplm1BOgIFWuH8eppcS1C8B2woLMzdrbZr/HpZdWtadZO
         zmep9t9oIoGfs8JJsEUu20DwbXoLknagBC4eikUAW/fXtnrSU8UP2AxQgJa+nDyQ/vdm
         6ahg==
X-Forwarded-Encrypted: i=1; AKwUvBzyYu+Bp+h4/5bOS644LGdz1l5cqaLrrSfh8anIDmtVG2LJL1SdOuAQ63BRX4xXs+FrEAU/rCPmrNUa@vger.kernel.org
X-Gm-Message-State: AFq9FYJv3NGhJEoYBHmpYtgX54vWxT8YHilLEVRjkZeVVADursaCuhfs
	eyU7mVCL9W0U87ILH+ZDvAKY9ujq5EewgCgjZOB6bnqD2PubvLpV7PZ1wBPiohdVdHwxgV05xtR
	Xpq0wPQUK7iz43u1i9FFvofr69KCEckCp8++VYvJI
X-Gm-Gg: AYBFou2K6s7BwMn1Q3WuwuEhvv2xxSjWTo4SL5f2KM0JzuuYqmmnHRq7NuduqEnKc4j
	7lbpit3F+DNteDJjCGXkqEI0rWux9XQEwA9+b4maOfNC8CeR6jI9lEq16kwRYt76VLO06RAGKqe
	y4UnNyqfPld7paOn+xrVVB2i6xj0iuQ3e14ztyB+U9xoVbaokfJP0PQRO3XnQuKSCC/O1pXYgN5
	J0PIxanLf0XP9nJX2OJEQPjjRVe/wwe52xZ621sicybOek3ho2S7yDWjR+ulVukfjBkza02Cxnw
	YGHE9AMhqXUVaFcKzererZwzDejWvDi439toRNApwwKrxFslDQKUwU54QEeqSvToNkMG10acRj3
	0Mkzw5iepEA==
X-Received: by 2002:a05:6402:a593:10b0:6b1:d313:16f8 with SMTP id
 4fb4d7f45d1cf-6b1d3131c5emr113934a12.0.1791909007037; Tue, 13 Oct 2026
 09:30:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012082148.1698596-4-almasrymina@google.com> <179188049412.434549.8105329401807782174@kernel.org>
In-Reply-To: <179188049412.434549.8105329401807782174@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 13 Oct 2026 09:29:55 -0700
X-Gm-Features: AclHuK8kCFpm3iyYaxSIjhAo3U-PNi7X2jSQzQnctTkUNfPkNJqv2oqIvvlgRMo
Message-ID: <CAHS8izOKULOVuav4R-2rcw=38G2oifcSj2EnbVoyEPcW=kLD4A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/6] net: skbuff: replace skb_page_unref() and
 __skb_frag_unref() with skb_netmem_unref()
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, u.kleine-koenig@baylibre.com, 
	shaojijie@huawei.com, mgr@kernel.org, j.raczynski@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 1:34=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] The patch fixes a real page refcount bug on mlx4's RX error
>   path but has no Fixes: tag, and the fix is folded into a tree-wide API=
=E2=80=A6
> - [Low] At this commit, the new kernel-doc for skb_netmem_unref() in
>   include/linux/skbuff_ref.h says it is the "Counterpart to=E2=80=A6
>
> --
>
> net: skbuff: replace skb_page_unref() and __skb_frag_unref() with skb_net=
mem_unref()
>
> This patch replaces skb_page_unref() and __skb_frag_unref() with a single
> helper, skb_netmem_unref(netmem, recycle). The SKB-owned fragment unrefs
> in mlx4, sky2, tls_strp and skb_shift() now use skb_frag_unref(), so they
> follow skb->pp_recycle. tls_device's destroy_record() now calls
> put_netmem() directly.
>
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/e=
thernet/mellanox/mlx4/en_rx.c
> > index 96f97fa0f5489..fe18606c2ab55 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> > @@ -497,7 +497,7 @@ static int mlx4_en_complete_rx_desc(struct mlx4_en_=
priv *priv,
> >  fail:
> >       while (nr > 0) {
> >               nr--;
> > -             __skb_frag_unref(skb_shinfo(skb)->frags + nr, false);
> > +             skb_frag_unref(skb, nr);
> >       }
> >       return 0;
> >  }
>
> [Severity: Medium]
> This looks like a real fix for mlx4. Should it have a Fixes: tag and go
> in separately from the API rework?
>

I think there were a lot of latent bugs in the refcounting, and if
possible I'd like to fix them and make the refcounting more consistent
rather than split them up. A lot of the fixes depend on reworked or
introduced new consistent and symetric helpers.

>
> [Severity: Low]
> This isn't a bug, but are these kernel-doc references accurate at this
> point in the series?
>

Very low prio nit. The comment becomes consistent later.


--=20
Thanks,
Mina
