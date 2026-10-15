Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30E2559CBE
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792079916; cv=none; b=TRp6/O9ex8AYTbEDE+9n+wIgcUnP03AoxuiJ1JeeAFnV1Kch+XHZdSmygwlJ2vmLmgww0BA4lmFLfvv3yUjoqyCsR+RymqG6MQs/7tqmCuJGrB857dLcvyj2vhc/uBEfwWxAnFUmXyoHeLMPXco8g4Y2WSjxwX3bXyWQpgz7wUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792079916; c=relaxed/simple;
	bh=PJVnddkinLLgW0OZhelW4VVJ+tJM8Ktu/3hS2vu+Uhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DYPR4aOBtkidu74IN6DuqRf5bwpNd/OQwAMiAlQsBSUmd59BeZ+zKD98fNM17fy9zlX6rPiU4urzm60d/h2GBWt/ldOxWLKPM1vRD0IAU4cIcokChwUYTakQZXlGsQaKgxcoXXDRBLre5ZfYq+tl7rpjupRkOo0zbLfL7qECRZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=MKk506lJ; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="MKk506lJ"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc4ca696de6so3075465a12.2
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792079895; x=1792684695;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PJVnddkinLLgW0OZhelW4VVJ+tJM8Ktu/3hS2vu+Uhs=;
        b=uQ602Vdr/0aZcMGE69sIRmifEEf1pHwSmaJFH+fNLEkPhHAjrlzFyBMMQgK/hqYDvt
         tm+XwsRRwbTf5Q2IgpDg7emres4GhPpxUZxL8DVO1J+OsGEmiDUbvAL1gm/T4gC8Qcz7
         zrELymhcfEEmkG2PN7r01i7JjhagmfxaAuzIqp8gl4PHbKrwdmlkzQbaxTFH7Yw0Hhex
         0x80iP7Vd9qtcNeFhBoFlRm2U9Rd5f9EanlnRNOm5rGWHCRlMxbDLxzqSBfdtYt4sPbI
         oqc5wkuGiqIpLbNF0TLbY94enFaSOuXqjKvonoDlRr04gZPgB9CeqdntFAk1489+1HMr
         w6rg==
X-Gm-Message-State: AFq9FYJukl/Mp6EkX197WcGb2Vy70RR92ePmILok/RGrInYdYmUVQsBS
	0aOKtmMwid4nFjz4RH1/q8cpcxaECrBZ53lh7ZDHsaujXL9qAvVplBLjXUfPRr62+9Q8uG6fn7o
	d089LqolqtmWQ2ra0NkaYi++enX6tboKNf6J76efMQi5JaNboiVOPZwUCy1OdrY9RsNEX+iQ9jW
	od3ww0A45YIYsuIZkWxstE1fEBN+pYVUr0U7zNDIMzkXW+6S44jLEbPaHM/l1UwHV9Rbple0DeM
	xz9NXXbZ9LdAg==
X-Gm-Gg: AYBFou113aC6bPZ/B6ysW3mM+ZGVFgaWDmLDLxcfc8Aj49AcYpokjM0+41wIxq3yVS/
	foiAznjtJVNVFeMGqjvvSD2Z6tz8GbtkSlAy7QDnnM2srEF8o0cCBqj0Qm/CLh+ohbnMi678mKD
	sZRm8PjW05c7xSbRaqAKvrRTMFQdsGUMRyqYwa1BI4Uk9hnFdKWFbtQR74usbLyiPzMKXHXqzdb
	veyLBPEWYg7c0zHVD9BFlSM6G/URQaIxk/WE328mNjZBog/iVwNU0i5Qj1+TRsPF1+OXJQ0bnPZ
	ZDYd+Ond+OUA/c0IXqEI6lnogcdT7PJTLXpztNMzeEzqqnqRPU1gNVgTdR0Vb4GWjfRcUoCAIcR
	igurVogNMIimV5shv7y0xK0qJP6dBa/ZsyIKiOVMQER5MeAKW/b/e9t6t1T/wRmVF4RtYXsab/L
	JhVjhTWUZoyzrjc/PGsQ04msuHMdHSVIOSkY4=
X-Received: by 2002:a17:90b:3b82:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3ab3a94f426mr18526189a91.24.1792079894433;
        Thu, 15 Oct 2026 08:58:14 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ac9404baf9sm1905300a91.0.2026.10.15.08.58.13
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 08:58:14 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c2e6affec80so583090366b.2
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 08:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792079892; x=1792684692; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PJVnddkinLLgW0OZhelW4VVJ+tJM8Ktu/3hS2vu+Uhs=;
        b=MKk506lJz9/zYtpoGBM95OZlZEDUOug8rkQtU6/OaRnGEl5BRLvS3U2WHIUe9bFlj1
         ePmxJPM96d8tj9CmjphJB+2z9im73khkmleQycy1C54FL3rxqZAs9Oxn6+d+i5F9caPa
         cf+NFoKeOvAJ0w1vFOl4BL03x6MQrNCiaxFgk=
