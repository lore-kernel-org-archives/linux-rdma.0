Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B584647A874
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786028439; cv=pass; b=gOj6gn/OyNgkgsefncDb9M4W3/QKPlHRZuwcwM4pSV/UZrUZVjrLkyNaefkZmy7rpOqwY1VADQ/FrED93zfLwz9jPXNESUdkfu47QIYnPTINeSlCSlrLgGFCUungAFt4VPI51GkAUuegJQFRuTAjWtzxXbIEbkD6ib/Qoo+yW7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786028439; c=relaxed/simple;
	bh=xHWfrtbUKzJn60DpMzTvrgdZeVM3KtRHSI8GmZl6zPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pbTw9+pDTSRLfv/Ca/LGlk2fO4oNPlaHPQEkkDFFhig88u0pQcuOnXTA7X8vGgpfSPmr35NP6364PLjTNX3MN1afT8IKJGEEQwCQhitcLzgfIJRHBVn7RpAd3Uj7rDl7io2aPc+kHVsBSvKcl9jqFiQQ6jJTPUp9Fd7Q1mowB2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BKSxu1Ra; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BKSxu1Ra"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso1477635f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 06 Aug 2026 08:00:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786028433; cv=none;
        d=google.com; s=arc-20260327;
        b=Q7iC8+WyQCeSNNV2F3vde19EojuVeTYzh8Ksnstle4gNMMpHAqD7YooY+X8zuq7F9T
         1myx4qQ50brd3efewyA89I4m702upY6ERjoWPnwbeYyrZ0xjLt4WqTL0wUF8P8ZCIbOP
         XuhRMvYEpzptJsTGgFhwr1MO3jChOmjKUZ6oaL8mFDyeaYlGAsrgIdAAyEWRZIyxcVoQ
         edKqCX5RBW+uXWkXK6n8hUlO4rchMbVNaQ58eCBuXzUjfBHQmX2gpAzfScwlQ4mMXdPK
         zrfOi0ct8iCAKK0B850AdWEMpYntkJ6l5adpg4PIEXDCkgZSv5Rg8K3YyUArwZQpQ6Ae
         EZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bLCroHoGf0o5ghe7Jl8U/e3ej3D31Q4DTDci56rDNSM=;
        fh=jfKuL0kc+GRuUbINysbGc94Sz+MZEortQGWblBONecg=;
        b=X84qQSQ75Tu2g3hvsVpGDDE/NJHL2xh73Hi5x1rEnRWF41zyOggHeb8GtI/bkvUal6
         7a7CGjI1fpSwK/KfSmC5bDNtJ5E4f1IrUoIa0dzFRWz+DRGGk19+r+i4U4k8O3DMfvvn
         hDrQ/M+4pjezk+8sqHxmpIz7AkRfdp7/8S2Qqn/WoIr/GyI7xnqe2cPCYu0wOxmHlemZ
         z+kWnlfick14yG8KCP68xEyDZLX7zjJbg9o9O1sDGm4dFP6UaZ+9lbEN5fGGGF8cLFdE
         EmjnrwdkpCAn/GZ1sslcsjtHQTg92PcrSiiCFO7CCfDGeJ/eX+Kc4vPhVt9rL9jRCPpq
         Hf5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786028433; x=1786633233; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bLCroHoGf0o5ghe7Jl8U/e3ej3D31Q4DTDci56rDNSM=;
        b=BKSxu1Raq6JT3Ik0gqq5iBH5cROw+YPM2+EG5MwCXqCZ2JpqHTJyqFznlT9ikO6dZN
         +d6pDajoVcRTZ5sDWVeZxBRgNaIAieqhHV/yzu4lP+bidE+ORLMqgvrWHhxFcfRF94S9
         +EtudeYin7bNjC2etIxahk/Jx57p6j6g3Wl74oh87FioCifGvjLqxQj1BC3phTOCap1h
         BblC2Qq2UzLABLvhtIzrGkhrxiNdVns9ehxCmfWqiNROy4NS/e0rTfey0Cm2zNxUDlLv
         j2TFzagrmemJ71oo4NRoT/yUweoOCc1b/edb7NuFzXqBC07Ce3Je5RMl3/JLgWa5Gt6l
         krpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786028433; x=1786633233;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLCroHoGf0o5ghe7Jl8U/e3ej3D31Q4DTDci56rDNSM=;
        b=rdK5kkwvI+qYHCrWwY6fok8dlxvwIuif6CMBO/RG5kZCP/RNZRuwBnGJoc24vX0U2N
         Dj4Z2Vn5fyvqVngF+uGiuuWKv0Qt6m/4XR51SckuGRYNq2ayhTpYNpGLIL1H70yb0Z0e
         ndUvivv61mDTpUkjFavbeTASSRkaALyjpSPX3I3Ridd8kyotDSRKIzn6ke6xr6HVQ6na
         YuF3thWLPe7cOJAsSRZaMS+S5ppdQZ+3eLRbvI4rXq1cxmzSwK7357sA8/V/OK0zrdzU
         1AEHg2PBnzDm4VANVcbRtnIxgjgbWHMiDjJ6KGxPopkp510ciRDDrt42b3jA/kIvfMNA
         VdKA==
