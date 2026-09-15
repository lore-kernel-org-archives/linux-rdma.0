Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6013D46DFF0
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 08:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461112; cv=none; b=BJanXEfIZs1n+sx6HLv7JX1Z1Y5DV3lvUMHjccP6MFc94fBifj//9UacYY/NeEglVY6oOX7tJo6XuAkYaLi9uiG9cqNaP9+3cdV/1VwbFmHfwqVInfCneOBOSFUkdRF+O226r6Usnb6AjYLzd5fd3WFtXLo0NuQVfm8k+rYMqOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461112; c=relaxed/simple;
	bh=L7RD5s26S/DB2ccyOm4dda/qhcxL/voBIWld5IvohRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fm92HAL+hF92lzo9hl801rXtkmVM5JPusqVQ7HxdV8Rk5Px2UV/Cwq7LinKhv5pQAol+jy5JlULaHgP6CigpxD0iR0YbnNyipzU/PvSk6tYqs/CKzGYR6PDxTPZbY4fLGx6QueHdIAv+aBYShmOziPZ0Nhu1Ho5VsMc/oDgPnPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Hs+xD1DS; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Hs+xD1DS"
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-5c989be99abso387128e0c.1
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 01:31:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461110; x=1790065910;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5OsC6yM64NepIzbxtkIh9aok8XmnmHDYy7yrsqioWZE=;
        b=z17EAWf21Yv0eSlpQArhZeZtbER+awBxnyOJ97mzBsJxKB6J0dq2NOSc1hoZjF+bIo
         tPW2tV6/7U9KL5gGE3cw07d9LcBQbytyrZyuTxF4QgFNAlmrb/kEnQ41BErk/d7KOt6v
         TwU4eQaOIOFm8Udhvcl3OfhwJwpNRsG4lHqbR1tvPbq9wlaKqjjbKyhzPVdJIlp3L7Jp
         2SQXx2hg9KEQOQ9jk+E7H45cM7Uc0UFLgVE13HOsTVNQ+J4Uvgcznyfjey6QJpHX8iet
         fJ+N9bRYcRbGgyip9gKvCNkDmIXp/+lZHoQ62VUD5XaHI8SjWJd3EqLU77hpPdsupcCc
         /Qug==
X-Forwarded-Encrypted: i=1; AKwUvBxJF5pUa5kJ2pwn3lWlhqbVmhmOizbOuDx+cDmNT4bVQpGZmgeFnTymcnOqsTbvIyC4/dl4VF+UEzsU@vger.kernel.org
X-Gm-Message-State: AFuF++lXOwsuhddXJWraXvEB8h6rv11Wx3ww3L1bsNuGvNRgeQEso/AK
	QoDzIQaZCOzrJOXsY4NVJxOaSbCl8w0Cn+lKhxlw+EO6Ynl9IfZGooQXlPjd69fKv4pRO89jeO0
	7sS96XQoDe7nuU+2SlDmtMBtiM1P9BfVBtSZHeOX1GYCbLgYQGj7jmfacVLW3Anz88nuszCPJ5V
	vLYeSY0x0GsqRYXc1LxB0ByKpCnFb6w3LjwOZZ/1/XCYDBg0kzKDIeYDVfgOJkQFSo/B98NCoYl
	0WNPjzK1HXy5aX1Rg==
X-Gm-Gg: AYBFou1BBtA8uNBtfvPjs7y9V+l4O+FtzU+EslZehabuXePELnqS++U+QuLPuPS1KV9
	CEicxSKWfN50mTpxICcckkbi/M6RRQhuCokg+YQOkafsB4iINs7qBmGryEH/HPq4ZqHCxy9+FGK
	W3BAuDAwmoWOPQmmyBiwz+Z5F/gtM7kCkgZ+xHMmM+dAe2WJXM5CYy/2dDHgMUfvgcvvcAqKC5j
	j4968GRG0pcqbN1RNemoN5nUrg8kMPsSx9D+o5TyWLO6UYsZFh74Qv+pp7RS65D7wklsxmlVuIY
	FYjxalem0y5ktX8cTRyl+riDfueVL9y22E9fLUabqieq9uaZOhtviestv2hyeFdgYlwExg8toF6
	vn5sJ31RPxkyO+AhCwjxiosM8DtZBgz9fSF5qQNZy0NK/7h04jgNoyfRcL4Df
