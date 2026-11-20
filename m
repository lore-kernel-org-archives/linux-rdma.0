Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795192747;
	b=FVWlbj9K1QHDRMf4CNUCn4Z4RHjCHezhlAEeNy5mh6L89QM5if89mnimwN6YRdMnZKL7
	 rpxVkBEZHHo23Ul7S7mVnM1ltWzmKsupSBKZuXHHF/6RVB/G+Nnjf4V/iy25AMYxyjFNS
	 EGaW06mf5qDfmPOzaUNgsguZQTOmv2po/TVLP3N8jnZv6uVugF/p5WrrCl6IcL/+8KjuL
	 4TYAbj8GeKTcFTKA75thm0AA1TSszIwNmaL6+aCCX+0AAQRxdOXwQ1+16xVTL4oLsprfk
	 DNnxG0qjR/8/M3nTjNzDy7ENtvvO4ng+OUI2DL0+NHrPJJzbL5OjHtDyxY8g+imDmdg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192747;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EhyQZs78XQFN3n2l0teC/H+aO7J33z3X0XEI3I1dEuk=;
	b=QCFxknWU/CTpAAHeEqhEmhQNCb/Shnz1wrfTMcoRKsklXOx5iNYqWmiEdeB94a0QpMm3
	 07hczp8UaaOzwM/RJgr/v+3wAvU7qe8VF06CZGNXyRAdx56RTt2KVImNU+xJIzg0B8BDw
	 iBG6HeLVUZLxiO2XVXaZ5onGKCDX0WNv5NpY5zDlbgSNX1ROr9LS5/PshKeZBDihRKspZ
	 3MVGxlizkYEuMo2ZHXTIMevirmYIhSvKP77+QDmYpoR0o0Ui+2B1YtXIMS2xqWcdsTBEw
	 yrosVMWNNTOXWr7zcdESjcshE7zVu1e8UiyYA7AGmRgjbsfSSFdF8Rii0p/VBvy08wA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=exBV0BpG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63E7606A320
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 16:39:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A63E7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=exBV0BpG
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b869ea8224so14918a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 08:39:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795192745; cv=none;
        d=google.com; s=arc-20260327;
        b=WoMyklCC1fPFpnx5qor1GOS4vWhSr6HXLjzQRHeMQhy9b7QG5uiwG8VtT1rdQtoM3I
         pIRRKqVPvlWwvxl0hYF+J5yQ+OvJ2pRzobmW1qJSxm090HPEsXw5xUkAsQ8Z1V31qjtf
         nPK78org1S+Yi7Q+vcEXLGsdb1Kw/Bc8DXD/1mG7FWOLOru1NdiCyJkSNG0UsSBhzS2a
         Uk8CFT7ky/Hi8K3E/AhDV7y9WWh2BsqA9rCg+lpy3k7uigMnRpRpBe0qdB66eUE/KLKd
         rVkljm/KePuHxJ+2ypPzI4pmAHZz/CC7S2iskC2B25w0Nkqu38woSXzRAo2bmY8QFTuI
         gr+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EhyQZs78XQFN3n2l0teC/H+aO7J33z3X0XEI3I1dEuk=;
        fh=RFhxTLRGGT2Yju/D9TGxQLJ+oPkp94xZXOLm2AXrSGA=;
        b=YJ/ffXgWSGQdJ8wIFpFhDfee9enM9091M+K578ATOiP5GXewrVtAATJhQKAl77h6s8
         +rKL0tPszKLW7Ko4j32Y79mv63WW2iRHakbtkWkhklv/AiEWCRAFIpFYHkRQtnAidyS+
         LmsbHNItLeCRdp1hF/6etTvo+nc4Tk+flCTmb8a8heKBeAOgiqMIW3uJDyPiMg7YN6vi
         gmBkzLJ2JKKZMBdUqRLY31gqc19PyjfPihVYnC/EDU5vHKUv0kPaZOMPIaoYysqMX2fG
         5xVneRqO2gdN7n80W23ZWJ+NHGjKvFzOJv4Upi47BWjOwcD4uAjCnj4tk1Wg2cbXa/20
         M4cQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795192745; x=1795797545; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EhyQZs78XQFN3n2l0teC/H+aO7J33z3X0XEI3I1dEuk=;
        b=exBV0BpGps5XdMiPxKLol86gpdtksfxwUBQOPNI/CX+Vjag7OL0AUTtUePEOEP8WrI
         RUlzfZV7tuY75+XXDgA2FE996IdeAwfOOQS71YLa3PVsYS5lYtvNykQXpLbu2IIk5Xo+
         a8hyM88U/z9KAR34tZG+Af7cXNA9wfKV2vvz43XNigXc3hnBJvtspPOn971ezY8WhRYk
         WGT7FhtNaw7YsBotMKoktHlPZY9bmmEaGf319WakY49a3oR3EgabQSfSpsLo6R3n4vGN
         xOyBFLseGL/E3NrU51a9p94L/ZXXx3Urm/HtJqUwhfNw4+eQb6KkyPFtmTNtcDHwyTsL
         BL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795192745; x=1795797545;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EhyQZs78XQFN3n2l0teC/H+aO7J33z3X0XEI3I1dEuk=;
        b=nJUhdun6fKKp7E1ggO/wXiIHn/tskUUCI/BQ9DZkSLrjC7SnRbRDHS1OxLerRiXlZG
         Wmcz6zbkN42/rzHELSg5Pp4cJFgewPxj8FZdfXlf426kg6RgacqJu0BesiCz8GZxwVeH
         caEVc/mY7GRwZZqyS2YymHFQ60ED2u1NNZv4glju5nzQoz5yocY/f2IVBN6UwjnP4EXH
         jB6AnFzr10e8j9A4H8G50FrRCLUHy/kKJMy44/bpUrPVvGiRZXZ4nrAbLx9BROQag1Ev
         M0aPTbA4UOaaB/CQhEzzFYQTE42FppEBZMoZ31ukukT3nroYeftIsnOsSgLwAVCwpb0+
         gGxw==
