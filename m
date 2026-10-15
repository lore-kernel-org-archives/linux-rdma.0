Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A62429CEE
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792081681; cv=none; b=ESyVnyLc8W9WyMHtDs8+7EqZ2J9jUbYSIGfpGmvUP+cHUMr/0O7WCV/ZC5M8d4INwcAxfMNMinHtEgkBIdJxtsz6nYK4GAD/jbCB64+FFODczTAsWuHF9bzNdCtTfcRQ1msRDAHsBT4pKfZxtN0szDHuAOV4tAyry6DmGakjGvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792081681; c=relaxed/simple;
	bh=xOVJ9r9j4VNiMpycidcn9pKci9ENfaRyKhzhrNHV5Pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WMM/pbpWb2m8G86F553jIvBNsUCbM5fZtK/2on7ond3ohBTK88IId7WyTPwLV6kG7OW6FcLa2nWJmO0eMYtsFLSEnb7tuZ0VzTIebyuRr4/Jv8J5tjiP/pJNB+Wz8x0OODYBxJRmsSU/w1XbTPTObUG13hHkh6iYNRZjVvGTbSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=aM3U5adA; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="aM3U5adA"
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-82395ae2ea8so1773452a34.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792081668; x=1792686468;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xOVJ9r9j4VNiMpycidcn9pKci9ENfaRyKhzhrNHV5Pk=;
        b=LEf2UsJ1wq8zrXn4NqzAOfmUCkY0eASbHsz54WaJE33e717FhdMf1Ap15ushvxOiZV
         5tc/uVslaw1UUJDXMzdXmhqzaKSOh42pxzbMy5ssTbygCxXnRFih+y3AL8INhtgvyrCJ
         i65Ih16AH3pm8PXWNwyaHDk9wiR32ENvyiZWgaVpPpIQafeoRZ54mWFpmeGKdf3qNmWZ
         KRYF3Wx/7+RWFY4EQikOObVxyy+w3K3Tz5df5gewR3oLDNdNGfzOIulbfSAWkd5ddDUL
         XSfIryOrzviEvVz1mHdOt+PlxmX3sdrZkYuiOT1mRPOnUufaM52PIZuQxLIHQqiGtroL
         W9Cw==
X-Forwarded-Encrypted: i=1; AKwUvBxWLCFGkWivFz2uU5IPYhQ1YftpR4c3mQJCYwA0MFnpwgea9kaN2QQn/dSXMOUUUqmVHGhjkU2IvlHC@vger.kernel.org
X-Gm-Message-State: AFq9FYL7/D6PO6a0bh9DcIHQ+9ji2v93+rhs/Gtt2r2T7n2vT0KJSzuk
	nG4emUeEaIq5SSRzVQ7l3pct8D1wQ9a/HHSREZlNmoeBTT5LeVTZxPEw+sjsVyH0Dd7m2dam7KZ
	jzWcXRsgA8mnsWqMeuzRM1oLVQdNb4GySAPBR9Dywq9R0SyQHhWwDsCi+ZKsq2MSdVctPT2L+AT
	RW12+Nz11YxCf4rkttWCT0p6MibK4s2G+1V+dhBxfBWGnzoYPWxOviosIIv5EpMxlkZLdK+ZkLD
	LV+3O/PXQIApg==
X-Gm-Gg: AYBFou3iUtB2Pk82rBJpZRYT+Wfj4oozFaB/W8+8UfAR6SHWcuM4k8K9vL95BhZvj4j
	7g2kqg66+ywbbB/HTk83Pkv7788QR2xSbKy5WaSS70PJK4g1pqcObB4XUkr3r6ZJ8jwWLx9OFwN
	O0TKrdj7vjVeiyYe6vWvhwY70WvmKrwyNxMurk+Lk6KGosWdzHUMkjw5K362EsuiT1dWgUs9uGh
	J2AIWAuCWzQds64xLNVhwEyySL0hZkF57jpaI8k0uRHG1iIKdJx+0ZaJHmGq+9N46MC9XnOk2lE
	TNyuJMS7NCHDc3JdNZUzT44ekrEKp+WM0ZJ+Yq11OB1HPdGx/CPYV3frw2COQNbBZ3yPT27IUUP
	CdgM+xWV7cod5J1mjIrZYUjFO3CBUe8UHKFEAw3TJCdJ11xrdHQrDzr3N6OIVBIkwMuHyYaaOgz
	Ee9co6+tfJkcGtAOjHiGlr1DBcjqEouYiMs8c=
