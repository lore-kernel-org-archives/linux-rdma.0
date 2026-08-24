Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E41376A0E
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 03:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787542218; cv=pass; b=Zs4JiAY3Qs0AQVAXxOizgwfvHtwzfRjAFHqpbghEaW6KCu832LHGYfwStAPiflrigl5mI5hyLXcZYpiXD+WbOAc0q8BoM/0zYfOSOuwqO1hQDun2GHiH6TuRCIOYeWBQy6B9fRnty7g0MPsV/6fFP2dktADN8Yvxxlp23kmNSGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787542218; c=relaxed/simple;
	bh=+nzZ6tdJPSH4n79gvadSJGNV7wbriV2ZXJzPTGvymEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ui3HCBL0v0D9yWEiQc/FXMWg4BZRHnsYnpSzzfqrvvJoQfBmcLeBKcn2a5cN2AztWCJZt9SdobtRFBFyrezIG/4pFaZWjSzkCEcIByQ0RSh67ZqEx+sPgeoG1u3Dg/t0FIZYQQJUkrPfdSrLxHrplJ6SBxVHH4QKBs+XzGkRubk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=EXCrPrlV; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="EXCrPrlV"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15f025146dso38903966b.2
        for <linux-rdma@vger.kernel.org>; Sun, 23 Aug 2026 20:30:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787542214; cv=none;
        d=google.com; s=arc-20260327;
        b=XTIyKhh4lvx2gBtHaZ4SCmN8qVwWGPMkQ5iM0VY4HeGRrF9OWrD43Ge5TtGH6W5YH6
         mLvWOHu9UqhesdO4NE1EkdU1C7LKUgB08bmxChgcxa1KlEpps5G8rzkBofV6ThuJakEZ
         laUjjs/rQLKqtDihso56D6B8/GaqINt7Qun2kt4vvFa8D1G54OWfK6trrzbgt1/VijbA
         Rxotq4ErQnRC4gDXmRMKJ6mZsaZQjDUfv4CXSagN+RhwMxs+VLBUbMfK1NbtfV4f4rAQ
         JltesyX/Tv1tGiamHb32L3Fz0+lHHIg12UEVHH/qdTAXPIYOsnf68BKsnFZZttmQBrhL
         62Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LLwzd8NaHrfcJF+QUosyNveH08w9wJnwsgT0VI4vxL4=;
        fh=q3RfSpH9W1Vp6I4ia8A0JqB056iZ65UuroicR+Z9sfE=;
        b=nBjd1PY2VFaq76Z1SKqZfGY3WYAvfZALjN5KTr9vyF/Oq7+XQD1YtLUnTWbAlS5zrq
         TMqv1ivYyF5FJ+8ARwmxRt7pR2TzKvkzkIsogS5QZyXWhBYcJsp76jRHH5uibZrtvcZ1
         vxCxPF0yGhO6dok/Fa5qr06ujuA8viqWzeXQbZkYALuZuCU4hWbotdqDLi0t4b/isih3
         oY16jii8nDX0Dq8kLG0MYH57zqLStlletB9rIA+eZgoXJEf0QWn7dBzqHiPYLGRKltli
         DekoVydbHgHfvffzTyE1suECib1hZcmC99iaI4JKKtT/2rI4q6MpEM8TeoQNfKJn8gxh
         wQLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1787542214; x=1788147014; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LLwzd8NaHrfcJF+QUosyNveH08w9wJnwsgT0VI4vxL4=;
        b=EXCrPrlVcdfHX56ZeYGCBht4J46EJetSD3gkEB/iUnRO5sIivm1ReqjP3cp/2Yl8/V
         fZzWrZD1PZYqIrfpV13C1K3QbtkHeQWY/3+I88ezafUxweULr+hHFOIASkt0U1p/0KFZ
         ES8iaXDeKrMTSzPfhttRxsMHhBGP6XS8CRrRU8jrBNBIH57pMQblIKoi8l6M+/kvaWhA
         jPGUAPtDORMG/0vWr+27R+UClOT3weLXZZm7JcrQdHflHxdCHjz5BaoDsCxHcGuQeugX
         Uqmijart5zMT3oBoMGjZIgpsh+xIa8x1c5UcpA712EatZv3rg6Rn2Mc/w55s2cS3YEO1
         5GpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787542214; x=1788147014;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LLwzd8NaHrfcJF+QUosyNveH08w9wJnwsgT0VI4vxL4=;
        b=lFp9V9d7bMffzDW3cjwonsOgJ0GpMdnTpZq0FWBBMoia/Jif3m/TeinN8jvDAh1qSg
         ByGzcvwwfGeeotI9X/Ea2tSHICItI7BoU56JgpRZ9Pk5wF0q7+1yGed4M/Ls+yxCBHYt
         yVrY6fE2EnX79yWGRMhcyIErArZW+xnxlnTuDHwsGS9JXy3w1Bo3j4aZa8MsuvoAdszU
         VdfDOXeSpQUQH6Spu43zBhnXxDm0LBt8AmYEiRleZ7v91sQ8Pzel6ZVlk5i4sdeyCSiO
         mZTFDy1up65WdugKeckhD85+lHBeKlxT3Tbtt7HXSqzIMGtYXC+/EVKWS2yzU2NEPMxG
         XLWQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq7mairoX9XIq4PRzgxJ09TLzcg6R0MtbstBD6nf/xtk9nM73pQ8ZPek6IndZHvDRp0dIy5vqUFNyiE@vger.kernel.org
