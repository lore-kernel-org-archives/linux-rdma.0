Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD654DA528
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449374; cv=none; b=D1scsUHTmQeECTXb9bysW5JiY/DTl8L4DLoljh4WKvQKyCYiji6MVu2WT0VaVSinioTB054m+atphhAVeMpjhDgOgLou+CpLtxL7dneW2U29QNhJcZ9BWSbEZ6/pp431Ym3DyAaxDzA3M2eOPQG7h+HW/pX7XTocc1vQF0ChsnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449374; c=relaxed/simple;
	bh=b+vF9QwtOZbarGAU8wZwcRgxsyqFZLz6AHuOiDaP8Hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d08hNJ2wP+91ZItmBFvl4d6adhcDUO+v4P9v8eDCFGpMtd1ri2XJPz1GtY30GMcEeWielD2wy/sruL96KBL0qckDLWOqLzoj9zPgpFXitSxdTrISYLiH86a5XPjARfDumHr6FgPadS5qg2utU6YjSMY3HruJsa72cmP/VEU4QjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AYkTmwg+; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AYkTmwg+"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-8541875f596so1195564b3a.0
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 08:29:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788449372; x=1789054172;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b+vF9QwtOZbarGAU8wZwcRgxsyqFZLz6AHuOiDaP8Hc=;
        b=XWp9CkgWiOGDhPdYVtl8xJMSjpOWU8M5TMa2F5OnGju+HQuZKOSMpkMRbObeLDb7St
         TPSKMSinVdSiyK0U+a9LiGvrq2nYoVzzrDxItAA6Qss2g4zgcTsdHcmMhho1PY0yoQj4
         kqzhqtdrDLivRcOMosLUsMzuLyh7NBn/va4o3uVfbJE55DEppU9lcgNToXh7McPoxYJR
         zv1HhOF92FuUB0kxfF1QV5ix4U4EJwP9pDzHp4GPgp7CJtJMRuTKXUMsM5MO93516CQn
         SpYa0aNUN68iK62bm4H7rkQO7UyVxD7AAMOF+os3uq6USjfL1FXXw3m5IfQwsNMEsrcg
         zE2Q==
X-Forwarded-Encrypted: i=1; AKwUvByDNsnNpm2V+m19Gzo0Rmeop/C+amQR9BA5tNAWC4Yjo7EnOm/OBzfLDOO38obWhqrQTpj9GAs68KGU@vger.kernel.org
X-Gm-Message-State: AFuF++kxOhBn+Y0W/LOTb47ASH7SgTaKGgSlTFgWa4FqSdS2jRfXFph0
	fmHDdnYU+w0pGa6D5O68FBrYh2mv8741WTw3M3KDEuGreLsKBwW5Y/BExeljN4iShlVRYXUo5eh
	Fep/XGGjl+VB8EffzgifW0cF1KHyjeoelvtAGp478uQNAMSLabuZoifGmEZj+GcaNM8OhDZa+kn
	QuPV5nm0lNvElOSLoU9nqbd540JNpyqQSImALZ/HVvePoBynqAD02Zo0n2cWcjTTn4WmOuYPsjC
	46xd43iA41T/armT2WH8Y8y9WhWVQ==
X-Gm-Gg: AYBFou2cj914HtgVf7rHuoUBtsOnZOLjiczb/RyChywVYOOGG4Dyij6tvkeg7RqNEmh
	XBAbi4gHE7Cr1oAQhbIRdvpAt/Ex9tFtgM76b5/F9FY0J9xCjZ1Pu9IBIIZRjOySfqeLDddQwj9
	KoL8sZmSGOZDTpNh4mwUOWeCucuAfe2puejCbrsIsbumOR4ym5Qg9RR2dKusGXxB6mNqzWSJYIp
	eM2/QwSmPmhkfobZKFJ9Z6vnBXUoA39SoNFnfAHwHVEO16+737xrLx2OXkI8Lqg9V/HfgrMRgGf
	/xg7xRZWavhekPJyOVgJgIQRAVU8S+QaT9e9nRdq0SF89UQEmXjYyVyNx6KFUPYKeojGOx7bEIl
	eB/WY/Dkg+xJOdflvgZv1Q4mLbtUaYUGr712YSwcaYAKG9D5g7I4HWWeryzHoVLA+agelrxkatZ
	la/+rmLuUQQk9RH+M3Po1OSAmY/YLeEx/YZ93CdjV9IhLKEp9t
