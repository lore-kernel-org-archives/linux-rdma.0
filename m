Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478519;
	b=Tmg203w5OUCTP0Os0YDoPR5R5YdPIaLUGs8F7q6x9VjxlWj0QdugwUGaqBFADoFTFCk2
	 tcx5/yboOoZtAFD9y0jdXjrNLjsff6CSGPUtzvqgxyfVaMkcPU+TGpd6REKJr6UbWQCwY
	 8v34sz6KmmZ/fxKrEuN9Gu4OTdAzqyVXQTsyYypb2Vcn640Pl6cThZGiUtKhSDqIMsg4+
	 AxuCaf7F7LsGzxxvMqOVXMDJAL1236P+QY+qwdUXn8yLcvYVGE/hePilgnfWNX8okhn+p
	 UaCbkvJuI2C987dkF3Oi7wgpj5fZwCH4/uhZjrqGMc1A/ie+GSQxHOF5ml3RPHPsYIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Content-Transfer-Encoding:Message-Id:References:To:X-Mailer;
	bh=/1Q/PUELyNwj2qbyBRmSt0cgWWpENEFwGaSV2JeSfBc=;
	b=TwW44oPsxRwty8UiZitST4b7kjGamvB6cDRuFjIEMWW3lvKrd5qBdNOinws7HMc04X3X
	 bK3AlsGPdzQf3gEToShDhxbDdnNnacY+Sy3ancPDmGiUt/mt7D/QLNtjFT53h+JNZpAiY
	 jN8b4pWzaJs2ycGyn9gn+VW9oLsXiThrgCTpLTevSdxnvkdc93D0BnoT8FdslaAknmJKZ
	 DaDpcFok97/o4cuGkE0UokRRA+VjRRD06x9wNkH3POlXIx/KfRWyGdW6bqoiIoNddSN7d
	 ofbMYhM5huK6lucH0RJAIFjDj3OaGkKk1mfTpcsrrGHGwwSvS0mCM5mYiIYmZrgKDSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o28cZZr9;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732BA606A880
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 10:15:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 732BA606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o28cZZr9
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4b4571ff080so45224545e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 02:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794478518; x=1795083318; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/1Q/PUELyNwj2qbyBRmSt0cgWWpENEFwGaSV2JeSfBc=;
        b=o28cZZr9g9jpgYFv2IkAdXN/FB30Ic2Om9QMaoI9ptc/Dkeq/fsb+ikjytptwp0jTM
         q7tA+X/K+O3Pk/FuYrVXthU4TrnP+3E5EnIejJqCn4boNKG0biOUA1GBrf8AzQRzIKH0
         xnKEjzYujKDlA1FV+NPcLYP2vrl1DKhmkwduP1Uc4aMXEHNihvTgDDQGppuRJ/4052qn
         GF6GrrWInW2v27loCh6kOUH4RlNMIHanQVUhdsRRlLvWW2afxHB5CbP39iByEX29auVe
         ex756m+6QLhIlcsHJjwFiCK1RJWKoo3OtKPZstJAJp43gXOtrqW5njw0txhEY1AupJGt
         V9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794478518; x=1795083318;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/1Q/PUELyNwj2qbyBRmSt0cgWWpENEFwGaSV2JeSfBc=;
        b=WBlttYuutiGwl1UVDxDVwZWiElURBzQVkrjR2DVmnZvTXQzh+3HQoK3ddNYs94FgNI
         vi2kU9R18Hvgp4Y2XodFWw8jCTADR+4PsH+Mk8mBBap+dwZ9SB0PmtL++pm52oGScsUj
         icoBdvjvlWY7JDL4WZECYStt/1w+/cATGMVi9jkrExAkyT4ws2UH2RG9495f3S+7IHsE
         7pl7cKmgJChxnIbDMEJmCfSyMUzFEeY8v7WO8ZUQ14FEhpnqU2/BYX12fxTK9016zUO2
         CKq+JiCnrjewoF42/kFQGQyzZwiSNwkz4rAJfwMS+g2B5GpdpsOZn4XNTh5JgLUvkCAo
         iRPQ==
