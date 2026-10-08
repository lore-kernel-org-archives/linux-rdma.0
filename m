Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DB6471CE6
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449255; cv=pass; b=j5H/lwaX2+UVg81eO51STEJYLIOJNzyhtPWlprC704gz3Bl65Z0q+Kene5JbhDX4n8eJkDzS4GzLa61D2WXS5ajKYJ81VoT1pXSkcmNo4cCGKRXAF4BJMxksIMk/yx+9WH9uNjc/9V4jAQ3QHrteibqNbsuZWwip5y7NXH04czU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449255; c=relaxed/simple;
	bh=wnf1Rxz7GOXO2mt1drF6YwLshKbYBKmoC34txj8aINc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pfdA40VBf5rDU2Eq2G7EFblJJPOB3nJURZM+c9sx5hHLgwpMeCGzbEoIlM3YASl+Fnry61iksDReoNQrU48RaxkVKvDQZMTZSp0P+/OXm+8ypFDLDs4RuAFY47eD6GkjYm8jrB+BwPcDWZkPxJbjvvPS4eEHOH1GlKULBcDNDUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuUSni7h; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuUSni7h"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2e61f2eb96so13242666b.3
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 01:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791449250; cv=none;
        d=google.com; s=arc-20260327;
        b=e3odJ3DAbeIei6UcNZ0CP7wgMibPrp1NyfQ2gBN+MwujNaPyMr5/Sf02Z0tfz8LpPw
         yS/bV81rM8cWwS8maoR7+N3MJOl2DSJvVSX5rr0maggyHGN2Ls8Vx600Own1uL2MXG3k
         UyOISWu9sUv5/dNZ92OWn2lEKrDWoRZib0CeWw4YvWse1rWwFNR+eukB/cCJxqsHyq7p
         IpdZMT35wg3SDjbXnUMCK79eLJ0JEtjS5yktd0DcQ1KoI2NWZ9ElFqtfUa9oqMGmzf/r
         LptSNoaTlywYPbDleXGV27fNHT/2U967Xod5/1qCHuDrkiI6o7D2I1XSummr77AkVlRY
         L4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0UcH2PL4jFdt0IAXyp77qe+AKdk/VbOyr7Y+0xZparU=;
        fh=k/6uSAfGF3JvRejiOwgFn6CwcXkTt6KS1VPnNxn8o5U=;
        b=cHUaofjUxzWvCzr19rmWMLCUJgf6o2aUiERz0HTWGTQuFUkIQBUVZ5Rxvbx4IPHsHp
         iufv2fTeqb5uGKPQvs2J9YIloRg1iEFaK7PDo3onfzEB8iTMHfXIZloWh54Lz9wXnTNZ
         R+zIW4S8OcZZEXThpBu+8jONlSpuWHq2F3/AAVpZqRo4AgpFsZoM1cNwMc2XRKs9RlIV
         7JMFHv0oQ2TxDo9sLOHpquQoiePFjcM9aYt84skxyYIsmv0P1rlKPrkBTFYRG42aGvpl
         su3SxRLzrfHV8u+QbUfXS/CxDhFsfA+o027TiCyF+s0IR3UdT+IIQ1SVzjYhfxmX7atT
         FjJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791449250; x=1792054050; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0UcH2PL4jFdt0IAXyp77qe+AKdk/VbOyr7Y+0xZparU=;
        b=kuUSni7hlE4lksl+gPcGL9an60/cobuTciWPG0OHc+15BstRjhLcDuDM1OwQ9BGf/e
         NjakGT8e6p5scau0Y74rF6mcakjRAxwRiRUzY3OiXBH05XesXmmD2g8dH6YnPFtS9p4t
         bm7eTNGm7PywFocmIleZf/dVg+prWH4BgkWtOCKHsOdqbPzYyV4JyVGQHS2TTba6zoIm
         2PLN65i+HaKPTU6OWXSYaJWZsUfNWjDO8UFmcGFkEZSk+erBZn/ydIUOHAkyNW81JN5d
         GBzF+7ANa+901btPE0aYQwHRNiFzufhlKMI7tpulSek/nGkGgImRm25mO+8b9jX2gOJt
         WMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791449250; x=1792054050;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0UcH2PL4jFdt0IAXyp77qe+AKdk/VbOyr7Y+0xZparU=;
        b=ygDKhRlt8RV0RCt4S45unAiyU+p+lPadcwLQoAXcoYq3GK55SDwh4JE0+fGFQ/pUfk
         COHe2VTjdda+RN2lDh62XnZZYwJmahoR5m3nhgdiKwjMm7apP0rO1gDC6KncK688N4nJ
         n88LmfSjRzFctICVG0QrLmzbk2g2ocG6uRtfOvsyW9suNAYO3dHB/dNrhy7TmcCcjsau
         WcRd6zaC81hMKfqeI5TY4IblCRgv2ewO0L6WOEyfP5cx+w4YHSLwpTq0QaiHkot49f3W
         4W9tVrGGXDnTKtLFRTkTItJsvb6g5+WzgZ5loGpqUPt03JmsVZpT6cLp6gpXhtMdR8qI
         ETTA==
