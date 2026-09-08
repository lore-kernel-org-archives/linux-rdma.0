Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C024AD4AB
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 23:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788909779; cv=none; b=mxsYZp6toArOPLzr0f4I4DGxb4eA2hdSSECSmy9ZwTTPWJ+X1qJ/9V9AG+Q1fGmdVqL2tVyTsexwRNPn13Cj6caob4sXD49rc7nuGmr4rBUUlQ0r8Edi83LLGGBNJ4ocZZBWC21NYPkOUa+nmlt8IQrRQ0unKb18XmYt424oOkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788909779; c=relaxed/simple;
	bh=igRLaNLKATsv/xrFKZo/2BMOVmf77KFzzmgZ9es4sLw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=f5RIhmbEa5hn8Np1WR1jNDvnHgsr1RKdS30YajsSu+J03UN/i6c9tVhPT7gDiJit4Qe6WkJ2oECcharinWvKrQEakEwdSiuXFwng2yI3ctoxSE2LX31JLegsPcFcbW9yaxhllPpBEWTgxHA2JVwknARch8PHpuh1V/yVCZjv/is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nyWhuL33; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nyWhuL33"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-90cd96389efso64180816d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 16:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788909774; x=1789514574; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1ZsRUEYFwJyfqiHg/NlJRFQE2q1GaX7lbKCnVamDOJQ=;
        b=nyWhuL33Skm6TfcUD+dSxlZ/n9gfJWfmXjhfJ1dSskPEAa/y8Ro+sexe/rLUA5Q1h5
         lpTMGgdS/S20U0mHs+3L/w7olDMrM0eLsw5+EoW4GiwkAlHEUUnRkFHdAdtAv6dSWffV
         5spIvs9mrdvNnbHTte00jK16QceqvvCveKuTK/6gzzgUBFPE+00HVcYQz0QhH9w3p9mB
         Nadj4nfY/5olSMMsa1CYjp7VfOnxPrAZDlGq03/7EGOIMpx3190W8pJ2SldomUwD58S7
         Ek3ojiDY+IUczNKSZA5BW7aNrXJzY7yPQwRs412Kitg3wq57shDcsWdKk1ovg0KoDTeP
         W/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788909774; x=1789514574;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1ZsRUEYFwJyfqiHg/NlJRFQE2q1GaX7lbKCnVamDOJQ=;
        b=UT7lHb0v1GBo2oFxxLarPF5mX8HcbL8aTItvO1T3fP8OR/+LuE0d26tNcIonbcgX1z
         CvmJ7hmTNMaddzq6Af/LgTOEh866EpQKh4UiEEPHDwc70byb1tntlCmcNxJyf+vy5b40
         b/6EcTbLz0jGdD8F4SPrgqC86FDKIt5z8AQPGDQJvthwlHD7NpddESDABY6oxVFxjU/P
         c+AIDQe52CvmgWpPnRZmcB7kDzcg+CiRFkS56UUq8u6dTk/Bd77+7dCEGV6dfJxmOt+k
         GGh1UQZ5pHPR3QgYuoHhvbhgQxL/bsNh1bVJ+uFmlF3Uifz/CYEsc9d42SwSzE7AYROQ
         ej4w==
X-Forwarded-Encrypted: i=1; AKwUvBzMKph9xwvxw5RqhqiUFI2y7zJ+dUZKi/Vo7nM9TNteXVUtBG2gHtxxr7vkOYXFin5lEFM6uphMmYnf@vger.kernel.org
X-Gm-Message-State: AFuF++mcTvt6OMRvNojfyC9ZI/ScIipFUfYuWH/WPKgEjhDx5ufTf4H2
	aYvmJvWIln8UiV+pZoUFjO/Sr214hRGIaVdtVPIRJ9D8S7u0a9W1Zol7
