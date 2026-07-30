Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFF43F8238
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 10:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785407307; cv=pass; b=WGhzfL6UPE+lLX7QX9FnbIQ8RR5PZbHIh0NFZdSescZS4sexWt8bk09m5YhtJAzZhsSLiEGtxj7z6iBjckaQ5umc7tNO6f6OwIRD3qDnbLnYhdGzsYXe8ZdzVuS1znIMn+Q626GPnPQLcZkncxpGrX1CWkIc1l5cg6wNZAjZaE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785407307; c=relaxed/simple;
	bh=gWxIpwYxIVNdq9btL+3O+1+adez6OPA97GMba0U7GtQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ESEP30ZwJ5eVzQIUye1ZnYcQYp3jEFZ6i7Mh6WFczknLjJZN1GJ4kuk9Ohs5CWATKYcISOSGRqU0gtbeFZ9rnX6E6IaMJxFeAgTwLh5Eu7cfJS2pzJX7rAawzOk1SF+FJW7zA7nJ7XRpSW1q8E9vH7S7pPJWWZQgTft64ifUqgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksmCxs29; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksmCxs29"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-698a99b1c37so286322a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 03:28:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785407304; cv=none;
        d=google.com; s=arc-20260327;
        b=nCSwb3ou1KtzVEGJ1qOmRaDdnLFbkqGHusnqJ22qiF/Cma/b3E1cVIhT6SRjW3LAHl
         1B7Ji6EHjZUzbYGZTFHKKarMGVjuyWWPXtMdmL+cJ147fF5St02N8GXFG8I/Q6kc0UgN
         xSjQZ6XCacGMsSNBEavI6CfcM0/aJURAyB3DCpb5UEDpOpZ3pU+CcoG1FpnlJ6kgtwc0
         2eP6PTTzewxpdWEfNlq7dLyvK05eMGM3eqQW0dciftZUjna5dtE1DFMTyjk2B2j1YZlF
         0qksIbzriSYFhYDXc/pM41BrcOT/mJKiIhj7K072rCPaAroIajHyCbmea18lvV6Ev9sS
         TWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6QXxKqfQ1KFWWVEQdtVCU1CqxX/OD+MUCly4H9utyfo=;
        fh=t2Gc7/HuSQOmDMECgWvjA37KASv8f2pu9L4BvCnQSdg=;
        b=cSja3v69GlyabU7130rb/FgYwJfISRs3v+Ie59rQwuO+ulJJOa1fqEX22oHnpfDB3K
         VSZoQLKgm2yM5X2Elt3tnpGEmamqlD7L9Btdrv+BL+OJjEsIL2i389gR/HxJDZBl3In9
         DGmD/LD2uZ9O+NhG6IWW+sI+ReEvVeJ3nGm/ad79eEI2xtF+UX0Ul+ScDUGdmmtp+6xH
         GVSLaNHURHbSiUiN711aj217gEO1XErB9peZF9vTz9kMORQHhyNY4aSN/APPj1+x9se0
         OU0E1sHmfDzocwDGxZqE3DVQ0aZfw5Np6Y+Zm0bFSjur+wwExvvsnxf1zjKUBqsx+uNv
         FFpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785407304; x=1786012104; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6QXxKqfQ1KFWWVEQdtVCU1CqxX/OD+MUCly4H9utyfo=;
        b=ksmCxs29vnQ6BrGIiWbWq7Gn4l5lKgqu3/J5xoYlyY4QDdqHEWh/SvNJ+CsqnCOyC9
         7x7adpCC7uyQaHLoXzNNi3A/5lSidS0D0Oj6siGYTLUw5hRWvSf8kjSre7tcC5ZSOeVr
         gvYUTb7PR6N+1VXLbbqFnUHAmN6czQbAtUl5I1elPVfnljWff8MFJkqYskYyl/jKXvcl
         Ssl/f689POigfBR9Tn9cH7d75olYFm+AMM+mJSQ8oUCXi2z84KiN94Uodvf3NC9XX0z9
         C4mugiRIvkxfGNZ8BMnnnPt+RV11KqTsNATSnTlLbOW+NNXRFS39Ejscb0kGNf+b7tBp
         5B+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785407304; x=1786012104;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6QXxKqfQ1KFWWVEQdtVCU1CqxX/OD+MUCly4H9utyfo=;
        b=Kr+V8wH/mhONud4r85UwhzX43DWle2lBUzmAAX5je3pepMVCdLAol9QDp+fuP+kL3J
         9T0jgSoIlFbGt72GIm8v0vVOwGRhZClHgI3cUfkTyJ0FlXJMrB4ukKvYxE49Ao5QpvMc
         DEO2KRDxEIdfS+FYlAdrYPOBBWykDVG6cL0T3mgGNJ23xF58W2hDkm8Tm5kxsZ3Wvs9T
         P7DLzkqjCmr6QDIX4mkBcK+rWwQKlUPebnu8UDEDLdWhjooHF95aYr9lA2DP2XD6rlbW
         D6aZZYnyVlYHPaFyLV65JNkpW5TMpvWKB8TLTyIflrUM4KCbwAkqcWGYZLZS97ZMUcaj
         bqoA==
