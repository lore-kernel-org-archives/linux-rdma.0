Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423678;
	b=VfjDcCle6NrMHP/F1GcgMzs7XNTuF6tLuLXmRRrlsMZ6W7p7sqnnWbfj4qxpxsymyh9v
	 wPNgR6fEYYiVpwTZt3UIJ/ZOheVo2oQWitrQWNpRa21Fk36iGd49BruUfsETW579H/KsG
	 KsChk5p70doNm7fuH8PX+K+n5RpeTTPXsVMSoSpBgwlkwczqMuZiCC1tHi+t73msu6PKO
	 6RCwNLyKWUKAvFWX1wk1jxQdy5muBJVziNgWkHdyz00CEE4At/dG1RjAUBpE2X4vwK4g8
	 AsYb0rWpfMGI4IFb4H/vEqaxkciykmUmy02zNgaQoKQJ6piAQJrJts98/L+SeMHqYGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=3mcdsvysa9luSuezEbeTLmuh15u7mjwAepQLZ7oOKD4=;
	b=xx6GRunQFy0Vvi+uG5lIdC8AuVhLVo01/28/Wso+xoZMXB+U2+xIMVmmvtSnCZktsOCX
	 hKJ4Yq70Ooz6TUlOi6mTRdFtN+1gVtFcHTYXxv7Qr4FWsy9tcvllHIV45xX4NkpFrqgBG
	 0ErXyCRFLLGI0RFlgtoe0Kwtf6ewgAQhkf3UgzfdKSqWH7AhNPsCJqG9SbvGXg6Q4LMrU
	 /ozZSpKYSlNH4l5i9/ERbhhmdGBuQNFoIBvz/8JV6ThlrcXw3USFvtGhh5MlU4PBfBrhh
	 4Y8FrjQTEnUGCcbaBb+Wwlb5iBDXQhlpTbsENh9L9LteIuwfdD5W84Hj141RtwRc0Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHkRigWs;
	arc=none smtp.remote-ip=209.85.222.181
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B79606A326
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 19:01:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41B79606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHkRigWs
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f1cf92c9eso337137985a.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 11:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794423677; x=1795028477; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3mcdsvysa9luSuezEbeTLmuh15u7mjwAepQLZ7oOKD4=;
        b=LHkRigWscoO1IXIQFs6/S7w1FUhRnu66lP+me1F9tp+woQK1t61v4UNNSyggqb4mOX
         hkOb5/IVXmfs4ZveeHLDMgbH2NVuzIEY/J/WPy/shFxDKAiXJz6IbXyPUV4ckFZ+CsC+
         c9gkmXH6qx8NuT+7knfat6nN41LKdJI5AqHmXOuhg18s+O76DdTa+1UL8roEbcvId/Ns
         kTG/VWDpa7xwT+xoPmwPqh3uf6iTwuE9zBLajqn7CgcAuA/eMNIzXPPLnoO373jqfflo
         BWXGJsKWiNERilvEBM6NM78A4lF9eT8HO6VECVYKCKap11URDX6Ewiu7J/Bp2B4VyeQc
         r7RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794423677; x=1795028477;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3mcdsvysa9luSuezEbeTLmuh15u7mjwAepQLZ7oOKD4=;
        b=2X/k/66e2ELPFOh77Vg6QraWImYCpaXKt1Of6wtkf1stisx+EF+MHIgu4Q7yuZlZRX
         XH8SOaUFm68xUt8xNqwEra6dvT4SQikXgWT3rSZ6YIpkzLrZRFmm95dSkakUUP7dVqiI
         p2u03qLplDFYcFYxFwnVQTOGGrOnMlf2OZf5XdGfar9n58lMtksupF61KjnZd3AUwa8G
         nW/lvQNiS/wkSC8/RS4JS/tMDLAkwtdB8znVoLGbjKx9vxFTa1mVcKRmqCGZSka2LnXC
         NTBioTHH82wWGT9+zwZg54OT9CMSdUSUKC76ApaW+WQ8D99MZiv1MSTmqPSjoH4sWmlo
         T/ug==
X-Forwarded-Encrypted: i=1; AL+hErGzErEp3xUr5K7qus911wsYDrMTMYWBxht9tKUr1fEddLqOrdPO1pJDtuJtRmvV/sV6JPzOdjuK1xgD@vger.kernel.org
X-Gm-Message-State: APuU4Z9XIShnZJbdIqy54mBfsuZjDqa98rP7viEvgnEce4VqLNTAXDkq
	jRxw+tBt0lvfaLWDdeKVwLFE6Fa4n7siloaTmqyoOHDMEQssR+fHAgyi
