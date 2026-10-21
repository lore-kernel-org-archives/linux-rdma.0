Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792611488;
	b=mak8SMbGirMLaS+hwHmcL4F1ma5yM3ZbNyeQHPdhjvDF8MHpw6muS4tZsX3znzyN9VVg
	 QBV1pvLa/7n69ijLcuNw00k4QskxxvpzD9YqgkIRmWmmly7MfxZkD0dg7t4eCxz86x37M
	 FzG3wvG1TnW93ZnHHJIijkjE6g689b99aIoSRxhk908HBpnTjPmmjVL4xjE4hTDg9wj6C
	 8S+86hnWx30M6YxzF/bmN/hRo8Bb8A+A7D7fga22eXZAxFXAXFSUGw16j9p2aB+rYpRh7
	 nj7QlYiL2qONipkV4yQQlhN9Eok4EcHQlg+nW9IBIBAEBzn2ytp9VgvK3tjdxnjkm7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611488;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=gx7b9r6EmXrF49L/iJ9Gk/oxTO3zxiI3rPNkkxbsnYk=;
	b=e2KgdglSArEeaMO/tH1PzlTyOZLZ/8IY9cSPip1YA45eDFU0s33ewndaFIGmxES9zJV2
	 TRHRWmsJ/FBaXr/6I8itDTGonoU2NWaCsl4GgEdyMRzB+reAp79zwzrBvmWWpFx8SCyae
	 d4u5Wfq7E3hLr9DmvTHcc2gleHLGa7lXLjAmvNGuhJExk2Oct2tNPrCBKeH9xLdjbMvxZ
	 h/THgA/3fUnTa+eKdRTMKdCo+QFgI8/72dKJ9DcH8RGF+3qCjKKopmUuoEANlX9s3ffLA
	 dH6NizQadfwSFR49mr7gs8K726IeLujludaaulWa5Ji9kv6w55bvZvuoDbk2BraV7LQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=V+e8E1kM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC3606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 19:38:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ABC3606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=V+e8E1kM
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-35f036b17easo993701eec.1
        for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 12:38:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792611486; cv=none;
        d=google.com; s=arc-20260327;
        b=mF9Uj4xdkjCdyEPoi38vO+SXKaAMgf05w8w9oax6SJtCvwmpdJUsLCZKP/l0sHZiHW
         ljoQLIA+j6TJbjjTXG2bSG/PaQCfgx57tIbdlklYbE9UG1ZodKUPyMsR4NDvGdVd20U6
         HYOawOKCLdGKFPHKpKDGwKTfmHc1tI+9++m9SCjuZIBsHxYeat8z/s0VO5R2vIUWvcI3
         YMmGf/PbcwHOfGd8X2z6XmtBo1Sl7ekTgiaV7atV6y0F4K1Pz+Lb32YmfSH+1UXQOcUV
         nzx0vj7JsokmnV2NLZA83USVPwILmZXpaPoiz28xWU0gvmL2jw0MkH3/xHUlvL4j+/cE
         +qxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gx7b9r6EmXrF49L/iJ9Gk/oxTO3zxiI3rPNkkxbsnYk=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=MUbyFgnLN8bRL6IYvcumeHADJPNhgBOpXkjPxX1fpFdf/+3sok8IVxe37A4Qc6P5b+
         ByKp4tGeCNNoOlom//UZsXFIcp9KzwjD2qhQZK7yrHFsjY7vqR7I48mM6NoBeIOlqaQv
         lSoM+Af0E8QQVSpogHB4RnKf4PiyWwYsyy0V1eZ8C5wc4pomnL8JZ7xnv4QRXyMH98j0
         ngBcSXorpDExe02KF6eTakqJvncfbxojGzjxZnYxRrlHh3FGmgiI5THBlqxaSWEglSBI
         TI8Mcsa2h2YkH8ZIdh5tCczWUywGX1Lhm24v+WoCIeGdAEPeh6KKznnZybRy+saQHKER
         gytA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792611486; x=1793216286; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gx7b9r6EmXrF49L/iJ9Gk/oxTO3zxiI3rPNkkxbsnYk=;
        b=V+e8E1kM5TbtUvhSKXj3AUJT4kD+5Kq332UZvov/aAK804MIG3Hkww2UVXSgHjr6v2
         3Y2ev/WFaeP30Goxt+gZISxlURse9to4jhWUFN19OYaQIAcS3OMEx19k3KhQev5hcsea
         ka7+PUQz7ujKP5Q4zWYjGjxCn5MymJj+aPWejJh/EyQv9xmHYvXm6m4TMFIgmMiP3o+V
         62hYUCyMVnmSp6R9nkmjfuZmbODF/IkXmKFhBiTAqFtMam7Gtu3xHPUBiOk/difKLlup
         /9/PPtJXx5IF+WQr6LuVVpYuuIs1XsyJaZOBurayYESo9pybsyvX/kD/EvKWCXpm26qP
         tHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611486; x=1793216286;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gx7b9r6EmXrF49L/iJ9Gk/oxTO3zxiI3rPNkkxbsnYk=;
        b=mOY5kBR76E4O2VInYbxdAqf6w21XFi+JgNWsQmf48+UjybAWcH43rLAhk/nLtiKIBz
         c4rgxjFEvxNc0kZeTMZnxLayZdewBaC2XPoESbcXN2A9xq0ShO+IUmouM+PIEBXOFGtf
         6e0ainq2TwamaCCTzinM0gV8T3os8/ImHgdbITjcg/Xl2ENLhaEQqbCjtY7xgocF59an
         jy4HRk2dSZSIK02MzBwfQHbd0Ro37omgtpiZv+Rd7gYIw0jLIIbGMSYq4YUMYNrH+l6m
         iZy3Mt3f+gzV9KwyCe1yzzBuAXfbQSKQNBC+tdVfmg4uJhWkN9qSJNAuLjEQxQR5VjUv
         kWgg==
