Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8644F546
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 21:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839752; cv=pass; b=nrZIsQrFrpDhMsxZn+Ytshqtak36iYFpEt7nk6iBFr7WxMV8VumtzddcewAX441KCqSZo71tBMY59spSxWPz/uXJ46pAdOKnVp1rvefh4EDA5XgMrk2ECaVhBsFL8vnv2SPczloAQroNUsVlI/8cTR1v+BVsC0SFnAuOaq1Eq4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839752; c=relaxed/simple;
	bh=MvRPWTrtyAjxzLPHNX4nRXVH1EEBCgyWdNoeqj5ZkMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWvB0kpbZ7wAZ7izkSJaEq5yW/z7CLsFR3x8FRFb202c2LVN5Se8oqaWFAH5WElMUBaru1uY0YylRvQY9zSAEeLaGrUHFK+hEr6o5Ld1E/cwvWgpskM9E0FoA9MEJqifgS0Wljv6tqm6fSdwMXOgAwC3VO6oar58cFsv/MF3WOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=d+7ApDRB; arc=pass smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="d+7ApDRB"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3514e7cbbbaso5793850eec.1
        for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 14:15:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791839751; cv=none;
        d=google.com; s=arc-20260327;
        b=Dr088apUT9JO1brQCWiQ3LQwnqU4HyHapU5tkPq0TcxwG9Ya84T1tAG1ubZLwjGA4e
         AO4Ma0g47zY7/zBZSvQqZgcH1pCnEmz5lvReluxzJYV/74dMLLzf9U48sZLRPbTXpp4a
         zvJKtb6iWP68r9S0X/PwzjzvVmXkvKkUoyIvNIlDYEpyf4A1DZJNApsIKz/FsepeJWeY
         s2/y1zz+onQDT23ScD+gbDpqmOtw6OLd4nX29CmZApdhUnojmGMlrCuErrd93J8hHGEc
         VlKapytUs/Ce+4sn4Rh+Sxt7cc5VTAqyDA43KgkKZ1sCsyfIciWSgoPjzOoVISgFv7/F
         Cs/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IANbA/IjdpnwKKoezh+3TmukPF52GIFYfzBOkPdztNk=;
        fh=0XjMWuOna6sLKtDAKouDNf8n4WDPWk5zy8GSwC33pYA=;
        b=DtKo+cF3MB38MHabEu/Mp+CpZpzYvGYdjQy9c6HfYAzZlunEORzq65ufKisi5uBEbE
         4JPj4gILgfzkMfgz+h26eIq5766PAi/Vf3sHV8oX+SWxmiN7oC0o5idJXfsuxe/cse3E
         yhhMfKGYS+k6j9/mlI0jXw7MnexH+jW5yMztD5Q7pdQjwF2Puk/mDinBksblhudjo3DQ
         1UUaFyGeOIm+k9D3FtQWs5iF7HKOD7X7Rt3YTHCKKax3IoJdAw6nAal4NoZZoXTvWeUl
         9YZOQovtoKXlHLbcWihD7ehWFIZ/W7Knhaaf/hkbvvQE6pkjZSNbgPLiojX6dXoIJz9k
         OoaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1791839751; x=1792444551; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IANbA/IjdpnwKKoezh+3TmukPF52GIFYfzBOkPdztNk=;
        b=d+7ApDRB9S456YfIHhXaDnZ4yDeqBgWD3BAdR+mY87zU9GT4rBNr+2f1ibjjiLCrvN
         MKOJxbjkdz4ooDSbUxxYiFI6ZDVPmLWy5Rl3hfXmgbpBGcM+ocE1f4MEQ0K1tCBv1lv4
         BVhsNC12MhzMdSJSX+s8lvT2ulkoSa/AO0tnPMnWr3KTtJNfdzAj5QyuKndrUtlo2cfj
         KFO4G6+mvEMk2iJFivdu6t6j0LLCx98nL4vFrIX0ejP3aNg/+b0vNzMtmtHGu3Q5rbws
         hble4YQp2ub6UE8LRYk7Y9TyGVmtgKF0ybm+GL2VmDr02FHYQUxhGwCf5AelcKSg+QIh
         TLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839751; x=1792444551;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IANbA/IjdpnwKKoezh+3TmukPF52GIFYfzBOkPdztNk=;
        b=CrdJY6Is6HJ4ryfamHhVcp0vAW1msAhfqI5ogOMT2Ugmr48r36u/dA2IqwVGEayMwo
         ovAzsv7s6gC2wlZJpS0lXGX2+QgMMS1za2WFY50z84727bjH8RExup6ClQYwKpl8KhNo
         uZmCn3zE2jjgK1fcbuSaszNzCH/VfaY6uIgnN61iZ1X6Yt9AXABpbgpuuF4ST5WLgYVL
         4yL9uVfT/uPIobf/up+XKBI6366pCj8EA2cv3XAGcXbEG3Z8DLQ26xwyeZqB/x6hFA6l
         0785YwTI/UgTHHB++mzQ7YO8J8hOl33x9PQcyQQFrAyA/JsdSrjGXkneEnNCMcq2iZEU
         tT6A==