X-Gm-Message-State: AFuF++lEbv9xiO4IlTmZ4910qMQVLKriosWEt1V8iBxLLimmZfoYW1gb
	2BIvhSFMVzrAU6Qi7gEqCvYi/23nyeHyNUgQJsg1xl5hDN5GitwDv7FvfTDoFrFITM6GEf10xqH
	pq5jXr+LIq3fRC1rnw/+cEjdulZAVBxxqffZG4yTabQQsRKtBq+zVqQs=
X-Gm-Gg: AR+sD12TPBXQbU6/lLrohMBH3JqQezPWOkYkRxorTm6a612vpzWXu++Pk4g/l9Kufqg
	qEu13M6OShR1wHV3abTWBMvcGecULull3Ar6E/AbTM7xRHXkkbZATongmiWPf/x6a0SgSt0WjJE
	vZtGZInP2bQERG0vyARPgRPlZ0ISf6yAm9Y/jVERSZ3h6k1J9K/HjppXlnUDL9o9+dFv9z3A0z3
	zdDaLQy0XMzavXCZiW1AYV9dtfueT5WsvBIxvmg8NxqlRh2ZVO3eduhjSlk1WGrtN6l6WV5Qk4a
	g/tRD4a7K6bIQxtb3uhUJjldecliBS59s+L4JwmhhzyoownGHzxEAqyhWn/ddbBx2SQtDo+NMyY
	4
X-Received: by 2002:a17:907:2951:b0:c24:908b:4e2e with SMTP id
 a640c23a62f3a-c24908b53c9mr596750366b.4.1787542209350; Sun, 23 Aug 2026
 20:30:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260823034303.163403-1-ryan.mehri1@gmail.com>
In-Reply-To: <20260823034303.163403-1-ryan.mehri1@gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 24 Aug 2026 05:29:56 +0200
X-Gm-Features: AcwNN1U-n-zUy07z8ztf_sz5VKy4Q0hIyyQkaioNJ_TzpW8wQ8zaTIOvGDpxLS0
Message-ID: <CAMGffEmnA6RGfnXh461+NioQBxa4iuiXFfZP-R3e4us45ta6ow@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rtrs: guard against null kobj name
To: Ryan Mehri <ryan.mehri1@gmail.com>
Cc: haris.iqbal@ionos.com, jgg@ziepe.ca, leon@kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 23, 2026 at 5:43=E2=80=AFAM Ryan Mehri <ryan.mehri1@gmail.com> =
wrote:
>
> In the client, if `init_path()` errors, the callee tries to clean up
> with `rtrs_clt_close_conns()`. However, this can lead to calling the
> event tracing code with `clt_path->kobj->name` being `NULL` and thus
> causing a null pointer dereference when trying to copy from it.
>
> This just adds a guard to check that the name is not `NULL` before
> copying from it. The server appears to have a similar pattern.
>
> Fixes: 5a93929d9f9a1 ("RDMA/rtrs-clt: Add event tracing support")
> Fixes: c16762b7bf54d ("RDMA/rtrs-srv: Add event tracing support")
> Reported-by: syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D1695193198994f4e7fed
> Signed-off-by: Ryan Mehri <ryan.mehri1@gmail.com>
lgtm, thx!
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>

> ---
>  drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h | 2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h b/drivers/infin=
iband/ulp/rtrs/rtrs-clt-trace.h
> index 7738e2676855..29e23404bb7b 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
> @@ -55,7 +55,7 @@ DECLARE_EVENT_CLASS(rtrs_clt_conn_class,
>                 __entry->max_reconnect_attempts =3D clt->max_reconnect_at=
tempts;
>                 __entry->fail_cnt =3D clt_path->stats->reconnects.fail_cn=
t;
>                 __entry->success_cnt =3D clt_path->stats->reconnects.succ=
essful_cnt;
> -               memcpy(__entry->sessname, kobject_name(&clt_path->kobj), =
NAME_MAX);
> +               strscpy(__entry->sessname, kobject_name(&clt_path->kobj) =
?: "", NAME_MAX);
>         ),
>
>         TP_printk("RTRS-CLT: sess=3D'%s' state=3D%s attempts=3D'%d' max-a=
ttempts=3D'%d' fail=3D'%d' success=3D'%d'",
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h b/drivers/infin=
iband/ulp/rtrs/rtrs-srv-trace.h
> index 587d3e033081..a7d7b971e6c8 100644
> --- a/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
> +++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
> @@ -61,7 +61,7 @@ TRACE_EVENT(send_io_resp_imm,
>                 __entry->msg_id =3D id->msg_id;
>                 __entry->wr_cnt =3D atomic_read(&con->c.wr_cnt);
>                 __entry->signal_interval =3D s->signal_interval;
> -               memcpy(__entry->sessname, kobject_name(&srv_path->kobj), =
NAME_MAX);
> +               strscpy(__entry->sessname, kobject_name(&srv_path->kobj) =
?: "", NAME_MAX);
>         ),
>
>         TP_printk("sess=3D'%s' state=3D'%s' dir=3D%s err=3D'%d' inval=3D'=
%d' glob-inval=3D'%d' msgid=3D'%u' wrcnt=3D'%d' sig-interval=3D'%u'",
> --
> 2.55.0
>
