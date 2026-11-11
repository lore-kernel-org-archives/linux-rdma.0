Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415817;
	b=avjzcar6UYNCQpY4EhgXUmYOOldM3HQEj+DooGnC4hUSCJvRUJlNZj8MPHhidDBFASkg
	 sP1jTpakgTmcvhMAMapeZV7/8j/wvRrwipYsCSFC57rf0LY5axdc8KFtj2G23KpbJNWyM
	 wcFctz6RXiu6TEa53mV1PPwlRcSzSDhWdQRIoPoHKrNP42Fi5sPyc5UAHgIxZSGm3NVyp
	 HRlCsJ0uoENmIneOgyELN8DSzYOjD7bNS/NUGMv5VRuAcrcVcyvPEz+U7C25NZi0vjuNV
	 zzw6T1L+YT78pCxyuD5OjAXh/sToAseV65skyEGLP/pR3Jt924w03UbILO6jZxno50A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415817;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 X-DetectorID-Processed:Content-Type;
	bh=Y+Kn25QRMC3mmI80LSHZ76EQqZfZxoMY4TavrU77wRo=;
	b=dN3BLse0AXeTORcRKHb/4ptlEyRPj5nHv6IYBJ0H3U9TqN1mk9NOEnHN6nwzHEqVMn3U
	 /S9O4XxbK79V/q0l5t4JRK+lkf9fi+0IIDBgBHQZgK9zXhSTNR4+jw+cAJeEE4yWXOQFQ
	 viEA5C8mrUbk74kHE1sWGyV2RNrvEEj1cM8CQofjsC8QQrPXBZB+qcV7D5g5uIpT8vHSV
	 aYBg2b4mqQGByX6egQzFSeAOUvaRtusJo2QRbXtQVsKm+TUJKLw7vUS8rAIxHlDxMc5Sz
	 ACINMP0miGlVQWzisFfw2AJIrVS4wxdKeaHpnaTY/Qxy+jSIBXproBJb0Yo5C2Dznww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=btv8PF+2;
	arc=none smtp.remote-ip=209.85.160.226
Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAF1606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBAF1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=btv8PF+2
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-5351d76e1baso244101cf.1
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 08:50:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794415816; x=1795020616;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y+Kn25QRMC3mmI80LSHZ76EQqZfZxoMY4TavrU77wRo=;
        b=UkSwNVwQ149qq6oyOx8///wf4o6e4ScnZzeP1iP7FLmAH6Vo4Ga5wQBApVPeTjulZR
         5AM4LTYo9XCs4K1QlrnPYHGCK90wx2+4glVPE2exebsDnreV6ehP1lxQwNqUbtiVximB
         pYYqvBVJuAYzk7hWqmUpkn3g4jbOzCJa9sPW5LCQIvwzuH0djaL2YZ/MFqlWPc7FOFi0
         2+A2pnuzg572Nm2i7rN5DfkMhxxK/wH2Uucq94sYMw/YAEeNd2RzWD7qa0mhQEc2a93O
         An0xM1cbu/QcueVlQDNS8IKtTd7Nl5RxQY/jWx4ajjgGcC8uqXG+tu3YLQV4RJULnKlO
         vrEg==
X-Gm-Message-State: APuU4Z/ztUO8+RC3w2k2muEcKLhLZ72wPvrnOrpXPV7eqCB0K/2TAlVs
	kRRDVCO5ygJcA/G8Pwsvw0fdiF8VA4wP8FU7S/F3B1TLl3T3wopAxZSQdtYHqiprTcBleHnE1sB
	Yliu8D08sQjyt8KgAMiv5ntLm/Zx6iEZV9k5rvnvfQ9MsqW1fxw6k1/obz0PuQPe/J7P5W/7yyD
	zgG76LPkk6Wsga8A3XkKcz36p6s0RqpkM8gxzCp+LOAHAPTVL1MkO3Lss30MwO9BfvzQqRDcUJM
	jLnGVxGBJtGBA==
