Received: from mail-ua1-f100.google.com (mail-ua1-f100.google.com [209.85.222.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C3A353A95
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 13:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727369; cv=none; b=KhIDKY46JfRQyfYnJ03jgdbac8XAPGX7o5NnGE14gOl8Uz2mV2Gn9pg7yJKVe20XzFgoDjvCyjfD6OrbBzjqJuP+EAMX0d5+1r9FBcBbVC6j+FocvMNfoST1ekAPFie9QQw9wqWtJ4oHoDeMfokRi2mWm8BlgbXuB/M1Mythw8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727369; c=relaxed/simple;
	bh=W6gmqs8i8rsVEw1KaF8GhAAo4GrgxIMLpC6QkVnHZrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BDkalpW0gVDGMVSoB3vqKrE2/x1FhTnPl8fOwQS9uzgEiKtZQuqGy57v0JmHnwsTaORypz5UirgDSzpXyjk1JdkZ2+GMRtSGNmMigL8eyQkQkPGumCXCaWnygeClYaDoJKVEo/HYQYmdZ+IbR8mfsElR94Z0hkNx2qsUr0U+f+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cFp2EFdb; arc=none smtp.client-ip=209.85.222.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cFp2EFdb"
Received: by mail-ua1-f100.google.com with SMTP id a1e0cc1a2514c-969524c1a63so4378953241.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 06:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784727366; x=1785332166;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mOVfFR7M4lyYk0KLUvszUf0FpYCdWFRgF4Gyo/r27B4=;
        b=PZmRFn0bH/M2gg/lopza3eRVJo/xTSRfXFZSdK6KsK5dtGY42svNYH0rfa2jnaylRI
         P0vBCV6y0Uiau1QGExnzCbnDiNZgjC1+rigsYDV8pwrEw57O69N5NYz1T+ZF0Nf9iFfU
         3IkP3StMTPR+16+4k6gMw9GZVdeQhGxfJGrqPu6krAtt1Zq2UbCsAZ3MeHzGXPHHEXKX
         SWkCyYlfEWEp5Lrh4Y9kEJi9Qhz8IO7sqqkGHg8B18RVLfZWItyldcv23VCiBmGmvnTU
         1RcJUyt+uGfcpVIpaIoqTgU9v7CL77i0u1eExwnlqvGmHPIrwopmlQKWJWGa8kqg4nkB
         iWfA==
X-Forwarded-Encrypted: i=1; AHgh+RoAgTdxyGvxDsXsWlFic1VyKEqnuFTftEIemY926g4IEOSQ4CIDk+7i50Nf8PY/czJOasFid6oTlA5j@vger.kernel.org
X-Gm-Message-State: AOJu0YzE7ndg8+/pBxSuOGHk8kT8WjUpnQcOCbVKc9YbWyDcHJY6WypG
	OZlt15/M7k3FCAl0Xtxp9Kw74nyKVLSqbFQslz4TOC8LwFlho8wn1xtv+rIUQH56qhW5KupD9LW
	d93EbV3KQbiaPT3LL+QF9Xxk68V8SACL4hnf+RqNLBgyi9pSqfzUjSvOB3vaJp0+G+la0mlrtRA
	Z7+pPH7J8JWBlSg6GdYOZPAuVmF69eXQkE86iT7KT5dUW9yASeERxp2AmnqWsaD5Whi8K+2vT2J
	l2gY1sotmr2o9DPIQ==
X-Gm-Gg: AR+sD1365jDgzZVztRJo6v9b/WO4/C635Is7AUTqGaxcKPwObBHHxb3eMWArSo+fBAv
	B0dRqzbBkSZZEZLPkMsCgN9vUbIbR4VaCN6YXD7r5QcCIK+J0DES0CcejA67eBsSqCxs4MI6Uxx
	SM/e1zD996ipREhWJkvC1D/VX8rwAHRki4vlPsWIkKmK7IocWb6kpLxLC0xO9qI9z4QiRQHgXsQ
	yQi7Mnz8Mdkn7OOrwc5iOrGht4OO/bAmxUPGLLCJubpRoLg87nL/5ju+p71TX3K0lZz1ahPzJuc
	/fpHqWm4qdu8sMDGVwXkdWUS9QQZNqV7cKpHeXfg+uUKQmyL9gUHM8+Eu4is8oHp/0eboa4i6am
	jWsomNlWW/NeClWjcCd1s0jwkxcz1nPS0t1rVOkXVaq+eOl+iKOXVAS5v2pOalAmTxV7iTJWPdp
	J3uwuhHpWlT4sEwLqcuv2eERLNNwsCvxk1+phn
X-Received: by 2002:a05:6102:5e83:b0:722:826e:1423 with SMTP id ada2fe7eead31-747536fa410mr8196930137.20.1784727366144;
        Wed, 22 Jul 2026 06:36:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-74ad31dd797sm243935137.6.2026.07.22.06.36.05
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2026 06:36:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8f000e221d7so190430026d6.0
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 06:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784727365; x=1785332165; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mOVfFR7M4lyYk0KLUvszUf0FpYCdWFRgF4Gyo/r27B4=;
        b=cFp2EFdbsw2JM2EkH/8h3Ae6uLL5/uzQW+8ORnoM1S45A2De/yd8kOfWe925QF4iaH
         TctxRoOS3Rf8LcL7Iu0LaNv2ptfP7MN3rZUKS6A5yXHvPXb5nZZrJR+s0wc4Ni4u7Ry2
         mVOFOlksrUOL5NEu0jm26knZAr2IEYcVy73o8=
X-Forwarded-Encrypted: i=1; AHgh+Rp9dinyvcIbiYyK6i6vSXmvGFSOrDaTaC8EISZky35dCa29HVE3VPLocLwl0jZpiBRBe1FLt7Vh5lXN@vger.kernel.org
X-Received: by 2002:a05:6214:8388:10b0:907:83cb:4204 with SMTP id 6a1803df08f44-90783cb695dmr155923486d6.14.1784727365331;
        Wed, 22 Jul 2026 06:36:05 -0700 (PDT)
X-Received: by 2002:a05:6214:8388:10b0:907:83cb:4204 with SMTP id
 6a1803df08f44-90783cb695dmr155923056d6.14.1784727364825; Wed, 22 Jul 2026
 06:36:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260722-missing-vma-write-protection-enforce-v1-1-567cd8499e23@nvidia.com>
In-Reply-To: <20260722-missing-vma-write-protection-enforce-v1-1-567cd8499e23@nvidia.com>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Wed, 22 Jul 2026 19:05:52 +0530
X-Gm-Features: AUfX_mwA2V2aFgCkuE33IzRa3QCNWxhqzH9TRZ99_FlUW10_Qy6zR_-8dZyng4U
Message-ID: <CA+sbYW0i0YQZO4wQRGXS9LEVGMmRtEhuAJYOZems2KmfCUfUCQ@mail.gmail.com>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Clear VM_MAYWRITE on read-only
 mmap of driver pages
To: Leon Romanovsky <leon@kernel.org>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Chandramohan Akula <chandramohan.akula@broadcom.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000a8589c06573338f6"

--000000000000a8589c06573338f6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 6:26=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> bnxt_re_mmap() rejects an initially writable mapping of the DBR pacing pa=
ge
> and the toggle page, but leaves VM_MAYWRITE set on the accepted read-only
> mapping. A later mprotect(PROT_READ | PROT_WRITE) therefore passes the mm
> permission check and upgrades the inserted PTEs, letting userspace write
> these driver-owned pages: the DBR pacing parameters maintained under
> rdev->pacing.dbq_lock, and the CQ/SRQ toggle state written from the NQ
> tasklet.
>
> Clear VM_MAYWRITE before vm_insert_page() so the mapping can never be mad=
e
> writable, making any such mprotect() fail with -EACCES while the read-onl=
y
> mapping continues to work.
>
> Fixes: ea222485788208 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniban=
d/hw/bnxt_re/ib_verbs.c
> index adc693736769..dcfb1b0ebc22 100644
> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> @@ -4984,12 +4984,15 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, str=
uct vm_area_struct *vma)
>                 break;
>         case BNXT_RE_MMAP_DBR_PAGE:
>         case BNXT_RE_MMAP_TOGGLE_PAGE:
> -               /* Driver doesn't expect write access for user space */
> -               if (vma->vm_flags & VM_WRITE)
> +               /* Reject writable mappings and prevent mprotect() upgrad=
es. */
> +               if (vma->vm_flags & VM_WRITE) {
>                         ret =3D -EFAULT;
> -               else
> -                       ret =3D vm_insert_page(vma, vma->vm_start,
> -                                            virt_to_page((void *)bnxt_en=
try->mem_offset));
> +                       break;
> +               }
> +
> +               vm_flags_clear(vma, VM_MAYWRITE);
> +               ret =3D vm_insert_page(vma, vma->vm_start,
> +                                    virt_to_page((void *)bnxt_entry->mem=
_offset));
Same change was done as part of my series which cleaned up the toggle
page for CQ/SRQ.
https://lore.kernel.org/linux-rdma/20260721115440.24021-5-selvin.xavier@bro=
adcom.com/
Do you want to take this and abandon my patch? I am okay with that. I
can rebase my series
once this gets merged.

Thanks,
Selvin

>                 break;
>         default:
>                 ret =3D -EINVAL;
>
> ---
> base-commit: 0e8e94c15091041ea8910cbfcade5a9c7cfe3f90
> change-id: 20260722-missing-vma-write-protection-enforce-2e99624c35dc
>
> Best regards,
> --
> Leon Romanovsky <leonro@nvidia.com>
>

--000000000000a8589c06573338f6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
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
LW2WhBiqdXUg1/ik9ZMgU51p+kMo0QbK+gzmOIWyNg0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwNzIyMTMzNjA1WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAAK+PRwXONhxNQl/Pros4XCa+LrPt6vEZNTHP
7MZt10dxwoeGdqDErOxtOOTUqsJzAxKeXxp7s8wIbQytXsRpSrLHI67p1c9oMPL3ejqzHt7O/3b2
6+Y1EFsKSmvoLD5AfAPzRYkdnD7qErxqrOWhXo9U2HVI6lG6Sk2oZWI6zNMOrK813EEevCB4A+Xn
S72Dl8Np/SSmPjg0xTaOftninkmaaKIkxQLcKCWNfStg7xWNMAynlJAI4OmCynU8s9Na42FUZeGk
2QELovJiOlpBKGmKzDy5OaSI2QMa2oYmK4qcKpB2qVfIXnzW8sLQlCjAlvyERUwhZDMf+GI+qz69
0A==
--000000000000a8589c06573338f6--
