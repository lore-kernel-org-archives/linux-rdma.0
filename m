Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89D747CC91
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 21:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792099171; cv=pass; b=tlxZ/3cy3a6NaYCPnEVOGEgiSlRhk+C+FX2YFDP3tH4zcNGhsFWAuzLh7jbgDN/HkamUPJzmrvbO7lZ+dQCv4RUr63FOGacaa5WyU+19wK6gsueFjbjkDZ6/fyyE1Hw8tHdxpXwMXByXrUGx77EtSFuoNO780qAwadZ9LPxf+dM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792099171; c=relaxed/simple;
	bh=Uz/5hctKvlaqdWO6KpHIaPRKCJnqvXCmJd5cUbHaT7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PGFQHcz2eP5bwcVEZ35tyQN6UzxSQ6cKJwhW+JoG8k6mGXjCDb/AQpz9U9Mfstq32Y6Lu2gyI6XecJDGx7+vX3RC9kzXI7wprajb8AhlUHcIKELeKJV3wT6uEXgD8Aa8kfI/3dkU37sL2JJkHeUMvYIVE3LzRa3LZvpoAY2b+HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=0LkLPT2h; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="0LkLPT2h"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3282db206d3so808131eec.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 14:19:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792099164; cv=none;
        d=google.com; s=arc-20260327;
        b=mioZv56GHze+Z6117N9/pAkseKZUcpVCthhABNzRAgO8jDwqTzgiZ7nu1oWdAUFtNn
         l9NHrj1V5UqTegfmj8T0wcamA5bxLJcztnv/iTE3P7bsNS2YZDFR3gGB+s3e2YqvRJSZ
         yESQiSt7TAiqX1VqKYm/R6uvXOKEtcvw0vLkV0F0CnXZfZaC1rLaISu8CI0pfiTA4LnG
         xVrTZDEie7iurCeyPSNAU5tbcPmD8ZXAaUHzL84RlDjIZ/VvxiK8nLYhi3MarYjrUow+
         D1C9I3T8DI0SBmC+cDta6FEjomyk/u+fcroVFpwC5KP3fHnYGa0tArCIEUxkB3aaO8N7
         YVOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WFhecx82FkxQ1C38UPIvum31gQyjmwYifrg5hB5ZM6E=;
        fh=Fjjq3fn2EBZGWDcjiliJtsp9aa9LurXF2QHHutcMKj0=;
        b=ZvSmLSsS4NDKVQC++5u1WwDDGeE1U8FKRAr6w0AEGCSkIZhhfe4I8G8Px3boashHUw
         C/0XBvC8MIoFi9HW+pQtsKAOxmNkO7vRXhG9gbw22G3Lv2g9aMFUZnkys0xgxvut1jDS
         zVReVUeB90BzdYuNUn84YaCap0esl92mxFNR+c7aUHSvJfry04fOocFZyWmgvK8gjL0H
         ng0Bx+ju9mHDP7AbgbTHmdJVMHe1+rTNUqX58++ufCzsskIs1fgW6TQzPj3e1x1nlTq9
         yuEVmqxYPTne8sdsE8DY5zsuWpCt5sgIt3iVFbP4kx3MgGto2hSmD0RGNhmBME7nG0/n
         Hgbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792099164; x=1792703964; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WFhecx82FkxQ1C38UPIvum31gQyjmwYifrg5hB5ZM6E=;
        b=0LkLPT2hrKkXY2CZBX5DPXvTJtNPaaYR2ncurNgOJ9XF5KdaPDw9in4Uoh20GkCY7U
         56u7MXyHVdGIhKPze4p4NBjIwjcEoWNGrfDuzcdg6FXx+NjBDUfepT/Gafots4TNFFUQ
         2k1/xJIma8uTtJ0hXZx+1I+omXPo7Y2Evb5t3h+YbHXUNCMMBstkDzc1ug7MTt4xPxFW
         kPyz1gwhR8shckEdhlft0zgi1Tozd8JX0nlBfn4VahMg/lsX9JARgIgC6mrr3kB3XiqY
         4YWPv0hSPiib7f8LLWOYP1ZmYtoub61GSWJavBywdDmKxNpRvvyHEHF1gbjQ20s0ZjQ7
         8Q3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792099164; x=1792703964;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WFhecx82FkxQ1C38UPIvum31gQyjmwYifrg5hB5ZM6E=;
        b=HAbsLUKz8lthARBObJsVcVa4QBjae+qaGWDMxPWYVbMj2BLznuhn++mlwlK0ulivdN
         wT9/TRZ+bFyaeFa3d2oKEWW2h8samB8Hs0X42P29EQeXh0MeYnAHKhfz8zBmr8LjpkKm
         Dv7a57Ta8XpG2oGAl+ptfAHP6bzxfDyx/vCKAMOXDA29nwAQR0a2PHp5dSk0Is+oTKTR
         Y0XoTBOsJLhQUxFj4R2Kr/XKpxMdINHls7Zz3ofUSGSmiWmSZ3MhThH8Mxzya4Dn4nmv
         p7vig15oeLwy/1KADbjLb8baJYFrk1qyssEbKqdRlDDTnv5fEsP/JAFUDX+/3ahUlfci
         UAog==
