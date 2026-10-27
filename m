Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068100;
	b=v5GDaPE3UqRxzIYSl+NjKbkGetI9cn7vmPJ7x/WsVIFUZBlrMzVwjUyvVG5LXVPBoDOR
	 rRIkNsGKP9M1km2VuBcIf/JXiwPsxcA3UNbnExpaoatOCJK5AOiDjNc2N8n3JdgzBWLi/
	 vk5cCxWItB4viXWh6YNXxtxRGXo6c1KNdjYqPRyI6wSsiH542IxnQSzv8qKoaPZGHCrFt
	 0wtWlcOFHNYVurAoHIo1wU442UzdOFcIWkF5aRy7X9QqDvjm3aA0Gqj95jotVfSdPCtja
	 bAKNWUz7FG5L0+nmQwU3BeUXVX4HY4UIZRWNMVup7hpPSNXnBJ21N+3WNAdT4SHXjVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068100;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bEAiBipa8jU82pSRH8jXGFpz9N0n7pgT41JnCn+/IIA=;
	b=yNQ5eXu/JAZjHwD7jJhq8Zmy8Inv75J+boMqDuJZ0+7w5xq5KvVwgyPUynEOk7kcaS6v
	 ipxGNp+fp0l8+1xw7HdE7l+/dN1GY4HqLxVMHps4u46ATC05kWZgwQzvrbgUqJ3vxG7F/
	 vz/0rFyECnlYmZeTsoOHh/5lhCN4arFDI8BWDfGRfZcaLeE1/iZApKOexZoNHvIFhiJUl
	 bTldtNY92nFxknPls0RrmgIT0f59XbnueiPuodMnh7QEbY9muNL9H9u5ywYXo9sQwKd5a
	 LShmEzoCc4nNbaKKRLoM3qCIc4X9GKEEXbMB6tT/6iB0id2VftcL7qZ2oxe9kXYAtBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ciykqybk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E847F606A31D
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ciykqybk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605E01F01825;
	Tue, 27 Oct 2026 02:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793068099;
	bh=bEAiBipa8jU82pSRH8jXGFpz9N0n7pgT41JnCn+/IIA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ciykqybkIPOjPOccmqGt+GRekcYRQn/quHMbjTFKzyDqgP2Ei1EQw9HcFl1mJ0ONF
	 QhyJtz3G0KCNRzyWBCrLZ5l2xKRFAvXX8UFMoncp1B/gO5lya46wj6s69AFNkH1Jbf
	 NSWk6dZ7+Bp5yJkyWR2CvsQbNtQ3UvnFOKSvUIJZUX0j+ifT2Kd+xhBiz3O0lMwijF
	 sbLcRyr9777q3h+O5SysGoPigJoUXhYae1sic61ZrW7hPojoH+lpFJp6MlB+r8/xhY
	 XhvZJ98R2TyKsZHjJfgkGuhsja2WKLk4XFY02bkLv3hJB83J+jwCypg0GC5axedi5r
	 zGZG5+9/QAc1g==
Message-ID: <sashiko-outbox-186019@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 2/7] RDMA/zrdma: Add core data structures and
 ABI definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-3-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-3-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:28:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Add fundamental data structures, hardware control structures, and
> user-space ABI definitions required by the driver. These headers
> provide the type definitions for the subsequent implementation patches.
>=20
> The UAPI header is installed to userspace, so it carries the
> Linux-syscall-note SPDX tag that headers_install requires for a
> GPL-licensed UAPI header.
>=20
> Signed-off-by: Yanze Zhang <zhang.yanze@zte.com.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D2