X-Forwarded-Encrypted: i=1; AHgh+RpQmgtaUTm3tFxWE80WG1ADUu6oJ8hH2TX5oKrr9DFj2GMU9X8q00jG5e5nW0AY8uOovNDhL279IYuN@vger.kernel.org
X-Gm-Message-State: AOJu0YxOYSBqnt89/6BkGiQezleSXqxWWmhzTrpU1XsJtPrkwbYi1aJZ
	Lx07ZCwq4gD9breGinnNci/HrG4VKRNJfDJGrjESktKFfWvemuCKSTtUM494+B1mItQ1tr9MHao
	ySkrdrWUCO7njV1Y4pP2ctIBWUfdRoMQ=
X-Gm-Gg: AR+sD11bOBbItSGSD6TzyUgNlgora3PZSKkF3+53i4E/01UZpVvY8Snl/CEowumxwWj
	S1u14MyQ2MNW0s3KpBTd307I0G9KC6LSH2htBvc8XP80nAOUXK8lgCrmP7O4Ul3egytO8z5dozK
	6dRzLw6e4FVeiDDhtZrOZXMDqtqHWcfUPTM0BLdrkyFjHAhKjciv459A37f84x/67WrO3ICC4s2
	8SfNVpnEQtKwxS3AAaZlAJpv3RV7/nTzfxe6EZnXB7zRIz0ZSq1pPykJHhoB6C5zvN/XVHq5ygN
	wWISYiArOYBhLHsnUfK63PyJaTT+PQN+nfaA2B5b68U7xUTCDdHq32kIO1ujEpmMASwFeahBMg=
	=
X-Received: by 2002:a05:6402:5191:b0:68e:4c0:f59a with SMTP id
 4fb4d7f45d1cf-6a07b851903mr1040959a12.2.1785407304296; Thu, 30 Jul 2026
 03:28:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
 <20260727174826.135662-1-nicoyip.dev@gmail.com> <26c1ea30-e6cb-4f3f-ab88-6d00f0ed2117@redhat.com>
In-Reply-To: <26c1ea30-e6cb-4f3f-ab88-6d00f0ed2117@redhat.com>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Thu, 30 Jul 2026 18:28:12 +0800
X-Gm-Features: AUfX_mxYT1x8uX62KawheLXfNHW3ozwMozJnaYpC63DKgR1SHsZfZifetC9okBs
Message-ID: <CAAo+4rXxnQFBsAtHuTNKiU60dMUnw5u+A_=EsQn8ntzJNV_++A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] rds: synchronize info callbacks with module unload
To: Paolo Abeni <pabeni@redhat.com>
Cc: Allison Henderson <achender@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Santosh Shilimkar <santosh.shilimkar@oracle.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, 
	Dan Carpenter <error27@gmail.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 6:02=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> Hi,
>
> It looks like I was too optimistic in my previous reply.
>
> On 7/27/26 7:48 PM, Chengfeng Ye wrote:
> > @@ -78,8 +80,13 @@ void rds_info_register_func(int optname, rds_info_fu=
nc func)
> >       BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> >
> >       spin_lock(&rds_info_lock);
> > -     BUG_ON(rds_info_funcs[offset]);
> > -     rds_info_funcs[offset] =3D func;
> > +     /* Validate the latest published slot value. */
> > +     if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]))) {
>
> This read is under the same lock that perform the store. It's totally
> unclear why smp_load_acquire() would be needed here. Very reasonably
> it's not.
>
> > +             spin_unlock(&rds_info_lock);
> > +             return;
> > +     }
> > +     /* Pair with lockless callback lookup. */
> > +     smp_store_release(&rds_info_funcs[offset], func);
> >       spin_unlock(&rds_info_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(rds_info_register_func);
> > @@ -91,9 +98,15 @@ void rds_info_deregister_func(int optname, rds_info_=
func func)
> >       BUG_ON(optname < RDS_INFO_FIRST || optname > RDS_INFO_LAST);
> >
> >       spin_lock(&rds_info_lock);
> > -     BUG_ON(rds_info_funcs[offset] !=3D func);
> > -     rds_info_funcs[offset] =3D NULL;
> > +     /* Validate the latest published slot value. */
> > +     if (WARN_ON_ONCE(smp_load_acquire(&rds_info_funcs[offset]) !=3D f=
unc)) {
>
> Same here.
>
> /P
>

Hi Paolo,

You are right, that two smp_load_acquire() are unnecessary. Should I
send a v3 patch to change that two smp_load_acquire() under locked to
use back plain read?

Thanks, Chengfeng
