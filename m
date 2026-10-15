Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575A2392811
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 16:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792081000; cv=none; b=dEzYTkoPlePceFwgEGNlig8hQFuefpxXcG//2XbOCVdgqG1lCVop2QmqhXH9exGpoO1tAJn5QRY+F9gAYQrTFGo+yd2fE/FiRvpDQCXocJ+2b9P548+wTQoOSUD9AyNw87seT4isd+z0L7XjBVdFOhWpR3Y+PBPhg/6m8RPND5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792081000; c=relaxed/simple;
	bh=LABEZcl64hCdAqau94c8ncttbXeR2cd+jdsXK8gbGdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwnGZUVj8xEe2T9s/EJBIoKTxlTq+ZxY7IQQZzI7VTlAudzVSHBo17ZNib/9uuvKXI+Yl4Zmhe08wD0cOgAHz6nXEA15TrUasuTEgPnJLmEsogOpElSDq3/XOlkbHWY41QnnokUvUl4KVlNHAnmORMP/pLgSOpCFDfv5MY8sJiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dLZQInZ7; arc=none smtp.client-ip=209.85.215.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dLZQInZ7"
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1323580a12.0
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792080989; x=1792685789;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LABEZcl64hCdAqau94c8ncttbXeR2cd+jdsXK8gbGdo=;
        b=e3MkAjyId5o57xQ5EcM3BkepzNxL2w4F/LcVVybFhtD1qBT7IZ/OxJTCIS3JIliZyN
         9tZTEeOIa42HThhoYpn0TaoWJ/JTu1Yx0X92f6oeQk+LSXUqm5Y5P1ZAOMOiCiCGrtmV
         RiW4OBCM2y2Q+VXvUHYaQgyVECT4LkYEntuSYEofpIPpZSDJZW6vfeA+rYTSxU5KDqPd
         R6xz6X9h0AXE0NZJPfd8k1aiBe0v7OjfshhYj9snWn2LsNu2cdUe3PuQ/XByKYCOv6Fl
         TqE/8fuEBfD2JhkbFPs1FZAacaO6Tss52tn01Y2hhaOnHFRPDQ4RRNWawtmGubIM5Ey2
         tmxA==
X-Gm-Message-State: AFq9FYILL2CJeUHV/RDma0iikU3xpVnXbdmjDlYdsYVtNsY3SlLDDOj6
	L0TiNyWmA4dKnOZuosNteNZFE7vZPGIyxQALEu5I6JMXa+738Uas6BnEuUGTlQRnWXTK0+LA2mv
	YTe9mRdvVFD1HWFPfsy9y0Cm5JPaNfBshrPgz4fApIcFaXyNlCPOtQDJXKUnykMQITZf32s+im9
	jTBb0Ge9+LSNJBFXQQNpRqIPMawSyzN8Pa9O8BdYMGNI02PTvea1Ewf9/g8qcJx8rucQ2mJJ/iQ
	J5a8ZNgfEabhA==
X-Gm-Gg: AYBFou0YTR6UdiIPk9fd0YJ1YQS5DguCMVsVQ86ZRwC1N9PiOulxbLmJc4cH28993JL
	gQ0IFH2DuGEBnF4+/q+L6evHESx1uILzh2wQvgShEplgt1wQfdWOaDBGEqNzxPjE0OkoDtTZUQP
	rpouWVs09hrOU5Nw3l3gQTjZv1+gHfLoHOiI0yUMt5YJvk+w6RgTKAFCsrEaaKLxrBU+1pk4LMu
	jNdfAwym+Zt53W+VibLGzHFxid7UUXxdT1FYVrTUXa/ws6+RvYduzRJUmzAS//S3g4keM+vLVx8
	UvzqFy3FZQEZx/oN5s41s7ODMKDTfu2Stm+aPIdrxQgmiTi/N5mwvRic6/8sWRhjXkzUIaT//Mm
	prTHM23AdxtulQtQhSOq+7Zkdqd7vPm9qGdm42FUZ+5hLTaGGAFbo4YoFwAtd3z8pB7o8E+T89K
	+e6961sM6OPs4JXeorXkh2/LCuax0f9ZAAN5g=
