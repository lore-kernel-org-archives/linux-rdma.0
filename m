Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BA340A943;
	Sun, 11 Oct 2026 08:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791707998; cv=none; b=Qx1v/7QFJT8cIaFMFRInRVKOISb+E2GxJUbcVi5Vr4Axwr55P9K9MLXUsIv4URd7gEQkjusoI6yQWA9GyTSHk3s84XguBMErhKOj9/ltOFrvU1rh10h5gmbA8aDyziA1fcj8ZVZb7jxdb9EzmKkZWbHT1fETJaPYBgQFCN0R7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791707998; c=relaxed/simple;
	bh=0+FY3vg5f1fS0jS8HBw6XYkQEF95BMgHkbk76Y96vdM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=k63EI8iWPSEPJFvArxuUgcIgb/1bKrL5fJUpWvposSKWlSrvTBIyP7Qhhcetc70y12POB9aPuzkkiGhj4qEpwb35MHm+WENP4kgXPSsfGX+5Ho3u8ur15cdhLUP5Qp8/AyVrCyYuEtlG//iV8yow8LRBd5jIdOCi9Ki+RKPDR5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFooJZg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFooJZg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99FB1F0089B;
	Sun, 11 Oct 2026 08:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791707997;
	bh=0+FY3vg5f1fS0jS8HBw6XYkQEF95BMgHkbk76Y96vdM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NFooJZg88n5u06NgzFd8ILNgyJNKCrwTwbu37SN52qkek7VPyaowhw5ydL9eylCEz
	 4py2MKuBaTbJRp5T6I/ooxyr0Bz/ILPB72NkEF+brczwHx1+GpdwbK1aVrLfzGqsMu
	 4KTirk2+13U4IU2vxpMla24l1/o6kbkcKUyZQIrlGhVEDZvNPDWNQtF3JJCB5w0dv8
	 JCWMPrPbnedQFD4GEP3auU2Aiy4yuYPUiRmTZamdVov8JJsfWqQSbbb9klxIVklfu2
	 jFKvwh1hjfKc+deJ3KI5apXONNyyJ5UIppv+AfTOmhY90GzJzwTQZViBzecEquxyKy
	 6JaUBi7VeBUlw==
Message-ID: <sashiko-outbox-167129@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 5/6] net: skbuff: use skb_frag_ref() in
 skb_try_coalesce()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261010083935.3274178-6-almasrymina@google.com>
References: <20261010083935.3274178-1-almasrymina@google.com>
 <20261010083935.3274178-6-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 08:39:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> skb_pp_frag_ref() was introduced solely to work around skb_frag_ref()
> ignoring skb->pp_recycle and incrementing the non-pp backing refcount.
> Now that skb_frag_ref() handles both pp_recycle=3D1 and pp_recycle=3D0
> symmetrically, call skb_frag_ref() directly in skb_try_coalesce() and
> remove skb_pp_frag_ref().
>=20
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010083935.3274=
178-1-almasrymina@google.com?part=3D5

