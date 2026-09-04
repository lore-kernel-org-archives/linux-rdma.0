Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E9E34751B
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 13:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528311; cv=none; b=fnU8vCsWO/qslRBsAyxFvvQbmYhoX74ScXJGG2Yx6H1FsUt2m9rQD4KnMF9RjJ0wruYf8nPY3jArDlHkq7F/rdowBTGR4H9LqhiJma8fRAdnpalKaW+jizevPZ1a5AZ6Vqbd3EqNuplFRCgx0004SXi7lTfgaG4jXQrP7zaX0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528311; c=relaxed/simple;
	bh=7IrgWckgLXmOp+bSbt2l3lsAkLznjIprg/+l63INEHk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=hHtp9LMjNFlltXcAR/JgKfkccjEMOViN0beValOYuxgIH1ADUd8BdydpEW3cPlnTW+b0axEz3dftlvkCRFE6MFED8XMLX1wka03N4FvXSGJts4FMjWpYVrqf0BXJ2ZZD7MR6Y7/GwjWr1y7xR4FYuN+Xd6PloTfGsOrZFkoRiMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khDIjVyV; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khDIjVyV"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8200b55dc47so12012587b3.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 06:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788528306; x=1789133106; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EUxRc34t0qU8FOfG0VqqQu2j6hNUb8g29gyCmIO8xCk=;
        b=khDIjVyVBMuvj6FrPJx3RNHnrQang80z6YdC0mcZS1MgLsgIZ/R0fulxYeb8ND6YoR
         XE5Xnx0+r1p1pGjH2OelHZ/plO0oDMPwsLa5tLEOOs2urSDx02E4dq9PAEVWwFqnDiKh
         P4iG+0toT7BOexLmeI5lqkasmVlXJ2IQvJwDEfj1TLBeFGONT5Ei0Ls5KK8NYohUiGwR
         PO22wpPZQGhRasAy1l9JCbd/co1zLbuEWu4T6NgSj5APmatage68rjy/rIlB4xZ/SbR3
         YYLMxrhmhv8xuX+TENhddec/exV2h5S0m3lzfGUXiHE58FP5DUm207tQaTthZFzx807/
         D1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528306; x=1789133106;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EUxRc34t0qU8FOfG0VqqQu2j6hNUb8g29gyCmIO8xCk=;
        b=fcrVUG6i2lz6O6k5GSAIzDpE3Ad5iTmVEuveSHznAtMXp7SP6mLTYGJttno3fTSmXg
         4rrFp/PIpFAqMrFt/G0X43xJf2m7mwIU+524YnJhnOWueXElsTiOnMBiWY5avWTw0ghQ
         yYqONc3E0CjChTLO42dQ0sWQmhNMzCxBpt8vmWikakwNu2YKA4eTRhPvfJZw3xxTiODn
         Sw9WSVF5qMrFiCP71yTWnHLADe13VnayO5Ib8NrfpVegWXjhBoHbQp0Th8jZ7XDQ6Bm7
         C5muVZdOVwQMkvB/2wl9UhrbtrzpPXZ/IMu6dsDRWwVJmmgakwwWw/2wW6sW3IPnbfWB
         QypA==
X-Forwarded-Encrypted: i=1; AKwUvBz5cW1jFmqILj6UqtEOgN73aRYZWvMcCPoHy0XCF5CS7gmkNYEw2aVKSadfdv0kfzWDFC1L11bVrRir@vger.kernel.org
X-Gm-Message-State: AFuF++n/KRKnFnQcC6wuzsQQogba4EHVwAsM1MxWXfybrpivcETADnEt
	Em5oSv/PNJx0M8PLHzGIpb7Yaf7gfvN2lLXshwnkITNWdlHWedOqCEJa
X-Gm-Gg: AYBFou0CveHWCi+IJTVfiZA1aaNfx8yybgvpREEmK2bpSbpC6EZTlQkXCdwQr4rhlUl
	UyeZ9+TPOcWS83y/tp/9v6NAkhEJft/eyT5GdyYcfaXO1r3PGSaoN7B9S9gvwm4zYndMhujBuFP
	xiRyKEsarFhovOFcj6P0xxvpYGYqxa53+5jWDvGHzFF6YX+8a/7n3Yvi8K5DIO4RAHFLmUvn02j
	nFblJmFRdp3O/HSBkHZMZJSjIfZ+BClivz+5QA/2OdvIlYMXLSyn16GvS9kFNKI2w4CB8Z0JHZU
	N7pJzgTXm7tBw+22q8e9eWsKLfMxbd4mYGtEtUkM8FOKyPAucwYqNh5kn9zaodkdb2ohCeuU9qE
	D6EiN0CBQIqEoOMqbX9Q5qRa3R4MEwiVT+C69/YRlQ/tnKUZsV3thChOPV967r9/LPbzP+wFMIK
	RE1Yg9HolZ8QzMRNKXvWVD5OTHLqzb1e94syC3QMBdHT9uPiRbIig+Hi+gElhT6AelKg==