X-Received: by 2002:a17:90b:224c:b0:3ab:2ad1:f10a with SMTP id 98e67ed59e1d1-3ab3a0ef48emr16306704a91.0.1792080989063;
        Thu, 15 Oct 2026 09:16:29 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ac9476e9a5sm1907539a91.6.2026.10.15.09.16.28
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 09:16:29 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b1d6c10725so4749518a12.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792080987; x=1792685787; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LABEZcl64hCdAqau94c8ncttbXeR2cd+jdsXK8gbGdo=;
        b=dLZQInZ7a4dVwDTbDEZ8WPDEb6Y/xY2NBAsracZhXv+q5vVgvY8rGWpYsr+lKB7F+R
         /54YHJ8I1IxmwezhZDW20WVv2UPHVdmdC9Laxe7d6jt/mMkotVC1sqMQUFJRY5PoeWHd
         EKzpokf/OGrEpcYjYloVbEidHi8Bneec4Ovjc=
X-Received: by 2002:a05:6402:2748:b0:6b1:c697:3c46 with SMTP id 4fb4d7f45d1cf-6b1e0afc778mr8249743a12.1.1792080986853;
        Thu, 15 Oct 2026 09:16:26 -0700 (PDT)
X-Received: by 2002:a05:6402:2748:b0:6b1:c697:3c46 with SMTP id
 4fb4d7f45d1cf-6b1e0afc778mr8249619a12.1.1792080983794; Thu, 15 Oct 2026
 09:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-5-a0e626117113@broadcom.com> <sashiko-outbox-172008@kernel.org>
In-Reply-To: <sashiko-outbox-172008@kernel.org>
From: Eric Davis <eric.davis@broadcom.com>
Date: Thu, 15 Oct 2026 09:15:56 -0700
X-Gm-Features: AclHuK-yYxy046X5qKLMTFY55FEszaL_pLFnsU8uzsMvxnf44BRf3mMNVKY0058
Message-ID: <CAMouMYL6cw6uNMnd_Vjz5WnWypTq7iq-YXHhyk14_taBJhwuug@mail.gmail.com>
Subject: Re: [PATCH rdma-next 05/13] RDMA/core: extended address handle attributes
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a6923b065de35e59"

--000000000000a6923b065de35e59
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 3:50=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> Should this use uverbs_copy_from_or_zero() instead, to properly support
> trailing zeros and allow future structure extensions?

Agreed, I will fix this in v2. Patch 7's JOB_ADDR_INSERT handler reads the =
same
struct ib_uverbs_ah_attr_ex the same way. v2 will fix both.

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-c=
ore-v1-0-a0e626117113@broadcom.com?part=3D5

Thanks,
- eric

--000000000000a6923b065de35e59
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
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgXq+2btKvFOfzUWAD
Hq0eoXnCdpbLzDb3DgwmeTA12cUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMDE1MTYxNjI3WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAj3VvZTHHHCddeMLl9IzvL/fftSK2mYPUYJ7Fzu50tKHfRwez91Fy
X4vuMidiMtBTFuzL+ia4flQr/0CK7rGxgZiS3gBZZrUYA2AfL2ElX/lNHNB+5mgWiw1GMuqhmBd6
oSpCy+hvHe47dMbIzD6D71eBBvab3mZ5Naq5fFHu0J4/Tn1ANouYwPkZOZdi5wBt5IydLRJXbVHZ
UidhZ9mEKclTqTC9iwA3IeT5hvm5UmBzDqRztXB0ZS/5UMTWmD/cJR2yg8uVEhjVMam6nbMt5efY
8cL3z6mjh4/WOh+g1MV5ChpiJLIQopBhVS/7D8mAqvf1O9NLE/cfCSpATsoydw==
--000000000000a6923b065de35e59--
