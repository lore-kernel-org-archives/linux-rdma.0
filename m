Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795532629;
	b=sp/ubxbyuys1m3/+z2SV1eWZCcuvD6cXbDhD1gRirUmngSVOyFIphQUOY4HoSFCPW3Tw
	 eNPioi/kGzgrx0zhFpmTCbFM8NQ7kuwJf8fX9aOwThF7JMp3VvA6B4nPZGNRfEGytwQv4
	 qok6J6dhpND9pzxa0rRSpgvW+inqEAj9fDS2noCvBZM51wt6k4v08EryJs8RUK6JjsKGG
	 qDJvGM58tllrzDwEidzFoUdcGu/iVgkYvBrr8TBrm5VT+RMq2Mr7PagDvGe0qgPNlXiAt
	 C9UPq8g6Ao3nwyNp/W7Og/+oeMR9y/uFATWXMrWJGMcQFmE3VFBKOwePgO94DxpoCiQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532629;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=VCY7Y2w2dk2GqpAZkyjY/eRbnj4QFPahj+iatU43WJ0=;
	b=LqtYSZj95qALIbnMWVT3ATdS/9InKtOxXN/bpmmvirqOdJPBg6inwmXz2uO9iQfiukf9
	 +8KN7Zwik3PEmGPcuORc0ZTDw9n2foR49pnCrWi0WiMJ0MAyd1whhI279x16xd4wDqcXj
	 07hm+A6H1IOXirHDFwcB6xUWTAlEU2b4OvGSG65qpfOhzJt52IydDL2C8WALGfYCKQUQV
	 mTXuFWuQls7O0CZpPluPMGlXJ+vzjrKXkJ7ieEFqnMFmJ1YvadkL9k8TCS6PnR4FuXzXp
	 kTYX6um4Qe2piAnHWEsQM00d7sHQ5uEPf9SPdln9jJWf14NoQv/BYosMxrjlyrYFPeA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b="iDMY/niA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90144606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 15:03:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90144606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=iDMY/niA
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so754561866b.2
        for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 07:03:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795532627; cv=none;
        d=google.com; s=arc-20260327;
        b=RHcLPEbGdILRnMA7+LV9Ib3AyBH0nLTYVq6ppNnDo1Cyrb/wYbOsKN/xzUpyKQQQB/
         xcW4T46Caws+Fx29aiuqAN0wMuc0XAcu/q0On4BmvWaTGDLtLY0w49FXZJf1yisSTytX
         buCS0RRVPUYbMhz3w7zqqtJ7tLNGkfSnsz2aRmW+0ltE5VxiyshZY3SkW6vDKSJak/hr
         uGUgL+2vyVcqIF9tSM254rc3BEKBGUBcUEB+WD/ufqlOaGzwsbN42+aONtCyUPjB0VZm
         AGiCeagck320pVWEir6dCQ97hOfKS87UUna1VzWjumBI825Nvaki2brapWtx/R4bWX2Y
         t0yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VCY7Y2w2dk2GqpAZkyjY/eRbnj4QFPahj+iatU43WJ0=;
        fh=q/HlIiqlVZnDWxvAhF0N29mH4t2uibTJEa3ykCezHMI=;
        b=cA51uobWIBUj7aIW3zY8hEa2XLLxi7v7YXTZatkTsLr23bW23Y76QCjEExBqgv6Qkq
         VTVDDtcIk0rNzgAHkzX7MKxmHtYKNn5+QlhiIHRopcw8mQwOFRIszFgPnRBEoCGzID/2
         JxWi0xmHnImOHT6AmfClr5eSlCM7E75MkIZxo69wnQFyTPwm+i7q7OlAmfIJRXoji2HM
         pLklLQqDjmPK+YRBlUg5CHS9VR9MEUDIjxtUBWdM4DANk/XIXiwwlJfY+NsTQpAmOoIi
         3pfVBauDW25MwKCb/VZ6KUZIiwfekK4Le++RtaUxTkTtr4dU3wTPqbGA7z6iV4b1OIz4
         VvgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1795532627; x=1796137427; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VCY7Y2w2dk2GqpAZkyjY/eRbnj4QFPahj+iatU43WJ0=;
        b=iDMY/niAK8PTbdbDy33pICIQSKYlpRr1TBWBI0wF3ceN6fy8gegcrQcAXAWsaiXa3I
         pKi+nnGqQ3tW5HItCHhxbkk/uNNPKiE1Y9m3SIvEf7GIVHwXjGDxYnT4OOvO04fb9HeG
         cz9H452M9s/NSfmqD28OrxTvVjhUCXrhSmpJwQ3hPVmuHGNlh0r7pj3xO6W7qF/yYuGY
         Rb8zboCMMAibWcvDbFXBiy4ed7TeHzssXJEj4rFTq9kKV/fdhvIwBIMWhfXOV0Pt9udt
         8GHD0dL/v642PnFCDb2Ug33nuvMFUCHApeHmmAVENN/EGFHdOfdim+88Sbb264rQhZNx
         tHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795532627; x=1796137427;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VCY7Y2w2dk2GqpAZkyjY/eRbnj4QFPahj+iatU43WJ0=;
        b=S3gnAAXq5zThTygiuJduERgiEHXulw2Puz1KSu+03TjBWH+52rL2zYF0rEvmptsIhq
         hN8z8CvrRbq3b19yTPVsOIJ/FfECZ/N7Id8eNlDXKuQHq5MH9VoMcqL1U9A1tS54n9ug
         LL+OiLBLTvg9TQ6oWrgm+0zljHwH3b638GnVozCjf2zljLCfwKdjUr0hGj+40Raa2vSl
         gf8ShiGv2KMlMgHq9lyMNyHuF3Axo3bUlwjTdSBhVgH6lXZNSR6Tf9LHBXMDE574Uj2S
         FVnRPyx/qBSvUVpQadDKnEEgITnZiQoSAW/zD2gOP0+qWAJISGvxfRHaGUqRMP4a2jgu
         DYJQ==
