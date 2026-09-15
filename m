Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C65360EF7
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461280; cv=none; b=YkwBSfpoXpOCc8/hjgpR61tnauqc4W35hsveqZCuDGH3agAXD7n/Uqb4Jl3H+Oh9pEIPB9iIUcFJQkb5vfMYGdoD+OeRUY+1oDqsjFDtkO0KieA/1g3ssqrcOezEvWv+Ob/xpARHERTmtERjWRM87aBIKZ7cJzXUvHQ8HunMVLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461280; c=relaxed/simple;
	bh=Oc4CsPdaPtZgjjsSJlkB0STOfl7IGSScLUhNoin5Rvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t49mxKmgTCcN9bZzlMtOzrmeRiRPTE/4sOYcF1FCAgRTPkIeTRmPcXaKQQvTFazuRKjp1S+EOEXnVHuHToSgcc8RaRCmxT9RsRxl7NeiaRLtleImo8UKJFZ6lvS3bIR/PXwsKCtgsBc2tUSECcR3mJ9h/okRl7/sPJ0rCMxqteY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OjEM0GvI; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OjEM0GvI"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2d58efc7356so36603775ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 01:34:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461277; x=1790066077;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nw7sKlFsRBN0D7g78ANvv6w/wVhhSfVcfDxf+3BxxfA=;
        b=F9nLaUhkHxK1R/Hc8OQ+V2hqQwaX8RdoyEsdWjinmeVU796sDvMbh55ccBbNUbLwcR
         ANVJzKQ1Nygcu2jvWSSXm6NjMTU5G2qwStJJbZUNoyCWLIT4OAkSHAoukEygtCB3cKrE
         qCwEFi1kRFWcyjQnslIj3Yni/KKit9NezfeMIBttXldkLN7iLbs8Ca5cBhb6BTa7fSZB
         OcryTJtex37DMgyBWsvvm94Oc97Q80G9eJA7N3MTLxypJzzlk9qXQ1lTbwCylZE6yNTK
         Y6ZlEqpA1Z+dNZMzmGmuxuGkVquhP5xCQsHIme2txGtVhztRxpKJoKpUIh+O3LIzEns6
         LF1Q==
X-Forwarded-Encrypted: i=1; AKwUvByVrsTyV98rARVn6+GLAoL6Y8KU4jrHkZJjye4kgQznlU7/aH2fhZSuocUZ7zApWupGWYMGZemcKWZF@vger.kernel.org
X-Gm-Message-State: AFuF++lNU04ER3USLMSWSo7evZgDxiTIxGFVcGTtZy59HC5/d65f7krE
	0673bZgP30bp1FLVB4m+jCLaPJJTUPQjmIhf+5H1fHTTEREGohI7v8tOMbkEtsZEU9rq0vYahsT
	6OnBT7T7hUc6ozstnVFiJ2vbjA9PfvKbSjOS2Ibavx6MWR+pqnmlU3pBdLbusabPveTXVRbQXP2
	sWXu9gFXHH3wcQ6I0JFuEklpGgTVnDxs+11WSMfCoYSFnFIBpDmpfL93j6SaSac39oKT7DGiGIN
	klvApf53I28FA77iw==
X-Gm-Gg: AYBFou3EmqiBhS8JZXy3Y3hqGfxfcOdQc+/1+K5ju4ub7zKKGPAFFEq8z01QrdJepli
	9+HsLC9iPToGcadSvFjxCBTSkzifx+LtOlzVEW4eP+lqSoLZx7j+2gL4HTK1Nep4jwBEtwcqypX
	qz59M26U86X6vUDPUZaKX1TBw1lGc0UYx4NnT8X1BZSiKXgNKQfqmmHLXU6Yg9hkgJgiIQFlWE6
	JJF+bqUTqBw9gyv2kRALEJDgvVOmhIY+1uxzchUVHqMmnSGywYRSeAm8NFuXhGlVRlWMdLaA12S
	3tWmjpn4KBOyjCeDdnGVtkK7N9JXgiR09uAGABHWXzdVkLyPIS1tcZsiD1zrWCmHDxrlgk/LhTR
	Mx9RxZnoZtd/A8RmyDlCEo6/bf2hh9E6NG143fSjPucZsNIveChCz32SB66+y
