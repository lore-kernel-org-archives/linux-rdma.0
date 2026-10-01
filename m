Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB87234F46D
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 05:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790832118; cv=none; b=LTh6QkHeK94tNl1r1IOkhkFr5KRINF1Kacn8D45Tft45MLOK86Fs5aTv190uZs4PRY3GFSZqcfJ5sT9NX46xkHRyEk/jz8Jn2/XsfG/5qxWMdu1SDKJDhnF12P88hAzktt/9lPhtbAfruRTTSV88hiEhY3peYP/wucmsiwtvmO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790832118; c=relaxed/simple;
	bh=pojgUQbTE28QdHMemP2K1mxz9AQ+GwbhMfKOL/hkwPk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QILvDTYdmeVThjnh5OGMQPQO4DLp0M6KUWcNbbQAYNx/WPheO2KQZjkDcX3QCgMVeClzur4ddAuggAiX4EG9UGbMn9kwfZrD6MU1i8vuKfJwN2N0rEt91j4btkt7LX5iDZZcIFivEuOTxjNSgNqS628c56xQemK4gVzk13zugy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UpWMBo0B; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UpWMBo0B"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so2110412a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 22:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790832116; x=1791436916;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DJBy4dZZAuwwDWzCEmpbRhY1bIoQpJrlA1wYBnPudso=;
        b=EHww42pnhpo1c3uto6HmLEufEzMirQSqiXuYliG+0xeCm7wpElAG7U8bMBylIIE/Ta
         cYCHGMulpoOdtYXOUFuJEXCinEzB9eDHzNqHRz5ru+om3QRhpapBilAu7r+sSm6K40fz
         oQqjG4AvEWMypH8Y3sf7yO+NakbAgobPB43OQlDCLg6zhbVzj7dmkJvbZKHEPsb9Zq2d
         8unRiNuERaDphoTg4sZQ+Dj1jYlk+clKu0Q6wPVogEGouhjuarAKhobGhRCoijAgfsH8
         kBfObhs1Ihd7E7LuhumquY21jw78aBZNCzl+N0ZfhFg+TJCvwKdKX5H7H/uIQ6B29Dev
         uEAw==
X-Forwarded-Encrypted: i=1; AKwUvByTp6jgacxvzpSEYsDVkYfmQ+RVzbeNCimE2sA1v5qZac1Zc02PjDdvyjDnstFtMKqU+Rcx7fsMvUg+@vger.kernel.org
X-Gm-Message-State: AFq9FYI30j7FxyODkh69ADRrBf0SRy0Gx5GqvhffHgVeDURw8mr9BfS0
	hiYdfpItKl2H6Uf1ZBGDDGyy469kAHGfF9bKBN8BM3jCR7uL8Mho0hIQ/jpM1SFsve6ty5v2r2b
	aRoIyJZA2TP/2lKesv4kV4Sl2Cs9tgvnFgkQAsFdIlkcY2b++v0v1xSxjmHbHZh+nTQKLWzsp4U
	jr7f5o8wynWfe1kqWABvH7JYZWLOvly2npApbGRRZErLB4JXrJHjt07DLkEACEewTIy62+DmfL9
	GavCO/7Fzizeis9UQ==
X-Gm-Gg: AYBFou1BychDKgZCELR7QE6selh4XPj8QYrNMBNUyXusXUftJKmFU6MhbyPi8gSnz2n
	D61FUppOgXOj5XlCUHVwTenIlJU2mFEqxiIxsvnxP53Ty3zsB65mmVaVvY44xJyw1PIQUkILtCl
	2Sk7YJS6T13BdaeJnzMPtTK9qEH/j7LoXSF1o5uFrS/jvDVSdLuRwyEhj0oY59xl+qDdcL9vqGx
	FQ1tg/VkoCoj+JZiGPLpwjbRSqYUnRCwNPwO4UUfXcZVnRcyp6rwCHhE8yRlAClWjJGq61KJpBo
	8ivpwCTYWxbyvrANe498OTENU4z148KHhCzrVwXfy/SMAA8Xw8ariXoyxeHuOi7e22ZGFSD2qBz
	qpsw3J/4r0VJod5uSb7HpJ/PDTOtM/6NLwIgK/5D9zYF9E6+dbzdmoEwRW4p/c6V9Ijcbo8uxZJ
	qKa1XM8Ik3Q1bye/Q+kHzUudSm7F/OUG/CyGi7eLM=