X-Gm-Gg: AYBFou2yucwzn6yN8+K387F8Sm3lDl8W589xGvQxyC3TDsA0KyP1rJ8K8bXoaFiCsjn
	jcgj3+wcD7lyL4pdBZBTnawftD+4uIgoix6YT5WqeJ5PT2pbLK32zkriii4uIzBX4+1nxs6HIlR
	nCnud8r/hjb4Os6m7aRF84OiwU8hehhi+kiuQ4jSZisfxAskSOvy4EUMPNSKaL8Oujm6tbHbb3U
	C2uZhyUv1b1Z30E12/zjdSdH+V3ViqGTJWHyHd3qKqSajjBJkUqGRjn70sWu08hQiSkRLuZSQ75
	mqI7cfR3Bo1cIh8ZJO5XwVBeC0DwbfD6bIS6b2E7E/yfuF5jVcTZYSq4hDrBOhJfCeHL/PWVGPC
	TW3PFJ/lx8ElAt5J+VFbSzv9G8Rc4fTQpKqaHOVkPcQK3rszE8B5QzCHHVarg30L9ClDwAgcq0N
	QX88cPVke2O1N+BNVdQkGZr+Que30H/1+O
X-Received: by 2002:ac8:5a4c:0:b0:531:2eb:be76 with SMTP id d75a77b69052e-5595684465cmr395791cf.22.1794415815531;
        Wed, 11 Nov 2026 08:50:15 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-5550b840548sm965691cf.24.2026.11.11.08.50.14
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:50:15 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c29c391bd2fso301397766b.2
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 08:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794415813; x=1795020613; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y+Kn25QRMC3mmI80LSHZ76EQqZfZxoMY4TavrU77wRo=;
        b=btv8PF+2NrsxDkDdWfejUjaCCED64hrSwkA0DH+zoF0ThHUspaWJ6jqm2zgeDDqeYp
         zdYb+1wA3v0dN3QX1YHYb6nMIvhmPJydkchjc9iNkaXl0HdPJchHHheRkEp9VIpX8dsv
         ++jHNd7JfmhUF2sROvOvK5F+2rENo2pqLmyuo=
X-Received: by 2002:a17:907:961a:b0:c4d:4ce5:7733 with SMTP id a640c23a62f3a-c5066b47974mr231100366b.30.1794415813146;
        Wed, 11 Nov 2026 08:50:13 -0800 (PST)
X-Received: by 2002:a17:907:961a:b0:c4d:4ce5:7733 with SMTP id
 a640c23a62f3a-c5066b47974mr231098166b.30.1794415812536; Wed, 11 Nov 2026
 08:50:12 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-13-3e7e7ffed2e9@broadcom.com> <sashiko-outbox-206403@kernel.org>
In-Reply-To: <sashiko-outbox-206403@kernel.org>
From: Eric Davis <eric.davis@broadcom.com>
Date: Wed, 11 Nov 2026 08:49:44 -0800
X-Gm-Features: AclHuK-9myP5sE6RQ76RXYDzKbis4jaL4liHUq7-Tg_ozYWMBDz1erRP_nxNphQ
Message-ID: <CAMouMYLToUfUx9Xqms8MHCQ=T1SB8s-3eTizrVz8j2Gm_X2quQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next v3 13/13] RDMA/core: attach a memory region to a
 queue pair
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000244eaf066002fda8"

--000000000000244eaf066002fda8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 10:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> Can uverbs_free_mr() observe a stale non-zero mr->usecnt after
> UVERBS_METHOD_QP_DETACH_MR or ib_destroy_qp_user() detaches the region an=
d
> spuriously fail with -EBUSY?

It can, but only for a dereg racing the detach. That dereg has no way
to know the detach finished, and -EBUSY is what it would get had it
run a moment earlier. If userspace orders the dereg after the detach
returns, whatever orders them also orders the decrement. Nothing is
freed early: the detach holds the MR with READ for its whole run.
Attach needs the barrier after its increment because there the other
outcome, a dereg reading 0 for an attached region, frees it in use.

> In addition, both UVERBS_METHOD_QP_DETACH_MR and ib_destroy_qp_user()
> clear mr->attached_qp before decrementing mr->usecnt.

On the destroy path this can happen, since QP destroy holds no lock on
the MR. Again the outcome is a spurious -EBUSY in a race of the
application with itself; the count never reads 0 early. Decrementing
first would be worse there: once usecnt is 0 the region can be freed
before attached_qp is cleared, the use-after-free found on v2.

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-c=
ore-v3-0-3e7e7ffed2e9@broadcom.com?part=3D13

Thanks,
- eric

