Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792720849;
	b=XtFKE1vBE8h3XMkr8wTty1PD2X96aQUUFdM9EOh9Mxa6fEv3aAzsS/L5BueYqahRr2Cp
	 Ps4sxsMoR+FDYbakoi2eayEU4wBo8zlr199LgMd27RBS1tNFwVtn7qqzChZlZWyY+kAO0
	 9QAzKSlIsKWCeJjW1jRVy4xQ+xisdlp3m1O6nvpqfS8jLMb4rpVjM2NnCWyO5/lQCUnVc
	 aCzoe07mVWugZXTfomLvYUy672FCwXo67BLacWOVLJ6Go/nqTdB/iZz1K4/0fxG1Gm/2Y
	 08MNMEd/m0hgC+OHhkKJdZUZFl1YH9fFA6qy5OBQ6xeL8ku+0Qaq6bWR3J15fDLEX2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792720849;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 X-DetectorID-Processed:Content-Type;
	bh=uZoCYHAN3w97tS0aaeyh2ldYsCerk63zCgDji17Gyqs=;
	b=44aniCz6v+A7QdW+GvWcmYecY7Ci621c4ch5WL5oDfB3DZcsIrfkKYvW68/y2133yAle
	 rfzoK4UPJv8Mo5ePA4N6iKFQUwdEx/5ihsgvuLjar5ZH+r6Q9x3RQ59CUyRzPADfyxKbe
	 gqiCjd/qaBf70ragQaZPIKcSlkCNgHiYyqszcmmeQFhVMjYQ9X+4yL0ZUR/Wc0E+jgkP1
	 A/v2AIIzsLO54s8E0j1SZb1Q9ZEnHfPVeSYiGI1DT0+G1SAJRMjPm6OFMIkV3rqYEUzSR
	 fbscRQ7g2T3cVCbODmMQFyoqvtQMPeoz3t8xOdQSN0PtLVHNJ4m5iebYYfQcWfpRRJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ezmhofpY;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A94606A324
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 02:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85A94606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ezmhofpY
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ab41538192so299302a91.0
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 19:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720848; x=1793325648;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uZoCYHAN3w97tS0aaeyh2ldYsCerk63zCgDji17Gyqs=;
        b=NynMmpihngBHhwx8GshTPyJJOeewfk3Zh8WZf6ED8lmHK+b7rP6+ngmCYEFXjA58M7
         chSZzG3l9k+ACnQ5mj7QPm3p2cG7Y3dZtUdFmv4heo+4jJttKafZsWuTg9Ct/TUjvmTo
         62mXhbhLlGIWhBIprV8YFpF6STHtns8eduI+pr2AGW+5Mv3KOi850ftkBKGIrv9RYqkq
         Emcb7/5bQDFYXOYzCSHn0qundqSbDLnHqgUWAmApFjWwoTcOISq0djeegHLqCsAt+b5D
         VfBMbDdfXVxILN+pzXPQp+mW/v9wjexICyAPOvk/3r+4b3VE5YkpXFuY6xeLuMnlMfPg
         4EJw==
X-Gm-Message-State: AFq9FYJC2HgQDZR32uAWBTwBIy/nHY9Hokt3fdcjEUKul5wMC42/vIRd
	TcPCc1sizQC3NbaKKXce0cQH9OAvUOLLF5brTU/mmBlza23mBkjtFQnzLKJkLChnxVlQxCxKKwB
	bmNqgWiIslXOhk2Pj5MQK7vtHHWv6yK3hQabhH7uAJAQQkvvBea8RfU1hghk/E9aCu6B7tbJ2Ou
	mQ9evv4mHNUodK8bfsjdRAP3I/X8boJehVyTO7JFrkDq2oWwSeCbO8XRMBVPJ+tpetF+MYqfIZR
	DGr/UoUmD5q2w==
X-Gm-Gg: AYBFou2bJk/GTZQNT1G7GGzhwU5hFqIM+lo7k2LA/8ktO1NiprZue7V5vYM4iNPA4oy
	8gHQ9NuMn1KaqUOrJeoUAl+9XtadV3QC2I0q8YC/EIPGoCkNQG+rvN30j0AB0WsRT3q26lDRIcE
	haMWQvwFWNj5A54XNwoEPyerGsjK93hiXO683KUWWJdwDMPrv5ohaAr23/AODWEwISPMJTl7o0k
	yUf56kWt2Y0NVM5KAjErhRns2iSc2xYX+CELcxYCDf45zzgj8nG5yNNagB+nbqOtUrPeAAAhO5m
	hCk/rvxnwJGxuKwL8Icl2P0yVz9BTKS5FkOl9EYJal+j7N2VSraVXVqnzlVmstQRntyPQSSU8Zj
	3wnbDaK5cpPN/kfwI8RcGwk+E6mAP1LrJxGSh3Ip7W6sfzN78VwMPQXZCRGmsiZ52hNLb70vZfS
	sUVwtT/e6iKTGvH1feA3UfKzCNRaHT4jYBQsM=
