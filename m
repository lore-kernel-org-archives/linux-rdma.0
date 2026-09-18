Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0097125333F
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 14:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789740794; cv=none; b=GHUQ9k2eThEHjLtuYRFnadURlkuuUsFP46nRUNOWm9XS88y20EYi+9KutTSacl0ZDNsTp7PXuiNCRQVFStMFXryeK0DK2yAB+T06sDA7jxPyHLEHiJr1ry5OUXVJRBOJV+ziiDGx2H+RCFZDE3u4iPlP1Zdcva9J7BdLIgeJZos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789740794; c=relaxed/simple;
	bh=WstU0fCt5cQEY7wBpYw6DSj+2+6rMkfgYZJ4IqVjykY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X8hMGnRIdfdxahbRaY340PD1SEh8dAjIsnSAsOCC4DkQZLjuls+pWe72g+Jtj26GaEb5fYpU1vDmS0414jLMrPEqGgpcmOMG/WMctkTYTVIbFdjqrcvXsL3nuqeuDp8NIGeZDDi35L+gbxBXzEy1tifHkFSN7dCMmewya2jvVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRD0+mC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRD0+mC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609681F000FF;
	Fri, 18 Sep 2026 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789740792;
	bh=WstU0fCt5cQEY7wBpYw6DSj+2+6rMkfgYZJ4IqVjykY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PRD0+mC0hjkfX9lpClqo2EalqKbjD5DPyMxS5dt2FureAFzFEL1i8t7zoM8wh18ZJ
	 P6FY62xj+puDnv5sNahfdUGWsuJUdMAQJczTzJCrZtfkW3ah6MUlnkHghAq+CoJPqL
	 cKKDaszJQTbPyexk8LoBSf8DWkafOgI8utB5R5cLXNyA4kpAstnT+m9tmrTmAXjimi
	 4/8M2I6p0j3K/JtmxH+ffSJQTvzpiVoc8XNdC/MOoHGeCYwcwO0u3OAQVmiSUIkYcW
	 0+pBwJ0HGOWM2LseG9HFC8BBTkVrOnkzLvUQcbfDfJfr6Ar5CxirHD5kDaw450PN0C
	 6KrR5HXosXGjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 3/5] RDMA/mana_ib: Revise UD receive
 posting with GDMA_WR_IB_SGL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260918140407.2922819-4-kotaranov@linux.microsoft.com>
References: <20260918140407.2922819-1-kotaranov@linux.microsoft.com>
 <20260918140407.2922819-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 14:13:11 +0000
Message-Id: <20260918141312.609681F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Pass receive verbs SGEs directly to GDMA instead of copying them into
> a small stack array. Accept the receive SGE limit, supply a dummy SGE
> for zero-length requests, and ring once after each successful batch.
>=20
> Introduce GDMA_WR_IB_SGL, its request union, and the wrap-aware verbs
> SGE writer together with their first consumer. These shared GDMA pieces
> must precede the later extended-WQE patch so this receive path does not
> depend on definitions or encoding support introduced after it.
>=20
> Address verbs SGEs by ring offset so both scattered-page boundaries and
> ring wrap preserve the local kernel baseline's non-contiguous buffers.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918140407.2922=
819-1-kotaranov@linux.microsoft.com?part=3D3

