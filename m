Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA7A525A69
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068911; cv=none; b=seqiLjOL17/elKjoURVTNCB36RKDxtj8WVH3ZQliEOscfNvp2bLOZfHcVoTLPNwvB77ZZiKIYSgBPnKJXHtAdtUFie9iVGM7Cvv1JISZKIM//IxIa82xr0mWddClBu2s28SNlvBqtQ+SrWBFGN1BrUoZRlF4mwDJUrumB29Va2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068911; c=relaxed/simple;
	bh=T7YDeT42dBdfBs2623ouOaAbGRiQkzLgG7ejBtfGs8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SxSqSlZ9E9n/XyWw+F5uLhGKFXW5oowb4JgztAxRJH84nEDxKT+int9xOp/dUGIvDnRQ6wAOSpcmDXDcsqbpgXhkIKtbI/KY/GgTM6A9zsVahyk9jmOZwuwac3vN90CpNQg8l5TGgBuElnL22+rJaODltwa0ULyifxVhi+u0hEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=OBsetLU6; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OBsetLU6"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-892734ce7e6so809857b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 05:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792068909; x=1792673709;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T7YDeT42dBdfBs2623ouOaAbGRiQkzLgG7ejBtfGs8E=;
        b=ZGQNoTbswC7U1XMX9IIznrUkd4DNyhiZ8cWopppay2H87iTnLrsoBQtILZKBYJCkpb
         Ju6UpVOyHJDxl7K9YYg/GB/PgaxtQTf+dulDD6f9GU2TG5jfA8UUmdBL3CZWFY9Vifpg
         PGypqiwSJxnk068NBP7mjpAAmYrDD7+768iaI9EhF/GcHTzGIXsQDHP4j2PCxk1/iTbP
         jc/SZcEu1OSJsiuxVxVes47zAFAHETv7gomTPzo0H/LtUW4768xYWXwBIEmIst9VCsvB
         j0I6d6pNlBdhdtfvMnDzL+1Kd9TfzBNo4xV8Df7804K+4+vnuv0zlM4qb0MKJGNVrFmB
         3tww==
X-Forwarded-Encrypted: i=1; AKwUvBzR27kZd+60VSmY2qm/9UNJCTuCE6Sy48YE+Ty9y17BhhDOU3qBPFa1lFV02lpLWVDfXMXzLPt6YFBK@vger.kernel.org
X-Gm-Message-State: AFq9FYL/xn4ovlWetYd9qJE3d/GiAShxEU/5pTbRfnc3bieQJwlkqdMj
	kraAkDDIygDbPFCmeepTI+Jfgiqfc2sPWRtCMr2DMkc2rCNZp6v7cBk9kzFyi00Sr98Uj39iReO
	FGZG8F3/SPD1dbL2iUjMS15MT+4l1AKiaEKTKHCqYCzPcjKOAo7j3cJlYj72XLMf1Vc/NqyuiPT
	CFhypqcAMdbBEa6OR+otiKCjmm5IbYqLVJouY13vHkSTJnHTsuRgiKu//FMCKJ/yN61Gf+soLco
	+rFBOpdmndvw6JHqKAnpm1U89A5hw==
X-Gm-Gg: AYBFou2aQujyeYz7qvxngG0fM6NPPsQ/cJaWqZjOPy233IivhzqwK72rnsrXkGlPEzB
	pXfIv31ExJSvlXwQkQNBRRQEO+/UV9Sxh8BL7uhKNfZMJ3qmlctmkM7bKR4YZSF9XxHHFtp1YCQ
	ht+81ki7EgMAI0Nj6/AhfQ70SRzUu+73uAcaTV1l4XI/QWMJxp6qJmH2ABEPuL0+GvCW09x/cdk
	97psY9JRRtinPhJ1ywzVau296HIgf1bpHum7MPnPF0FRmEv4yTRkMXE9zwq4ucxvF8DlReG99ov
	H4zky4/ynHeCPzHlVnrOPaN/QxNRSUCNWahPQw0fsR/JEJ8IAgGGYIWhmZ59S2+/ejImqfD9xRR
	yEzOHMa+kI7FYcMOIluOR3hd04xD4gc6hJiZt5unEidw8rhdqVQEeIkTjvsioQqpLEKG6SAul/J
	Uqc+q/eWSr0OG/7hFwJxOjztfoGy/fK90Ya1STrEXKQDQ1Z8c3t/M=
X-Received: by 2002:a05:6a00:2e03:b0:89e:7bfa:f88b with SMTP id d2e1a72fcca58-89e7bfafaeamr1924031b3a.18.1792068908866;
        Thu, 15 Oct 2026 05:55:08 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-89d803cf6cesm141816b3a.12.2026.10.15.05.55.08
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 05:55:08 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd5fd34fee0so1423365a12.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 05:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792068907; x=1792673707; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T7YDeT42dBdfBs2623ouOaAbGRiQkzLgG7ejBtfGs8E=;
        b=OBsetLU6R7pRPYqvXDNDAQu293nF0imMOcbhntB94kv/JcBK7Rr+rrP7oyOdmShoIU
         sd5Bwrzoz80vp/SHO9jiBaYHMefrat4KuSsTK22A63xv4XmGXMop/jHwZRdQouEPqwr3
         JV2SKfM2WTpxeXIhkBV4AMuikfPvAnMOK5h80=
