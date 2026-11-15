Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753900;
	b=VTQfKDXw9lQtAev5R3mqlayVDRT2RBPGobGB3Os258Px6Q90bQw7GAwnmSni9c5cmBav
	 tGY/5pJA8aaoUwz9V3uCTgwyQadWPpqMAM2ImBfVPW67otyzCkJYy1/zNwnYsLKuncwJv
	 D0iGWw0sdIPfjqn1/4m7VJs4aScnyF66owE4B0wsEtXMzYuMHNhw1ueB93MFRxlQAXsdZ
	 sW3qvjT1Ld5pdTDAzQdGr8Dw1KwWNVj6I1O7Eri6XXWYPDdvfs+Y65422jERIraT6vC6s
	 KhbyEu+vM+H01L2FhcvOuzRmn+gdQ5oPQXxhzWBwfKRMoBudeRP4+7wdRYpwRyJD83w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753900;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KfGUENXC1Y5be6pEzEt14H6jYm6mg8rnxKbUaAGySBI=;
	b=lCHugetG3vkXtFDb8GVpUGPg0DlDR0HzIIsJOg3eesUQtRGVIIK+86852pD6Z0GTwW2l
	 NeyicdtnZJM1GCmtxwyk/KQkP6YY/R7LTRNO8GTVi/lWqXeQDWJNWD3RC/18daCFXmudQ
	 ema1x8KERD0tREUf6rt/xjHFJC3SxSf0JR+avLcSVVunCukIUoc3h/TlrY8RZDLPls+u3
	 NReLVbRkJ5haqGsV069Natstl06cgg9Ag2DUcN1+ARMMs/4utYIhqQa7KRhVQE2GV7Njt
	 3TT9d9e2k82HOQM7Xm2PLbzkBbiKIDJtJQ4DaVnzcnLh0e+6jdyJQWOgriGhP89h27Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CzWj019G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649BA606A31E
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CzWj019G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D351F000C4;
	Sun, 15 Nov 2026 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794753900;
	bh=KfGUENXC1Y5be6pEzEt14H6jYm6mg8rnxKbUaAGySBI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CzWj019GnXn5rOdXRT6GWuLmuECuZrIGZee7VPbpfWApn39ssPWcmInzZdzRnNaji
	 Y6KOsJhE6MChKoqaZaS6n0eOa+cIEqzSezmper4K0QQHyPMhVGfU6E8RDDxgCYUDwN
	 RnywhCkh15hcSCKsnWu7CZQXOkJmyOx9c5yEVmuoZL3i0H8qaIP7yMbrHXnOPY0vl8
	 sx4/h6YU7rWaNwoY8PelLuWSs5W23XwA1db4bhq8vuozpFml56y4P0U8mDD8QzTQgM
	 ldIFHBZ29bqET8xe3s++XaQ7A9p107+UL/CKuT4QM0E1v0mIaQxPFTV7G+8g+BMVOg
	 lMtGQP2SPDZPw==
Message-ID: <sashiko-outbox-215589@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
Reply-To: sashiko-reviews@lists.linux.dev
To: Jinvas <jinvas@126.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261114144325.816-2-jinvas@126.com>
References: <20261114144325.816-1-jinvas@126.com>
 <20261114144325.816-2-jinvas@126.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 14:44:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net/mlx5e: single-word handle used in Signed-off-by trailer
--

commit e432b554ac248a62d98278a82ac39e3c5d863c99
Author: Jinvas <jinvas@126.com>

> net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
>
> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
>
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups(). The latter walks
> ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
> Since ft->g was freed and set to NULL, this is a NULL pointer
> dereference, and the kernel oopses.
>
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
>
> Freeing ft->g here was added by commit 3c6d5189246f ("net/mlx5e: fix a
> double-free in arfs_create_groups"). Before that commit, the group
> failure path did not touch ft->g at all, so the caller destroyed the
> flow groups that had been created and then freed the array. That
> commit fixed a double free in the allocation failure path by freeing
> ft->g here as well, and in doing so changed the group failure path
> too.
>
> Rather than also resetting ft->num_groups, leave the free of ft->g to
> the caller: mlx5e_destroy_flow_table() frees ft->g exactly once, and
> also destroys the flow groups that were created. This fixes the NULL
> pointer dereference and the leak, while keeping the double free fixed.
>
> This also makes the error handling of this function consistent with the
> rest of the driver, e.g. mlx5e_create_l2_table().
>
> Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
> Signed-off-by: Jinvas <jinvas@126.com>

[Severity: High]
Documentation/process/submitting-patches.rst requires a full real name in
the Author header and Signed-off-by trailer rather than a single-word
handle or username, so the patch cannot be merged under the Developer's
Certificate of Origin rules as signed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114144325.816-=
1-jinvas@126.com?part=3D1
