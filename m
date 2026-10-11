Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBC3306744
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 02:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791687246; cv=pass; b=pkrrk5qBEE2ONVEj/m1+aEDAiOZgQN0kU7a1nVlNn7hqk4MZ39f+wKc4bumuViugdiNCnmv4bM2h5as1qH5iTPrePnWEjfXEhaGrUhLHU7Rz9hoLdBoRmEwi6ggGzbM9AFjBDf8PSyQtutCC4QXkY1jKrNJgOVlEoP7Ml3A7yJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791687246; c=relaxed/simple;
	bh=TtyBwfmEH3Qw9cTr/b5h+StO88FfqoSbIz9e8paJbwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OtCwd+yDvxuuebI5L69jeyyGNxL6Sp3eCWsApep9nX9Mf9DV+KAgvZ0FgoNXXLq4f+Wrn2JTwAp6fcgC3zQxZWAG8Oql2evv+uNL8xgqcg0BIKi4XR2FntsRzktW3+S/q2avQhXk7bysQ8h6bWWRvLLTKO0pgaPOXOJEi9gK0RE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPUzKgJv; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPUzKgJv"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6aa9164072cso1294184a12.2
        for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 19:54:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791687241; cv=none;
        d=google.com; s=arc-20260327;
        b=WC1UAdaciyGTZ+fpf8GEa6a83/x58gVFSzbqRpr73hgNzlGoYhZHUAtie++1ovWDv3
         t5InxV4OhLE2aOTU1hNP/GnykxzFdIa+FUFfr8EXOIYJ0JpahtnX9Xzc565KRrHffjtq
         g0zNo+jruvRkcLrt1paeG/512q3t7XCvSZDpGuaD7Zp+mN7q4xTNUxlDz9VLlWKQ+Yg9
         bckkM1qinvdz6gCcR7jMNE0W4Ix1c71tUcgJS0TKyoVhTuQRxA2RcpXzorHvRfGfl4+B
         EgCwpR1dgO/hUs5IS3i0QTr+jMMJnSKjRoF6zSUQtGavJp4Jjq7TveaKEVk1m6MsnxA+
         u2pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fyP6CG/MmWFtaGWCfyVtclKnfvDKONsgkJWdCRKUOco=;
        fh=Ba8AO6YQw7puc+2wNLyFKrhdOdoe9JsM9GiAb2iSEKk=;
        b=RPoAm3tL32AvAWlSKKGCJ67kHo9YBsN2l1Nb3wu5J8OMvL9tKmChyGmDLs/GZlitUe
         Ubr6VP7J/LsktSW+iy4+LVUojeNwTg29xjHnHWRE0mcauSBWeaImW296hmzbd6Y1v2M9
         dfqmH2acm9XFimDqWo/FYoRaVL5TAeyT/EARObHqSpBV2KpV097lj0bwIQiCc+EjtIsY
         2T3IGsW7yOYGHZjmkyR/TMm27TWZKu20m8k4h1yMYGB5VkuI9zqtMY5/6PscG62MYKFs
         nIJYnC90rIvdA40eDTiOIUn/ajKnHH/wJEC9qdgFtO6zKR3NybL8A8NiCQFn+7uZU1WQ
         RMSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791687241; x=1792292041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fyP6CG/MmWFtaGWCfyVtclKnfvDKONsgkJWdCRKUOco=;
        b=bPUzKgJvwPHtlXuT7nptIb8ptZOT3gzx0IPNd3NEC1o3MeYiCw6xAeeaGnY1nOdir1
         3NxO5aApkrwi1yJbGPA5RZhvKf8PQGlShlTQWCpwcBcmnx9oyo75dMBRbsu2w+nNJ/i1
         GxahXolACeoajd/uPeu2vsUltM8HxgS+hEJBUX194mo6Womohe+Vo+XU558zU1+/fsRV
         KntG93zproDPSIJTso/GtEFckOQnoDQKYYPqZXAsov+4XIQwHPQLVrAD08LBZ9pZtbU/
         DEJhWbdg8jR0KzoNdYBSvog8LoZROKQ78vsapkQrD56UcQC1Pp30kIhY47rhGS0IZlpY
         NqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791687241; x=1792292041;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fyP6CG/MmWFtaGWCfyVtclKnfvDKONsgkJWdCRKUOco=;
        b=qMjKqrzkfj3A7RzZLjgudFtaOQI6iRyLshyfrs+VH2niIma4MIPhPCPjcbPM9s+0Z1
         ekvjNXG6fE+6oV77pvky5vICT3AcM2Lvi1RdwKQzedRoyjCnMRRgNsZj4Kr/omN8mAJ/
         mDr8mdv7eADRKqAX+lXbbo0dxlH0gMrsiRCdV0JIb/PSwQK41OS5WJ9Wd4VG08k+0oMU
         rouY3QUCunBaEf6mImQCYf+xYwyCq+G1L2So7YNCbDSX/1Y3sepQzD/9iFJ86TY2WF4Y
         DHOkpBkfapu1pPaDf9KgqEEoPQrmy02NszpVSi1L85usUb9EBeNEL9id2iCw51DypgsA
         lQPQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0lmcUU5PLoNp3Q1oVbSxJJ+xh1cGsdMiRVkR/xJCiaEcHFrPrgZDnl1pgRwS+iIyxBg1Q6OaBfuVj@vger.kernel.org
