Received: from mail-vs1-f102.google.com (mail-vs1-f102.google.com [209.85.217.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3D13B0AF5
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191972; cv=none; b=XGfx7MNA2H0qw6MKsfUacUz8FcXXeurOBMrteNxoCi9f8Mk26k3+WH6xTGAqluh2DUuup/1Fr9dEOseQ93UugpWT0Xv7KEvUXQeXmED/PHAE6MDXyR8/EMlqnAjOYF0jX72W/2DGQfSdVhXt0IIXrlMvAaoYbpJA9Gd1ith7444=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191972; c=relaxed/simple;
	bh=YBfSQrsHanj55qP/LI0ee8uE94CoE4yYz4PoQbCcrMA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LuWussF9jaP5kuO7SBgW0AEJPos852qc1DwjkK6nYUX2kovhVzvcMlEjFBpnRB312C3/cGuYa2Msm2MFN9iVldgfkmZWoZjo2KVb+oux3tTYwnAXSmGXYO1TZZOsXI8EfTZ79aPSrGG7jHs28mB9I0U2rk0lmdb9c4xDzdrYWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NCN3noCQ; arc=none smtp.client-ip=209.85.217.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NCN3noCQ"
Received: by mail-vs1-f102.google.com with SMTP id ada2fe7eead31-726840fb461so1398575137.0
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 01:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784191968; x=1784796768;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jc8mw3EqnoWydlxKptJbJcRU3c/fKvlPkUzV7fFetTE=;
        b=em1L0lnfiaTaUyjTbgtF4Wmkk9guhTCXqBqFhVdcKedFtceD9zEkndnoZMxiXo5Law
         ITGOtvmJbIuar4qe2CyVguu4e8ITAmUTvtDpDQQoXkQ7qHOfNIdpAvGpplhahEXD25d8
         oUjAqQLfoB+9pjO3BuwrA8OUZH0fnEjczmjFBcMKzSdPh5KLeNt96s+fmfleSq+SMIia
         OSib/r4z95lGw50NPbDK18Hnym9ST3j9kwPmBpY0eRIglzvuDcsBbSDbLwVCZlBqPmNk
         8wex1dt2FJXjfaixNWNtVCA0NINxkjSlFkldk9ST74v+Zi0fPOGWb5GZRoVhfKXoyeg1
         nSpg==
X-Forwarded-Encrypted: i=1; AHgh+Rogh+vPz2vSocsGbtgzKLRNXyfu2ljbbkB1tr7W5GPL5lLouhKiOHjoMKeEBk20GP6T0qcdkCoG1j6x@vger.kernel.org
X-Gm-Message-State: AOJu0YylrErwag9ZEUo7q6L1u6Wi34oOVxX4iLGKwl9MA4P16w4/yd6L
	M/qESwFTXF00QTqDcHdt5ep333YTpl+O08WR3PRosomGU9Z7ExfHMmuO7LY77TjvrNVx9k+ETCX
	bZPATPX1H90hzZrwZjrNZEoa/1EQt5qGQjjjHK2Ht+ay44YnQ4KFnwtIFqh/eut1b0CsV7uel0V
	l2cQvKWKTagRdFUnQckg103OCkI6YcTsmTo/3tu3zgT1t9DWWK5pX6h2gBxbXGLX9xWSmUsPu78
	mnz15PRHY9sVJlfV9Q8
X-Gm-Gg: AfdE7cmBy1P+zhHvO5T8d/KYtLrtyTG6+BqsM6VqTHvQuyUtarYNCgh3nItSvN1tWoj
	Ny4Yz9fXafkossbt2k1nQym66fz493ydu3GTBdYQGfI6tJt+Hd6PEHD/0KiaUNQ3ssj1uzGUcks
	NcxpWtqO0KyOmjjLXRsN9Uv2A6jaks2gI2TCVWPu7fr5vvvAmuCwIPi+6dLA6QB6C+YaMamnqNM
	yysaf72USLw2QL1HgiMLjYvaSlZJwydKqMahZg8oRIdOKLsdtpJdM2em7ClSL16EARN+unJfomq
	V8m1WJefAbFE6PF3uH+cbAes0fbQNSzT4YY0vcPpKYc5MF91Hc+bxWofgtrZmhSp2P6o0J3+Cee
	pC6S/lchL942obqF/G9FAE//o3KwgJlqU/qYqU+HcIGykdd91Jc6fjG7lYa5lDatUN0qIiIcpUQ
	a8Od2/NYFj27kdkElFOuwneEo83MGF8VJUuftP7ic=
X-Received: by 2002:a05:6102:5691:b0:736:7e78:cf7f with SMTP id ada2fe7eead31-7457ea123aamr5613396137.25.1784191967933;
        Thu, 16 Jul 2026 01:52:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-74507010231sm1594165137.8.2026.07.16.01.52.47
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2026 01:52:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a3c96e87c9so815239eaf.0
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 01:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784191967; x=1784796767; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jc8mw3EqnoWydlxKptJbJcRU3c/fKvlPkUzV7fFetTE=;
        b=NCN3noCQn4iEw0M7D03WHJ//soJpQXmnI2jDRwKYvKvgggcHQ6daIhHtwoZL5FblBL
         S3xq3WZbcWQjM2ziIpnQRF3eX2DxNjN7WOn4ickoBkX1MJBAaIxs6KxJBJnp/PTbu/bh
         4AtHBEn7OKeBHAajveSd7rJ3h+Mxtu07hg/TU=
X-Forwarded-Encrypted: i=1; AHgh+RphFAa2BkEYlqng9eZZhYozdhUNTBEEB/7R+FUML66GelV20lbye93Cjx33RMB2Ms9PPigWqpaIiny4@vger.kernel.org
X-Received: by 2002:a05:6820:4dc7:b0:6a3:1e40:6332 with SMTP id 006d021491bc7-6a3c620b79fmr7373278eaf.59.1784191966892;
        Thu, 16 Jul 2026 01:52:46 -0700 (PDT)
X-Received: by 2002:a05:6820:4dc7:b0:6a3:1e40:6332 with SMTP id
 006d021491bc7-6a3c620b79fmr7373251eaf.59.1784191966419; Thu, 16 Jul 2026
 01:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713135830.1934471-1-selvin.xavier@broadcom.com>
 <20260713135830.1934471-2-selvin.xavier@broadcom.com> <20260714121944.GC19233@unreal>
In-Reply-To: <20260714121944.GC19233@unreal>
From: Selvin Xavier <selvin.xavier@broadcom.com>
Date: Thu, 16 Jul 2026 14:22:34 +0530
X-Gm-Features: AUfX_mz15UVBYvxJfAJbhXYoac0wehCLVO_Ys-NAvkKZTp0sKgDUy8ebAVYdrtY
Message-ID: <CA+sbYW2N_uGeHuqdh1Ca+cNED1huqeVbf3QNTx1dQpUv8Zi7uA@mail.gmail.com>
Subject: Re: [PATCH for-next v3 1/4] RDMA/bnxt_re: Replace per-device hash
 tables with per-context XArrays
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
	kalesh-anakkur.purayil@broadcom.com, sriharsha.basavapatna@broadcom.com, 
	alhouseenyousef@gmail.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000006be8680656b69058"

--0000000000006be8680656b69058
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 5:49=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Mon, Jul 13, 2026 at 06:58:27AM -0700, Selvin Xavier wrote:
> > The CQ and SRQ hash tables (cq_hash, srq_hash) on struct bnxt_re_dev
> > were used exclusively to look up a toggle-page pointer from a
> > user-space-supplied hardware queue ID in the GET_TOGGLE_MEM
> > ioctl handler. This approach has couple of problems. First,
> > because the tables are per-device, any user can look up another
> > user's CQ or SRQ by guessing the hardware queue ID. Second,
> > concurrent add and remove operations on the hash table are not
> > protected by any lock, leaving a race window.
> >
> > The correct fix is to retrieve the CQ and SRQ objects via the uverbs
> > object handle, which gives built-in ownership verification and referenc=
e
> > pinning for the duration of the ioctl. That is added in the next patch =
of
> > this series.
> >
> > To maintain backward compatibility with older rdma-core versions that
> > do not send a uverbs object handle, the driver must continue to support
> > the existing TYPE + RES_ID lookup path. This patch replaces the per-dev=
ice
> > hash tables with per-ucontext XArrays (cq_xa and srq_xa on struct
> > bnxt_re_ucontext), which narrows the lookup scope to the calling contex=
t,
> > eliminating the cross-user visibility. Also adds Xarray locking mechani=
sm
> > for synchronization.
> >
> > The GET_TOGGLE_MEM ioctl handler is updated to call xa_load()
> > in place of the now-removed bnxt_re_search_for_cq()/
> > bnxt_re_search_for_srq() helpers. No ABI changes are required.
> >
> > Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> > ---
> >  drivers/infiniband/hw/bnxt_re/bnxt_re.h  |  5 --
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 76 ++++++++++++++++++------
> >  drivers/infiniband/hw/bnxt_re/ib_verbs.h |  6 +-
> >  drivers/infiniband/hw/bnxt_re/main.c     |  4 --
> >  drivers/infiniband/hw/bnxt_re/uapi.c     | 75 ++++++++---------------
> >  5 files changed, 87 insertions(+), 79 deletions(-)
>
> <...>
>
> > +             if (uctx) {
> > +                     xa_lock(&uctx->srq_xa);
> > +                     __xa_erase(&uctx->srq_xa, srq->qplib_srq.id);
> > +                     xa_unlock(&uctx->srq_xa);
>
> Something very minor, there is no need in this lock->__erase->unlock
> pattern, use xa_erase() directly as it will perform locking internally.
>
> > +                     free_page((unsigned long)srq->uctx_srq_page);
>
> It is worth to get rid of get_zeroed_page/free_page too.
> https://lore.kernel.org/linux-rdma/20260713-b4-rdma-v2-0-65d2a1a5180c@ker=
nel.org/T/#t
Leon,
Do you want me to take care of this in the next version of this series
or should i wait till you post the series that makes this change
across all drivers in rdma tree?

>
> Thanks

--0000000000006be8680656b69058
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
vmAALYRUoHFeNyhVrfO7wlkk94J7vjzRdB8gNCrUyLQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMjYwNzE2MDg1MjQ3WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAd5wvhg70xJ+aRHO9KHbBPCJJuu4hhjCLYzle
+kzn8H0ynug46P/AbUL6cOAipe2N1WNDisIDCJirXbeKq+PZtU5S2TM99i0RxMVrBJ8W2ceVbrUx
Jq8X+/rWg+ZAaNC+sor8YvnvTDuNOjLo3pZullEy6MxDJ9dszXDWsAtxg8azNTLNxkemJpHQVYM2
J8rzJtHZjwoWCpshQkDSd+fSoXyXiIML+jCeSp3gqGM4jETXt5FTtSUwiyXoGpDZYyMWiK1S2mbT
auIVEwV9dmz63k00jUHWW6l/CokMhXYlhzW8Vq0mNde2TqHiI2RoTaedwYV2mePBuZjMYkVlQB2W
/A==
--0000000000006be8680656b69058--
