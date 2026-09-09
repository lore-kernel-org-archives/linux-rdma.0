Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA53319871
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 04:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788929837; cv=none; b=MIj2ujvrIXk4Rlrj0eF9tkj8CuiXZ+EVkGZJSvyvVJ/BHg0BIS6F5FAX2RQhJ2XpRjNY1ospOnQF0OOnoqQkBVEEo3PmHau3I9NodJm6eGU/4f9CY8P1pqexrloSU1YNw0eGgy27dP1C/g6fQFDq47Fv1X9E0n5p4ybfnTiAMaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788929837; c=relaxed/simple;
	bh=itkmENnyBG2lNR2COGYml/TSP0w8bzSbEo9hdGnc21o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nfYW8UGj3bdnVcp6EaGUkhe56h4JuFRr2t/oIiXqLJwyBba21mfQLdyCWh6O2akoMgacKRjtP4MmKaI5CEHxwKjWhFAsU4JQ4muqWnv0pWIsjM4zW8heBBIzV3C1GdVLSa8j1KL3/7XIdsdT5zLzcllG9OTpnNRqWwvHx4szMOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=H+KQZm8Z; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="H+KQZm8Z"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-85590c5aeabso3795706b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 21:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788929835; x=1789534635;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nzYLN0PDUiRYW8+lll4k0lnKINhzqPoBCRW1c4Irpek=;
        b=Nl44Z+kkirsUv1pYFY6+qpr329Pp9arJEbJ9bjuwX7DXm/YoUPRfvtvXKvFF2I4tg2
         Qs3Qd37XaodLA3gsTGSAik5cavs9drs0JKr5v3Grxra67+MkkYKhVUZTu6Dad/7xrUVm
         pWThFgNFk3XoTQ5pWYuISBwULBaoyYfQ7/7cYyFCTUGBYcjhO1V+Seo8f/1hmYjmn9RZ
         AI6kwtv0r9wz88HFZEzvfJVZd1o5Oo5WNkSFVDFd6IHnRDUxdqHU8IqeMgReRD7EmrTY
         tm9ZqQ0ds6F5u4w7jMB+f6xGE2isD0++Q9j6a0IQ675IM/6ufZVR8TsRl3R6cBygcnzN
         ncpQ==
X-Forwarded-Encrypted: i=1; AKwUvByzETR/Q35tXlUygdW9PFaTonjxch+T5XTTm42vV0XuLW9lHWSWDv5fnXh73t3XgMIX4w+YeiCEvoaz@vger.kernel.org
X-Gm-Message-State: AFuF++mo+M4NQ1OZaTQxEVk1IKBVv9E4GM5pLZBtUrhsdzvYmPdH6CuI
	Q/fAxUu6h/Ab4ejj1ahv1glxYRuDcdd8iRr/kGL1bbO0haFEVCwXDh7Gw+G8lR03qFGHFI2Vm9z
	creVQqjgqyUi3HNd400UEhg3XYVlJ6KuqmrNAVotUTs+3q8eQZQoaoozZ2eofmmnEH/0mkvjtit
	DQ335fNrNsUuCZTMWWituch3zd9RbIHwIOvwJL5Pna5VT9VfzBduqzMP97mGeKpJyVoqFZhL0Ik
	2hapt/tBWKgL9/4QQ==
X-Gm-Gg: AYBFou1lh2w6UCrtWmKSC0OyzKdg9A2IVM6d7ofQv+ny1Qgt+K6SxgMPIZKrsk4WWU1
	vmPWGDrbwPSNt/MqPFYXG1CiJmdV9lS67Ya4imFyxAT+D+pqOxO1C9KEqPOE+4o5WfgIVhIrFZk
	P2msv2SIx4FyNX5hGjiWSeY6XUgVv2qGuVgsyiyk02xQ9o2ZfoWitTjJ2tG5n2X1FgYKU6vhUSq
	GiT6MaQ5RNNWPTtBMSeIYsG/d4TsqmebqsE/pV+El761b9teoPrHhoWccBpmhkQoQ//UgktvcmU
	ye9ojwrNiPig4fjLczfPfsUj7a1Srg7QsWsGtyW+TjX8fyHp2XPnqxu0XezS4rEA1NcIyBtAK6P
	h6um6V1FirCrnyLxRTq7bi8ZhvTWLxf05ufcm4gYO3cqvFRVMq/XFXaBMmUbSuVHbq0VsQnaCEd
	/ajvmM2OQOpb9y++vIZ8MQrsWmrABOhdBQutnN27U=