X-Forwarded-Encrypted: i=1; AL+hErGmfICjSDkPzJqRM4WFEkLe38fVshtdGlOS3pd92e+LH/pokhESDed4PQVim1CAbRlGspcSHcCKV2V8@vger.kernel.org
X-Gm-Message-State: APuU4Z9fGzUQvN6AORfK9Gh2Mg+Tg1w94ll3CF+f032VvTqTeggGtRmy
	i2V7fXvGYvmWt92DM07xgOtF4OelikDTjdy9eonlWCu3CjIuIHxgNdRq
X-Gm-Gg: AYBFou3m+6fd+RwkKk2b1w3f/9NHr5OYNPbINbVL4BZtTbmZ3DsZAwCJda9NRJb1PCG
	IgGbve/i5kdijPRgWqOnRBHKi1pBu8XI2UXTfD7Cn9p6l8spna4ele7o2wn3mnwIqTQoMuM2LRs
	5gx0oxqu1OBpTI0dexQ+IbXpeQOescYcXoV9rtG+WWHnwfzvf+fB/xAAhfouaJFowG4dwoCN4GS
	K4mxG699QxLPOQ9xuzev6nHVfUFDAZJgzJzyO45U9sAWqicc3YUoBrA+iWmgQziTl/VAFkrA0E8
	YVpBDJNqbYOMTrOtO3Ogf7FaRZb79Aj2195dTjwCyGwBZilW03Y+T+p5+oRR3J+cwo6uB6Abx0C
	AfMcN0awcgoUWCuvE8h9oEZF8zObxzGFZx+sSvQkMBiPGBqJPPmmjWYIOSRqjhGEaJz/s/DCOmo
	39VzmAl2Ezo2II7jXD7eyMrldBoygCMoFye0iYRqBUBvi1VTDB/OnvlaJFXSsJaleBzOyGFNJeh
	CdhePlUZIg1z0CC82X8uJWsH27N9RLApqbwwhcQoDULFjAi1JPjP2AnV+/Z/iF/57+akBIyc0xm
	LZJIe+909wRk5qrRa8CN1QWRbldse/p5zyO0lExRF1dpartKPsI=
X-Received: by 2002:a05:600d:2:b0:4bb:52bd:a3c7 with SMTP id 5b1f17b1804b1-4bb52bda3e9mr9993475e9.6.1794478517767;
        Thu, 12 Nov 2026 02:15:17 -0800 (PST)
Received: from smtpclient.apple ([217.111.110.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e26700fsm66747305e9.10.2026.11.12.02.15.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2026 02:15:17 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH ipsec v2 4/7] xfrm: prevent AES-GCM nonce reuse after
 early GSO
From: Usman Malik <usmalik90@gmail.com>
In-Reply-To: <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
Date: Thu, 12 Nov 2026 11:15:06 +0100
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Sabrina Dubroca <sd@queasysnail.net>,
 "David S. Miller" <davem@davemloft.net>,
 Boris Pismenny <borisp@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>,
 netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7A2301CE-C145-4CB2-81CA-4A2BACBA8430@gmail.com>
References: <20261108142652.1330952-1-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261108142652.1330952-5-Jeremy.Jean@oss.cyber.gouv.fr>
To: =?utf-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: Apple Mail (2.3901.200.71.1.16)

On Sun, 8 Nov 2026 14:26:49 +0000, Jeremy Jean wrote:
> With software ESP offload, xfrm_output() attaches a secpath before
> calling xfrm_output_gso() for an encapsulated GSO packet, but
> skb_gso_segment() leaves the splitted skbs sharing the same secpath,
> including xo->seq.

I tested v1 of this patch and posted the results in the v1 thread:
=
https://lore.kernel.org/netdev/20260930144523.435271-6-Jeremy.Jean@oss.cyb=
er.gouv.fr/T/

In v2 only the commit message and the code comment changed, the code
is the same, so the results hold.

Tested-by: Usman Malik <usmanmalik@engineer.com>