X-Received: by 2002:a17:902:f712:b0:2db:20fa:9443 with SMTP id d9443c01a7336-2dd6c6db8c2mr126823015ad.13.1789461276154;
        Tue, 15 Sep 2026 01:34:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2dd2d0343adsm5951225ad.45.2026.09.15.01.34.34
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 01:34:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-455ad408573so7618951fac.3
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 01:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789461274; x=1790066074; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nw7sKlFsRBN0D7g78ANvv6w/wVhhSfVcfDxf+3BxxfA=;
        b=OjEM0GvITy/XePK+iCMIgLZTnHAsjh4hinLH6Bd4oSQSXzHoXGBTXLmTSrNH4p21MW
         R0LwdfttwMPjlkLqU9tKKTjwLcRFk+Blns3W0kl0dR8hR4w7ixKtu3Y2HDimxyOtLz7y
         4AE9FlugLx/KvK+utWxobSMEQIOwoPPIm+sSE=
X-Forwarded-Encrypted: i=1; AKwUvBzzgIgazbTE5gaV5VDuWVJ0zdtpU8cKgw9rLKzVknp9baYH/h3fYwE8zQNKP7E/6RGALQPvo//UcfeZ@vger.kernel.org
X-Received: by 2002:a05:6871:c963:b0:468:2c18:a031 with SMTP id 586e51a60fabf-481f82452a1mr4431338fac.12.1789461274096;
        Tue, 15 Sep 2026 01:34:34 -0700 (PDT)
X-Received: by 2002:a05:6871:c963:b0:468:2c18:a031 with SMTP id
 586e51a60fabf-481f82452a1mr4431297fac.12.1789461273182; Tue, 15 Sep 2026
 01:34:33 -0700 (PDT)
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
In-Reply-To: <CA+sbYW2_jnyMkFbqk-MHAcu=UswVJ90cQg_EgcXSnF0b_RaWkQ@mail.gmail.com>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Tue, 15 Sep 2026 14:04:20 +0530
X-Gm-Features: AcwNN1VgmgOkeJZwdYq9A3ELN271e_Gws8azGSp60BN8AB_sMsMWj8w4ac8Vv-k
Message-ID: <CA+sbYW2tOKp33LwrfePC3YZoCEEW__pQ=XPKB7iUBYCwMbRGMA@mail.gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, 
	andrew.gospodarek@broadcom.com, kalesh-anakkur.purayil@broadcom.com, 
	Yousef Alhouseen <alhouseenyousef@gmail.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000994d4a065b816baf"