X-Received: by 2002:a05:6a00:929e:b0:857:7317:cff6 with SMTP id d2e1a72fcca58-8616aa630a5mr45417505b3a.23.1788929834981;
        Tue, 08 Sep 2026 21:57:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8652a30058bsm2374343b3a.8.2026.09.08.21.57.14
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2026 21:57:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b2fb8f0df0so5886635b6e.0
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 21:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788929833; x=1789534633; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nzYLN0PDUiRYW8+lll4k0lnKINhzqPoBCRW1c4Irpek=;
        b=H+KQZm8ZafsiSu7XLfZH8HUCuLj1LYjKvdPRCbrHlbKYf4ABzibzn92uisnk+iQYgH
         8c8WTrZ3QJ5Z2IVp6Env30hnQ3Z9xfNNOngTr/vrN51okuY0jgdqmHOVOUUL954hCkpn
         EWadNUv3yJv3p47ecCr5lU6Kk6r2MWgH+WSaI=
X-Forwarded-Encrypted: i=1; AKwUvBwjcD/eEJw8IVX+IELUO/ZHDod2mPMaK2uvLC0ae1ppJ7qpZW9FTZlTgi4+hbw4rpQWkdYLqNSshz95@vger.kernel.org
X-Received: by 2002:a05:6820:814:b0:6b0:4fbc:aecf with SMTP id 006d021491bc7-6b6fcbd5788mr19528223eaf.24.1788929833450;
        Tue, 08 Sep 2026 21:57:13 -0700 (PDT)
X-Received: by 2002:a05:6820:814:b0:6b0:4fbc:aecf with SMTP id
 006d021491bc7-6b6fcbd5788mr19528208eaf.24.1788929832984; Tue, 08 Sep 2026
 21:57:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906230700.12233-1-selvin.xavier@broadcom.com>
 <20260906230700.12233-2-selvin.xavier@broadcom.com> <20260908134553.GO13683@unreal>
In-Reply-To: <20260908134553.GO13683@unreal>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Wed, 9 Sep 2026 10:27:01 +0530
X-Gm-Features: AcwNN1VkDLrGA5vDVlgqj2egPGuTav7aLyamM9Hx9zh-IfVlrDw11ENimXzyaXE
Message-ID: <CA+sbYW1maYZ4kFNgzLrSDi+x_3w0PfDnYO7XQZxdV4APHegMdw@mail.gmail.com>
Subject: Re: [PATCH for-rc 1/8] RDMA/bnxt_re: Reject executable mappings of
 the DBR and toggle pages
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
	kalesh-anakkur.purayil@broadcom.com, 
	Yousef Alhouseen <alhouseenyousef@gmail.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000045a19a065b05af08"

--00000000000045a19a065b05af08
Content-Type: multipart/alternative; boundary="000000000000396a3b065b05aff4"

--000000000000396a3b065b05aff4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 7:15=E2=80=AFPM Leon Romanovsky <leon@kernel.org> wr=
ote:

> On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier wrote:
> > The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of
> > bnxt_re_mmap() hand out kernel pages that userspace is only supposed to
> > read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace
> > could map these kernel pages executable. Reject VM_EXEC as well.
> > Also, return EPERM instead of EFAULT.
> >
> > Fixes: 9b66c9af7172 ("RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle pag=
e
> mmap")
> > CC: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
> > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > ---
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > index ccd2702db78b..e39f99434923 100644
> > --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> > @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx,
> struct vm_area_struct *vma)
> >               break;
> >       case BNXT_RE_MMAP_DBR_PAGE:
> >       case BNXT_RE_MMAP_TOGGLE_PAGE:
> > -             /* Driver doesn't expect write access for user space */
> > -             if (vma->vm_flags & VM_WRITE) {
> > -                     ret =3D -EFAULT;
> > +             /* Driver doesn't expect write and exec access for user
> space */
> > +             if (vma->vm_flags & (VM_WRITE | VM_EXEC)) {
> > +                     ret =3D -EPERM;
> >               } else {
> > -                     vm_flags_clear(vma, VM_MAYWRITE);
> > +                     vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);
>
> This is an opposite to 10bf13c33450 ("RDMA/mlx5: Remove MAYEXEC flag")
> commit.
>
> Thanks
>
ok.. will remove this and post v2.

>
> >                       ret =3D vm_insert_page(vma, vma->vm_start,
> >                                            virt_to_page((void
> *)bnxt_entry->mem_offset));
> >               }
> > --
> > 2.39.3
> >
>