X-Gm-Message-State: APuU4Z+y4mGbSloTtstGDyr6JrsMl21LatyiV0lLsKGLvN0ihzzKSpwY
	FHyg0K+unNT8GfpeCso4vGMOXas10pAJFY7NaI+91azSLBtUR/yXZy1BPCXHsUEXT0pD6ySqVcv
	7EEpKDkRwMn+d0UR/yxtlFj7eBWC9oEk8h9yriwN9rA==
X-Gm-Gg: AZFdTZcfXtGw06YObP4JrLhOomas0q/LkTb0OU2himBElt2BTT8iH5huKRcATA5i1+Z
	XzeGkT5vkLGkV2Z8+dutXLb7pT2+42ENI9wdLzuIGT9MMLXZdHCUeFaBMyt2bW14HurhsKzEvNd
	FnYptbg9yaNhSPdwCWbgb7IknfpEySQqyuWPva5T/2XGft02ZLB4kqVa0rDZwbu8pFg4nFX1npC
	VO75JTDBbKp04u5pCjz9zOuEZ8kKNpG5plCNwacH/zZvx9whZeomey/9M7AJiF3o/elphfhd9bi
	ZlW5Te3UKO9B+5pt7QcJ7br8UyjaFvC0ErXlCI2P+WmxuSnsPzeTxaYSpshghylnrGU4qYZUXXD
	YMI1Zhcmfh1/RQTHyMpfnTBunn2SuYJ5dzHIvrquSxR8FgsR17GuPMGyndptbjiMD/56J3jbrKb
	jskrqm5dmXcY8NfJV9d/0AXIi5VTYur+L9dZxm9F6mtJ11Ed3/XZmskuYC+M3skVeFn9hOwtTR2
	hUiBkqggXnnqcZ62N5J3iyW
X-Received: by 2002:a17:906:383:b0:c46:8b51:c17c with SMTP id
 a640c23a62f3a-c513a5ea73dmr909885166b.17.1795532626771; Tue, 24 Nov 2026
 07:03:46 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
 <20261123143719.938876-6-haris.iqbal@ionos.com> <sashiko-outbox-229434@kernel.org>
