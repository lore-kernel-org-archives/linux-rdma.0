Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9925F4FB9BA
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791903692; cv=pass; b=VjA3FnWC7kJmcSw1ZJpXP6yK9DdPSbWdHT2AgNry3zp32K58xFKYVZBgZieZf8Jn5GGVnVpI0rFXZMifs8c/8Sa5frkhrd5BxDHNsz0JlS95pdyms+jgbPXt2cdKUWiudAEtGE53vIX+egNagd0Q1/+fsXIqlRJOlVgswJedBKQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791903692; c=relaxed/simple;
	bh=tw/fVrFqpZzJSyIZ5wzwHJRG0AwN51iLSFbnVvJXUeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a336SFvMnq3nae1g7thot3XCveJj1DVMsh4FcPs7k+5TSiaw9zwurwe7YUmCjnYxVaWsl3pNu9JaowgkAWZNzadCGTIM1TCW/XyORGf1aHHHSz/miN90MPYxETNIObfpa07+HQmdjTkpAB7quTdS930PO4jNxY9h3eZoI33qOXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qdeFJnFj; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qdeFJnFj"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ae14cdc63aso25681a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 08:01:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791903689; cv=none;
        d=google.com; s=arc-20260327;
        b=REbTAWQt85aVvTRwYviZcCRyr+dyPOZQD3Kjm1nz8JVX1s9He6USIN1YEfY6XoL2SG
         1snvM3HTtmN2KID10myynTD4hhsuuROI6u5H5xGGPKGPOG9GF8g+/6H4pevuX+RxJ7gb
         ufMfNoRZdANzI1DuKBvMpHYOEEAlwBUbCykdYZD4mG7jTcV41Y87DKeJd3d3u0dGZDkF
         IVkrzLQPzTP4vhrm1nGyezBeqszjooo5fA4l+OxdovQGtl15xQHp0axUO/YZJntedgAr
         NPtWk38/gT5j8Pfj8AAw17QeOYW8uB45HBcZrIqT+Ej1FMwMTH03WNw9f8xrdLtHmkdg
         FAlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rymSkdZezJnGb9FeGEEgvGAMLZUCeRFNqmLOcwpB228=;
        fh=hVpOB/H+Wo6OlonK1GGSrvbmkRe5Zng6w+TlY8mnbsQ=;
        b=FHyHqEJVROS5/kPuSfAyrvFclAHor0PiYWjKTMfciGSke8CZuNX/8OGt5GbEvmBGae
         t5A7p25O8Rxov+1jvO4pewNczt18dz06PmioiIz0vxVKpeSoCKxJN+X/zAxnmjnOtKWI
         BkCIhM7QYGy5M16KGz5qm+LWbWNIo5lONRlFr9ZDaS8W/NUfSk1hCzaHaIfyrJa4rZp4
         AGi6z8jki2Zg9wcrwAMK7LUiC1fQZImieuT+MfPM1BiclBSAvHBn5VFEsZ/0FDGhvw+f
         K7j/x0ZgzEBSswD4wt1DgLFYbLd++fs1WirI/WpQVAfgAxqOEBmooVOtmq5jKLd7xTqn
         DXaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791903689; x=1792508489; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rymSkdZezJnGb9FeGEEgvGAMLZUCeRFNqmLOcwpB228=;
        b=qdeFJnFj9/9ZCIJ7Kl78fEn7Xr+7jToAszoCs9mnnUQMkFGdtUq0Vt9xvt82Rhbm98
         Xf4cYvqAc17Yz175Kr4jlW67zTllhSSH1TgIDA+fyEEycY0r7xXbkzNcgccmd5XaMrl8
         I744D6yhxytWlq6Kmwg5eHsxn1USSFKJbvfZ4s72dI5NJaEXpkbgt3hFlBRxYhFhAwNd
         TjMe4oWQGgmTo8sbIAlxbLQ3SxUMJNSSqoc56SPxHMNo4LzsMgWRrs9IMHqASXesSUjl
         wOTSjrOTYaUMF0iFUM4ds5+t1Gnl59uapjglfYsFriknYC9uCpOB8nhVnZ3fi5GwcXTR
         hbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791903689; x=1792508489;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rymSkdZezJnGb9FeGEEgvGAMLZUCeRFNqmLOcwpB228=;
        b=D3ZZ3iDSbbN+3z0jM/MQDg27cfgRX1ZVZBG+2sdcZFfoTgQsjCyegcl1WFlrp63I7y
         HrWfQsxjY/EECW3YWZ8vRhl8PdOUGyCq+dZZ/Et8rQOiv6aGwQt10jeZN6wfkCRsMhe0
         PJLQ/yN9CINV52fXi524T8cq3fREl7K5vG/tDeKLGW5SfHEQpw4e0hic9UWIAueHKQ89
         inFp9VDTCR9eOqYBJVagWsV48vcIJ1fcmac96fmw2v4hbc7eJmwQzZoh4zJUup3hN/l7
         u0cMMGpw41wXtFLbsDssdrxLmnd6NnseehJl1dabY7vHd9PBfzCGg98upCUfMh9VuRqq
         /+NQ==
