Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795114788;
	b=5mXG8K2nFecpyDrWH9E6QwfXhQbdEExjsHHjCnXMKi9bwqpz3TtO3ix73eycojpVWiGY
	 GU8FWMacUjhhapvMBQ4u8rr6rVoL1AltcAIj6qKqe49Puu9MK9pjBGaJuYB8rQg0GL7zs
	 92zmN6iqE8TzM/WlkmzL766hJsp6Oh881L5JsoIuThH541vQrOZAZyA2IFsUfO/l9mKyK
	 PMD/VxE3NzRVtX8LiPkN53a3H5/AH8LKFso3DfxhAvidaN+o3df58mIrC3pj9wvsobwOU
	 acCVHv5inIZIwdVkXm8waJRDmC5VZ5CyoVcRZSAN5x1En5OT/eUROumLnemGCWv68Cw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=wbxe7kLubw9u1wufA+gD9vxLgwISeFpqRh3SSGVI7cw=;
	b=htCDwlx2kRcUh9VNtx7jB/ScFVihlGXEEzU09RdJb0TTG2nRSKHsK2MaVp/AVxuOGI/M
	 Sq9vm5RHEdVY7xz1CRdnGTphAs4TXaAOtXzMBTvd5isgyTB/9ZK4jOHX+sKf14sTGz8Rk
	 K0airnwallxQXozsxjuJCc0HS66UvdlmuK0lPXlfbns6S24gw6eGKG9NND5afBuxdH/7D
	 oQ18TS+++hDxtGsFsKegxHFBGYzNFFBoUEjmm/waRxqEQ3+tSFcv0vYtz2q+ljj7+Klbp
	 WpvGyy6isdKTlMdRbu0HfTjg7Fox6fal290Gddq35r+MMPRu6IezlK7GSnE+u9k+AKA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b06SVsdc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E64606A32A
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 18:59:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3E64606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=b06SVsdc
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-380b40312e2so51841eec.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:59:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795114787; cv=none;
        d=google.com; s=arc-20260327;
        b=LcG9kn9HzzEucHQB1+whqyr9kKUJDEiw3kOADZRcGYOiL7b8DNUu3DQ5e6a8AtuVvJ
         PRbdCgjtBtTBjv65qCwaGYzl17bIzUBbqNjOOp2PD3q9w90KsLs81hES/nW2VeMwxvEv
         3zZumKfVAeSUtkxVO47bAJT4YmXfzGi8OVw20uz4VgJ8LHo0O6sWsWQ6geeDmCivOMNd
         fDLLOUpeZZEX7E4frUztacPz3zUK1Eb05RfEHvW+N+h942I1fMBsQqkft3XJmoYQs/4o
         sA5fPTL5lj6yXyR05FzHaYTW3XxNFnlG53c5oSHdWTk44DulnI5BLy5nQqmSRrNkqdMk
         DyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wbxe7kLubw9u1wufA+gD9vxLgwISeFpqRh3SSGVI7cw=;
        fh=KjPOIUpAa5v7tdqh8ED/S/HED5F/ze0SlY82EGOmxcY=;
        b=YPAQ/0eB66MVMHJcDQB2Kzit4VEwGPMi2lrUcicvZcUfWrrcvJ83AP2L456g8AIchm
         3CGF7e1BxNHMe1JEulWiNhuW/hAU0g6iRZrYA14jscG3fyxGcFlq4s5uRcyfwacIvgao
         Oh33JirGsEye5PxY8dN2g7txEszsKzMKOOvzgoNTrDMkIrHXBDFFkTzwL0Gs0ahW/VQm
         d118KNi1knyvRBUiUXkuNiBYRYqap+lyd6CjUOzsINT4P6BORsGRmNlR2IWDbVynEdRS
         2v04kkm+EE66RQRV7UdiSDuE8+/ckFYe3tU3AiPlVyeYrIRNrYgzGKH0OzDuFKMK84DA
         XJaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795114787; x=1795719587; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wbxe7kLubw9u1wufA+gD9vxLgwISeFpqRh3SSGVI7cw=;
        b=b06SVsdcaDcUIiqLafzT/utdQ/iCjsDIoPHheymBP14C9oVM+Nij/QnTatPmo5MLd7
         VWBwzL6foEyhbglKHqywrYsDot3ltlNUz3u3/RxZcXrSwaQqK0r7pphL3G80HqysQJOr
         RwuwmOjSc3g4F9xMvGEAuyWvzy3Ttht94JwG3wRz1UyFb0Yoehvd14U3X/FaQHODbnNz
         UbH54uyTHEJIi3O+qLH3rX689h1ixmJHiGMEmfZGg0ICYydBD9ccP+r2c39K7hFPbzWc
         IrNzaT5Z2aJKpIyzCz/I6Lj5uMjJ3JPS/SEhCliplYtOTnP13itNDhlUdUiBB7kCz7L/
         Cm+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114787; x=1795719587;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wbxe7kLubw9u1wufA+gD9vxLgwISeFpqRh3SSGVI7cw=;
        b=x6jV2hdgJh0S8TQPcwesGjQa6KIY4NMuHjPtAd9JJw8VUbWmb2K5fXD4TwLvIrILC/
         wTmB5GpYKYoFJ5q0eEj9CSygEsimSXPP2eRK1hn2ilKVy1DfnMox++pydD7ip08LIzNh
         a3zS635LXbNO21bOGSmXZeWaW43XnU6WENYApZpH8Sbm88hCF/EmW+OJKl2JaxrANK8X
         uo6YsbX6Vwz34jRiav5o/e01+VSTs3gqRwBnuk1x2S8pIIRUOREdIGbib6wLcwE3jcer
         iPL/OlfRjG8/AlscDqTYMmwcJ35gD6KsFYAg7IyjaxQFU9OxQ11X279eypq+oaAnytnZ
         7t3Q==