X-Received: by 2002:a17:90b:5863:b0:3ac:9f24:44df with SMTP id 98e67ed59e1d1-3adcdc89a0amr631928a91.2.1792720847612;
        Thu, 22 Oct 2026 19:00:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3adcb1c92fdsm738305a91.6.2026.10.22.19.00.47
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2026 19:00:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c42f98f351eso45920466b.0
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 19:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792720845; x=1793325645; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uZoCYHAN3w97tS0aaeyh2ldYsCerk63zCgDji17Gyqs=;
        b=ezmhofpYgEDaii+pZLacbxMm+sdBxOtPCHPFUbLBL/GILgsAMwziID83yKui4Na4UG
         LnXQE8Tj0BfffzhyEaaqCcfgineslLoIFkT0LaYlE94RJSrm81I6GbFYlkitei72uOb3
         vMLbpQjoa5v9WIrf6e31Hh5p0mQkhLRvSwGhQ=
X-Received: by 2002:a17:907:e849:b0:c31:b89b:213b with SMTP id a640c23a62f3a-c46a900e861mr145167766b.18.1792720845475;
        Thu, 22 Oct 2026 19:00:45 -0700 (PDT)
X-Received: by 2002:a17:907:e849:b0:c31:b89b:213b with SMTP id
 a640c23a62f3a-c46a900e861mr145165066b.18.1792720844926; Thu, 22 Oct 2026
 19:00:44 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-13-8bd654f25370@broadcom.com> <sashiko-outbox-178828@kernel.org>
In-Reply-To: <sashiko-outbox-178828@kernel.org>
From: Eric Davis <eric.davis@broadcom.com>
Date: Thu, 22 Oct 2026 19:00:17 -0700
X-Gm-Features: AclHuK9fznijRHes4Zh9iwpBLWhIkHKYzo9AQrVm3xUgoviC6U7EHKyLOM83TkY
Message-ID: <CAMouMY+J=pi6bGtRfHqwrHyFm70E5zvC27mhC4WW-bifa56iFQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next v2 13/13] RDMA/core: attach a memory region to a
 queue pair
To: sashiko-reviews@lists.linux.dev, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000315072065e785949"

--000000000000315072065e785949
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 3:21=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
> Can this sequence in ib_destroy_qp_user() cause a use-after-free write to
> mr->attached_qp or a race on mr->usecnt?

The first part is real and will be fixed in v3. A relaxed atomic_dec() can
become visible before the store to mr->attached_qp, and a concurrent
uverbs_free_mr() can then free the region under it.

> Should mr->usecnt be decremented before clearing mr->attached_qp

No, that opens the same window from the other side. Once usecnt is
zero, uverbs_free_mr() can free the region before mr->attached_qp is
cleared. v3 will keep the order and make the decrement a release, with
smp_mb__before_atomic(), so the cleared pointer is visible before the
count can read zero. uverbs_free_mr() frees only after it reads usecnt,
so that side is ordered by the control dependency.

> Once mr->attached_qp is cleared to NULL, another thread can attach
> and detach the MR on a second QP [...] and then call uverbs_free_mr()
> or ib_uverbs_rereg_mr() before the first thread runs
> atomic_dec(&mr->usecnt)

This cannot happen. Attach and detach take the MR handle with
UVERBS_ACCESS_READ, and destroy and rereg need it exclusively, so
neither can run while a detach is between clearing the pointer and
dropping the count. A concurrent destroy gets -EBUSY from the uobject
lock.

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-c=
ore-v2-0-8bd654f25370@broadcom.com?part=3D13

Thanks,
- eric

--000000000000315072065e785949
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
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgEflJHMb1VId9HhxT
FGu9j/sackU1obwuzA0BiwaLhg4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMDIzMDIwMDQ1WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAxu8xJL2rBvZ1XKyY5IaeNnn7TfOXWc4HfuZMB7K3/G85+F0BlXoP
pvI4NzK3BmcimEksi5sYxVUA/6bYD7YOHKyjiZYEdUBIq+RTcnJyw6beNqzIFhQw5pn4IMV6HDAs
NqR4gUXvknhIGHpsDg8CmJhVs/ExQIq3/8WV9b3MQrycDQ3UgbTKBqe8hgT4UkqUzxwwofe4KJdx
IbySyca8MiSJL3T6fEC8pegsQgeSMsH6Lma+hDQICHBfq/SHWvPAZmTNN/7lAgunA+wstXv13yv2
SjKB/He304ZgXQgLGHOczHeSB8QGIY5tLI3k8sbcjrQhQgzrUprcrdCGYl+xGQ==
--000000000000315072065e785949--
