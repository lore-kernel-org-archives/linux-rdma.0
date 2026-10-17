Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA8941D23A
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 07:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792220427; cv=none; b=GhX/0GVcblV3VkHtrZ5dw5nxqGstaAn8GOnEubCVAnPdayB32/gfOGNlpa6NlMdWK+9jvVx3hhIv/N8TlrTD1Zlm8Twza8yq9kSgt+JlEJFuxFbJTw7EfbXU0xWDw/2TgR5Hd2IvB47PEQJ2RS3riel78CfwayQjJfzctdWLLqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792220427; c=relaxed/simple;
	bh=jZSB8eh+8aeMR7lVichQ2HPsmjpl7CGPWQSD0IyWi0E=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Pn9e5Tshief20nTAC8Wi/hQG/eXDE+SUIcospl3WQNBe7UP0+Ld9KTGchsDE44Vs3S0p2VFc4npGwfiKUbDgnQ06bGzPEBZgWP2TRt4c3IkLL7bpm7Ek3OYqhJrrYOC/O2xyFuURXPSQmZRxOVQo2aQiPSDyq/XhA/Yw/2PuyWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaVB9+Yy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaVB9+Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0851F000C4;
	Sat, 17 Oct 2026 07:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792220415;
	bh=jZSB8eh+8aeMR7lVichQ2HPsmjpl7CGPWQSD0IyWi0E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FaVB9+YyYz1iFZ+ZXQKXKokVYTXd9bek/a4PnhEJqFuPbI1yv+SHtDqKo0UxoBnyh
	 zrESZOQZ3mBXe/FLJBTMQq4Oke/FpR8kQ3NgwXPdCWv+9lNlDBni2dtkJTTB8oIGzr
	 F5rvqpBE1H34Rsym7oEQp53B37ZLOFcTdapC4ztydFC9E5EpcvesfhG5evBAHEzhqu
	 RkUflv3mcmDA+i6xjoDJdv4ftirpQMVfN8hlhePbjxJ2DkU+oPLsHy+jzG5raTUQ0F
	 glSez0KK7g+S9gFWxGNUc8B+E8Y44maShuPTC5UkJhbFpufWuEy62dDqOWfYpGKcdV
	 4czJwS4DGkchg==
Message-ID: <sashiko-outbox-175356@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v5 06/10] RDMA/mana_ib: Post send and
 memory-management WRs on RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017064413.995985-7-kotaranov@linux.microsoft.com>
References: <20261017064413.995985-1-kotaranov@linux.microsoft.com>
 <20261017064413.995985-7-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 07:00:15 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement send work request posting for RC QPs. Post communication WRs
> to the send queue and memory WRs to the memory management queue.
>=20
> Advertise the memory management extensions on adapters that support
> extended WQEs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017064413.9959=
85-1-kotaranov@linux.microsoft.com?part=3D6