X-Forwarded-Encrypted: i=1; AL+hErEyJP/EhZ84Qi1QIJVxTxSrkBbWzfHKwmVQk7sg0zvx3IBAteGxJ6ipNnF3zm34u3bK4AYQEBUGe0HJ@vger.kernel.org
X-Gm-Message-State: APuU4Z85gGZNxRu0Olp9uawZsmZbgHJ50aaV01dDJCwTEP+zBq2TSlGF
	JPpidaTft0CHYbbSgL+JRCat7lUp10tGceLtN22hoxs84NiIYDcqtH85uMZ6qMiddiu2FHzkS9H
	Je3xcAVrdVYvQ+uuYoUuv/M2p0ZaoVac=
X-Gm-Gg: AZFdTZcwttT8tfuWELfqFiYrUIdGE2DHXL1bh6eNE4yPbxQJ4EUBJJ5ydWHuowG6bSj
	rCHXvL+krQ3KlMssKMf9MilnnvWVmJz+Xf6+nm3dnRhQFCCVXg6zp8BMFApMzhBVlVnOiku+d86
	5DutXuuWw7yyO6/gA5+SmnvnviZkHBcUTW2unARmamxpIDxdY0aqwDPyLM4pa2MGa68XzDc8go6
	mXB8NpgEU2ju3XHYwkfkbgN1nS/HmIIqFQhFVJ3/PAG6qz5gU3LIXa3DgmnBiquVbaegctQT5+e
	zaNBblYD8qCFTSaWiK9OBz7GnpUW/5MlGF55d8NPhjEz43GQ+XHYTazJMaHHvB9W4FJMDFHC6lc
	8NJ9XiLk+NpVF09o7ICKavRlZ8bkpFaXf1XuQUuBhr4mEsaiWxgCO0rqie4YFNM215U45LHXhDD
	lkKLDwiG3ecLELXyDbiA==
X-Received: by 2002:a05:7300:f491:b0:37b:7bba:8199 with SMTP id
 5a478bee46e88-3856fd5cc92mr183443eec.6.1795114786784; Thu, 19 Nov 2026
 10:59:46 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119012707.555494-1-lcy8047@gmail.com> <7e94f48f-f352-4809-a96e-d5363b8be273@nvidia.com>
In-Reply-To: <7e94f48f-f352-4809-a96e-d5363b8be273@nvidia.com>
From: Changyul Lee <lcy8047@gmail.com>
Date: Thu, 19 Nov 2026 13:59:35 -0500
X-Gm-Features: Aa3M54po2B1r57yvjEB-PRSHSy7gIA46Bx8WGdBCs9hXYwC8qE8ue_MB7q0s0UE
Message-ID: <CAKefsHt0MC47dMy++wZS7SJ_yZVYeOMdKmG8RvkNtqCoGn2_qA@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx5e: Skip hairpin entries not ready in debugfs dump
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thank you for the review and the corrections :)
I will send a v2 patch with the fix tag.

Best,
Changyul