X-Gm-Message-State: AFq9FYJuxxOOy57SJuhn3x+HECymGHVCW+fz3mfNy74S56c829KdZU6C
	xQwTz9hn+4Tu6yYNxZNt49srOI25Z27RFHtd3Ngn1/sukNWTDrFZ18571OFH1Lr5kbUg6mknZEW
	rvS0Zw7dbQldZiKVpJfq7JyGW6rOnFpS6XpH4oOjb
X-Gm-Gg: AYBFou2X0v3Ub8LtOM1h5w8mgLLhKIwPgB2H03ujbWvah2r6fmVaejW6kO8PT3ZUzRI
	B77PssgAyE87DM2YdTd5/9KUUutS6GSz+h0npawAQTL6PlO/hMF6hgvfMeV/aSoZiaCm0rz1L+q
	aKjmeErvfCznKDT5gtWlxQI8muaEEogTn4HqF/M5ym0ZTf1AQrjR7IQWXA3dtW+OhpgnkFiMzlX
	IOZdfJcBKUoEQKzlDFF+IxrfxS2CUqVUFbx4PoqF2TVFY8piqoAhS2UTJZMuMKk4TXwrC5ctwLA
	H61M/MkLimaSnl2SGPqVUg0yTTTmo3RxbEZ/lPS8TloMnRgzi7tzfIn0QzvMPmG+giGZbONH0aI
	BkVmW844tl+c=
X-Received: by 2002:a05:6402:652:b0:6ac:bdfe:116 with SMTP id
 4fb4d7f45d1cf-6b199a8e6camr137824a12.16.1791903687982; Tue, 13 Oct 2026
 08:01:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012082148.1698596-1-almasrymina@google.com>
 <20261012082148.1698596-7-almasrymina@google.com> <sashiko-outbox-169237@kernel.org>