X-Forwarded-Encrypted: i=1; AHgh+RpmSNjGwrIG/3CgKirHXTdL59Mzn9+GKVh5p4Fci5568qQPFK1zlSuIJrZLhcOmYGvxJegDdDD1DFBw@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2J2dJaYxsrhLRyQOxXkvM9+r31thtPB5dJObLfhLEJ+qIxjZ1
	0WeLRXraJ3EzEQp0UxGq6hi4neoOxUY718lbBwU9OdR/wzzhcp1fter8rBejF84L0qHXtNq+bRD
	ErkpI73bh2svvArspcSvOMe6bI3KeC9Q=
X-Gm-Gg: AR+sD109yVHRhJPr0r0cH4Xg54DxugsbJ09SkV7FidXyGkJ/F5T+QRar5Huo4fKUFdf
	+80HeU3ULnc3qcYK4O/yJ/JvLxrWNgtLRbZtY7KKmzZ/d8Vt6UJvwgMkcIhwEqC9IK6iDqDi1Dv
	gISKW6vpNIHR16QFM+rdzAiN5F6eBFlquVDowZq3k2WMhLDORYiPo7SsSS6HA76gGccIYwvXvwO
	pQJRK7RihTh0VeZNbKypNwXjgTcaJ09CMheaS2YRsCrCErQv/JAmS0Crmk6hBwM7eTFtiDwP16T
	j6DzzU316MhdLTIzB25+ilETutuV9FKIxkqUWGpujY8zgA==
X-Received: by 2002:adf:e005:0:10b0:47f:8b9e:f44e with SMTP id
 ffacd0b85a97d-47fec52828bmr21215134f8f.12.1786028432410; Thu, 06 Aug 2026
 08:00:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804213917.3413525-1-gyf161023@gmail.com> <905fe2d9-a8c9-4047-82af-6f530d024ba2@linux.ibm.com>
In-Reply-To: <905fe2d9-a8c9-4047-82af-6f530d024ba2@linux.ibm.com>
From: =?UTF-8?B?6auY6YC46aOe?= <gyf161023@gmail.com>
Date: Thu, 6 Aug 2026 11:00:17 -0400
X-Gm-Features: AUfX_myepY0Ow5BHeLBg3UOI6iMPPgT6p_3js1Gm3-IOdv6gZ05ymxdaZ7gYMsQ
Message-ID: <CAB665WCeZ2bTxCduGqKb_xeaoDb1Ty9wJ+vZ2be_jwj5osHYrQ@mail.gmail.com>
Subject: Re: [PATCH] net/smc: fix sock refcount leak in smc_switch_conns()
 error path
To: Hidayathulla Khan I <hidayath@linux.ibm.com>
Cc: "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org, Tony Lu <tonylu@linux.alibaba.com>, 
	Wen Gu <guwen@linux.alibaba.com>, Karsten Graul <kgraul@linux.ibm.com>, 
	Ursula Braun <ubraun@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hidayath,

Thanks for the fix =E2=80=94 I see yours covers the same issue and was post=
ed
first. Please disregard my duplicate.


Hidayathulla Khan I <hidayath@linux.ibm.com> =E4=BA=8E2026=E5=B9=B48=E6=9C=
=885=E6=97=A5=E5=91=A8=E4=B8=89 02:26=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Yifei,
>
> Thanks for looking into this.
>
> Yes I have submitted a patch for the same issue.
> https://lore.kernel.org/netdev/20260804082800.498672-1-hidayath@linux.ibm=
.com/
>
> Hidayath
>
> On 05/08/26 3:09 am, Yifei Gao wrote:
> > smc_switch_conns() takes a reference on the socket with sock_hold() bef=
ore
> > dropping conns_lock to prefetch a tx slot. On success the reference is
> > released by the sock_put() after smc_switch_cursor(). When
> > smc_cdc_get_free_slot() fails, however, the function jumps straight to
> > err_out without a sock_put(), leaking the reference and leaving the soc=
ket
> > unreclaimable. During SMC-R link failover with an exhausted backup link
> > this leaks one reference per failing connection switch.
> >
> > Release the reference before jumping to err_out. The err_out label is a=
lso
> > reached from the smc_switch_cursor() failure path, which has already do=
ne
> > its own sock_put(), so the put must stay at the get_free_slot failure s=
ite
> > rather than at the label.
> >
> > Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
> > Cc: stable@vger.kernel.org
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Yifei Gao <gyf161023@gmail.com>
> > ---
> >   net/smc/smc_core.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> > index cf6b620fef05..04c6ce608ec7 100644
> > --- a/net/smc/smc_core.c
> > +++ b/net/smc/smc_core.c
> > @@ -1148,8 +1148,10 @@ struct smc_link *smc_switch_conns(struct smc_lin=
k_group *lgr,
> >               read_unlock_bh(&lgr->conns_lock);
> >               /* pre-fetch buffer outside of send_lock, might sleep */
> >               rc =3D smc_cdc_get_free_slot(conn, to_lnk, &wr_buf, NULL,=
 &pend);
> > -             if (rc)
> > +             if (rc) {
> > +                     sock_put(&smc->sk);
> >                       goto err_out;
> > +             }
> >               /* avoid race with smcr_tx_sndbuf_nonempty() */
> >               spin_lock_bh(&conn->send_lock);
> >               smc_switch_link_and_count(conn, to_lnk);