X-Forwarded-Encrypted: i=1; AKwUvByB2zbGWw/vKoUhT+lHZ3nAlOG9DhdFmwa4tbEp+v16jFa8/6k8MMIzQ7v0OUKoE8Ty1sUaCKWSII42@vger.kernel.org
X-Received: by 2002:a05:6a21:4cc5:b0:3dd:d729:c62c with SMTP id adf61e73a8af0-3e16c067a60mr15591524637.54.1792068907295;
        Thu, 15 Oct 2026 05:55:07 -0700 (PDT)
X-Received: by 2002:a05:6a21:4cc5:b0:3dd:d729:c62c with SMTP id
 adf61e73a8af0-3e16c067a60mr15591511637.54.1792068906902; Thu, 15 Oct 2026
 05:55:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261015-ib-core-fixes-v1-0-60f6da3ddec3@nvidia.com> <20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com>
In-Reply-To: <20261015-ib-core-fixes-v1-2-60f6da3ddec3@nvidia.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Thu, 15 Oct 2026 18:24:54 +0530
X-Gm-Features: AclHuK_CjBZVTc__rzL7uzgk52Xh32w-umD4XAIp5pEHVEy5553PnQ3BcAKIMog
Message-ID: <CAH-L+nMq-54p9_forPExpP2r4EQ9pNdAruQXR8y+ds+jSc=rbw@mail.gmail.com>
Subject: Re: [PATCH rdma-next 2/3] RDMA/core: Free unpublished port statistics
 after initial-read failure
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a69bea065de08e33"

--000000000000a69bea065de08e33
Content-Type: multipart/alternative; boundary="0000000000009c0b7b065de08e15"

--0000000000009c0b7b065de08e15
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 5:31=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:

> From: Leon Romanovsky <leonro@nvidia.com>
>
> An initial port counter read can fail after allocating its statistics
> buffer and wrapper. Free these both allocations.
>
> Fixes: 467f432a521a ("RDMA/core: Split port and device counter sysfs
> attributes")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>


> LGTM,
> Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
>
>

--=20
Regards,
Kalesh AP

--0000000000009c0b7b065de08e15
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Oct 15,=
 2026 at 5:31=E2=80=AFPM Leon Romanovsky &lt;<a href=3D"mailto:leon@kernel.=
org">leon@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">From: Leon Romanovsky &lt;<a href=3D"mailto:leonro@nvid=
ia.com" target=3D"_blank">leonro@nvidia.com</a>&gt;<br>
<br>
An initial port counter read can fail after allocating its statistics<br>
buffer and wrapper. Free these both allocations.<br>
<br>
Fixes: 467f432a521a (&quot;RDMA/core: Split port and device counter sysfs a=
ttributes&quot;)<br>
Signed-off-by: Leon Romanovsky &lt;<a href=3D"mailto:leonro@nvidia.com" tar=
get=3D"_blank">leonro@nvidia.com</a>&gt;<br><div></div></blockquote><div>=
=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div>LGTM,</d=
iv><div>Reviewed-by: Kalesh AP &lt;<a href=3D"mailto:kalesh-anakkur.purayil=
@broadcom.com" target=3D"_blank">kalesh-anakkur.purayil@broadcom.com</a>&gt=
;</div>
<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr">Regards,<div>Kalesh AP</div></div></div></div>

--0000000000009c0b7b065de08e15--

--000000000000a69bea065de08e33
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
dDANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg+i30ECsS4KKt6WEXm+ezbmWzSj8e
WAX6B2L+qAovllowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYx
MDE1MTI1NTA3WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEAaB9uUtAtaKcOe9Pxxug5BD3AapdMIupHajpyDNIYgxOPy3OiAwxA4wZ1TPtMR96Y
imzJcu4n7i2GjC+jEaFD16zBGpv2TKXGB8JLNUMmfr3h86rpfW8zWGu/atfBhxCpkkxzIWhEmesc
tIh5LJ5dD3JGIjAKyz3vj3MEjsEAJlsHEFdFI2fX5hXTX0y4ADz8LFmi5h00+aYx2bxlUorL/nW6
GwmlBYGAekxIyqJz6CnaLOtcvwajLNn1eMr3wg7oVv72vQ4CWTFWVbxVGMAJGAbjWTroG26pneuc
nXRMaqhhFKjrFNHtJygs3i43uxLRopAGl2g6T5xRsHRgcBKUdw==
--000000000000a69bea065de08e33--