X-Gm-Gg: AYBFou0f6T1v0SdbpLT9+c/IYK8kSiqtgS8T92qdCOfi1J9eg6WaN2oWnTr609plo5P
	2KCHXIyNspsgN79qnYxl34eByZgRsp2GdfUFUnc5h7WebGDlj+TwStiIMBVeYqoE+F9p9E6b6+l
	Ylg7EQnvOyNcfehgmoohmYhaLVIQCojU4J0hE8u6r3YReQM1UW1YecEmN44ROoQPB+8Ank965R9
	923sjM34iqdzBeGK5WUX/SofGprFUcwyBxNoPfwlXe8AEILd9yyAanHM+AVR5ajs2HEA9HfBxSP
	vqFvSEeTv2E5BiiLYYRC9WyYvcv0miN/9yBKNWEHtpAlXjYRI4lJBdANO7MrwkkJQb/ACP96Mhe
	Oi2Zqo6OtGOaX+kUDxuqalou5r07qndyTbjAtT30C/r9iERdI0h8SqPgEKTViUIQQk7PFuf9UUb
	q92+kaZ7ZqokjFOny1pHZzU0/9Nmyj0wWE4882ynBbhH4y5ZBwKfLVRNcRzIJrDqcz3w==
X-Received: by 2002:a05:6214:84cf:b0:90c:e685:d0ef with SMTP id 6a1803df08f44-9103eff8ca6mr419740676d6.23.1788909770512;
        Tue, 08 Sep 2026 16:22:50 -0700 (PDT)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406b0f51sm128531996d6.42.2026.09.08.16.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 16:22:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 19:22:48 -0400
Message-Id: <DLABL6GQC9HK.2P8KU1JJRO1XV@gmail.com>
Cc: "Bobby Eshleman" <bobbyeshleman@meta.com>, "Boris Pismenny"
 <borisp@nvidia.com>, "Carolina Jubran" <cjubran@nvidia.com>, "Cosmin Ratiu"
 <cratiu@nvidia.com>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Doruk Tan
 Ozturk" <doruk@0sec.ai>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, "Jianbo Liu" <jianbol@nvidia.com>, "Kees Cook"
 <kees@kernel.org>, "Leon Romanovsky" <leon@kernel.org>, "open list"
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Raed Salem" <raeds@nvidia.com>, "Rahul
 Rameshbabu" <rrameshbabu@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Shuah Khan" <shuah@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Simon Horman" <horms@kernel.org>, "Willem de Bruijn" <willemb@google.com>,
 "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next V4 14/14] selftests: drv-net: Add PSP HW GRO
 conformance tests
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-15-tariqt@nvidia.com>
In-Reply-To: <20260908065244.3799142-15-tariqt@nvidia.com>

On Tue Sep 8, 2026 at 2:52 AM EDT, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
>
> Add PSP conformance tests using the same gro helper binary as other gro
> tests , but in --psp mode. SPIs are procured by psp_gro.py from a real
> PSP device and handed off to the gro sender & receiver. The sender
> crafts and encrypts packets in software, the receiver relies fully on
> the HW to decrypt, decapsulate and do HW GRO.
>
> Because the NIC decrypts and decapsulates before the frames reach the
> receiver AF_PACKET tap, the gro receiver sees the plain frames and the
> assertions remain exactly the same as other gro tests.
>
> So these tests verify, at length, that the device does PSP HW-GRO the
> same way as plain TCP.
>
> Additional PSP-specific tests are defined to check that GRO doesn't
> merge packets across PSP versions, SPIs, encryption-status, etc.
>
> Some gro tests are not included because they don't work:
> - ip_csum: the checksum is recomputed by psp_dev_rcv().

psp_dev_rcv() isn't on the hw gro path for mlx5, right?

> - tcp_csum: packets are marked with CHECKSUM_UNNECESSARY.

this also seems strange to me as the hw gro engine and its decision to
coalesce two packets sits upstream of this skb->ip_summed determination
in the driver, right?

> - ip_frag4/ip_frag6: PSP is incompatible with IP fragmentation.
> - IPv6 extension header tests: PSP doesn't deal with IPv6 ext headers.
>
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
...
> +
> +@ksft_variants(_ip_variants())
> +def test_psp_ver_diff(cfg, protocol):
> +    """Frames from two different PSP versions must not coalesce."""
> +    init_psp_dev(cfg)
> +    if len(cfg.psp_info['psp-versions-cap']) < 2:

nit: what the above checks is slightly different than what the _run()
below uses, e.g. dev supports versions 0 and 2.

> +        raise KsftSkipEx("Device supports a single PSP version")
> +
> +    _run(cfg, "psp_ver_diff", protocol, [0, 1])
> +

couple of minor comments:

Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
