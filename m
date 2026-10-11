Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3F310651
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791734176; cv=pass; b=fwCf+bifR+JtR7eXc0pa1nrr21MvZGX4ThL14kIjMZZFvDzdFh4jWz6HqfcAXwOqieVLrdFha5T7CnAamqSF3gpX2e+Q07+EG7FoX97TxYcpC7Me25yW18Y+CGw2/XHWvFI0xCBDKA9J0P5dLrx4NA6mN0hh/WJoNyOEtcWLwvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791734176; c=relaxed/simple;
	bh=/JK+8oneyHjSUbJbc3j9nJhc1e8XAgMgQI7ekpEsvxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d34dQ5FOslHrvEQfSZvzBM1KzK6Fn7GSKlgtp/+WvceK6naiYa0gX37jk4aFRXU6mDVXipH4EBTE/6rSwEvXD6G74cTLUKJBXaY1HkswKPUI4/GzbhcWYHwX1WiCSgwn7rmY6Wp+ntOl+3kqxIlhPPrf/49iddqzCW2pfxoBdKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTWt42B5; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTWt42B5"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1b12de661so1408a12.0
        for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 08:56:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791734173; cv=none;
        d=google.com; s=arc-20260327;
        b=aKxkN7Vzwl+5E5u2OKGXMmZ4TWjhhEE9QCjcc9qmQkxmHtFDylAkF3Tjl4+/A07kTQ
         oP2bV/waZkTruX09JHkhDU4KLlXsga3zWRBTERSyzD535UHM+9BlBwCNx488TIe6fWLQ
         K/aDDGSIuVPMUd6vfn68FLOgz/dDCI8ZsqxztDfTaAOwgV7MlT9/OjeYxlMoTjlTY24t
         PmPDXcAEPNOOf5XfAImb+YdkBU+NReK2rWF7wjEP0EJ8WmmUmjBffEoRfhWy+GZe/WrW
         Md+ezuVBuNAxDUDecrav/vU049rxiGX4DDKKO6tyfPhJXPK3ubtRvdx8fIrDBsSHacjZ
         0HEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/JK+8oneyHjSUbJbc3j9nJhc1e8XAgMgQI7ekpEsvxg=;
        fh=I8uVdHnK9QZ2EOdPcNBahmuthSjwFUt+2Z2nE3ovV+A=;
        b=sDrX/BNMLF5GOtyD4wp5YOORF+5iFNaNL0OtsaWQR86myfQAM1CZEMexfvHWJQksIT
         oh2JMyy9D1YiKenFjC2gO1DFaLqO59qdhNP96cFfyLAUMgLoUzIVTm3hwyFQbSfMwSpF
         zIUTmdp6Anfc/dVwKMyZjbJsy9yOlIFY6OsqANYOexG5EtBXiGFAeY6zE6gT14MBaCJG
         Fd6sKCJrBjmbV9MX1tlN8mEOuUYKT/J7ktVuR9YZyr+me/H0+8pdWeZ0xUjBWS3oJyZ7
         24VYiccfnfl5LYRgWiS/SK/4KzxspVyAB6t/U/famvzfQXwD/6cM6gtlEhGwJfxCY/7d
         Q90A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791734173; x=1792338973; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/JK+8oneyHjSUbJbc3j9nJhc1e8XAgMgQI7ekpEsvxg=;
        b=DTWt42B5LkI2szJVPHCoQxA+Ac9vBYc6SBWESIZtpg0A6M6a8RT8GcUSfOOWCsGs75
         1ElnUKHWQxBsMojffPmn4/7vrKZGkFGfRej6G80p5Dc8oDiPhOiPLFEzPTZleb0KB1wR
         w1MNTSyitfqoa4yQYzOclHcoYGiCdyObcXvh7WStRl6zZpJEHWljr5qkW8b7ZBtg7NQf
         qkGoifDy2ENyTHLGAu4PegXqs/yleRxehBp1GMlZDcZ8ifc6aLwbOp1mul7RMPKktwfY
         rWVBM6EijA2+WlVAK08KB7NM/7e5bhm5DSzg+AImqIB378URTIAZZ6a5zTmIRxI73JdF
         vf7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791734173; x=1792338973;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/JK+8oneyHjSUbJbc3j9nJhc1e8XAgMgQI7ekpEsvxg=;
        b=donzI14MUD+5aF//iNcHi9RX39B6ztf8hOLqeaLWaYFjuDHEtkeguu/j1aeMKs5yzp
         5se1Yp2z9V+kNOWriOTmOANLkmRCwcym34MoFo45M0f8Z/W/aZF+o9NhhOmTda0xSVRd
         nyKxPl6/79rrZG1TV0naPYOvoqg1qXatPZSpkuGc7pJQgeOv+Yp7fKUQGQfEJ8JpHJ3e
         rai5tp7TbjeEQ8UmOjpaYHqgBUfEj2++2vpXB8K08ZOlb+7VJ6xeiOvl4sDoRe44OQJC
         XQxgd/kZEV/hx4Hx5wj8aEOREcMloRI87SMvvRToHF0yt4/+h7DZcec6wVSHUNO5EF9a
         W4ig==
