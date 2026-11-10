Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794345909;
	b=ILn6SRhf8wM7h8VcX0JeSHcARB+ZUPI+meOyixuouUopCa2HRgMLkL2r2B0aU/+Paxhf
	 zcH56QQTp/EQMYbufgBq0omd+VJ4WVm8odcD78WDng3thG2u30J4JrGJ1MNWl0s5nIwpt
	 Nge9hQCtNAH1CkSsfbB75+66NkekUsVeFtV4GwFjIGvhRMNyBrcSZTAMnvzgCvL9FKAzb
	 UBjzg0v4qO8bbbcN4E43rv9LibLnnEIG+PZMTiFvHtrHokZQyofnKRBJp6qSrjtQD2mWJ
	 5mZ0a+/fi7409eds4tbkvWJ7i9iXNu8q/ShGOAuz9821jYY9h01Qe+lklMucn3Xc38w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8Im2O9UQXSYjJdu0UyR42PEbf4jui61dGr3vWu43P8I=;
	b=nmO/oluadoQlD35r7KbpBijo+YYxChybtS9V8Sl2d+avBlI5KG5ckNMZmF8L6f1tVVRn
	 Xq6uKv2nuQZ2l4zwcmHb23fHxbgt3bLgS/yIBTjWDS6ivLTr4VyNy28DgUzKTPwJj2lG3
	 9P6az76QvO+Wd/rwYXe/a3L/BOxUfwOd09aq4OChKMHx3LTDrLoPta/0uGcpf46QvF8zZ
	 jcudIsFdCsd3rSEBIOb9NfLznuIegSeXreJbfA/TEaemR7/OEvA6DbMLS/xblx+ZZRaDF
	 6DFNz29+AISGgT3NN7CEhWgzm2bEIFmfDaKiy5c+zTXamUeRMSG5sSJl3u3X4byEpyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PH7MPCFz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE06606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:25:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFE06606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PH7MPCFz
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-54492d8a988so20531cf.0
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 13:25:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794345908; cv=none;
        d=google.com; s=arc-20260327;
        b=W2R15GIuJl5OvsR8kyZ4qKFjIB1VapbcvzgmzhWCz4rgsCpHBj3NM34Pep+KvhY5Ut
         sXxUE2a5+9s/BN9DhAe4QNx0BrBKTABznsnkmWJaHjeWd0ifPQbxnPq+uL8vNChZ9+At
         OO9Ww2h3bZZ2idJvHcDqTAbEvayCAE4jZku/4e+yAZJt8U1lX1iqCe7/hzJKNN2u8SFP
         bc8R6p1EicDdQDzN1qaywl0i/fZBEGjn3ybfn+6OKP2b/uuurdLQrOvgmByoZH/ZpitX
         7hP4I4IYqh6XONVDD+vNuHcmpZIPmwLlvtcOJB/Rf5bpiKnc5Fl7rQYcMeKOP7fIB+4+
         dT0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Im2O9UQXSYjJdu0UyR42PEbf4jui61dGr3vWu43P8I=;
        fh=lzlj/p5XInD20z/IjZ41NpI6o/Y6dN/NmFMVodBEXYs=;
        b=imFYRmGs4H6mUU8QUSIH4YpTomJVLFt+s1OczMbyf8EYOlTB2fbiFdO6KzDtFK6yg9
         AqelnVyJRH7sF3b2xtcwZx4QTYXQl3bO9gSbvLo/1Ya2Mf5a8yz6HzZ0l7cn4szBe9sj
         AM+dctXDUjvEEJHGjRThaZpcx26GQWUjaYZiNIf3fX5vyogrlgLKY+9ixDZYc9j4xezs
         65Q0H5ZNoaRBQN41KdVJOj1jwb9oEgFqbgd9aMEK7D5adBSHFjJ7xrxLyR8xjW+Ac4SG
         cl5ZlMhho1Va6R7T0DFPKObBrMkTxMUJ0X2YGobISXQwI4VgI4sXhLwsK6S1Ld6IWkwr
         m77w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794345908; x=1794950708; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8Im2O9UQXSYjJdu0UyR42PEbf4jui61dGr3vWu43P8I=;
        b=PH7MPCFz0sYPTBuaSaQhH48rqLN1H55SFQE49X79LLcX/8L++a0QesRY9Po9F/TEOD
         sKkBlXUI9HLgzUk/6tj76EmfTTjlI+jYy1H3wnLWNRZdCDPtmlK6OFd3YaiymxwPNHYA
         5lAh4DAbxtjW73g6MJzR+FNLhx6zqgLWc7fkDB/EP3f3je3qs7UzLjsNJun39zrabT2c
         1vVM96SrTgIutcMceMzHXdr98sPhxDvOwkcJWRSFZt6uHArmRE4MpHYsDb3cMQQigV+/
         cfFePhjnaakmJ49SObOIJBJGA5aspQmdXLAvgkdeqjdUWcvcjmW8I3ysB6+OMzAV/SVy
         Uy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794345908; x=1794950708;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Im2O9UQXSYjJdu0UyR42PEbf4jui61dGr3vWu43P8I=;
        b=0JpOYhtvht3JnhRnSNIck2JeFi0nvKy01hYGPE0tNBW8HR43BwXDfp2FsSTlCiLCjZ
         j6jv/Sw4PMB1Is/mplaQ0ZDtI2DOgDlZLe+DFFoki+QtHZuxu2wWweYq6H1XT5vA3nAU
         h+XdKc2ajWDB777vASgfnfYmV5x6c7noRGf9IMsid8+X81zHbk2z/ERGHC1m2v6a5knj
         4qLMtBkd9XciKoOruM24S6Rg+LZjdVp8ET8kgf87SBbn0BrVa6JVdhJrS+mLDr1FCHJt
         4G8z//ZWS2SsqvQKRYA8YCtycOVRBgyzuusdcO+SfnDdWb5G6Vl+QbKqnKXp/m3UGKUG
         JGQg==
