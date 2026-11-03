Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793709903;
	b=GsVWZq8iiZD1YIAyv7KSUtogxsauxXrcRbqWsJU03VP6zr154JiawQcdW+2ubEgLy/SB
	 mUA1DU1wO++CXTtW78IqkwBfX0KxgX/bE4T759sNFtctU+5h/kb7IssOauXy/lCatoDhA
	 66aWigo/Skmo+iQQgz64agxTN/KfpQjYfQlDwvKOdb6VnrORslKw9vGNh3AkZoYVpj+9N
	 50pklAP6vRwi4XQ5PZzL5tDjvb3MNFR2Mk6zaiDMovoQhxADklwS2OBvjFJZuQU+eG70I
	 oHzrIUHCubSCwNUiaYK/fzkVURcXpkFMIvAw0zS3Fs9ts6H7TTxkfl9lvUc1PUH94Hg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709903;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=cJss4DTSAFF0TC2y24FFpMgu2U/hDyAjjGTYiZ+imqE=;
	b=PQSERFljCwteuyldxdkEmXWaTMdp93EZ+Onre9YyrQx1+Aqxgw3Z8JDF69WitL4wbK27
	 sDp8LK6rWvKVcfU7ZMgcKimSQ2eyMP1mQ4R8hSB0HTYIchoCKJ7C/bgzJ3TVcnAKMCH64
	 ogo7kKG+K8MQKpq/0ACI6nIQG5yZgXEBhe9rB4rg+dmGiyi4CjFxKkH8Jg8OK55LxMSyi
	 GNpGOEX3hGYm3j85ZTAnZBeFH/hgZmhrU7Zck8xqn2HX1waFKKGNftMzPIsjnHfS30xDD
	 XS9PA09TNyZhnSGQUbsyGdOHa5aCKLJvaNKlq/9493rx1iKO+CjpEvJfpr7Ml0hOgIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X7YIwu+P;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.41
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA30606EE99
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 12:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EA30606EE99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=X7YIwu+P
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-49e08af5fd4so1853669fac.1
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 04:45:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793709901; cv=none;
        d=google.com; s=arc-20260327;
        b=VKJOdUYr6DgmszvbTxmGeDfbzUwbUVxGr2BgCmW5yuFtRTuiRQhL9LijTPvpR7l/St
         mu5erpfxvGUOglCma7w4mJvFfnBuhOJW+bC7+kW/3u+c7wunFd8G9gvCM4vsRlEjOo4j
         ScIqSz0XcdLGvsTV3bXzB4lOZoc1OBf8yvDCnSWyJ05achHeauD37wCSOw46Y0oc7Cwk
         InAnjpO9Vpv+4J57naCSRiVf6wiwLYN9uLIIpKYH2+AHIe4vw7q76GGZ+5Jz5vqalPaW
         K00x9032UURLU8AJZsbLonQjR4hNzEt06KKz+GFdCQYgHeLRudxKTbpUk69UPrzPA9/Y
         K3YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cJss4DTSAFF0TC2y24FFpMgu2U/hDyAjjGTYiZ+imqE=;
        fh=wdlQNzcnviMZxZcZ4FRSDiTFrEERUyD4G+N9ho6Q/hc=;
        b=sTWFF+7hLfxOo/1BjuX+H64ba9ccasScygetUQaHJXI0KrUDchGVR/0z7J+HAWZQO8
         PfRaZQT2EEFNQxbjF+uKaysmW3d9V6KQkVZ/xxPKg7gxARmgnbB5FqTZwYhcpF/pE8Wm
         SFm9lyvEYmlScuwC0fRpWXBue966Z6aYvo2lg29wrAu1MiwxFB+dPc5lVU+ECYjT3zwL
         oGgwzpGfMl2LNGQb2VgA+HDuF2cJnV4SH8t06Cq3xk3+wrEb21Y907bB8kM8CDrDuNlw
         zWawBM50DLYpe6lssOgv6GHh+quEptQ++HabMS5mVJMhC/1qj31KEj3ZdPHNW8Un4qH1
         PSQQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793709901; x=1794314701; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cJss4DTSAFF0TC2y24FFpMgu2U/hDyAjjGTYiZ+imqE=;
        b=X7YIwu+P57YbvarctNfqfO7T/pAsbLAUPr1ZHvH/QyvkiDBJARSLe/e5hzhvwmWD1m
         FDB9O1eM0jLjHjBT7zIhZtEfxB9hxtt+GPeuaY5adipemtw5ydKNpOA0sR63qXoszWhS
         87S1+WFmEQeF/jRnHieppIfgUe2st71Xy4FZmpakVMOZzWdeMduHI6JUsrvD/P86AWrf
         Z7ARWoEr3qErGbGvkfpcLu5SYYuErQ1f4g8XJOZuHfQ02SjF5rMvGCqIViryEQwVKXpB
         d+nxfcnLqnitYjnnRLlt9+xm2QRhKRcsb0HU82egfjN2OYCC5xcxMpwf7/RukhY6xzVx
         /Rzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709901; x=1794314701;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cJss4DTSAFF0TC2y24FFpMgu2U/hDyAjjGTYiZ+imqE=;
        b=aGszUagIt2kwkHNaThfq5PoxRVytBZA+DA7iwNz7JzomBEsYntlfNbJvlk2qzEIFmv
         ok9iocFUw1mTsL+OMINN4gJCy9VOrbxfl7BVESNe76M1fzr5TDBQOD0Yl9+981PcYjKo
         eRQgOdXIMcPMg+lh1lB6EgHt8zajakyl5Fd4CNSJIitohMp+K3mEITx1l02K2FDmTSXm
         PcFeZKmFfftTNCK/BYzg4Wn1C1h4t5xU1bp5Dy4+mjqoHX6FMhuH4Pw9M636fQoHQ6UP
         RcBkJ8T/f1GZSiOS3ysglFA3KnhWldOfQOU7chBPGKzz2fhJXXRlSvozNOrXR7NkZm4W
         9aNw==