X-Gm-Gg: AYBFou2qbzVk+EnseaD6QGkYUqAnJ2C0JWZXAjAr6U9P6qgmj7r8PLKloLV3zLJ9GAi
	bKC/zQpX5aSTXIDMfclPEGIw+k57DdDXVd7zSDpBlzvbrbSvOl7yR3GM03fPgIVkzEBcDsiLR1K
	kh3SbaD1/0IjYW2skzpZZRYLBSBNcBZKktgBxi/y89OMi7irxQxkvii6QejkITajLkmuKX4y5yv
	o5M1juoojE6X3r5SYbv+FOJWsT+GsmvrKfxL9ujA+tBf5SJtFgBx5ndHAmDEYVxFDeG4Z2Lepyu
	0BqydpG4V8lYqUTcVvELIVGtLd/G+/VdAaRW85jnVatqebuv+U/AAK5/XFsCW4mX0zShQ/I/2eA
	uKOsVa/3GP3bDqa/VJTaqLf3eGvR26VDJq1ubmEBpnxrTmB2rJkntoPf+qU5ch8jTcEkc+0smbZ
	p3XEjta6wlobnPLvTqiRtvE6OvFs5yqQpqUmtjQWmA0rGSbkSvxAJNU+6fPM3UMjFzRRJo0EOok
	ErXcvT+H+tQeirjBLcnyifcjzwPZ7iZkH/f4fnEphx/2nAdvownrzwJoiVkH2rNBAQVS4OhOF1K
	48aJ4nn7mnMt/bPJx+IgmEUNBITxaV0jrulif7TwELc0SfomVEpL5e0=
X-Received: by 2002:a05:620a:2b96:b0:93f:53d1:54c7 with SMTP id af79cd13be357-947b00d141dmr521152085a.70.1794423676923;
        Wed, 11 Nov 2026 11:01:16 -0800 (PST)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9479e73b2d2sm545314185a.10.2026.11.11.11.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 11:01:15 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 14:01:14 -0500
Message-Id: <DMSM3RNRY412.1GXB07F4KGJYR@gmail.com>
Cc: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>, =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?=
 <bjorn@kernel.org>, <bpf@vger.kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Donald Hunter" <donald.hunter@gmail.com>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Jamal
 Hadi Salim" <jhs@mojatatu.com>, "Jiri Pirko" <jiri@resnulli.us>, "John
 Fastabend" <john.fastabend@gmail.com>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>,
 "Paolo Abeni" <pabeni@redhat.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Simon Horman" <horms@kernel.org>, "Tariq Toukan" <tariqt@nvidia.com>, "Wei
 Wang" <weiwan@google.com>, "Willem de Bruijn"
 <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v1 04/15] psp: add support for socket-less psp
 associations
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Todd Bert Freed" <toddfreed@meta.com>, "Daniel Zahka"
 <daniel.zahka@gmail.com>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-5-toddfreed@meta.com>
 <DMSJB8MZZCXK.MCEBRZQDAM5Q@gmail.com>
 <CADh2yMx8MPjcH7Bpj72rNNd_tT=6uSC5Ow9JyGjTMjFgs499Pw@mail.gmail.com>
In-Reply-To: <CADh2yMx8MPjcH7Bpj72rNNd_tT=6uSC5Ow9JyGjTMjFgs499Pw@mail.gmail.com>

On Wed Nov 11, 2026 at 1:23 PM EST, Todd Bert Freed wrote:
>> I'm not sure the kernel actually needs any bookkeeping at all for these
>> generic rx spi allocations. You could probably just pass the spi, dev
>> id, key, and probably rotation count (as a device key generation of
>> sorts) to the user without creating a kernel object. For socket
>> psp_assocs, the rx state is consulted on the datapath before queueing to
>> the socket. For tx state in all psp_assocs, there is the possibility
>> that an SADB handle needs to be cleaned up. Neither of those apply here
>> or in the rest of the series as I understand it.
>>
>> I figure the tc ingress rule can just take the spi and dev id by value
>> rather than needing a reference to an object that we create here.
>
> That is how it works in this series. The tc psp decap rule (ingress) does=
 not
> make reference to an rx assoc ; instead, it should have flower matches on
> psp_spi, psp_ver, and psp_dev. That effectively ties it to packets from j=
ust
> one rx assoc.
>
> So why keep track of rx assoc objects at all? Two considerations.
>
> 1/ don't accept packets that correspond to a stale association. That is, =
even
> if the device decrypted the packet, it should be dropped if the device ke=
y
> which minted the assoc's SPI is two rotations behind. For psp socket offl=
oad
> that is enforced in __psp_sk_rx_policy_check() with the pas->generation
> check.
>

I asked why we needed to keep track of socketless rx assoc objects. The
above applies to the existing transport mode code, which is my point.
The rx state from the assoc is looked up from the datapath. It doesn't
seem like that is the case in this series.

> The spec permits SPIs to be reused immediately after two rotations. So th=
e
> device could decrypt a packet with a SPI that is more than two rotations =
old
> in that case, or if a previous packet is being replayed, for example.
>

A SPI that is two generations old will cause and auth error on rx. The
hazard is that an old tc rule with a SPI from two generations ago can
alias a different SPI from this generation. Userspace can just flush old
rules before doing a key rotation. That is why I suggested including a
'rotations' attribute, although that is probably not even necessary to
keep track of which rules need to be flushed.

> 2/ hardware offload. the solution to #1 should be able to be fully offloa=
ded
> to the device. psp tunnel mode will be hw offload only, and is implemente=
d
> in the eswitch with connect-x.
>
> We could add a psp_gen flower match to replicate the pas->generation
> check, but the device has no access to the pas and can't offload that.
>
> Keeping track of the rx assoc means that the kernel can take action on th=
e
> "this assoc is now stale" event. Possibly by enumerating the tc rules and
> either deleting them, or marking them stale for userspace to reap.
>

I think it makes more sense for userspace to just get rid of the rules
before rotating the keys.=20

> -Todd