X-Forwarded-Encrypted: i=1; AKwUvBwhmt2GkybnYrh11JoYmbmfbtlnVW4PQ3Nb7j5Wd8d1Ne4GEtBzBQcSaMdhEiZfMKf+R6HoRGOioLIM@vger.kernel.org
X-Gm-Message-State: AFq9FYKoZRwvC/0wFzRGZiy/Bqu9XA0RbxNxAYvYVofuw5u7dzEx4gBe
	EehAXRU420Au1mv+fZ2PGi6X0YTIU7bvYg2dhy7lkz1Uv0qOHTMWA/KucFmsHivhZRG4tPtnpXG
	SRUJoR5AQaRdz6oymBW+kR5xZ241l5MbyJP9VrTHc
X-Gm-Gg: AYBFou0vXhIpiAX+iwCahAhjABIkE5R8zdv45sDXxWwplxrsmGiTs4ethSvzIkowJ+m
	zkuttKgS3IlJyCRJkLCW14X8o/KVg6bEVjyouyH8kNA4H3e1wJWGC5st7lYeEmUFKJebZGKBwmx
	r47HHY4jfPA+ajxac9exsE2NK2vN6BWfiym625CIrTT5B5l48b8o5plwZ+ye9RiOK5sj85ZGDF5
	KtfVWjiBAzBs56YXTT8c2hYHi+I8X5TOlwbOOn053j34Z/Z5XsTtf4ySqWcjvwPdb+RUzlkkYMg
	YDt3fGHY6KH69h31lZ9fapGSmv8NA97+4IDagWfMqwde5ZkSiiH00kEcqWT0waTD
X-Received: by 2002:a05:6402:548f:b0:6aa:b72b:d762 with SMTP id
 4fb4d7f45d1cf-6b198823fcfmr54337a12.1.1791734172609; Sun, 11 Oct 2026
 08:56:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261010083935.3274178-1-almasrymina@google.com> <20261010083935.3274178-7-almasrymina@google.com>
In-Reply-To: <20261010083935.3274178-7-almasrymina@google.com>
From: Mina Almasry <almasrymina@google.com>
Date: Sun, 11 Oct 2026 08:56:01 -0700
X-Gm-Features: AclHuK9SxZyeBfW-6W6d1kton3R7TtfUwblUvnT30CCIbrIv1iqXLpJDIRaE5ao
Message-ID: <CAHS8izP58-H+bGw+4RJazukywpeDX5jMKaH9coMwcXh-mFa7AQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 6/6] net: kunit: test netmem, page_pool, and
 skb frag refcounting
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Cc: Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Simon Horman <horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Eric Biggers <ebiggers@kernel.org>, Kees Cook <kees@kernel.org>, 
	Michael Grzeschik <mgr@kernel.org>, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>, 
	Petr Machata <petrm@nvidia.com>, Arend van Spriel <arend.vanspriel@broadcom.com>, 
	Jakub Raczynski <j.raczynski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 10, 2026 at 1:39=E2=80=AFAM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> Verify that non-pp (page._refcount / binding->ref) and page_pool
> (pp_ref_count) references stay balanced without cross-counter leaks or
> underflows across regular pages, page_pool pages, non-pp net_iovs, and
> page_pool net_iovs with both pp_recycle=3D0 and pp_recycle=3D1.
>
> Cover get/put_net_iov(), get/put_netmem(), napi_pp_get/put_page(),
> skb_netmem_ref/unref(), skb_frag_ref/unref(), pskb_copy(),
> skb_zerocopy(), skb_shift(), skb_split(), skb_release_data() (clones,
> unclone ordering, pskb_extract(), and skb_morph()), and skb_segment().
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>

This patch introduced warnings in patchwork:

Documentation/.renames.txt: warning: ignored by one of the .gitignore files
Documentation/.renames.txt: warning: ignored by one of the .gitignore files
ERROR: modpost: net/core/net_test.ko: symbol 'skb_shift' undefined!
make[3]: *** [../scripts/Makefile.modpost:147: Module.symvers] Error 1
make[2]: *** [/srv/nipa-poller/net-next/wt-1/Makefile:2179: modpost] Error =
2
make[1]: *** [/srv/nipa-poller/net-next/wt-1/Makefile:248: __sub-make] Erro=
r 2
make: *** [Makefile:248: __sub-make] Error 2
New errors added
--- /tmp/tmp.UjTzqx5Cgh 2026-10-10 05:13:14.877336904 -0400
+++ /tmp/tmp.2YswE6nv11 2026-10-10 05:13:32.781257136 -0400
@@ -1,0 +2,5 @@
+ERROR: modpost: net/core/net_test.ko: symbol 'skb_shift' undefined!
+make[3]: *** [../scripts/Makefile.modpost:147: Module.symvers] Error 1
+make[2]: *** [/srv/nipa-poller/net-next/wt-1/Makefile:2179: modpost] Error=
 2
+make[1]: *** [/srv/nipa-poller/net-next/wt-1/Makefile:248: __sub-make] Err=
or 2
+make: *** [Makefile:248: __sub-make] Error 2
Per-file breakdown

We're not instructed to pw-bot: cr our patches on patchwork errors for
non-sashiko failures, but it seems the maintainers will want this
fixed anyway, so i'll pw-bot: cr myself and let me know if you don't
want that.

pw-bot: cr

--=20
Thanks,
Mina
