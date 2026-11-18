Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017688;
	b=eKnOrQbu1uXNRjP3aMxaHFcQ7QJIq9LLKsoK/KMzGMoHVIuE5Ap7QP13fMHFwAuoEtiF
	 zOtOTvZkFIk66Y42m+PIQMhTaDjePRddw1NeCREg8HYX9ih/wWMPNmwo4ZF3vzq2+PYbM
	 i9ShuXse7N5xE9bH+ak9+pUHt5bD92y12JBZL6avWfPS0B4JDF7EJwolB3RyuV2jCSKcB
	 fdrwbpMrlpQV/KmGd1CYYOpDMUw/+3Tdj56TPrYtKURueYswBaiAhVjsXtUe4Ly8Bh+p2
	 VrVxP3c3RAlhV2fOJcfj+TY+I1vpLMi3WOhZUs7Ur5WOTO8YbQk3VIhuh+q+tB0XuZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3fNwV5mca6mk5RseTv4BMRVlN1EpM9RKm/LbzhTYmbk=;
	b=yfpUyg7ezolto2v9FQjx/hw3xRweNhkhjSonG4kpAEWsh0YxN5n6NdO5ESmPJrBOyRTD
	 99d0WiII5Aqb3l1UFJzV7xPPoKlZpDhxVccCLhRnembDW11guW9h20wLhtJRFjZMwdcLz
	 h+Oae3PMBi0Bved0IUNbgp374Wx0u5Kx/P5++q+3wZDS+KyXdAhmpwStvZqPFwZ/O6jER
	 d8WCxjM8aHl/ceSlrxKRdpjrijOezm2RK39bXSrCryis48almNnt0b6lGurNNf4410QXe
	 jejgZNfVsm5M/HCX59eW9brqbN4pTzOVm6YKCfieV3Ai/0xJn4RH8fwJ0wP44NdWT7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4ipdUcT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13C5606A332
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M4ipdUcT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC5A1F000C5;
	Wed, 18 Nov 2026 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795017687;
	bh=3fNwV5mca6mk5RseTv4BMRVlN1EpM9RKm/LbzhTYmbk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M4ipdUcTI8Xs1O+qrMdLA2E4kCz6v1eba2sxdILoNu1wKbbZ71VKg03AGi8w4pjPz
	 vitXllJWenOxoFJCjw7bVAXGFZ78/v2XhcTHGsqDBeC4XlPyiLnRAtz45qVeGqlpc5
	 AUlfjOCfqVBahX/5ldwUVxnoEDKjFczpOj1XUulqv2zUcngU+v/gqtml6ZkBUruMn0
	 y05RS8GHWV4jW9rqZNdUpNGx5t6MnAF4IaMvoClmCFLTaDLscBFRUWtCXkjRmZ/y2B
	 Y5KsXIv+8wUNfzUV5+aBJPPovOOFY/G9NfRfF/VMAAVtBugqap46xTX/9Pnf3myIdK
	 o5tRAtbMeccag==
Message-ID: <sashiko-outbox-221401@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v11 2/4] net: mana: give each HWC message slot
 its own completion state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <42d753b49df1b873b2f0f6477771820e14e9fab4.1794751992.git.weh@linux.microsoft.com>
References: <cover.1794751992.git.weh@linux.microsoft.com>
 <42d753b49df1b873b2f0f6477771820e14e9fab4.1794751992.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 16:01:27 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> Concurrent requests require the response handler and the waiting sender to
> agree on the lifetime and result state of each message slot.
>=20
> Protect the caller's output buffer, Linux error and device status with a
> per-slot lock. Publish the output buffer only while the sender is waiting
> and withdraw it before every return. This fixes the original driver's
> late response copy through caller storage whose lifetime has ended.
>=20
> Reinitialize completion and result state under both the allocation and
> per-slot locks when acquiring the slot. This also fixes stale completion
> state surviving a timed-out request. A response handler can still hold the
> per-slot lock after the previous sender has returned its admission permit,
> so an unpublished bitmap bit alone is not sufficient protection. If the
> [ ... ]
> Link: https://lore.kernel.org/r/179196575434.434549.4428132041097324407@k=
ernel.org
> Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@k=
ernel.org
> Link: https://lore.kernel.org/r/179455239815.2199510.4673285259543925635@=
kernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794751992.gi=
t.weh@linux.microsoft.com?part=3D2