X-Forwarded-Encrypted: i=1; AKwUvBzLRmd36A7lmTLVrt0G7ghsKQgFb6LZkexAgTNEQZv0/X6oG4HMVjLerGs90/Cy6sr2ahtLIAZd597k@vger.kernel.org
X-Gm-Message-State: AFuF++mHYlZJ7SrxfhBPylgJYAsEmAreAK3UsgOcM6s/5IXO58FAPDQ8
	Z7sY4L/R6vC75Um8cUKPyOcjn9JGTqh7ptYCupfCyst/SMddpFx8ZPMQbXofNjr0oQpzlviYljg
	qoztHFtAG/rlhYJonVSX9wnoQ2cKJMzs=
X-Gm-Gg: AYBFou3d56VeKxy6ImKbvFzf0v3yQJcPNr5XhTMSWYfdAB6qlhhdOgjDigljRNngQaG
	PAr4cW63JBWZgNhLRG+2FOEhlsIg15FYqkhokpZaQHbS1bQaZ0i5SH7KXh2hHDMkv19ndG+j7VK
	775XRAoegmMyqboTtwQqUuzRjJYp2M5uSVP3BiOpcA/oZK0PAK+/Wres50ekAjvTday+SCzz/xO
	XU3mnFG2PG/wJQDkgaKuppc6t+0lIHYqtr0W5J5LdiV5AmqJjmKtMC8GQgF3syCN8S+Ny0Ifujk
	9afu4WYxsmppnTBK8jd9dUoJGkoWhdlnR/uHYZyMybYs7Acyk3J07OpZ3TMLg9cvrTqvQodaXuf
	g0EsMMkKTzkY=
X-Received: by 2002:a17:907:3f1a:b0:c29:5637:ed76 with SMTP id
 a640c23a62f3a-c3190b7f237mr174970566b.2.1791449250106; Thu, 08 Oct 2026
 01:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261003183325.2289707-1-nicoyip.dev@gmail.com> <4bb7f15e-2cd8-4598-9bab-1ea5f5d2bb59@linux.ibm.com>
In-Reply-To: <4bb7f15e-2cd8-4598-9bab-1ea5f5d2bb59@linux.ibm.com>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Thu, 8 Oct 2026 16:47:17 +0800
X-Gm-Features: AclHuK-HvCltyPhbBd2tQBXjDEN4keSNVUMLUN1JKqvwBHV5wUDOdUDGOh2UcnU
Message-ID: <CAAo+4rVmRy7Hj-PRuCzuzXg=r5HDib2ztNnBa6On9+Lx1W1Ysw@mail.gmail.com>
Subject: Re: [PATCH net v2] net/smc: serialize clcsock access with its release
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, 
	Wen Gu <guwen@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 3:32=E2=80=AFPM Mahanta Jambigi <mjambigi@linux.ibm.=
