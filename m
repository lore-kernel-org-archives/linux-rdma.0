Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7594A547074
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 03:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792122498; cv=pass; b=Pt9Nf+5KajZejTjK5e55TrdWVsp0gOMkyHGzVBic0LS8BwrZayOZlGjyFuFvCR3Rwb/dIwb5qOH2nPNn3xnRGo18cvBgXSNV2G491s88oqSRbFMdy8VQV1uGhaOCSvq7rZF5UeAmaxNFFT1rumf29uhrPdF+cpCyfgdZVv+kcIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792122498; c=relaxed/simple;
	bh=WDhfqi9KVGdv84+1ic9hTc/O7+GDjdOl7MkC6oMvKIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TedqsumIj49rdTUpKYETKwGb3noHkiXqj3nQF7UEoRCCWt7RJIHoGBl1Oxhreae8xRd1b0QRpeHpgNu3WN9/ImN2Gf5kPKWRpp9yXzy93F2LzTGhfcoewEHKyUo+XI03NuCRfl0q+PQ06Ngx9LUSxW9AB6wyxxB6xJzckdfnj0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MFUnJYMq; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MFUnJYMq"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6afac79b3a3so3546a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 20:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792122496; cv=none;
        d=google.com; s=arc-20260327;
        b=CZzWPfob0KoftOc1fgyGcQjUPFsw5UrcSZvWAAAj1QUanapSAZMgnizyZ8A11PuOIp
         K4BFB8pXqRmehktCoGcwCF5X/nAUUuqv+6UXCKcDjre3l+HlEZRUZIhBSyg23Lmh49XR
         DKETxTZSAmFIE8pMplcGVXCnoVQ6+etFbpeB8hGbeBjIyU9Rh4ZT3Bmw5tyt/PodiL3O
         b88OQOEoH0s82cg6qhARWmCt1BRIlpnaZYrBijowvXeKa0tFEvOBiadFtJ5uOZS+SYVI
         FdbNxx+wIwIP9VGR1o+TetLmLAE8xdR78YIwAYFqVTQdRpXBTCmyxznRcLFZtId6Lu3Z
         IPzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cHwmVcL3Ea2QJiHo6JwLvdH2j4OcK78NhenhdrCZCWk=;
        fh=0w9MIUiiBtbOWcnKt2lixYO9btT/x6i1XsVICbjxH20=;
        b=cPD5U2p3JxMeQ836uj50krRUU3jqmDC8ol3s8xyNN7vgPwtUU3oNpU2Hi6rP2PbUIW
         wMhAvBErDMndjgIIonNBmYSMLgQHC8bHGC4JcnyNltxlbuvuF825kWGfYLNBlNH2t5BJ
         Xo8u3EFwmy5Gtk4A13GUVPAyz5WEgoRhvfriu84hgg7U98w3XOo8l2HxD8vzR6Nc+XOG
         s0RTbjJoGUPv4Qnni8vTePNj5rTjTSVVXvhbleFyBCwntmMNQbYBXHZAqYPGi3l5phFF
         n2dkkgQPMeQ2RH4HDF2BgQafQRUgj8IjsKA+YgS35cch9NWkjYvmplcTi5Xb78gG7eO3
         ELnw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792122496; x=1792727296; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cHwmVcL3Ea2QJiHo6JwLvdH2j4OcK78NhenhdrCZCWk=;
        b=MFUnJYMqeRN8pn5oS/fx7Cd7aYGZTuAmL2OPtbvk0h3AtusqHufhUy/9R6we1FzGNn
         bBiaEt0IoROvODwpQgTngVSOBgbPr3GOWyKRzCSfikrMcdUKGd0EziFzmIUG00VCAETh
         GcF95UW2KmEWCHa4jPsDafHok/nbbXBUu5l4cFYA73wuuyQl1nvwkiiyQqZngE4O17V9
         ZTY095u1puHUkVdeCxOdqk+UQTLkUeao3SXccnbw6t2YW6/4qw8Yyc5EHtrT4/gFylU1
         9QHOTqyYD5w+XTG1uqls1Fi7QAXNy3HD7iLDB9Nqi0L0HcPN7mWIcD2UnifQm39korJ+
         dJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792122496; x=1792727296;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cHwmVcL3Ea2QJiHo6JwLvdH2j4OcK78NhenhdrCZCWk=;
        b=T2Jhn/YTi/aB/ZkX9/V0Bf0l88yf5qupwr16j+Mve5eGYAkjemuou4EM7pka6YoiwC
         bPyf3H8r23ssbn6ygHGGY2iFyKAVzH69Gd9B0NS6ZQ6DacO8Etb7MDCnw1GJBpTLgkZS
         ZTZYJTY1cld49j1rDFd+Up+6K8ui3d5uXg+3JzfgYUbG2WAkioHRbWyL4gqV4OOXsoMc
         Ii9eFKbWCyzQDqPD+dVJI/BUcRJDyvsfF5M/p98NRI2PkRoD6aVpQsdEMIhG1LzSCzkV
         RAfwQ2dYIEsl5Uz/TI3UC7dGxcuutacVGeIu4DdVJ3odOORmkXt1uIQ4jcVF512Vv+Wo
         pHZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzctHkcBjttTQEBLppE9eD7q/4Cnz9p7IdSyMjFugAvcFhiMuAIOIOmEqJnaRenbCr9ZlA4/Qp93mh/@vger.kernel.org