X-Received: by 2002:a05:6122:698c:b0:5bf:a181:d46d with SMTP id 71dfb90a1353d-5c993a98da4mr332e0c.3.1789461110060;
        Tue, 15 Sep 2026 01:31:50 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 71dfb90a1353d-5c97d662b26sm2281970e0c.8.2026.09.15.01.31.49
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 01:31:50 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-46509ab0149so5327131fac.2
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 01:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789461109; x=1790065909; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OsC6yM64NepIzbxtkIh9aok8XmnmHDYy7yrsqioWZE=;
        b=Hs+xD1DSZ057vGXcJaVKhedNYy+py+7fF/Shj2dX/QEZxGcPJgDjNlUJ0Q8tYQUXkH
         10Ay0XtsVLi4WV8S+J5vEzuQJonvbeeYsz7BgW/U/LhjTUAYYLEWgxGw4u5cl/dQ1Duy
         9tq5U15GGlF0Zjbuvhymr/G09dcpEqIup1f+U=
X-Forwarded-Encrypted: i=1; AKwUvBxb81UZIqOjs1tHKwDpBxHAf3af8GI9+BqCidKgZZrRCpWtyshrnobH2g+8aBfA36kAgEF5XUNsR/To@vger.kernel.org
X-Received: by 2002:a05:6871:547:b0:456:4c93:a7f8 with SMTP id 586e51a60fabf-481f7b29064mr4152234fac.6.1789461109213;
        Tue, 15 Sep 2026 01:31:49 -0700 (PDT)
X-Received: by 2002:a05:6871:547:b0:456:4c93:a7f8 with SMTP id
 586e51a60fabf-481f7b29064mr4151972fac.6.1789461103985; Tue, 15 Sep 2026
 01:31:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com> <20260908134553.GO13683@unreal>
 <20260909132948.GI2543240@ziepe.ca> <20260910092651.GP13683@unreal> <20260910134743.GC4083318@ziepe.ca>
In-Reply-To: <20260910134743.GC4083318@ziepe.ca>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Tue, 15 Sep 2026 14:01:31 +0530
X-Gm-Features: AcwNN1XwRyty3L6FtmlFm726nAGXcqevAA3yCsICEBNELqiQZECDO81dAfCpbBA
Message-ID: <CA+sbYW2_jnyMkFbqk-MHAcu=UswVJ90cQg_EgcXSnF0b_RaWkQ@mail.gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, 
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
	Yousef Alhouseen <alhouseenyousef@gmail.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000c5b943065b81618d"