X-Received: by 2002:a05:6830:3492:b0:822:a034:551f with SMTP id 46e09a7af769-8309064f539mr18497426a34.2.1792081667642;
        Thu, 15 Oct 2026 09:27:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-100.dlp.protect.broadcom.com. [144.49.247.100])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-8423738697dsm1531a34.0.2026.10.15.09.27.45
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 09:27:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e47a584edso235759066b.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792081664; x=1792686464; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xOVJ9r9j4VNiMpycidcn9pKci9ENfaRyKhzhrNHV5Pk=;
        b=aM3U5adAq5t8iexsH/GlotKbvCQ77X/KD8qeJBWselz1q5veBWd+6J1YRhNDOedRbB
         cGaKjpfg/VVfc6TW4wHV8NYyrFIy4y042o3yrnp3piyfa7wF+q6jTxvaE8Ii+Y0jTGsM
         TXZhf2PNuTKJ0ToxmWD9dYm5AGGHeDX0kqiAQ=
X-Forwarded-Encrypted: i=1; AKwUvBySwfMuuqIsrz40j9Z0hZecZP8GVa+G1XXO1BW+96tafbOkQF1OntmZ3sg5JHX8FGybFDUyYLF7LfsL@vger.kernel.org
X-Received: by 2002:a05:6402:a0d8:b0:6b1:d2d6:4013 with SMTP id 4fb4d7f45d1cf-6b1d2d656aamr7550898a12.17.1792081664270;
        Thu, 15 Oct 2026 09:27:44 -0700 (PDT)
X-Received: by 2002:a05:6402:a0d8:b0:6b1:d2d6:4013 with SMTP id
 4fb4d7f45d1cf-6b1d2d656aamr7550881a12.17.1792081663764; Thu, 15 Oct 2026
 09:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <2bfb4db7-c9e2-4aa4-91c4-7991ee858089@hpe.com> <20261015000834.GQ14213@ziepe.ca>
In-Reply-To: <20261015000834.GQ14213@ziepe.ca>
From: Eric Davis <eric.davis@broadcom.com>
Date: Thu, 15 Oct 2026 09:27:16 -0700
X-Gm-Features: AclHuK_Ku2kqILOZUxbBRwmdTnlFmgaLrGH4me_SX4Xy4t6xnCWBNUy4MEVi7KY
Message-ID: <CAMouMYJ8sdCLU2V_jBT6ncti0SKZcAC_Si81=f+6DxZ0+G46EA@mail.gmail.com>
Subject: Re: [PATCH rdma-next 00/13] RDMA/core: Ultra Ethernet transport verbs
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <doug.ledford@hpe.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000077a6f065de387ab"

--000000000000077a6f065de387ab
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Wed, Oct 14, 2026 at 5:08=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
> You each will give reviewd-by's for each others?

Yes, definitely.

> You are running sashiko locally and fixing the bugs it finds?

Yes. I ran my patch series through a local Sashiko run before posting and
I fixed those findings. It was amazing what it found. I've answered this ro=
und
per patch. Two will be fixed for v2 (patches 5 and 6), the rest don't apply=
 to
UET ports or how core handles RU QPs.

Hope this helps.

Thanks,
- eric

--000000000000077a6f065de387ab
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
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgdpSREqVs1zs4sq8Z
se/RiuIpFC7HgVFjTA/l1bkhN8MwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMDE1MTYyNzQ0WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAeXhK8pMHe3m4xFz9F+eBfE9eqbzsHNlQDQ/Klq2sKbmEXOcq6lm7
ocMWIb9HmtZtOwr3oyYQc2MZ0ilen3rMbvg8DkMtYyNdc+Fm4SaPaWVi6S+5MnPie99QXnvM2Rst
BxoBCePpJf0F2fFF3i4vxvWU9ZFaELb3+ZoexS4HPiovoOazDB9Nr0iw3mwZ/B2WOtqnPvNK33us
8d1U2yCUlu9WCQHd3qgVUBv4R8XaaTLl2t4c8MtiS7OXa4zU2lKcsZPXRvxVTxIgL9UwnYyjvwml
MiyNxfN27TOevPMGW/b6yJbS3yWGLTynM6H49w9AcSkEmUzvShahaZ/vo4uvqw==
--000000000000077a6f065de387ab--