X-Received: by 2002:a05:6a00:4505:b0:857:73e2:9108 with SMTP id d2e1a72fcca58-85ed98befbbmr19000117b3a.24.1788449372108;
        Thu, 03 Sep 2026 08:29:32 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8614b297b3asm43438b3a.0.2026.09.03.08.29.31
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2026 08:29:32 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1b6f65dacso40322a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 08:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788449370; x=1789054170; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b+vF9QwtOZbarGAU8wZwcRgxsyqFZLz6AHuOiDaP8Hc=;
        b=AYkTmwg+ieSspMeWnMC23PstQn02Rrz91CwCavep0Vjzb5o6hk0mEu66S3iHL1EXoA
         fRubQbC37iWiF057Wlbnxik0xmdPvBFO8R9GudrghdNpl/6kXhBrivCDhmYh9zFcP5TF
         n3EjMNxXKrg45FcXQMmj2iNm2D80I4SKjFi0U=
X-Forwarded-Encrypted: i=1; AKwUvByJf18rUolIqON9XK4EsYB4W1CTuG3d4oF0vlPc2RXPAVhL8pab7m+pQUw1cYUmKuA0E6grUpIeMrpY@vger.kernel.org
X-Received: by 2002:a05:6a00:139a:b0:835:6388:655d with SMTP id d2e1a72fcca58-85ed8ed87b8mr18330695b3a.14.1788449370159;
        Thu, 03 Sep 2026 08:29:30 -0700 (PDT)
X-Received: by 2002:a05:6a00:139a:b0:835:6388:655d with SMTP id
 d2e1a72fcca58-85ed8ed87b8mr18330620b3a.14.1788449369554; Thu, 03 Sep 2026
 08:29:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
 <20260903-64-bit-iova-is-silently-truncated-to-v1-2-96e878ea6873@nvidia.com>
In-Reply-To: <20260903-64-bit-iova-is-silently-truncated-to-v1-2-96e878ea6873@nvidia.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Thu, 3 Sep 2026 20:59:15 +0530
X-Gm-Features: AcwNN1U_7SRY207nVO2e40U-fvwTEuF82VJHAG_LK7dgLCcn04xG3zYyNMMAeyM
Message-ID: <CAH-L+nOSRQ+XyrwO4h61_JPUQBsCqCwY7xsLuu53GRVrCstFVg@mail.gmail.com>
Subject: Re: [PATCH rdma-next 2/2] RDMA/irdma: Remove unused post_sq arguments
To: Leon Romanovsky <leon@kernel.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000006fd6d6065a95d11b"

--0000000000006fd6d6065a95d11b
Content-Type: multipart/alternative; boundary="0000000000005f3e5f065a95d19f"

--0000000000005f3e5f065a95d19f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 5:11=E2=80=AFPM Leon Romanovsky <leon@kernel.org> wr=
ote:

> From: Leon Romanovsky <leonro@nvidia.com>
>
> The only callers of irdma_sc_qp_flush_wqes() and
> irdma_sc_mr_fast_register() always request their respective send queues t=
o
> be posted, so their post_sq false branches are unreachable.
>
> Remove both arguments and post the queues unconditionally. Drop the
> redundant QP flush request assignments as well.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>


Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

--=20
Regards,
Kalesh AP

--0000000000005f3e5f065a95d19f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 3, =
2026 at 5:11=E2=80=AFPM Leon Romanovsky &lt;<a href=3D"mailto:leon@kernel.o=
rg">leon@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">From: Leon Romanovsky &lt;<a href=3D"mailto:leonro@nvidi=
a.com" target=3D"_blank">leonro@nvidia.com</a>&gt;<br>
<br>
The only callers of irdma_sc_qp_flush_wqes() and<br>
irdma_sc_mr_fast_register() always request their respective send queues to<=
br>
be posted, so their post_sq false branches are unreachable.<br>
<br>
Remove both arguments and post the queues unconditionally. Drop the<br>
redundant QP flush request assignments as well.<br>
<br>
Signed-off-by: Leon Romanovsky &lt;<a href=3D"mailto:leonro@nvidia.com" tar=
get=3D"_blank">leonro@nvidia.com</a>&gt;</blockquote><div>=C2=A0</div><div>=
Reviewed-by: Kalesh AP &lt;<a href=3D"mailto:kalesh-anakkur.purayil@broadco=
m.com">kalesh-anakkur.purayil@broadcom.com</a>&gt;=C2=A0</div></div><div><b=
r></div><span class=3D"gmail_signature_prefix">-- </span><br><div dir=3D"lt=
r" class=3D"gmail_signature"><div dir=3D"ltr">Regards,<div>Kalesh AP</div><=
/div></div></div>

--0000000000005f3e5f065a95d19f--