X-Forwarded-Encrypted: i=1; AKwUvBwgFfP+POYwRH6BpUDzCcPl9bL2ej0LyRRPIBsy06w56TK0/ep9NDu5G7vIboa+f0O93FQhaerqNJfG@vger.kernel.org
X-Gm-Message-State: APuU4Z8+EhOp6nByhvGVJ2w7MnthAuJrCWTrMnhti0O0XkyEZJqyL3Hy
	og43/wlRKuSWwkp9lgffrt9LKaadkNXgOUzfzsQJXd4TrOAHaTuHW4o+u22rkuahnn/1K37sZ/7
	0RV0sAkrVSCQhKL3ltkLt/47p7Yt6GiPZBSKpU3rV
X-Gm-Gg: AYBFou1EvbhF9tEtcuvfoFYhPlc8tT7VqtHmdTp0iaVuXMTDZN4LNKF94jbYaVDPE97
	wN5HO9H2QUezmrZytJ0g1jsxbbDLl0dgT+C4lTS5JBBfNnD+lg2rEyunEyrK8KPFKuzMm+cqw58
	Jcqg3tYR7Kb6ssnq8LdOkPCL0K2em33rjW76KdXHo5RAfZUdaf4B8bINPWhXyKSiu8JHwWLjKEv
	u702peKQq137Rxz7o0KzNDxqg9CDihBo65/J67Ckp8ADs3zx/ZP3+9bn7s0gMMYM+etUL8wIm/e
	9LzEKUL1n3WiXoTYG28wQVhvx7lJil+WhteEJJY1mKV6DRW3xabNAjmbOKEXrnn+5oOwRMRiwsU
	qTZQVXmUvMiYVrDlFOrdwt5p+TglwKEjbcnDsk4vEZ4P8ab+OWkHGhbDlOJFzyzUYFvtLfuHbZN
	YKGL79VBo=
X-Received: by 2002:a05:6871:c8cd:b0:494:76db:2aa8 with SMTP id
 586e51a60fabf-4a90730f375mr7994740fac.5.1793709900334; Tue, 03 Nov 2026
 04:45:00 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030173254.2000665-1-dhu@x6u.co>
In-Reply-To: <20261030173254.2000665-1-dhu@x6u.co>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 3 Nov 2026 07:44:19 -0500
X-Gm-Features: AclHuK8nDugVTssmfIb-0C2nE1vAsrv5to5v5OGV3nTs3pUaP90m0Vgw84uKISA
Message-ID: <CAHYDg1QgFnyKEA_Dbx5dpdUV6Hfs3w+japBgBGeR3iD9UG72dg@mail.gmail.com>
Subject: Re: [PATCH rdma-next] RDMA/irdma: Free cq with a safer cq num reference
To: David Hu <dhu@x6u.co>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hu <xuehaohu@google.com>, 
	sashiko-bot <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Jacob Moroni <jmoroni@google.com>

On Fri, Oct 30, 2026 at 1:33=E2=80=AFPM David Hu <dhu@x6u.co> wrote:
>
> From: David Hu <xuehaohu@google.com>
>
> Within a iwcq, `cq_num` is allocated first, and only
> copied to an inner uk structure, `cq_uk.cq_id` at a
> later stage. Freeing cq by `cq_uk.cq_id` before the
> later stage leads to a cq id leak.
>
> Free `iwcq->cq_num` instead, which is allocated
> right after initial rsrc allocation.
>
> Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261016202909.1289496-1-dhu@x6u.c=
o?part=3D4
> Signed-off-by: David Hu <xuehaohu@google.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index c91c55917de9..1726a0ddeac8 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -1948,8 +1948,6 @@ static void irdma_srq_free_rsrc(struct irdma_pci_f =
*rf, struct irdma_srq *iwsrq)
>   */
>  static void irdma_cq_free_rsrc(struct irdma_pci_f *rf, struct irdma_cq *=
iwcq)
>  {
> -       struct irdma_sc_cq *cq =3D &iwcq->sc_cq;
> -
>         if (!iwcq->user_mode) {
>                 dma_free_coherent(rf->sc_dev.hw->device, iwcq->kmem.size,
>                                   iwcq->kmem.va, iwcq->kmem.pa);
> @@ -1975,7 +1973,7 @@ static void irdma_cq_free_rsrc(struct irdma_pci_f *=
rf, struct irdma_cq *iwcq)
>                 }
>         }
>
> -       irdma_free_rsrc(rf, rf->allocated_cqs, cq->cq_uk.cq_id);
> +       irdma_free_rsrc(rf, rf->allocated_cqs, iwcq->cq_num);
>  }
>
>  /**
>
> base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
> --
> 2.56.0.317.g454f8302e1-goog
>