--000000000000994d4a065b816baf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 2:01=E2=80=AFPM Selvin Xavier
<selvin.xavier@broadcom.com> wrote:
>
> On Thu, Sep 10, 2026 at 7:17=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wr=
ote:
> >
> > On Thu, Sep 10, 2026 at 12:26:51PM +0300, Leon Romanovsky wrote:
> > > On Wed, Sep 09, 2026 at 10:29:48AM -0300, Jason Gunthorpe wrote:
> > > > On Tue, Sep 08, 2026 at 04:45:53PM +0300, Leon Romanovsky wrote:
> > > > > On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > > > > > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > > > > > bnxt_re_mmap() hand out kernel pages that userspace is only sup=
posed to
> > > > > > read. VM_WRITE was already rejected, but VM_EXEC was not, so us=
erspace
> > > > > > could map these kernel pages executable. Reject VM_EXEC as well=
.
> > > > > > Also, return EPERM instead of EFAULT.
> > > > > >
> > > > > > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/to=
ggle page mmap")
> > > > > > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > > > > > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > > > > > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > > > > > ---
> > > > > >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> > > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers=
/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > index ccd2702db78b..e39f99434923 100644
> > > > > > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > > > > > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib=
_uctx, struct vm_area_struct *vma)
> > > > > >                 break;
> > > > > >         case BNXT_RE_MMAP_DBR_PAGE:
> > > > > >         case BNXT_RE_MMAP_TOGGLE_PAGE:
> > > > > > -               /* Driver doesn't expect write access for user =
space */
> > > > > > -               if (vma->vm_flags & VM_WRITE) {
> > > > > > -                       ret =3D -EFAULT;
> > > > > > +               /* Driver doesn't expect write and exec access =
for user space */
> > > > > > +               if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > > > > > +                       ret =3D -EPERM;
> > > > > >                 } else {
> > > > > > -                       vm_flags_clear(vma, VM_MAYWRITE);
> > > > > > +                       vm_flags_clear(vma, VM_MAYWRITE | VM_MA=
YEXEC);
> > > > >
> > > > > This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC f=
lag")
> > > > > commit.
> > > >
> > > > Why did we do that? These MMIO mmap should never be executable
> > >
> > > I don't remember the rationale, but if I understood my findings corre=
ctly,
> > > clearing VM_MAYEXEC broke memcopy.
> >
> > That doesn't make sense..
>
> Shall i post a v3 series with v1 contents again?
Sashiko review mentioned to clear VM_MAYEXEC also. For your reference.
https://sashiko.dev/#/message/20260909084241.570431F00A3A%40smtp.kernel.org
>
> Thanks,
> Selvin
> >
> > Jason

--000000000000994d4a065b816baf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIVXQYJKoZIhvcNAQcCoIIVTjCCFUoCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghLKMIIGqDCCBJCgAwIBAgIQfofDCS7XZu8vIeKo0KeY9DANBgkqhkiG9w0BAQwFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSNjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMzA0MTkwMzUzNTNaFw0yOTA0MTkwMDAwMDBaMFIxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBS
NiBTTUlNRSBDQSAyMDIzMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAwjAEbSkPcSyn
26Zn9VtoE/xBvzYmNW29bW1pJZ7jrzKwPJm/GakCvy0IIgObMsx9bpFaq30X1kEJZnLUzuE1/hlc
hatYqyORVBeHlv5V0QRSXY4faR0dCkIhXhoGknZ2O0bUJithcN1IsEADNizZ1AJIaWsWbQ4tYEYj
ytEdvfkxz1WtX3SjtecZR+9wLJLt6HNa4sC//QKdjyfr/NhDCzYrdIzAssoXFnp4t+HcMyQTrj0r
pD8KkPj96sy9axzegLbzte7wgTHbWBeJGp0sKg7BAu+G0Rk6teO1yPd75arbCvfY/NaRRQHk6tmG
71gpLdB1ZhP9IcNYyeTKXIgfMh2tVK9DnXGaksYCyi6WisJa1Oa+poUroX2ESXO6o03lVxiA1xyf
G8lUzpUNZonGVrUjhG5+MdY16/6b0uKejZCLbgu6HLPvIyqdTb9XqF4XWWKu+OMDs/rWyQ64v3mv
Sa0te5Q5tchm4m9K0Pe9LlIKBk/gsgfaOHJDp4hYx4wocDr8DeCZe5d5wCFkxoGc1ckM8ZoMgpUc
4pgkQE5ShxYMmKbPvNRPa5YFzbFtcFn5RMr1Mju8gt8J0c+dxYco2hi7dEW391KKxGhv7MJBcc+0
x3FFTnmhU+5t6+CnkKMlrmzyaoeVryRTvOiH4FnTNHtVKUYDsCM0CLDdMNgoxgkCAwEAAaOCAX4w
ggF6MA4GA1UdDwEB/wQEAwIBhjBMBgNVHSUERTBDBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQB
gjcUAgIGCisGAQQBgjcKAwwGCisGAQQBgjcKAwQGCSsGAQQBgjcVBjASBgNVHRMBAf8ECDAGAQH/
AgEAMB0GA1UdDgQWBBQAKTaeXHq6D68tUC3boCOFGLCgkjAfBgNVHSMEGDAWgBSubAWjkxPioufi
1xzWx/B/yGdToDB7BggrBgEFBQcBAQRvMG0wLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9i
YWxzaWduLmNvbS9yb290cjYwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjYuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yNi5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IC
AQCRkUdr1aIDRmkNI5jx5ggapGUThq0KcM2dzpMu314mJne8yKVXwzfKBtqbBjbUNMODnBkhvZcn
bHUStur2/nt1tP3ee8KyNhYxzv4DkI0NbV93JChXipfsan7YjdfEk5vI2Fq+wpbGALyyWBgfy79Y
IgbYWATB158tvEh5UO8kpGpjY95xv+070X3FYuGyeZyIvao26mN872FuxRxYhNLwGHIy38N9ASa1
Q3BTNKSrHrZngadofHglG5W3TMFR11JOEOAUHhUgpbVVvgCYgGA6dSX0y5z7k3rXVyjFOs7KBSXr
dJPKadpl4vqYphH7+P40nzBRcxJHrv5FeXlTrb+drjyXNjZSCmzfkOuCqPspBuJ7vab0/9oeNERg
nz6SLCjLKcDXbMbKcRXgNhFBlzN4OUBqieSBXk80w2Nzx12KvNj758WavxOsXIbX0Zxwo1h3uw75
AI2v8qwFWXNclO8qW2VXoq6kihWpeiuvDmFfSAwRLxwwIjgUuzG9SaQ+pOomuaC7QTKWMI0hL0b4
mEPq9GsPPQq1UmwkcYFJ/Z4I93DZuKcXmKMmuANTS6wxwIEw8Q5MQ6y9fbJxGEOgOgYL4QIqNULb
5CYPnt2LeiIiEnh8Uuh8tawqSjnR0h7Bv5q4mgo3L1Z9QQuexUntWD96t4o0q1jXWLyrpgP7Zcnu
CzCCBYMwggNroAMCAQICDkXmuwODM8OFZUjm/0VRMA0GCSqGSIb3DQEBDAUAMEwxIDAeBgNVBAsT
F0dsb2JhbFNpZ24gUm9vdCBDQSAtIFI2MRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpH
bG9iYWxTaWduMB4XDTE0MTIxMDAwMDAwMFoXDTM0MTIxMDAwMDAwMFowTDEgMB4GA1UECxMXR2xv
YmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2Jh
bFNpZ24wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCVB+hzymb57BTKezz3DQjxtEUL
LIK0SMbrWzyug7hBkjMUpG9/6SrMxrCIa8W2idHGsv8UzlEUIexK3RtaxtaH7k06FQbtZGYLkoDK
RN5zlE7zp4l/T3hjCMgSUG1CZi9NuXkoTVIaihqAtxmBDn7EirxkTCEcQ2jXPTyKxbJm1ZCatzEG
xb7ibTIGph75ueuqo7i/voJjUNDwGInf5A959eqiHyrScC5757yTu21T4kh8jBAHOP9msndhfuDq
jDyqtKT285VKEgdt/Yyyic/QoGF3yFh0sNQjOvddOsqi250J3l1ELZDxgc1Xkvp+vFAEYzTfa5MY
vms2sjnkrCQ2t/DvthwTV5O23rL44oW3c6K4NapF8uCdNqFvVIrxclZuLojFUUJEFZTuo8U4lptO
TloLR/MGNkl3MLxxN+Wm7CEIdfzmYRY/d9XZkZeECmzUAk10wBTt/Tn7g/JeFKEEsAvp/u6P4W4L
sgizYWYJarEGOmWWWcDwNf3J2iiNGhGHcIEKqJp1HZ46hgUAntuA1iX53AWeJ1lMdjlb6vmlodiD
D9H/3zAR+YXPM0j1ym1kFCx6WE/TSwhJxZVkGmMOeT31s4zKWK2cQkV5bg6HGVxUsWW2v4yb3BPp
DW+4LtxnbsmLEbWEFIoAGXCDeZGXkdQaJ783HjIH2BRjPChMrwIDAQABo2MwYTAOBgNVHQ8BAf8E
BAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUrmwFo5MT4qLn4tcc1sfwf8hnU6AwHwYD
VR0jBBgwFoAUrmwFo5MT4qLn4tcc1sfwf8hnU6AwDQYJKoZIhvcNAQEMBQADggIBAIMl7ejR/ZVS
zZ7ABKCRaeZc0ITe3K2iT+hHeNZlmKlbqDyHfAKK0W63FnPmX8BUmNV0vsHN4hGRrSMYPd3hckSW
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGkzCCBHug
AwIBAgIMPLvp1FinrmXIXZzjMA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEzNTI0NFoXDTI3MDYyMTEzNTI0NFowgdoxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEPMA0GA1UEBBMGWGF2aWVyMQ8wDQYDVQQqEwZTZWx2aW4xFjAUBgNVBAoTDUJST0FEQ09N
IElOQy4xIzAhBgNVBAMMGnNlbHZpbi54YXZpZXJAYnJvYWRjb20uY29tMSkwJwYJKoZIhvcNAQkB
FhpzZWx2aW4ueGF2aWVyQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALyww4rAbY/uRJ/p/H3RRc0ipz0vxZgIXUdvhNOrG9uErj7X64vntdJTkcN1BOWQC1xpmt5e
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
c88XcywnWrdvNKSxL54rjdqS7+FcBvjetBjE2OKnC6MwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwOTE1MDgzNDM0WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAcUXGLxNSGgraFjS8rXOueUmJCJO9Z6Seqqex
dGn4jqcJycKQhvOLoqvWMwdEz9qzKwhR0La7PtvffsHbt4nMOJKmdUblPnEhqeo6NkW9BFwhTcip
WgNYebo+ERuWHgwG9XHhkBWXpoF/x+ijHwCViuazYqHRJmeUuC2KPbSL1iMT2HaJi7iyuJcglbeh
TfntI0ntejE3zp7bhd9IHwSjKqmMwnLxWn/qzTbtg8N3sMjU56lp5lGaxrk6BYdCoeJS+YtM8UHH
Ju3rpSq2Ms7fJub4z6doE0UwPIhyTCsBAe2ma48pE8fGDWeY8uKToXms9yEDsdtzdFg0rRH1BQty
rw==
--000000000000994d4a065b816baf--