X-Forwarded-Encrypted: i=1; AKwUvBz2JQFh/AoIIwWJajl1fB9k67Ant6RRI0Uj9DSeatwxw5eVTl74CmPPdqiQ0p7Clzaqrpjf2oAodQG8@vger.kernel.org
X-Gm-Message-State: AFq9FYL4nIxDu94V4LnTtTExLGlAp4E5n7xxvmQkP0Qpzgp1ndmeHU52
	eLx9FzVy42Gr815W7mUZT4mohchD4hfYu1pIGTWYr0z74XeSJw5ggA5P9qOcwgMSAS87N8j+6sy
	TSoxLxZPg+x7W+UGPzTR+3fNyqMpXU8UA+oVutU2b73I=
X-Gm-Gg: AYBFou1i2EygbonRMRVl88scQlttO50GVHUN1dfdVdcE6mDV6y15SuO7MoHhKs0sy4r
	5bIPhMD1uDAphVmTAJXHBf/PZ8K/d/5owFkzSfLuTBTgvprUzkZ1Ml26DQt3cvPB+bdBaDmOCOb
	HuqA011tet52nTFi27vUo7Zg/CXUjQLVf5Kl/leBBtRqlEZytlA3x57H+okBo/Ef+IzAYikdqw2
	JnnSRzjvJgcb9C+GZspbOW14WdzUyDk27aJDKkniFbhP6hO3/QeRENxZ9HFrklrLsHBEbKGmxaz
	kU4tqV0ME/CLYDpLq/GyQFeDFhl6PL2fF6/ZjrKmlUCjYjxy0Qmyo0ooIWnIjc5d5rrfX+XqwPp
	50EIBY2giyH6GTtucvzrYcLmYYL/3dG3knb/9LNVe0g==
X-Received: by 2002:a05:693c:2503:b0:35e:5db8:2ef with SMTP id
 5a478bee46e88-35e5dc756c3mr5975575eec.24.1792099163746; Thu, 15 Oct 2026
 14:19:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261015011940.4122452-1-dhu@x6u.co> <20261015011940.4122452-5-dhu@x6u.co>
 <20261015181713.GB219304@unreal>
In-Reply-To: <20261015181713.GB219304@unreal>
From: David Hu <dhu@x6u.co>
Date: Thu, 15 Oct 2026 17:19:12 -0400
X-Gm-Features: AclHuK983uRNo0pxUvQDGtecJUcInNsMhMtPfO5CNth4ZI64eLju23gowvdoTn4
Message-ID: <CABdL-LQK+hQkJkZVA8iwSVYTnBLtX7VYJ=VjhP534MR7d2ep5w@mail.gmail.com>
Subject: Re: [PATCH rdma-next v2 4/6] RDMA/irdma: Split CQ setup to umode and kmode
To: Leon Romanovsky <leon@kernel.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, jmoroni@google.com, 
	eagleshaw@google.com, xuehaohu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 2:17=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Thu, Oct 15, 2026 at 01:19:38AM +0000, David Hu wrote:
> > From: David Hu <xuehaohu@google.com>
> > @@ -2624,6 +2624,126 @@ static inline int cq_validate_flags(u32 flags, =
u8 hw_rev)
> >       return flags & ~IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION ? -EOPNOT=
SUPP : 0;
> >  }
> >
> > +static int irdma_setup_kmode_cq(struct irdma_device *iwdev,
> > +                             struct irdma_cq *iwcq,
> > +                             struct irdma_cq_init_info *info,
> > +                             const struct ib_cq_init_attr *attr)
> > +{
> > +     struct irdma_cq_uk_init_info *ukinfo =3D &info->cq_uk_init_info;
> > +     struct irdma_pci_f *rf =3D iwdev->rf;
> > +     struct irdma_sc_dev *dev =3D &rf->sc_dev;
> > +     int entries =3D attr->cqe;
> > +     bool cqe_64byte_ena;
> > +     u8 cqe_size;
> > +     int rsize;
> > +
> > +     if (entries < 1 || entries > rf->max_cqe)
> > +             return -EINVAL;
>
> This if() is impossible.

Hi Leon,

Right. That is impossible following your series in [1]. I'll clean up
the checks.

[1] https://lore.kernel.org/all/20260213-refactor-umem-v1-0-f3be85847922@nv=
idia.com/

> > @@ -2689,109 +2806,12 @@ static int irdma_create_cq(struct ib_cq *ibcq,
> >       info.type =3D IRDMA_CQ_TYPE_IWARP;
> >       info.vsi =3D &iwdev->vsi;

> > +     if (udata)
> > +             err_code =3D irdma_setup_umode_cq(iwdev, iwcq, &info, uda=
ta);
> > +     else
> > +             err_code =3D irdma_setup_kmode_cq(iwdev, iwcq, &info, att=
r);
>
> No, the idea was to actually implement and set ,crate_user_cq() callback
> and clean as much as possible from existing .create_cq() callback.

Thank you Leon for clarifying ! =E2=80=94 Will do. I will send out a v3 sho=
rtly.

Regards,
David