X-Forwarded-Encrypted: i=1; AL+hErGsgf+MX4WKEGpCyu8VKMV6QQT8HDFOe/VF6N752uNmJg9PdX2fkx1O00UliAdBQO+U0VVTtaH/knMt@vger.kernel.org
X-Gm-Message-State: APuU4Z9d/gwSjbkyzFPScG5KbUQo8jzxFHrcNrkhLO+SoCdBuMT93sOM
	hw6Ake4Sc14mTOnqpfrRJGyCX4fNsHAauTJPna05TaSkgcWjAFlqKqrduVTR03AdBuzIek33Gc/
	Kjm1scyF/Wm1SbOq4AiwHxpCeJEkGPzKlRPGtsXE=
X-Gm-Gg: AYBFou1FebhcxAQkomqESh8v2QBpJV1pW4CC/JkcoiVGVe0sTDoo2bTLrI0SZQ2CqyS
	G6zYeaqaa0lABg2HEDHx654G43E9yjzD/8D4A2b+r9EdzuXQFd4/dT6wzbcnqq7edyNJMCBAofX
	vNOddC6l6mzCfBofuJfJfT2JS58Mk/q6ce1/3Y85pQJwLGkZU5Xq0jfj99E21xbm4lzGcxCNhAO
	aQd9tArgFHd1vOqQCYOLX7SEv8HJvDGWhj343VGFci/FOheCz0bmmbZkcfioUSJzrT06WtFyt5f
	eqIynvq5G+tvmbF2iGCijDw1KY7T/B2GZkeq8M4tqMWj2M6Vm3M2x0RE+mYPpVvnZxdoMNzwGRm
	B7JgxKxmIojw1j7+6fFXDdziCXS3/46jp86XyMmJPh+be6Tab0dwZQcFW5eenHzGSw7LL0g==
X-Received: by 2002:a05:622a:1cc9:b0:534:313:9b4e with SMTP id
 d75a77b69052e-556a0454605mr4347971cf.5.1794345907033; Tue, 10 Nov 2026
 13:25:07 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com> <20261106221201.2266301-2-jmoroni@google.com>
In-Reply-To: <20261106221201.2266301-2-jmoroni@google.com>
From: David Hu <xuehaohu@google.com>
Date: Tue, 10 Nov 2026 16:24:56 -0500
X-Gm-Features: AclHuK9FbakXhbrhutUVLuV1FSkXvSb-QRdrqH0rVtHpIlot6cSGSK7awCLIBTk
Message-ID: <CAPd9Lg-242fV-2NhvXA-Ya2v7tZ0CHFLdwOBV7yK5aEHpkiULQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/4] RDMA/irdma: Fix QP handle assignment for
 SRQ completions
To: Jacob Moroni <jmoroni@google.com>
Cc: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 5:12=E2=80=AFPM Jacob Moroni <jmoroni@google.com> wr=
ote:
>
> The QP handle comes from a different location in the CQE depending
> on whether it's an SRQ or normal completion. For normal SQ/RQ CQEs,
> it comes from offset 8, but for SRQs, it comes from offset 40.
>
> This was correctly handled when the QP handle was initially loaded
> in irdma_uk_cq_poll_cmpl(), but there was a leftover re-load of
> the QP handle later on in that function which unconditionally
> loaded it from offset 8. This would result in a bogus QP handle
> being used when processing SRQ completions.
>
> Fix this by removing the extra QP handle load.
>
> While at it, load the QP handle into the u64 comp_ctx and cast
> it rather than loading directly into the QP pointer since this
> could overflow on 32 bit systems.
>
> Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>
> ---
>  drivers/infiniband/hw/irdma/uk.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/ird=
ma/uk.c
> index a34883fe9983..250267ef5727 100644
> --- a/drivers/infiniband/hw/irdma/uk.c
> +++ b/drivers/infiniband/hw/irdma/uk.c
> @@ -1220,11 +1220,11 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
>         is_srq =3D (u8)FIELD_GET(IRDMA_CQ_SRQ, qword3);
>         info->error =3D (bool)FIELD_GET(IRDMA_CQ_ERROR, qword3);
>         info->ipv4 =3D (bool)FIELD_GET(IRDMACQ_IPV4, qword3);
> -       get_64bit_val(cqe, 8, &comp_ctx);
>         if (is_srq)
> -               get_64bit_val(cqe, 40, (u64 *)&qp);
> +               get_64bit_val(cqe, 40, &comp_ctx);
>         else
> -               qp =3D (struct irdma_qp_uk *)(unsigned long)comp_ctx;
> +               get_64bit_val(cqe, 8, &comp_ctx);
> +       qp =3D (struct irdma_qp_uk *)(unsigned long)comp_ctx;
AULT;

Looks good. Curious if `cq->avoid_mem_cflct` is worth checking before
reading offset at 40, similar to that in 3/4
