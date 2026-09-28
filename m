Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8104C419303
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576120; cv=none; b=OA0o885+HuCW7vearX/qesbZ1UdELU6eaSuV6ZM/voU36lSZoRayGjagRjHJY9fbaGCaZN5Xsnk4uo9YrrE+3cnPJiZI2YmG+N5pVMJL3d9ytFg0iMcLDfM9OYdO/tNGmqlNDcFoDtUSblDbMR5eDlOnMA6B2rbdQ4dVIevCZuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576120; c=relaxed/simple;
	bh=u99To5Y6+jx/Deu8n53mLYX/DCNFllcEFOrZWnKf4Fc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DHrzksYxfHfdjSlpmq1jzpByWJwtvfShNSolbAVwnOhwuw27MUsK4hefPNPaEowH4EYHpQCDmUMb4kcXD17rMIywOEC/a22a/dsBxgqbad4EJXr4ATs/XyPOwDQmuhkGxl3PJzpGp3jvnJ2C4s03jn+LnLiYNejgB9GVnz0u4OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpU1sCNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpU1sCNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46301F0089A;
	Mon, 28 Sep 2026 06:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576102;
	bh=TPoGjs1aXxup0Gv8LtOQw0gvJC6bA/nF2tPSxpNihN4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jpU1sCNTWamhCoGKCCtLQawHPK/KVdFuKi0f+3a5PfmSrDJqRUlH/pdba74xJ5YY+
	 AvWdHLMgAmoyIZWjAt5vRwlD6mAJ4x4LdH67X1D+6MEPNaqF7mSkoz3EFOOcXcMxHC
	 w9bj8sWkZ15OFFR+bsDKFuwX0ATnql5QykFM07GI/Cw9VqhHV8wuXOHyxfBZldf0Pg
	 HPBHeUSKiOstOsuP3eB9BgLfB81BXmkDHD6xQGcJJnMlpxA2qNtGGDJpYP7Fm2ZFSy
	 AERR6Y546MGs8rHhxMyfxQJoV8BTXC/BTxzwilmcF0TnRNd6zGfywJVZOFvMr8Kpwf
	 iSLjy6rHhp3SA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 06/12] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-7-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:02 +0000
Message-Id: <20260928061502.B46301F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending - once the following patches hand out references to lookups,
> sockets and incs - would execute transport module code after that
> module's text is gone.  At this point in the series the initial
> reference is the only one and the wait returns at once; the guarantee
> becomes load-bearing with those patches.
>=20
> rds_ib_add_conn() loses its assertion that the nodev list is
> non-empty: with the sweep below emptying that list while it destroys
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D6

