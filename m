Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3353C352021
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 04:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789532615; cv=none; b=mtc5PvWvmOIoGD4sh4DUmw42D9tdLcjoQj9/byBH73ixTLLGblc8pbUQr1leWxN5OdoamNMf7CrI3aaYePFq3vSpcGUv5RdVkHurdapmXWTtrhl0O0m6SvF6S6nW2shQyDlUOK7hhlyxLMPc0sodpIkZ7zfHeSw+LA3PwrbinEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789532615; c=relaxed/simple;
	bh=2RRX39kNB9titQd3JSSFD9bA7GlpJZjaXUtORYHMM+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HhqoENqTlieapvZ9AUnlm5gDhGA9NdD1yYZ07GiR3lJhqHxw4th+ZE5xt6GyZi5s6/0D+t+dWiozVZ+QAus86QY6UxHkfwaVYS9FLv+l/LVWkhs4y4cg3wZgQCboD2EINUR10cZFPKuouLSwmvej/jnyyR+rw8RzRlDnsqeZPBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Y68Oz16f; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Y68Oz16f"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-862815e2683so652574b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 21:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789532613; x=1790137413;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2TkCkMKl4FneR5wzoIOUJlCXGdwgLhPECdDJcOvEjb0=;
        b=tSZr9nvODUSvQwsYvY2kfKqDQY87XC9kK0Ud9zYwHUimMovLmZlVMZA9oxUzCaixCS
         OR/juxc4P/VUNAqubziNY6CjPJ+mxuuCX61lJaJlJCAuRmI4S9nWx+qf/qoxFaERv3Fu
         F0nDMZ6DSxfuF05hHRomVM1wt1uoNftKZpvn7ObHi7J2dVlpDy3dbsgYxUYsRkZgnTj/
         kbaihhJdW2hozPJlFTSuHQRUDkBvptzSfUmCjWq7WBka62Jqx2M3XiOzvBLKjKgQ2ED+
         pzOmteQ0Cy/MJaLUAAu4CliG1IUlKbYdnkhUejzx+ktAfzQ3ueBJx4HsrQyoLKZngHYd
         T4JQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2j5yyjN6edND18ZRfOiot3num2+8WvFuU+pbE2meytS7HqsWeP7NgO5PuGLhWzsaZ7mC4KEy28iMN@vger.kernel.org
X-Gm-Message-State: AFuF++lTPO5/+8nuvJk3rX1rQrMAanCJbn3bhhedTlEa91GBu0QGKFOX
	SIHRT6ElxggiYzLsdlrRTygUh8mMoRnH7IpAx4Qy+Z+Z5kG47A+QJ58qOMHInx1f91w3eimsBom
	Hh1uAK4qHOJk4eH96PpZu58AvjGWusQ69v34mApdYKlZkZNTXYMYbJTehhw85/R2V64b6+UG/MN
	CqWcPC0LxvDh+7ezRnXV5ZkixoC75/R8ux5Mz4nxWt1OCV/CKRdNICJss0OJWaNl78nHzmrgUBC
	kKZahd+H3mdKeSZBg==
X-Gm-Gg: AYBFou3xUAJa5/z/9QTNwBvCl2YyHhwktGN4qTMMQZNLpcyGKy8WRkmNpZxp+Jx/TJ3
	YMsiMa64OYyqkOwrcgxG+La30OE/VR955l0z/3WdlEnzKwW12x+XpXDUw9Sq0LakkIizpvmVOCl
	I4gdxf4/uC7X4sVq7jNt81Z2nI7cDXNqjtfNpxQhCOt8uEGafJw8vNrK80tLjQaenQ4hShMb/SB
	mL/QDXTSnUcA7SAokEwfpgOi+WVpPSUAtYKA9ffgpwYudCq7wqt2rxuGqq5a5suQII5LO4prqt8
	U3UrQ3Kl49O46lMTOsJE6MguOwsKewjsKTfST8e+ufIlfRwk6d34awMJrNFkW9QZkEAPmqnQFz/
	etP8ZB5c8Oc99T4psC3bi16G3F24NBjZc2tYlz7gw6weqA/Ol9LxQ/jjhuY4uTkTHKBNtFRiX8l
	Tlzj3pn/y93R11j1Lhe7SDz4N7dEx8NUqu7+5O
X-Received: by 2002:a17:90b:280a:b0:39d:f60b:8121 with SMTP id 98e67ed59e1d1-39e1e4d39damr2892619a91.17.1789532613342;
        Tue, 15 Sep 2026 21:23:33 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e1b6e332fsm754620a91.4.2026.09.15.21.23.33
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 21:23:33 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-80585ded89eso7534019a34.0
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 21:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789532612; x=1790137412; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2TkCkMKl4FneR5wzoIOUJlCXGdwgLhPECdDJcOvEjb0=;
        b=Y68Oz16fw6bd2Vt0avxT9TnJW2Q3SEPDBwqsPSaSVXX3W+VycUfJl/0kbsLVyzgofl
         tKEoLOI6jQZCxuOTHU1LW4sUSP2QhkszTpM7c2dGN0yj2qcvphZOfb3a7JZQ42ZsPMEq
         19hM9BwE49R0BweOVvMbxkYVhmeEYOrIo42Jg=
X-Forwarded-Encrypted: i=1; AKwUvBzpboha3DrVLGT7rlP34I3ShGy79XGJ3lvPbkiojCRGwB8TuFrIB9y0fyk/eeT1PyzeCS1XyJenNJVb@vger.kernel.org
X-Received: by 2002:a05:6871:56c1:b0:457:b657:b084 with SMTP id 586e51a60fabf-484777f1b4amr2276803fac.18.1789532612084;
        Tue, 15 Sep 2026 21:23:32 -0700 (PDT)