--0000000000006fd6d6065a95d11b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIVgQYJKoZIhvcNAQcCoIIVcjCCFW4CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghLuMIIGqDCCBJCgAwIBAgIQfofDCS7XZu8vIeKo0KeY9DANBgkqhkiG9w0BAQwFADBMMSAwHgYD
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
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGtzCCBJ+g
AwIBAgIMEvVs5DNhf00RSyR0MA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEzNDI1N1oXDTI3MDYyMTEzNDI1N1owgfUxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEYMBYGA1UEBBMPQW5ha2t1ciBQdXJheWlsMQ8wDQYDVQQqEwZLYWxlc2gxFjAUBgNVBAoT
DUJST0FEQ09NIElOQy4xLDAqBgNVBAMMI2thbGVzaC1hbmFra3VyLnB1cmF5aWxAYnJvYWRjb20u
Y29tMTIwMAYJKoZIhvcNAQkBFiNrYWxlc2gtYW5ha2t1ci5wdXJheWlsQGJyb2FkY29tLmNvbTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOG5Nf+oQkB79NOTXl/T/Ixz4F6jXeF0+Qnn
3JsEcyfkKD4bFwFz3ruqhN2XmFFaK0T8gjJ3ZX5J7miihNKl0Jxo5asbWsM4wCQLdq3/+QwN/xAm
+ZAt/5BgDoPqdN61YPyPs8KNAQ8zHt8iZA0InZgmNkDcHhnOJ38cszc1S0eSlOqFa4W9TiQXDRYT
NFREznPoL3aCNNbDPWAkAc+0/X1XdV1kt4D9jrei4RoDevg15euOaij9X7stUsj+IMgzCt2Fyp7+
CeElPmNQ0YOba2ws52no4x/sT5R2k3DTPisRieErWuQNhePfW2fZFFXYv7N2LMgfMi9hiLi2Q3eO
1jMCAwEAAaOCAecwggHjMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcB
AQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQv
Z3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2ln
bi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAy
ASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNv
bS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29t
L2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwLgYDVR0RBCcwJYEja2FsZXNoLWFuYWtrdXIucHVyYXlp
bEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUACk2nlx6ug+v
LVAt26AjhRiwoJIwHQYDVR0OBBYEFJ/R8BNY0JEVQpirvzzFQFgflqtJMA0GCSqGSIb3DQEBCwUA
A4ICAQCLsxTSA9ERT90FGuX/UM2ZQboBpTPs7DwZPq12XIrkD58GkHWgWAYS2xL1yyvD7pEtN28N
8d4+o6IcPz7yPrfWUCCpAitaeSbu0QiZzIAZlFWNUaOXCgZmHam8Oc+Lp/+XJFrRLhNkzczcw3zT
cyViuRF/upsrQ3KY/kqimiQjR9BduvKiX/w/tMWDib1UhbVhXxuhuWMr8j8sja2/QR9fk670ViD9
amx7b5x595AulQfiDhcN0qxG4fr7L22Y/RYX8fCoBAGo0SF7IpxSukVsp6z5uZp5ggdNr2Cq88qk
if7GG/Oy1beosYD9I5S5dIRcP25oNbcJkbCb/GuvWegzGfxCCBuirb09mTSZRxaBmb1P6dANmPvh
PdqGqxfFrXagvwbO15DN46GarD9KiHa8QHyTtWghL3q+G6ZHlZUWnyS4YMacrx8Ngy0x7HR4dNdT
pqAqOOsOwDmQFBNRYomMdAaOXm6x6MFDnp51sIWVNGWK2u4le2VI6RJMzEqLzMZKL0vTW+HPqMaT
hWv2s5x6cJdLio1vP63rDxJS7vH++zMaY0Jcptrx6eAhzfcq+y/TkHJaZ4dWrtbof1yw3z5EpCvT
YDxV0XFQiCRLNKuZhkVvQ8dtmVhcpiT/mENrWKWOt0DwNEeC/3Fr1ruoyriggbnRmBQt1bC5uxfv
+CEHcDGCAlcwggJTAgEBMGIwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gR0NDIFI2IFNNSU1FIENBIDIwMjMCDBL1bOQzYX9NEUsk
dDANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgS6h/9y6snTx07V3RNQbLGUX3Nipr
fN1HsQsgiNz2jbMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYw
OTAzMTUyOTMwWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAt05T3fbzdWHQe9wsy7FEGNLq1fovEF8cs7LboFqz9Ihdm21qLSRwle7QVVgHIQ9T
gtN9agl3Zs7UoYnB49AoCf5mPAatO2TMe0C2EH2lyRq4ryUHJkm00gr49UYg0GmrCdgoPq9h22sy
NwEToIxbSxo56JPCCzI/AOPQC0eup8VedmwMAtzykSO6dxNvEa0B7ZWqamDO8S97PRcrR25oBwgx
DDDa7p6w01Zw0kEF/h9A5oLZEbMy91rAkQoGiw3+KAHkYXba+O60anyoujvI5p3LgV7tT0Le+WDV
suLzXwQxSsyfjCubaT8MYguCKcS+BYjf2FYF0XGnNxh/yfEm4A==
--0000000000006fd6d6065a95d11b--
