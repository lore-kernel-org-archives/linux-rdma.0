Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94CE3C1083
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792080602; cv=none; b=aw9NoZqAI1gARbDNXmPbjCE7QUBRC6iIruFhOjSHq4o3TA3QTH3K5Tb71VPLHtVY8XE5gqsPvNiMl5fIMGZNj9N5lbGraF5Dhm+V790rGIfKTSz9fCJ7XEj19md9EXl4hoL8CrxUgIiX+hG4V4K4fYOIn5vb5P9tarukXxhz1a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792080602; c=relaxed/simple;
	bh=EPcm2DCw0bMn1nuLyaeMJBsmtvQgiIcYn5COsX6S00s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W6iZBZw3CHbNllYtcK5DT5uKMy0gV1cwk2vSOyKHOeCqaYD1ELjo5XosvJaeeqBbDIBe/gZ/lM23z1pkkJ1FV81Lf2/8iwfrsH8KkkRxvJez98BKaOb5ltPmmO4V//DXOGxa3IJEHLHu+CdWmZKEzJ/uUBKlwhK3woCJHHRgynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LTqK8TXr; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LTqK8TXr"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-91791ec1b83so14875176d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:09:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792080591; x=1792685391;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EPcm2DCw0bMn1nuLyaeMJBsmtvQgiIcYn5COsX6S00s=;
        b=HzK8y6J2XhmB6hH3k8bvrtE91H4q0+4Rsxe4EZrXoS5XHUpHcyH+xNTqsZx2wXlL6g
         tJq/rIk3bAx7+XTpjZU2ygUgscARKy0cBrL1EUk9NLxSsGQ4qP7PRAOEjCDVO3IluIyV
         uPWguV8h9EJyjhA7aZsotoA+sz5b2pv0FvT69qRAtjyUdzp2pDbcepjqnpmrg0+2qTjJ
         iABzDoSmzNW73o7oKoytbp/1oIr5FRnuAkq+yH9dDb3HHkruujrCxOHzWZ+ujtMf7AwU
         CvkyWZtWbT8GLFWmrAVWuAEztfaF+65YdZj5jCX6AlWU3zgApqAGxj42341vVtRBzVml
         qAOA==
X-Gm-Message-State: AFq9FYLQZJvFfMZkgdgLCThUStyCuQNSuCcnRLj8rbx8dIveA+wabIZb
	i62zaicpaPGlZoKCJ6nYMuSGrBFFcQhM89AyTMjZL4QrxfLJlIeXAVkkWH3Gd6QCfgdFTLCCQEw
	sWyOWs+d/DUgtfyQWfizWf0ufIqVGZPVUsAiFyX5cBMiRodXZNFmSeoeTZuFI7HnL2ojSkUmNlR
	i6TZqFZA09F185nNV85gcM6s/t+AcOaWbvLjgXn1AeBfCHQZbN2mDs9rVIdzgmzcHmyRTrNgK7x
	PZDEoFD6g7Elw==
X-Gm-Gg: AYBFou1/Gn5W98Qw0YXH5Kww2mXVO9HcW2YBaAapTPptmIoWtzsGg7pm4/0KSQcfON1
	Zd3i6iNMJ6EKDSeEJF5tPORK+hwyCk6DjldRLDNDpsv0ndBZ2Vs28ClmLiFlD+RKdiWmyTFJmkK
	SaM8carq443QY+JbjU6yKRK57BOl9xfDcpd/qPpV0trUiYxUKkPqKgd7migUYdQuJm9pBShsUYH
	hWFVq8YmeqDyFf2GPsmpgGDM/aGX64gU6dA54vQozjQvuuGQujF3QOyywyzTTzakg1y8tjdGAj1
	W6nJnrN8eIHAl7ejOdXIR3n6bNMSPLwY/I1aZTMn11zQv1f49hP6JeEDhNqxojZ5L9zuxA7/EJ8
	an6VqAwsrrc3ZiJsuf974RJAl+afB280vDmSvM/0x2ew4C9ty+VbQiRU5c8EO0/Y35I2h7Cbd6s
	ey4NukPcUr0BxB+dOFAFFcBschFkarGiHZCpU=
X-Received: by 2002:a05:6214:21a4:b0:917:949d:1cfa with SMTP id 6a1803df08f44-91b555723c0mr337213756d6.33.1792080591229;
        Thu, 15 Oct 2026 09:09:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-91bca43dd21sm12856d6.36.2026.10.15.09.09.50
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 09:09:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1d43907c2so4170370a12.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792080589; x=1792685389; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EPcm2DCw0bMn1nuLyaeMJBsmtvQgiIcYn5COsX6S00s=;
        b=LTqK8TXr9jUrQz9q4fyAwSU0UkpADFAEWkj3F2un7CseJOcmdaxLpjxl3akKiceja7
         IJ0v6nTdw5QmUMPd8v+cLsd2ZCwcR49vtaV3XiYtXffjx9EaVZb9+eP7gkkKbAwq1XQV
         TAoiNCGwir+09yuo3b7Yf5UC6dGgNjISnSPyg=
