Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5542E738F
	for <linux-rdma@vger.kernel.org>; Sat, 10 Oct 2026 07:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791616121; cv=none; b=m0gfLesczUfFYv9LKgR9m66cdTfvQXdu2L7KgohIWR5gL5MInSNUGsISKNYsekcFxOvHf89KjjV3LwNEX6wpf2YhuFZ8rM1YYzcLIV1LzxlJKUvXpm9KWRkHP1AEUSR61zyE17LyC+QPdGSEZKiq7b8UziiTpLCG6AyF9pL2nO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791616121; c=relaxed/simple;
	bh=haC9B1PNZqohw82hvtgUtgge60IfLZvZyAQABqE7a40=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jwLasUECKp6gJZbAMaZqPd3kQ5iMnlzet6yMIZDQTl6FrjTKaObboLWp5HmJLghoHy+0Pcvy2oIzq75jU3ZLBxCBN+DN4pdyPGd5I4caLnl7pa4rCj2QNpxYOwF8arcYCqa9bd2c7glgBVqVkhJphRrwe7WDa7yygObCfSpAxGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUN5+WXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUN5+WXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A81F000FF;
	Sat, 10 Oct 2026 07:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791616119;
	bh=haC9B1PNZqohw82hvtgUtgge60IfLZvZyAQABqE7a40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cUN5+WXCrx2J1xMvWStb//ero9lbQq2Yv37uzV2nUPwtksGAr9oFw7Sx9qLtSg86d
	 ckaEC8W0jlAK77VuFJ26/0+Lk09e+iMfJqWHLXuBaZ80N4GnfKc6bAhESieJA/EuHZ
	 17UkoHCKJvYg5oqQagLjDR30e7Nf4G4JVS4hUO/UPyZFTi0hKZ7NWuSK+05fnmPQvx
	 Zb6VC6kQSz+dYmBWlCwfDsYJWBqG+t9INgrDNAEQ+zDTyaqcHAdjwCgJwFr+aXMUNH
	 SA1j2rjTRJaDBDAOuo5F+JEmcpJiXfbS8hWSDNFEBmBmWt7/hJm2lWjUoBRdhBjUiW
	 vQt+ojBjRATCQ==
Message-ID: <sashiko-outbox-166296@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 05/10] RDMA/mana_ib: Post receive WRs on
 kernel RC QPs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261010065443.3554193-6-kotaranov@linux.microsoft.com>
References: <20261010065443.3554193-1-kotaranov@linux.microsoft.com>
 <20261010065443.3554193-6-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 07:08:38 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement receive request posting for RC QPs. When posting a batch of
> WRs, ring the doorbell periodically to prevent the u8 counter from
> overflowing.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261010065443.3554=
193-1-kotaranov@linux.microsoft.com?part=3D5