X-Gm-Message-State: AFq9FYI773Ol2/F5vO+SLRSdD7m606L9+Irl7bquHsyc+vnxkz2pOrNq
	FCtq+UfL496hEedNSpbCixLzEJ4dA/QW+EhLupT5ahwUOGK7b+5SIxN+329O3iPpUAmbY1wT8Zz
	OPMUQk+Ocov91evsVpRSqter9qBQ/HYS6APNMtII=
X-Gm-Gg: AYBFou2UAL6N5iyFwoUP/MQjigXSHN2rhfG04+rIq8mP3vtxDoI+j9ywFVhecz0kcMO
	D4LKLdhPqu34Isngj+G0noOhVoDDKOS7KDqLnbw6dWRxcrI5o1DQKsijuHmlbfHyZpePtE188VN
	dQw1H2p7cta0K94C46mklc5asjT4Svldv2+tkeH9PZGQr6Uv8bxE9moVDXUpcPBx2XLB9TlKleb
	HshzZgQS8VsLR6T5n91WLFHTibv3QJkMsqXymTF4ydoww2bTvFty/Q3FUQEP9Pe/77VLMpahdi0
	yMUqS86+3swRty68XU51F+/MdvqUa/cOnsrX9DK/gTWDEXhCMz6Yn2u2ehelKbitu2dvooYpk3d
	GZ6clEhse3i785yPQ9oVhwxnuAGPNT5XUvN3ewoVmbXgloGC//4/i3q81b8PWnwXOaxagOdmeqs
	1GsWYwTS/tTFy0dKpTjGy3IutcPDZO44dCDVekiiX14Z9Hywnv8Z7AtipyLKADSvdj0MgoHEGzX
	OraRC/dbDqi24HjBDecU3xJ+ALiZV+y3YBZCWduHZhKPw7adVavTSGEC/RUkT5B+SBmQDTfm2Vn
	+RFV1YVQ
X-Received: by 2002:a17:907:2d12:b0:c2c:d06f:cf89 with SMTP id
 a640c23a62f3a-c31a9a10df4mr535728966b.2.1791687240866; Sat, 10 Oct 2026
 19:54:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007040009.137568-1-atharva.a.vartak@gmail.com> <sashiko-outbox-162620@kernel.org>
In-Reply-To: <sashiko-outbox-162620@kernel.org>
From: Atharva Vartak <atharva.a.vartak@gmail.com>
Date: Sat, 10 Oct 2026 22:53:49 -0400
X-Gm-Features: AclHuK_VRhFl2QnU4-PLdqLkG3n2BnlNN5bAfz2ea1QbUuSDNKyKsM4qI9CZFqE
Message-ID: <CAMaGtJZa8FvAYP9aq3JZsL6u6xN1MpaM_mj0yAmhp+RDAfg76g@mail.gmail.com>
Subject: Re: [PATCH v2] net/smc: hold a reference on net_device returned by pnet_find_base_ndev()
To: sashiko-reviews@lists.linux.dev
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, 
	linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The bug was found through manual code auditing.
It was confirmed with a proof-of-concept that triggers a KASAN
slab-use-after-free report.

Regards,
Atharva

On Wed, 7 Oct 2026 at 00:07, <sashiko-bot@kernel.org> wrote:
>
> > pnet_find_base_ndev() resolves the base net_device for stacked devices
> > under RTNL, then drops the lock and returns the raw pointer without
> > taking a reference.  All three callers dereference the pointer after
> > RTNL has been released, creating a use-after-free window if the device
> > is concurrently unregistered.
> >
> > Take a reference with netdev_hold() before dropping RTNL and add the
> > matching netdev_put() in every return path of the three callers:
> >
> >   - smc_pnet_add_eth()
> >   - smc_pnet_find_roce_by_pnetid()
> >   - smc_pnet_find_ism_by_pnetid()
> >
> > Fixes: 0afff91c6f5e ("net/smc: add pnetid support")
> > Fixes: 1619f770589a ("net/smc: add pnetid support for SMC-D and ISM")
> > Cc: "D. Wythe" <alibuda@linux.alibaba.com>
> > Cc: Dust Li <dust.li@linux.alibaba.com>
> > Cc: Sidraya Jayagond <sidraya@linux.ibm.com>
> > Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>
> > Cc: Tony Lu <tonylu@linux.alibaba.com>
> > Cc: Wen Gu <guwen@linux.alibaba.com>
> > Cc: Willy Tarreau <w@1wt.eu>
> > Cc: linux-rdma@vger.kernel.org
> > Cc: linux-s390@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Atharva Vartak <atharva.a.vartak@gmail.com>
>
> Sashiko has reviewed this patch and found no issues. It looks great!
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007040009.13=
7568-1-atharva.a.vartak@gmail.com?part=3D1
>
