Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F804E50CC
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791553426; cv=pass; b=Hm5Ohwr7TAUPMfI7JJ2GpOiVSN2xab+0Io8ona9Y+G7BVoIGlnAlKDyp0f7Cx6E1ajyrDOC1E3mNHE99poruNMy3ZcmtC2YpCzXJ7y6wPzPbEvZ7p8KXoqJs3E26kW3yq0MMPMcTyURH6N6EcTo3qUQy2Kovq6rocNKctjMhgKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791553426; c=relaxed/simple;
	bh=LQYO10lBY8YucsXcJTd6r+9tll/gYfDwC9yXCQh2QM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gEAHMTyDca/3kJz6sauXFF7bdheUeQL0khFNUh06ImxoKznyH/TMc5cYfW3tpF3C501HCnp4S2dcBoHRREaRu0XKgHq7YzaU74uujfk7Gmu2qyAfca2QoNbqiPNNv1kqPBgiLeX0tL9IiWjtLFGRaccNKkjtR3HWjPCoZZGtH10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=KK/LlfF5; arc=pass smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="KK/LlfF5"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-354ba08cfd1so680661eec.1
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 06:43:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791553423; cv=none;
        d=google.com; s=arc-20260327;
        b=CgUDk7LrCl6b45SNE9hpTUgmvS9hQnY67GOodb19VeS250kuGmEM3oLDrmELLfOAqJ
         EkvTi3zCE0k6cV4xz7oOpgNAlxhpb75gESJ3gVUZFJUxMqxCHeztDqyi9tb+0XS4K9TU
         xis/b7t/ORRsiduD1NUcNWg0SMyfZAb3SWrv+mQwfmO+omccDLGZctaDseb1BuIDJzax
         WDu1tO9Rt+WrGHCt3FHf/8k8o7oj7Wey90C+Tel0z+Cg6/SMxbcsguXrXc/7Ub/x2BSp
         nT9TTkuQgct1K9pQLo53cpVmflT/5HyYqoDNLYW5bgubHctKcWkkNXNBMfDhvAauP49+
         x3fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cr53QXzLPPnzzAYL9+Ow9RuREkmHHvveZLDzlgyx6as=;
        fh=kwzvxOSiFVlX11UWP08fDt8HMkrWmIz3wCWrTrzMvzs=;
        b=H49fRU+RS+8ZhiPVIKWpwe7NEyZRSl+cbNN8zpgruJ0b6v/zRYGURhPKV455TCNwK3
         SsxJih2CXWqgnSbC4+CvHW82N0aelYc/XJSAfSlmHKwHd5f/c+CQ6UVJx2voeKyjeBMD
         kFB+ZqAiakbhVjWFtvGEHSveRt7CHNW7qi4ygmHlF7CDVdPmhMt1lbcx+3Lm/mJsfHgw
         VHS6xYx/nmgmPwgwJDNMOSR/LgVp9STnil8Ax4ed05i24QoC6uLcsB17A5zVH+T0D2pR
         l0+jAk1h0hE1ckf+K2a7+nvO80WhIEZCBItCdc0zK+9j2m2DfXUvROiLH2AkENLGpJeX
         5nsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791553423; x=1792158223; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Cr53QXzLPPnzzAYL9+Ow9RuREkmHHvveZLDzlgyx6as=;
        b=KK/LlfF500M9HKvvEgwUZaMtwopK0KJsc7zlInv3lmgORbkZwrgh1WDGJoxJHLO40o
         pHVo62d91gMPpJ3soaq1BiMrYr0AizMjjPyqCIBkIC4w7gjHvTfLXybRAUnI5Po67+ie
         n137UHeoo/KUHK5CaLCeN98pBwDFobrzY5qzA/8N0CnbljkinGekpq6jiakTio/VeKRu
         uZQBtUFGx4xjW+G3Qg29Fz00i5EgI3yHysYnN5n5UAl/a272zYo6fcBrghJk14YL9/ot
         Spbh2FcFdSnRMUlw5oad4QAPXxpc2UICU9dzngX3csn5Koj5Xd9VcWaEv6Qq+EplAiAf
         BntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791553423; x=1792158223;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cr53QXzLPPnzzAYL9+Ow9RuREkmHHvveZLDzlgyx6as=;
        b=L2nZTXp+qnal0jwokDGzeLA1P5Y+ysQBZWgQOuUwpBXwvuQTf91WxSfsrvPzWXmqvY
         DB9px4mXtuP3z6GXgJV634PKo0oYoCKQFhh++XNoJdHlqbpT5NKdkmvepfeZDGYILGl6
         519DvkBoCIXkhA1wUphheKvhyXvDyE+tbmKbg/D3ygB3LGfRxsEriBLC7DeB2uqp+Rv3
         KWKy+qaUVwX71ImeicuLMHdDuXS/UJIrvXbxCWGnrdfomiVTzY4WR7YwE2YJuMTI36iq
         v9jZZ4db6hfxSiAaJrnQAF8of3L301WWCyBjBtrg+ug4n7U/S2GhMDXTBx5qQcDzMZIF
         5FRw==