--000000000000244eaf066002fda8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIVUQYJKoZIhvcNAQcCoIIVQjCCFT4CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghK+MIIGqDCCBJCgAwIBAgIQfofDCS7XZu8vIeKo0KeY9DANBgkqhkiG9w0BAQwFADBMMSAwHgYD
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
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGhzCCBG+g
AwIBAgIMV+ot3F/3fQjMh7yLMA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEzNTIwOFoXDTI3MDYyMTEzNTIwOFowgdExCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEOMAwGA1UEBBMFRGF2aXMxDTALBgNVBCoTBEVyaWMxFjAUBgNVBAoTDUJST0FEQ09NIElO
Qy4xIDAeBgNVBAMMF2VyaWMuZGF2aXNAYnJvYWRjb20uY29tMSYwJAYJKoZIhvcNAQkBFhdlcmlj
LmRhdmlzQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANfEH6AC
+LxMFQKtBM+3IIkk3y79FdNJ0aSEtx7ylIALY2Cy+w4cZ2mnTQBz8I/fcvc+7Nu4+C82MEouggu7
THSLCC9N61nO6/woOMp7U0lttATSMIeibGPNnU8AizWyI5DxXKkIG5jv1EosjdJwBsJ8ZntvpfIx
+KplEkYfqN7Sy+7LOzXXkl5KhTkDELRuftv+sahPNzVHW1cJgj0HjMb1sCrFjzcAuO27JA4geQXW
cl+gyZDv53xtHnMSNmIoqDEINo4yoSHYPGK+cTtGC4K9a6yCXdP2zyLkkSQtZ+hEUOru4dQ1gIZf
4bWVHOILQGaMbqVAVA1OrjpUNGktgz0CAwEAAaOCAdswggHXMA4GA1UdDwEB/wQEAwIFoDAMBgNV
HRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5n
bG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYt
aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFww
CQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwIgYDVR0RBBswGYEX
ZXJpYy5kYXZpc0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAU
ACk2nlx6ug+vLVAt26AjhRiwoJIwHQYDVR0OBBYEFIjgxJwMJZ5pkTAB1796PUvJ+W7DMA0GCSqG
SIb3DQEBCwUAA4ICAQCM/INVouXcD/gHdJNCPtF31BpLUwHGTj4BlO4083w8xuxt0iSjyb0EKv7S
LBz29Dw9scSTMRS/sY9dotjJ03vVvzceiGB4FbMIZNSKHTy1PTNu0oZR7TwhBEEZHC4RtST9S2hU
MvDagOAWRM/56PG6FH2i7dnhwtcnsBX8CMeVJQc6SB21LuxJVqgULli/kbrkr1DBVMh2f7oCFHVu
0VgtvRtACeQVi7ny8wspKNV/WXN2IqT06c0vtUmFUPkidlgGxMzYCfQXbXcE3YvA7+xYqmCY0zdQ
f/ira3VJoAytznhfRSBRV4gmlChdSg8yoaM6LHNE7igDDqhVFT2QCqkRkIcPOCQYxNE4kViiDKKo
3VFnREnYmLzRbJkdGY4X3m+N7HOU8R99Zeatx6hN02eJQH1vZ1J9cH4SqxuqDxKi05n3SGE7J4Wc
oNsgfaIDL28JX+2JBG+gKr/vvjocja5y9G43gvIOs9yEzGBt91FCuuwPedXIIREUcqJtq6+MOvAq
ZMEsct9jQXibihTD7z9wLTIkXqOHumCc6f53zhsQCRofr8m7Tm0YrckGCHd0BowU12A6oVax5xEQ
6j1hyszkhFPrlLKAlaFU7VuIwlcjKvN9XYrmOfXfTnYoVV6f1IDwhgbtJNlKnJksqoCzfsbAVd0e
usA704DOznTCfAYJqjGCAlcwggJTAgEBMGIwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
bFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gR0NDIFI2IFNNSU1FIENBIDIwMjMCDFfq
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgtkaha8Fgk/SBveY7
7UWytyktVmDek+pnF+dIi43nW0AwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMTExMTY1MDEzWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAyeh9n2dlyVZovgrzD/AUPjy9dnyAauGAFMMGiDNHA/gf4ePzFR5V
MGhsQLt6mvRJfbJmD533Lj/XxmSrgrRBVO91UDu8tbsCrFuF1Vi4sJb8LNDRIyfydkNsU9oIGzxy
+msLVfoA263hH+68ChAY+QPlxay6XWFW7wQWRS1HMFKda1J7BSCWOfiavksTj0Vpbqaua7XP+6fj
3z6O3OtF8COUQHzwttg7mN95XcHAHdIOeMwVMXCixTjNtez2Ep+6baLvuSbYgH0EJG2zClQYEZ/F
YDT1RoCKRMFOohMlfCyFqWgyvROCKZjt2pie7Y9XnlZNJn3XIak8JZ8ZRFx9pg==
--000000000000244eaf066002fda8--