In-Reply-To: <sashiko-outbox-229434@kernel.org>
From: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Date: Tue, 24 Nov 2026 16:03:35 +0100
X-Gm-Features: Aa3M54rGFFJxdeKvVQk0baiADNCrfyuEVU653ZOhNJxA1vR4wwUIA2kDsE9_5Pc
Message-ID: <CAJpMwyip3EJTBT6JN90nYcD1-PjwjigW2OQg0xAsmHRMZba6WA@mail.gmail.com>
Subject: Re: [PATCH 5/9] RDMA/rtrs-clt: rename pathname parameter to sessname
 in rtrs_clt_open()
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Jinpu Wang <jinpu.wang@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:42=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Critical] RDMA/rtrs-clt: use-after-free in rtrs_clt_open() [1]
> --
>
> commit d270a6058ae45a4fbd952be02c065eb235215fda
> Author: Danil Kipnis <danil.kipnis1@ionos.com>
>
> RDMA/rtrs-clt: rename pathname parameter to sessname in rtrs_clt_open()
>
> This commit renames the pathname parameter of rtrs_clt_open() to sessname
> in the header declaration and implementation.
>
> > diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniban=
d/ulp/rtrs/rtrs-clt.c
> > index 5ef912a472cda..c059d69c3e5a3 100644
> > --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
>
> [ ... ]
>
> > @@ -2848,7 +2848,7 @@ static void free_clt(struct rtrs_clt_sess *clt)
> >   * Return a valid pointer on success otherwise PTR_ERR.
> >   */
> >  struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
> > -                              const char *pathname,
> > +                              const char *sessname,
> >                                const struct rtrs_addr *paths,
> >                                size_t paths_num, u16 port,
> >                                size_t pdu_sz, u8 reconnect_delay_sec,
> > @@ -2858,13 +2858,13 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs=
_clt_ops *ops,
> >       struct rtrs_clt_sess *clt;
> >       int err, i;
> >
> > -     if (strchr(pathname, '/') || strchr(pathname, '.')) {
> > -             pr_err("pathname cannot contain / and .\n");
> > +     if (strchr(sessname, '/') || strchr(sessname, '.')) {
> > +             pr_err("sessname cannot contain / and .\n");
> >               err =3D -EINVAL;
> >               goto out;
> >       }
> >
> > -     clt =3D alloc_clt(pathname, paths_num, port, pdu_sz, ops->priv,
> > +     clt =3D alloc_clt(sessname, paths_num, port, pdu_sz, ops->priv,
> >                       ops->link_ev,
> >                       reconnect_delay_sec,
> >                       max_reconnect_attempts);
>
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can a failure in
> rtrs_clt_create_path_files() later in rtrs_clt_open() cause a
> use-after-free and double free of clt_path [1]?
>
> When kobject_init_and_add() fails in rtrs_clt_create_path_files(), it
> calls kobject_put(&clt_path->kobj), which invokes rtrs_clt_path_release()
> and frees clt_path via free_path():
>
> drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:rtrs_clt_create_path_files()=
 {
>     ...
>         err =3D kobject_init_and_add(&clt_path->kobj, &ktype_sess,
>                                    clt->kobj_paths,
>                                    "%s", str);
>         if (err) {
>                 pr_err("kobject_init_and_add: %pe\n", ERR_PTR(err));
>                 kobject_put(&clt_path->kobj);
>                 return err;
>         }
>     ...
> }
>
> rtrs_clt_open() then touches the freed clt_path in list_del_rcu(),
> rtrs_clt_close_conns(), and free_percpu() before calling free_path() a
> second time:
>
> drivers/infiniband/ulp/rtrs/rtrs-clt.c:rtrs_clt_open() {
>     ...
>                 err =3D rtrs_clt_create_path_files(clt_path);
>                 if (err) {
>                         list_del_rcu(&clt_path->s.entry);
>                         rtrs_clt_close_conns(clt_path, true);
>                         free_percpu(clt_path->stats->pcpu_stats);
>                         free_path(clt_path);
>                         goto close_all_path;
>                 }
>     ...
> }

This is the same bug being discussed here.
https://lore.kernel.org/linux-rdma/AB*APAAaLFrQFfZxcNOqk4oI.3.1795529068345=
.Hmail.202321181@mail.sdu.edu.cn/

We will send a patch soon.


>
> [1] https://sashiko.dev/#/bug/linux-982ecccb-b1ca-401f-8293-d1973992f3f6
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123143719.93=
8876-1-haris.iqbal@ionos.com?part=3D5



--=20

Regards
-Haris