X-Received: by 2002:a17:90b:2f4c:b0:3a4:c673:763d with SMTP id 98e67ed59e1d1-3a4d1788696mr3078286a91.43.1790832115965;
        Wed, 30 Sep 2026 22:21:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a4f43c5865sm920191a91.2.2026.09.30.22.21.55
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Sep 2026 22:21:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-81fa41e424fso2401631a34.0
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 22:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790832114; x=1791436914; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DJBy4dZZAuwwDWzCEmpbRhY1bIoQpJrlA1wYBnPudso=;
        b=UpWMBo0BbrC6T1emMBHYu5q18SsoJMkSEeIanEQUXzmv1X2vtOf+MdwrkOae5pRljM
         9PnPmnKQntYjNY/lu+8ZgSElXcquHvnY4uKnHwmHdchapyTknvIkoHTivHtGCbpEgBY8
         5iQtRgO/v5mg78tNR1kjnvfDWdk2+T4avxV4o=
X-Forwarded-Encrypted: i=1; AKwUvBykSItlf9tJ0mnVpJvomwrtASGetNE1WqTd3mCY794s89mH9QfudJCBWaplY+/vhYWmBeUCqEfy6cG9@vger.kernel.org
X-Received: by 2002:a05:6820:201a:b0:6d8:5491:3752 with SMTP id 006d021491bc7-6dcf4e644e3mr4685743eaf.46.1790832114548;
        Wed, 30 Sep 2026 22:21:54 -0700 (PDT)
X-Received: by 2002:a05:6820:201a:b0:6d8:5491:3752 with SMTP id
 006d021491bc7-6dcf4e644e3mr4685728eaf.46.1790832114102; Wed, 30 Sep 2026
 22:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922061230.7909-1-selvin.xavier@broadcom.com> <20260929083651.GI563127@unreal>
In-Reply-To: <20260929083651.GI563127@unreal>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Thu, 1 Oct 2026 10:51:42 +0530
X-Gm-Features: AclHuK98sR16anKRdQgRaoKH69EUdf3D_8pCNnOZvXSAc05DB-8DgpdiwtfjzLc
Message-ID: <CA+sbYW1aMLV20zMQHUnZ2P8H6DS+-T6Fd4TxXsVUP_YV5YvQxA@mail.gmail.com>
Subject: Re: [PATCH for-rc v3 0/8] RDMA/bnxt_re: Fix input validation and
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
	kalesh-anakkur.purayil@broadcom.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000000e8d09065cc098df"

--0000000000000e8d09065cc098df
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 2:06=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Mon, Sep 21, 2026 at 11:12:22PM -0700, Selvin Xavier wrote:
> > This series fixes some of the bugs found while auditing bnxt_re's
> > handling of user-supplied values and some generic bug fixes
> >
> > Please review and apply the series.
> >
> > Thanks,
> > Selvin Xavier
> >
> >  v2 -> v3:
> >   - Drop the VM_MAYEXEC clearing patch from this series. Will work on a
> >     core level series which implements this in other drivers also
> >   - Dropped rdev lifetime race patch from v2 series as it is reporting
> >     few more review comments to be handled
> >   - New fix to serialize dcb_wq against async notifier
> >   - Removed is_in_used flags related patch to be posted as a separate r=
cfw
> >     series
> >  v1 -> v2:
> >    - Handle review comment about clearing VM_MAYEXEC vma flag
> >
> > Selvin Xavier (8):
> >   RDMA/bnxt_re: Fix integer overflow in send payload size computation
> >   RDMA/bnxt_re: Detect wrong sge_len passed for inline
> >   RDMA/bnxt_re: Validate SRQ max_sge at create time
> >   RDMA/bnxt_re: Initialize wqe.flags in bnxt_re_post_srq_recv()
> >   RDMA/bnxt_re: Serialize dcb_wq access against async notifier
> >   RDMA/bnxt_re: Fix the PD and DPI table size
> >   RDMA/bnxt_re: Use bnxt_ext_stats_supported for counter count selectio=
n
>
> I have applied all the patches above.
>
> >   RDMA/bnxt_re: Validate num_sge in bnxt_re_post_srq_recv()
>
> This needs some more work. It can be improved commit message, or code to
> make sashiko happy.
>
> Thanks
Sure. will repost it.

--0000000000000e8d09065cc098df
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
n0tGl/jOwfbNtE3xrXfaYwMUqq46KAT8Lqgd0pgN5hMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYxMDAxMDUyMTU0WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAlVanP1pRxpgmWC/YuyadjKkpudLObu8mxF1M
B0BOccVs/BAdZ2/DCzX0qYqrBSjjVlHDJH5sK6N2j9jUtSoowDbU+TfvzQH/RuzgTx9jrBLTuAaM
mqKRtYmrz+beShhMyVKOHWt91vhJDtY2iQN9zt6q36YznAZP42hq9ldq7FThOBgusVqexI28KWh9
2xCtSLqtev5Jqyn5g6aGJS1TnF0zXPYnZ7JmWf1MEckbdgrnh4Bzw1ORFwDWNUJ2ko2ayv8gfiDS
He9s/IH2tNCZ6MOU9+WXL8YJskZBrh7USbAnYbMVc+Rn4Ek3cBrycyy5g01S9SXPnBcq6rAxtY+O
Wg==
--0000000000000e8d09065cc098df--
