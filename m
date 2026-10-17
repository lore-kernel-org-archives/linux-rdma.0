Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98E63955F0
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792251573; cv=none; b=nCmDhL+FFdrBoQSFOBwYoSRBs/rgk3gxAmwKsMtc+1QnJYO6FPBZihHg2AXayAPRMnK9EDfcNBjAYaPFZpmLdVrXPq+TBNt2WhxTTguI9VIq6p/CEFJc9l3URGqB6cIodK2wEo+vpHlsQBZo8BJYuaypTOjkezExHtjDy8qWHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792251573; c=relaxed/simple;
	bh=z/uFea29luqeZCtEGg5623I1/b9jM2z2SAZ5sVAPGUU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kk2eA6QGSHtOk305M761EG0ICyvoATJvoiu0zGkP1BNNpEUcSxqY86o40enPalhx4UYnRP1AOcerFX4MknJPk1hAno3Lor45OLI9TpORFfHPoUl988cIXy0ERhV5TsZUcAwrennyoZmNrXRoagRqYWZZ3NYiHa2GBhujywiqyXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIQ/g8by; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIQ/g8by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AAC1F000C6;
	Sat, 17 Oct 2026 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792251569;
	bh=z/uFea29luqeZCtEGg5623I1/b9jM2z2SAZ5sVAPGUU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LIQ/g8bya2mlN/8+xzDEj2VGCMxSL1EPuqrRqxGx5sLqVOSgcQ+hgki4ioY3QPB9R
	 oogIAvA/Cxp7akgcCMld+2whlrffrrg2pAdpvGV/uNlGl91LkcjcEWzwG8YndWTfbd
	 DjvRekuRRsmYVil0p2FRikGQcJpYmg5rrYXPKHlcAS4TCxo4dJ9CxeEzsTj5a75awn
	 p77JrF5rMvesbyUSvD6B2W1i0VuqodUht2NkHqRraqrV4rHtqz4F8JXxJeFpkxHjbY
	 SWVWl0Lou1LlKksaaclopDYf9CUj656n8mZpfsBvMJ/iUophHpmxUSalm1brBc1Vn5
	 uIb3fm2yewEyg==
Message-ID: <sashiko-outbox-175609@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 09/13] net: mana: do not bail out of
 mana_detach on dealloc failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <743b6f30faf788fcbf663ba6bde90fbfc51ad0e8.1791710735.git.weh@linux.microsoft.com>
References: <cover.1791710735.git.weh@linux.microsoft.com>
 <743b6f30faf788fcbf663ba6bde90fbfc51ad0e8.1791710735.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 15:39:29 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
>=20
> Remove the early return after mana_dealloc_queues() so detach continues
> its device and port-context cleanup.
>=20
> The return is currently unreachable: mana_dealloc_queues() only rejects
> an up port, and mana_detach() clears port_is_up before calling it. This
> is a robustness cleanup, not a fix for a reachable reset failure.
>=20
> Make mana_detach() return void and remove the now-unreachable
> error branches from reset and removal callers. Keep ndo_stop's
> required integer return and the internal deallocation error log.
>=20
> Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791710735.gi=
t.weh@linux.microsoft.com?part=3D9