--000000000000396a3b065b05aff4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Sep 8, =
2026 at 7:15=E2=80=AFPM Leon Romanovsky &lt;<a href=3D"mailto:leon@kernel.o=
rg">leon@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">On Sun, Sep 06, 2026 at 04:06:53PM -0700, Selvin Xavier =
wrote:<br>
&gt; The BNXT_RE_MMAP_DBR_PAGE and BNXT_RE_MMAP_TOGGLE_PAGE cases of<br>
&gt; bnxt_re_mmap() hand out kernel pages that userspace is only supposed t=
o<br>
&gt; read. VM_WRITE was already rejected, but VM_EXEC was not, so userspace=
<br>
&gt; could map these kernel pages executable. Reject VM_EXEC as well.<br>
&gt; Also, return EPERM instead of EFAULT.<br>
&gt; <br>
&gt; Fixes: 9b66c9af7172 (&quot;RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/togg=
le page mmap&quot;)<br>
&gt; CC: Yousef Alhouseen &lt;<a href=3D"mailto:alhouseenyousef@gmail.com" =
target=3D"_blank">alhouseenyousef@gmail.com</a>&gt;<br>
&gt; Reviewed-by: Kalesh AP &lt;<a href=3D"mailto:kalesh-anakkur.purayil@br=
oadcom.com" target=3D"_blank">kalesh-anakkur.purayil@broadcom.com</a>&gt;<b=
r>
&gt; Signed-off-by: Selvin Xavier &lt;<a href=3D"mailto:selvin.xavier@broad=
com.com" target=3D"_blank">selvin.xavier@broadcom.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 8 ++++----<br>
&gt;=C2=A0 1 file changed, 4 insertions(+), 4 deletions(-)<br>
&gt; <br>
&gt; diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infini=
band/hw/bnxt_re/ib_verbs.c<br>
&gt; index ccd2702db78b..e39f99434923 100644<br>
&gt; --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c<br>
&gt; +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c<br>
&gt; @@ -5057,11 +5057,11 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, =
struct vm_area_struct *vma)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0case BNXT_RE_MMAP_DBR_PAGE:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0case BNXT_RE_MMAP_TOGGLE_PAGE:<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Driver doesn&#39;t=
 expect write access for user space */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vma-&gt;vm_flags =
&amp; VM_WRITE) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ret =3D -EFAULT;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Driver doesn&#39;t=
 expect write and exec access for user space */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (vma-&gt;vm_flags =
&amp; (VM_WRITE | VM_EXEC)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ret =3D -EPERM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0vm_flags_clear(vma, VM_MAYWRITE);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0vm_flags_clear(vma, VM_MAYWRITE | VM_MAYEXEC);<br>
<br>
This is an opposite to 10bf13c33450 (&quot;RDMA/mlx5: Remove MAYEXEC flag&q=
uot;)<br>
commit.<br>
<br>
Thanks<br></blockquote><div>ok.. will remove this and post v2.=C2=A0</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0ret =3D vm_insert_page(vma, vma-&gt;vm_start,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 virt_to_page((void *)bnxt_entry-&gt;mem_offset));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -- <br>
&gt; 2.39.3<br>
&gt; <br>
</blockquote></div></div>

--000000000000396a3b065b05aff4--

--00000000000045a19a065b05af08
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
2hUY4X8VPkd3IwDsDV1hL8TFtWtdAxhKjn/Ji7tJF14wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwOTA5MDQ1NzEzWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAJNlvRXxvsL8fcfnOwV/SL4q6kj0lvwB/GSvY
QmOoxdW1NsHTyLThOv+Gba9Dvpj/cSpceGqBwY6npratgU5pYCXf8AnKEc1p9Gsj80fwDG91rYyx
fAI8Q65igW4Q5tq/wOgTyOFasSFYcdpb54g3HfKtKLezY7PAPEUQUqE1zLFu8TRQAQsArDInNzmr
WeUR0RZqXC8NAXqVyCh/vtUUaTaMxxzJOzYMFdkDz+OLqD2SDCmUBdzbMhIlHavBEW0tsw3/3kDs
5vFzjDhaMsMG8150R6ul2e7TM2crzlM5Ql7Uz+6mBeZ26STfHTb5VKLyEHeDqUNwxtd9wO+f+tir
sA==
--00000000000045a19a065b05af08--