--000000000000c5b943065b81618d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 7:17=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Sep 10, 2026 at 12:26:51PM +0300, Leon Romanovsky wrote:
> > On Wed, Sep 09, 2026 at 10:29:48AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote:
> > > > On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > > > > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > > > > bnxt_re_mmap() hand out kernel pages that userspace is only suppo=
sed to
> > > > > read. VM_WRITE was already rejected, but VM_EXEC was not, so user=
space
> > > > > could map these kernel pages executable. Reject VM_EXEC as well.
> > > > > Also, return EPERM instead of EFAULT.
> > > > >
> > > > > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/togg=
le page mmap")
> > > > > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > > > > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > > > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > > > ---
> > > > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/i=
nfiniband/hw/bnxt_re/ib_verbs.c
> > > > > index ccd2702db78b..e39f99434923 100644
> > > > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_u=
ctx, struct vm_area_struct *vma)
> > > > >                 break;
> > > > >         case BNXT_RE_MMAP_DBR_PAGE:
> > > > >         case BNXT_RE_MMAP_TOGGLE_PAGE:
> > > > > -               /* Driver doesn't expect write access for user sp=
ace */
> > > > > -               if (vma->vm_flags & VM_WRITE) {
> > > > > -                       ret =3D -EFAULT;
> > > > > +               /* Driver doesn't expect write and exec access fo=
r user space */
> > > > > +               if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > > > > +                       ret =3D -EPERM;
> > > > >                 } else {
> > > > > -                       vm_flags_clear(vma, VM_MAYWRITE);
> > > > > +                       vm_flags_clear(vma, VM_MAYWRITE | VM_MAYE=
XEC);
> > > >
> > > > This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC fla=
g")
> > > > commit.
> > >
> > > Why did we do that? These MMIO mmap should never be executable
> >
> > I don't remember the rationale, but if I understood my findings correct=
ly,
> > clearing VM_MAYEXEC broke memcopy.
>
> That doesn't make sense..

Shall i post a v3 series with v1 contents again?

Thanks,
Selvin
>
> Jason

--000000000000c5b943065b81618d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zJH6Ivyz2skA36zh/px/UmF2ORX4Y0CY6GtU8/vxuN2j4rd2medlyifwALUm+KI3SsD782IwKLCf
8bNhYGiw4YxsbyX7dV7O4SNQc5U9ktrSKH3D4SuTnK/xdjca5PiNI2NTcBVmP7+u2bvVLdRqISop
9dpRkJ6xxhGJjxakljIxHdcZLXltxX4YM0Onf3agcjY3boIqnVlDjBwSZX674ZU+YVrcIlcRcqs/
W83e6PmIRFwpkKOhuLNKSpW5mZoEQdpnxGwE9U7qLGECAwEAAaOCAd4wggHaMA4GA1UdDwEB/wQE
AwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDov
L3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5Bggr
BgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUG
A1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUF
BwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDag
NKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJQYD
VR0RBB4wHIEac2VsdmluLnhhdmllckBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYBBQUHAwQw
HwYDVR0jBBgwFoAUACk2nlx6ug+vLVAt26AjhRiwoJIwHQYDVR0OBBYEFJA9fV7cOoiN64ws5XPC
J5qtayo5MA0GCSqGSIb3DQEBCwUAA4ICAQBFCIF4AxAiXVz6gX5YfFEbIYtbGFifcfe+QGc5cfac
CSzIrQWUPXAYAef3G5WouD2AKwa2tPGJgK2L7n1r2W4NIvr93588EDVnGgfMfWaFsB8VlLsPlH8Y
fLfaTdN3OQPnFFp54yK9wv8AtTIiTQcailMw7QX5x5GE6HVZElxf0V0Ljc2NrUQLoYzHzAU+sysl
6JQzomxjIfuXiIiUfmnWQdhO95kQchRdOUAaguLTV+RRfPZ1p54dRmgGEpJtzjGLdsrLkZ2rCN5j
cOTTXyxJmvlgm9jfT0Uy5SOPHdq1jtZbQyXrNT4fQ07Odmq3xQCUTi+a59IiC+6V7nFJ8zyCSk+p
n/iGouvun/owYzTmFxB6sVLWZcaWz2Ufcm7b6nOYV+pwUS/n6+6oFRKmGLrl0CRCF0AOph5p81aV
kgKuS5oXBoDefJfjKHuu5lJVelBx3n++iMGMW9FWFmXErCHy2d+L42Raai5X2PL8jAmh+lpPRDX4
CT9jL6xWM5QkCBtxyVKuxGxxUY2wczmVcQ1nGh9mGghI04Scs4OtE8Qh9LMOe2PXzxcV6lpF+yay
B3fwJWxl7miwNFjWuu9M6Z+rcjm3JF5srcAu2fp/VzQD4AE5Kq7ywukMvlU4Y3X2t+D2eU1DH8pk
c8mM1CtQWfWUboaoLABVmYmYfihDvTURkzGCAlcwggJTAgEBMGIwUjELMAkGA1UEBhMCQkUxGTAX
BgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gR0NDIFI2IFNNSU1F
IENBIDIwMjMCDDy76dRYp65lyF2c4zANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg
ObF0hiIMqjOVk/YlTzctzZJUWvSICeD/80mdY0VGB1YwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwOTE1MDgzMTQ5WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEArTm+SoFZlbeTP9CmAGrWSdctO8v62CUNo/LU
T3cR4WJ/1RKg9ZCjY/JtkgNy/Qv7b/7Y4814gegCozo5XvnCQYKAjsURgU0ySsR6EqsUS06AiXVV
WruaWqM7EeUOXZJ2jkwZdwIHBzV7zdy7EFtqfgTG+jZPJUQSyckx4YE8gYa0gs1eHxrYbY3nu/ZY
Xcqo9w/HojQBU2Q6EjRIPajccB63tommJZ8fIDQF7eoUmot1SYPAbNEQH50US65r+Sej5ut70EzR
2v+1C7gPAsY7dSh4pHKja6VusdSlw4OejTlUQBulgGMnm2ZXAZq5FenDUN2zkZLFO03WhyN74i2n
DA==
--000000000000c5b943065b81618d--
