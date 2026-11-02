Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793607838;
	b=DZbmOlVqnl2W5pfzx5GDRQKB5tnpfKjQ2RMj5OpDh0s0v1GzPKIwgmAZx8NA+kTt08p+
	 PEuiutcbu+mmi/n4C6KTlVTT60xJrVxaD4YrUFODZKEhtVKU+MEh15vrBtF/u7sDiorbT
	 aeDmikNSDqqWZ0+8oY7NkRzn4yxkHtoCG8sF/AIujb5ne8Hf1FqqtquuRFFVFrSLuu/A/
	 O1yDlWb32J1etHfA+WS1sx2qweGGLrZ9S6FkcnRqA1w11W+XDOJgLcjXQqVuBaixpzdvi
	 zWY97prSDWKbMVaB9MeEK7xyusKhcd3mkrNDE8ULLQ5cb4btYp/zJDcYQ/QWzsOocjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793607838;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lpu0kpNRbGQmmLPiaREejhSqnCZlM0qV5Cqma+NI4WQ=;
	b=MiJ0/gc/NvWCa/pNMTSFJE2Ke4hxykGsZsugj3MGI6ci4CR+cMFAJBic6rnJtFR+Cvrf
	 VYt3LcWk3iUxAJkhxjkR4TMTnxeop71ZWKLARIxOsOMrP8eEOBDHEpVyLnxyzW8oZYnDu
	 VOocDPlBXGkonk8QM565jixwXAJofXUIJV6YDOroT71vK2lwt+XukWNP0v8opjUZhDhqc
	 e5H4RGO8rZ67CpWDf55/F8UrLARxJssd1Lqu+inUqu8ZLAuV3PiLJoD55dGx0KwoWQrO8
	 bAAbb6fWYwh9kqgZr+6ldNPlGrL6XrWngu65bgqK4Zms1h9TcOMxKeBsIqjvaLQzWhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwqPab81;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B914F606A324
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hwqPab81
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C821F000C1;
	Mon,  2 Nov 2026 08:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793607837;
	bh=lpu0kpNRbGQmmLPiaREejhSqnCZlM0qV5Cqma+NI4WQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hwqPab8157pKqUdcAsdTwgMYjasXKrJTftFR5iHfRwnNlv25+uAP2s6kIpT47f4fY
	 4qGmY5tjGn8AK7hwt1Ulo7ks6z4yyhsODcWDAiQNQkl+mQzau7vfysSrxZfgUL4pS7
	 5y2v8tpaN5oWrpfAtkJSioyx28dfqth1DVepaYzUwm3N3QaeqjOBF4Wyn85ZfghAex
	 ODLCzu9yr2M3lu06hcL72cwd+SZhEzcMQ85gz7rbTe6pCuWjqpj6MpwJQOA8g/xgwc
	 wQUpf2EFhYlwG1IRpJUMytkx3wQEbHit58JRht1qku0JgrhaCH3Lt3ueBhJ4a3FKnS
	 Y33E6ImQX+vWg==
Message-ID: <sashiko-outbox-193102@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] RDMA/iwpm: Fix use-after-free in mapping info dump
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102081813.37754-1-18983559317@163.com>
References: <20261102081813.37754-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 08:23:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> iwpm_send_mapinfo() walks the mapinfo hash table while holding
> iwpm_mapinfo_lock, but when the current skb is full it temporarily drops
> that lock to send the skb and allocate another one.  The hlist iterator is
> not protected across that window:
>=20
> CPU0                                                CPU1
> iwpm_send_mapinfo()
> spin_lock_irqsave(&iwpm_mapinfo_lock, flags)
> hlist_for_each_entry(..., map_info, ...)
>   map_info points at map_info A
>   fill the current skb
>   spin_unlock_irqrestore(&iwpm_mapinfo_lock,flags)
>   send the skb / allocate the next skb
>                                                     iwpm_remove_mapinfo()
>                                                     spin_lock_irqsave(&iw=
pm_mapinfo_lock,flags)
> [ ... ]
> infrastructure, the issue was not observed at runtime.
>=20
> Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user s=
pace service")
> Assisted-by: Coccinelle
> Signed-off-by: Binbin Deng <18983559317@163.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102081813.3775=
4-1-18983559317@163.com?part=3D1