X-Received: by 2002:a05:690c:dd3:b0:873:5c6b:a2ff with SMTP id 00721157ae682-8735c6ba63bmr2923997b3.45.1788528301340;
        Fri, 04 Sep 2026 06:25:01 -0700 (PDT)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406bbb79sm20079006d6.47.2026.09.04.06.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 06:25:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 09:24:58 -0400
Message-Id: <DL6KD9FKLYQ8.1HD909WP9YA21@gmail.com>
Cc: "Aleksandr Loktionov" <aleksandr.loktionov@intel.com>, "Alexei Lazar"
 <alazar@nvidia.com>, "Alexei Starovoitov" <ast@kernel.org>, "Allison
 Henderson" <allison.henderson@oracle.com>, "Antonio Quartulli"
 <antonio@openvpn.net>, "Anubhav Singh" <anubhavsinggh@google.com>, "Bobby
 Eshleman" <bobbyeshleman@meta.com>, "Boris Pismenny" <borisp@nvidia.com>,
 <bpf@vger.kernel.org>, "Carolina Jubran" <cjubran@nvidia.com>, "Chris Mi"
 <cmi@nvidia.com>, "Cosmin Ratiu" <cratiu@nvidia.com>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Daniel Zahka" <daniel.zahka@gmail.com>, "David
 Wei" <dw@davidwei.uk>, "Doruk Tan Ozturk" <doruk@0sec.ai>, "Dragos Tatulea"
 <dtatulea@nvidia.com>, "Gal Pressman" <gal@nvidia.com>, "Jacob Keller"
 <Jacob.e.keller@intel.com>, "Jesper Dangaard Brouer" <hawk@kernel.org>,
 "Jianbo Liu" <jianbol@nvidia.com>, "John Fastabend"
 <john.fastabend@gmail.com>, "Kees Cook" <kees@kernel.org>, "Lama Kayal"
 <lkayal@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>, "open list"
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Matthieu
 Baerts (NGI0)" <matttbe@kernel.org>, "Patrisious Haddad"
 <phaddad@nvidia.com>, "Petr Machata" <petrm@nvidia.com>, "Raed Salem"
 <raeds@nvidia.com>, "Rahul Rameshbabu" <rrameshbabu@nvidia.com>, "Richard
 Gobert" <richardbgobert@gmail.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Shuah Khan" <shuah@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Simon Horman" <horms@kernel.org>, "Stanislav Fomichev" <sdf@fomichev.me>,
 "Stanislav Fomichev" <sdf.kernel@gmail.com>, "Willem de Bruijn"
 <willemb@google.com>, "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next V3 01/15] net/mlx5e: Generalize TC <-> IPsec
 mutual exclusion
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20260903085215.3691657-1-tariqt@nvidia.com>
 <20260903085215.3691657-2-tariqt@nvidia.com>
In-Reply-To: <20260903085215.3691657-2-tariqt@nvidia.com>

On Thu Sep 3, 2026 at 4:52 AM EDT, Tariq Toukan wrote:
> -#ifdef CONFIG_MLX5_ESWITCH
> -static int mlx5e_ipsec_block_tc_offload(struct mlx5_core_dev *mdev)
> -{
> -	struct mlx5_eswitch *esw =3D mdev->priv.eswitch;
> -	int err =3D 0;
> -
> -	if (esw) {
> -		err =3D mlx5_esw_lock(esw);

This appears to the last caller of mlx5_esw_lock(), so the function will
be dead code after this patch.

> -		if (err)
> -			return err;
> -	}
> -
> -	if (mdev->num_block_ipsec) {
> -		err =3D -EBUSY;
> -		goto unlock;
> -	}
> -
> -	mdev->num_block_tc++;
> -
> -unlock:
> -	if (esw)
> -		mlx5_esw_unlock(esw);
> -
> -	return err;
> -}