X-Gm-Message-State: AFq9FYJCIgyPr8VuzIzxv1n4vUIsN67F3KylC7vhhZaARA2QgiAvZfcy
	BVF8nrFa1D6c4pxKTUBhCrahFHBf2kvIAiLAA+rvRRl+kiS/MWegSE91kI/Qh+2z93YnLKklHvb
	9d1I7vhCMoWiNPmyouN7dFPwLg5qWmDqBYOhnEFheGTA=
X-Gm-Gg: AYBFou3cTC2fL7a5x2eF4E0CWh9tNXae8BEF+5WScI4N5aQ4chhfGkUgndtCmDm72tM
	lIuvWrP1zXPKz5ugT9RPqOMBdJfwKGMUm3txLLKw/zqp6YholEepN+fCf73oduWYz4512eQSFtY
	uHMxcvt+cqqvwABj9E6Uc2Dqz0KdWjVycICqdm+VrIdTUqXvaN4a+LVOuytknS0y79n4VdsdeUv
	jKw3vTpwFTYJTNfgU38MrEb0rd2mWjBlKe1CQtMV6FZYy3hS6yfLjgMQuaWnlq5f3BasHrpNPwX
	r5sDpspMwXvSOk7W6F2KerZZQbNS5554ccS6eNjL9AajbuPI76JLFzkUr/o2k5D25LC313Qo9YH
	x+QMNO4P54Sra2sVCIpP9ggSorsqHF8Y0YVZXyogio3ZWPYZoHL3m4vSSGz7jXmdyH6IdwKXi4y
	08ks8TA4qLHkuwUJG1IW3auw==
X-Received: by 2002:a05:7300:d58a:b0:35b:9f06:e383 with SMTP id
 5a478bee46e88-3674e450e8emr4670388eec.8.1792611486142; Wed, 21 Oct 2026
 12:38:06 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016202909.1289496-1-dhu@x6u.co> <20261016202909.1289496-5-dhu@x6u.co>
 <sashiko-outbox-174921@kernel.org>
In-Reply-To: <sashiko-outbox-174921@kernel.org>
From: David Hu <dhu@x6u.co>
Date: Wed, 21 Oct 2026 15:37:55 -0400
X-Gm-Features: AclHuK-arAWvDrTZe7uApi0sMp8JPVVE32312fzqw2LiTVQd6LDBosGNwx8KMuE
Message-ID: <CABdL-LQR1iEdy27AYzBXHFx=cMhPqKbSa5++LM7zww=rPDM6eQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next v3 4/6] RDMA/irdma: Split CQ setup to umode and kmode
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 4:44=E2=80=AFPM <sashiko-bot@kernel.org> wrote:

> > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/h=
w/irdma/verbs.c
> > index ab25445f38282..4b7e9c2d9cff5 100644
> > --- a/drivers/infiniband/hw/irdma/verbs.c
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > @@ -2624,41 +2624,198 @@ static inline int cq_validate_flags(u32 flags,=
 u8 hw_rev)
> >       return flags & ~IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION ? -EOPNOT=
SUPP : 0;
> >  }

> > +/**
> > + * irdma_create_cq - create kmode cq
> > + * @ibcq: CQ allocated
> > + * @attr: attributes for cq
> > + * @attrs: uverbs attribute bundle
> > + */
> > +static int irdma_create_cq(struct ib_cq *ibcq,
> > +                        const struct ib_cq_init_attr *attr,
> > +                        struct uverbs_attr_bundle *attrs)
> > +{
> [ ... ]

>
> drivers/infiniband/hw/irdma/verbs.c:irdma_cq_free_rsrc() {
>         ...
>         irdma_free_rsrc(rf, rf->allocated_cqs, cq->cq_uk.cq_id);
> }
>
> When one of these pre-init error paths jumps to cq_free_rsrc, wouldn't th=
is
> leak iwcq->cq_num and clear reserved bit 0 (IRDMA_RSVD_CQ_ID_CQP) in
> rf->allocated_cqs instead?
>

This is pre-existing, and a valid finding nonetheless.
`cq->cq_uk.cq_id` is only populated in `irdma_sc_cq_init()`, right
before sending cqp req.

Happy to send a patch for this, or fold it into v4 (if v4 is needed).

Best,
David