X-Gm-Message-State: AFq9FYJcYG5sQ3dSkqfJh14PeaxY0wBf2+A3Za6vl/CHFe8YhzPZ4mxn
	e5WnhWq/7GEoRQIaRLizUEv3xvdXJioC1Mta5G0niM7+t/6pnB02+lpae/Zc8EaHA3kWSW+DlNj
	jxsoGgvW9CyXiBvLLrp+bKs8+cySKy1N+FwFfKRge
X-Gm-Gg: AYBFou1Dh7wa3ddhC08Nik/t2mJfCMoraffRZZNXK520q3KFmLwpGAM5m3hD27P12PM
	JxYNhKT2OZvh/iW2zKmk207GPYx9ZMC+MihIldAZCtkObBbq0y1yHWe7huKYeCLjWUPZ657VIvs
	HvuEZxImXLS5RsGhTRM3ypI2bSk6OfcsbofPDd1PA0xl3C58IO6gQxzcZR5ladL8U3SGCH/PMLK
	WsiyujXORK3/pLVu2XK0oWqMCcB/toj8ygbjQDPRxEdED+awXXuv6uAiLLDMEpA5gaNnQ2rjhWx
	BPuSRKob8/EHYyrbG5OJFCQbWnJkQSR3RJDaHCgtIBuLDNhn41CPPg==
X-Received: by 2002:a05:6402:a6c6:20b0:6b1:aa31:a627 with SMTP id
 4fb4d7f45d1cf-6b38ba0dfd0mr16268a12.4.1792122495231; Thu, 15 Oct 2026
 20:48:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261014173945.373295-4-almasrymina@google.com> <179209666051.434549.2929683677785392178@kernel.org>
In-Reply-To: <179209666051.434549.2929683677785392178@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 15 Oct 2026 20:48:03 -0700
X-Gm-Features: AclHuK82vYjG9iaKBiwqWzObGCIoi3MxPyudlxUnlS3qJQCEAcDwsenVdF71kak
Message-ID: <CAHS8izPxoA6fU10fSNzKkZHFrWingOgduWOoD7ywii2058GABQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/6] net: skbuff: replace skb_page_unref() and
 __skb_frag_unref() with skb_netmem_unref()
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, ayush.sawal@chelsio.com, 
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, tariqt@nvidia.com, horms@kernel.org, 
	steffen.klassert@secunet.com, herbert@gondor.apana.org.au, 
	ncardwell@google.com, kuniyu@google.com, john.fastabend@gmail.com, 
	sd@queasysnail.net, ebiggers@kernel.org, kees@kernel.org, 
	aleksandr.loktionov@intel.com, petrm@nvidia.com, u.kleine-koenig@baylibre.com, 
	j.raczynski@samsung.com, wang.zhan@smartx.com, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 1:37=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in ca=
se
> you want to address the nit picks below when you respin.
>
> Low priority / nit picks for your consideration:
>
> - [Low] This commit fixes a real refcount imbalance in
>   mlx4_en_complete_rx_desc()=E2=80=A6
> - [Low] The commit message describes the mlx4 RX error-path bug as
>   "underflowing the page refcount".
> - [Low] At this commit, the new kernel-doc in include/linux/skbuff_ref.h
>   names ref-side counterparts that do not match the code.
>

If it's OK with folks I'll just ignore low comments. Even if I
reworded the commit messages, the bot will find some other complaint
about how the commit message is worded I think.

--=20
Thanks,
Mina
