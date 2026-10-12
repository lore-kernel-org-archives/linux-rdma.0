Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E8F41835E
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 10:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801151; cv=none; b=i2Yv9qHTu7itTNoZ3wxdZLljlf8dJ/kS9qy12SIbclidgboqL7MNAg5xFferaYf5bnIbXdZcXA8tpRGrw+eMyL/0wf9cX2+iCTLjZOQ4oe/IuNv9UFLkqcUnc0cuLDzRpWAtqyEenaByrlq9+bLuGDnwcRKMHlEPNGuWQQxreA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801151; c=relaxed/simple;
	bh=lPVyf9qd/L7uhI48rxK4Ar4FlWJirChDP2HvVQ/YG9Y=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mwFULHJ0mL1gf1aEeBXS2nHdMYvIl0cTWM40vcqSe0d7WsKwd4n0EafsRK654qJlEq9bZxQAbWT0iybq3q+096aocMB3W/8Alx1m0D/IfQx0qUfr09l9zzLoMWLKpHlOCxlYov7oKrQpPHOxf4Pp1QrBl5gIdrspeuyEi6HAT1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iAw4uSh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iAw4uSh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234621F0089B;
	Mon, 12 Oct 2026 10:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801141;
	bh=lPVyf9qd/L7uhI48rxK4Ar4FlWJirChDP2HvVQ/YG9Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iAw4uSh2k2xsE1ryKJ2GP3IsjQSxX3yvU1cwdhFj8gseSPPc5RrlE1vhfv7x8wl3q
	 KwSuAYWVmq7iY8npXiHc2HkbmAyMI24ZflflAL6ku6xxfw2AfUSwW0xJWbmU2KILEQ
	 XOOf6si7gWZegw8sgwooPqRHidsPSWj+yBq3oAoLOASCvX9uxkQHSTR/y5YPq5iJXc
	 4V3p34O61eQdddByUxmAxT7I0N0P5rX52D+Lk0dopkWiR+ajemv0nKH9k5wsGDO7ID
	 WlzgqbSOTJVU33LPitcJtQ19pItMgC9hczqBN9bjKs4ffJuWDMiJ9iRDkkXN+9aDpP
	 uMhHORWTAmT0w==
Message-ID: <sashiko-outbox-167959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/2] net/mlx5: HWS, fix modify header pattern
 compare on big-endian
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012101937.1335231-2-acassen@corp.free.fr>
References: <20261012101937.1335231-1-acassen@corp.free.fr>
 <20261012101937.1335231-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 10:32:20 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5hws_pat_compare_pattern() casts each __be64 action to __be32 to
> compare only its control dword. On big-endian this keeps the data dword
> instead, which HWS clears from the pattern of set and add actions. Two
> such actions writing the same value into different fields then share a
> pattern and the second rule modifies the wrong field.
>=20
> Read the first dword of each action from memory instead. Little-endian
> behavior is unchanged.
>=20
> Discovered by an AI code review agent [1] and confirmed by code
> inspection. Not reproduced for lack of big-endian hardware running HWS.
>=20
> Fixes: aefc15a0fa1c ("net/mlx5: HWS, added modify header pattern and args=
 handling")
> Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261010120147.=
135825-1-acassen%40corp.free.fr [1]
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012101937.1335=
231-1-acassen@corp.free.fr?part=3D1