X-Forwarded-Encrypted: i=1; AL+hErFw26Pe0uvvqRBXuqFsAIBPQOsVzbFZYo9yHDlUGRINQon3hKPK2UEkFcFN87FS5Oqid2FbdMkpOkm3@vger.kernel.org
X-Gm-Message-State: APuU4Z/1z6iuV/q/TQp2X6m9zua2vIxmx2JVBlRJCzxMccEql/fILRpm
	jSe4FvaXz21D72QrCeS6cv92HZSQ8gZEExe99X7O5dsBFtNaP0Y/tKr7bru7FngGzkATzOJRyzT
	JohnoxDEVqNrc2ZGlzfBCzAsNwbSLNLumGC4LBVEY
X-Gm-Gg: AZFdTZdzQoNjfHzhi7K4iA7BLLSr3aBi6o2X1J4F01gxkMxX7I4dGrCAN0lnfyy7PmF
	TNyS05NSQqif3kwyTaHZGKafAnh6cx/HLIFfmUQqg9pF4JibtCXUTv6QCtmbk2lvWZSFVGWUg18
	d+rPHFDiLr8rRCp8/c5I4V7nuHB2oQI08Cgliblu+nO5MXq4hOOjlfsziiLe8P4Vsegjmeu2b+t
	fqcF54QifEX/w9UpyKnQgFV80TpOaIjJcw8wga0+19vc7i2IRVf6TLbVFToz2vEUy1jYDiAxqMq
	A0li4wfKWipf/Bb3MSiWjKd26+NIZooNopziNSUPzm8cFOj+qj3PaYgaHFMaOHMBJ6YaePTRPw/
	pf0bZm420CVIy5/Sz5V76yl8XR2lj9tlW9PzVLg==
X-Received: by 2002:a05:6402:c4c6:10b0:6b5:77a4:e7c9 with SMTP id
 4fb4d7f45d1cf-6ba38153010mr103871a12.2.1795192744560; Fri, 20 Nov 2026
 08:39:04 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110183826.2927274-1-tariqt@nvidia.com> <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
In-Reply-To: <b5305251-b758-45cf-a28d-406b04d8bccd@nvidia.com>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 20 Nov 2026 08:38:52 -0800
X-Gm-Features: Aa3M54qvoBN2Yfkw1kEqj7wTtv_eM2s0F8mqRYMDR_EgYh3FvB_9-0cl5hbrfvs
Message-ID: <CAHS8izMhSVabXgMmNbHHLm8cYqW_EVQbpXME2z_tUEJuN2BTnA@mail.gmail.com>
Subject: Re: [PATCH net-next V2 00/13] net/mlx5e: Add netdev support for data direct
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran <cjubran@nvidia.com>, 
	Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, 
	Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>, 
	Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Matt Fleming <mfleming@cloudflare.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 6:39=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Hi all,
>
> On 10.11.26 19:38, Tariq Toukan wrote:
> [...]
> >
> >  .../ethernet/mellanox/mlx5/core/data_direct.c |   9 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  14 +
> >  .../ethernet/mellanox/mlx5/core/en/params.c   |  18 +-
> >  .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
> >  .../mellanox/mlx5/core/en/reporter_rx.c       |   1 +
> >  .../mellanox/mlx5/core/en/reporter_tx.c       |   1 +
> >  .../ethernet/mellanox/mlx5/core/en_common.c   |  38 ++-
> >  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  67 +++++
> >  .../net/ethernet/mellanox/mlx5/core/en_main.c | 253 +++++++++++++++++-
> >  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  33 +--
> >  .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   4 +-
> >  .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
> >  include/linux/mlx5/driver.h                   |   1 +
> >  include/net/netdev_queues.h                   |   1 +
> >  include/net/netmem.h                          |  24 ++
> >  net/core/devmem.c                             |  85 ++++++
> >  net/core/devmem.h                             |   6 +
> >  net/core/netdev_queues.c                      |  51 ++++
> While working on V3 I realized that keeping the core part in
> this series is not the best approach. Initially it made sense
> because the change was small.
>
> I think I should re-spin it in a separate series with netdevsim
> based selftests for the new APIs. I would base it on Mina's devmem
> leased queues unregister [1].
>
> Any reason not to?
>

I honestly wanted to comment that you should base it on the leased
queues series from me but didn't want to be annoying, especially
because I made you wait for the previous series.

My series creates binding->bind_dev, and binding->map_dev, and core
will (should) handle things correctly across both devices. This seems
perfect for you, because you have a bind device and a separate map
device and their lifetime is different.


--=20
Thanks,
Mina