X-Received: by 2002:a05:6402:2b92:b0:6b1:ef16:1850 with SMTP id 4fb4d7f45d1cf-6b1ef161c44mr7454545a12.43.1792079892418;
        Thu, 15 Oct 2026 08:58:12 -0700 (PDT)
X-Received: by 2002:a05:6402:2b92:b0:6b1:ef16:1850 with SMTP id
 4fb4d7f45d1cf-6b1ef161c44mr7454529a12.43.1792079891854; Thu, 15 Oct 2026
 08:58:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-2-a0e626117113@broadcom.com> <sashiko-outbox-171976@kernel.org>
In-Reply-To: <sashiko-outbox-171976@kernel.org>
From: Eric Davis <eric.davis@broadcom.com>
Date: Thu, 15 Oct 2026 08:57:44 -0700
X-Gm-Features: AclHuK-lpP_Mcqyy76vJBYumgCFGGa8Kt7HDAmx9AtzR_Dexgy0wPSrFOkAHsOI
Message-ID: <CAMouMY+nCYZ1V_-0La4phKNkvYBke7Njhsr+HRwWkAfahgf3pg@mail.gmail.com>
Subject: Re: [PATCH rdma-next 02/13] RDMA/core: add the UET GID types
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000006b84fd065de31df0"

--0000000000006b84fd065de31df0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 3:35=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> Sashiko AI review found 3 potential issue(s) to consider:

Disagree with all three and no change planned. None of these paths runs on
a UET port.

A UET port's core_cap_flags are RDMA_CORE_CAP_PROT_UET_[UDP|IP] plus
RDMA_CORE_CAP_ETH_AH. It has no IB_MAD, IB_CM, IB_SA or IB_MCAST bit.

> Does this explicitly fail Address Handle initialization for UET-only port=
s?

Yes, deliberately. ib_init_ah_attr_from_wc() is called by the MAD agent,
the CM, mad_rmpp, and user_mad. These all need IB_MAD, so none of them
sees a completion from a UET-only port. The check is a guard as an
unconnected peer is named through an extended address handle (patch 5) or
the job's address table (patch 7), never from a WC.

> Could this cause incoming UET packets to be incorrectly mapped to a RoCEv=
2
> GID index, breaking the UET transport response?

On a port that runs both RoCE and UET the MAD traffic is RoCE, so mapping
it to RoCEv2 is correct.

> In sa_conv_gid_to_pathrec_type() in include/rdma/ib_sa.h, there are no
> cases for the new UET GID types
[...]
> In cma_ib_acquire_dev(), UET-only ports fail the RoCE check and fall
> into the else block intended for InfiniBand

cma_supported() only takes a device that has an IB_CM or IW_CM port, so
rdma_cm never binds a UET-only port, and cma_ib_acquire_dev(),
rdma_resolve_route() and ib_init_ah_from_mcmember() are not reached. On
a dual-mode port, rdma_cm keeps using RoCE GIDs: this patch makes
cma_set_default_gid_type() refuse both UET types, so a UET GID never
reaches the SA path record code.

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-c=
ore-v1-0-a0e626117113@broadcom.com?part=3D2

Thanks,
- eric

--0000000000006b84fd065de31df0
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
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgZVLXUivT4zsPP6VA
RleLsIdIr3MyF5btueVcZlGD9WgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMDE1MTU1ODEyWjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAyv6oRZS8k7/FI26DgEgsZDs6RfvDKRhhmp0dnEVY3mLyeCqLjrn5
EuvVAOXdQ6SjFtiTIHxfn8Oh37UYS/yvwVWbT+P8baqoGIpIMG2bQPAJh1fkvpe8OiTWr2A1gXLz
n/9fCLk9xegrYKlLWIVK+Z+VH8t0E+4xuecKQAcNMeYvtuPHFBMMcMjejIGdVTUQC4N4kiPZzR53
bhXsU1aV7CYpcebLGWMj2ryVofkZ3rwYrZP/GKYocZp3aRPbIS7tpk+QTJdQqT+ASzz/9gZwXCrW
b285zzcpeMM2KOwAeavgkXMn7b5SVbtvczCOQlzxVG4C4BnlSQpS3faLOTrG5g==
--0000000000006b84fd065de31df0--
