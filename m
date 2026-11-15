Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794749564;
	b=0lG+pp+zbHLOQ+QA4exs6xpagKXo/RwcNe8G0NcKKsHHr24JkFPa6IdKx+BwrHx4jqgw
	 16X5L/Gqffu10DNeEAmsm9EWY4Mr6ay6syNKknKWBvlfP/NffwgC2erWBPkeOtWmfVuBH
	 ek/cn7URZnVc9ZPitWoFMcFSpr2liiTIWICDqz73BvVcUAtZpqK4DW5nlgQwCbEuwFXKc
	 Qtd7K7AwJzbPtZVAE+N3AdEAWSg6C47dsYd1NJiuJXaPUO7a4rBc4BtixGx0lg0yBNt89
	 jgofv5EF1DHYfUz7hnOIhAwnwDYjq5ZTP7WdAjxUZRPT2b/ioEpbFF1siVJ6E3wH8aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794749564;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+VWTeeWBj9iaXqP3fkKEcek4Vs+0SoJL27H0WUsG+Zs=;
	b=hSDlAtiTY5SLZDn1ixMMZ+HidxYt2+DZmtr/owbg46M3ryBx8s680hdOC4DTfMWLtO/U
	 um6VdpZA6kTGwof1W7q+LK6bboOyf/NUQaCXXugWAz1r58HW3sMmtyCtAtlGmWVFAXJrC
	 FSFvJLzZppT+k6guVhnDkbB70mTq3ZnX/G5JZfIpJGPrtqeXjilCzXmTQbzWqWQpr5c0Y
	 XLhqx5qM62TEOkvwvoqy03RvOQKMBwQdic+MAvpykuGaN7RjzyUh2ya2LVBWQHCy+42X+
	 rZ8QTboYADGFbfDC5P8kEveipvtqH3yr/hx1YQIT8tjN3N2Uu0h2su4TXB4GoxGuRLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVCBRITl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFBA606A33B
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVCBRITl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2119E1F000CC;
	Sun, 15 Nov 2026 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749564;
	bh=+VWTeeWBj9iaXqP3fkKEcek4Vs+0SoJL27H0WUsG+Zs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hVCBRITl9X3CVDmlhR4mUarge77lGBrYthG9jQ8evPBd6PAeCJFXpXkaaGbyRj0jr
	 5D4mUSNPTGzl82w6lpm1+CITH/XMf8M2bV0bV1SjxxLYQq8QdaWd3m+M4p5gxdVbvo
	 KV5tpYonvSIojiT6rpeCRuNOlWWdiXbm1o7vPjfXLCF7U4ajgqUYKVZ+nWusewFdUQ
	 Zr7djU8Urac3jGbnKPjyXgFdDPOHmFOzIKFQeoED6d7Oy/4Ly88HmyHhHYk5fYGkV5
	 XTwKVjz/S575hS+sT7hd/ZPKliao32KORBq8Fc6VX6Ccx1LrYhoWkeeyOeJeVDPeIv
	 5JbmXj6QW8NCg==
Message-ID: <sashiko-outbox-215531@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 net-next 3/5] net/rds/tcp.c: introduce
 rds_tcp_{init,exit}_net_sysctl() helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oleg Nesterov" <oleg@redhat.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <avmyvkuAjrz6IqvJ@redhat.com>
References: <avmyvkuAjrz6IqvJ@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 13:32:43 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Preparation to simplify the next change.
>=20
> Extract the net namespace sysctl registration and unregistration logic
> from rds_tcp_init_net() and rds_tcp_exit_net() into new helpers.
>=20
> This also simplifies the error paths in rds_tcp_init_net(); it can use
> rds_tcp_exit_net_sysctl() too.
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avmymGvelu00X5EH@re=
dhat.com?part=3D3