X-Received: by 2002:a05:6871:56c1:b0:457:b657:b084 with SMTP id
 586e51a60fabf-484777f1b4amr2276787fac.18.1789532611614; Tue, 15 Sep 2026
 21:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com> <20260908134553.GO13683@unreal>
 <20260909132948.GI2543240@ziepe.ca> <20260910092651.GP13683@unreal>
 <20260910134743.GC4083318@ziepe.ca> <CA+sbYW2_jnyMkFbqk-MHAcu=UswVJ90cQg_EgcXSnF0b_RaWkQ@mail.gmail.com>
 <CA+sbYW2tOKp33LwrfePC3YZoCEEW__pQ=XPKB7iUBYCwMbRGMA@mail.gmail.com> <20260915115154.GM13683@unreal>
In-Reply-To: <20260915115154.GM13683@unreal>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Wed, 16 Sep 2026 09:53:19 +0530
X-Gm-Features: AcwNN1XeTphqM1g22TOod0u0MECYvwFrwTtMDGX1yyM7fF63UL2N1xZU-b-IUuw
Message-ID: <CA+sbYW2ypFr4ogZQKe12H1hkDUtGnx9r00SAwngsEb5O-U7CcQ@mail.gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
	Yousef Alhouseen <alhouseenyousef@gmail.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000ad12bf065b9207a8"

--000000000000ad12bf065b9207a8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 5:22=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Tue, Sep 15, 2026 at 02:04:20PM +0530, Selvin Xavier wrote:
> > On Tue, Sep 15, 2026 at 2:01=E2=80=AFPM Selvin Xavier
> > <selvin.xavier@broadcom.com> wrote:
> > >
> > > On Thu, Sep 10, 2026 at 7:17=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca=
> wrote:
> > > >
> > > > On Thu, Sep 10, 2026 at 12:26:51PM +0300, Leon Romanovsky wrote:
> > > > > On Wed, Sep 09, 2026 at 10:29:48AM -0300, Jason Gunthorpe wrote:
> > > > > > On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote=
:
> > > > > > > On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote=
:
> > > > > > > > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE case=
s of
> > > > > > > > bnxt_re_mmap() hand out kernel pages that userspace is only=
 supposed to
> > > > > > > > read. VM_WRITE was already rejected, but VM_EXEC was not, s=
o userspace
> > > > > > > > could map these kernel pages executable. Reject VM_EXEC as =
well.
> > > > > > > > Also, return EPERM instead of EFAULT.
> > > > > > > >
> > > > > > > > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DB=
R/toggle page mmap")
> > > > > > > > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > > > > > > > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com=
>
> > > > > > > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > > > > > > ---
> > > > > > > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> > > > > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/dri=
vers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > > > index ccd2702db78b..e39f99434923 100644
> > > > > > > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > > > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext=
 *ib_uctx, struct vm_area_struct *vma)
> > > > > > > >                 break;
> > > > > > > >         case BNXT_RE_MMAP_DBR_PAGE:
> > > > > > > >         case BNXT_RE_MMAP_TOGGLE_PAGE:
> > > > > > > > -               /* Driver doesn't expect write access for u=
ser space */
> > > > > > > > -               if (vma->vm_flags & VM_WRITE) {
> > > > > > > > -                       ret =3D -EFAULT;
> > > > > > > > +               /* Driver doesn't expect write and exec acc=
ess for user space */
> > > > > > > > +               if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > > > > > > > +                       ret =3D -EPERM;
> > > > > > > >                 } else {
> > > > > > > > -                       vm_flags_clear(vma, VM_MAYWRITE);
> > > > > > > > +                       vm_flags_clear(vma, VM_MAYWRITE | V=
M_MAYEXEC);
> > > > > > >
> > > > > > > This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEX=
EC flag")
> > > > > > > commit.
> > > > > >
> > > > > > Why did we do that? These MMIO mmap should never be executable
> > > > >
> > > > > I don't remember the rationale, but if I understood my findings c=
orrectly,
> > > > > clearing VM_MAYEXEC broke memcopy.
> > > >
> > > > That doesn't make sense..
> > >
> > > Shall i post a v3 series with v1 contents again?
> > Sashiko review mentioned to clear VM_MAYEXEC also. For your reference.
> > https://sashiko.dev/#/message/20260909084241.570431F00A3A%40smtp.kernel=
.org
>
> I lost track of it too. Anyway, if you repost it, could you check whether
> this can be handled in the core code so that it applies to all devices?
>
 Okay, I'll drop this patch from my bug fix series then.  I will
explore the core code change and repost it.

Thanks
> Thanks
>
> > >
> > > Thanks,
> > > Selvin
> > > >
> > > > Jason
>
>

--000000000000ad12bf065b9207a8
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
xGe90qJQSBUd56RQmmyxkSY3M+Hx3v9TfoeOKNxLA9YwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwOTE2MDQyMzMyWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAHecdYqfUPnJGwqQ5PiV/y298tBschbzFJ8xw
ixhP1pMRrHXjF9hoDD59i0zN6ChpRrhg3P9U9HCAmp6E7h3c6HEuays0ZuB45uPNkfnOJeDENwZX
jrhH6B+FmOBUHf8hYAuCJaC78uXBh+zx6mtEIalxrIHg0an4v9wkFzZiFlPgA0EGNYe3ytrrxtY3
GfpawRU3K8tl9mG1iyaQGSdghLOzMALRd0kdsd2r7WTFsWoV3H0195QgDXtWY6o8k41IHufjm/8c
WM6w5QvZlvbF64Pny9AKvpgCyeIace4xR6WfcI7LeLlX1lSBQOZdbM2HO/q2rPVJFAmCYc/i3d9s
yQ==
--000000000000ad12bf065b9207a8--