X-Forwarded-Encrypted: i=1; AKwUvByw3MME7g882XFyFHNOFLRhFLeiKqGB52dSIkeWzF9VxW3IO2XD5s5VXJdU6JLvc3YuSUjG71K7J19k@vger.kernel.org
X-Gm-Message-State: AFuF++nR0y7N2hiPGXn6eVmGs1KT6i/Y8Y+pYBplBt4owVuS78CdbpLl
	fs9K9ExQWyjXhlEcJGrAbUB7BbwoR2/YnzfZ5MT+MbebcbmhwL81WIE6rCv5G6htZrqdM7IkuA9
	ZTMfHgX0qJtOWxfd5WCtAnHS54ytJ2oqB4pfHFCO9EH/iffw1lqbDQDUs2Wcd
X-Gm-Gg: AYBFou3CVvOJbMe3cgeDbItmn/LqlzoaImop/Qd3SZ4YxDxkT5KebRyRSBvc+mtPriP
	h9NVGBn9thNj/VmfWk2skHPRXYIWDqJHrkIHJtf2mE93MPksowvaCB4iCWzGtiq+x198MTTR5iL
	0X4V5TiMwHHWTd+ShxGzF3m6n+AJGbmH6hixW18lt04by8IiSn4x5ABnaIs4FVdFrcmziPNjqA9
	p7U6u7Ma6fN9AZf2cvwtPuUPsXnr5h/cT5qvFmydlvN9QT7wrALdrzswN/wUP69ABhOICH2nH9n
	qZOH4Sy+UsGUs73jhWdo3mOLrA9UWMSDEoMyrFMuGqos5EHRh6FocptlDMA/TWkEngvwwr/pya7
	CSC745JpMmPqB8Q==
X-Received: by 2002:a05:7301:6e98:b0:33c:e74:4624 with SMTP id
 5a478bee46e88-3537e112919mr2778982eec.27.1791553422908; Fri, 09 Oct 2026
 06:43:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008141131.0ac356dd@kernel.org>
In-Reply-To: <20261008141131.0ac356dd@kernel.org>
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 9 Oct 2026 09:43:31 -0400
X-Gm-Features: AclHuK9i2kH_QiKyGXflCaQStHSk6ronnlxME5kUtzkQ0rs0GpgdrjH4gnmAJRI
Message-ID: <CAEzrpqfgBrvwy0Q_AX8X1s3ogq3g1U=JmpqHAM8QUmMHAqWPsw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/10] net: stop calling __pskb_pull_tail()
 from drivers
To: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Manish Chopra <manishc@marvell.com>, 
	Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com, 
	Shahed Shaikh <shshaikh@marvell.com>, Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 8, 2026 at 5:11=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Thu, 08 Oct 2026 21:02:47 +0000 Josef Bacik wrote:
> > v1->v2:
> > - New 1/10: skb_drop_empty_frags(). xen-netfront, netxen and qlcnic
> >   relied on __pskb_pull_tail() releasing zero-length frags even when
> >   there's nothing to pull, which pskb_may_pull() doesn't do (Sashiko).
> > - xen-netfront, netxen, qlcnic: call skb_drop_empty_frags() after
> >   pskb_may_pull().
> > - skb_drop_empty_frags() checked with a boot-time test under KASAN and
> >   kmemleak, on cloned and uncloned skbs.
>
> Please keep in mind that we ask people to limit themselves to 15
> outstanding patches per tree. You have 18 right now.
> (200 active netdev contributors + an LLM) x 20 patches =3D=3D insanity :/

Eesh sorry Jakub, the skbuff BUG_ON() removal series is the more
important one, this series is the followup so I can finish that work.
By outstanding do you mean per-merge window or once I get
notifications for things being merged I'm good to send the next batch?
 Thanks,

Josef