X-Received: by 2002:a05:6402:3227:b0:6b1:d961:ecbb with SMTP id 4fb4d7f45d1cf-6b1d961f873mr8882422a12.32.1792080589017;
        Thu, 15 Oct 2026 09:09:49 -0700 (PDT)
X-Received: by 2002:a05:6402:3227:b0:6b1:d961:ecbb with SMTP id
 4fb4d7f45d1cf-6b1d961f873mr8882389a12.32.1792080588499; Thu, 15 Oct 2026
 09:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-4-a0e626117113@broadcom.com> <sashiko-outbox-172001@kernel.org>
 <CAMouMYKADaQjsjeGZZyB+eWvswpf+b_H=aT-VZHVoe=vQFhxZA@mail.gmail.com>
In-Reply-To: <CAMouMYKADaQjsjeGZZyB+eWvswpf+b_H=aT-VZHVoe=vQFhxZA@mail.gmail.com>
From: Eric Davis <eric.davis@broadcom.com>
Date: Thu, 15 Oct 2026 09:09:20 -0700
X-Gm-Features: AclHuK-qOsXp3gBTTqrXvT3N1n-V1a6FDEYT2EWH4nC80y9pVk1m9o7k7-Ud1Zc
Message-ID: <CAMouMYKo+z70vA86P5gG-Kz=5TCSUZVfuLS1wAaCLKopze=R=Q@mail.gmail.com>
Subject: Re: [PATCH rdma-next 04/13] RDMA/core: add the reliable unconnected
 queue pair type
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f13392065de3465c"

--000000000000f13392065de3465c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If it's preferred, v2 can make both post commands return -EOPNOTSUPP for an
IB_QPT_RU QP so that is explicit. Let me know.

Thanks,
- eric

On Thu, Oct 15, 2026 at 9:07=E2=80=AFAM Eric Davis <eric.davis@broadcom.com=
> wrote:
>
> On Wed, Oct 14, 2026 at 3:43=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> > With the addition of IB_QPT_RU, should it also be added to qp_state_tab=
le[]
> > in drivers/infiniband/core/verbs.c?
>
> No. Core never calls ib_modify_qp_is_ok(). It is a helper a driver may
> call from its own modify_qp, and an RU driver validates RU state changes
> itself.
>
> I don't think a row can be added without causing a regression. The valid =
flag
> in qp_state_table is per transition, not per QP type, so making RESET->RT=
S
> valid for RU would make it valid for RC, UD, and every other type in
> every driver that uses the helper.
>
> What core does enforce for RU is in patch 10. The attributes a QP may be
> created with are limited to STATE, PKEY_INDEX, PORT, ACCESS_FLAGS and
> PATH_MTU, and the state must be RTS. The driver's modify_qp then takes
> that as RESET->RTS, and the QP is destroyed if it refuses.
>
> > Since IB_QPT_RU is an unconnected queue pair type, should
> > ib_uverbs_post_send() in drivers/infiniband/core/uverbs_cmd.c be update=
d to
> > account for it?
>
> No. RU work requests never enter the kernel in this design; they are
> posted by the provider (the rdma-core series), and there is no kernel RU
> work request struct that a driver could mistake an ib_send_wr for. The
> write() POST_SEND and POST_RECV commands are declared with
> UAPI_DEF_METHOD_NEEDS_FN(post_send) and (post_recv), so they only
> exist on a device whose driver supplies those ops.
>
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib=
-core-v1-0-a0e626117113@broadcom.com?part=3D4
>
> Thanks,
> - e

--000000000000f13392065de3465c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgOLnF/cKsBYcQqnrn
TipKnrmE/KRPlXNSUGOIdgSRWeMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMDE1MTYwOTQ5WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAhowAQ8xFLr0WwzssTUzW3bVQjBb7RmzooaxGbJ69nUWVoeQtYpwL
scQGFATMqHfzzYwfi+0zMP3yJR1rCqSRTp4gAoH/WaJm3jpAz2srnYZekzNLGi6IxG8Uy8l7V1Sn
8YPViUQVF1EGE7ZB9cWLVBqj9zx3urwlQSLhC+9wfNW3mfFb+F/DSK+A68G4Gwawq7h4383gfOUg
ZXzT23Gpcg7EkjDaV2R5/vLIkuZ6umjqw4K3cswbD0aIAGdE5mlup2kokJJz3QNp6SSyxmoloQ/S
4rnRGOGWiEOGEQhZ9dLA2EXAiY0xg/xQroL977I12/T58UlcK8YBej5WtMAqXA==
--000000000000f13392065de3465c--