In-Reply-To: <sashiko-outbox-169237@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 13 Oct 2026 08:01:16 -0700
X-Gm-Features: AclHuK8M8mD59YUfA3CRA-iHfHLQ1szT4G06vA9qiJ8Q4zstPlMFFHmXtF7_XfU
Message-ID: <CAHS8izNBV==1fOkO+NP-vBznqtLZe9EzdkEj08gC_uZHiTRLhg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2026 at 1:22=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] net/kunit: kernel panic in TCP devmem test due to unset skb->u=
nreadable
> --
>
> commit 432a5016a6d079e3237437e79dd79f25313c4f7a
> Author: Mina Almasry <almasrymina@google.com>
>
> net: kunit: test netmem, page_pool, and skb frag refcounting
>
> Verify that non-pp (page._refcount / binding->ref) and page_pool
> (pp_ref_count) references stay balanced without cross-counter leaks or
> underflows across regular pages, page_pool pages, non-pp net_iovs, and
> page_pool net_iovs with both pp_recycle=3D0 and pp_recycle=3D1.
>
> > diff --git a/net/core/net_test.c b/net/core/net_test.c
> > index 9c3a590865d26..6f21e6baf7fb3 100644
> > --- a/net/core/net_test.c
> > +++ b/net/core/net_test.c
> [ ... ]
> > @@ -370,10 +370,1213 @@ static void ip_tunnel_flags_test_run(struct kun=
it *test)
> [ ... ]
> > +static void netmem_ref_test_tcp_devmem_recv(struct kunit *test)
> > +{
> [ ... ]
> > +     /* 1. Receive via tcp_recvmsg_dmabuf -> SO_DEVMEM_DONTNEED releas=
e */
> > +     skb =3D alloc_skb(0, GFP_KERNEL);
> > +     KUNIT_ASSERT_NOT_NULL(test, skb);
> > +     skb->pp_recycle =3D 1;
> > +     skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
> > +     napi_pp_get_page(niov_nm);
> > +     TCP_SKB_CB(skb)->seq =3D 0;
> > +     TCP_SKB_CB(skb)->end_seq =3D 64;
> > +     skb_queue_tail(&sock->sk->sk_receive_queue, skb);
>
> [Severity: Medium]
> Does this code need to set skb->unreadable =3D 1 when injecting this devm=
em
> fragment?
>
> Without it, tcp_recvmsg_locked() checks skb_frags_readable(skb) and retur=
ns
> true. The TCP stack will attempt to copy the payload using
> skb_copy_datagram_msg() instead of processing it via tcp_recvmsg_dmabuf()=
.
>
> This leads to a kernel panic when __skb_datagram_iter() executes
> skb_frag_foreach_page() and retrieves the page pointer via netmem_to_page=
().
> Because the underlying memory is a net_iov, netmem_to_page() returns NULL=
 and
> the subsequent kmap_local_page(NULL) call crashes the kernel during test
> execution.
>

It certainly doesn't panic when I run it. And we're testing
refcounting here, I feel like going through a rabbithole of what skb
flags may be wrong on these test skbs may be pointless. And general
design is not necesasrily net-iov =3D=3D unreadable.

> > +
> > +     msg.msg_control =3D cmsg_buf;
> > +     msg.msg_controllen =3D sizeof(cmsg_buf);
> > +     ret =3D kernel_recvmsg(sock, &msg, &iov, 0, 64,
> > +                          MSG_SOCK_DEVMEM | MSG_DONTWAIT);
> > +     KUNIT_ASSERT_EQ(test, ret, 64);
> > +     KUNIT_EXPECT_EQ(test, atomic_long_read(&niov.desc.pp_ref_count), =
3L);
> > +     KUNIT_EXPECT_EQ(test, atomic_long_read(&binding.ref.data->count),
> > +                     base_iov_ref);
> [ ... ]
> > +     /* 2. Receive second packet & destroy socket to test
> > +      * tcp_release_user_frags() -> napi_pp_put_page().
> > +      */
> > +     skb =3D alloc_skb(0, GFP_KERNEL);
> > +     KUNIT_ASSERT_NOT_NULL(test, skb);
> > +     skb->pp_recycle =3D 1;
> > +     skb_add_rx_frag_netmem(skb, 0, niov_nm, 0, 64, PAGE_SIZE);
> > +     napi_pp_get_page(niov_nm);
> > +     TCP_SKB_CB(skb)->seq =3D 64;
> > +     TCP_SKB_CB(skb)->end_seq =3D 128;
> > +     skb_queue_tail(&sock->sk->sk_receive_queue, skb);
>
> [Severity: Medium]
> Will this second injected SKB also trigger the same panic since it lacks
> skb->unreadable =3D 1?
>

Same.



--=20
Thanks,
Mina