X-Forwarded-Encrypted: i=1; AKwUvByERpkknih63jJnLi/M+k5PfTD8diXArqiov3HFtRAShjUmV2V8IZOIaqaXxJCZP/7LLHRteteJYbDX@vger.kernel.org
X-Gm-Message-State: AFq9FYJbvYOLTrlbbSzX7x4W3B0hlfIaQLZLfdnD4JJEJOHf1aV5+ZuC
	UMwaHiUcoYyzHRzzkwSlmZToqi4UlUF04smZo4IOhB+oSZyUwY/qBbV9iEAAczApsBLt/gWrhPG
	ocqcgsv7lpkXHDQCjiz6aw7uIc7xXMYW784/2IujRmYA=
X-Gm-Gg: AYBFou1OikAlRGQcX+r8kRGvQ8Hdr+Vp3AXh3unwr9tZIrpoXBojDEPfOiP29GNJx4h
	8OjUKanK/SVQdlqfThA/Mt9G9Gyzr0ylj5fQ8A0e5HkxMOtbdAWE9shfyzudLW7V1yjxfLKkT+n
	2bhJTdr+qrq8u9AEA+pd7hYe4uHM9eNVWjOEvGhpUZX3fGeWIuonsfU2nTffh+MchRXmAPt0H+K
	UQpw5Pges9g3Mjwb4SR6qZWzPY++pBHtrW+F8W+S2kEqPhXpkfDSuSKsR8WEq5QT6WGDkAzUxnI
	HkT3UbRH7Isv09tTTswsayG0+/clnGZ0l+07tUJDm1isZDzhDue54NzKpq4TSr3sevlin0Ew/bt
	vXmQ+04EdQBpKwfFjDuhO71iYvru8GBpjJJIIGUeJIA==
X-Received: by 2002:a05:7300:1c94:b0:351:4a80:d94c with SMTP id
 5a478bee46e88-3537dfbbe1bmr16689633eec.21.1791839750665; Mon, 12 Oct 2026
 14:15:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011011022.1445352-1-dhu@x6u.co> <20261011011022.1445352-5-dhu@x6u.co>
 <20261012141725.GG219304@unreal>
In-Reply-To: <20261012141725.GG219304@unreal>
From: David Hu <dhu@x6u.co>
Date: Mon, 12 Oct 2026 17:15:39 -0400
X-Gm-Features: AclHuK-WSsye-UZZ0-V6UWBm8gdg-DYRcfAamBGa6KpOmrjBSgQosSoXHhwrVLU
Message-ID: <CABdL-LRjOf3GiL+eq4ZvRTWmWRqsehrDE_rZsRUJYRqzxaTVxQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next 4/5] RDMA/irdma: Support UMEM attribute for CQ creation
To: Leon Romanovsky <leon@kernel.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, jmoroni@google.com, 
	eagleshaw@google.com, David Hu <xuehaohu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 10:17=E2=80=AFAM Leon Romanovsky <leon@kernel.org> =
wrote:
>
> On Sun, Oct 11, 2026 at 01:10:21AM +0000, David Hu wrote:

> > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/h=
w/irdma/verbs.c
> > index ab25445f3828..e4a02a6b2a11 100644
> > --- a/drivers/infiniband/hw/irdma/verbs.c
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
> >
> > @@ -2708,29 +2719,94 @@ static int irdma_create_cq(struct ib_cq *ibcq,
> >               if (err_code)
> >                       goto cq_free_rsrc;
> >
> > -             spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags)=
;
> > -             iwcq->iwpbl =3D irdma_get_pbl((unsigned long)req.user_cq_=
buf,
> > -                                         &ucontext->cq_reg_mem_list);
> > -             spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, f=
lags);
> > -             if (!iwcq->iwpbl) {
> > -                     err_code =3D -EPROTO;
> > -                     goto cq_free_rsrc;
> > -             }
> > +             if (attrs && uverbs_attr_is_valid(attrs, UVERBS_ATTR_CREA=
TE_CQ_BUF_UMEM)) {
>
> While making this change, it=E2=80=99s a good opportunity to split
> irdma_create_cq() into kernel and user paths.
>
> Also, please keep commit-message lines around 75=E2=80=9380 characters. T=
here=E2=80=99s no
> need to wrap them at 50 characters.
>

Hi Leon,

Thank you for the review. I'll split `irdma_create_cq()` accordingly
and keep commit message lines around 75-80 for this patch and going
forward. I'll send out a v2 shortly.

Regards,
David