com> wrote:
>
>
>
> On 04/10/26 12:03 am, Chengfeng Ye wrote:
> > Link-group termination can release the CLC socket through
> > smc_close_active_abort() while the SMC socket is still open, for exampl=
e
> > after shutdown(SHUT_WR). A file reference keeps the SMC socket alive bu=
t
> > does not prevent this asynchronous release of its CLC socket.
> >
> > smc_getname() can race the pointer removal and sock_release(). The same
> > missing lifetime synchronization affects smc_set_keepalive(), diagnosti=
c
> > address copying and an in-flight SMC-R CDC receiver. smc_shutdown() can
> > also reach its final CLC shutdown after its close helper drops the sock=
et
> > lock and a concurrent abort closes the socket. Holding the SMC socket
> > lock alone is insufficient because CLC release runs outside that lock.
> >
> > KASAN reported the getname failure:
> >
> >   BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
> >   Read of size 8 at addr ffff888109abb4e0 by task poc/103
> >   Call Trace:
> >    smc_getname+0x19e/0x1b0
> >    do_getsockname+0xe5/0x170
> >    __sys_getsockname+0x8c/0x100
> >
> >   Allocated by task 95:
> >    sock_alloc_inode+0x1e/0x280
> >    sock_alloc+0x3d/0x240
> >    __sock_create+0x7e/0x430
> >    smc_create+0x121/0x240
> >
> >   Freed by task 0:
> >    kmem_cache_free+0xcc/0x340
> >    rcu_core+0x50a/0x1850
> >
> >   Last potentially related work creation:
> >    evict+0x446/0x6c0
> >    smc_clcsock_release+0xa8/0xd0
> >    smc_close_active_abort+0x26a/0x3a0
> >    __smc_lgr_terminate.part.0+0x137/0x2e0
>
> Hi Chengfeng,
>
> Thanks for the KASAN report and the fix. The UAF in smc_getname is real
> and needs to go to net and stable. However, I think the v2 approach of
> adding a new spinlock and extending clcsock_release_lock to cover more
> readers is treating symptoms rather than the root cause. Let me explain
> what I think should happen instead. What to keep from your patch.
>
> Please send a v3 with only the smc_getname fix:
>
> int smc_getname(struct socket *sock, struct sockaddr *addr,
>                 int peer)
> {
>         struct smc_sock *smc;
> +       int rc =3D -EBADF;
>
>         if (peer && (sock->sk->sk_state !=3D SMC_ACTIVE) &&
>             (sock->sk->sk_state !=3D SMC_APPCLOSEWAIT1))
>                 return -ENOTCONN;
>
>         smc =3D smc_sk(sock->sk);
>
> -       return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
> +       mutex_lock(&smc->clcsock_release_lock);
> +       if (smc->clcsock)
> +               rc =3D smc->clcsock->ops->getname(smc->clcsock, addr, pee=
r);
> +       mutex_unlock(&smc->clcsock_release_lock);
> +       return rc;
> }
>
> That is 4 lines against the confirmed KASAN-reported UAF, uses
> infrastructure that already exists (clcsock_release_lock is already held
> by smc_clcsock_release() when it frees clcsock, and already initialized
> in smc_sk_init()), and is a clean candidate for stable. Nothing else
> from v2 is needed for this specific bug.
>
> Drop the clcsock_lock spinlock, the CDC change, the diag change, the
> shutdown change, the connect-abort change, and the smc_accept_dequeue
> change. Those races are real but I will address them with a proper
> structural fix as Me & Dust Li have already discussed on LKML in August[1=
].
>
> Why the other races exist and what the right fix is
>
> Every race in your v2 =E2=80=94 keepalive, CDC, diag, shutdown, the
> connect-abort path =E2=80=94 has the same root cause: clcsock can be free=
d while
> the SMC socket is still alive. Several close paths call
> sock_release(clcsock) before the SMC socket's own refcount reaches zero:
>
> 1) smc_close_active_abort() =E2=80=94 for PEERCLOSEWAIT*, PROCESSABORT,
> APPFINCLOSEWAIT states
> 2) smc_close_passive_work() =E2=80=94 when the passive close work transit=
ions to
> SMC_CLOSED
> 3) __smc_release() =E2=80=94 when sk_state =3D=3D SMC_CLOSED
>
> Every access site that can race with those releases is then forced to
> take clcsock_release_lock and check if (!smc->clcsock). Your v2 adds a
> second lock on top of this for the BH/atomic readers that cannot take a
> mutex. This complexity is unnecessary because none of those early paths
> actually need to destroy the socket =E2=80=94 they only need to stop it.
> tcp_abort() and kernel_sock_shutdown() are sufficient for that, and both
> are safe to call more than once. sock_release() is the exception: it
> frees memory and must happen exactly once.
>
> The fix is to move that single sock_release() call to smc_destruct() =E2=
=80=94
> the sk->sk_destruct callback that fires from __sk_free() when the last
> sock reference drops. At that point no concurrent user can exist:
>
> 1) fd users are gone: smc_release() calls sock_orphan() before dropping
> its reference, so no file descriptor can reach the socket after that poin=
t
> 2) workqueue contexts (close_work, smc_listen_work) hold a sock_hold()
> and therefore keep smc_destruct() from running while they are active
> 3) accept-queue entries hold a sock_hold() via smc_accept_enqueue() for
> the same reason
>
> This gives us a simple invariant: clcsock is non-NULL for the entire
> lifetime of the SMC socket. With that invariant every reader becomes
> trivially safe =E2=80=94 no lock needed, no NULL check needed, the race
> condition simply cannot occur.
>
> [1] https://lore.kernel.org/netdev/ao5bB9OCbJ5PQbEp@linux.alibaba.com/

Hi Mahanta,

Thanks for the detailed response. I just sent v3 with only the
smc_getname() fix.

The additional locking in v2 was added in response to Sashiko=E2=80=99s rev=
iew
of v1. I should have checked the August discussion before expanding
the scope of the patch.

Best regards,
Chengfeng
