Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67733D9DB3
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884732; cv=none; b=dnsf3m9QaPifdfBuHz9JJdO4LwmlQtuT3gAI1rmnssvKtSM/vjg7GPEgkBYB2ZQwvGvEZ3K2vXuJPImDrmM9lrN9wxrUf/etxmYkv5GkLfVdKtejUTiH7bSG2yU6CB7/iLT9MTzd9UlBSyf+BOKWpdJMc6G7xHO4Aa9XuUPheGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884732; c=relaxed/simple;
	bh=v3eeH7IYC6d3xwHCxWdv7MA9dbSQrTygLTerM5JWrWk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OVwNfxpT8yVNRxUaSCR3c+lD79efdCH1EQf4DF/dI3Wv1psHVnPcHl8LCP6ElmdwCyKFZzuwcu8xDSf94dnagnKW1i8INvdAvlF0GA3jQzh8vjg6EOpikXalkxCyuq623DTvcAeLUaiTdGc+quseZfDZ409U3DIxofHWw6naRiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrXgJMrU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrXgJMrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCAF1F00893;
	Sun, 20 Sep 2026 06:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884731;
	bh=DWzwKxCSglYKcfCyDq69kjP21d/FF4ATibfm+wDs5uQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XrXgJMrU2cAoCNmEePWkiK7oJ9gEr872LmTtdrb3LBFJ7/rFgvNo10DhGtj/ZjAC4
	 yFya4rlJPbA8ZZAdd0VoOwE7FjQVkaDxMWhIl2bqqvK9vx4ZVocwD7azzo0aGXBh0L
	 fD7jKwTwhSlVT4JSiSF77WI6dF6ahSrLsJ9knn4QmgS5j9JiQvHd18/kgiUKa/wyVA
	 K1/yZiKT28H357O2xxc3y2K9pVPXu3B3zrWUZ5jurtBCagzG7VhQ5qyNObhfp5qvrW
	 itzftkiGZWbFBDSB9ytKB7HZF9wxIDVv/JAXJh2/ttSS7OOT4VxYGrFmY2EPcK7JUT
	 cPJ2e8rSGi4rA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 12/12] net/rds: hold a connection reference
 from struct rds_incoming
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-13-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:11 +0000
Message-Id: <20260920061211.6CCAF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> struct rds_incoming->i_conn stores a pointer to the connection a message
> it belongs to, for both received messages and messages the socket sends.
> But without taking a reference, nothing keeps that connection alive.
> Embedded as the messages m_inc, an inc routinely outlives the connection
> it points at, by sitting in the socket's receive queue until the
> application reads it, while the connection is destroyed by device removal,
> netns teardown or module unload - and every dereference of i_conn after
> that point touches freed memory.
>=20
> Chengfeng Ye reported one way to reach it, where the socket info
> callbacks walk a receive queue after rmmod freed the connections:
>=20
>   BUG: KASAN: slab-use-after-free in rds6_inc_info_copy+0x459/0x530 [rds]
> [ ... ]
>  m_inc reference is dropped from a shared rds_message_free() helper
>  that both paths call; rds_recv_incoming() takes the new reference
>  before dropping the old; rewrite commit message]
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D12

