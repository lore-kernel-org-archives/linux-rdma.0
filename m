Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484912;
	b=HOi6PZfbndWz4XQmmpaXyeVitkIrY6MwMcLIxdop/Z2Z4BOv98BRi9+WmLhjgq0zVigm
	 Vi0lGYMnmnYfe0aYlQ22Z5ljN6oo+MOH4MLpbxkfmMdH3pJPFQfH0mcewX+lFgmuFB+od
	 kW/ME6qpjt0WqvfO7RE1+F0MZuEk1bKLUqMKa1TiKYNjw/LRKowL61VPJHpIFGEVd65ZO
	 6fLvlgjeiaLuJE7TheD9WU/VWzudbUtxz2p4CvJrvuMk1FZnMFl89NBwmLaAZtInRvWqb
	 C10DFw5x24KDayvKo3thG9VKjl57mXY/YM7Rz6JX/1lO6VBPH1/U90FWyhVpV8G1Pvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484912;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ae9SP5kYRbwP0v+7I8yKOvJY0P6Pt3X2ZRPpF7sB0k0=;
	b=XF7rVYTHbFc4nJ4A3Pj4ZoJ5pJYIMRzvXVdOf2+sH6MmLDMiFgE/zYJcOIf2DxLXX/0b
	 eIr6gi5aHiu+fO6KiKzHpXuBCKBYK5N9UFxJeJtJv9G7ZSGi3g8TZ+YSOSs96TQPu/pQ5
	 D3NOV3Qm7cr0x+cixCc+3OqiV2jH7KzKW06ss9AxeUSDIvkqdGZs2uh5bqZXkM3/HSoOU
	 v47nyJqvnqmFxuoND5HMhopNnRAB3GE1c+7Al7EzUWcGzwvEL/7AdAH9f8ljGfOjy3Aft
	 KnHw2lYWl3Pp6MCg4QXM2HLOfSFMDDMlZsmXb0wdDA7mHOXFm9U9UpaNftRnAR2Lgfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LeXEKmfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9810606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LeXEKmfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6615D1F000C5;
	Tue, 20 Oct 2026 08:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484911;
	bh=Ae9SP5kYRbwP0v+7I8yKOvJY0P6Pt3X2ZRPpF7sB0k0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LeXEKmfNNy6cWeuPaWt30XnzHHMyvEB/ROZXLt1Aee+9VTfvbowve9BlmoxJgahNa
	 jgGL4E6d9btKvU5SS7boyH4dIiiNt4ahrv9wotMBJ2MI6vWQO/3lpA+I+adSw9RP6x
	 CxCjwhfjB7edAUdq/71EHe9p7toi4nyGfMHXVeh5XKdKJIDmt1DbqSnFwVjFhZIkFU
	 OFNNmuD4wcnGlAGfavIJGnUaBKybK1OpjYpkB/de1oOWm4JkKfhKbH4S2txOYqEtip
	 yVaXgRLPyt5fdJBphhf1GZ3ghoIyqwLQdDz9EJrPrB+t5IC39ARipAT+jUd4+6cM8O
	 7z1ZBjWRtnhPg==
Message-ID: <sashiko-outbox-178547@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 04/13] RDMA/core: add the reliable
 unconnected queue pair type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019-uet-ib-core-v2-4-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
 <20261019-uet-ib-core-v2-4-8bd654f25370@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 08:28:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Add IB_QPT_RU and its userspace counterpart, together with the field
> layout of a reliable unconnected queue pair number used by UET.
>=20
> Such a number uses all 32 bits, unlike the 24-bit InfiniBand and RoCE
> one, so exempt it from the restrack assertion that no queue pair number
> sets the top byte.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-uet-ib-cor=
e-v2-0-8bd654f25370@broadcom.com?part=3D4

