Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10049E135;
	Thu, 10 Sep 2026 22:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079128; cv=none; b=hjCkvQYTtH7T+2Q7nJSzVoFfUm+QoewNbzbNyWbOFcfX7FlJbE5d8WxQXJIkG385SzMIZI2qqS5xlDci+Qxyp8wIwc1jmaKQpnLPEQ2vcpf4rSRHBKVzdo7uIaUL1qbfYo/Ca7tsZaxN6YJl4vurxbloskpmXk6/w3DZawEnxww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079128; c=relaxed/simple;
	bh=8UupOqk9OnLIKLMMQw/Wx5aP4HgTRlSrhtm39dwSwZ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=niUEyZSfGW4e62UpeulORQYwOfiLycMD2U26UBIpfvBwbtkmP4XaD12C8LRPl+1rn2x/aEL/SsKmEWywSXeDaJn82hjL/ipYd6foDzQrNwCD8Eag+INC47QFpbAeAta7OehRP8IrZsEaeXaKAE6Vl1AiMk8lyJVkTw5CEYaIFQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcilR/ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcilR/ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA081F0089C;
	Thu, 10 Sep 2026 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079124;
	bh=8UupOqk9OnLIKLMMQw/Wx5aP4HgTRlSrhtm39dwSwZ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mcilR/ayaY20rTMryqr67sN8Cz5U4NfHuOXuxY062pENpDj8sFoopXfZ6EnaHyh/v
	 4ZaZshQJ5WRhxfJ6ImsJR4j7U/XdiMkfSIQ6d9ZQn38bxdG5en+ntozNDQw1E3W94B
	 j8x4ivUDD0aXL/VqeKqW8schpynAbmiWBBdC0nZuGWK5s8W541jiFk1V/URIyme5lS
	 RXnU/ItlGn2qqgX4Caa7AfwK3JV1q9unGqBYvyolExl7++EWBypBBu+Wif+ZXLiBx6
	 1QZ/qsWviwpG+n1lxBYI7MQAUp31SuGe8QUpOujB1YwVhGDqP2nZnXBRbsjKveUU+n
	 z7de9A93JKpLw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 06/13] net: mana: swap queue sets in
 mana_change_mtu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260909222416.884246-7-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-7-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:23 +0000
Message-Id: <20260910222523.ECA081F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Carry the MTU in the queue set and size replacement RX buffers from it.
> Publish ndev->mtu after RSS configuration succeeds; allocation failure
> leaves the live queues and advertised MTU unchanged.
>=20
> This still rebuilds all queues, requiring both sets' SQ/RQ/CQ objects
> and RX buffers temporarily. Resource limits can therefore reject an MTU
> change that detach/attach previously accepted.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D6

